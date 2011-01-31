Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab1AaV3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:29:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:36616 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab1AaV3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:29:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/5] perf top: Move display agnostic routines to util/top.[ch]
Date: Mon, 31 Jan 2011 19:29:20 -0200
Message-Id: <1296509362-28054-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296509362-28054-1-git-send-email-acme@infradead.org>
References: <1296509362-28054-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Paving the way for a slang browser a la 'perf report --tui'.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |    2 +
 tools/perf/builtin-top.c |  482 +++++++++++++---------------------------------
 tools/perf/util/top.c    |  212 ++++++++++++++++++++
 tools/perf/util/top.h    |   67 +++++++
 4 files changed, 418 insertions(+), 345 deletions(-)
 create mode 100644 tools/perf/util/top.c
 create mode 100644 tools/perf/util/top.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 36ff73c..edc660e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -437,6 +437,7 @@ LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
 LIB_H += util/cpumap.h
+LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
@@ -464,6 +465,7 @@ LIB_OBJS += $(OUTPUT)util/strbuf.o
 LIB_OBJS += $(OUTPUT)util/string.o
 LIB_OBJS += $(OUTPUT)util/strlist.o
 LIB_OBJS += $(OUTPUT)util/strfilter.o
+LIB_OBJS += $(OUTPUT)util/top.o
 LIB_OBJS += $(OUTPUT)util/usage.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 599036b..3c9ba94 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -27,6 +27,7 @@
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/thread_map.h"
+#include "util/top.h"
 #include "util/util.h"
 #include <linux/rbtree.h>
 #include "util/parse-options.h"
@@ -47,7 +48,6 @@
 #include <errno.h>
 #include <time.h>
 #include <sched.h>
-#include <pthread.h>
 
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
@@ -62,75 +62,35 @@
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
-struct perf_evlist		*evsel_list;
+static struct perf_top top = {
+	.count_filter		= 5,
+	.delay_secs		= 2,
+	.display_weighted	= -1,
+	.target_pid		= -1,
+	.target_tid		= -1,
+	.active_symbols		= LIST_HEAD_INIT(top.active_symbols),
+	.active_symbols_lock	= PTHREAD_MUTEX_INITIALIZER,
+	.freq			= 1000, /* 1 KHz */
+};
 
 static bool			system_wide			=  false;
 
 static int			default_interval		=      0;
 
-static int			count_filter			=      5;
-static int			print_entries;
-
-static int			target_pid			=     -1;
-static int			target_tid			=     -1;
 static bool			inherit				=  false;
 static int			realtime_prio			=      0;
 static bool			group				=  false;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			=    128;
-static int			freq				=   1000; /* 1 KHz */
 
-static int			delay_secs			=      2;
-static bool			zero                            =  false;
 static bool			dump_symtab                     =  false;
 
-static bool			hide_kernel_symbols		=  false;
-static bool			hide_user_symbols		=  false;
 static struct winsize		winsize;
 
-/*
- * Source
- */
-
-struct source_line {
-	u64			eip;
-	unsigned long		count[MAX_COUNTERS];
-	char			*line;
-	struct source_line	*next;
-};
-
 static const char		*sym_filter			=   NULL;
 struct sym_entry		*sym_filter_entry		=   NULL;
 struct sym_entry		*sym_filter_entry_sched		=   NULL;
 static int			sym_pcnt_filter			=      5;
