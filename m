Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1AZMO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:14:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:39992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab1AZMO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:14:56 -0500
Date: Wed, 26 Jan 2011 12:14:16 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, samu.p.onkalo@nokia.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, samu.p.onkalo@nokia.com,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix switch_from_fair()
Message-ID: <tip-da7a735e51f9622eb3e1672594d4a41da01d7e4f@git.kernel.org>
Git-Commit-ID: da7a735e51f9622eb3e1672594d4a41da01d7e4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:14:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da7a735e51f9622eb3e1672594d4a41da01d7e4f
Gitweb:     http://git.kernel.org/tip/da7a735e51f9622eb3e1672594d4a41da01d7e4f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 17 Jan 2011 17:03:27 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 12:33:22 +0100

sched: Fix switch_from_fair()

When a task is taken out of the fair class we must ensure the vruntime
is properly normalized because when we put it back in it will assume
to be normalized.

The case that goes wrong is when changing away from the fair class
while sleeping. Sleeping tasks have non-normalized vruntime in order
to make sleeper-fairness work. So treat the switch away from fair as a
wakeup and preserve the relative vruntime.

Also update sysrq-n to call the ->switch_{to,from} methods.

Reported-by: Onkalo Samu <samu.p.onkalo@nokia.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h   |    8 +++-----
 kernel/sched.c          |   25 ++++++++++++++-----------
 kernel/sched_fair.c     |   42 ++++++++++++++++++++++++++++++++++++------
 kernel/sched_idletask.c |    7 +++----
 kernel/sched_rt.c       |   19 ++++++++++---------
 kernel/sched_stoptask.c |    7 +++----
 6 files changed, 69 insertions(+), 39 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index af6e15f..0542774 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1084,12 +1084,10 @@ struct sched_class {
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_fork) (struct task_struct *p);
 
-	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
-			       int running);
-	void (*switched_to) (struct rq *this_rq, struct task_struct *task,
-			     int running);
+	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
+	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
-			     int oldprio, int running);
+			     int oldprio);
 
 	unsigned int (*get_rr_interval) (struct rq *rq,
 					 struct task_struct *task);
diff --git a/kernel/sched.c b/kernel/sched.c
index 8b718b5..78fa753 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2057,14 +2057,14 @@ inline int task_curr(const struct task_struct *p)
 
 static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 				       const struct sched_class *prev_class,
-				       int oldprio, int running)
+				       int oldprio)
 {
 	if (prev_class != p->sched_class) {
 		if (prev_class->switched_from)
-			prev_class->switched_from(rq, p, running);
-		p->sched_class->switched_to(rq, p, running);
-	} else
-		p->sched_class->prio_changed(rq, p, oldprio, running);
+			prev_class->switched_from(rq, p);
+		p->sched_class->switched_to(rq, p);
+	} else if (oldprio != p->prio)
+		p->sched_class->prio_changed(rq, p, oldprio);
 }
 
 static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
@@ -2598,6 +2598,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
+	p->se.vruntime			= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
@@ -4696,11 +4697,10 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq) {
+	if (on_rq)
 		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
 
-		check_class_changed(rq, p, prev_class, oldprio, running);
-	}
+	check_class_changed(rq, p, prev_class, oldprio);
 	task_rq_unlock(rq, &flags);
 }
 
@@ -5028,11 +5028,10 @@ recheck:
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq) {
+	if (on_rq)
 		activate_task(rq, p, 0);
 
-		check_class_changed(rq, p, prev_class, oldprio, running);
-	}
+	check_class_changed(rq, p, prev_class, oldprio);
 	__task_rq_unlock(rq);
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
@@ -8237,6 +8236,8 @@ EXPORT_SYMBOL(__might_sleep);
 #ifdef CONFIG_MAGIC_SYSRQ
 static void normalize_task(struct rq *rq, struct task_struct *p)
 {
+	const struct sched_class *prev_class = p->sched_class;
+	int old_prio = p->prio;
 	int on_rq;
 
 	on_rq = p->se.on_rq;
@@ -8247,6 +8248,8 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 		activate_task(rq, p, 0);
 		resched_task(rq->curr);
 	}
+
+	check_class_changed(rq, p, prev_class, old_prio);
 }
 
 void normalize_rt_tasks(void)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4cbc912..55040f3 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -4078,33 +4078,62 @@ static void task_fork_fair(struct task_struct *p)
  * Priority of the task has changed. Check to see if we preempt
  * the current task.
  */
