Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab1JMPIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:08:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:43437 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab1JMPIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:08:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/6] perf ui browser: Remove ui_browser__add_exit_keys
Date: Thu, 13 Oct 2011 12:08:23 -0300
Message-Id: <1318518504-23299-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318518504-23299-1-git-send-email-acme@infradead.org>
References: <1318518504-23299-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Users (hist_browser, etc) should just handle all keys, discarding the
ones they don't handle.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-fjouann12v2k58t6vdd2wawb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c           |   18 ------------------
 tools/perf/util/ui/browser.h           |    2 --
 tools/perf/util/ui/browsers/annotate.c |   12 ++++--------
 tools/perf/util/ui/browsers/hists.c    |   28 ++++++++--------------------
 tools/perf/util/ui/browsers/map.c      |    3 ---
 5 files changed, 12 insertions(+), 51 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 05a0f61..2923c49 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -142,20 +142,6 @@ void ui_browser__reset_index(struct ui_browser *self)
 	self->seek(self, 0, SEEK_SET);
 }
 
-void ui_browser__add_exit_key(struct ui_browser *browser __used, int key __used)
-{
-}
-
-void ui_browser__add_exit_keys(struct ui_browser *self, int keys[])
-{
-	int i = 0;
-
-	while (keys[i] && i < 64) {
-		ui_browser__add_exit_key(self, keys[i]);
-		++i;
-	}
-}
-
 void __ui_browser__show_title(struct ui_browser *browser, const char *title)
 {
 	SLsmg_gotorc(0, 0);
@@ -175,16 +161,12 @@ int ui_browser__show(struct ui_browser *self, const char *title,
 {
 	int err;
 	va_list ap;
-	int keys[] = { NEWT_KEY_UP, NEWT_KEY_DOWN, NEWT_KEY_PGUP,
-		       NEWT_KEY_PGDN, NEWT_KEY_HOME, NEWT_KEY_END, ' ',
-		       NEWT_KEY_LEFT, NEWT_KEY_ESCAPE, 'q', CTRL('c'), 0 };
 
 	ui_browser__refresh_dimensions(self);
 
 	pthread_mutex_lock(&ui__lock);
 	__ui_browser__show_title(self, title);
 
-	ui_browser__add_exit_keys(self, keys);
 	self->title = title;
 	free(self->helpline);
 	self->helpline = NULL;
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 37d56bf..7dd9d61 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -32,8 +32,6 @@ void ui_browser__refresh_dimensions(struct ui_browser *self);
 void ui_browser__reset_index(struct ui_browser *self);
 
 void ui_browser__gotorc(struct ui_browser *self, int y, int x);
-void ui_browser__add_exit_key(struct ui_browser *self, int key);
-void ui_browser__add_exit_keys(struct ui_browser *self, int keys[]);
 void __ui_browser__show_title(struct ui_browser *browser, const char *title);
 void ui_browser__show_title(struct ui_browser *browser, const char *title);
 int ui_browser__show(struct ui_browser *self, const char *title,
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 1967fbf..cbefb4f 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -175,12 +175,6 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 	struct rb_node *nd = NULL;
 	struct map_symbol *ms = self->b.priv;
 	struct symbol *sym = ms->sym;
-	/*
-	 * RIGHT To allow builtin-annotate to cycle thru multiple symbols by
-	 * examining the exit key for this function.
-	 */
-	int exit_keys[] = { 'H', NEWT_KEY_TAB, NEWT_KEY_UNTAB,
-			    NEWT_KEY_RIGHT, NEWT_KEY_ENTER, 0 };
 	int key;
 
 	if (ui_browser__show(&self->b, sym->name,
@@ -188,7 +182,6 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 			     "cycle hottest lines, H: Hottest, -> Line action") < 0)
 		return -1;
 
-	ui_browser__add_exit_keys(&self->b, exit_keys);
 	annotate_browser__calc_percent(self, evidx);
 
 	if (self->curr_hot)
@@ -292,8 +285,11 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 						     timer, arg, delay_secs);
 			}
 			break;
-		default:
+		case 'q':
+		case CTRL('c'):
 			goto out;
+		default:
+			continue;
 		}
 
 		if (nd != NULL)
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 603d6ee..662b721 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -302,9 +302,6 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 {
 	int key;
 	char title[160];
-	int sym_exit_keys[] = { 'a', 'h', 'C', 'd', 'E', 't', 0, };
-	int exit_keys[] = { '?', 'h', 'D', NEWT_KEY_LEFT, NEWT_KEY_RIGHT,
-			    NEWT_KEY_TAB, NEWT_KEY_UNTAB, NEWT_KEY_ENTER, 0, };
 
 	self->b.entries = &self->hists->entries;
 	self->b.nr_entries = self->hists->nr_entries;
@@ -317,10 +314,6 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 			     "Press '?' for help on key bindings") < 0)
 		return -1;
 
-	ui_browser__add_exit_keys(&self->b, exit_keys);
-	if (self->has_symbols)
-		ui_browser__add_exit_keys(&self->b, sym_exit_keys);
-
 	while (1) {
 		key = ui_browser__run(&self->b, delay_secs);
 
@@ -921,8 +914,11 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			    !ui__dialog_yesno("Do you really want to exit?"))
 				continue;
 			/* Fall thru */
-		default:
+		case 'q':
+		case CTRL('c'):
 			goto out_free_stack;
+		default:
+			continue;
 		}
 
 		if (!browser->has_symbols)
@@ -1056,7 +1052,6 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 				int nr_events, const char *help,
 				void(*timer)(void *arg), void *arg, int delay_secs)
 {
-	int exit_keys[] = { NEWT_KEY_ENTER, NEWT_KEY_RIGHT, 0, };
 	struct perf_evlist *evlist = menu->b.priv;
 	struct perf_evsel *pos;
 	const char *ev_name, *title = "Available samples";
@@ -1066,8 +1061,6 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 			     "ESC: exit, ENTER|->: Browse histograms") < 0)
 		return -1;
 
-	ui_browser__add_exit_keys(&menu->b, exit_keys);
-
 	while (1) {
 		key = ui_browser__run(&menu->b, delay_secs);
 
@@ -1091,15 +1084,6 @@ browse_hists:
 			break;
 		case NEWT_KEY_LEFT:
 			continue;
-		case NEWT_KEY_ESCAPE:
-			if (!ui__dialog_yesno("Do you really want to exit?"))
-				continue;
-			/* Fall thru */
-		default:
-			goto out;
-		}
-
-		switch (key) {
 		case NEWT_KEY_TAB:
 			if (pos->node.next == &evlist->entries)
 				pos = list_entry(evlist->entries.next, struct perf_evsel, node);
@@ -1114,6 +1098,10 @@ browse_hists:
 				pos = list_entry(pos->node.prev, struct perf_evsel, node);
 			perf_evlist__set_selected(evlist, pos);
 			goto browse_hists;
+		case NEWT_KEY_ESCAPE:
+			if (!ui__dialog_yesno("Do you really want to exit?"))
+				continue;
+			/* Fall thru */
 		case 'q':
 		case CTRL('c'):
 			goto out;
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
index 499db76..6905bcc 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/util/ui/browsers/map.c
@@ -109,9 +109,6 @@ static int map_browser__run(struct map_browser *self)
 			     verbose ? "" : "restart with -v to use") < 0)
 		return -1;
 
-	if (verbose)
-		ui_browser__add_exit_key(&self->b, '/');
-
 	while (1) {
 		key = ui_browser__run(&self->b, 0);
 
-- 
1.6.2.5

