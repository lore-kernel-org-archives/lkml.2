Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab2EBTZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:25:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47299 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab2EBTZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:25:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/15] perf ui: Change fallback policy of setup_browser()
Date: Wed,  2 May 2012 16:25:02 -0300
Message-Id: <1335986702-9408-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335986702-9408-1-git-send-email-acme@infradead.org>
References: <1335986702-9408-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If gtk2 support is not enabled (or failed for some reason) try TUI again
instead of falling directly back to the stdio interface.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335761711-31403-6-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/setup.c |    4 ++--
 tools/perf/ui/setup.c     |   13 +++++++------
 tools/perf/ui/tui/setup.c |    2 +-
 tools/perf/util/cache.h   |   15 ++++++---------
 4 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index 8c3b573..8295299 100644
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
index 98130e0..9f5f888 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -13,13 +13,14 @@ void setup_browser(bool fallback_to_pager)
 
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
 		if (fallback_to_pager)
 			setup_pager();
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index 0194cea..d33e943 100644
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
index 761d4e9..cff18c6 100644
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
1.7.9.2.358.g22243