-static int			sym_counter			=      0;
-static struct perf_evsel	*sym_evsel			=   NULL;
-static int			display_weighted		=     -1;
-static const char		*cpu_list;
-
-/*
- * Symbols
- */
-
-struct sym_entry_source {
-	struct source_line	*source;
-	struct source_line	*lines;
-	struct source_line	**lines_tail;
-	pthread_mutex_t		lock;
-};
-
-struct sym_entry {
-	struct rb_node		rb_node;
-	struct list_head	node;
-	unsigned long		snap_count;
-	double			weight;
-	int			skip;
-	u16			name_len;
-	u8			origin;
-	struct map		*map;
-	struct sym_entry_source	*src;
-	unsigned long		count[0];
-};
 
 /*
  * Source functions
@@ -165,10 +125,10 @@ void get_term_dimensions(struct winsize *ws)
 
 static void update_print_entries(struct winsize *ws)
 {
-	print_entries = ws->ws_row;
+	top.print_entries = ws->ws_row;
 
-	if (print_entries > 9)
-		print_entries -= 9;
+	if (top.print_entries > 9)
+		top.print_entries -= 9;
 }
 
 static void sig_winch_handler(int sig __used)
@@ -269,7 +229,7 @@ static void __zero_source_counters(struct sym_entry *syme)
 
 	line = syme->src->lines;
 	while (line) {
-		for (i = 0; i < evsel_list->nr_entries; i++)
+		for (i = 0; i < top.evlist->nr_entries; i++)
 			line->count[i] = 0;
 		line = line->next;
 	}
@@ -331,9 +291,9 @@ static void show_lines(struct source_line *queue, int count, int total)
 
 	line = queue;
 	for (i = 0; i < count; i++) {
-		float pcnt = 100.0*(float)line->count[sym_counter]/(float)total;
+		float pcnt = 100.0*(float)line->count[top.sym_counter]/(float)total;
 
-		printf("%8li %4.1f%%\t%s\n", line->count[sym_counter], pcnt, line->line);
+		printf("%8li %4.1f%%\t%s\n", line->count[top.sym_counter], pcnt, line->line);
 		line = line->next;
 	}
 }
@@ -358,13 +318,13 @@ static void show_details(struct sym_entry *syme)
 		return;
 
 	symbol = sym_entry__symbol(syme);
-	printf("Showing %s for %s\n", event_name(sym_evsel), symbol->name);
+	printf("Showing %s for %s\n", event_name(top.sym_evsel), symbol->name);
 	printf("  Events  Pcnt (>=%d%%)\n", sym_pcnt_filter);
 
 	pthread_mutex_lock(&syme->src->lock);
 	line = syme->src->source;
 	while (line) {
-		total += line->count[sym_counter];
+		total += line->count[top.sym_counter];
 		line = line->next;
 	}
 
@@ -376,10 +336,10 @@ static void show_details(struct sym_entry *syme)
 			line_queue = line;
 		line_queue_count++;
 
-		if (line->count[sym_counter])
-			pcnt = 100.0 * line->count[sym_counter] / (float)total;
+		if (line->count[top.sym_counter])
+			pcnt = 100.0 * line->count[top.sym_counter] / (float)total;
 		if (pcnt >= (float)sym_pcnt_filter) {
-			if (displayed <= print_entries)
+			if (displayed <= top.print_entries)
 				show_lines(line_queue, line_queue_count, total);
 			else more++;
 			displayed += line_queue_count;
@@ -390,7 +350,7 @@ static void show_details(struct sym_entry *syme)
 			line_queue_count--;
 		}
 
-		line->count[sym_counter] = zero ? 0 : line->count[sym_counter] * 7 / 8;
+		line->count[top.sym_counter] = top.zero ? 0 : line->count[top.sym_counter] * 7 / 8;
 		line = line->next;
 	}
 	pthread_mutex_unlock(&syme->src->lock);
@@ -398,181 +358,30 @@ static void show_details(struct sym_entry *syme)
 		printf("%d lines not displayed, maybe increase display entries [e]\n", more);
 }
 
-/*
- * Symbols will be added here in perf_event__process_sample and will get out
- * after decayed.
- */
-static LIST_HEAD(active_symbols);
-static pthread_mutex_t active_symbols_lock = PTHREAD_MUTEX_INITIALIZER;
-
-/*
- * Ordering weight: count-1 * count-2 * ... / count-n
- */
-static double sym_weight(const struct sym_entry *sym)
-{
-	double weight = sym->snap_count;
-	int counter;
-
-	if (!display_weighted)
-		return weight;
-
-	for (counter = 1; counter < evsel_list->nr_entries - 1; counter++)
-		weight *= sym->count[counter];
-
-	weight /= (sym->count[counter] + 1);
-
-	return weight;
-}
-
-static long			samples;
-static long			kernel_samples, us_samples;
-static long			exact_samples;
-static long			guest_us_samples, guest_kernel_samples;
 static const char		CONSOLE_CLEAR[] = "[H[2J";
 
 static void __list_insert_active_sym(struct sym_entry *syme)
 {
-	list_add(&syme->node, &active_symbols);
-}
-
-static void list_remove_active_sym(struct sym_entry *syme)
-{
-	pthread_mutex_lock(&active_symbols_lock);
-	list_del_init(&syme->node);
-	pthread_mutex_unlock(&active_symbols_lock);
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
+	list_add(&syme->node, &top.active_symbols);
 }
 
 static void print_sym_table(struct perf_session *session)
 {
-	int printed = 0, j;
-	struct perf_evsel *counter;
-	int snap = !display_weighted ? sym_counter : 0;
-	float samples_per_sec = samples/delay_secs;
-	float ksamples_per_sec = kernel_samples/delay_secs;
-	float us_samples_per_sec = (us_samples)/delay_secs;
-	float guest_kernel_samples_per_sec = (guest_kernel_samples)/delay_secs;
-	float guest_us_samples_per_sec = (guest_us_samples)/delay_secs;
-	float esamples_percent = (100.0*exact_samples)/samples;
-	float sum_ksamples = 0.0;
-	struct sym_entry *syme, *n;
-	struct rb_root tmp = RB_ROOT;
+	char bf[160];
+	int printed = 0;
 	struct rb_node *nd;
-	int sym_width = 0, dso_width = 0, dso_short_width = 0;
+	struct sym_entry *syme;
+	struct rb_root tmp = RB_ROOT;
 	const int win_width = winsize.ws_col - 1;
-
-	samples = us_samples = kernel_samples = exact_samples = 0;
-	guest_kernel_samples = guest_us_samples = 0;
-
-	/* Sort the active symbols */
-	pthread_mutex_lock(&active_symbols_lock);
-	syme = list_entry(active_symbols.next, struct sym_entry, node);
-	pthread_mutex_unlock(&active_symbols_lock);
-
-	list_for_each_entry_safe_from(syme, n, &active_symbols, node) {
-		syme->snap_count = syme->count[snap];
-		if (syme->snap_count != 0) {
-
-			if ((hide_user_symbols &&
-			     syme->origin == PERF_RECORD_MISC_USER) ||
-			    (hide_kernel_symbols &&
-			     syme->origin == PERF_RECORD_MISC_KERNEL)) {
-				list_remove_active_sym(syme);
-				continue;
-			}
-			syme->weight = sym_weight(syme);
-			rb_insert_active_sym(&tmp, syme);
-			sum_ksamples += syme->snap_count;
-
-			for (j = 0; j < evsel_list->nr_entries; j++)
-				syme->count[j] = zero ? 0 : syme->count[j] * 7 / 8;
-		} else
-			list_remove_active_sym(syme);
-	}
+	int sym_width, dso_width, dso_short_width;
+	float sum_ksamples = perf_top__decay_samples(&top, &tmp);
 
 	puts(CONSOLE_CLEAR);
 
-	if (!perf_guest) {
-		printf("   PerfTop:%8.0f irqs/sec  kernel:%4.1f%%"
-			"  exact: %4.1f%% [",
-			samples_per_sec,
-			100.0 - (100.0 * ((samples_per_sec - ksamples_per_sec) /
-					 samples_per_sec)),
-			esamples_percent);
-	} else {
-		printf("   PerfTop:%8.0f irqs/sec  kernel:%4.1f%% us:%4.1f%%"
-			" guest kernel:%4.1f%% guest us:%4.1f%%"
-			" exact: %4.1f%% [",
-			samples_per_sec,
-			100.0 - (100.0 * ((samples_per_sec-ksamples_per_sec) /
-					  samples_per_sec)),
-			100.0 - (100.0 * ((samples_per_sec-us_samples_per_sec) /
-					  samples_per_sec)),
-			100.0 - (100.0 * ((samples_per_sec -
-						guest_kernel_samples_per_sec) /
-					  samples_per_sec)),
-			100.0 - (100.0 * ((samples_per_sec -
-					   guest_us_samples_per_sec) /
-					  samples_per_sec)),
-			esamples_percent);
-	}
+	perf_top__header_snprintf(&top, bf, sizeof(bf));
+	printf("%s\n", bf);
 
-	if (evsel_list->nr_entries == 1 || !display_weighted) {
-		struct perf_evsel *first;
-		first = list_entry(evsel_list->entries.next, struct perf_evsel, node);
-		printf("%" PRIu64, (uint64_t)first->attr.sample_period);
-		if (freq)
-			printf("Hz ");
-		else
-			printf(" ");
-	}
-
-	if (!display_weighted)
-		printf("%s", event_name(sym_evsel));
-	else list_for_each_entry(counter, &evsel_list->entries, node) {
-		if (counter->idx)
-			printf("/");
-
-		printf("%s", event_name(counter));
-	}
-
-	printf( "], ");
-
-	if (target_pid != -1)
-		printf(" (target_pid: %d", target_pid);
-	else if (target_tid != -1)
-		printf(" (target_tid: %d", target_tid);
-	else
-		printf(" (all");
-
-	if (cpu_list)
-		printf(", CPU%s: %s)\n", evsel_list->cpus->nr > 1 ? "s" : "", cpu_list);
-	else {
-		if (target_tid != -1)
-			printf(")\n");
-		else
-			printf(", %d CPU%s)\n", evsel_list->cpus->nr,
-			       evsel_list->cpus->nr > 1 ? "s" : "");
-	}
+	perf_top__reset_sample_counters(&top);
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
 
@@ -587,26 +396,8 @@ static void print_sym_table(struct perf_session *session)
 		return;
 	}
 
