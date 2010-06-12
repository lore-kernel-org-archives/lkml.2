Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab0FLHfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 03:35:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62888 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab0FLHfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 03:35:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=AOt3HtJAgnnZ/TV6gReHErfnAh+4pwvbvFwAUrUT4Wq+hUwyqAZ2d3CB9fWv/fYTkL
         ukJr2R+Qkh0F/6pTopEme6fM8eRChsT0SQRaZ7EXC+PJCGFhAMhj2mroAbaauiDJfBjt
         QKNUDPPZrqD1W4uM+HLcpX06VwNJbHZdDtOeo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/5] perf: Introduce task, softirq and hardirq contexts exclusion
Date: Sat, 12 Jun 2010 09:34:57 +0200
Message-Id: <1276328098-24114-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1276328098-24114-1-git-send-regression-fweisbec@gmail.com>
References: <1276328098-24114-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings the possibility to exclude task and irq context from
the instrumentation, so that one can either filter any kind of
context or just confine the profiling to a single one.

In order to achieve that, this hooks into the irq_enter(),
irq_exit() and also the softirq paths. Each time we enter or exit
a new non-nested context, we determine the events that need to be
paused or resumed.

Here we use the ->stop() and ->start() callbacks that provide
lightweight pause/resume modes to the events.

The off-case (no running events having these new exclude properties
set) only adds a single atomic_read() in each hooks: two in the irq
path and two in the softirq path.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/perf_event.h |   42 +++++++++-
 kernel/perf_event.c        |  205 ++++++++++++++++++++++++++++++++++++++------
 kernel/softirq.c           |    6 ++
 3 files changed, 227 insertions(+), 26 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cea69c9..185a295 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -215,8 +215,11 @@ struct perf_event_attr {
 				 */
 				precise_ip     :  2, /* skid constraint       */
 				mmap_data      :  1, /* non-exec mmap data    */
+				exclude_task   :  1, /* exclude task contexts */
+				exclude_softirq:  1, /* exclude softirq contexts */
+				exclude_hardirq:  1, /* exclude hardirq contexts */
 
-				__reserved_1   : 46;
+				__reserved_1   : 43;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -936,10 +939,16 @@ static inline int is_software_event(struct perf_event *event)
 }
 
 extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
+extern atomic_t nr_excluded_events;
 
 extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
 extern int perf_swevent_int(struct perf_event *event);
 
+extern void __perf_event_hardirq_enter(void);
+extern void __perf_event_hardirq_exit(void);
+extern void __perf_event_softirq_enter(void);
+extern void __perf_event_softirq_exit(void);
+
 #ifndef perf_arch_fetch_caller_regs
 static inline void
 perf_arch_fetch_caller_regs(struct regs *regs, unsigned long ip) { }
@@ -975,6 +984,31 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
+
+static inline void perf_event_hardirq_enter(void)
+{
+	if (atomic_read(&nr_excluded_events))
+		__perf_event_hardirq_enter();
+}
+
+static inline void perf_event_hardirq_exit(void)
+{
+	if (atomic_read(&nr_excluded_events))
+		__perf_event_hardirq_exit();
+}
+
+static inline void perf_event_softirq_enter(void)
+{
+	if (atomic_read(&nr_excluded_events))
+		__perf_event_softirq_enter();
+}
+
+static inline void perf_event_softirq_exit(void)
+{
+	if (atomic_read(&nr_excluded_events))
+		__perf_event_softirq_exit();
+}
+
 extern struct perf_guest_info_callbacks *perf_guest_cbs;
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
@@ -1046,6 +1080,12 @@ static inline int perf_event_task_enable(void)				{ return -EINVAL; }
 static inline void
 perf_sw_event(u32 event_id, u64 nr, int nmi,
 		     struct pt_regs *regs, u64 addr)			{ }
