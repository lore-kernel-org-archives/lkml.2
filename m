Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0CQImW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:42:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:59033 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab0CQImR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:42:17 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       dipankar@in.ibm.com, josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       oleg@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
       arjan@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] scheduler: replace migration_thread with cpuhog
Date: Wed, 17 Mar 2010 17:40:50 +0900
Message-Id: <1268815251-31407-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1268815251-31407-1-git-send-email-tj@kernel.org>
References: <1268815251-31407-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 08:41:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently migration_thread is serving three purposes - migration
pusher, context to execute active_load_balance() and forced context
switcher for expedited RCU synchronize_sched.  All three roles are
hardcoded into migration_thread() and determining which job is
scheduled is slightly messy.

This patch kills migration_thread and replaces all three uses with
cpuhog.  The three different roles of migration_thread() are splitted
into three separate cpuhog callbacks - migration_hog(),
active_load_balance_hog() and synchronize_sched_expedited_hog() - and
each use case now simply asks cpuhog to execute the callback as
necessary.

synchronize_sched_expedited() was implemented with private
preallocated resources and custom multi-cpu queueing and waiting
logic, both of which are provided by cpuhog.
synchronize_sched_expedited_count is made atomic and all other shared
resources along with the mutex are dropped.

synchronize_sched_expedited() also implemented a check to detect cases
where not all the callback got executed on their assigned cpus and
fall back to synchronize_sched().  If called with cpu hotplug blocked,
cpuhog already guarantees that and the condition cannot happen;
otherwise, stop_machine() would break.  However, this patch preserves
the paranoid check using a cpumask to record on which cpus the hog ran
so that it can serve as a bisection point if something actually goes
wrong theree.

Because the internal execution state is no longer visible,
rcu_expedited_torture_stats() is removed.

This patch also renames cpuhog threads to from "hog/%d" to
"migration/%d".  The names of these threads ultimately don't matter
and there's no reason to make unnecessary userland visible changes.

With this patch applied, stop_machine() and sched now share the same
resources.  stop_machine() is faster without wasting any resources and
sched migration users are much cleaner.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Josh Triplett <josh@freedesktop.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
---
 Documentation/RCU/torture.txt |   10 --
 include/linux/rcutiny.h       |    2 -
 include/linux/rcutree.h       |    1 -
 kernel/cpuhog.c               |    2 +-
 kernel/rcutorture.c           |    2 +-
 kernel/sched.c                |  313 +++++++++++------------------------------
 kernel/sched_fair.c           |   39 ++++--
 7 files changed, 109 insertions(+), 260 deletions(-)

diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 0e50bc2..5d90167 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -182,16 +182,6 @@ Similarly, sched_expedited RCU provides the following:
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
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index a519587..0006b2d 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -60,8 +60,6 @@ static inline long rcu_batches_completed_bh(void)
 	return 0;
 }
 
