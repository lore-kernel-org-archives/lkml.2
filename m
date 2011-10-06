Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197Ab1JFR0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:26:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:44290 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765Ab1JFRWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/15] perf top: Reuse the 'report' hist_entry/hists classes
Date: Thu,  6 Oct 2011 14:22:29 -0300
Message-Id: <1317921758-4154-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This actually fixes several problems we had in the old 'perf top':

1. Unresolved symbols not show, limitation that came from the old
   "KernelTop" codebase, to solve it we would need to do changes
   that would make sym_entry have most of the hist_entry fields.
2. It was using the number of samples, not the sum of sample->period.

And brings the --sort code that allows us to have all the views in
'perf report', for instance:

[root@emilia ~]# perf top --sort dso
PerfTop: 5903 irqs/sec kernel:77.5% exact: 0.0% [1000Hz cycles], (all, 8 CPUs)
------------------------------------------------------------------------------

    31.59%  libcrypto.so.1.0.0
    21.55%  [kernel]
    18.57%  libpython2.6.so.1.0
     7.04%  libc-2.12.so
     6.99%  _backend_agg.so
     4.72%  sshd
     1.48%  multiarray.so
     1.39%  libfreetype.so.6.3.22
     1.37%  perf
     0.71%  libgobject-2.0.so.0.2200.5
     0.53%  [tg3]
     0.48%  libglib-2.0.so.0.2200.5
     0.44%  libstdc++.so.6.0.13
     0.40%  libcairo.so.2.10800.8
     0.38%  libm-2.12.so
     0.34%  umath.so
     0.30%  libgdk-x11-2.0.so.0.1800.9
     0.22%  libpthread-2.12.so
     0.20%  libgtk-x11-2.0.so.0.1800.9
     0.20%  librt-2.12.so
     0.15%  _path.so
     0.13%  libpango-1.0.so.0.2800.1
     0.11%  libatlas.so.3.0
     0.09%  ft2font.so
     0.09%  libpangoft2-1.0.so.0.2800.1
     0.08%  libX11.so.6.3.0
     0.07%  [vdso]
     0.06%  cyclictest
^C

All the filter lists can be used as well: --dsos, --comms, --symbols,
etc.

The 'perf report' TUI is also reused, being possible to apply all the
zoom operations, do annotation, etc.

This change will allow multiple simplifications in the symbol system as
well, that will be detailed in upcoming changesets.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-xzaaldxq7zhqrrxdxjifk1mh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-top.txt |   23 +++-
 tools/perf/Makefile                   |    4 -
 tools/perf/builtin-top.c              |  281 ++++++++++++++-------------------
 tools/perf/util/hist.c                |   48 ++++++
 tools/perf/util/hist.h                |    3 +
 tools/perf/util/top.c                 |  141 +----------------
 tools/perf/util/top.h                 |   36 +----
 tools/perf/util/ui/browsers/top.c     |  236 ---------------------------
 8 files changed, 194 insertions(+), 578 deletions(-)
 delete mode 100644 tools/perf/util/ui/browsers/top.c

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index f6eb1cd..d146ba3 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -106,6 +106,26 @@ Default is to monitor all CPUS.
 --zero::
 	Zero history across display updates.
 
+-s::
+--sort::
+	Sort by key(s): pid, comm, dso, symbol, parent
+
+-n::
+--show-nr-samples::
+	Show a column with the number of samples.
+
+--show-total-period::
+	Show a column with the sum of periods.
+
+--dsos::
+	Only consider symbols in these dsos.
+
+--comms::
+	Only consider symbols in these comms.
+
+--symbols::
+	Only consider these symbols.
+
 INTERACTIVE PROMPTING KEYS
 --------------------------
 
@@ -130,9 +150,6 @@ INTERACTIVE PROMPTING KEYS
 [S]::
 	Stop annotation, return to full profile display.
 
-[w]::
-	Toggle between weighted sum and individual count[E]r profile.
-
 [z]::
 	Toggle event count zeroing across display updates.
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3b8f7b8..729ecda 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -459,7 +459,6 @@ else
 		LIB_OBJS += $(OUTPUT)util/ui/browsers/annotate.o
 		LIB_OBJS += $(OUTPUT)util/ui/browsers/hists.o
 		LIB_OBJS += $(OUTPUT)util/ui/browsers/map.o
-		LIB_OBJS += $(OUTPUT)util/ui/browsers/top.o
 		LIB_OBJS += $(OUTPUT)util/ui/helpline.o
 		LIB_OBJS += $(OUTPUT)util/ui/progress.o
 		LIB_OBJS += $(OUTPUT)util/ui/util.o
@@ -722,9 +721,6 @@ $(OUTPUT)util/ui/browser.o: util/ui/browser.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/ui/browsers/annotate.o: util/ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
-$(OUTPUT)util/ui/browsers/top.o: util/ui/browsers/top.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
 $(OUTPUT)util/ui/browsers/hists.o: util/ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 23c4f71..2cf5e50 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -5,6 +5,7 @@
  * any workload, CPU or specific PID.
  *
  * Copyright (C) 2008, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
+ *		 2011, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
  *
  * Improvements and fixes by:
  *
@@ -36,6 +37,7 @@
 #include "util/parse-events.h"
 #include "util/cpumap.h"
 #include "util/xyarray.h"
+#include "util/sort.h"
 
 #include "util/debug.h"
 
