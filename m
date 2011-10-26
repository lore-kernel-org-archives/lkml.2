Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853Ab1JZRts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:49:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:54971 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778Ab1JZRsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:48:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/11] perf ui browser: Handle K_RESIZE in dialog windows
Date: Wed, 26 Oct 2011 15:48:33 -0200
Message-Id: <1319651314-29404-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319651314-29404-1-git-send-email-acme@infradead.org>
References: <1319651314-29404-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just provide wrappers for things like ui__warning, ui__dialog_yesno and
if they return K_RESIZE, refresh dimensions, redraw the entries, etc.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3ih7hyk9weryxaxb501sfq4u@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/debug.c             |    7 +++--
 tools/perf/util/debug.h             |    6 ++--
 tools/perf/util/ui/browser.c        |   40 +++++++++++++++++++++++++++++++++++
 tools/perf/util/ui/browser.h        |    5 ++++
 tools/perf/util/ui/browsers/hists.c |   22 +++++++++++++------
 tools/perf/util/ui/helpline.c       |    6 +++++
 tools/perf/util/ui/helpline.h       |    2 +
 tools/perf/util/ui/util.c           |   27 ++++++++++++++---------
 tools/perf/util/ui/util.h           |    5 ++-
 9 files changed, 94 insertions(+), 26 deletions(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 5563403..26817da 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -47,19 +47,20 @@ int dump_printf(const char *fmt, ...)
 }
 
 #ifdef NO_NEWT_SUPPORT
-void ui__warning(const char *format, ...)
+int ui__warning(const char *format, ...)
 {
 	va_list args;
 
 	va_start(args, format);
 	vfprintf(stderr, format, args);
 	va_end(args);
+	return 0;
 }
 #endif
 
