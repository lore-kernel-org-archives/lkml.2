Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0IITxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:53:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:54399 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab0IITxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:53:30 -0400
Date: Thu, 9 Sep 2010 19:52:56 GMT
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
Subject: [tip:perf/core] perf: Multiple task contexts
Message-ID: <tip-8dc85d547285668e509f86c177bcd4ea055bcaaf@git.kernel.org>
Git-Commit-ID: 8dc85d547285668e509f86c177bcd4ea055bcaaf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:52:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8dc85d547285668e509f86c177bcd4ea055bcaaf
Gitweb:     http://git.kernel.org/tip/8dc85d547285668e509f86c177bcd4ea055bcaaf
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 2 Sep 2010 16:50:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:33 +0200

perf: Multiple task contexts

Provide the infrastructure for multiple task contexts.

A more flexible approach would have resulted in more pointer chases
in the scheduling hot-paths. This approach has the limitation of a
static number of task contexts.

Since I expect most external PMUs to be system wide, or at least node
wide (as per the intel uncore unit) they won't actually need a task
context.

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
 include/linux/perf_event.h |    1 +
 include/linux/sched.h      |    8 +-
 kernel/perf_event.c        |  336 ++++++++++++++++++++++++++++++--------------
 3 files changed, 239 insertions(+), 106 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 22155ef..9ecfd85 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -572,6 +572,7 @@ struct pmu {
 
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
+	int				task_ctx_nr;
 
 	/*
 	 * Fully disable/enable this PMU, can be used to protect from the PMI
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1e2a6db..89d6023 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1160,6 +1160,12 @@ struct sched_rt_entity {
 
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
@@ -1431,7 +1437,7 @@ struct task_struct {
 	struct futex_pi_state *pi_state_cache;
 #endif
 #ifdef CONFIG_PERF_EVENTS
-	struct perf_event_context *perf_event_ctxp;
+	struct perf_event_context *perf_event_ctxp[perf_nr_task_contexts];
 	struct mutex perf_event_mutex;
 	struct list_head perf_event_list;
 #endif
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 13d98d7..7223ea8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -148,13 +148,13 @@ static u64 primary_event_id(struct perf_event *event)
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
@@ -167,7 +167,7 @@ retry:
 		 * can't get swapped on us any more.
 		 */
 		raw_spin_lock_irqsave(&ctx->lock, *flags);
-		if (ctx != rcu_dereference(task->perf_event_ctxp)) {
+		if (ctx != rcu_dereference(task->perf_event_ctxp[ctxn])) {
 			raw_spin_unlock_irqrestore(&ctx->lock, *flags);
 			goto retry;
 		}
@@ -186,12 +186,13 @@ retry:
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
@@ -1179,28 +1180,15 @@ static void perf_event_sync_stat(struct perf_event_context *ctx,
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
+	struct perf_event_context *ctx = task->perf_event_ctxp[ctxn];
 	struct perf_event_context *next_ctx;
 	struct perf_event_context *parent;
 	struct perf_cpu_context *cpuctx;
 	int do_switch = 1;
 
-	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
-
 	if (likely(!ctx))
 		return;
 
@@ -1210,7 +1198,7 @@ void perf_event_task_sched_out(struct task_struct *task,
 
 	rcu_read_lock();
 	parent = rcu_dereference(ctx->parent_ctx);
-	next_ctx = next->perf_event_ctxp;
+	next_ctx = next->perf_event_ctxp[ctxn];
 	if (parent && next_ctx &&
 	    rcu_dereference(next_ctx->parent_ctx) == parent) {
 		/*
@@ -1229,8 +1217,8 @@ void perf_event_task_sched_out(struct task_struct *task,
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
@@ -1248,6 +1236,31 @@ void perf_event_task_sched_out(struct task_struct *task,
 	}
 }
 
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
@@ -1366,38 +1379,23 @@ static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
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
+
+void perf_event_context_sched_in(struct perf_event_context *ctx)
 {
-	struct perf_event_context *ctx = task->perf_event_ctxp;
 	struct perf_cpu_context *cpuctx;
 
-	if (likely(!ctx))
-		return;
-
 	cpuctx = __get_cpu_context(ctx);
 	if (cpuctx->task_ctx == ctx)
 		return;
@@ -1422,6 +1420,31 @@ void perf_event_task_sched_in(struct task_struct *task)
 	perf_pmu_rotate_start(ctx->pmu);
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
+	int ctxn;
+
+	for_each_task_context_nr(ctxn) {
+		ctx = task->perf_event_ctxp[ctxn];
+		if (likely(!ctx))
+			continue;
+
+		perf_event_context_sched_in(ctx);
+	}
+}
+
 #define MAX_INTERRUPTS (~0ULL)
 
 static void perf_log_throttle(struct perf_event *event, int enable);
@@ -1588,7 +1611,7 @@ static enum hrtimer_restart perf_event_context_tick(struct hrtimer *timer)
 {
 	enum hrtimer_restart restart = HRTIMER_NORESTART;
 	struct perf_cpu_context *cpuctx;
-	struct perf_event_context *ctx;
+	struct perf_event_context *ctx = NULL;
 	int rotate = 0;
 
 	cpuctx = container_of(timer, struct perf_cpu_context, timer);
@@ -1599,7 +1622,7 @@ static enum hrtimer_restart perf_event_context_tick(struct hrtimer *timer)
 			rotate = 1;
 	}
 
-	ctx = current->perf_event_ctxp;
+	ctx = cpuctx->task_ctx;
 	if (ctx && ctx->nr_events) {
 		restart = HRTIMER_RESTART;
 		if (ctx->nr_events != ctx->nr_active)
@@ -1623,7 +1646,7 @@ static enum hrtimer_restart perf_event_context_tick(struct hrtimer *timer)
 
 	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
-		task_ctx_sched_in(current, EVENT_FLEXIBLE);
+		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
 
 done:
 	hrtimer_forward_now(timer, ns_to_ktime(cpuctx->timer_interval));
@@ -1650,20 +1673,18 @@ static int event_enable_on_exec(struct perf_event *event,
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
 
@@ -1687,7 +1708,7 @@ static void perf_event_enable_on_exec(struct task_struct *task)
 
 	raw_spin_unlock(&ctx->lock);
 
-	perf_event_task_sched_in(task);
+	perf_event_context_sched_in(ctx);
 out:
 	local_irq_restore(flags);
 }
@@ -1995,7 +2016,7 @@ find_get_context(struct pmu *pmu, pid_t pid, int cpu)
 	struct perf_cpu_context *cpuctx;
 	struct task_struct *task;
 	unsigned long flags;
-	int err;
+	int ctxn, err;
 
 	if (pid == -1 && cpu != -1) {
 		/* Must be root to operate on a CPU event: */
@@ -2044,8 +2065,13 @@ find_get_context(struct pmu *pmu, pid_t pid, int cpu)
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
@@ -2059,7 +2085,7 @@ retry:
 
 		get_ctx(ctx);
 
-		if (cmpxchg(&task->perf_event_ctxp, NULL, ctx)) {
+		if (cmpxchg(&task->perf_event_ctxp[ctxn], NULL, ctx)) {
 			/*
 			 * We raced with some other task; use
 			 * the context they set.
@@ -3773,19 +3799,26 @@ static void perf_event_task_ctx(struct perf_event_context *ctx,
 
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
 
@@ -3890,9 +3923,10 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
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
@@ -3907,19 +3941,31 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
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
+	int ctxn;
 
-	if (task->perf_event_ctxp)
-		perf_event_enable_on_exec(task);
+	for_each_task_context_nr(ctxn) {
+		ctx = task->perf_event_ctxp[ctxn];
+		if (!ctx)
+			continue;
+
+		perf_event_enable_on_exec(ctx);
+	}
 
 	if (!atomic_read(&nr_comm_events))
 		return;
@@ -4022,6 +4068,7 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	char *buf = NULL;
 	const char *name;
 	struct pmu *pmu;
+	int ctxn;
 
 	memset(tmp, 0, sizeof(tmp));
 
@@ -4078,10 +4125,17 @@ got_name:
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
@@ -5042,6 +5096,43 @@ static void perf_pmu_cancel_txn(struct pmu *pmu)
 	perf_pmu_enable(pmu);
 }
 
+/*
+ * Ensures all contexts with the same task_ctx_nr have the same
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
+	mutex_lock(&pmus_lock);
+	/*
+	 * Like a real lame refcount.
+	 */
+	list_for_each_entry(pmu, &pmus, entry) {
+		if (pmu->pmu_cpu_context == cpu_context)
+			goto out;
+	}
+
+	free_percpu(cpu_context);
+out:
+	mutex_unlock(&pmus_lock);
+}
+
 int perf_pmu_register(struct pmu *pmu)
 {
 	int cpu, ret;
@@ -5052,6 +5143,10 @@ int perf_pmu_register(struct pmu *pmu)
 	if (!pmu->pmu_disable_count)
 		goto unlock;
 
+	pmu->pmu_cpu_context = find_pmu_context(pmu->task_ctx_nr);
+	if (pmu->pmu_cpu_context)
+		goto got_cpu_context;
+
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
 	if (!pmu->pmu_cpu_context)
 		goto free_pdc;
@@ -5067,6 +5162,7 @@ int perf_pmu_register(struct pmu *pmu)
 		cpuctx->timer.function = perf_event_context_tick;
 	}
 
+got_cpu_context:
 	if (!pmu->start_txn) {
 		if (pmu->pmu_enable) {
 			/*
@@ -5114,7 +5210,7 @@ void perf_pmu_unregister(struct pmu *pmu)
 	synchronize_srcu(&pmus_srcu);
 
 	free_percpu(pmu->pmu_disable_count);
-	free_percpu(pmu->pmu_cpu_context);
+	free_pmu_context(pmu->pmu_cpu_context);
 }
 
 struct pmu *perf_init_event(struct perf_event *event)
@@ -5628,16 +5724,13 @@ __perf_event_exit_task(struct perf_event *child_event,
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
@@ -5649,7 +5742,7 @@ void perf_event_exit_task(struct task_struct *child)
 	 * scheduled, so we are now safe from rescheduling changing
 	 * our context.
 	 */
-	child_ctx = child->perf_event_ctxp;
+	child_ctx = child->perf_event_ctxp[ctxn];
 	__perf_event_task_sched_out(child_ctx);
 
 	/*
@@ -5658,7 +5751,7 @@ void perf_event_exit_task(struct task_struct *child)
 	 * incremented the context's refcount before we do put_ctx below.
 	 */
 	raw_spin_lock(&child_ctx->lock);
-	child->perf_event_ctxp = NULL;
+	child->perf_event_ctxp[ctxn] = NULL;
 	/*
 	 * If this context is a clone; unclone it so it can't get
 	 * swapped to another process while we're removing all
@@ -5711,6 +5804,17 @@ again:
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
@@ -5732,32 +5836,37 @@ static void perf_free_event(struct perf_event *event,
 
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
+	int ctxn;
 
-	if (!ctx)
-		return;
+	for_each_task_context_nr(ctxn) {
+		ctx = task->perf_event_ctxp[ctxn];
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
 
-	list_for_each_entry_safe(event, tmp, &ctx->flexible_groups,
-				 group_entry)
-		perf_free_event(event, ctx);
+		list_for_each_entry_safe(event, tmp, &ctx->flexible_groups,
+				group_entry)
+			perf_free_event(event, ctx);
 
-	if (!list_empty(&ctx->pinned_groups) ||
-	    !list_empty(&ctx->flexible_groups))
-		goto again;
+		if (!list_empty(&ctx->pinned_groups) ||
+				!list_empty(&ctx->flexible_groups))
+			goto again;
 
-	mutex_unlock(&ctx->mutex);
+		mutex_unlock(&ctx->mutex);
 
-	put_ctx(ctx);
+		put_ctx(ctx);
+	}
 }
 
 /*
@@ -5863,17 +5972,18 @@ static int inherit_group(struct perf_event *parent_event,
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
@@ -5886,7 +5996,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 		if (!child_ctx)
 			return -ENOMEM;
 
-		child->perf_event_ctxp = child_ctx;
+		child->perf_event_ctxp[ctxn] = child_ctx;
 	}
 
 	ret = inherit_group(event, parent, parent_ctx,
@@ -5901,7 +6011,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 /*
  * Initialize the perf_event context in task_struct
  */
-int perf_event_init_task(struct task_struct *child)
+int perf_event_init_context(struct task_struct *child, int ctxn)
 {
 	struct perf_event_context *child_ctx, *parent_ctx;
 	struct perf_event_context *cloned_ctx;
@@ -5910,19 +6020,19 @@ int perf_event_init_task(struct task_struct *child)
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
@@ -5942,20 +6052,20 @@ int perf_event_init_task(struct task_struct *child)
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
@@ -5984,6 +6094,22 @@ int perf_event_init_task(struct task_struct *child)
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
