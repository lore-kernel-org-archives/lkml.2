Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab0FPQIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:08:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47310 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200Ab0FPQGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:06:34 -0400
Message-Id: <20100616160238.721536975@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 16 Jun 2010 18:00:35 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 8/8] perf: Rework the PMU methods
References: <20100616160027.590430763@chello.nl>
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

XXX: implement: ARM, SPARC, POWERPC

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/sh/kernel/perf_event.c      |   67 +++++++++++++-----
 arch/x86/kernel/cpu/perf_event.c |   93 +++++++++++++------------
 include/linux/perf_event.h       |   40 ++++++++---
 kernel/hw_breakpoint.c           |   33 ++++++++-
 kernel/perf_event.c              |  140 ++++++++++++++++++++-------------------
 kernel/trace/trace_event_perf.c  |    6 +
 6 files changed, 236 insertions(+), 143 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -133,6 +133,12 @@ struct cpu_hw_events {
 	struct amd_nb		*amd_nb;
 };
 
+/*
+ * hw_perf_event::state flags
+ */
+#define HES_STOPPED	0x01
+#define HES_UPTODATE	0x02
+
 #define __EVENT_CONSTRAINT(c, n, m, w) {\
 	{ .idxmsk64 = (n) },		\
 	.code = (c),			\
@@ -800,8 +806,8 @@ static inline int match_prev_assignment(
 		hwc->last_tag == cpuc->tags[i];
 }
 
-static int x86_pmu_start(struct perf_event *event);
-static void x86_pmu_stop(struct perf_event *event);
+static int x86_pmu_start(struct perf_event *event, int flags);
+static void x86_pmu_stop(struct perf_event *event, int flags);
 
 static void x86_pmu_pmu_enable(struct pmu *pmu)
 {
@@ -839,7 +845,7 @@ static void x86_pmu_pmu_enable(struct pm
 			    match_prev_assignment(hwc, cpuc, i))
 				continue;
 
-			x86_pmu_stop(event);
+			x86_pmu_stop(event, PERF_EF_UPDATE);
 		}
 
 		for (i = 0; i < cpuc->n_events; i++) {
@@ -851,7 +857,8 @@ static void x86_pmu_pmu_enable(struct pm
 			else if (i < n_running)
 				continue;
 
-			x86_pmu_start(event);
+			if (!(event->hw.state & HES_STOPPED))
+				x86_pmu_start(event, PERF_EF_RELOAD);
 		}
 		cpuc->n_added = 0;
 		perf_events_lapic_init();
@@ -952,15 +959,12 @@ static void x86_pmu_enable_event(struct 
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
@@ -975,10 +979,14 @@ static int x86_pmu_enable(struct perf_ev
 	if (ret < 0)
 		goto out;
 
+	hwc->state = HES_UPTODATE;
+	if (!(flags & PERF_EF_START))
+		hwc->state |= HES_STOPPED;
+
 	/*
 	 * If group events scheduling transaction was started,
 	 * skip the schedulability test here, it will be peformed
-	 * at commit time(->commit_txn) as a whole
+	 * at commit time (->commit_txn) as a whole
 	 */
 	if (cpuc->group_flag & PERF_EVENT_TXN)
 		goto done_collect;
@@ -1003,27 +1011,24 @@ out:
 	return ret;
 }
 
-static int x86_pmu_start(struct perf_event *event)
+static void x86_pmu_start(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx = event->hw.idx;
 
-	if (idx == -1)
-		return -EAGAIN;
+	if (WARN_ON_ONCE(idx == -1))
+		return;
+
+	if (flags & PERF_EF_RELOAD) {
+		WARN_ON_ONCE(!(event->hw.state & HES_UPTODATE));
+		x86_perf_event_set_period(event);
+	}
 
-	x86_perf_event_set_period(event);
 	cpuc->events[idx] = event;
 	__set_bit(idx, cpuc->active_mask);
+	event->hw.state = 0;
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
@@ -1080,27 +1085,25 @@ void perf_event_print_debug(void)
 	local_irq_restore(flags);
 }
 
-static void x86_pmu_stop(struct perf_event *event)
+static void x86_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct hw_perf_event *hwc = &event->hw;
-	int idx = hwc->idx;
-
 	if (!__test_and_clear_bit(idx, cpuc->active_mask))
-		return;
-
-	x86_pmu.disable(event);
-
-	/*
-	 * Drain the remaining delta count out of a event
-	 * that we are disabling:
-	 */
-	x86_perf_event_update(event);
+		x86_pmu.disable(event);
+		cpuc->events[idx] = NULL;
+		event->hw.state |= HES_STOPPED;
+	}
 
-	cpuc->events[idx] = NULL;
+	if ((flags & PERF_EF_UPDATE) && !(event->hw.state & HES_UPTODATE)) {
+		/*
+		 * Drain the remaining delta count out of a event
+		 * that we are disabling:
+		 */
+		x86_perf_event_update(event);
+		event->hw.state |= HES_UPTODATE;
+	}
 }
 
