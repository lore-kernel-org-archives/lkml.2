Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab0ETUtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:49:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63786 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab0ETUtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:49:09 -0400
Date: Thu, 20 May 2010 16:48:10 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RFC] reduce runqueue lock contention
Message-ID: <20100520204810.GA19188@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, peterz@infradead.org, axboe@kernel.dk,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BF5A010.018F:SCFMA922111,ss=1,pt=DBB_66871,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is more of a starting point than a patch, but it is something I've
been meaning to look at for a long time.  Many different workloads end
up hammering very hard on try_to_wake_up, to the point where the
runqueue locks dominate CPU profiles.

This includes benchmarking really fast IO subsystems, fast networking,
fast pipes...well anywhere that we lots of procs on lots of cpus waiting
for short periods on lots of different things.

I think we probably want to add a way to wait just for a little while as
a more lightweight operation (less balancing etc) but this patch doesn't
do that.  It only tries to make the act of waking someone up less
expensive by avoiding the runqueue lock when we're on a different CPU
than the process we want to wake.

I do this with a per-runqueue list and some cmpxchg tricks.  Basically
all the other CPUs will toss a given process they want to wakeup onto
the destination per-runqueue list.  Later on, when that runqueue is
finding a new task to run, it processes the list in bulk.

>From a performance point of view, this adds about 10% to a TPC
simulation on a large numa machine.  It doubles the speed of my IPC semaphore
benchmark (which really just hammers on wakeup in a loop).

This is probably broken in less than subtle ways, so it includes a new
schedule feature to (FAST_WAKEUP) to control the new mode.

diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..9c2f188 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1187,6 +1187,8 @@ struct task_struct {
 	const struct sched_class *sched_class;
 	struct sched_entity se;
 	struct sched_rt_entity rt;
+	struct task_struct *fast_wakeup_next;
+	unsigned long fast_wakeup_mode;
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
diff --git a/kernel/sched.c b/kernel/sched.c
index 3c2a54f..3667e89 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -530,6 +530,7 @@ struct rq {
 	unsigned long nr_uninterruptible;
 
 	struct task_struct *curr, *idle;
+	struct task_struct *fast_wakeup;
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
 
@@ -968,6 +969,24 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 	}
 }
 
+/*
+ * return the rq for a task without actually taking the lock
+ * this is racey, the task may get moved elsewhere
+ */
+static struct rq *task_rq_nolock(struct task_struct *p, unsigned long *flags)
+{
+	struct rq *rq;
+
+	for (;;) {
+		while (task_is_waking(p))
+			cpu_relax();
+		smp_mb();
+		rq = task_rq(p);
+		if (likely(rq == task_rq(p) && !task_is_waking(p)))
+			return rq;
+	}
+}
+
 void task_rq_unlock_wait(struct task_struct *p)
 {
 	struct rq *rq = task_rq(p);
@@ -1241,6 +1260,29 @@ void wake_up_idle_cpu(int cpu)
 }
 #endif /* CONFIG_NO_HZ */
 
+void force_idle_wake(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	smp_mb();
+	if (rq->curr != rq->idle)
+		return;
+
+	if (cpu_is_offline(cpu))
+		return;
+	/*
+	 * We can set TIF_RESCHED on the idle task of the other CPU
+	 * lockless. The worst case is that the other CPU runs the
+	 * idle task through an additional NOOP schedule()
+	 */
+	set_tsk_need_resched(rq->idle);
+
+	/* NEED_RESCHED must be visible before we test polling */
+	smp_mb();
+	if (!tsk_is_polling(rq->idle))
+		smp_send_reschedule(cpu);
+}
+
 static u64 sched_avg_period(void)
 {
 	return (u64)sysctl_sched_time_avg * NSEC_PER_MSEC / 2;
@@ -2351,6 +2393,138 @@ int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 }
 #endif
 
