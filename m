Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab1GOOaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:30:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:53067 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab1GOO35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:29:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,535,1304319600"; 
   d="scan'208";a="26267117"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/6] perf, x86: Add Intel Nehalem/Westmere uncore pmu
Date: Fri, 15 Jul 2011 14:34:59 +0000
Message-Id: <1310740503-15608-3-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Intel Nehalem/Westmere uncore pmu support.
And also the generic data structure to support uncore pmu.

Uncore pmu interrupt does not work, so hrtimer is used to pull counters.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/include/asm/msr-index.h              |    8 +
 arch/x86/kernel/cpu/Makefile                  |    1 +
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  450 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   53 +++
 4 files changed, 512 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_uncore.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_uncore.h

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 485b4f1..e66011e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -421,6 +421,14 @@
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
 
+/* Intel Nehalem/Westmere uncore performance counters */
+#define MSR_UNCORE_PERF_GLOBAL_CTRL	0x00000391
+#define MSR_UNCORE_FIXED_CTR_CTRL	0x00000394
+#define MSR_UNCORE_FIXED_CTR0		0x00000395
+
+#define MSR_NHM_UNCORE_PMC0		0x000003b0
+#define MSR_NHM_UNCORE_PERFEVTSEL0	0x000003c0
+
 /* Geode defined MSRs */
 #define MSR_GEODE_BUSCONT_CONF0		0x00001900
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6042981..31fd49e 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
 obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
