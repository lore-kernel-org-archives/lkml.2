Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab2L0PsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 10:48:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab2L0PsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 10:48:12 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=bntQ99_Hy_jGvhwCyeIA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356623289.10284.0.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.4.24-rt36
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 27 Dec 2012 10:48:09 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.4.24-rt36 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: c094034cc852ce529317bddff5bda479aed11385


Or to build 3.4.24-rt36 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.24.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.24-rt36.patch.xz


You can also build from 3.4.24-rt35 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4.24-rt35-rt36.patch.xz



Enjoy,

-- Steve


Changes from 3.4.24-rt35:

---

Steven Rostedt (1):
      Linux 3.4.24-rt36

Thomas Gleixner (4):
      sched: Adjust sched_reset_on_fork when nothing else changes
      sched: Queue RT tasks to head when prio drops
      sched: Consider pi boosting in setscheduler
      block: Use cpu_chill() for retry loops

----
 block/blk-ioc.c       |    5 +++--
 include/linux/sched.h |    5 +++++
 kernel/rtmutex.c      |   12 +++++++++++
 kernel/sched/core.c   |   55 +++++++++++++++++++++++++++++++++++++------------
 localversion-rt       |    2 +-
 5 files changed, 63 insertions(+), 16 deletions(-)
---------------------------
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index fb95dd2..6b54201 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -8,6 +8,7 @@
 #include <linux/blkdev.h>
 #include <linux/bootmem.h>	/* for max_pfn/max_low_pfn */
 #include <linux/slab.h>
+#include <linux/delay.h>
 
 #include "blk.h"
 
@@ -110,7 +111,7 @@ static void ioc_release_fn(struct work_struct *work)
 			spin_unlock(q->queue_lock);
 		} else {
 			spin_unlock_irqrestore(&ioc->lock, flags);
-			cpu_relax();
+			cpu_chill();
 			spin_lock_irqsave_nested(&ioc->lock, flags, 1);
 		}
 	}
@@ -188,7 +189,7 @@ retry:
 			spin_unlock(icq->q->queue_lock);
 		} else {
 			spin_unlock_irqrestore(&ioc->lock, flags);
-			cpu_relax();
+			cpu_chill();
 			goto retry;
 		}
 	}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f291347..b0448fa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2166,6 +2166,7 @@ extern unsigned int sysctl_sched_cfs_bandwidth_slice;
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
+extern int rt_mutex_check_prio(struct task_struct *task, int newprio);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
 {
@@ -2176,6 +2177,10 @@ static inline int rt_mutex_getprio(struct task_struct *p)
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
index 3bff726..20742e7 100644
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
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1f9d6f5..7b501a3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4085,7 +4085,8 @@ EXPORT_SYMBOL(sleep_on_timeout);
  * This function changes the 'effective' priority of a task. It does
  * not touch ->normal_prio like __setscheduler().
  *
- * Used by the rt_mutex code to implement priority inheritance logic.
+ * Used by the rt_mutex code to implement priority inheritance
+ * logic. Call site only calls if the priority of the task changed.
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
@@ -4308,20 +4309,25 @@ static struct task_struct *find_process_by_pid(pid_t pid)
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
@@ -4346,6 +4352,7 @@ static bool check_same_owner(struct task_struct *p)
 static int __sched_setscheduler(struct task_struct *p, int policy,
 				const struct sched_param *param, bool user)
 {
+	int newprio = MAX_RT_PRIO - 1 - param->sched_priority;
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	unsigned long flags;
 	const struct sched_class *prev_class;
@@ -4441,11 +4448,13 @@ recheck:
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
@@ -4472,6 +4481,25 @@ recheck:
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
@@ -4479,17 +4507,18 @@ recheck:
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
-		enqueue_task(rq, p, 0);
-
+	if (on_rq) {
+		/*
+		 * We enqueue to tail when the priority of a task is
+		 * increased (user space view).
+		 */
+		enqueue_task(rq, p, oldprio <= p->prio ? ENQUEUE_HEAD : 0);
+	}
 	check_class_changed(rq, p, prev_class, oldprio);
 	task_rq_unlock(rq, p, &flags);
 
diff --git a/localversion-rt b/localversion-rt
index 366440d..2294034 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt35
+-rt36


