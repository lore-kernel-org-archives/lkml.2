Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1CCC0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:26:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:26958 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007Ab1CCC0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:26:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,256,1297065600"; 
   d="scan'208";a="663266680"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/4] perf: Add support for supplementary event registers
Date: Thu,  3 Mar 2011 10:34:47 +0800
Message-Id: <1299119690-13991-2-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1299119690-13991-1-git-send-email-ming.m.lin@intel.com>
References: <1299119690-13991-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Change logs against Andi's original version:
- Extends perf_event_attr:config to config{,1,2} (Peter Zijlstra)
- Fixed a major event scheduling issue. There cannot be a ref++ on an
event that has already done ref++ once and without calling
put_constraint() in between. (Stephane Eranian)
- Use thread_cpumask for percore allocation. (Lin Ming)
- Use MSR names in the extra reg lists. (Lin Ming)
- Remove redundant "c = NULL" in intel_percore_constraints
- Fix comment of perf_event_attr::config1

Intel Nehalem/Westmere have a special OFFCORE_RESPONSE event
that can be used to monitor any offcore accesses from a core.
This is a very useful event for various tunings, and it's
also needed to implement the generic LLC-* events correctly.

Unfortunately this event requires programming a mask in a separate
register. And worse this separate register is per core, not per
CPU thread.

This patch adds:
- Teaches perf_events that OFFCORE_RESPONSE needs extra parameters.
The extra parameters are passed by user space in the
perf_event_attr::config1 field.
- Add support to the Intel perf_event core to schedule per
core resources. This adds fairly generic infrastructure that
can be also used for other per core resources.
The basic code has is patterned after the similar AMD northbridge
constraints code.

Thanks to Stephane Eranian who pointed out some problems
in the original version and suggested improvements.

Cc: eranian@google.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/include/asm/msr-index.h       |    3 +
 arch/x86/kernel/cpu/perf_event.c       |   64 ++++++++++
 arch/x86/kernel/cpu/perf_event_intel.c |  200 ++++++++++++++++++++++++++++++++
 include/linux/perf_event.h             |   13 ++-
 4 files changed, 278 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4d0dfa0..d25e74c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -47,6 +47,9 @@
 #define MSR_IA32_MCG_STATUS		0x0000017a
 #define MSR_IA32_MCG_CTL		0x0000017b
 
+#define MSR_OFFCORE_RSP_0		0x000001a6
+#define MSR_OFFCORE_RSP_1		0x000001a7
+
 #define MSR_IA32_PEBS_ENABLE		0x000003f1
 #define MSR_IA32_DS_AREA		0x00000600
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ea03c72..ec6a6db 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -93,6 +93,8 @@ struct amd_nb {
 	struct event_constraint event_constraints[X86_PMC_IDX_MAX];
 };
 
