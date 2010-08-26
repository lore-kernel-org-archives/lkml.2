Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0HZSOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:14:51 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38180 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab0HZSOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:14:46 -0400
Message-Id: <20100826181341.635603837@efficios.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 Aug 2010 14:09:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 09/11] sched: timer-driven next buddy
References: <20100826180908.648103531@efficios.com>
Content-Disposition: inline; filename=sched-timer-buddy.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 26 Aug 2010 18:13:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Impact: implement TIMER feature to diminish the latencies induced by wakeups
          performed by timer callbacks ]

Ensure that timer callbacks triggering wakeups get served ASAP by giving
timer-driven wakeups next-buddy affinity.

My test program is wakeup-latency.c, provided by Nokia originally. A 10ms timer
spawns a thread which reads the time, and shows a warning if the expected
deadline has been missed by too much. It also warns about timer overruns.

Without the TIMER and TIMER_FORK_EXPEDITED features:

min priority: 0, max priority: 0
[....]
maximum latency: 41453.6 µs
average latency: 4127.0 µs
missed timer events: 0

With the features enabled:

min priority: 0, max priority: 0
[...]
maximum latency: 10013.5 µs
average latency: 162.9 µs
missed timer events: 0

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h     |   16 +++++++++++++++-
 kernel/hrtimer.c          |    2 ++
 kernel/itimer.c           |    2 ++
 kernel/posix-cpu-timers.c |    2 ++
 kernel/posix-timers.c     |    2 ++
 kernel/sched.c            |    9 +++++++++
 kernel/sched_fair.c       |   11 ++++++++---
 kernel/sched_features.h   |    4 ++++
 kernel/timer.c            |    2 ++
 9 files changed, 46 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng.laptop/include/linux/sched.h
===================================================================
--- linux-2.6-lttng.laptop.orig/include/linux/sched.h
+++ linux-2.6-lttng.laptop/include/linux/sched.h
@@ -1027,12 +1027,14 @@ struct sched_domain;
 #define WF_SYNC		(1 << 0)	/* waker goes to sleep after wakup */
 #define WF_FORK		(1 << 1)	/* child wakeup after fork */
 #define WF_INTERACTIVE	(1 << 2)	/* interactivity-driven wakeup */
+#define WF_TIMER	(1 << 3)	/* timer-driven wakeup */
 
 #define ENQUEUE_WAKEUP	(1 << 0)
 #define ENQUEUE_WAKING	(1 << 1)
 #define ENQUEUE_HEAD	(1 << 2)
 #define ENQUEUE_IO	(1 << 3)
 #define ENQUEUE_LATENCY	(1 << 4)
+#define ENQUEUE_TIMER	(1 << 5)
 
 #define DEQUEUE_SLEEP	(1 << 0)
 
@@ -1128,7 +1130,8 @@ struct sched_entity {
 	struct rb_node		run_node;
 	struct list_head	group_node;
 	unsigned int		on_rq:1,
-				interactive:1;
+				interactive:1,
+				timer:1;
 
 	u64			exec_start;
 	u64			sum_exec_runtime;
@@ -1242,6 +1245,7 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;		/* Revert to default
 						 * priority/policy on fork */
 	unsigned sched_wake_interactive:4;	/* User-driven wakeup */
+	unsigned sched_wake_timer:4;		/* Timer-driven wakeup */
 
 	pid_t pid;
 	pid_t tgid;
@@ -1517,6 +1521,16 @@ static inline void sched_wake_interactiv
 	current->sched_wake_interactive--;
 }
 
+static inline void sched_wake_timer_enable(void)
+{
+	current->sched_wake_timer++;
+}
+
+static inline void sched_wake_timer_disable(void)
+{
+	current->sched_wake_timer--;
+}
+
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
Index: linux-2.6-lttng.laptop/kernel/sched_features.h
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/sched_features.h
+++ linux-2.6-lttng.laptop/kernel/sched_features.h
@@ -58,6 +58,10 @@ SCHED_FEAT(DYN_MIN_VRUNTIME, 0)
  * Input subsystem next buddy affinity. Not transitive across new task wakeups.
  */
 SCHED_FEAT(INTERACTIVE, 0)