@@ -65,12 +67,8 @@
 static struct perf_top top = {
 	.count_filter		= 5,
 	.delay_secs		= 2,
-	.display_weighted	= -1,
 	.target_pid		= -1,
 	.target_tid		= -1,
-	.active_symbols		= LIST_HEAD_INIT(top.active_symbols),
-	.active_symbols_lock	= PTHREAD_MUTEX_INITIALIZER,
-	.active_symbols_cond	= PTHREAD_COND_INITIALIZER,
 	.freq			= 1000, /* 1 KHz */
 };
 
@@ -85,7 +83,6 @@ static bool			vmlinux_warned;
 static bool			inherit				=  false;
 static int			realtime_prio			=      0;
 static bool			group				=  false;
-static unsigned int		page_size;
 static unsigned int		mmap_pages			=    128;
 
 static bool			dump_symtab                     =  false;
@@ -93,7 +90,6 @@ static bool			dump_symtab                     =  false;
 static struct winsize		winsize;
 
 static const char		*sym_filter			=   NULL;
-struct sym_entry		*sym_filter_entry_sched		=   NULL;
 static int			sym_pcnt_filter			=      5;
 
 /*
@@ -136,18 +132,18 @@ static void sig_winch_handler(int sig __used)
 	update_print_entries(&winsize);
 }
 
-static int parse_source(struct sym_entry *syme)
+static int parse_source(struct hist_entry *he)
 {
 	struct symbol *sym;
 	struct annotation *notes;
 	struct map *map;
 	int err = -1;
 
-	if (!syme)
+	if (!he || !he->ms.sym)
 		return -1;
 
-	sym = sym_entry__symbol(syme);
-	map = syme->map;
+	sym = he->ms.sym;
+	map = he->ms.map;
 
 	/*
 	 * We can't annotate with just /proc/kallsyms
@@ -175,52 +171,62 @@ static int parse_source(struct sym_entry *syme)
 		return err;
 	}
 
-	err = symbol__annotate(sym, syme->map, 0);
+	err = symbol__annotate(sym, map, 0);
 	if (err == 0) {
 out_assign:
-		top.sym_filter_entry = syme;
+		top.sym_filter_entry = he;
 	}
 
 	pthread_mutex_unlock(&notes->lock);
 	return err;
 }
 
-static void __zero_source_counters(struct sym_entry *syme)
+static void __zero_source_counters(struct hist_entry *he)
 {
-	struct symbol *sym = sym_entry__symbol(syme);
+	struct symbol *sym = he->ms.sym;
 	symbol__annotate_zero_histograms(sym);
 }
 
-static void record_precise_ip(struct sym_entry *syme, int counter, u64 ip)
+static void record_precise_ip(struct hist_entry *he, int counter, u64 ip)
 {
 	struct annotation *notes;
 	struct symbol *sym;
 
-	if (syme != top.sym_filter_entry)
+	if (he == NULL || he->ms.sym == NULL ||
+	    (he != top.sym_filter_entry && use_browser != 1))
 		return;
 
-	sym = sym_entry__symbol(syme);
+	sym = he->ms.sym;
 	notes = symbol__annotation(sym);
 
 	if (pthread_mutex_trylock(&notes->lock))
 		return;
 
-	ip = syme->map->map_ip(syme->map, ip);
-	symbol__inc_addr_samples(sym, syme->map, counter, ip);
+	if (notes->src == NULL &&
+	    symbol__alloc_hist(sym, top.evlist->nr_entries) < 0) {
+		pthread_mutex_unlock(&notes->lock);
+		pr_err("Not enough memory for annotating '%s' symbol!\n",
+		       sym->name);
+		sleep(1);
+		return;
+	}
+
+	ip = he->ms.map->map_ip(he->ms.map, ip);
+	symbol__inc_addr_samples(sym, he->ms.map, counter, ip);
 
 	pthread_mutex_unlock(&notes->lock);
 }
 
-static void show_details(struct sym_entry *syme)
+static void show_details(struct hist_entry *he)
 {
 	struct annotation *notes;
 	struct symbol *symbol;
 	int more;
 
-	if (!syme)
+	if (!he)
 		return;
 
-	symbol = sym_entry__symbol(syme);
+	symbol = he->ms.sym;
 	notes = symbol__annotation(symbol);
 
 	pthread_mutex_lock(&notes->lock);
@@ -231,7 +237,7 @@ static void show_details(struct sym_entry *syme)
 	printf("Showing %s for %s\n", event_name(top.sym_evsel), symbol->name);
 	printf("  Events  Pcnt (>=%d%%)\n", sym_pcnt_filter);
 
-	more = symbol__annotate_printf(symbol, syme->map, top.sym_evsel->idx,
+	more = symbol__annotate_printf(symbol, he->ms.map, top.sym_evsel->idx,
 				       0, sym_pcnt_filter, top.print_entries, 4);
 	if (top.zero)
 		symbol__annotate_zero_histogram(symbol, top.sym_evsel->idx);
@@ -245,21 +251,28 @@ out_unlock:
 
 static const char		CONSOLE_CLEAR[] = "[H[2J";
 
-static void __list_insert_active_sym(struct sym_entry *syme)
+static struct hist_entry *
+	perf_session__add_hist_entry(struct perf_session *session,
+				     struct addr_location *al,
+				     struct perf_sample *sample,
+				     struct perf_evsel *evsel)
 {
-	list_add(&syme->node, &top.active_symbols);
+	struct hist_entry *he;
+
+	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period);
+	if (he == NULL)
+		return NULL;
+
+	session->hists.stats.total_period += sample->period;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	return he;
 }
 
 static void print_sym_table(void)
 {
 	char bf[160];
 	int printed = 0;
-	struct rb_node *nd;
-	struct sym_entry *syme;
-	struct rb_root tmp = RB_ROOT;
 	const int win_width = winsize.ws_col - 1;
-	int sym_width, dso_width, dso_short_width;
-	float sum_ksamples = perf_top__decay_samples(&top, &tmp);
 
 	puts(CONSOLE_CLEAR);
 
@@ -275,6 +288,7 @@ static void print_sym_table(void)
 		color_fprintf(stdout, PERF_COLOR_RED, "WARNING:");
 		printf(" LOST %" PRIu64 " events, Check IO/CPU overload\n",
 		       top.total_lost_warned);
+		++printed;
 	}
 
 	if (top.sym_filter_entry) {
@@ -282,58 +296,13 @@ static void print_sym_table(void)
 		return;
 	}
 
-	perf_top__find_widths(&top, &tmp, &dso_width, &dso_short_width,
-			      &sym_width);
-
-	if (sym_width + dso_width > winsize.ws_col - 29) {
-		dso_width = dso_short_width;
-		if (sym_width + dso_width > winsize.ws_col - 29)
-			sym_width = winsize.ws_col - dso_width - 29;
-	}
+	hists__collapse_resort_threaded(&top.sym_evsel->hists);
+	hists__output_resort_threaded(&top.sym_evsel->hists);
+	hists__decay_entries(&top.sym_evsel->hists);
+	hists__output_recalc_col_len(&top.sym_evsel->hists, winsize.ws_row - 3);
 	putchar('\n');
-	if (top.evlist->nr_entries == 1)
-		printf("             samples  pcnt");
-	else
-		printf("   weight    samples  pcnt");
-
-	if (verbose)
-		printf("         RIP       ");
-	printf(" %-*.*s DSO\n", sym_width, sym_width, "function");
-	printf("   %s    _______ _____",
-	       top.evlist->nr_entries == 1 ? "      " : "______");
-	if (verbose)
-		printf(" ________________");
-	printf(" %-*.*s", sym_width, sym_width, graph_line);
-	printf(" %-*.*s", dso_width, dso_width, graph_line);
-	puts("\n");
-
-	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
-		struct symbol *sym;
-		double pcnt;
-
-		syme = rb_entry(nd, struct sym_entry, rb_node);
-		sym = sym_entry__symbol(syme);
-		if (++printed > top.print_entries ||
-		    (int)syme->snap_count < top.count_filter)
-			continue;
-
-		pcnt = 100.0 - (100.0 * ((sum_ksamples - syme->snap_count) /
-					 sum_ksamples));
-
-		if (top.evlist->nr_entries == 1 || !top.display_weighted)
-			printf("%20.2f ", syme->weight);
-		else
-			printf("%9.1f %10ld ", syme->weight, syme->snap_count);
-
-		percent_color_fprintf(stdout, "%4.1f%%", pcnt);
-		if (verbose)
-			printf(" %016" PRIx64, sym->start);
-		printf(" %-*.*s", sym_width, sym_width, sym->name);
-		printf(" %-*.*s\n", dso_width, dso_width,
-		       dso_width >= syme->map->dso->long_name_len ?
-					syme->map->dso->long_name :
-					syme->map->dso->short_name);
-	}
+	hists__fprintf(&top.sym_evsel->hists, NULL, false, false,
+		       winsize.ws_row - 4 - printed, win_width, stdout);
 }
 
 static void prompt_integer(int *target, const char *msg)
@@ -371,10 +340,11 @@ static void prompt_percent(int *target, const char *msg)
 		*target = tmp;
 }
 
-static void prompt_symbol(struct sym_entry **target, const char *msg)
+static void prompt_symbol(struct hist_entry **target, const char *msg)
 {
 	char *buf = malloc(0), *p;
-	struct sym_entry *syme = *target, *n, *found = NULL;
+	struct hist_entry *syme = *target, *n, *found = NULL;
+	struct rb_node *next;
 	size_t dummy = 0;
 
 	/* zero counters of active symbol */
