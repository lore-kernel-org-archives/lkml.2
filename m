Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184Ab2ILONu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:13:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44061 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759151Ab2ILONo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:13:44 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Subject: [PATCH v2 2/3] perf: use hrtimer for event multiplexing
Date: Wed, 12 Sep 2012 16:13:14 +0200
Message-Id: <1347459195-5491-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347459195-5491-1-git-send-email-eranian@google.com>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current scheme of using the timer tick was fine
for per-thread events. However, it was causing
bias issues in system-wide mode (including for
uncore PMUs). Event groups would not get their
fair share of runtime on the PMU. With tickless
kernels, if a core is idle there is no timer tick,
and thus no event rotation (multiplexing). However,
there are events (especially uncore events) which do
count even though cores are asleep.

This patch changes the timer source for multiplexing.
It introduces a per-PMU per-cpu hrtimer. The advantage
is that even when a core goes idle, it will come back
to service the hrtimer, thus multiplexing on system-wide
events works much better.

The per-PMU implementation (suggested by PeterZ) enables
adjusting the multiplexing interval per PMU. The preferred
interval is stashed into the struct pmu. If not set, it
will be forced to the default interval value.

In order to minimize the impact of the hrtimer, it
is turned on and off on demand. When the PMU on
a CPU is overcommited, the hrtimer is activated.
It is stopped when the PMU is not overcommitted.

In order for this to work properly, we had to change
the order of initialization in start_kernel() such
that hrtimer_init() is run before perf_event_init().

The default interval in milliseconds is set to a
timer tick just like with the old code. We will
provide a sysctl to tune this in another patch.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h |    4 +-
 init/main.c                |    2 +-
 kernel/events/core.c       |  123 ++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 118 insertions(+), 11 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cc5e2cd..f299fc8 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1106,8 +1106,10 @@ struct perf_cpu_context {
 	struct perf_event_context	*task_ctx;
 	int				active_oncpu;
 	int				exclusive;
+	struct hrtimer			hrtimer;
 	struct list_head		rotation_list;
-	int				jiffies_interval;
+	ktime_t				hrtimer_interval;
+	int				hrtimer_active;
 	struct pmu			*active_pmu;
 	struct perf_cgroup		*cgrp;
 };
diff --git a/init/main.c b/init/main.c
index b286730..8ffe441 100644
--- a/init/main.c
+++ b/init/main.c
@@ -541,7 +541,6 @@ asmlinkage void __init start_kernel(void)
 		local_irq_disable();
 	}
 	idr_init_cache();
-	perf_event_init();
 	rcu_init();
 	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
@@ -553,6 +552,7 @@ asmlinkage void __init start_kernel(void)
 	softirq_init();
 	timekeeping_init();
 	time_init();
+	perf_event_init();
 	profile_init();
 	call_function_init();
 	if (!irqs_disabled())
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 40f42b8..cf1aec4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -148,6 +148,8 @@ static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
 static struct srcu_struct pmus_srcu;
 
+static DEFINE_PER_CPU(struct list_head, rotation_list);
+
 /*
  * perf event paranoia level:
  *  -1 - not paranoid at all
@@ -168,6 +170,8 @@ int sysctl_perf_event_sample_rate __read_mostly = DEFAULT_MAX_SAMPLE_RATE;
 static int max_samples_per_tick __read_mostly =
 	DIV_ROUND_UP(DEFAULT_MAX_SAMPLE_RATE, HZ);
 
+static int perf_rotate_context(struct perf_cpu_context *cpuctx);
+
 int perf_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
@@ -625,6 +629,100 @@ perf_cgroup_mark_enabled(struct perf_event *event,
 }
 #endif
 
+/*
+ * set default to be dependent on timer tick just
+ * like original code
+ */
+#define PERF_CPU_HRTIMER (1000 / HZ)
+static enum hrtimer_restart perf_cpu_hrtimer_handler(struct hrtimer *hr)
+{
+	struct perf_cpu_context *cpuctx;
+	enum hrtimer_restart ret = HRTIMER_NORESTART;
+	unsigned long flags;
+	int rotations = 0;
+
+	cpuctx = container_of(hr, struct perf_cpu_context, hrtimer);
+
+	local_irq_save(flags);
+
+	if (cpuctx->hrtimer_active) {
+		rotations = perf_rotate_context(cpuctx);
+		if (!rotations)
+			cpuctx->hrtimer_active = 0;
+	}
+
+	local_irq_restore(flags);
+
+	/*
+	 * arm timer if needed
+	 */
+	if (rotations) {
+		hrtimer_forward_now(hr, cpuctx->hrtimer_interval);
+		ret = HRTIMER_RESTART;
+	}
+
+	return ret;
+}
+
+/* CPU is going down */
+void perf_cpu_hrtimer_cancel(int cpu)
+{
+	struct list_head *head = &__get_cpu_var(rotation_list);
+	struct perf_cpu_context *cpuctx, *tmp;
+	unsigned long flags;
+
+	if (WARN_ON(cpu != smp_processor_id()))
+		return;
+
+	local_irq_save(flags);
+
+	list_for_each_entry_safe(cpuctx, tmp, head, rotation_list) {
+		if (cpuctx->hrtimer_active) {
+			hrtimer_cancel(&cpuctx->hrtimer);
+			cpuctx->hrtimer_active = 0;
+		}
+	}
+
+	local_irq_restore(flags);
+}
+
+static void __perf_cpu_hrtimer_init(struct perf_cpu_context *cpuctx, int cpu)
+{
+	struct hrtimer *hr = &cpuctx->hrtimer;
+	struct pmu *pmu = cpuctx->ctx.pmu;
+
+	cpuctx->hrtimer_active = 0;
+
+	/* no multiplexing needed for SW PMU */
+	if (pmu->task_ctx_nr == perf_sw_context)
+		return;
+
+	cpuctx->hrtimer_interval =
+		ns_to_ktime(NSEC_PER_MSEC * PERF_CPU_HRTIMER);
+
+	hrtimer_init_cpu(cpu, hr, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hr->function = perf_cpu_hrtimer_handler;
+}
+
+static void perf_cpu_hrtimer_restart(struct perf_cpu_context *cpuctx)
+{
+	struct hrtimer *hr = &cpuctx->hrtimer;
+	struct pmu *pmu = cpuctx->ctx.pmu;
+
+	/* not for SW PMU */
+	if (pmu->task_ctx_nr == perf_sw_context)
+		return;
+
+	if (cpuctx->hrtimer_active)
+		return;
+
+	cpuctx->hrtimer_active = 1;
+
+	if (!hrtimer_callback_running(hr))
+		__hrtimer_start_range_ns(hr, cpuctx->hrtimer_interval,
+					 0, HRTIMER_MODE_REL_PINNED, 0);
+}
+
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -639,8 +737,6 @@ void perf_pmu_enable(struct pmu *pmu)
 		pmu->pmu_enable(pmu);
 }
 