+/*
+ * Timer subsystem next buddy affinity. Not transitive across new task wakeups.
+ */
+SCHED_FEAT(TIMER, 0)
 
 /*
  * Spin-wait on mutex acquisition when the mutex owner is running on
Index: linux-2.6-lttng.laptop/kernel/sched.c
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/sched.c
+++ linux-2.6-lttng.laptop/kernel/sched.c
@@ -2295,6 +2295,13 @@ static int try_to_wake_up(struct task_st
 			en_flags |= ENQUEUE_LATENCY;
 	}
 
+	if (sched_feat(TIMER) && !(wake_flags & WF_FORK)) {
+		if (current->sched_wake_timer ||
+				wake_flags & WF_TIMER ||
+				current->se.timer)
+			en_flags |= ENQUEUE_TIMER;
+	}
+
 	this_cpu = get_cpu();
 
 	smp_wmb();
@@ -3623,6 +3630,8 @@ need_resched_nonpreemptible:
 		else {
 			if (sched_feat(INTERACTIVE))
 				prev->se.interactive = 0;
+			if (sched_feat(TIMER))
+				prev->se.timer = 0;
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 		}
 		switch_count = &prev->nvcsw;
Index: linux-2.6-lttng.laptop/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.laptop/kernel/sched_fair.c
@@ -777,6 +777,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 		if (sched_feat(INTERACTIVE)
 		    && flags & ENQUEUE_LATENCY && !(flags & ENQUEUE_IO))
 			se->interactive = 1;
+		if (sched_feat(TIMER)
+		    && flags & ENQUEUE_TIMER && !(flags & ENQUEUE_IO))
+			se->timer = 1;
 		place_entity(cfs_rq, se, 0);
 		enqueue_sleeper(cfs_rq, se);
 	}
@@ -923,7 +926,8 @@ static struct sched_entity *pick_next_en
 		se = cfs_rq->last;
 
 	/*
-	 * Prefer the next buddy, only set through the interactivity logic.
+	 * Prefer the next buddy, only set through the interactivity and timer
+	 * logic.
 	 */
 	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
 		se = cfs_rq->next;
@@ -1674,8 +1678,9 @@ static void check_preempt_wakeup(struct
 	if (unlikely(se == pse))
 		return;
 
-	if (sched_feat(INTERACTIVE)
-	    && !(wake_flags & WF_FORK) && pse->interactive) {
+	if (!(wake_flags & WF_FORK)
+	    && ((sched_feat(INTERACTIVE) && pse->interactive)
+		|| (sched_feat(TIMER) && pse->timer))) {
 		clear_buddies(cfs_rq, NULL);
 		set_next_buddy(pse);
 		preempt = 1;
Index: linux-2.6-lttng.laptop/kernel/posix-timers.c
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/posix-timers.c
+++ linux-2.6-lttng.laptop/kernel/posix-timers.c
@@ -402,6 +402,7 @@ static enum hrtimer_restart posix_timer_
 	int si_private = 0;
 	enum hrtimer_restart ret = HRTIMER_NORESTART;
 
+	sched_wake_timer_enable();
 	timr = container_of(timer, struct k_itimer, it.real.timer);
 	spin_lock_irqsave(&timr->it_lock, flags);
 
@@ -456,6 +457,7 @@ static enum hrtimer_restart posix_timer_
 	}
 
 	unlock_timer(timr, flags);
+	sched_wake_timer_disable();
 	return ret;
 }
 
Index: linux-2.6-lttng.laptop/kernel/timer.c
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/timer.c
+++ linux-2.6-lttng.laptop/kernel/timer.c
@@ -1038,6 +1038,7 @@ static void call_timer_fn(struct timer_l
 	 */
 	struct lockdep_map lockdep_map = timer->lockdep_map;
 #endif
+	sched_wake_timer_enable();
 	/*
 	 * Couple the lock chain with the lock chain at
 	 * del_timer_sync() by acquiring the lock_map around the fn()
@@ -1062,6 +1063,7 @@ static void call_timer_fn(struct timer_l
 		 */
 		preempt_count() = preempt_count;
 	}
+	sched_wake_timer_disable();
 }
 
 #define INDEX(N) ((base->timer_jiffies >> (TVR_BITS + (N) * TVN_BITS)) & TVN_MASK)
Index: linux-2.6-lttng.laptop/kernel/hrtimer.c
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/hrtimer.c
+++ linux-2.6-lttng.laptop/kernel/hrtimer.c
@@ -1212,6 +1212,7 @@ static void __run_hrtimer(struct hrtimer
 
 	WARN_ON(!irqs_disabled());
 
+	sched_wake_timer_enable();
 	debug_deactivate(timer);
 	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
 	timer_stats_account_hrtimer(timer);
@@ -1238,6 +1239,7 @@ static void __run_hrtimer(struct hrtimer
 		enqueue_hrtimer(timer, base);
 	}
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
+	sched_wake_timer_disable();
 }
 
 #ifdef CONFIG_HIGH_RES_TIMERS
Index: linux-2.6-lttng.laptop/kernel/itimer.c
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/itimer.c
+++ linux-2.6-lttng.laptop/kernel/itimer.c
@@ -129,7 +129,9 @@ enum hrtimer_restart it_real_fn(struct h
 
 	trace_itimer_expire(ITIMER_REAL, sig->leader_pid, 0);
 	trace_timer_itimer_expired(sig);
+	sched_wake_timer_enable();
 	kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->leader_pid);
+	sched_wake_timer_disable();
 
 	return HRTIMER_NORESTART;
 }
Index: linux-2.6-lttng.laptop/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/posix-cpu-timers.c
+++ linux-2.6-lttng.laptop/kernel/posix-cpu-timers.c
@@ -610,6 +610,7 @@ static void arm_timer(struct k_itimer *t
  */
 static void cpu_timer_fire(struct k_itimer *timer)
 {
+	sched_wake_timer_enable();
 	if ((timer->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE) {
 		/*
 		 * User don't want any signal.
@@ -637,6 +638,7 @@ static void cpu_timer_fire(struct k_itim
 		 */
 		posix_cpu_timer_schedule(timer);
 	}
+	sched_wake_timer_disable();
 }
 
 /*

