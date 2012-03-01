Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826Ab2CATEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:04:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab2CATDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:03:49 -0500
X-Authority-Analysis: v=2.0 cv=Z7xu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=ybd6yNBq5OsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1wyGHPGnlIp9iMfNahYA:9 a=yeXsRqvEFQ5LLe58C-wA:7 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120301190346.172835662@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 01 Mar 2012 13:55:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Subject: [PATCH RT 7/9][RFC] [PATCH 7/9] cpu/rt: Rework cpu down for PREEMPT_RT
References: <20120301185527.064629423@goodmis.org>
Content-Disposition: inline; filename=0007-cpu-rt-Rework-cpu-down-for-PREEMPT_RT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bringing a CPU down is a pain with the PREEMPT_RT kernel because
tasks can be preempted in many more places than in non-RT. In
order to handle per_cpu variables, tasks may be pinned to a CPU
for a while, and even sleep. But these tasks need to be off the CPU
if that CPU is going down.

Several synchronization methods have been tried, but when stressed
they failed. This is a new approach.

A sync_tsk thread is still created and tasks may still block on a
lock when the CPU is going down, but how that works is a bit different.
When cpu_down() starts, it will create the sync_tsk and wait on it
to inform that current tasks that are pinned on the CPU are no longer
pinned. But new tasks that are about to be pinned will still be allowed
to do so at this time.

Then the notifiers are called. Several notifiers will bring down tasks
that will enter these locations. Some of these tasks will take locks
of other tasks that are on the CPU. If we don't let those other tasks
continue, but make them block until CPU down is done, the tasks that
the notifiers are waiting on will never complete as they are waiting
for the locks held by the tasks that are blocked.

Thus we still let the task pin the CPU until the notifiers are done.
After the notifiers run, we then make new tasks entering the pinned
CPU sections grab a mutex and wait. This mutex is now a per CPU mutex
in the hotplug_pcp descriptor.

To help things along, a new function in the scheduler code is created
called migrate_me(). This function will try to migrate the current task
off the CPU this is going down if possible. When the sync_tsk is created,
all tasks will then try to migrate off the CPU going down. There are
several cases that this wont work, but it helps in most cases.

After the notifiers are called and if a task can't migrate off but enters
the pin CPU sections, it will be forced to wait on the hotplug_pcp mutex
until the CPU down is complete. Then the scheduler will force the migration
anyway.

