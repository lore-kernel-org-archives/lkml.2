Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab0EMKtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:49:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:60623 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758640Ab0EMKtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:49:20 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH 2/4] sched: implement __set_cpus_allowed()
Date: Thu, 13 May 2010 12:48:23 +0200
Message-Id: <1273747705-7829-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273747705-7829-1-git-send-email-tj@kernel.org>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 10:48:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Concurrency managed workqueue needs to be able to migrate tasks to a
cpu which is online but !active for the following two purposes.

p1. To guarantee forward progress during cpu down sequence.  Each
    workqueue which could be depended upon during memory allocation
    has an emergency worker task which is summoned when a pending work
    on such workqueue can't be serviced immediately.  cpu hotplug
    callbacks expect workqueues to work during cpu down sequence
    (usually so that they can flush them), so, to guarantee forward
    progress, it should be possible to summon emergency workers to
    !active but online cpus.

p2. To migrate back unbound workers when a cpu comes back online.
    When a cpu goes down, existing workers are unbound from the cpu
    and allowed to run on other cpus if there still are pending or
    running works.  If the cpu comes back online while those workers
    are still around, those workers are migrated back and re-bound to
    the cpu.  This isn't strictly required for correctness as long as
    those unbound workers don't execute works which are newly
    scheduled after the cpu comes back online; however, migrating back
    the workers has the advantage of making the behavior more
    consistent thus avoiding surprises which are difficult to expect
    and reproduce, and being actually cleaner and easier to implement.

To implement this, __set_cpus_allowed() is factored out from
set_cpus_allowed_ptr() and @force parameter is added to it.  The
latter is now a wrapper around the former with @force set to %false.
When @force is %false, the following original behaviors are
maintained.

c1. Check whether PF_THREAD_BOUND is set.  This is set for bound
    kthreads so that they can't be moved around.

c2. Check whether the target cpu is still marked active -
    cpu_active().  Active state is cleared early while downing a cpu.

When @force parameter is %true, __set_cpus_allowed() ignores c1 and
uses cpu online state instead of active state for c2.

Due to the way migration is implemented, the @force parameter needs to
be passed over to the migration cpu_stop callback.  @force parameter
is added to struct migration_req and passed to __migrate_task().

Please note the naming discrepancy between set_cpus_allowed_ptr() and
the new functions.  The _ptr suffix is from the days when cpumask API
wasn't mature and future changes should drop it from
set_cpus_allowed_ptr() too.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   14 +++++++++---
 kernel/sched.c        |   51 +++++++++++++++++++++++++++++++-----------------
 2 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index dfea405..ef6067c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1776,11 +1776,11 @@ static inline void rcu_copy_process(struct task_struct *p)
 #endif
 
 #ifdef CONFIG_SMP
-extern int set_cpus_allowed_ptr(struct task_struct *p,
-				const struct cpumask *new_mask);
+extern int __set_cpus_allowed(struct task_struct *p,
+			      const struct cpumask *new_mask, bool force);
 #else
