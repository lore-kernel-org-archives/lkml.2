Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2KROgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:36:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:59370 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2KROaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/32] perf ui: Introduce generic ui_progress helper
Date: Sun, 18 Nov 2012 11:29:49 -0300
Message-Id: <1353248997-30763-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Make ui_progress functions generic so that UI frontend code will add its
callbacks.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1352813436-14173-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile          |    1 +
 tools/perf/ui/gtk/util.c     |   11 -----------
 tools/perf/ui/progress.c     |   20 ++++++++++++++++++++
 tools/perf/ui/progress.h     |    8 ++++++++
 tools/perf/ui/tui/progress.c |   12 +++++++++++-
 tools/perf/ui/tui/setup.c    |    1 +
 6 files changed, 41 insertions(+), 12 deletions(-)
 create mode 100644 tools/perf/ui/progress.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 50e85c8..f8466b4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -423,6 +423,7 @@ LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
 
 LIB_OBJS += $(OUTPUT)ui/helpline.o
+LIB_OBJS += $(OUTPUT)ui/progress.o
 LIB_OBJS += $(OUTPUT)ui/hist.o
 LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
 
diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
index ccb046a..c06942a 100644
--- a/tools/perf/ui/gtk/util.c
+++ b/tools/perf/ui/gtk/util.c
@@ -111,14 +111,3 @@ struct perf_error_ops perf_gtk_eops = {
 	.warning	= perf_gtk__warning_statusbar,
 #endif
 };
-
-/*
- * FIXME: Functions below should be implemented properly.
- *        For now, just add stubs for NO_NEWT=1 build.
- */
-#ifndef NEWT_SUPPORT
-void ui_progress__update(u64 curr __maybe_unused, u64 total __maybe_unused,
-			 const char *title __maybe_unused)
-{
-}
-#endif
diff --git a/tools/perf/ui/progress.c b/tools/perf/ui/progress.c
new file mode 100644
index 0000000..f5e4d1b
--- /dev/null
+++ b/tools/perf/ui/progress.c
@@ -0,0 +1,20 @@
+#include "../cache.h"
+#include "progress.h"
+
+static void nop_progress_update(u64 curr __maybe_unused,
+				u64 total __maybe_unused,
+				const char *title __maybe_unused)
+{
+}
+
+static struct ui_progress default_progress_fns =
+{
+	.update		= nop_progress_update,
+};
+
+struct ui_progress *progress_fns = &default_progress_fns;
+
+void ui_progress__update(u64 curr, u64 total, const char *title)
+{
+	return progress_fns->update(curr, total, title);
+}
diff --git a/tools/perf/ui/progress.h b/tools/perf/ui/progress.h
index d9c205b..717814b 100644
--- a/tools/perf/ui/progress.h
+++ b/tools/perf/ui/progress.h
@@ -3,6 +3,14 @@
 
 #include <../types.h>
 
+struct ui_progress {
+	void (*update)(u64, u64, const char *);
+};
+
+extern struct ui_progress *progress_fns;
+
+void ui_progress__init(void);
+
 void ui_progress__update(u64 curr, u64 total, const char *title);
 
 #endif
diff --git a/tools/perf/ui/tui/progress.c b/tools/perf/ui/tui/progress.c
index f8dc986..6c2184d 100644
--- a/tools/perf/ui/tui/progress.c
+++ b/tools/perf/ui/tui/progress.c
@@ -4,7 +4,7 @@
 #include "../ui.h"
 #include "../browser.h"
 
-void ui_progress__update(u64 curr, u64 total, const char *title)
+static void tui_progress__update(u64 curr, u64 total, const char *title)
 {
 	int bar, y;
 	/*
@@ -30,3 +30,13 @@ void ui_progress__update(u64 curr, u64 total, const char *title)
 	SLsmg_refresh();
 	pthread_mutex_unlock(&ui__lock);
 }
+
+static struct ui_progress tui_progress_fns =
+{
+	.update		= tui_progress__update,
+};
+
+void ui_progress__init(void)
+{
+	progress_fns = &tui_progress_fns;
+}
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index 60debb8..81efa19 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -118,6 +118,7 @@ int ui__init(void)
 	newtSetSuspendCallback(newt_suspend, NULL);
 	ui_helpline__init();
 	ui_browser__init();
+	ui_progress__init();
 
 	signal(SIGSEGV, ui__signal);
 	signal(SIGFPE, ui__signal);
-- 
1.7.9.2.358.g22243

