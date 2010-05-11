Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0EKQaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:30:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:37548 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab0EKQaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:30:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/3] perf hist: Adopt filter by dso and by thread methods from the newt browser
Date: Tue, 11 May 2010 13:29:48 -0300
Message-Id: <1273595390-6486-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273595390-6486-1-git-send-email-acme@infradead.org>
References: <1273595390-6486-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Those are really not specific to the newt code, can be used by other UI
frontends.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    5 +--
 tools/perf/util/hist.c      |   59 +++++++++++++++++++++++++++++++
 tools/perf/util/hist.h      |   15 ++++++++
 tools/perf/util/newt.c      |   80 +++++++-----------------------------------
 tools/perf/util/session.h   |   15 --------
 5 files changed, 89 insertions(+), 85 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d7c7529..3d67d6b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -301,10 +301,7 @@ static int __cmd_report(void)
 		hists__collapse_resort(hists);
 		hists__output_resort(hists);
 		if (use_browser)
-			perf_session__browse_hists(&hists->entries,
-						   hists->nr_entries,
-						   hists->stats.total, help,
-						   input_name);
+			hists__browse(hists, help, input_name);
 		else {
 			if (rb_first(&session->hists.entries) ==
 			    rb_last(&session->hists.entries))
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e34fd24..baa55be 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -784,3 +784,62 @@ print_entries:
 
 	return ret;
 }
+
+enum hist_filter {
+	HIST_FILTER__DSO,
+	HIST_FILTER__THREAD,
+};
+
+void hists__filter_by_dso(struct hists *self, const struct dso *dso)
+{
+	struct rb_node *nd;
+
+	self->nr_entries = self->stats.total = 0;
+	self->max_sym_namelen = 0;
+
+	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (symbol_conf.exclude_other && !h->parent)
+			continue;
+
+		if (dso != NULL && (h->ms.map == NULL || h->ms.map->dso != dso)) {
+			h->filtered |= (1 << HIST_FILTER__DSO);
+			continue;
+		}
+
+		h->filtered &= ~(1 << HIST_FILTER__DSO);
+		if (!h->filtered) {
+			++self->nr_entries;
+			self->stats.total += h->count;
+			if (h->ms.sym &&
+			    self->max_sym_namelen < h->ms.sym->namelen)
+				self->max_sym_namelen = h->ms.sym->namelen;
+		}
+	}
+}
+
+void hists__filter_by_thread(struct hists *self, const struct thread *thread)
+{
+	struct rb_node *nd;
+
+	self->nr_entries = self->stats.total = 0;
+	self->max_sym_namelen = 0;
+
+	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (thread != NULL && h->thread != thread) {
+			h->filtered |= (1 << HIST_FILTER__THREAD);
+			continue;
+		}
+		h->filtered &= ~(1 << HIST_FILTER__THREAD);
+		if (!h->filtered) {
+			++self->nr_entries;
+			self->stats.total += h->count;
+			if (h->ms.sym &&
+			    self->max_sym_namelen < h->ms.sym->namelen)
+				self->max_sym_namelen = h->ms.sym->namelen;
+		}
+	}
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1b18d04..1c5f93a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -44,4 +44,19 @@ void hists__output_resort(struct hists *self);
 void hists__collapse_resort(struct hists *self);
 size_t hists__fprintf(struct hists *self, struct hists *pair,
 		      bool show_displacement, FILE *fp);
+
+void hists__filter_by_dso(struct hists *self, const struct dso *dso);
+void hists__filter_by_thread(struct hists *self, const struct thread *thread);
+
+#ifdef NO_NEWT_SUPPORT
+static inline int hists__browse(struct hists self __used,
+				const char *helpline __used,
+				const char *input_name __used)
+{
+	return 0;
+}
+#else
+int hists__browse(struct hists *self, const char *helpline,
+		  const char *input_name);
+#endif
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index e283a6e..638b519 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -410,8 +410,8 @@ static void hist_browser__delete(struct hist_browser *self)
 	free(self);
 }
 
-static int hist_browser__populate(struct hist_browser *self, struct rb_root *hists,
-				  u64 nr_hists, u64 session_total, const char *title)
+static int hist_browser__populate(struct hist_browser *self, struct hists *hists,
+				  const char *title)
 {
 	int max_len = 0, idx, cols, rows;
 	struct ui_progress *progress;
@@ -426,7 +426,7 @@ static int hist_browser__populate(struct hist_browser *self, struct rb_root *his
 	}
 
 	snprintf(str, sizeof(str), "Samples: %Ld                            ",
-		 session_total);
+		 hists->stats.total);
 	newtDrawRootText(0, 0, str);
 
 	newtGetScreenSize(NULL, &rows);
