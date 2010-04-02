Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab0DBTOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:14:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:46765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab0DBTOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:14:41 -0400
Date: Fri, 2 Apr 2010 19:14:14 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add enqueue/dequeue flags
Message-ID: <tip-371fd7e7a56a5c136d31aa980011bd2f131c3ef5@git.kernel.org>
Git-Commit-ID: 371fd7e7a56a5c136d31aa980011bd2f131c3ef5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:14:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  371fd7e7a56a5c136d31aa980011bd2f131c3ef5
Gitweb:     http://git.kernel.org/tip/371fd7e7a56a5c136d31aa980011bd2f131c3ef5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 24 Mar 2010 16:38:48 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 20:12:05 +0200

sched: Add enqueue/dequeue flags

In order to reduce the dependency on TASK_WAKING rework the enqueue
interface to support a proper flags field.

Replace the int wakeup, bool head arguments with an int flags argument
and create the following flags:

  ENQUEUE_WAKEUP - the enqueue is a wakeup of a sleeping task,
  ENQUEUE_WAKING - the enqueue has relative vruntime due to
                   having sched_class::task_waking() called,
  ENQUEUE_HEAD - the waking task should be places on the head
                 of the priority queue (where appropriate).

For symmetry also convert sched_class::dequeue() to a flags scheme.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h   |   11 ++++++++---
 kernel/sched.c          |   32 +++++++++++++++++---------------
 kernel/sched_fair.c     |   25 ++++++++-----------------
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |    8 ++++----
 5 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fb6c188..e3e900f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1032,12 +1032,17 @@ struct sched_domain;
 #define WF_SYNC		0x01		/* waker goes to sleep after wakup */
 #define WF_FORK		0x02		/* child wakeup after fork */
 
+#define ENQUEUE_WAKEUP		1
+#define ENQUEUE_WAKING		2
+#define ENQUEUE_HEAD		4
+
+#define DEQUEUE_SLEEP		1
+
 struct sched_class {
 	const struct sched_class *next;
 
-	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup,
-			      bool head);
-	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
+	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
+	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*yield_task) (struct rq *rq);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
diff --git a/kernel/sched.c b/kernel/sched.c
index 14c8d2a..4a57e96 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1877,44 +1877,43 @@ static void update_avg(u64 *avg, u64 sample)
 	*avg += diff >> 3;
 }
 
-static void
-enqueue_task(struct rq *rq, struct task_struct *p, int wakeup, bool head)
+static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	update_rq_clock(rq);
 	sched_info_queued(p);
-	p->sched_class->enqueue_task(rq, p, wakeup, head);
+	p->sched_class->enqueue_task(rq, p, flags);
 	p->se.on_rq = 1;
 }
 
-static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
+static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	update_rq_clock(rq);
 	sched_info_dequeued(p);
-	p->sched_class->dequeue_task(rq, p, sleep);
+	p->sched_class->dequeue_task(rq, p, flags);
 	p->se.on_rq = 0;
 }
 
 /*
  * activate_task - move a task to the runqueue.
  */
-static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
+static void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 
-	enqueue_task(rq, p, wakeup, false);
+	enqueue_task(rq, p, flags);
 	inc_nr_running(rq);
 }
 
 /*
  * deactivate_task - remove a task from the runqueue.
  */
-static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
+static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible++;
 
-	dequeue_task(rq, p, sleep);
+	dequeue_task(rq, p, flags);
 	dec_nr_running(rq);
 }
 
@@ -2353,6 +2352,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 {
 	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
+	unsigned long en_flags = ENQUEUE_WAKEUP;
 	struct rq *rq;
 
 	this_cpu = get_cpu();
@@ -2386,8 +2386,10 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	}
 	p->state = TASK_WAKING;
 
-	if (p->sched_class->task_waking)
+	if (p->sched_class->task_waking) {
 		p->sched_class->task_waking(rq, p);
+		en_flags |= ENQUEUE_WAKING;
+	}
 
 	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
 	if (cpu != orig_cpu)
@@ -2432,7 +2434,7 @@ out_activate:
 		schedstat_inc(p, se.statistics.nr_wakeups_local);
 	else
 		schedstat_inc(p, se.statistics.nr_wakeups_remote);
-	activate_task(rq, p, 1);
+	activate_task(rq, p, en_flags);
 	success = 1;
 
 out_running:
