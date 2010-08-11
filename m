Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0HKHmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:42:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:48457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab0HKHmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:42:38 -0400
Date: Wed, 11 Aug 2010 07:42:18 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Complete the breakdown of util/newt.c
Message-ID: <tip-1e6dd077a880ba5570beb690523b7a78a91a7615@git.kernel.org>
Git-Commit-ID: 1e6dd077a880ba5570beb690523b7a78a91a7615
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 11 Aug 2010 07:42:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e6dd077a880ba5570beb690523b7a78a91a7615
Gitweb:     http://git.kernel.org/tip/1e6dd077a880ba5570beb690523b7a78a91a7615
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 10 Aug 2010 15:58:50 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Aug 2010 16:11:38 -0300

perf ui: Complete the breakdown of util/newt.c

LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                    |    7 +--
 tools/perf/util/debug.c                |    2 +-
 tools/perf/util/debug.h                |    6 +-
 tools/perf/util/ui/browsers/annotate.c |    2 +-
 tools/perf/util/ui/browsers/hists.c    |    8 +---
 tools/perf/util/ui/helpline.c          |   26 ++++++++++++
 tools/perf/util/ui/helpline.h          |    1 +
 tools/perf/util/ui/setup.c             |   42 +++++++++++++++++++
 tools/perf/util/{newt.c => ui/util.c}  |   70 +++----------------------------
 tools/perf/util/ui/util.h              |   10 +++++
 10 files changed, 96 insertions(+), 78 deletions(-)

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
diff --git a/tools/perf/util/newt.c b/tools/perf/util/ui/util.c
similarity index 63%
rename from tools/perf/util/newt.c
rename to tools/perf/util/ui/util.c
index 6bccdaa..04600e2 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/ui/util.c
@@ -5,35 +5,13 @@
 #include <string.h>
 #include <sys/ttydefaults.h>
 
-#include "cache.h"
-#include "debug.h"
-#include "ui/browser.h"
-#include "ui/helpline.h"
+#include "../cache.h"
+#include "../debug.h"
+#include "browser.h"
+#include "helpline.h"
+#include "util.h"
 
 newtComponent newt_form__new(void);
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
 
 static void newt_form__set_exit_keys(newtComponent self)
 {
@@ -52,7 +30,7 @@ newtComponent newt_form__new(void)
 	return self;
 }
 
-int popup_menu(int argc, char * const argv[])
+int ui__popup_menu(int argc, char * const argv[])
 {
 	struct newtExitStruct es;
 	int i, rc = -1, max_len = 5;
@@ -128,43 +106,9 @@ out_destroy_form:
 	return rc;
 }
 
-bool dialog_yesno(const char *msg)
+bool ui__dialog_yesno(const char *msg)
 {
 	/* newtWinChoice should really be accepting const char pointers... */
 	char yes[] = "Yes", no[] = "No";
 	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
 }
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
