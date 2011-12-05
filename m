Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab1LENBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:01:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57048 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab1LENBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:01:09 -0500
Date: Mon, 5 Dec 2011 05:00:09 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-i33q40wwvk2zna8fd36ex6sm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Stop using globals for tool state
Git-Commit-ID: 1758af10cf13d156014035b29ff50eab3773d849
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:00:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1758af10cf13d156014035b29ff50eab3773d849
Gitweb:     http://git.kernel.org/tip/1758af10cf13d156014035b29ff50eab3773d849
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 28 Nov 2011 09:37:05 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:39:44 -0200

perf top: Stop using globals for tool state

Use its 'perf_tool' base class instead.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-i33q40wwvk2zna8fd36ex6sm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |  464 +++++++++++++++++++++++-----------------------
 tools/perf/util/top.h    |   16 ++
 2 files changed, 245 insertions(+), 235 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 42a7d96..50ff362 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -64,44 +64,6 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-static struct perf_top top = {
-	.count_filter		= 5,
-	.delay_secs		= 2,
-	.target_pid		= -1,
-	.target_tid		= -1,
-	.freq			= 1000, /* 1 KHz */
-};
-
-static bool			system_wide			=  false;
-
-static bool			use_tui, use_stdio;
-
-static bool			sort_has_symbols;
-
-static bool			dont_use_callchains;
-static char			callchain_default_opt[]		= "fractal,0.5,callee";
-
-
-static int			default_interval		=      0;
-
-static bool			kptr_restrict_warned;
-static bool			vmlinux_warned;
-static bool			inherit				=  false;
-static int			realtime_prio			=      0;
-static bool			group				=  false;
-static bool			sample_id_all_avail		=   true;
-static unsigned int		mmap_pages			=    128;
-
-static bool			dump_symtab                     =  false;
-
-static struct winsize		winsize;
-
-static const char		*sym_filter			=   NULL;
-static int			sym_pcnt_filter			=      5;
-
-/*
- * Source functions
- */
 
 void get_term_dimensions(struct winsize *ws)
 {
@@ -125,21 +87,23 @@ void get_term_dimensions(struct winsize *ws)
 	ws->ws_col = 80;
 }
 
-static void update_print_entries(struct winsize *ws)
+static void perf_top__update_print_entries(struct perf_top *top)
 {
-	top.print_entries = ws->ws_row;
+	top->print_entries = top->winsize.ws_row;
 
-	if (top.print_entries > 9)
-		top.print_entries -= 9;
+	if (top->print_entries > 9)
+		top->print_entries -= 9;
 }
 
-static void sig_winch_handler(int sig __used)
+static void perf_top__sig_winch(int sig __used, siginfo_t *info __used, void *arg)
 {
-	get_term_dimensions(&winsize);
-	update_print_entries(&winsize);
+	struct perf_top *top = arg;
+
+	get_term_dimensions(&top->winsize);
+	perf_top__update_print_entries(top);
 }
 
-static int parse_source(struct hist_entry *he)
+static int perf_top__parse_source(struct perf_top *top, struct hist_entry *he)
 {
 	struct symbol *sym;
 	struct annotation *notes;
@@ -181,7 +145,7 @@ static int parse_source(struct hist_entry *he)
 	err = symbol__annotate(sym, map, 0);
 	if (err == 0) {
 out_assign:
-		top.sym_filter_entry = he;
+		top->sym_filter_entry = he;
 	}
 
 	pthread_mutex_unlock(&notes->lock);
@@ -194,14 +158,16 @@ static void __zero_source_counters(struct hist_entry *he)
 	symbol__annotate_zero_histograms(sym);
 }
 
-static void record_precise_ip(struct hist_entry *he, int counter, u64 ip)
+static void perf_top__record_precise_ip(struct perf_top *top,
+					struct hist_entry *he,
+					int counter, u64 ip)
 {
 	struct annotation *notes;
 	struct symbol *sym;
 
 	if (he == NULL || he->ms.sym == NULL ||
-	    ((top.sym_filter_entry == NULL ||
-	      top.sym_filter_entry->ms.sym != he->ms.sym) && use_browser != 1))
+	    ((top->sym_filter_entry == NULL ||
+	      top->sym_filter_entry->ms.sym != he->ms.sym) && use_browser != 1))
 		return;
 
 	sym = he->ms.sym;
@@ -224,8 +190,9 @@ static void record_precise_ip(struct hist_entry *he, int counter, u64 ip)
 	pthread_mutex_unlock(&notes->lock);
 }
 