Also, I found that THREAD_BOUND need to also be accounted for in the
pinned CPU, and the migrate_disable no longer treats them special.
This helps fix issues with ksoftirqd and workqueue that unbind on CPU down.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/sched.h |    7 ++
 kernel/cpu.c          |  193 ++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sched.c        |   82 ++++++++++++++++++++-
 3 files changed, 262 insertions(+), 20 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1f6b11a..3453856 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1933,6 +1933,10 @@ extern void do_set_cpus_allowed(struct task_struct *p,
 
 extern int set_cpus_allowed_ptr(struct task_struct *p,
 				const struct cpumask *new_mask);
+int migrate_me(void);
+void tell_sched_cpu_down_begin(int cpu);
+void tell_sched_cpu_down_done(int cpu);
+
 #else
 static inline void do_set_cpus_allowed(struct task_struct *p,
 				      const struct cpumask *new_mask)
@@ -1945,6 +1949,9 @@ static inline int set_cpus_allowed_ptr(struct task_struct *p,
 		return -EINVAL;
 	return 0;
 }
+static inline int migrate_me(void) { return 0; }
+static inline void tell_sched_cpu_down_begin(int cpu) { }
+static inline void tell_sched_cpu_down_done(int cpu) { }
 #endif
 
 #ifndef CONFIG_CPUMASK_OFFSTACK
diff --git a/kernel/cpu.c b/kernel/cpu.c
index fa40834..1a74ef5 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -58,10 +58,28 @@ static struct {
 	.refcount = 0,
 };
 
+/**
+ * hotplug_pcp - per cpu hotplug descriptor
+ * @unplug:	set when pin_current_cpu() needs to sync tasks
+ * @sync_tsk:	the task that waits for tasks to finish pinned sections
+ * @refcount:	counter of tasks in pinned sections
+ * @grab_lock:	set when the tasks entering pinned sections should wait
+ * @synced:	notifier for @sync_tsk to tell cpu_down it's finished
+ * @mutex:	the mutex to make tasks wait (used when @grab_lock is true)
+ * @mutex_init:	zero if the mutex hasn't been initialized yet.
+ *
+ * Although @unplug and @sync_tsk may point to the same task, the @unplug
+ * is used as a flag and still exists after @sync_tsk has exited and
+ * @sync_tsk set to NULL.
+ */
 struct hotplug_pcp {
 	struct task_struct *unplug;
+	struct task_struct *sync_tsk;
 	int refcount;
+	int grab_lock;
 	struct completion synced;
+	struct mutex mutex;
+	int mutex_init;
 };
 
 static DEFINE_PER_CPU(struct hotplug_pcp, hotplug_pcp);
@@ -77,18 +95,40 @@ static DEFINE_PER_CPU(struct hotplug_pcp, hotplug_pcp);
 void pin_current_cpu(void)
 {
 	struct hotplug_pcp *hp;
+	int force = 0;
 
 retry:
 	hp = &__get_cpu_var(hotplug_pcp);
 
-	if (!hp->unplug || hp->refcount || preempt_count() > 1 ||
+	if (!hp->unplug || hp->refcount || force || preempt_count() > 1 ||
 	    hp->unplug == current || (current->flags & PF_STOMPER)) {
 		hp->refcount++;
 		return;
 	}
-	preempt_enable();
-	mutex_lock(&cpu_hotplug.lock);
-	mutex_unlock(&cpu_hotplug.lock);
+
+	if (hp->grab_lock) {
+		preempt_enable();
+		mutex_lock_savestate(&hp->mutex);
+		mutex_unlock(&hp->mutex);
+	} else {
+		preempt_enable();
+		/*
+		 * Try to push this task off of this CPU.
+		 */
+		if (!migrate_me()) {
+			preempt_disable();
+			hp = &__get_cpu_var(hotplug_pcp);
+			if (!hp->grab_lock) {
+				/*
+				 * Just let it continue it's already pinned
+				 * or about to sleep.
+				 */
+				force = 1;
+				goto retry;
+			}
+			preempt_enable();
+		}
+	}
 	preempt_disable();
 	goto retry;
 }
@@ -110,26 +150,84 @@ void unpin_current_cpu(void)
 		wake_up_process(hp->unplug);
 }
 
-/*
- * FIXME: Is this really correct under all circumstances ?
- */
+static void wait_for_pinned_cpus(struct hotplug_pcp *hp)
+{
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	while (hp->refcount) {
+		schedule_preempt_disabled();
+		set_current_state(TASK_UNINTERRUPTIBLE);
+	}
+}
+
 static int sync_unplug_thread(void *data)
 {
 	struct hotplug_pcp *hp = data;
 
 	preempt_disable();
 	hp->unplug = current;
+	wait_for_pinned_cpus(hp);
+
+	/*
+	 * This thread will synchronize the cpu_down() with threads
+	 * that have pinned the CPU. When the pinned CPU count reaches
+	 * zero, we inform the cpu_down code to continue to the next step.
+	 */
 	set_current_state(TASK_UNINTERRUPTIBLE);
-	while (hp->refcount) {
-		schedule_preempt_disabled();
+	preempt_enable();
+	complete(&hp->synced);
+
+	/*
+	 * If all succeeds, the next step will need tasks to wait till
+	 * the CPU is offline before continuing. To do this, the grab_lock
+	 * is set and tasks going into pin_current_cpu() will block on the
+	 * mutex. But we still need to wait for those that are already in
+	 * pinned CPU sections. If the cpu_down() failed, the kthread_should_stop()
+	 * will kick this thread out.
+	 */
+	while (!hp->grab_lock && !kthread_should_stop()) {
+		schedule();
+		set_current_state(TASK_UNINTERRUPTIBLE);
+	}
+
+	/* Make sure grab_lock is seen before we see a stale completion */
+	smp_mb();
+
+	/*
+	 * Now just before cpu_down() enters stop machine, we need to make
+	 * sure all tasks that are in pinned CPU sections are out, and new
+	 * tasks will now grab the lock, keeping them from entering pinned
+	 * CPU sections.
+	 */
+	if (!kthread_should_stop()) {
+		preempt_disable();
+		wait_for_pinned_cpus(hp);
+		preempt_enable();
+		complete(&hp->synced);
+	}
+
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		schedule();
 		set_current_state(TASK_UNINTERRUPTIBLE);
 	}
 	set_current_state(TASK_RUNNING);
-	preempt_enable();
-	complete(&hp->synced);
+
+	/*
+	 * Force this thread off this CPU as it's going down and
+	 * we don't want any more work on this CPU.
+	 */
+	current->flags &= ~PF_THREAD_BOUND;
+	do_set_cpus_allowed(current, cpu_present_mask);
+	migrate_me();
 	return 0;
 }
 
+static void __cpu_unplug_sync(struct hotplug_pcp *hp)
+{
+	wake_up_process(hp->sync_tsk);
+	wait_for_completion(&hp->synced);
+}
+
 /*
  * Start the sync_unplug_thread on the target cpu and wait for it to
  * complete.
@@ -137,23 +235,79 @@ static int sync_unplug_thread(void *data)
 static int cpu_unplug_begin(unsigned int cpu)
 {
 	struct hotplug_pcp *hp = &per_cpu(hotplug_pcp, cpu);
-	struct task_struct *tsk;
+	int err;
+
+	/* Protected by cpu_hotplug.lock */
+	if (!hp->mutex_init) {
+		mutex_init(&hp->mutex);
+		hp->mutex_init = 1;
+	}
+
+	/* Inform the scheduler to migrate tasks off this CPU */
+	tell_sched_cpu_down_begin(cpu);
 
 	init_completion(&hp->synced);
-	tsk = kthread_create(sync_unplug_thread, hp, "sync_unplug/%d", cpu);
-	if (IS_ERR(tsk))
-		return (PTR_ERR(tsk));
-	kthread_bind(tsk, cpu);
-	wake_up_process(tsk);
-	wait_for_completion(&hp->synced);
+
+	hp->sync_tsk = kthread_create(sync_unplug_thread, hp, "sync_unplug/%d", cpu);
+	if (IS_ERR(hp->sync_tsk)) {
+		err = PTR_ERR(hp->sync_tsk);
+		hp->sync_tsk = NULL;
+		return err;
+	}
+	kthread_bind(hp->sync_tsk, cpu);
+
+	/*
+	 * Wait for tasks to get out of the pinned sections,
+	 * it's still OK if new tasks enter. Some CPU notifiers will
+	 * wait for tasks that are going to enter these sections and
+	 * we must not have them block.
+	 */
+	__cpu_unplug_sync(hp);
+
 	return 0;
 }
 
