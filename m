Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab0KUMBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 07:01:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:51181 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab0KUMB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 07:01:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,231,1288594800"; 
   d="scan'208";a="576016517"
Subject: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Nov 2010 20:01:17 +0800
Message-Id: <1290340877.2245.124.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the background of Nehalem uncore pmu, see Intel SDM Volume 3B
"30.6.2 Performance Monitoring Facility in the Uncore"

1. data structure

struct node_hw_events {
        struct perf_event *events[X86_PMC_IDX_MAX];
        int n_events;
        struct spinlock lock;
};

struct node_hw_events is the per node structure.
"lock" protects add/delete events to uncore pmu.

TODO: this need to be converted to per-socket since "uncore" refers to
subsystems in the physical processor package that are shared by multiple
processor cores.

2. Uncore pmu NMI handling

All the 4 cores are programmed to receive uncore counter overflow
interrupt. The NMI handler(running on 1 of the 4 cores) handle all
counters enabled by all 4 cores. 

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/include/asm/msr-index.h              |    1 +
 arch/x86/include/asm/perf_event.h             |    5 +
 arch/x86/kernel/cpu/Makefile                  |    1 +
 arch/x86/kernel/cpu/perf_event.c              |    6 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  475 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   87 +++++
 include/linux/perf_event.h                    |    1 +
 7 files changed, 571 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_uncore.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_uncore.h

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 6b89f5e..a1cc40b 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -81,6 +81,7 @@
 #define DEBUGCTLMSR_BTS_OFF_OS		(1UL <<  9)
 #define DEBUGCTLMSR_BTS_OFF_USR		(1UL << 10)
 #define DEBUGCTLMSR_FREEZE_LBRS_ON_PMI	(1UL << 11)
+#define DEBUGCTLMSR_ENABLE_UNCORE_PMI	(1UL << 13)
 
 #define MSR_IA32_MC0_CTL		0x00000400
 #define MSR_IA32_MC0_STATUS		0x00000401
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 550e26b..9572166 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -75,6 +75,10 @@ union cpuid10_edx {
 	unsigned int full;
 };
 