-static void show_details(struct hist_entry *he)
+static void perf_top__show_details(struct perf_top *top)
 {
+	struct hist_entry *he = top->sym_filter_entry;
 	struct annotation *notes;
 	struct symbol *symbol;
 	int more;
@@ -241,15 +208,15 @@ static void show_details(struct hist_entry *he)
 	if (notes->src == NULL)
 		goto out_unlock;
 
-	printf("Showing %s for %s\n", event_name(top.sym_evsel), symbol->name);
-	printf("  Events  Pcnt (>=%d%%)\n", sym_pcnt_filter);
+	printf("Showing %s for %s\n", event_name(top->sym_evsel), symbol->name);
+	printf("  Events  Pcnt (>=%d%%)\n", top->sym_pcnt_filter);
 
-	more = symbol__annotate_printf(symbol, he->ms.map, top.sym_evsel->idx,
-				       0, sym_pcnt_filter, top.print_entries, 4);
-	if (top.zero)
-		symbol__annotate_zero_histogram(symbol, top.sym_evsel->idx);
+	more = symbol__annotate_printf(symbol, he->ms.map, top->sym_evsel->idx,
+				       0, top->sym_pcnt_filter, top->print_entries, 4);
+	if (top->zero)
+		symbol__annotate_zero_histogram(symbol, top->sym_evsel->idx);
 	else
-		symbol__annotate_decay_histogram(symbol, top.sym_evsel->idx);
+		symbol__annotate_decay_histogram(symbol, top->sym_evsel->idx);
 	if (more != 0)
 		printf("%d lines not displayed, maybe increase display entries [e]\n", more);
 out_unlock:
@@ -273,45 +240,46 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	return he;
 }
 
-static void print_sym_table(void)
+static void perf_top__print_sym_table(struct perf_top *top)
 {
 	char bf[160];
 	int printed = 0;
-	const int win_width = winsize.ws_col - 1;
+	const int win_width = top->winsize.ws_col - 1;
 
 	puts(CONSOLE_CLEAR);
 
-	perf_top__header_snprintf(&top, bf, sizeof(bf));
+	perf_top__header_snprintf(top, bf, sizeof(bf));
 	printf("%s\n", bf);
 
-	perf_top__reset_sample_counters(&top);
+	perf_top__reset_sample_counters(top);
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
 
-	if (top.sym_evsel->hists.stats.nr_lost_warned !=
-	    top.sym_evsel->hists.stats.nr_events[PERF_RECORD_LOST]) {
-		top.sym_evsel->hists.stats.nr_lost_warned =
-			top.sym_evsel->hists.stats.nr_events[PERF_RECORD_LOST];
+	if (top->sym_evsel->hists.stats.nr_lost_warned !=
+	    top->sym_evsel->hists.stats.nr_events[PERF_RECORD_LOST]) {
+		top->sym_evsel->hists.stats.nr_lost_warned =
+			top->sym_evsel->hists.stats.nr_events[PERF_RECORD_LOST];
 		color_fprintf(stdout, PERF_COLOR_RED,
 			      "WARNING: LOST %d chunks, Check IO/CPU overload",
-			      top.sym_evsel->hists.stats.nr_lost_warned);
+			      top->sym_evsel->hists.stats.nr_lost_warned);
 		++printed;
 	}
 
-	if (top.sym_filter_entry) {
-		show_details(top.sym_filter_entry);
+	if (top->sym_filter_entry) {
+		perf_top__show_details(top);
 		return;
 	}
 
-	hists__collapse_resort_threaded(&top.sym_evsel->hists);
-	hists__output_resort_threaded(&top.sym_evsel->hists);
-	hists__decay_entries_threaded(&top.sym_evsel->hists,
-				      top.hide_user_symbols,
-				      top.hide_kernel_symbols);
-	hists__output_recalc_col_len(&top.sym_evsel->hists, winsize.ws_row - 3);
+	hists__collapse_resort_threaded(&top->sym_evsel->hists);
+	hists__output_resort_threaded(&top->sym_evsel->hists);
+	hists__decay_entries_threaded(&top->sym_evsel->hists,
+				      top->hide_user_symbols,
+				      top->hide_kernel_symbols);
+	hists__output_recalc_col_len(&top->sym_evsel->hists,
+				     top->winsize.ws_row - 3);
 	putchar('\n');
-	hists__fprintf(&top.sym_evsel->hists, NULL, false, false,
-		       winsize.ws_row - 4 - printed, win_width, stdout);
+	hists__fprintf(&top->sym_evsel->hists, NULL, false, false,
+		       top->winsize.ws_row - 4 - printed, win_width, stdout);
 }
 
 static void prompt_integer(int *target, const char *msg)
@@ -349,17 +317,17 @@ static void prompt_percent(int *target, const char *msg)
 		*target = tmp;
 }
 
-static void prompt_symbol(struct hist_entry **target, const char *msg)
+static void perf_top__prompt_symbol(struct perf_top *top, const char *msg)
 {
 	char *buf = malloc(0), *p;
-	struct hist_entry *syme = *target, *n, *found = NULL;
+	struct hist_entry *syme = top->sym_filter_entry, *n, *found = NULL;
 	struct rb_node *next;
 	size_t dummy = 0;
 
 	/* zero counters of active symbol */
 	if (syme) {
 		__zero_source_counters(syme);
-		*target = NULL;
+		top->sym_filter_entry = NULL;
 	}
 
 	fprintf(stdout, "\n%s: ", msg);
@@ -370,7 +338,7 @@ static void prompt_symbol(struct hist_entry **target, const char *msg)
 	if (p)
 		*p = 0;
 
-	next = rb_first(&top.sym_evsel->hists.entries);
+	next = rb_first(&top->sym_evsel->hists.entries);
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		if (n->ms.sym && !strcmp(buf, n->ms.sym->name)) {
@@ -385,45 +353,45 @@ static void prompt_symbol(struct hist_entry **target, const char *msg)
 		sleep(1);
 		return;
 	} else
-		parse_source(found);
+		perf_top__parse_source(top, found);
 
 out_free:
 	free(buf);
 }
 
