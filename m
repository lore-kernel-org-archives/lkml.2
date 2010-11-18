Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab0KROKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:10:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:41467 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144Ab0KROKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:10:19 -0500
Date: Thu, 18 Nov 2010 14:09:53 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
        mingo@elte.hu
In-Reply-To: <1289851597.2109.547.camel@laptop>
References: <1289851597.2109.547.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Simplify cpu-hot-unplug task migration
Message-ID: <tip-48c5ccae88dcd989d9de507e8510313c6cbd352b@git.kernel.org>
Git-Commit-ID: 48c5ccae88dcd989d9de507e8510313c6cbd352b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:09:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48c5ccae88dcd989d9de507e8510313c6cbd352b
Gitweb:     http://git.kernel.org/tip/48c5ccae88dcd989d9de507e8510313c6cbd352b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 13 Nov 2010 19:32:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:27:46 +0100

sched: Simplify cpu-hot-unplug task migration

While discussing the need for sched_idle_next(), Oleg remarked that
since try_to_wake_up() ensures sleeping tasks will end up running on a
sane cpu, we can do away with migrate_live_tasks().

If we then extend the existing hack of migrating current from
CPU_DYING to migrating the full rq worth of tasks from CPU_DYING, the
need for the sched_idle_next() abomination disappears as well, since
idle will be the only possible thread left after the migration thread
stops.

This greatly simplifies the hot-unplug task migration path, as can be
seen from the resulting code reduction (and about half the new lines
are comments).

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1289851597.2109.547.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    3 -
 kernel/cpu.c          |   16 ++---
 kernel/sched.c        |  206 +++++++++++++++----------------------------------
 3 files changed, 67 insertions(+), 158 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3cd70cf..29d953a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1871,14 +1871,11 @@ extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 
 #ifdef CONFIG_HOTPLUG_CPU
-extern void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p);
 extern void idle_task_exit(void);
 #else
 static inline void idle_task_exit(void) {}
 #endif
 
-extern void sched_idle_next(void);
-
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
 extern void wake_up_idle_cpu(int cpu);
 #else
diff --git a/kernel/cpu.c b/kernel/cpu.c
index f6e726f..8615aa6 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -189,7 +189,6 @@ static inline void check_for_tasks(int cpu)
 }
 
 struct take_cpu_down_param {
-	struct task_struct *caller;
 	unsigned long mod;
 	void *hcpu;
 };
@@ -208,11 +207,6 @@ static int __ref take_cpu_down(void *_param)
 
 	cpu_notify(CPU_DYING | param->mod, param->hcpu);
 
-	if (task_cpu(param->caller) == cpu)
-		move_task_off_dead_cpu(cpu, param->caller);
-	/* Force idle task to run as soon as we yield: it should
-	   immediately notice cpu is offline and die quickly. */
-	sched_idle_next();
 	return 0;
 }
 
@@ -223,7 +217,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
-		.caller = current,
 		.mod = mod,
 		.hcpu = hcpu,
 	};
@@ -253,9 +246,12 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	}
 	BUG_ON(cpu_online(cpu));
 
-	/* Wait for it to sleep (leaving idle task). */
-	while (!idle_cpu(cpu))
-		yield();
+	/*
+	 * The migration_call() CPU_DYING callback will have removed all
+	 * runnable tasks from the cpu, there's only the idle task left now
+	 * that the migration thread is done doing the stop_machine thing.
+	 */
+	BUG_ON(!idle_cpu(cpu));
 
 	/* This actually kills the CPU. */
 	__cpu_die(cpu);
diff --git a/kernel/sched.c b/kernel/sched.c
index 41f1869..b0d5f1b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2366,18 +2366,15 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 		return dest_cpu;
 
 	/* No more Mr. Nice Guy. */
