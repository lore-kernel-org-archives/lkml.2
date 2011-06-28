Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1F1OxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 10:53:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54033 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440Ab1F1OwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 10:52:04 -0400
Message-ID: <4E09EA90.8040801@gmail.com>
Date: Tue, 28 Jun 2011 08:52:00 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip 3/4] perf script: add the option to show the offset
 of symbols
References: <20110628074019.4269.32109.stgit@linux3> <20110628074044.4269.40422.stgit@linux3>
In-Reply-To: <20110628074044.4269.40422.stgit@linux3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2011 01:40 AM, Akihiro Nagai wrote:
> Add the option '--show-symbol-offset' to show the offset from
> the symbols in the output of perf-script. We can get the more
> detailed address information.

I like the offset option; added that locally last week as well. more below.

> 
> Output sample:
> # perf script -f ip,addr,sym --show-symbol-offset
> 301ec016b0 ffffffff81467612 irq_return+0x0
> 301ec016b0            _start+0x0 ffffffff81467612 irq_return+0x0
> 301ec04b70         _dl_start+0x0       301ec016b3 _start+0x3
> 301ec04b70         _dl_start+0x0 ffffffff81467612 irq_return+0x0
> 301ec04b96        _dl_start+0x26 ffffffff81467612 irq_return+0x0
> 301ec04b9d        _dl_start+0x2d ffffffff81467612 irq_return+0x0
> 301ec04c0d        _dl_start+0x9d       301ec04beb _dl_start+0x7b
> 301ec04bf0        _dl_start+0x80       301ec04c11 _dl_start+0xa1
> [snip]
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
>  tools/perf/Documentation/perf-script.txt |    3 +++
>  tools/perf/builtin-script.c              |   20 ++++++++++++++------
>  tools/perf/util/session.c                |   16 ++++++++++------
>  tools/perf/util/session.h                |    3 ++-
>  4 files changed, 29 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
> index c6068cb..39c4721 100644
> --- a/tools/perf/Documentation/perf-script.txt
> +++ b/tools/perf/Documentation/perf-script.txt
> @@ -182,6 +182,9 @@ OPTIONS
>  --hide-call-graph::
>          When printing symbols do not display call chain.
>  
> +--show-symbol-offset::
> +	Show the offset of the symbols.
> +
>  SEE ALSO
>  --------
>  linkperf:perf-record[1], linkperf:perf-script-perl[1],
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 2d68086..f9b7047 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -21,6 +21,7 @@ static u64			last_timestamp;
>  static u64			nr_unordered;
>  extern const struct option	record_options[];
>  static bool			no_callchain;
> +static bool			show_symbol_offset;
>  
>  enum perf_output_field {
>  	PERF_OUTPUT_COMM            = 1U << 0,
> @@ -324,6 +325,7 @@ static void print_sample_addr(union perf_event *event,
>  	struct addr_location al;
>  	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
>  	const char *symname, *dsoname;
> +	unsigned long offset;
>  
>  	printf("%16" PRIx64, sample->addr);
>  
> @@ -346,12 +348,15 @@ static void print_sample_addr(union perf_event *event,
>  		al.sym = map__find_symbol(al.map, al.addr, NULL);
>  
>  	if (PRINT_FIELD(SYM)) {
> -		if (al.sym && al.sym->name)
> +		printf(" ");
> +		if (al.sym && al.sym->name) {
>  			symname = al.sym->name;
> -		else
> -			symname = "";

dropping the else path will cause columns to misalign when ip's do not
resolve.

> -
> -		printf(" %16s", symname);
> +			offset = al.addr - al.sym->start;

move the offset calculation under the if (show_symbol_offset)

> +			if (show_symbol_offset)
> +				printf("%16s+0x%lx", symname, offset);
> +			else
> +				printf("%16s", symname);
> +		}
>  	}
>  
>  	if (PRINT_FIELD(DSO)) {
> @@ -390,7 +395,8 @@ static void process_event(union perf_event *event __unused,
>  		else
>  			printf("\n");
>  		perf_session__print_ip(event, sample, session,
> -					      PRINT_FIELD(SYM), PRINT_FIELD(DSO));
> +				       PRINT_FIELD(SYM), PRINT_FIELD(DSO),
> +				       show_symbol_offset);
>  	}
>  
>  	printf("\n");
> @@ -1084,6 +1090,8 @@ static const struct option options[] = {
>  	OPT_CALLBACK('f', "fields", NULL, "str",
>  		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
>  		     parse_output_fields),
> +	OPT_BOOLEAN('\0', "show-symbol-offset", &show_symbol_offset,
> +		    "Show the offset of the symbol."),
>  
>  	OPT_END()
>  };
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 632266f..bb522ed 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1205,10 +1205,11 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
>  void perf_session__print_ip(union perf_event *event,
>  			    struct perf_sample *sample,
>  			    struct perf_session *session,
> -			    int print_sym, int print_dso)
> +			    int print_sym, int print_dso, int print_offset)
>  {
>  	struct addr_location al;
>  	const char *symname, *dsoname;
> +	unsigned long offset;
>  	struct callchain_cursor *cursor = &session->callchain_cursor;
>  	struct callchain_cursor_node *node;
>  
> @@ -1259,12 +1260,15 @@ void perf_session__print_ip(union perf_event *event,
>  	} else {
>  		printf("%16" PRIx64, sample->ip);
>  		if (print_sym) {
> -			if (al.sym && al.sym->name)
> +			printf(" ");
> +			if (al.sym && al.sym->name) {
>  				symname = al.sym->name;
> -			else
> -				symname = "";
> -
> -			printf(" %s", symname);
> +				offset = al.addr - al.sym->start;
> +				if (print_offset)
> +					printf("%s+0x%lx", symname, offset);

same comments for this code path.

David


> +				else
> +					printf("%s", symname);
> +			}
>  		}
>  
>  		if (print_dso) {
> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
> index de4178d..8187e68 100644
> --- a/tools/perf/util/session.h
> +++ b/tools/perf/util/session.h
> @@ -170,6 +170,7 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
>  void perf_session__print_ip(union perf_event *event,
>  				 struct perf_sample *sample,
>  				 struct perf_session *session,
> -				 int print_sym, int print_dso);
> +				 int print_sym, int print_dso,
> +				 int print_offset);
>  
>  #endif /* __PERF_SESSION_H */
> 
