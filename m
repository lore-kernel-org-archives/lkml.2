Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab2LVE0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 23:26:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33192 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab2LVEZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 23:25:55 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=elHMl7bu-2cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=indFvSXu9MUA:10 a=VwQbUJbxAAAA:8 a=83LvUfSxHAvV0hNkIzwA:9 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121222042554.001351234@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 21 Dec 2012 23:25:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, <stable@vger.kernel.org>,
        <stable-rt@vger.kernel.org>
Subject: [PATCH RT 3/5] sched: Consider pi boosting in setscheduler
References: <20121222042515.867823077@goodmis.org>
Content-Disposition: inline; filename=0003-sched-Consider-pi-boosting-in-setscheduler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

If a PI boosted task policy/priority is modified by a setscheduler()
call we unconditionally dequeue and requeue the task if it is on the
runqueue even if the new priority is lower than the current effective
boosted priority. This can result in undesired reordering of the
priority bucket list.

If the new priority is less or equal than the current effective we
just store the new parameters in the task struct and leave the
scheduler class and the runqueue untouched. This is handled when the
task deboosts itself. Only if the new priority is higher than the
effective boosted priority we apply the change immediately.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Cc: stable-rt@vger.kernel.org
---
 include/linux/sched.h |    5 +++++
 kernel/rtmutex.c      |   12 ++++++++++++
 kernel/sched/core.c   |   40 +++++++++++++++++++++++++++++++---------
 3 files changed, 48 insertions(+), 9 deletions(-)

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
index b02f995..7b501a3 100644
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
@@ -4474,6 +4481,25 @@ recheck:
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
@@ -4481,9 +4507,6 @@ recheck:
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	p->sched_reset_on_fork = reset_on_fork;
-
-	oldprio = p->prio;
 	prev_class = p->sched_class;
 	__setscheduler(rq, p, policy, param->sched_priority);
 
@@ -4496,7 +4519,6 @@ recheck:
 		 */
 		enqueue_task(rq, p, oldprio <= p->prio ? ENQUEUE_HEAD : 0);
 	}
-
 	check_class_changed(rq, p, prev_class, oldprio);
 	task_rq_unlock(rq, p, &flags);
 
-- 
1.7.10.4