-	if (unlikely(dest_cpu >= nr_cpu_ids)) {
-		dest_cpu = cpuset_cpus_allowed_fallback(p);
-		/*
-		 * Don't tell them about moving exiting tasks or
-		 * kernel threads (both mm NULL), since they never
-		 * leave kernel.
-		 */
-		if (p->mm && printk_ratelimit()) {
-			printk(KERN_INFO "process %d (%s) no "
-			       "longer affine to cpu%d\n",
-			       task_pid_nr(p), p->comm, cpu);
-		}
+	dest_cpu = cpuset_cpus_allowed_fallback(p);
+	/*
+	 * Don't tell them about moving exiting tasks or
+	 * kernel threads (both mm NULL), since they never
+	 * leave kernel.
+	 */
+	if (p->mm && printk_ratelimit()) {
+		printk(KERN_INFO "process %d (%s) no longer affine to cpu%d\n",
+				task_pid_nr(p), p->comm, cpu);
 	}
 
 	return dest_cpu;
@@ -5712,29 +5709,20 @@ static int migration_cpu_stop(void *data)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
+
 /*
- * Figure out where task on dead CPU should go, use force if necessary.
+ * Ensures that the idle task is using init_mm right before its cpu goes
+ * offline.
  */
-void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
+void idle_task_exit(void)
 {
-	struct rq *rq = cpu_rq(dead_cpu);
-	int needs_cpu, uninitialized_var(dest_cpu);
-	unsigned long flags;
+	struct mm_struct *mm = current->active_mm;
 
-	local_irq_save(flags);
+	BUG_ON(cpu_online(smp_processor_id()));
 
-	raw_spin_lock(&rq->lock);
-	needs_cpu = (task_cpu(p) == dead_cpu) && (p->state != TASK_WAKING);
-	if (needs_cpu)
-		dest_cpu = select_fallback_rq(dead_cpu, p);
-	raw_spin_unlock(&rq->lock);
-	/*
-	 * It can only fail if we race with set_cpus_allowed(),
-	 * in the racer should migrate the task anyway.
-	 */
-	if (needs_cpu)
-		__migrate_task(p, dead_cpu, dest_cpu);
-	local_irq_restore(flags);
+	if (mm != &init_mm)
+		switch_mm(mm, &init_mm, current);
+	mmdrop(mm);
 }
 
 /*
@@ -5747,128 +5735,69 @@ void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 static void migrate_nr_uninterruptible(struct rq *rq_src)
 {
 	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
-	unsigned long flags;
 
-	local_irq_save(flags);
-	double_rq_lock(rq_src, rq_dest);
 	rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
 	rq_src->nr_uninterruptible = 0;
-	double_rq_unlock(rq_src, rq_dest);
-	local_irq_restore(flags);
-}
-
-/* Run through task list and migrate tasks from the dead cpu. */
-static void migrate_live_tasks(int src_cpu)
-{
-	struct task_struct *p, *t;
-
-	read_lock(&tasklist_lock);
-
-	do_each_thread(t, p) {
-		if (p == current)
-			continue;
-
-		if (task_cpu(p) == src_cpu)
-			move_task_off_dead_cpu(src_cpu, p);
-	} while_each_thread(t, p);
-
-	read_unlock(&tasklist_lock);
 }
 
 /*
- * Schedules idle task to be the next runnable task on current CPU.
- * It does so by boosting its priority to highest possible.
- * Used by CPU offline code.
+ * remove the tasks which were accounted by rq from calc_load_tasks.
  */
-void sched_idle_next(void)
+static void calc_global_load_remove(struct rq *rq)
 {
-	int this_cpu = smp_processor_id();
-	struct rq *rq = cpu_rq(this_cpu);
-	struct task_struct *p = rq->idle;
-	unsigned long flags;
-
-	/* cpu has to be offline */
-	BUG_ON(cpu_online(this_cpu));
-
-	/*
-	 * Strictly not necessary since rest of the CPUs are stopped by now
-	 * and interrupts disabled on the current cpu.
-	 */
-	raw_spin_lock_irqsave(&rq->lock, flags);
-
-	__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
-
-	activate_task(rq, p, 0);
-
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
+	rq->calc_load_active = 0;
 }
 
 /*
- * Ensures that the idle task is using init_mm right before its cpu goes
- * offline.
+ * Migrate all tasks from the rq, sleeping tasks will be migrated by
+ * try_to_wake_up()->select_task_rq().
+ *
+ * Called with rq->lock held even though we'er in stop_machine() and
+ * there's no concurrency possible, we hold the required locks anyway
+ * because of lock validation efforts.
  */
-void idle_task_exit(void)
-{
-	struct mm_struct *mm = current->active_mm;
-
-	BUG_ON(cpu_online(smp_processor_id()));
-
-	if (mm != &init_mm)
-		switch_mm(mm, &init_mm, current);
-	mmdrop(mm);
-}
-
-/* called under rq->lock with disabled interrupts */
-static void migrate_dead(unsigned int dead_cpu, struct task_struct *p)
+static void migrate_tasks(unsigned int dead_cpu)
 {
 	struct rq *rq = cpu_rq(dead_cpu);
-
-	/* Must be exiting, otherwise would be on tasklist. */
-	BUG_ON(!p->exit_state);
-
-	/* Cannot have done final schedule yet: would have vanished. */
-	BUG_ON(p->state == TASK_DEAD);
-
-	get_task_struct(p);
+	struct task_struct *next, *stop = rq->stop;
+	int dest_cpu;
 
 	/*
-	 * Drop lock around migration; if someone else moves it,
-	 * that's OK. No task can be added to this CPU, so iteration is
-	 * fine.
+	 * Fudge the rq selection such that the below task selection loop
+	 * doesn't get stuck on the currently eligible stop task.
+	 *
+	 * We're currently inside stop_machine() and the rq is either stuck
+	 * in the stop_machine_cpu_stop() loop, or we're executing this code,
+	 * either way we should never end up calling schedule() until we're
+	 * done here.
 	 */
-	raw_spin_unlock_irq(&rq->lock);
-	move_task_off_dead_cpu(dead_cpu, p);
-	raw_spin_lock_irq(&rq->lock);
-
-	put_task_struct(p);
-}
-
-/* release_task() removes task from tasklist, so we won't find dead tasks. */
-static void migrate_dead_tasks(unsigned int dead_cpu)
-{
-	struct rq *rq = cpu_rq(dead_cpu);
-	struct task_struct *next;
+	rq->stop = NULL;
 
 	for ( ; ; ) {
-		if (!rq->nr_running)
+		/*
+		 * There's this thread running, bail when that's the only
+		 * remaining thread.
+		 */
+		if (rq->nr_running == 1)
 			break;
+
 		next = pick_next_task(rq);
-		if (!next)
-			break;
+		BUG_ON(!next);
 		next->sched_class->put_prev_task(rq, next);
-		migrate_dead(dead_cpu, next);
 
+		/* Find suitable destination for @next, with force if needed. */
+		dest_cpu = select_fallback_rq(dead_cpu, next);
+		raw_spin_unlock(&rq->lock);
+
+		__migrate_task(next, dead_cpu, dest_cpu);
+
+		raw_spin_lock(&rq->lock);
 	}
-}
 
-/*
- * remove the tasks which were accounted by rq from calc_load_tasks.
- */
-static void calc_global_load_remove(struct rq *rq)
-{
-	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
-	rq->calc_load_active = 0;
+	rq->stop = stop;
 }
+
 #endif /* CONFIG_HOTPLUG_CPU */
 
 #if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_SYSCTL)
@@ -6078,15 +6007,13 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	unsigned long flags;
 	struct rq *rq = cpu_rq(cpu);
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		rq->calc_load_update = calc_load_update;
 		break;
 
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		/* Update our root-domain */
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
@@ -6098,30 +6025,19 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		migrate_live_tasks(cpu);
-		/* Idle task back to normal (off runqueue, low prio) */
-		raw_spin_lock_irq(&rq->lock);
-		deactivate_task(rq, rq->idle, 0);
-		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
-		rq->idle->sched_class = &idle_sched_class;
-		migrate_dead_tasks(cpu);
-		raw_spin_unlock_irq(&rq->lock);
-		migrate_nr_uninterruptible(rq);
-		BUG_ON(rq->nr_running != 0);
-		calc_global_load_remove(rq);
-		break;
-
 	case CPU_DYING:
-	case CPU_DYING_FROZEN:
 		/* Update our root-domain */
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 			set_rq_offline(rq);
 		}
+		migrate_tasks(cpu);
+		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+
+		migrate_nr_uninterruptible(rq);
+		calc_global_load_remove(rq);
 		break;
 #endif
 	}
