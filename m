Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab1C2Icm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 04:32:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39631 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1C2Icj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 04:32:39 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20110328165648.GA9304@redhat.com>
References: <20110324164436.GC1930@jolsa.brq.redhat.com>
	 <1301153868.2250.359.camel@laptop> <20110326161346.GA18272@redhat.com>
	 <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com>
	 <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop>
	 <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins>
	 <1301327368.4859.28.camel@twins>  <20110328165648.GA9304@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Mar 2011 10:32:12 +0200
Message-ID: <1301387532.4859.54.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 18:56 +0200, Oleg Nesterov wrote:
> On 03/28, Peter Zijlstra wrote:
> >
> > Another fun race, suppose we do properly remove task_ctx and is_active,
> > but then the task gets scheduled back in before free_event() gets around
> > to disabling the jump_label..
> 
> Yes, this too...
> 
> Well, ignoring the HAVE_JUMP_LABEL case... perhaps we can split
> perf_sched_events into 2 counters? I mean,
> 
> 	atomic_t perf_sched_events_in, perf_sched_events_out;
> 
> 	static inline void perf_event_task_sched_in(struct task_struct *task)
> 	{
> 		COND_STMT(&perf_sched_events_in, __perf_event_task_sched_in(task));
> 	}
> 
> 	static inline
> 	void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
> 	{
> 		perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
> 
> 		COND_STMT(&perf_sched_events_out, __perf_event_task_sched_out(task, next));
> 	}
> 
> 	void perf_sched_events_inc(void)
> 	{
> 		atomic_inc(&perf_sched_events_out);
> 		smp_mb__after_atomic_inc();
> 		atomic_inc(&perf_sched_events_in);
> 	}
> 
> 	void perf_sched_events_dec(void)
> 	{
> 		if (atomic_dec_and_test(&perf_sched_events_in))
> 			synchronize_sched();
> 		atomic_dec(&perf_sched_events_out);
> 	}
> 
> The last 2 helpers should be used instead of jump_label_inc/dec.

Very clever, my approach was to make __perf_event_task_sched_in() a NOP
when !nr_events, which opens up another race against
perf_install_in_context() but hey ;-) Added my current hackery below.


> As for HAVE_JUMP_LABEL, I still can't understand why this test-case
> triggers the problem. 

FWIW I tested without that..

> But jump_label_inc/dec logic looks obviously
> racy.
> 
> jump_label_dec:
> 
> 	if (atomic_dec_and_test(key))
> 		jump_label_disable(key);
> 
> Another thread can create the PERF_ATTACH_TASK event in between
> and call jump_label_update(JUMP_LABEL_ENABLE) first. Looks like,
> jump_label_update() should ensure that "type" matches the state
> of the "*key" under jump_label_lock().

No I think you're right, and I think we fixed that but it looks like
Ingo still didn't merge the new jump-label patches :/



---

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1461,9 +1461,6 @@ static void add_event_to_ctx(struct perf
 	event->tstamp_stopped = tstamp;
 }
 
-static void perf_event_context_sched_in(struct perf_event_context *ctx,
-					struct task_struct *tsk);
-
 /*
  * Cross CPU call to install and enable a performance event
  *
@@ -1473,20 +1470,11 @@ static int  __perf_install_in_context(vo
 {
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
-	struct perf_event *leader = event->group_leader;
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
-	int err;
-
-	/*
-	 * In case we're installing a new context to an already running task,
-	 * could also happen before perf_event_task_sched_in() on architectures
-	 * which do context switches with IRQs enabled.
-	 */
-	if (ctx->task && !cpuctx->task_ctx)
-		perf_event_context_sched_in(ctx, ctx->task);
+	struct perf_event_context *task_ctx;
+	struct task_struct *task = NULL;
 
 	raw_spin_lock(&ctx->lock);
-	ctx->is_active = 1;
 	update_context_time(ctx);
 	/*
 	 * update cgrp time only if current cgrp
@@ -1497,43 +1485,48 @@ static int  __perf_install_in_context(vo
 
 	add_event_to_ctx(event, ctx);
 
-	if (!event_filter_match(event))
-		goto unlock;
+	if (!event_filter_match(event)) {
+		raw_spin_unlock(&ctx->lock);
+		return;
+	}
+	raw_spin_unlock(&ctx->lock);
 
 	/*
-	 * Don't put the event on if it is disabled or if
-	 * it is in a group and the group isn't on.
+	 * Since both these are only set during context-switches
+	 * and IRQs are disabled, their value is stable.
 	 */
-	if (event->state != PERF_EVENT_STATE_INACTIVE ||
-	    (leader != event && leader->state != PERF_EVENT_STATE_ACTIVE))
-		goto unlock;
+       	task_ctx = cpuctx->task_ctx;
 
