Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2GPKnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 06:43:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:52612 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2GPKmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:42:45 -0400
Message-Id: <20120716103948.775527032@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 16 Jul 2012 10:42:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [Patch 7/7] infiniband: ehca: Use hotplug thread infrastructure
References: <20120716103749.122800930@linutronix.de>
Content-Disposition: inline; filename=infiniband-ehca-use-smp-threads.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the hotplug notifiers and use the generic hotplug thread
infrastructure.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |  255 ++++++++++++----------------------
 drivers/infiniband/hw/ehca/ehca_irq.h |    6 
 2 files changed, 96 insertions(+), 165 deletions(-)

Index: tip/drivers/infiniband/hw/ehca/ehca_irq.c
===================================================================
--- tip.orig/drivers/infiniband/hw/ehca/ehca_irq.c
+++ tip/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -42,6 +42,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/smpboot.h>
 
 #include "ehca_classes.h"
 #include "ehca_irq.h"
@@ -652,7 +653,7 @@ void ehca_tasklet_eq(unsigned long data)
 	ehca_process_eq((struct ehca_shca*)data, 1);
 }
 
-static inline int find_next_online_cpu(struct ehca_comp_pool *pool)
+static int find_next_online_cpu(struct ehca_comp_pool *pool)
 {
 	int cpu;
 	unsigned long flags;
@@ -662,17 +663,23 @@ static inline int find_next_online_cpu(s
 		ehca_dmp(cpu_online_mask, cpumask_size(), "");
 
 	spin_lock_irqsave(&pool->last_cpu_lock, flags);
-	cpu = cpumask_next(pool->last_cpu, cpu_online_mask);
-	if (cpu >= nr_cpu_ids)
-		cpu = cpumask_first(cpu_online_mask);
-	pool->last_cpu = cpu;
+	while (1) {
+		cpu = cpumask_next(pool->last_cpu, cpu_online_mask);
+		if (cpu >= nr_cpu_ids)
+			cpu = cpumask_first(cpu_online_mask);
+		pool->last_cpu = cpu;
+		/* Might be on the way out */
+		if (per_cpu_ptr(pool->cpu_comp_tasks, cpu)->active)
+			break;
+	}
 	spin_unlock_irqrestore(&pool->last_cpu_lock, flags);
 
 	return cpu;
 }
 
 static void __queue_comp_task(struct ehca_cq *__cq,
-			      struct ehca_cpu_comp_task *cct)
+			      struct ehca_cpu_comp_task *cct,
+			      struct task_struct *thread)
 {
 	unsigned long flags;
 
@@ -683,7 +690,7 @@ static void __queue_comp_task(struct ehc
 		__cq->nr_callbacks++;
 		list_add_tail(&__cq->entry, &cct->cq_list);
 		cct->cq_jobs++;
-		wake_up(&cct->wait_queue);
+		wake_up_process(thread);
 	} else
 		__cq->nr_callbacks++;
 
@@ -695,6 +702,7 @@ static void queue_comp_task(struct ehca_
 {
 	int cpu_id;
 	struct ehca_cpu_comp_task *cct;
+	struct task_struct *thread;
 	int cq_jobs;
 	unsigned long flags;
 
@@ -702,7 +710,8 @@ static void queue_comp_task(struct ehca_
 	BUG_ON(!cpu_online(cpu_id));
 
 	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu_id);
-	BUG_ON(!cct);
+	thread = per_cpu_ptr(pool->cpu_comp_threads, cpu_id);
+	BUG_ON(!cct || !thread);
 
 	spin_lock_irqsave(&cct->task_lock, flags);
 	cq_jobs = cct->cq_jobs;
@@ -710,28 +719,25 @@ static void queue_comp_task(struct ehca_
 	if (cq_jobs > 0) {
 		cpu_id = find_next_online_cpu(pool);
 		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu_id);
-		BUG_ON(!cct);
+		thread = per_cpu_ptr(pool->cpu_comp_threads, cpu_id);
+		BUG_ON(!cct || !thread);
 	}
-
-	__queue_comp_task(__cq, cct);
+	__queue_comp_task(__cq, cct, thread);
 }
 
 static void run_comp_task(struct ehca_cpu_comp_task *cct)
 {
 	struct ehca_cq *cq;
-	unsigned long flags;
-
-	spin_lock_irqsave(&cct->task_lock, flags);
 
 	while (!list_empty(&cct->cq_list)) {
 		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
-		spin_unlock_irqrestore(&cct->task_lock, flags);
+		spin_unlock_irq(&cct->task_lock);
 
 		comp_event_callback(cq);
 		if (atomic_dec_and_test(&cq->nr_events))
 			wake_up(&cq->wait_completion);
 
-		spin_lock_irqsave(&cct->task_lock, flags);
+		spin_lock_irq(&cct->task_lock);
 		spin_lock(&cq->task_lock);
 		cq->nr_callbacks--;
 		if (!cq->nr_callbacks) {
@@ -740,159 +746,76 @@ static void run_comp_task(struct ehca_cp
 		}
 		spin_unlock(&cq->task_lock);
 	}
-
-	spin_unlock_irqrestore(&cct->task_lock, flags);
 }
 
-static int comp_task(void *__cct)
+static void comp_task_park(unsigned int cpu)
 {
-	struct ehca_cpu_comp_task *cct = __cct;
-	int cql_empty;
-	DECLARE_WAITQUEUE(wait, current);
-
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		add_wait_queue(&cct->wait_queue, &wait);
-
-		spin_lock_irq(&cct->task_lock);
-		cql_empty = list_empty(&cct->cq_list);
-		spin_unlock_irq(&cct->task_lock);
-		if (cql_empty)
-			schedule();
-		else
-			__set_current_state(TASK_RUNNING);
-
-		remove_wait_queue(&cct->wait_queue, &wait);
+	struct ehca_cpu_comp_task *cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+	struct ehca_cpu_comp_task *target;
+	struct task_struct *thread;
+	struct ehca_cq *cq, *tmp;
+	LIST_HEAD(list);
 
-		spin_lock_irq(&cct->task_lock);
-		cql_empty = list_empty(&cct->cq_list);
-		spin_unlock_irq(&cct->task_lock);
-		if (!cql_empty)
-			run_comp_task(__cct);
+	spin_lock_irq(&cct->task_lock);
+	cct->cq_jobs = 0;
+	cct->active = 0;
+	list_splice_init(&cct->cq_list, &list);
+	spin_unlock_irq(&cct->task_lock);
 
-		set_current_state(TASK_INTERRUPTIBLE);
+	cpu = find_next_online_cpu(pool);
+	target = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+	thread = per_cpu_ptr(pool->cpu_comp_threads, cpu);
+	spin_lock_irq(&target->task_lock);
+	list_for_each_entry_safe(cq, tmp, &list, entry) {
+		list_del(&cq->entry);
+		__queue_comp_task(cq, target, thread);
 	}
-	__set_current_state(TASK_RUNNING);
-
-	return 0;
-}
-
-static struct task_struct *create_comp_task(struct ehca_comp_pool *pool,
-					    int cpu)
-{
-	struct ehca_cpu_comp_task *cct;
-
-	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
-	spin_lock_init(&cct->task_lock);
-	INIT_LIST_HEAD(&cct->cq_list);
-	init_waitqueue_head(&cct->wait_queue);
-	cct->task = kthread_create_on_node(comp_task, cct, cpu_to_node(cpu),
-					   "ehca_comp/%d", cpu);
-
-	return cct->task;
+	spin_unlock_irq(&target->task_lock);
 }
 
-static void destroy_comp_task(struct ehca_comp_pool *pool,
-			      int cpu)
+static void comp_task_stop(unsigned int cpu, bool online)
 {
-	struct ehca_cpu_comp_task *cct;
-	struct task_struct *task;
-	unsigned long flags_cct;
-
-	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
-
-	spin_lock_irqsave(&cct->task_lock, flags_cct);
+	struct ehca_cpu_comp_task *cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
 
-	task = cct->task;
-	cct->task = NULL;
+	spin_lock_irq(&cct->task_lock);
 	cct->cq_jobs = 0;
-
-	spin_unlock_irqrestore(&cct->task_lock, flags_cct);
-
-	if (task)
-		kthread_stop(task);
+	cct->active = 0;
+	WARN_ON(!list_empty(&cct->cq_list));
+	spin_unlock_irq(&cct->task_lock);
 }
 
-static void __cpuinit take_over_work(struct ehca_comp_pool *pool, int cpu)
+static int comp_task_should_run(unsigned int cpu)
 {
 	struct ehca_cpu_comp_task *cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
-	LIST_HEAD(list);
-	struct ehca_cq *cq;
-	unsigned long flags_cct;
-
-	spin_lock_irqsave(&cct->task_lock, flags_cct);
-
-	list_splice_init(&cct->cq_list, &list);
-
-	while (!list_empty(&list)) {
-		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
-
-		list_del(&cq->entry);
-		__queue_comp_task(cq, this_cpu_ptr(pool->cpu_comp_tasks));
-	}
-
-	spin_unlock_irqrestore(&cct->task_lock, flags_cct);
 
+	return cct->cq_jobs;
 }
 
-static int __cpuinit comp_pool_callback(struct notifier_block *nfb,
-					unsigned long action,
-					void *hcpu)
+static int comp_task(unsigned int cpu)
 {
-	unsigned int cpu = (unsigned long)hcpu;
-	struct ehca_cpu_comp_task *cct;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		ehca_gen_dbg("CPU: %x (CPU_PREPARE)", cpu);
-		if (!create_comp_task(pool, cpu)) {
-			ehca_gen_err("Can't create comp_task for cpu: %x", cpu);
-			return notifier_from_errno(-ENOMEM);
-		}
-		break;
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		ehca_gen_dbg("CPU: %x (CPU_CANCELED)", cpu);
-		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
-		kthread_bind(cct->task, cpumask_any(cpu_online_mask));
-		destroy_comp_task(pool, cpu);
-		break;
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		ehca_gen_dbg("CPU: %x (CPU_ONLINE)", cpu);
-		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
-		kthread_bind(cct->task, cpu);
-		wake_up_process(cct->task);
-		break;
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		ehca_gen_dbg("CPU: %x (CPU_DOWN_PREPARE)", cpu);
-		break;
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-		ehca_gen_dbg("CPU: %x (CPU_DOWN_FAILED)", cpu);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		ehca_gen_dbg("CPU: %x (CPU_DEAD)", cpu);
-		destroy_comp_task(pool, cpu);
-		take_over_work(pool, cpu);
-		break;
-	}
+	struct ehca_cpu_comp_task *cct = this_cpu_ptr(pool->cpu_comp_tasks);
+	int cql_empty;
 
-	return NOTIFY_OK;
+	spin_lock_irq(&cct->task_lock);
+	cql_empty = list_empty(&cct->cq_list);
+	if (!cql_empty) {
+		__set_current_state(TASK_RUNNING);
+		run_comp_task(cct);
+	}
+	spin_unlock_irq(&cct->task_lock);
 }
 
-static struct notifier_block comp_pool_callback_nb __cpuinitdata = {
-	.notifier_call	= comp_pool_callback,
-	.priority	= 0,
+static struct smp_hotplug_thread comp_pool_threads = {
+	.thread_should_run	= comp_task_should_run,
+	.thread_fn		= comp_task,
+	.thread_comm		= "ehca_comp/%u",
+	.cleanup		= comp_task_stop,
+	.park			= comp_task_park,
 };
 
 int ehca_create_comp_pool(void)
 {
-	int cpu;
-	struct task_struct *task;
+	int cpu, ret = -ENOMEM;
 
 	if (!ehca_scaling_code)
 		return 0;
@@ -905,38 +828,46 @@ int ehca_create_comp_pool(void)
 	pool->last_cpu = cpumask_any(cpu_online_mask);
 
 	pool->cpu_comp_tasks = alloc_percpu(struct ehca_cpu_comp_task);
-	if (pool->cpu_comp_tasks == NULL) {
-		kfree(pool);
-		return -EINVAL;
-	}
+	if (!pool->cpu_comp_tasks)
+		goto out_pool;
 
-	for_each_online_cpu(cpu) {
-		task = create_comp_task(pool, cpu);
-		if (task) {
-			kthread_bind(task, cpu);
-			wake_up_process(task);
-		}
+	pool->cpu_comp_threads = alloc_percpu(struct task_struct *);
+	if (!pool->cpu_comp_threads)
+		goto out_tasks;
+
+	for_each_present_cpu(cpu) {
+		struct ehca_cpu_comp_task *cct;
+
+		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+		spin_lock_init(&cct->task_lock);
+		INIT_LIST_HEAD(&cct->cq_list);
 	}
 
-	register_hotcpu_notifier(&comp_pool_callback_nb);
+	comp_pool_threads.store = pool->cpu_comp_threads;
+	ret = smpboot_register_percpu_thread(&comp_pool_threads);
+	if (ret)
+		goto out_threads;
 
-	printk(KERN_INFO "eHCA scaling code enabled\n");
+	pr_info("eHCA scaling code enabled\n");
+	return ret;
 
-	return 0;
+out_threads:
+	free_percpu(pool->cpu_comp_threads);
+out_tasks:
+	free_percpu(pool->cpu_comp_tasks);
+out_pool:
+	kfree(pool);
+	return ret;
 }
 
 void ehca_destroy_comp_pool(void)
 {
-	int i;
-
 	if (!ehca_scaling_code)
 		return;
 
-	unregister_hotcpu_notifier(&comp_pool_callback_nb);
-
-	for_each_online_cpu(i)
-		destroy_comp_task(pool, i);
+	smpboot_unregister_percpu_thread(&comp_pool_threads);
 
+	free_percpu(pool->cpu_comp_threads);
 	free_percpu(pool->cpu_comp_tasks);
 	kfree(pool);
 }
Index: tip/drivers/infiniband/hw/ehca/ehca_irq.h
===================================================================
--- tip.orig/drivers/infiniband/hw/ehca/ehca_irq.h
+++ tip/drivers/infiniband/hw/ehca/ehca_irq.h
@@ -58,15 +58,15 @@ void ehca_tasklet_eq(unsigned long data)
 void ehca_process_eq(struct ehca_shca *shca, int is_irq);
 
 struct ehca_cpu_comp_task {
-	wait_queue_head_t wait_queue;
 	struct list_head cq_list;
-	struct task_struct *task;
 	spinlock_t task_lock;
 	int cq_jobs;
+	int active;
 };
 
 struct ehca_comp_pool {
-	struct ehca_cpu_comp_task *cpu_comp_tasks;
+	struct ehca_cpu_comp_task __percpu *cpu_comp_tasks;
+	struct task_struct * __percpu *cpu_comp_threads;
 	int last_cpu;
 	spinlock_t last_cpu_lock;
 };


