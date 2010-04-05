Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0DEP0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 11:26:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab0DEP00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 11:26:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf TUI: Show filters on the title and add help line about how to zoom out
Date: Mon,  5 Apr 2010 12:26:15 -0300
Message-Id: <1270481176-20659-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1270481176-20659-1-git-send-email-acme@infradead.org>
References: <1270481176-20659-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Suggested-by: Ingo Molnar <molnar@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   96 ++++++++++++++++++++++++++++++++++--------------
 1 files changed, 68 insertions(+), 28 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 6d6e022..c0e71aa 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -411,7 +411,7 @@ static void hist_browser__delete(struct hist_browser *self)
 }
 
 static int hist_browser__populate(struct hist_browser *self, struct rb_root *hists,
-				  u64 nr_hists, u64 session_total)
+				  u64 nr_hists, u64 session_total, const char *title)
 {
 	int max_len = 0, idx, cols, rows;
 	struct ui_progress *progress;
@@ -476,7 +476,7 @@ static int hist_browser__populate(struct hist_browser *self, struct rb_root *his
 		newtListboxSetWidth(self->tree, max_len);
 
 	newtCenteredWindow(max_len + (symbol_conf.use_callchain ? 5 : 0),
-			   rows - 5, "Report");
+			   rows - 5, title);
 	self->form = newt_form__new();
 	if (self->form == NULL)
 		return -1;
@@ -495,7 +495,7 @@ enum hist_filter {
 	HIST_FILTER__THREAD,
 };
 
-static u64 hists__filter_by_dso(struct rb_root *hists, struct dso *dso,
+static u64 hists__filter_by_dso(struct rb_root *hists, const struct dso *dso,
 				u64 *session_total)
 {
 	struct rb_node *nd;
@@ -560,25 +560,47 @@ out:
 	return *(struct thread **)(self->selection + 1);
 }
 
+static int hist_browser__title(char *bf, size_t size, const char *input_name,
+			       const struct dso *dso, const struct thread *thread)
+{
+	int printed = 0;
+
+	if (thread)
+		printed += snprintf(bf + printed, size - printed,
+				    "Thread: %s(%d)",
+				    (thread->comm_set ?  thread->comm : ""),
+				    thread->pid);
+	if (dso)
+		printed += snprintf(bf + printed, size - printed,
+				    "%sDSO: %s", thread ? " " : "",
+				    dso->short_name);
+	return printed ?: snprintf(bf, size, "Report: %s", input_name);
+}
+
 int perf_session__browse_hists(struct rb_root *hists, u64 nr_hists,
 			       u64 session_total, const char *helpline,
 			       const char *input_name)
 {
+	struct hist_browser *browser = hist_browser__new();
+	const struct thread *thread_filter = NULL;
+	const struct dso *dso_filter = NULL;
 	struct newtExitStruct es;
-	bool dso_filtered = false, thread_filtered = false;
+	char msg[160];
 	int err = -1;
-	struct hist_browser *browser = hist_browser__new();
 
 	if (browser == NULL)
 		return -1;
 
 	newtPushHelpLine(helpline);
 
-	if (hist_browser__populate(browser, hists, nr_hists, session_total) < 0)
+	hist_browser__title(msg, sizeof(msg), input_name,
+			    dso_filter, thread_filter);
+	if (hist_browser__populate(browser, hists, nr_hists, session_total, msg) < 0)
 		goto out;
 
 	while (1) {
 		const struct thread *thread;
+		const struct dso *dso;
 		char *options[16];
 		int nr_options = 0, choice = 0, i,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2;
@@ -602,20 +624,21 @@ int perf_session__browse_hists(struct rb_root *hists, u64 nr_hists,
 			     browser->selection->sym->name) > 0)
 			annotate = nr_options++;
 
-		if (browser->selection->map != NULL &&
-		    asprintf(&options[nr_options], "Zoom %s %s DSO",
-			     dso_filtered ? "out of" : "into",
-			     (browser->selection->map->dso->kernel ? "the Kernel" :
-			      browser->selection->map->dso->short_name)) > 0)
-			zoom_dso = nr_options++;
-
 		thread = hist_browser__selected_thread(browser);
 		if (thread != NULL &&
 		    asprintf(&options[nr_options], "Zoom %s %s(%d) thread",
-			     (thread_filtered ? "out of" : "into"),
-			     (thread->comm_set ?  thread->comm : ""), thread->pid) > 0)
+			     (thread_filter ? "out of" : "into"),
+			     (thread->comm_set ? thread->comm : ""),
+			     thread->pid) > 0)
 			zoom_thread = nr_options++;
 
+		dso = browser->selection->map ? browser->selection->map->dso : NULL;
+		if (dso != NULL &&
+		    asprintf(&options[nr_options], "Zoom %s %s DSO",
+			     (dso_filter ? "out of" : "into"),
+			     (dso->kernel ? "the Kernel" : dso->short_name)) > 0)
+			zoom_dso = nr_options++;
+
 		options[nr_options++] = (char *)"Exit";
 
 		choice = popup_menu(nr_options, options);
@@ -637,22 +660,39 @@ do_annotate:
 						 "kallsyms file");
 				continue;
 			}
-			map_symbol__annotate_browser(browser->selection,
-						     input_name);
+			map_symbol__annotate_browser(browser->selection, input_name);
 		} else if (choice == zoom_dso) {
-			nr_hists = hists__filter_by_dso(hists,
-							(dso_filtered ? NULL :
-							 browser->selection->map->dso),
-							&session_total);
-			dso_filtered = !dso_filtered;
-			if (hist_browser__populate(browser, hists, nr_hists, session_total) < 0)
+			if (dso_filter) {
+				newtPopHelpLine();
+				dso_filter = NULL;
+			} else {
+				snprintf(msg, sizeof(msg),
+					 "To zoom out press -> + \"Zoom out of %s DSO\"",
+					 dso->kernel ? "the Kernel" : dso->short_name);
+				newtPushHelpLine(msg);
+				dso_filter = dso;
+			}
+			nr_hists = hists__filter_by_dso(hists, dso_filter, &session_total);
+			hist_browser__title(msg, sizeof(msg), input_name,
+					    dso_filter, thread_filter);
+			if (hist_browser__populate(browser, hists, nr_hists, session_total, msg) < 0)
 				goto out;
 		} else if (choice == zoom_thread) {
-			nr_hists = hists__filter_by_thread(hists,
-							   (thread_filtered ? NULL : thread),
-							   &session_total);
-			thread_filtered = !thread_filtered;
-			if (hist_browser__populate(browser, hists, nr_hists, session_total) < 0)
+			if (thread_filter) {
+				newtPopHelpLine();
+				thread_filter = NULL;
+			} else {
+				snprintf(msg, sizeof(msg),
+					 "To zoom out press -> + \"Zoom out of %s(%d) thread\"",
+					 (thread->comm_set ? thread->comm : ""),
+					 thread->pid);
+				newtPushHelpLine(msg);
+				thread_filter = thread;
+			}
+			nr_hists = hists__filter_by_thread(hists, thread_filter, &session_total);
+			hist_browser__title(msg, sizeof(msg), input_name,
+					    dso_filter, thread_filter);
+			if (hist_browser__populate(browser, hists, nr_hists, session_total, msg) < 0)
 				goto out;
 		}
 	}
-- 
1.6.2.5

