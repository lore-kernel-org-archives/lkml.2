Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab1CaNv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:51:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:50010 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab1CaNv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:51:56 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20110331132815.GA4267@redhat.com>
References: <1301157483.2250.366.camel@laptop>
	 <20110326170922.GA20329@redhat.com> <20110326173545.GA22919@redhat.com>
	 <1301164168.2250.370.camel@laptop> <20110328133033.GA8254@redhat.com>
	 <1301324275.4859.25.camel@twins> <1301327368.4859.28.camel@twins>
	 <20110328165648.GA9304@redhat.com>
	 <20110330130951.GA2124@jolsa.brq.redhat.com>
	 <1301496684.4859.192.camel@twins>  <20110331132815.GA4267@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 31 Mar 2011 15:51:24 +0200
Message-ID: <1301579484.4859.277.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 15:28 +0200, Oleg Nesterov wrote:
> On 03/30, Peter Zijlstra wrote:
> >
> > -atomic_t perf_sched_events __read_mostly;
> > +atomic_t perf_sched_events_in __read_mostly;
> > +atomic_t perf_sched_events_out __read_mostly;
> >  static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
> >
> > +static void perf_sched_events_inc(void)
> > +{
> > +	jump_label_inc(&perf_sched_events_out);
> > +	jump_label_inc(&perf_sched_events_in);
> > +}
> > +
> > +static void perf_sched_events_dec(void)
> > +{
> > +	jump_label_dec(&perf_sched_events_in);
> > +	JUMP_LABEL(&perf_sched_events_in, no_sync);
> > +	synchronize_sched();
> > +no_sync:
> > +	jump_label_dec(&perf_sched_events_out);
> > +}
> 
> OK, synchronize_sched() can't work. How about
> 
> 	static int force_perf_event_task_sched_out(void *unused)
> 	{
> 		struct task_struct *curr = current;
> 
> 		__perf_event_task_sched_out(curr, task_rq(curr)->idle);

I'd call task_ctx_sched_out() there, we can't actually use struct rq
outside of sched.c and we know we'll not swap contexts with the idle
thread.

> 
> 		return 0;
> 	}
> 
> 	void synchronize_perf_event_task_sched_out(void)
> 	{
> 		stop_machine(force_perf_event_task_sched_out, NULL,
> 				cpu_possible_mask);
> 	}
> 
> instead?
> 
> 	- stop_machine(cpu_possible_mask) ensures that each cpu
> 	  does the context switch and calls _sched_out
> 
> 	- force_perf_event_task_sched_out() is only needed because
> 	  the migration thread can have the counters too.
> 
> Note, I am not sure this is the best solution. Just in case we don't
> find something better.
> 
> In any case, do you think this can work or I missed something again?

No I think that should work fine, but I'd rather keep the
perf_event_task_sched_out() call unoptimized as put in a stop_machine
call for the !JUMP_LABEL case too (-rt disables jump-labels to avoid all
the stop-machine noise)

Anyway, I _think_ we can do better.. but then, I haven't fully gone
through things yet.. compile tested only..

What the below does is rework the ctx locking, what we used to do was
lock and unlock ctx->lock and flip between task and cpu contexts a lot.

I changed that to hold both cpuctx->ctx.lock and cpuctx->task_ctx->lock,
which made things a lot saner.

I then changed ctx->is_active to be a bitmask of EVENT_PINNED|
EVENT_FLEXIBLE to reflect which part is actually scheduled in, and
changed lots of code (except the cgroup bits) to simply sched_out
eveything (or as much as needed) and then sched_in everything in the
proper order.

Like said, I think this'll get us there, but I've stared at this code
for too long again and might not be seeing things straight anymore (time
to go work on something else for a bit).


---
 perf_event.c |  427 +++++++++++++++++++++++++++--------------------------------
 1 file changed, 197 insertions(+), 230 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -172,13 +172,6 @@ int perf_proc_update_handler(struct ctl_
 
 static atomic64_t perf_event_id;
 
-static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
-			      enum event_type_t event_type);
-
-static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-			     enum event_type_t event_type,
-			     struct task_struct *task);
-
 static void update_context_time(struct perf_event_context *ctx);
 static u64 perf_event_time(struct perf_event *event);
 