@@ -442,24 +442,25 @@ static int hist_browser__populate(struct hist_browser *self, struct rb_root *his
 	newtComponentAddCallback(self->tree, hist_browser__selection,
 				 &self->selection);
 
-	progress = ui_progress__new("Adding entries to the browser...", nr_hists);
+	progress = ui_progress__new("Adding entries to the browser...",
+				    hists->nr_entries);
 	if (progress == NULL)
 		return -1;
 
 	idx = 0;
-	for (nd = rb_first(hists); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 		int len;
 
 		if (h->filtered)
 			continue;
 
-		len = hist_entry__append_browser(h, self->tree, session_total);
+		len = hist_entry__append_browser(h, self->tree, hists->stats.total);
 		if (len > max_len)
 			max_len = len;
 		if (symbol_conf.use_callchain)
 			hist_entry__append_callchain_browser(h, self->tree,
-							     session_total, idx++);
+							     hists->stats.total, idx++);
 		++curr_hist;
 		if (curr_hist % 5)
 			ui_progress__update(progress, curr_hist);
@@ -490,57 +491,6 @@ static int hist_browser__populate(struct hist_browser *self, struct rb_root *his
 	return 0;
 }
 
-enum hist_filter {
-	HIST_FILTER__DSO,
-	HIST_FILTER__THREAD,
-};
-
-static u64 hists__filter_by_dso(struct rb_root *hists, const struct dso *dso,
-				u64 *session_total)
-{
-	struct rb_node *nd;
-	u64 nr_hists = 0;
-
-	*session_total = 0;
-
-	for (nd = rb_first(hists); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-
-		if (dso != NULL && (h->ms.map == NULL || h->ms.map->dso != dso)) {
-			h->filtered |= (1 << HIST_FILTER__DSO);
-			continue;
-		}
-		h->filtered &= ~(1 << HIST_FILTER__DSO);
-		++nr_hists;
-		*session_total += h->count;
-	}
-
-	return nr_hists;
-}
-
-static u64 hists__filter_by_thread(struct rb_root *hists, const struct thread *thread,
-				   u64 *session_total)
-{
-	struct rb_node *nd;
-	u64 nr_hists = 0;
-
-	*session_total = 0;
-
-	for (nd = rb_first(hists); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-
-		if (thread != NULL && h->thread != thread) {
-			h->filtered |= (1 << HIST_FILTER__THREAD);
-			continue;
-		}
-		h->filtered &= ~(1 << HIST_FILTER__THREAD);
-		++nr_hists;
-		*session_total += h->count;
-	}
-
-	return nr_hists;
-}
-
 static struct thread *hist_browser__selected_thread(struct hist_browser *self)
 {
 	int *indexes;
@@ -577,9 +527,7 @@ static int hist_browser__title(char *bf, size_t size, const char *input_name,
 	return printed ?: snprintf(bf, size, "Report: %s", input_name);
 }
 
-int perf_session__browse_hists(struct rb_root *hists, u64 nr_hists,
-			       u64 session_total, const char *helpline,
-			       const char *input_name)
+int hists__browse(struct hists *self, const char *helpline, const char *input_name)
 {
 	struct hist_browser *browser = hist_browser__new();
 	const struct thread *thread_filter = NULL;
@@ -595,7 +543,7 @@ int perf_session__browse_hists(struct rb_root *hists, u64 nr_hists,
 
 	hist_browser__title(msg, sizeof(msg), input_name,
 			    dso_filter, thread_filter);
-	if (hist_browser__populate(browser, hists, nr_hists, session_total, msg) < 0)
+	if (hist_browser__populate(browser, self, msg) < 0)
 		goto out;
 
 	while (1) {
@@ -672,10 +620,10 @@ do_annotate:
 				newtPushHelpLine(msg);
 				dso_filter = dso;
 			}
-			nr_hists = hists__filter_by_dso(hists, dso_filter, &session_total);
+			hists__filter_by_dso(self, dso_filter);
 			hist_browser__title(msg, sizeof(msg), input_name,
 					    dso_filter, thread_filter);
-			if (hist_browser__populate(browser, hists, nr_hists, session_total, msg) < 0)
+			if (hist_browser__populate(browser, self, msg) < 0)
 				goto out;
 		} else if (choice == zoom_thread) {
 			if (thread_filter) {
@@ -689,10 +637,10 @@ do_annotate:
 				newtPushHelpLine(msg);
 				thread_filter = thread;
 			}
-			nr_hists = hists__filter_by_thread(hists, thread_filter, &session_total);
+			hists__filter_by_thread(self, thread_filter);
 			hist_browser__title(msg, sizeof(msg), input_name,
 					    dso_filter, thread_filter);
-			if (hist_browser__populate(browser, hists, nr_hists, session_total, msg) < 0)
+			if (hist_browser__populate(browser, self, msg) < 0)
 				goto out;
 		}
 	}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 46190f9..ce00fa6 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -102,21 +102,6 @@ int perf_session__create_kernel_maps(struct perf_session *self);
 int do_read(int fd, void *buf, size_t size);
 void perf_session__update_sample_type(struct perf_session *self);
 
-#ifdef NO_NEWT_SUPPORT
-static inline int perf_session__browse_hists(struct rb_root *hists __used,
-					      u64 nr_hists __used,
-					      u64 session_total __used,
-					     const char *helpline __used,
-					     const char *input_name __used)
-{
-	return 0;
-}
-#else
-int perf_session__browse_hists(struct rb_root *hists, u64 nr_hists,
-			       u64 session_total, const char *helpline,
-			       const char *input_name);
-#endif
-
 static inline
 struct machine *perf_session__find_host_machine(struct perf_session *self)
 {
-- 
1.6.2.5

