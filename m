Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab0HJUPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:15:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657Ab0HJUPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:15:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 8/9] perf ui: Complete the breakdown of util/newt.c
Date: Tue, 10 Aug 2010 17:15:38 -0300
Message-Id: <1281471339-10878-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281471339-10878-1-git-send-email-acme@infradead.org>
References: <1281471339-10878-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                    |    7 +-
 tools/perf/util/debug.c                |    2 +-
 tools/perf/util/debug.h                |    6 +-
 tools/perf/util/newt.c                 |  170 --------------------------------
 tools/perf/util/ui/browsers/annotate.c |    2 +-
 tools/perf/util/ui/browsers/hists.c    |    8 +-
 tools/perf/util/ui/helpline.c          |   26 +++++
 tools/perf/util/ui/helpline.h          |    1 +
 tools/perf/util/ui/setup.c             |   42 ++++++++
 tools/perf/util/ui/util.c              |  114 +++++++++++++++++++++
 tools/perf/util/ui/util.h              |   10 ++
 11 files changed, 203 insertions(+), 185 deletions(-)
 delete mode 100644 tools/perf/util/newt.c
 create mode 100644 tools/perf/util/ui/setup.c
 create mode 100644 tools/perf/util/ui/util.c
 create mode 100644 tools/perf/util/ui/util.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 62e4d6f..41abb90 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -567,18 +567,20 @@ else
 		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
 		BASIC_CFLAGS += -I/usr/include/slang
 		EXTLIBS += -lnewt -lslang
-		LIB_OBJS += $(OUTPUT)util/newt.o
+		LIB_OBJS += $(OUTPUT)util/ui/setup.o
 		LIB_OBJS += $(OUTPUT)util/ui/browser.o
 		LIB_OBJS += $(OUTPUT)util/ui/browsers/annotate.o
 		LIB_OBJS += $(OUTPUT)util/ui/browsers/hists.o
 		LIB_OBJS += $(OUTPUT)util/ui/browsers/map.o
 		LIB_OBJS += $(OUTPUT)util/ui/helpline.o
 		LIB_OBJS += $(OUTPUT)util/ui/progress.o
+		LIB_OBJS += $(OUTPUT)util/ui/util.o
 		LIB_H += util/ui/browser.h
 		LIB_H += util/ui/browsers/map.h
 		LIB_H += util/ui/helpline.h
 		LIB_H += util/ui/libslang.h
 		LIB_H += util/ui/progress.h
+		LIB_H += util/ui/util.h
 	endif
 endif
 
