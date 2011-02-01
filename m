Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab1BAODI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:03:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:59813 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872Ab1BAODG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:03:06 -0500
Subject: [PATCH] perf: Cure task_oncpu_function_call() races
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1296502154.26581.72.camel@laptop>
References: <1296134077.15234.161.camel@laptop>
	 <20110127165712.GC25060@redhat.com> <1296148294.15234.242.camel@laptop>
	 <20110127221856.GA10539@redhat.com> <1296215577.15234.333.camel@laptop>
	 <1296226667.15234.337.camel@laptop> <20110128162847.GA25088@redhat.com>
	 <1296238278.15234.340.camel@laptop> <20110131172626.GA5407@redhat.com>
	 <1296498205.26581.54.camel@laptop>  <20110131191109.GA10906@redhat.com>
	 <1296502154.26581.72.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 15:03:57 +0100
Message-ID: <1296569037.26581.194.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oleg, I've actually run-tested the below and all seems well (clearly
I've never actually hit the races found before either, so in that
respect its not a conclusive test).

Can you agree with this patch?

---
Oleg reported that on architectures with
__ARCH_WANT_INTERRUPTS_ON_CTXSW the IPI from task_oncpu_function_call()
can land before perf_event_task_sched_in() and cause interesting
situations for eg. perf_install_in_context().

This patch reworks the task_oncpu_function_call() interface to give a
more usable primitive as well as rework all its users to hopefully be
more obvious as well as remove the races.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    7 --
 kernel/perf_event.c   |  240 +++++++++++++++++++++++++++++++------------------
 kernel/sched.c        |   29 +-----
 3 files changed, 157 insertions(+), 119 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3294f60..57ad0f9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2575,13 +2575,6 @@ static inline void inc_syscw(struct task_struct *tsk)
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
-/*
- * Call the function if the target task is executing on a CPU right now:
- */
-extern void task_oncpu_function_call(struct task_struct *p,
-				     void (*func) (void *info), void *info);
-
-
 #ifdef CONFIG_MM_OWNER
 extern void mm_update_next_owner(struct mm_struct *mm);
 extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 852ae8c..b81f31f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -38,6 +38,79 @@
 
 #include <asm/irq_regs.h>
 
