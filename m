Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab2L0P7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 10:59:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18861 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2L0P7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 10:59:30 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=FeVwYDZYfeFsj4wyoFoA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356623968.10284.1.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.2.35-rt53
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 27 Dec 2012 10:59:28 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.35-rt53 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: a0023b3571d382691eaa75863a33dea512eac135


Or to build 3.2.35-rt53 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.35.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.35-rt53.patch.xz


You can also build from 3.2.35-rt52 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.35-rt52-rt53.patch.xz



Enjoy,

-- Steve


Changes from 3.2.35-rt52:

---

Steven Rostedt (1):
      Linux 3.2.35-rt53

Thomas Gleixner (3):
      sched: Adjust sched_reset_on_fork when nothing else changes
      sched: Queue RT tasks to head when prio drops
      sched: Consider pi boosting in setscheduler

----
 include/linux/sched.h |    5 +++++
 kernel/rtmutex.c      |   12 +++++++++++
 kernel/sched.c        |   54 ++++++++++++++++++++++++++++++++++++++-----------
 localversion-rt       |    2 +-
 4 files changed, 60 insertions(+), 13 deletions(-)
---------------------------
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 12317b6..e2f9e3b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2127,6 +2127,7 @@ extern unsigned int sysctl_sched_cfs_bandwidth_slice;
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
+extern int rt_mutex_check_prio(struct task_struct *task, int newprio);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
 {
@@ -2137,6 +2138,10 @@ static inline int rt_mutex_getprio(struct task_struct *p)
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
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 9c4f6e5..6075f17 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -124,6 +124,18 @@ int rt_mutex_getprio(struct task_struct *task)
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
diff --git a/kernel/sched.c b/kernel/sched.c
index cdf9484..b318b4a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5363,7 +5363,8 @@ EXPORT_SYMBOL(sleep_on_timeout);
  * This function changes the 'effective' priority of a task. It does
  * not touch ->normal_prio like __setscheduler().
  *
- * Used by the rt_mutex code to implement priority inheritance logic.
+ * Used by the rt_mutex code to implement priority inheritance
+ * logic. Call site only calls if the priority of the task changed.
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
@@ -5586,20 +5587,25 @@ static struct task_struct *find_process_by_pid(pid_t pid)
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
@@ -5624,6 +5630,7 @@ static bool check_same_owner(struct task_struct *p)
 static int __sched_setscheduler(struct task_struct *p, int policy,
 				const struct sched_param *param, bool user)
 {
+	int newprio = MAX_RT_PRIO - 1 - param->sched_priority;
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	unsigned long flags;
 	const struct sched_class *prev_class;
@@ -5719,11 +5726,13 @@ recheck:
 	}
 
 	/*
-	 * If not changing anything there's no need to proceed further:
+	 * If not changing anything there's no need to proceed
+	 * further, but store a possible modification of
+	 * reset_on_fork.
 	 */
 	if (unlikely(policy == p->policy && (!rt_policy(policy) ||
 			param->sched_priority == p->rt_priority))) {
-
+		p->sched_reset_on_fork = reset_on_fork;
 		__task_rq_unlock(rq);
 		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		return 0;
@@ -5750,6 +5759,25 @@ recheck:
 		task_rq_unlock(rq, p, &flags);
 		goto recheck;
 	}
+
+	p->sched_reset_on_fork = reset_on_fork;
+	oldprio = p->prio;
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
+
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
@@ -5757,16 +5785,18 @@ recheck:
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	p->sched_reset_on_fork = reset_on_fork;
-
-	oldprio = p->prio;
 	prev_class = p->sched_class;
 	__setscheduler(rq, p, policy, param->sched_priority);
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq)
-		activate_task(rq, p, 0);
+	if (on_rq) {
+		/*
+		 * We enqueue to tail when the priority of a task is
+		 * increased (user space view).
+		 */
+		activate_task(rq, p, oldprio <= p->prio ? ENQUEUE_HEAD : 0);
+	}
 
 	check_class_changed(rq, p, prev_class, oldprio);
 	task_rq_unlock(rq, p, &flags);
diff --git a/localversion-rt b/localversion-rt
index 66a5ed8..e6c0dc6 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt52
+-rt53