+/*
+ * we stuff a 0x1 into the task fast_wakeup_next pointer to claim
+ * ownership of the pointer.  Basically this allows us to make sure
+ * that only a single process is doing a fast queue on a given process at
+ * once.
+ *
+ * fastwake_next() masks off the 0x1 so we can check to see if the next
+ * pointer is null.  We can't set it to null while the task is on the
+ * list because that would allow someone else to jump in and
+ * try to queue up the process again.
+ */
+static inline struct task_struct *fastwake_next(struct task_struct *p)
+{
+	return (struct task_struct *)((unsigned long)p->fast_wakeup_next &
+				      ~(1UL));
+}
+
+/*
+ * accessing the runqueue lock from a remote numa node can
+ * be very expensive.  To avoid contention on the runqueue lock
+ * we do a lockless cmpxchg operation to just stuff this task
+ * into a per-runq list of things that must be woken up.
+ *
+ * The list is processed each time we schedule.
+ *
+ * This returns 0 if all went well or -1 if you must
+ * proceed with the try_to_wake_up yourself.
+ */
+static int queue_fast_wakeup(struct task_struct *p, int mode)
+{
+	struct rq *rq;
+	unsigned long flags;
+	struct task_struct *old_tail;
+	struct task_struct *old_ptr;
+	struct task_struct *next;
+	int ret = 0;
+
+	if (!sched_feat(FAST_WAKEUP))
+		return -1;
+
+	old_ptr = cmpxchg(&p->fast_wakeup_next, NULL,
+			  (struct task_struct *)0x1);
+
+	rq = task_rq_nolock(p, &flags);
+
+	/* if it wasn't null fast_wakeup_next, we're already on some CPU's list
+	 * of things to be woken.  We don't know which list, and
+	 * things can go badly if we assume this task isn't
+	 * already running somewhere.
+	 *
+	 * If we return zero here, things go badly with exclusive wakeups
+	 * because our caller thinks we've woken up a task when really this
+	 * one might be running.  To avoid those kinds of races and other
+	 * issues, we return -1 and force the caller to go all the way
+	 * through with the full try_to_wake_up.
+	 */
+	if (old_ptr) {
+		if (mode == TASK_ALL)
+			p->fast_wakeup_mode = TASK_ALL;
+		ret = -1;
+		goto checks;
+	}
+	/*
+	 * fast_wakeup_next is now set to 0x1, which means this task is our
+	 * responsibility to wake up.  We take a reference on the task struct
+	 * for the list
+	 */
+	get_task_struct(p);
+	old_tail = NULL;
+
+	/* offline cpus mean just use the real ttwu */
+	if (cpu_is_offline(rq->cpu)) {
+		p->fast_wakeup_next = NULL;
+		put_task_struct(p);
+		return -1;
+	}
+	p->fast_wakeup_mode = mode;
+
+	/* our xchg loop has two parts.  We replace the
+	 * rq fast_wakeup list with NULL and we append
+	 * any procs that were in the list onto our list.
+	 * Then we try to cmpxchg our updated list back into
+	 * the rq.
+	 *
+	 * If the rq still has NULL, we're done.  If not
+	 * someone else has raced in and we loop around again
+	 * pulling their updates off the list and appending them
+	 * onto our own list
+	 */
+	while (1) {
+		old_ptr = xchg(&rq->fast_wakeup, NULL);
+		if (old_ptr) {
+			if (old_tail) {
+				while (1) {
+					next = fastwake_next(old_tail);
+					if (!next)
+						break;
+					old_tail = next;
+				}
+			} else {
+				old_tail = p;
+			}
+			old_tail->fast_wakeup_next = old_ptr;
+		}
+		old_ptr = cmpxchg(&rq->fast_wakeup, NULL, p);
+		if (!old_ptr)
+			break;
+	}
+checks:
+	smp_mb();
+	/*
+	 * if the process state changed after they went into the
+	 * dedicated list, go through the full try_to_wake_up code
+	 * We don't want to return that we've woken a task if it
+	 * was actually already running on its own.
+	 *
+	 * But make sure to do the reschedule kick so that our
+	 * task is eventually taken off the list for that CPU.
+	 */
+	if (!(p->state & mode) || p->se.on_rq || task_running(rq, p))
+		ret = -1;
+
+	if (unlikely(rt_prio(p->prio)))
+		resched_cpu(rq->cpu);
+	else
+		force_idle_wake(rq->cpu);
+
+	if (cpu_is_offline(rq->cpu))
+		ret = -1;
+	return ret;
+}
+
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
@@ -2377,6 +2551,20 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 
 	this_cpu = get_cpu();
 
