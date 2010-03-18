Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab0CROgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:36:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:44827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab0CROgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:36:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Joerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, <zhiteng.huang@intel.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf stat: Enable counters when collecting process-wide or system-wide data
Date: Thu, 18 Mar 2010 11:36:03 -0300
Message-Id: <1268922965-14774-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

Command 'perf stat' doesn't enable counters when collecting an existing
(by -p) process or a system-wide statistics. Fix the issue.

Change the condition of fork/exec subcommand. If there is a subcommand
parameter, perf always fork/exec it. The usage example is:

 # perf stat -a sleep 10

So this command could collect statistics for 10 seconds precisely. User
still could stop it by CTRL+C. Without the new capability, user could
only use CTRL+C to stop it without precise time clock.

Another issue is 'perf stat -a' consumes 100% time of a full single
logical cpu. It has a bad impact on running workload. Fix it by adding a
sleep(1) in the while(!done) loop in function run_perf_stat.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sheng Yang <sheng@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Zachary Amsden <zamsden@redhat.com>
Cc: <zhiteng.huang@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 95db31c..5f41244 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -159,8 +159,10 @@ static void create_perf_stat_counter(int counter, int pid)
 		}
 	} else {
 		attr->inherit	     = inherit;
-		attr->disabled	     = 1;
-		attr->enable_on_exec = 1;
+		if (target_pid == -1) {
+			attr->disabled = 1;
+			attr->enable_on_exec = 1;
+		}
 
 		fd[0][counter] = sys_perf_event_open(attr, pid, -1, -1, 0);
 		if (fd[0][counter] < 0 && verbose)
@@ -251,9 +253,9 @@ static int run_perf_stat(int argc __used, const char **argv)
 	unsigned long long t0, t1;
 	int status = 0;
 	int counter;
-	int pid = target_pid;
+	int pid;
 	int child_ready_pipe[2], go_pipe[2];
-	const bool forks = (target_pid == -1 && argc > 0);
+	const bool forks = (argc > 0);
 	char buf;
 
 	if (!system_wide)
@@ -265,10 +267,10 @@ static int run_perf_stat(int argc __used, const char **argv)
 	}
 
 	if (forks) {
-		if ((pid = fork()) < 0)
+		if ((child_pid = fork()) < 0)
 			perror("failed to fork");
 
-		if (!pid) {
+		if (!child_pid) {
 			close(child_ready_pipe[0]);
 			close(go_pipe[1]);
 			fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
@@ -297,8 +299,6 @@ static int run_perf_stat(int argc __used, const char **argv)
 			exit(-1);
 		}
 
-		child_pid = pid;
-
 		/*
 		 * Wait for the child to be ready to exec.
 		 */
@@ -309,6 +309,10 @@ static int run_perf_stat(int argc __used, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
+	if (target_pid == -1)
+		pid = child_pid;
+	else
+		pid = target_pid;
 	for (counter = 0; counter < nr_counters; counter++)
 		create_perf_stat_counter(counter, pid);
 
@@ -321,7 +325,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 		close(go_pipe[1]);
 		wait(&status);
 	} else {
-		while(!done);
+		while(!done) sleep(1);
 	}
 
 	t1 = rdclock();
@@ -459,7 +463,7 @@ static volatile int signr = -1;
 
 static void skip_signal(int signo)
 {
-	if(target_pid != -1)
+	if(child_pid == -1)
 		done = 1;
 
 	signr = signo;
-- 
1.6.2.5