@@ -391,17 +361,14 @@ static void prompt_symbol(struct sym_entry **target, const char *msg)
 	if (p)
 		*p = 0;
 
-	pthread_mutex_lock(&top.active_symbols_lock);
-	syme = list_entry(top.active_symbols.next, struct sym_entry, node);
-	pthread_mutex_unlock(&top.active_symbols_lock);
-
-	list_for_each_entry_safe_from(syme, n, &top.active_symbols, node) {
-		struct symbol *sym = sym_entry__symbol(syme);
-
-		if (!strcmp(buf, sym->name)) {
-			found = syme;
+	next = rb_first(&top.sym_evsel->hists.entries);
+	while (next) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		if (n->ms.sym && !strcmp(buf, n->ms.sym->name)) {
+			found = n;
 			break;
 		}
+		next = rb_next(&n->rb_node);
 	}
 
 	if (!found) {
@@ -420,7 +387,7 @@ static void print_mapped_keys(void)
 	char *name = NULL;
 
 	if (top.sym_filter_entry) {
-		struct symbol *sym = sym_entry__symbol(top.sym_filter_entry);
+		struct symbol *sym = top.sym_filter_entry->ms.sym;
 		name = sym->name;
 	}
 
@@ -437,9 +404,6 @@ static void print_mapped_keys(void)
 	fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
 	fprintf(stdout, "\t[S]     stop annotation.\n");
 
-	if (top.evlist->nr_entries > 1)
-		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", top.display_weighted ? 1 : 0);
-
 	fprintf(stdout,
 		"\t[K]     hide kernel_symbols symbols.     \t(%s)\n",
 		top.hide_kernel_symbols ? "yes" : "no");
@@ -466,8 +430,6 @@ static int key_mapped(int c)
 		case 'S':
 			return 1;
 		case 'E':
-		case 'w':
-			return top.evlist->nr_entries > 1 ? 1 : 0;
 		default:
 			break;
 	}
@@ -560,7 +522,7 @@ static void handle_keypress(int c)
 			if (!top.sym_filter_entry)
 				break;
 			else {
-				struct sym_entry *syme = top.sym_filter_entry;
+				struct hist_entry *syme = top.sym_filter_entry;
 
 				top.sym_filter_entry = NULL;
 				__zero_source_counters(syme);
@@ -569,9 +531,6 @@ static void handle_keypress(int c)
 		case 'U':
 			top.hide_user_symbols = !top.hide_user_symbols;
 			break;
-		case 'w':
-			top.display_weighted = ~top.display_weighted;
-			break;
 		case 'z':
 			top.zero = !top.zero;
 			break;
@@ -580,19 +539,29 @@ static void handle_keypress(int c)
 	}
 }
 
