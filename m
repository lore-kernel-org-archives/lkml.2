Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab0EESLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:11:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:48910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab0EESLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:11:43 -0400
Message-ID: <4BE1B49F.2020404@kernel.org>
Date: Wed, 05 May 2010 20:10:39 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Josh Triplett <josh@freedesktop.org>, Oleg Nesterov <oleg@redhat.com>,
       Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH 3/4 UPDATED] scheduler: replace migration_thread with cpu_stop
References: <1272980864-27235-1-git-send-email-tj@kernel.org> <1272980864-27235-4-git-send-email-tj@kernel.org> <20100505013351.GN2639@linux.vnet.ibm.com> <4BE11E29.6040106@kernel.org> <20100505174725.GA6783@linux.vnet.ibm.com>
In-Reply-To: <20100505174725.GA6783@linux.vnet.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 18:10:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently migration_thread is serving three purposes - migration
pusher, context to execute active_load_balance() and forced context
switcher for expedited RCU synchronize_sched.  All three roles are
hardcoded into migration_thread() and determining which job is
scheduled is slightly messy.

This patch kills migration_thread and replaces all three uses with
cpu_stop.  The three different roles of migration_thread() are
splitted into three separate cpu_stop callbacks -
migration_cpu_stop(), active_load_balance_cpu_stop() and
synchronize_sched_expedited_cpu_stop() - and each use case now simply
asks cpu_stop to execute the callback as necessary.

synchronize_sched_expedited() was implemented with private
preallocated resources and custom multi-cpu queueing and waiting
logic, both of which are provided by cpu_stop.
synchronize_sched_expedited_count is made atomic and all other shared
resources along with the mutex are dropped.

synchronize_sched_expedited() also implemented a check to detect cases
where not all the callback got executed on their assigned cpus and
fall back to synchronize_sched().  If called with cpu hotplug blocked,
cpu_stop already guarantees that and the condition cannot happen;
otherwise, stop_machine() would break.  However, this patch preserves
the paranoid check using a cpumask to record on which cpus the stopper
ran so that it can serve as a bisection point if something actually
goes wrong theree.

Because the internal execution state is no longer visible,
rcu_expedited_torture_stats() is removed.

This patch also renames cpu_stop threads to from "stopper/%d" to
"migration/%d".  The names of these threads ultimately don't matter
and there's no reason to make unnecessary userland visible changes.

With this patch applied, stop_machine() and sched now share the same
resources.  stop_machine() is faster without wasting any resources and
sched migration users are much cleaner.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Josh Triplett <josh@freedesktop.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
---
Alright, smp_mb() and comments added.  Paul, can you please ack this?

Thank you.

 Documentation/RCU/torture.txt |   10 -
 include/linux/rcutiny.h       |    2
 include/linux/rcutree.h       |    1
 kernel/rcutorture.c           |    2
 kernel/sched.c                |  315 ++++++++++++------------------------------
 kernel/sched_fair.c           |   48 ++++--
 kernel/stop_machine.c         |    2
 7 files changed, 127 insertions(+), 253 deletions(-)

Index: work/kernel/sched.c
===================================================================
--- work.orig/kernel/sched.c
+++ work/kernel/sched.c
@@ -55,9 +55,9 @@
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/percpu.h>
-#include <linux/kthread.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/stop_machine.h>
 #include <linux/sysctl.h>
 #include <linux/syscalls.h>
 #include <linux/times.h>
