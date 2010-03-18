Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab0CRJ3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:29:12 -0400
Received: from mga05.intel.com ([192.55.52.89]:13545 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751284Ab0CRJ3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:29:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,265,1267430400"; 
   d="scan'208";a="550106655"
Subject: [PATCH 1/3] perf events: Enable counters when collecting
 process-wide or system-wide data by 'perf stat'
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 18 Mar 2010 17:31:01 +0800
Message-Id: <1268904661.2813.170.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tool perf has a couple of sub commands. There are a couple of issues around
counter enabling time point. In addition, we want a precise time clock
when collect system-wide or process/thread-wide statistics.

I worked out 3 patches against tips/master tree of March 17 to fix such issues
and enhance perf to be more user-friendly.


Subject: [PATCH 1/3] perf events: Enable counters when collecting process-wide or system-wide data by 'perf stat'
From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

Command 'perf stat' doesn't enable counters when collecting an existing (by -p) process
or a system-wide statistics. Fix the issue.
Change the condition of fork/exec subcommand. If there is a subcommand parameter,
perf always fork/exec it. The usage example is:
#perf stat -a sleep 10

So this command could collect statistics for 10 seconds precisely. User
still could stop it by CTRL+C. Without the new capability, user could only
use CTRL+C to stop it without precise time clock.

Another issue is 'perf stat -a' consumes 100% time of a full single logical cpu. It
has a bad impact on running workload. Fix it by adding a sleep(1) in the while(!done)
loop in function run_perf_stat.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6_tipmaster0317/tools/perf/builtin-stat.c linux-2.6_tipmaster0317_fixstat/tools/perf/builtin-stat.c
--- linux-2.6_tipmaster0317/tools/perf/builtin-stat.c	2010-03-18 09:04:40.938289813 +0800
+++ linux-2.6_tipmaster0317_fixstat/tools/perf/builtin-stat.c	2010-03-18 13:07:26.773773541 +0800
@@ -159,8 +159,10 @@ static void create_perf_stat_counter(int
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
@@ -251,9 +253,9 @@ static int run_perf_stat(int argc __used
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
@@ -265,10 +267,10 @@ static int run_perf_stat(int argc __used
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
@@ -297,8 +299,6 @@ static int run_perf_stat(int argc __used
 			exit(-1);
 		}
 
-		child_pid = pid;
-
 		/*
 		 * Wait for the child to be ready to exec.
 		 */
@@ -309,6 +309,10 @@ static int run_perf_stat(int argc __used
 		close(child_ready_pipe[0]);
 	}
 
+	if (target_pid == -1)
+		pid = child_pid;
+	else
+		pid = target_pid;
 	for (counter = 0; counter < nr_counters; counter++)
 		create_perf_stat_counter(counter, pid);
 
@@ -321,7 +325,7 @@ static int run_perf_stat(int argc __used
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


