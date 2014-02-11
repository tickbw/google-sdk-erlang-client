PROJECT = google-sdk-erlang-client
DIALYZER = dialyzer
REBAR = ./rebar

all: app

deps:
	@$(REBAR) get-deps

app: deps
	@$(REBAR) compile

clean: clean-logs
	@$(REBAR) clean
	rm -f erl_crash.dump

clean-logs:
	rm -rf log 

tests: app eunit

eunit:
	@$(REBAR) eunit skip_deps=true

build-plt:
	@$(DIALYZER) --build_plt --output_plt .$(PROJECT).plt \
		--apps erts kernel stdlib sasl tools inets crypto public_key ssl eunit

dialyze: app
	@$(DIALYZER) ebin/googlesdk*.beam --plt .$(PROJECT).plt \
	-Werror_handling  #-Wunmatched_returns -Wrace_conditions -Wunderspecs

shell: 
	erl -config priv/app.config -args_file priv/vm.args 


build_tests:
	erlc -pa ebin -pa deps/lager/ebin -o ebin -I include \
	+export_all +debug_info test/*.erl