-static inline int set_cpus_allowed_ptr(struct task_struct *p,
-				       const struct cpumask *new_mask)
+static inline int __set_cpus_allowed(struct task_struct *p,
+				     const struct cpumask *new_mask, bool force)
 {
 	if (!cpumask_test_cpu(0, new_mask))
 		return -EINVAL;
@@ -1788,6 +1788,12 @@ static inline int set_cpus_allowed_ptr(struct task_struct *p,
 }
 #endif
 
+static inline int set_cpus_allowed_ptr(struct task_struct *p,
+				       const struct cpumask *new_mask)
+{
+	return __set_cpus_allowed(p, new_mask, false);
+}
+
 #ifndef CONFIG_CPUMASK_OFFSTACK
 static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 {
diff --git a/kernel/sched.c b/kernel/sched.c
index aca4a20..ecf024d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2038,6 +2038,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 struct migration_arg {
 	struct task_struct *task;
 	int dest_cpu;
+	bool force;
 };
 
 static int migration_cpu_stop(void *data);
@@ -3111,7 +3112,7 @@ void sched_exec(void)
 	 */
 	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
 	    likely(cpu_active(dest_cpu)) && migrate_task(p, dest_cpu)) {
-		struct migration_arg arg = { p, dest_cpu };
+		struct migration_arg arg = { p, dest_cpu, false };
 
 		task_rq_unlock(rq, &flags);
 		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
@@ -5280,17 +5281,27 @@ static inline void sched_init_granularity(void)
  *    is done.
  */
 
-/*
- * Change a given task's CPU affinity. Migrate the thread to a
- * proper CPU and schedule it away if the CPU it's executing on
- * is removed from the allowed bitmask.
+/**
+ * __set_cpus_allowed - change a task's CPU affinity
+ * @p: task to change CPU affinity for
+ * @new_mask: new CPU affinity
+ * @force: override CPU active status and PF_THREAD_BOUND check
+ *
+ * Migrate the thread to a proper CPU and schedule it away if the CPU
+ * it's executing on is removed from the allowed bitmask.
+ *
+ * The caller must have a valid reference to the task, the task must
+ * not exit() & deallocate itself prematurely. The call is not atomic;
+ * no spinlocks may be held.
  *
- * NOTE: the caller must have a valid reference to the task, the
- * task must not exit() & deallocate itself prematurely. The
- * call is not atomic; no spinlocks may be held.
+ * If @force is %true, PF_THREAD_BOUND test is bypassed and CPU active
+ * state is ignored as long as the CPU is online.
  */
-int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
+int __set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask,
+		       bool force)
 {
+	const struct cpumask *cpu_cand_mask =
+		force ? cpu_online_mask : cpu_active_mask;
 	unsigned long flags;
 	struct rq *rq;
 	unsigned int dest_cpu;
@@ -5309,12 +5320,12 @@ again:
 		goto again;
 	}
 
-	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
+	if (!cpumask_intersects(new_mask, cpu_cand_mask)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
+	if (unlikely((p->flags & PF_THREAD_BOUND) && !force && p != current &&
 		     !cpumask_equal(&p->cpus_allowed, new_mask))) {
 		ret = -EINVAL;
 		goto out;
@@ -5331,9 +5342,9 @@ again:
 	if (cpumask_test_cpu(task_cpu(p), new_mask))
 		goto out;
 
-	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
+	dest_cpu = cpumask_any_and(cpu_cand_mask, new_mask);
 	if (migrate_task(p, dest_cpu)) {
-		struct migration_arg arg = { p, dest_cpu };
+		struct migration_arg arg = { p, dest_cpu, force };
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, &flags);
 		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
@@ -5345,7 +5356,7 @@ out:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
+EXPORT_SYMBOL_GPL(__set_cpus_allowed);
 
 /*
  * Move (not current) task off this cpu, onto dest cpu. We're doing
@@ -5358,12 +5369,15 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
  *
  * Returns non-zero if task was successfully migrated.
  */
-static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
+static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu,
+			  bool force)
 {
+	const struct cpumask *cpu_cand_mask =
+		force ? cpu_online_mask : cpu_active_mask;
 	struct rq *rq_dest, *rq_src;
 	int ret = 0;
 
-	if (unlikely(!cpu_active(dest_cpu)))
+	if (unlikely(!cpumask_test_cpu(dest_cpu, cpu_cand_mask)))
 		return ret;
 
 	rq_src = cpu_rq(src_cpu);
@@ -5408,7 +5422,8 @@ static int migration_cpu_stop(void *data)
 	 * be on another cpu but it doesn't matter.
 	 */
 	local_irq_disable();
-	__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu);
+	__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu,
+		       arg->force);
 	local_irq_enable();
 	return 0;
 }
@@ -5435,7 +5450,7 @@ void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 	 * in the racer should migrate the task anyway.
 	 */
 	if (needs_cpu)
-		__migrate_task(p, dead_cpu, dest_cpu);
+		__migrate_task(p, dead_cpu, dest_cpu, false);
 	local_irq_restore(flags);
 }
 
-- 
1.6.4.2

