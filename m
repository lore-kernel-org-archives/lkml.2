Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432Ab2EKGiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:38:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759848Ab2EKGiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:38:01 -0400
Date: Thu, 10 May 2012 23:37:10 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-dc41b9b8f02dbe2228ae787d525dac43beebb7fa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@gmail.com
In-Reply-To: <1335761711-31403-6-git-send-email-namhyung.kim@lge.com>
References: <1335761711-31403-6-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Change fallback policy of setup_browser()
Git-Commit-ID: dc41b9b8f02dbe2228ae787d525dac43beebb7fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:37:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc41b9b8f02dbe2228ae787d525dac43beebb7fa
Gitweb:     http://git.kernel.org/tip/dc41b9b8f02dbe2228ae787d525dac43beebb7fa
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 30 Apr 2012 13:55:09 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 2 May 2012 16:17:37 -0300

perf ui: Change fallback policy of setup_browser()

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
