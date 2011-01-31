Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab1AaVan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:30:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44484 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab1AaV3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:29:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 5/5] perf top: Introduce slang based TUI
Date: Mon, 31 Jan 2011 19:29:22 -0200
Message-Id: <1296509362-28054-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296509362-28054-1-git-send-email-acme@infradead.org>
References: <1296509362-28054-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Disabled by default as there are features found in the stdio based one
that aren't implemented, like live annotation, filtering knobs data
entry.

Annotation hopefully will get somehow merged with the 'perf annotate'
code.

To use it:

perf top --tui

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
 tools/perf/Makefile               |    4 +
 tools/perf/builtin-top.c          |   35 ++++++++--
 tools/perf/util/top.c             |    7 ++-
 tools/perf/util/top.h             |   15 ++++-
 tools/perf/util/ui/browsers/top.c |  136 +++++++++++++++++++++++++++++++++++++
 5 files changed, 189 insertions(+), 8 deletions(-)
 create mode 100644 tools/perf/util/ui/browsers/top.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index edc660e..67a9f4d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -621,6 +621,7 @@ else
 		LIB_OBJS += $(OUTPUT)util/ui/browsers/annotate.o
 		LIB_OBJS += $(OUTPUT)util/ui/browsers/hists.o
 		LIB_OBJS += $(OUTPUT)util/ui/browsers/map.o
+		LIB_OBJS += $(OUTPUT)util/ui/browsers/top.o
 		LIB_OBJS += $(OUTPUT)util/ui/helpline.o
 		LIB_OBJS += $(OUTPUT)util/ui/progress.o
 		LIB_OBJS += $(OUTPUT)util/ui/util.o
@@ -1050,6 +1051,9 @@ $(OUTPUT)util/ui/browser.o: util/ui/browser.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/ui/browsers/annotate.o: util/ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
+$(OUTPUT)util/ui/browsers/top.o: util/ui/browsers/top.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
 $(OUTPUT)util/ui/browsers/hists.o: util/ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 3c9ba94..104de9a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -20,6 +20,7 @@
 
 #include "perf.h"
 
+#include "util/cache.h"
 #include "util/color.h"
 #include "util/evlist.h"
 #include "util/evsel.h"
@@ -75,6 +76,8 @@ static struct perf_top top = {
 
 static bool			system_wide			=  false;
 
+static bool			use_tui, use_stdio;
+
 static int			default_interval		=      0;
 
 static bool			inherit				=  false;
@@ -96,11 +99,6 @@ static int			sym_pcnt_filter			=      5;
  * Source functions
  */
 
-static inline struct symbol *sym_entry__symbol(struct sym_entry *self)
-{
-       return ((void *)self) + symbol_conf.priv_size;
-}
-
 void get_term_dimensions(struct winsize *ws)
 {
 	char *s = getenv("LINES");
@@ -695,6 +693,14 @@ static void handle_keypress(struct perf_session *session, int c)
 	}
 }
 
