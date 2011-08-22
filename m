Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1HVNCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:02:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62499 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab1HVNCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:02:41 -0400
Message-ID: <4E52536F.40609@gmail.com>
Date: Mon, 22 Aug 2011 07:02:39 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v3 4/5] perf script: add the offset field specifier
References: <20110811120555.5900.23642.stgit@linux3> <20110811120632.5900.16933.stgit@linux3>
In-Reply-To: <20110811120632.5900.16933.stgit@linux3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2011 06:06 AM, Akihiro Nagai wrote:
> Add the offset field specifier 'offs' to show the offset from
> the symbols in the output of perf-script. We can get the more
> detailed address information.
> 
> Output sample:
> # perf script -f ip,addr,sym,offs
> 301ec016b0            _start+0x0 ffffffff81467612 irq_return+0x0
> 301ec016b0            _start+0x0 ffffffff81467612 irq_return+0x0
> 301ec04b70         _dl_start+0x0       301ec016b3 _start+0x3
> 301ec04b70         _dl_start+0x0 ffffffff81467612 irq_return+0x0
> 301ec04b96        _dl_start+0x26 ffffffff81467612 irq_return+0x0
> 301ec04b9d        _dl_start+0x2d ffffffff81467612 irq_return+0x0
> 301ec04c0d        _dl_start+0x9d       301ec04beb _dl_start+0x7b
> 301ec04bf0        _dl_start+0x80       301ec04c11 _dl_start+0xa1
> [snip]
> 
> Changes in v2:
>  - change the way to output offset from '--show-symbol-offset' to
>    'offs' field.
>  - clean up codes.
> 
> Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
> 
>  tools/perf/Documentation/perf-script.txt |    2 +-
>  tools/perf/builtin-script.c              |   20 +++++++++++++++++---
>  tools/perf/util/session.c                |    7 +++++--
>  tools/perf/util/session.h                |    3 ++-
>  tools/perf/util/symbol.c                 |   22 +++++++++++++++-------
>  tools/perf/util/symbol.h                 |    2 ++
>  6 files changed, 42 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
> index db01786..ee4d477 100644
> --- a/tools/perf/Documentation/perf-script.txt
> +++ b/tools/perf/Documentation/perf-script.txt
> @@ -115,7 +115,7 @@ OPTIONS
>  -f::
>  --fields::
>          Comma separated list of fields to print. Options are:
> -        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr.
> +        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, offs.
>          Field list can be prepended with the type, trace, sw or hw,
>          to indicate to which event type the field list applies.
>          e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index aeec5bc..78797b3 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -37,6 +37,7 @@ enum perf_output_field {
>  	PERF_OUTPUT_SYM             = 1U << 8,
>  	PERF_OUTPUT_DSO             = 1U << 9,
>  	PERF_OUTPUT_ADDR            = 1U << 10,
> +	PERF_OUTPUT_OFFSET          = 1U << 11,
>  };
>  
>  struct output_option {
> @@ -54,6 +55,7 @@ struct output_option {
>  	{.str = "sym",   .field = PERF_OUTPUT_SYM},
>  	{.str = "dso",   .field = PERF_OUTPUT_DSO},
>  	{.str = "addr",  .field = PERF_OUTPUT_ADDR},
> +	{.str = "offs",  .field = PERF_OUTPUT_OFFSET},
>  };
>  
>  /* default set to maintain compatibility with current format */
> @@ -190,6 +192,11 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
>  		       "to symbols.\n");
>  		return -EINVAL;
>  	}
> +	if (PRINT_FIELD(OFFSET) && !PRINT_FIELD(SYM)) {
> +		pr_err("Display of offsets requested but symbol is not"
> +		       "selected.\n");
> +		return -EINVAL;
> +	}
>  	if (PRINT_FIELD(DSO) && !PRINT_FIELD(IP) && !PRINT_FIELD(ADDR)) {
>  		pr_err("Display of DSO requested but neither sample IP nor "
>  			   "sample address\nis selected. Hence, no addresses to convert "
> @@ -346,7 +353,10 @@ static void print_sample_addr(union perf_event *event,
>  
>  	if (PRINT_FIELD(SYM)) {
>  		printf(" ");
> -		symbol__print_symname(al.sym);
> +		if (PRINT_FIELD(OFFSET))
> +			symbol__print_symname_offs(al.sym, &al);
> +		else
> +			symbol__print_symname(al.sym);
>  	}
>  
>  	if (PRINT_FIELD(DSO)) {
> @@ -382,7 +392,8 @@ static void process_event(union perf_event *event __unused,
>  		else
>  			printf("\n");
>  		perf_session__print_ip(event, sample, session,
> -					      PRINT_FIELD(SYM), PRINT_FIELD(DSO));
> +				       PRINT_FIELD(SYM), PRINT_FIELD(DSO),
> +				       PRINT_FIELD(OFFSET));
>  	}
>  
>  	printf("\n");
> @@ -1078,7 +1089,10 @@ static const struct option options[] = {
>  	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
>  		    "Look for files with symbols relative to this directory"),
>  	OPT_CALLBACK('f', "fields", NULL, "str",
> -		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
> +		     "comma separated output fields prepend with 'type:'. "
> +		     "Valid types: hw,sw,trace,raw. "
> +		     "Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,"
> +		     "addr,offs",
>  		     parse_output_fields),
>  	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
>  
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 730fcd2..51d0a28 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1217,7 +1217,7 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
>  void perf_session__print_ip(union perf_event *event,
>  			    struct perf_sample *sample,
>  			    struct perf_session *session,
> -			    int print_sym, int print_dso)
> +			    int print_sym, int print_dso, int print_offset)
>  {
>  	struct addr_location al;
>  	struct callchain_cursor *cursor = &session->callchain_cursor;
> @@ -1264,7 +1264,10 @@ void perf_session__print_ip(union perf_event *event,
>  		printf("%16" PRIx64, sample->ip);
>  		if (print_sym) {
>  			printf(" ");
> -			symbol__print_symname(al.sym);
> +			if (print_offset)
> +				symbol__print_symname_offs(al.sym, &al);
> +			else
> +				symbol__print_symname(al.sym);
>  		}
>  
>  		if (print_dso) {
> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
> index 170601e..2689017 100644
> --- a/tools/perf/util/session.h
> +++ b/tools/perf/util/session.h
> @@ -171,7 +171,8 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
>  void perf_session__print_ip(union perf_event *event,
>  				 struct perf_sample *sample,
>  				 struct perf_session *session,
> -				 int print_sym, int print_dso);
> +				 int print_sym, int print_dso,
> +				 int print_offset);
>  
>  int perf_session__cpu_bitmap(struct perf_session *session,
>  			     const char *cpu_list, unsigned long *cpu_bitmap);
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index aa37485..28e14be 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -175,16 +175,24 @@ static size_t symbol__fprintf(struct symbol *sym, FILE *fp)
>  		       sym->name);
>  }
>  
> -void symbol__print_symname(const struct symbol *sym)
> +void symbol__print_symname_offs(const struct symbol *sym,
> +				const struct addr_location *al)
>  {
> -	const char *symname;
> +	unsigned long offset;
>  
> -	if (sym && sym->name)
> -		symname = sym->name;
> -	else
> -		symname = "[unknown]";
> +	if (sym && sym->name) {
> +		printf("%s", sym->name);
> +		if (al) {
> +			offset = al->addr - sym->start;
> +			printf("+0x%lx", offset);
> +		}
> +	} else
> +		printf("[unknown]");
> +}
>  
> -	printf("%s", symname);
> +void symbol__print_symname(const struct symbol *sym)
> +{
> +	symbol__print_symname_offs(sym, NULL);
>  }
>  
>  void dso__set_long_name(struct dso *dso, char *name)
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 1ec17b4..554b2fe 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -238,6 +238,8 @@ void machines__destroy_guest_kernel_maps(struct rb_root *machines);
>  
>  int symbol__init(void);
>  void symbol__exit(void);
> +void symbol__print_symname_offs(const struct symbol *sym,
> +				const struct addr_location *al);
>  void symbol__print_symname(const struct symbol *sym);
>  bool symbol_type__is_a(char symbol_type, enum map_type map_type);
>  
> 

Acked-By: David Ahern <dsahern@gmail.com>
