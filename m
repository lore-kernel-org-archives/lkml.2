Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab0FIIjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:39:52 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44634 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab0FIIju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:39:50 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH] perf: prevent kill(0, SIGTERM);
Date: Wed,  9 Jun 2010 18:38:00 +1000
Message-Id: <1276072680-17378-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

At exit, perf record will kill the process it was profiling by sending a
SIGTERM to child_pid (if it had been initialised), but in certain
situations child_pid may be 0 and perf would mistakenly kill more
processes than intended.

child_pid is set to the return of fork() to either 0 or the pid of the
child. Ordinarily this would not present an issue as the child calls
execvp to spawn the process to be profilled and would therefore never
run it's sig_atexit and never attempt to kill pid 0.

However, if a nonexistant binary had been passed in to perf record the
call to execvp would fail and child_pid would be left set to 0. The
child would then exit and it's atexit handler, finding that child_pid
was initialised to 0, would call kill(0, SIGTERM), resulting in every
process within it's process group being killed.

In the case that perf was being run directly from the shell this
typically would not be an issue as the shell isolates the process.
However, if perf was being called from another program it could kill
unexpected processes, which may even include X.

This patch changes the logic of the test for whether child_pid was
initialised to only considder positive pids as valid, thereby never
attempting to kill pid 0.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/builtin-record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5e5c640..300da82 100644
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
1.7.1

