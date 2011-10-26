Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805Ab1JZRss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:48:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37753 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792Ab1JZRsq (ORCPT
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
Subject: [PATCH 06/11] perf ui: Reimplement the popup windows using libslang
Date: Wed, 26 Oct 2011 15:48:29 -0200
Message-Id: <1319651314-29404-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319651314-29404-1-git-send-email-acme@infradead.org>
References: <1319651314-29404-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
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
Link: http://lkml.kernel.org/n/tip-vtxnmz1t1807ykprapnk9njl@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c             |    9 ++-
 tools/perf/util/debug.h                |    1 +
 tools/perf/util/ui/browsers/annotate.c |   14 +---
 tools/perf/util/ui/setup.c             |    8 +-
 tools/perf/util/ui/util.c              |  110 +++++++++++++++++--------------
 tools/perf/util/ui/util.h              |    2 +
 6 files changed, 77 insertions(+), 67 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index bc8f477..119e996 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -310,9 +310,12 @@ fallback:
 		}
 		err = -ENOENT;
 		dso->annotate_warned = 1;
-		pr_err("Can't annotate %s: No vmlinux file%s was found in the "
-		       "path.\nPlease use 'perf buildid-cache -av vmlinux' or "
-		       "--vmlinux vmlinux.\n",
+		pr_err("Can't annotate %s:\n\n"
+		       "No vmlinux file%s\nwas found in the path.\n\n"
+		       "Please use:\n\n"
+		       "  perf buildid-cache -av vmlinux\n\n"
+		       "or:\n\n"
+		       "  --vmlinux vmlinux",
 		       sym->name, build_id_msg ?: "");
 		goto out_free_filename;
 	}
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 510adac..9c59b95 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -29,5 +29,6 @@ int ui_helpline__show_help(const char *format, va_list ap);
 
 void ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 void ui__warning_paranoid(void);
+void ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 4e0cb7f..0575905 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -1,6 +1,9 @@
+#include "../../util.h"
 #include "../browser.h"
 #include "../helpline.h"
 #include "../libslang.h"
+#include "../ui.h"
+#include "../util.h"
 #include "../../annotate.h"
 #include "../../hist.h"
 #include "../../sort.h"
@@ -8,15 +11,6 @@
 #include <pthread.h>
 #include <newt.h>
 
-static void ui__error_window(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	newtWinMessagev((char *)"Error", (char *)"Ok", (char *)fmt, ap);
-	va_end(ap);
-}
-
 struct annotate_browser {
 	struct ui_browser b;
 	struct rb_root	  entries;
@@ -400,7 +394,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 		return -1;
 
 	if (symbol__annotate(sym, map, sizeof(struct objdump_line_rb_node)) < 0) {
-		ui__error_window(ui_helpline__last_msg);
+		ui__error("%s", ui_helpline__last_msg);
 		return -1;
 	}
 
diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
index c4e025f..85a69fa 100644
--- a/tools/perf/util/ui/setup.c
+++ b/tools/perf/util/ui/setup.c
@@ -146,10 +146,10 @@ void setup_browser(bool fallback_to_pager)
 void exit_browser(bool wait_for_ok)
 {
 	if (use_browser > 0) {
-		if (wait_for_ok) {
-			char title[] = "Fatal Error", ok[] = "Ok";
-			newtWinMessage(title, ok, ui_helpline__last_msg);
-		}
+		if (wait_for_ok)
+			ui__question_window("Fatal Error",
+					    ui_helpline__last_msg,
+					    "Press any key...", 0);
 		ui__exit();
 	}
 }
diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 37e6fe0..ef9b793 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -1,6 +1,5 @@
-#include <newt.h>
+#include "../util.h"
 #include <signal.h>
-#include <stdio.h>
 #include <stdbool.h>
 #include <string.h>
 #include <sys/ttydefaults.h>
@@ -12,6 +11,7 @@
 #include "helpline.h"
 #include "ui.h"
 #include "util.h"
+#include "libslang.h"
 
 static void ui_browser__argv_write(struct ui_browser *browser,
 				   void *entry, int row)
@@ -56,23 +56,6 @@ static int popup_menu__run(struct ui_browser *menu)
 	return key;
 }
 
