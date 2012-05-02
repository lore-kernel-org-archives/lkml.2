Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab2EBT1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:27:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:56705 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab2EBTZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:25:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/15] perf ui: Make setup_browser() generic
Date: Wed,  2 May 2012 16:24:58 -0300
Message-Id: <1335986702-9408-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335986702-9408-1-git-send-email-acme@infradead.org>
References: <1335986702-9408-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The setup_browser contained newt-related codes in it.

As gtk front-end added recently, it should be more generic to handle
both cases properly.

So move newt codes to the ui__init() for now.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335761711-31403-2-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/setup.c |   44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 85a69fa..becdcd0 100644
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
1.7.9.2.358.g22243

