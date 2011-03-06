Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1CFUsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 15:48:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1CFUsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 15:48:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, William Cohen <wcohen@redhat.com>
Subject: [PATCH 6/6] perf report tui: Improve multi event session support
Date: Sun,  6 Mar 2011 17:48:27 -0300
Message-Id: <1299444507-26549-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1299444507-26549-1-git-send-email-acme@infradead.org>
References: <1299444507-26549-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When multiple events were used in 'perf record', allow the user to
choose which one is wanted before showing the per event histograms.

Annotations will be performed on the chosen event.

Allow going back and forth from event to event quickly using just the
arrow keys and enter.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: William Cohen <wcohen@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c         |    7 +-
 tools/perf/util/hist.h              |   16 +---
 tools/perf/util/ui/browsers/hists.c |  147 +++++++++++++++++++++++++++++++----
 3 files changed, 140 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1c399ea..e9b5d51 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -222,7 +222,8 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	return ret + fprintf(fp, "\n#\n");
 }
 
-static int hists__tty_browse_tree(struct perf_evlist *evlist, const char *help)
+static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
+					 const char *help)
 {
 	struct perf_evsel *pos;
 
@@ -304,9 +305,9 @@ static int __cmd_report(void)
 	}
 
 	if (use_browser > 0)
-		hists__tui_browse_tree(session->evlist, help);
+		perf_evlist__tui_browse_hists(session->evlist, help);
 	else
-		hists__tty_browse_tree(session->evlist, help);
+		perf_evlist__tty_browse_hists(session->evlist, help);
 
 out_delete:
 	/*
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 0d38b43..cb6858a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -87,15 +87,9 @@ bool hists__new_col_len(struct hists *self, enum hist_column col, u16 len);
 struct perf_evlist;
 
 #ifdef NO_NEWT_SUPPORT
-static inline int hists__browse(struct hists *self __used,
-				const char *helpline __used,
-				const char *ev_name __used, int evidx __used)
-{
-	return 0;
-}
-
-static inline int hists__tui_browse_tree(struct perf_evlist *evlist __used,
-					 const char *help __used)
+static inline
+int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __used,
+				  const char *help __used)
 {
 	return 0;
 }
@@ -109,14 +103,12 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
 #define KEY_RIGHT -2
 #else
 #include <newt.h>
-int hists__browse(struct hists *self, const char *helpline,
-		  const char *ev_name, int evidx);
 int hist_entry__tui_annotate(struct hist_entry *self, int evidx);
 
 #define KEY_LEFT NEWT_KEY_LEFT
 #define KEY_RIGHT NEWT_KEY_RIGHT
 
-int hists__tui_browse_tree(struct perf_evlist *evlist, const char *help);
+int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help);
 #endif
 
 unsigned int hists__sort_list_width(struct hists *self);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index f3af4fe..798efdc 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -803,9 +803,11 @@ static int hists__browser_title(struct hists *self, char *bf, size_t size,
 	return printed;
 }
 
-int hists__browse(struct hists *self, const char *helpline,
-		  const char *ev_name, int evidx)
+static int perf_evsel__hists_browse(struct perf_evsel *evsel,
+				    const char *helpline, const char *ev_name,
+				    bool left_exits)
 {
+	struct hists *self = &evsel->hists;
 	struct hist_browser *browser = hist_browser__new(self);
 	struct pstack *fstack;
 	const struct thread *thread_filter = NULL;
@@ -878,8 +880,14 @@ int hists__browse(struct hists *self, const char *helpline,
 		case NEWT_KEY_LEFT: {
 			const void *top;
 
-			if (pstack__empty(fstack))
+			if (pstack__empty(fstack)) {
+				/*
+				 * Go back to the perf_evsel_menu__run or other user
+				 */
+				if (left_exits)
+					goto out_free_stack;
 				continue;
+			}
 			top = pstack__pop(fstack);
 			if (top == &dso_filter)
 				goto zoom_out_dso;
@@ -888,7 +896,8 @@ int hists__browse(struct hists *self, const char *helpline,
 			continue;
 		}
 		case NEWT_KEY_ESCAPE:
-			if (!ui__dialog_yesno("Do you really want to exit?"))
+			if (!left_exits &&
+			    !ui__dialog_yesno("Do you really want to exit?"))
 				continue;
 			/* Fall thru */
 		default:
@@ -940,7 +949,7 @@ do_annotate:
 			if (he == NULL)
 				continue;
 
-			hist_entry__tui_annotate(he, evidx);
+			hist_entry__tui_annotate(he, evsel->idx);
 		} else if (choice == browse_map)
 			map__browse(browser->selection->map);
 		else if (choice == zoom_dso) {
@@ -989,15 +998,71 @@ out:
 	return key;
 }
 