-static void print_mapped_keys(void)
+static void perf_top__print_mapped_keys(struct perf_top *top)
 {
 	char *name = NULL;
 
-	if (top.sym_filter_entry) {
-		struct symbol *sym = top.sym_filter_entry->ms.sym;
+	if (top->sym_filter_entry) {
+		struct symbol *sym = top->sym_filter_entry->ms.sym;
 		name = sym->name;
 	}
 
 	fprintf(stdout, "\nMapped keys:\n");
-	fprintf(stdout, "\t[d]     display refresh delay.             \t(%d)\n", top.delay_secs);
-	fprintf(stdout, "\t[e]     display entries (lines).           \t(%d)\n", top.print_entries);
+	fprintf(stdout, "\t[d]     display refresh delay.             \t(%d)\n", top->delay_secs);
+	fprintf(stdout, "\t[e]     display entries (lines).           \t(%d)\n", top->print_entries);
 
-	if (top.evlist->nr_entries > 1)
-		fprintf(stdout, "\t[E]     active event counter.              \t(%s)\n", event_name(top.sym_evsel));
+	if (top->evlist->nr_entries > 1)
+		fprintf(stdout, "\t[E]     active event counter.              \t(%s)\n", event_name(top->sym_evsel));
 
-	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", top.count_filter);
+	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", top->count_filter);
 
-	fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", sym_pcnt_filter);
+	fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", top->sym_pcnt_filter);
 	fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
 	fprintf(stdout, "\t[S]     stop annotation.\n");
 
 	fprintf(stdout,
 		"\t[K]     hide kernel_symbols symbols.     \t(%s)\n",
-		top.hide_kernel_symbols ? "yes" : "no");
+		top->hide_kernel_symbols ? "yes" : "no");
 	fprintf(stdout,
 		"\t[U]     hide user symbols.               \t(%s)\n",
-		top.hide_user_symbols ? "yes" : "no");
-	fprintf(stdout, "\t[z]     toggle sample zeroing.             \t(%d)\n", top.zero ? 1 : 0);
+		top->hide_user_symbols ? "yes" : "no");
+	fprintf(stdout, "\t[z]     toggle sample zeroing.             \t(%d)\n", top->zero ? 1 : 0);
 	fprintf(stdout, "\t[qQ]    quit.\n");
 }
 
-static int key_mapped(int c)
+static int perf_top__key_mapped(struct perf_top *top, int c)
 {
 	switch (c) {
 		case 'd':
@@ -439,7 +407,7 @@ static int key_mapped(int c)
 		case 'S':
 			return 1;
 		case 'E':
-			return top.evlist->nr_entries > 1 ? 1 : 0;
+			return top->evlist->nr_entries > 1 ? 1 : 0;
 		default:
 			break;
 	}
@@ -447,13 +415,13 @@ static int key_mapped(int c)
 	return 0;
 }
 