+struct pmu_nmi_state {
+	unsigned int	marked;
+	int		handled;
+};
 
 /*
  * Fixed-purpose performance events:
@@ -127,6 +131,7 @@ union cpuid10_edx {
 #ifdef CONFIG_PERF_EVENTS
 extern void init_hw_perf_events(void);
 extern void perf_events_lapic_init(void);
+extern void init_uncore_pmu(void);
 
 #define PERF_EVENT_INDEX_OFFSET			0
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3f0ebe4..db4bf99 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
 obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
+obj-$(CONFIG_PERF_EVENTS)		+= perf_event_intel_uncore.o
 
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index cb16b9c..81517bc 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1196,11 +1196,6 @@ void perf_events_lapic_init(void)
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
 
-struct pmu_nmi_state {
-	unsigned int	marked;
-	int		handled;
-};
-
 static DEFINE_PER_CPU(struct pmu_nmi_state, pmu_nmi);
 
 static int __kprobes
@@ -1348,6 +1343,7 @@ void __init init_hw_perf_events(void)
 
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_INTEL:
+		init_uncore_pmu();
 		err = intel_pmu_init();
 		break;
 	case X86_VENDOR_AMD:
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
new file mode 100644
index 0000000..908643d
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -0,0 +1,475 @@
+#include "perf_event_intel_uncore.h"
+
+static struct node_hw_events *uncore_events[MAX_NUMNODES];
+static bool uncore_pmu_initialized;
+static atomic_t active_uncore_events;
+
+static void uncore_pmu_enable_fixed_event(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	wrmsrl(hwc->config_base, MSR_UNCORE_FIXED_EN | MSR_UNCORE_FIXED_PMI);
+}
+
+static void uncore_pmu_enable_event(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (hwc->idx == UNCORE_FIXED_EVENT_IDX)
+		uncore_pmu_enable_fixed_event(event);
+	else
+		wrmsrl(hwc->config_base + hwc->idx, hwc->config | UNCORE_EVENTSEL_ENABLE);
+}
+
+static void uncore_pmu_disable_fixed_event(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	wrmsrl(hwc->config_base, 0);
+}
+
+static void uncore_pmu_disable_event(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (hwc->idx == UNCORE_FIXED_EVENT_IDX)
+		uncore_pmu_disable_fixed_event(event);
+	else
+		wrmsrl(hwc->config_base + hwc->idx, hwc->config);
+}
+
+static void uncore_pmu_enable_all(void)
+{
+	u64 ctrl;
+
+	/*
+	 * (0xFULL << 48): 1 of the 4 cores can receive NMI each time
+	 * but we don't know which core will receive the NMI when overflow happens
+	 */
+	ctrl = ((1 << UNCORE_NUM_GENERAL_COUNTERS) - 1) | (0xFULL << 48);
+	ctrl |= MSR_UNCORE_PERF_GLOBAL_CTRL_EN_FC0;
+
+	/*
+	 * Freeze the uncore pmu on overflow of any uncore counter.
+	 * This makes unocre NMI handling easier.
+	 */
+	ctrl |= MSR_UNCORE_PERF_GLOBAL_CTRL_PMI_FRZ;
+
+	wrmsrl(MSR_UNCORE_PERF_GLOBAL_CTRL, ctrl);
+}
+
+static void uncore_pmu_disable_all(void)
+{
+	wrmsrl(MSR_UNCORE_PERF_GLOBAL_CTRL, 0);
+}
+
+static void uncore_perf_event_destroy(struct perf_event *event)
+{
+	atomic_dec(&active_uncore_events);
+}
+
+static int uncore_pmu_event_init(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (!uncore_pmu_initialized)
+		return -ENOENT;
+
+	switch (event->attr.type) {
+	case PERF_TYPE_UNCORE:
+		/*
+		 * Uncore PMU does measure at all privilege level all the time.
+		 * So it doesn't make sense to specify any exclude bits.
+		 */
+		if (event->attr.exclude_user || event->attr.exclude_kernel
+			|| event->attr.exclude_hv || event->attr.exclude_idle)
+			return -ENOENT;
+		break;
+
+	default:
+		return -ENOENT;
+	}
+
+	if (!hwc->sample_period) {
+		hwc->sample_period = (1ULL << UNCORE_CNTVAL_BITS) - 1;
+		hwc->last_period = hwc->sample_period;
+		local64_set(&hwc->period_left, hwc->sample_period);
+	}
+
+	atomic_inc(&active_uncore_events);
+
+	event->destroy = uncore_perf_event_destroy;
+
+	hwc->idx = -1;
+	hwc->config = (event->attr.config & UNCORE_RAW_EVENT_MASK) | UNCORE_EVENTSEL_PMI;
+	if ((hwc->config & UNCORE_EVENTSEL_EVENT) == UNCORE_FIXED_EVENT) {
+		hwc->config_base = MSR_UNCORE_FIXED_CTR_CTRL;
+		hwc->event_base = MSR_UNCORE_FIXED_CTR0;
+	} else {
+		hwc->config_base = MSR_UNCORE_PERFEVTSEL0;
+		hwc->event_base = MSR_UNCORE_PMC0;
+	}
+
+	return 0;
+}
+
+static int
+uncore_perf_event_set_period(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	s64 left = local64_read(&hwc->period_left);
+	s64 period = hwc->sample_period;
+	u64 max_period = (1ULL << UNCORE_CNTVAL_BITS) - 1;
+	int ret = 0, idx = hwc->idx;
+
+	/*
+	 * If we are way outside a reasonable range then just skip forward:
+	 */
+	if (unlikely(left <= -period)) {
+		left = period;
+		local64_set(&hwc->period_left, left);
+		hwc->last_period = period;
+		ret = 1;
+	}
+
+	if (unlikely(left <= 0)) {
+		left += period;
+		local64_set(&hwc->period_left, left);
+		hwc->last_period = period;
+		ret = 1;
+	}
+
+	if (left > max_period)
+		left = max_period;
+
+	/*
+	 * The hw event starts counting from this event offset,
+	 * mark it to be able to extra future deltas:
+	 */
+	local64_set(&hwc->prev_count, (u64)-left);
+
+	if (idx == UNCORE_FIXED_EVENT_IDX)
+		idx = 0;
+	wrmsrl(hwc->event_base + idx, (u64)(-left) & max_period);
+
+	perf_event_update_userpage(event);
+
+	return ret;
+}
+
+static void uncore_pmu_start(struct perf_event *event, int flags)
+{
+	if (flags & PERF_EF_RELOAD)
+		uncore_perf_event_set_period(event);
+
+	uncore_pmu_enable_event(event);
+
+	perf_event_update_userpage(event);
+}
+
+static void uncore_pmu_stop(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	int idx = hwc->idx;
+
+	uncore_pmu_disable_event(event);
+
+	if (flags & PERF_EF_UPDATE) {
+		if (idx == UNCORE_FIXED_EVENT_IDX)
+			hwc->idx = 0;
+		x86_perf_event_update(event, UNCORE_CNTVAL_BITS);
+		hwc->idx = idx;
+	}
+}
+
+static int uncore_pmu_add(struct perf_event *event, int flags)
+{
+	int node = numa_node_id();
+	int ret = 1;
+	int i = 0, fixed = 0;
+
+	spin_lock(&uncore_events[node]->lock);
+
+	if ((event->attr.config & UNCORE_EVENTSEL_EVENT) == UNCORE_FIXED_EVENT) {
+		i = UNCORE_FIXED_EVENT_IDX;
+		fixed = 1;
+	}
+	for (; i < X86_PMC_IDX_MAX; i++) {
+		if (!fixed && i == UNCORE_NUM_GENERAL_COUNTERS)
+			break;
+		if (!uncore_events[node]->events[i]) {
+			uncore_events[node]->events[i] = event;
+			uncore_events[node]->n_events++;
+
+			event->hw.idx = i;
+			if (flags & PERF_EF_START)
+				uncore_pmu_start(event, PERF_EF_RELOAD);
+			ret = 0;
+			break;
+		}
+
+		if (i == UNCORE_FIXED_EVENT_IDX)
+			break;
+	}
+
+	if (uncore_events[node]->n_events == 1)
+		uncore_pmu_enable_all();
+
+	spin_unlock(&uncore_events[node]->lock);
+
+	return ret;
+}
+
+static void uncore_pmu_del(struct perf_event *event, int flags)
+{
+	int node = numa_node_id();
+	struct hw_perf_event *hwc = &event->hw;
+	int i;
+
+	spin_lock(&uncore_events[node]->lock);
+
+	for (i = 0; i < X86_PMC_IDX_MAX; i++) {
+		if (uncore_events[node]->events[i] == event) {
+			uncore_events[node]->events[hwc->idx] = NULL;
+			uncore_events[node]->n_events--;
+
+			uncore_pmu_stop(event, PERF_EF_UPDATE);
+			break;
+		}
+	}
+
+	if (uncore_events[node]->n_events == 0)
+		uncore_pmu_disable_all();
+
+	spin_unlock(&uncore_events[node]->lock);
+}
+
+static void uncore_pmu_read(struct perf_event *event)
+{
+	x86_perf_event_update(event, UNCORE_CNTVAL_BITS);
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
+
+static inline u64 uncore_pmu_get_status(void)
+{
+	u64 status;
+
+	rdmsrl(MSR_UNCORE_PERF_GLOBAL_STATUS, status);
+
+	return status;
+}
+
+static inline void uncore_pmu_ack_status(u64 ack)
+{
+	wrmsrl(MSR_UNCORE_PERF_GLOBAL_OVF_CTRL, ack);
+}
+
+static int uncore_pmu_save_and_restart(struct perf_event *event)
+{
+	x86_perf_event_update(event, UNCORE_CNTVAL_BITS);
+	return uncore_perf_event_set_period(event);
+}
+
+static int uncore_pmu_handle_irq(struct pt_regs *regs)
+{
+	struct perf_sample_data data;
+	struct node_hw_events *uncore_node;
+	int node;
+	int bit;
+	u64 status;
+	int handled = 0;
+
+	/*
+	 * Don't need to disable uncore PMU globally,
+	 * because it's set to freeze on any overflow.
+	 * See uncore_pmu_enable_all
+	 */
+
+	perf_sample_data_init(&data, 0);
+
+	node = numa_node_id();
+	uncore_node = uncore_events[node];
+
+	status = uncore_pmu_get_status();
+	if (!status) {
+		uncore_pmu_enable_all();
+		return 1;
+	}
+
+again:
+	uncore_pmu_ack_status(status);
+
+	status &= ~(MSR_UNCORE_PERF_GLOBAL_STATUS_OVF_PMI |
+		MSR_UNCORE_PERF_GLOBAL_STATUS_CHG);
+
+	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
+		struct perf_event *event = uncore_node->events[bit];
+
+		handled++;
+
+		if (!uncore_pmu_save_and_restart(event))
+			continue;
+
+		data.period = event->hw.last_period;
+
+		if (perf_event_overflow(event, 1, &data, regs))
+			uncore_pmu_stop(event, 0);
+	}
+
+	/*
+	 * Repeat if there is more work to be done:
+	 */
+	status = uncore_pmu_get_status();
+	if (status)
+		goto again;
+
+	uncore_pmu_enable_all();
+	return handled;
+}
+
+/* Copy from perf_event_nmi_handler */
+
+static DEFINE_PER_CPU(struct pmu_nmi_state, pmu_uncore_nmi);
+
+static int __kprobes
+perf_event_uncore_nmi_handler(struct notifier_block *self,
+			 unsigned long cmd, void *__args)
+{
+	struct die_args *args = __args;
+	unsigned int this_nmi;
+	int handled;
+
+	if (!atomic_read(&active_uncore_events))
+		return NOTIFY_DONE;
+
+	switch (cmd) {
+	case DIE_NMI:
+	case DIE_NMI_IPI:
+		break;
+	case DIE_NMIUNKNOWN:
+		this_nmi = percpu_read(irq_stat.__nmi_count);
+		if (this_nmi != __get_cpu_var(pmu_uncore_nmi).marked)
+			/* let the kernel handle the unknown nmi */
+			return NOTIFY_DONE;
+		/*
+		 * This one is a PMU back-to-back nmi. Two events
+		 * trigger 'simultaneously' raising two back-to-back
+		 * NMIs. If the first NMI handles both, the latter
+		 * will be empty and daze the CPU. So, we drop it to
+		 * avoid false-positive 'unknown nmi' messages.
+		 */
+		return NOTIFY_STOP;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+
+	handled = uncore_pmu_handle_irq(args->regs);
+	if (!handled)
+		return NOTIFY_DONE;
+
+	this_nmi = percpu_read(irq_stat.__nmi_count);
+	if ((handled > 1) ||
+		/* the next nmi could be a back-to-back nmi */
+	    ((__get_cpu_var(pmu_uncore_nmi).marked == this_nmi) &&
+	     (__get_cpu_var(pmu_uncore_nmi).handled > 1))) {
+		/*
+		 * We could have two subsequent back-to-back nmis: The
+		 * first handles more than one counter, the 2nd
+		 * handles only one counter and the 3rd handles no
+		 * counter.
+		 *
+		 * This is the 2nd nmi because the previous was
+		 * handling more than one counter. We will mark the
+		 * next (3rd) and then drop it if unhandled.
+		 */
+		__get_cpu_var(pmu_uncore_nmi).marked	= this_nmi + 1;
+		__get_cpu_var(pmu_uncore_nmi).handled	= handled;
+	}
+
+	return NOTIFY_STOP;
+}
+
+static __read_mostly struct notifier_block perf_event_uncore_nmi_notifier = {
+	.notifier_call		= perf_event_uncore_nmi_handler,
+	.next			= NULL,
+	.priority		= 1
+};
+
+void __init init_uncore_pmu(void)
+{
+	union cpuid01_eax eax;
+	unsigned int unused;
+	unsigned int model;
+	int i, node;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return;
+
+	cpuid(1, &eax.full, &unused, &unused, &unused);
+
+	/* Check CPUID signatures: 06_1AH, 06_1EH, 06_1FH */
+	model = eax.split.model | (eax.split.ext_model << 4);
+	if (eax.split.family != 6 || (model != 0x1A && model != 0x1E && model != 0x1F))
+		return;
+
+	pr_cont("Nehalem uncore pmu, \n");
+
+	for_each_node(node) {
+		uncore_events[node] = kmalloc_node(sizeof(struct node_hw_events),
+			GFP_KERNEL | __GFP_ZERO, node);
+		if (unlikely(!uncore_events[node]))
+			goto fail;
+
+		spin_lock_init(&uncore_events[node]->lock);
+	}
+
+	perf_pmu_register(&uncore_pmu);
+	register_die_notifier(&perf_event_uncore_nmi_notifier);
+	uncore_pmu_initialized = true;
+	return;
+
+fail:
+	for (i = 0; i < node; i++)
+		kfree(uncore_events[node]);
+}
+
+static void uncore_setup_per_cpu(void *info)
+{
+	u64 val;
+
+	/*
+	 * PMI delivery due to an uncore counter overflow is enabled by
+	 * setting IA32_DEBUG_CTL.Offcore_PMI_EN to 1.
+	 */
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, val);
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, val | DEBUGCTLMSR_ENABLE_UNCORE_PMI);
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+}
+
+static int __init uncore_per_cpu_init(void)
+{
+	int cpu;
+
+	if (!uncore_pmu_initialized)
+		return 0;
+
+	/*
+	 * Setup each logical cpu, so they can receive uncore pmu interrupt.
+	 */
+	for_each_online_cpu(cpu)
+		smp_call_function_single(cpu, uncore_setup_per_cpu, NULL, 1);
+
+	return 0;
+}
+__initcall(uncore_per_cpu_init);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
new file mode 100644
index 0000000..e616c7b
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -0,0 +1,87 @@
+#include <linux/perf_event.h>
+#include <linux/capability.h>
+#include <linux/notifier.h>
+#include <linux/hardirq.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/kdebug.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/highmem.h>
+#include <linux/cpu.h>
+#include <linux/bitops.h>
+
+#include <asm/apic.h>
+#include <asm/stacktrace.h>
+#include <asm/nmi.h>
+#include <asm/compat.h>
+
+#define MSR_UNCORE_PERF_GLOBAL_CTRL	0x391
+#define MSR_UNCORE_PERF_GLOBAL_STATUS	0x392
+#define MSR_UNCORE_PERF_GLOBAL_OVF_CTRL	0x393
+#define MSR_UNCORE_FIXED_CTR0		0x394
+#define MSR_UNCORE_FIXED_CTR_CTRL	0x395
+#define MSR_UNCORE_ADDR_OPCODE_MATCH	0x396
+
+#define MSR_UNCORE_PMC0			0x3b0
+
+#define MSR_UNCORE_PERFEVTSEL0		0x3c0
+
+#define MSR_UNCORE_PERF_GLOBAL_CTRL_EN_FC0 (1ULL << 32)
+#define MSR_UNCORE_PERF_GLOBAL_CTRL_PMI_CORE0 (1ULL << 48)
+#define MSR_UNCORE_PERF_GLOBAL_CTRL_PMI_FRZ (1ULL << 63)
+
+#define MSR_UNCORE_PERF_GLOBAL_STATUS_OVF_PMI	(1ULL << 61)
+#define MSR_UNCORE_PERF_GLOBAL_STATUS_CHG       (1ULL << 63)
+
+#define MSR_UNCORE_FIXED_EN	(1ULL << 0)
+#define MSR_UNCORE_FIXED_PMI	(1ULL << 2)
+
+#define UNCORE_EVENTSEL_EVENT			0x000000FFULL
+#define UNCORE_EVENTSEL_UMASK			0x0000FF00ULL
+#define UNCORE_EVENTSEL_OCC_CTR_RST		(1ULL << 17)
+#define UNCORE_EVENTSEL_EDGE			(1ULL << 18)
+#define UNCORE_EVENTSEL_PMI			(1ULL << 20)
+#define UNCORE_EVENTSEL_ENABLE			(1ULL << 22)
+#define UNCORE_EVENTSEL_INV			(1ULL << 23)
+#define UNCORE_EVENTSEL_CMASK			0xFF000000ULL
+
+#define UNCORE_RAW_EVENT_MASK		\
+	(UNCORE_EVENTSEL_EVENT |	\
+	 UNCORE_EVENTSEL_UMASK |	\
+	 UNCORE_EVENTSEL_EDGE  |	\
+	 UNCORE_EVENTSEL_INV   |	\
+	 UNCORE_EVENTSEL_CMASK)
+
+#define UNCORE_CNTVAL_BITS	48
+
+/* 8 general purpose counters + 1 fixed-function counter */
+#define UNCORE_NUM_GENERAL_COUNTERS 8
+#define UNCORE_NUM_FIXED_COUNTERS 1
+#define UNCORE_NUM_COUNTERS (UNCORE_NUM_GENERAL_COUNTERS + UNCORE_NUM_FIXED_COUNTERS)
+
+/* TBD: fix event config value passed by userspace */
+#define UNCORE_FIXED_EVENT 0xFF
+#define UNCORE_FIXED_EVENT_IDX 32
+
+union cpuid01_eax {
+	struct {
+		unsigned int stepping:4;
+		unsigned int model:4;
+		unsigned int family:4;
+		unsigned int type:2;
+		unsigned int reserve:2;
+		unsigned int ext_model:4;
+		unsigned int ext_family:4;
+	} split;
+	unsigned int full;
+};
+
+struct node_hw_events {
+	struct perf_event *events[X86_PMC_IDX_MAX]; /* in counter order */
+	int n_events;
+	struct spinlock lock;
+};
+
+extern u64 x86_perf_event_update(struct perf_event *event, int cntval_bits);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 40150f3..7acc40c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -32,6 +32,7 @@ enum perf_type_id {
 	PERF_TYPE_HW_CACHE			= 3,
 	PERF_TYPE_RAW				= 4,
 	PERF_TYPE_BREAKPOINT			= 5,
+	PERF_TYPE_UNCORE			= 6,
 
 	PERF_TYPE_MAX,				/* non-ABI */
 };
-- 
1.7.2.3






