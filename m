Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab0KMUwO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 15:52:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:43426 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab0KMUwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 15:52:13 -0500
Subject: Re: [RFC][PATCH 06/22] sched: SCHED_DEADLINE handles spacial
 kthreads
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289680291.2109.244.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333876.8661.147.camel@Palantir> <1289486096.2084.123.camel@laptop>
	 <20101111152750.GA2510@redhat.com> <1289490202.2084.140.camel@laptop>
	 <20101111163242.GA5697@redhat.com> <1289673355.2109.79.camel@laptop>
	 <20101113195857.GA11411@redhat.com>  <1289680291.2109.244.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 21:51:37 +0100
Message-ID: <1289681497.2109.270.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Latest version, I actually compiled it too ! 

---
Subject: sched: Simplify cpu-hot-unplug task migration
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Sat Nov 13 19:32:29 CET 2010

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    3 
 kernel/cpu.c          |   17 +---
 kernel/sched.c        |  201 ++++++++++++++------------------------------------
 3 files changed, 63 insertions(+), 158 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1872,14 +1872,11 @@ extern void sched_clock_idle_sleep_event
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
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -189,7 +189,6 @@ static inline void check_for_tasks(int c
 }
 
 struct take_cpu_down_param {
-	struct task_struct *caller;
 	unsigned long mod;
 	void *hcpu;
 };
@@ -198,7 +197,6 @@ struct take_cpu_down_param {
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
-	unsigned int cpu = (unsigned long)param->hcpu;
 	int err;
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
@@ -208,11 +206,6 @@ static int __ref take_cpu_down(void *_pa
 
 	cpu_notify(CPU_DYING | param->mod, param->hcpu);
 
-	if (task_cpu(param->caller) == cpu)
-		move_task_off_dead_cpu(cpu, param->caller);
-	/* Force idle task to run as soon as we yield: it should
-	   immediately notice cpu is offline and die quickly. */
-	sched_idle_next();
 	return 0;
 }
 
@@ -223,7 +216,6 @@ static int __ref _cpu_down(unsigned int
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
-		.caller = current,
 		.mod = mod,
 		.hcpu = hcpu,
 	};
@@ -253,9 +245,12 @@ static int __ref _cpu_down(unsigned int
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
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2381,18 +2381,15 @@ static int select_fallback_rq(int cpu, s
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
@@ -5727,29 +5724,20 @@ static int migration_cpu_stop(void *data
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
@@ -5762,128 +5750,66 @@ void move_task_off_dead_cpu(int dead_cpu
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
+ * Called with rq->lock held.
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
+		/*
+		 * Will terminate the loop before we should get around
+		 * selecting the idle task.
+		 */
 		if (!rq->nr_running)
 			break;
 		next = pick_next_task(rq);
-		if (!next)
-			break;
+		BUG_ON(!next); /* there's always the idle task */
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
@@ -6093,15 +6019,13 @@ migration_call(struct notifier_block *nf
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
@@ -6113,30 +6037,19 @@ migration_call(struct notifier_block *nf
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
+		BUG_ON(rq->nr_running != 0);
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+
+		migrate_nr_uninterruptible(rq);
+		calc_global_load_remove(rq);
 		break;
 #endif
 	}