+static void cpu_unplug_sync(unsigned int cpu)
+{
+	struct hotplug_pcp *hp = &per_cpu(hotplug_pcp, cpu);
+
+	init_completion(&hp->synced);
+	/* The completion needs to be initialzied before setting grab_lock */
+	smp_wmb();
+
+	/* Grab the mutex before setting grab_lock */
+	mutex_lock(&hp->mutex);
+	hp->grab_lock = 1;
+
+	/*
+	 * The CPU notifiers have been completed.
+	 * Wait for tasks to get out of pinned CPU sections and have new
+	 * tasks block until the CPU is completely down.
+	 */
+	__cpu_unplug_sync(hp);
+
+	/* All done with the sync thread */
+	kthread_stop(hp->sync_tsk);
+	hp->sync_tsk = NULL;
+}
+
 static void cpu_unplug_done(unsigned int cpu)
 {
 	struct hotplug_pcp *hp = &per_cpu(hotplug_pcp, cpu);
 
 	hp->unplug = NULL;
+	/* Let all tasks know cpu unplug is finished before cleaning up */
+	smp_wmb();
+
+	if (hp->sync_tsk)
+		kthread_stop(hp->sync_tsk);
+
+	if (hp->grab_lock) {
+		mutex_unlock(&hp->mutex);
+		/* protected by cpu_hotplug.lock */
+		hp->grab_lock = 0;
+	}
+	tell_sched_cpu_down_done(cpu);
 }
 
 void get_online_cpus(void)
