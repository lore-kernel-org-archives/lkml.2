Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab0KLQ4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:56:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59853 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab0KLQzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:55:54 -0500
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] perf-events: Add support for supplementary event registers v2
Date: Fri, 12 Nov 2010 17:55:40 +0100
Message-Id: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Intel Nehalem/Westmere have a special OFFCORE_RESPONSE event
that can be used to monitor any offcore accesses from a core.
This is a very useful event for various tunings, and it's
also needed to implement the generic LLC-* events correctly.

Unfortunately this event requires programming a mask in a separate
register. And worse this separate register is per core, not per
CPU thread.

This patch adds:
- Teaches perf_events that OFFCORE_RESPONSE need extra parameters.
The extra parameters are passed by user space in the unused upper
32bits of the config word.
- Add support to the Intel perf_event core to schedule the per
core resource. I tried to add generic infrastructure for this
that could be also used for other core resources.
The basic code has is patterned after the similar AMD northbridge
constraints code.

Thanks to Stephane Eranian who pointed out some problems
in the original version and suggested improvements.

Full git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git perf-offcore2
Cc: eranian@google.com
v2: Lots of updates based on review feedback. Also fixes some issues
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   70 ++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel.c |  159 ++++++++++++++++++++++++++++++++
 include/linux/perf_event.h             |    2 +
 3 files changed, 231 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ed63101..346006a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -93,6 +93,8 @@ struct amd_nb {
 	struct event_constraint event_constraints[X86_PMC_IDX_MAX];
 };
 
