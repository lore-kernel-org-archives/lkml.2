Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab0FPQGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:06:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47308 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759194Ab0FPQGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:06:33 -0400
Message-Id: <20100616160238.431137125@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 16 Jun 2010 18:00:32 +0200
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
Subject: [RFC][PATCH 5/8] perf: Reduce perf_disable() usage
References: <20100616160027.590430763@chello.nl>
Content-Disposition: inline; filename=perf-less-disable-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the current perf_disable() usage is only an optimization, remove
it for now. This eases the removal of the weak hw_perf_enable
interface.

[ Some comments talk about NMI races, but I cannot find any such
  things. ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/kernel/perf_event.c         |    3 ++
 arch/powerpc/kernel/perf_event_fsl_emb.c |    8 +++++-
 arch/sparc/kernel/perf_event.c           |    3 ++
 arch/x86/kernel/cpu/perf_event.c         |   22 +++++++++++-------
 include/linux/perf_event.h               |   20 ++++++++--------
 kernel/perf_event.c                      |   37 -------------------------------
 6 files changed, 37 insertions(+), 56 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -562,26 +562,26 @@ struct pmu {
 	struct list_head		entry;
 
 	/*
-	 * Should return -ENOENT when the @event doesn't match this pmu
+	 * Should return -ENOENT when the @event doesn't match this PMU.
 	 */
 	int (*event_init)		(struct perf_event *event);
 
-	int (*enable)			(struct perf_event *event);
+	int  (*enable)			(struct perf_event *event);
 	void (*disable)			(struct perf_event *event);
-	int (*start)			(struct perf_event *event);
+	int  (*start)			(struct perf_event *event);
 	void (*stop)			(struct perf_event *event);
 	void (*read)			(struct perf_event *event);
 	void (*unthrottle)		(struct perf_event *event);
 
 	/*
-	 * Group events scheduling is treated as a transaction, add group
-	 * events as a whole and perform one schedulability test. If the test
-	 * fails, roll back the whole group
+	 * Group events scheduling is treated as a transaction, add
+	 * group events as a whole and perform one schedulability test.
+	 * If the test fails, roll back the whole group
 	 */
 
 	/*
-	 * Start the transaction, after this ->enable() doesn't need
-	 * to do schedulability tests.
+	 * Start the transaction, after this ->enable() doesn't need to
+	 * do schedulability tests.
 	 */
 	void (*start_txn)	(struct pmu *pmu);
 	/*
@@ -592,8 +592,8 @@ struct pmu {
 	 */
 	int  (*commit_txn)	(struct pmu *pmu);
 	/*
-	 * Will cancel the transaction, assumes ->disable() is called for
-	 * each successfull ->enable() during the transaction.
+	 * Will cancel the transaction, assumes ->disable() is called
+	 * for each successfull ->enable() during the transaction.
 	 */
 	void (*cancel_txn)	(struct pmu *pmu);
 };
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -460,11 +460,6 @@ static void __perf_event_remove_from_con
 		return;
 
 	raw_spin_lock(&ctx->lock);
-	/*
-	 * Protect the list operation against NMI by disabling the
-	 * events on a global level.
-	 */
-	perf_disable();
 
 	event_sched_out(event, cpuctx, ctx);
 
@@ -480,7 +475,6 @@ static void __perf_event_remove_from_con
 			    perf_max_events - perf_reserved_percpu);
 	}
 
