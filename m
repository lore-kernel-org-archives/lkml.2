Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab2IGOcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:32:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44620 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933286Ab2IGObS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:31:18 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Subject: [PATCH 1/3] perf: use hrtimer for event multiplexing
Date: Fri,  7 Sep 2012 16:29:27 +0200
Message-Id: <1347028169-1983-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347028169-1983-1-git-send-email-eranian@google.com>
References: <1347028169-1983-1-git-send-email-eranian@google.com>
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
It introduces a per-cpu hrtimer. The advantage is that
even when the core goes idle, it will come back to
service the hrtimer, thus multiplexing on system-wide
events works much better.

In order to minimize the impact of the hrtimer, it
is turned on and off on demand. When the PMU on
a CPU is overcommited, the hrtimer is activated.
It is stopped when the PMU is not overcommitted.

In order for this to work properly with HOTPLUG_CPU,
we had to change the order of initialization in
start_kernel() such that hrtimer_init() is run
before perf_event_init().

The default hrtimer interval in milliseconds
is set to a timer tick just like with the old
code. We will provide a sysctl to tune this in
another patch.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 init/main.c          |    2 +-
 kernel/events/core.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 118 insertions(+), 9 deletions(-)

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
index 40f42b8..ab4ef10 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -148,6 +148,15 @@ static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
 static struct srcu_struct pmus_srcu;
 
+struct perf_cpu_hrtimer {
+	struct hrtimer hrtimer;
+	int active;
+};
+
+static DEFINE_PER_CPU(struct list_head, rotation_list);
+
+static DEFINE_PER_CPU(struct perf_cpu_hrtimer, perf_cpu_hrtimer);
+
 /*
  * perf event paranoia level:
  *  -1 - not paranoid at all
@@ -168,6 +177,8 @@ int sysctl_perf_event_sample_rate __read_mostly = DEFAULT_MAX_SAMPLE_RATE;
 static int max_samples_per_tick __read_mostly =
 	DIV_ROUND_UP(DEFAULT_MAX_SAMPLE_RATE, HZ);
 
+static int perf_rotate_context(struct perf_cpu_context *cpuctx);
+
 int perf_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
@@ -625,6 +636,95 @@ perf_cgroup_mark_enabled(struct perf_event *event,
 }
 #endif
 
+/*
+ * set default to be dependent on timer tick just
+ * like original code
+ */
+#define PERF_CPU_HRTIMER (1000 / HZ)
+static enum hrtimer_restart perf_cpu_hrtimer_handler(struct hrtimer *hr)
+{
+	struct perf_cpu_hrtimer *h = &__get_cpu_var(perf_cpu_hrtimer);
+	struct list_head *head = &__get_cpu_var(rotation_list);
+	struct perf_cpu_context *cpuctx, *tmp;
+	enum hrtimer_restart ret = HRTIMER_NORESTART;
+	unsigned long flags;
+	int rotations = 0;
+
+	/* sanity check */
+	if (WARN_ON_ONCE(hr != &h->hrtimer))
+		goto end;
+
+	local_irq_save(flags);
+
+	if (h->active)
+		list_for_each_entry_safe(cpuctx, tmp, head, rotation_list)
+			rotations += perf_rotate_context(cpuctx);
+
+	/*
+	 * if no rotations done, then we can stop timer
+	 * will be reactivated in group_sched_in()
+	 */
+	if (!rotations)
+		h->active = 0;
+
+	local_irq_restore(flags);
+
+	/*
+	 * arm timer if needed
+	 */
+	if (rotations) {
+		hrtimer_forward_now(hr, ns_to_ktime(PERF_CPU_HRTIMER));
+		ret = HRTIMER_RESTART;
+	}
+end:
+	return ret;
+}
+
+void perf_cpu_hrtimer_init(int cpu)
+{
+	struct perf_cpu_hrtimer *h = &__get_cpu_var(perf_cpu_hrtimer);
+	struct hrtimer *hr = &h->hrtimer;
+
+	if (WARN_ON(cpu != smp_processor_id()))
+		return;
+
+	if (WARN_ON(h->active))
+		return;
+
+	hrtimer_init(hr, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hr->function = perf_cpu_hrtimer_handler;
+	h->active = 0;
+}
+
+void perf_cpu_hrtimer_cancel(int cpu)
+{
+	struct perf_cpu_hrtimer *h = &__get_cpu_var(perf_cpu_hrtimer);
+	struct hrtimer *hr = &h->hrtimer;
+
+	if (WARN_ON(cpu != smp_processor_id()))
+		return;
+
+	if (h->active) {
+		hrtimer_cancel(hr);
+		h->active = 0;
+	}
+}
+
+static void perf_cpu_hrtimer_restart(void)
+{
+	struct perf_cpu_hrtimer *h = &__get_cpu_var(perf_cpu_hrtimer);
+	struct hrtimer *hr = &h->hrtimer;
+
+	if (h->active)
+		return;
+
+	h->active = 1;
+
+	if (!hrtimer_callback_running(hr))
+		__hrtimer_start_range_ns(hr, ns_to_ktime(PERF_CPU_HRTIMER),
+					 0, HRTIMER_MODE_REL_PINNED, 0);
+}
+
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -639,8 +739,6 @@ void perf_pmu_enable(struct pmu *pmu)
 		pmu->pmu_enable(pmu);
 }
 