-	/*
-	 * Find the longest symbol name that will be displayed
-	 */
-	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
-		syme = rb_entry(nd, struct sym_entry, rb_node);
-		if (++printed > print_entries ||
-		    (int)syme->snap_count < count_filter)
-			continue;
-
-		if (syme->map->dso->long_name_len > dso_width)
-			dso_width = syme->map->dso->long_name_len;
-
-		if (syme->map->dso->short_name_len > dso_short_width)
-			dso_short_width = syme->map->dso->short_name_len;
-
-		if (syme->name_len > sym_width)
-			sym_width = syme->name_len;
-	}
-
-	printed = 0;
+	perf_top__find_widths(&top, &tmp, &dso_width, &dso_short_width,
+			      &sym_width);
 
 	if (sym_width + dso_width > winsize.ws_col - 29) {
 		dso_width = dso_short_width;
@@ -614,7 +405,7 @@ static void print_sym_table(struct perf_session *session)
 			sym_width = winsize.ws_col - dso_width - 29;
 	}
 	putchar('\n');
-	if (evsel_list->nr_entries == 1)
+	if (top.evlist->nr_entries == 1)
 		printf("             samples  pcnt");
 	else
 		printf("   weight    samples  pcnt");
@@ -623,7 +414,7 @@ static void print_sym_table(struct perf_session *session)
 		printf("         RIP       ");
 	printf(" %-*.*s DSO\n", sym_width, sym_width, "function");
 	printf("   %s    _______ _____",
-	       evsel_list->nr_entries == 1 ? "      " : "______");
+	       top.evlist->nr_entries == 1 ? "      " : "______");
 	if (verbose)
 		printf(" ________________");
 	printf(" %-*.*s", sym_width, sym_width, graph_line);
@@ -636,13 +427,14 @@ static void print_sym_table(struct perf_session *session)
 
 		syme = rb_entry(nd, struct sym_entry, rb_node);
 		sym = sym_entry__symbol(syme);
-		if (++printed > print_entries || (int)syme->snap_count < count_filter)
+		if (++printed > top.print_entries ||
+		    (int)syme->snap_count < top.count_filter)
 			continue;
 
 		pcnt = 100.0 - (100.0 * ((sum_ksamples - syme->snap_count) /
 					 sum_ksamples));
 
-		if (evsel_list->nr_entries == 1 || !display_weighted)
+		if (top.evlist->nr_entries == 1 || !top.display_weighted)
 			printf("%20.2f ", syme->weight);
 		else
 			printf("%9.1f %10ld ", syme->weight, syme->snap_count);
@@ -715,11 +507,11 @@ static void prompt_symbol(struct sym_entry **target, const char *msg)
 	if (p)
 		*p = 0;
 
-	pthread_mutex_lock(&active_symbols_lock);
-	syme = list_entry(active_symbols.next, struct sym_entry, node);
-	pthread_mutex_unlock(&active_symbols_lock);
+	pthread_mutex_lock(&top.active_symbols_lock);
+	syme = list_entry(top.active_symbols.next, struct sym_entry, node);
+	pthread_mutex_unlock(&top.active_symbols_lock);
 
