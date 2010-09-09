Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab0IITwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:52:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:33234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab0IITw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:52:28 -0400
Date: Thu, 9 Sep 2010 19:51:53 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, eranian@googlemail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, robert.richter@amd.com,
        fweisbec@gmail.com, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, eranian@googlemail.com,
        a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com,
        fweisbec@gmail.com, robert.richter@amd.com, ming.m.lin@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Per-pmu-per-cpu contexts
Message-ID: <tip-108b02cfce04ee90b0a07ee0b104baffd39f5934@git.kernel.org>
Git-Commit-ID: 108b02cfce04ee90b0a07ee0b104baffd39f5934
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:51:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  108b02cfce04ee90b0a07ee0b104baffd39f5934
Gitweb:     http://git.kernel.org/tip/108b02cfce04ee90b0a07ee0b104baffd39f5934
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Sep 2010 14:32:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:32 +0200

perf: Per-pmu-per-cpu contexts

Allocate per-cpu contexts per pmu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Yanmin <yanmin_zhang@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    4 +-
 kernel/perf_event.c        |  178 +++++++++++++++++++++++++++-----------------
 2 files changed, 113 insertions(+), 69 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index fa04537..22155ef 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -570,7 +570,8 @@ struct perf_event;
 struct pmu {
 	struct list_head		entry;
 
-	int				*pmu_disable_count;
+	int * __percpu			pmu_disable_count;
+	struct perf_cpu_context * __percpu pmu_cpu_context;
 
 	/*
 	 * Fully disable/enable this PMU, can be used to protect from the PMI
@@ -808,6 +809,7 @@ struct perf_event {
  * Used as a container for task events and CPU events as well:
  */
 struct perf_event_context {
+	struct pmu			*pmu;
 	/*
 	 * Protect the states of the events in the list,
 	 * nr_active, and the list:
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index d75e4c8..8ca6e69 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
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
@@ -78,9 +77,9 @@ void perf_pmu_enable(struct pmu *pmu)
 		pmu->pmu_enable(pmu);
 }
 
-static void perf_pmu_rotate_start(void)
+static void perf_pmu_rotate_start(struct pmu *pmu)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 
 	if (hrtimer_active(&cpuctx->timer))
 		return;
@@ -90,9 +89,9 @@ static void perf_pmu_rotate_start(void)
 			HRTIMER_MODE_REL_PINNED, 0);
 }
 
-static void perf_pmu_rotate_stop(void)
+static void perf_pmu_rotate_stop(struct pmu *pmu)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 
 	hrtimer_cancel(&cpuctx->timer);
 }
@@ -301,7 +300,7 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	if (!ctx->nr_events)
-		perf_pmu_rotate_start();
+		perf_pmu_rotate_start(ctx->pmu);
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat++;
@@ -466,6 +465,12 @@ group_sched_out(struct perf_event *group_event,
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
@@ -474,9 +479,9 @@ group_sched_out(struct perf_event *group_event,
  */
 static void __perf_event_remove_from_context(void *info)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
 	/*
 	 * If this is a task context, we need to check whether it is
@@ -556,8 +561,8 @@ retry:
 static void __perf_event_disable(void *info)
 {
 	struct perf_event *event = info;
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = event->ctx;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
 	/*
 	 * If this is a per-task event, need to check whether this
@@ -765,10 +770,10 @@ static void add_event_to_ctx(struct perf_event *event,
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
@@ -912,9 +917,9 @@ static void __perf_event_mark_enabled(struct perf_event *event,
 static void __perf_event_enable(void *info)
 {
 	struct perf_event *event = info;
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = event->ctx;
 	struct perf_event *leader = event->group_leader;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 	int err;
 
 	/*
@@ -1188,15 +1193,19 @@ static void perf_event_sync_stat(struct perf_event_context *ctx,
 void perf_event_task_sched_out(struct task_struct *task,
 				 struct task_struct *next)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = task->perf_event_ctxp;
 	struct perf_event_context *next_ctx;
 	struct perf_event_context *parent;
+	struct perf_cpu_context *cpuctx;
 	int do_switch = 1;
 
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
-	if (likely(!ctx || !cpuctx->task_ctx))
+	if (likely(!ctx))
+		return;
+
+	cpuctx = __get_cpu_context(ctx);
+	if (!cpuctx->task_ctx)
 		return;
 
 	rcu_read_lock();
@@ -1242,7 +1251,7 @@ void perf_event_task_sched_out(struct task_struct *task,
 static void task_ctx_sched_out(struct perf_event_context *ctx,
 			       enum event_type_t event_type)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
 	if (!cpuctx->task_ctx)
 		return;
@@ -1360,8 +1369,8 @@ static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
 static void task_ctx_sched_in(struct task_struct *task,
 			      enum event_type_t event_type)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = task->perf_event_ctxp;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
 	if (likely(!ctx))
 		return;
@@ -1383,12 +1392,13 @@ static void task_ctx_sched_in(struct task_struct *task,
  */
 void perf_event_task_sched_in(struct task_struct *task)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = task->perf_event_ctxp;
+	struct perf_cpu_context *cpuctx;
 
 	if (likely(!ctx))
 		return;
 
+	cpuctx = __get_cpu_context(ctx);
 	if (cpuctx->task_ctx == ctx)
 		return;
 
@@ -1409,7 +1419,7 @@ void perf_event_task_sched_in(struct task_struct *task)
 	 * Since these rotations are per-cpu, we need to ensure the
 	 * cpu-context we got scheduled on is actually rotating.
 	 */
-	perf_pmu_rotate_start();
+	perf_pmu_rotate_start(ctx->pmu);
 }
 
 #define MAX_INTERRUPTS (~0ULL)
@@ -1687,9 +1697,9 @@ out:
  */
 static void __perf_event_read(void *info)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
 	/*
 	 * If this is a task context, we need to check whether it is
@@ -1962,7 +1972,8 @@ __perf_event_init_context(struct perf_event_context *ctx,
 	ctx->task = task;
 }
 
-static struct perf_event_context *find_get_context(pid_t pid, int cpu)
+static struct perf_event_context *
+find_get_context(struct pmu *pmu, pid_t pid, int cpu)
 {
 	struct perf_event_context *ctx;
 	struct perf_cpu_context *cpuctx;
@@ -1986,7 +1997,7 @@ static struct perf_event_context *find_get_context(pid_t pid, int cpu)
 		if (!cpu_online(cpu))
 			return ERR_PTR(-ENODEV);
 
-		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 		ctx = &cpuctx->ctx;
 		get_ctx(ctx);
 
@@ -2030,6 +2041,7 @@ retry:
 		if (!ctx)
 			goto errout;
 		__perf_event_init_context(ctx, task);
+		ctx->pmu = pmu;
 		get_ctx(ctx);
 		if (cmpxchg(&task->perf_event_ctxp, NULL, ctx)) {
 			/*
@@ -3745,18 +3757,20 @@ static void perf_event_task_ctx(struct perf_event_context *ctx,
 
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
@@ -3861,6 +3875,7 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx;
 	unsigned int size;
+	struct pmu *pmu;
 	char comm[TASK_COMM_LEN];
 
 	memset(comm, 0, sizeof(comm));
@@ -3872,14 +3887,15 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 
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
@@ -3989,6 +4005,7 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	char tmp[16];
 	char *buf = NULL;
 	const char *name;
+	struct pmu *pmu;
 
 	memset(tmp, 0, sizeof(tmp));
 
@@ -4040,14 +4057,16 @@ got_name:
 
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
@@ -4982,10 +5001,6 @@ static struct pmu perf_task_clock = {
 	.read		= task_clock_event_read,
 };
 
-static LIST_HEAD(pmus);
-static DEFINE_MUTEX(pmus_lock);
-static struct srcu_struct pmus_srcu;
-
 static void perf_pmu_nop_void(struct pmu *pmu)
 {
 }
@@ -5013,7 +5028,7 @@ static void perf_pmu_cancel_txn(struct pmu *pmu)
 
 int perf_pmu_register(struct pmu *pmu)
 {
-	int ret;
+	int cpu, ret;
 
 	mutex_lock(&pmus_lock);
 	ret = -ENOMEM;
@@ -5021,6 +5036,21 @@ int perf_pmu_register(struct pmu *pmu)
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
@@ -5049,6 +5079,10 @@ unlock:
 	mutex_unlock(&pmus_lock);
 
 	return ret;
+
+free_pdc:
+	free_percpu(pmu->pmu_disable_count);
+	goto unlock;
 }
 
 void perf_pmu_unregister(struct pmu *pmu)
@@ -5057,9 +5091,14 @@ void perf_pmu_unregister(struct pmu *pmu)
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
@@ -5374,7 +5413,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	/*
 	 * Get the target context (task or percpu):
 	 */
-	ctx = find_get_context(pid, cpu);
+	ctx = find_get_context(event->pmu, pid, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
 		goto err_alloc;
@@ -5489,7 +5528,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err;
 	}
 
-	ctx = find_get_context(pid, cpu);
+	ctx = find_get_context(event->pmu, pid, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
 		goto err_free;
@@ -5833,6 +5872,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 			return -ENOMEM;
 
 		__perf_event_init_context(child_ctx, child);
+		child_ctx->pmu = event->pmu;
 		child->perf_event_ctxp = child_ctx;
 		get_task_struct(child);
 	}
@@ -5935,30 +5975,18 @@ int perf_event_init_task(struct task_struct *child)
 
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
@@ -5972,32 +6000,46 @@ static void __cpuinit perf_event_init_cpu(int cpu)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void __perf_event_exit_cpu(void *info)
+static void __perf_event_exit_context(void *__info)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
-	struct perf_event_context *ctx = &cpuctx->ctx;
+	struct perf_event_context *ctx = __info;
 	struct perf_event *event, *tmp;
 
-	perf_pmu_rotate_stop();
+	perf_pmu_rotate_stop(ctx->pmu);
 
 	list_for_each_entry_safe(event, tmp, &ctx->pinned_groups, group_entry)
 		__perf_event_remove_from_context(event);
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