-static DEFINE_PER_CPU(struct list_head, rotation_list);
-
 /*
  * perf_pmu_rotate_start() and perf_rotate_context() are fully serialized
  * because they're strictly cpu affine and rotate_start is called with IRQs
@@ -1458,6 +1556,7 @@ group_sched_in(struct perf_event *group_event,
 
 	if (event_sched_in(group_event, cpuctx, ctx)) {
 		pmu->cancel_txn(pmu);
+		perf_cpu_hrtimer_restart();
 		return -EAGAIN;
 	}
 
@@ -1504,6 +1603,8 @@ group_sched_in(struct perf_event *group_event,
 
 	pmu->cancel_txn(pmu);
 
+	perf_cpu_hrtimer_restart();
+
 	return -EAGAIN;
 }
 
@@ -1759,8 +1860,10 @@ static int __perf_event_enable(void *info)
 		 * If this event can't go on and it's part of a
 		 * group, then the whole group has to come off.
 		 */
-		if (leader != event)
+		if (leader != event) {
 			group_sched_out(leader, cpuctx, ctx);
+			perf_cpu_hrtimer_restart();
+		}
 		if (leader->attr.pinned) {
 			update_group_times(leader);
 			leader->state = PERF_EVENT_STATE_ERROR;
@@ -2507,7 +2610,7 @@ static void rotate_ctx(struct perf_event_context *ctx)
  * because they're strictly cpu affine and rotate_start is called with IRQs
  * disabled, while rotate_context is called from IRQ context.
  */
-static void perf_rotate_context(struct perf_cpu_context *cpuctx)
+static int perf_rotate_context(struct perf_cpu_context *cpuctx)
 {
 	struct perf_event_context *ctx = NULL;
 	int rotate = 0, remove = 1;
@@ -2546,6 +2649,8 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 done:
 	if (remove)
 		list_del_init(&cpuctx->rotation_list);
+
+	return rotate;
 }
 
 void perf_event_task_tick(void)
@@ -2567,10 +2672,6 @@ void perf_event_task_tick(void)
 		ctx = cpuctx->task_ctx;
 		if (ctx)
 			perf_adjust_freq_unthr_context(ctx, throttled);
-
-		if (cpuctx->jiffies_interval == 1 ||
-				!(jiffies % cpuctx->jiffies_interval))
-			perf_rotate_context(cpuctx);
 	}
 }
 
@@ -7379,6 +7480,14 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 	case CPU_DOWN_PREPARE:
 		perf_event_exit_cpu(cpu);
 		break;
+	case CPU_DYING:
+		/* must be run on actual cpu */
+		perf_cpu_hrtimer_cancel(cpu);
+		break;
+	case CPU_STARTING:
+		/* must be run on actual cpu */
+		perf_cpu_hrtimer_init(cpu);
+		break;
 
 	default:
 		break;
-- 
1.7.5.4

