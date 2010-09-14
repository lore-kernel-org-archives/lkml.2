Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab0INSZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:25:45 -0400
Received: from mail.openrapids.net ([64.15.138.104]:32867 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752060Ab0INSZo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:25:44 -0400
Date: Tue, 14 Sep 2010 14:25:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: [RFC PATCH] sched: START_NICE feature (temporarily niced forks)
	(v2)
Message-ID: <20100914182541.GA25962@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:24:41 up 234 days, 21:01,  4 users,  load average: 0.07, 0.14,
	0.11
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
 include/linux/sched.h   |    2 ++
 kernel/sched.c          |    2 ++
 kernel/sched_debug.c    |   11 ++++++++---
 kernel/sched_fair.c     |   34 +++++++++++++++++++++++++++++++++-
 kernel/sched_features.h |    6 ++++++
 5 files changed, 51 insertions(+), 4 deletions(-)

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
@@ -433,6 +433,14 @@ calc_delta_fair(unsigned long delta, str
 	if (unlikely(se->load.weight != NICE_0_LOAD))
 		delta = calc_delta_mine(delta, NICE_0_LOAD, &se->load);
 
+	if (se->fork_nice_penality) {
+		if ((s64)(se->sum_exec_runtime - se->fork_nice_timeout) > 0) {
+			se->fork_nice_penality = 0;
+			se->fork_nice_timeout = 0;
+		} else
+			delta <<= se->fork_nice_penality;
+	}
+
 	return delta;
 }
 
@@ -832,6 +840,11 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	 */
 	if (!(flags & DEQUEUE_SLEEP))
 		se->vruntime -= cfs_rq->min_vruntime;
+
+	if (se->fork_nice_penality) {
+		se->fork_nice_penality = 0;
+		se->fork_nice_timeout = 0;
+	}
 }
 
 /*
@@ -3544,8 +3557,27 @@ static void task_fork_fair(struct task_s
 
 	update_curr(cfs_rq);
 
-	if (curr)
+	if (curr) {
 		se->vruntime = curr->vruntime;
+		if (sched_feat(START_NICE)) {
+			if (curr->fork_nice_penality &&
+			    (s64)(curr->sum_exec_runtime
+				  - curr->fork_nice_timeout) > 0) {
+				curr->fork_nice_penality = 0;
+				curr->fork_nice_timeout = 0;
+			}
+
+			if (!curr->fork_nice_timeout)
+				curr->fork_nice_timeout =
+					curr->sum_exec_runtime;
+			curr->fork_nice_timeout += sched_slice(cfs_rq, curr);
+			curr->fork_nice_penality = min_t(unsigned int,
+							 curr->fork_nice_penality + 1, 8);
+			se->fork_nice_timeout = curr->fork_nice_timeout
+						- curr->sum_exec_runtime;
+			se->fork_nice_penality = curr->fork_nice_penality;
+		}
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
