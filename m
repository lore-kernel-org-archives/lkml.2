Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab2KNHZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:25:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44025 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2KNHZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:25:02 -0500
Date: Tue, 13 Nov 2012 23:23:10 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-9783adf777a445a1e9d0db4857a3a896a9f42d4a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, dsahern@gmail.com,
        irina.tirdea@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, irina.tirdea@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1351835406-15208-2-git-send-email-namhyung@kernel.org>
References: <1351835406-15208-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Introduce struct hist_browser_timer
Git-Commit-ID: 9783adf777a445a1e9d0db4857a3a896a9f42d4a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:23:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9783adf777a445a1e9d0db4857a3a896a9f42d4a
Gitweb:     http://git.kernel.org/tip/9783adf777a445a1e9d0db4857a3a896a9f42d4a
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 2 Nov 2012 14:50:05 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:03:58 -0300

perf tools: Introduce struct hist_browser_timer

Currently various hist browser functions receive 3 arguments for
refreshing histogram but only used from a few places.  Also it's only
for perf top command so that it can be NULL for other (and probably
most) cases.  Pack them into a struct in order to reduce number of those
unused arguments.

This is a mechanical change and does not intend a functional change.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351835406-15208-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c     |    2 +-
 tools/perf/builtin-report.c       |    4 +-
 tools/perf/builtin-top.c          |    9 +++++--
 tools/perf/ui/browsers/annotate.c |   27 ++++++++++-------------
 tools/perf/ui/browsers/hists.c    |   43 ++++++++++++++++--------------------
 tools/perf/ui/gtk/browser.c       |    4 +--
 tools/perf/util/annotate.h        |    8 +++---
 tools/perf/util/hist.h            |   28 +++++++++++-------------
 8 files changed, 58 insertions(+), 67 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index cb23476..dc870cf 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -139,7 +139,7 @@ find_next:
 		}
 
 		if (use_browser > 0) {
-			key = hist_entry__tui_annotate(he, evidx, NULL, NULL, 0);
+			key = hist_entry__tui_annotate(he, evidx, NULL);
 			switch (key) {
 			case K_RIGHT:
 				next = rb_next(nd);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f07eae7..234f34d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -428,10 +428,10 @@ static int __cmd_report(struct perf_report *rep)
 	if (use_browser > 0) {
 		if (use_browser == 1) {
 			perf_evlist__tui_browse_hists(session->evlist, help,
-						      NULL, NULL, 0);
+						      NULL);
 		} else if (use_browser == 2) {
 			perf_evlist__gtk_browse_hists(session->evlist, help,
-						      NULL, NULL, 0);
+						      NULL);
 		}
 	} else
 		perf_evlist__tty_browse_hists(session->evlist, rep, help);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f2ecd49..102b43c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -582,6 +582,11 @@ static void *display_thread_tui(void *arg)
 	struct perf_evsel *pos;
 	struct perf_top *top = arg;
 	const char *help = "For a higher level overview, try: perf top --sort comm,dso";
+	struct hist_browser_timer hbt = {
+		.timer		= perf_top__sort_new_samples,
+		.arg		= top,
+		.refresh	= top->delay_secs,
+	};
 
 	perf_top__sort_new_samples(top);
 
@@ -593,9 +598,7 @@ static void *display_thread_tui(void *arg)
 	list_for_each_entry(pos, &top->evlist->entries, node)
 		pos->hists.uid_filter_str = top->target.uid_str;
 
-	perf_evlist__tui_browse_hists(top->evlist, help,
-				      perf_top__sort_new_samples,
-				      top, top->delay_secs);
+	perf_evlist__tui_browse_hists(top->evlist, help, &hbt);
 
 	exit_browser(0);
 	exit(0);
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 28f8aab..3eff17f 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -386,9 +386,8 @@ static void annotate_browser__init_asm_mode(struct annotate_browser *browser)
 	browser->b.nr_entries = browser->nr_asm_entries;
 }
 
