Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab0EXBbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 21:31:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48942 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab0EXBbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 21:31:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf report: Support multiple events on the TUI
Date: Sun, 23 May 2010 22:31:10 -0300
Message-Id: <1274664671-27385-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274664671-27385-1-git-send-email-acme@infradead.org>
References: <1274664671-27385-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The hists__tty_browse_tree function was created with the loop to print
all events, and its equivalent, hists__tui_browse_tree, was created in a
similar fashion, where it is possible to switch among the multiple
events, if present, using TAB to go the next event, and shift+TAB
(UNTAB) to go to the previous.

The report TUI now shows as the window title the name of the event and a
leak was fixed wrt pstacks.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |   60 +++++++++++++++++++++--------------
 tools/perf/util/hist.h      |   14 +++++++-
 tools/perf/util/newt.c      |   74 ++++++++++++++++++++++++++++++++++--------
 3 files changed, 108 insertions(+), 40 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a7b8760..3ff4e66 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -288,6 +288,38 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	return ret + fprintf(fp, "\n#\n");
 }
 
+static int hists__tty_browse_tree(struct rb_root *tree, const char *help)
+{
+	struct rb_node *next = rb_first(tree);
+
+	while (next) {
+		struct hists *hists = rb_entry(next, struct hists, rb_node);
+		const char *evname = NULL;
+
+		if (rb_first(&hists->entries) != rb_last(&hists->entries))
+			evname = __event_name(hists->type, hists->config);
+
+		hists__fprintf_nr_sample_events(hists, evname, stdout);
+		hists__fprintf(hists, NULL, false, stdout);
+		fprintf(stdout, "\n\n");
+		next = rb_next(&hists->rb_node);
+	}
+
+	if (sort_order == default_sort_order &&
+	    parent_pattern == default_parent_pattern) {
+		fprintf(stdout, "#\n# (%s)\n#\n", help);
+
+		if (show_threads) {
+			bool style = !strcmp(pretty_printing_style, "raw");
+			perf_read_values_display(stdout, &show_threads_values,
+						 style);
+			perf_read_values_destroy(&show_threads_values);
+		}
+	}
+
+	return 0;
+}
+
 static int __cmd_report(void)
 {
 	int ret = -EINVAL;
@@ -330,34 +362,14 @@ static int __cmd_report(void)
 		hists = rb_entry(next, struct hists, rb_node);
 		hists__collapse_resort(hists);
 		hists__output_resort(hists);
-		if (use_browser > 0)
-			hists__browse(hists, help, input_name);
-		else {
-			const char *evname = NULL;
-			if (rb_first(&session->hists.entries) !=
-			    rb_last(&session->hists.entries))
-				evname = __event_name(hists->type, hists->config);
-
-			hists__fprintf_nr_sample_events(hists, evname, stdout);
-
-			hists__fprintf(hists, NULL, false, stdout);
-			fprintf(stdout, "\n\n");
-		}
-
 		next = rb_next(&hists->rb_node);
 	}
 
-	if (use_browser <= 0 && sort_order == default_sort_order &&
-	    parent_pattern == default_parent_pattern) {
-		fprintf(stdout, "#\n# (%s)\n#\n", help);
+	if (use_browser)
+		hists__tui_browse_tree(&session->hists_tree, help);
+	else
+		hists__tty_browse_tree(&session->hists_tree, help);
 
-		if (show_threads) {
-			bool style = !strcmp(pretty_printing_style, "raw");
-			perf_read_values_display(stdout, &show_threads_values,
-						 style);
-			perf_read_values_destroy(&show_threads_values);
-		}
-	}
 out_delete:
 	perf_session__delete(session);
 	return ret;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2d5203f..83fa33a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -98,10 +98,17 @@ void hists__filter_by_thread(struct hists *self, const struct thread *thread);
 #ifdef NO_NEWT_SUPPORT
 static inline int hists__browse(struct hists *self __used,
 				const char *helpline __used,
-				const char *input_name __used)
+				const char *ev_name __used)
 {
 	return 0;
 }
+
+static inline int hists__tui_browse_tree(struct rb_root *self __used,
+					 const char *help __used)
+{
+	return 0;
+}
+
 static inline int hist_entry__tui_annotate(struct hist_entry *self __used)
 {
 	return 0;
@@ -111,9 +118,12 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self __used)
 #else
 #include <newt.h>
 int hists__browse(struct hists *self, const char *helpline,
-		  const char *input_name);
+		  const char *ev_name);
 int hist_entry__tui_annotate(struct hist_entry *self);
+
 #define KEY_LEFT NEWT_KEY_LEFT
 #define KEY_RIGHT NEWT_KEY_RIGHT
+
+int hists__tui_browse_tree(struct rb_root *self, const char *help);
 #endif
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index ffd0472..d54c540 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -842,6 +842,8 @@ static int hist_browser__populate(struct hist_browser *self, struct hists *hists
 	newtFormAddHotKey(self->form, 'h');
 	newtFormAddHotKey(self->form, NEWT_KEY_F1);
 	newtFormAddHotKey(self->form, NEWT_KEY_RIGHT);
+	newtFormAddHotKey(self->form, NEWT_KEY_TAB);
+	newtFormAddHotKey(self->form, NEWT_KEY_UNTAB);
 	newtFormAddComponents(self->form, self->tree, NULL);
 	self->selection = newt__symbol_tree_get_current(self->tree);
 
@@ -873,7 +875,7 @@ static struct thread *hist_browser__selected_thread(struct hist_browser *self)
 	return he ? he->thread : NULL;
 }
 