-static DEFINE_PER_CPU(struct list_head, rotation_list);
-
 /*
  * perf_pmu_rotate_start() and perf_rotate_context() are fully serialized
  * because they're strictly cpu affine and rotate_start is called with IRQs
@@ -1458,6 +1554,7 @@ group_sched_in(struct perf_event *group_event,
 
 	if (event_sched_in(group_event, cpuctx, ctx)) {
 		pmu->cancel_txn(pmu);
+		perf_cpu_hrtimer_restart(cpuctx);
 		return -EAGAIN;
 	}
 
@@ -1504,6 +1601,8 @@ group_sched_in(struct perf_event *group_event,
 
 	pmu->cancel_txn(pmu);
 
+	perf_cpu_hrtimer_restart(cpuctx);
+
 	return -EAGAIN;
 }
 
@@ -1759,8 +1858,10 @@ static int __perf_event_enable(void *info)
 		 * If this event can't go on and it's part of a
 		 * group, then the whole group has to come off.
 		 */
-		if (leader != event)
+		if (leader != event) {
 			group_sched_out(leader, cpuctx, ctx);
+			perf_cpu_hrtimer_restart(cpuctx);
+		}
 		if (leader->attr.pinned) {
 			update_group_times(leader);
 			leader->state = PERF_EVENT_STATE_ERROR;
@@ -2507,7 +2608,7 @@ static void rotate_ctx(struct perf_event_context *ctx)
  * because they're strictly cpu affine and rotate_start is called with IRQs
  * disabled, while rotate_context is called from IRQ context.
  */
-static void perf_rotate_context(struct perf_cpu_context *cpuctx)
+static int perf_rotate_context(struct perf_cpu_context *cpuctx)
 {
 	struct perf_event_context *ctx = NULL;
 	int rotate = 0, remove = 1;
@@ -2546,6 +2647,8 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 done:
 	if (remove)
 		list_del_init(&cpuctx->rotation_list);
+
+	return rotate;
 }
 
 void perf_event_task_tick(void)
@@ -2567,10 +2670,6 @@ void perf_event_task_tick(void)
 		ctx = cpuctx->task_ctx;
 		if (ctx)
 			perf_adjust_freq_unthr_context(ctx, throttled);
-
-		if (cpuctx->jiffies_interval == 1 ||
-				!(jiffies % cpuctx->jiffies_interval))
-			perf_rotate_context(cpuctx);
 	}
 }
 
@@ -6000,7 +6099,9 @@ int perf_pmu_register(struct pmu *pmu, char *name, int type)
 		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
 		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
-		cpuctx->jiffies_interval = 1;
+
+		__perf_cpu_hrtimer_init(cpuctx, cpu);
+
 		INIT_LIST_HEAD(&cpuctx->rotation_list);
 		cpuctx->active_pmu = pmu;
 	}
@@ -7379,6 +7480,10 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 	case CPU_DOWN_PREPARE:
 		perf_event_exit_cpu(cpu);
 		break;
+	case CPU_DYING:
+		/* must be run on actual cpu */
+		perf_cpu_hrtimer_cancel(cpu);
+		break;
 
 	default:
 		break;
-- 
1.7.5.4