-void ui__error_paranoid(void)
+int ui__error_paranoid(void)
 {
-	ui__error("Permission error - are you root?\n"
+	return ui__error("Permission error - are you root?\n"
 		    "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
 		    " -1 - Not paranoid at all\n"
 		    "  0 - Disallow raw tracepoint access for unpriv\n"
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 16cc752..f2ce88d 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -27,10 +27,10 @@ static inline void ui_progress__update(u64 curr __used, u64 total __used,
 extern char ui_helpline__last_msg[];
 int ui_helpline__show_help(const char *format, va_list ap);
 #include "ui/progress.h"
-void ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
+int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 #endif
 
-void ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
-void ui__error_paranoid(void);
+int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
+int ui__error_paranoid(void);
 
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 8607efa..d2051be 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -169,6 +169,46 @@ void ui_browser__refresh_dimensions(struct ui_browser *self)
 	self->x = 0;
 }
 
+void ui_browser__handle_resize(struct ui_browser *browser)
+{
+	ui__refresh_dimensions(false);
+	ui_browser__show(browser, browser->title, ui_helpline__current);
+	ui_browser__refresh(browser);
+}
+
+int ui_browser__warning(struct ui_browser *browser, const char *format, ...)
+{
+	va_list args;
+	int key;
+
+	va_start(args, format);
+	while ((key = __ui__warning("Warning!", format, args)) == K_RESIZE)
+		ui_browser__handle_resize(browser);
+	va_end(args);
+
+	return key;
+}
+
+int ui_browser__help_window(struct ui_browser *browser, const char *text)
+{
+	int key;
+
+	while ((key = ui__help_window(text)) == K_RESIZE)
+		ui_browser__handle_resize(browser);
+
+	return key;
+}
+
+bool ui_browser__dialog_yesno(struct ui_browser *browser, const char *text)
+{
+	int key;
+
+	while ((key = ui__dialog_yesno(text)) == K_RESIZE)
+		ui_browser__handle_resize(browser);
+
+	return key == K_ENTER || toupper(key) == 'Y';
+}
+
 void ui_browser__reset_index(struct ui_browser *self)
 {
 	self->index = self->top_idx = 0;
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 81a8d2a..fb1c598 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -43,6 +43,11 @@ void ui_browser__hide(struct ui_browser *self);
 int ui_browser__refresh(struct ui_browser *self);
 int ui_browser__run(struct ui_browser *browser, int delay_secs);
 void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries);
+void ui_browser__handle_resize(struct ui_browser *browser);
+
+int ui_browser__warning(struct ui_browser *browser, const char *format, ...);
+int ui_browser__help_window(struct ui_browser *browser, const char *text);
+bool ui_browser__dialog_yesno(struct ui_browser *browser, const char *text);
 
 void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence);
 unsigned int ui_browser__argv_refresh(struct ui_browser *browser);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 44210d4..b8733c0 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -17,6 +17,7 @@
 #include "../browser.h"
 #include "../helpline.h"
 #include "../util.h"
+#include "../ui.h"
 #include "map.h"
 
 struct hist_browser {
@@ -882,7 +883,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			goto out_free_stack;
 		case 'a':
 			if (!browser->has_symbols) {
-				ui__warning(
+				ui_browser__warning(&browser->b,
 			"Annotation is only available for symbolic views, "
 			"include \"sym\" in --sort to use it.");
 				continue;
@@ -900,7 +901,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		case K_F1:
 		case 'h':
 		case '?':
-			ui__help_window("h/?/F1        Show this window\n"
+			ui_browser__help_window(&browser->b,
+					"h/?/F1        Show this window\n"
 					"UP/DOWN/PGUP\n"
 					"PGDN/SPACE    Navigate\n"
 					"q/ESC/CTRL+C  Exit browser\n\n"
@@ -939,7 +941,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		}
 		case K_ESC:
 			if (!left_exits &&
-			    !ui__dialog_yesno("Do you really want to exit?"))
+			    !ui_browser__dialog_yesno(&browser->b,
+					       "Do you really want to exit?"))
 				continue;
 			/* Fall thru */
 		case 'q':
@@ -992,6 +995,7 @@ add_exit_option:
 
 		if (choice == annotate) {
 			struct hist_entry *he;
+			int err;
 do_annotate:
 			he = hist_browser__selected_entry(browser);
 			if (he == NULL)
@@ -1000,10 +1004,12 @@ do_annotate:
 			 * Don't let this be freed, say, by hists__decay_entry.
 			 */
 			he->used = true;
-			hist_entry__tui_annotate(he, evsel->idx, nr_events,
-						 timer, arg, delay_secs);
+			err = hist_entry__tui_annotate(he, evsel->idx, nr_events,
+						       timer, arg, delay_secs);
 			he->used = false;
 			ui_browser__update_nr_entries(&browser->b, browser->hists->nr_entries);
+			if (err)
+				ui_browser__handle_resize(&browser->b);
 		} else if (choice == browse_map)
 			map__browse(browser->selection->map);
 		else if (choice == zoom_dso) {
@@ -1132,7 +1138,8 @@ browse_hists:
 					pos = list_entry(pos->node.prev, struct perf_evsel, node);
 				goto browse_hists;
 			case K_ESC:
-				if (!ui__dialog_yesno("Do you really want to exit?"))
+				if (!ui_browser__dialog_yesno(&menu->b,
+						"Do you really want to exit?"))
 					continue;
 				/* Fall thru */
 			case 'q':
@@ -1144,7 +1151,8 @@ browse_hists:
 		case K_LEFT:
 			continue;
 		case K_ESC:
-			if (!ui__dialog_yesno("Do you really want to exit?"))
+			if (!ui_browser__dialog_yesno(&menu->b,
+					       "Do you really want to exit?"))
 				continue;
 			/* Fall thru */
 		case 'q':
diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/util/ui/helpline.c
index 600243d..6ef3c56 100644
--- a/tools/perf/util/ui/helpline.c
+++ b/tools/perf/util/ui/helpline.c
@@ -1,6 +1,7 @@
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 
 #include "../debug.h"
 #include "helpline.h"
@@ -11,12 +12,17 @@ void ui_helpline__pop(void)
 {
 }
 
+char ui_helpline__current[512];
+
 void ui_helpline__push(const char *msg)
 {
+	const size_t sz = sizeof(ui_helpline__current);
+
 	SLsmg_gotorc(SLtt_Screen_Rows - 1, 0);
 	SLsmg_set_color(0);
 	SLsmg_write_nstring((char *)msg, SLtt_Screen_Cols);
 	SLsmg_refresh();
+	strncpy(ui_helpline__current, msg, sz)[sz - 1] = '\0';
 }
 
 void ui_helpline__vpush(const char *fmt, va_list ap)
diff --git a/tools/perf/util/ui/helpline.h b/tools/perf/util/ui/helpline.h
index fdcbc02..7bab6b3 100644
--- a/tools/perf/util/ui/helpline.h
+++ b/tools/perf/util/ui/helpline.h
@@ -11,4 +11,6 @@ void ui_helpline__vpush(const char *fmt, va_list ap);
 void ui_helpline__fpush(const char *fmt, ...);
 void ui_helpline__puts(const char *msg);
 
+extern char ui_helpline__current[];
+
 #endif /* _PERF_UI_HELPLINE_H_ */
diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index ef9b793..45daa7c 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -121,43 +121,48 @@ int ui__help_window(const char *text)
 	return ui__question_window("Help", text, "Press any key...", 0);
 }
 
-bool ui__dialog_yesno(const char *msg)
+int ui__dialog_yesno(const char *msg)
 {
-	int answer = ui__question_window(NULL, msg, "Enter: Yes, ESC: No", 0);
-
-	return answer == K_ENTER;
+	return ui__question_window(NULL, msg, "Enter: Yes, ESC: No", 0);
 }
 
-static void __ui__warning(const char *title, const char *format, va_list args)
+int __ui__warning(const char *title, const char *format, va_list args)
 {
 	char *s;
 
 	if (use_browser > 0 && vasprintf(&s, format, args) > 0) {
+		int key;
+
 		pthread_mutex_lock(&ui__lock);
-		ui__question_window(title, s, "Press any key...", 0);
+		key = ui__question_window(title, s, "Press any key...", 0);
 		pthread_mutex_unlock(&ui__lock);
 		free(s);
-		return;
+		return key;
 	}
 
 	fprintf(stderr, "%s:\n", title);
 	vfprintf(stderr, format, args);
+	return K_ESC;
 }
 
-void ui__warning(const char *format, ...)
+int ui__warning(const char *format, ...)
 {
+	int key;
 	va_list args;
 
 	va_start(args, format);
-	__ui__warning("Warning", format, args);
+	key = __ui__warning("Warning", format, args);
 	va_end(args);
+	return key;
 }
 
-void ui__error(const char *format, ...)
+int ui__error(const char *format, ...)
 {
+	int key;
 	va_list args;
 
 	va_start(args, format);
-	__ui__warning("Error", format, args);
+	key = __ui__warning("Error", format, args);
 	va_end(args);
+	return key;
 }
diff --git a/tools/perf/util/ui/util.h b/tools/perf/util/ui/util.h
index 9a25538..2d1738b 100644
--- a/tools/perf/util/ui/util.h
+++ b/tools/perf/util/ui/util.h
@@ -1,13 +1,14 @@
 #ifndef _PERF_UI_UTIL_H_
 #define _PERF_UI_UTIL_H_ 1
 
-#include <stdbool.h>
+#include <stdarg.h>
 
 int ui__getch(int delay_secs);
 int ui__popup_menu(int argc, char * const argv[]);
 int ui__help_window(const char *text);
-bool ui__dialog_yesno(const char *msg);
+int ui__dialog_yesno(const char *msg);
 int ui__question_window(const char *title, const char *text,
 			const char *exit_msg, int delay_secs);
+int __ui__warning(const char *title, const char *format, va_list args);
 
 #endif /* _PERF_UI_UTIL_H_ */
-- 
1.6.2.5

