Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0C0AVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 20:21:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:43868 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab0C0AVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 20:21:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf report: Add progress bars
Date: Fri, 26 Mar 2010 21:21:12 -0300
Message-Id: <1269649272-12094-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

For when we are processing the events and inserting the entries in the
browser.

Experimentation here: naming "ui_something" we may be treading into
creating a TUI/GUI set of routines that can then be implemented in terms
of multiple backends.

Also the time it takes for adding things to the "browser" takes, visually
(I guess I should do some profiling here ;-) ), more time than for
processing the events...

That means we probably need to create a custom hist_entry browser, so
that we reuse the structures we have in place instead of duplicating
them in newt.

But progress was made and at least we can see something while long files
are being loaded, that must be one of UI 101 bullet points :-)

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    7 ++-
 tools/perf/util/debug.h     |   16 +++++++
 tools/perf/util/hist.c      |    5 ++-
 tools/perf/util/hist.h      |    2 +-
 tools/perf/util/newt.c      |  103 +++++++++++++++++++++++++++++++++----------
 tools/perf/util/session.c   |    6 +++
 tools/perf/util/session.h   |   12 +++--
 7 files changed, 119 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3ab6d9e..e93a7ed 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -302,13 +302,14 @@ static int __cmd_report(void)
 	next = rb_first(&session->stats_by_id);
 	while (next) {
 		struct event_stat_id *stats;
+		u64 nr_hists;
 
 		stats = rb_entry(next, struct event_stat_id, rb_node);
 		perf_session__collapse_resort(&stats->hists);
-		perf_session__output_resort(&stats->hists, stats->stats.total);
-
+		nr_hists = perf_session__output_resort(&stats->hists,
+						       stats->stats.total);
 		if (use_browser)
-			perf_session__browse_hists(&stats->hists,
+			perf_session__browse_hists(&stats->hists, nr_hists,
 						   stats->stats.total, help);
 		else {
 			if (rb_first(&session->stats_by_id) ==
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 0172edf..5cb0a1b 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -10,13 +10,29 @@ extern int dump_trace;
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(event_t *event);
 
+struct ui_progress;
+
 #ifdef NO_NEWT_SUPPORT
 static inline int browser__show_help(const char *format __used, va_list ap __used)
 {
 	return 0;
 }
+
+static inline struct ui_progress *ui_progress__new(const char *title __used,
+						   u64 total __used)
+{
+	return (struct ui_progress *)1;
+}
+
+static inline void ui_progress__update(struct ui_progress *self __used,
+				       u64 curr __used) {}
+
+static inline void ui_progress__delete(struct ui_progress *self __used) {}
 #else
 int browser__show_help(const char *format, va_list ap);
+struct ui_progress *ui_progress__new(const char *title, u64 total);
+void ui_progress__update(struct ui_progress *self, u64 curr);
+void ui_progress__delete(struct ui_progress *self);
 #endif
 
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index de31901..a46d093 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -185,12 +185,13 @@ static void perf_session__insert_output_hist_entry(struct rb_root *root,
 	rb_insert_color(&he->rb_node, root);
 }
 
-void perf_session__output_resort(struct rb_root *hists, u64 total_samples)
+u64 perf_session__output_resort(struct rb_root *hists, u64 total_samples)
 {
 	struct rb_root tmp;
 	struct rb_node *next;
 	struct hist_entry *n;
 	u64 min_callchain_hits;
+	u64 nr_hists = 0;
 
 	min_callchain_hits =
 		total_samples * (callchain_param.min_percent / 100);
@@ -205,9 +206,11 @@ void perf_session__output_resort(struct rb_root *hists, u64 total_samples)
 		rb_erase(&n->rb_node, hists);
 		perf_session__insert_output_hist_entry(&tmp, n,
 						       min_callchain_hits);
+		++nr_hists;
 	}
 
 	*hists = tmp;
+	return nr_hists;
 }
 
 static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index fe366ce..da6a8c1 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -25,7 +25,7 @@ size_t hist_entry__fprintf(struct hist_entry *self,
 			   u64 session_total);
 void hist_entry__free(struct hist_entry *);
 
-void perf_session__output_resort(struct rb_root *hists, u64 total_samples);
+u64 perf_session__output_resort(struct rb_root *hists, u64 total_samples);
 void perf_session__collapse_resort(struct rb_root *hists);
 size_t perf_session__fprintf_hists(struct rb_root *hists,
 				   struct perf_session *pair,
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index e99bcc8..b0210ae 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -12,6 +12,72 @@
 #include "sort.h"
 #include "symbol.h"
 
+struct ui_progress {
+	newtComponent form, scale;
+};
+
+struct ui_progress *ui_progress__new(const char *title, u64 total)
+{
+	struct ui_progress *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		int cols;
+		newtGetScreenSize(&cols, NULL);
+		cols -= 4;
+		newtCenteredWindow(cols, 1, title);
+		self->form  = newtForm(NULL, NULL, 0);
+		if (self->form == NULL)
+			goto out_free_self;
+		self->scale = newtScale(0, 0, cols, total);
+		if (self->scale == NULL)
+			goto out_free_form;
+		newtFormAddComponents(self->form, self->scale, NULL);
+		newtRefresh();
+	}
+
+	return self;
+
+out_free_form:
+	newtFormDestroy(self->form);
+out_free_self:
+	free(self);
+	return NULL;
+}
+
+void ui_progress__update(struct ui_progress *self, u64 curr)
+{
+	newtScaleSet(self->scale, curr);
+	newtRefresh();
+}
+
+void ui_progress__delete(struct ui_progress *self)
+{
+	newtFormDestroy(self->form);
+	newtPopWindow();
+	free(self);
+}
+
+static char browser__last_msg[1024];
+
+int browser__show_help(const char *format, va_list ap)
+{
+	int ret;
+	static int backlog;
+
+        ret = vsnprintf(browser__last_msg + backlog,
+			sizeof(browser__last_msg) - backlog, format, ap);
+	backlog += ret;
+
+	if (browser__last_msg[backlog - 1] == '\n') {
+		newtPopHelpLine();
+		newtPushHelpLine(browser__last_msg);
+		newtRefresh();
+		backlog = 0;
+	}
+
+	return ret;
+}
+
 static void newt_form__set_exit_keys(newtComponent self)
 {
 	newtFormAddHotKey(self, NEWT_KEY_ESCAPE);
@@ -364,8 +430,8 @@ static void perf_session__selection(newtComponent self, void *data)
 	*symbol_ptr = newt__symbol_tree_get_current(self);
 }
 
-void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
-				const char *helpline)
+int perf_session__browse_hists(struct rb_root *hists, u64 nr_hists,
+			       u64 session_total, const char *helpline)
 {
 	struct sort_entry *se;
 	struct rb_node *nd;
@@ -378,6 +444,12 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 	newtComponent form, tree;
 	struct newtExitStruct es;
 	const struct map_symbol *selection;
+	u64 curr_hist = 0;
+	struct ui_progress *progress;
+
+	progress = ui_progress__new("Adding entries to the browser...", nr_hists);
+	if (progress == NULL)
+		return -1;
 
 	snprintf(str, sizeof(str), "Samples: %Ld", session_total);
 	newtDrawRootText(0, 0, str);
@@ -419,8 +491,13 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 			max_len = len;
 		if (symbol_conf.use_callchain)
 			hist_entry__append_callchain_browser(h, tree, session_total, idx++);
+		++curr_hist;
+		if (curr_hist % 5)
+			ui_progress__update(progress, curr_hist);
 	}
 
+	ui_progress__delete(progress);
+
 	if (max_len > cols)
 		max_len = cols - 3;
 
@@ -480,27 +557,7 @@ do_annotate:
 
 	newtFormDestroy(form);
 	newtPopWindow();
-}
-
-static char browser__last_msg[1024];
-
-int browser__show_help(const char *format, va_list ap)
-{
-	int ret;
-	static int backlog;
-
-        ret = vsnprintf(browser__last_msg + backlog,
-			sizeof(browser__last_msg) - backlog, format, ap);
-	backlog += ret;
-
-	if (browser__last_msg[backlog - 1] == '\n') {
-		newtPopHelpLine();
-		newtPushHelpLine(browser__last_msg);
-		newtRefresh();
-		backlog = 0;
-	}
-
-	return ret;
+	return 0;
 }
 
 void setup_browser(void)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 76b4ac6..32765cd 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -397,6 +397,10 @@ int __perf_session__process_events(struct perf_session *self,
 	event_t *event;
 	uint32_t size;
 	char *buf;
+	struct ui_progress *progress = ui_progress__new("Processing events...",
+							self->size);
+	if (progress == NULL)
+		return -1;
 
 	perf_event_ops__fill_defaults(ops);
 
@@ -425,6 +429,7 @@ remap:
 
 more:
 	event = (event_t *)(buf + head);
+	ui_progress__update(progress, offset);
 
 	if (self->header.needs_swap)
 		perf_event_header__bswap(&event->header);
@@ -475,6 +480,7 @@ more:
 done:
 	err = 0;
 out_err:
+	ui_progress__delete(progress);
 	return err;
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 631f815..6a15dae 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -88,11 +88,15 @@ static inline struct map *
 }
 
 #ifdef NO_NEWT_SUPPORT
-static inline void perf_session__browse_hists(struct rb_root *hists __used,
+static inline int perf_session__browse_hists(struct rb_root *hists __used,
+					      u64 nr_hists __used,
 					      u64 session_total __used,
-					      const char *helpline __used) {}
+					      const char *helpline __used)
+{
+	return 0;
+}
 #else
-void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
-				const char *helpline);
+int perf_session__browse_hists(struct rb_root *hists, u64 nr_hists,
+				u64 session_total, const char *helpline);
 #endif
 #endif /* __PERF_SESSION_H */
-- 
1.6.2.5

