Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab1JFRYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:24:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50063 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758776Ab1JFRWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/15] perf browsers: Add live mode to the hists, annotate browsers
Date: Thu,  6 Oct 2011 14:22:28 -0300
Message-Id: <1317921758-4154-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This allows passing a timer to be run periodically, which will update
the hists tree that then gers refreshed on the screen, just like the
Live mode (symbol entries, annotation) we already have in 'perf top
--tui'.

Will be used by the new hist_entry/hists based 'top' tool.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2r44qd8oe4sagzcgoikl8qzc@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c          |    2 +-
 tools/perf/builtin-report.c            |    7 +-
 tools/perf/util/annotate.h             |    7 ++-
 tools/perf/util/evlist.c               |    6 ++
 tools/perf/util/evlist.h               |    4 +
 tools/perf/util/hist.h                 |   14 +++-
 tools/perf/util/ui/browsers/annotate.c |   25 +++++---
 tools/perf/util/ui/browsers/hists.c    |  105 +++++++++++++++++++++-----------
 tools/perf/util/ui/browsers/top.c      |    2 +-
 9 files changed, 116 insertions(+), 56 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index cf68819..39e3d38 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -137,7 +137,7 @@ find_next:
 		}
 
 		if (use_browser > 0) {
-			key = hist_entry__tui_annotate(he, evidx);
+			key = hist_entry__tui_annotate(he, evidx, NULL, NULL, 0);
 			switch (key) {
 			case KEY_RIGHT:
 				next = rb_next(nd);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c1cc7ab..e7140c6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -327,9 +327,10 @@ static int __cmd_report(void)
 		goto out_delete;
 	}
 
-	if (use_browser > 0)
-		perf_evlist__tui_browse_hists(session->evlist, help);
-	else
+	if (use_browser > 0) {
+		perf_evlist__tui_browse_hists(session->evlist, help,
+					      NULL, NULL, 0);
+	} else
 		perf_evlist__tty_browse_hists(session->evlist, help);
 
 out_delete:
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 6ede128..aafbc7e 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -91,13 +91,16 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 #ifdef NO_NEWT_SUPPORT
 static inline int symbol__tui_annotate(struct symbol *sym __used,
 				       struct map *map __used,
-				       int evidx __used, int refresh __used)
+				       int evidx __used,
+				       void(*timer)(void *arg) __used,
+				       void *arg __used, int delay_secs __used)
 {
 	return 0;
 }
 #else
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
-			 int refresh);
+			 void(*timer)(void *arg), void *arg,
+			 int delay_secs);
 #endif
 
 extern const char	*disassembler_style;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index c12bd47..dbc8e48 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -520,3 +520,9 @@ bool perf_evlist__sample_id_all(const struct perf_evlist *evlist)
 	first = list_entry(evlist->entries.next, struct perf_evsel, node);
 	return first->attr.sample_id_all;
 }
+
+void perf_evlist__set_selected(struct perf_evlist *evlist,
+			       struct perf_evsel *evsel)
+{
+	evlist->selected = evsel;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index ce85ae9..c4f32f3 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -25,6 +25,7 @@ struct perf_evlist {
 	struct pollfd	 *pollfd;
 	struct thread_map *threads;
 	struct cpu_map	  *cpus;
+	struct perf_evsel *selected;
 };
 
 struct perf_evsel;
@@ -55,6 +56,9 @@ void perf_evlist__munmap(struct perf_evlist *evlist);
 
 void perf_evlist__disable(struct perf_evlist *evlist);
 
+void perf_evlist__set_selected(struct perf_evlist *evlist,
+			       struct perf_evsel *evsel);
+
 static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 					 struct cpu_map *cpus,
 					 struct thread_map *threads)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d3f976c..424f9eb 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -100,13 +100,16 @@ struct perf_evlist;
 #ifdef NO_NEWT_SUPPORT
 static inline
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __used,
-				  const char *help __used)
+				  const char *help __used, void(*timer)(void *arg) __used, void *arg,
+				  int refresh __used)
 {
 	return 0;
 }
 
 static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
-					   int evidx __used)
+					   int evidx __used,
+					   void(*timer)(void *arg) __used,
+					   void *arg __used, int delay_secs __used);
 {
 	return 0;
 }
@@ -114,12 +117,15 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
 #define KEY_RIGHT -2
 #else
 #include <newt.h>
