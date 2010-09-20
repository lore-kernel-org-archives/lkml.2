Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab0ITTTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:19:33 -0400
Received: from mail.openrapids.net ([64.15.138.104]:52553 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754824Ab0ITTTc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:19:32 -0400
Date: Mon, 20 Sep 2010 15:19:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: [RFC PATCH] sched: START_NICE feature (temporarily niced forks)
	(v4)
Message-ID: <20100920191929.GA29026@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:17:33 up 240 days, 21:54,  5 users,  load average: 0.02, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tweaks the fair vruntime calculation of both the parent and the child
after a fork to double vruntime increment speed, but this is only applied to
their first slice after the fork. The goal of this scheme is that their
respective vruntime will increment faster in the first slice after the fork, so
a workload doing many forks (e.g.  make -j10) will have a limited impact on
latency-sensitive workloads.

This is an alternative to START_DEBIT which does not have the downside of moving
newly forked threads to the end of the runqueue.

Changelog since v3:
- Take Peter Zijlstra's comments into account.
- Move timeout check and penality reset to __update_curr().

Changelog since v2:
- Apply vruntime penality even the first time the exec time has moved across
  the timeout.

Changelog since v1:
- Moving away from modifying the task weight from within the scheduler, as it is
  error-prone: modifying the weight of a queued task leads to cpu weight errors.
  For the moment, just tweak calc_delta_fair vruntime calculation. Eventually we
  could revisit the weight modification approach if we decide that it's worth
  the more intrusive changes. I redid the START_NICE benchmark, which did not
  change much: it is still appealing.


Latency benchmark:

* wakeup-latency.c (SIGEV_THREAD) with make -j10 on UP 2.0GHz

Kernel used: mainline 2.6.35.2 with smaller min_granularity and check_preempt
vruntime vs runtime comparison patches applied.

- START_DEBIT (vanilla setting)

maximum latency: 26409.0 탎
average latency: 6762.1 탎
missed timer events: 0

- NO_START_DEBIT, NO_START_NICE

maximum latency: 10001.8 탎
average latency: 1618.7 탎
missed timer events: 0

- START_NICE

maximum latency: 8351.2 탎
average latency: 1597.7 탎
missed timer events: 0


On the Xorg interactivity aspect, I notice a major improvement with START_NICE
compared to the two other settings. I just came up with a very simple repeatable
low-tech test that takes into account both input and video update
responsiveness:

Start make -j10 in a gnome-terminal
In another gnome-terminal, start pressing the space bar, holding it.
Use the cursor speed (my cursor is a full rectangle) as latency indicator. With
low latency, its speed should be constant, no stopping and no sudden
acceleration.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h   |    2 +
 kernel/sched.c          |    2 +
 kernel/sched_debug.c    |   11 +++++---
 kernel/sched_fair.c     |   65 ++++++++++++++++++++++++++++++++++++++++++------
 kernel/sched_features.h |    6 ++++
 5 files changed, 75 insertions(+), 11 deletions(-)

Index: linux-2.6-lttng.git/kernel/sched_features.h
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_features.h
+++ linux-2.6-lttng.git/kernel/sched_features.h
@@ -12,6 +12,12 @@ SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
 SCHED_FEAT(START_DEBIT, 1)
 
 /*
+ * After a fork, ensure both the parent and the child get niced for their
+ * following slice.
+ */
+SCHED_FEAT(START_NICE, 0)
+
+/*
  * Should wakeups try to preempt running tasks.
  */
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
Index: linux-2.6-lttng.git/include/linux/sched.h
===================================================================
--- linux-2.6-lttng.git.orig/include/linux/sched.h
+++ linux-2.6-lttng.git/include/linux/sched.h
@@ -1132,6 +1132,8 @@ struct sched_entity {
 	u64			prev_sum_exec_runtime;
 
 	u64			nr_migrations;
+	u64			fork_nice_timeout;
+	unsigned int		fork_nice_penality;
 
 #ifdef CONFIG_SCHEDSTATS
 	struct sched_statistics statistics;
Index: linux-2.6-lttng.git/kernel/sched.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched.c
+++ linux-2.6-lttng.git/kernel/sched.c
@@ -2421,6 +2421,8 @@ static void __sched_fork(struct task_str
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
+	p->se.fork_nice_timeout		= 0;
+	p->se.fork_nice_penality	= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.git/kernel/sched_fair.c
@@ -432,6 +432,8 @@ calc_delta_fair(unsigned long delta, str
 {
 	if (unlikely(se->load.weight != NICE_0_LOAD))
 		delta = calc_delta_mine(delta, NICE_0_LOAD, &se->load);
+	if (se->fork_nice_penality)
+		delta <<= se->fork_nice_penality;
 
 	return delta;
 }
@@ -481,6 +483,8 @@ static u64 sched_slice(struct cfs_rq *cf
 			load = &lw;
 		}
 		slice = calc_delta_mine(slice, se->load.weight, load);
+		if (se->fork_nice_penality)
+			slice <<= se->fork_nice_penality;
 	}
 	return slice;
 }
@@ -511,6 +515,13 @@ __update_curr(struct cfs_rq *cfs_rq, str
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
 	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
+	if (curr->fork_nice_penality) {
+		if ((s64)(curr->sum_exec_runtime
+		    - curr->fork_nice_timeout) > 0) {
+			curr->fork_nice_penality = 0;
+			curr->fork_nice_timeout = 0;
+		}
+	}
 
 	curr->vruntime += delta_exec_weighted;
 	update_min_vruntime(cfs_rq);
@@ -830,7 +841,12 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	 * update can refer to the ->curr item and we need to reflect this
 	 * movement in our normalized position.
 	 */
-	if (!(flags & DEQUEUE_SLEEP))
+	if (flags & DEQUEUE_SLEEP) {
+		if (se->fork_nice_penality) {
+			se->fork_nice_penality = 0;
+			se->fork_nice_timeout = 0;
+		}
+	} else
 		se->vruntime -= cfs_rq->min_vruntime;
 }
 
@@ -1576,8 +1592,6 @@ select_task_rq_fair(struct rq *rq, struc
 static unsigned long
 wakeup_gran(struct sched_entity *curr, struct sched_entity *se)
 {
-	unsigned long gran = sysctl_sched_wakeup_granularity;
-
 	/*
 	 * Since its curr running now, convert the gran from real-time
 	 * to virtual-time in his units.
@@ -1591,10 +1605,7 @@ wakeup_gran(struct sched_entity *curr, s
 	 * This is especially important for buddies when the leftmost
 	 * task is higher priority than the buddy.
 	 */
-	if (unlikely(se->load.weight != NICE_0_LOAD))
-		gran = calc_delta_fair(gran, se);
-
-	return gran;
+	return calc_delta_fair(sysctl_sched_wakeup_granularity, se);
 }
 
 /*
@@ -3525,6 +3536,42 @@ static void task_tick_fair(struct rq *rq
 }
 
 /*
+ * Set task nice penality at fork. This is a temporary penality set for both
+ * parent and child at fork, which is removed after a slice.
+ */
+static void task_fork_fair_set_penality(struct cfs_rq *cfs_rq,
+					struct sched_entity *curr,
+					struct sched_entity *se)
+{
+	if (!sched_feat(START_NICE))
+		return;
+
+	if (curr->fork_nice_penality && (s64)(curr->sum_exec_runtime
+					      - curr->fork_nice_timeout) > 0) {
+		curr->fork_nice_penality = 0;
+		curr->fork_nice_timeout = 0;
+	}
+
+	if (!curr->fork_nice_timeout)
+		curr->fork_nice_timeout = curr->sum_exec_runtime;
+	curr->fork_nice_timeout += sched_slice(cfs_rq, curr);
+	/*
+	 * Arbitrarily cap the nice penality to <<= 8, which is 256 times
+	 * lighter than the actual task weight. 256 is about 4 times lighter
+	 * than the range from nice 0 to nice 19, which is 68 times lighter.
+	 * This should be sufficient to gradually penalize fork-happy tasks
+	 * without risking to run into shift overflow problems on deltas which
+	 * are represented on a 64-bit unsigned integer.
+	 */
+	curr->fork_nice_penality = min_t(unsigned int,
+					 curr->fork_nice_penality + 1, 8);
+	/* Child sum_exec_runtime starts at 0 */
+	se->fork_nice_timeout = curr->fork_nice_timeout
+				- curr->sum_exec_runtime;
+	se->fork_nice_penality = curr->fork_nice_penality;
+}
+
+/*
  * called on fork with the child task as argument from the parent's context
  *  - child not yet on the tasklist
  *  - preemption disabled
@@ -3544,8 +3591,10 @@ static void task_fork_fair(struct task_s
 
 	update_curr(cfs_rq);
 
-	if (curr)
+	if (curr) {
 		se->vruntime = curr->vruntime;
+		task_fork_fair_set_penality(cfs_rq, curr, se);
+	}
 	place_entity(cfs_rq, se, 1);
 
 	if (sysctl_sched_child_runs_first && curr && entity_before(curr, se)) {
Index: linux-2.6-lttng.git/kernel/sched_debug.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_debug.c
+++ linux-2.6-lttng.git/kernel/sched_debug.c
@@ -120,6 +120,10 @@ print_task(struct seq_file *m, struct rq
 		SEQ_printf(m, " %s", path);
 	}
 #endif
+
+	SEQ_printf(m, " %d", p->se.fork_nice_penality);
+	SEQ_printf(m, " %9Ld.%06ld", SPLIT_NS(p->se.fork_nice_timeout));
+
 	SEQ_printf(m, "\n");
 }
 
@@ -131,9 +135,10 @@ static void print_rq(struct seq_file *m,
 	SEQ_printf(m,
 	"\nrunnable tasks:\n"
 	"            task   PID         tree-key  switches  prio"
-	"     exec-runtime         sum-exec        sum-sleep\n"
-	"------------------------------------------------------"
-	"----------------------------------------------------\n");
+	"     exec-runtime         sum-exec        sum-sleep    nice-pen"
+	"     nice-pen-timeout\n"
+	"---------------------------------------------------------------"
+	"---------------------------------------------------------------\n");
 
 	read_lock_irqsave(&tasklist_lock, flags);
 
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