+	perf_pmu_disable(ctx->pmu);
 	/*
-	 * An exclusive event can't go on if there are already active
-	 * hardware events, and no hardware event can go on if there
-	 * is already an exclusive event on.
-	 */
-	if (!group_can_go_on(event, cpuctx, 1))
-		err = -EEXIST;
-	else
-		err = event_sched_in(event, cpuctx, ctx);
-
-	if (err) {
-		/*
-		 * This event couldn't go on.  If it is in a group
-		 * then we have to pull the whole group off.
-		 * If the event group is pinned then put it in error state.
-		 */
-		if (leader != event)
-			group_sched_out(leader, cpuctx, ctx);
-		if (leader->attr.pinned) {
-			update_group_times(leader);
-			leader->state = PERF_EVENT_STATE_ERROR;
-		}
-	}
+	 * Reschedule the PMU to possible include the fresh event, we take the
+	 * brute force approach of unscheduling everything and then re-add the
+	 * events in the correct order (CPU-pinned, TASK-pinned, CPU-flexible,
+	 * TASK-flexible).
+	 *
+	 * It is possible we received this IPI before the scheduler called
+	 * perf_event_task_sched_in() on platforms that context switch with
+	 * interrupts enabled. In that case the below DTRT.
+	 */
+	cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+	if (task_ctx)
+		ctx_sched_out(task_ctx, cpuctx, EVENT_ALL);
+
+	if (ctx->task) {
+		cpuctx->task_ctx = task_ctx = ctx;
+		task = ctx->task
+	} else if (task_ctx)
+		task = task_ctx->task;
+
+	cpu_ctx_sched_in(cpuctx, EVENT_PINNED, task);
+	if (task_ctx)
+		ctx_sched_in(task_ctx, cpuctx, EVENT_PINNED, task);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task);
+	if (task_ctx)
+		ctx_sched_in(task_ctx, cpuctx, EVENT_FLEXIBLE, task);
 
-unlock:
-	raw_spin_unlock(&ctx->lock);
+	perf_pmu_rotate_start(ctx->pmu);
+	perf_pmu_enable(ctx->pmu);
 
 	return 0;
 }
@@ -2114,8 +2107,19 @@ static void perf_event_context_sched_in(
 	struct perf_cpu_context *cpuctx;
 
 	cpuctx = __get_cpu_context(ctx);
-	if (cpuctx->task_ctx == ctx)
+	raw_spin_lock(&ctx->lock);
+	/*
+	 * Serialize against perf_install_in_context(), the interesting case
+	 * is where perf_install_in_context() finds the context inactive and
+	 * another cpu is just about to schedule the task in. In that case
+	 * we need to avoid observing a stale ctx->nr_events.
+	 */
+	ctx->is_active = 1;
+	if (cpuctx->task_ctx == ctx || !ctx->nr_events) {
+		raw_spin_lock(&ctx->lock);
 		return;
+	}
+	raw_spin_lock(&ctx->lock);
 
 	perf_pmu_disable(ctx->pmu);
 	/*
@@ -2125,12 +2129,12 @@ static void perf_event_context_sched_in(
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
+	cpuctx->task_ctx = ctx;
+
 	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task);
 	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task);
 	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task);
 
-	cpuctx->task_ctx = ctx;
-
 	/*
 	 * Since these rotations are per-cpu, we need to ensure the
 	 * cpu-context we got scheduled on is actually rotating.
@@ -2922,15 +2926,40 @@ static void free_event(struct perf_event
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
 
-int perf_event_release_kernel(struct perf_event *event)
+static int __perf_event_release(void *info)
 {
+	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
+	int ret;
 
 	/*
-	 * Remove from the PMU, can't get re-enabled since we got
-	 * here because the last ref went.
+	 * Disable the event if its still running, we're shutting down.
 	 */
-	perf_event_disable(event);
+	ret = __perf_event_disable(info);
+	if (ret)
+		return ret;
+
+	raw_spin_lock_irq(&ctx->lock);
+	perf_group_detach(event);
+	list_del_event(event, ctx);
+	/*
+	 * In case we removed the last event from an active task_ctx
+	 * deactivate the task_ctx because this event being freed might
+	 * lead to the perf_sched_events jump_label being disabled
+	 * which avoids the task sched-out hook from being called.
+	 */
+	if (!ctx->nr_events && cpuctx->task_ctx == ctx) {
+		ctx->is_active = 0;
+		cpuctx->task_ctx = NULL;
+	}
+	raw_spin_unlock_irq(&ctx->lock);
+}
+
+int perf_event_release_kernel(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+	struct task_struct *task = ctx->task;
 
 	WARN_ON_ONCE(ctx->parent_ctx);
 	/*
@@ -2946,10 +2975,28 @@ int perf_event_release_kernel(struct per
 	 *     to trigger the AB-BA case.
 	 */
 	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
+	if (!task) {
+		cpu_function_call(event->cpu, __perf_event_release, event);
+		goto unlock;
+	}
+
+retry:
+	if (!task_function_call(task, __perf_event_release, event))
+		goto unlock;
+
 	raw_spin_lock_irq(&ctx->lock);
+	if (ctx->is_active) {
+		raw_spin_unlock_irq(&ctx->lock);
+		goto retry;
+	}
+
+	WARN_ON_ONCE(event->state == PERF_EVENT_STATE_ACTIVE);
+
 	perf_group_detach(event);
 	list_del_event(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
+
+unlock:
 	mutex_unlock(&ctx->mutex);
 
 	free_event(event);