+static void *display_thread_tui(void *arg __used)
+{
+	perf_top__tui_browser(&top);
+	exit_browser(0);
+	exit(0);
+	return NULL;
+}
+
 static void *display_thread(void *arg __used)
 {
 	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
@@ -1005,7 +1011,8 @@ static int __cmd_top(void)
 
 	perf_session__mmap_read(session);
 
-	if (pthread_create(&thread, NULL, display_thread, session)) {
+	if (pthread_create(&thread, NULL, (use_browser > 0 ? display_thread_tui :
+							     display_thread), session)) {
 		printf("Could not create display thread.\n");
 		exit(-1);
 	}
@@ -1078,6 +1085,8 @@ static const struct option options[] = {
 		    "display this many functions"),
 	OPT_BOOLEAN('U', "hide_user_symbols", &top.hide_user_symbols,
 		    "hide user symbols"),
+	OPT_BOOLEAN(0, "tui", &use_tui, "Use the TUI interface"),
+	OPT_BOOLEAN(0, "stdio", &use_stdio, "Use the stdio interface"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_END()
@@ -1098,6 +1107,20 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (argc)
 		usage_with_options(top_usage, options);
 
+	/*
+ 	 * XXX For now start disabled, only using TUI if explicitely asked for.
+ 	 * Change that when handle_keys equivalent gets written, live annotation
+ 	 * done, etc.
+ 	 */
+	use_browser = 0;
+
+	if (use_stdio)
+		use_browser = 0;
+	else if (use_tui)
+		use_browser = 1;
+
+	setup_browser(false);
+
 	/* CPU and PID are mutually exclusive */
 	if (top.target_tid > 0 && top.cpu_list) {
 		printf("WARNING: PID switch overriding CPU\n");
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index c06cc53..1d2e265 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -158,6 +158,7 @@ float perf_top__decay_samples(struct perf_top *top, struct rb_root *root)
 	syme = list_entry(top->active_symbols.next, struct sym_entry, node);
 	pthread_mutex_unlock(&top->active_symbols_lock);
 
+	top->rb_entries = 0;
 	list_for_each_entry_safe_from(syme, n, &top->active_symbols, node) {
 		syme->snap_count = syme->count[snap];
 		if (syme->snap_count != 0) {
@@ -170,7 +171,11 @@ float perf_top__decay_samples(struct perf_top *top, struct rb_root *root)
 				continue;
 			}
 			syme->weight = sym_weight(syme, top);
-			rb_insert_active_sym(root, syme);
+
+			if ((int)syme->snap_count >= top->count_filter) {
+				rb_insert_active_sym(root, syme);
+				++top->rb_entries;
+			}
 			sum_ksamples += syme->snap_count;
 
 			for (j = 0; j < top->evlist->nr_entries; j++)
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 0467b26..611370f 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -38,6 +38,11 @@ struct sym_entry {
 	unsigned long		count[0];
 };
 
+static inline struct symbol *sym_entry__symbol(struct sym_entry *self)
+{
+       return ((void *)self) + symbol_conf.priv_size;
+}
+
 struct perf_top {
 	struct perf_evlist *evlist;
 	/*
@@ -51,7 +56,7 @@ struct perf_top {
 	u64		   exact_samples;
 	u64		   guest_us_samples, guest_kernel_samples;
 	int		   print_entries, count_filter, delay_secs;
-	int		   display_weighted, freq;
+	int		   display_weighted, freq, rb_entries;
 	int		   sym_counter, target_pid, target_tid;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	const char	   *cpu_list;
@@ -64,4 +69,12 @@ float perf_top__decay_samples(struct perf_top *top, struct rb_root *root);
 void perf_top__find_widths(struct perf_top *top, struct rb_root *root,
 			   int *dso_width, int *dso_short_width, int *sym_width);
 
+#ifdef NO_NEWT_SUPPORT
+static inline int perf_top__tui_browser(struct perf_top *top __used)
+{
+	return 0;
+}
+#else
+int perf_top__tui_browser(struct perf_top *top);
+#endif
 #endif /* __PERF_TOP_H */
diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
new file mode 100644
index 0000000..ca60624
--- /dev/null
+++ b/tools/perf/util/ui/browsers/top.c
@@ -0,0 +1,136 @@
+/*
+ * Copyright (C) 2011, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Parts came from builtin-{top,stat,record}.c, see those files for further
+ * copyright notes.
+ *
+ * Released under the GPL v2. (and only v2, not any later version)
+ */
+#include "../browser.h"
+#include "../helpline.h"
+#include "../libslang.h"
+#include "../../evlist.h"
+#include "../../hist.h"
+#include "../../sort.h"
+#include "../../symbol.h"
+#include "../../top.h"
+
+struct perf_top_browser {
+	struct ui_browser b;
+	struct rb_root	  root;
+	float		  sum_ksamples;
+	int		  dso_width;
+	int		  dso_short_width;
+	int		  sym_width;
+};
+
+static void perf_top_browser__write(struct ui_browser *browser, void *entry, int row)
+{
+	struct perf_top_browser *top_browser = container_of(browser, struct perf_top_browser, b);
+	struct sym_entry *syme = rb_entry(entry, struct sym_entry, rb_node);
+	bool current_entry = ui_browser__is_current_entry(browser, row);
+	struct symbol *symbol = sym_entry__symbol(syme);
+	struct perf_top *top = browser->priv;
+	int width = browser->width;
+	double pcnt;
+
+	pcnt = 100.0 - (100.0 * ((top_browser->sum_ksamples - syme->snap_count) /
+				 top_browser->sum_ksamples));
+	ui_browser__set_percent_color(browser, pcnt, current_entry);
+
+	if (top->evlist->nr_entries == 1 || !top->display_weighted) {
+		slsmg_printf("%20.2f ", syme->weight);
+		width -= 24;
+	} else {
+		slsmg_printf("%9.1f %10ld ", syme->weight, syme->snap_count);
+		width -= 23;
+	}
+
+	slsmg_printf("%4.1f%%", pcnt);
+	width -= 7;
+
+	if (verbose) {
+		slsmg_printf(" %016" PRIx64, symbol->start);
+		width -= 17;
+	}
+
+	slsmg_printf(" %-*.*s ", top_browser->sym_width, top_browser->sym_width,
+		     symbol->name);
+	width -= top_browser->sym_width;
+	slsmg_write_nstring(width >= syme->map->dso->long_name_len ?
+				syme->map->dso->long_name :
+				syme->map->dso->short_name, width);
+}
+
+static void perf_top_browser__update_rb_tree(struct perf_top_browser *browser)
+{
+	struct perf_top *top = browser->b.priv;
+
+	browser->root = RB_ROOT;
+	browser->b.top = NULL;
+	browser->sum_ksamples = perf_top__decay_samples(top, &browser->root);
+	perf_top__find_widths(top, &browser->root, &browser->dso_width,
+			      &browser->dso_short_width,
+                              &browser->sym_width);
+	if (browser->sym_width + browser->dso_width > browser->b.width - 29) {
+		browser->dso_width = browser->dso_short_width;
+		if (browser->sym_width + browser->dso_width > browser->b.width - 29)
+			browser->sym_width = browser->b.width - browser->dso_width - 29;
+	}
+	browser->b.nr_entries = top->rb_entries;
+}
+
+static int perf_top_browser__run(struct perf_top_browser *browser)
+{
+	int key;
+	char title[160];
+	struct perf_top *top = browser->b.priv;
+	int delay_msecs = top->delay_secs * 1000;
+
+	perf_top_browser__update_rb_tree(browser);
+        perf_top__header_snprintf(top, title, sizeof(title));
+        perf_top__reset_sample_counters(top);
+
+	if (ui_browser__show(&browser->b, title, "ESC: exit") < 0)
+		return -1;
+
+	newtFormSetTimer(browser->b.form, delay_msecs);
+
+	while (1) {
+		key = ui_browser__run(&browser->b);
+
+		switch (key) {
+		case -1:
+			/* FIXME we need to check if it was es.reason == NEWT_EXIT_TIMER */
+			perf_top_browser__update_rb_tree(browser);
+			perf_top__header_snprintf(top, title, sizeof(title));
+			perf_top__reset_sample_counters(top);
+			ui_browser__set_color(&browser->b, NEWT_COLORSET_ROOT);
+			SLsmg_gotorc(0, 0);
+			slsmg_write_nstring(title, browser->b.width);
+			break;
+		case NEWT_KEY_TAB:
+		default:
+			goto out;
+		}
+	}
+out:
+	ui_browser__hide(&browser->b);
+	return key;
+}
+
+int perf_top__tui_browser(struct perf_top *top)
+{
+	struct perf_top_browser browser = {
+		.b = {
+			.entries = &browser.root,
+			.refresh = ui_browser__rb_tree_refresh,
+			.seek	 = ui_browser__rb_tree_seek,
+			.write	 = perf_top_browser__write,
+			.priv	 = top,
+		},
+	};
+
+	ui_helpline__push("Press <- or ESC to exit");
+	return perf_top_browser__run(&browser);
+}
-- 
1.6.2.5

