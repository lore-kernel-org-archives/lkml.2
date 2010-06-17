Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368Ab0FQUhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:37:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:42952 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342Ab0FQUhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:37:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Ian Munsie <imunsie@au1.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf record: prevent kill(0, SIGTERM);
Date: Thu, 17 Jun 2010 17:36:53 -0300
Message-Id: <1276807013-21626-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1276807013-21626-1-git-send-email-acme@infradead.org>
References: <1276807013-21626-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

At exit, perf record will kill the process it was profiling by sending a
SIGTERM to child_pid (if it had been initialised), but in certain situations
child_pid may be 0 and perf would mistakenly kill more processes than intended.

child_pid is set to the return of fork() to either 0 or the pid of the child.
Ordinarily this would not present an issue as the child calls execvp to spawn
the process to be profiled and would therefore never run it's sig_atexit and
never attempt to kill pid 0.

However, if a nonexistant binary had been passed in to perf record the call to
execvp would fail and child_pid would be left set to 0. The child would then
exit and it's atexit handler, finding that child_pid was initialised to 0,
would call kill(0, SIGTERM), resulting in every process within it's process
group being killed.

In the case that perf was being run directly from the shell this typically
would not be an issue as the shell isolates the process.  However, if perf was
being called from another program it could kill unexpected processes, which may
even include X.

This patch changes the logic of the test for whether child_pid was initialised
to only consider positive pids as valid, thereby never attempting to kill pid
0.

Cc: David S. Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <1276072680-17378-1-git-send-email-imunsie@au1.ibm.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index dc3435e..711745f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -193,7 +193,7 @@ static void sig_handler(int sig)
 
 static void sig_atexit(void)
 {
-	if (child_pid != -1)
+	if (child_pid > 0)
 		kill(child_pid, SIGTERM);
 
 	if (signr == -1)
-- 
1.6.2.5