+obj-$(CONFIG_PERF_EVENTS)              += perf_event_intel_uncore.o
 
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
new file mode 100644
index 0000000..79a501e
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -0,0 +1,450 @@
+#include "perf_event_intel_uncore.h"
+
+static DEFINE_PER_CPU(struct cpu_uncore_events, cpu_uncore_events);
+static DEFINE_RAW_SPINLOCK(intel_uncore_lock);
+
+static bool uncore_pmu_initialized;
+static struct intel_uncore_pmu intel_uncore_pmu __read_mostly;
+
+/*
+ * Uncore pmu interrupt does not work.
+ * Use hrtimer to pull the counter every 10 seconds.
+ */
+#define UNCORE_PMU_HRTIMER_INTERVAL (10000000000ULL)
+
+/* Common functions for Nehalem/Westmere/SandyBridge */
+
+static void uncore_pmu_disable_all(void)
+{
+	wrmsrl(MSR_UNCORE_PERF_GLOBAL_CTRL, 0);
+}
+
+static void uncore_fixed_hw_config(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	hwc->config_base = MSR_UNCORE_FIXED_CTR_CTRL;
+	hwc->event_base = MSR_UNCORE_FIXED_CTR0;
+}
+
+static void uncore_fixed_disable_event(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	wrmsrl(hwc->config_base, 0);
+}
+
+static void uncore_pmu_enable_event(struct perf_event *event, u64 fixed_enable)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (event->hw.idx == X86_PMC_IDX_FIXED) {
+		wrmsrl(hwc->config_base, fixed_enable);
+		return;
+	}
+
+	wrmsrl(hwc->config_base,
+	       hwc->config | UNCORE_EVENTSEL_ENABLE);
+}
+
+static void uncore_pmu_disable_event(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (event->hw.idx == X86_PMC_IDX_FIXED) {
+		uncore_fixed_disable_event(event);
+		return;
+	}
+
+	wrmsrl(hwc->config_base, hwc->config);
+}
+
+/* Nehalem/Westmere uncore pmu */
+
+static void nhm_uncore_pmu_enable_all(void)
+{
+	u64 ctrl = (1 << UNCORE_NUM_COUNTERS) - 1;
+
+	wrmsrl(MSR_UNCORE_PERF_GLOBAL_CTRL, ctrl);
+}
+
+static void nhm_uncore_pmu_enable_event(struct perf_event *event)
+{
+	uncore_pmu_enable_event(event, NHM_UNCORE_FIXED_CTR_CTRL_EN);
+}
+
+static void nhm_uncore_pmu_hw_config(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (event->hw.idx == X86_PMC_IDX_FIXED) {
+		uncore_fixed_hw_config(event);
+		return;
+	}
+
+	hwc->config = event->attr.config & NHM_UNCORE_RAW_EVENT_MASK;
+	hwc->config_base = MSR_NHM_UNCORE_PERFEVTSEL0 + hwc->idx;
+	hwc->event_base = MSR_NHM_UNCORE_PMC0 + hwc->idx;
+}
+
+static __initconst const struct intel_uncore_pmu nhm_uncore_pmu = {
+	.name			= "Nehalem/Westmere",
+	.disable_all		= uncore_pmu_disable_all,
+	.enable_all		= nhm_uncore_pmu_enable_all,
+	.enable			= nhm_uncore_pmu_enable_event,
+	.disable		= uncore_pmu_disable_event,
+	.hw_config		= nhm_uncore_pmu_hw_config,
+	.cntval_bits		= 48,
+	.cntval_bits_fixed	= 48,
+};
+
+static u64 uncore_perf_event_update(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	int shift;
+	u64 prev_raw_count, new_raw_count;
+	s64 delta;
+
+	if (event->hw.idx == X86_PMC_IDX_FIXED)
+		shift = 64 - intel_uncore_pmu.cntval_bits_fixed;
+	else
+		shift = 64 - intel_uncore_pmu.cntval_bits;
+
+again:
+	prev_raw_count = local64_read(&hwc->prev_count);
+	rdmsrl(hwc->event_base, new_raw_count);
+
+	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
+			    new_raw_count) != prev_raw_count)
+		goto again;
+
+	/*
+	 * Now we have the new raw value and have updated the prev
+	 * timestamp already. We can now calculate the elapsed delta
+	 * (event-)time and add that to the generic event.
+	 *
+	 * Careful, not all hw sign-extends above the physical width
+	 * of the count.
+	 */
+	delta = (new_raw_count << shift) - (prev_raw_count << shift);
+	delta >>= shift;
+
+	local64_add(delta, &event->count);
+
+	return new_raw_count;
+}
+
+static enum hrtimer_restart uncore_pmu_hrtimer(struct hrtimer *hrtimer)
+{
+	struct intel_uncore *uncore;
+	enum hrtimer_restart ret = HRTIMER_RESTART;
+	int bit;
+
+	uncore = container_of(hrtimer, struct intel_uncore, hrtimer);
+	raw_spin_lock(&uncore->lock);
+
+	if (!uncore->n_events) {
+		ret = HRTIMER_NORESTART;
+		goto unlock;
+	}
+
+	intel_uncore_pmu.disable_all();
+
+	for_each_set_bit(bit, uncore->active_mask, X86_PMC_IDX_MAX)
+		uncore_perf_event_update(uncore->events[bit]);
+
+	hrtimer_forward_now(hrtimer, ns_to_ktime(UNCORE_PMU_HRTIMER_INTERVAL));
+
+	intel_uncore_pmu.enable_all();
+unlock:
+	raw_spin_unlock(&uncore->lock);
+	return ret;
+}
+
+static void uncore_pmu_start_hrtimer(struct intel_uncore *uncore)
+{
+	__hrtimer_start_range_ns(&uncore->hrtimer,
+				ns_to_ktime(UNCORE_PMU_HRTIMER_INTERVAL), 0,
+				HRTIMER_MODE_REL_PINNED, 0);
+}
+
+static void uncore_pmu_cancel_hrtimer(struct intel_uncore *uncore)
+{
+	hrtimer_cancel(&uncore->hrtimer);
+}
+
+static void uncore_pmu_init_hrtimer(struct intel_uncore *uncore)
+{
+	hrtimer_init(&uncore->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	uncore->hrtimer.function = uncore_pmu_hrtimer;
+}
+
+static struct pmu uncore_pmu;
+
+static int uncore_pmu_event_init(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (!uncore_pmu_initialized)
+		return -ENOENT;
+
+	if (event->attr.type != uncore_pmu.type)
+		return -ENOENT;
+
+	/*
+	 * Uncore PMU does measure at all privilege level all the time.
+	 * So it doesn't make sense to specify any exclude bits.
+	 */
+	if (event->attr.exclude_user || event->attr.exclude_kernel
+	    || event->attr.exclude_hv || event->attr.exclude_idle)
+		return -ENOENT;
+
+	/* Sampling not supported yet */
+	if (hwc->sample_period)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void uncore_pmu_start(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	u64 now;
+
+	rdmsrl(hwc->event_base, now);
+
+	local64_set(&event->hw.prev_count, now);
+	intel_uncore_pmu.enable(event);
+}
+
+static void uncore_pmu_stop(struct perf_event *event, int flags)
+{
+	intel_uncore_pmu.disable(event);
+	uncore_perf_event_update(event);
+}
+
+static int uncore_pmu_add(struct perf_event *event, int flags)
+{
+	struct cpu_uncore_events *cpuc = &__get_cpu_var(cpu_uncore_events);
+	struct intel_uncore *uncore = cpuc->intel_uncore;
+	int ret = 1;
+	int i;
+
+	raw_spin_lock(&uncore->lock);
+
+	if (event->attr.config == UNCORE_FIXED_EVENT) {
+		i = X86_PMC_IDX_FIXED;
+		goto fixed_event;
+	}
+
+	for (i = 0; i < X86_PMC_IDX_FIXED; i++) {
+fixed_event:
+		if (!uncore->events[i]) {
+			uncore->events[i] = event;
+			uncore->n_events++;
+			event->hw.idx = i;
+			__set_bit(i, uncore->active_mask);
+
+			intel_uncore_pmu.hw_config(event);
+
+			if (flags & PERF_EF_START)
+				uncore_pmu_start(event, flags);
+			ret = 0;
+			break;
+		}
+	}
+
+	if (uncore->n_events == 1) {
+		uncore_pmu_start_hrtimer(uncore);
+		intel_uncore_pmu.enable_all();
+	}
+
+	raw_spin_unlock(&uncore->lock);
+
+	return ret;
+}
+
+static void uncore_pmu_del(struct perf_event *event, int flags)
+{
+	struct cpu_uncore_events *cpuc = &__get_cpu_var(cpu_uncore_events);
+	struct intel_uncore *uncore = cpuc->intel_uncore;
+	int idx = event->hw.idx;
+
+	raw_spin_lock(&uncore->lock);
+
+	if (__test_and_clear_bit(idx, uncore->active_mask)) {
+		uncore->events[idx] = NULL;
+		uncore->n_events--;
+
+		uncore_pmu_stop(event, flags);
+	}
+
+	if (uncore->n_events == 0) {
+		intel_uncore_pmu.disable_all();
+		uncore_pmu_cancel_hrtimer(uncore);
+	}
+
+	raw_spin_unlock(&uncore->lock);
+}
+
+static void uncore_pmu_read(struct perf_event *event)
+{
+	uncore_perf_event_update(event);
+}
+
+#define UNCORE_PMU_NUM_GENERIC_EVENTS 1
+
+static struct pmu_event uncore_events[UNCORE_PMU_NUM_GENERIC_EVENTS] = {
+	{"cycle", 0xffff, },
+};
+
+static void uncore_pmu_add_events(void)
+{
+	perf_pmu_add_events(&uncore_pmu, uncore_events,
+		UNCORE_PMU_NUM_GENERIC_EVENTS);
+}
+
+static struct pmu uncore_pmu = {
+	.task_ctx_nr	= perf_invalid_context,
+	.event_init	= uncore_pmu_event_init,
+	.add		= uncore_pmu_add,
+	.del		= uncore_pmu_del,
+	.start		= uncore_pmu_start,
+	.stop		= uncore_pmu_stop,
+	.read		= uncore_pmu_read,
+	.add_events	= uncore_pmu_add_events,
+};
+
+static struct intel_uncore *alloc_uncore(int cpu, int uncore_id)
+{
+	struct intel_uncore *uncore;
+
+	uncore =
+	    kmalloc_node(sizeof(struct intel_uncore), GFP_KERNEL | __GFP_ZERO,
+			 cpu_to_node(cpu));
+	if (!uncore)
+		return NULL;
+
+	uncore->id = uncore_id;
+	raw_spin_lock_init(&uncore->lock);
+
+	return uncore;
+}
+
+static int uncore_pmu_cpu_prepare(int cpu)
+{
+	struct cpu_uncore_events *cpuc = &per_cpu(cpu_uncore_events, cpu);
+
+	WARN_ON_ONCE(cpuc->intel_uncore);
+
+	cpuc->intel_uncore = alloc_uncore(cpu, -1);
+	if (!cpuc->intel_uncore)
+		return NOTIFY_BAD;
+
+	return NOTIFY_OK;
+}
+
+static void uncore_pmu_cpu_starting(int cpu)
+{
+	struct cpu_uncore_events *cpuc = &per_cpu(cpu_uncore_events, cpu);
+	struct intel_uncore *uncore;
+	int i, uncore_id;
+
+	uncore_id = topology_physical_package_id(cpu);
+	WARN_ON_ONCE(uncore_id == BAD_APICID);
+
+	raw_spin_lock(&intel_uncore_lock);
+
+	for_each_online_cpu(i) {
+		uncore = per_cpu(cpu_uncore_events, i).intel_uncore;
+		if (WARN_ON_ONCE(!uncore))
+			continue;
+
+		if (uncore->id == uncore_id) {
+			kfree(cpuc->intel_uncore);
+			cpuc->intel_uncore = uncore;
+			break;
+		}
+	}
+
+	cpuc->intel_uncore->id = uncore_id;
+	cpuc->intel_uncore->refcnt++;
+	uncore_pmu_init_hrtimer(cpuc->intel_uncore);
+
+	raw_spin_unlock(&intel_uncore_lock);
+}
+
+static void uncore_pmu_cpu_dead(int cpu)
+{
+	struct cpu_uncore_events *cpuhw;
+
+	cpuhw = &per_cpu(cpu_uncore_events, cpu);
+
+	raw_spin_lock(&intel_uncore_lock);
+
+	if (cpuhw->intel_uncore) {
+		struct intel_uncore *uncore = cpuhw->intel_uncore;
+
+		if (uncore->id == -1 || --uncore->refcnt == 0)
+			kfree(uncore);
+
+		cpuhw->intel_uncore = NULL;
+	}
+
+	raw_spin_unlock(&intel_uncore_lock);
+}
+
+static int __cpuinit
+uncore_pmu_notifier(struct notifier_block *self, unsigned long action,
+		    void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+	int ret = NOTIFY_OK;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		ret = uncore_pmu_cpu_prepare(cpu);
+		break;
+
+	case CPU_STARTING:
+		uncore_pmu_cpu_starting(cpu);
+		break;
+
+	case CPU_DYING:
+		uncore_pmu_cpu_dead(cpu);
+		break;
+
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+
+static int __init uncore_pmu_init(void)
+{
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL ||
+	    boot_cpu_data.x86 != 6)
+		return 0;
+
+	switch (boot_cpu_data.x86_model) {
+	case 26: /* Nehalem */
+	case 30:
+	case 31:
+	case 37: /* Westmere */
+		intel_uncore_pmu = nhm_uncore_pmu;
+		break;
+
+	default:
+		return 0;
+	}
+
+	pr_cont("Performance Events: %s uncore PMU.\n", intel_uncore_pmu.name);
+
+	perf_pmu_register(&uncore_pmu, "uncore", -1);
+	perf_cpu_notifier(uncore_pmu_notifier);
+	uncore_pmu_initialized = true;
+	return 0;
+}
+early_initcall(uncore_pmu_init);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
new file mode 100644
index 0000000..431c8b4
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -0,0 +1,53 @@
+#include <linux/perf_event.h>
+#include <linux/kprobes.h>
+#include <linux/hardirq.h>
+#include <linux/slab.h>
+
+#define UNCORE_FIXED_EVENT			0xFFFF
+#define NHM_UNCORE_FIXED_CTR_CTRL_EN		(1ULL << 0)
+
+#define UNCORE_EVENTSEL_EVENT			0x000000FFULL
+#define UNCORE_EVENTSEL_UMASK			0x0000FF00ULL
+#define UNCORE_EVENTSEL_EDGE			(1ULL << 18)
+#define UNCORE_EVENTSEL_ENABLE			(1ULL << 22)
+#define UNCORE_EVENTSEL_INV			(1ULL << 23)
+#define NHM_UNCORE_EVENTSEL_CMASK		0xFF000000ULL
+
+#define NHM_UNCORE_RAW_EVENT_MASK	\
+	(UNCORE_EVENTSEL_EVENT |	\
+	 UNCORE_EVENTSEL_UMASK |	\
+	 UNCORE_EVENTSEL_EDGE  |	\
+	 UNCORE_EVENTSEL_INV   |	\
+	 NHM_UNCORE_EVENTSEL_CMASK)
+
+/* 8 generic counters + 1 fixed counter */
+#define UNCORE_NUM_GENERIC_COUNTERS		8
+#define UNCORE_NUM_FIXED_COUNTERS		1
+#define UNCORE_NUM_COUNTERS			((UNCORE_NUM_GENERIC_COUNTERS) + \
+						(UNCORE_NUM_FIXED_COUNTERS))
+
+struct intel_uncore {
+	int id;			/* uncore id */
+	int refcnt;		/* reference count */
+
+	struct perf_event *events[X86_PMC_IDX_MAX];	/* in counter order */
+	unsigned long active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	int n_events;
+	raw_spinlock_t lock;
+	struct hrtimer hrtimer;
+};
+
+struct cpu_uncore_events {
+	struct intel_uncore *intel_uncore;
+};
+
+struct intel_uncore_pmu {
+	const char	*name;
+	void		(*disable_all)(void);
+	void		(*enable_all)(void);
+	void		(*enable)(struct perf_event *);
+	void		(*disable)(struct perf_event *);
+	void		(*hw_config)(struct perf_event *event);
+	int		cntval_bits;
+	int		cntval_bits_fixed;
+};
-- 
1.7.5.1