+struct intel_percore;
+
 #define MAX_LBR_ENTRIES		16
 
 struct cpu_hw_events {
@@ -127,6 +129,13 @@ struct cpu_hw_events {
 	struct perf_branch_stack	lbr_stack;
 	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
 
+	/* 
+	 * Intel percore register state.
+	 * Coordinate shared resources between HT threads.
+	 */
+	int 				percore_used; /* Used by this CPU? */
+	struct intel_percore		*per_core;
+
 	/*
 	 * AMD specific bits
 	 */
@@ -175,6 +184,32 @@ struct cpu_hw_events {
 #define for_each_event_constraint(e, c)	\
 	for ((e) = (c); (e)->weight; (e)++)
 
+/*
+ * Extra registers for specific events.
+ * Some events need large masks and require external MSRs.
+ * Define a mapping to these extra registers.
+ * The actual contents are still encoded in unused parts of the
+ * original config u64.
+ */
+struct extra_reg {
+	unsigned int		event;
+	unsigned int		msr;
+	unsigned int		extra_shift;
+	u64 			config_mask;
+	u64 			valid_mask;
+};
+
+#define EVENT_EXTRA_REG(e, ms, m, vm, es) {	\
+	.event = (e),    	\
+	.msr = (ms),	     	\
+	.config_mask = (m),  	\
+	.valid_mask = (vm),	\
+	.extra_shift = (es),	\
+	}
+#define INTEL_EVENT_EXTRA_REG(event, msr, vm, es)	\
+	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, es)
+#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, 0)
+
 union perf_capabilities {
 	struct {
 		u64	lbr_format    : 6;
@@ -219,6 +254,7 @@ struct x86_pmu {
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
+	struct event_constraint *percore_constraints;
 	void		(*quirks)(void);
 	int		perfctr_second_write;
 
@@ -247,6 +283,11 @@ struct x86_pmu {
 	 */
 	unsigned long	lbr_tos, lbr_from, lbr_to; /* MSR base regs       */
 	int		lbr_nr;			   /* hardware stack size */
+
+	/*
+	 * Extra registers for events
+	 */
+	struct extra_reg *extra_regs;
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -321,6 +362,33 @@ again:
 	return new_raw_count;
 }
 
+/*
+ * Find and validate any extra registers to set up.
+ */
+static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
+{
+	struct extra_reg *er;
+	u64 extra;
+
+	event->hw.extra_reg = 0;
+	event->hw.extra_config = 0;
+
+	if (!x86_pmu.extra_regs)
+		return 0;
+
+	for (er = x86_pmu.extra_regs; er->msr; er++) {
+		if (er->event != (config & er->config_mask))
+			continue;
+		event->hw.extra_reg = er->msr;
+		extra = config >> er->extra_shift;
+		if (extra & ~er->valid_mask)
+			return -EINVAL;
+		event->hw.extra_config = extra;
+		break;
+	}
+	return 0;
+}
+
 static atomic_t active_events;
 static DEFINE_MUTEX(pmc_reserve_mutex);
 
@@ -876,6 +944,8 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 					  u64 enable_mask)
 {
 	wrmsrl(hwc->config_base + hwc->idx, hwc->config | enable_mask);
+	if (hwc->extra_reg)
+		wrmsrl(hwc->extra_reg, hwc->extra_config);
 }
 
 static inline void x86_pmu_disable_event(struct perf_event *event)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index c8f5c08..a84de7e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1,5 +1,20 @@
 #ifdef CONFIG_CPU_SUP_INTEL
 
+/* 
+ * Per core state
+ * This used to coordinate shared resources for HT threads.
+ * Exists per CPU, but only the entry for the first CPU
+ * in the core is used.
+ */
+struct intel_percore {
+	raw_spinlock_t 		lock;		/* protect structure */
+	int 			ref;		/* reference count */
+	u64 			config;	        /* main counter config */
+	unsigned int 		extra_reg;	/* extra MSR number */
+	u64 			extra_config;	/* extra MSR config */
+};
+static struct intel_percore __percpu *intel_percore;
+
 /*
  * Intel PerfMon, used on Core and later.
  */
@@ -64,6 +79,18 @@ static struct event_constraint intel_nehalem_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
+static struct extra_reg intel_nehalem_extra_regs[] =
+{
+	INTEL_EVENT_EXTRA_REG(0xb7, 0x1a6, 0xffff, 32), /* OFFCORE_RESPONSE_0 */
+	EVENT_EXTRA_END
+};
+
+static struct event_constraint intel_nehalem_percore_constraints[] =
+{
+	INTEL_EVENT_CONSTRAINT(0xb7, 0),
+	EVENT_CONSTRAINT_END
+};
+
 static struct event_constraint intel_westmere_event_constraints[] =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
@@ -76,6 +103,20 @@ static struct event_constraint intel_westmere_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
+static struct extra_reg intel_westmere_extra_regs[] =
+{
+	INTEL_EVENT_EXTRA_REG(0xb7, 0x1a6, 0xffff, 32), /* OFFCORE_RESPONSE_0 */
+	INTEL_EVENT_EXTRA_REG(0xbb, 0x1a7, 0xffff, 32), /* OFFCORE_RESPONSE_1 */
+	EVENT_EXTRA_END
+};
+
+static struct event_constraint intel_westmere_percore_constraints[] =
+{
+	INTEL_EVENT_CONSTRAINT(0xb7, 0),
+	INTEL_EVENT_CONSTRAINT(0xbb, 0),
+	EVENT_CONSTRAINT_END
+};
+
 static struct event_constraint intel_gen_event_constraints[] =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
@@ -794,6 +835,56 @@ intel_bts_constraints(struct perf_event *event)
 }
 
 static struct event_constraint *
+intel_percore_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned int e = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
+	struct event_constraint *c;
+	struct intel_percore *pc;
+
+	if (!x86_pmu.percore_constraints)
+		return NULL;
+
+	for (c = x86_pmu.percore_constraints; c->cmask; c++) { 
+		if (e != c->code)
+			continue;
+
+		c = NULL;
+
+		/*
+		 * Allocate resource per core.
+		 * Currently only one such per core resource can be allocated.
+		 */
+		pc = cpuc->per_core;
+		if (!pc)
+			break;
+		raw_spin_lock(&pc->lock);
+		if (pc->ref > 0) {
+			/* Allow identical settings */
+			if (hwc->config == pc->config &&
+			    hwc->extra_reg == pc->extra_reg &&
+			    hwc->extra_config == pc->extra_config) {
+				pc->ref++;
+				cpuc->percore_used = 1;
+			} else {
+				/* Deny due to conflict */
+				c = &emptyconstraint;
+			}
+		} else {
+			pc->config = hwc->config;
+			pc->extra_reg = hwc->extra_reg;
+			pc->extra_config = hwc->extra_config;
+			pc->ref = 1;
+			cpuc->percore_used = 1;
+		}
+		raw_spin_unlock(&pc->lock);
+		return c;
+	}
+
+	return NULL;
+}
+
+static struct event_constraint *
 intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
 	struct event_constraint *c;
@@ -806,9 +897,38 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
 	if (c)
 		return c;
 
+	c = intel_percore_constraints(cpuc, event);
+	if (c)
+		return c;
+
 	return x86_get_event_constraints(cpuc, event);
 }
 