-static bool annotate_browser__callq(struct annotate_browser *browser,
-				    int evidx, void (*timer)(void *arg),
-				    void *arg, int delay_secs)
+static bool annotate_browser__callq(struct annotate_browser *browser, int evidx,
+				    struct hist_browser_timer *hbt)
 {
 	struct map_symbol *ms = browser->b.priv;
 	struct disasm_line *dl = browser->selection;
@@ -418,7 +417,7 @@ static bool annotate_browser__callq(struct annotate_browser *browser,
 	}
 
 	pthread_mutex_unlock(&notes->lock);
-	symbol__tui_annotate(target, ms->map, evidx, timer, arg, delay_secs);
+	symbol__tui_annotate(target, ms->map, evidx, hbt);
 	ui_browser__show_title(&browser->b, sym->name);
 	return true;
 }
@@ -602,13 +601,13 @@ static void annotate_browser__update_addr_width(struct annotate_browser *browser
 }
 
 static int annotate_browser__run(struct annotate_browser *browser, int evidx,
-				 void(*timer)(void *arg),
-				 void *arg, int delay_secs)
+				 struct hist_browser_timer *hbt)
 {
 	struct rb_node *nd = NULL;
 	struct map_symbol *ms = browser->b.priv;
 	struct symbol *sym = ms->sym;
 	const char *help = "Press 'h' for help on key bindings";
+	int delay_secs = hbt ? hbt->refresh : 0;
 	int key;
 
 	if (ui_browser__show(&browser->b, sym->name, help) < 0)
@@ -639,8 +638,8 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 
 		switch (key) {
 		case K_TIMER:
-			if (timer != NULL)
-				timer(arg);
+			if (hbt)
+				hbt->timer(hbt->arg);
 
 			if (delay_secs != 0)
 				symbol__annotate_decay_histogram(sym, evidx);
@@ -740,7 +739,7 @@ show_help:
 					goto show_sup_ins;
 				goto out;
 			} else if (!(annotate_browser__jump(browser) ||
-				     annotate_browser__callq(browser, evidx, timer, arg, delay_secs))) {
+				     annotate_browser__callq(browser, evidx, hbt))) {
 show_sup_ins:
 				ui_helpline__puts("Actions are only available for 'callq', 'retq' & jump instructions.");
 			}
@@ -763,10 +762,9 @@ out:
 }
 
 int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
-			     void(*timer)(void *arg), void *arg, int delay_secs)
+			     struct hist_browser_timer *hbt)
 {
-	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx,
-				    timer, arg, delay_secs);
+	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx, hbt);
 }
 
 static void annotate_browser__mark_jump_targets(struct annotate_browser *browser,
@@ -816,8 +814,7 @@ static inline int width_jumps(int n)
 }
 
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
-			 void(*timer)(void *arg), void *arg,
-			 int delay_secs)
+			 struct hist_browser_timer *hbt)
 {
 	struct disasm_line *pos, *n;
 	struct annotation *notes;
@@ -899,7 +896,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	annotate_browser__update_addr_width(&browser);
 
-	ret = annotate_browser__run(&browser, evidx, timer, arg, delay_secs);
+	ret = annotate_browser__run(&browser, evidx, hbt);
 	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
 		list_del(&pos->node);
 		disasm_line__free(pos);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 082078a..c7d32ed 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -310,10 +310,11 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 }
 
 static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