-static int hist_browser__title(char *bf, size_t size, const char *input_name,
+static int hist_browser__title(char *bf, size_t size, const char *ev_name,
 			       const struct dso *dso, const struct thread *thread)
 {
 	int printed = 0;
@@ -887,18 +889,18 @@ static int hist_browser__title(char *bf, size_t size, const char *input_name,
 		printed += snprintf(bf + printed, size - printed,
 				    "%sDSO: %s", thread ? " " : "",
 				    dso->short_name);
-	return printed ?: snprintf(bf, size, "Report: %s", input_name);
+	return printed ?: snprintf(bf, size, "Event: %s", ev_name);
 }
 
-int hists__browse(struct hists *self, const char *helpline, const char *input_name)
+int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 {
 	struct hist_browser *browser = hist_browser__new();
-	struct pstack *fstack = pstack__new(2);
+	struct pstack *fstack;
 	const struct thread *thread_filter = NULL;
 	const struct dso *dso_filter = NULL;
 	struct newtExitStruct es;
 	char msg[160];
-	int err = -1;
+	int key = -1;
 
 	if (browser == NULL)
 		return -1;
@@ -909,7 +911,7 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 
 	ui_helpline__push(helpline);
 
-	hist_browser__title(msg, sizeof(msg), input_name,
+	hist_browser__title(msg, sizeof(msg), ev_name,
 			    dso_filter, thread_filter);
 	if (hist_browser__populate(browser, self, msg) < 0)
 		goto out_free_stack;
@@ -927,10 +929,23 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 		dso = browser->selection->map ? browser->selection->map->dso : NULL;
 
 		if (es.reason == NEWT_EXIT_HOTKEY) {
-			if (es.u.key == NEWT_KEY_F1)
+			key = es.u.key;
+
+			switch (key) {
+			case NEWT_KEY_F1:
 				goto do_help;
+			case NEWT_KEY_TAB:
+			case NEWT_KEY_UNTAB:
+				/*
+				 * Exit the browser, let hists__browser_tree
+				 * go to the next or previous
+				 */
+				goto out_free_stack;
+			default:;
+			}
 
-			switch (toupper(es.u.key)) {
+			key = toupper(key);
+			switch (key) {
 			case 'A':
 				if (browser->selection->map == NULL &&
 				    browser->selection->map->dso->annotate_warned)
@@ -953,8 +968,8 @@ do_help:
 				continue;
 			default:;
 			}
-			if (is_exit_key(es.u.key)) {
-				if (es.u.key == NEWT_KEY_ESCAPE) {
+			if (is_exit_key(key)) {
+				if (key == NEWT_KEY_ESCAPE) {
 					if (dialog_yesno("Do you really want to exit?"))
 						break;
 					else
@@ -1041,7 +1056,7 @@ zoom_out_dso:
 				pstack__push(fstack, &dso_filter);
 			}
 			hists__filter_by_dso(self, dso_filter);
-			hist_browser__title(msg, sizeof(msg), input_name,
+			hist_browser__title(msg, sizeof(msg), ev_name,
 					    dso_filter, thread_filter);
 			if (hist_browser__populate(browser, self, msg) < 0)
 				goto out;
@@ -1060,18 +1075,49 @@ zoom_out_thread:
 				pstack__push(fstack, &thread_filter);
 			}
 			hists__filter_by_thread(self, thread_filter);
-			hist_browser__title(msg, sizeof(msg), input_name,
+			hist_browser__title(msg, sizeof(msg), ev_name,
 					    dso_filter, thread_filter);
 			if (hist_browser__populate(browser, self, msg) < 0)
 				goto out;
 		}
 	}
-	err = 0;
 out_free_stack:
 	pstack__delete(fstack);
 out:
 	hist_browser__delete(browser);
-	return err;
+	return key;
+}
+
+int hists__tui_browse_tree(struct rb_root *self, const char *help)
+{
+	struct rb_node *first = rb_first(self), *nd = first, *next;
+	int key = 0;
+
+	while (nd) {
+		struct hists *hists = rb_entry(nd, struct hists, rb_node);
+		const char *ev_name = __event_name(hists->type, hists->config);
+
+		key = hists__browse(hists, help, ev_name);
+
+		if (is_exit_key(key))
+			break;
+
+		switch (key) {
+		case NEWT_KEY_TAB:
+			next = rb_next(nd);
+			if (next)
+				nd = next;
+			break;
+		case NEWT_KEY_UNTAB:
+			if (nd == first)
+				continue;
+			nd = rb_prev(nd);
+		default:
+			break;
+		}
+	}
+
+	return key;
 }
 
 static struct newtPercentTreeColors {
-- 
1.6.2.5

