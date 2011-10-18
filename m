Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab1JRVoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 17:44:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:49907 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab1JRVoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 17:44:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/7] perf tui: Catch signals to exit gracefully
Date: Tue, 18 Oct 2011 19:44:02 -0200
Message-Id: <1318974247-6683-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318974247-6683-1-git-send-email-acme@infradead.org>
References: <1318974247-6683-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Resetting the terminal to a sane state.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-myu44ujofadcy3y6an2mk383@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/setup.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
index ee46d67..8b8a57b 100644
--- a/tools/perf/util/ui/setup.c
+++ b/tools/perf/util/ui/setup.c
@@ -7,6 +7,7 @@
 #include "browser.h"
 #include "helpline.h"
 #include "ui.h"
+#include "libslang.h"
 
 pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
 
@@ -17,6 +18,21 @@ static void newt_suspend(void *d __used)
 	newtResume();
 }
 
+static void ui__exit(void)
+{
+	SLtt_set_cursor_visibility(1);
+	SLsmg_refresh();
+	SLsmg_reset_smg();
+	SLang_reset_tty();
+}
+
+static void ui__signal(int sig)
+{
+	ui__exit();
+	psignal(sig, "perf");
+	exit(0);
+}
+
 void setup_browser(bool fallback_to_pager)
 {
 	if (!isatty(1) || !use_browser || dump_trace) {
@@ -32,6 +48,12 @@ void setup_browser(bool fallback_to_pager)
 	newtSetSuspendCallback(newt_suspend, NULL);
 	ui_helpline__init();
 	ui_browser__init();
+
+	signal(SIGSEGV, ui__signal);
+	signal(SIGFPE, ui__signal);
+	signal(SIGINT, ui__signal);
+	signal(SIGQUIT, ui__signal);
+	signal(SIGTERM, ui__signal);
 }
 
 void exit_browser(bool wait_for_ok)
@@ -41,6 +63,6 @@ void exit_browser(bool wait_for_ok)
 			char title[] = "Fatal Error", ok[] = "Ok";
 			newtWinMessage(title, ok, ui_helpline__last_msg);
 		}
-		newtFinished();
+		ui__exit();
 	}
 }
-- 
1.6.2.5

