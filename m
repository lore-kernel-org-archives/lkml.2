Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab0INHHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:07:23 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56377 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751848Ab0INHHW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:07:22 -0400
Date: Tue, 14 Sep 2010 03:07:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: [RFC PATCH] sched: START_NICE feature (temporarily niced forks)
Message-ID: <20100914070718.GA25117@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 02:52:23 up 234 days,  9:29,  3 users,  load average: 0.00, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tweaks the nice value of both the parent and the child after a fork
to a higher nice value, but this is only applied to their first slice after the
fork. The goal of this scheme is that their respective vruntime will increment
faster in the first slice after the fork, so a workload doing many forks (e.g.
make -j10) will have a limited impact on latency-sensitive workloads.

This is an alternative to START_DEBIT which does not have the downside of moving
newly forked threads to the end of the runqueue.

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

maximum latency: 9873.9 탎
average latency: 901.2 탎
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
 kernel/sched.c          |   16 ++++++++++++++--
 kernel/sched_fair.c     |   30 +++++++++++++++++++++++++++++-
 kernel/sched_features.h |    6 ++++++
 4 files changed, 51 insertions(+), 3 deletions(-)

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
@@ -1829,6 +1829,8 @@ static void dec_nr_running(struct rq *rq
 
 static void set_load_weight(struct task_struct *p)
 {
+	unsigned int prio;
+
 	if (task_has_rt_policy(p)) {
 		p->se.load.weight = 0;
 		p->se.load.inv_weight = WMULT_CONST;
@@ -1844,8 +1846,10 @@ static void set_load_weight(struct task_
 		return;
 	}
 
-	p->se.load.weight = prio_to_weight[p->static_prio - MAX_RT_PRIO];
-	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
+	prio = min_t(unsigned int, MAX_PRIO,
+		     p->static_prio + p->se.fork_nice_penality);
+	p->se.load.weight = prio_to_weight[prio - MAX_RT_PRIO];
+	p->se.load.inv_weight = prio_to_wmult[prio - MAX_RT_PRIO];
 }
 
 static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
@@ -2421,6 +2425,8 @@ static void __sched_fork(struct task_str
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
+	p->se.fork_nice_timeout		= 0;
+	p->se.fork_nice_penality	= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
@@ -2482,7 +2488,13 @@ void sched_fork(struct task_struct *p, i
 
 	if (p->sched_class->task_fork)
 		p->sched_class->task_fork(p);
+	if (sched_feat(START_NICE)) {
+		struct rq *rq = this_rq();
 
+		p->sched_class->put_prev_task(rq, current);
+		set_load_weight(p);
+		p->sched_class->set_curr_task(rq);
+	}
 	/*
 	 * The child is not yet in the pid-hash so no cgroup attach races,
 	 * and the cgroup is pinned to this child due to cgroup_fork()
Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.git/kernel/sched_fair.c
@@ -513,6 +513,16 @@ __update_curr(struct cfs_rq *cfs_rq, str
 	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
 
 	curr->vruntime += delta_exec_weighted;
+	if (curr->fork_nice_penality && curr->fork_nice_timeout != -1UL) {
+		curr->fork_nice_timeout -= delta_exec;
+		/*
+		 * We cannot update load here while task is enqueued, so
+		 * perform the update lazily at the end of the current (or next)
+		 * dequeue.
+		 */
+		if ((s64)curr->fork_nice_timeout < 0)
+			curr->fork_nice_timeout = -1UL;
+	}
 	update_min_vruntime(cfs_rq);
 }
 
@@ -832,6 +842,16 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	 */
 	if (!(flags & DEQUEUE_SLEEP))
 		se->vruntime -= cfs_rq->min_vruntime;
+
+	/*
+	 * We can only set the weight back to its normal value when the task is
+	 * dequeued.
+	 */
+	if (se->fork_nice_timeout == -1UL) {
+		se->fork_nice_penality = 0;
+		set_load_weight(task_of(se));
+		se->fork_nice_timeout = 0;
+	}
 }
 
 /*
@@ -3544,8 +3564,16 @@ static void task_fork_fair(struct task_s
 
 	update_curr(cfs_rq);
 
-	if (curr)
+	if (curr) {
 		se->vruntime = curr->vruntime;
+		if (sched_feat(START_NICE)) {
+			curr->fork_nice_timeout += sched_slice(cfs_rq, curr);
+			curr->fork_nice_penality += 3;	/* about 50% lighter */
+			se->fork_nice_timeout = curr->fork_nice_timeout;
+			se->fork_nice_penality = curr->fork_nice_penality;
+			set_load_weight(p);
+		}
+	}
 	place_entity(cfs_rq, se, 1);
 
 	if (sysctl_sched_child_runs_first && curr && entity_before(curr, se)) {
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
