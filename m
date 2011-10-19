Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1JSSZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:25:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42619 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1JSSXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:23:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/7] perf hists: Move the dso and thread filters from hist_browser
Date: Wed, 19 Oct 2011 16:23:32 -0200
Message-Id: <1319048618-9790-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319048618-9790-1-git-send-email-acme@infradead.org>
References: <1319048618-9790-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since with dynamic addition of new hist entries we need to apply those
filters as we merge new batches of hist_entry instances, for instance in
perf top.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-zjhhf8kh9w1buty9p10od6rz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c              |   10 ++++---
 tools/perf/util/hist.h              |    9 +++++-
 tools/perf/util/ui/browsers/hists.c |   48 ++++++++++++++++-------------------
 3 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 8d15e9f..fdff2a8 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1087,7 +1087,7 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 	hists__calc_col_len(hists, h);
 }
 
-void hists__filter_by_dso(struct hists *hists, const struct dso *dso)
+void hists__filter_by_dso(struct hists *hists)
 {
 	struct rb_node *nd;
 
@@ -1101,7 +1101,8 @@ void hists__filter_by_dso(struct hists *hists, const struct dso *dso)
 		if (symbol_conf.exclude_other && !h->parent)
 			continue;
 
-		if (dso != NULL && (h->ms.map == NULL || h->ms.map->dso != dso)) {
+		if (hists->dso_filter != NULL &&
+		    (h->ms.map == NULL || h->ms.map->dso != hists->dso_filter)) {
 			h->filtered |= (1 << HIST_FILTER__DSO);
 			continue;
 		}
@@ -1110,7 +1111,7 @@ void hists__filter_by_dso(struct hists *hists, const struct dso *dso)
 	}
 }
 
-void hists__filter_by_thread(struct hists *hists, const struct thread *thread)
+void hists__filter_by_thread(struct hists *hists)
 {
 	struct rb_node *nd;
 
@@ -1121,7 +1122,8 @@ void hists__filter_by_thread(struct hists *hists, const struct thread *thread)
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
-		if (thread != NULL && h->thread != thread) {
+		if (hists->thread_filter != NULL &&
+		    h->thread != hists->thread_filter) {
 			h->filtered |= (1 << HIST_FILTER__THREAD);
 			continue;
 		}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index f338cb0..575bcbc 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -43,12 +43,17 @@ enum hist_column {
 	HISTC_NR_COLS, /* Last entry */
 };
 
+struct thread;
+struct dso;
+
 struct hists {
 	struct rb_root		entries_in_array[2];
 	struct rb_root		*entries_in;
 	struct rb_root		entries;
 	struct rb_root		entries_collapsed;
 	u64			nr_entries;
+	const struct thread	*thread_filter;
+	const struct dso	*dso_filter;
 	pthread_mutex_t		lock;
 	struct events_stats	stats;
 	u64			event_stream;
@@ -91,8 +96,8 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 int hist_entry__inc_addr_samples(struct hist_entry *self, int evidx, u64 addr);
 int hist_entry__annotate(struct hist_entry *self, size_t privsize);
 
-void hists__filter_by_dso(struct hists *self, const struct dso *dso);
-void hists__filter_by_thread(struct hists *self, const struct thread *thread);
+void hists__filter_by_dso(struct hists *hists);
+void hists__filter_by_thread(struct hists *hists);
 
 u16 hists__col_len(struct hists *self, enum hist_column col);
 void hists__set_col_len(struct hists *self, enum hist_column col, u16 len);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 936e641..94e1ab0 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -24,14 +24,11 @@ struct hist_browser {
 	struct hists	    *hists;
 	struct hist_entry   *he_selection;
 	struct map_symbol   *selection;
-	const struct thread *thread_filter;
-	const struct dso    *dso_filter;
 	bool		     has_symbols;
 };
 
 static int hists__browser_title(struct hists *self, char *bf, size_t size,
-				const char *ev_name, const struct dso *dso,
-				const struct thread *thread);
+				const char *ev_name);
 
 static void hist_browser__refresh_dimensions(struct hist_browser *self)
 {
@@ -307,8 +304,7 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 	self->b.nr_entries = self->hists->nr_entries;
 
 	hist_browser__refresh_dimensions(self);
-	hists__browser_title(self->hists, title, sizeof(title), ev_name,
-			     self->dso_filter, self->thread_filter);
+	hists__browser_title(self->hists, title, sizeof(title), ev_name);
 
 	if (ui_browser__show(&self->b, title,
 			     "Press '?' for help on key bindings") < 0)
@@ -323,8 +319,7 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 			timer(arg);
 			ui_browser__update_nr_entries(&self->b, self->hists->nr_entries);
 			hists__browser_title(self->hists, title, sizeof(title),
-					     ev_name, self->dso_filter,
-					     self->thread_filter);
+					     ev_name);
 			ui_browser__show_title(&self->b, title);
 			continue;
 		case 'D': { /* Debug */
@@ -809,11 +804,12 @@ static struct thread *hist_browser__selected_thread(struct hist_browser *self)
 }
 
 static int hists__browser_title(struct hists *self, char *bf, size_t size,
-				const char *ev_name, const struct dso *dso,
-				const struct thread *thread)
+				const char *ev_name)
 {
 	char unit;
 	int printed;
+	const struct dso *dso = self->dso_filter;
+	const struct thread *thread = self->thread_filter;
 	unsigned long nr_events = self->stats.nr_events[PERF_RECORD_SAMPLE];
 
 	nr_events = convert_unit(nr_events, &unit);
@@ -917,9 +913,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				continue;
 			}
 			top = pstack__pop(fstack);
-			if (top == &browser->dso_filter)
+			if (top == &browser->hists->dso_filter)
 				goto zoom_out_dso;
-			if (top == &browser->thread_filter)
+			if (top == &browser->hists->thread_filter)
 				goto zoom_out_thread;
 			continue;
 		}