+
+static inline void perf_event_hardirq_enter(void)			{ }
+static inline void perf_event_hardirq_exit(void)			{ }
+static inline void perf_event_softirq_enter(void)			{ }
+static inline void perf_event_softirq_exit(void)			{ }
+
 static inline void
 perf_bp_event(struct perf_event *event, void *data)			{ }
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index e440f21..cb8c3f6 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -48,6 +48,7 @@ static atomic_t nr_events __read_mostly;
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
+atomic_t nr_excluded_events __read_mostly;
 
 /*
  * perf event paranoia level:
@@ -642,17 +643,23 @@ event_sched_in(struct perf_event *event,
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
 
-	event->state = PERF_EVENT_STATE_ACTIVE;
 	event->oncpu = smp_processor_id();
-	/*
-	 * The new state must be visible before we turn it on in the hardware:
-	 */
-	smp_wmb();
 
-	if (event->pmu->enable(event)) {
-		event->state = PERF_EVENT_STATE_INACTIVE;
-		event->oncpu = -1;
-		return -EAGAIN;
+
+	if (event->attr.exclude_task && event->pmu->reserve) {
+		event->state = PERF_EVENT_STATE_PAUSED;
+		/*
+		 * The new state must be visible before we turn it on in
+		 * the hardware:
+		 */
+		smp_wmb();
+		if (event->pmu->reserve(event))
+			goto failed;
+	} else {
+		event->state = PERF_EVENT_STATE_ACTIVE;
+		smp_wmb();
+		if (event->pmu->enable(event))
+			goto failed;
 	}
 
 	event->tstamp_running += ctx->time - event->tstamp_stopped;
@@ -665,6 +672,11 @@ event_sched_in(struct perf_event *event,
 		cpuctx->exclusive = 1;
 
 	return 0;
+
+ failed:
+	event->state = PERF_EVENT_STATE_INACTIVE;
+	event->oncpu = -1;
+	return -EAGAIN;
 }
 
 static int
@@ -1191,6 +1203,159 @@ static void perf_event_sync_stat(struct perf_event_context *ctx,
 	}
 }
 