-int hist_entry__tui_annotate(struct hist_entry *self, int evidx);
+int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
+			     void(*timer)(void *arg), void *arg, int delay_secs);
 
 #define KEY_LEFT NEWT_KEY_LEFT
 #define KEY_RIGHT NEWT_KEY_RIGHT
 
-int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help);
+int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
+				  void(*timer)(void *arg), void *arg,
+				  int refresh);
 #endif
 
 unsigned int hists__sort_list_width(struct hists *self);
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 0229723..76c1d08 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -164,7 +164,8 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 }
 
 static int annotate_browser__run(struct annotate_browser *self, int evidx,
-				 int refresh)
+				 void(*timer)(void *arg) __used, void *arg __used,
+				 int delay_secs)
 {
 	struct rb_node *nd = NULL;
 	struct symbol *sym = self->b.priv;
@@ -189,13 +190,13 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 
 	nd = self->curr_hot;
 
-	if (refresh != 0)
-		newtFormSetTimer(self->b.form, refresh);
+	if (delay_secs != 0)
+		newtFormSetTimer(self->b.form, delay_secs * 1000);
 
 	while (1) {
 		key = ui_browser__run(&self->b);
 
-		if (refresh != 0) {
+		if (delay_secs != 0) {
 			annotate_browser__calc_percent(self, evidx);
 			/*
 			 * Current line focus got out of the list of most active
@@ -212,7 +213,10 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
  			 * FIXME we need to check if it was
  			 * es.reason == NEWT_EXIT_TIMER
  			 */
-			if (refresh != 0)
+			if (timer != NULL)
+				timer(arg);
+
+			if (delay_secs != 0)
 				symbol__annotate_decay_histogram(sym, evidx);
 			continue;
 		case NEWT_KEY_TAB:
@@ -246,13 +250,16 @@ out:
 	return key;
 }
 
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx)
+int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
+			     void(*timer)(void *arg), void *arg, int delay_secs)
 {
-	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx, 0);
+	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx,
+				    timer, arg, delay_secs);
 }
 
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
-			 int refresh)
+			void(*timer)(void *arg), void *arg,
+			int delay_secs)
 {
 	struct objdump_line *pos, *n;
 	struct annotation *notes;
@@ -293,7 +300,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
-	ret = annotate_browser__run(&browser, evidx, refresh);
+	ret = annotate_browser__run(&browser, evidx, timer, arg, delay_secs);
 	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
 		list_del(&pos->node);
 		objdump_line__free(pos);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 5d767c6..6244d19 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -24,8 +24,14 @@ struct hist_browser {
 	struct hists	    *hists;
 	struct hist_entry   *he_selection;
 	struct map_symbol   *selection;
+	const struct thread *thread_filter;
+	const struct dso    *dso_filter;
 };
 
+static int hists__browser_title(struct hists *self, char *bf, size_t size,
+				const char *ev_name, const struct dso *dso,
+				const struct thread *thread);
+
 static void hist_browser__refresh_dimensions(struct hist_browser *self)
 {
 	/* 3 == +/- toggle symbol before actual hist_entry rendering */
@@ -290,9 +296,12 @@ static void hist_browser__set_folding(struct hist_browser *self, bool unfold)
 	ui_browser__reset_index(&self->b);
 }
 
-static int hist_browser__run(struct hist_browser *self, const char *title)
+static int hist_browser__run(struct hist_browser *self, const char *ev_name,
+			     void(*timer)(void *arg), void *arg, int delay_secs)
 {
 	int key;
+	int delay_msecs = delay_secs * 1000;
+	char title[160];
 	int exit_keys[] = { 'a', '?', 'h', 'C', 'd', 'D', 'E', 't',
 			    NEWT_KEY_ENTER, NEWT_KEY_RIGHT, NEWT_KEY_LEFT,
 			    NEWT_KEY_TAB, NEWT_KEY_UNTAB, 0, };
@@ -301,17 +310,30 @@ static int hist_browser__run(struct hist_browser *self, const char *title)
 	self->b.nr_entries = self->hists->nr_entries;
 
 	hist_browser__refresh_dimensions(self);
+	hists__browser_title(self->hists, title, sizeof(title), ev_name,
+			     self->dso_filter, self->thread_filter);
 
 	if (ui_browser__show(&self->b, title,
 			     "Press '?' for help on key bindings") < 0)
 		return -1;
 
+	if (timer != NULL)
+		newtFormSetTimer(self->b.form, delay_msecs);
+
 	ui_browser__add_exit_keys(&self->b, exit_keys);
 
 	while (1) {
 		key = ui_browser__run(&self->b);
 
 		switch (key) {
+		case -1:
+			/* FIXME we need to check if it was es.reason == NEWT_EXIT_TIMER */
+			timer(arg);
+			hists__browser_title(self->hists, title, sizeof(title),
+					     ev_name, self->dso_filter,
+					     self->thread_filter);
+			ui_browser__show_title(&self->b, title);
+			continue;
 		case 'D': { /* Debug */
 			static int seq;
 			struct hist_entry *h = rb_entry(self->b.top,
@@ -805,14 +827,13 @@ static int hists__browser_title(struct hists *self, char *bf, size_t size,
 
 static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 				    const char *helpline, const char *ev_name,
-				    bool left_exits)
+				    bool left_exits,
+				    void(*timer)(void *arg), void *arg,
+				    int delay_secs)
 {
 	struct hists *self = &evsel->hists;
 	struct hist_browser *browser = hist_browser__new(self);
 	struct pstack *fstack;
-	const struct thread *thread_filter = NULL;
-	const struct dso *dso_filter = NULL;
-	char msg[160];
 	int key = -1;
 
 	if (browser == NULL)
@@ -824,8 +845,6 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 
 	ui_helpline__push(helpline);
 
-	hists__browser_title(self, msg, sizeof(msg), ev_name,
-			     dso_filter, thread_filter);
 	while (1) {
 		const struct thread *thread = NULL;
 		const struct dso *dso = NULL;
@@ -834,7 +853,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
 		    browse_map = -2;
 
-		key = hist_browser__run(browser, msg);
+		key = hist_browser__run(browser, ev_name, timer, arg, delay_secs);
 
 		if (browser->he_selection != NULL) {
 			thread = hist_browser__selected_thread(browser);
@@ -889,9 +908,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 				continue;
 			}
 			top = pstack__pop(fstack);
-			if (top == &dso_filter)
+			if (top == &browser->dso_filter)
 				goto zoom_out_dso;
-			if (top == &thread_filter)
+			if (top == &browser->thread_filter)
 				goto zoom_out_thread;
 			continue;
 		}
@@ -913,14 +932,14 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 
 		if (thread != NULL &&
 		    asprintf(&options[nr_options], "Zoom %s %s(%d) thread",
-			     (thread_filter ? "out of" : "into"),
+			     (browser->thread_filter ? "out of" : "into"),
 			     (thread->comm_set ? thread->comm : ""),
 			     thread->pid) > 0)
 			zoom_thread = nr_options++;
 
 		if (dso != NULL &&
 		    asprintf(&options[nr_options], "Zoom %s %s DSO",
-			     (dso_filter ? "out of" : "into"),
+			     (browser->dso_filter ? "out of" : "into"),
 			     (dso->kernel ? "the Kernel" : dso->short_name)) > 0)
 			zoom_dso = nr_options++;
 
@@ -949,45 +968,42 @@ do_annotate:
 			if (he == NULL)
 				continue;
 
-			hist_entry__tui_annotate(he, evsel->idx);
+			hist_entry__tui_annotate(he, evsel->idx,
+						 timer, arg, delay_secs);
 		} else if (choice == browse_map)
 			map__browse(browser->selection->map);
 		else if (choice == zoom_dso) {
 zoom_dso:
-			if (dso_filter) {
-				pstack__remove(fstack, &dso_filter);
+			if (browser->dso_filter) {
+				pstack__remove(fstack, &browser->dso_filter);
 zoom_out_dso:
 				ui_helpline__pop();
-				dso_filter = NULL;
+				browser->dso_filter = NULL;
 			} else {
 				if (dso == NULL)
 					continue;
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s DSO\"",
 						   dso->kernel ? "the Kernel" : dso->short_name);
-				dso_filter = dso;
-				pstack__push(fstack, &dso_filter);
+				browser->dso_filter = dso;
+				pstack__push(fstack, &browser->dso_filter);
 			}
-			hists__filter_by_dso(self, dso_filter);
-			hists__browser_title(self, msg, sizeof(msg), ev_name,
-					     dso_filter, thread_filter);
+			hists__filter_by_dso(self, browser->dso_filter);
 			hist_browser__reset(browser);
 		} else if (choice == zoom_thread) {
 zoom_thread:
-			if (thread_filter) {
-				pstack__remove(fstack, &thread_filter);
+			if (browser->thread_filter) {
+				pstack__remove(fstack, &browser->thread_filter);
 zoom_out_thread:
 				ui_helpline__pop();
-				thread_filter = NULL;
+				browser->thread_filter = NULL;
 			} else {
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s(%d) thread\"",
 						   thread->comm_set ? thread->comm : "",
 						   thread->pid);
-				thread_filter = thread;
-				pstack__push(fstack, &thread_filter);
+				browser->thread_filter = thread;
+				pstack__push(fstack, &browser->thread_filter);
 			}
-			hists__filter_by_thread(self, thread_filter);
-			hists__browser_title(self, msg, sizeof(msg), ev_name,
-					     dso_filter, thread_filter);
+			hists__filter_by_thread(self, browser->thread_filter);
 			hist_browser__reset(browser);
 		}
 	}
@@ -1026,9 +1042,11 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 		menu->selection = evsel;
 }
 
-static int perf_evsel_menu__run(struct perf_evsel_menu *menu, const char *help)
+static int perf_evsel_menu__run(struct perf_evsel_menu *menu, const char *help,
+				void(*timer)(void *arg), void *arg, int delay_secs)
 {
 	int exit_keys[] = { NEWT_KEY_ENTER, NEWT_KEY_RIGHT, 0, };
+	int delay_msecs = delay_secs * 1000;
 	struct perf_evlist *evlist = menu->b.priv;
 	struct perf_evsel *pos;
 	const char *ev_name, *title = "Available samples";
@@ -1038,20 +1056,29 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu, const char *help)
 			     "ESC: exit, ENTER|->: Browse histograms") < 0)
 		return -1;
 
+	if (timer != NULL)
+		newtFormSetTimer(menu->b.form, delay_msecs);
+
 	ui_browser__add_exit_keys(&menu->b, exit_keys);
 
 	while (1) {
 		key = ui_browser__run(&menu->b);
 
 		switch (key) {
+		case -1:
+			/* FIXME we need to check if it was es.reason == NEWT_EXIT_TIMER */
+			timer(arg);
+			continue;
 		case NEWT_KEY_RIGHT:
 		case NEWT_KEY_ENTER:
 			if (!menu->selection)
 				continue;
 			pos = menu->selection;
+			perf_evlist__set_selected(evlist, pos);
 browse_hists:
 			ev_name = event_name(pos);
-			key = perf_evsel__hists_browse(pos, help, ev_name, true);
+			key = perf_evsel__hists_browse(pos, help, ev_name, true,
+						       timer, arg, delay_secs);
 			ui_browser__show_title(&menu->b, title);
 			break;
 		case NEWT_KEY_LEFT:
@@ -1091,7 +1118,9 @@ out:
 }
 
 static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
-					   const char *help)
+					   const char *help,
+					   void(*timer)(void *arg), void *arg,
+					   int delay_secs)
 {
 	struct perf_evsel *pos;
 	struct perf_evsel_menu menu = {
@@ -1121,18 +1150,22 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			pos->name = strdup(ev_name);
 	}
 
-	return perf_evsel_menu__run(&menu, help);
+	return perf_evsel_menu__run(&menu, help, timer, arg, delay_secs);
 }
 
