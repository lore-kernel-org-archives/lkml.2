Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab0HJUP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:15:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55233 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab0HJUPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:15:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/9] perf ui: Move ui_progress routines to separate file in util/ui/
Date: Tue, 10 Aug 2010 17:15:33 -0300
Message-Id: <1281471339-10878-4-git-send-email-acme@infradead.org>
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
 tools/perf/Makefile           |    2 +
 tools/perf/util/debug.h       |    4 +--
 tools/perf/util/newt.c        |   56 --------------------------------------
 tools/perf/util/ui/progress.c |   60 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/ui/progress.h |   11 +++++++
 5 files changed, 74 insertions(+), 59 deletions(-)
 create mode 100644 tools/perf/util/ui/progress.c
 create mode 100644 tools/perf/util/ui/progress.h

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
-- 
1.6.2.5