+struct remote_function_call {
+	struct task_struct *p;
+	int (*func)(void *info);
+	void *info;
+	int ret;
+};
+
+static void remote_function(void *data)
+{
+	struct remote_function_call *tfc = data;
+	struct task_struct *p = tfc->p;
+
+	if (p) {
+		tfc->ret = -EAGAIN;
+		if (task_cpu(p) != smp_processor_id() || !task_curr(p))
+			return;
+	}
+
+	tfc->ret = tfc->func(tfc->info);
+}
+
+/**
+ * task_function_call - call a function on the cpu on which a task runs
+ * @p:		the task to evaluate
+ * @func:	the function to be called
+ * @info:	the function call argument
+ *
+ * Calls the function @func when the task is currently running. This might
+ * be on the current CPU, which just calls the function directly
+ *
+ * returns: @func return value, or
+ * 	    -ESRCH  - when the process isn't running
+ * 	    -EAGAIN - when the process moved away
+ */
+static int
+task_function_call(struct task_struct *p, int (*func) (void *info), void *info)
+{
+	struct remote_function_call data = {
+		.p = p,
+		.func = func,
+		.info = info,
+		.ret = -ESRCH, /* No such (running) process */
+	};
+
+	if (task_curr(p))
+		smp_call_function_single(task_cpu(p), remote_function, &data, 1);
+
+	return data.ret;
+}
+
+/**
+ * cpu_function_call - call a function on the cpu
+ * @func:	the function to be called
+ * @info:	the function call argument
+ *
+ * Calls the function @func on the remote cpu.
+ *
+ * returns: @func return value or -ENXIO when the cpu is offline
+ */
+static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
+{
+	struct remote_function_call data = {
+		.p = NULL,
+		.func = func,
+		.info = info,
+		.ret = -ENXIO, /* No such CPU */
+	};
+
+	smp_call_function_single(cpu, remote_function, &data, 1);
+
+	return data.ret;
+}
+
 enum event_type_t {
 	EVENT_FLEXIBLE = 0x1,
 	EVENT_PINNED = 0x2,
@@ -618,35 +691,24 @@ __get_cpu_context(struct perf_event_context *ctx)
  * We disable the event on the hardware level first. After that we
  * remove it from the context list.
  */
-static void __perf_event_remove_from_context(void *info)
+static int __perf_remove_from_context(void *info)
 {
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
-	/*
-	 * If this is a task context, we need to check whether it is
-	 * the current task context of this cpu. If not it has been
-	 * scheduled out before the smp call arrived.
-	 */
-	if (ctx->task && cpuctx->task_ctx != ctx)
-		return;
-
 	raw_spin_lock(&ctx->lock);
-
 	event_sched_out(event, cpuctx, ctx);
-
 	list_del_event(event, ctx);
-
 	raw_spin_unlock(&ctx->lock);
+
+	return 0;
 }
 
 
 /*
  * Remove the event from a task's (or a CPU's) list of events.
  *
- * Must be called with ctx->mutex held.
- *
  * CPU events are removed with a smp call. For task events we only
  * call when the task is on a CPU.
  *
@@ -657,49 +719,48 @@ static void __perf_event_remove_from_context(void *info)
  * When called from perf_event_exit_task, it's OK because the
  * context has been detached from its task.
  */
-static void perf_event_remove_from_context(struct perf_event *event)
+static void perf_remove_from_context(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
 
+	lockdep_assert_held(&ctx->mutex);
+
 	if (!task) {
 		/*
 		 * Per cpu events are removed via an smp call and
 		 * the removal is always successful.
 		 */
-		smp_call_function_single(event->cpu,
-					 __perf_event_remove_from_context,
-					 event, 1);
+		cpu_function_call(event->cpu, __perf_remove_from_context, event);
 		return;
 	}
 
 retry:
-	task_oncpu_function_call(task, __perf_event_remove_from_context,
-				 event);
+	if (!task_function_call(task, __perf_remove_from_context, event))
+		return;
 
 	raw_spin_lock_irq(&ctx->lock);
 	/*
-	 * If the context is active we need to retry the smp call.
+	 * If we failed to find a running task, but find it running now that
+	 * we've acquired the ctx->lock, retry.
 	 */
-	if (ctx->nr_active && !list_empty(&event->group_entry)) {
+	if (task_curr(task)) {
 		raw_spin_unlock_irq(&ctx->lock);
 		goto retry;
 	}
 
 	/*
-	 * The lock prevents that this context is scheduled in so we
-	 * can remove the event safely, if the call above did not
-	 * succeed.
+	 * Since the task isn't running, its safe to remove the event, us
+	 * holding the ctx->lock ensures the task won't get scheduled in.
 	 */
-	if (!list_empty(&event->group_entry))
-		list_del_event(event, ctx);
+	list_del_event(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
 /*
  * Cross CPU call to disable a performance event
  */
-static void __perf_event_disable(void *info)
+static int __perf_event_disable(void *info)
 {
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
@@ -708,9 +769,12 @@ static void __perf_event_disable(void *info)
 	/*
 	 * If this is a per-task event, need to check whether this
 	 * event's task is the current task on this cpu.
+	 *
+	 * Can trigger due to concurrent perf_event_context_sched_out()
+	 * flipping contexts around.
 	 */
 	if (ctx->task && cpuctx->task_ctx != ctx)
-		return;
+		return -EINVAL;
 
 	raw_spin_lock(&ctx->lock);
 
@@ -729,6 +793,8 @@ static void __perf_event_disable(void *info)
 	}
 
 	raw_spin_unlock(&ctx->lock);
+
+	return 0;
 }
 
 /*
@@ -753,13 +819,13 @@ void perf_event_disable(struct perf_event *event)
 		/*
 		 * Disable the event on the cpu that it's on
 		 */
-		smp_call_function_single(event->cpu, __perf_event_disable,
-					 event, 1);
+		cpu_function_call(event->cpu, __perf_event_disable, event);
 		return;
 	}
 
 retry:
-	task_oncpu_function_call(task, __perf_event_disable, event);
+	if (!task_function_call(task, __perf_event_disable, event))
+		return;
 
 	raw_spin_lock_irq(&ctx->lock);
 	/*
@@ -767,6 +833,11 @@ retry:
 	 */
 	if (event->state == PERF_EVENT_STATE_ACTIVE) {
 		raw_spin_unlock_irq(&ctx->lock);
+		/*
+		 * Reload the task pointer, it might have been changed by
+		 * a concurrent perf_event_context_sched_out().
+		 */
+		task = ctx->task;
 		goto retry;
 	}
 
@@ -778,7 +849,6 @@ retry:
 		update_group_times(event);
 		event->state = PERF_EVENT_STATE_OFF;
 	}
-
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
@@ -928,12 +998,14 @@ static void add_event_to_ctx(struct perf_event *event,
 	event->tstamp_stopped = tstamp;
 }
 
+static void perf_event_context_sched_in(struct perf_event_context *ctx);
+
 /*
  * Cross CPU call to install and enable a performance event
  *
  * Must be called with ctx->mutex held
  */
-static void __perf_install_in_context(void *info)
+static int  __perf_install_in_context(void *info)
 {
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
@@ -942,17 +1014,12 @@ static void __perf_install_in_context(void *info)
 	int err;
 
 	/*
-	 * If this is a task context, we need to check whether it is
-	 * the current task context of this cpu. If not it has been
-	 * scheduled out before the smp call arrived.
-	 * Or possibly this is the right context but it isn't
-	 * on this cpu because it had no events.
+	 * In case we're installing a new context to an already running task,
+	 * could also happen before perf_event_task_sched_in() on architectures
+	 * which do context switches with IRQs enabled.
 	 */
-	if (ctx->task && cpuctx->task_ctx != ctx) {
-		if (cpuctx->task_ctx || ctx->task != current)
-			return;
-		cpuctx->task_ctx = ctx;
-	}
+	if (ctx->task && !cpuctx->task_ctx)
+		perf_event_context_sched_in(ctx);
 
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
@@ -997,6 +1064,8 @@ static void __perf_install_in_context(void *info)
 
 unlock:
 	raw_spin_unlock(&ctx->lock);
+
+	return 0;
 }
 
 /*
@@ -1008,8 +1077,6 @@ unlock:
  * If the event is attached to a task which is on a CPU we use a smp
  * call to enable it in the task context. The task might have been
  * scheduled away, but we check this in the smp call again.
- *
- * Must be called with ctx->mutex held.
  */
 static void
 perf_install_in_context(struct perf_event_context *ctx,
@@ -1018,6 +1085,8 @@ perf_install_in_context(struct perf_event_context *ctx,
 {
 	struct task_struct *task = ctx->task;
 
+	lockdep_assert_held(&ctx->mutex);
+
 	event->ctx = ctx;
 
 	if (!task) {
@@ -1025,31 +1094,29 @@ perf_install_in_context(struct perf_event_context *ctx,
 		 * Per cpu events are installed via an smp call and
 		 * the install is always successful.
 		 */
-		smp_call_function_single(cpu, __perf_install_in_context,
-					 event, 1);
+		cpu_function_call(cpu, __perf_install_in_context, event);
 		return;
 	}
 
 retry:
-	task_oncpu_function_call(task, __perf_install_in_context,
-				 event);
+	if (!task_function_call(task, __perf_install_in_context, event))
+		return;
 
 	raw_spin_lock_irq(&ctx->lock);
 	/*
-	 * we need to retry the smp call.
+	 * If we failed to find a running task, but find it running now that
+	 * we've acquired the ctx->lock, retry.
 	 */
-	if (ctx->is_active && list_empty(&event->group_entry)) {
+	if (task_curr(task)) {
 		raw_spin_unlock_irq(&ctx->lock);
 		goto retry;
 	}
 
 	/*
-	 * The lock prevents that this context is scheduled in so we
-	 * can add the event safely, if it the call above did not
-	 * succeed.
+	 * Since the task isn't running, its safe to add the event, us holding
+	 * the ctx->lock ensures the task won't get scheduled in.
 	 */
-	if (list_empty(&event->group_entry))
-		add_event_to_ctx(event, ctx);
+	add_event_to_ctx(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
@@ -1078,7 +1145,7 @@ static void __perf_event_mark_enabled(struct perf_event *event,
 /*
  * Cross CPU call to enable a performance event
  */
-static void __perf_event_enable(void *info)
+static int __perf_event_enable(void *info)
 {
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
@@ -1086,18 +1153,10 @@ static void __perf_event_enable(void *info)
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 	int err;
 
-	/*
-	 * If this is a per-task event, need to check whether this
-	 * event's task is the current task on this cpu.
-	 */
-	if (ctx->task && cpuctx->task_ctx != ctx) {
-		if (cpuctx->task_ctx || ctx->task != current)
-			return;
-		cpuctx->task_ctx = ctx;
-	}
+	if (WARN_ON_ONCE(!ctx->is_active))
+		return -EINVAL;
 
 	raw_spin_lock(&ctx->lock);
-	ctx->is_active = 1;
 	update_context_time(ctx);
 
 	if (event->state >= PERF_EVENT_STATE_INACTIVE)
@@ -1138,6 +1197,8 @@ static void __perf_event_enable(void *info)
 
 unlock:
 	raw_spin_unlock(&ctx->lock);
+
+	return 0;
 }
 
 /*
@@ -1158,8 +1219,7 @@ void perf_event_enable(struct perf_event *event)
 		/*
 		 * Enable the event on the cpu that it's on
 		 */
-		smp_call_function_single(event->cpu, __perf_event_enable,
-					 event, 1);
+		cpu_function_call(event->cpu, __perf_event_enable, event);
 		return;
 	}
 
@@ -1178,8 +1238,15 @@ void perf_event_enable(struct perf_event *event)
 		event->state = PERF_EVENT_STATE_OFF;
 
 retry:
+	if (!ctx->is_active) {
+		__perf_event_mark_enabled(event, ctx);
+		goto out;
+	}
+
 	raw_spin_unlock_irq(&ctx->lock);
-	task_oncpu_function_call(task, __perf_event_enable, event);
+
+	if (!task_function_call(task, __perf_event_enable, event))
+		return;
 
 	raw_spin_lock_irq(&ctx->lock);
 
@@ -1187,15 +1254,14 @@ retry:
 	 * If the context is active and the event is still off,
 	 * we need to retry the cross-call.
 	 */
-	if (ctx->is_active && event->state == PERF_EVENT_STATE_OFF)
+	if (ctx->is_active && event->state == PERF_EVENT_STATE_OFF) {
+		/*
+		 * task could have been flipped by a concurrent
+		 * perf_event_context_sched_out()
+		 */
+		task = ctx->task;
 		goto retry;
-
-	/*
-	 * Since we have the lock this context can't be scheduled
-	 * in, so we can change the state safely.
-	 */
-	if (event->state == PERF_EVENT_STATE_OFF)
-		__perf_event_mark_enabled(event, ctx);
+	}
 
 out:
 	raw_spin_unlock_irq(&ctx->lock);
@@ -1339,8 +1405,8 @@ static void perf_event_sync_stat(struct perf_event_context *ctx,
 	}
 }
 
-void perf_event_context_sched_out(struct task_struct *task, int ctxn,
-				  struct task_struct *next)
+static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
+					 struct task_struct *next)
 {
 	struct perf_event_context *ctx = task->perf_event_ctxp[ctxn];
 	struct perf_event_context *next_ctx;
@@ -1541,7 +1607,7 @@ static void task_ctx_sched_in(struct perf_event_context *ctx,
 	cpuctx->task_ctx = ctx;
 }
 
-void perf_event_context_sched_in(struct perf_event_context *ctx)
+static void perf_event_context_sched_in(struct perf_event_context *ctx)
 {
 	struct perf_cpu_context *cpuctx;
 
@@ -5949,10 +6015,10 @@ SYSCALL_DEFINE5(perf_event_open,
 		struct perf_event_context *gctx = group_leader->ctx;
 
 		mutex_lock(&gctx->mutex);
-		perf_event_remove_from_context(group_leader);
+		perf_remove_from_context(group_leader);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
-			perf_event_remove_from_context(sibling);
+			perf_remove_from_context(sibling);
 			put_ctx(gctx);
 		}
 		mutex_unlock(&gctx->mutex);
@@ -6103,7 +6169,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 {
 	struct perf_event *parent_event;
 
-	perf_event_remove_from_context(child_event);
+	perf_remove_from_context(child_event);
 
 	parent_event = child_event->parent;
 	/*
@@ -6594,9 +6660,9 @@ static void __perf_event_exit_context(void *__info)
 	perf_pmu_rotate_stop(ctx->pmu);
 
 	list_for_each_entry_safe(event, tmp, &ctx->pinned_groups, group_entry)
-		__perf_event_remove_from_context(event);
+		__perf_remove_from_context(event);
 	list_for_each_entry_safe(event, tmp, &ctx->flexible_groups, group_entry)
-		__perf_event_remove_from_context(event);
+		__perf_remove_from_context(event);
 }
 
 static void perf_event_exit_cpu_context(int cpu)
diff --git a/kernel/sched.c b/kernel/sched.c
index 477e1bc..6daa737 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2297,27 +2297,6 @@ void kick_process(struct task_struct *p)
 EXPORT_SYMBOL_GPL(kick_process);
 #endif /* CONFIG_SMP */
 
-/**
- * task_oncpu_function_call - call a function on the cpu on which a task runs
- * @p:		the task to evaluate
- * @func:	the function to be called
- * @info:	the function call argument
- *
- * Calls the function @func when the task is currently running. This might
- * be on the current CPU, which just calls the function directly
- */
-void task_oncpu_function_call(struct task_struct *p,
-			      void (*func) (void *info), void *info)
-{
-	int cpu;
-
-	preempt_disable();
-	cpu = task_cpu(p);
-	if (task_curr(p))
-		smp_call_function_single(cpu, func, info, 1);
-	preempt_enable();
-}
-
 #ifdef CONFIG_SMP
 /*
  * ->cpus_allowed is protected by either TASK_WAKING or rq->lock held.
@@ -2809,9 +2788,12 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
+	sched_info_switch(prev, next);
+	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
+	trace_sched_switch(prev, next);
 }
 
 /**
@@ -2944,7 +2926,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	trace_sched_switch(prev, next);
+
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
@@ -4116,9 +4098,6 @@ need_resched_nonpreemptible:
 	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
-		sched_info_switch(prev, next);
-		perf_event_task_sched_out(prev, next);
-
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;


