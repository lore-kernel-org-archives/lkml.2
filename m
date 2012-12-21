Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2LUNur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:50:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:52651 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2LUNuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:50:40 -0500
Date: Fri, 21 Dec 2012 14:50:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.6.11-rt24 (apocalypse release)c
Message-ID: <alpine.LFD.2.02.1212211413200.3148@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.6.11-rt24 release. 3.6.9-rt21, 3.6.10-rt22
and 3.6.11-rt23 are not announced updates to the respective 3.6.y
stable releases without any RT changes

Changes since 3.6.11-rt23:

   * Fix the scheduler bug really. Thanks to Mike for noticing the
     issue. It turned out that there are a few more corner cases
     hidden in that code. See the 3 separate patches in the quilt
     queue for details.

   * Fix a livelock issue in the block layer. Thanks to Steve for
     debugging it.

Known issues:

   * There is still a possibility to get false positives from the NOHZ
     idle softirq pending detector. It's rather complex to fix and I
     have postponed it for a separate release. The warnings are
     harmless and can be ignored for now.

For those who are going to vanish today due to their firm believe in
the Mayan Apocalypse it's the last release ever and I can assure you
it's the best one as well. You just won't have enough time to verify
that.

For all others this is just the last release of 2012.


The delta patch against 3.6.11-rt23 is appended below and can be found
here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.11-rt23-rt24.patch.xz

The RT patch against 3.6.11 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.11-rt24.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.11-rt24.tar.xz


Thanks to all of you who have contributed with patches, bugreports,
testing ...! Special thanks to Steven for running the stable series!

I wish you all a Merry Christmas and a Happy New Year!

       Thomas

