Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0HZSOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:14:54 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56604 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab0HZSOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:14:46 -0400
Message-Id: <20100826181341.378571531@efficios.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 Aug 2010 14:09:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 08/11] sched input interactivity-driven next buddy
References: <20100826180908.648103531@efficios.com>
Content-Disposition: inline; filename=sched-input-buddy.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 26 Aug 2010 18:13:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Impact: implement INTERACTIVE feature to increase Xorg responsiveness. ]

Apply next buddy logic to interactivity-driven wakeups. Don't pass the
interactivity flag across forks to defuse interactivity-based fork-bombs. The
goal of this patch is to ensure that Xorg keeps a good interactivity level by
ensuring that Xorg and its related threads quickly respond to wakeups caused by
user inputs.

Derived from a patch from Peter Zijlstra.

* This patch also makes sure that as soon as an iowait is perceived, the
  interactivity chain is stopped.
* This patch removes the previously available "NEXT_BUDDY" scheduler feature
  altogether.

On my 2.0GHz uniprocessor desktop, enabling the INTERACTIVE feature makes
firefox very responsive even if I overcommit my CPU with a make -j5 kernel
build.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 drivers/input/evdev.c   |    2 ++
 include/linux/sched.h   |   31 +++++++++++++++++++++++--------
 kernel/sched.c          |   12 +++++++++++-
 kernel/sched_fair.c     |   26 +++++++++++++++++++-------
 kernel/sched_features.h |   11 ++++-------
 5 files changed, 59 insertions(+), 23 deletions(-)

