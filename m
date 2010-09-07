Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab0IGQ5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:57:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32878 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab0IGQ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:56:59 -0400
Message-Id: <20100907165011.997507021@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 18:46:47 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 14/19] perf: Per-pmu-per-cpu contexts
References: <20100907164633.879932949@chello.nl>
Content-Disposition: inline; filename=perf-pmu-context-4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate per-cpu contexts per pmu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    4 -
 kernel/perf_event.c        |  159 +++++++++++++++++++++++++++------------------
 2 files changed, 101 insertions(+), 62 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -570,7 +570,8 @@ struct perf_event;
 struct pmu {
 	struct list_head		entry;
 
-	int				*pmu_disable_count;
+	int * __percpu			pmu_disable_count;
+	struct perf_cpu_context * __percpu pmu_cpu_context;
 
 	/*
 	 * Fully disable/enable this PMU, can be used to protect from the PMI
@@ -813,6 +814,7 @@ struct perf_event {
  * Used as a container for task events and CPU events as well:
  */
 struct perf_event_context {
+	struct pmu			*pmu;
 	/*
 	 * Protect the states of the events in the list,
 	 * nr_active, and the list:
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -34,16 +34,15 @@
 
 #include <asm/irq_regs.h>
 
-/*
- * Each CPU has a list of per CPU events:
- */
-static DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
-
 static atomic_t nr_events __read_mostly;
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
 
+static LIST_HEAD(pmus);
+static DEFINE_MUTEX(pmus_lock);
+static struct srcu_struct pmus_srcu;
+
 /*
  * perf event paranoia level:
  *  -1 - not paranoid at all
@@ -447,6 +446,12 @@ group_sched_out(struct perf_event *group
 		cpuctx->exclusive = 0;
 }
 
+static inline struct perf_cpu_context *
+__get_cpu_context(struct perf_event_context *ctx)
+{
+	return this_cpu_ptr(ctx->pmu->pmu_cpu_context);
+}
+
 /*
  * Cross CPU call to remove a performance event
  *
@@ -455,9 +460,9 @@ group_sched_out(struct perf_event *group
  */
 static void __perf_event_remove_from_context(void *info)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
 	/*
 	 * If this is a task context, we need to check whether it is
@@ -537,8 +542,8 @@ static void perf_event_remove_from_conte
 static void __perf_event_disable(void *info)
 {
 	struct perf_event *event = info;
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = event->ctx;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
 	/*
 	 * If this is a per-task event, need to check whether this
@@ -746,10 +751,10 @@ static void add_event_to_ctx(struct perf
  */
 static void __perf_install_in_context(void *info)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
 	struct perf_event *leader = event->group_leader;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 	int err;
 
 	/*
@@ -893,9 +898,9 @@ static void __perf_event_mark_enabled(st
 static void __perf_event_enable(void *info)
 {
 	struct perf_event *event = info;
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = event->ctx;
 	struct perf_event *leader = event->group_leader;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 	int err;
 
 	/*
@@ -1169,8 +1174,8 @@ static void perf_event_sync_stat(struct 
 void perf_event_task_sched_out(struct task_struct *task,
 				 struct task_struct *next)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = task->perf_event_ctxp;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 	struct perf_event_context *next_ctx;
 	struct perf_event_context *parent;
 	int do_switch = 1;
@@ -1223,7 +1228,7 @@ void perf_event_task_sched_out(struct ta
 static void task_ctx_sched_out(struct perf_event_context *ctx,
 			       enum event_type_t event_type)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
 	if (!cpuctx->task_ctx)
 		return;
@@ -1341,8 +1346,8 @@ static void cpu_ctx_sched_in(struct perf
 static void task_ctx_sched_in(struct task_struct *task,
 			      enum event_type_t event_type)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = task->perf_event_ctxp;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
 	if (likely(!ctx))
 		return;
@@ -1364,8 +1369,8 @@ static void task_ctx_sched_in(struct tas
  */
 void perf_event_task_sched_in(struct task_struct *task)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = task->perf_event_ctxp;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
 	if (likely(!ctx))
 		return;
@@ -1593,7 +1598,7 @@ static enum hrtimer_restart perf_event_c
 
 static void perf_pmu_rotate_start(struct pmu *pmu)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 
 	if (hrtimer_active(&cpuctx->timer))
 		return;
@@ -1669,9 +1674,9 @@ static void perf_event_enable_on_exec(st
  */
 static void __perf_event_read(void *info)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
 	/*
 	 * If this is a task context, we need to check whether it is
@@ -1944,7 +1949,8 @@ __perf_event_init_context(struct perf_ev
 	ctx->task = task;
 }
 
-static struct perf_event_context *find_get_context(pid_t pid, int cpu)
+static struct perf_event_context *
+find_get_context(struct pmu *pmu, pid_t pid, int cpu)
 {
 	struct perf_event_context *ctx;
 	struct perf_cpu_context *cpuctx;
@@ -1968,7 +1974,7 @@ static struct perf_event_context *find_g
 		if (!cpu_online(cpu))
 			return ERR_PTR(-ENODEV);
 
-		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 		ctx = &cpuctx->ctx;
 		get_ctx(ctx);
 
@@ -2012,6 +2018,7 @@ static struct perf_event_context *find_g
 		if (!ctx)
 			goto errout;
 		__perf_event_init_context(ctx, task);
+		ctx->pmu = pmu;
 		get_ctx(ctx);
 		if (cmpxchg(&task->perf_event_ctxp, NULL, ctx)) {
 			/*
@@ -3727,18 +3734,20 @@ static void perf_event_task_ctx(struct p
 
 static void perf_event_task_event(struct perf_task_event *task_event)
 {
-	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx = task_event->task_ctx;
+	struct perf_cpu_context *cpuctx;
+	struct pmu *pmu;
 
-	rcu_read_lock();
-	cpuctx = &get_cpu_var(perf_cpu_context);
-	perf_event_task_ctx(&cpuctx->ctx, task_event);
+	rcu_read_lock_sched();
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		perf_event_task_ctx(&cpuctx->ctx, task_event);
+	}
 	if (!ctx)
 		ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
 		perf_event_task_ctx(ctx, task_event);
-	put_cpu_var(perf_cpu_context);
-	rcu_read_unlock();
+	rcu_read_unlock_sched();
 }
 
 static void perf_event_task(struct task_struct *task,
@@ -3843,6 +3852,7 @@ static void perf_event_comm_event(struct
 	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx;
 	unsigned int size;
+	struct pmu *pmu;
 	char comm[TASK_COMM_LEN];
 
 	memset(comm, 0, sizeof(comm));
@@ -3854,14 +3864,15 @@ static void perf_event_comm_event(struct
 
 	comm_event->event_id.header.size = sizeof(comm_event->event_id) + size;
 
-	rcu_read_lock();
-	cpuctx = &get_cpu_var(perf_cpu_context);
-	perf_event_comm_ctx(&cpuctx->ctx, comm_event);
+	rcu_read_lock_sched();
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		perf_event_comm_ctx(&cpuctx->ctx, comm_event);
+	}
 	ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
 		perf_event_comm_ctx(ctx, comm_event);
-	put_cpu_var(perf_cpu_context);
-	rcu_read_unlock();
+	rcu_read_unlock_sched();
 }
 
 void perf_event_comm(struct task_struct *task)
@@ -3971,6 +3982,7 @@ static void perf_event_mmap_event(struct
 	char tmp[16];
 	char *buf = NULL;
 	const char *name;
+	struct pmu *pmu;
 
 	memset(tmp, 0, sizeof(tmp));
 
@@ -4022,14 +4034,16 @@ static void perf_event_mmap_event(struct
 
 	mmap_event->event_id.header.size = sizeof(mmap_event->event_id) + size;
 
-	rcu_read_lock();
-	cpuctx = &get_cpu_var(perf_cpu_context);
-	perf_event_mmap_ctx(&cpuctx->ctx, mmap_event, vma->vm_flags & VM_EXEC);
+	rcu_read_lock_sched();
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		perf_event_mmap_ctx(&cpuctx->ctx, mmap_event,
+					vma->vm_flags & VM_EXEC);
+	}
 	ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
 		perf_event_mmap_ctx(ctx, mmap_event, vma->vm_flags & VM_EXEC);
-	put_cpu_var(perf_cpu_context);
-	rcu_read_unlock();
+	rcu_read_unlock_sched();
 
 	kfree(buf);
 }
@@ -4964,10 +4978,6 @@ static struct pmu perf_task_clock = {
 	.read		= task_clock_event_read,
 };
 
-static LIST_HEAD(pmus);
-static DEFINE_MUTEX(pmus_lock);
-static struct srcu_struct pmus_srcu;
-
 static void perf_pmu_nop_void(struct pmu *pmu)
 {
 }
@@ -4995,7 +5005,7 @@ static void perf_pmu_cancel_txn(struct p
 
 int perf_pmu_register(struct pmu *pmu)
 {
-	int ret;
+	int cpu, ret;
 
 	mutex_lock(&pmus_lock);
 	ret = -ENOMEM;
@@ -5003,6 +5013,21 @@ int perf_pmu_register(struct pmu *pmu)
 	if (!pmu->pmu_disable_count)
 		goto unlock;
 
+	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
+	if (!pmu->pmu_cpu_context)
+		goto free_pdc;
+
+	for_each_possible_cpu(cpu) {
+		struct perf_cpu_context *cpuctx;
+
+		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
+		__perf_event_init_context(&cpuctx->ctx, NULL);
+		cpuctx->ctx.pmu = pmu;
+		cpuctx->timer_interval = TICK_NSEC;
+		hrtimer_init(&cpuctx->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		cpuctx->timer.function = perf_event_context_tick;
+	}
+
 	if (!pmu->start_txn) {
 		if (pmu->pmu_enable) {
 			/*
@@ -5034,6 +5059,10 @@ int perf_pmu_register(struct pmu *pmu)
 	mutex_unlock(&pmus_lock);
 
 	return ret;
+
+free_pdc:
+	free_percpu(pmu->pmu_disable_count);
+	goto unlock;
 }
 
 void perf_pmu_unregister(struct pmu *pmu)
@@ -5042,9 +5071,14 @@ void perf_pmu_unregister(struct pmu *pmu
 	list_del_rcu(&pmu->entry);
 	mutex_unlock(&pmus_lock);
 
+	/*
+	 * We use the pmu list either under SRCU or preempt_disable,
+	 * synchronize_srcu() implies synchronize_sched() so we're good.
+	 */
 	synchronize_srcu(&pmus_srcu);
 
 	free_percpu(pmu->pmu_disable_count);
+	free_percpu(pmu->pmu_cpu_context);
 }
 
 struct pmu *perf_init_event(struct perf_event *event)
@@ -5359,7 +5393,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	/*
 	 * Get the target context (task or percpu):
 	 */
-	ctx = find_get_context(pid, cpu);
+	ctx = find_get_context(event->pmu, pid, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
 		goto err_alloc;
@@ -5474,7 +5508,7 @@ perf_event_create_kernel_counter(struct 
 		goto err;
 	}
 
-	ctx = find_get_context(pid, cpu);
+	ctx = find_get_context(event->pmu, pid, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
 		goto err_free;
@@ -5818,6 +5852,7 @@ inherit_task_group(struct perf_event *ev
 			return -ENOMEM;
 
 		__perf_event_init_context(child_ctx, child);
+		child_ctx->pmu = event->pmu;
 		child->perf_event_ctxp = child_ctx;
 		get_task_struct(child);
 	}
@@ -5920,30 +5955,18 @@ int perf_event_init_task(struct task_str
 
 static void __init perf_event_init_all_cpus(void)
 {
-	struct perf_cpu_context *cpuctx;
 	struct swevent_htable *swhash;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
 		swhash = &per_cpu(swevent_htable, cpu);
 		mutex_init(&swhash->hlist_mutex);
-
-		cpuctx = &per_cpu(perf_cpu_context, cpu);
-		__perf_event_init_context(&cpuctx->ctx, NULL);
-		cpuctx->timer_interval = TICK_NSEC;
-		hrtimer_init(&cpuctx->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-		cpuctx->timer.function = perf_event_context_tick;
 	}
 }
 
 static void __cpuinit perf_event_init_cpu(int cpu)
 {
-	struct perf_cpu_context *cpuctx;
-	struct swevent_htable *swhash;
-
-	cpuctx = &per_cpu(perf_cpu_context, cpu);
-
-	swhash = &per_cpu(swevent_htable, cpu);
+	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
 	mutex_lock(&swhash->hlist_mutex);
 	if (swhash->hlist_refcount > 0) {
@@ -5957,10 +5980,9 @@ static void __cpuinit perf_event_init_cp
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void __perf_event_exit_cpu(void *info)
+static void __perf_event_exit_context(void *__info)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
-	struct perf_event_context *ctx = &cpuctx->ctx;
+	struct perf_event_context *ctx = __info;
 	struct perf_event *event, *tmp;
 
 	list_for_each_entry_safe(event, tmp, &ctx->pinned_groups, group_entry)
@@ -5968,19 +5990,34 @@ static void __perf_event_exit_cpu(void *
 	list_for_each_entry_safe(event, tmp, &ctx->flexible_groups, group_entry)
 		__perf_event_remove_from_context(event);
 }
+
+static void perf_event_exit_cpu_context(int cpu)
+{
+	struct perf_event_context *ctx;
+	struct pmu *pmu;
+	int idx;
+
+	idx = srcu_read_lock(&pmus_srcu);
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		ctx = &this_cpu_ptr(pmu->pmu_cpu_context)->ctx;
+
+		mutex_lock(&ctx->mutex);
+		smp_call_function_single(cpu, __perf_event_exit_context, ctx, 1);
+		mutex_unlock(&ctx->mutex);
+	}
+	srcu_read_unlock(&pmus_srcu, idx);
+
+}
+
 static void perf_event_exit_cpu(int cpu)
 {
-	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
 	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
-	struct perf_event_context *ctx = &cpuctx->ctx;
 
 	mutex_lock(&swhash->hlist_mutex);
 	swevent_hlist_release(swhash);
 	mutex_unlock(&swhash->hlist_mutex);
 
-	mutex_lock(&ctx->mutex);
-	smp_call_function_single(cpu, __perf_event_exit_cpu, NULL, 1);
-	mutex_unlock(&ctx->mutex);
+	perf_event_exit_cpu_context(cpu);
 }
 #else
 static inline void perf_event_exit_cpu(int cpu) { }


