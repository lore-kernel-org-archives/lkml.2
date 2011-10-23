Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab1JWTN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 15:13:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:45165 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab1JWTMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 15:12:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] perf ui browser: Use libslang to read keys
Date: Sun, 23 Oct 2011 17:12:21 -0200
Message-Id: <1319397143-20301-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319397143-20301-1-git-send-email-acme@infradead.org>
References: <1319397143-20301-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just another step in stopping the use of libnewt in perf.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-uy6s534uqxq8tenh6s3k8ocj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                    |    1 +
 tools/perf/builtin-annotate.c          |    8 ++--
 tools/perf/util/hist.h                 |    9 +--
 tools/perf/util/ui/browser.c           |   79 +++++++++++++++++++++----------
 tools/perf/util/ui/browsers/annotate.c |   19 +++----
 tools/perf/util/ui/browsers/hists.c    |   33 ++++++-------
 tools/perf/util/ui/keysyms.h           |   25 ++++++++++
 tools/perf/util/ui/libslang.h          |    2 +
 tools/perf/util/ui/setup.c             |   13 +++++
 9 files changed, 125 insertions(+), 64 deletions(-)
 create mode 100644 tools/perf/util/ui/keysyms.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 37fe930..b98e307 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -472,6 +472,7 @@ else
 		LIB_H += util/ui/browser.h
 		LIB_H += util/ui/browsers/map.h
 		LIB_H += util/ui/helpline.h