-extern int rcu_expedited_torture_stats(char *page);
-
 static inline void rcu_force_quiescent_state(void)
 {
 }
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 42cc3a0..24e467e 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -35,7 +35,6 @@ struct notifier_block;
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern int rcu_needs_cpu(int cpu);
-extern int rcu_expedited_torture_stats(char *page);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
diff --git a/kernel/cpuhog.c b/kernel/cpuhog.c
index 877a5ed..6866cb2 100644
--- a/kernel/cpuhog.c
+++ b/kernel/cpuhog.c
@@ -295,7 +295,7 @@ static int __cpuinit cpuhog_cpu_callback(struct notifier_block *nfb,
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
 		BUG_ON(hog->thread || hog->enabled || !list_empty(&hog->works));
-		p = kthread_create(cpuhog_thread, hog, "hog/%d", cpu);
+		p = kthread_create(cpuhog_thread, hog, "migration/%d", cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
 		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 258cdf0..9607e29 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -669,7 +669,7 @@ static struct rcu_torture_ops sched_expedited_ops = {
 	.sync		= synchronize_sched_expedited,
 	.cb_barrier	= NULL,
 	.fqs		= rcu_sched_force_quiescent_state,
-	.stats		= rcu_expedited_torture_stats,
+	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "sched_expedited"
 };
diff --git a/kernel/sched.c b/kernel/sched.c
index cc6dc8c..926b8bd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -53,9 +53,9 @@
 #include <linux/timer.h>
 #include <linux/rcupdate.h>
 #include <linux/cpu.h>
+#include <linux/cpuhog.h>
 #include <linux/cpuset.h>
 #include <linux/percpu.h>
-#include <linux/kthread.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/sysctl.h>
@@ -538,15 +538,13 @@ struct rq {
 	int post_schedule;
 	int active_balance;
 	int push_cpu;
+	struct cpuhog_work active_balance_work;
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
@@ -2051,21 +2049,18 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
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
 
+static int migration_hog(void *data);
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
 
@@ -2073,15 +2068,7 @@ migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
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
@@ -3073,7 +3060,6 @@ static void update_cpu_load(struct rq *this_rq)
 void sched_exec(void)
 {
 	struct task_struct *p = current;
-	struct migration_req req;
 	int dest_cpu, this_cpu;
 	unsigned long flags;
 	struct rq *rq;
@@ -3099,16 +3085,11 @@ again:
 	}
 
 	/* force the process onto the specified CPU */
-	if (migrate_task(p, dest_cpu, &req)) {
-		/* Need to wait for migration thread (might exit: take ref). */
-		struct task_struct *mt = rq->migration_thread;
+	if (migrate_task(p, dest_cpu)) {
+		struct migration_arg arg = { p, dest_cpu };
 
-		get_task_struct(mt);
 		task_rq_unlock(rq, &flags);
-		wake_up_process(mt);
-		put_task_struct(mt);
-		wait_for_completion(&req.done);
-
+		hog_one_cpu(this_cpu, migration_hog, &arg);
 		return;
 	}
 	task_rq_unlock(rq, &flags);
@@ -5259,17 +5240,12 @@ static inline void sched_init_granularity(void)
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
+ * 1) we invoke migration_hog() on the target CPU using hog_one_cpu().
+ * 2) hog starts to run (implicitly forcing the migrated thread off the CPU)
+ * 3) it checks whether the migrated task is still in the wrong runqueue.
+ * 4) if it's in the wrong runqueue then the migration thread removes
  *    it and puts it into the right queue.
- * 6) migration thread up()s the semaphore.
- * 7) we wake up and the migration is done.
+ * 5) hog completes and hog_one_cpu() returns and the migration is done.
  */
 
 /*
@@ -5283,9 +5259,9 @@ static inline void sched_init_granularity(void)
  */
 int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 {
-	struct migration_req req;
 	unsigned long flags;
 	struct rq *rq;
+	unsigned int dest_cpu;
 	int ret = 0;
 
 	rq = task_rq_lock(p, &flags);
@@ -5312,15 +5288,12 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
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
-		wake_up_process(rq->migration_thread);
-		put_task_struct(mt);
-		wait_for_completion(&req.done);
+		hog_one_cpu(cpu_of(rq), migration_hog, &arg);
 		tlb_migrate_finish(p->mm);
 		return 0;
 	}
@@ -5378,75 +5351,6 @@ fail:
 	return ret;
 }
 