+static void perf_top__sort_new_samples(void *arg)
+{
+	struct perf_top *t = arg;
+	perf_top__reset_sample_counters(t);
+
+	if (t->evlist->selected != NULL)
+		t->sym_evsel = t->evlist->selected;
+
+	hists__collapse_resort_threaded(&t->sym_evsel->hists);
+	hists__output_resort_threaded(&t->sym_evsel->hists);
+	hists__decay_entries(&t->sym_evsel->hists);
+	hists__output_recalc_col_len(&t->sym_evsel->hists, winsize.ws_row - 3);
+}
+
 static void *display_thread_tui(void *arg __used)
 {
-	int err = 0;
-	pthread_mutex_lock(&top.active_symbols_lock);
-	while (list_empty(&top.active_symbols)) {
-		err = pthread_cond_wait(&top.active_symbols_cond,
-					&top.active_symbols_lock);
-		if (err)
-			break;
-	}
-	pthread_mutex_unlock(&top.active_symbols_lock);
-	if (!err)
-		perf_top__tui_browser(&top);
+	const char *help = "For a higher level overview, try: perf top --sort comm,dso";
+
+	perf_top__sort_new_samples(&top);
+	perf_evlist__tui_browse_hists(top.evlist, help,
+				      perf_top__sort_new_samples,
+				      &top, top.delay_secs);
+
 	exit_browser(0);
 	exit(0);
 	return NULL;
@@ -644,9 +613,8 @@ static const char *skip_symbols[] = {
 	NULL
 };
 
-static int symbol_filter(struct map *map, struct symbol *sym)
+static int symbol_filter(struct map *map __used, struct symbol *sym)
 {
-	struct sym_entry *syme;
 	const char *name = sym->name;
 	int i;
 
@@ -666,16 +634,6 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 	    strstr(name, "_text_end"))
 		return 1;
 
-	syme = symbol__priv(sym);
-	syme->map = map;
-	symbol__annotate_init(map, sym);
-
-	if (!top.sym_filter_entry && sym_filter && !strcmp(name, sym_filter)) {
-		/* schedule initial sym_filter_entry setup */
-		sym_filter_entry_sched = syme;
-		sym_filter = NULL;
-	}
-
 	for (i = 0; skip_symbols[i]; i++) {
 		if (!strcmp(skip_symbols[i], name)) {
 			sym->ignore = true;
@@ -691,7 +649,6 @@ static void perf_event__process_sample(const union perf_event *event,
 				       struct perf_session *session)
 {
 	u64 ip = event->ip.ip;
-	struct sym_entry *syme;
 	struct addr_location al;
 	struct machine *machine;
 	u8 origin = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
@@ -782,46 +739,25 @@ static void perf_event__process_sample(const union perf_event *event,
 				sleep(5);
 			vmlinux_warned = true;
 		}
-
-		return;
-	}
-
-	/* let's see, whether we need to install initial sym_filter_entry */
-	if (sym_filter_entry_sched) {
-		top.sym_filter_entry = sym_filter_entry_sched;
-		sym_filter_entry_sched = NULL;
-		if (parse_source(top.sym_filter_entry) < 0) {
-			struct symbol *sym = sym_entry__symbol(top.sym_filter_entry);
-
-			pr_err("Can't annotate %s", sym->name);
-			if (top.sym_filter_entry->map->dso->symtab_type == SYMTAB__KALLSYMS) {
-				pr_err(": No vmlinux file was found in the path:\n");
-				machine__fprintf_vmlinux_path(machine, stderr);
-			} else
-				pr_err(".\n");
-			exit(1);
-		}
 	}
 
-	syme = symbol__priv(al.sym);
-	if (!al.sym->ignore) {
+	if (al.sym == NULL || !al.sym->ignore) {
 		struct perf_evsel *evsel;
+		struct hist_entry *he;
 
 		evsel = perf_evlist__id2evsel(top.evlist, sample->id);
 		assert(evsel != NULL);
-		syme->count[evsel->idx]++;
-		record_precise_ip(syme, evsel->idx, ip);
-		pthread_mutex_lock(&top.active_symbols_lock);
-		if (list_empty(&syme->node) || !syme->node.next) {
-			static bool first = true;
-			__list_insert_active_sym(syme);
-			if (first) {
-				pthread_cond_broadcast(&top.active_symbols_cond);
-				first = false;
-			}
+
+		he = perf_session__add_hist_entry(session, &al, sample, evsel);
+		if (he == NULL) {
+			pr_err("Problem incrementing symbol period, skipping event\n");
+			return;
 		}
-		pthread_mutex_unlock(&top.active_symbols_lock);
+
+		record_precise_ip(he, evsel->idx, ip);
 	}
+
+	return;
 }
 
 static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
@@ -873,6 +809,7 @@ static void start_counters(struct perf_evlist *evlist)
 		}
 
 		attr->mmap = 1;
+		attr->comm = 1;
 		attr->inherit = inherit;
 try_again:
 		if (perf_evsel__open(counter, top.evlist->cpus,
@@ -1018,7 +955,7 @@ static const struct option options[] = {
 			    "put the counters into a counter group"),
 	OPT_BOOLEAN('i', "inherit", &inherit,
 		    "child tasks inherit counters"),
-	OPT_STRING('s', "sym-annotate", &sym_filter, "symbol name",
+	OPT_STRING(0, "sym-annotate", &sym_filter, "symbol name",
 		    "symbol to annotate"),
 	OPT_BOOLEAN('z', "zero", &top.zero,
 		    "zero history across updates"),
@@ -1032,6 +969,18 @@ static const struct option options[] = {
 	OPT_BOOLEAN(0, "stdio", &use_stdio, "Use the stdio interface"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
+	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
+		   "sort by key(s): pid, comm, dso, symbol, parent"),
+	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
+		    "Show a column with the number of samples"),
+	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
+		    "Show a column with the sum of periods"),
+	OPT_STRING(0, "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
+		   "only consider symbols in these dsos"),
+	OPT_STRING(0, "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
+		   "only consider symbols in these comms"),
+	OPT_STRING(0, "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
+		   "only consider these symbols"),
 	OPT_END()
 };
 
@@ -1044,12 +993,17 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (top.evlist == NULL)
 		return -ENOMEM;
 
-	page_size = sysconf(_SC_PAGE_SIZE);
+	symbol_conf.exclude_other = false;
 
 	argc = parse_options(argc, argv, options, top_usage, 0);
 	if (argc)
 		usage_with_options(top_usage, options);
 
+	if (sort_order == default_sort_order)
+		sort_order = "dso,symbol";
+
+	setup_sorting(top_usage, options);
+
 	/*
  	 * XXX For now start disabled, only using TUI if explicitely asked for.
  	 * Change that when handle_keys equivalent gets written, live annotation
@@ -1118,13 +1072,16 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
 
-	symbol_conf.priv_size = (sizeof(struct sym_entry) + sizeof(struct annotation) +
-				 (top.evlist->nr_entries + 1) * sizeof(unsigned long));
+	symbol_conf.priv_size = sizeof(struct annotation);
 
 	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
 	if (symbol__init() < 0)
 		return -1;
 
+	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
+	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
+	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
+
 	get_term_dimensions(&winsize);
 	if (top.print_entries == 0) {
 		update_print_entries(&winsize);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 80fe30d..82138a2 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -92,6 +92,39 @@ static void hist_entry__add_cpumode_period(struct hist_entry *self,
 	}
 }
 
+static void hist_entry__decay(struct hist_entry *he)
+{
+	he->period = (he->period * 7) / 8;
+	he->nr_events = (he->nr_events * 7) / 8;
+}
+
+static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
+{
+	hists->stats.total_period -= he->period;
+	hist_entry__decay(he);
+	hists->stats.total_period += he->period;
+	return he->period == 0;
+}
+
+void hists__decay_entries(struct hists *hists)
+{
+	struct rb_node *next = rb_first(&hists->entries);
+	struct hist_entry *n;
+
+	while (next) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		next = rb_next(&n->rb_node);
+
+		if (hists__decay_entry(hists, n)) {
+			rb_erase(&n->rb_node, &hists->entries);
+
+			if (sort__need_collapse)
+				rb_erase(&n->rb_node_in, &hists->entries_collapsed);
+			--hists->nr_entries;
+		}
+	}
+}
+
 /*
  * histogram, sorted on item, collects periods
  */
@@ -635,6 +668,21 @@ static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 	return ret;
 }
 
+void hists__output_recalc_col_len(struct hists *hists, int max_rows)
+{
+	struct rb_node *next = rb_first(&hists->entries);
+	struct hist_entry *n;
+	int row = 0;
+
+	hists__reset_col_len(hists);
+
+	while (next && row++ < max_rows) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		hists__calc_col_len(hists, n);
+		next = rb_next(&n->rb_node);
+	}
+}
+
 int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 			 struct hists *hists, struct hists *pair_hists,
 			 bool show_displacement, long displacement,
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 424f9eb..f87677b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -78,6 +78,9 @@ void hists__output_resort_threaded(struct hists *hists);
 void hists__collapse_resort(struct hists *self);
 void hists__collapse_resort_threaded(struct hists *hists);
 
+void hists__decay_entries(struct hists *hists);
+void hists__output_recalc_col_len(struct hists *hists, int max_rows);
+
 void hists__inc_nr_events(struct hists *self, u32 type);
 size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
 
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index a11f607..500471d 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -15,52 +15,6 @@
 #include "top.h"
 #include <inttypes.h>
 
-/*
- * Ordering weight: count-1 * count-2 * ... / count-n
- */
-static double sym_weight(const struct sym_entry *sym, struct perf_top *top)
-{
-	double weight = sym->snap_count;
-	int counter;
-
-	if (!top->display_weighted)
-		return weight;
-
-	for (counter = 1; counter < top->evlist->nr_entries - 1; counter++)
-		weight *= sym->count[counter];
-
-	weight /= (sym->count[counter] + 1);
-
-	return weight;
-}
-
-static void perf_top__remove_active_sym(struct perf_top *top, struct sym_entry *syme)
-{
-	pthread_mutex_lock(&top->active_symbols_lock);
-	list_del_init(&syme->node);
-	pthread_mutex_unlock(&top->active_symbols_lock);
-}
-
-static void rb_insert_active_sym(struct rb_root *tree, struct sym_entry *se)
-{
-	struct rb_node **p = &tree->rb_node;
-	struct rb_node *parent = NULL;
-	struct sym_entry *iter;
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct sym_entry, rb_node);
-
-		if (se->weight > iter->weight)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&se->rb_node, parent, p);
-	rb_insert_color(&se->rb_node, tree);
-}
-
 #define SNPRINTF(buf, size, fmt, args...) \
 ({ \
 	size_t r = snprintf(buf, size, fmt, ## args); \
@@ -69,7 +23,6 @@ static void rb_insert_active_sym(struct rb_root *tree, struct sym_entry *se)
 
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 {
-	struct perf_evsel *counter;
 	float samples_per_sec = top->samples / top->delay_secs;
 	float ksamples_per_sec = top->kernel_samples / top->delay_secs;
 	float esamples_percent = (100.0 * top->exact_samples) / top->samples;
@@ -104,7 +57,7 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 			       esamples_percent);
 	}
 
-	if (top->evlist->nr_entries == 1 || !top->display_weighted) {
+	if (top->evlist->nr_entries == 1) {
 		struct perf_evsel *first;
 		first = list_entry(top->evlist->entries.next, struct perf_evsel, node);
 		ret += SNPRINTF(bf + ret, size - ret, "%" PRIu64 "%s ",
@@ -112,27 +65,7 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 				top->freq ? "Hz" : "");
 	}
 
-	if (!top->display_weighted) {
-		ret += SNPRINTF(bf + ret, size - ret, "%s",
-				event_name(top->sym_evsel));
-	} else {
-		/*
-		 * Don't let events eat all the space. Leaving 30 bytes
-		 * for the rest should be enough.
-		 */
-		size_t last_pos = size - 30;
-
-		list_for_each_entry(counter, &top->evlist->entries, node) {
-			ret += SNPRINTF(bf + ret, size - ret, "%s%s",
-					counter->idx ? "/" : "",
-					event_name(counter));
-			if (ret > last_pos) {
-				sprintf(bf + last_pos - 3, "..");
-				ret = last_pos - 1;
-				break;
-			}
-		}
-	}
+	ret += SNPRINTF(bf + ret, size - ret, "%s", event_name(top->sym_evsel));
 
 	ret += SNPRINTF(bf + ret, size - ret, "], ");
 
@@ -166,73 +99,3 @@ void perf_top__reset_sample_counters(struct perf_top *top)
 	top->exact_samples = top->guest_kernel_samples =
 	top->guest_us_samples = 0;
 }
-
-float perf_top__decay_samples(struct perf_top *top, struct rb_root *root)
-{
-	struct sym_entry *syme, *n;
-	float sum_ksamples = 0.0;
-	int snap = !top->display_weighted ? top->sym_evsel->idx : 0, j;
-
-	/* Sort the active symbols */
-	pthread_mutex_lock(&top->active_symbols_lock);
-	syme = list_entry(top->active_symbols.next, struct sym_entry, node);
-	pthread_mutex_unlock(&top->active_symbols_lock);
-
-	top->rb_entries = 0;
-	list_for_each_entry_safe_from(syme, n, &top->active_symbols, node) {
-		syme->snap_count = syme->count[snap];
-		if (syme->snap_count != 0) {
-
-			if ((top->hide_user_symbols &&
-			     syme->map->dso->kernel == DSO_TYPE_USER) ||
-			    (top->hide_kernel_symbols &&
-			     syme->map->dso->kernel == DSO_TYPE_KERNEL)) {
-				perf_top__remove_active_sym(top, syme);
-				continue;
-			}
-			syme->weight = sym_weight(syme, top);
-
-			if ((int)syme->snap_count >= top->count_filter) {
-				rb_insert_active_sym(root, syme);
-				++top->rb_entries;
-			}
-			sum_ksamples += syme->snap_count;
-
-			for (j = 0; j < top->evlist->nr_entries; j++)
-				syme->count[j] = top->zero ? 0 : syme->count[j] * 7 / 8;
-		} else
-			perf_top__remove_active_sym(top, syme);
-	}
-
-	return sum_ksamples;
-}
-
-/*
- * Find the longest symbol name that will be displayed
- */
-void perf_top__find_widths(struct perf_top *top, struct rb_root *root,
-			   int *dso_width, int *dso_short_width, int *sym_width)
-{
-	struct rb_node *nd;
-	int printed = 0;
-
-	*sym_width = *dso_width = *dso_short_width = 0;
-
-	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
-		struct sym_entry *syme = rb_entry(nd, struct sym_entry, rb_node);
-		struct symbol *sym = sym_entry__symbol(syme);
-
-		if (++printed > top->print_entries ||
-		    (int)syme->snap_count < top->count_filter)
-			continue;
-
-		if (syme->map->dso->long_name_len > *dso_width)
-			*dso_width = syme->map->dso->long_name_len;
-
-		if (syme->map->dso->short_name_len > *dso_short_width)
-			*dso_short_width = syme->map->dso->short_name_len;
-
-		if (sym->namelen > *sym_width)
-			*sym_width = sym->namelen;
-	}
-}
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index b07b041..01d1057 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -4,64 +4,32 @@
 #include "types.h"
 #include "../perf.h"
 #include <stddef.h>
-#include <pthread.h>
-#include <linux/list.h>
-#include <linux/rbtree.h>
 
 struct perf_evlist;
 struct perf_evsel;
 struct perf_session;
 
-struct sym_entry {
-	struct rb_node		rb_node;
-	struct list_head	node;
-	unsigned long		snap_count;
-	double			weight;
-	struct map		*map;
-	unsigned long		count[0];
-};
-
-static inline struct symbol *sym_entry__symbol(struct sym_entry *self)
-{
-       return ((void *)self) + symbol_conf.priv_size;
-}
-
 struct perf_top {
 	struct perf_evlist *evlist;
 	/*
 	 * Symbols will be added here in perf_event__process_sample and will
 	 * get out after decayed.
 	 */
-	struct list_head   active_symbols;
-	pthread_mutex_t	   active_symbols_lock;
-	pthread_cond_t	   active_symbols_cond;
 	u64		   samples;
 	u64		   kernel_samples, us_samples;
 	u64		   exact_samples;
 	u64		   guest_us_samples, guest_kernel_samples;
 	u64		   total_lost_warned;
 	int		   print_entries, count_filter, delay_secs;
-	int		   display_weighted, freq, rb_entries;
+	int		   freq;
 	pid_t		   target_pid, target_tid;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	const char	   *cpu_list;
-	struct sym_entry   *sym_filter_entry;
+	struct hist_entry  *sym_filter_entry;
 	struct perf_evsel  *sym_evsel;
 	struct perf_session *session;
 };
 
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size);
 void perf_top__reset_sample_counters(struct perf_top *top);