@@ -202,6 +195,13 @@ __get_cpu_context(struct perf_event_cont
 
 #ifdef CONFIG_CGROUP_PERF
 
+static void cpuctx_sched_out(struct perf_cpu_context *cpuctx,
+			      enum event_type_t event_type);
+
+static void cpuctx_sched_in(struct perf_cpu_context *cpuctx,
+			     enum event_type_t event_type,
+			     struct task_struct *task);
+
 /*
  * Must ensure cgroup is pinned (css_get) before calling
  * this function. In other words, we cannot call this function
@@ -355,7 +355,7 @@ void perf_cgroup_switch(struct task_stru
 		if (cpuctx->ctx.nr_cgroups > 0) {
 
 			if (mode & PERF_CGROUP_SWOUT) {
-				cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+				cpuctx_sched_out(cpuctx, EVENT_ALL);
 				/*
 				 * must not be done before ctxswout due
 				 * to event_filter_match() in event_sched_out()
@@ -369,7 +369,7 @@ void perf_cgroup_switch(struct task_stru
 				 * have to pass task around
 				 */
 				cpuctx->cgrp = perf_cgroup_from_task(task);
-				cpu_ctx_sched_in(cpuctx, EVENT_ALL, task);
+				cpuctx_sched_in(cpuctx, EVENT_ALL, task);
 			}
 		}
 
