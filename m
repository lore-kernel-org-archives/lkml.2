Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab1JFRYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:24:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50171 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758784Ab1JFRWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/15] perf annotate browser: Allow navigation to called functions
Date: Thu,  6 Oct 2011 14:22:31 -0300
Message-Id: <1317921758-4154-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

I.e. when in the annotate TUI window, if Enter is pressed over an
assembly line with a 'callq' it will try to open another TUI window with
that symbol.

This is just a proof of concept and works only on x86_64, more work is
needed to support kernel modules, userland, other arches, etc, but
should already be useful as-is.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-opyvskw5na3qdmkv8vxi3zbr@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c          |    9 +++-
 tools/perf/util/annotate.h             |    2 +-
 tools/perf/util/hist.h                 |    4 +-
 tools/perf/util/ui/browsers/annotate.c |   69 ++++++++++++++++++++++++++-----
 tools/perf/util/ui/browsers/hists.c    |   20 ++++++----
 5 files changed, 79 insertions(+), 25 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 39e3d38..24db9d2 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -114,7 +114,8 @@ static int hist_entry__tty_annotate(struct hist_entry *he, int evidx)
 				    print_line, full_paths, 0, 0);
 }
 
-static void hists__find_annotations(struct hists *self, int evidx)
+static void hists__find_annotations(struct hists *self, int evidx,
+				    int nr_events)
 {
 	struct rb_node *nd = rb_first(&self->entries), *next;
 	int key = KEY_RIGHT;
@@ -137,7 +138,8 @@ find_next:
 		}
 
 		if (use_browser > 0) {
-			key = hist_entry__tui_annotate(he, evidx, NULL, NULL, 0);
+			key = hist_entry__tui_annotate(he, evidx, nr_events,
+						       NULL, NULL, 0);
 			switch (key) {
 			case KEY_RIGHT:
 				next = rb_next(nd);
@@ -215,7 +217,8 @@ static int __cmd_annotate(void)
 			total_nr_samples += nr_samples;
 			hists__collapse_resort(hists);
 			hists__output_resort(hists);
-			hists__find_annotations(hists, pos->idx);
+			hists__find_annotations(hists, pos->idx,
+						session->evlist->nr_entries);
 		}
 	}
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index aafbc7e..d907252 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -99,7 +99,7 @@ static inline int symbol__tui_annotate(struct symbol *sym __used,
 }
 #else
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
-			 void(*timer)(void *arg), void *arg,
+			 int nr_events, void(*timer)(void *arg), void *arg,
 			 int delay_secs);
 #endif
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index f87677b..7ea1e56 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -110,7 +110,7 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __used,
 }
 
 static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