@@ -947,14 +943,14 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 		if (thread != NULL &&
 		    asprintf(&options[nr_options], "Zoom %s %s(%d) thread",
-			     (browser->thread_filter ? "out of" : "into"),
+			     (browser->hists->thread_filter ? "out of" : "into"),
 			     (thread->comm_set ? thread->comm : ""),
 			     thread->pid) > 0)
 			zoom_thread = nr_options++;
 
 		if (dso != NULL &&
 		    asprintf(&options[nr_options], "Zoom %s %s DSO",
-			     (browser->dso_filter ? "out of" : "into"),
+			     (browser->hists->dso_filter ? "out of" : "into"),
 			     (dso->kernel ? "the Kernel" : dso->short_name)) > 0)
 			zoom_dso = nr_options++;
 
@@ -994,36 +990,36 @@ do_annotate:
 			map__browse(browser->selection->map);
 		else if (choice == zoom_dso) {
 zoom_dso:
-			if (browser->dso_filter) {
-				pstack__remove(fstack, &browser->dso_filter);
+			if (browser->hists->dso_filter) {
+				pstack__remove(fstack, &browser->hists->dso_filter);
 zoom_out_dso:
 				ui_helpline__pop();
-				browser->dso_filter = NULL;
+				browser->hists->dso_filter = NULL;
 			} else {
 				if (dso == NULL)
 					continue;
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s DSO\"",
 						   dso->kernel ? "the Kernel" : dso->short_name);
-				browser->dso_filter = dso;
-				pstack__push(fstack, &browser->dso_filter);
+				browser->hists->dso_filter = dso;
+				pstack__push(fstack, &browser->hists->dso_filter);
 			}
-			hists__filter_by_dso(self, browser->dso_filter);
+			hists__filter_by_dso(self);
 			hist_browser__reset(browser);
 		} else if (choice == zoom_thread) {
 zoom_thread:
-			if (browser->thread_filter) {
-				pstack__remove(fstack, &browser->thread_filter);
+			if (browser->hists->thread_filter) {
+				pstack__remove(fstack, &browser->hists->thread_filter);
 zoom_out_thread:
 				ui_helpline__pop();
-				browser->thread_filter = NULL;
+				browser->hists->thread_filter = NULL;
 			} else {
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s(%d) thread\"",
 						   thread->comm_set ? thread->comm : "",
 						   thread->pid);
-				browser->thread_filter = thread;
-				pstack__push(fstack, &browser->thread_filter);
+				browser->hists->thread_filter = thread;
+				pstack__push(fstack, &browser->hists->thread_filter);
 			}
-			hists__filter_by_thread(self, browser->thread_filter);
+			hists__filter_by_thread(self);
 			hist_browser__reset(browser);
 		}
 	}
-- 
1.6.2.5