@@ -1112,6 +1112,10 @@ static int __perf_remove_from_context(vo
 	raw_spin_lock(&ctx->lock);
 	event_sched_out(event, cpuctx, ctx);
 	list_del_event(event, ctx);
+	if (!ctx->nr_events && cpuctx->task_ctx == ctx) {
+		ctx->is_active = 0;
+		cpuctx->task_ctx = NULL;
+	}
 	raw_spin_unlock(&ctx->lock);
 
 	return 0;
@@ -1461,135 +1465,6 @@ static void add_event_to_ctx(struct perf
 	event->tstamp_stopped = tstamp;
 }
 
-static void perf_event_context_sched_in(struct perf_event_context *ctx,
-					struct task_struct *tsk);
-
-/*
- * Cross CPU call to install and enable a performance event
- *
- * Must be called with ctx->mutex held
- */
-static int  __perf_install_in_context(void *info)
-{
-	struct perf_event *event = info;
-	struct perf_event_context *ctx = event->ctx;
-	struct perf_event *leader = event->group_leader;
-	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
-	int err;
-
-	/*
-	 * In case we're installing a new context to an already running task,
-	 * could also happen before perf_event_task_sched_in() on architectures
-	 * which do context switches with IRQs enabled.
-	 */
-	if (ctx->task && !cpuctx->task_ctx)
-		perf_event_context_sched_in(ctx, ctx->task);
-
-	raw_spin_lock(&ctx->lock);
-	ctx->is_active = 1;
-	update_context_time(ctx);
-	/*
-	 * update cgrp time only if current cgrp
-	 * matches event->cgrp. Must be done before
-	 * calling add_event_to_ctx()
-	 */
-	update_cgrp_time_from_event(event);
-
-	add_event_to_ctx(event, ctx);
-
-	if (!event_filter_match(event))
-		goto unlock;
-
-	/*
-	 * Don't put the event on if it is disabled or if
-	 * it is in a group and the group isn't on.
-	 */
-	if (event->state != PERF_EVENT_STATE_INACTIVE ||
-	    (leader != event && leader->state != PERF_EVENT_STATE_ACTIVE))
-		goto unlock;
-
-	/*
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
-
-unlock:
-	raw_spin_unlock(&ctx->lock);
-
-	return 0;
-}
-
-/*
- * Attach a performance event to a context
- *
- * First we add the event to the list with the hardware enable bit
- * in event->hw_config cleared.
- *
- * If the event is attached to a task which is on a CPU we use a smp
- * call to enable it in the task context. The task might have been
- * scheduled away, but we check this in the smp call again.
- */
-static void
-perf_install_in_context(struct perf_event_context *ctx,
-			struct perf_event *event,
-			int cpu)
-{
-	struct task_struct *task = ctx->task;
-
-	lockdep_assert_held(&ctx->mutex);
-
-	event->ctx = ctx;
-
-	if (!task) {
-		/*
-		 * Per cpu events are installed via an smp call and
-		 * the install is always successful.
-		 */
-		cpu_function_call(cpu, __perf_install_in_context, event);
-		return;
-	}
-
-retry:
-	if (!task_function_call(task, __perf_install_in_context, event))
-		return;
-
-	raw_spin_lock_irq(&ctx->lock);
-	/*
-	 * If we failed to find a running task, but find the context active now
-	 * that we've acquired the ctx->lock, retry.
-	 */
-	if (ctx->is_active) {
-		raw_spin_unlock_irq(&ctx->lock);
-		goto retry;
-	}
-
-	/*
-	 * Since the task isn't running, its safe to add the event, us holding
-	 * the ctx->lock ensures the task won't get scheduled in.
-	 */
-	add_event_to_ctx(event, ctx);
-	raw_spin_unlock_irq(&ctx->lock);
-}
-
 /*
  * Put a event into inactive state and update time fields.
  * Enabling the leader of a group effectively enables all
@@ -1765,30 +1640,51 @@ static void ctx_sched_out(struct perf_ev
 			  enum event_type_t event_type)
 {
 	struct perf_event *event;
+	int is_active = ctx->is_active;
 
-	raw_spin_lock(&ctx->lock);
-	perf_pmu_disable(ctx->pmu);
-	ctx->is_active = 0;
+	lockdep_assert_held(&ctx->lock);
+
+	ctx->is_active &= ~event_type;
 	if (likely(!ctx->nr_events))
-		goto out;
+		return;
+
 	update_context_time(ctx);
 	update_cgrp_time_from_cpuctx(cpuctx);
 
 	if (!ctx->nr_active)
-		goto out;
+		return;
 
-	if (event_type & EVENT_PINNED) {
+	perf_pmu_disable(ctx->pmu);
+	if ((event_type & EVENT_PINNED) && (is_active & EVENT_PINNED)) {
 		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
 
-	if (event_type & EVENT_FLEXIBLE) {
+	if ((event_type & EVENT_FLEXIBLE) && (is_active & EVENT_FLEXIBLE)) {
 		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
-out:
 	perf_pmu_enable(ctx->pmu);
-	raw_spin_unlock(&ctx->lock);
+}
+
+static void cpuctx_sched_out(struct perf_cpu_context *cpuctx,
+			      enum event_type_t event_type)
+{
+	ctx_sched_out(&cpuctx->ctx, cpuctx, event_type);
+}
+
+static void task_ctx_sched_out(struct perf_event_context *ctx)
+{
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
+
+	if (!cpuctx->task_ctx)
+		return;
+
+	if (WARN_ON_ONCE(ctx != cpuctx->task_ctx))
+		return;
+
+	ctx_sched_out(ctx, cpuctx, EVENT_ALL);
+	cpuctx->task_ctx = NULL;
 }
 
 /*
@@ -1936,8 +1832,9 @@ static void perf_event_context_sched_out
 	rcu_read_unlock();
 
 	if (do_switch) {
-		ctx_sched_out(ctx, cpuctx, EVENT_ALL);
-		cpuctx->task_ctx = NULL;
+		raw_spin_lock(&ctx->lock);
+		task_ctx_sched_out(ctx);
+		raw_spin_unlock(&ctx->lock);
 	}
 }
 
@@ -1972,30 +1869,6 @@ void __perf_event_task_sched_out(struct 
 		perf_cgroup_sched_out(task);
 }
 
-static void task_ctx_sched_out(struct perf_event_context *ctx,
-			       enum event_type_t event_type)
-{
-	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
-
-	if (!cpuctx->task_ctx)
-		return;
-
-	if (WARN_ON_ONCE(ctx != cpuctx->task_ctx))
-		return;
-
-	ctx_sched_out(ctx, cpuctx, event_type);
-	cpuctx->task_ctx = NULL;
-}
-
-/*
- * Called with IRQs disabled
- */
-static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
-			      enum event_type_t event_type)
-{
-	ctx_sched_out(&cpuctx->ctx, cpuctx, event_type);
-}
-
 static void
 ctx_pinned_sched_in(struct perf_event_context *ctx,
 		    struct perf_cpu_context *cpuctx)
@@ -2062,11 +1935,13 @@ ctx_sched_in(struct perf_event_context *
 	     struct task_struct *task)
 {
 	u64 now;
+	int is_active = ctx->is_active;
 
-	raw_spin_lock(&ctx->lock);
-	ctx->is_active = 1;
+	lockdep_assert_held(&ctx->lock);
+
+	ctx->is_active |= event_type;
 	if (likely(!ctx->nr_events))
-		goto out;
+		return;
 
 	now = perf_clock();
 	ctx->timestamp = now;
@@ -2075,18 +1950,16 @@ ctx_sched_in(struct perf_event_context *
 	 * First go through the list and put on any pinned groups
 	 * in order to give them the best chance of going on.
 	 */
-	if (event_type & EVENT_PINNED)
+	if ((event_type & EVENT_PINNED) && !(is_active & EVENT_PINNED))
 		ctx_pinned_sched_in(ctx, cpuctx);
 
 	/* Then walk through the lower prio flexible groups */
-	if (event_type & EVENT_FLEXIBLE)
+	if ((event_type & EVENT_FLEXIBLE) && !(is_active & EVENT_FLEXIBLE))
 		ctx_flexible_sched_in(ctx, cpuctx);
-
-out:
-	raw_spin_unlock(&ctx->lock);
 }
 
-static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
+#ifdef CONFIG_CGROUP_PERF
+static void cpuctx_sched_in(struct perf_cpu_context *cpuctx,
 			     enum event_type_t event_type,
 			     struct task_struct *task)
 {
@@ -2094,18 +1967,129 @@ static void cpu_ctx_sched_in(struct perf
 
 	ctx_sched_in(ctx, cpuctx, event_type, task);
 }
+#endif
 
-static void task_ctx_sched_in(struct perf_event_context *ctx,
-			      enum event_type_t event_type)
+static void perf_event_sched_in(struct perf_cpu_context *cpuctx,
+				struct perf_event_context *ctx,
+				struct task_struct *task)
 {
-	struct perf_cpu_context *cpuctx;
+	struct perf_event_context *cctx = &cpuctx->ctx;
 
-	cpuctx = __get_cpu_context(ctx);
-	if (cpuctx->task_ctx == ctx)
+	/*
+	 * We want to keep the following order in events:
+	 *   CPU-pinned
+	 *   TASK-pinned
+	 *   CPU-flexible
+	 *   TASK-flexible
+	 */
+	ctx_sched_in(cctx, cpuctx, EVENT_PINNED, task);
+	if (ctx)
+		ctx_sched_in(ctx, cpuctx, EVENT_PINNED, NULL);
+	ctx_sched_in(cctx, cpuctx, EVENT_FLEXIBLE, task);
+	if (ctx) {
+		ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, NULL);
+		cpuctx->task_ctx = ctx;
+	}
+}
+
+static void perf_lock_ctx(struct perf_cpu_context *cpuctx,
+			  struct perf_event_context *ctx)
+{
+	raw_spin_lock(&cpuctx->ctx.lock);
+	if (ctx)
+		raw_spin_lock(&ctx->lock);
+}
+
+static void perf_unlock_ctx(struct perf_cpu_context *cpuctx,
+			    struct perf_event_context *ctx)
+{
+	if (ctx)
+		raw_spin_unlock(&ctx->lock);
+	raw_spin_unlock(&cpuctx->ctx.lock);
+}
+
+/*
+ * Cross CPU call to install and enable a performance event
+ *
+ * Must be called with ctx->mutex held
+ */
+static int  __perf_install_in_context(void *info)
+{
+	struct perf_event *event = info;
+	struct perf_event_context *ctx = event->ctx;
+	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
+
+	perf_lock_ctx(cpuctx, cpuctx->task_ctx);
+	perf_pmu_disable(cpuctx->ctx.pmu);
+	if (cpuctx->task_ctx)
+		ctx_sched_out(cpuctx->task_ctx, cpuctx, EVENT_ALL);
+
+	if (ctx->task && cpuctx->task_ctx != ctx) {
+		if (cpuctx->task_ctx)
+			raw_spin_unlock(&cpuctx->task_ctx->lock);
+		cpuctx->task_ctx = ctx;
+		raw_spin_lock(&ctx->lock);
+	}
+	cpuctx_sched_out(cpuctx, EVENT_FLEXIBLE);
+
+	add_event_to_ctx(event, ctx);
+
+	perf_event_sched_in(cpuctx, cpuctx->task_ctx, current);
+	perf_unlock_ctx(cpuctx, cpuctx->task_ctx);
+
+	return 0;
+}
+
+/*
+ * Attach a performance event to a context
+ *
+ * First we add the event to the list with the hardware enable bit
+ * in event->hw_config cleared.
+ *
+ * If the event is attached to a task which is on a CPU we use a smp
+ * call to enable it in the task context. The task might have been
+ * scheduled away, but we check this in the smp call again.
+ */
+static void
+perf_install_in_context(struct perf_event_context *ctx,
+			struct perf_event *event,
+			int cpu)
+{
+	struct task_struct *task = ctx->task;
+
+	lockdep_assert_held(&ctx->mutex);
+
+	event->ctx = ctx;
+
+	if (!task) {
+		/*
+		 * Per cpu events are installed via an smp call and
+		 * the install is always successful.
+		 */
+		cpu_function_call(cpu, __perf_install_in_context, event);
+		return;
+	}
+
+retry:
+	if (!task_function_call(task, __perf_install_in_context, event))
 		return;
 
-	ctx_sched_in(ctx, cpuctx, event_type, NULL);
-	cpuctx->task_ctx = ctx;
+	raw_spin_lock_irq(&ctx->lock);
+	/*
+	 * If we failed to find a running task, but find the context active now
+	 * that we've acquired the ctx->lock, retry.
+	 */
+	if (ctx->is_active) {
+		raw_spin_unlock_irq(&ctx->lock);
+		goto retry;
+	}
+
+	/*
+	 * Since the task isn't running, its safe to add the event, us holding
+	 * the ctx->lock ensures the task won't get scheduled in.
+	 */
+	add_event_to_ctx(event, ctx);
+	raw_spin_unlock_irq(&ctx->lock);
 }
 
 static void perf_event_context_sched_in(struct perf_event_context *ctx,
@@ -2117,26 +2101,18 @@ static void perf_event_context_sched_in(
 	if (cpuctx->task_ctx == ctx)
 		return;
 
+	perf_lock_ctx(cpuctx, ctx);
 	perf_pmu_disable(ctx->pmu);
-	/*
-	 * We want to keep the following priority order:
-	 * cpu pinned (that don't need to move), task pinned,
-	 * cpu flexible, task flexible.
-	 */
-	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
-
-	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task);
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task);
-	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task);
-
-	cpuctx->task_ctx = ctx;
+	cpuctx_sched_out(cpuctx, EVENT_FLEXIBLE);
+	perf_event_sched_in(cpuctx, ctx, task);
+	perf_pmu_enable(ctx->pmu);
 
 	/*
 	 * Since these rotations are per-cpu, we need to ensure the
 	 * cpu-context we got scheduled on is actually rotating.
 	 */
 	perf_pmu_rotate_start(ctx->pmu);
-	perf_pmu_enable(ctx->pmu);
+	perf_unlock_ctx(cpuctx, ctx);
 }
 
 /*
@@ -2276,7 +2252,6 @@ static void perf_ctx_adjust_freq(struct 
 	u64 interrupts, now;
 	s64 delta;
 
-	raw_spin_lock(&ctx->lock);
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
@@ -2308,7 +2283,6 @@ static void perf_ctx_adjust_freq(struct 
 		if (delta > 0)
 			perf_adjust_period(event, period, delta);
 	}
-	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -2316,16 +2290,12 @@ static void perf_ctx_adjust_freq(struct 
  */
 static void rotate_ctx(struct perf_event_context *ctx)
 {
-	raw_spin_lock(&ctx->lock);
-
 	/*
 	 * Rotate the first entry last of non-pinned groups. Rotation might be
 	 * disabled by the inheritance code.
 	 */
 	if (!ctx->rotate_disable)
 		list_rotate_left(&ctx->flexible_groups);
-
-	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -2352,6 +2322,7 @@ static void perf_rotate_context(struct p
 			rotate = 1;
 	}
 
+	perf_lock_ctx(cpuctx, ctx);
 	perf_pmu_disable(cpuctx->ctx.pmu);
 	perf_ctx_adjust_freq(&cpuctx->ctx, interval);
 	if (ctx)
@@ -2360,23 +2331,22 @@ static void perf_rotate_context(struct p
 	if (!rotate)
 		goto done;
 
-	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
+	cpuctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
-		task_ctx_sched_out(ctx, EVENT_FLEXIBLE);
+		ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
 
 	rotate_ctx(&cpuctx->ctx);
 	if (ctx)
 		rotate_ctx(ctx);
 
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, current);
-	if (ctx)
-		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
+	perf_event_sched_in(cpuctx, ctx, current);
 
 done:
 	if (remove)
 		list_del_init(&cpuctx->rotation_list);
 
 	perf_pmu_enable(cpuctx->ctx.pmu);
+	perf_unlock_ctx(cpuctx, ctx);
 }
 
 void perf_event_task_tick(void)