Index: linux-2.6-lttng.laptop/drivers/input/evdev.c
===================================================================
--- linux-2.6-lttng.laptop.orig/drivers/input/evdev.c
+++ linux-2.6-lttng.laptop/drivers/input/evdev.c
@@ -78,6 +78,7 @@ static void evdev_event(struct input_han
 	event.code = code;
 	event.value = value;
 
+	sched_wake_interactive_enable();
 	rcu_read_lock();
 
 	client = rcu_dereference(evdev->grab);
@@ -90,6 +91,7 @@ static void evdev_event(struct input_han
 	rcu_read_unlock();
 
 	wake_up_interruptible(&evdev->wait);
+	sched_wake_interactive_disable();
 }
 
 static int evdev_fasync(int fd, struct file *file, int on)
Index: linux-2.6-lttng.laptop/include/linux/sched.h
===================================================================
--- linux-2.6-lttng.laptop.orig/include/linux/sched.h
+++ linux-2.6-lttng.laptop/include/linux/sched.h
@@ -1024,14 +1024,17 @@ struct sched_domain;
 /*
  * wake flags
  */
-#define WF_SYNC		0x01		/* waker goes to sleep after wakup */
-#define WF_FORK		0x02		/* child wakeup after fork */
+#define WF_SYNC		(1 << 0)	/* waker goes to sleep after wakup */
+#define WF_FORK		(1 << 1)	/* child wakeup after fork */
+#define WF_INTERACTIVE	(1 << 2)	/* interactivity-driven wakeup */
+
+#define ENQUEUE_WAKEUP	(1 << 0)
+#define ENQUEUE_WAKING	(1 << 1)
+#define ENQUEUE_HEAD	(1 << 2)
+#define ENQUEUE_IO	(1 << 3)
+#define ENQUEUE_LATENCY	(1 << 4)
 
-#define ENQUEUE_WAKEUP		1
-#define ENQUEUE_WAKING		2
-#define ENQUEUE_HEAD		4
-
-#define DEQUEUE_SLEEP		1
+#define DEQUEUE_SLEEP	(1 << 0)
 
 struct sched_class {
 	const struct sched_class *next;
@@ -1124,7 +1127,8 @@ struct sched_entity {
 	struct load_weight	load;		/* for load-balancing */
 	struct rb_node		run_node;
 	struct list_head	group_node;
-	unsigned int		on_rq;
+	unsigned int		on_rq:1,
+				interactive:1;
 
 	u64			exec_start;
 	u64			sum_exec_runtime;
@@ -1237,6 +1241,7 @@ struct task_struct {
 	unsigned sched_in_iowait:1;		/* Called io_schedule() */
 	unsigned sched_reset_on_fork:1;		/* Revert to default
 						 * priority/policy on fork */
+	unsigned sched_wake_interactive:4;	/* User-driven wakeup */
 
 	pid_t pid;
 	pid_t tgid;
@@ -1502,6 +1507,16 @@ struct task_struct {
 #endif
 };
 
+static inline void sched_wake_interactive_enable(void)
+{
+	current->sched_wake_interactive++;
+}
+
+static inline void sched_wake_interactive_disable(void)
+{
+	current->sched_wake_interactive--;
+}
+
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
Index: linux-2.6-lttng.laptop/kernel/sched.c
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/sched.c
+++ linux-2.6-lttng.laptop/kernel/sched.c
@@ -2288,6 +2288,13 @@ static int try_to_wake_up(struct task_st
 	unsigned long en_flags = ENQUEUE_WAKEUP;
 	struct rq *rq;
 
+	if (sched_feat(INTERACTIVE) && !(wake_flags & WF_FORK)) {
+		if (current->sched_wake_interactive ||
+				wake_flags & WF_INTERACTIVE ||
+				current->se.interactive)
+			en_flags |= ENQUEUE_LATENCY;
+	}
+
 	this_cpu = get_cpu();
 
 	smp_wmb();
@@ -3613,8 +3620,11 @@ need_resched_nonpreemptible:
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev)))
 			prev->state = TASK_RUNNING;
-		else
+		else {
+			if (sched_feat(INTERACTIVE))
+				prev->se.interactive = 0;
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
+		}
 		switch_count = &prev->nvcsw;
 	}
 
Index: linux-2.6-lttng.laptop/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.laptop/kernel/sched_fair.c
@@ -774,6 +774,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	account_entity_enqueue(cfs_rq, se);
 
 	if (flags & ENQUEUE_WAKEUP) {
+		if (sched_feat(INTERACTIVE)
+		    && flags & ENQUEUE_LATENCY && !(flags & ENQUEUE_IO))
+			se->interactive = 1;
 		place_entity(cfs_rq, se, 0);
 		enqueue_sleeper(cfs_rq, se);
 	}
@@ -916,14 +919,14 @@ static struct sched_entity *pick_next_en
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
 	struct sched_entity *left = se;
 
-	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
-		se = cfs_rq->next;
+	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
+		se = cfs_rq->last;
 
 	/*
-	 * Prefer last buddy, try to return the CPU to a preempted task.
+	 * Prefer the next buddy, only set through the interactivity logic.
 	 */
-	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
-		se = cfs_rq->last;
+	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
+		se = cfs_rq->next;
 
 	clear_buddies(cfs_rq, se);
 
@@ -1046,6 +1049,9 @@ enqueue_task_fair(struct rq *rq, struct
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
 
+	if (p->sched_in_iowait)
+		flags |= ENQUEUE_IO;
+
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
@@ -1657,6 +1663,7 @@ static void check_preempt_wakeup(struct
 	 * tasks for there to be buddies.
 	 */
 	int buddies = (cfs_rq->nr_running >= 2);
+	int preempt = 0;
 
 	if (unlikely(rt_prio(p->prio)))
 		goto preempt;
@@ -1667,8 +1674,13 @@ static void check_preempt_wakeup(struct
 	if (unlikely(se == pse))
 		return;
 
-	if (sched_feat(NEXT_BUDDY) && buddies && !(wake_flags & WF_FORK))
+	if (sched_feat(INTERACTIVE)
+	    && !(wake_flags & WF_FORK) && pse->interactive) {
+		clear_buddies(cfs_rq, NULL);
 		set_next_buddy(pse);
+		preempt = 1;
+		buddies = 0;
+	}
 
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
@@ -1694,7 +1706,7 @@ static void check_preempt_wakeup(struct
 	update_curr(cfs_rq);
 	find_matching_se(&se, &pse);
 	BUG_ON(!pse);
-	if (wakeup_preempt_entity(se, pse) == 1)
+	if (preempt || wakeup_preempt_entity(se, pse) == 1)
 		goto preempt;
 
 	return;
Index: linux-2.6-lttng.laptop/kernel/sched_features.h
===================================================================
--- linux-2.6-lttng.laptop.orig/kernel/sched_features.h
+++ linux-2.6-lttng.laptop/kernel/sched_features.h
@@ -26,13 +26,6 @@ SCHED_FEAT(WAKEUP_PREEMPT, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
 
 /*
- * Prefer to schedule the task we woke last (assuming it failed
- * wakeup-preemption), since its likely going to consume data we
- * touched, increases cache locality.
- */
-SCHED_FEAT(NEXT_BUDDY, 0)
-
-/*
  * Prefer to schedule the task that ran last (when we did
  * wake-preempt) as that likely will touch the same data, increases
  * cache locality.
@@ -61,6 +54,10 @@ SCHED_FEAT(ASYM_EFF_LOAD, 1)
  * ensures the spread does not grow beyond control.
  */
 SCHED_FEAT(DYN_MIN_VRUNTIME, 0)
+/*
+ * Input subsystem next buddy affinity. Not transitive across new task wakeups.
+ */
+SCHED_FEAT(INTERACTIVE, 0)
 
 /*
  * Spin-wait on mutex acquisition when the mutex owner is running on