-					   int evidx __used,
+					   int evidx __used, int nr_events __used,
 					   void(*timer)(void *arg) __used,
 					   void *arg __used, int delay_secs __used);
 {
@@ -120,7 +120,7 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
 #define KEY_RIGHT -2
 #else
 #include <newt.h>
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
+int hist_entry__tui_annotate(struct hist_entry *he, int evidx, int nr_events,
 			     void(*timer)(void *arg), void *arg, int delay_secs);
 
 #define KEY_LEFT NEWT_KEY_LEFT
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 76c1d08..77421ba 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -20,6 +20,7 @@ struct annotate_browser {
 	struct ui_browser b;
 	struct rb_root	  entries;
 	struct rb_node	  *curr_hot;
+	struct objdump_line *selection;
 };
 
 struct objdump_line_rb_node {
@@ -36,6 +37,7 @@ struct objdump_line_rb_node *objdump_line__rb(struct objdump_line *self)
 
 static void annotate_browser__write(struct ui_browser *self, void *entry, int row)
 {
+	struct annotate_browser *ab = container_of(self, struct annotate_browser, b);
 	struct objdump_line *ol = rb_entry(entry, struct objdump_line, node);
 	bool current_entry = ui_browser__is_current_entry(self, row);
 	int width = self->width;
@@ -58,6 +60,8 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 
 	if (!current_entry)
 		ui_browser__set_color(self, HE_COLORSET_CODE);
+	else
+		ab->selection = ol;
 }
 
 static double objdump_line__calc_percent(struct objdump_line *self,
@@ -141,7 +145,8 @@ static void annotate_browser__set_top(struct annotate_browser *self,
 static void annotate_browser__calc_percent(struct annotate_browser *browser,
 					   int evidx)
 {
-	struct symbol *sym = browser->b.priv;
+	struct map_symbol *ms = browser->b.priv;
+	struct symbol *sym = ms->sym;
 	struct annotation *notes = symbol__annotation(sym);
 	struct objdump_line *pos;
 
@@ -164,17 +169,18 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 }
 
 static int annotate_browser__run(struct annotate_browser *self, int evidx,
-				 void(*timer)(void *arg) __used, void *arg __used,
-				 int delay_secs)
+				 int nr_events, void(*timer)(void *arg),
+				 void *arg, int delay_secs)
 {
 	struct rb_node *nd = NULL;
-	struct symbol *sym = self->b.priv;
+	struct map_symbol *ms = self->b.priv;
+	struct symbol *sym = ms->sym;
 	/*
 	 * RIGHT To allow builtin-annotate to cycle thru multiple symbols by
 	 * examining the exit key for this function.
 	 */
 	int exit_keys[] = { 'H', NEWT_KEY_TAB, NEWT_KEY_UNTAB,
-			    NEWT_KEY_RIGHT, 0 };
+			    NEWT_KEY_RIGHT, NEWT_KEY_ENTER, 0 };
 	int key;
 
 	if (ui_browser__show(&self->b, sym->name,
@@ -238,6 +244,42 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 		case 'H':
 			nd = self->curr_hot;
 			break;
+		case NEWT_KEY_ENTER:
+			if (self->selection != NULL) {
+				char *s = strstr(self->selection->line, "callq ");
+				struct annotation *notes;
+				struct symbol *target;
+				u64 ip;
+
+				if (s == NULL)
+					continue;
+
+				s = strchr(s, ' ');
+				if (s++ == NULL)
+					continue;
+
+				ip = strtoull(s, NULL, 16);
+				ip = ms->map->map_ip(ms->map, ip);
+				target = map__find_symbol(ms->map, ip, NULL);
+				if (target == NULL)
+					continue;
+
+				notes = symbol__annotation(target);
+				pthread_mutex_lock(&notes->lock);
+
+				if (notes->src == NULL &&
+				    symbol__alloc_hist(target, nr_events) < 0) {
+					pthread_mutex_unlock(&notes->lock);
+					ui__warning("Not enough memory for annotating '%s' symbol!\n",
+						    target->name);
+					continue;
+				}
+
+				pthread_mutex_unlock(&notes->lock);
+				symbol__tui_annotate(target, ms->map, evidx, nr_events,
+						     timer, arg, delay_secs);
+			}
+			break;
 		default:
 			goto out;
 		}
@@ -250,25 +292,29 @@ out:
 	return key;
 }
 
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
+int hist_entry__tui_annotate(struct hist_entry *he, int evidx, int nr_events,
 			     void(*timer)(void *arg), void *arg, int delay_secs)
 {
-	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx,
+	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx, nr_events,
 				    timer, arg, delay_secs);
 }
 
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
-			void(*timer)(void *arg), void *arg,
-			int delay_secs)
+			 int nr_events, void(*timer)(void *arg), void *arg,
+			 int delay_secs)
 {
 	struct objdump_line *pos, *n;
 	struct annotation *notes;
+	struct map_symbol ms = {
+		.map = map,
+		.sym = sym,
+	};
 	struct annotate_browser browser = {
 		.b = {
 			.refresh = ui_browser__list_head_refresh,
 			.seek	 = ui_browser__list_head_seek,
 			.write	 = annotate_browser__write,
-			.priv	 = sym,
+			.priv	 = &ms,
 		},
 	};
 	int ret;
@@ -300,7 +346,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
-	ret = annotate_browser__run(&browser, evidx, timer, arg, delay_secs);
+	ret = annotate_browser__run(&browser, evidx, nr_events,
+				    timer, arg, delay_secs);
 	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
 		list_del(&pos->node);
 		objdump_line__free(pos);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 6244d19..f0515cb 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -825,7 +825,7 @@ static int hists__browser_title(struct hists *self, char *bf, size_t size,
 	return printed;
 }
 
-static int perf_evsel__hists_browse(struct perf_evsel *evsel,
+static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				    const char *helpline, const char *ev_name,
 				    bool left_exits,
 				    void(*timer)(void *arg), void *arg,
@@ -968,7 +968,7 @@ do_annotate:
 			if (he == NULL)
 				continue;
 
-			hist_entry__tui_annotate(he, evsel->idx,
+			hist_entry__tui_annotate(he, evsel->idx, nr_events,
 						 timer, arg, delay_secs);
 		} else if (choice == browse_map)
 			map__browse(browser->selection->map);
@@ -1042,7 +1042,8 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 		menu->selection = evsel;
 }
 
-static int perf_evsel_menu__run(struct perf_evsel_menu *menu, const char *help,
+static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
+				int nr_events, const char *help,
 				void(*timer)(void *arg), void *arg, int delay_secs)
 {
 	int exit_keys[] = { NEWT_KEY_ENTER, NEWT_KEY_RIGHT, 0, };
@@ -1077,8 +1078,9 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu, const char *help,
 			perf_evlist__set_selected(evlist, pos);
 browse_hists:
 			ev_name = event_name(pos);
-			key = perf_evsel__hists_browse(pos, help, ev_name, true,
-						       timer, arg, delay_secs);
+			key = perf_evsel__hists_browse(pos, nr_events, help,
+						       ev_name, true, timer,
+						       arg, delay_secs);
 			ui_browser__show_title(&menu->b, title);
 			break;
 		case NEWT_KEY_LEFT:
@@ -1150,7 +1152,8 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			pos->name = strdup(ev_name);
 	}
 
-	return perf_evsel_menu__run(&menu, help, timer, arg, delay_secs);
+	return perf_evsel_menu__run(&menu, evlist->nr_entries, help, timer,
+				    arg, delay_secs);
 }
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
@@ -1162,8 +1165,9 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 		struct perf_evsel *first = list_entry(evlist->entries.next,
 						      struct perf_evsel, node);
 		const char *ev_name = event_name(first);
-		return perf_evsel__hists_browse(first, help, ev_name, false,
-						timer, arg, delay_secs);
+		return perf_evsel__hists_browse(first, evlist->nr_entries, help,
+						ev_name, false, timer, arg,
+						delay_secs);
 	}
 
 	return __perf_evlist__tui_browse_hists(evlist, help,
-- 
1.6.2.5