-static void handle_keypress(int c)
+static void perf_top__handle_keypress(struct perf_top *top, int c)
 {
-	if (!key_mapped(c)) {
+	if (!perf_top__key_mapped(top, c)) {
 		struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
 		struct termios tc, save;
 
-		print_mapped_keys();
+		perf_top__print_mapped_keys(top);
 		fprintf(stdout, "\nEnter selection, or unmapped key to continue: ");
 		fflush(stdout);
 
@@ -468,81 +436,86 @@ static void handle_keypress(int c)
 		c = getc(stdin);
 
 		tcsetattr(0, TCSAFLUSH, &save);
-		if (!key_mapped(c))
+		if (!perf_top__key_mapped(top, c))
 			return;
 	}
 
 	switch (c) {
 		case 'd':
-			prompt_integer(&top.delay_secs, "Enter display delay");
-			if (top.delay_secs < 1)
-				top.delay_secs = 1;
+			prompt_integer(&top->delay_secs, "Enter display delay");
+			if (top->delay_secs < 1)
+				top->delay_secs = 1;
 			break;
 		case 'e':
-			prompt_integer(&top.print_entries, "Enter display entries (lines)");
-			if (top.print_entries == 0) {
-				sig_winch_handler(SIGWINCH);
-				signal(SIGWINCH, sig_winch_handler);
+			prompt_integer(&top->print_entries, "Enter display entries (lines)");
+			if (top->print_entries == 0) {
+				struct sigaction act = {
+					.sa_sigaction = perf_top__sig_winch,
+					.sa_flags     = SA_SIGINFO,
+				};
+				perf_top__sig_winch(SIGWINCH, NULL, top);
+				sigaction(SIGWINCH, &act, NULL);
 			} else
 				signal(SIGWINCH, SIG_DFL);
 			break;
 		case 'E':
-			if (top.evlist->nr_entries > 1) {
+			if (top->evlist->nr_entries > 1) {
 				/* Select 0 as the default event: */
 				int counter = 0;
 
 				fprintf(stderr, "\nAvailable events:");
 
-				list_for_each_entry(top.sym_evsel, &top.evlist->entries, node)
-					fprintf(stderr, "\n\t%d %s", top.sym_evsel->idx, event_name(top.sym_evsel));
+				list_for_each_entry(top->sym_evsel, &top->evlist->entries, node)
+					fprintf(stderr, "\n\t%d %s", top->sym_evsel->idx, event_name(top->sym_evsel));
 
 				prompt_integer(&counter, "Enter details event counter");
 
-				if (counter >= top.evlist->nr_entries) {
-					top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
-					fprintf(stderr, "Sorry, no such event, using %s.\n", event_name(top.sym_evsel));
+				if (counter >= top->evlist->nr_entries) {
+					top->sym_evsel = list_entry(top->evlist->entries.next, struct perf_evsel, node);
+					fprintf(stderr, "Sorry, no such event, using %s.\n", event_name(top->sym_evsel));
 					sleep(1);
 					break;
 				}
-				list_for_each_entry(top.sym_evsel, &top.evlist->entries, node)
-					if (top.sym_evsel->idx == counter)
+				list_for_each_entry(top->sym_evsel, &top->evlist->entries, node)
+					if (top->sym_evsel->idx == counter)
 						break;
 			} else
-				top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
+				top->sym_evsel = list_entry(top->evlist->entries.next, struct perf_evsel, node);
 			break;
 		case 'f':
-			prompt_integer(&top.count_filter, "Enter display event count filter");
+			prompt_integer(&top->count_filter, "Enter display event count filter");
 			break;
 		case 'F':
-			prompt_percent(&sym_pcnt_filter, "Enter details display event filter (percent)");
+			prompt_percent(&top->sym_pcnt_filter,
+				       "Enter details display event filter (percent)");
 			break;
 		case 'K':
-			top.hide_kernel_symbols = !top.hide_kernel_symbols;
+			top->hide_kernel_symbols = !top->hide_kernel_symbols;
 			break;
 		case 'q':
 		case 'Q':
 			printf("exiting.\n");
-			if (dump_symtab)
-				perf_session__fprintf_dsos(top.session, stderr);
+			if (top->dump_symtab)
+				perf_session__fprintf_dsos(top->session, stderr);
 			exit(0);
 		case 's':
-			prompt_symbol(&top.sym_filter_entry, "Enter details symbol");
+			perf_top__prompt_symbol(top, "Enter details symbol");
 			break;
 		case 'S':
-			if (!top.sym_filter_entry)
+			if (!top->sym_filter_entry)
 				break;
 			else {
-				struct hist_entry *syme = top.sym_filter_entry;
+				struct hist_entry *syme = top->sym_filter_entry;
 
-				top.sym_filter_entry = NULL;
+				top->sym_filter_entry = NULL;
 				__zero_source_counters(syme);
 			}
 			break;
 		case 'U':
-			top.hide_user_symbols = !top.hide_user_symbols;
+			top->hide_user_symbols = !top->hide_user_symbols;
 			break;
 		case 'z':
-			top.zero = !top.zero;
+			top->zero = !top->zero;
 			break;
 		default:
 			break;
@@ -560,28 +533,30 @@ static void perf_top__sort_new_samples(void *arg)
 	hists__collapse_resort_threaded(&t->sym_evsel->hists);
 	hists__output_resort_threaded(&t->sym_evsel->hists);
 	hists__decay_entries_threaded(&t->sym_evsel->hists,
-				      top.hide_user_symbols,
-				      top.hide_kernel_symbols);
+				      t->hide_user_symbols,
+				      t->hide_kernel_symbols);
 }
 
-static void *display_thread_tui(void *arg __used)
+static void *display_thread_tui(void *arg)
 {
+	struct perf_top *top = arg;
 	const char *help = "For a higher level overview, try: perf top --sort comm,dso";
 
-	perf_top__sort_new_samples(&top);
-	perf_evlist__tui_browse_hists(top.evlist, help,
+	perf_top__sort_new_samples(top);
+	perf_evlist__tui_browse_hists(top->evlist, help,
 				      perf_top__sort_new_samples,
-				      &top, top.delay_secs);
+				      top, top->delay_secs);
 
 	exit_browser(0);
 	exit(0);
 	return NULL;
 }
 
-static void *display_thread(void *arg __used)
+static void *display_thread(void *arg)
 {
 	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
 	struct termios tc, save;
+	struct perf_top *top = arg;
 	int delay_msecs, c;
 
 	tcgetattr(0, &save);
@@ -592,13 +567,13 @@ static void *display_thread(void *arg __used)
 
 	pthread__unblock_sigwinch();
 repeat:
-	delay_msecs = top.delay_secs * 1000;
+	delay_msecs = top->delay_secs * 1000;
 	tcsetattr(0, TCSANOW, &tc);
 	/* trash return*/
 	getc(stdin);
 
 	while (1) {
-		print_sym_table();
+		perf_top__print_sym_table(top);
 		/*
 		 * Either timeout expired or we got an EINTR due to SIGWINCH,
 		 * refresh screen in both cases.
@@ -618,7 +593,7 @@ process_hotkey:
 	c = getc(stdin);
 	tcsetattr(0, TCSAFLUSH, &save);
 
-	handle_keypress(c);
+	perf_top__handle_keypress(top, c);
 	goto repeat;
 
 	return NULL;
@@ -670,11 +645,13 @@ static int symbol_filter(struct map *map __used, struct symbol *sym)
 	return 0;
 }
 
-static void perf_event__process_sample(const union perf_event *event,
+static void perf_event__process_sample(struct perf_tool *tool,
+				       const union perf_event *event,
 				       struct perf_evsel *evsel,
 				       struct perf_sample *sample,
 				       struct machine *machine)
 {
+	struct perf_top *top = container_of(tool, struct perf_top, tool);
 	struct symbol *parent = NULL;
 	u64 ip = event->ip.ip;
 	struct addr_location al;
@@ -687,14 +664,14 @@ static void perf_event__process_sample(const union perf_event *event,
 	}
 
 	if (event->header.misc & PERF_RECORD_MISC_EXACT_IP)
-		top.exact_samples++;
+		top->exact_samples++;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
 					  symbol_filter) < 0 ||
 	    al.filtered)
 		return;
 
-	if (!kptr_restrict_warned &&
+	if (!top->kptr_restrict_warned &&
 	    symbol_conf.kptr_restrict &&
 	    al.cpumode == PERF_RECORD_MISC_KERNEL) {
 		ui__warning(
@@ -705,7 +682,7 @@ static void perf_event__process_sample(const union perf_event *event,
 			  " modules" : "");
 		if (use_browser <= 0)
 			sleep(5);
-		kptr_restrict_warned = true;
+		top->kptr_restrict_warned = true;
 	}
 
 	if (al.sym == NULL) {
@@ -721,7 +698,7 @@ static void perf_event__process_sample(const union perf_event *event,
 		 * --hide-kernel-symbols, even if the user specifies an
 		 * invalid --vmlinux ;-)
 		 */
-		if (!kptr_restrict_warned && !vmlinux_warned &&
+		if (!top->kptr_restrict_warned && !top->vmlinux_warned &&
 		    al.map == machine->vmlinux_maps[MAP__FUNCTION] &&
 		    RB_EMPTY_ROOT(&al.map->dso->symbols[MAP__FUNCTION])) {
 			if (symbol_conf.vmlinux_name) {
@@ -734,7 +711,7 @@ static void perf_event__process_sample(const union perf_event *event,
 
 			if (use_browser <= 0)
 				sleep(5);
-			vmlinux_warned = true;
+			top->vmlinux_warned = true;
 		}
 	}
 
@@ -762,56 +739,57 @@ static void perf_event__process_sample(const union perf_event *event,
 				return;
 		}
 
-		if (sort_has_symbols)
-			record_precise_ip(he, evsel->idx, ip);
+		if (top->sort_has_symbols)
+			perf_top__record_precise_ip(top, he, evsel->idx, ip);
 	}
 
 	return;
 }
 
-static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
+static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 {
 	struct perf_sample sample;
 	struct perf_evsel *evsel;
+	struct perf_session *session = top->session;
 	union perf_event *event;
 	struct machine *machine;
 	u8 origin;
 	int ret;
 
-	while ((event = perf_evlist__mmap_read(top.evlist, idx)) != NULL) {
-		ret = perf_session__parse_sample(self, event, &sample);
+	while ((event = perf_evlist__mmap_read(top->evlist, idx)) != NULL) {
+		ret = perf_session__parse_sample(session, event, &sample);
 		if (ret) {
 			pr_err("Can't parse sample, err = %d\n", ret);
 			continue;
 		}
 
-		evsel = perf_evlist__id2evsel(self->evlist, sample.id);
+		evsel = perf_evlist__id2evsel(session->evlist, sample.id);
 		assert(evsel != NULL);
 
 		origin = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
 		if (event->header.type == PERF_RECORD_SAMPLE)
-			++top.samples;
+			++top->samples;
 
 		switch (origin) {
 		case PERF_RECORD_MISC_USER:
-			++top.us_samples;
-			if (top.hide_user_symbols)
+			++top->us_samples;
+			if (top->hide_user_symbols)
 				continue;
-			machine = perf_session__find_host_machine(self);
+			machine = perf_session__find_host_machine(session);
 			break;
 		case PERF_RECORD_MISC_KERNEL:
-			++top.kernel_samples;
-			if (top.hide_kernel_symbols)
+			++top->kernel_samples;
+			if (top->hide_kernel_symbols)
 				continue;
-			machine = perf_session__find_host_machine(self);
+			machine = perf_session__find_host_machine(session);
 			break;
 		case PERF_RECORD_MISC_GUEST_KERNEL:
-			++top.guest_kernel_samples;
-			machine = perf_session__find_machine(self, event->ip.pid);
+			++top->guest_kernel_samples;
+			machine = perf_session__find_machine(session, event->ip.pid);
 			break;
 		case PERF_RECORD_MISC_GUEST_USER:
-			++top.guest_us_samples;
+			++top->guest_us_samples;
 			/*
 			 * TODO: we don't process guest user from host side
 			 * except simple counting.
@@ -822,27 +800,29 @@ static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
 		}
 
 
-		if (event->header.type == PERF_RECORD_SAMPLE)
-			perf_event__process_sample(event, evsel, &sample, machine);
-		else if (event->header.type < PERF_RECORD_MAX) {
+		if (event->header.type == PERF_RECORD_SAMPLE) {
+			perf_event__process_sample(&top->tool, event, evsel,
+						   &sample, machine);
+		} else if (event->header.type < PERF_RECORD_MAX) {
 			hists__inc_nr_events(&evsel->hists, event->header.type);
-			perf_event__process(&top.tool, event, &sample, machine);
+			perf_event__process(&top->tool, event, &sample, machine);
 		} else
-			++self->hists.stats.nr_unknown_events;
+			++session->hists.stats.nr_unknown_events;
 	}
 }
 
-static void perf_session__mmap_read(struct perf_session *self)
+static void perf_top__mmap_read(struct perf_top *top)
 {
 	int i;
 
-	for (i = 0; i < top.evlist->nr_mmaps; i++)
-		perf_session__mmap_read_idx(self, i);
+	for (i = 0; i < top->evlist->nr_mmaps; i++)
+		perf_top__mmap_read_idx(top, i);
 }
 
-static void start_counters(struct perf_evlist *evlist)
+static void perf_top__start_counters(struct perf_top *top)
 {
 	struct perf_evsel *counter, *first;
+	struct perf_evlist *evlist = top->evlist;
 
 	first = list_entry(evlist->entries.next, struct perf_evsel, node);
 
@@ -850,15 +830,15 @@ static void start_counters(struct perf_evlist *evlist)
 		struct perf_event_attr *attr = &counter->attr;
 		struct xyarray *group_fd = NULL;
 
-		if (group && counter != first)
+		if (top->group && counter != first)
 			group_fd = first->fd;
 
 		attr->sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
-		if (top.freq) {
+		if (top->freq) {
 			attr->sample_type |= PERF_SAMPLE_PERIOD;
 			attr->freq	  = 1;
-			attr->sample_freq = top.freq;
+			attr->sample_freq = top->freq;
 		}
 
 		if (evlist->nr_entries > 1) {
@@ -871,23 +851,23 @@ static void start_counters(struct perf_evlist *evlist)
 
 		attr->mmap = 1;
 		attr->comm = 1;
-		attr->inherit = inherit;
+		attr->inherit = top->inherit;
 retry_sample_id:
-		attr->sample_id_all = sample_id_all_avail ? 1 : 0;
+		attr->sample_id_all = top->sample_id_all_avail ? 1 : 0;
 try_again:
-		if (perf_evsel__open(counter, top.evlist->cpus,
-				     top.evlist->threads, group,
+		if (perf_evsel__open(counter, top->evlist->cpus,
+				     top->evlist->threads, top->group,
 				     group_fd) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
 				ui__error_paranoid();
 				goto out_err;
-			} else if (err == EINVAL && sample_id_all_avail) {
+			} else if (err == EINVAL && top->sample_id_all_avail) {
 				/*
 				 * Old kernel, no attr->sample_id_type_all field
 				 */
-				sample_id_all_avail = false;
+				top->sample_id_all_avail = false;
 				goto retry_sample_id;
 			}
 			/*
@@ -921,7 +901,7 @@ try_again:
 		}
 	}
 
-	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0) {
+	if (perf_evlist__mmap(evlist, top->mmap_pages, false) < 0) {
 		ui__warning("Failed to mmap with %d (%s)\n",
 			    errno, strerror(errno));
 		goto out_err;
@@ -934,14 +914,14 @@ out_err:
 	exit(0);
 }
 
-static int setup_sample_type(void)
+static int perf_top__setup_sample_type(struct perf_top *top)
 {
-	if (!sort_has_symbols) {
+	if (!top->sort_has_symbols) {
 		if (symbol_conf.use_callchain) {
 			ui__warning("Selected -g but \"sym\" not present in --sort/-s.");
 			return -EINVAL;
 		}
-	} else if (!dont_use_callchains && callchain_param.mode != CHAIN_NONE) {
+	} else if (!top->dont_use_callchains && callchain_param.mode != CHAIN_NONE) {
 		if (callchain_register_param(&callchain_param) < 0) {
 			ui__warning("Can't register callchain params.\n");
 			return -EINVAL;
@@ -951,7 +931,7 @@ static int setup_sample_type(void)
 	return 0;
 }
 
-static int __cmd_top(void)
+static int __cmd_top(struct perf_top *top)
 {
 	pthread_t thread;
 	int ret;
@@ -959,40 +939,40 @@ static int __cmd_top(void)
 	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
 	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
 	 */
-	top.session = perf_session__new(NULL, O_WRONLY, false, false, NULL);
-	if (top.session == NULL)
+	top->session = perf_session__new(NULL, O_WRONLY, false, false, NULL);
+	if (top->session == NULL)
 		return -ENOMEM;
 
-	ret = setup_sample_type();
+	ret = perf_top__setup_sample_type(top);
 	if (ret)
 		goto out_delete;
 
-	if (top.target_tid != -1)
-		perf_event__synthesize_thread_map(&top.tool, top.evlist->threads,
+	if (top->target_tid != -1)
+		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
 						  perf_event__process,
-						  &top.session->host_machine);
+						  &top->session->host_machine);
 	else
-		perf_event__synthesize_threads(&top.tool, perf_event__process,
-					       &top.session->host_machine);
-	start_counters(top.evlist);
-	top.session->evlist = top.evlist;
-	perf_session__update_sample_type(top.session);
+		perf_event__synthesize_threads(&top->tool, perf_event__process,
+					       &top->session->host_machine);
+	perf_top__start_counters(top);
+	top->session->evlist = top->evlist;
+	perf_session__update_sample_type(top->session);
 
 	/* Wait for a minimal set of events before starting the snapshot */
-	poll(top.evlist->pollfd, top.evlist->nr_fds, 100);
+	poll(top->evlist->pollfd, top->evlist->nr_fds, 100);
 
-	perf_session__mmap_read(top.session);
+	perf_top__mmap_read(top);
 
 	if (pthread_create(&thread, NULL, (use_browser > 0 ? display_thread_tui :
-							     display_thread), NULL)) {
+							    display_thread), top)) {
 		printf("Could not create display thread.\n");
 		exit(-1);
 	}
 
-	if (realtime_prio) {
+	if (top->realtime_prio) {
 		struct sched_param param;
 
-		param.sched_priority = realtime_prio;
+		param.sched_priority = top->realtime_prio;
 		if (sched_setscheduler(0, SCHED_FIFO, &param)) {
 			printf("Could not set realtime priority.\n");
 			exit(-1);
@@ -1000,25 +980,25 @@ static int __cmd_top(void)
 	}
 
 	while (1) {
-		u64 hits = top.samples;
+		u64 hits = top->samples;
 
-		perf_session__mmap_read(top.session);
+		perf_top__mmap_read(top);
 
-		if (hits == top.samples)
-			ret = poll(top.evlist->pollfd, top.evlist->nr_fds, 100);
+		if (hits == top->samples)
+			ret = poll(top->evlist->pollfd, top->evlist->nr_fds, 100);
 	}
 
 out_delete:
-	perf_session__delete(top.session);
-	top.session = NULL;
+	perf_session__delete(top->session);
+	top->session = NULL;
 
 	return 0;
 }
 
 static int
-parse_callchain_opt(const struct option *opt __used, const char *arg,
-		    int unset)
+parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 {
+	struct perf_top *top = (struct perf_top *)opt->value;
 	char *tok, *tok2;
 	char *endptr;
 
@@ -1026,7 +1006,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 	 * --no-call-graph
 	 */
 	if (unset) {
-		dont_use_callchains = true;
+		top->dont_use_callchains = true;
 		return 0;
 	}
 
@@ -1100,17 +1080,32 @@ static const char * const top_usage[] = {
 	NULL
 };
 
-static const struct option options[] = {
+int cmd_top(int argc, const char **argv, const char *prefix __used)
+{
+	struct perf_evsel *pos;
+	int status = -ENOMEM;
+	struct perf_top top = {
+		.count_filter	     = 5,
+		.delay_secs	     = 2,
+		.target_pid	     = -1,
+		.target_tid	     = -1,
+		.freq		     = 1000, /* 1 KHz */
+		.sample_id_all_avail = true,
+		.mmap_pages	     = 128,
+		.sym_pcnt_filter     = 5,
+	};
+	char callchain_default_opt[] = "fractal,0.5,callee";
+	const struct option options[] = {
 	OPT_CALLBACK('e', "event", &top.evlist, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events_option),
-	OPT_INTEGER('c', "count", &default_interval,
+	OPT_INTEGER('c', "count", &top.default_interval,
 		    "event period to sample"),
 	OPT_INTEGER('p', "pid", &top.target_pid,
 		    "profile events on existing process id"),
 	OPT_INTEGER('t', "tid", &top.target_tid,
 		    "profile events on existing thread id"),
-	OPT_BOOLEAN('a', "all-cpus", &system_wide,
+	OPT_BOOLEAN('a', "all-cpus", &top.system_wide,
 			    "system-wide collection from all CPUs"),
 	OPT_STRING('C', "cpu", &top.cpu_list, "cpu",
 		    "list of cpus to monitor"),
@@ -1118,20 +1113,20 @@ static const struct option options[] = {
 		   "file", "vmlinux pathname"),
 	OPT_BOOLEAN('K', "hide_kernel_symbols", &top.hide_kernel_symbols,
 		    "hide kernel symbols"),
-	OPT_UINTEGER('m', "mmap-pages", &mmap_pages, "number of mmap data pages"),
-	OPT_INTEGER('r', "realtime", &realtime_prio,
+	OPT_UINTEGER('m', "mmap-pages", &top.mmap_pages, "number of mmap data pages"),
+	OPT_INTEGER('r', "realtime", &top.realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
 	OPT_INTEGER('d', "delay", &top.delay_secs,
 		    "number of seconds to delay between refreshes"),
-	OPT_BOOLEAN('D', "dump-symtab", &dump_symtab,
+	OPT_BOOLEAN('D', "dump-symtab", &top.dump_symtab,
 			    "dump the symbol table used for profiling"),
 	OPT_INTEGER('f', "count-filter", &top.count_filter,
 		    "only display functions with more events than this"),
-	OPT_BOOLEAN('g', "group", &group,
+	OPT_BOOLEAN('g', "group", &top.group,
 			    "put the counters into a counter group"),
-	OPT_BOOLEAN('i', "inherit", &inherit,
+	OPT_BOOLEAN('i', "inherit", &top.inherit,
 		    "child tasks inherit counters"),
-	OPT_STRING(0, "sym-annotate", &sym_filter, "symbol name",
+	OPT_STRING(0, "sym-annotate", &top.sym_filter, "symbol name",
 		    "symbol to annotate"),
 	OPT_BOOLEAN('z', "zero", &top.zero,
 		    "zero history across updates"),
@@ -1141,15 +1136,15 @@ static const struct option options[] = {
 		    "display this many functions"),
 	OPT_BOOLEAN('U', "hide_user_symbols", &top.hide_user_symbols,
 		    "hide user symbols"),
-	OPT_BOOLEAN(0, "tui", &use_tui, "Use the TUI interface"),
-	OPT_BOOLEAN(0, "stdio", &use_stdio, "Use the stdio interface"),
+	OPT_BOOLEAN(0, "tui", &top.use_tui, "Use the TUI interface"),
+	OPT_BOOLEAN(0, "stdio", &top.use_stdio, "Use the stdio interface"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
-	OPT_CALLBACK_DEFAULT('G', "call-graph", NULL, "output_type,min_percent, call_order",
+	OPT_CALLBACK_DEFAULT('G', "call-graph", &top, "output_type,min_percent, call_order",
 		     "Display callchains using output_type (graph, flat, fractal, or none), min percent threshold and callchain order. "
 		     "Default: fractal,0.5,callee", &parse_callchain_opt,
 		     callchain_default_opt),
@@ -1168,12 +1163,7 @@ static const struct option options[] = {
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_END()
-};
-
-int cmd_top(int argc, const char **argv, const char *prefix __used)
-{
-	struct perf_evsel *pos;
-	int status = -ENOMEM;
+	};
 
 	top.evlist = perf_evlist__new(NULL, NULL);
 	if (top.evlist == NULL)
@@ -1190,9 +1180,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	setup_sorting(top_usage, options);
 
-	if (use_stdio)
+	if (top.use_stdio)
 		use_browser = 0;
-	else if (use_tui)
+	else if (top.use_tui)
 		use_browser = 1;
 
 	setup_browser(false);
@@ -1225,10 +1215,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	/*
 	 * User specified count overrides default frequency.
 	 */
-	if (default_interval)
+	if (top.default_interval)
 		top.freq = 0;
 	else if (top.freq) {
-		default_interval = top.freq;
+		top.default_interval = top.freq;
 	} else {
 		fprintf(stderr, "frequency and count are zero, aborting\n");
 		exit(EXIT_FAILURE);
@@ -1244,7 +1234,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		if (pos->attr.sample_period)
 			continue;
 
-		pos->attr.sample_period = default_interval;
+		pos->attr.sample_period = top.default_interval;
 	}
 
 	if (perf_evlist__alloc_pollfd(top.evlist) < 0 ||
@@ -1267,15 +1257,19 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	 * Avoid annotation data structures overhead when symbols aren't on the
 	 * sort list.
 	 */
-	sort_has_symbols = sort_sym.list.next != NULL;
+	top.sort_has_symbols = sort_sym.list.next != NULL;
 
-	get_term_dimensions(&winsize);
+	get_term_dimensions(&top.winsize);
 	if (top.print_entries == 0) {
-		update_print_entries(&winsize);
-		signal(SIGWINCH, sig_winch_handler);
+		struct sigaction act = {
+			.sa_sigaction = perf_top__sig_winch,
+			.sa_flags     = SA_SIGINFO,
+		};
+		perf_top__update_print_entries(&top);
+		sigaction(SIGWINCH, &act, NULL);
 	}
 
-	status = __cmd_top();
+	status = __cmd_top(&top);
 out_free_fd:
 	perf_evlist__delete(top.evlist);
 
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 40430ec..a248f3c 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -25,10 +25,26 @@ struct perf_top {
 	int		   freq;
 	pid_t		   target_pid, target_tid;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
+	bool		   system_wide;
+	bool		   use_tui, use_stdio;
+	bool		   sort_has_symbols;
+	bool		   dont_use_callchains;
+	bool		   kptr_restrict_warned;
+	bool		   vmlinux_warned;
+	bool		   inherit;
+	bool		   group;
+	bool		   sample_id_all_avail;
+	bool		   dump_symtab;
 	const char	   *cpu_list;
 	struct hist_entry  *sym_filter_entry;
 	struct perf_evsel  *sym_evsel;
 	struct perf_session *session;
+	struct winsize	   winsize;
+	unsigned int	   mmap_pages;
+	int		   default_interval;
+	int		   realtime_prio;
+	int		   sym_pcnt_filter;
+	const char	   *sym_filter;
 };
 
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size);
