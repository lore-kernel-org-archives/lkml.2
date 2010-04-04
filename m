Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab0DDBlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 21:41:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57100 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab0DDBlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 21:41:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Avi Kivity <avi@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf TUI: Add a "Zoom into COMM(PID) thread" and reverse operations
Date: Sat,  3 Apr 2010 22:40:50 -0300
Message-Id: <1270345250-4833-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1270345250-4833-1-git-send-email-acme@infradead.org>
References: <1270345250-4833-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now one can press the right arrow key and in addition to being able to
filter by DSO, filter out by thread too, or a combination of both
filters.

With this one can start collecting events for the whole system, then
focus on a subset of the collected data quickly.

Cc: Avi Kivity <avi@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   82 +++++++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/sort.h |    9 ++++-
 2 files changed, 81 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index bbf725d..6d6e022 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -490,6 +490,11 @@ static int hist_browser__populate(struct hist_browser *self, struct rb_root *his
 	return 0;
 }
 
+enum hist_filter {
+	HIST_FILTER__DSO,
+	HIST_FILTER__THREAD,
+};
+
 static u64 hists__filter_by_dso(struct rb_root *hists, struct dso *dso,
 				u64 *session_total)
 {
@@ -502,10 +507,10 @@ static u64 hists__filter_by_dso(struct rb_root *hists, struct dso *dso,
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (dso != NULL && (h->ms.map == NULL || h->ms.map->dso != dso)) {
-			h->filtered = true;
+			h->filtered |= (1 << HIST_FILTER__DSO);
 			continue;
 		}
-		h->filtered = false;
+		h->filtered &= ~(1 << HIST_FILTER__DSO);
 		++nr_hists;
 		*session_total += h->count;
 	}
@@ -513,12 +518,54 @@ static u64 hists__filter_by_dso(struct rb_root *hists, struct dso *dso,
 	return nr_hists;
 }
 
+static u64 hists__filter_by_thread(struct rb_root *hists, const struct thread *thread,
+				   u64 *session_total)
+{
+	struct rb_node *nd;
+	u64 nr_hists = 0;
+
+	*session_total = 0;
+
+	for (nd = rb_first(hists); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (thread != NULL && h->thread != thread) {
+			h->filtered |= (1 << HIST_FILTER__THREAD);
+			continue;
+		}
+		h->filtered &= ~(1 << HIST_FILTER__THREAD);
+		++nr_hists;
+		*session_total += h->count;
+	}
+
+	return nr_hists;
+}
+
+static struct thread *hist_browser__selected_thread(struct hist_browser *self)
+{
+	int *indexes;
+
+	if (!symbol_conf.use_callchain)
+		goto out;
+
+	indexes = newtCheckboxTreeFindItem(self->tree, (void *)self->selection);
+	if (indexes) {
+		bool is_hist_entry = indexes[1] == NEWT_ARG_LAST;
+		free(indexes);
+		if (is_hist_entry)
+			goto out;
+	}
+	return NULL;
+out:
+	return *(struct thread **)(self->selection + 1);
+}
+
 int perf_session__browse_hists(struct rb_root *hists, u64 nr_hists,
 			       u64 session_total, const char *helpline,
 			       const char *input_name)
 {
 	struct newtExitStruct es;
-	bool dso_filtered = false;
+	bool dso_filtered = false, thread_filtered = false;
 	int err = -1;
 	struct hist_browser *browser = hist_browser__new();
 
@@ -531,9 +578,10 @@ int perf_session__browse_hists(struct rb_root *hists, u64 nr_hists,
 		goto out;
 
 	while (1) {
+		const struct thread *thread;
 		char *options[16];
 		int nr_options = 0, choice = 0, i,
-		    annotate = -2, zoom_dso = -2;
+		    annotate = -2, zoom_dso = -2, zoom_thread = -2;
 
 		newtFormRun(browser->form, &es);
 		if (es.reason == NEWT_EXIT_HOTKEY) {
@@ -561,6 +609,13 @@ int perf_session__browse_hists(struct rb_root *hists, u64 nr_hists,
 			      browser->selection->map->dso->short_name)) > 0)
 			zoom_dso = nr_options++;
 
+		thread = hist_browser__selected_thread(browser);
+		if (thread != NULL &&
+		    asprintf(&options[nr_options], "Zoom %s %s(%d) thread",
+			     (thread_filtered ? "out of" : "into"),
+			     (thread->comm_set ?  thread->comm : ""), thread->pid) > 0)
+			zoom_thread = nr_options++;
+
 		options[nr_options++] = (char *)"Exit";
 
 		choice = popup_menu(nr_options, options);
@@ -570,6 +625,9 @@ int perf_session__browse_hists(struct rb_root *hists, u64 nr_hists,
 
 		if (choice == nr_options - 1)
 			break;
+
+		if (choice == -1)
+			continue;
 do_annotate:
 		if (choice == annotate) {
 			if (browser->selection->map->dso->origin == DSO__ORIG_KERNEL) {
@@ -581,13 +639,21 @@ do_annotate:
 			}
 			map_symbol__annotate_browser(browser->selection,
 						     input_name);
-		} if (choice == zoom_dso) {
-			hists__filter_by_dso(hists,
-					     dso_filtered ? NULL : browser->selection->map->dso,
-					     &session_total);
+		} else if (choice == zoom_dso) {
+			nr_hists = hists__filter_by_dso(hists,
+							(dso_filtered ? NULL :
+							 browser->selection->map->dso),
+							&session_total);
 			dso_filtered = !dso_filtered;
 			if (hist_browser__populate(browser, hists, nr_hists, session_total) < 0)
 				goto out;
+		} else if (choice == zoom_thread) {
+			nr_hists = hists__filter_by_thread(hists,
+							   (thread_filtered ? NULL : thread),
+							   &session_total);
+			thread_filtered = !thread_filtered;
+			if (hist_browser__populate(browser, hists, nr_hists, session_total) < 0)
+				goto out;
 		}
 	}
 	err = 0;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index dce79d3..2046ab7 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -44,11 +44,16 @@ extern enum sort_type sort__first_dimension;
 struct hist_entry {
 	struct rb_node		rb_node;
 	u64			count;
-	struct thread		*thread;
+	/*
+	 * XXX WARNING!
+	 * thread _has_ to come after ms, see
+	 * map_symbol__thread in util/newt.c
+	 */
 	struct map_symbol	ms;
+	struct thread		*thread;
 	u64			ip;
 	char			level;
-	bool			filtered;
+	u8			filtered;
 	struct symbol		*parent;
 	union {
 		unsigned long	  position;
-- 
1.6.2.5