-static void newt_form__set_exit_keys(newtComponent self)
-{
-	newtFormAddHotKey(self, NEWT_KEY_LEFT);
-	newtFormAddHotKey(self, NEWT_KEY_ESCAPE);
-	newtFormAddHotKey(self, 'Q');
-	newtFormAddHotKey(self, 'q');
-	newtFormAddHotKey(self, CTRL('c'));
-}
-
-static newtComponent newt_form__new(void)
-{
-	newtComponent self = newtForm(NULL, NULL, 0);
-	if (self)
-		newt_form__set_exit_keys(self);
-	return self;
-}
-
 int ui__popup_menu(int argc, char * const argv[])
 {
 	struct ui_browser menu = {
@@ -86,17 +69,13 @@ int ui__popup_menu(int argc, char * const argv[])
 	return popup_menu__run(&menu);
 }
 
-int ui__help_window(const char *text)
+int ui__question_window(const char *title, const char *text,
+			const char *exit_msg, int delay_secs)
 {
-	struct newtExitStruct es;
-	newtComponent tb, form = newt_form__new();
-	int rc = -1;
+	int x, y;
 	int max_len = 0, nr_lines = 0;
 	const char *t;
 
-	if (form == NULL)
-		return -1;
-
 	t = text;
 	while (1) {
 		const char *sep = strchr(t, '\n');
@@ -113,28 +92,56 @@ int ui__help_window(const char *text)
 		t = sep + 1;
 	}
 
-	tb = newtTextbox(0, 0, max_len, nr_lines, 0);
-	if (tb == NULL)
-		goto out_destroy_form;
-
-	newtTextboxSetText(tb, text);
-	newtFormAddComponent(form, tb);
-	newtCenteredWindow(max_len, nr_lines, NULL);
-	newtFormRun(form, &es);
-	newtPopWindow();
-	rc = 0;
-out_destroy_form:
-	newtFormDestroy(form);
-	return rc;
+	max_len += 2;
+	nr_lines += 4;
+	y = SLtt_Screen_Rows / 2 - nr_lines / 2,
+	x = SLtt_Screen_Cols / 2 - max_len / 2;
+
+	SLsmg_set_color(0);
+	SLsmg_draw_box(y, x++, nr_lines, max_len);
+	if (title) {
+		SLsmg_gotorc(y, x + 1);
+		SLsmg_write_string((char *)title);
+	}
+	SLsmg_gotorc(++y, x);
+	nr_lines -= 2;
+	max_len -= 2;
+	SLsmg_write_wrapped_string((unsigned char *)text, y, x,
+				   nr_lines, max_len, 1);
+	SLsmg_gotorc(y + nr_lines - 2, x);
+	SLsmg_write_nstring((char *)" ", max_len);
+	SLsmg_gotorc(y + nr_lines - 1, x);
+	SLsmg_write_nstring((char *)exit_msg, max_len);
+	SLsmg_refresh();
+	return ui__getch(delay_secs);
 }
 
-static const char yes[] = "Yes", no[] = "No",
-		  warning_str[] = "Warning!", ok[] = "Ok";
+int ui__help_window(const char *text)
+{
+	return ui__question_window("Help", text, "Press any key...", 0);
+}
 
 bool ui__dialog_yesno(const char *msg)
 {
-	/* newtWinChoice should really be accepting const char pointers... */
-	return newtWinChoice(NULL, (char *)yes, (char *)no, (char *)msg) == 1;
+	int answer = ui__question_window(NULL, msg, "Enter: Yes, ESC: No", 0);
+
+	return answer == K_ENTER;
+}
+
+static void __ui__warning(const char *title, const char *format, va_list args)
+{
+	char *s;
+
+	if (use_browser > 0 && vasprintf(&s, format, args) > 0) {
+		pthread_mutex_lock(&ui__lock);
+		ui__question_window(title, s, "Press any key...", 0);
+		pthread_mutex_unlock(&ui__lock);
+		free(s);
+		return;
+	}
+
+	fprintf(stderr, "%s:\n", title);
+	vfprintf(stderr, format, args);
 }
 
 void ui__warning(const char *format, ...)
@@ -142,12 +149,15 @@ void ui__warning(const char *format, ...)
 	va_list args;
 
 	va_start(args, format);
-	if (use_browser > 0) {
-		pthread_mutex_lock(&ui__lock);
-		newtWinMessagev((char *)warning_str, (char *)ok,
-				(char *)format, args);
-		pthread_mutex_unlock(&ui__lock);
-	} else
-		vfprintf(stderr, format, args);
+	__ui__warning("Warning", format, args);
+	va_end(args);
+}
+
+void ui__error(const char *format, ...)
+{
+	va_list args;
+
+	va_start(args, format);
+	__ui__warning("Error", format, args);
 	va_end(args);
 }
diff --git a/tools/perf/util/ui/util.h b/tools/perf/util/ui/util.h
index e53c3d3..9a25538 100644
--- a/tools/perf/util/ui/util.h
+++ b/tools/perf/util/ui/util.h
@@ -7,5 +7,7 @@ int ui__getch(int delay_secs);
 int ui__popup_menu(int argc, char * const argv[]);
 int ui__help_window(const char *text);
 bool ui__dialog_yesno(const char *msg);
+int ui__question_window(const char *title, const char *text,
+			const char *exit_msg, int delay_secs);
 
 #endif /* _PERF_UI_UTIL_H_ */
-- 
1.6.2.5