-	list_for_each_entry_safe_from(syme, n, &active_symbols, node) {
+	list_for_each_entry_safe_from(syme, n, &top.active_symbols, node) {
 		struct symbol *sym = sym_entry__symbol(syme);
 
 		if (!strcmp(buf, sym->name)) {
@@ -749,28 +541,28 @@ static void print_mapped_keys(void)
 	}
 
 	fprintf(stdout, "\nMapped keys:\n");
-	fprintf(stdout, "\t[d]     display refresh delay.             \t(%d)\n", delay_secs);
-	fprintf(stdout, "\t[e]     display entries (lines).           \t(%d)\n", print_entries);
+	fprintf(stdout, "\t[d]     display refresh delay.             \t(%d)\n", top.delay_secs);
+	fprintf(stdout, "\t[e]     display entries (lines).           \t(%d)\n", top.print_entries);
 
-	if (evsel_list->nr_entries > 1)
-		fprintf(stdout, "\t[E]     active event counter.              \t(%s)\n", event_name(sym_evsel));
+	if (top.evlist->nr_entries > 1)
+		fprintf(stdout, "\t[E]     active event counter.              \t(%s)\n", event_name(top.sym_evsel));
 
-	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", count_filter);
+	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", top.count_filter);
 
 	fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", sym_pcnt_filter);
 	fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
 	fprintf(stdout, "\t[S]     stop annotation.\n");
 
-	if (evsel_list->nr_entries > 1)
-		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", display_weighted ? 1 : 0);
+	if (top.evlist->nr_entries > 1)
+		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", top.display_weighted ? 1 : 0);
 
 	fprintf(stdout,
 		"\t[K]     hide kernel_symbols symbols.     \t(%s)\n",
-		hide_kernel_symbols ? "yes" : "no");
+		top.hide_kernel_symbols ? "yes" : "no");
 	fprintf(stdout,
 		"\t[U]     hide user symbols.               \t(%s)\n",
-		hide_user_symbols ? "yes" : "no");
-	fprintf(stdout, "\t[z]     toggle sample zeroing.             \t(%d)\n", zero ? 1 : 0);
+		top.hide_user_symbols ? "yes" : "no");
+	fprintf(stdout, "\t[z]     toggle sample zeroing.             \t(%d)\n", top.zero ? 1 : 0);
 	fprintf(stdout, "\t[qQ]    quit.\n");
 }
 
@@ -791,7 +583,7 @@ static int key_mapped(int c)
 			return 1;
 		case 'E':
 		case 'w':
-			return evsel_list->nr_entries > 1 ? 1 : 0;
+			return top.evlist->nr_entries > 1 ? 1 : 0;
 		default:
 			break;
 	}
