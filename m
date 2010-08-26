Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0HZSPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:15:03 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47501 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab0HZSOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:14:48 -0400
Message-Id: <20100826181340.837434020@efficios.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 Aug 2010 14:09:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 06/11] sched: dynamic min_vruntime
References: <20100826180908.648103531@efficios.com>
Content-Disposition: inline; filename=sched-dyn-min-vruntime.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 26 Aug 2010 18:13:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Impact: Fixes the large vruntime spread problems I identified last fall, but
	  might have bad side-effects on Xorg interactivity. See the INTERACTIVE
          feature in a following patch that addresses this. ]

Push the scheduler dynamic min_vruntime upon deschedule. This ensures that the
following workload won't grow the spread to insanely large values over time
(give it 1-2 minutes), thus making the scheduler behave oddly with combined Xorg
and latency-sensitive threads: Xorg gets at the beginning of the spread, and the
latency-sensitive workloads get to be somewhere in the middle of the spread.

periodic-fork.sh:

#!/etc/sh

while ((1)); do
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
        tac /etc/passwd > /dev/null;
sleep 1;
done

My test program is wakeup-latency.c, provided by Nokia originally. A 10ms timer
spawns a thread which reads the time, and shows a warning if the expected
deadline has been missed by too much. It also warns about timer overruns.
It's available at:

http://www.efficios.com/pub/elc2010/wakeup-latency-0.1.tar.bz2

With periodic-fork.sh running and Xorg, without the DYN_MIN_VRUNTIME feature,
but with the INTERACTIVE, INTERACTIVE_FORK_EXPEDITED, TIMER and
TIMER_FORK_EXPEDITED features enabled:

....
min priority: 0, max priority: 0
late by: 6765.8 µs
late by: 5536.1 µs
overruns: 1
late by: 12212.3 µs
late by: 5477.5 µs
overruns: 1
late by: 12259.3 µs
overruns: 1
late by: 12224.9 µs
overruns: 1
late by: 12214.3 µs
overruns: 1
late by: 12196.2 µs

maximum latency: 12259.3 µs
average latency: 46.4 µs
missed timer events: 5

Now same workload with the DYN_MIN_VRUNTIME feature enabled:

min priority: 0, max priority: 0

maximum latency: 2908.3 µs
average latency: 6.9 µs
missed timer events: 0

Inspired from a patch done by Peter Zijlstra.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c     |   15 ++++++++++-----
 kernel/sched_features.h |    6 ++++++
 2 files changed, 16 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.git/kernel/sched_fair.c
@@ -301,9 +301,9 @@ static inline s64 entity_key(struct cfs_
 	return se->vruntime - cfs_rq->min_vruntime;
 }
 
-static void update_min_vruntime(struct cfs_rq *cfs_rq)
+static void update_min_vruntime(struct cfs_rq *cfs_rq, unsigned long delta_exec)
 {
-	u64 vruntime = cfs_rq->min_vruntime;
+	u64 vruntime = cfs_rq->min_vruntime, new_vruntime;
 
 	if (cfs_rq->curr)
 		vruntime = cfs_rq->curr->vruntime;
@@ -319,7 +319,12 @@ static void update_min_vruntime(struct c
 			vruntime = min_vruntime(vruntime, se->vruntime);
 	}
 
-	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
+	new_vruntime = cfs_rq->min_vruntime;
+	if (sched_feat(DYN_MIN_VRUNTIME) && delta_exec)
+		new_vruntime += calc_delta_mine(delta_exec, NICE_0_LOAD,
+						&cfs_rq->load);
+
+	cfs_rq->min_vruntime = max_vruntime(new_vruntime, vruntime);
 }
 
 /*
@@ -513,7 +518,7 @@ __update_curr(struct cfs_rq *cfs_rq, str
 	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
 
 	curr->vruntime += delta_exec_weighted;
-	update_min_vruntime(cfs_rq);
+	update_min_vruntime(cfs_rq, delta_exec);
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -822,7 +827,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
-	update_min_vruntime(cfs_rq);
+	update_min_vruntime(cfs_rq, 0);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
Index: linux-2.6-lttng.git/kernel/sched_features.h
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_features.h
+++ linux-2.6-lttng.git/kernel/sched_features.h
@@ -57,6 +57,12 @@ SCHED_FEAT(LB_SHARES_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 
 /*
+ * Push the min_vruntime spread floor value when descheduling a task. This
+ * ensures the spread does not grow beyond control.
+ */
+SCHED_FEAT(DYN_MIN_VRUNTIME, 0)
+
+/*
  * Spin-wait on mutex acquisition when the mutex owner is running on
  * another cpu -- assumes that when the owner is running, it will soon
  * release the lock. Decreases scheduling overhead.