+struct intel_percore;
+
 #define MAX_LBR_ENTRIES		16
 
 struct cpu_hw_events {
@@ -128,6 +130,13 @@ struct cpu_hw_events {
 	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
 
 	/*
+	 * Intel percore register state.
+	 * Coordinate shared resources between HT threads.
+	 */
+	int				percore_used; /* Used by this CPU? */
+	struct intel_percore		*per_core;
+
+	/*
 	 * AMD specific bits
 	 */
 	struct amd_nb		*amd_nb;
@@ -177,6 +186,28 @@ struct cpu_hw_events {
 #define for_each_event_constraint(e, c)	\
 	for ((e) = (c); (e)->weight; (e)++)
 
+/*
+ * Extra registers for specific events.
+ * Some events need large masks and require external MSRs.
+ * Define a mapping to these extra registers.
+ */
+struct extra_reg {
+	unsigned int		event;
+	unsigned int		msr;
+	u64			config_mask;
+	u64			valid_mask;
+};
+
+#define EVENT_EXTRA_REG(e, ms, m, vm) {	\
+	.event = (e),		\
+	.msr = (ms),		\
+	.config_mask = (m),	\
+	.valid_mask = (vm),	\
+	}
+#define INTEL_EVENT_EXTRA_REG(event, msr, vm)	\
+	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm)
+#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0)
+
 union perf_capabilities {
 	struct {
 		u64	lbr_format    : 6;
@@ -221,6 +252,7 @@ struct x86_pmu {
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
+	struct event_constraint *percore_constraints;
 	void		(*quirks)(void);
 	int		perfctr_second_write;
 
@@ -249,6 +281,11 @@ struct x86_pmu {
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
@@ -341,6 +378,31 @@ static inline unsigned int x86_pmu_event_addr(int index)
 	return x86_pmu.perfctr + x86_pmu_addr_offset(index);
 }
 
+/*
+ * Find and validate any extra registers to set up.
+ */
+static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
+{
+	struct extra_reg *er;
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
+		if (event->attr.config1 & ~er->valid_mask)
+			return -EINVAL;
+		event->hw.extra_reg = er->msr;
+		event->hw.extra_config = event->attr.config1;
+		break;
+	}
+	return 0;
+}
+
 static atomic_t active_events;
 static DEFINE_MUTEX(pmc_reserve_mutex);
 
@@ -665,6 +727,8 @@ static void x86_pmu_disable(struct pmu *pmu)
 static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 					  u64 enable_mask)
 {
+	if (hwc->extra_reg)
+		wrmsrl(hwc->extra_reg, hwc->extra_config);
 	wrmsrl(hwc->config_base, hwc->config | enable_mask);
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index ba8aad1..af0c6a2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1,5 +1,27 @@
 #ifdef CONFIG_CPU_SUP_INTEL
 
+#define MAX_EXTRA_REGS 2
+
+/*
+ * Per register state.
+ */
+struct er_account {
+	int			ref;		/* reference count */
+	unsigned int		extra_reg;	/* extra MSR number */
+	u64			extra_config;	/* extra MSR config */
+};
+
+/*
+ * Per core state
+ * This used to coordinate shared registers for HT threads.
+ */
+struct intel_percore {
+	raw_spinlock_t		lock;		/* protect structure */
+	struct er_account	regs[MAX_EXTRA_REGS];
+	int			refcnt;		/* number of threads */
+	unsigned		core_id;
+};
+
 /*
  * Intel PerfMon, used on Core and later.
  */
@@ -64,6 +86,18 @@ static struct event_constraint intel_nehalem_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
+static struct extra_reg intel_nehalem_extra_regs[] =
+{
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff),
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
@@ -89,6 +123,20 @@ static struct event_constraint intel_snb_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
+static struct extra_reg intel_westmere_extra_regs[] =
+{
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff),
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
@@ -907,6 +955,67 @@ intel_bts_constraints(struct perf_event *event)
 }
 
 static struct event_constraint *
+intel_percore_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned int e = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
+	struct event_constraint *c;
+	struct intel_percore *pc;
+	struct er_account *era;
+	int i;
+	int free_slot;
+	int found;
+
+	if (!x86_pmu.percore_constraints || hwc->extra_alloc)
+		return NULL;
+
+	for (c = x86_pmu.percore_constraints; c->cmask; c++) {
+		if (e != c->code)
+			continue;
+
+		/*
+		 * Allocate resource per core.
+		 */
+		pc = cpuc->per_core;
+		if (!pc)
+			break;
+		c = &emptyconstraint;
+		raw_spin_lock(&pc->lock);
+		free_slot = -1;
+		found = 0;
+		for (i = 0; i < MAX_EXTRA_REGS; i++) {
+			era = &pc->regs[i];
+			if (era->ref > 0 && hwc->extra_reg == era->extra_reg) {
+				/* Allow sharing same config */
+				if (hwc->extra_config == era->extra_config) {
+					era->ref++;
+					cpuc->percore_used = 1;
+					hwc->extra_alloc = 1;
+					c = NULL;
+				}
+				/* else conflict */
+				found = 1;
+				break;
+			} else if (era->ref == 0 && free_slot == -1)
+				free_slot = i;
+		}
+		if (!found && free_slot != -1) {
+			era = &pc->regs[free_slot];
+			era->ref = 1;
+			era->extra_reg = hwc->extra_reg;
+			era->extra_config = hwc->extra_config;
+			cpuc->percore_used = 1;
+			hwc->extra_alloc = 1;
+			c = NULL;
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
@@ -919,9 +1028,51 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
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
+	struct extra_reg *er;
+	struct intel_percore *pc;
+	struct er_account *era;
+	struct hw_perf_event *hwc = &event->hw;
+	int i, allref;
+
+	if (!cpuc->percore_used)
+		return;
+
+	for (er = x86_pmu.extra_regs; er->msr; er++) {
+		if (er->event != (hwc->config & er->config_mask))
+			continue;
+
+		pc = cpuc->per_core;
+		raw_spin_lock(&pc->lock);
+		for (i = 0; i < MAX_EXTRA_REGS; i++) {
+			era = &pc->regs[i];
+			if (era->ref > 0 &&
+			    era->extra_config == hwc->extra_config &&
+			    era->extra_reg == er->msr) {
+				era->ref--;
+				hwc->extra_alloc = 0;
+				break;
+			}
+		}
+		allref = 0;
+		for (i = 0; i < MAX_EXTRA_REGS; i++)
+			allref += pc->regs[i].ref;
+		if (allref == 0)
+			cpuc->percore_used = 0;
+		raw_spin_unlock(&pc->lock);
+		break;
+	}
+}
+
 static int intel_pmu_hw_config(struct perf_event *event)
 {
 	int ret = x86_pmu_hw_config(event);
@@ -993,11 +1144,43 @@ static __initconst const struct x86_pmu core_pmu = {
 	 */
 	.max_period		= (1ULL << 31) - 1,
 	.get_event_constraints	= intel_get_event_constraints,
+	.put_event_constraints	= intel_put_event_constraints,
 	.event_constraints	= intel_core_event_constraints,
 };
 
+static int intel_pmu_cpu_prepare(int cpu)
+{
+	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
+
+	cpuc->per_core = kzalloc_node(sizeof(struct intel_percore),
+				      GFP_KERNEL, cpu_to_node(cpu));
+	if (!cpuc->per_core)
+		return NOTIFY_BAD;
+
+	raw_spin_lock_init(&cpuc->per_core->lock);
+	cpuc->per_core->core_id = -1;
+	return NOTIFY_OK;
+}
+
 static void intel_pmu_cpu_starting(int cpu)
 {
+	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
+	int core_id = topology_core_id(cpu);
+	int i;
+
+	for_each_cpu(i, topology_thread_cpumask(cpu)) {
+		struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
+
+		if (pc && pc->core_id == core_id) {
+			kfree(cpuc->per_core);
+			cpuc->per_core = pc;
+			break;
+		}
+	}
+
+	cpuc->per_core->core_id = core_id;
+	cpuc->per_core->refcnt++;
+
 	init_debug_store_on_cpu(cpu);
 	/*
 	 * Deal with CPUs that don't clear their LBRs on power-up.
@@ -1007,6 +1190,15 @@ static void intel_pmu_cpu_starting(int cpu)
 
 static void intel_pmu_cpu_dying(int cpu)
 {
+	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
+	struct intel_percore *pc = cpuc->per_core;
+
+	if (pc) {
+		if (pc->core_id == -1 || --pc->refcnt == 0)
+			kfree(pc);
+		cpuc->per_core = NULL;
+	}
+
 	fini_debug_store_on_cpu(cpu);
 }
 
@@ -1031,7 +1223,9 @@ static __initconst const struct x86_pmu intel_pmu = {
 	 */
 	.max_period		= (1ULL << 31) - 1,
 	.get_event_constraints	= intel_get_event_constraints,
+	.put_event_constraints	= intel_put_event_constraints,
 
+	.cpu_prepare		= intel_pmu_cpu_prepare,
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
 };
@@ -1149,7 +1343,10 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_nehalem_event_constraints;
+		x86_pmu.percore_constraints =
+			intel_nehalem_percore_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
+		x86_pmu.extra_regs = intel_nehalem_extra_regs;
 		pr_cont("Nehalem events, ");
 		break;
 
@@ -1171,7 +1368,10 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_westmere_event_constraints;
+		x86_pmu.percore_constraints =
+			intel_westmere_percore_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
+		x86_pmu.extra_regs = intel_westmere_extra_regs;
 		pr_cont("Westmere events, ");
 		break;
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8ceb5a6..614615b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -225,8 +225,14 @@ struct perf_event_attr {
 	};
 
 	__u32			bp_type;
-	__u64			bp_addr;
-	__u64			bp_len;
+	union {
+		__u64		bp_addr;
+		__u64		config1; /* extension of config */
+	};
+	union {
+		__u64		bp_len;
+		__u64		config2; /* extension of config1 */
+	};
 };
 
 /*
@@ -541,6 +547,9 @@ struct hw_perf_event {
 			unsigned long	event_base;
 			int		idx;
 			int		last_cpu;
+			unsigned int	extra_reg;
+			u64		extra_config;
+			int		extra_alloc;
 		};
 		struct { /* software */
 			struct hrtimer	hrtimer;
-- 
1.7.3

