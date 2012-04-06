Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2DFHPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:15:33 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37410 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab2DFHPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:15:32 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: [PATCH 10/16] sched: add resource limits for -deadline tasks.
Date: Fri,  6 Apr 2012 09:14:35 +0200
Message-Id: <1333696481-3433-11-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Faggioli <raistlin@linux.it>

Add resource limits for non-root tasks in using the SCHED_DEADLINE
policy, very similarly to what already exists for RT policies.

In fact, this patch:
 - adds the resource limit RLIMIT_DLDLINE, which is the minimum value
   a user task can use as its own deadline;
 - adds the resource limit RLIMIT_DLRTIME, which is the maximum value
   a user task can use as it own runtime.

Notice that to exploit these, a modified version of the ulimit
utility and a modified resource.h header file are needed. They
both will be available on the website of the project.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 include/asm-generic/resource.h |    7 ++++++-
 kernel/sched.c                 |   25 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/resource.h b/include/asm-generic/resource.h
index 61fa862..a682848 100644
--- a/include/asm-generic/resource.h
+++ b/include/asm-generic/resource.h
@@ -45,7 +45,10 @@
 					   0-39 for nice level 19 .. -20 */
 #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
 #define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
-#define RLIM_NLIMITS		16
+
+#define RLIMIT_DLDLINE		16	/* minimum deadline in us */
+#define RLIMIT_DLRTIME		17	/* maximum runtime in us */
+#define RLIM_NLIMITS		18
 
 /*
  * SuS says limits have to be unsigned.
@@ -87,6 +90,8 @@
 	[RLIMIT_NICE]		= { 0, 0 },				\
 	[RLIMIT_RTPRIO]		= { 0, 0 },				\
 	[RLIMIT_RTTIME]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
+	[RLIMIT_DLDLINE]	= { ULONG_MAX, ULONG_MAX },		\
+	[RLIMIT_DLRTIME]	= { 0, 0 },				\
 }
 
 #endif	/* __KERNEL__ */
diff --git a/kernel/sched.c b/kernel/sched.c
index ea4787a..92d5e26 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5593,6 +5593,31 @@ recheck:
 	 * Allow unprivileged RT tasks to decrease priority:
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
+		if (dl_policy(policy)) {
+			u64 rlim_dline, rlim_rtime;
+			u64 dline, rtime;
+
+			if (!lock_task_sighand(p, &flags))
+				return -ESRCH;
+			rlim_dline = p->signal->rlim[RLIMIT_DLDLINE].rlim_cur;
+			rlim_rtime = p->signal->rlim[RLIMIT_DLRTIME].rlim_cur;
+			unlock_task_sighand(p, &flags);
+
+			/* can't set/change -deadline policy */
+			if (policy != p->policy && !rlim_rtime)
+				return -EPERM;
+
+			/* can't decrease the deadline */
+			rlim_dline *= NSEC_PER_USEC;
+			dline = param->sched_deadline;
+			if (dline < p->dl.dl_deadline && dline < rlim_dline)
+				return -EPERM;
+			/* can't increase the runtime */
+			rlim_rtime *= NSEC_PER_USEC;
+			rtime = param->sched_runtime;
+			if (rtime > p->dl.dl_runtime && rtime > rlim_rtime)
+				return -EPERM;
+		}
 		if (rt_policy(policy)) {
 			unsigned long rlim_rtprio =
 					task_rlimit(p, RLIMIT_RTPRIO);
-- 
1.7.5.4