-int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help)
+int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
+				  void(*timer)(void *arg), void *arg,
+				  int delay_secs)
 {
 
 	if (evlist->nr_entries == 1) {
 		struct perf_evsel *first = list_entry(evlist->entries.next,
 						      struct perf_evsel, node);
 		const char *ev_name = event_name(first);
-		return perf_evsel__hists_browse(first, help, ev_name, false);
+		return perf_evsel__hists_browse(first, help, ev_name, false,
+						timer, arg, delay_secs);
 	}
 
-	return __perf_evlist__tui_browse_hists(evlist, help);
+	return __perf_evlist__tui_browse_hists(evlist, help,
+					       timer, arg, delay_secs);
 }
diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
index 9b6b43b..d43875b 100644
--- a/tools/perf/util/ui/browsers/top.c
+++ b/tools/perf/util/ui/browsers/top.c
@@ -142,7 +142,7 @@ static void perf_top_browser__annotate(struct perf_top_browser *browser)
 
 	pthread_mutex_unlock(&notes->lock);
 do_annotation:
-	symbol__tui_annotate(sym, syme->map, 0, top->delay_secs * 1000);
+	symbol__tui_annotate(sym, syme->map, 0, NULL, NULL, top->delay_secs * 1000);
 }
 
 static void perf_top_browser__warn_lost(struct perf_top_browser *browser)
-- 
1.6.2.5

