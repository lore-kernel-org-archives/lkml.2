Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab1BCPye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:54:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41553 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab1BCPyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:54:32 -0500
Date: Thu, 3 Feb 2011 16:54:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20110203155419.GA13399@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Javi Merino (1):
      sched, docs: Update schedstats documentation to version 15

Peter Zijlstra (1):
      sched: Fix update_curr_rt()


 Documentation/scheduler/sched-stats.txt |   33 ++++++++++++++----------------
 kernel/sched_rt.c                       |    2 +-
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/Documentation/scheduler/sched-stats.txt b/Documentation/scheduler/sched-stats.txt
index 01e6940..1cd5d51 100644
--- a/Documentation/scheduler/sched-stats.txt
+++ b/Documentation/scheduler/sched-stats.txt
@@ -1,3 +1,7 @@
+Version 15 of schedstats dropped counters for some sched_yield:
+yld_exp_empty, yld_act_empty and yld_both_empty. Otherwise, it is
+identical to version 14.
+
 Version 14 of schedstats includes support for sched_domains, which hit the
 mainline kernel in 2.6.20 although it is identical to the stats from version
 12 which was in the kernel from 2.6.13-2.6.19 (version 13 never saw a kernel
@@ -28,32 +32,25 @@ to write their own scripts, the fields are described here.
 
 CPU statistics
 --------------
-cpu<N> 1 2 3 4 5 6 7 8 9 10 11 12
-
-NOTE: In the sched_yield() statistics, the active queue is considered empty
-    if it has only one process in it, since obviously the process calling
-    sched_yield() is that process.
+cpu<N> 1 2 3 4 5 6 7 8 9
 
-First four fields are sched_yield() statistics:
-     1) # of times both the active and the expired queue were empty
-     2) # of times just the active queue was empty
-     3) # of times just the expired queue was empty
-     4) # of times sched_yield() was called
+First field is a sched_yield() statistic:
+     1) # of times sched_yield() was called
 
 Next three are schedule() statistics:
-     5) # of times we switched to the expired queue and reused it
-     6) # of times schedule() was called
-     7) # of times schedule() left the processor idle
+     2) # of times we switched to the expired queue and reused it
+     3) # of times schedule() was called
+     4) # of times schedule() left the processor idle
 
 Next two are try_to_wake_up() statistics:
-     8) # of times try_to_wake_up() was called
-     9) # of times try_to_wake_up() was called to wake up the local cpu
+     5) # of times try_to_wake_up() was called
+     6) # of times try_to_wake_up() was called to wake up the local cpu
 
 Next three are statistics describing scheduling latency:
-    10) sum of all time spent running by tasks on this processor (in jiffies)
-    11) sum of all time spent waiting to run by tasks on this processor (in
+     7) sum of all time spent running by tasks on this processor (in jiffies)
+     8) sum of all time spent waiting to run by tasks on this processor (in
         jiffies)
-    12) # of timeslices run on this cpu
+     9) # of timeslices run on this cpu
 
 
 Domain statistics
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index c914ec7..ad62677 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -625,7 +625,7 @@ static void update_curr_rt(struct rq *rq)
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	u64 delta_exec;
 
-	if (!task_has_rt_policy(curr))
+	if (curr->sched_class != &rt_sched_class)
 		return;
 
 	delta_exec = rq->clock_task - curr->se.exec_start;