@@ -2423,10 +2393,10 @@ static void perf_event_enable_on_exec(st
 	if (!ctx || !ctx->nr_events)
 		goto out;
 
-	task_ctx_sched_out(ctx, EVENT_ALL);
-
 	raw_spin_lock(&ctx->lock);
 
+	task_ctx_sched_out(ctx);
+
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		ret = event_enable_on_exec(event, ctx);
 		if (ret)
@@ -2831,16 +2801,12 @@ find_get_context(struct pmu *pmu, struct
 		unclone_ctx(ctx);
 		++ctx->pin_count;
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
-	}
-
-	if (!ctx) {
+	} else {
 		ctx = alloc_perf_context(pmu, task);
 		err = -ENOMEM;
 		if (!ctx)
 			goto errout;
 
-		get_ctx(ctx);
-
 		err = 0;
 		mutex_lock(&task->perf_event_mutex);
 		/*
@@ -2852,14 +2818,14 @@ find_get_context(struct pmu *pmu, struct
 		else if (task->perf_event_ctxp[ctxn])
 			err = -EAGAIN;
 		else {
+			get_ctx(ctx);
 			++ctx->pin_count;
 			rcu_assign_pointer(task->perf_event_ctxp[ctxn], ctx);
 		}
 		mutex_unlock(&task->perf_event_mutex);
 
 		if (unlikely(err)) {
-			put_task_struct(task);
-			kfree(ctx);
+			put_ctx(ctx);
 
 			if (err == -EAGAIN)
 				goto retry;
@@ -2930,12 +2896,6 @@ int perf_event_release_kernel(struct per
 {
 	struct perf_event_context *ctx = event->ctx;
 
-	/*
-	 * Remove from the PMU, can't get re-enabled since we got
-	 * here because the last ref went.
-	 */
-	perf_event_disable(event);
-
 	WARN_ON_ONCE(ctx->parent_ctx);
 	/*
 	 * There are two ways this annotation is useful:
@@ -2952,8 +2912,8 @@ int perf_event_release_kernel(struct per
 	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
 	raw_spin_lock_irq(&ctx->lock);
 	perf_group_detach(event);
-	list_del_event(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
+	perf_remove_from_context(event);
 	mutex_unlock(&ctx->mutex);
 
 	free_event(event);
@@ -5982,6 +5942,7 @@ static int pmu_dev_alloc(struct pmu *pmu
 }
 
 static struct lock_class_key cpuctx_mutex;
+static struct lock_class_key cpuctx_lock;
 
 int perf_pmu_register(struct pmu *pmu, char *name, int type)
 {
@@ -6032,6 +5993,7 @@ int perf_pmu_register(struct pmu *pmu, c
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 		__perf_event_init_context(&cpuctx->ctx);
 		lockdep_set_class(&cpuctx->ctx.mutex, &cpuctx_mutex);
+		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
 		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->jiffies_interval = 1;
@@ -6531,6 +6493,11 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_alloc;
 	}
 
+	if (task) {
+		put_task_struct(task);
+		task = NULL;
+	}
+
 	/*
 	 * Look up the group leader (we will attach this event to it):
 	 */
@@ -6771,7 +6738,6 @@ static void perf_event_exit_task_context
 	 * our context.
 	 */
 	child_ctx = rcu_dereference_raw(child->perf_event_ctxp[ctxn]);
-	task_ctx_sched_out(child_ctx, EVENT_ALL);
 
 	/*
 	 * Take the context lock here so that if find_get_context is
@@ -6779,6 +6745,7 @@ static void perf_event_exit_task_context
 	 * incremented the context's refcount before we do put_ctx below.
 	 */
 	raw_spin_lock(&child_ctx->lock);
+	task_ctx_sched_out(child_ctx);
 	child->perf_event_ctxp[ctxn] = NULL;
 	/*
 	 * If this context is a clone; unclone it so it can't get