-float perf_top__decay_samples(struct perf_top *top, struct rb_root *root);
-void perf_top__find_widths(struct perf_top *top, struct rb_root *root,
-			   int *dso_width, int *dso_short_width, int *sym_width);
-
-#ifdef NO_NEWT_SUPPORT
-static inline int perf_top__tui_browser(struct perf_top *top __used)
-{
-	return 0;
-}
-#else
-int perf_top__tui_browser(struct perf_top *top);
-#endif
 #endif /* __PERF_TOP_H */
diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
deleted file mode 100644
index d43875b..0000000
--- a/tools/perf/util/ui/browsers/top.c
+++ /dev/null
@@ -1,236 +0,0 @@
-/*
- * Copyright (C) 2011, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
- *
- * Parts came from builtin-{top,stat,record}.c, see those files for further
- * copyright notes.
- *
- * Released under the GPL v2. (and only v2, not any later version)
- */
-#include "../browser.h"
-#include "../../annotate.h"
-#include "../helpline.h"
-#include "../libslang.h"
-#include "../util.h"
-#include "../ui.h"
-#include "../../evlist.h"
-#include "../../hist.h"
-#include "../../sort.h"
-#include "../../symbol.h"
-#include "../../session.h"
-#include "../../top.h"
-
-struct perf_top_browser {
-	struct ui_browser b;
-	struct rb_root	  root;
-	struct sym_entry  *selection;
-	float		  sum_ksamples;
-	int		  dso_width;
-	int		  dso_short_width;
-	int		  sym_width;
-};
-
-static void perf_top_browser__write(struct ui_browser *browser, void *entry, int row)
-{
-	struct perf_top_browser *top_browser = container_of(browser, struct perf_top_browser, b);
-	struct sym_entry *syme = rb_entry(entry, struct sym_entry, rb_node);
-	bool current_entry = ui_browser__is_current_entry(browser, row);
-	struct symbol *symbol = sym_entry__symbol(syme);
-	struct perf_top *top = browser->priv;
-	int width = browser->width;
-	double pcnt;
-
-	pcnt = 100.0 - (100.0 * ((top_browser->sum_ksamples - syme->snap_count) /
-				 top_browser->sum_ksamples));
-	ui_browser__set_percent_color(browser, pcnt, current_entry);
-
-	if (top->evlist->nr_entries == 1 || !top->display_weighted) {
-		slsmg_printf("%20.2f ", syme->weight);
-		width -= 21;
-	} else {
-		slsmg_printf("%9.1f %10ld ", syme->weight, syme->snap_count);
-		width -= 20;
-	}
-
-	slsmg_printf("%4.1f%%", pcnt);
-	width -= 7;
-
-	if (verbose) {
-		slsmg_printf(" %016" PRIx64, symbol->start);
-		width -= 17;
-	}
-
-	slsmg_printf(" %-*.*s ", top_browser->sym_width, top_browser->sym_width,
-		     symbol->name);
-	width -= top_browser->sym_width;
-	slsmg_write_nstring(width >= syme->map->dso->long_name_len ?
-				syme->map->dso->long_name :
-				syme->map->dso->short_name, width);
-
-	if (current_entry)
-		top_browser->selection = syme;
-}
-
-static void perf_top_browser__update_rb_tree(struct perf_top_browser *browser)
-{
-	struct perf_top *top = browser->b.priv;
-	u64 top_idx = browser->b.top_idx;
-
-	browser->root = RB_ROOT;
-	browser->b.top = NULL;
-	browser->sum_ksamples = perf_top__decay_samples(top, &browser->root);
-	/*
- 	 * No active symbols
- 	 */
-	if (top->rb_entries == 0)
-		return;
-
-	perf_top__find_widths(top, &browser->root, &browser->dso_width,
-			      &browser->dso_short_width,
-                              &browser->sym_width);
-	if (browser->sym_width + browser->dso_width > browser->b.width - 29) {
-		browser->dso_width = browser->dso_short_width;
-		if (browser->sym_width + browser->dso_width > browser->b.width - 29)
-			browser->sym_width = browser->b.width - browser->dso_width - 29;
-	}
-
-	/*
-	 * Adjust the ui_browser indexes since the entries in the browser->root
-	 * rb_tree may have changed, then seek it from start, so that we get a
-	 * possible new top of the screen.
- 	 */
-	browser->b.nr_entries = top->rb_entries;
-
-	if (top_idx >= browser->b.nr_entries) {
-		if (browser->b.height >= browser->b.nr_entries)
-			top_idx = browser->b.nr_entries - browser->b.height;
-		else
-			top_idx = 0;
-	}
-
-	if (browser->b.index >= top_idx + browser->b.height)
-		browser->b.index = top_idx + browser->b.index - browser->b.top_idx;
-
-	if (browser->b.index >= browser->b.nr_entries)
-		browser->b.index = browser->b.nr_entries - 1;
-
-	browser->b.top_idx = top_idx;
-	browser->b.seek(&browser->b, top_idx, SEEK_SET);
-}
-
-static void perf_top_browser__annotate(struct perf_top_browser *browser)
-{
-	struct sym_entry *syme = browser->selection;
-	struct symbol *sym = sym_entry__symbol(syme);
-	struct annotation *notes = symbol__annotation(sym);
-	struct perf_top *top = browser->b.priv;
-
-	if (notes->src != NULL)
-		goto do_annotation;
-
-	pthread_mutex_lock(&notes->lock);
-
-	top->sym_filter_entry = NULL;
-
-	if (symbol__alloc_hist(sym, top->evlist->nr_entries) < 0) {
-		pr_err("Not enough memory for annotating '%s' symbol!\n",
-		       sym->name);
-		pthread_mutex_unlock(&notes->lock);
-		return;
-	}
-
-	top->sym_filter_entry = syme;
-
-	pthread_mutex_unlock(&notes->lock);
-do_annotation:
-	symbol__tui_annotate(sym, syme->map, 0, NULL, NULL, top->delay_secs * 1000);
-}
-
-static void perf_top_browser__warn_lost(struct perf_top_browser *browser)
-{
-	struct perf_top *top = browser->b.priv;
-	char msg[128];
-	int len;
-
-	top->total_lost_warned = top->session->hists.stats.total_lost;
-	pthread_mutex_lock(&ui__lock);
-	ui_browser__set_color(&browser->b, HE_COLORSET_TOP);
-	len = snprintf(msg, sizeof(msg),
-		      " WARNING: LOST %" PRIu64 " events, Check IO/CPU overload",
-		      top->total_lost_warned);
-	if (len > browser->b.width)
-		len = browser->b.width;
-	SLsmg_gotorc(0, browser->b.width - len);
-	slsmg_write_nstring(msg, len);
-	pthread_mutex_unlock(&ui__lock);
-}
-
-static int perf_top_browser__run(struct perf_top_browser *browser)
-{
-	int key;
-	char title[160];
-	struct perf_top *top = browser->b.priv;
-	int delay_msecs = top->delay_secs * 1000;
-	int exit_keys[] = { 'a', NEWT_KEY_ENTER, NEWT_KEY_RIGHT, 0, };
-
-	perf_top_browser__update_rb_tree(browser);
-        perf_top__header_snprintf(top, title, sizeof(title));
-        perf_top__reset_sample_counters(top);
-
-	if (ui_browser__show(&browser->b, title,
-			     "ESC: exit, ENTER|->|a: Live Annotate") < 0)
-		return -1;
-
-	newtFormSetTimer(browser->b.form, delay_msecs);
-	ui_browser__add_exit_keys(&browser->b, exit_keys);
-
-	while (1) {
-		key = ui_browser__run(&browser->b);
-
-		switch (key) {
-		case -1:
-			/* FIXME we need to check if it was es.reason == NEWT_EXIT_TIMER */
-			perf_top_browser__update_rb_tree(browser);
-			perf_top__header_snprintf(top, title, sizeof(title));
-			perf_top__reset_sample_counters(top);
-			ui_browser__set_color(&browser->b, NEWT_COLORSET_ROOT);
-			SLsmg_gotorc(0, 0);
-			slsmg_write_nstring(title, browser->b.width);
-
-			if (top->total_lost_warned != top->session->hists.stats.total_lost)
-				perf_top_browser__warn_lost(browser);
-			break;
-		case 'a':
-		case NEWT_KEY_RIGHT:
-		case NEWT_KEY_ENTER:
-			if (browser->selection)
-				perf_top_browser__annotate(browser);
-			break;
-		case NEWT_KEY_LEFT:
-			continue;
-		case NEWT_KEY_ESCAPE:
-			if (!ui__dialog_yesno("Do you really want to exit?"))
-				continue;
-			/* Fall thru */
-		default:
-			goto out;
-		}
-	}
-out:
-	ui_browser__hide(&browser->b);
-	return key;
-}
-
-int perf_top__tui_browser(struct perf_top *top)
-{
-	struct perf_top_browser browser = {
-		.b = {
-			.entries = &browser.root,
-			.refresh = ui_browser__rb_tree_refresh,
-			.seek	 = ui_browser__rb_tree_seek,
-			.write	 = perf_top_browser__write,
-			.priv	 = top,
-		},
-	};
-
-	return perf_top_browser__run(&browser);
-}
-- 
1.6.2.5

