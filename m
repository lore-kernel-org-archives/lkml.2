Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab0HTCs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 22:48:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:60398 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab0HTCsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 22:48:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/3] perf ui browser: Return the exit key in all browsers
Date: Thu, 19 Aug 2010 23:47:48 -0300
Message-Id: <1282272469-3675-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1282272469-3675-1-git-send-email-acme@infradead.org>
References: <1282272469-3675-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Make all browsers return the exit key uniformly and remove the
newtExitStruct parameter, removing one more newt specific thing from the
ui API.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c          |   17 ++--
 tools/perf/util/ui/browser.c           |   16 ++--
 tools/perf/util/ui/browser.h           |    2 +-
 tools/perf/util/ui/browsers/annotate.c |   18 ++---
 tools/perf/util/ui/browsers/hists.c    |  132 ++++++++++++++------------------
 tools/perf/util/ui/browsers/map.c      |   20 +++--
 tools/perf/util/util.h                 |   13 ---
 7 files changed, 93 insertions(+), 125 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 1478dc6..20ee21d 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -321,7 +321,7 @@ static int hist_entry__tty_annotate(struct hist_entry *he)
 
 static void hists__find_annotations(struct hists *self)
 {
-	struct rb_node *first = rb_first(&self->entries), *nd = first;
+	struct rb_node *nd = rb_first(&self->entries), *next;
 	int key = KEY_RIGHT;
 
 	while (nd) {
@@ -343,20 +343,19 @@ find_next:
 
 		if (use_browser > 0) {
 			key = hist_entry__tui_annotate(he);
-			if (is_exit_key(key))
-				break;
 			switch (key) {
 			case KEY_RIGHT:
-			case '\t':
-				nd = rb_next(nd);
+				next = rb_next(nd);
 				break;
 			case KEY_LEFT:
-				if (nd == first)
-					continue;
-				nd = rb_prev(nd);
-			default:
+				next = rb_prev(nd);
 				break;
+			default:
+				return;
 			}
+
+			if (next != NULL)
+				nd = next;
 		} else {
 			hist_entry__tty_annotate(he);
 			nd = rb_next(nd);
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index d237410..669a980 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -204,21 +204,21 @@ int ui_browser__refresh(struct ui_browser *self)
 	return 0;
 }
 
-int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
+int ui_browser__run(struct ui_browser *self)
 {
+	struct newtExitStruct es;
+
 	if (ui_browser__refresh(self) < 0)
 		return -1;
 
 	while (1) {
 		off_t offset;
 
-		newtFormRun(self->form, es);
+		newtFormRun(self->form, &es);
 
-		if (es->reason != NEWT_EXIT_HOTKEY)
+		if (es.reason != NEWT_EXIT_HOTKEY)
 			break;
-		if (is_exit_key(es->u.key))
-			return es->u.key;
-		switch (es->u.key) {
+		switch (es.u.key) {
 		case NEWT_KEY_DOWN:
 			if (self->index == self->nr_entries - 1)
 				break;
@@ -275,12 +275,12 @@ int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
 			self->seek(self, -offset, SEEK_END);
 			break;
 		default:
-			return es->u.key;
+			return es.u.key;
 		}
 		if (ui_browser__refresh(self) < 0)
 			return -1;
 	}
-	return 0;
+	return -1;
 }
 
 unsigned int ui_browser__list_head_refresh(struct ui_browser *self)
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 27c23c2..332a675 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -37,7 +37,7 @@ int ui_browser__show(struct ui_browser *self, const char *title,
 		     const char *helpline, ...);
 void ui_browser__hide(struct ui_browser *self);
 int ui_browser__refresh(struct ui_browser *self);
-int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es);
+int ui_browser__run(struct ui_browser *self);
 
 void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence);
 unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self);
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index a00d529..a8bc2c0 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -133,14 +133,14 @@ static void annotate_browser__set_top(struct annotate_browser *self,
 	self->curr_hot = nd;
 }
 
-static int annotate_browser__run(struct annotate_browser *self,
-				 struct newtExitStruct *es)
+static int annotate_browser__run(struct annotate_browser *self)
 {
 	struct rb_node *nd;
 	struct hist_entry *he = self->b.priv;
+	int key;
 
 	if (ui_browser__show(&self->b, he->ms.sym->name,
-			     "<- or ESC: exit, TAB/shift+TAB: cycle thru samples") < 0)
+			     "<-, -> or ESC: exit, TAB/shift+TAB: cycle thru samples") < 0)
 		return -1;
 
 	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