@@ -539,15 +539,13 @@ struct rq {
 	int post_schedule;
 	int active_balance;
 	int push_cpu;
+	struct cpu_stop_work active_balance_work;
 	/* cpu of this runqueue: */
 	int cpu;
 	int online;

 	unsigned long avg_load_per_task;

-	struct task_struct *migration_thread;
-	struct list_head migration_queue;
-
 	u64 rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
@@ -2037,21 +2035,18 @@ void set_task_cpu(struct task_struct *p,
 	__set_task_cpu(p, new_cpu);
 }

-struct migration_req {
-	struct list_head list;
-
+struct migration_arg {
 	struct task_struct *task;
 	int dest_cpu;
-
-	struct completion done;
 };

+static int migration_cpu_stop(void *data);
+
 /*
  * The task's runqueue lock must be held.
  * Returns true if you have to wait for migration thread.
  */
-static int
-migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
+static bool migrate_task(struct task_struct *p, int dest_cpu)
 {
 	struct rq *rq = task_rq(p);

@@ -2059,15 +2054,7 @@ migrate_task(struct task_struct *p, int
 	 * If the task is not on a runqueue (and not running), then
 	 * the next wake-up will properly place the task.
 	 */
-	if (!p->se.on_rq && !task_running(rq, p))
-		return 0;
-
-	init_completion(&req->done);
-	req->task = p;
-	req->dest_cpu = dest_cpu;
-	list_add(&req->list, &rq->migration_queue);
-
-	return 1;
+	return p->se.on_rq || task_running(rq, p);
 }

 /*
@@ -3056,7 +3043,6 @@ static void update_cpu_load(struct rq *t
 void sched_exec(void)
 {
 	struct task_struct *p = current;
-	struct migration_req req;
 	unsigned long flags;
 	struct rq *rq;
 	int dest_cpu;
@@ -3070,17 +3056,11 @@ void sched_exec(void)
 	 * select_task_rq() can race against ->cpus_allowed
 	 */
 	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
-	    likely(cpu_active(dest_cpu)) &&
-	    migrate_task(p, dest_cpu, &req)) {
-		/* Need to wait for migration thread (might exit: take ref). */
-		struct task_struct *mt = rq->migration_thread;
+	    likely(cpu_active(dest_cpu)) && migrate_task(p, dest_cpu)) {
+		struct migration_arg arg = { p, dest_cpu };

-		get_task_struct(mt);
 		task_rq_unlock(rq, &flags);
-		wake_up_process(mt);
-		put_task_struct(mt);
-		wait_for_completion(&req.done);
-
+		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
 		return;
 	}
 unlock:
@@ -5236,17 +5216,15 @@ static inline void sched_init_granularit
 /*
  * This is how migration works:
  *
- * 1) we queue a struct migration_req structure in the source CPU's
- *    runqueue and wake up that CPU's migration thread.
- * 2) we down() the locked semaphore => thread blocks.
- * 3) migration thread wakes up (implicitly it forces the migrated
- *    thread off the CPU)
- * 4) it gets the migration request and checks whether the migrated
- *    task is still in the wrong runqueue.
- * 5) if it's in the wrong runqueue then the migration thread removes
+ * 1) we invoke migration_cpu_stop() on the target CPU using
+ *    stop_one_cpu().
+ * 2) stopper starts to run (implicitly forcing the migrated thread
+ *    off the CPU)
+ * 3) it checks whether the migrated task is still in the wrong runqueue.
+ * 4) if it's in the wrong runqueue then the migration thread removes
  *    it and puts it into the right queue.
- * 6) migration thread up()s the semaphore.
- * 7) we wake up and the migration is done.
+ * 5) stopper completes and stop_one_cpu() returns and the migration
+ *    is done.
  */

 /*
@@ -5260,9 +5238,9 @@ static inline void sched_init_granularit
  */
 int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 {
-	struct migration_req req;
 	unsigned long flags;
 	struct rq *rq;
+	unsigned int dest_cpu;
 	int ret = 0;

 	/*
@@ -5300,15 +5278,12 @@ again:
 	if (cpumask_test_cpu(task_cpu(p), new_mask))
 		goto out;

-	if (migrate_task(p, cpumask_any_and(cpu_active_mask, new_mask), &req)) {
+	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
+	if (migrate_task(p, dest_cpu)) {
+		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
-		struct task_struct *mt = rq->migration_thread;
-
-		get_task_struct(mt);
 		task_rq_unlock(rq, &flags);
-		wake_up_process(mt);
-		put_task_struct(mt);
-		wait_for_completion(&req.done);
+		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
 		tlb_migrate_finish(p->mm);
 		return 0;
 	}
@@ -5366,70 +5341,22 @@ fail:
 	return ret;
 }

-#define RCU_MIGRATION_IDLE	0
-#define RCU_MIGRATION_NEED_QS	1
-#define RCU_MIGRATION_GOT_QS	2
-#define RCU_MIGRATION_MUST_SYNC	3
-
 /*
- * migration_thread - this is a highprio system thread that performs
- * thread migration by bumping thread off CPU then 'pushing' onto
- * another runqueue.
+ * migration_cpu_stop - this will be executed by a highprio stopper thread
+ * and performs thread migration by bumping thread off CPU then
+ * 'pushing' onto another runqueue.
  */
-static int migration_thread(void *data)
+static int migration_cpu_stop(void *data)
 {
-	int badcpu;
-	int cpu = (long)data;
-	struct rq *rq;
-
-	rq = cpu_rq(cpu);
-	BUG_ON(rq->migration_thread != current);
-
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		struct migration_req *req;
-		struct list_head *head;
-
-		raw_spin_lock_irq(&rq->lock);
-
-		if (cpu_is_offline(cpu)) {
-			raw_spin_unlock_irq(&rq->lock);
-			break;
-		}
-
-		if (rq->active_balance) {
-			active_load_balance(rq, cpu);
-			rq->active_balance = 0;
-		}
-
-		head = &rq->migration_queue;
-
-		if (list_empty(head)) {
-			raw_spin_unlock_irq(&rq->lock);
-			schedule();
-			set_current_state(TASK_INTERRUPTIBLE);
-			continue;
-		}
-		req = list_entry(head->next, struct migration_req, list);
-		list_del_init(head->next);
-
-		if (req->task != NULL) {
-			raw_spin_unlock(&rq->lock);
-			__migrate_task(req->task, cpu, req->dest_cpu);
-		} else if (likely(cpu == (badcpu = smp_processor_id()))) {
-			req->dest_cpu = RCU_MIGRATION_GOT_QS;
-			raw_spin_unlock(&rq->lock);
-		} else {
-			req->dest_cpu = RCU_MIGRATION_MUST_SYNC;
-			raw_spin_unlock(&rq->lock);
-			WARN_ONCE(1, "migration_thread() on CPU %d, expected %d\n", badcpu, cpu);
-		}
-		local_irq_enable();
-
-		complete(&req->done);
-	}
-	__set_current_state(TASK_RUNNING);
+	struct migration_arg *arg = data;

+	/*
+	 * The original target cpu might have gone down and we might
+	 * be on another cpu but it doesn't matter.
+	 */
+	local_irq_disable();
+	__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu);
+	local_irq_enable();
 	return 0;
 }

@@ -5796,35 +5723,20 @@ static void set_rq_offline(struct rq *rq
 static int __cpuinit
 migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
-	struct task_struct *p;
 	int cpu = (long)hcpu;
 	unsigned long flags;
-	struct rq *rq;
+	struct rq *rq = cpu_rq(cpu);

 	switch (action) {

 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
-		if (IS_ERR(p))
-			return NOTIFY_BAD;
-		kthread_bind(p, cpu);
-		/* Must be high prio: stop_machine expects to yield to it. */
-		rq = task_rq_lock(p, &flags);
-		__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
-		task_rq_unlock(rq, &flags);
-		get_task_struct(p);
-		cpu_rq(cpu)->migration_thread = p;
 		rq->calc_load_update = calc_load_update;
 		break;

 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		/* Strictly unnecessary, as first user will wake it. */
-		wake_up_process(cpu_rq(cpu)->migration_thread);
-
 		/* Update our root-domain */
-		rq = cpu_rq(cpu);
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
@@ -5835,25 +5747,9 @@ migration_call(struct notifier_block *nf
 		break;

 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		if (!cpu_rq(cpu)->migration_thread)
-			break;
-		/* Unbind it from offline cpu so it can run. Fall thru. */
-		kthread_bind(cpu_rq(cpu)->migration_thread,
-			     cpumask_any(cpu_online_mask));
-		kthread_stop(cpu_rq(cpu)->migration_thread);
-		put_task_struct(cpu_rq(cpu)->migration_thread);
-		cpu_rq(cpu)->migration_thread = NULL;
-		break;
-
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		migrate_live_tasks(cpu);
-		rq = cpu_rq(cpu);
-		kthread_stop(rq->migration_thread);
-		put_task_struct(rq->migration_thread);
-		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
 		raw_spin_lock_irq(&rq->lock);
 		deactivate_task(rq, rq->idle, 0);
@@ -5864,29 +5760,11 @@ migration_call(struct notifier_block *nf
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 		calc_global_load_remove(rq);
-		/*
-		 * No need to migrate the tasks: it was best-effort if
-		 * they didn't take sched_hotcpu_mutex. Just wake up
-		 * the requestors.
-		 */
-		raw_spin_lock_irq(&rq->lock);
-		while (!list_empty(&rq->migration_queue)) {
-			struct migration_req *req;
-
-			req = list_entry(rq->migration_queue.next,
-					 struct migration_req, list);
-			list_del_init(&req->list);
-			raw_spin_unlock_irq(&rq->lock);
-			complete(&req->done);
-			raw_spin_lock_irq(&rq->lock);
-		}
-		raw_spin_unlock_irq(&rq->lock);
 		break;

 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
 		/* Update our root-domain */
-		rq = cpu_rq(cpu);
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
@@ -7700,10 +7578,8 @@ void __init sched_init(void)
 		rq->push_cpu = 0;
 		rq->cpu = i;
 		rq->online = 0;
-		rq->migration_thread = NULL;
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
-		INIT_LIST_HEAD(&rq->migration_queue);
 		rq_attach_root(rq, &def_root_domain);
 #endif
 		init_rq_hrtick(rq);
@@ -8997,43 +8873,39 @@ struct cgroup_subsys cpuacct_subsys = {

 #ifndef CONFIG_SMP

-int rcu_expedited_torture_stats(char *page)
-{
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rcu_expedited_torture_stats);
-
 void synchronize_sched_expedited(void)
 {
+	/*
+	 * There must be a full memory barrier on each affected CPU
+	 * between the time that try_stop_cpus() is called and the
+	 * time that it returns.
+	 *
+	 * In the current initial implementation of cpu_stop, the
+	 * above condition is already met when the control reaches
+	 * this point and the following smp_mb() is not strictly
+	 * necessary.  Do smp_mb() anyway for documentation and
+	 * robustness against future implementation changes.
+	 */
+	smp_mb();
 }
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);

 #else /* #ifndef CONFIG_SMP */

-static DEFINE_PER_CPU(struct migration_req, rcu_migration_req);
-static DEFINE_MUTEX(rcu_sched_expedited_mutex);
-
-#define RCU_EXPEDITED_STATE_POST -2
-#define RCU_EXPEDITED_STATE_IDLE -1
-
-static int rcu_expedited_state = RCU_EXPEDITED_STATE_IDLE;
+static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);

-int rcu_expedited_torture_stats(char *page)
+static int synchronize_sched_expedited_cpu_stop(void *data)
 {
-	int cnt = 0;
-	int cpu;
+	static DEFINE_SPINLOCK(done_mask_lock);
+	struct cpumask *done_mask = data;

-	cnt += sprintf(&page[cnt], "state: %d /", rcu_expedited_state);
-	for_each_online_cpu(cpu) {
-		 cnt += sprintf(&page[cnt], " %d:%d",
-				cpu, per_cpu(rcu_migration_req, cpu).dest_cpu);
+	if (done_mask) {
+		spin_lock(&done_mask_lock);
+		cpumask_set_cpu(smp_processor_id(), done_mask);
+		spin_unlock(&done_mask_lock);
 	}
-	cnt += sprintf(&page[cnt], "\n");
-	return cnt;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(rcu_expedited_torture_stats);
-
-static long synchronize_sched_expedited_count;

 /*
  * Wait for an rcu-sched grace period to elapse, but use "big hammer"
@@ -9047,60 +8919,55 @@ static long synchronize_sched_expedited_
  */
 void synchronize_sched_expedited(void)
 {
-	int cpu;
-	unsigned long flags;
-	bool need_full_sync = 0;
-	struct rq *rq;
-	struct migration_req *req;
-	long snap;
-	int trycount = 0;
+	cpumask_var_t done_mask_var;
+	struct cpumask *done_mask = NULL;
+	int snap, trycount = 0;
+
+	/*
+	 * done_mask is used to check that all cpus actually have
+	 * finished running the stopper, which is guaranteed by
+	 * stop_cpus() if it's called with cpu hotplug blocked.  Keep
+	 * the paranoia for now but it's best effort if cpumask is off
+	 * stack.
+	 */
+	if (zalloc_cpumask_var(&done_mask_var, GFP_ATOMIC))
+		done_mask = done_mask_var;

 	smp_mb();  /* ensure prior mod happens before capturing snap. */
-	snap = ACCESS_ONCE(synchronize_sched_expedited_count) + 1;
+	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
 	get_online_cpus();
-	while (!mutex_trylock(&rcu_sched_expedited_mutex)) {
+	while (try_stop_cpus(cpu_online_mask,
+			     synchronize_sched_expedited_cpu_stop,
+			     done_mask) == -EAGAIN) {
 		put_online_cpus();
 		if (trycount++ < 10)
 			udelay(trycount * num_online_cpus());
 		else {
 			synchronize_sched();
-			return;
+			goto free_out;
 		}
-		if (ACCESS_ONCE(synchronize_sched_expedited_count) - snap > 0) {
+		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
 			smp_mb(); /* ensure test happens before caller kfree */
-			return;
+			goto free_out;
 		}
 		get_online_cpus();
 	}
-	rcu_expedited_state = RCU_EXPEDITED_STATE_POST;
-	for_each_online_cpu(cpu) {
-		rq = cpu_rq(cpu);
-		req = &per_cpu(rcu_migration_req, cpu);
-		init_completion(&req->done);
-		req->task = NULL;
-		req->dest_cpu = RCU_MIGRATION_NEED_QS;
-		raw_spin_lock_irqsave(&rq->lock, flags);
-		list_add(&req->list, &rq->migration_queue);
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
-		wake_up_process(rq->migration_thread);
-	}
-	for_each_online_cpu(cpu) {
-		rcu_expedited_state = cpu;
-		req = &per_cpu(rcu_migration_req, cpu);
-		rq = cpu_rq(cpu);
-		wait_for_completion(&req->done);
-		raw_spin_lock_irqsave(&rq->lock, flags);
-		if (unlikely(req->dest_cpu == RCU_MIGRATION_MUST_SYNC))
-			need_full_sync = 1;
-		req->dest_cpu = RCU_MIGRATION_IDLE;
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
-	}
-	rcu_expedited_state = RCU_EXPEDITED_STATE_IDLE;
-	synchronize_sched_expedited_count++;
-	mutex_unlock(&rcu_sched_expedited_mutex);
+	atomic_inc(&synchronize_sched_expedited_count);
+	if (done_mask)
+		cpumask_xor(done_mask, done_mask, cpu_online_mask);
 	put_online_cpus();
-	if (need_full_sync)
+
+	/* paranoia - this can't happen */
+	if (done_mask && cpumask_weight(done_mask)) {
+		char buf[80];
+
+		cpulist_scnprintf(buf, sizeof(buf), done_mask);
+		WARN_ONCE(1, "synchronize_sched_expedited: cpu online and done masks disagree on %d cpus: %s\n",
+			  cpumask_weight(done_mask), buf);
 		synchronize_sched();
+	}
+free_out:
+	free_cpumask_var(done_mask_var);
 }
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);

Index: work/include/linux/rcutree.h
===================================================================
--- work.orig/include/linux/rcutree.h
+++ work/include/linux/rcutree.h
@@ -35,7 +35,6 @@ struct notifier_block;
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern int rcu_needs_cpu(int cpu);
-extern int rcu_expedited_torture_stats(char *page);

 #ifdef CONFIG_TREE_PREEMPT_RCU

Index: work/kernel/rcutorture.c
===================================================================
--- work.orig/kernel/rcutorture.c
+++ work/kernel/rcutorture.c
@@ -669,7 +669,7 @@ static struct rcu_torture_ops sched_expe
 	.sync		= synchronize_sched_expedited,
 	.cb_barrier	= NULL,
 	.fqs		= rcu_sched_force_quiescent_state,
-	.stats		= rcu_expedited_torture_stats,
+	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "sched_expedited"
 };
Index: work/Documentation/RCU/torture.txt
===================================================================
--- work.orig/Documentation/RCU/torture.txt
+++ work/Documentation/RCU/torture.txt
@@ -182,16 +182,6 @@ Similarly, sched_expedited RCU provides
 	sched_expedited-torture: Reader Pipe:  12660320201 95875 0 0 0 0 0 0 0 0 0
 	sched_expedited-torture: Reader Batch:  12660424885 0 0 0 0 0 0 0 0 0 0
 	sched_expedited-torture: Free-Block Circulation:  1090795 1090795 1090794 1090793 1090792 1090791 1090790 1090789 1090788 1090787 0
-	state: -1 / 0:0 3:0 4:0
-
-As before, the first four lines are similar to those for RCU.
-The last line shows the task-migration state.  The first number is
--1 if synchronize_sched_expedited() is idle, -2 if in the process of
-posting wakeups to the migration kthreads, and N when waiting on CPU N.
-Each of the colon-separated fields following the "/" is a CPU:state pair.
-Valid states are "0" for idle, "1" for waiting for quiescent state,
-"2" for passed through quiescent state, and "3" when a race with a
-CPU-hotplug event forces use of the synchronize_sched() primitive.


 USAGE
Index: work/kernel/sched_fair.c
===================================================================
--- work.orig/kernel/sched_fair.c
+++ work/kernel/sched_fair.c
@@ -2802,6 +2802,8 @@ static int need_active_balance(struct sc
 	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
 }

+static int active_load_balance_cpu_stop(void *data);
+
 /*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
@@ -2891,8 +2893,9 @@ redo:
 		if (need_active_balance(sd, sd_idle, idle)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);

-			/* don't kick the migration_thread, if the curr
-			 * task on busiest cpu can't be moved to this_cpu
+			/* don't kick the active_load_balance_cpu_stop,
+			 * if the curr task on busiest cpu can't be
+			 * moved to this_cpu
 			 */
 			if (!cpumask_test_cpu(this_cpu,
 					      &busiest->curr->cpus_allowed)) {
@@ -2902,14 +2905,22 @@ redo:
 				goto out_one_pinned;
 			}

+			/*
+			 * ->active_balance synchronizes accesses to
+			 * ->active_balance_work.  Once set, it's cleared
+			 * only after active load balance is finished.
+			 */
 			if (!busiest->active_balance) {
 				busiest->active_balance = 1;
 				busiest->push_cpu = this_cpu;
 				active_balance = 1;
 			}
 			raw_spin_unlock_irqrestore(&busiest->lock, flags);
+
 			if (active_balance)
-				wake_up_process(busiest->migration_thread);
+				stop_one_cpu_nowait(cpu_of(busiest),
+					active_load_balance_cpu_stop, busiest,
+					&busiest->active_balance_work);

 			/*
 			 * We've kicked active balancing, reset the failure
@@ -3016,24 +3027,29 @@ static void idle_balance(int this_cpu, s
 }

 /*
- * active_load_balance is run by migration threads. It pushes running tasks
- * off the busiest CPU onto idle CPUs. It requires at least 1 task to be
- * running on each physical CPU where possible, and avoids physical /
- * logical imbalances.
- *
- * Called with busiest_rq locked.
+ * active_load_balance_cpu_stop is run by cpu stopper. It pushes
+ * running tasks off the busiest CPU onto idle CPUs. It requires at
+ * least 1 task to be running on each physical CPU where possible, and
+ * avoids physical / logical imbalances.
  */
-static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
+static int active_load_balance_cpu_stop(void *data)
 {
+	struct rq *busiest_rq = data;
+	int busiest_cpu = cpu_of(busiest_rq);
 	int target_cpu = busiest_rq->push_cpu;
+	struct rq *target_rq = cpu_rq(target_cpu);
 	struct sched_domain *sd;
-	struct rq *target_rq;
+
+	raw_spin_lock_irq(&busiest_rq->lock);
+
+	/* make sure the requested cpu hasn't gone down in the meantime */
+	if (unlikely(busiest_cpu != smp_processor_id() ||
+		     !busiest_rq->active_balance))
+		goto out_unlock;

 	/* Is there any task to move? */
 	if (busiest_rq->nr_running <= 1)
-		return;
-
-	target_rq = cpu_rq(target_cpu);
+		goto out_unlock;

 	/*
 	 * This condition is "impossible", if it occurs
@@ -3062,6 +3078,10 @@ static void active_load_balance(struct r
 			schedstat_inc(sd, alb_failed);
 	}
 	double_unlock_balance(busiest_rq, target_rq);
+out_unlock:
+	busiest_rq->active_balance = 0;
+	raw_spin_unlock_irq(&busiest_rq->lock);
+	return 0;
 }

 #ifdef CONFIG_NO_HZ
Index: work/include/linux/rcutiny.h
===================================================================
--- work.orig/include/linux/rcutiny.h
+++ work/include/linux/rcutiny.h
@@ -60,8 +60,6 @@ static inline long rcu_batches_completed
 	return 0;
 }

-extern int rcu_expedited_torture_stats(char *page);
-
 static inline void rcu_force_quiescent_state(void)
 {
 }
Index: work/kernel/stop_machine.c
===================================================================
--- work.orig/kernel/stop_machine.c
+++ work/kernel/stop_machine.c
@@ -301,7 +301,7 @@ static int __cpuinit cpu_stop_cpu_callba
 	case CPU_UP_PREPARE:
 		BUG_ON(stopper->thread || stopper->enabled ||
 		       !list_empty(&stopper->works));
-		p = kthread_create(cpu_stopper_thread, stopper, "stopper/%d",
+		p = kthread_create(cpu_stopper_thread, stopper, "migration/%d",
 				   cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
