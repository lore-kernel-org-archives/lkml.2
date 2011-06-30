Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab1F3IE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:04:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:12112 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758610Ab1F3IDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:03:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,449,1304319600"; 
   d="scan'208";a="20764682"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] perf, x86: Add Intel Nehalem/Westmere uncore pmu
Date: Thu, 30 Jun 2011 08:09:53 +0000
Message-Id: <1309421396-17438-2-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Intel Nehalem/Westmere uncore pmu support.
And also the generic data structure to support uncore pmu.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/Makefile                  |    1 +
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  351 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   48 ++++
 3 files changed, 400 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_uncore.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_uncore.h

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
index 0000000..01060ce
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -0,0 +1,351 @@
+#include "perf_event_intel_uncore.h"
+
+static DEFINE_PER_CPU(struct cpu_uncore_events, cpu_uncore_events);
+static DEFINE_RAW_SPINLOCK(intel_uncore_lock);
+
+static bool uncore_pmu_initialized;
+static struct intel_uncore_pmu intel_uncore_pmu __read_mostly;
+
+/* Nehalem/Westmere uncore pmu */
+
+static void nhm_uncore_pmu_enable_all(void)
+{
+	u64 ctrl = (1 << intel_uncore_pmu.num_counters) - 1;
+
+	wrmsrl(NHM_MSR_UNCORE_PERF_GLOBAL_CTRL, ctrl);
+}
+
+static void nhm_uncore_pmu_disable_all(void)
+{
+	wrmsrl(NHM_MSR_UNCORE_PERF_GLOBAL_CTRL, 0);
+}
+
+static int nhm_uncore_pmu_hw_config(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	hwc->config = event->attr.config & NHM_UNCORE_RAW_EVENT_MASK;
+	hwc->config_base = NHM_MSR_UNCORE_PERFEVTSEL0 + hwc->idx;
+	hwc->event_base = NHM_MSR_UNCORE_PMC0 + hwc->idx;
+
+	return 0;
+}
+
+static void nhm_uncore_pmu_enable_event(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	wrmsrl(hwc->config_base,
+	       hwc->config | NHM_UNCORE_EVENTSEL_ENABLE);
+}
+
+static void nhm_uncore_pmu_disable_event(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	wrmsrl(hwc->config_base, hwc->config);
+}
+
+static __initconst const struct intel_uncore_pmu nhm_uncore_pmu = {
+	.name			= "Nehalem/Westmere",
+	.disable_all		= nhm_uncore_pmu_disable_all,
+	.enable_all		= nhm_uncore_pmu_enable_all,
+	.enable			= nhm_uncore_pmu_enable_event,
+	.disable		= nhm_uncore_pmu_disable_event,
+	.hw_config		= nhm_uncore_pmu_hw_config,
+	.num_counters		= 8,
+	.cntval_bits		= 48,
+};
+
+static u64 uncore_perf_event_update(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	int shift = 64 - intel_uncore_pmu.cntval_bits;
+	u64 prev_raw_count, new_raw_count;
+	s64 delta;
+
+	/*
+	 * Careful: an NMI might modify the previous event value.
+	 *
+	 * Our tactic to handle this is to first atomically read and
+	 * exchange a new raw count - then add that new-prev delta
+	 * count to the generic event atomically:
+	 */
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
+	spin_lock(&uncore->lock);
+
+	for (i = 0; i < X86_PMC_IDX_MAX; i++) {
+		if (!uncore->events[i]) {
+			uncore->events[i] = event;
+			uncore->n_events++;
+			event->hw.idx = i;
+			intel_uncore_pmu.hw_config(event);
+
+			if (flags & PERF_EF_START)
+				uncore_pmu_start(event, flags);
+			ret = 0;
+			break;
+		}
+	}
+
+	if (uncore->n_events == 1)
+		intel_uncore_pmu.enable_all();
+
+	spin_unlock(&uncore->lock);
+
+	return ret;
+}
+
+static void uncore_pmu_del(struct perf_event *event, int flags)
+{
+	struct cpu_uncore_events *cpuc = &__get_cpu_var(cpu_uncore_events);
+	struct intel_uncore *uncore = cpuc->intel_uncore;
+	struct hw_perf_event *hwc = &event->hw;
+	int i;
+
+	spin_lock(&uncore->lock);
+
+	for (i = 0; i < X86_PMC_IDX_MAX; i++) {
+		if (uncore->events[i] == event) {
+			uncore->events[hwc->idx] = NULL;
+			uncore->n_events--;
+
+			uncore_pmu_stop(event, flags);
+			break;
+		}
+	}
+
+	if (uncore->n_events == 0)
+		intel_uncore_pmu.disable_all();
+
+	spin_unlock(&uncore->lock);
+}
+
+static void uncore_pmu_read(struct perf_event *event)
+{
+	uncore_perf_event_update(event);
+}
+
+static struct pmu uncore_pmu = {
+	.event_init	= uncore_pmu_event_init,
+	.add		= uncore_pmu_add,
+	.del		= uncore_pmu_del,
+	.start		= uncore_pmu_start,
+	.stop		= uncore_pmu_stop,
+	.read		= uncore_pmu_read,
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
+	spin_lock_init(&uncore->lock);
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
+	if (boot_cpu_data.x86_max_cores < 2)
+		return NOTIFY_OK;
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
+	if (boot_cpu_data.x86_max_cores < 2)
+		return;
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
+
+	raw_spin_unlock(&intel_uncore_lock);
+}
+
+static void uncore_pmu_cpu_dead(int cpu)
+{
+	struct cpu_uncore_events *cpuhw;
+
+	if (boot_cpu_data.x86_max_cores < 2)
+		return;
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
+	pr_cont("Performance Events: %s uncore PMU.", intel_uncore_pmu.name);
+
+	perf_pmu_register(&uncore_pmu, "uncore", -1);
+	perf_cpu_notifier(uncore_pmu_notifier);
+	uncore_pmu_initialized = true;
+	return 0;
+}
+early_initcall(uncore_pmu_init);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
new file mode 100644
index 0000000..f622f97
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -0,0 +1,48 @@
+#include <linux/perf_event.h>
+#include <linux/kprobes.h>
+#include <linux/hardirq.h>
+#include <linux/slab.h>
+
+/* Nehalme/Westmere uncore MSR */
+
+#define NHM_MSR_UNCORE_PERF_GLOBAL_CTRL    	0x391
+#define NHM_MSR_UNCORE_PMC0			0x3b0
+#define NHM_MSR_UNCORE_PERFEVTSEL0		0x3c0
+
+#define NHM_UNCORE_EVENTSEL_EVENT		0x000000FFULL
+#define NHM_UNCORE_EVENTSEL_UMASK		0x0000FF00ULL
+#define NHM_UNCORE_EVENTSEL_EDGE		(1ULL << 18)
+#define NHM_UNCORE_EVENTSEL_ENABLE		(1ULL << 22)
+#define NHM_UNCORE_EVENTSEL_INV			(1ULL << 23)
+#define NHM_UNCORE_EVENTSEL_CMASK		0xFF000000ULL
+
+#define NHM_UNCORE_RAW_EVENT_MASK	\
+	(NHM_UNCORE_EVENTSEL_EVENT |	\
+	 NHM_UNCORE_EVENTSEL_UMASK |	\
+	 NHM_UNCORE_EVENTSEL_EDGE  |	\
+	 NHM_UNCORE_EVENTSEL_INV   |	\
+	 NHM_UNCORE_EVENTSEL_CMASK)
+
+struct intel_uncore {
+	int id;			/* uncore id */
+	int refcnt;		/* reference count */
+
+	struct perf_event *events[X86_PMC_IDX_MAX];	/* in counter order */
+	int n_events;
+	struct spinlock lock;
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
+	int		(*hw_config)(struct perf_event *event);
+	int		num_counters;
+	int		cntval_bits;
+};
-- 
1.7.5.1