-			     void(*timer)(void *arg), void *arg, int delay_secs)
+			     struct hist_browser_timer *hbt)
 {
 	int key;
 	char title[160];
+	int delay_secs = hbt ? hbt->refresh : 0;
 
 	browser->b.entries = &browser->hists->entries;
 	browser->b.nr_entries = browser->hists->nr_entries;
@@ -330,7 +331,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 
 		switch (key) {
 		case K_TIMER:
-			timer(arg);
+			hbt->timer(hbt->arg);
 			ui_browser__update_nr_entries(&browser->b, browser->hists->nr_entries);
 
 			if (browser->hists->stats.nr_lost_warned !=
@@ -1136,8 +1137,7 @@ static inline bool is_report_browser(void *timer)
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				    const char *helpline, const char *ev_name,
 				    bool left_exits,
-				    void(*timer)(void *arg), void *arg,
-				    int delay_secs)
+				    struct hist_browser_timer *hbt)
 {
 	struct hists *hists = &evsel->hists;
 	struct hist_browser *browser = hist_browser__new(hists);
@@ -1148,6 +1148,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	int key = -1;
 	char buf[64];
 	char script_opt[64];
+	int delay_secs = hbt ? hbt->refresh : 0;
 
 	if (browser == NULL)
 		return -1;
@@ -1170,7 +1171,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 		nr_options = 0;
 
-		key = hist_browser__run(browser, ev_name, timer, arg, delay_secs);
+		key = hist_browser__run(browser, ev_name, hbt);
 
 		if (browser->he_selection != NULL) {
 			thread = hist_browser__selected_thread(browser);
@@ -1220,7 +1221,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			}
 			continue;
 		case 'r':
-			if (is_report_browser(timer))
+			if (is_report_browser(hbt))
 				goto do_scripts;
 			continue;
 		case K_F1:
@@ -1388,8 +1389,7 @@ do_annotate:
 			 * Don't let this be freed, say, by hists__decay_entry.
 			 */
 			he->used = true;
-			err = hist_entry__tui_annotate(he, evsel->idx,
-						       timer, arg, delay_secs);
+			err = hist_entry__tui_annotate(he, evsel->idx, hbt);
 			he->used = false;
 			/*
 			 * offer option to annotate the other branch source or target
@@ -1512,11 +1512,12 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 
 static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 				int nr_events, const char *help,
-				void(*timer)(void *arg), void *arg, int delay_secs)
+				struct hist_browser_timer *hbt)
 {
 	struct perf_evlist *evlist = menu->b.priv;
 	struct perf_evsel *pos;
 	const char *ev_name, *title = "Available samples";
+	int delay_secs = hbt ? hbt->refresh : 0;
 	int key;
 
 	if (ui_browser__show(&menu->b, title,
@@ -1528,7 +1529,7 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 
 		switch (key) {
 		case K_TIMER:
-			timer(arg);
+			hbt->timer(hbt->arg);
 
 			if (!menu->lost_events_warned && menu->lost_events) {
 				ui_browser__warn_lost_events(&menu->b);
@@ -1546,12 +1547,11 @@ browse_hists:
 			 * Give the calling tool a chance to populate the non
 			 * default evsel resorted hists tree.
 			 */
-			if (timer)
-				timer(arg);
+			if (hbt)
+				hbt->timer(hbt->arg);
 			ev_name = perf_evsel__name(pos);
 			key = perf_evsel__hists_browse(pos, nr_events, help,
-						       ev_name, true, timer,
-						       arg, delay_secs);
+						       ev_name, true, hbt);
 			ui_browser__show_title(&menu->b, title);
 			switch (key) {
 			case K_TAB:
@@ -1599,8 +1599,7 @@ out:
 
 static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 					   const char *help,
-					   void(*timer)(void *arg), void *arg,
-					   int delay_secs)
+					   struct hist_browser_timer *hbt)
 {
 	struct perf_evsel *pos;
 	struct perf_evsel_menu menu = {
@@ -1624,23 +1623,19 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			menu.b.width = line_len;
 	}
 
-	return perf_evsel_menu__run(&menu, evlist->nr_entries, help, timer,
-				    arg, delay_secs);
+	return perf_evsel_menu__run(&menu, evlist->nr_entries, help, hbt);
 }
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
-				  void(*timer)(void *arg), void *arg,
-				  int delay_secs)
+				  struct hist_browser_timer *hbt)
 {
 	if (evlist->nr_entries == 1) {
 		struct perf_evsel *first = list_entry(evlist->entries.next,
 						      struct perf_evsel, node);
 		const char *ev_name = perf_evsel__name(first);
 		return perf_evsel__hists_browse(first, evlist->nr_entries, help,
-						ev_name, false, timer, arg,
-						delay_secs);
+						ev_name, false, hbt);
 	}
 
