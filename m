Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab0IGQ72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:59:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab0IGQ4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:56:43 -0400
Message-Id: <20100907165012.167924668@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 18:46:50 +0200
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
Subject: [RFC][PATCH 17/19] perf: Multiple task contexts
References: <20100907164633.879932949@chello.nl>
Content-Disposition: inline; filename=perf-pmu-context-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the infrastructure for multiple task contexts.

A more flexible approach would have resulted in more pointer chases
in the scheduling hot-paths. This approach has the limitation of a
static number of task contexts.

Since I expect most external PMUs to be system wide, or at least node
wide (as per the intel uncore unit) they won't actually need a task
context.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    1 
 include/linux/sched.h      |    8 -
 kernel/perf_event.c        |  344 ++++++++++++++++++++++++++++++---------------
 3 files changed, 243 insertions(+), 110 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1161,6 +1161,12 @@ struct sched_rt_entity {
 
 struct rcu_node;
 
+enum perf_event_task_context {
+	perf_invalid_context = -1,
+	perf_hw_context = 0,
+	perf_nr_task_contexts,
+};
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1434,7 +1440,7 @@ struct task_struct {
 	struct futex_pi_state *pi_state_cache;
 #endif
 #ifdef CONFIG_PERF_EVENTS
-	struct perf_event_context *perf_event_ctxp;
+	struct perf_event_context *perf_event_ctxp[perf_nr_task_contexts];
 	struct mutex perf_event_mutex;
 	struct list_head perf_event_list;
 #endif
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -129,13 +129,13 @@ static u64 primary_event_id(struct perf_
  * the context could get moved to another task.
  */
 static struct perf_event_context *
-perf_lock_task_context(struct task_struct *task, unsigned long *flags)
+perf_lock_task_context(struct task_struct *task, int ctxn, unsigned long *flags)
 {
 	struct perf_event_context *ctx;
 
 	rcu_read_lock();
 retry:
-	ctx = rcu_dereference(task->perf_event_ctxp);
+	ctx = rcu_dereference(task->perf_event_ctxp[ctxn]);
 	if (ctx) {
 		/*
 		 * If this context is a clone of another, it might
@@ -148,7 +148,7 @@ perf_lock_task_context(struct task_struc
 		 * can't get swapped on us any more.
 		 */
 		raw_spin_lock_irqsave(&ctx->lock, *flags);
-		if (ctx != rcu_dereference(task->perf_event_ctxp)) {
+		if (ctx != rcu_dereference(task->perf_event_ctxp[ctxn])) {
 			raw_spin_unlock_irqrestore(&ctx->lock, *flags);
 			goto retry;
 		}
@@ -167,12 +167,13 @@ perf_lock_task_context(struct task_struc
  * can't get swapped to another task.  This also increments its
  * reference count so that the context can't get freed.
  */
-static struct perf_event_context *perf_pin_task_context(struct task_struct *task)
+static struct perf_event_context *
+perf_pin_task_context(struct task_struct *task, int ctxn)
 {
 	struct perf_event_context *ctx;
 	unsigned long flags;
 
-	ctx = perf_lock_task_context(task, &flags);
+	ctx = perf_lock_task_context(task, ctxn, &flags);
 	if (ctx) {
 		++ctx->pin_count;
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
@@ -1160,34 +1161,25 @@ static void perf_event_sync_stat(struct 
 	}
 }
 
-/*
- * Called from scheduler to remove the events of the current task,
- * with interrupts disabled.
- *
- * We stop each event and update the event value in event->count.
- *
- * This does not protect us against NMI, but disable()
- * sets the disabled bit in the control field of event _before_
- * accessing the event control register. If a NMI hits, then it will
- * not restart the event.
- */
-void perf_event_task_sched_out(struct task_struct *task,
-				 struct task_struct *next)
+void perf_event_context_sched_out(struct task_struct *task, int ctxn,
+				  struct task_struct *next)
 {
-	struct perf_event_context *ctx = task->perf_event_ctxp;
-	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
+	struct perf_event_context *ctx = task->perf_event_ctxp[ctxn];
+	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *next_ctx;
 	struct perf_event_context *parent;
 	int do_switch = 1;
 
-	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
+	if (likely(!ctx))
+		return;
 
-	if (likely(!ctx || !cpuctx->task_ctx))
+       	cpuctx = __get_cpu_context(ctx);
+	if (!cpuctx->task_ctx)
 		return;
 
 	rcu_read_lock();
 	parent = rcu_dereference(ctx->parent_ctx);
-	next_ctx = next->perf_event_ctxp;
+	next_ctx = next->perf_event_ctxp[ctxn];
 	if (parent && next_ctx &&
 	    rcu_dereference(next_ctx->parent_ctx) == parent) {
 		/*
@@ -1206,8 +1198,8 @@ void perf_event_task_sched_out(struct ta
 			 * XXX do we need a memory barrier of sorts
 			 * wrt to rcu_dereference() of perf_event_ctxp
 			 */
-			task->perf_event_ctxp = next_ctx;
-			next->perf_event_ctxp = ctx;
+			task->perf_event_ctxp[ctxn] = next_ctx;
+			next->perf_event_ctxp[ctxn] = ctx;
 			ctx->task = next;
 			next_ctx->task = task;
 			do_switch = 0;
@@ -1225,6 +1217,36 @@ void perf_event_task_sched_out(struct ta
 	}
 }
 
+#define for_each_task_context(ctx, task)				\
+	for ((ctx) = (task)->perf_event_ctxp[0];			\
+	     (ctx) - (task)->perf_event_ctxp[0] < perf_nr_task_contexts;\
+	     (ctx)++)
+
+#define for_each_task_context_nr(ctxn)					\
+	for ((ctxn) = 0; (ctxn) < perf_nr_task_contexts; (ctxn)++)
+
+/*
+ * Called from scheduler to remove the events of the current task,
+ * with interrupts disabled.
+ *
+ * We stop each event and update the event value in event->count.
+ *
+ * This does not protect us against NMI, but disable()
+ * sets the disabled bit in the control field of event _before_
+ * accessing the event control register. If a NMI hits, then it will
+ * not restart the event.
+ */
+void perf_event_task_sched_out(struct task_struct *task,
+			       struct task_struct *next)
+{
+	int ctxn;
+
+	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
+
+	for_each_task_context_nr(ctxn)
+		perf_event_context_sched_out(task, ctxn, next);
+}
+
 static void task_ctx_sched_out(struct perf_event_context *ctx,
 			       enum event_type_t event_type)
 {
@@ -1343,38 +1365,24 @@ static void cpu_ctx_sched_in(struct perf
 	ctx_sched_in(ctx, cpuctx, event_type);
 }
 
-static void task_ctx_sched_in(struct task_struct *task,
+static void task_ctx_sched_in(struct perf_event_context *ctx,
 			      enum event_type_t event_type)
 {
-	struct perf_event_context *ctx = task->perf_event_ctxp;
-	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
+	struct perf_cpu_context *cpuctx;
 
-	if (likely(!ctx))
-		return;
+       	cpuctx = __get_cpu_context(ctx);
 	if (cpuctx->task_ctx == ctx)
 		return;
+
 	ctx_sched_in(ctx, cpuctx, event_type);
 	cpuctx->task_ctx = ctx;
 }
-/*
- * Called from scheduler to add the events of the current task
- * with interrupts disabled.
- *
- * We restore the event value and then enable it.
- *
- * This does not protect us against NMI, but enable()
- * sets the enabled bit in the control field of event _before_
- * accessing the event control register. If a NMI hits, then it will
- * keep the event running.
- */
-void perf_event_task_sched_in(struct task_struct *task)
-{
-	struct perf_event_context *ctx = task->perf_event_ctxp;
-	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
-	if (likely(!ctx))
-		return;
+void perf_event_context_sched_in(struct perf_event_context *ctx)
+{
+	struct perf_cpu_context *cpuctx;
 
+	cpuctx = __get_cpu_context(ctx);
 	if (cpuctx->task_ctx == ctx)
 		return;
 
@@ -1392,6 +1400,29 @@ void perf_event_task_sched_in(struct tas
 	cpuctx->task_ctx = ctx;
 }
 
+/*
+ * Called from scheduler to add the events of the current task
+ * with interrupts disabled.
+ *
+ * We restore the event value and then enable it.
+ *
+ * This does not protect us against NMI, but enable()
+ * sets the enabled bit in the control field of event _before_
+ * accessing the event control register. If a NMI hits, then it will
+ * keep the event running.
+ */
+void perf_event_task_sched_in(struct task_struct *task)
+{
+	struct perf_event_context *ctx;
+
+	for_each_task_context(ctx, task) {
+		if (likely(!ctx))
+			continue;
+
+		perf_event_context_sched_in(ctx);
+	}
+}
+
 #define MAX_INTERRUPTS (~0ULL)
 
 static void perf_log_throttle(struct perf_event *event, int enable);
@@ -1553,7 +1584,7 @@ static enum hrtimer_restart perf_event_c
 {
 	enum hrtimer_restart restart = HRTIMER_NORESTART;
 	struct perf_cpu_context *cpuctx;
-	struct perf_event_context *ctx;
+	struct perf_event_context *ctx = NULL;
 	int rotate = 0;
 
 	cpuctx = container_of(timer, struct perf_cpu_context, timer);
@@ -1564,7 +1595,7 @@ static enum hrtimer_restart perf_event_c
 			rotate = 1;
 	}
 
-	ctx = current->perf_event_ctxp;
+	ctx = cpuctx->task_ctx;
 	if (ctx && ctx->nr_events) {
 		restart = HRTIMER_RESTART;
 		if (ctx->nr_events != ctx->nr_active)
@@ -1588,7 +1619,7 @@ static enum hrtimer_restart perf_event_c
 
 	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
-		task_ctx_sched_in(current, EVENT_FLEXIBLE);
+		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
 
 done:
 	hrtimer_forward_now(timer, ns_to_ktime(cpuctx->timer_interval));
@@ -1627,20 +1658,18 @@ static int event_enable_on_exec(struct p
  * Enable all of a task's events that have been marked enable-on-exec.
  * This expects task == current.
  */
-static void perf_event_enable_on_exec(struct task_struct *task)
+static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 {
-	struct perf_event_context *ctx;
 	struct perf_event *event;
 	unsigned long flags;
 	int enabled = 0;
 	int ret;
 
 	local_irq_save(flags);
-	ctx = task->perf_event_ctxp;
 	if (!ctx || !ctx->nr_events)
 		goto out;
 
-	__perf_event_task_sched_out(ctx);
+	task_ctx_sched_out(ctx, EVENT_ALL);
 
 	raw_spin_lock(&ctx->lock);
 
@@ -1664,7 +1693,7 @@ static void perf_event_enable_on_exec(st
 
 	raw_spin_unlock(&ctx->lock);
 
-	perf_event_task_sched_in(task);
+	perf_event_context_sched_in(ctx);
 out:
 	local_irq_restore(flags);
 }
@@ -1972,7 +2001,7 @@ find_get_context(struct pmu *pmu, pid_t 
 	struct perf_cpu_context *cpuctx;
 	struct task_struct *task;
 	unsigned long flags;
-	int err;
+	int ctxn, err;
 
 	if (pid == -1 && cpu != -1) {
 		/* Must be root to operate on a CPU event: */
@@ -2021,8 +2050,13 @@ find_get_context(struct pmu *pmu, pid_t 
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto errout;
 
+	err = -EINVAL;
+	ctxn = pmu->task_ctx_nr;
+	if (ctxn < 0)
+		goto errout;
+
 retry:
-	ctx = perf_lock_task_context(task, &flags);
+	ctx = perf_lock_task_context(task, ctxn, &flags);
 	if (ctx) {
 		unclone_ctx(ctx);
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
@@ -2036,7 +2070,7 @@ find_get_context(struct pmu *pmu, pid_t 
 
 		get_ctx(ctx);
 
-		if (cmpxchg(&task->perf_event_ctxp, NULL, ctx)) {
+		if (cmpxchg(&task->perf_event_ctxp[ctxn], NULL, ctx)) {
 			/*
 			 * We raced with some other task; use
 			 * the context they set.
@@ -3750,19 +3784,26 @@ static void perf_event_task_ctx(struct p
 
 static void perf_event_task_event(struct perf_task_event *task_event)
 {
-	struct perf_event_context *ctx = task_event->task_ctx;
 	struct perf_cpu_context *cpuctx;
+	struct perf_event_context *ctx;
 	struct pmu *pmu;
+	int ctxn;
 
 	rcu_read_lock_sched();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 		perf_event_task_ctx(&cpuctx->ctx, task_event);
+
+		ctx = task_event->task_ctx;
+		if (!ctx) {
+			ctxn = pmu->task_ctx_nr;
+			if (ctxn < 0)
+				continue;
+			ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
+		}
+		if (ctx)
+			perf_event_task_ctx(ctx, task_event);
 	}
-	if (!ctx)
-		ctx = rcu_dereference(current->perf_event_ctxp);
-	if (ctx)
-		perf_event_task_ctx(ctx, task_event);
 	rcu_read_unlock_sched();
 }
 
@@ -3867,9 +3908,10 @@ static void perf_event_comm_event(struct
 {
 	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx;
+	char comm[TASK_COMM_LEN];
 	unsigned int size;
 	struct pmu *pmu;
-	char comm[TASK_COMM_LEN];
+	int ctxn;
 
 	memset(comm, 0, sizeof(comm));
 	strlcpy(comm, comm_event->task->comm, sizeof(comm));
@@ -3884,19 +3926,28 @@ static void perf_event_comm_event(struct
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 		perf_event_comm_ctx(&cpuctx->ctx, comm_event);
+
+		ctxn = pmu->task_ctx_nr;
+		if (ctxn < 0)
+			continue;
+
+		ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
+		if (ctx)
+			perf_event_comm_ctx(ctx, comm_event);
 	}
-	ctx = rcu_dereference(current->perf_event_ctxp);
-	if (ctx)
-		perf_event_comm_ctx(ctx, comm_event);
 	rcu_read_unlock_sched();
 }
 
 void perf_event_comm(struct task_struct *task)
 {
 	struct perf_comm_event comm_event;
+	struct perf_event_context *ctx;
 
-	if (task->perf_event_ctxp)
-		perf_event_enable_on_exec(task);
+	for_each_task_context(ctx, task) {
+		if (!ctx)
+			continue;
+		perf_event_enable_on_exec(ctx);
+	}
 
 	if (!atomic_read(&nr_comm_events))
 		return;
@@ -3999,6 +4050,7 @@ static void perf_event_mmap_event(struct
 	char *buf = NULL;
 	const char *name;
 	struct pmu *pmu;
+	int ctxn;
 
 	memset(tmp, 0, sizeof(tmp));
 
@@ -4055,10 +4107,17 @@ static void perf_event_mmap_event(struct
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 		perf_event_mmap_ctx(&cpuctx->ctx, mmap_event,
 					vma->vm_flags & VM_EXEC);
+
+		ctxn = pmu->task_ctx_nr;
+		if (ctxn < 0)
+			continue;
+
+		ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
+		if (ctx) {
+			perf_event_mmap_ctx(ctx, mmap_event,
+					vma->vm_flags & VM_EXEC);
+		}
 	}
-	ctx = rcu_dereference(current->perf_event_ctxp);
-	if (ctx)
-		perf_event_mmap_ctx(ctx, mmap_event, vma->vm_flags & VM_EXEC);
 	rcu_read_unlock_sched();
 
 	kfree(buf);
@@ -5019,6 +5078,40 @@ static void perf_pmu_cancel_txn(struct p
 	perf_pmu_enable(pmu);
 }
 
+/*
+ * Ensures all context's with the same task_ctx_nr have the same
+ * pmu_cpu_context too.
+ */
+static void *find_pmu_context(int ctxn)
+{
+	struct pmu *pmu;
+
+	if (ctxn < 0)
+		return NULL;
+
+	list_for_each_entry(pmu, &pmus, entry) {
+		if (pmu->task_ctx_nr == ctxn)
+			return pmu->pmu_cpu_context;
+	}
+
+	return NULL;
+}
+
+static void free_pmu_context(void * __percpu cpu_context)
+{
+	struct pmu *pmu;
+
+	/*
+	 * Like a real lame refcount.
+	 */
+	list_for_each_entry(pmu, &pmus, entry) {
+		if (pmu->pmu_cpu_context == cpu_context)
+			return;
+	}
+
+	free_percpu(cpu_context);
+}
+
 int perf_pmu_register(struct pmu *pmu)
 {
 	int cpu, ret;
@@ -5029,6 +5122,10 @@ int perf_pmu_register(struct pmu *pmu)
 	if (!pmu->pmu_disable_count)
 		goto unlock;
 
+	pmu->pmu_cpu_context = find_pmu_context(pmu->task_ctx_nr);
+	if (pmu->pmu_cpu_context)
+		goto got_cpu_context;
+
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
 	if (!pmu->pmu_cpu_context)
 		goto free_pdc;
@@ -5044,6 +5141,7 @@ int perf_pmu_register(struct pmu *pmu)
 		cpuctx->timer.function = perf_event_context_tick;
 	}
 
+got_cpu_context:
 	if (!pmu->start_txn) {
 		if (pmu->pmu_enable) {
 			/*
@@ -5094,7 +5192,7 @@ void perf_pmu_unregister(struct pmu *pmu
 	synchronize_srcu(&pmus_srcu);
 
 	free_percpu(pmu->pmu_disable_count);
-	free_percpu(pmu->pmu_cpu_context);
+	free_pmu_context(pmu->pmu_cpu_context);
 }
 
 struct pmu *perf_init_event(struct perf_event *event)
@@ -5608,16 +5706,13 @@ __perf_event_exit_task(struct perf_event
 	}
 }
 
-/*
- * When a child task exits, feed back event values to parent events.
- */
-void perf_event_exit_task(struct task_struct *child)
+static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
 	struct perf_event *child_event, *tmp;
 	struct perf_event_context *child_ctx;
 	unsigned long flags;
 
-	if (likely(!child->perf_event_ctxp)) {
+	if (likely(!child->perf_event_ctxp[ctxn])) {
 		perf_event_task(child, NULL, 0);
 		return;
 	}
@@ -5629,7 +5724,7 @@ void perf_event_exit_task(struct task_st
 	 * scheduled, so we are now safe from rescheduling changing
 	 * our context.
 	 */
-	child_ctx = child->perf_event_ctxp;
+	child_ctx = child->perf_event_ctxp[ctxn];
 	__perf_event_task_sched_out(child_ctx);
 
 	/*
@@ -5638,7 +5733,7 @@ void perf_event_exit_task(struct task_st
 	 * incremented the context's refcount before we do put_ctx below.
 	 */
 	raw_spin_lock(&child_ctx->lock);
-	child->perf_event_ctxp = NULL;
+	child->perf_event_ctxp[ctxn] = NULL;
 	/*
 	 * If this context is a clone; unclone it so it can't get
 	 * swapped to another process while we're removing all
@@ -5691,6 +5786,17 @@ void perf_event_exit_task(struct task_st
 	put_ctx(child_ctx);
 }
 
+/*
+ * When a child task exits, feed back event values to parent events.
+ */
+void perf_event_exit_task(struct task_struct *child)
+{
+	int ctxn;
+
+	for_each_task_context_nr(ctxn)
+		perf_event_exit_task_context(child, ctxn);
+}
+
 static void perf_free_event(struct perf_event *event,
 			    struct perf_event_context *ctx)
 {
@@ -5712,32 +5818,35 @@ static void perf_free_event(struct perf_
 
 /*
  * free an unexposed, unused context as created by inheritance by
- * init_task below, used by fork() in case of fail.
+ * perf_event_init_task below, used by fork() in case of fail.
  */
 void perf_event_free_task(struct task_struct *task)
 {
-	struct perf_event_context *ctx = task->perf_event_ctxp;
+	struct perf_event_context *ctx;
 	struct perf_event *event, *tmp;
 
-	if (!ctx)
-		return;
+	for_each_task_context(ctx, task) {
+		if (!ctx)
+			continue;
 
-	mutex_lock(&ctx->mutex);
+		mutex_lock(&ctx->mutex);
 again:
-	list_for_each_entry_safe(event, tmp, &ctx->pinned_groups, group_entry)
-		perf_free_event(event, ctx);
+		list_for_each_entry_safe(event, tmp, &ctx->pinned_groups,
+				group_entry)
+			perf_free_event(event, ctx);
+
+		list_for_each_entry_safe(event, tmp, &ctx->flexible_groups,
+				group_entry)
+			perf_free_event(event, ctx);
+
+		if (!list_empty(&ctx->pinned_groups) ||
+				!list_empty(&ctx->flexible_groups))
+			goto again;
 
-	list_for_each_entry_safe(event, tmp, &ctx->flexible_groups,
-				 group_entry)
-		perf_free_event(event, ctx);
-
-	if (!list_empty(&ctx->pinned_groups) ||
-	    !list_empty(&ctx->flexible_groups))
-		goto again;
-
-	mutex_unlock(&ctx->mutex);
+		mutex_unlock(&ctx->mutex);
 
-	put_ctx(ctx);
+		put_ctx(ctx);
+	}
 }
 
 /*
@@ -5843,17 +5952,18 @@ static int inherit_group(struct perf_eve
 static int
 inherit_task_group(struct perf_event *event, struct task_struct *parent,
 		   struct perf_event_context *parent_ctx,
-		   struct task_struct *child,
+		   struct task_struct *child, int ctxn,
 		   int *inherited_all)
 {
 	int ret;
-	struct perf_event_context *child_ctx = child->perf_event_ctxp;
+	struct perf_event_context *child_ctx;
 
 	if (!event->attr.inherit) {
 		*inherited_all = 0;
 		return 0;
 	}
 
+       	child_ctx = child->perf_event_ctxp[ctxn];
 	if (!child_ctx) {
 		/*
 		 * This is executed from the parent task context, so
@@ -5866,7 +5976,7 @@ inherit_task_group(struct perf_event *ev
 		if (!child_ctx)
 			return -ENOMEM;
 
-		child->perf_event_ctxp = child_ctx;
+		child->perf_event_ctxp[ctxn] = child_ctx;
 	}
 
 	ret = inherit_group(event, parent, parent_ctx,
@@ -5881,7 +5991,7 @@ inherit_task_group(struct perf_event *ev
 /*
  * Initialize the perf_event context in task_struct
  */
-int perf_event_init_task(struct task_struct *child)
+int perf_event_init_context(struct task_struct *child, int ctxn)
 {
 	struct perf_event_context *child_ctx, *parent_ctx;
 	struct perf_event_context *cloned_ctx;
@@ -5890,19 +6000,19 @@ int perf_event_init_task(struct task_str
 	int inherited_all = 1;
 	int ret = 0;
 
-	child->perf_event_ctxp = NULL;
+	child->perf_event_ctxp[ctxn] = NULL;
 
 	mutex_init(&child->perf_event_mutex);
 	INIT_LIST_HEAD(&child->perf_event_list);
 
-	if (likely(!parent->perf_event_ctxp))
+	if (likely(!parent->perf_event_ctxp[ctxn]))
 		return 0;
 
 	/*
 	 * If the parent's context is a clone, pin it so it won't get
 	 * swapped under us.
 	 */
-	parent_ctx = perf_pin_task_context(parent);
+	parent_ctx = perf_pin_task_context(parent, ctxn);
 
 	/*
 	 * No need to check if parent_ctx != NULL here; since we saw
@@ -5922,20 +6032,20 @@ int perf_event_init_task(struct task_str
 	 * the list, not manipulating it:
 	 */
 	list_for_each_entry(event, &parent_ctx->pinned_groups, group_entry) {
-		ret = inherit_task_group(event, parent, parent_ctx, child,
-					 &inherited_all);
+		ret = inherit_task_group(event, parent, parent_ctx,
+					 child, ctxn, &inherited_all);
 		if (ret)
 			break;
 	}
 
 	list_for_each_entry(event, &parent_ctx->flexible_groups, group_entry) {
-		ret = inherit_task_group(event, parent, parent_ctx, child,
-					 &inherited_all);
+		ret = inherit_task_group(event, parent, parent_ctx,
+					 child, ctxn, &inherited_all);
 		if (ret)
 			break;
 	}
 
-	child_ctx = child->perf_event_ctxp;
+	child_ctx = child->perf_event_ctxp[ctxn];
 
 	if (child_ctx && inherited_all) {
 		/*
@@ -5964,6 +6074,22 @@ int perf_event_init_task(struct task_str
 	return ret;
 }
 
+/*
+ * Initialize the perf_event context in task_struct
+ */
+int perf_event_init_task(struct task_struct *child)
+{
+	int ctxn, ret;
+
+	for_each_task_context_nr(ctxn) {
+		ret = perf_event_init_context(child, ctxn);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static void __init perf_event_init_all_cpus(void)
 {
 	struct swevent_htable *swhash;
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -572,6 +572,7 @@ struct pmu {
 
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
+	int				task_ctx_nr;
 
 	/*
 	 * Fully disable/enable this PMU, can be used to protect from the PMI


