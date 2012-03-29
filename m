Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2C2Gha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:37:30 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45958 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab2C2Ggv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:36:51 -0400
X-AuditID: 9c93016f-b7c86ae000005478-21-4f7402ffe1ca
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 3/7] perf ui: Make setup_browser() generic
Date: Thu, 29 Mar 2012 15:36:40 +0900
Message-Id: <1333003004-6391-4-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333003004-6391-1-git-send-email-namhyung.kim@lge.com>
References: <1333003004-6391-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The setup_browser contained newt-related codes in it.
As gtk front-end added recently, it should be more
generic to handle both cases properly. So move newt
codes to the ui__init() for now.

Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/ui/setup.c |   44 +++++++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index d111b0047324..9947ec0f7fd1 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -93,14 +93,37 @@ static void newt_suspend(void *d __used)
 	newtResume();
 }
 
+static void ui__exit(void);
+
+static void ui__signal(int sig)
+{
+	ui__exit();
+	psignal(sig, "perf");
+	exit(0);
+}
+
 static int ui__init(void)
 {
-	int err = SLkp_init();
+	int err;
 
-	if (err < 0)
+	newtInit();
+	err = SLkp_init();
+	if (err < 0) {
+		pr_err("TUI initialization failed.\n");
 		goto out;
+	}
 
 	SLkp_define_keysym((char *)"^(kB)", SL_KEY_UNTAB);
+
+	newtSetSuspendCallback(newt_suspend, NULL);
+	ui_helpline__init();
+	ui_browser__init();
+
+	signal(SIGSEGV, ui__signal);
+	signal(SIGFPE, ui__signal);
+	signal(SIGINT, ui__signal);
+	signal(SIGQUIT, ui__signal);
+	signal(SIGTERM, ui__signal);
 out:
 	return err;
 }
@@ -113,13 +136,6 @@ static void ui__exit(void)
 	SLang_reset_tty();
 }
 
-static void ui__signal(int sig)
-{
-	ui__exit();
-	psignal(sig, "perf");
-	exit(0);
-}
-
 void setup_browser(bool fallback_to_pager)
 {
 	if (!isatty(1) || !use_browser || dump_trace) {
@@ -130,17 +146,7 @@ void setup_browser(bool fallback_to_pager)
 	}
 
 	use_browser = 1;
-	newtInit();
 	ui__init();
-	newtSetSuspendCallback(newt_suspend, NULL);
-	ui_helpline__init();
-	ui_browser__init();
-
-	signal(SIGSEGV, ui__signal);
-	signal(SIGFPE, ui__signal);
-	signal(SIGINT, ui__signal);
-	signal(SIGQUIT, ui__signal);
-	signal(SIGTERM, ui__signal);
 }
 
 void exit_browser(bool wait_for_ok)
-- 
1.7.7.6

