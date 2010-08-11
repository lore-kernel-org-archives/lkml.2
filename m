Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab0HKHke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:40:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:48372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932635Ab0HKHkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:40:32 -0400
Date: Wed, 11 Aug 2010 07:40:15 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Move ui_helpline routines to separate file in util/ui/
Message-ID: <tip-5575536fc7ad7577a4e687a13e2f49acebc519f3@git.kernel.org>
Git-Commit-ID: 5575536fc7ad7577a4e687a13e2f49acebc519f3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 11 Aug 2010 07:40:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5575536fc7ad7577a4e687a13e2f49acebc519f3
Gitweb:     http://git.kernel.org/tip/5575536fc7ad7577a4e687a13e2f49acebc519f3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sun, 8 Aug 2010 19:48:31 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Aug 2010 16:08:51 -0300

perf ui: Move ui_helpline routines to separate file in util/ui/

LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile           |    2 +
 tools/perf/util/newt.c        |   38 +-----------------------------------
 tools/perf/util/ui/helpline.c |   43 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/ui/helpline.h |    9 ++++++++
 4 files changed, 55 insertions(+), 37 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d5bce76..d77a101 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -569,7 +569,9 @@ else
 		EXTLIBS += -lnewt -lslang
 		LIB_OBJS += $(OUTPUT)util/newt.o
 		LIB_OBJS += $(OUTPUT)util/ui/browser.o
+		LIB_OBJS += $(OUTPUT)util/ui/helpline.o
 		LIB_H += util/ui/browser.h
+		LIB_H += util/ui/helpline.h
 	endif
 endif
 
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 9768be3..23f3b7d 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -24,6 +24,7 @@
 #include "sort.h"
 #include "symbol.h"
 #include "ui/browser.h"
+#include "ui/helpline.h"
 
 #if SLANG_VERSION < 20104
 #define slsmg_printf(msg, args...) SLsmg_printf((char *)msg, ##args)
@@ -94,43 +95,6 @@ void ui_progress__delete(struct ui_progress *self)
 	free(self);
 }
 
-static void ui_helpline__pop(void)
-{
-	newtPopHelpLine();
-}
-
-static void ui_helpline__push(const char *msg)
-{
-	newtPushHelpLine(msg);
-}
-
-static void ui_helpline__vpush(const char *fmt, va_list ap)
-{
-	char *s;
-
-	if (vasprintf(&s, fmt, ap) < 0)
-		vfprintf(stderr, fmt, ap);
-	else {
-		ui_helpline__push(s);
-		free(s);
-	}
-}
-
-static void ui_helpline__fpush(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	ui_helpline__vpush(fmt, ap);
-	va_end(ap);
-}
-
-static void ui_helpline__puts(const char *msg)
-{
-	ui_helpline__pop();
-	ui_helpline__push(msg);
-}
-
 static int ui_entry__read(const char *title, char *bf, size_t size, int width)
 {
 	struct newtExitStruct es;
diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/util/ui/helpline.c
new file mode 100644
index 0000000..6a11e13
--- /dev/null
+++ b/tools/perf/util/ui/helpline.c
@@ -0,0 +1,43 @@
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <newt.h>
+
+#include "helpline.h"
+
+void ui_helpline__pop(void)
+{
+	newtPopHelpLine();
+}
+
+void ui_helpline__push(const char *msg)
+{
+	newtPushHelpLine(msg);
+}
+
+static void ui_helpline__vpush(const char *fmt, va_list ap)
+{
+	char *s;
+
+	if (vasprintf(&s, fmt, ap) < 0)
+		vfprintf(stderr, fmt, ap);
+	else {
+		ui_helpline__push(s);
+		free(s);
+	}
+}
+
+void ui_helpline__fpush(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	ui_helpline__vpush(fmt, ap);
+	va_end(ap);
+}
+
+void ui_helpline__puts(const char *msg)
+{
+	ui_helpline__pop();
+	ui_helpline__push(msg);
+}
diff --git a/tools/perf/util/ui/helpline.h b/tools/perf/util/ui/helpline.h
new file mode 100644
index 0000000..56d8c1d
--- /dev/null
+++ b/tools/perf/util/ui/helpline.h
@@ -0,0 +1,9 @@
+#ifndef _PERF_UI_HELPLINE_H_
+#define _PERF_UI_HELPLINE_H_ 1
+
+void ui_helpline__pop(void);
+void ui_helpline__push(const char *msg);
+void ui_helpline__fpush(const char *fmt, ...);
+void ui_helpline__puts(const char *msg);
+
+#endif /* _PERF_UI_HELPLINE_H_ */