@@ -153,12 +153,9 @@ static int annotate_browser__run(struct annotate_browser *self,
 	}
 
 	while (1) {
-		ui_browser__run(&self->b, es);
+		key = ui_browser__run(&self->b);
 
-		if (es->reason != NEWT_EXIT_HOTKEY)
-			break;
-
-		switch (es->u.key) {
+		switch (key) {
 		case NEWT_KEY_TAB:
 			nd = rb_prev(nd);
 			if (nd == NULL)
@@ -177,12 +174,11 @@ static int annotate_browser__run(struct annotate_browser *self,
 	}
 out:
 	ui_browser__hide(&self->b);
-	return es->u.key;
+	return key;
 }
 
 int hist_entry__tui_annotate(struct hist_entry *self)
 {
-	struct newtExitStruct es;
 	struct objdump_line *pos, *n;
 	struct objdump_line_rb_node *rbpos;
 	LIST_HEAD(head);
@@ -230,7 +226,7 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 		annotate_browser__set_top(&browser, browser.curr_hot);
 
 	browser.b.width += 18; /* Percentage */
-	ret = annotate_browser__run(&browser, &es);
+	ret = annotate_browser__run(&browser);
 	list_for_each_entry_safe(pos, n, &head, node) {
 		list_del(&pos->node);
 		objdump_line__free(pos);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 5723091..1735c48 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -195,9 +195,9 @@ static bool hist_browser__toggle_fold(struct hist_browser *self)
 	return false;
 }
 
-static int hist_browser__run(struct hist_browser *self, const char *title,
-			     struct newtExitStruct *es)
+static int hist_browser__run(struct hist_browser *self, const char *title)
 {
+	int key;
 	char str[256], unit;
 	unsigned long nr_events = self->hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
@@ -227,11 +227,9 @@ static int hist_browser__run(struct hist_browser *self, const char *title,
 	newtFormAddHotKey(self->b.form, NEWT_KEY_ENTER);
 
 	while (1) {
-		ui_browser__run(&self->b, es);
+		key = ui_browser__run(&self->b);
 
-		if (es->reason != NEWT_EXIT_HOTKEY)
-			break;
-		switch (es->u.key) {
+		switch (key) {
 		case 'D': { /* Debug */
 			static int seq;
 			struct hist_entry *h = rb_entry(self->b.top,
@@ -251,12 +249,12 @@ static int hist_browser__run(struct hist_browser *self, const char *title,
 				break;
 			/* fall thru */
 		default:
-			return 0;
+			goto out;
 		}
 	}
-
+out:
 	ui_browser__hide(&self->b);
-	return 0;
+	return key;
 }
 
 static char *callchain_list__sym_name(struct callchain_list *self,
@@ -687,8 +685,6 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 
 static void hist_browser__delete(struct hist_browser *self)
 {
-	newtFormDestroy(self->b.form);
-	newtPopWindow();
 	free(self);
 }
 
@@ -725,7 +721,6 @@ int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 	struct pstack *fstack;
 	const struct thread *thread_filter = NULL;
 	const struct dso *dso_filter = NULL;
-	struct newtExitStruct es;
 	char msg[160];
 	int key = -1;
 
@@ -749,70 +744,63 @@ int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
 		    browse_map = -2;
 
-		if (hist_browser__run(browser, msg, &es))
-			break;
+		key = hist_browser__run(browser, msg);
 
 		thread = hist_browser__selected_thread(browser);
 		dso = browser->selection->map ? browser->selection->map->dso : NULL;
 
-		if (es.reason == NEWT_EXIT_HOTKEY) {
-			key = es.u.key;
-
-			switch (key) {
-			case NEWT_KEY_F1:
-				goto do_help;
-			case NEWT_KEY_TAB:
-			case NEWT_KEY_UNTAB:
-				/*
-				 * Exit the browser, let hists__browser_tree
-				 * go to the next or previous
-				 */
-				goto out_free_stack;
-			default:;
-			}
-
-			switch (key) {
-			case 'a':
-				if (browser->selection->map == NULL &&
-				    browser->selection->map->dso->annotate_warned)
-					continue;
-				goto do_annotate;
-			case 'd':
-				goto zoom_dso;
-			case 't':
-				goto zoom_thread;
-			case 'h':
-			case '?':
-do_help:
-				ui__help_window("->        Zoom into DSO/Threads & Annotate current symbol\n"
-						"<-        Zoom out\n"
-						"a         Annotate current symbol\n"
-						"h/?/F1    Show this window\n"
-						"d         Zoom into current DSO\n"
-						"t         Zoom into current Thread\n"
-						"q/CTRL+C  Exit browser");
+		switch (key) {
+		case NEWT_KEY_F1:
+			goto do_help;
+		case NEWT_KEY_TAB:
+		case NEWT_KEY_UNTAB:
+			/*
+			 * Exit the browser, let hists__browser_tree
+			 * go to the next or previous
+			 */
+			goto out_free_stack;
+		case 'a':
+			if (browser->selection->map == NULL &&
+			    browser->selection->map->dso->annotate_warned)
 				continue;
-			default:;
-			}
-			if (is_exit_key(key)) {
-				if (key == NEWT_KEY_ESCAPE &&
-				    !ui__dialog_yesno("Do you really want to exit?"))
-					continue;
-				break;
-			}
-
-			if (es.u.key == NEWT_KEY_LEFT) {
-				const void *top;
+			goto do_annotate;
+		case 'd':
+			goto zoom_dso;
+		case 't':
+			goto zoom_thread;
+		case 'h':
+		case '?':
+do_help:
+			ui__help_window("->        Zoom into DSO/Threads & Annotate current symbol\n"
+					"<-        Zoom out\n"
+					"a         Annotate current symbol\n"
+					"h/?/F1    Show this window\n"
+					"d         Zoom into current DSO\n"
+					"t         Zoom into current Thread\n"
+					"q/CTRL+C  Exit browser");
+			continue;
+		case NEWT_KEY_ENTER:
+		case NEWT_KEY_RIGHT:
+			/* menu */
+			break;
+		case NEWT_KEY_LEFT: {
+			const void *top;
 
-				if (pstack__empty(fstack))
-					continue;
-				top = pstack__pop(fstack);
-				if (top == &dso_filter)
-					goto zoom_out_dso;
-				if (top == &thread_filter)
-					goto zoom_out_thread;
+			if (pstack__empty(fstack))
 				continue;
-			}
+			top = pstack__pop(fstack);
+			if (top == &dso_filter)
+				goto zoom_out_dso;
+			if (top == &thread_filter)
+				goto zoom_out_thread;
+			continue;
+		}
+		case NEWT_KEY_ESCAPE:
+			if (!ui__dialog_yesno("Do you really want to exit?"))
+				continue;
+			/* Fall thru */
+		default:
+			goto out_free_stack;
 		}
 
 		if (browser->selection->sym != NULL &&
@@ -925,10 +913,6 @@ int hists__tui_browse_tree(struct rb_root *self, const char *help)
 		const char *ev_name = __event_name(hists->type, hists->config);
 
 		key = hists__browse(hists, help, ev_name);
-
-		if (is_exit_key(key))
-			break;
-
 		switch (key) {
 		case NEWT_KEY_TAB:
 			next = rb_next(nd);
@@ -940,7 +924,7 @@ int hists__tui_browse_tree(struct rb_root *self, const char *help)
 				continue;
 			nd = rb_prev(nd);
 		default:
-			break;
+			return key;
 		}
 	}
 
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
index 733daba..16b7d70 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/util/ui/browsers/map.c
@@ -97,31 +97,34 @@ static int map_browser__search(struct map_browser *self)
 	return 0;
 }
 
-static int map_browser__run(struct map_browser *self, struct newtExitStruct *es)
+static int map_browser__run(struct map_browser *self)
 {
+	int key;
+
 	if (ui_browser__show(&self->b, self->map->dso->long_name,
 			     "Press <- or ESC to exit, %s / to search",
 			     verbose ? "" : "restart with -v to use") < 0)
 		return -1;
 
 	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
-	newtFormAddHotKey(self->b.form, NEWT_KEY_ENTER);
+	newtFormAddHotKey(self->b.form, NEWT_KEY_ESCAPE);
+	newtFormAddHotKey(self->b.form, 'Q');
+	newtFormAddHotKey(self->b.form, 'q');
+	newtFormAddHotKey(self->b.form, CTRL('c'));
 	if (verbose)
 		newtFormAddHotKey(self->b.form, '/');
 
 	while (1) {
-		ui_browser__run(&self->b, es);
+		key = ui_browser__run(&self->b);
 
-		if (es->reason != NEWT_EXIT_HOTKEY)
-			break;
-		if (verbose && es->u.key == '/')
+		if (verbose && key == '/')
 			map_browser__search(self);
 		else
 			break;
 	}
 
 	ui_browser__hide(&self->b);
-	return 0;
+	return key;
 }
 
 int map__browse(struct map *self)
@@ -135,7 +138,6 @@ int map__browse(struct map *self)
 		},
 		.map = self,
 	};
-	struct newtExitStruct es;
 	struct rb_node *nd;
 	char tmp[BITS_PER_LONG / 4];
 	u64 maxaddr = 0;
@@ -156,5 +158,5 @@ int map__browse(struct map *self)
 
 	mb.addrlen = snprintf(tmp, sizeof(tmp), "%llx", maxaddr);
 	mb.b.width += mb.addrlen * 2 + 4 + mb.namelen;
-	return map_browser__run(&mb, &es);
+	return map_browser__run(&mb);
 }
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index f380fed..7562707 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -266,19 +266,6 @@ bool strglobmatch(const char *str, const char *pat);
 bool strlazymatch(const char *str, const char *pat);
 unsigned long convert_unit(unsigned long value, char *unit);
 
-#ifndef ESC
-#define ESC 27
-#endif
-
-static inline bool is_exit_key(int key)
-{
-	char up;
-	if (key == CTRL('c') || key == ESC)
-		return true;
-	up = toupper(key);
-	return up == 'Q';
-}
-
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
-- 
1.6.2.5