@@ -826,47 +618,47 @@ static void handle_keypress(struct perf_session *session, int c)
 
 	switch (c) {
 		case 'd':
-			prompt_integer(&delay_secs, "Enter display delay");
-			if (delay_secs < 1)
-				delay_secs = 1;
+			prompt_integer(&top.delay_secs, "Enter display delay");
+			if (top.delay_secs < 1)
+				top.delay_secs = 1;
 			break;
 		case 'e':
-			prompt_integer(&print_entries, "Enter display entries (lines)");
-			if (print_entries == 0) {
+			prompt_integer(&top.print_entries, "Enter display entries (lines)");
+			if (top.print_entries == 0) {
 				sig_winch_handler(SIGWINCH);
 				signal(SIGWINCH, sig_winch_handler);
 			} else
 				signal(SIGWINCH, SIG_DFL);
 			break;
 		case 'E':
-			if (evsel_list->nr_entries > 1) {
+			if (top.evlist->nr_entries > 1) {
 				fprintf(stderr, "\nAvailable events:");
 
-				list_for_each_entry(sym_evsel, &evsel_list->entries, node)
-					fprintf(stderr, "\n\t%d %s", sym_evsel->idx, event_name(sym_evsel));
+				list_for_each_entry(top.sym_evsel, &top.evlist->entries, node)
+					fprintf(stderr, "\n\t%d %s", top.sym_evsel->idx, event_name(top.sym_evsel));
 
-				prompt_integer(&sym_counter, "Enter details event counter");
+				prompt_integer(&top.sym_counter, "Enter details event counter");
 
-				if (sym_counter >= evsel_list->nr_entries) {
-					sym_evsel = list_entry(evsel_list->entries.next, struct perf_evsel, node);
-					sym_counter = 0;
-					fprintf(stderr, "Sorry, no such event, using %s.\n", event_name(sym_evsel));
+				if (top.sym_counter >= top.evlist->nr_entries) {
+					top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
+					top.sym_counter = 0;
+					fprintf(stderr, "Sorry, no such event, using %s.\n", event_name(top.sym_evsel));
 					sleep(1);
 					break;
 				}
-				list_for_each_entry(sym_evsel, &evsel_list->entries, node)
-					if (sym_evsel->idx == sym_counter)
+				list_for_each_entry(top.sym_evsel, &top.evlist->entries, node)
+					if (top.sym_evsel->idx == top.sym_counter)
 						break;
-			} else sym_counter = 0;
+			} else top.sym_counter = 0;
 			break;
 		case 'f':
-			prompt_integer(&count_filter, "Enter display event count filter");
+			prompt_integer(&top.count_filter, "Enter display event count filter");
 			break;
 		case 'F':
 			prompt_percent(&sym_pcnt_filter, "Enter details display event filter (percent)");
 			break;
 		case 'K':
-			hide_kernel_symbols = !hide_kernel_symbols;
+			top.hide_kernel_symbols = !top.hide_kernel_symbols;
 			break;
 		case 'q':
 		case 'Q':
@@ -890,13 +682,13 @@ static void handle_keypress(struct perf_session *session, int c)
 			}
 			break;
 		case 'U':
-			hide_user_symbols = !hide_user_symbols;
+			top.hide_user_symbols = !top.hide_user_symbols;
 			break;
 		case 'w':
-			display_weighted = ~display_weighted;
+			top.display_weighted = ~top.display_weighted;
 			break;
 		case 'z':
-			zero = !zero;
+			top.zero = !top.zero;
 			break;
 		default:
 			break;
@@ -917,7 +709,7 @@ static void *display_thread(void *arg __used)
 	tc.c_cc[VTIME] = 0;
 
 repeat:
-	delay_msecs = delay_secs * 1000;
+	delay_msecs = top.delay_secs * 1000;
 	tcsetattr(0, TCSANOW, &tc);
 	/* trash return*/
 	getc(stdin);
@@ -1005,27 +797,27 @@ static void perf_event__process_sample(const union perf_event *event,
 	struct machine *machine;
 	u8 origin = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	++samples;
+	++top.samples;
 
 	switch (origin) {
 	case PERF_RECORD_MISC_USER:
-		++us_samples;
-		if (hide_user_symbols)
+		++top.us_samples;
+		if (top.hide_user_symbols)
 			return;
 		machine = perf_session__find_host_machine(session);
 		break;
 	case PERF_RECORD_MISC_KERNEL:
-		++kernel_samples;
-		if (hide_kernel_symbols)
+		++top.kernel_samples;
+		if (top.hide_kernel_symbols)
 			return;
 		machine = perf_session__find_host_machine(session);
 		break;
 	case PERF_RECORD_MISC_GUEST_KERNEL:
-		++guest_kernel_samples;
+		++top.guest_kernel_samples;
 		machine = perf_session__find_machine(session, event->ip.pid);
 		break;
 	case PERF_RECORD_MISC_GUEST_USER:
-		++guest_us_samples;
+		++top.guest_us_samples;
 		/*
 		 * TODO: we don't process guest user from host side
 		 * except simple counting.
@@ -1042,7 +834,7 @@ static void perf_event__process_sample(const union perf_event *event,
 	}
 
 	if (event->header.misc & PERF_RECORD_MISC_EXACT_IP)
-		exact_samples++;
+		top.exact_samples++;
 
 	if (perf_event__preprocess_sample(event, session, &al, sample,
 					  symbol_filter) < 0 ||
@@ -1093,14 +885,14 @@ static void perf_event__process_sample(const union perf_event *event,
 		struct perf_evsel *evsel;
 
 		syme->origin = origin;
-		evsel = perf_evlist__id2evsel(evsel_list, sample->id);
+		evsel = perf_evlist__id2evsel(top.evlist, sample->id);
 		assert(evsel != NULL);
 		syme->count[evsel->idx]++;
 		record_precise_ip(syme, evsel->idx, ip);
-		pthread_mutex_lock(&active_symbols_lock);
+		pthread_mutex_lock(&top.active_symbols_lock);
 		if (list_empty(&syme->node) || !syme->node.next)
 			__list_insert_active_sym(syme);
-		pthread_mutex_unlock(&active_symbols_lock);
+		pthread_mutex_unlock(&top.active_symbols_lock);
 	}
 }
 
@@ -1109,7 +901,7 @@ static void perf_session__mmap_read_cpu(struct perf_session *self, int cpu)
 	struct perf_sample sample;
 	union perf_event *event;
 
-	while ((event = perf_evlist__read_on_cpu(evsel_list, cpu)) != NULL) {
+	while ((event = perf_evlist__read_on_cpu(top.evlist, cpu)) != NULL) {
 		perf_session__parse_sample(self, event, &sample);
 
 		if (event->header.type == PERF_RECORD_SAMPLE)
@@ -1123,7 +915,7 @@ static void perf_session__mmap_read(struct perf_session *self)
 {
 	int i;
 
-	for (i = 0; i < evsel_list->cpus->nr; i++)
+	for (i = 0; i < top.evlist->cpus->nr; i++)
 		perf_session__mmap_read_cpu(self, i);
 }
 
@@ -1136,10 +928,10 @@ static void start_counters(struct perf_evlist *evlist)
 
 		attr->sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
-		if (freq) {
+		if (top.freq) {
 			attr->sample_type |= PERF_SAMPLE_PERIOD;
 			attr->freq	  = 1;
-			attr->sample_freq = freq;
+			attr->sample_freq = top.freq;
 		}
 
 		if (evlist->nr_entries > 1) {
@@ -1149,8 +941,8 @@ static void start_counters(struct perf_evlist *evlist)
 
 		attr->mmap = 1;
 try_again:
-		if (perf_evsel__open(counter, evsel_list->cpus,
-				     evsel_list->threads, group, inherit) < 0) {
+		if (perf_evsel__open(counter, top.evlist->cpus,
+				     top.evlist->threads, group, inherit) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES)
@@ -1198,18 +990,18 @@ static int __cmd_top(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (target_tid != -1)
-		perf_event__synthesize_thread(target_tid, perf_event__process,
+	if (top.target_tid != -1)
+		perf_event__synthesize_thread(top.target_tid, perf_event__process,
 					      session);
 	else
 		perf_event__synthesize_threads(perf_event__process, session);
 
-	start_counters(evsel_list);
-	first = list_entry(evsel_list->entries.next, struct perf_evsel, node);
+	start_counters(top.evlist);
+	first = list_entry(top.evlist->entries.next, struct perf_evsel, node);
 	perf_session__set_sample_type(session, first->attr.sample_type);
 
 	/* Wait for a minimal set of events before starting the snapshot */
-	poll(evsel_list->pollfd, evsel_list->nr_fds, 100);
+	poll(top.evlist->pollfd, top.evlist->nr_fds, 100);
 
 	perf_session__mmap_read(session);
 
@@ -1229,12 +1021,12 @@ static int __cmd_top(void)
 	}
 
 	while (1) {
-		int hits = samples;
+		u64 hits = top.samples;
 
 		perf_session__mmap_read(session);
 
-		if (hits == samples)
-			ret = poll(evsel_list->pollfd, evsel_list->nr_fds, 100);
+		if (hits == top.samples)
+			ret = poll(top.evlist->pollfd, top.evlist->nr_fds, 100);
 	}
 
 	return 0;
@@ -1246,31 +1038,31 @@ static const char * const top_usage[] = {
 };
 
 static const struct option options[] = {
-	OPT_CALLBACK('e', "event", &evsel_list, "event",
+	OPT_CALLBACK('e', "event", &top.evlist, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events),
 	OPT_INTEGER('c', "count", &default_interval,
 		    "event period to sample"),
-	OPT_INTEGER('p', "pid", &target_pid,
+	OPT_INTEGER('p', "pid", &top.target_pid,
 		    "profile events on existing process id"),
-	OPT_INTEGER('t', "tid", &target_tid,
+	OPT_INTEGER('t', "tid", &top.target_tid,
 		    "profile events on existing thread id"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 			    "system-wide collection from all CPUs"),
-	OPT_STRING('C', "cpu", &cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &top.cpu_list, "cpu",
 		    "list of cpus to monitor"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
-	OPT_BOOLEAN('K', "hide_kernel_symbols", &hide_kernel_symbols,
+	OPT_BOOLEAN('K', "hide_kernel_symbols", &top.hide_kernel_symbols,
 		    "hide kernel symbols"),
 	OPT_UINTEGER('m', "mmap-pages", &mmap_pages, "number of mmap data pages"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
-	OPT_INTEGER('d', "delay", &delay_secs,
+	OPT_INTEGER('d', "delay", &top.delay_secs,
 		    "number of seconds to delay between refreshes"),
 	OPT_BOOLEAN('D', "dump-symtab", &dump_symtab,
 			    "dump the symbol table used for profiling"),
-	OPT_INTEGER('f', "count-filter", &count_filter,
+	OPT_INTEGER('f', "count-filter", &top.count_filter,
 		    "only display functions with more events than this"),
 	OPT_BOOLEAN('g', "group", &group,
 			    "put the counters into a counter group"),
@@ -1278,13 +1070,13 @@ static const struct option options[] = {
 		    "child tasks inherit counters"),
 	OPT_STRING('s', "sym-annotate", &sym_filter, "symbol name",
 		    "symbol to annotate"),
-	OPT_BOOLEAN('z', "zero", &zero,
+	OPT_BOOLEAN('z', "zero", &top.zero,
 		    "zero history across updates"),
-	OPT_INTEGER('F', "freq", &freq,
+	OPT_INTEGER('F', "freq", &top.freq,
 		    "profile at this frequency"),
-	OPT_INTEGER('E', "entries", &print_entries,
+	OPT_INTEGER('E', "entries", &top.print_entries,
 		    "display this many functions"),
-	OPT_BOOLEAN('U', "hide_user_symbols", &hide_user_symbols,
+	OPT_BOOLEAN('U', "hide_user_symbols", &top.hide_user_symbols,
 		    "hide user symbols"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
@@ -1296,8 +1088,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	struct perf_evsel *pos;
 	int status = -ENOMEM;
 
-	evsel_list = perf_evlist__new(NULL, NULL);
-	if (evsel_list == NULL)
+	top.evlist = perf_evlist__new(NULL, NULL);
+	if (top.evlist == NULL)
 		return -ENOMEM;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
@@ -1307,43 +1099,43 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(top_usage, options);
 
 	/* CPU and PID are mutually exclusive */
-	if (target_tid > 0 && cpu_list) {
+	if (top.target_tid > 0 && top.cpu_list) {
 		printf("WARNING: PID switch overriding CPU\n");
 		sleep(1);
-		cpu_list = NULL;
+		top.cpu_list = NULL;
 	}
 
-	if (target_pid != -1)
-		target_tid = target_pid;
+	if (top.target_pid != -1)
+		top.target_tid = top.target_pid;
 
-	if (perf_evlist__create_maps(evsel_list, target_pid,
-				     target_tid, cpu_list) < 0)
+	if (perf_evlist__create_maps(top.evlist, top.target_pid,
+				     top.target_tid, top.cpu_list) < 0)
 		usage_with_options(top_usage, options);
 
-	if (!evsel_list->nr_entries &&
-	    perf_evlist__add_default(evsel_list) < 0) {
+	if (!top.evlist->nr_entries &&
+	    perf_evlist__add_default(top.evlist) < 0) {
 		pr_err("Not enough memory for event selector list\n");
 		return -ENOMEM;
 	}
 
-	if (delay_secs < 1)
-		delay_secs = 1;
+	if (top.delay_secs < 1)
+		top.delay_secs = 1;
 
 	/*
 	 * User specified count overrides default frequency.
 	 */
 	if (default_interval)
-		freq = 0;
-	else if (freq) {
-		default_interval = freq;
+		top.freq = 0;
+	else if (top.freq) {
+		default_interval = top.freq;
 	} else {
 		fprintf(stderr, "frequency and count are zero, aborting\n");
 		exit(EXIT_FAILURE);
 	}
 
-	list_for_each_entry(pos, &evsel_list->entries, node) {
-		if (perf_evsel__alloc_fd(pos, evsel_list->cpus->nr,
-					 evsel_list->threads->nr) < 0)
+	list_for_each_entry(pos, &top.evlist->entries, node) {
+		if (perf_evsel__alloc_fd(pos, top.evlist->cpus->nr,
+					 top.evlist->threads->nr) < 0)
 			goto out_free_fd;
 		/*
 		 * Fill in the ones not specifically initialized via -c:
@@ -1354,28 +1146,28 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		pos->attr.sample_period = default_interval;
 	}
 
-	if (perf_evlist__alloc_pollfd(evsel_list) < 0 ||
-	    perf_evlist__alloc_mmap(evsel_list) < 0)
+	if (perf_evlist__alloc_pollfd(top.evlist) < 0 ||
+	    perf_evlist__alloc_mmap(top.evlist) < 0)
 		goto out_free_fd;
 
-	sym_evsel = list_entry(evsel_list->entries.next, struct perf_evsel, node);
+	top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
 
 	symbol_conf.priv_size = (sizeof(struct sym_entry) +
-				 (evsel_list->nr_entries + 1) * sizeof(unsigned long));
+				 (top.evlist->nr_entries + 1) * sizeof(unsigned long));
 
 	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
 	if (symbol__init() < 0)
 		return -1;
 
 	get_term_dimensions(&winsize);
-	if (print_entries == 0) {
+	if (top.print_entries == 0) {
 		update_print_entries(&winsize);
 		signal(SIGWINCH, sig_winch_handler);
 	}
 
 	status = __cmd_top();
 out_free_fd:
-	perf_evlist__delete(evsel_list);
+	perf_evlist__delete(top.evlist);
 
 	return status;
 }
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
new file mode 100644
index 0000000..c06cc53
--- /dev/null
+++ b/tools/perf/util/top.c
@@ -0,0 +1,212 @@
+/*
+ * Copyright (C) 2011, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Refactored from builtin-top.c, see that files for further copyright notes.
+ *
+ * Released under the GPL v2. (and only v2, not any later version)
+ */
+
+#include "cpumap.h"
+#include "event.h"
+#include "evlist.h"
+#include "evsel.h"
+#include "parse-events.h"
+#include "symbol.h"
+#include "top.h"
+#include <inttypes.h>
+
+/*
+ * Ordering weight: count-1 * count-2 * ... / count-n
+ */
+static double sym_weight(const struct sym_entry *sym, struct perf_top *top)
+{
+	double weight = sym->snap_count;
+	int counter;
+
+	if (!top->display_weighted)
+		return weight;
+
+	for (counter = 1; counter < top->evlist->nr_entries - 1; counter++)
+		weight *= sym->count[counter];
+
+	weight /= (sym->count[counter] + 1);
+
+	return weight;
+}
+
+static void perf_top__remove_active_sym(struct perf_top *top, struct sym_entry *syme)
+{
+	pthread_mutex_lock(&top->active_symbols_lock);
+	list_del_init(&syme->node);
+	pthread_mutex_unlock(&top->active_symbols_lock);
+}
+
+static void rb_insert_active_sym(struct rb_root *tree, struct sym_entry *se)
+{
+	struct rb_node **p = &tree->rb_node;
+	struct rb_node *parent = NULL;
+	struct sym_entry *iter;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct sym_entry, rb_node);
+
+		if (se->weight > iter->weight)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&se->rb_node, parent, p);
+	rb_insert_color(&se->rb_node, tree);
+}
+
+size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
+{
+	struct perf_evsel *counter;
+	float samples_per_sec = top->samples / top->delay_secs;
+	float ksamples_per_sec = top->kernel_samples / top->delay_secs;
+	float esamples_percent = (100.0 * top->exact_samples) / top->samples;
+	size_t ret = 0;
+
+	if (!perf_guest) {
+		ret = snprintf(bf, size,
+			       "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%%"
+			       "  exact: %4.1f%% [", samples_per_sec,
+			       100.0 - (100.0 * ((samples_per_sec - ksamples_per_sec) /
+					samples_per_sec)),
+				esamples_percent);
+	} else {
+		float us_samples_per_sec = top->us_samples / top->delay_secs;
+		float guest_kernel_samples_per_sec = top->guest_kernel_samples / top->delay_secs;
+		float guest_us_samples_per_sec = top->guest_us_samples / top->delay_secs;
+
+		ret = snprintf(bf, size,
+			       "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%% us:%4.1f%%"
+			       " guest kernel:%4.1f%% guest us:%4.1f%%"
+			       " exact: %4.1f%% [", samples_per_sec,
+			       100.0 - (100.0 * ((samples_per_sec - ksamples_per_sec) /
+						 samples_per_sec)),
+			       100.0 - (100.0 * ((samples_per_sec - us_samples_per_sec) /
+						 samples_per_sec)),
+			       100.0 - (100.0 * ((samples_per_sec -
+						  guest_kernel_samples_per_sec) /
+						 samples_per_sec)),
+			       100.0 - (100.0 * ((samples_per_sec -
+						  guest_us_samples_per_sec) /
+						 samples_per_sec)),
+			       esamples_percent);
+	}
+
+	if (top->evlist->nr_entries == 1 || !top->display_weighted) {
+		struct perf_evsel *first;
+		first = list_entry(top->evlist->entries.next, struct perf_evsel, node);
+		ret += snprintf(bf + ret, size - ret, "%" PRIu64 "%s ",
+				(uint64_t)first->attr.sample_period,
+				top->freq ? "Hz" : "");
+	}
+
+	if (!top->display_weighted) {
+		ret += snprintf(bf + ret, size - ret, "%s",
+				event_name(top->sym_evsel));
+	} else list_for_each_entry(counter, &top->evlist->entries, node) {
+		ret += snprintf(bf + ret, size - ret, "%s%s",
+				counter->idx ? "/" : "", event_name(counter));
+	}
+
+	ret += snprintf(bf + ret, size - ret, "], ");
+
+	if (top->target_pid != -1)
+		ret += snprintf(bf + ret, size - ret, " (target_pid: %d",
+				top->target_pid);
+	else if (top->target_tid != -1)
+		ret += snprintf(bf + ret, size - ret, " (target_tid: %d",
+				top->target_tid);
+	else
+		ret += snprintf(bf + ret, size - ret, " (all");
+
+	if (top->cpu_list)
+		ret += snprintf(bf + ret, size - ret, ", CPU%s: %s)",
+				top->evlist->cpus->nr > 1 ? "s" : "", top->cpu_list);
+	else {
+		if (top->target_tid != -1)
+			ret += snprintf(bf + ret, size - ret, ")");
+		else
+			ret += snprintf(bf + ret, size - ret, ", %d CPU%s)",
+					top->evlist->cpus->nr,
+					top->evlist->cpus->nr > 1 ? "s" : "");
+	}
+
+	return ret;
+}
+
+void perf_top__reset_sample_counters(struct perf_top *top)
+{
+	top->samples = top->us_samples = top->kernel_samples =
+	top->exact_samples = top->guest_kernel_samples =
+	top->guest_us_samples = 0;
+}
+
+float perf_top__decay_samples(struct perf_top *top, struct rb_root *root)
+{
+	struct sym_entry *syme, *n;
+	float sum_ksamples = 0.0;
+	int snap = !top->display_weighted ? top->sym_counter : 0, j;
+
+	/* Sort the active symbols */
+	pthread_mutex_lock(&top->active_symbols_lock);
+	syme = list_entry(top->active_symbols.next, struct sym_entry, node);
+	pthread_mutex_unlock(&top->active_symbols_lock);
+
+	list_for_each_entry_safe_from(syme, n, &top->active_symbols, node) {
+		syme->snap_count = syme->count[snap];
+		if (syme->snap_count != 0) {
+
+			if ((top->hide_user_symbols &&
+			     syme->origin == PERF_RECORD_MISC_USER) ||
+			    (top->hide_kernel_symbols &&
+			     syme->origin == PERF_RECORD_MISC_KERNEL)) {
+				perf_top__remove_active_sym(top, syme);
+				continue;
+			}
+			syme->weight = sym_weight(syme, top);
+			rb_insert_active_sym(root, syme);
+			sum_ksamples += syme->snap_count;
+
+			for (j = 0; j < top->evlist->nr_entries; j++)
+				syme->count[j] = top->zero ? 0 : syme->count[j] * 7 / 8;
+		} else
+			perf_top__remove_active_sym(top, syme);
+	}
+
+	return sum_ksamples;
+}
+
+/*
+ * Find the longest symbol name that will be displayed
+ */
+void perf_top__find_widths(struct perf_top *top, struct rb_root *root,
+			   int *dso_width, int *dso_short_width, int *sym_width)
+{
+	struct rb_node *nd;
+	int printed = 0;
+
+	*sym_width = *dso_width = *dso_short_width = 0;
+
+	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
+		struct sym_entry *syme = rb_entry(nd, struct sym_entry, rb_node);
+
+		if (++printed > top->print_entries ||
+		    (int)syme->snap_count < top->count_filter)
+			continue;
+
+		if (syme->map->dso->long_name_len > *dso_width)
+			*dso_width = syme->map->dso->long_name_len;
+
+		if (syme->map->dso->short_name_len > *dso_short_width)
+			*dso_short_width = syme->map->dso->short_name_len;
+
+		if (syme->name_len > *sym_width)
+			*sym_width = syme->name_len;
+	}
+}
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
new file mode 100644
index 0000000..0467b26
--- /dev/null
+++ b/tools/perf/util/top.h
@@ -0,0 +1,67 @@
+#ifndef __PERF_TOP_H
+#define __PERF_TOP_H 1
+
+#include "types.h"
+#include "../perf.h"
+#include <stddef.h>
+#include <pthread.h>
+#include <linux/list.h>
+#include <linux/rbtree.h>
+
+struct perf_evlist;
+struct perf_evsel;
+
+struct source_line {
+	u64			eip;
+	unsigned long		count[MAX_COUNTERS]; /* FIXME */
+	char			*line;
+	struct source_line	*next;
+};
+
+struct sym_entry_source {
+	struct source_line	*source;
+	struct source_line	*lines;
+	struct source_line	**lines_tail;
+	pthread_mutex_t		lock;
+};
+
+struct sym_entry {
+	struct rb_node		rb_node;
+	struct list_head	node;
+	unsigned long		snap_count;
+	double			weight;
+	int			skip;
+	u16			name_len;
+	u8			origin;
+	struct map		*map;
+	struct sym_entry_source	*src;
+	unsigned long		count[0];
+};
+
+struct perf_top {
+	struct perf_evlist *evlist;
+	/*
+	 * Symbols will be added here in perf_event__process_sample and will
+	 * get out after decayed.
+	 */
+	struct list_head   active_symbols;
+	pthread_mutex_t	   active_symbols_lock;
+	u64		   samples;
+	u64		   kernel_samples, us_samples;
+	u64		   exact_samples;
+	u64		   guest_us_samples, guest_kernel_samples;
+	int		   print_entries, count_filter, delay_secs;
+	int		   display_weighted, freq;
+	int		   sym_counter, target_pid, target_tid;
+	bool		   hide_kernel_symbols, hide_user_symbols, zero;
+	const char	   *cpu_list;
+	struct perf_evsel  *sym_evsel;
+};
+
+size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size);
+void perf_top__reset_sample_counters(struct perf_top *top);
+float perf_top__decay_samples(struct perf_top *top, struct rb_root *root);
+void perf_top__find_widths(struct perf_top *top, struct rb_root *root,
+			   int *dso_width, int *dso_short_width, int *sym_width);
+
+#endif /* __PERF_TOP_H */
-- 
1.6.2.5

