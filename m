Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab2C2GiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:38:24 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55510 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab2C2Gg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:36:59 -0400
X-AuditID: 9c93016f-b7c86ae000005478-2d-4f7402ff67e8
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 7/7] perf ui: Change fallback policy of setup_browser()
Date: Thu, 29 Mar 2012 15:36:44 +0900
Message-Id: <1333003004-6391-8-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333003004-6391-1-git-send-email-namhyung.kim@lge.com>
References: <1333003004-6391-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If gtk2 support is not enabled (or failed for some reason) try TUI
again instead of falling directly back to the stdio interface.

Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/ui/gtk/setup.c |    4 ++--
 tools/perf/ui/setup.c     |   14 ++++++++------
 tools/perf/ui/tui/setup.c |    2 +-
 tools/perf/util/cache.h   |   15 ++++++---------
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index 8c3b573e863d..829529957766 100644
--- a/tools/perf/ui/gtk/setup.c
+++ b/tools/perf/ui/gtk/setup.c
@@ -1,9 +1,9 @@
 #include "gtk.h"
 #include "../../util/cache.h"
 
-void perf_gtk__init(bool fallback_to_pager __used)
+int perf_gtk__init(void)
 {
-	gtk_init(NULL, NULL);
+	return gtk_init_check(NULL, NULL) ? 0 : -1;
 }
 
 void perf_gtk__exit(bool wait_for_ok __used)
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 8a2b13378f26..2d653dc9b8de 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -9,14 +9,16 @@ void setup_browser(bool fallback_to_pager)
 
 	switch (use_browser) {
 	case 2:
-		perf_gtk__init(fallback_to_pager);
-		break;
-
+		if (perf_gtk__init() == 0)
+			break;
+		/* fall through */
 	case 1:
-		ui__init(fallback_to_pager);
-		break;
-
+		use_browser = 1;
+		if (ui__init() == 0)
+			break;
+		/* fall through */
 	default:
+		use_browser = 0;
 		if (fallback_to_pager)
 			setup_pager();
 		break;
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index 0194cea2ea0e..d33e943ac434 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -100,7 +100,7 @@ static void ui__signal(int sig)
 	exit(0);
 }
 
-int ui__init(bool fallback_to_pager __used)
+int ui__init(void)
 {
 	int err;
 
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 761d4e998101..cff18c617d13 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -45,27 +45,24 @@ void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 
 #ifdef NO_NEWT_SUPPORT
-static inline int ui__init(bool fallback_to_pager)
+static inline int ui__init(void)
 {
-	if (fallback_to_pager)
-		setup_pager();
-	return 0;
+	return -1;
 }
 static inline void ui__exit(bool wait_for_ok __used) {}
 #else
-int ui__init(bool fallback_to_pager);
+int ui__init(void);
 void ui__exit(bool wait_for_ok);
 #endif
 
 #ifdef NO_GTK2_SUPPORT
-static inline void perf_gtk__init(bool fallback_to_pager)
+static inline int perf_gtk__init(void)
 {
-	if (fallback_to_pager)
-		setup_pager();
+	return -1;
 }
 static inline void perf_gtk__exit(bool wait_for_ok __used) {}
 #else
-void perf_gtk__init(bool fallback_to_pager);
+int perf_gtk__init(void);
 void perf_gtk__exit(bool wait_for_ok);
 #endif
 #endif /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
-- 
1.7.7.6

