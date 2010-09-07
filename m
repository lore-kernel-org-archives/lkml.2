Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab0IGQ64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:58:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32864 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab0IGQ4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:56:45 -0400
Message-Id: <20100907165011.729417181@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 18:46:42 +0200
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
Subject: [RFC][PATCH 09/19] perf: Rework the PMU methods
References: <20100907164633.879932949@chello.nl>
Content-Disposition: inline; filename=perf-change-ops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace pmu::{enable,disable,start,stop,unthrottle} with
pmu::{add,del,start,stop}, all of which take a flags argument.

The new interface extends the capability to stop a counter while
keeping it scheduled on the PMU. We replace the throttled state with
the generic stopped state.

This also allows us to efficiently stop/start counters over certain
code paths (like IRQ handlers).

It also allows scheduling a counter without it starting, allowing for
a generic frozen state (useful for rotating stopped counters).

The stopped state is implemented in two different ways, depending on
how the architecture implemented the throttled state:

 1) We disable the counter:
    a) the pmu has per-counter enable bits, we flip that
    b) we program a NOP event, preserving the counter state

 2) We store the counter state and ignore all read/overflow events

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/alpha/kernel/perf_event.c            |   71 +++++++++++----
 arch/arm/kernel/perf_event.c              |   96 +++++++++++++-------
 arch/powerpc/kernel/perf_event.c          |  105 ++++++++++++++--------
 arch/powerpc/kernel/perf_event_fsl_emb.c  |  107 ++++++++++++++--------
 arch/sh/kernel/perf_event.c               |   75 ++++++++++------
 arch/sparc/kernel/perf_event.c            |  109 ++++++++++++++---------
 arch/x86/kernel/cpu/perf_event.c          |  106 +++++++++++++---------
 arch/x86/kernel/cpu/perf_event_intel.c    |    2 
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    2 
 include/linux/ftrace_event.h              |    4 
 include/linux/perf_event.h                |   54 ++++++++---
 kernel/hw_breakpoint.c                    |   29 +++++-
 kernel/perf_event.c                       |  140 +++++++++++++++---------------
 kernel/trace/trace_event_perf.c           |    7 +
 14 files changed, 576 insertions(+), 331 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -582,7 +582,7 @@ static void x86_pmu_disable_all(void)
 	}
 }
 
-static void x86_pmu_pmu_disable(struct pmu *pmu)
+static void x86_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -799,10 +799,10 @@ static inline int match_prev_assignment(
 		hwc->last_tag == cpuc->tags[i];
 }
 
-static int x86_pmu_start(struct perf_event *event);
-static void x86_pmu_stop(struct perf_event *event);
+static void x86_pmu_start(struct perf_event *event, int flags);
+static void x86_pmu_stop(struct perf_event *event, int flags);
 
-static void x86_pmu_pmu_enable(struct pmu *pmu)
+static void x86_pmu_enable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct perf_event *event;
@@ -838,7 +838,14 @@ static void x86_pmu_pmu_enable(struct pm
 			    match_prev_assignment(hwc, cpuc, i))
 				continue;
 