-int hists__tui_browse_tree(struct perf_evlist *evlist, const char *help)
+struct perf_evsel_menu {
+	struct ui_browser b;
+	struct perf_evsel *selection;
+};
+
+static void perf_evsel_menu__write(struct ui_browser *browser,
+				   void *entry, int row)
+{
+	struct perf_evsel_menu *menu = container_of(browser,
+						    struct perf_evsel_menu, b);
+	struct perf_evsel *evsel = list_entry(entry, struct perf_evsel, node);
+	bool current_entry = ui_browser__is_current_entry(browser, row);
+	unsigned long nr_events = evsel->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+	const char *ev_name = event_name(evsel);
+	char bf[256], unit;
+
+	ui_browser__set_color(browser, current_entry ? HE_COLORSET_SELECTED :
+						       HE_COLORSET_NORMAL);
+
+	nr_events = convert_unit(nr_events, &unit);
+	snprintf(bf, sizeof(bf), "%lu%c%s%s", nr_events,
+		 unit, unit == ' ' ? "" : " ", ev_name);
+	slsmg_write_nstring(bf, browser->width);
+
+	if (current_entry)
+		menu->selection = evsel;
+}
+
+static int perf_evsel_menu__run(struct perf_evsel_menu *menu, const char *help)
 {
+	int exit_keys[] = { NEWT_KEY_ENTER, NEWT_KEY_RIGHT, 0, };
+	struct perf_evlist *evlist = menu->b.priv;
 	struct perf_evsel *pos;
+	const char *ev_name, *title = "Available samples";
+	int key;
 
-	pos = list_entry(evlist->entries.next, struct perf_evsel, node);
-	while (pos) {
-		struct hists *hists = &pos->hists;
-		const char *ev_name = event_name(pos);
-		int key = hists__browse(hists, help, ev_name, pos->idx);
+	if (ui_browser__show(&menu->b, title,
+			     "ESC: exit, ENTER|->: Browse histograms") < 0)
+		return -1;
+
+	ui_browser__add_exit_keys(&menu->b, exit_keys);
+
+	while (1) {
+		key = ui_browser__run(&menu->b);
+
+		switch (key) {
+		case NEWT_KEY_RIGHT:
+		case NEWT_KEY_ENTER:
+			if (!menu->selection)
+				continue;
+			pos = menu->selection;
+browse_hists:
+			ev_name = event_name(pos);
+			key = perf_evsel__hists_browse(pos, help, ev_name, true);
+			ui_browser__show_title(&menu->b, title);
+			break;
+		case NEWT_KEY_LEFT:
+			continue;
+		case NEWT_KEY_ESCAPE:
+			if (!ui__dialog_yesno("Do you really want to exit?"))
+				continue;
+			/* Fall thru */
+		default:
+			goto out;
+		}
 
 		switch (key) {
 		case NEWT_KEY_TAB:
@@ -1005,17 +1070,69 @@ int hists__tui_browse_tree(struct perf_evlist *evlist, const char *help)
 				pos = list_entry(evlist->entries.next, struct perf_evsel, node);
 			else
 				pos = list_entry(pos->node.next, struct perf_evsel, node);
-			break;
+			goto browse_hists;
 		case NEWT_KEY_UNTAB:
 			if (pos->node.prev == &evlist->entries)
 				pos = list_entry(evlist->entries.prev, struct perf_evsel, node);
 			else
 				pos = list_entry(pos->node.prev, struct perf_evsel, node);
-			break;
+			goto browse_hists;
+		case 'q':
+		case CTRL('c'):
+			goto out;
 		default:
-			return key;
+			break;
 		}
 	}
 
-	return 0;
+out:
+	ui_browser__hide(&menu->b);
+	return key;
+}
+
+static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
+					   const char *help)
+{
+	struct perf_evsel *pos;
+	struct perf_evsel_menu menu = {
+		.b = {
+			.entries    = &evlist->entries,
+			.refresh    = ui_browser__list_head_refresh,
+			.seek	    = ui_browser__list_head_seek,
+			.write	    = perf_evsel_menu__write,
+			.nr_entries = evlist->nr_entries,
+			.priv	    = evlist,
+		},
+	};
+
+	ui_helpline__push("Press ESC to exit");
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		const char *ev_name = event_name(pos);
+		size_t line_len = strlen(ev_name) + 7;
+
+		if (menu.b.width < line_len)
+			menu.b.width = line_len;
+		/*
+		 * Cache the evsel name, tracepoints have a _high_ cost per
+		 * event_name() call.
+		 */
+		if (pos->name == NULL)
+			pos->name = strdup(ev_name);
+	}
+
+	return perf_evsel_menu__run(&menu, help);
+}
+
+int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help)
+{
+
+	if (evlist->nr_entries == 1) {
+		struct perf_evsel *first = list_entry(evlist->entries.next,
+						      struct perf_evsel, node);
+		const char *ev_name = event_name(first);
+		return perf_evsel__hists_browse(first, help, ev_name, false);
+	}
+
+	return __perf_evlist__tui_browse_hists(evlist, help);
 }
-- 
1.6.2.5