-	return __perf_evlist__tui_browse_hists(evlist, help,
-					       timer, arg, delay_secs);
+	return __perf_evlist__tui_browse_hists(evlist, help, hbt);
 }
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 4125c62..253b621 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -237,9 +237,7 @@ static GtkWidget *perf_gtk__setup_statusbar(void)
 
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 				  const char *help,
-				  void (*timer) (void *arg)__maybe_unused,
-				  void *arg __maybe_unused,
-				  int delay_secs __maybe_unused)
+				  struct hist_browser_timer *hbt __maybe_unused)
 {
 	struct perf_evsel *pos;
 	GtkWidget *vbox;
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index a4dd25a..c627201 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -5,6 +5,7 @@
 #include <stdint.h>
 #include "types.h"
 #include "symbol.h"
+#include "hist.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <pthread.h>
@@ -140,14 +141,13 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 
 #ifdef NEWT_SUPPORT
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
-			 void(*timer)(void *arg), void *arg, int delay_secs);
+			 struct hist_browser_timer *hbt);
 #else
 static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
 				       struct map *map __maybe_unused,
 				       int evidx __maybe_unused,
-				       void(*timer)(void *arg) __maybe_unused,
-				       void *arg __maybe_unused,
-				       int delay_secs __maybe_unused)
+				       struct hist_browser_timer *hbt
+				       __maybe_unused)
 {
 	return 0;
 }
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index b874609..96664cc 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -157,22 +157,25 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 
 struct perf_evlist;
 
+struct hist_browser_timer {
+	void (*timer)(void *arg);
+	void *arg;
+	int refresh;
+};
+
 #ifdef NEWT_SUPPORT
 #include "../ui/keysyms.h"
 int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
-			     void(*timer)(void *arg), void *arg, int delay_secs);
+			     struct hist_browser_timer *hbt);
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
-				  void(*timer)(void *arg), void *arg,
-				  int refresh);
+				  struct hist_browser_timer *hbt);
 int script_browse(const char *script_opt);
 #else
 static inline
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __maybe_unused,
 				  const char *help __maybe_unused,
-				  void(*timer)(void *arg) __maybe_unused,
-				  void *arg __maybe_unused,
-				  int refresh __maybe_unused)
+				  struct hist_browser_timer *hbt __maybe_unused)
 {
 	return 0;
 }
@@ -180,10 +183,8 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __maybe_unused,
 static inline int hist_entry__tui_annotate(struct hist_entry *self
 					   __maybe_unused,
 					   int evidx __maybe_unused,
-					   void(*timer)(void *arg)
-					   __maybe_unused,
-					   void *arg __maybe_unused,
-					   int delay_secs __maybe_unused)
+					   struct hist_browser_timer *hbt
+					   __maybe_unused)
 {
 	return 0;
 }
@@ -199,15 +200,12 @@ static inline int script_browse(const char *script_opt)
 
 #ifdef GTK2_SUPPORT
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
-				  void(*timer)(void *arg), void *arg,
-				  int refresh);
+				  struct hist_browser_timer *hbt __maybe_unused);
 #else
 static inline
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
 				  const char *help __maybe_unused,
-				  void(*timer)(void *arg) __maybe_unused,
-				  void *arg __maybe_unused,
-				  int refresh __maybe_unused)
+				  struct hist_browser_timer *hbt __maybe_unused)
 {
 	return 0;
 }
