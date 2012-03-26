Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2CZIvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 04:51:47 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46627 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab2CZIvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 04:51:41 -0400
X-AuditID: 9c93016f-b7cc6ae00000317e-22-4f702e192a14
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 5/5] perf ui: Change fallback policy of setup_browser()
Date: Mon, 26 Mar 2012 17:51:36 +0900
Message-Id: <1332751896-11210-6-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
References: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If gtk2 support is not enabled (or failed for some reason) try TUI
again instead of falling directly back to the stdio interface.

While at it, rename setup functions properly and remove unused
unused arguments.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/ui/setup.c         |   18 ++++++++++--------
 tools/perf/util/cache.h       |   23 ++++++++++-------------
 tools/perf/util/gtk/browser.c |    6 +++---
 tools/perf/util/ui/setup.c    |    6 +++---
 4 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index ee4916fc8157..5cd36675e6fb 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -11,14 +11,16 @@ void setup_browser(bool fallback_to_pager)
 
 	switch (use_browser) {
 	case 2:
-		perf_gtk__setup_browser(fallback_to_pager);
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
+		if (perf_tui__init() == 0)
+			break;
+		/* fall through */
 	default:
+		use_browser = 0;
 		if (fallback_to_pager)
 			setup_pager();
 		break;
@@ -29,11 +31,11 @@ void exit_browser(bool wait_for_ok)
 {
 	switch (use_browser) {
 	case 2:
-		perf_gtk__exit_browser(wait_for_ok);
+		perf_gtk__exit(wait_for_ok);
 		break;
 
 	case 1:
-		ui__exit(wait_for_ok);
+		perf_tui__exit(wait_for_ok);
 		break;
 
 	default:
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 845571f53121..d50b9f627d9d 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -45,28 +45,25 @@ void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 
 #ifdef NO_NEWT_SUPPORT
-static inline int ui__init(bool fallback_to_pager)
+static inline int perf_tui__init(void)
 {
-	if (fallback_to_pager)
-		setup_pager();
-	return 0;
+	return -1;
 }
-static inline void ui__exit(bool wait_for_ok __used) {}
+static inline void perf_tui__exit(bool wait_for_ok __used) {}
 #else
-int ui__init(bool fallback_to_pager);
-void ui__exit(bool wait_for_ok);
+int perf_tui__init(void);
+void perf_tui__exit(bool wait_for_ok);
 #endif
 
 #ifdef NO_GTK2_SUPPORT
-static inline void perf_gtk__setup_browser(bool fallback_to_pager)
+static inline int perf_gtk__init(void)
 {
-	if (fallback_to_pager)
-		setup_pager();
+	return -1;
 }
-static inline void perf_gtk__exit_browser(bool wait_for_ok __used) {}
+static inline void perf_gtk__exit(bool wait_for_ok __used) {}
 #else
-void perf_gtk__setup_browser(bool fallback_to_pager);
-void perf_gtk__exit_browser(bool wait_for_ok);
+int perf_gtk__init(void);
+void perf_gtk__exit(bool wait_for_ok);
 #endif
 #endif /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
 
diff --git a/tools/perf/util/gtk/browser.c b/tools/perf/util/gtk/browser.c
index 5eafd9b3b783..17520310ea3c 100644
--- a/tools/perf/util/gtk/browser.c
+++ b/tools/perf/util/gtk/browser.c
@@ -9,12 +9,12 @@
 
 #define MAX_COLUMNS			32
 
-void perf_gtk__setup_browser(bool fallback_to_pager __used)
+int perf_gtk__init(void)
 {
-	gtk_init(NULL, NULL);
+	return gtk_init_check(NULL, NULL) ? 0 : -1;
 }
 
-void perf_gtk__exit_browser(bool wait_for_ok __used)
+void perf_gtk__exit(bool wait_for_ok __used)
 {
 	gtk_main_quit();
 }
diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
index 907adfb4e99c..dd33b7b65d3b 100644
--- a/tools/perf/util/ui/setup.c
+++ b/tools/perf/util/ui/setup.c
@@ -95,12 +95,12 @@ static void newt_suspend(void *d __used)
 
 static void ui__signal(int sig)
 {
-	ui__exit(false);
+	perf_tui__exit(false);
 	psignal(sig, "perf");
 	exit(0);
 }
 
-int ui__init(bool fallback_to_pager __used)
+int perf_tui__init(void)
 {
 	int err;
 
@@ -126,7 +126,7 @@ out:
 	return err;
 }
 
-void ui__exit(bool wait_for_ok)
+void perf_tui__exit(bool wait_for_ok)
 {
 	if (wait_for_ok)
 		ui__question_window("Fatal Error",
-- 
1.7.7.6

