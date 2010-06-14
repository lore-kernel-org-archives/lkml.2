Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0FNVms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:42:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:46943 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711Ab0FNVjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:22 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/30] workqueue: kill cpu_populated_map
Date: Mon, 14 Jun 2010 23:37:26 +0200
Message-Id: <1276551467-21246-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Worker management is about to be overhauled.  Simplify things by
removing cpu_populated_map, creating workers for all possible cpus and
making single threaded workqueues behave more like multi threaded
ones.

After this patch, all cwqs are always initialized, all workqueues are
linked on the workqueues list and workers for all possibles cpus
always exist.  This also makes CPU hotplug support simpler - checking
->cpus_allowed before processing works in worker_thread() and flushing
cwqs on CPU_POST_DEAD are enough.

While at it, make get_cwq() always return the cwq for the specified
cpu, add target_cwq() for cases where single thread distinction is
necessary and drop all direct usage of per_cpu_ptr() on wq->cpu_wq.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |  173 ++++++++++++++++++----------------------------------
 1 files changed, 59 insertions(+), 114 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f7ab703..dc78956 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -55,6 +55,7 @@ struct cpu_workqueue_struct {
 	struct list_head worklist;
 	wait_queue_head_t more_work;
 	struct work_struct *current_work;
+	unsigned int		cpu;
 
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	struct task_struct	*thread;
@@ -189,34 +190,19 @@ static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
-static const struct cpumask *cpu_singlethread_map __read_mostly;
-/*
- * _cpu_down() first removes CPU from cpu_online_map, then CPU_DEAD
- * flushes cwq->worklist. This means that flush_workqueue/wait_on_work
- * which comes in between can't use for_each_online_cpu(). We could
- * use cpu_possible_map, the cpumask below is more a documentation
- * than optimization.
- */
-static cpumask_var_t cpu_populated_map __read_mostly;
-
-/* If it's single threaded, it isn't in the list of workqueues. */
-static inline bool is_wq_single_threaded(struct workqueue_struct *wq)
-{
-	return wq->flags & WQ_SINGLE_THREAD;
-}
 
-static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
+static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
+					    struct workqueue_struct *wq)
 {
-	return is_wq_single_threaded(wq)
-		? cpu_singlethread_map : cpu_populated_map;
+	return per_cpu_ptr(wq->cpu_wq, cpu);
 }
 
-static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
-					    struct workqueue_struct *wq)
+static struct cpu_workqueue_struct *target_cwq(unsigned int cpu,
+					       struct workqueue_struct *wq)
 {
-	if (unlikely(is_wq_single_threaded(wq)))
+	if (unlikely(wq->flags & WQ_SINGLE_THREAD))
 		cpu = singlethread_cpu;
-	return per_cpu_ptr(wq->cpu_wq, cpu);
+	return get_cwq(cpu, wq);
 }
 
 /*
@@ -279,7 +265,7 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
-	struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+	struct cpu_workqueue_struct *cwq = target_cwq(cpu, wq);
 	unsigned long flags;
 
 	debug_work_activate(work);
@@ -383,7 +369,7 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 		timer_stats_timer_set_start_info(&dwork->timer);
 
 		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work, get_cwq(raw_smp_processor_id(), wq), 0);
+		set_wq_data(work, target_cwq(raw_smp_processor_id(), wq), 0);
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -495,6 +481,10 @@ static int worker_thread(void *__cwq)
 		if (kthread_should_stop())
 			break;
 
+		if (unlikely(!cpumask_equal(&cwq->thread->cpus_allowed,
+					    get_cpu_mask(cwq->cpu))))
+			set_cpus_allowed_ptr(cwq->thread,
+					     get_cpu_mask(cwq->cpu));
 		run_workqueue(cwq);
 	}
 
@@ -574,14 +564,13 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
  */
 void flush_workqueue(struct workqueue_struct *wq)
 {
-	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
 	might_sleep();
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
-	for_each_cpu(cpu, cpu_map)
-		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
+	for_each_possible_cpu(cpu)
+		flush_cpu_workqueue(get_cwq(cpu, wq));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -699,7 +688,6 @@ static void wait_on_work(struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
-	const struct cpumask *cpu_map;
 	int cpu;
 
 	might_sleep();
@@ -712,9 +700,8 @@ static void wait_on_work(struct work_struct *work)
 		return;
 
 	wq = cwq->wq;
-	cpu_map = wq_cpu_map(wq);
 
-	for_each_cpu(cpu, cpu_map)
+	for_each_possible_cpu(cpu)
 		wait_on_cpu_work(get_cwq(cpu, wq), work);
 }
 
@@ -972,7 +959,7 @@ int current_is_keventd(void)
 
 	BUG_ON(!keventd_wq);
 
-	cwq = per_cpu_ptr(keventd_wq->cpu_wq, cpu);
+	cwq = get_cwq(cpu, keventd_wq);
 	if (current == cwq->thread)
 		ret = 1;
 
@@ -980,26 +967,12 @@ int current_is_keventd(void)
 
 }
 
-static struct cpu_workqueue_struct *
-init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
-{
-	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-
-	cwq->wq = wq;
-	spin_lock_init(&cwq->lock);
-	INIT_LIST_HEAD(&cwq->worklist);
-	init_waitqueue_head(&cwq->more_work);
-
-	return cwq;
-}
-
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
 	struct workqueue_struct *wq = cwq->wq;