+static void perf_event_stop(struct perf_event *event)
+{
+	if (!event->pmu->stop)
+		return event->pmu->disable(event);
+
+	return event->pmu->stop(event);
+}
+
+static int perf_event_start(struct perf_event *event)
+{
+	if (!event->pmu->start)
+		return event->pmu->enable(event);
+
+	return event->pmu->start(event);
+}
+
+enum enter_context_t {
+	CONTEXT_HARDIRQ,
+	CONTEXT_SOFTIRQ,
+	CONTEXT_TASK,
+};
+
+static int event_enter_context(enum enter_context_t context,
+			       struct perf_event *event)
+{
+	int exclude;
+	int ret = 0;
+
+	switch (context) {
+	case CONTEXT_HARDIRQ:
+		exclude = event->attr.exclude_hardirq;
+		break;
+	case CONTEXT_SOFTIRQ:
+		exclude = event->attr.exclude_softirq;
+		break;
+	case CONTEXT_TASK:
+		exclude = event->attr.exclude_task;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	if (exclude && event->state == PERF_EVENT_STATE_ACTIVE) {
+		event->state = PERF_EVENT_STATE_PAUSED;
+		perf_event_stop(event);
+	} else if (!exclude && event->state == PERF_EVENT_STATE_PAUSED) {
+		event->state = PERF_EVENT_STATE_ACTIVE;
+		ret = perf_event_start(event);
+	}
+
+	return ret;
+}
+
+static void
+group_enter_context(enum enter_context_t context,
+		    struct perf_event *group_event,
+		    struct perf_cpu_context *cpuctx,
+		    struct perf_event_context *ctx)
+{
+	struct perf_event *event;
+
+	if (group_event->state < PERF_EVENT_STATE_PAUSED)
+		return;
+
+	/*
+	 * We probably want to make the exclude_* things all the same in a
+	 * group, to enforce the group instrumentation and to optmitize this
+	 * path.
+	 */
+	if (event_enter_context(context, group_event))
+		goto fail;
+
+	list_for_each_entry(event, &group_event->sibling_list, group_entry) {
+		if (event_enter_context(context, event))
+			goto fail;
+	}
+
+	return;
+
+ fail:
+	group_sched_out(group_event, cpuctx, ctx);
+	group_event->state = PERF_EVENT_STATE_ERROR;
+}
+
+static void
+ctx_enter_context(enum enter_context_t context,
+		  struct perf_cpu_context *cpuctx,
+		  struct perf_event_context *ctx)
+{
+	struct perf_event *group_event;
+
+	raw_spin_lock(&ctx->lock);
+
+	list_for_each_entry(group_event, &ctx->pinned_groups, group_entry)
+		group_enter_context(context, group_event, cpuctx, ctx);
+
+	list_for_each_entry(group_event, &ctx->flexible_groups, group_entry)
+		group_enter_context(context, group_event, cpuctx, ctx);
+
+	raw_spin_unlock(&ctx->lock);
+}
+
+static void enter_context(enum enter_context_t context)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_event_context *ctx = current->perf_event_ctxp;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	perf_disable();
+
+	ctx_enter_context(context, cpuctx, &cpuctx->ctx);
+	if (ctx)
+		ctx_enter_context(context, cpuctx, ctx);
+
+	perf_enable();
+
+	local_irq_restore(flags);
+}
+
+void __perf_event_hardirq_enter(void)
+{
+	/* Don't account nested cases */
+	if (!hardirq_count())
+		enter_context(CONTEXT_HARDIRQ);
+}
+
+void __perf_event_hardirq_exit(void)
+{
+	/* We are not truly leaving the irq if we nested */
+	if (hardirq_count())
+		return;
+
+	if (softirq_count())
+		enter_context(CONTEXT_SOFTIRQ);
+	else
+		enter_context(CONTEXT_TASK);
+}
+
+void __perf_event_softirq_enter(void)
+{
+	/* Softirqs can't nest */
+	enter_context(CONTEXT_SOFTIRQ);
+}
+
+void __perf_event_softirq_exit(void)
+{
+	/* Softirqs could have only interrupted a task context */
+	enter_context(CONTEXT_TASK);
+}
+
 /*
  * Called from scheduler to remove the events of the current task,
  * with interrupts disabled.
@@ -1506,22 +1671,6 @@ do {					\
 	return div64_u64(dividend, divisor);
 }
 
-static void perf_event_stop(struct perf_event *event)
-{
-	if (!event->pmu->stop)
-		return event->pmu->disable(event);
-
-	return event->pmu->stop(event);
-}
-
-static int perf_event_start(struct perf_event *event)
-{
-	if (!event->pmu->start)
-		return event->pmu->enable(event);
-
-	return event->pmu->start(event);
-}
-
 static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -1909,6 +2058,9 @@ static void free_event(struct perf_event *event)
 			atomic_dec(&nr_comm_events);
 		if (event->attr.task)
 			atomic_dec(&nr_task_events);
+		if (event->attr.exclude_task || event->attr.exclude_softirq ||
+		    event->attr.exclude_hardirq)
+			atomic_dec(&nr_excluded_events);
 	}
 
 	if (event->buffer) {
@@ -4943,6 +5095,9 @@ done:
 			atomic_inc(&nr_comm_events);
 		if (event->attr.task)
 			atomic_inc(&nr_task_events);
+		if (event->attr.exclude_task || event->attr.exclude_softirq ||
+		    event->attr.exclude_hardirq)
+			atomic_inc(&nr_excluded_events);
 	}
 
 	return event;
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 825e112..bb31457 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -198,6 +198,8 @@ asmlinkage void __do_softirq(void)
 	pending = local_softirq_pending();
 	account_system_vtime(current);
 
+	perf_event_softirq_enter();
+
 	__local_bh_disable((unsigned long)__builtin_return_address(0));
 	lockdep_softirq_enter();
 
@@ -246,6 +248,8 @@ restart:
 
 	account_system_vtime(current);
 	_local_bh_enable();
+
+	perf_event_softirq_exit();
 }
 
 #ifndef __ARCH_HAS_DO_SOFTIRQ
@@ -277,6 +281,7 @@ void irq_enter(void)
 {
 	int cpu = smp_processor_id();
 
+	perf_event_hardirq_enter();
 	rcu_irq_enter();
 	if (idle_cpu(cpu) && !in_interrupt()) {
 		__irq_enter();
@@ -302,6 +307,7 @@ void irq_exit(void)
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
+	perf_event_hardirq_exit();
 	rcu_irq_exit();
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
-- 
1.6.2.3