+	if (sched_feat(FAST_WAKEUP)) {
+		smp_mb();
+		/* we only want to do the fast wakeup if
+		 * the task isn't already running.
+		 */
+		if (this_cpu != task_cpu(p) && wake_flags == 0 &&
+		    !p->se.on_rq && p->pid != 0 && (p->state & state)) {
+			if (queue_fast_wakeup(p, state) == 0) {
+				put_cpu();
+				return 1;
+			}
+		}
+	}
+
 	smp_wmb();
 	rq = task_rq_lock(p, &flags);
 	update_rq_clock(rq);
@@ -2499,10 +2687,42 @@ out_running:
 out:
 	task_rq_unlock(rq, &flags);
 	put_cpu();
-
 	return success;
 }
 
+/*
+ * run all the wakeups we've queued on the rq.
+ */
+static void run_fast_queue(struct rq *rq)
+{
+	struct task_struct *head;
+	struct task_struct *next;
+	unsigned long mode;
+
+	if (!sched_feat(FAST_WAKEUP) && !rq->fast_wakeup)
+		return;
+
+again:
+	/*
+	 * we swap the list pointer on the rq with NULL
+	 * and then we are able to go through the
+	 * entire list without any locks
+	 */
+	head = xchg(&rq->fast_wakeup, NULL);
+
+	while (head) {
+		next = fastwake_next(head);
+		mode = head->fast_wakeup_mode;
+		head->fast_wakeup_next = NULL;
+		try_to_wake_up(head, mode, 0);
+		put_task_struct(head);
+		head = next;
+	}
+	smp_mb();
+	if (rq->fast_wakeup)
+		goto again;
+}
+
 /**
  * wake_up_process - Wake up a specific process
  * @p: The process to be woken up.
@@ -2533,6 +2753,7 @@ int wake_up_state(struct task_struct *p, unsigned int state)
  */
 static void __sched_fork(struct task_struct *p)
 {
+	p->fast_wakeup_next = NULL;
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
@@ -2858,6 +3079,7 @@ static inline void post_schedule(struct rq *rq)
 
 		rq->post_schedule = 0;
 	}
+	run_fast_queue(rq);
 }
 
 #else
@@ -3711,6 +3933,9 @@ need_resched:
 	switch_count = &prev->nivcsw;
 
 	release_kernel_lock(prev);
+
+	run_fast_queue(rq);
+
 need_resched_nonpreemptible:
 
 	schedule_debug(prev);
@@ -5674,7 +5899,6 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
 			break;
 		next->sched_class->put_prev_task(rq, next);
 		migrate_dead(dead_cpu, next);
-
 	}
 }
 
@@ -5944,9 +6168,11 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		rq = cpu_rq(cpu);
+		run_fast_queue(rq);
+
 		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
-		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
 		put_task_struct(rq->migration_thread);
 		rq->migration_thread = NULL;
@@ -7747,6 +7973,7 @@ void __init sched_init(void)
 
 		rq = cpu_rq(i);
 		raw_spin_lock_init(&rq->lock);
+		rq->fast_wakeup = NULL;
 		rq->nr_running = 0;
 		rq->calc_load_active = 0;
 		rq->calc_load_update = jiffies + LOAD_FREQ;
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index d5059fd..044e93c 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -116,3 +116,5 @@ SCHED_FEAT(ASYM_EFF_LOAD, 1)
  * release the lock. Decreases scheduling overhead.
  */
 SCHED_FEAT(OWNER_SPIN, 1)
+
+SCHED_FEAT(FAST_WAKEUP, 0)
