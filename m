Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab1BASxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:53:05 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53243 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab1BASxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:53:03 -0500
Message-ID: <4D48562B.20006@kernel.org>
Date: Tue, 01 Feb 2011 10:51:23 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf top: Introduce slang based TUI
References: <new-submission> <tip-c0443df1b69b59675fc6790e0ddce87c8ca00abf@git.kernel.org>
In-Reply-To: <tip-c0443df1b69b59675fc6790e0ddce87c8ca00abf@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 01:20 AM, tip-bot for Arnaldo Carvalho de Melo wrote:
> Commit-ID:  c0443df1b69b59675fc6790e0ddce87c8ca00abf
> Gitweb:     http://git.kernel.org/tip/c0443df1b69b59675fc6790e0ddce87c8ca00abf
> Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> AuthorDate: Mon, 31 Jan 2011 18:19:33 -0200
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Mon, 31 Jan 2011 18:19:33 -0200
> 
> perf top: Introduce slang based TUI
> 
> Disabled by default as there are features found in the stdio based one
> that aren't implemented, like live annotation, filtering knobs data
> entry.
> 
> Annotation hopefully will get somehow merged with the 'perf annotate'
> code.
> 
> To use it:
> 
> perf top --tui
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/Makefile               |    4 +
>  tools/perf/builtin-top.c          |   35 ++++++++--
>  tools/perf/util/top.c             |    7 ++-
>  tools/perf/util/top.h             |   15 ++++-
>  tools/perf/util/ui/browsers/top.c |  136 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 189 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index edc660e..67a9f4d 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -621,6 +621,7 @@ else
>  		LIB_OBJS += $(OUTPUT)util/ui/browsers/annotate.o
>  		LIB_OBJS += $(OUTPUT)util/ui/browsers/hists.o
>  		LIB_OBJS += $(OUTPUT)util/ui/browsers/map.o
> +		LIB_OBJS += $(OUTPUT)util/ui/browsers/top.o
>  		LIB_OBJS += $(OUTPUT)util/ui/helpline.o
>  		LIB_OBJS += $(OUTPUT)util/ui/progress.o
>  		LIB_OBJS += $(OUTPUT)util/ui/util.o
> @@ -1050,6 +1051,9 @@ $(OUTPUT)util/ui/browser.o: util/ui/browser.c $(OUTPUT)PERF-CFLAGS
>  $(OUTPUT)util/ui/browsers/annotate.o: util/ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
>  
> +$(OUTPUT)util/ui/browsers/top.o: util/ui/browsers/top.c $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
> +
>  $(OUTPUT)util/ui/browsers/hists.o: util/ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
>  
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 3c9ba94..104de9a 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -20,6 +20,7 @@
>  
>  #include "perf.h"
>  
> +#include "util/cache.h"
>  #include "util/color.h"
>  #include "util/evlist.h"
>  #include "util/evsel.h"
> @@ -75,6 +76,8 @@ static struct perf_top top = {
>  
>  static bool			system_wide			=  false;
>  
> +static bool			use_tui, use_stdio;
> +
>  static int			default_interval		=      0;
>  
>  static bool			inherit				=  false;
> @@ -96,11 +99,6 @@ static int			sym_pcnt_filter			=      5;
>   * Source functions
>   */
>  
> -static inline struct symbol *sym_entry__symbol(struct sym_entry *self)
> -{
> -       return ((void *)self) + symbol_conf.priv_size;
> -}
> -
>  void get_term_dimensions(struct winsize *ws)
>  {
>  	char *s = getenv("LINES");
> @@ -695,6 +693,14 @@ static void handle_keypress(struct perf_session *session, int c)
>  	}
>  }
>  
> +static void *display_thread_tui(void *arg __used)
> +{
> +	perf_top__tui_browser(&top);
> +	exit_browser(0);
> +	exit(0);
> +	return NULL;
> +}
> +
>  static void *display_thread(void *arg __used)
>  {
>  	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
> @@ -1005,7 +1011,8 @@ static int __cmd_top(void)
>  
>  	perf_session__mmap_read(session);
>  
> -	if (pthread_create(&thread, NULL, display_thread, session)) {
> +	if (pthread_create(&thread, NULL, (use_browser > 0 ? display_thread_tui :
> +							     display_thread), session)) {
>  		printf("Could not create display thread.\n");
>  		exit(-1);
>  	}
> @@ -1078,6 +1085,8 @@ static const struct option options[] = {
>  		    "display this many functions"),
>  	OPT_BOOLEAN('U', "hide_user_symbols", &top.hide_user_symbols,
>  		    "hide user symbols"),
> +	OPT_BOOLEAN(0, "tui", &use_tui, "Use the TUI interface"),
> +	OPT_BOOLEAN(0, "stdio", &use_stdio, "Use the stdio interface"),
>  	OPT_INCR('v', "verbose", &verbose,
>  		    "be more verbose (show counter open errors, etc)"),
>  	OPT_END()
> @@ -1098,6 +1107,20 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
>  	if (argc)
>  		usage_with_options(top_usage, options);
>  
> +	/*
> + 	 * XXX For now start disabled, only using TUI if explicitely asked for.
> + 	 * Change that when handle_keys equivalent gets written, live annotation
> + 	 * done, etc.
> + 	 */
> +	use_browser = 0;
> +
> +	if (use_stdio)
> +		use_browser = 0;
> +	else if (use_tui)
> +		use_browser = 1;
> +
> +	setup_browser(false);
> +
>  	/* CPU and PID are mutually exclusive */
>  	if (top.target_tid > 0 && top.cpu_list) {
>  		printf("WARNING: PID switch overriding CPU\n");
> diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
> index c06cc53..1d2e265 100644
> --- a/tools/perf/util/top.c
> +++ b/tools/perf/util/top.c
> @@ -158,6 +158,7 @@ float perf_top__decay_samples(struct perf_top *top, struct rb_root *root)
>  	syme = list_entry(top->active_symbols.next, struct sym_entry, node);
>  	pthread_mutex_unlock(&top->active_symbols_lock);
>  
> +	top->rb_entries = 0;
>  	list_for_each_entry_safe_from(syme, n, &top->active_symbols, node) {
>  		syme->snap_count = syme->count[snap];
>  		if (syme->snap_count != 0) {
> @@ -170,7 +171,11 @@ float perf_top__decay_samples(struct perf_top *top, struct rb_root *root)
>  				continue;
>  			}
>  			syme->weight = sym_weight(syme, top);
> -			rb_insert_active_sym(root, syme);
> +
> +			if ((int)syme->snap_count >= top->count_filter) {
> +				rb_insert_active_sym(root, syme);
> +				++top->rb_entries;
> +			}
>  			sum_ksamples += syme->snap_count;
>  
>  			for (j = 0; j < top->evlist->nr_entries; j++)
> diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
> index 0467b26..611370f 100644
> --- a/tools/perf/util/top.h
> +++ b/tools/perf/util/top.h
> @@ -38,6 +38,11 @@ struct sym_entry {
>  	unsigned long		count[0];
>  };
>  
> +static inline struct symbol *sym_entry__symbol(struct sym_entry *self)
> +{
> +       return ((void *)self) + symbol_conf.priv_size;
> +}
> +
>  struct perf_top {
>  	struct perf_evlist *evlist;
>  	/*
> @@ -51,7 +56,7 @@ struct perf_top {
>  	u64		   exact_samples;
>  	u64		   guest_us_samples, guest_kernel_samples;
>  	int		   print_entries, count_filter, delay_secs;
> -	int		   display_weighted, freq;
> +	int		   display_weighted, freq, rb_entries;
>  	int		   sym_counter, target_pid, target_tid;
>  	bool		   hide_kernel_symbols, hide_user_symbols, zero;
>  	const char	   *cpu_list;
> @@ -64,4 +69,12 @@ float perf_top__decay_samples(struct perf_top *top, struct rb_root *root);
>  void perf_top__find_widths(struct perf_top *top, struct rb_root *root,
>  			   int *dso_width, int *dso_short_width, int *sym_width);
>  
> +#ifdef NO_NEWT_SUPPORT
> +static inline int perf_top__tui_browser(struct perf_top *top __used)
> +{
> +	return 0;
> +}
> +#else
> +int perf_top__tui_browser(struct perf_top *top);
> +#endif
>  #endif /* __PERF_TOP_H */
> diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
> new file mode 100644
> index 0000000..ca60624
> --- /dev/null
> +++ b/tools/perf/util/ui/browsers/top.c
> @@ -0,0 +1,136 @@
> +/*
> + * Copyright (C) 2011, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
> + *
> + * Parts came from builtin-{top,stat,record}.c, see those files for further
> + * copyright notes.
> + *
> + * Released under the GPL v2. (and only v2, not any later version)
> + */
> +#include "../browser.h"
> +#include "../helpline.h"
> +#include "../libslang.h"
> +#include "../../evlist.h"
> +#include "../../hist.h"
> +#include "../../sort.h"
> +#include "../../symbol.h"
> +#include "../../top.h"
> +
> +struct perf_top_browser {
> +	struct ui_browser b;
> +	struct rb_root	  root;
> +	float		  sum_ksamples;
> +	int		  dso_width;
> +	int		  dso_short_width;
> +	int		  sym_width;
> +};
> +
> +static void perf_top_browser__write(struct ui_browser *browser, void *entry, int row)
> +{
> +	struct perf_top_browser *top_browser = container_of(browser, struct perf_top_browser, b);
> +	struct sym_entry *syme = rb_entry(entry, struct sym_entry, rb_node);
> +	bool current_entry = ui_browser__is_current_entry(browser, row);
> +	struct symbol *symbol = sym_entry__symbol(syme);
> +	struct perf_top *top = browser->priv;
> +	int width = browser->width;
> +	double pcnt;
> +
> +	pcnt = 100.0 - (100.0 * ((top_browser->sum_ksamples - syme->snap_count) /
> +				 top_browser->sum_ksamples));
> +	ui_browser__set_percent_color(browser, pcnt, current_entry);
> +
> +	if (top->evlist->nr_entries == 1 || !top->display_weighted) {
> +		slsmg_printf("%20.2f ", syme->weight);
> +		width -= 24;
> +	} else {
> +		slsmg_printf("%9.1f %10ld ", syme->weight, syme->snap_count);
> +		width -= 23;
> +	}
> +
> +	slsmg_printf("%4.1f%%", pcnt);
> +	width -= 7;
> +
> +	if (verbose) {
> +		slsmg_printf(" %016" PRIx64, symbol->start);
> +		width -= 17;
> +	}
> +
> +	slsmg_printf(" %-*.*s ", top_browser->sym_width, top_browser->sym_width,
> +		     symbol->name);
> +	width -= top_browser->sym_width;
> +	slsmg_write_nstring(width >= syme->map->dso->long_name_len ?
> +				syme->map->dso->long_name :
> +				syme->map->dso->short_name, width);


need update macro for that calling

[PATCH] perf: fix compiling for perf top tui

util/ui/browsers/top.c: In function ‘perf_top_browser__write’:
util/ui/browsers/top.c:60:2: error: cast to pointer from integer of different size
util/ui/browsers/top.c:60:2: error: comparison between pointer and integer
util/ui/browsers/top.c:60:2: error: passing argument 1 of ‘SLsmg_write_nstring’ discards qualifiers from pointer target type
/usr/include/slang.h:1728:16: note: expected ‘char *’ but argument is of type ‘const char *’
make: *** [util/ui/browsers/top.o] Error 1

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 tools/perf/util/ui/libslang.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/tools/perf/util/ui/libslang.h
===================================================================
--- linux-2.6.orig/tools/perf/util/ui/libslang.h
+++ linux-2.6/tools/perf/util/ui/libslang.h
@@ -13,11 +13,11 @@
 
 #if SLANG_VERSION < 20104
 #define slsmg_printf(msg, args...) \
-	SLsmg_printf((char *)msg, ##args)
+	SLsmg_printf((char *)(msg), ##args)
 #define slsmg_write_nstring(msg, len) \
-	SLsmg_write_nstring((char *)msg, len)
+	SLsmg_write_nstring((char *)(msg), len)
 #define sltt_set_color(obj, name, fg, bg) \
-	SLtt_set_color(obj,(char *)name, (char *)fg, (char *)bg)
+	SLtt_set_color(obj,(char *)(name), (char *)(fg), (char *)(bg))
 #else
 #define slsmg_printf SLsmg_printf
 #define slsmg_write_nstring SLsmg_write_nstring