-static void prio_changed_fair(struct rq *rq, struct task_struct *p,
-			      int oldprio, int running)
+static void
+prio_changed_fair(struct rq *rq, struct task_struct *p, int oldprio)
 {
+	if (!p->se.on_rq)
+		return;
+
 	/*
 	 * Reschedule if we are currently running on this runqueue and
 	 * our priority decreased, or if we are not currently running on
 	 * this runqueue and our priority is higher than the current's
 	 */
-	if (running) {
+	if (rq->curr == p) {
 		if (p->prio > oldprio)
 			resched_task(rq->curr);
 	} else
 		check_preempt_curr(rq, p, 0);
 }
 
+static void switched_from_fair(struct rq *rq, struct task_struct *p)
+{
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	/*
+	 * Ensure the task's vruntime is normalized, so that when its
+	 * switched back to the fair class the enqueue_entity(.flags=0) will
+	 * do the right thing.
+	 *
+	 * If it was on_rq, then the dequeue_entity(.flags=0) will already
+	 * have normalized the vruntime, if it was !on_rq, then only when
+	 * the task is sleeping will it still have non-normalized vruntime.
+	 */
+	if (!se->on_rq && p->state != TASK_RUNNING) {
+		/*
+		 * Fix up our vruntime so that the current sleep doesn't
+		 * cause 'unlimited' sleep bonus.
+		 */
+		place_entity(cfs_rq, se, 0);
+		se->vruntime -= cfs_rq->min_vruntime;
+	}
+}
+
 /*
  * We switched to the sched_fair class.
  */
-static void switched_to_fair(struct rq *rq, struct task_struct *p,
-			     int running)
+static void switched_to_fair(struct rq *rq, struct task_struct *p)
 {
+	if (!p->se.on_rq)
+		return;
+
 	/*
 	 * We were most likely switched from sched_rt, so
 	 * kick off the schedule if running, otherwise just see
 	 * if we can still preempt the current task.
 	 */
-	if (running)
+	if (rq->curr == p)
 		resched_task(rq->curr);
 	else
 		check_preempt_curr(rq, p, 0);
@@ -4190,6 +4219,7 @@ static const struct sched_class fair_sched_class = {
 	.task_fork		= task_fork_fair,
 
 	.prio_changed		= prio_changed_fair,
+	.switched_from		= switched_from_fair,
 	.switched_to		= switched_to_fair,
 
 	.get_rr_interval	= get_rr_interval_fair,
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 41eb62a..c82f26c 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -52,14 +52,13 @@ static void set_curr_task_idle(struct rq *rq)
 {
 }
 
-static void
-switched_to_idle(struct rq *rq, struct task_struct *p, int running)
+static void switched_to_idle(struct rq *rq, struct task_struct *p)
 {
 	BUG();
 }
 
-static void prio_changed_idle(struct rq *rq, struct task_struct *p,
-			      int oldprio, int running)
+static void
+prio_changed_idle(struct rq *rq, struct task_struct *p, int oldprio)
 {
 	BUG();
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index c914ec7..c381fdc 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1595,8 +1595,7 @@ static void rq_offline_rt(struct rq *rq)
  * When switch from the rt queue, we bring ourselves to a position
  * that we might want to pull RT tasks from other runqueues.
  */
-static void switched_from_rt(struct rq *rq, struct task_struct *p,
-			   int running)
+static void switched_from_rt(struct rq *rq, struct task_struct *p)
 {
 	/*
 	 * If there are other RT tasks then we will reschedule
@@ -1605,7 +1604,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p,
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (!rq->rt.rt_nr_running)
+	if (p->se.on_rq && !rq->rt.rt_nr_running)
 		pull_rt_task(rq);
 }
 
@@ -1624,8 +1623,7 @@ static inline void init_sched_rt_class(void)
  * with RT tasks. In this case we try to push them off to
  * other runqueues.
  */
-static void switched_to_rt(struct rq *rq, struct task_struct *p,
-			   int running)
+static void switched_to_rt(struct rq *rq, struct task_struct *p)
 {
 	int check_resched = 1;
 
@@ -1636,7 +1634,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p,
 	 * If that current running task is also an RT task
 	 * then see if we can move to another run queue.
 	 */
-	if (!running) {
+	if (p->se.on_rq && rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (rq->rt.overloaded && push_rt_task(rq) &&
 		    /* Don't resched if we changed runqueues */
@@ -1652,10 +1650,13 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p,
  * Priority of the task has changed. This may cause
  * us to initiate a push or pull.
  */
-static void prio_changed_rt(struct rq *rq, struct task_struct *p,
-			    int oldprio, int running)
+static void
+prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio)
 {
-	if (running) {
+	if (!p->se.on_rq)
+		return;
+
+	if (rq->curr == p) {
 #ifdef CONFIG_SMP
 		/*
 		 * If our priority decreases while running, we
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 2bf6b47..84ec9bc 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -59,14 +59,13 @@ static void set_curr_task_stop(struct rq *rq)
 {
 }
 
-static void switched_to_stop(struct rq *rq, struct task_struct *p,
-			     int running)
+static void switched_to_stop(struct rq *rq, struct task_struct *p)
 {
 	BUG(); /* its impossible to change to this class */
 }
 
-static void prio_changed_stop(struct rq *rq, struct task_struct *p,
-			      int oldprio, int running)
+static void
+prio_changed_stop(struct rq *rq, struct task_struct *p, int oldprio)
 {
 	BUG(); /* how!?, what priority? */
 }
