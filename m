Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0IITt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:49:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:33025 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab0IITtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:49:25 -0400
Date: Thu, 9 Sep 2010 19:48:41 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, dengcheng.zhu@gmail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, gorcunov@gmail.com, fweisbec@gmail.com,
        robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        eranian@googlemail.com, will.deacon@arm.com, lethal@linux-sh.org,
        davem@davemloft.net, mingo@elte.hu, mcree@orcon.net.nz
Reply-To: mingo@redhat.com, dengcheng.zhu@gmail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, gorcunov@gmail.com, fweisbec@gmail.com,
        robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        eranian@googlemail.com, will.deacon@arm.com, lethal@linux-sh.org,
        davem@davemloft.net, mingo@elte.hu, mcree@orcon.net.nz
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Reduce perf_disable() usage
Message-ID: <tip-24cd7f54a0d47e1d5b3de29e2456bfbd2d8447b7@git.kernel.org>
Git-Commit-ID: 24cd7f54a0d47e1d5b3de29e2456bfbd2d8447b7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:48:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24cd7f54a0d47e1d5b3de29e2456bfbd2d8447b7
Gitweb:     http://git.kernel.org/tip/24cd7f54a0d47e1d5b3de29e2456bfbd2d8447b7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 11 Jun 2010 17:32:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:29 +0200

perf: Reduce perf_disable() usage

Since the current perf_disable() usage is only an optimization,
remove it for now. This eases the removal of the __weak
hw_perf_enable() interface.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Yanmin <yanmin_zhang@linux.intel.com>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: David Miller <davem@davemloft.net>
Cc: Michael Cree <mcree@orcon.net.nz>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/kernel/perf_event.c             |    3 ++
 arch/powerpc/kernel/perf_event.c         |    3 ++
 arch/powerpc/kernel/perf_event_fsl_emb.c |    8 +++++-
 arch/sh/kernel/perf_event.c              |   11 ++++++--
 arch/sparc/kernel/perf_event.c           |    3 ++
 arch/x86/kernel/cpu/perf_event.c         |   22 +++++++++++------
 include/linux/perf_event.h               |   20 ++++++++--------
 kernel/perf_event.c                      |   37 +-----------------------------
 8 files changed, 48 insertions(+), 59 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index f62f9db..afc92c5 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -277,6 +277,8 @@ armpmu_enable(struct perf_event *event)
 	int idx;
 	int err = 0;
 
+	perf_disable();
+
 	/* If we don't have a space for the counter then finish early. */
 	idx = armpmu->get_event_idx(cpuc, hwc);
 	if (idx < 0) {
@@ -303,6 +305,7 @@ armpmu_enable(struct perf_event *event)
 	perf_event_update_userpage(event);
 
 out:
+	perf_enable();
 	return err;
 }
 
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 19131b2..c140882 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -861,6 +861,7 @@ void power_pmu_start_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
+	perf_disable();
 	cpuhw->group_flag |= PERF_EVENT_TXN;
 	cpuhw->n_txn_start = cpuhw->n_events;
 }
@@ -875,6 +876,7 @@ void power_pmu_cancel_txn(struct pmu *pmu)
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
+	perf_enable();
 }
 
 /*
@@ -901,6 +903,7 @@ int power_pmu_commit_txn(struct pmu *pmu)
 		cpuhw->event[i]->hw.config = cpuhw->events[i];
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
+	perf_enable();
 	return 0;
 }
 
diff --git a/arch/powerpc/kernel/perf_event_fsl_emb.c b/arch/powerpc/kernel/perf_event_fsl_emb.c
index ea6a804..9bc84a7 100644
--- a/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ b/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -262,7 +262,7 @@ static int collect_events(struct perf_event *group, int max_count,
 	return n;
 }
 
-/* perf must be disabled, context locked on entry */
+/* context locked on entry */
 static int fsl_emb_pmu_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuhw;
@@ -271,6 +271,7 @@ static int fsl_emb_pmu_enable(struct perf_event *event)
 	u64 val;
 	int i;
 
+	perf_disable();
 	cpuhw = &get_cpu_var(cpu_hw_events);
 
 	if (event->hw.config & FSL_EMB_EVENT_RESTRICTED)
@@ -310,15 +311,17 @@ static int fsl_emb_pmu_enable(struct perf_event *event)
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
 
@@ -346,6 +349,7 @@ static void fsl_emb_pmu_disable(struct perf_event *event)
 	cpuhw->n_events--;
 
  out:
+	perf_enable();
 	put_cpu_var(cpu_hw_events);
 }
 
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 8cb2065..d042989 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -230,11 +230,14 @@ static int sh_pmu_enable(struct perf_event *event)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
+	int ret = -EAGAIN;
+
+	perf_disable();
 
 	if (test_and_set_bit(idx, cpuc->used_mask)) {
 		idx = find_first_zero_bit(cpuc->used_mask, sh_pmu->num_events);
 		if (idx == sh_pmu->num_events)
-			return -EAGAIN;
+			goto out;
 
 		set_bit(idx, cpuc->used_mask);
 		hwc->idx = idx;
@@ -248,8 +251,10 @@ static int sh_pmu_enable(struct perf_event *event)
 	sh_pmu->enable(hwc, idx);
 
 	perf_event_update_userpage(event);
-
-	return 0;
+	ret = 0;
+out:
+	perf_enable();
+	return ret;
 }
 
 static void sh_pmu_read(struct perf_event *event)
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index bed4327..d0131de 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1113,6 +1113,7 @@ static void sparc_pmu_start_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
+	perf_disable();
 	cpuhw->group_flag |= PERF_EVENT_TXN;
 }
 