@@ -976,9 +978,6 @@ $(OUTPUT)builtin-init-db.o: builtin-init-db.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
-$(OUTPUT)util/newt.o: util/newt.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
 $(OUTPUT)util/ui/browser.o: util/ui/browser.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 318dab1..f9c7e3a 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -23,7 +23,7 @@ int eprintf(int level, const char *fmt, ...)
 	if (verbose >= level) {
 		va_start(args, fmt);
 		if (use_browser > 0)
-			ret = browser__show_help(fmt, args);
+			ret = ui_helpline__show_help(fmt, args);
 		else
 			ret = vfprintf(stderr, fmt, args);
 		va_end(args);
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index ba4892e..7a17ee0 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -14,7 +14,7 @@ void trace_event(event_t *event);
 struct ui_progress;
 
 #ifdef NO_NEWT_SUPPORT
-static inline int browser__show_help(const char *format __used, va_list ap __used)
+static inline int ui_helpline__show_help(const char *format __used, va_list ap __used)
 {
 	return 0;
 }
@@ -30,8 +30,8 @@ static inline void ui_progress__update(struct ui_progress *self __used,
 
 static inline void ui_progress__delete(struct ui_progress *self __used) {}
 #else
-extern char browser__last_msg[];
-int browser__show_help(const char *format, va_list ap);
+extern char ui_helpline__last_msg[];
+int ui_helpline__show_help(const char *format, va_list ap);
 #include "ui/progress.h"
 #endif
 
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
deleted file mode 100644
index 6bccdaa..0000000
--- a/tools/perf/util/newt.c
+++ /dev/null
@@ -1,170 +0,0 @@
-#include <newt.h>
-#include <signal.h>
-#include <stdio.h>
-#include <stdbool.h>
-#include <string.h>
-#include <sys/ttydefaults.h>
-
-#include "cache.h"
-#include "debug.h"
-#include "ui/browser.h"
-#include "ui/helpline.h"
-
-newtComponent newt_form__new(void);
-int popup_menu(int argc, char * const argv[]);
-int ui__help_window(const char *text);
-bool dialog_yesno(const char *msg);
-
-char browser__last_msg[1024];
-
-int browser__show_help(const char *format, va_list ap)
-{
-	int ret;
-	static int backlog;
-
-        ret = vsnprintf(browser__last_msg + backlog,
-			sizeof(browser__last_msg) - backlog, format, ap);
-	backlog += ret;
-
-	if (browser__last_msg[backlog - 1] == '\n') {
-		ui_helpline__puts(browser__last_msg);
-		newtRefresh();
-		backlog = 0;
-	}
-
-	return ret;
-}
-
-static void newt_form__set_exit_keys(newtComponent self)
-{
-	newtFormAddHotKey(self, NEWT_KEY_LEFT);
-	newtFormAddHotKey(self, NEWT_KEY_ESCAPE);
-	newtFormAddHotKey(self, 'Q');
-	newtFormAddHotKey(self, 'q');
-	newtFormAddHotKey(self, CTRL('c'));
-}
-
-newtComponent newt_form__new(void)
-{
-	newtComponent self = newtForm(NULL, NULL, 0);
-	if (self)
-		newt_form__set_exit_keys(self);
-	return self;
-}
-
-int popup_menu(int argc, char * const argv[])
-{
-	struct newtExitStruct es;
-	int i, rc = -1, max_len = 5;
-	newtComponent listbox, form = newt_form__new();
-
-	if (form == NULL)
-		return -1;
-
-	listbox = newtListbox(0, 0, argc, NEWT_FLAG_RETURNEXIT);
-	if (listbox == NULL)
-		goto out_destroy_form;
-
-	newtFormAddComponent(form, listbox);
-
-	for (i = 0; i < argc; ++i) {
-		int len = strlen(argv[i]);
-		if (len > max_len)
-			max_len = len;
-		if (newtListboxAddEntry(listbox, argv[i], (void *)(long)i))
-			goto out_destroy_form;
-	}
-
-	newtCenteredWindow(max_len, argc, NULL);
-	newtFormRun(form, &es);
-	rc = newtListboxGetCurrent(listbox) - NULL;
-	if (es.reason == NEWT_EXIT_HOTKEY)
-		rc = -1;
-	newtPopWindow();
-out_destroy_form:
-	newtFormDestroy(form);
-	return rc;
-}
-
-int ui__help_window(const char *text)
-{
-	struct newtExitStruct es;
-	newtComponent tb, form = newt_form__new();
-	int rc = -1;
-	int max_len = 0, nr_lines = 0;
-	const char *t;
-
-	if (form == NULL)
-		return -1;
-
-	t = text;
-	while (1) {
-		const char *sep = strchr(t, '\n');
-		int len;
-
-		if (sep == NULL)
-			sep = strchr(t, '\0');
-		len = sep - t;
-		if (max_len < len)
-			max_len = len;
-		++nr_lines;
-		if (*sep == '\0')
-			break;
-		t = sep + 1;
-	}
-
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
-}
-
-bool dialog_yesno(const char *msg)
-{
-	/* newtWinChoice should really be accepting const char pointers... */
-	char yes[] = "Yes", no[] = "No";
-	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
-}
-
-static void newt_suspend(void *d __used)
-{
-	newtSuspend();
-	raise(SIGTSTP);
-	newtResume();
-}
-
-void setup_browser(void)
-{
-	if (!isatty(1) || !use_browser || dump_trace) {
-		use_browser = 0;
-		setup_pager();
-		return;
-	}
-
-	use_browser = 1;
-	newtInit();
-	newtCls();
-	newtSetSuspendCallback(newt_suspend, NULL);
-	ui_helpline__puts(" ");
-	ui_browser__init();
-}
-
-void exit_browser(bool wait_for_ok)
-{
-	if (use_browser > 0) {
-		if (wait_for_ok) {
-			char title[] = "Fatal Error", ok[] = "Ok";
-			newtWinMessage(title, ok, browser__last_msg);
-		}
-		newtFinished();
-	}
-}
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 783d277..5b01df6 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -86,7 +86,7 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 		return -1;
 
 	if (hist_entry__annotate(self, &head) < 0) {
-		ui__error_window(browser__last_msg);
+		ui__error_window(ui_helpline__last_msg);
 		return -1;
 	}
 
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 9d32a41..cee7998 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -17,10 +17,6 @@
 #include "../util.h"
 #include "map.h"
 
-int ui__help_window(const char *text);
-bool dialog_yesno(const char *msg);
-int popup_menu(int argc, char * const argv[]);
-
 struct hist_browser {
 	struct ui_browser   b;
 	struct hists	    *hists;
@@ -798,7 +794,7 @@ do_help:
 			}
 			if (is_exit_key(key)) {
 				if (key == NEWT_KEY_ESCAPE &&
-				    !dialog_yesno("Do you really want to exit?"))
+				    !ui__dialog_yesno("Do you really want to exit?"))
 					continue;
 				break;
 			}
@@ -842,7 +838,7 @@ do_help:
 
 		options[nr_options++] = (char *)"Exit";
 
-		choice = popup_menu(nr_options, options);
+		choice = ui__popup_menu(nr_options, options);
 
 		for (i = 0; i < nr_options - 1; ++i)
 			free(options[i]);
diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/util/ui/helpline.c
index 6a11e13..ff58460 100644
--- a/tools/perf/util/ui/helpline.c
+++ b/tools/perf/util/ui/helpline.c
@@ -3,6 +3,7 @@
 #include <stdlib.h>
 #include <newt.h>
 
+#include "../debug.h"
 #include "helpline.h"
 
 void ui_helpline__pop(void)
@@ -41,3 +42,28 @@ void ui_helpline__puts(const char *msg)
 	ui_helpline__pop();
 	ui_helpline__push(msg);
 }
