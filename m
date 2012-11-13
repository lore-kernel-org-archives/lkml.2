Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab2KMNbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:31:06 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37184 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2KMNbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:31:04 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/6] perf ui/tui: Move progress.c under ui/tui directory
Date: Tue, 13 Nov 2012 22:30:31 +0900
Message-Id: <1352813436-14173-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current ui_progress functions are implemented for TUI only.  So move
the file under the tui directory.  This is needed for providing an UI-
agnostic wrapper.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile          |    2 +-
 tools/perf/ui/progress.c     |   32 --------------------------------
 tools/perf/ui/tui/progress.c |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 33 deletions(-)
 delete mode 100644 tools/perf/ui/progress.c
 create mode 100644 tools/perf/ui/tui/progress.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9af012f37718..50e85c852656 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -617,11 +617,11 @@ ifndef NO_NEWT
 		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/map.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
-		LIB_OBJS += $(OUTPUT)ui/progress.o
 		LIB_OBJS += $(OUTPUT)ui/util.o
 		LIB_OBJS += $(OUTPUT)ui/tui/setup.o
 		LIB_OBJS += $(OUTPUT)ui/tui/util.o
 		LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
+		LIB_OBJS += $(OUTPUT)ui/tui/progress.o
 		LIB_H += ui/browser.h
 		LIB_H += ui/browsers/map.h
 		LIB_H += ui/keysyms.h
diff --git a/tools/perf/ui/progress.c b/tools/perf/ui/progress.c
deleted file mode 100644
index 13aa64e50e11..000000000000
--- a/tools/perf/ui/progress.c
+++ /dev/null
@@ -1,32 +0,0 @@
-#include "../cache.h"
-#include "progress.h"
-#include "libslang.h"
-#include "ui.h"
-#include "browser.h"
-
-void ui_progress__update(u64 curr, u64 total, const char *title)
-{
-	int bar, y;
-	/*
-	 * FIXME: We should have a per UI backend way of showing progress,
-	 * stdio will just show a percentage as NN%, etc.
-	 */
-	if (use_browser <= 0)
-		return;
-
-	if (total == 0)
-		return;
-
-	ui__refresh_dimensions(true);
-	pthread_mutex_lock(&ui__lock);
-	y = SLtt_Screen_Rows / 2 - 2;
-	SLsmg_set_color(0);
-	SLsmg_draw_box(y, 0, 3, SLtt_Screen_Cols);
-	SLsmg_gotorc(y++, 1);
-	SLsmg_write_string((char *)title);
-	SLsmg_set_color(HE_COLORSET_SELECTED);
-	bar = ((SLtt_Screen_Cols - 2) * curr) / total;
-	SLsmg_fill_region(y, 1, 1, bar, ' ');
-	SLsmg_refresh();
-	pthread_mutex_unlock(&ui__lock);
-}
diff --git a/tools/perf/ui/tui/progress.c b/tools/perf/ui/tui/progress.c
new file mode 100644
index 000000000000..f8dc986e427d
--- /dev/null
+++ b/tools/perf/ui/tui/progress.c
@@ -0,0 +1,32 @@
+#include "../cache.h"
+#include "../progress.h"
+#include "../libslang.h"
+#include "../ui.h"
+#include "../browser.h"
+
+void ui_progress__update(u64 curr, u64 total, const char *title)
+{
+	int bar, y;
+	/*
+	 * FIXME: We should have a per UI backend way of showing progress,
+	 * stdio will just show a percentage as NN%, etc.
+	 */
+	if (use_browser <= 0)
+		return;
+
+	if (total == 0)
+		return;
+
+	ui__refresh_dimensions(true);
+	pthread_mutex_lock(&ui__lock);
+	y = SLtt_Screen_Rows / 2 - 2;
+	SLsmg_set_color(0);
+	SLsmg_draw_box(y, 0, 3, SLtt_Screen_Cols);
+	SLsmg_gotorc(y++, 1);
+	SLsmg_write_string((char *)title);
+	SLsmg_set_color(HE_COLORSET_SELECTED);
+	bar = ((SLtt_Screen_Cols - 2) * curr) / total;
+	SLsmg_fill_region(y, 1, 1, bar, ' ');
+	SLsmg_refresh();
+	pthread_mutex_unlock(&ui__lock);
+}
-- 
1.7.9.2