@@ -1126,6 +1127,7 @@ static void sparc_pmu_cancel_txn(struct pmu *pmu)
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
+	perf_enable();
 }
 
 /*
@@ -1149,6 +1151,7 @@ static int sparc_pmu_commit_txn(struct pmu *pmu)
 		return -EAGAIN;
 
 	cpuc->group_flag &= ~PERF_EVENT_TXN;
+	perf_enable();
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2c89264..846070c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -969,10 +969,11 @@ static int x86_pmu_enable(struct perf_event *event)
 
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
@@ -980,23 +981,26 @@ static int x86_pmu_enable(struct perf_event *event)
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
@@ -1432,6 +1436,7 @@ static void x86_pmu_start_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
+	perf_disable();
 	cpuc->group_flag |= PERF_EVENT_TXN;
 	cpuc->n_txn = 0;
 }
@@ -1451,6 +1456,7 @@ static void x86_pmu_cancel_txn(struct pmu *pmu)
 	 */
 	cpuc->n_added -= cpuc->n_txn;
 	cpuc->n_events -= cpuc->n_txn;
+	perf_enable();
 }
 
 /*
@@ -1480,7 +1486,7 @@ static int x86_pmu_commit_txn(struct pmu *pmu)
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
 	cpuc->group_flag &= ~PERF_EVENT_TXN;
-
+	perf_enable();
 	return 0;
 }
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ab72f56..243286a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -564,26 +564,26 @@ struct pmu {
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
@@ -594,8 +594,8 @@ struct pmu {
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
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 149ca18..9a98ce9 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -478,11 +478,6 @@ static void __perf_event_remove_from_context(void *info)
 		return;
 
 	raw_spin_lock(&ctx->lock);
-	/*
-	 * Protect the list operation against NMI by disabling the
-	 * events on a global level.
-	 */
-	perf_disable();
 
 	event_sched_out(event, cpuctx, ctx);
 
@@ -498,7 +493,6 @@ static void __perf_event_remove_from_context(void *info)
 			    perf_max_events - perf_reserved_percpu);
 	}
 
-	perf_enable();
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -803,12 +797,6 @@ static void __perf_install_in_context(void *info)
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
@@ -850,8 +838,6 @@ static void __perf_install_in_context(void *info)
 		cpuctx->max_pertask--;
 
 unlock:
-	perf_enable();
-
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -972,12 +958,10 @@ static void __perf_event_enable(void *info)
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
@@ -1090,9 +1074,8 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 		goto out;
 	update_context_time(ctx);
 
-	perf_disable();
 	if (!ctx->nr_active)
-		goto out_enable;
+		goto out;
 
 	if (event_type & EVENT_PINNED) {
 		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
@@ -1103,9 +1086,6 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
-
- out_enable:
-	perf_enable();
 out:
 	raw_spin_unlock(&ctx->lock);
 }
@@ -1364,8 +1344,6 @@ ctx_sched_in(struct perf_event_context *ctx,
 
 	ctx->timestamp = perf_clock();
 
-	perf_disable();
-
 	/*
 	 * First go through the list and put on any pinned groups
 	 * in order to give them the best chance of going on.
@@ -1377,7 +1355,6 @@ ctx_sched_in(struct perf_event_context *ctx,
 	if (event_type & EVENT_FLEXIBLE)
 		ctx_flexible_sched_in(ctx, cpuctx);
 
-	perf_enable();
 out:
 	raw_spin_unlock(&ctx->lock);
 }
@@ -1425,8 +1402,6 @@ void perf_event_task_sched_in(struct task_struct *task)
 	if (cpuctx->task_ctx == ctx)
 		return;
 
-	perf_disable();
-
 	/*
 	 * We want to keep the following priority order:
 	 * cpu pinned (that don't need to move), task pinned,
@@ -1439,8 +1414,6 @@ void perf_event_task_sched_in(struct task_struct *task)
 	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
 
 	cpuctx->task_ctx = ctx;
-
-	perf_enable();
 }
 
 #define MAX_INTERRUPTS (~0ULL)
@@ -1555,11 +1528,9 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 	hwc->sample_period = sample_period;
 
 	if (local64_read(&hwc->period_left) > 8*sample_period) {
-		perf_disable();
 		perf_event_stop(event);
 		local64_set(&hwc->period_left, 0);
 		perf_event_start(event);
-		perf_enable();
 	}
 }
 
@@ -1588,15 +1559,12 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
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
@@ -1604,7 +1572,6 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 
 		if (delta > 0)
 			perf_adjust_period(event, TICK_NSEC, delta);
-		perf_enable();
 	}
 	raw_spin_unlock(&ctx->lock);
 }
@@ -1647,7 +1614,6 @@ void perf_event_task_tick(struct task_struct *curr)
 	if (!rotate)
 		return;
 
-	perf_disable();
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
 		task_ctx_sched_out(ctx, EVENT_FLEXIBLE);
@@ -1659,7 +1625,6 @@ void perf_event_task_tick(struct task_struct *curr)
 	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
 		task_ctx_sched_in(curr, EVENT_FLEXIBLE);
-	perf_enable();
 }
 
 static int event_enable_on_exec(struct perf_event *event,