+
+void ui_helpline__init(void)
+{
+	ui_helpline__puts(" ");
+}
+
+char ui_helpline__last_msg[1024];
+
+int ui_helpline__show_help(const char *format, va_list ap)
+{
+	int ret;
+	static int backlog;
+
+        ret = vsnprintf(ui_helpline__last_msg + backlog,
+			sizeof(ui_helpline__last_msg) - backlog, format, ap);
+	backlog += ret;
+
+	if (ui_helpline__last_msg[backlog - 1] == '\n') {
+		ui_helpline__puts(ui_helpline__last_msg);
+		newtRefresh();
+		backlog = 0;
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/ui/helpline.h b/tools/perf/util/ui/helpline.h
index 56d8c1d..5d1e5e7 100644
--- a/tools/perf/util/ui/helpline.h
+++ b/tools/perf/util/ui/helpline.h
@@ -1,6 +1,7 @@
 #ifndef _PERF_UI_HELPLINE_H_
 #define _PERF_UI_HELPLINE_H_ 1
 
+void ui_helpline__init(void);
 void ui_helpline__pop(void);
 void ui_helpline__push(const char *msg);
 void ui_helpline__fpush(const char *fmt, ...);
diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
new file mode 100644
index 0000000..6620850
--- /dev/null
+++ b/tools/perf/util/ui/setup.c
@@ -0,0 +1,42 @@
+#include <newt.h>
+#include <signal.h>
+#include <stdbool.h>
+
+#include "../cache.h"
+#include "../debug.h"
+#include "browser.h"
+#include "helpline.h"
+
+static void newt_suspend(void *d __used)
+{
+	newtSuspend();
+	raise(SIGTSTP);
+	newtResume();
+}
+
+void setup_browser(void)
+{
+	if (!isatty(1) || !use_browser || dump_trace) {
+		use_browser = 0;
+		setup_pager();
+		return;
+	}
+
+	use_browser = 1;
+	newtInit();
+	newtCls();
+	newtSetSuspendCallback(newt_suspend, NULL);
+	ui_helpline__init();
+	ui_browser__init();
+}
+
+void exit_browser(bool wait_for_ok)
+{
+	if (use_browser > 0) {
+		if (wait_for_ok) {
+			char title[] = "Fatal Error", ok[] = "Ok";
+			newtWinMessage(title, ok, ui_helpline__last_msg);
+		}
+		newtFinished();
+	}
+}
diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
new file mode 100644
index 0000000..04600e2
--- /dev/null
+++ b/tools/perf/util/ui/util.c
@@ -0,0 +1,114 @@
+#include <newt.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <string.h>
+#include <sys/ttydefaults.h>
+
+#include "../cache.h"
+#include "../debug.h"
+#include "browser.h"
+#include "helpline.h"
+#include "util.h"
+
+newtComponent newt_form__new(void);
+
+static void newt_form__set_exit_keys(newtComponent self)
+{
+	newtFormAddHotKey(self, NEWT_KEY_LEFT);
+	newtFormAddHotKey(self, NEWT_KEY_ESCAPE);
+	newtFormAddHotKey(self, 'Q');
+	newtFormAddHotKey(self, 'q');
+	newtFormAddHotKey(self, CTRL('c'));
+}
+
+newtComponent newt_form__new(void)
+{
+	newtComponent self = newtForm(NULL, NULL, 0);
+	if (self)
+		newt_form__set_exit_keys(self);
+	return self;
+}
+
+int ui__popup_menu(int argc, char * const argv[])
+{
+	struct newtExitStruct es;
+	int i, rc = -1, max_len = 5;
+	newtComponent listbox, form = newt_form__new();
+
+	if (form == NULL)
+		return -1;
+
+	listbox = newtListbox(0, 0, argc, NEWT_FLAG_RETURNEXIT);
+	if (listbox == NULL)
+		goto out_destroy_form;
+
+	newtFormAddComponent(form, listbox);
+
+	for (i = 0; i < argc; ++i) {
+		int len = strlen(argv[i]);
+		if (len > max_len)
+			max_len = len;
+		if (newtListboxAddEntry(listbox, argv[i], (void *)(long)i))
+			goto out_destroy_form;
+	}
+
+	newtCenteredWindow(max_len, argc, NULL);
+	newtFormRun(form, &es);
+	rc = newtListboxGetCurrent(listbox) - NULL;
+	if (es.reason == NEWT_EXIT_HOTKEY)
+		rc = -1;
+	newtPopWindow();
+out_destroy_form:
+	newtFormDestroy(form);
+	return rc;
+}
+
+int ui__help_window(const char *text)
+{
+	struct newtExitStruct es;
+	newtComponent tb, form = newt_form__new();
+	int rc = -1;
+	int max_len = 0, nr_lines = 0;
+	const char *t;
+
+	if (form == NULL)
+		return -1;
+
+	t = text;
+	while (1) {
+		const char *sep = strchr(t, '\n');
+		int len;
+
+		if (sep == NULL)
+			sep = strchr(t, '\0');
+		len = sep - t;
+		if (max_len < len)
+			max_len = len;
+		++nr_lines;
+		if (*sep == '\0')
+			break;
+		t = sep + 1;
+	}
+
+	tb = newtTextbox(0, 0, max_len, nr_lines, 0);
+	if (tb == NULL)
+		goto out_destroy_form;
+
+	newtTextboxSetText(tb, text);
+	newtFormAddComponent(form, tb);
+	newtCenteredWindow(max_len, nr_lines, NULL);
+	newtFormRun(form, &es);
+	newtPopWindow();
+	rc = 0;
+out_destroy_form:
+	newtFormDestroy(form);
+	return rc;
+}
+
+bool ui__dialog_yesno(const char *msg)
+{
+	/* newtWinChoice should really be accepting const char pointers... */
+	char yes[] = "Yes", no[] = "No";
+	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
+}
diff --git a/tools/perf/util/ui/util.h b/tools/perf/util/ui/util.h
new file mode 100644
index 0000000..afcbc1d
--- /dev/null
+++ b/tools/perf/util/ui/util.h
@@ -0,0 +1,10 @@
+#ifndef _PERF_UI_UTIL_H_
+#define _PERF_UI_UTIL_H_ 1
+
+#include <stdbool.h>
+
+int ui__popup_menu(int argc, char * const argv[]);
+int ui__help_window(const char *text);
+bool ui__dialog_yesno(const char *msg);
+
+#endif /* _PERF_UI_UTIL_H_ */
-- 
1.6.2.5