-static void x86_pmu_disable(struct perf_event *event)
+static void x86_pmu_del(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int i;
@@ -1113,7 +1116,7 @@ static void x86_pmu_disable(struct perf_
 	if (cpuc->group_flag & PERF_EVENT_TXN)
 		return;
 
-	x86_pmu_stop(event);
+	x86_pmu_stop(event, PERF_EF_UPDATE);
 
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event_list[i]) {
@@ -1165,7 +1168,7 @@ static int x86_pmu_handle_irq(struct pt_
 			continue;
 
 		if (perf_event_overflow(event, 1, &data, regs))
-			x86_pmu_stop(event);
+			x86_pmu_stop(event, 0);
 	}
 
 	if (handled)
@@ -1574,13 +1577,15 @@ int x86_pmu_event_init(struct perf_event
 static struct pmu pmu = {
 	.pmu_enable	= x86_pmu_pmu_enable,
 	.pmu_disable	= x86_pmu_pmu_disable,
-	.event_init	= x86_pmu_event_init
-	.enable		= x86_pmu_enable,
-	.disable	= x86_pmu_disable,
+
+	.event_init	= x86_pmu_event_init,
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
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -529,7 +529,6 @@ struct hw_perf_event {
 			int		last_cpu;
 		};
 		struct { /* software */
-			s64		remaining;
 			struct hrtimer	hrtimer;
 		};
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
@@ -537,6 +536,7 @@ struct hw_perf_event {
 		struct arch_hw_breakpoint	info;
 #endif
 	};
+	int				state;
 	local64_t			prev_count;
 	u64				sample_period;
 	u64				last_period;
@@ -563,28 +563,48 @@ struct pmu {
 
 	int				*pmu_disable_count;
 
+	/*
+	 * Fully disable/enable this PMU, can be used to protect from the PMI
+	 * as well as for lazy/batch writing of the MSRs.
+	 */
 	void (*pmu_enable)		(struct pmu *pmu);
 	void (*pmu_disable)		(struct pmu *pmu);
 
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
+	 *
 	 * Start the transaction, after this ->enable() doesn't need to
 	 * do schedulability tests.
 	 */
@@ -679,7 +699,7 @@ struct perf_event {
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
-	struct pmu		*pmu;
+	struct pmu			*pmu;
 
 	enum perf_event_active_state	state;
 	unsigned int			attach_state;
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -404,7 +404,7 @@ event_sched_out(struct perf_event *event
 		event->state = PERF_EVENT_STATE_OFF;
 	}
 	event->tstamp_stopped = ctx->time;
-	event->pmu->disable(event);
+	event->pmu->del(event, 0);
 	event->oncpu = -1;
 
 	if (!is_software_event(event))
@@ -631,7 +631,7 @@ event_sched_in(struct perf_event *event,
 	 */
 	smp_wmb();
 
-	if (event->pmu->enable(event)) {
+	if (event->pmu->add(event, PERF_EF_START)) {
 		event->state = PERF_EVENT_STATE_INACTIVE;
 		event->oncpu = -1;
 		return -EAGAIN;
@@ -1465,22 +1465,6 @@ do {					\
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
@@ -1500,9 +1484,9 @@ static void perf_adjust_period(struct pe
 	hwc->sample_period = sample_period;
 
 	if (local64_read(&hwc->period_left) > 8*sample_period) {
-		perf_event_stop(event);
+		event->pmu->stop(event, PERF_EF_UPDATE);
 		local64_set(&hwc->period_left, 0);
-		perf_event_start(event);
+		event->pmu->start(event, PERF_EF_RELOAD);
 	}
 }
 
@@ -1531,7 +1515,7 @@ static void perf_ctx_adjust_freq(struct 
 		 */
 		if (interrupts == MAX_INTERRUPTS) {
 			perf_log_throttle(event, 1);
-			event->pmu->unthrottle(event);
+			event->pmu->start(event, 0);
 		}
 
 		if (!event->attr.freq || !event->attr.sample_freq)
@@ -3900,8 +3884,6 @@ static int __perf_event_overflow(struct 
 	struct hw_perf_event *hwc = &event->hw;
 	int ret = 0;
 
-	throttle = (throttle && event->pmu->unthrottle != NULL);
-
 	if (!throttle) {
 		hwc->interrupts++;
 	} else {
@@ -4069,6 +4051,9 @@ static int perf_swevent_match(struct per
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
+	if (event->hw.state)
+		return 0;
+
 	if (event->attr.type != type)
 		return 0;
 
@@ -4211,7 +4196,7 @@ static void perf_swevent_read(struct per
 {
 }
 
-static int perf_swevent_enable(struct perf_event *event)
+static int perf_swevent_add(struct perf_event *event, int flags)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct perf_cpu_context *cpuctx;
@@ -4224,6 +4209,8 @@ static int perf_swevent_enable(struct pe
 		perf_swevent_set_period(event);
 	}
 
+	hwc->state = !(flags & PERF_EF_START);
+
 	head = find_swevent_head(cpuctx, event);
 	if (WARN_ON_ONCE(!head))
 		return -EINVAL;
@@ -4233,13 +4220,19 @@ static int perf_swevent_enable(struct pe
 	return 0;
 }
 
-static void perf_swevent_disable(struct perf_event *event)
+static void perf_swevent_del(struct perf_event *event, int flags)
 {
 	hlist_del_rcu(&event->hlist_entry);
 }
 
-static void perf_swevent_void(struct perf_event *event)
+static void perf_swevent_start(struct perf_event *event, int flags)
+{
+	event->hw.state = 0;
+}
+
+static void perf_swevent_stop(struct perf_event *event, int flags)
 {
+	event->hw.state = 1;
 }
 
 /* Deref the hlist from the update side */
@@ -4393,12 +4386,11 @@ static int perf_swevent_int(struct perf_
 
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
@@ -4485,12 +4477,11 @@ static int perf_tp_event_init(struct per
 
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
@@ -4546,7 +4537,7 @@ void perf_bp_event(struct perf_event *bp
 
 	perf_sample_data_init(&sample, bp->attr.bp_addr);
 
-	if (!perf_exclude_event(bp, regs))
+	if (!bp->hw.state && !perf_exclude_event(bp, regs))
 		perf_swevent_add(bp, 1, 1, &sample, regs);
 }
 #endif
@@ -4591,12 +4582,12 @@ static void perf_swevent_start_hrtimer(s
 	if (hwc->sample_period) {
 		u64 period;
 
-		if (hwc->remaining) {
-			if (hwc->remaining < 0)
+		if (hwc->period_left) {
+			if (hwc->period_left < 0)
 				period = 10000;
 			else
-				period = hwc->remaining;
-			hwc->remaining = 0;
+				period = hwc->period_left;
+			hwc->period_left = 0;
 		} else {
 			period = max_t(u64, 10000, hwc->sample_period);
 		}
@@ -4611,8 +4602,8 @@ static void perf_swevent_cancel_hrtimer(
 	struct hw_perf_event *hwc = &event->hw;
 
 	if (hwc->sample_period) {
-		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
-		hwc->remaining = ktime_to_ns(remaining);
+		ktime_t period_left = hrtimer_get_period_left(&hwc->hrtimer);
+		hwc->period_left = ktime_to_ns(period_left);
 
 		hrtimer_cancel(&hwc->hrtimer);
 	}
@@ -4624,32 +4615,39 @@ static void perf_swevent_cancel_hrtimer(
 
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
@@ -4668,8 +4666,10 @@ static int cpu_clock_event_init(struct p
 
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
 
@@ -4687,25 +4687,27 @@ static void task_clock_event_update(stru
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
 
+static int task_clock_event_add(struct perf_event *event, int flags)
+{
+	if (flags & PERF_EF_START)
+		task_clock_event_start(event, flags);
+}
+
+static void task_clock_event_stop(struct perf_event *event, int flags)
+{
+	task_clock_event_stop(event, flags);
 }
 
 static void task_clock_event_read(struct perf_event *event)
@@ -4737,8 +4739,10 @@ static int task_clock_event_init(struct 
 
 static struct pmu perf_ops_clock = {
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
@@ -107,7 +107,7 @@ int perf_trace_init(struct perf_event *p
 	return ret;
 }
 
-int perf_trace_enable(struct perf_event *p_event)
+int perf_trace_add(struct perf_event *p_event, int flags)
 {
 	struct ftrace_event_call *tp_event = p_event->tp_event;
 	struct hlist_head *list;
@@ -116,13 +116,15 @@ int perf_trace_enable(struct perf_event 
 	if (WARN_ON_ONCE(!list))
 		return -EINVAL;
 
+	p_event->hw.stopped = !(flags & PERF_EF_START);
+
 	list = this_cpu_ptr(list);
 	hlist_add_head_rcu(&p_event->hlist_entry, list);
 
 	return 0;
 }
 
-void perf_trace_disable(struct perf_event *p_event)
+void perf_trace_del(struct perf_event *p_event, int flags)
 {
 	hlist_del_rcu(&p_event->hlist_entry);
 }
Index: linux-2.6/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6.orig/kernel/hw_breakpoint.c
+++ linux-2.6/kernel/hw_breakpoint.c
@@ -570,10 +570,39 @@ static struct pmu *bp_perf_event_init(st
 	return 0;
 }
 
+static int hw_breakpoint_add(struct perf_event *event, int flags)
+{
+	int ret;
+
+	ret = arch_install_hw_breakpoint(event);
+	if (ret)
+		return ret;
+
+	event->hw.state = !(flags & PERF_EF_START);
+	return 0;
+}
+
+static void hw_breakpoint_del(struct perf_event *event, int flags)
+{
+	arch_uninstall_hw_breakpoint(event);
+}
+
+static void hw_breakpoint_start(struct perf_event *event, int flags)
+{
+	event->hw.state = 0;
+}
+
+static void hw_breakpoint_stop(struct perf_event *event, int flags)
+{
+	event->hw.state = 1;
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
 
Index: linux-2.6/arch/sh/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/perf_event.c
+++ linux-2.6/arch/sh/kernel/perf_event.c
@@ -30,9 +30,14 @@
 struct cpu_hw_events {
 	struct perf_event	*events[MAX_HWEVENTS];
 	unsigned long		used_mask[BITS_TO_LONGS(MAX_HWEVENTS)];
-	unsigned long		active_mask[BITS_TO_LONGS(MAX_HWEVENTS)];
 };
 
+/*
+ * hw_perf_event::state flags
+ */
+#define HES_STOPPED	0x01
+#define HES_UPTODATE	0x02
+
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
 
 static struct sh_pmu *sh_pmu __read_mostly;
@@ -206,46 +211,72 @@ again:
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
+	if (!(event->hw.state & HES_STOPPED)) {
+		sh_pmu->disable(hwc, idx);
+		cpuc->events[idx] = NULL;
+		event->hw.state |= HES_STOPPED;
+	}
+
+	if ((flags & PERF_EF_UPDATE) && !(event->hw.state & HES_UPTODATE)) {
+		sh_perf_event_update(event, &event->hw, idx);
+		event->hw.state |= HES_UPTODATE;
+	}
+}
+
+static void sh_pmu_start(struct perf_event *event, int flags)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+	int idx = hwc->idx;
+
+	if (WARN_ON_ONCE(idx == -1))
+		return;
 
-	barrier();
+	if (flags & PERF_EF_RELOAD)
+		WARN_ON_ONCE(!(event->hw.state & HES_UPTODATE));
+
+	cpuc->events[idx] = event;
+	event->hw.state = 0;
+	sh_pmu->enable(hwc, idx);
+}
 
-	sh_perf_event_update(event, &event->hw, idx);
+static void sh_pmu_del(struct perf_event *event, int flags)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	cpuc->events[idx] = NULL;
-	clear_bit(idx, cpuc->used_mask);
+	sh_pmu_stop(event, PERF_EF_UPDATE);
+	__clear_bit(event->hw.idx, cpuc->used_mask);
 
 	perf_event_update_userpage(event);
 }
 
-static int sh_pmu_enable(struct perf_event *event)
+static int sh_pmu_enable(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
-	if (test_and_set_bit(idx, cpuc->used_mask)) {
+	if (__test_and_set_bit(idx, cpuc->used_mask)) {
 		idx = find_first_zero_bit(cpuc->used_mask, sh_pmu->num_events);
 		if (idx == sh_pmu->num_events)
 			return -EAGAIN;
 
-		set_bit(idx, cpuc->used_mask);
 		hwc->idx = idx;
 	}
 
 	sh_pmu->disable(hwc, idx);
 
-	cpuc->events[idx] = event;
-	set_bit(idx, cpuc->active_mask);
-
-	sh_pmu->enable(hwc, idx);
+	event->hw.state = HES_UPTODATE;
+	if (!(flags & PERF_EF_START))
+		event->hw.state = HES_STOPPED;
+	else
+		sh_pmu_start(event, PERF_EF_RELOAD);
 
 	perf_event_update_userpage(event);
 
@@ -288,8 +319,10 @@ static struct pmu pmu = {
 	.pmu_enable	= sh_pmu_pmu_enable,
 	.pmu_disable	= sh_pmu_pmu_disable,
 	.event_init	= sh_pmu_event_init,
-	.enable		= sh_pmu_enable,
-	.disable	= sh_pmu_disable,
+	.add		= sh_pmu_add,
+	.del		= sh_pmu_del,
+	.start		= sh_pmu_start,
+	.stop		= sh_pmu_stop,
 	.read		= sh_pmu_read,
 };
 