+static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
+					struct perf_event *event)
+{
+	struct event_constraint *c;
+	struct intel_percore *pc;
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned int e = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
+
+	if (!cpuc->percore_used)
+		return;
+
+	for (c = x86_pmu.percore_constraints; c->cmask; c++) { 
+		if (e != c->code)
+			continue;
+
+		pc = cpuc->per_core;
+		raw_spin_lock(&pc->lock);
+		pc->ref--;
+		BUG_ON(pc->ref < 0);
+		raw_spin_unlock(&pc->lock);
+		cpuc->percore_used = 0;
+		break;
+	}
+}
+
 static int intel_pmu_hw_config(struct perf_event *event)
 {
 	int ret = x86_pmu_hw_config(event);
@@ -854,6 +974,7 @@ static __initconst const struct x86_pmu core_pmu = {
 	 */
 	.max_period		= (1ULL << 31) - 1,
 	.get_event_constraints	= intel_get_event_constraints,
+	.put_event_constraints	= intel_put_event_constraints,
 	.event_constraints	= intel_core_event_constraints,
 };
 
@@ -892,6 +1013,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	 */
 	.max_period		= (1ULL << 31) - 1,
 	.get_event_constraints	= intel_get_event_constraints,
+	.put_event_constraints	= intel_put_event_constraints,
 
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
@@ -923,6 +1045,35 @@ static void intel_clovertown_quirks(void)
 	x86_pmu.pebs_constraints = NULL;
 }
 
+static __initdata int needs_percore = 1; /* CHANGEME */
+
+static __init int init_intel_percore(void)
+{
+	int cpu;
+
+	if (!needs_percore)
+		return 0;
+
+	intel_percore = alloc_percpu(struct intel_percore);
+	if (!intel_percore)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		raw_spin_lock_init(&per_cpu_ptr(intel_percore, cpu)->lock);
+		per_cpu(cpu_hw_events, cpu).per_core =
+			per_cpu_ptr(intel_percore,
+			    cpumask_first(topology_thread_cpumask(cpu)));
+		printk("cpu %d core %d\n", 
+		       cpu, cpumask_first(topology_thread_cpumask(cpu)));
+	}
+
+	return 0;
+}
+/* 
+ * Runs later because per cpu allocations don't work early on.
+ */
+__initcall(init_intel_percore);
+
 static __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
@@ -1010,7 +1161,11 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_nehalem_event_constraints;
+		x86_pmu.percore_constraints =
+			intel_nehalem_percore_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
+		x86_pmu.extra_regs = intel_nehalem_extra_regs;
+		needs_percore = 1;
 		pr_cont("Nehalem events, ");
 		break;
 
@@ -1032,7 +1187,11 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_westmere_event_constraints;
+		x86_pmu.percore_constraints =
+			intel_westmere_percore_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
+		x86_pmu.extra_regs = intel_westmere_extra_regs;
+		needs_percore = 1;
 		pr_cont("Westmere events, ");
 		break;
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 057bf22..6124e93 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -529,6 +529,8 @@ struct hw_perf_event {
 			unsigned long	event_base;
 			int		idx;
 			int		last_cpu;
+			unsigned int	extra_reg;
+			u64		extra_config;
 		};
 		struct { /* software */
 			struct hrtimer	hrtimer;
-- 
1.7.1

