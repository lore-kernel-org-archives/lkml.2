Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187Ab2EKGeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:34:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57118 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2EKGeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:34:07 -0400
Date: Thu, 10 May 2012 23:33:50 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-ca09b2e1b307724666577859eb460ac6d4c67330@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@gmail.com
In-Reply-To: <1335761711-31403-2-git-send-email-namhyung.kim@lge.com>
References: <1335761711-31403-2-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Make setup_browser() generic
Git-Commit-ID: ca09b2e1b307724666577859eb460ac6d4c67330
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:33:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca09b2e1b307724666577859eb460ac6d4c67330
Gitweb:     http://git.kernel.org/tip/ca09b2e1b307724666577859eb460ac6d4c67330
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 30 Apr 2012 13:55:05 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 2 May 2012 16:17:20 -0300

perf ui: Make setup_browser() generic

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
 1 files changed, 25 insertions(+), 19 deletions(-)

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