-	const char *fmt = is_wq_single_threaded(wq) ? "%s" : "%s/%d";
 	struct task_struct *p;
 
-	p = kthread_create(worker_thread, cwq, fmt, wq->name, cpu);
+	p = kthread_create(worker_thread, cwq, "%s/%d", wq->name, cpu);
 	/*
 	 * Nobody can add the work_struct to this cwq,
 	 *	if (caller is __create_workqueue)
@@ -1031,8 +1004,8 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 						struct lock_class_key *key,
 						const char *lock_name)
 {
+	bool singlethread = flags & WQ_SINGLE_THREAD;
 	struct workqueue_struct *wq;
-	struct cpu_workqueue_struct *cwq;
 	int err = 0, cpu;
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
@@ -1048,37 +1021,37 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
 
-	if (flags & WQ_SINGLE_THREAD) {
-		cwq = init_cpu_workqueue(wq, singlethread_cpu);
-		err = create_workqueue_thread(cwq, singlethread_cpu);
-		start_workqueue_thread(cwq, -1);
-	} else {
-		cpu_maps_update_begin();
-		/*
-		 * We must place this wq on list even if the code below fails.
-		 * cpu_down(cpu) can remove cpu from cpu_populated_map before
-		 * destroy_workqueue() takes the lock, in that case we leak
-		 * cwq[cpu]->thread.
-		 */
-		spin_lock(&workqueue_lock);
-		list_add(&wq->list, &workqueues);
-		spin_unlock(&workqueue_lock);
-		/*
-		 * We must initialize cwqs for each possible cpu even if we
-		 * are going to call destroy_workqueue() finally. Otherwise
-		 * cpu_up() can hit the uninitialized cwq once we drop the
-		 * lock.
-		 */
-		for_each_possible_cpu(cpu) {
-			cwq = init_cpu_workqueue(wq, cpu);
-			if (err || !cpu_online(cpu))
-				continue;
-			err = create_workqueue_thread(cwq, cpu);
+	cpu_maps_update_begin();
+	/*
+	 * We must initialize cwqs for each possible cpu even if we
+	 * are going to call destroy_workqueue() finally. Otherwise
+	 * cpu_up() can hit the uninitialized cwq once we drop the
+	 * lock.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+
+		cwq->wq = wq;
+		cwq->cpu = cpu;
+		spin_lock_init(&cwq->lock);
+		INIT_LIST_HEAD(&cwq->worklist);
+		init_waitqueue_head(&cwq->more_work);
+
+		if (err)
+			continue;
+		err = create_workqueue_thread(cwq, cpu);
+		if (cpu_online(cpu) && !singlethread)
 			start_workqueue_thread(cwq, cpu);
-		}
-		cpu_maps_update_done();
+		else
+			start_workqueue_thread(cwq, -1);
 	}
 
+	spin_lock(&workqueue_lock);
+	list_add(&wq->list, &workqueues);
+	spin_unlock(&workqueue_lock);
+
+	cpu_maps_update_done();
+
 	if (err) {
 		destroy_workqueue(wq);
 		wq = NULL;
@@ -1128,17 +1101,16 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
 	cpu_maps_update_begin();
 	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
+	cpu_maps_update_done();
 
-	for_each_cpu(cpu, cpu_map)
-		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
- 	cpu_maps_update_done();
+	for_each_possible_cpu(cpu)
+		cleanup_workqueue_thread(get_cwq(cpu, wq));
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);
@@ -1152,48 +1124,25 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
-	int err = 0;
 
 	action &= ~CPU_TASKS_FROZEN;
 
-	switch (action) {
-	case CPU_UP_PREPARE:
-		cpumask_set_cpu(cpu, cpu_populated_map);
-	}
-undo:
 	list_for_each_entry(wq, &workqueues, list) {
-		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+		if (wq->flags & WQ_SINGLE_THREAD)
+			continue;
 
-		switch (action) {
-		case CPU_UP_PREPARE:
-			err = create_workqueue_thread(cwq, cpu);
-			if (!err)
-				break;
-			printk(KERN_ERR "workqueue [%s] for %i failed\n",
-				wq->name, cpu);
-			action = CPU_UP_CANCELED;
-			err = -ENOMEM;
-			goto undo;
-
-		case CPU_ONLINE:
-			start_workqueue_thread(cwq, cpu);
-			break;
+		cwq = get_cwq(cpu, wq);
 
-		case CPU_UP_CANCELED:
-			start_workqueue_thread(cwq, -1);
+		switch (action) {
 		case CPU_POST_DEAD:
-			cleanup_workqueue_thread(cwq);
+			lock_map_acquire(&cwq->wq->lockdep_map);
+			lock_map_release(&cwq->wq->lockdep_map);
+			flush_cpu_workqueue(cwq);
 			break;
 		}
 	}
 
-	switch (action) {
-	case CPU_UP_CANCELED:
-	case CPU_POST_DEAD:
-		cpumask_clear_cpu(cpu, cpu_populated_map);
-	}
-
-	return notifier_from_errno(err);
+	return notifier_from_errno(0);
 }
 
 #ifdef CONFIG_SMP
@@ -1245,11 +1194,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
 
 void __init init_workqueues(void)
 {
-	alloc_cpumask_var(&cpu_populated_map, GFP_KERNEL);
-
-	cpumask_copy(cpu_populated_map, cpu_online_mask);
 	singlethread_cpu = cpumask_first(cpu_possible_mask);
-	cpu_singlethread_map = cpumask_of(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
-- 
1.6.4.2

