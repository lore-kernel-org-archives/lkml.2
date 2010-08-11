Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab0HKHk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:40:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:48384 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612Ab0HKHky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:40:54 -0400
Date: Wed, 11 Aug 2010 07:40:35 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Move ui_progress routines to separate file in util/ui/
Message-ID: <tip-34cea7f7c0620c964676eece258ef431a6608bce@git.kernel.org>
Git-Commit-ID: 34cea7f7c0620c964676eece258ef431a6608bce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 11 Aug 2010 07:40:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34cea7f7c0620c964676eece258ef431a6608bce
Gitweb:     http://git.kernel.org/tip/34cea7f7c0620c964676eece258ef431a6608bce
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sun, 8 Aug 2010 19:56:47 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Aug 2010 16:09:14 -0300

perf ui: Move ui_progress routines to separate file in util/ui/

LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile           |    2 +
 tools/perf/util/debug.h       |    4 +--
 tools/perf/util/newt.c        |   56 --------------------------------------
 tools/perf/util/ui/progress.c |   60 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/ui/progress.h |   11 +++++++
 5 files changed, 74 insertions(+), 59 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d77a101..528c914 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -570,8 +570,10 @@ else
 		LIB_OBJS += $(OUTPUT)util/newt.o
 		LIB_OBJS += $(OUTPUT)util/ui/browser.o
 		LIB_OBJS += $(OUTPUT)util/ui/helpline.o
+		LIB_OBJS += $(OUTPUT)util/ui/progress.o
 		LIB_H += util/ui/browser.h
 		LIB_H += util/ui/helpline.h
+		LIB_H += util/ui/progress.h
 	endif
 endif
 
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 047ac33..a929b06 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -31,9 +31,7 @@ static inline void ui_progress__update(struct ui_progress *self __used,
 static inline void ui_progress__delete(struct ui_progress *self __used) {}
 #else
 int browser__show_help(const char *format, va_list ap);
-struct ui_progress *ui_progress__new(const char *title, u64 total);
-void ui_progress__update(struct ui_progress *self, u64 curr);
-void ui_progress__delete(struct ui_progress *self);
+#include "ui/progress.h"
 #endif
 
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 23f3b7d..c0986d3 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -39,62 +39,6 @@
 
 newtComponent newt_form__new(void);
 
-struct ui_progress {
-	newtComponent form, scale;
-};
-
-struct ui_progress *ui_progress__new(const char *title, u64 total)
-{
-	struct ui_progress *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		int cols;
-
-		if (use_browser <= 0)	
-			return self;
-		newtGetScreenSize(&cols, NULL);
-		cols -= 4;
-		newtCenteredWindow(cols, 1, title);
-		self->form  = newtForm(NULL, NULL, 0);
-		if (self->form == NULL)
-			goto out_free_self;
-		self->scale = newtScale(0, 0, cols, total);
-		if (self->scale == NULL)
-			goto out_free_form;
-		newtFormAddComponent(self->form, self->scale);
-		newtRefresh();
-	}
-
-	return self;
-
-out_free_form:
-	newtFormDestroy(self->form);
-out_free_self:
-	free(self);
-	return NULL;
-}
-
-void ui_progress__update(struct ui_progress *self, u64 curr)
-{
-	/*
-	 * FIXME: We should have a per UI backend way of showing progress,
-	 * stdio will just show a percentage as NN%, etc.
-	 */
-	if (use_browser <= 0)
-		return;
-	newtScaleSet(self->scale, curr);
-	newtRefresh();
-}
-
-void ui_progress__delete(struct ui_progress *self)
-{
-	if (use_browser > 0) {
-		newtFormDestroy(self->form);
-		newtPopWindow();
-	}
-	free(self);
-}
-
 static int ui_entry__read(const char *title, char *bf, size_t size, int width)
 {
 	struct newtExitStruct es;
diff --git a/tools/perf/util/ui/progress.c b/tools/perf/util/ui/progress.c
new file mode 100644
index 0000000..d7fc399
--- /dev/null
+++ b/tools/perf/util/ui/progress.c
@@ -0,0 +1,60 @@
+#include <stdlib.h>
+#include <newt.h>
+#include "../cache.h"
+#include "progress.h"
+
+struct ui_progress {
+	newtComponent form, scale;
+};
+
+struct ui_progress *ui_progress__new(const char *title, u64 total)
+{
+	struct ui_progress *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		int cols;
+
+		if (use_browser <= 0)
+			return self;
+		newtGetScreenSize(&cols, NULL);
+		cols -= 4;
+		newtCenteredWindow(cols, 1, title);
+		self->form  = newtForm(NULL, NULL, 0);
+		if (self->form == NULL)
+			goto out_free_self;
+		self->scale = newtScale(0, 0, cols, total);
+		if (self->scale == NULL)
+			goto out_free_form;
+		newtFormAddComponent(self->form, self->scale);
+		newtRefresh();
+	}
+
+	return self;
+
+out_free_form:
+	newtFormDestroy(self->form);
+out_free_self:
+	free(self);
+	return NULL;
+}
+
+void ui_progress__update(struct ui_progress *self, u64 curr)
+{
+	/*
+	 * FIXME: We should have a per UI backend way of showing progress,
+	 * stdio will just show a percentage as NN%, etc.
+	 */
+	if (use_browser <= 0)
+		return;
+	newtScaleSet(self->scale, curr);
+	newtRefresh();
+}
+
+void ui_progress__delete(struct ui_progress *self)
+{
+	if (use_browser > 0) {
+		newtFormDestroy(self->form);
+		newtPopWindow();
+	}
+	free(self);
+}
diff --git a/tools/perf/util/ui/progress.h b/tools/perf/util/ui/progress.h
new file mode 100644
index 0000000..a3820a0
--- /dev/null
+++ b/tools/perf/util/ui/progress.h
@@ -0,0 +1,11 @@
+#ifndef _PERF_UI_PROGRESS_H_
+#define _PERF_UI_PROGRESS_H_ 1
+
+struct ui_progress;
+
+struct ui_progress *ui_progress__new(const char *title, u64 total);
+void ui_progress__delete(struct ui_progress *self);
+
+void ui_progress__update(struct ui_progress *self, u64 curr);
+
+#endif