-	perf_enable();
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -785,12 +779,6 @@ static void __perf_install_in_context(vo
 	ctx->is_active = 1;
 	update_context_time(ctx);
 
-	/*
-	 * Protect the list operation against NMI by disabling the
-	 * events on a global level. NOP for non NMI based events.
-	 */
-	perf_disable();
-
 	add_event_to_ctx(event, ctx);
 
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
@@ -832,8 +820,6 @@ static void __perf_install_in_context(vo
 		cpuctx->max_pertask--;
 
 unlock:
-	perf_enable();
-
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -954,12 +940,10 @@ static void __perf_event_enable(void *in
 	if (!group_can_go_on(event, cpuctx, 1)) {
 		err = -EEXIST;
 	} else {
-		perf_disable();
 		if (event == leader)
 			err = group_sched_in(event, cpuctx, ctx);
 		else
 			err = event_sched_in(event, cpuctx, ctx);
-		perf_enable();
 	}
 
 	if (err) {
@@ -1072,9 +1056,8 @@ static void ctx_sched_out(struct perf_ev
 		goto out;
 	update_context_time(ctx);
 
-	perf_disable();
 	if (!ctx->nr_active)
-		goto out_enable;
+		goto out;
 
 	if (event_type & EVENT_PINNED) {
 		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
@@ -1085,9 +1068,6 @@ static void ctx_sched_out(struct perf_ev
 		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
-
- out_enable:
-	perf_enable();
 out:
 	raw_spin_unlock(&ctx->lock);
 }
@@ -1346,8 +1326,6 @@ ctx_sched_in(struct perf_event_context *
 
 	ctx->timestamp = perf_clock();
 
-	perf_disable();
-
 	/*
 	 * First go through the list and put on any pinned groups
 	 * in order to give them the best chance of going on.
@@ -1359,7 +1337,6 @@ ctx_sched_in(struct perf_event_context *
 	if (event_type & EVENT_FLEXIBLE)
 		ctx_flexible_sched_in(ctx, cpuctx);
 
-	perf_enable();
 out:
 	raw_spin_unlock(&ctx->lock);
 }
@@ -1407,8 +1384,6 @@ void perf_event_task_sched_in(struct tas
 	if (cpuctx->task_ctx == ctx)
 		return;
 
-	perf_disable();
-
 	/*
 	 * We want to keep the following priority order:
 	 * cpu pinned (that don't need to move), task pinned,
@@ -1421,8 +1396,6 @@ void perf_event_task_sched_in(struct tas
 	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
 
 	cpuctx->task_ctx = ctx;
-
-	perf_enable();
 }
 
 #define MAX_INTERRUPTS (~0ULL)
@@ -1537,11 +1510,9 @@ static void perf_adjust_period(struct pe
 	hwc->sample_period = sample_period;
 
 	if (local64_read(&hwc->period_left) > 8*sample_period) {
-		perf_disable();
 		perf_event_stop(event);
 		local64_set(&hwc->period_left, 0);
 		perf_event_start(event);
-		perf_enable();
 	}
 }
 
@@ -1570,15 +1541,12 @@ static void perf_ctx_adjust_freq(struct 
 		 */
 		if (interrupts == MAX_INTERRUPTS) {
 			perf_log_throttle(event, 1);
-			perf_disable();
 			event->pmu->unthrottle(event);
-			perf_enable();
 		}
 
 		if (!event->attr.freq || !event->attr.sample_freq)
 			continue;
 
-		perf_disable();
 		event->pmu->read(event);
 		now = local64_read(&event->count);
 		delta = now - hwc->freq_count_stamp;
@@ -1586,7 +1554,6 @@ static void perf_ctx_adjust_freq(struct 
 
 		if (delta > 0)
 			perf_adjust_period(event, TICK_NSEC, delta);
-		perf_enable();
 	}
 	raw_spin_unlock(&ctx->lock);
 }
@@ -1629,7 +1596,6 @@ void perf_event_task_tick(struct task_st
 	if (!rotate)
 		return;
 
-	perf_disable();
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
 		task_ctx_sched_out(ctx, EVENT_FLEXIBLE);
@@ -1641,7 +1607,6 @@ void perf_event_task_tick(struct task_st
 	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
 		task_ctx_sched_in(curr, EVENT_FLEXIBLE);
-	perf_enable();
 }
 
 static int event_enable_on_exec(struct perf_event *event,
Index: linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -262,7 +262,7 @@ static int collect_events(struct perf_ev
 	return n;
 }
 
-/* perf must be disabled, context locked on entry */
+/* context locked on entry */
 static int fsl_emb_pmu_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuhw;
@@ -271,6 +271,7 @@ static int fsl_emb_pmu_enable(struct per
 	u64 val;
 	int i;
 
+	perf_disable();
 	cpuhw = &get_cpu_var(cpu_hw_events);
 
 	if (event->hw.config & FSL_EMB_EVENT_RESTRICTED)
@@ -310,15 +311,17 @@ static int fsl_emb_pmu_enable(struct per
 	ret = 0;
  out:
 	put_cpu_var(cpu_hw_events);
+	perf_enable();
 	return ret;
 }
 
-/* perf must be disabled, context locked on entry */
+/* context locked on entry */
 static void fsl_emb_pmu_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuhw;
 	int i = event->hw.idx;
 
+	perf_disable();
 	if (i < 0)
 		goto out;
 
@@ -346,6 +349,7 @@ static void fsl_emb_pmu_disable(struct p
 	cpuhw->n_events--;
 
  out:
+	perf_enable();
 	put_cpu_var(cpu_hw_events);
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -969,10 +969,11 @@ static int x86_pmu_enable(struct perf_ev
 
 	hwc = &event->hw;
 
+	perf_disable();
 	n0 = cpuc->n_events;
-	n = collect_events(cpuc, event, false);
-	if (n < 0)
-		return n;
+	ret = n = collect_events(cpuc, event, false);
+	if (ret < 0)
+		goto out;
 
 	/*
 	 * If group events scheduling transaction was started,
@@ -980,23 +981,26 @@ static int x86_pmu_enable(struct perf_ev
 	 * at commit time(->commit_txn) as a whole
 	 */
 	if (cpuc->group_flag & PERF_EVENT_TXN)
-		goto out;
+		goto done_collect;
 
 	ret = x86_pmu.schedule_events(cpuc, n, assign);
 	if (ret)
-		return ret;
+		goto out;
 	/*
 	 * copy new assignment, now we know it is possible
 	 * will be used by hw_perf_enable()
 	 */
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
-out:
+done_collect:
 	cpuc->n_events = n;
 	cpuc->n_added += n - n0;
 	cpuc->n_txn += n - n0;
 
-	return 0;
+	ret = 0;
+out:
+	perf_enable();
+	return ret;
 }
 
 static int x86_pmu_start(struct perf_event *event)
@@ -1399,6 +1403,7 @@ static void x86_pmu_start_txn(struct pmu
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
+	perf_disable();
 	cpuc->group_flag |= PERF_EVENT_TXN;
 	cpuc->n_txn = 0;
 }
@@ -1418,6 +1423,7 @@ static void x86_pmu_cancel_txn(struct pm
 	 */
 	cpuc->n_added -= cpuc->n_txn;
 	cpuc->n_events -= cpuc->n_txn;
+	perf_enable();
 }
 
 /*
@@ -1447,7 +1453,7 @@ static int x86_pmu_commit_txn(struct pmu
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
 	cpuc->group_flag &= ~PERF_EVENT_TXN;
-
+	perf_enable();
 	return 0;
 }
 
Index: linux-2.6/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event.c
+++ linux-2.6/arch/powerpc/kernel/perf_event.c
@@ -858,6 +858,7 @@ void power_pmu_start_txn(struct pmu *pmu
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
+	perf_disable();
 	cpuhw->group_flag |= PERF_EVENT_TXN;
 	cpuhw->n_txn_start = cpuhw->n_events;
 }
@@ -872,6 +873,7 @@ void power_pmu_cancel_txn(struct pmu *pm
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
+	perf_enable();
 }
 
 /*
@@ -898,6 +900,7 @@ int power_pmu_commit_txn(struct pmu *pmu
 		cpuhw->event[i]->hw.config = cpuhw->events[i];
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
+	perf_enable();
 	return 0;
 }
 
Index: linux-2.6/arch/sparc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/perf_event.c
+++ linux-2.6/arch/sparc/kernel/perf_event.c
@@ -1102,6 +1102,7 @@ static void sparc_pmu_start_txn(struct p
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
+	perf_disable();
 	cpuhw->group_flag |= PERF_EVENT_TXN;
 }
 
@@ -1115,6 +1116,7 @@ static void sparc_pmu_cancel_txn(struct 
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
+	perf_enable();
 }
 
 /*
@@ -1138,6 +1140,7 @@ static int sparc_pmu_commit_txn(struct p
 		return -EAGAIN;
 
 	cpuc->group_flag &= ~PERF_EVENT_TXN;
+	perf_enable();
 	return 0;
 }
 