-			x86_pmu_stop(event);
+			/*
+			 * Ensure we don't accidentally enable a stopped
+			 * counter simply because we rescheduled.
+			 */
+			if (hwc->state & PERF_HES_STOPPED)
+				hwc->state |= PERF_HES_ARCH;
+
+			x86_pmu_stop(event, PERF_EF_UPDATE);
 		}
 
 		for (i = 0; i < cpuc->n_events; i++) {
@@ -850,7 +857,10 @@ static void x86_pmu_pmu_enable(struct pm
 			else if (i < n_running)
 				continue;
 
-			x86_pmu_start(event);
+			if (hwc->state & PERF_HES_ARCH)
+				continue;
+
+			x86_pmu_start(event, PERF_EF_RELOAD);
 		}
 		cpuc->n_added = 0;
 		perf_events_lapic_init();
@@ -951,15 +961,12 @@ static void x86_pmu_enable_event(struct 
 }
 
 /*
- * activate a single event
+ * Add a single event to the PMU.
  *
  * The event is added to the group of enabled events
  * but only if it can be scehduled with existing events.
- *
- * Called with PMU disabled. If successful and return value 1,
- * then guaranteed to call perf_enable() and hw_perf_enable()
  */
-static int x86_pmu_enable(struct perf_event *event)
+static int x86_pmu_add(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc;
@@ -974,10 +981,14 @@ static int x86_pmu_enable(struct perf_ev
 	if (ret < 0)
 		goto out;
 
+	hwc->state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+	if (!(flags & PERF_EF_START))
+		hwc->state |= PERF_HES_ARCH;
+
 	/*
 	 * If group events scheduling transaction was started,
 	 * skip the schedulability test here, it will be peformed
-	 * at commit time(->commit_txn) as a whole
+	 * at commit time (->commit_txn) as a whole
 	 */
 	if (cpuc->group_flag & PERF_EVENT_TXN)
 		goto done_collect;
@@ -1002,27 +1013,28 @@ static int x86_pmu_enable(struct perf_ev
 	return ret;
 }
 
-static int x86_pmu_start(struct perf_event *event)
+static void x86_pmu_start(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx = event->hw.idx;
 
-	if (idx == -1)
-		return -EAGAIN;
+	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
+		return;
+
+	if (WARN_ON_ONCE(idx == -1))
+		return;
+
+	if (flags & PERF_EF_RELOAD) {
+		WARN_ON_ONCE(!(event->hw.state & PERF_HES_UPTODATE));
+		x86_perf_event_set_period(event);
+	}
+
+	event->hw.state = 0;
 
-	x86_perf_event_set_period(event);
 	cpuc->events[idx] = event;
 	__set_bit(idx, cpuc->active_mask);
 	x86_pmu.enable(event);
 	perf_event_update_userpage(event);
-
-	return 0;
-}
-
-static void x86_pmu_unthrottle(struct perf_event *event)
-{
-	int ret = x86_pmu_start(event);
-	WARN_ON_ONCE(ret);
 }
 
 void perf_event_print_debug(void)
@@ -1079,27 +1091,29 @@ void perf_event_print_debug(void)
 	local_irq_restore(flags);
 }
 
-static void x86_pmu_stop(struct perf_event *event)
+static void x86_pmu_stop(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
-	int idx = hwc->idx;
-
-	if (!__test_and_clear_bit(idx, cpuc->active_mask))
-		return;
-
-	x86_pmu.disable(event);
 
-	/*
-	 * Drain the remaining delta count out of a event
-	 * that we are disabling:
-	 */
-	x86_perf_event_update(event);
+	if (__test_and_clear_bit(hwc->idx, cpuc->active_mask)) {
+		x86_pmu.disable(event);
+		cpuc->events[hwc->idx] = NULL;
+		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
+		hwc->state |= PERF_HES_STOPPED;
+	}
 
-	cpuc->events[idx] = NULL;
+	if ((flags & PERF_EF_UPDATE) && !(hwc->state & PERF_HES_UPTODATE)) {
+		/*
+		 * Drain the remaining delta count out of a event
+		 * that we are disabling:
+		 */
+		x86_perf_event_update(event);
+		hwc->state |= PERF_HES_UPTODATE;
+	}
 }
 
-static void x86_pmu_disable(struct perf_event *event)
+static void x86_pmu_del(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int i;
@@ -1112,7 +1126,7 @@ static void x86_pmu_disable(struct perf_
 	if (cpuc->group_flag & PERF_EVENT_TXN)
 		return;
 
-	x86_pmu_stop(event);
+	x86_pmu_stop(event, PERF_EF_UPDATE);
 
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event_list[i]) {
@@ -1164,7 +1178,7 @@ static int x86_pmu_handle_irq(struct pt_
 			continue;
 
 		if (perf_event_overflow(event, 1, &data, regs))
-			x86_pmu_stop(event);
+			x86_pmu_stop(event, 0);
 	}
 
 	if (handled)
@@ -1604,15 +1618,17 @@ int x86_pmu_event_init(struct perf_event
 }
 
 static struct pmu pmu = {
-	.pmu_enable	= x86_pmu_pmu_enable,
-	.pmu_disable	= x86_pmu_pmu_disable,
+	.pmu_enable	= x86_pmu_enable,
+	.pmu_disable	= x86_pmu_disable,
+
 	.event_init	= x86_pmu_event_init,
-	.enable		= x86_pmu_enable,
-	.disable	= x86_pmu_disable,
+
+	.add		= x86_pmu_add,
+	.del		= x86_pmu_del,
 	.start		= x86_pmu_start,
 	.stop		= x86_pmu_stop,
 	.read		= x86_pmu_read,
-	.unthrottle	= x86_pmu_unthrottle,
+
 	.start_txn	= x86_pmu_start_txn,
 	.cancel_txn	= x86_pmu_cancel_txn,
 	.commit_txn	= x86_pmu_commit_txn,
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -424,7 +424,7 @@ event_sched_out(struct perf_event *event
 		event->state = PERF_EVENT_STATE_OFF;
 	}
 	event->tstamp_stopped = ctx->time;
-	event->pmu->disable(event);
+	event->pmu->del(event, 0);
 	event->oncpu = -1;
 
 	if (!is_software_event(event))
@@ -649,7 +649,7 @@ event_sched_in(struct perf_event *event,
 	 */
 	smp_wmb();
 
-	if (event->pmu->enable(event)) {
+	if (event->pmu->add(event, PERF_EF_START)) {
 		event->state = PERF_EVENT_STATE_INACTIVE;
 		event->oncpu = -1;
 		return -EAGAIN;
@@ -1482,22 +1482,6 @@ do {					\
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
@@ -1517,9 +1501,9 @@ static void perf_adjust_period(struct pe
 	hwc->sample_period = sample_period;
 
 	if (local64_read(&hwc->period_left) > 8*sample_period) {
-		perf_event_stop(event);
+		event->pmu->stop(event, PERF_EF_UPDATE);
 		local64_set(&hwc->period_left, 0);
-		perf_event_start(event);
+		event->pmu->start(event, PERF_EF_RELOAD);
 	}
 }
 
@@ -1548,7 +1532,7 @@ static void perf_ctx_adjust_freq(struct 
 		 */
 		if (interrupts == MAX_INTERRUPTS) {
 			perf_log_throttle(event, 1);
-			event->pmu->unthrottle(event);
+			event->pmu->start(event, 0);
 		}
 
 		if (!event->attr.freq || !event->attr.sample_freq)
@@ -2506,6 +2490,9 @@ int perf_event_task_disable(void)
 
 static int perf_event_index(struct perf_event *event)
 {
+	if (event->hw.state & PERF_HES_STOPPED)
+		return 0;
+
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
 		return 0;
 
@@ -4120,8 +4107,6 @@ static int __perf_event_overflow(struct 
 	struct hw_perf_event *hwc = &event->hw;
 	int ret = 0;
 
-	throttle = (throttle && event->pmu->unthrottle != NULL);
-
 	if (!throttle) {
 		hwc->interrupts++;
 	} else {
@@ -4246,7 +4231,7 @@ static void perf_swevent_overflow(struct
 	}
 }
 
-static void perf_swevent_add(struct perf_event *event, u64 nr,
+static void perf_swevent_event(struct perf_event *event, u64 nr,
 			       int nmi, struct perf_sample_data *data,
 			       struct pt_regs *regs)
 {
@@ -4272,6 +4257,9 @@ static void perf_swevent_add(struct perf
 static int perf_exclude_event(struct perf_event *event,
 			      struct pt_regs *regs)
 {
+	if (event->hw.state & PERF_HES_STOPPED)
+		return 0;
+
 	if (regs) {
 		if (event->attr.exclude_user && user_mode(regs))
 			return 1;
@@ -4371,7 +4359,7 @@ static void do_perf_sw_event(enum perf_t
 
 	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
 		if (perf_swevent_match(event, type, event_id, data, regs))
-			perf_swevent_add(event, nr, nmi, data, regs);
+			perf_swevent_event(event, nr, nmi, data, regs);
 	}
 end:
 	rcu_read_unlock();
@@ -4415,7 +4403,7 @@ static void perf_swevent_read(struct per
 {
 }
 
-static int perf_swevent_enable(struct perf_event *event)
+static int perf_swevent_add(struct perf_event *event, int flags)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct perf_cpu_context *cpuctx;
@@ -4428,6 +4416,8 @@ static int perf_swevent_enable(struct pe
 		perf_swevent_set_period(event);
 	}
 
+	hwc->state = !(flags & PERF_EF_START);
+
 	head = find_swevent_head(cpuctx, event);
 	if (WARN_ON_ONCE(!head))
 		return -EINVAL;
@@ -4437,18 +4427,19 @@ static int perf_swevent_enable(struct pe
 	return 0;
 }
 
-static void perf_swevent_disable(struct perf_event *event)
+static void perf_swevent_del(struct perf_event *event, int flags)
 {
 	hlist_del_rcu(&event->hlist_entry);
 }
 
-static void perf_swevent_void(struct perf_event *event)
+static void perf_swevent_start(struct perf_event *event, int flags)
 {
+	event->hw.state = 0;
 }
 
-static int perf_swevent_int(struct perf_event *event)
+static void perf_swevent_stop(struct perf_event *event, int flags)
 {
-	return 0;
+	event->hw.state = PERF_HES_STOPPED;
 }
 
 /* Deref the hlist from the update side */
@@ -4604,12 +4595,11 @@ static int perf_swevent_init(struct perf
 
 static struct pmu perf_swevent = {
 	.event_init	= perf_swevent_init,
-	.enable		= perf_swevent_enable,
-	.disable	= perf_swevent_disable,
-	.start		= perf_swevent_int,
-	.stop		= perf_swevent_void,
+	.add		= perf_swevent_add,
+	.del		= perf_swevent_del,
+	.start		= perf_swevent_start,
+	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
-	.unthrottle	= perf_swevent_void, /* hwc->interrupts already reset */
 };
 
 #ifdef CONFIG_EVENT_TRACING
@@ -4657,7 +4647,7 @@ void perf_tp_event(u64 addr, u64 count, 
 
 	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
 		if (perf_tp_event_match(event, &data, regs))
-			perf_swevent_add(event, count, 1, &data, regs);
+			perf_swevent_event(event, count, 1, &data, regs);
 	}
 
 	perf_swevent_put_recursion_context(rctx);
@@ -4696,12 +4686,11 @@ static int perf_tp_event_init(struct per
 
 static struct pmu perf_tracepoint = {
 	.event_init	= perf_tp_event_init,
-	.enable		= perf_trace_enable,
-	.disable	= perf_trace_disable,
-	.start		= perf_swevent_int,
-	.stop		= perf_swevent_void,
+	.add		= perf_trace_add,
+	.del		= perf_trace_del,
+	.start		= perf_swevent_start,
+	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
-	.unthrottle	= perf_swevent_void,
 };
 
 static inline void perf_tp_register(void)
@@ -4757,8 +4746,8 @@ void perf_bp_event(struct perf_event *bp
 
 	perf_sample_data_init(&sample, bp->attr.bp_addr);
 
-	if (!perf_exclude_event(bp, regs))
-		perf_swevent_add(bp, 1, 1, &sample, regs);
+	if (!bp->hw.state && !perf_exclude_event(bp, regs))
+		perf_swevent_event(bp, 1, 1, &sample, regs);
 }
 #endif
 
@@ -4834,32 +4823,39 @@ static void perf_swevent_cancel_hrtimer(
 
 static void cpu_clock_event_update(struct perf_event *event)
 {
-	int cpu = raw_smp_processor_id();
 	s64 prev;
 	u64 now;
 
-	now = cpu_clock(cpu);
+	now = local_clock();
 	prev = local64_xchg(&event->hw.prev_count, now);
 	local64_add(now - prev, &event->count);
 }
 
-static int cpu_clock_event_enable(struct perf_event *event)
+static void cpu_clock_event_start(struct perf_event *event, int flags)
 {
-	struct hw_perf_event *hwc = &event->hw;
-	int cpu = raw_smp_processor_id();
-
-	local64_set(&hwc->prev_count, cpu_clock(cpu));
+	local64_set(&event->hw.prev_count, local_clock());
 	perf_swevent_start_hrtimer(event);
-
-	return 0;
 }
 
-static void cpu_clock_event_disable(struct perf_event *event)
+static void cpu_clock_event_stop(struct perf_event *event, int flags)
 {
 	perf_swevent_cancel_hrtimer(event);
 	cpu_clock_event_update(event);
 }
 
+static int cpu_clock_event_add(struct perf_event *event, int flags)
+{
+	if (flags & PERF_EF_START)
+		cpu_clock_event_start(event, flags);
+
+	return 0;
+}
+
+static void cpu_clock_event_del(struct perf_event *event, int flags)
+{
+	cpu_clock_event_stop(event, flags);
+}
+
 static void cpu_clock_event_read(struct perf_event *event)
 {
 	cpu_clock_event_update(event);
@@ -4878,8 +4874,10 @@ static int cpu_clock_event_init(struct p
 
 static struct pmu perf_cpu_clock = {
 	.event_init	= cpu_clock_event_init,
-	.enable		= cpu_clock_event_enable,
-	.disable	= cpu_clock_event_disable,
+	.add		= cpu_clock_event_add,
+	.del		= cpu_clock_event_del,
+	.start		= cpu_clock_event_start,
+	.stop		= cpu_clock_event_stop,
 	.read		= cpu_clock_event_read,
 };
 
@@ -4897,25 +4895,29 @@ static void task_clock_event_update(stru
 	local64_add(delta, &event->count);
 }
 
-static int task_clock_event_enable(struct perf_event *event)
+static void task_clock_event_start(struct perf_event *event, int flags)
 {
-	struct hw_perf_event *hwc = &event->hw;
-	u64 now;
-
-	now = event->ctx->time;
-
-	local64_set(&hwc->prev_count, now);
-
+	local64_set(&event->hw.prev_count, event->ctx->time);
 	perf_swevent_start_hrtimer(event);
-
-	return 0;
 }
 
-static void task_clock_event_disable(struct perf_event *event)
+static void task_clock_event_stop(struct perf_event *event, int flags)
 {
 	perf_swevent_cancel_hrtimer(event);
 	task_clock_event_update(event, event->ctx->time);
+}
+
+static int task_clock_event_add(struct perf_event *event, int flags)
+{
+	if (flags & PERF_EF_START)
+		task_clock_event_start(event, flags);
 
+	return 0;
+}
+
+static void task_clock_event_del(struct perf_event *event, int flags)
+{
+	task_clock_event_stop(event, PERF_EF_UPDATE);
 }
 
 static void task_clock_event_read(struct perf_event *event)
@@ -4947,8 +4949,10 @@ static int task_clock_event_init(struct 
 
 static struct pmu perf_task_clock = {
 	.event_init	= task_clock_event_init,
-	.enable		= task_clock_event_enable,
-	.disable	= task_clock_event_disable,
+	.add		= task_clock_event_add,
+	.del		= task_clock_event_del,
+	.start		= task_clock_event_start,
+	.stop		= task_clock_event_stop,
 	.read		= task_clock_event_read,
 };
 
Index: linux-2.6/kernel/trace/trace_event_perf.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_event_perf.c
+++ linux-2.6/kernel/trace/trace_event_perf.c
@@ -101,7 +101,7 @@ int perf_trace_init(struct perf_event *p
 	return ret;
 }
 
-int perf_trace_enable(struct perf_event *p_event)
+int perf_trace_add(struct perf_event *p_event, int flags)
 {
 	struct ftrace_event_call *tp_event = p_event->tp_event;
 	struct hlist_head __percpu *pcpu_list;
@@ -111,13 +111,16 @@ int perf_trace_enable(struct perf_event 
 	if (WARN_ON_ONCE(!pcpu_list))
 		return -EINVAL;
 
+	if (!(flags & PERF_EF_START))
+		p_event->hw.state = PERF_HES_STOPPED;
+
 	list = this_cpu_ptr(pcpu_list);
 	hlist_add_head_rcu(&p_event->hlist_entry, list);
 
 	return 0;
 }
 
-void perf_trace_disable(struct perf_event *p_event)
+void perf_trace_del(struct perf_event *p_event, int flags)
 {
 	hlist_del_rcu(&p_event->hlist_entry);
 }
Index: linux-2.6/arch/sh/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/perf_event.c
+++ linux-2.6/arch/sh/kernel/perf_event.c
@@ -206,26 +206,52 @@ static void sh_perf_event_update(struct 
 	local64_add(delta, &event->count);
 }
 
-static void sh_pmu_disable(struct perf_event *event)
+static void sh_pmu_stop(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
-	clear_bit(idx, cpuc->active_mask);
-	sh_pmu->disable(hwc, idx);
+	if (!(event->hw.state & PERF_HES_STOPPED)) {
+		sh_pmu->disable(hwc, idx);
+		cpuc->events[idx] = NULL;
+		event->hw.state |= PERF_HES_STOPPED;
+	}
 
-	barrier();
+	if ((flags & PERF_EF_UPDATE) && !(event->hw.state & PERF_HES_UPTODATE)) {
+		sh_perf_event_update(event, &event->hw, idx);
+		event->hw.state |= PERF_HES_UPTODATE;
+	}
+}
 
-	sh_perf_event_update(event, &event->hw, idx);
+static void sh_pmu_start(struct perf_event *event, int flags)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+	int idx = hwc->idx;
 
-	cpuc->events[idx] = NULL;
-	clear_bit(idx, cpuc->used_mask);
+	if (WARN_ON_ONCE(idx == -1))
+		return;
+
+	if (flags & PERF_EF_RELOAD)
+		WARN_ON_ONCE(!(event->hw.state & PERF_HES_UPTODATE));
+
+	cpuc->events[idx] = event;
+	event->hw.state = 0;
+	sh_pmu->enable(hwc, idx);
+}
+
+static void sh_pmu_del(struct perf_event *event, int flags)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	sh_pmu_stop(event, PERF_EF_UPDATE);
+	__clear_bit(event->hw.idx, cpuc->used_mask);
 
 	perf_event_update_userpage(event);
 }
 
-static int sh_pmu_enable(struct perf_event *event)
+static int sh_pmu_add(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
@@ -234,21 +260,20 @@ static int sh_pmu_enable(struct perf_eve
 
 	perf_pmu_disable(event->pmu);
 
-	if (test_and_set_bit(idx, cpuc->used_mask)) {
+	if (__test_and_set_bit(idx, cpuc->used_mask)) {
 		idx = find_first_zero_bit(cpuc->used_mask, sh_pmu->num_events);
 		if (idx == sh_pmu->num_events)
 			goto out;
 
-		set_bit(idx, cpuc->used_mask);
+		__set_bit(idx, cpuc->used_mask);
 		hwc->idx = idx;
 	}
 
 	sh_pmu->disable(hwc, idx);
 
-	cpuc->events[idx] = event;
-	set_bit(idx, cpuc->active_mask);
-
-	sh_pmu->enable(hwc, idx);
+	event->hw.state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+	if (flags & PERF_EF_START)
+		sh_pmu_start(event, PERF_EF_RELOAD);
 
 	perf_event_update_userpage(event);
 	ret = 0;
@@ -285,7 +310,7 @@ static int sh_pmu_event_init(struct perf
 	return err;
 }
 
-static void sh_pmu_pmu_enable(struct pmu *pmu)
+static void sh_pmu_enable(struct pmu *pmu)
 {
 	if (!sh_pmu_initialized())
 		return;
@@ -293,7 +318,7 @@ static void sh_pmu_pmu_enable(struct pmu
 	sh_pmu->enable_all();
 }
 
-static void sh_pmu_pmu_disable(struct pmu *pmu)
+static void sh_pmu_disable(struct pmu *pmu)
 {
 	if (!sh_pmu_initialized())
 		return;
@@ -302,11 +327,13 @@ static void sh_pmu_pmu_disable(struct pm
 }
 
 static struct pmu pmu = {
-	.pmu_enable	= sh_pmu_pmu_enable,
-	.pmu_disable	= sh_pmu_pmu_disable,
+	.pmu_enable	= sh_pmu_enable,
+	.pmu_disable	= sh_pmu_disable,
 	.event_init	= sh_pmu_event_init,
-	.enable		= sh_pmu_enable,
-	.disable	= sh_pmu_disable,
+	.add		= sh_pmu_add,
+	.del		= sh_pmu_del,
+	.start		= sh_pmu_start,
+	.stop		= sh_pmu_stop,
 	.read		= sh_pmu_read,
 };
 
@@ -334,15 +361,15 @@ sh_pmu_notifier(struct notifier_block *s
 	return NOTIFY_OK;
 }
 
-int __cpuinit register_sh_pmu(struct sh_pmu *pmu)
+int __cpuinit register_sh_pmu(struct sh_pmu *_pmu)
 {
 	if (sh_pmu)
 		return -EBUSY;
-	sh_pmu = pmu;
+	sh_pmu = _pmu;
 
-	pr_info("Performance Events: %s support registered\n", pmu->name);
+	pr_info("Performance Events: %s support registered\n", _pmu->name);
 
-	WARN_ON(pmu->num_events > MAX_HWEVENTS);
+	WARN_ON(_pmu->num_events > MAX_HWEVENTS);
 
 	perf_pmu_register(&pmu);
 	perf_cpu_notifier(sh_pmu_notifier);
Index: linux-2.6/arch/arm/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/perf_event.c
+++ linux-2.6/arch/arm/kernel/perf_event.c
@@ -221,46 +221,56 @@ armpmu_event_update(struct perf_event *e
 }
 
 static void
-armpmu_disable(struct perf_event *event)
+armpmu_read(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
-	int idx = hwc->idx;
-
-	WARN_ON(idx < 0);
-
-	clear_bit(idx, cpuc->active_mask);
-	armpmu->disable(hwc, idx);
-
-	barrier();
 
-	armpmu_event_update(event, hwc, idx);
-	cpuc->events[idx] = NULL;
-	clear_bit(idx, cpuc->used_mask);
+	/* Don't read disabled counters! */
+	if (hwc->idx < 0)
+		return;
 
-	perf_event_update_userpage(event);
+	armpmu_event_update(event, hwc, hwc->idx);
 }
 
 static void
-armpmu_read(struct perf_event *event)
+armpmu_stop(struct perf_event *event, int flags)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
-	/* Don't read disabled counters! */
-	if (hwc->idx < 0)
+	if (!armpmu)
 		return;
 
-	armpmu_event_update(event, hwc, hwc->idx);
+	/*
+	 * ARM pmu always has to update the counter, so ignore
+	 * PERF_EF_UPDATE, see comments in armpmu_start().
+	 */
+	if (!(hwc->state & PERF_HES_STOPPED)) {
+		armpmu->disable(hwc, hwc->idx);
+		barrier(); /* why? */
+		armpmu_event_update(event, hwc, hwc->idx);
+		hwc->state |= PERF_HES_STOPPED | PERF_HES_UPTODATE;
+	}
 }
 
 static void
-armpmu_unthrottle(struct perf_event *event)
+armpmu_start(struct perf_event *event, int flags)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
+	if (!armpmu)
+		return;
+
+	/*
+	 * ARM pmu always has to reprogram the period, so ignore
+	 * PERF_EF_RELOAD, see the comment below.
+	 */
+	if (flags & PERF_EF_RELOAD)
+		WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));
+
+	hwc->state = 0;
 	/*
 	 * Set the period again. Some counters can't be stopped, so when we
-	 * were throttled we simply disabled the IRQ source and the counter
+	 * were stopped we simply disabled the IRQ source and the counter
 	 * may have been left counting. If we don't do this step then we may
 	 * get an interrupt too soon or *way* too late if the overflow has
 	 * happened since disabling.
@@ -269,8 +279,25 @@ armpmu_unthrottle(struct perf_event *eve
 	armpmu->enable(hwc, hwc->idx);
 }
 
+static void
+armpmu_del(struct perf_event *event, int flags)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+	int idx = hwc->idx;
+
+	WARN_ON(idx < 0);
+
+	clear_bit(idx, cpuc->active_mask);
+	armpmu_stop(event, PERF_EF_UPDATE);
+	cpuc->events[idx] = NULL;
+	clear_bit(idx, cpuc->used_mask);
+
+	perf_event_update_userpage(event);
+}
+
 static int
-armpmu_enable(struct perf_event *event)
+armpmu_add(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
@@ -295,11 +322,9 @@ armpmu_enable(struct perf_event *event)
 	cpuc->events[idx] = event;
 	set_bit(idx, cpuc->active_mask);
 
-	/* Set the period for the event. */
-	armpmu_event_set_period(event, hwc, idx);
-
-	/* Enable the event. */
-	armpmu->enable(hwc, idx);
+	hwc->state = PERF_HES_STOPPED | PERF_HES_UPTODATE;
+	if (flags & PERF_EF_START)
+		armpmu_start(event, PERF_EF_RELOAD);
 
 	/* Propagate our changes to the userspace mapping. */
 	perf_event_update_userpage(event);
@@ -534,7 +559,7 @@ static int armpmu_event_init(struct perf
 	return err;
 }
 
-static void armpmu_pmu_enable(struct pmu *pmu)
+static void armpmu_enable(struct pmu *pmu)
 {
 	/* Enable all of the perf events on hardware. */
 	int idx;
@@ -555,20 +580,21 @@ static void armpmu_pmu_enable(struct pmu
 	armpmu->start();
 }
 
-static void armpmu_pmu_disable(struct pmu *pmu)
+static void armpmu_disable(struct pmu *pmu)
 {
 	if (armpmu)
 		armpmu->stop();
 }
 
 static struct pmu pmu = {
-	.pmu_enable = armpmu_pmu_enable,
-	.pmu_disable= armpmu_pmu_disable,
-	.event_init = armpmu_event_init,
-	.enable	    = armpmu_enable,
-	.disable    = armpmu_disable,
-	.unthrottle = armpmu_unthrottle,
-	.read	    = armpmu_read,
+	.pmu_enable	= armpmu_enable,
+	.pmu_disable	= armpmu_disable,
+	.event_init	= armpmu_event_init,
+	.add		= armpmu_add,
+	.del		= armpmu_del,
+	.start		= armpmu_start,
+	.stop		= armpmu_stop,
+	.read		= armpmu_read,
 };
 
 /*
Index: linux-2.6/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event.c
+++ linux-2.6/arch/powerpc/kernel/perf_event.c
@@ -402,6 +402,9 @@ static void power_pmu_read(struct perf_e
 {
 	s64 val, delta, prev;
 
+	if (event->hw.state & PERF_HES_STOPPED)
+		return;
+
 	if (!event->hw.idx)
 		return;
 	/*
@@ -517,7 +520,7 @@ static void write_mmcr0(struct cpu_hw_ev
  * Disable all events to prevent PMU interrupts and to allow
  * events to be added or removed.
  */
-static void power_pmu_pmu_disable(struct pmu *pmu)
+static void power_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw;
 	unsigned long flags;
@@ -565,7 +568,7 @@ static void power_pmu_pmu_disable(struct
  * If we were previously disabled and events were added, then
  * put the new config on the PMU.
  */
-static void power_pmu_pmu_enable(struct pmu *pmu)
+static void power_pmu_enable(struct pmu *pmu)
 {
 	struct perf_event *event;
 	struct cpu_hw_events *cpuhw;
@@ -672,6 +675,8 @@ static void power_pmu_pmu_enable(struct 
 		}
 		local64_set(&event->hw.prev_count, val);
 		event->hw.idx = idx;
+		if (event->hw.state & PERF_HES_STOPPED)
+			val = 0;
 		write_pmc(idx, val);
 		perf_event_update_userpage(event);
 	}
@@ -727,7 +732,7 @@ static int collect_events(struct perf_ev
  * re-enable the PMU in order to get hw_perf_enable to do the
  * actual work of reconfiguring the PMU.
  */
-static int power_pmu_enable(struct perf_event *event)
+static int power_pmu_add(struct perf_event *event, int ef_flags)
 {
 	struct cpu_hw_events *cpuhw;
 	unsigned long flags;
@@ -749,6 +754,9 @@ static int power_pmu_enable(struct perf_
 	cpuhw->events[n0] = event->hw.config;
 	cpuhw->flags[n0] = event->hw.event_base;
 
+	if (!(ef_flags & PERF_EF_START))
+		event->hw.state = PERF_HES_STOPPED | PERF_HES_UPTODATE;
+
 	/*
 	 * If group events scheduling transaction was started,
 	 * skip the schedulability test here, it will be peformed
@@ -777,7 +785,7 @@ static int power_pmu_enable(struct perf_
 /*
  * Remove a event from the PMU.
  */
-static void power_pmu_disable(struct perf_event *event)
+static void power_pmu_del(struct perf_event *event, int ef_flags)
 {
 	struct cpu_hw_events *cpuhw;
 	long i;
@@ -826,27 +834,53 @@ static void power_pmu_disable(struct per
 }
 
 /*
- * Re-enable interrupts on a event after they were throttled
- * because they were coming too fast.
+ * POWER-PMU does not support disabling individual counters, hence
+ * program their cycle counter to their max value and ignore the interrupts.
  */
-static void power_pmu_unthrottle(struct perf_event *event)
+
+static void power_pmu_start(struct perf_event *event, int ef_flags)
 {
-	s64 val, left;
 	unsigned long flags;
+	s64 left;
 
 	if (!event->hw.idx || !event->hw.sample_period)
 		return;
+
+	if (!(event->hw.state & PERF_HES_STOPPED))
+		return;
+
+	if (ef_flags & PERF_EF_RELOAD)
+		WARN_ON_ONCE(!(event->hw.state & PERF_HES_UPTODATE));
+
+	local_irq_save(flags);
+	perf_pmu_disable(event->pmu);
+
+	event->hw.state = 0;
+	left = local64_read(&event->hw.period_left);
+	write_pmc(event->hw.idx, left);
+
+	perf_event_update_userpage(event);
+	perf_pmu_enable(event->pmu);
+	local_irq_restore(flags);
+}
+
+static void power_pmu_stop(struct perf_event *event, int ef_flags)
+{
+	unsigned long flags;
+
+	if (!event->hw.idx || !event->hw.sample_period)
+		return;
+
+	if (event->hw.state & PERF_HES_STOPPED)
+		return;
+
 	local_irq_save(flags);
 	perf_pmu_disable(event->pmu);
+
 	power_pmu_read(event);
-	left = event->hw.sample_period;
-	event->hw.last_period = left;
-	val = 0;
-	if (left < 0x80000000L)
-		val = 0x80000000L - left;
-	write_pmc(event->hw.idx, val);
-	local64_set(&event->hw.prev_count, val);
-	local64_set(&event->hw.period_left, left);
+	event->hw.state |= PERF_HES_STOPPED | PERF_HES_UPTODATE;
+	write_pmc(event->hw.idx, 0);
+
 	perf_event_update_userpage(event);
 	perf_pmu_enable(event->pmu);
 	local_irq_restore(flags);
@@ -1131,13 +1165,14 @@ static int power_pmu_event_init(struct p
 }
 
 struct pmu power_pmu = {
-	.pmu_enable	= power_pmu_pmu_enable,
-	.pmu_disable	= power_pmu_pmu_disable,
+	.pmu_enable	= power_pmu_enable,
+	.pmu_disable	= power_pmu_disable,
 	.event_init	= power_pmu_event_init,
-	.enable		= power_pmu_enable,
-	.disable	= power_pmu_disable,
+	.add		= power_pmu_add,
+	.del		= power_pmu_del,
+	.start		= power_pmu_start,
+	.stop		= power_pmu_stop,
 	.read		= power_pmu_read,
-	.unthrottle	= power_pmu_unthrottle,
 	.start_txn	= power_pmu_start_txn,
 	.cancel_txn	= power_pmu_cancel_txn,
 	.commit_txn	= power_pmu_commit_txn,
@@ -1155,6 +1190,11 @@ static void record_and_restart(struct pe
 	s64 prev, delta, left;
 	int record = 0;
 
+	if (event->hw.state & PERF_HES_STOPPED) {
+		write_pmc(event->hw.idx, 0);
+		return;
+	}
+
 	/* we don't have to worry about interrupts here */
 	prev = local64_read(&event->hw.prev_count);
 	delta = (val - prev) & 0xfffffffful;
@@ -1177,6 +1217,11 @@ static void record_and_restart(struct pe
 			val = 0x80000000LL - left;
 	}
 
+	write_pmc(event->hw.idx, val);
+	local64_set(&event->hw.prev_count, val);
+	local64_set(&event->hw.period_left, left);
+	perf_event_update_userpage(event);
+
 	/*
 	 * Finally record data if requested.
 	 */
@@ -1189,23 +1234,9 @@ static void record_and_restart(struct pe
 		if (event->attr.sample_type & PERF_SAMPLE_ADDR)
 			perf_get_data_addr(regs, &data.addr);
 
-		if (perf_event_overflow(event, nmi, &data, regs)) {
-			/*
-			 * Interrupts are coming too fast - throttle them
-			 * by setting the event to 0, so it will be
-			 * at least 2^30 cycles until the next interrupt
-			 * (assuming each event counts at most 2 counts
-			 * per cycle).
-			 */
-			val = 0;
-			left = ~0ULL >> 1;
-		}
+		if (perf_event_overflow(event, nmi, &data, regs))
+			power_pmu_stop(event, 0);
 	}
-
-	write_pmc(event->hw.idx, val);
-	local64_set(&event->hw.prev_count, val);
-	local64_set(&event->hw.period_left, left);
-	perf_event_update_userpage(event);
 }
 
 /*
Index: linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -156,6 +156,9 @@ static void fsl_emb_pmu_read(struct perf
 {
 	s64 val, delta, prev;
 
+	if (event->hw.state & PERF_HES_STOPPED)
+		return;
+
 	/*
 	 * Performance monitor interrupts come even when interrupts
 	 * are soft-disabled, as long as interrupts are hard-enabled.
@@ -177,7 +180,7 @@ static void fsl_emb_pmu_read(struct perf
  * Disable all events to prevent PMU interrupts and to allow
  * events to be added or removed.
  */
-static void fsl_emb_pmu_pmu_disable(struct pmu *pmu)
+static void fsl_emb_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw;
 	unsigned long flags;
@@ -216,7 +219,7 @@ static void fsl_emb_pmu_pmu_disable(stru
  * If we were previously disabled and events were added, then
  * put the new config on the PMU.
  */
-static void fsl_emb_pmu_pmu_enable(struct pmu *pmu)
+static void fsl_emb_pmu_enable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw;
 	unsigned long flags;
@@ -263,7 +266,7 @@ static int collect_events(struct perf_ev
 }
 
 /* context locked on entry */
-static int fsl_emb_pmu_enable(struct perf_event *event)
+static int fsl_emb_pmu_add(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuhw;
 	int ret = -EAGAIN;
@@ -302,6 +305,12 @@ static int fsl_emb_pmu_enable(struct per
 			val = 0x80000000L - left;
 	}
 	local64_set(&event->hw.prev_count, val);
+
+	if (!(flags & PERF_EF_START)) {
+		event->hw.state = PERF_HES_STOPPED | PERF_HES_UPTODATE;
+		val = 0;
+	}
+
 	write_pmc(i, val);
 	perf_event_update_userpage(event);
 
@@ -316,7 +325,7 @@ static int fsl_emb_pmu_enable(struct per
 }
 
 /* context locked on entry */
-static void fsl_emb_pmu_disable(struct perf_event *event)
+static void fsl_emb_pmu_del(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuhw;
 	int i = event->hw.idx;
@@ -353,30 +362,49 @@ static void fsl_emb_pmu_disable(struct p
 	put_cpu_var(cpu_hw_events);
 }
 
-/*
- * Re-enable interrupts on a event after they were throttled
- * because they were coming too fast.
- *
- * Context is locked on entry, but perf is not disabled.
- */
-static void fsl_emb_pmu_unthrottle(struct perf_event *event)
+static void fsl_emb_pmu_start(struct perf_event *event, int ef_flags)
+{
+	unsigned long flags;
+	s64 left;
+
+	if (event->hw.idx < 0 || !event->hw.sample_period)
+		return;
+
+	if (!(event->hw.state & PERF_HES_STOPPED))
+		return;
+
+	if (ef_flags & PERF_EF_RELOAD)
+		WARN_ON_ONCE(!(event->hw.state & PERF_HES_UPTODATE));
+
+	local_irq_save(flags);
+	perf_pmu_disable(event->pmu);
+
+	event->hw.state = 0;
+	left = local64_read(&event->hw.period_left);
+	write_pmc(event->hw.idx, left);
+
+	perf_event_update_userpage(event);
+	perf_pmu_enable(event->pmu);
+	local_irq_restore(flags);
+}
+
+static void fsl_emb_pmu_stop(struct perf_event *event, int ef_flags)
 {
-	s64 val, left;
 	unsigned long flags;
 
 	if (event->hw.idx < 0 || !event->hw.sample_period)
 		return;
+
+	if (event->hw.state & PERF_HES_STOPPED)
+		return;
+
 	local_irq_save(flags);
 	perf_pmu_disable(event->pmu);
+
 	fsl_emb_pmu_read(event);
-	left = event->hw.sample_period;
-	event->hw.last_period = left;
-	val = 0;
-	if (left < 0x80000000L)
-		val = 0x80000000L - left;
-	write_pmc(event->hw.idx, val);
-	local64_set(&event->hw.prev_count, val);
-	local64_set(&event->hw.period_left, left);
+	event->hw.state |= PERF_HES_STOPPED | PERF_HES_UPTODATE;
+	write_pmc(event->hw.idx, 0);
+
 	perf_event_update_userpage(event);
 	perf_pmu_enable(event->pmu);
 	local_irq_restore(flags);
@@ -524,13 +552,14 @@ static int fsl_emb_pmu_event_init(struct
 }
 
 static struct pmu fsl_emb_pmu = {
-	.pmu_enable	= fsl_emb_pmu_pmu_enable,
-	.pmu_disable	= fsl_emb_pmu_pmu_disable,
+	.pmu_enable	= fsl_emb_pmu_enable,
+	.pmu_disable	= fsl_emb_pmu_disable,
 	.event_init	= fsl_emb_pmu_event_init,
-	.enable		= fsl_emb_pmu_enable,
-	.disable	= fsl_emb_pmu_disable,
+	.add		= fsl_emb_pmu_add,
+	.del		= fsl_emb_pmu_del,
+	.start		= fsl_emb_pmu_start,
+	.stop		= fsl_emb_pmu_stop,
 	.read		= fsl_emb_pmu_read,
-	.unthrottle	= fsl_emb_pmu_unthrottle,
 };
 
 /*
@@ -545,6 +574,11 @@ static void record_and_restart(struct pe
 	s64 prev, delta, left;
 	int record = 0;
 
+	if (event->hw.state & PERF_HES_STOPPED) {
+		write_pmc(event->hw.idx, 0);
+		return;
+	}
+
 	/* we don't have to worry about interrupts here */
 	prev = local64_read(&event->hw.prev_count);
 	delta = (val - prev) & 0xfffffffful;
@@ -567,6 +601,11 @@ static void record_and_restart(struct pe
 			val = 0x80000000LL - left;
 	}
 
+	write_pmc(event->hw.idx, val);
+	local64_set(&event->hw.prev_count, val);
+	local64_set(&event->hw.period_left, left);
+	perf_event_update_userpage(event);
+
 	/*
 	 * Finally record data if requested.
 	 */
@@ -576,23 +615,9 @@ static void record_and_restart(struct pe
 		perf_sample_data_init(&data, 0);
 		data.period = event->hw.last_period;
 
-		if (perf_event_overflow(event, nmi, &data, regs)) {
-			/*
-			 * Interrupts are coming too fast - throttle them
-			 * by setting the event to 0, so it will be
-			 * at least 2^30 cycles until the next interrupt
-			 * (assuming each event counts at most 2 counts
-			 * per cycle).
-			 */
-			val = 0;
-			left = ~0ULL >> 1;
-		}
+		if (perf_event_overflow(event, nmi, &data, regs))
+			fsl_emb_pmu_stop(event, 0);
 	}
-
-	write_pmc(event->hw.idx, val);
-	local64_set(&event->hw.prev_count, val);
-	local64_set(&event->hw.period_left, left);
-	perf_event_update_userpage(event);
 }
 
 static void perf_event_interrupt(struct pt_regs *regs)
Index: linux-2.6/arch/sparc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/perf_event.c
+++ linux-2.6/arch/sparc/kernel/perf_event.c
@@ -658,13 +658,16 @@ static u64 maybe_change_configuration(st
 
 		enc = perf_event_get_enc(cpuc->events[i]);
 		pcr &= ~mask_for_index(idx);
-		pcr |= event_encoding(enc, idx);
+		if (hwc->state & PERF_HES_STOPPED)
+			pcr |= nop_for_index(idx);
+		else
+			pcr |= event_encoding(enc, idx);
 	}
 out:
 	return pcr;
 }
 
-static void sparc_pmu_pmu_enable(struct pmu *pmu)
+static void sparc_pmu_enable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	u64 pcr;
@@ -691,7 +694,7 @@ static void sparc_pmu_pmu_enable(struct 
 	pcr_ops->write(cpuc->pcr);
 }
 
-static void sparc_pmu_pmu_disable(struct pmu *pmu)
+static void sparc_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	u64 val;
@@ -710,10 +713,53 @@ static void sparc_pmu_pmu_disable(struct
 	pcr_ops->write(cpuc->pcr);
 }
 
-static void sparc_pmu_disable(struct perf_event *event)
+static int active_event_index(struct cpu_hw_events *cpuc,
+			      struct perf_event *event)
+{
+	int i;
+
+	for (i = 0; i < cpuc->n_events; i++) {
+		if (cpuc->event[i] == event)
+			break;
+	}
+	BUG_ON(i == cpuc->n_events);
+	return cpuc->current_idx[i];
+}
+
+static void sparc_pmu_start(struct perf_event *event, int flags)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx = active_event_index(cpuc, event);
+
+	if (flags & PERF_EF_RELOAD) {
+		WARN_ON_ONCE(!(event->hw.state & PERF_HES_UPTODATE));
+		sparc_perf_event_set_period(event, &event->hw, idx);
+	}
+
+	event->hw.state = 0;
+
+	sparc_pmu_enable_event(cpuc, &event->hw, idx);
+}
+
+static void sparc_pmu_stop(struct perf_event *event, int flags)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx = active_event_index(cpuc, event);
+
+	if (!(event->hw.state & PERF_HES_STOPPED)) {
+		sparc_pmu_disable_event(cpuc, &event->hw, idx);
+		event->hw.state |= PERF_HES_STOPPED;
+	}
+
+	if (!(event->hw.state & PERF_HES_UPTODATE) && (flags & PERF_EF_UPDATE)) {
+		sparc_perf_event_update(event, &event->hw, idx);
+		event->hw.state |= PERF_HES_UPTODATE;
+	}
+}
+
+static void sparc_pmu_del(struct perf_event *event, int _flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct hw_perf_event *hwc = &event->hw;
 	unsigned long flags;
 	int i;
 
@@ -722,7 +768,10 @@ static void sparc_pmu_disable(struct per
 
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event[i]) {
-			int idx = cpuc->current_idx[i];
+			/* Absorb the final count and turn off the
+			 * event.
+			 */
+			sparc_pmu_stop(event, PERF_EF_UPDATE);
 
 			/* Shift remaining entries down into
 			 * the existing slot.
@@ -734,13 +783,6 @@ static void sparc_pmu_disable(struct per
 					cpuc->current_idx[i];
 			}
 
-			/* Absorb the final count and turn off the
-			 * event.
-			 */
-			sparc_pmu_disable_event(cpuc, hwc, idx);
-			barrier();
-			sparc_perf_event_update(event, hwc, idx);
-
 			perf_event_update_userpage(event);
 
 			cpuc->n_events--;
@@ -752,19 +794,6 @@ static void sparc_pmu_disable(struct per
 	local_irq_restore(flags);
 }
 
-static int active_event_index(struct cpu_hw_events *cpuc,
-			      struct perf_event *event)
-{
-	int i;
-
-	for (i = 0; i < cpuc->n_events; i++) {
-		if (cpuc->event[i] == event)
-			break;
-	}
-	BUG_ON(i == cpuc->n_events);
-	return cpuc->current_idx[i];
-}
-
 static void sparc_pmu_read(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -774,15 +803,6 @@ static void sparc_pmu_read(struct perf_e
 	sparc_perf_event_update(event, hwc, idx);
 }
 
-static void sparc_pmu_unthrottle(struct perf_event *event)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	int idx = active_event_index(cpuc, event);
-	struct hw_perf_event *hwc = &event->hw;
-
-	sparc_pmu_enable_event(cpuc, hwc, idx);
-}
-
 static atomic_t active_events = ATOMIC_INIT(0);
 static DEFINE_MUTEX(pmc_grab_mutex);
 
@@ -984,7 +1004,7 @@ static int collect_events(struct perf_ev
 	return n;
 }
 
-static int sparc_pmu_enable(struct perf_event *event)
+static int sparc_pmu_add(struct perf_event *event, int ef_flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int n0, ret = -EAGAIN;
@@ -1001,6 +1021,10 @@ static int sparc_pmu_enable(struct perf_
 	cpuc->events[n0] = event->hw.event_base;
 	cpuc->current_idx[n0] = PIC_NO_INDEX;
 
+	event->hw.state = PERF_HES_UPTODATE;
+	if (!(ef_flags & PERF_EF_START))
+		event->hw.state |= PERF_HES_STOPPED;
+
 	/*
 	 * If group events scheduling transaction was started,
 	 * skip the schedulability test here, it will be peformed
@@ -1156,13 +1180,14 @@ static int sparc_pmu_commit_txn(struct p
 }
 
 static struct pmu pmu = {
-	.pmu_enable	= sparc_pmu_pmu_enable,
-	.pmu_disable	= sparc_pmu_pmu_disable,
+	.pmu_enable	= sparc_pmu_enable,
+	.pmu_disable	= sparc_pmu_disable,
 	.event_init	= sparc_pmu_event_init,
-	.enable		= sparc_pmu_enable,
-	.disable	= sparc_pmu_disable,
+	.add		= sparc_pmu_add,
+	.del		= sparc_pmu_del,
+	.start		= sparc_pmu_start,
+	.stop		= sparc_pmu_stop,
 	.read		= sparc_pmu_read,
-	.unthrottle	= sparc_pmu_unthrottle,
 	.start_txn	= sparc_pmu_start_txn,
 	.cancel_txn	= sparc_pmu_cancel_txn,
 	.commit_txn	= sparc_pmu_commit_txn,
@@ -1243,7 +1268,7 @@ static int __kprobes perf_event_nmi_hand
 			continue;
 
 		if (perf_event_overflow(event, 1, &data, regs))
-			sparc_pmu_disable_event(cpuc, hwc, idx);
+			sparc_pmu_stop(event, 0);
 	}
 
 	return NOTIFY_STOP;
Index: linux-2.6/include/linux/ftrace_event.h
===================================================================
--- linux-2.6.orig/include/linux/ftrace_event.h
+++ linux-2.6/include/linux/ftrace_event.h
@@ -252,8 +252,8 @@ DECLARE_PER_CPU(struct pt_regs, perf_tra
 
 extern int  perf_trace_init(struct perf_event *event);
 extern void perf_trace_destroy(struct perf_event *event);
-extern int  perf_trace_enable(struct perf_event *event);
-extern void perf_trace_disable(struct perf_event *event);
+extern int  perf_trace_add(struct perf_event *event, int flags);
+extern void perf_trace_del(struct perf_event *event, int flags);
 extern int  ftrace_profile_set_filter(struct perf_event *event, int event_id,
 				     char *filter_str);
 extern void ftrace_profile_free_filter(struct perf_event *event);
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -538,6 +538,7 @@ struct hw_perf_event {
 		};
 #endif
 	};
+	int				state;
 	local64_t			prev_count;
 	u64				sample_period;
 	u64				last_period;
@@ -549,6 +550,13 @@ struct hw_perf_event {
 #endif
 };
 
+/*
+ * hw_perf_event::state flags
+ */
+#define PERF_HES_STOPPED	0x01 /* the counter is stopped */
+#define PERF_HES_UPTODATE	0x02 /* event->count up-to-date */
+#define PERF_HES_ARCH		0x04
+
 struct perf_event;
 
 /*
@@ -564,42 +572,62 @@ struct pmu {
 
 	int				*pmu_disable_count;
 
+	/*
+	 * Fully disable/enable this PMU, can be used to protect from the PMI
+	 * as well as for lazy/batch writing of the MSRs.
+	 */
 	void (*pmu_enable)		(struct pmu *pmu); /* optional */
 	void (*pmu_disable)		(struct pmu *pmu); /* optional */
 
 	/*
+	 * Try and initialize the event for this PMU.
 	 * Should return -ENOENT when the @event doesn't match this PMU.
 	 */
 	int (*event_init)		(struct perf_event *event);
 
-	int  (*enable)			(struct perf_event *event);
-	void (*disable)			(struct perf_event *event);
-	int  (*start)			(struct perf_event *event);
-	void (*stop)			(struct perf_event *event);
+#define PERF_EF_START	0x01		/* start the counter when adding    */
+#define PERF_EF_RELOAD	0x02		/* reload the counter when starting */
+#define PERF_EF_UPDATE	0x04		/* update the counter when stopping */
+
+	/*
+	 * Adds/Removes a counter to/from the PMU, can be done inside
+	 * a transaction, see the ->*_txn() methods.
+	 */
+	int  (*add)			(struct perf_event *event, int flags);
+	void (*del)			(struct perf_event *event, int flags);
+
+	/*
+	 * Starts/Stops a counter present on the PMU. The PMI handler
+	 * should stop the counter when perf_event_overflow() returns
+	 * !0. ->start() will be used to continue.
+	 */
+	void (*start)			(struct perf_event *event, int flags);
+	void (*stop)			(struct perf_event *event, int flags);
+
+	/*
+	 * Updates the counter value of the event.
+	 */
 	void (*read)			(struct perf_event *event);
-	void (*unthrottle)		(struct perf_event *event);
 
 	/*
 	 * Group events scheduling is treated as a transaction, add
 	 * group events as a whole and perform one schedulability test.
 	 * If the test fails, roll back the whole group
-	 */
-
-	/*
-	 * Start the transaction, after this ->enable() doesn't need to
+	 *
+	 * Start the transaction, after this ->add() doesn't need to
 	 * do schedulability tests.
 	 */
 	void (*start_txn)	(struct pmu *pmu); /* optional */
 	/*
-	 * If ->start_txn() disabled the ->enable() schedulability test
+	 * If ->start_txn() disabled the ->add() schedulability test
 	 * then ->commit_txn() is required to perform one. On success
 	 * the transaction is closed. On error the transaction is kept
 	 * open until ->cancel_txn() is called.
 	 */
 	int  (*commit_txn)	(struct pmu *pmu); /* optional */
 	/*
-	 * Will cancel the transaction, assumes ->disable() is called
-	 * for each successfull ->enable() during the transaction.
+	 * Will cancel the transaction, assumes ->del() is called
+	 * for each successfull ->add() during the transaction.
 	 */
 	void (*cancel_txn)	(struct pmu *pmu); /* optional */
 };
@@ -680,7 +708,7 @@ struct perf_event {
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
-	struct pmu		*pmu;
+	struct pmu			*pmu;
 
 	enum perf_event_active_state	state;
 	unsigned int			attach_state;
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -763,7 +763,7 @@ static int intel_pmu_handle_irq(struct p
 		data.period = event->hw.last_period;
 
 		if (perf_event_overflow(event, 1, &data, regs))
-			x86_pmu_stop(event);
+			x86_pmu_stop(event, 0);
 	}
 
 	/*
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -491,7 +491,7 @@ static void __intel_pmu_pebs_event(struc
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
 	if (perf_event_overflow(event, 1, &data, &regs))
-		x86_pmu_stop(event);
+		x86_pmu_stop(event, 0);
 }
 
 static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
Index: linux-2.6/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6.orig/kernel/hw_breakpoint.c
+++ linux-2.6/kernel/hw_breakpoint.c
@@ -586,10 +586,35 @@ static int hw_breakpoint_event_init(stru
 	return 0;
 }
 
+static int hw_breakpoint_add(struct perf_event *bp, int flags)
+{
+	if (!(flags & PERF_EF_START))
+		bp->hw.state = PERF_HES_STOPPED;
+
+	return arch_install_hw_breakpoint(bp);
+}
+
+static void hw_breakpoint_del(struct perf_event *bp, int flags)
+{
+	arch_uninstall_hw_breakpoint(bp);
+}
+
+static void hw_breakpoint_start(struct perf_event *bp, int flags)
+{
+	bp->hw.state = 0;
+}
+
+static void hw_breakpoint_stop(struct perf_event *bp, int flags)
+{
+	bp->hw.state = PERF_HES_STOPPED;
+}
+
 static struct pmu perf_breakpoint = {
 	.event_init	= hw_breakpoint_event_init,
-	.enable		= arch_install_hw_breakpoint,
-	.disable	= arch_uninstall_hw_breakpoint,
+	.add		= hw_breakpoint_add,
+	.del		= hw_breakpoint_del,
+	.start		= hw_breakpoint_start,
+	.stop		= hw_breakpoint_stop,
 	.read		= hw_breakpoint_pmu_read,
 };
 
Index: linux-2.6/arch/alpha/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/perf_event.c
+++ linux-2.6/arch/alpha/kernel/perf_event.c
@@ -307,7 +307,7 @@ static unsigned long alpha_perf_event_up
 			     new_raw_count) != prev_raw_count)
 		goto again;
 
-	delta = (new_raw_count  - (prev_raw_count & alpha_pmu->pmc_count_mask[idx])) + ovf;
+	delta = (new_raw_count - (prev_raw_count & alpha_pmu->pmc_count_mask[idx])) + ovf;
 
 	/* It is possible on very rare occasions that the PMC has overflowed
 	 * but the interrupt is yet to come.  Detect and fix this situation.
@@ -402,14 +402,13 @@ static void maybe_change_configuration(s
 		struct hw_perf_event *hwc = &pe->hw;
 		int idx = hwc->idx;
 
-		if (cpuc->current_idx[j] != PMC_NO_INDEX) {
-			cpuc->idx_mask |= (1<<cpuc->current_idx[j]);
-			continue;
+		if (cpuc->current_idx[j] == PMC_NO_INDEX) {
+			alpha_perf_event_set_period(pe, hwc, idx);
+			cpuc->current_idx[j] = idx;
 		}
 
-		alpha_perf_event_set_period(pe, hwc, idx);
-		cpuc->current_idx[j] = idx;
-		cpuc->idx_mask |= (1<<cpuc->current_idx[j]);
+		if (!(hwc->state & PERF_HES_STOPPED))
+			cpuc->idx_mask |= (1<<cpuc->current_idx[j]);
 	}
 	cpuc->config = cpuc->event[0]->hw.config_base;
 }
@@ -420,7 +419,7 @@ static void maybe_change_configuration(s
  *  - this function is called from outside this module via the pmu struct
  *    returned from perf event initialisation.
  */
-static int alpha_pmu_enable(struct perf_event *event)
+static int alpha_pmu_add(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int n0;
@@ -455,6 +454,10 @@ static int alpha_pmu_enable(struct perf_
 		}
 	}
 
+	hwc->state = PERF_HES_UPTODATE;
+	if (!(flags & PERF_EF_START))
+		hwc->state |= PERF_HES_STOPPED;
+
 	local_irq_restore(flags);
 	perf_pmu_enable(event->pmu);
 
@@ -467,7 +470,7 @@ static int alpha_pmu_enable(struct perf_
  *  - this function is called from outside this module via the pmu struct
  *    returned from perf event initialisation.
  */
-static void alpha_pmu_disable(struct perf_event *event)
+static void alpha_pmu_del(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
@@ -514,13 +517,44 @@ static void alpha_pmu_read(struct perf_e
 }
 
 
-static void alpha_pmu_unthrottle(struct perf_event *event)
+static void alpha_pmu_stop(struct perf_event *event, int flags)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
+	if (!(hwc->state & PERF_HES_STOPPED)) {
+		cpuc->idx_mask &= !(1UL<<hwc->idx);
+		hwc->state |= PERF_HES_STOPPED;
+	}
+
+	if ((flags & PERF_EF_UPDATE) && !(hwc->state & PERF_HES_UPTODATE)) {
+		alpha_perf_event_update(event, hwc, hwc->idx, 0);
+		hwc->state |= PERF_HES_UPTODATE;
+	}
+
+	if (cpuc->enabled)
+		wrperfmon(PERFMON_CMD_ENABLE, (1UL<<hwc->idx));
+}
+
+
+static void alpha_pmu_start(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
+		return;
+
+	if (flags & PERF_EF_RELOAD) {
+		WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));
+		alpha_perf_event_set_period(event, hwc, hwc->idx);
+	}
+
+	hwc->state = 0;
+
 	cpuc->idx_mask |= 1UL<<hwc->idx;
-	wrperfmon(PERFMON_CMD_ENABLE, (1UL<<hwc->idx));
+	if (cpuc->enabled)
+		wrperfmon(PERFMON_CMD_ENABLE, (1UL<<hwc->idx));
 }
 
 
@@ -671,7 +705,7 @@ static int alpha_pmu_event_init(struct p
 /*
  * Main entry point - enable HW performance counters.
  */
-static void alpha_pmu_pmu_enable(struct pmu *pmu)
+static void alpha_pmu_enable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -697,7 +731,7 @@ static void alpha_pmu_pmu_enable(struct 
  * Main entry point - disable HW performance counters.
  */
 
-static void alpha_pmu_pmu_disable(struct pmu *pmu)
+static void alpha_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -711,13 +745,14 @@ static void alpha_pmu_pmu_disable(struct
 }
 
 static struct pmu pmu = {
-	.pmu_enable	= alpha_pmu_pmu_enable,
-	.pmu_disable	= alpha_pmu_pmu_disable,
+	.pmu_enable	= alpha_pmu_enable,
+	.pmu_disable	= alpha_pmu_disable,
 	.event_init	= alpha_pmu_event_init,
-	.enable		= alpha_pmu_enable,
-	.disable	= alpha_pmu_disable,
+	.add		= alpha_pmu_add,
+	.del		= alpha_pmu_del,
+	.start		= alpha_pmu_start,
+	.stop		= alpha_pmu_stop,
 	.read		= alpha_pmu_read,
-	.unthrottle	= alpha_pmu_unthrottle,
 };
 
 