@@ -3623,7 +3625,7 @@ need_resched_nonpreemptible:
 		if (unlikely(signal_pending_state(prev->state, prev)))
 			prev->state = TASK_RUNNING;
 		else
-			deactivate_task(rq, prev, 1);
+			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 		switch_count = &prev->nvcsw;
 	}
 
@@ -4193,7 +4195,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		enqueue_task(rq, p, 0, oldprio < prio);
+		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
@@ -4236,7 +4238,7 @@ void set_user_nice(struct task_struct *p, long nice)
 	delta = p->prio - old_prio;
 
 	if (on_rq) {
-		enqueue_task(rq, p, 0, false);
+		enqueue_task(rq, p, 0);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -8180,7 +8182,7 @@ void sched_move_task(struct task_struct *tsk)
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
 	if (on_rq)
-		enqueue_task(rq, tsk, 0, false);
+		enqueue_task(rq, tsk, 0);
 
 	task_rq_unlock(rq, &flags);
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8a5e763..88d3053 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -757,9 +757,6 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	se->vruntime = vruntime;
 }
 
-#define ENQUEUE_WAKEUP	1
-#define ENQUEUE_MIGRATE 2
-
 static void
 enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
@@ -767,7 +764,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update the normalized vruntime before updating min_vruntime
 	 * through callig update_curr().
 	 */
-	if (!(flags & ENQUEUE_WAKEUP) || (flags & ENQUEUE_MIGRATE))
+	if (!(flags & ENQUEUE_WAKEUP) || (flags & ENQUEUE_WAKING))
 		se->vruntime += cfs_rq->min_vruntime;
 
 	/*
@@ -803,7 +800,7 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 static void
-dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
+dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
 	/*
 	 * Update run-time statistics of the 'current'.
@@ -811,7 +808,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 	update_curr(cfs_rq);
 
 	update_stats_dequeue(cfs_rq, se);
-	if (sleep) {
+	if (flags & DEQUEUE_SLEEP) {
 #ifdef CONFIG_SCHEDSTATS
 		if (entity_is_task(se)) {
 			struct task_struct *tsk = task_of(se);
@@ -836,7 +833,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 	 * update can refer to the ->curr item and we need to reflect this
 	 * movement in our normalized position.
 	 */
-	if (!sleep)
+	if (!(flags & DEQUEUE_SLEEP))
 		se->vruntime -= cfs_rq->min_vruntime;
 }
 
@@ -1045,16 +1042,10 @@ static inline void hrtick_update(struct rq *rq)
  * then put the task into the rbtree:
  */
 static void
-enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup, bool head)
+enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
-	int flags = 0;
-
-	if (wakeup)
-		flags |= ENQUEUE_WAKEUP;
-	if (p->state == TASK_WAKING)
-		flags |= ENQUEUE_MIGRATE;
 
 	for_each_sched_entity(se) {
 		if (se->on_rq)
@@ -1072,18 +1063,18 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup, bool head)
  * decreased. We remove the task from the rbtree and
  * update the fair scheduling stats:
  */
-static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
+static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
-		dequeue_entity(cfs_rq, se, sleep);
+		dequeue_entity(cfs_rq, se, flags);
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight)
 			break;
-		sleep = 1;
+		flags |= DEQUEUE_SLEEP;
 	}
 
 	hrtick_update(rq);
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 5af709f..bea2b8f 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -33,7 +33,7 @@ static struct task_struct *pick_next_task_idle(struct rq *rq)
  * message if some code attempts to do it:
  */
 static void
-dequeue_task_idle(struct rq *rq, struct task_struct *p, int sleep)
+dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
 {
 	raw_spin_unlock_irq(&rq->lock);
 	printk(KERN_ERR "bad: scheduling from the idle thread!\n");
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index fde895f..8afb953 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -888,20 +888,20 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
  * Adding/removing a task to/from a priority array:
  */
 static void
-enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup, bool head)
+enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
 
-	if (wakeup)
+	if (flags & ENQUEUE_WAKEUP)
 		rt_se->timeout = 0;
 
-	enqueue_rt_entity(rt_se, head);
+	enqueue_rt_entity(rt_se, flags & ENQUEUE_HEAD);
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 }
 
-static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
+static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
 