------------->
Index: linux-stable/include/linux/sched.h
===================================================================
--- linux-stable.orig/include/linux/sched.h
+++ linux-stable/include/linux/sched.h
@@ -2144,6 +2144,7 @@ extern unsigned int sysctl_sched_cfs_ban
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
+extern int rt_mutex_check_prio(struct task_struct *task, int newprio);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
 {
@@ -2154,6 +2155,10 @@ static inline int rt_mutex_getprio(struc
 {
 	return p->normal_prio;
 }
+static inline int rt_mutex_check_prio(struct task_struct *task, int newprio)
+{
+	return 0;
+}
 # define rt_mutex_adjust_pi(p)		do { } while (0)
 static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
 {
Index: linux-stable/kernel/rtmutex.c
===================================================================
--- linux-stable.orig/kernel/rtmutex.c
+++ linux-stable/kernel/rtmutex.c
@@ -124,6 +124,18 @@ int rt_mutex_getprio(struct task_struct 
 }
 
 /*
+ * Called by sched_setscheduler() to check whether the priority change
+ * is overruled by a possible priority boosting.
+ */
+int rt_mutex_check_prio(struct task_struct *task, int newprio)
+{
+	if (!task_has_pi_waiters(task))
+		return 0;
+
+	return task_top_pi_waiter(task)->pi_list_entry.prio <= newprio;
+}
+
+/*
  * Adjust the priority of a task, after its pi_waiters got modified.
  *
  * This can be both boosting and unboosting. task->pi_lock must be held.
Index: linux-stable/kernel/sched/core.c
===================================================================
--- linux-stable.orig/kernel/sched/core.c
+++ linux-stable/kernel/sched/core.c
@@ -4236,7 +4236,8 @@ EXPORT_SYMBOL(sleep_on_timeout);
  * This function changes the 'effective' priority of a task. It does
  * not touch ->normal_prio like __setscheduler().
  *
- * Used by the rt_mutex code to implement priority inheritance logic.
+ * Used by the rt_mutex code to implement priority inheritance
+ * logic. Call site only calls if the priority of the task changed.
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
@@ -4268,8 +4269,6 @@ void rt_mutex_setprio(struct task_struct
 
 	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
-	if (oldprio == prio)
-		goto out_unlock;
 	prev_class = p->sched_class;
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
@@ -4461,20 +4460,25 @@ static struct task_struct *find_process_
 	return pid ? find_task_by_vpid(pid) : current;
 }
 
-/* Actually do priority change: must hold rq lock. */
-static void
-__setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
+static void __setscheduler_params(struct task_struct *p, int policy, int prio)
 {
 	p->policy = policy;
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
+	set_load_weight(p);
+}
+
+/* Actually do priority change: must hold rq lock. */
+static void
+__setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
+{
+	__setscheduler_params(p, policy, prio);
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
 	if (rt_prio(p->prio))
 		p->sched_class = &rt_sched_class;
 	else
 		p->sched_class = &fair_sched_class;
-	set_load_weight(p);
 }
 
 /*
@@ -4496,6 +4500,7 @@ static bool check_same_owner(struct task
 static int __sched_setscheduler(struct task_struct *p, int policy,
 				const struct sched_param *param, bool user)
 {
+	int newprio = MAX_RT_PRIO - 1 - param->sched_priority;
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	unsigned long flags;
 	const struct sched_class *prev_class;
@@ -4591,10 +4596,13 @@ recheck:
 	}
 
 	/*
-	 * If not changing anything there's no need to proceed further:
+	 * If not changing anything there's no need to proceed
+	 * further, but store a possible modification of
+	 * reset_on_fork.
 	 */
 	if (unlikely(policy == p->policy && (!rt_policy(policy) ||
 			param->sched_priority == p->rt_priority))) {
+		p->sched_reset_on_fork = reset_on_fork;
 		task_rq_unlock(rq, p, &flags);
 		return 0;
 	}
@@ -4622,10 +4630,22 @@ recheck:
 	}
 
 	p->sched_reset_on_fork = reset_on_fork;
-
 	oldprio = p->prio;
-	if (oldprio == param->sched_priority)
-		goto out;
+
+	/*
+	 * Special case for priority boosted tasks.
+	 *
+	 * If the new priority is lower or equal (user space view)
+	 * than the current (boosted) priority, we just store the new
+	 * normal parameters and do not touch the scheduler class and
+	 * the runqueue. This will be done when the task deboost
+	 * itself.
+	 */
+	if (rt_mutex_check_prio(p, newprio)) {
+		__setscheduler_params(p, policy, param->sched_priority);
+		task_rq_unlock(rq, p, &flags);
+		return 0;
+	}
 
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
@@ -4639,12 +4659,14 @@ recheck:
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq)
-		enqueue_task(rq, p, oldprio < param->sched_priority ?
-			     ENQUEUE_HEAD : 0);
-
+	if (on_rq) {
+		/*
+		 * We enqueue to tail when the priority of a task is
+		 * increased (user space view).
+		 */
+		enqueue_task(rq, p, oldprio <= p->prio ? ENQUEUE_HEAD : 0);
+	}
 	check_class_changed(rq, p, prev_class, oldprio);
-out:
 	task_rq_unlock(rq, p, &flags);
 
 	rt_mutex_adjust_pi(p);
Index: linux-stable/localversion-rt
===================================================================
--- linux-stable.orig/localversion-rt
+++ linux-stable/localversion-rt
@@ -1 +1 @@
--rt23
+-rt24
Index: linux-stable/block/blk-ioc.c
===================================================================
--- linux-stable.orig/block/blk-ioc.c
+++ linux-stable/block/blk-ioc.c
@@ -110,7 +110,7 @@ static void ioc_release_fn(struct work_s
 			spin_unlock(q->queue_lock);
 		} else {
 			spin_unlock_irqrestore(&ioc->lock, flags);
-			cpu_relax();
+			cpu_chill();
 			spin_lock_irqsave_nested(&ioc->lock, flags, 1);
 		}
 	}
@@ -188,7 +188,7 @@ retry:
 			spin_unlock(icq->q->queue_lock);
 		} else {
 			spin_unlock_irqrestore(&ioc->lock, flags);
-			cpu_relax();
+			cpu_chill();
 			goto retry;
 		}
 	}