@@ -354,6 +508,9 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		goto out_release;
 	}
 
+	/* Notifiers are done. Don't let any more tasks pin this CPU. */
+	cpu_unplug_sync(cpu);
+
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
diff --git a/kernel/sched.c b/kernel/sched.c
index 1cc706d..2e31cad 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4404,7 +4404,7 @@ void migrate_disable(void)
 {
 	struct task_struct *p = current;
 
-	if (in_atomic() || p->flags & PF_THREAD_BOUND) {
+	if (in_atomic()) {
 #ifdef CONFIG_SCHED_DEBUG
 		p->migrate_disable_atomic++;
 #endif
@@ -4435,7 +4435,7 @@ void migrate_enable(void)
 	unsigned long flags;
 	struct rq *rq;
 
-	if (in_atomic() || p->flags & PF_THREAD_BOUND) {
+	if (in_atomic()) {
 #ifdef CONFIG_SCHED_DEBUG
 		p->migrate_disable_atomic--;
 #endif
@@ -6361,6 +6361,84 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 	cpumask_copy(&p->cpus_allowed, new_mask);
 }
 
+static DEFINE_PER_CPU(struct cpumask, sched_cpumasks);
+static DEFINE_MUTEX(sched_down_mutex);
+static cpumask_t sched_down_cpumask;
+
+void tell_sched_cpu_down_begin(int cpu)
+{
+	mutex_lock(&sched_down_mutex);
+	cpumask_set_cpu(cpu, &sched_down_cpumask);
+	mutex_unlock(&sched_down_mutex);
+}
+
+void tell_sched_cpu_down_done(int cpu)
+{
+	mutex_lock(&sched_down_mutex);
+	cpumask_clear_cpu(cpu, &sched_down_cpumask);
+	mutex_unlock(&sched_down_mutex);
+}
+
+/**
+ * migrate_me - try to move the current task off this cpu
+ *
+ * Used by the pin_current_cpu() code to try to get tasks
+ * to move off the current CPU as it is going down.
+ * It will only move the task if the task isn't pinned to
+ * the CPU (with migrate_disable, affinity or THREAD_BOUND)
+ * and the task has to be in a RUNNING state. Otherwise the
+ * movement of the task will wake it up (change its state
+ * to running) when the task did not expect it.
+ *
+ * Returns 1 if it succeeded in moving the current task
+ *         0 otherwise.
+ */
+int migrate_me(void)
+{
+	struct task_struct *p = current;
+	struct migration_arg arg;
+	struct cpumask *cpumask;
+	struct cpumask *mask;
+	unsigned long flags;
+	unsigned int dest_cpu;
+	struct rq *rq;
+
+	/*
+	 * We can not migrate tasks bounded to a CPU or tasks not
+	 * running. The movement of the task will wake it up.
+	 */
+	if (p->flags & PF_THREAD_BOUND || p->state)
+		return 0;
+
+	mutex_lock(&sched_down_mutex);
+	rq = task_rq_lock(p, &flags);
+
+	cpumask = &__get_cpu_var(sched_cpumasks);
+	mask = &p->cpus_allowed;
+
+	cpumask_andnot(cpumask, mask, &sched_down_cpumask);
+
+	if (!cpumask_weight(cpumask)) {
+		/* It's only on this CPU? */
+		task_rq_unlock(rq, p, &flags);
+		mutex_unlock(&sched_down_mutex);
+		return 0;
+	}
+
+	dest_cpu = cpumask_any_and(cpu_active_mask, cpumask);
+
+	arg.task = p;
+	arg.dest_cpu = dest_cpu;
+
+	task_rq_unlock(rq, p, &flags);
+
+	stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
+	tlb_migrate_finish(p->mm);
+	mutex_unlock(&sched_down_mutex);
+
+	return 1;
+}
+
 /*
  * This is how migration works:
  *
-- 
1.7.3.4