+		LIB_H += util/ui/keysyms.h
 		LIB_H += util/ui/libslang.h
 		LIB_H += util/ui/progress.h
 		LIB_H += util/ui/util.h
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 3ea764a..46b4c24 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -118,7 +118,7 @@ static void hists__find_annotations(struct hists *self, int evidx,
 				    int nr_events)
 {
 	struct rb_node *nd = rb_first(&self->entries), *next;
-	int key = KEY_RIGHT;
+	int key = K_RIGHT;
 
 	while (nd) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
@@ -130,7 +130,7 @@ static void hists__find_annotations(struct hists *self, int evidx,
 		notes = symbol__annotation(he->ms.sym);
 		if (notes->src == NULL) {
 find_next:
-			if (key == KEY_LEFT)
+			if (key == K_LEFT)
 				nd = rb_prev(nd);
 			else
 				nd = rb_next(nd);
@@ -141,10 +141,10 @@ find_next:
 			key = hist_entry__tui_annotate(he, evidx, nr_events,
 						       NULL, NULL, 0);
 			switch (key) {
-			case KEY_RIGHT:
+			case K_RIGHT:
 				next = rb_next(nd);
 				break;
-			case KEY_LEFT:
+			case K_LEFT:
 				next = rb_prev(nd);
 				break;
 			default:
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 575bcbc..ff93ddc 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -125,16 +125,13 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
 {
 	return 0;
 }
-#define KEY_LEFT -1
-#define KEY_RIGHT -2
+#define K_LEFT -1
+#define K_RIGHT -2
 #else
-#include <newt.h>
+#include "ui/keysyms.h"
 int hist_entry__tui_annotate(struct hist_entry *he, int evidx, int nr_events,
 			     void(*timer)(void *arg), void *arg, int delay_secs);
 
-#define KEY_LEFT NEWT_KEY_LEFT
-#define KEY_RIGHT NEWT_KEY_RIGHT
-
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  void(*timer)(void *arg), void *arg,
 				  int refresh);
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 06fc9eb..5359f37 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -11,10 +11,9 @@
 #include <sys/ttydefaults.h>
 #include "browser.h"
 #include "helpline.h"
+#include "keysyms.h"
 #include "../color.h"
 
-int newtGetKey(void);
-
 static int ui_browser__percent_color(struct ui_browser *browser,
 				     double percent, bool current)
 {
@@ -292,16 +291,55 @@ void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries)
 	browser->seek(browser, browser->top_idx, SEEK_SET);
 }
 
+static int ui__getch(int delay_secs)
+{
+	struct timeval timeout, *ptimeout = delay_secs ? &timeout : NULL;
+	fd_set read_set;
+	int err, key;
+
+	FD_ZERO(&read_set);
+	FD_SET(0, &read_set);
+
+	if (delay_secs) {
+		timeout.tv_sec = delay_secs;
+		timeout.tv_usec = 0;
+	}
+
+        err = select(1, &read_set, NULL, NULL, ptimeout);
+
+	if (err == 0)
+		return K_TIMER;
+
+	if (err == -1) {
+		if (errno == EINTR)
+			return K_RESIZE;
+		return K_ERROR;
+	}
+
+	key = SLang_getkey();
+	if (key != K_ESC)
+		return key;
+
+	FD_ZERO(&read_set);
+	FD_SET(0, &read_set);
+	timeout.tv_sec = 0;
+	timeout.tv_usec = 20;
+        err = select(1, &read_set, NULL, NULL, &timeout);
+	if (err == 0)
+		return K_ESC;
+
+	SLang_ungetkey(key);
+	return SLkp_getkey();
+}
+
 int ui_browser__run(struct ui_browser *self, int delay_secs)
 {
 	int err, key;
-	struct timeval timeout, *ptimeout = delay_secs ? &timeout : NULL;
 
 	pthread__unblock_sigwinch();
 
 	while (1) {
 		off_t offset;
-		fd_set read_set;
 
 		pthread_mutex_lock(&ui__lock);
 		err = __ui_browser__refresh(self);
@@ -310,20 +348,9 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 		if (err < 0)
 			break;
 
-		FD_ZERO(&read_set);
-		FD_SET(0, &read_set);
+		key = ui__getch(delay_secs);
 
-		if (delay_secs) {
-			timeout.tv_sec = delay_secs;
-			timeout.tv_usec = 0;
-		}
-
-	        err = select(1, &read_set, NULL, NULL, ptimeout);
-		if (err > 0 && FD_ISSET(0, &read_set))
-			key = newtGetKey();
-		else if (err == 0)
-			break;
-		else {
+		if (key == K_RESIZE) {
 			pthread_mutex_lock(&ui__lock);
 			SLtt_get_screen_size();
 			SLsmg_reinit_smg();
@@ -335,9 +362,9 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 		}
 
 		if (self->use_navkeypressed && !self->navkeypressed) {
-			if (key == NEWT_KEY_DOWN || key == NEWT_KEY_UP ||
-			    key == NEWT_KEY_PGDN || key == NEWT_KEY_PGUP ||
-			    key == NEWT_KEY_HOME || key == NEWT_KEY_END ||
+			if (key == K_DOWN || key == K_UP ||
+			    key == K_PGDN || key == K_PGUP ||
+			    key == K_HOME || key == K_END ||
 			    key == ' ') {
 				self->navkeypressed = true;
 				continue;
@@ -346,7 +373,7 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 		}
 
 		switch (key) {
-		case NEWT_KEY_DOWN:
+		case K_DOWN:
 			if (self->index == self->nr_entries - 1)
 				break;
 			++self->index;
@@ -355,7 +382,7 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 				self->seek(self, +1, SEEK_CUR);
 			}
 			break;
-		case NEWT_KEY_UP:
+		case K_UP:
 			if (self->index == 0)
 				break;
 			--self->index;
@@ -364,7 +391,7 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 				self->seek(self, -1, SEEK_CUR);
 			}
 			break;
-		case NEWT_KEY_PGDN:
+		case K_PGDN:
 		case ' ':
 			if (self->top_idx + self->height > self->nr_entries - 1)
 				break;
@@ -376,7 +403,7 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 			self->top_idx += offset;
 			self->seek(self, +offset, SEEK_CUR);
 			break;
-		case NEWT_KEY_PGUP:
+		case K_PGUP:
 			if (self->top_idx == 0)
 				break;
 
@@ -389,10 +416,10 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 			self->top_idx -= offset;
 			self->seek(self, -offset, SEEK_CUR);
 			break;
-		case NEWT_KEY_HOME:
+		case K_HOME:
 			ui_browser__reset_index(self);
 			break;
-		case NEWT_KEY_END:
+		case K_END:
 			offset = self->height - 1;
 			if (offset >= self->nr_entries)
 				offset = self->nr_entries - 1;
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 1a12d8f..4e0cb7f 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -6,6 +6,7 @@
 #include "../../sort.h"
 #include "../../symbol.h"
 #include <pthread.h>
+#include <newt.h>
 
 static void ui__error_window(const char *fmt, ...)
 {
@@ -265,18 +266,14 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 		}
 
 		switch (key) {
-		case -1:
-			/*
- 			 * FIXME we need to check if it was
- 			 * es.reason == NEWT_EXIT_TIMER
- 			 */
+		case K_TIMER:
 			if (timer != NULL)
 				timer(arg);
 
 			if (delay_secs != 0)
 				symbol__annotate_decay_histogram(sym, evidx);
 			continue;
-		case NEWT_KEY_TAB:
+		case K_TAB:
 			if (nd != NULL) {
 				nd = rb_prev(nd);
 				if (nd == NULL)
@@ -284,7 +281,7 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 			} else
 				nd = self->curr_hot;
 			break;
-		case NEWT_KEY_UNTAB:
+		case K_UNTAB:
 			if (nd != NULL)
 				nd = rb_next(nd);
 				if (nd == NULL)
@@ -299,8 +296,8 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 			if (annotate_browser__toggle_source(self))
 				ui_helpline__puts(help);
 			continue;
-		case NEWT_KEY_ENTER:
-		case NEWT_KEY_RIGHT:
+		case K_ENTER:
+		case K_RIGHT:
 			if (self->selection == NULL) {
 				ui_helpline__puts("Huh? No selection. Report to linux-kernel@vger.kernel.org");
 				continue;
@@ -350,8 +347,8 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 						     timer, arg, delay_secs);
 			}
 			continue;
-		case NEWT_KEY_LEFT:
-		case NEWT_KEY_ESCAPE:
+		case K_LEFT:
+		case K_ESC:
 		case 'q':
 		case CTRL('c'):
 			goto out;
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index a06e7d9..af12e6f 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -344,7 +344,7 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 			/* Expand the whole world. */
 			hist_browser__set_folding(self, true);
 			break;
-		case NEWT_KEY_ENTER:
+		case K_ENTER:
 			if (hist_browser__toggle_fold(self))
 				break;
 			/* fall thru */
@@ -872,8 +872,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		}
 
 		switch (key) {
-		case NEWT_KEY_TAB:
-		case NEWT_KEY_UNTAB:
+		case K_TAB:
+		case K_UNTAB:
 			if (nr_events == 1)
 				continue;
 			/*
@@ -891,7 +891,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			goto zoom_dso;
 		case 't':
 			goto zoom_thread;
-		case NEWT_KEY_F1:
+		case K_F1:
 		case 'h':
 		case '?':
 			ui__help_window("h/?/F1        Show this window\n"
@@ -909,11 +909,11 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"d             Zoom into current DSO\n"
 					"t             Zoom into current Thread\n");
 			continue;
-		case NEWT_KEY_ENTER:
-		case NEWT_KEY_RIGHT:
+		case K_ENTER:
+		case K_RIGHT:
 			/* menu */
 			break;
-		case NEWT_KEY_LEFT: {
+		case K_LEFT: {
 			const void *top;
 
 			if (pstack__empty(fstack)) {
@@ -931,7 +931,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				goto zoom_out_thread;
 			continue;
 		}
-		case NEWT_KEY_ESCAPE:
+		case K_ESC:
 			if (!left_exits &&
 			    !ui__dialog_yesno("Do you really want to exit?"))
 				continue;
@@ -1091,12 +1091,11 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 		key = ui_browser__run(&menu->b, delay_secs);
 
 		switch (key) {
-		case -1:
-			/* FIXME we need to check if it was es.reason == NEWT_EXIT_TIMER */
+		case K_TIMER:
 			timer(arg);
 			continue;
-		case NEWT_KEY_RIGHT:
-		case NEWT_KEY_ENTER:
+		case K_RIGHT:
+		case K_ENTER:
 			if (!menu->selection)
 				continue;
 			pos = menu->selection;
@@ -1114,19 +1113,19 @@ browse_hists:
 						       arg, delay_secs);
 			ui_browser__show_title(&menu->b, title);
 			switch (key) {
-			case NEWT_KEY_TAB:
+			case K_TAB:
 				if (pos->node.next == &evlist->entries)
 					pos = list_entry(evlist->entries.next, struct perf_evsel, node);
 				else
 					pos = list_entry(pos->node.next, struct perf_evsel, node);
 				goto browse_hists;
-			case NEWT_KEY_UNTAB:
+			case K_UNTAB:
 				if (pos->node.prev == &evlist->entries)
 					pos = list_entry(evlist->entries.prev, struct perf_evsel, node);
 				else
 					pos = list_entry(pos->node.prev, struct perf_evsel, node);
 				goto browse_hists;
-			case NEWT_KEY_ESCAPE:
+			case K_ESC:
 				if (!ui__dialog_yesno("Do you really want to exit?"))
 					continue;
 				/* Fall thru */
@@ -1136,9 +1135,9 @@ browse_hists:
 			default:
 				continue;
 			}
-		case NEWT_KEY_LEFT:
+		case K_LEFT:
 			continue;
-		case NEWT_KEY_ESCAPE:
+		case K_ESC:
 			if (!ui__dialog_yesno("Do you really want to exit?"))
 				continue;
 			/* Fall thru */
diff --git a/tools/perf/util/ui/keysyms.h b/tools/perf/util/ui/keysyms.h
new file mode 100644
index 0000000..3458b19
--- /dev/null
+++ b/tools/perf/util/ui/keysyms.h
@@ -0,0 +1,25 @@
+#ifndef _PERF_KEYSYMS_H_
+#define _PERF_KEYSYMS_H_ 1
+
+#include "libslang.h"
+
+#define K_DOWN	SL_KEY_DOWN
+#define K_END	SL_KEY_END
+#define K_ENTER	'\r'
+#define K_ESC	033
+#define K_F1	SL_KEY_F(1)
+#define K_HOME	SL_KEY_HOME
+#define K_LEFT	SL_KEY_LEFT
+#define K_PGDN	SL_KEY_NPAGE
+#define K_PGUP	SL_KEY_PPAGE
+#define K_RIGHT	SL_KEY_RIGHT
+#define K_TAB	'\t'
+#define K_UNTAB	SL_KEY_UNTAB
+#define K_UP	SL_KEY_UP
+
+/* Not really keys */
+#define K_TIMER	 -1
+#define K_ERROR	 -2
+#define K_RESIZE -3
+
+#endif /* _PERF_KEYSYMS_H_ */
diff --git a/tools/perf/util/ui/libslang.h b/tools/perf/util/ui/libslang.h
index 2b63e1c..4d54b64 100644
--- a/tools/perf/util/ui/libslang.h
+++ b/tools/perf/util/ui/libslang.h
@@ -24,4 +24,6 @@
 #define sltt_set_color SLtt_set_color
 #endif
 
+#define SL_KEY_UNTAB 0x1000
+
 #endif /* _PERF_UI_SLANG_H_ */
diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
index 5111f1a..1e6ba06 100644
--- a/tools/perf/util/ui/setup.c
+++ b/tools/perf/util/ui/setup.c
@@ -18,6 +18,18 @@ static void newt_suspend(void *d __used)
 	newtResume();
 }
 
+static int ui__init(void)
+{
+	int err = SLkp_init();
+
+	if (err < 0)
+		goto out;
+
+	SLkp_define_keysym((char *)"^(kB)", SL_KEY_UNTAB);
+out:
+	return err;
+}
+
 static void ui__exit(void)
 {
 	SLtt_set_cursor_visibility(1);
@@ -44,6 +56,7 @@ void setup_browser(bool fallback_to_pager)
 
 	use_browser = 1;
 	newtInit();
+	ui__init();
 	newtSetSuspendCallback(newt_suspend, NULL);
 	ui_helpline__init();
 	ui_browser__init();
-- 
1.6.2.5