-#define RCU_MIGRATION_IDLE	0
-#define RCU_MIGRATION_NEED_QS	1
-#define RCU_MIGRATION_GOT_QS	2
-#define RCU_MIGRATION_MUST_SYNC	3
-
-/*
- * migration_thread - this is a highprio system thread that performs
- * thread migration by bumping thread off CPU then 'pushing' onto
- * another runqueue.
- */
-static int migration_thread(void *data)
-{
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
-
-	return 0;
-}
-
-#ifdef CONFIG_HOTPLUG_CPU
-
 static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
 {
 	int ret;
@@ -5458,6 +5362,25 @@ static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
 }
 
 /*
+ * migration_hog - this will be executed by a highprio cpuhog thread
+ * and performs thread migration by bumping thread off CPU then
+ * 'pushing' onto another runqueue.
+ */
+static int migration_hog(void *data)
+{
+	struct migration_arg *arg = data;
+
+	/*
+	 * The original target cpu might have gone down and we might
+	 * be on another cpu but it doesn't matter.
+	 */
+	__migrate_task_irq(arg->task, raw_smp_processor_id(), arg->dest_cpu);
+	return 0;
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
  * Figure out where task on dead CPU should go, use force if necessary.
  */
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
@@ -5809,35 +5732,20 @@ static void set_rq_offline(struct rq *rq)
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
@@ -5848,26 +5756,10 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
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
 		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
-		rq = cpu_rq(cpu);
-		kthread_stop(rq->migration_thread);
-		put_task_struct(rq->migration_thread);
-		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
 		raw_spin_lock_irq(&rq->lock);
 		deactivate_task(rq, rq->idle, 0);
@@ -5879,29 +5771,11 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
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
@@ -7711,10 +7585,8 @@ void __init sched_init(void)
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
@@ -9008,12 +8880,6 @@ struct cgroup_subsys cpuacct_subsys = {
 
 #ifndef CONFIG_SMP
 
-int rcu_expedited_torture_stats(char *page)
-{
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rcu_expedited_torture_stats);
-
 void synchronize_sched_expedited(void)
 {
 }
@@ -9021,30 +8887,20 @@ EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
 
 #else /* #ifndef CONFIG_SMP */
 
-static DEFINE_PER_CPU(struct migration_req, rcu_migration_req);
-static DEFINE_MUTEX(rcu_sched_expedited_mutex);
+static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
 
-#define RCU_EXPEDITED_STATE_POST -2
-#define RCU_EXPEDITED_STATE_IDLE -1
-
-static int rcu_expedited_state = RCU_EXPEDITED_STATE_IDLE;
-
-int rcu_expedited_torture_stats(char *page)
+static int synchronize_sched_expedited_hog(void *data)
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
@@ -9058,60 +8914,53 @@ static long synchronize_sched_expedited_count;
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
+	 * finished running the hog, which is guaranteed by hog_cpus()
+	 * if it's called with cpu hotplug blocked.  Keep the paranoia
+	 * for now but it's best effort if cpumask is off stack.
+	 */
+	if (zalloc_cpumask_var(&done_mask_var, GFP_ATOMIC))
+		done_mask = done_mask_var;
 
 	smp_mb();  /* ensure prior mod happens before capturing snap. */
-	snap = ACCESS_ONCE(synchronize_sched_expedited_count) + 1;
+	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
 	get_online_cpus();
-	while (!mutex_trylock(&rcu_sched_expedited_mutex)) {
+	while (try_hog_cpus(cpu_online_mask, synchronize_sched_expedited_hog,
+			    done_mask) == -EAGAIN) {
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
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 35a5c64..4ea25b2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2807,6 +2807,8 @@ static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle)
 	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
 }
 
+static int active_load_balance_hog(void *data);
+
 /*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
@@ -2896,7 +2898,7 @@ redo:
 		if (need_active_balance(sd, sd_idle, idle)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);
 
-			/* don't kick the migration_thread, if the curr
+			/* don't kick the active_load_balance_hog, if the curr
 			 * task on busiest cpu can't be moved to this_cpu
 			 */
 			if (!cpumask_test_cpu(this_cpu,
@@ -2914,7 +2916,9 @@ redo:
 			}
 			raw_spin_unlock_irqrestore(&busiest->lock, flags);
 			if (active_balance)
-				wake_up_process(busiest->migration_thread);
+				hog_one_cpu_nowait(cpu_of(busiest),
+					active_load_balance_hog, busiest,
+					&busiest->active_balance_work);
 
 			/*
 			 * We've kicked active balancing, reset the failure
@@ -3021,24 +3025,29 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 }
 
 /*
- * active_load_balance is run by migration threads. It pushes running tasks
- * off the busiest CPU onto idle CPUs. It requires at least 1 task to be
- * running on each physical CPU where possible, and avoids physical /
- * logical imbalances.
- *
- * Called with busiest_rq locked.
+ * active_load_balance_hog is run by cpuhog. It pushes running tasks
+ * off the busiest CPU onto idle CPUs. It requires at least 1 task to
+ * be running on each physical CPU where possible, and avoids physical
+ * / logical imbalances.
  */
-static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
+static int active_load_balance_hog(void *data)
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
@@ -3067,6 +3076,10 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
 			schedstat_inc(sd, alb_failed);
 	}
 	double_unlock_balance(busiest_rq, target_rq);
+out_unlock:
+	busiest_rq->active_balance = 0;
+	raw_spin_unlock_irq(&busiest_rq->lock);
+	return 0;
 }
 
 #ifdef CONFIG_NO_HZ
-- 
1.6.4.2

