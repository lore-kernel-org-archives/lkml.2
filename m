Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1H3LW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:22:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64157 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1H3LW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:22:56 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] x86: perf: Clean up perf_event cpu code
Date: Tue, 30 Aug 2011 08:21:31 -0300
Message-Id: <1314703291-3080-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314105839.8002.51.camel@twins>
References: <1314105839.8002.51.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU support for perf events on x86 was implemented via included C files
with #ifdefs.  Clean this up by creating a new header file and compiling
the vendor-specific files as needed.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---

This is the first time I've attempted a patch this large.  Should I break it up
into smaller pieces?  Or does that requirement not really apply since it's just
a cleanup patch?

Also, it is based on Linus' tree, should I base it on tip instead?



 arch/x86/kernel/cpu/Makefile               |    5 +
 arch/x86/kernel/cpu/perf_event.c           |  367 +--------------------
 arch/x86/kernel/cpu/perf_event.h           |  491 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_amd.c       |   18 +-
 arch/x86/kernel/cpu/perf_event_intel.c     |   52 ++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |   79 ++---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   28 +-
 arch/x86/kernel/cpu/perf_event_p4.c        |    9 +-
 arch/x86/kernel/cpu/perf_event_p6.c        |    9 +-
 9 files changed, 600 insertions(+), 458 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6042981..1044fd7 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -28,6 +28,11 @@ obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 
+ifdef CONFIG_PERF_EVENTS
+obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_p4.o perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
+endif
+
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4ee3abf..44574ae 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -32,6 +32,8 @@
 #include <asm/smp.h>
 #include <asm/alternative.h>
 
+#include "perf_event.h"
+
 #if 0
 #undef wrmsrl
 #define wrmsrl(msr, val) 					\
@@ -43,283 +45,17 @@ do {								\
 } while (0)
 #endif
 
-/*
- *          |   NHM/WSM    |      SNB     |
- * register -------------------------------
- *          |  HT  | no HT |  HT  | no HT |
- *-----------------------------------------
- * offcore  | core | core  | cpu  | core  |
- * lbr_sel  | core | core  | cpu  | core  |
- * ld_lat   | cpu  | core  | cpu  | core  |
- *-----------------------------------------
- *
- * Given that there is a small number of shared regs,
- * we can pre-allocate their slot in the per-cpu
- * per-core reg tables.
- */
-enum extra_reg_type {
-	EXTRA_REG_NONE  = -1,	/* not used */
-
-	EXTRA_REG_RSP_0 = 0,	/* offcore_response_0 */
-	EXTRA_REG_RSP_1 = 1,	/* offcore_response_1 */
-
-	EXTRA_REG_MAX		/* number of entries needed */
-};
-
-struct event_constraint {
-	union {
-		unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-		u64		idxmsk64;
-	};
-	u64	code;
-	u64	cmask;
-	int	weight;
-};
-
-struct amd_nb {
-	int nb_id;  /* NorthBridge id */
-	int refcnt; /* reference count */
-	struct perf_event *owners[X86_PMC_IDX_MAX];
-	struct event_constraint event_constraints[X86_PMC_IDX_MAX];
-};
-
-struct intel_percore;
-
-#define MAX_LBR_ENTRIES		16
-
-struct cpu_hw_events {
-	/*
-	 * Generic x86 PMC bits
-	 */
-	struct perf_event	*events[X86_PMC_IDX_MAX]; /* in counter order */
-	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-	unsigned long		running[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-	int			enabled;
-
-	int			n_events;
-	int			n_added;
-	int			n_txn;
-	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
-	u64			tags[X86_PMC_IDX_MAX];
-	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
-
-	unsigned int		group_flag;
-
-	/*
-	 * Intel DebugStore bits
-	 */
-	struct debug_store	*ds;
-	u64			pebs_enabled;
-
-	/*
-	 * Intel LBR bits
-	 */
-	int				lbr_users;
-	void				*lbr_context;
-	struct perf_branch_stack	lbr_stack;
-	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
-
-	/*
-	 * manage shared (per-core, per-cpu) registers
-	 * used on Intel NHM/WSM/SNB
-	 */
-	struct intel_shared_regs	*shared_regs;
-
-	/*
-	 * AMD specific bits
-	 */
-	struct amd_nb		*amd_nb;
-};
-
-#define __EVENT_CONSTRAINT(c, n, m, w) {\
-	{ .idxmsk64 = (n) },		\
-	.code = (c),			\
-	.cmask = (m),			\
-	.weight = (w),			\
-}
-
-#define EVENT_CONSTRAINT(c, n, m)	\
-	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n))
-
-/*
- * Constraint on the Event code.
- */
-#define INTEL_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
-
-/*
- * Constraint on the Event code + UMask + fixed-mask
- *
- * filter mask to validate fixed counter events.
- * the following filters disqualify for fixed counters:
- *  - inv
- *  - edge
- *  - cnt-mask
- *  The other filters are supported by fixed counters.
- *  The any-thread option is supported starting with v3.
- */
-#define FIXED_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, (1ULL << (32+n)), X86_RAW_EVENT_MASK)
-
-/*
- * Constraint on the Event code + UMask
- */
-#define INTEL_UEVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
-
-#define EVENT_CONSTRAINT_END		\
-	EVENT_CONSTRAINT(0, 0, 0)
-
-#define for_each_event_constraint(e, c)	\
-	for ((e) = (c); (e)->weight; (e)++)
-
-/*
- * Per register state.
- */
-struct er_account {
-	raw_spinlock_t		lock;	/* per-core: protect structure */
-	u64			config;	/* extra MSR config */
-	u64			reg;	/* extra MSR number */
-	atomic_t		ref;	/* reference count */
-};
-
-/*
- * Extra registers for specific events.
- *
- * Some events need large masks and require external MSRs.
- * Those extra MSRs end up being shared for all events on
- * a PMU and sometimes between PMU of sibling HT threads.
- * In either case, the kernel needs to handle conflicting
- * accesses to those extra, shared, regs. The data structure
- * to manage those registers is stored in cpu_hw_event.
- */
-struct extra_reg {
-	unsigned int		event;
-	unsigned int		msr;
-	u64			config_mask;
-	u64			valid_mask;
-	int			idx;  /* per_xxx->regs[] reg index */
-};
-
-#define EVENT_EXTRA_REG(e, ms, m, vm, i) {	\
-	.event = (e),		\
-	.msr = (ms),		\
-	.config_mask = (m),	\
-	.valid_mask = (vm),	\
-	.idx = EXTRA_REG_##i	\
-	}
-
-#define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
-	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, idx)
-
-#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, RSP_0)
+struct x86_pmu x86_pmu __read_mostly;
 
-union perf_capabilities {
-	struct {
-		u64	lbr_format    : 6;
-		u64	pebs_trap     : 1;
-		u64	pebs_arch_reg : 1;
-		u64	pebs_format   : 4;
-		u64	smm_freeze    : 1;
-	};
-	u64	capabilities;
-};
-
-/*
- * struct x86_pmu - generic x86 pmu
- */
-struct x86_pmu {
-	/*
-	 * Generic x86 PMC bits
-	 */
-	const char	*name;
-	int		version;
-	int		(*handle_irq)(struct pt_regs *);
-	void		(*disable_all)(void);
-	void		(*enable_all)(int added);
-	void		(*enable)(struct perf_event *);
-	void		(*disable)(struct perf_event *);
-	int		(*hw_config)(struct perf_event *event);
-	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
-	unsigned	eventsel;
-	unsigned	perfctr;
-	u64		(*event_map)(int);
-	int		max_events;
-	int		num_counters;
-	int		num_counters_fixed;
-	int		cntval_bits;
-	u64		cntval_mask;
-	int		apic;
-	u64		max_period;
-	struct event_constraint *
-			(*get_event_constraints)(struct cpu_hw_events *cpuc,
-						 struct perf_event *event);
-
-	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
-						 struct perf_event *event);
-	struct event_constraint *event_constraints;
-	void		(*quirks)(void);
-	int		perfctr_second_write;
-
-	int		(*cpu_prepare)(int cpu);
-	void		(*cpu_starting)(int cpu);
-	void		(*cpu_dying)(int cpu);
-	void		(*cpu_dead)(int cpu);
-
-	/*
-	 * Intel Arch Perfmon v2+
-	 */
-	u64			intel_ctrl;
-	union perf_capabilities intel_cap;
-
-	/*
-	 * Intel DebugStore bits
-	 */
-	int		bts, pebs;
-	int		bts_active, pebs_active;
-	int		pebs_record_size;
-	void		(*drain_pebs)(struct pt_regs *regs);
-	struct event_constraint *pebs_constraints;
-
-	/*
-	 * Intel LBR
-	 */
-	unsigned long	lbr_tos, lbr_from, lbr_to; /* MSR base regs       */
-	int		lbr_nr;			   /* hardware stack size */
-
-	/*
-	 * Extra registers for events
-	 */
-	struct extra_reg *extra_regs;
-	unsigned int er_flags;
-};
-
-#define ERF_NO_HT_SHARING	1
-#define ERF_HAS_RSP_1		2
-
-static struct x86_pmu x86_pmu __read_mostly;
-
-static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
+DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
 
-static int x86_perf_event_set_period(struct perf_event *event);
-
-/*
- * Generalized hw caching related hw_event table, filled
- * in on a per model basis. A value of 0 means
- * 'not supported', -1 means 'hw_event makes no sense on
- * this CPU', any other value means the raw hw_event
- * ID.
- */
-
-#define C(x) PERF_COUNT_HW_CACHE_##x
-
-static u64 __read_mostly hw_cache_event_ids
+u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
-static u64 __read_mostly hw_cache_extra_regs
+u64 __read_mostly hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
@@ -329,8 +65,7 @@ static u64 __read_mostly hw_cache_extra_regs
  * Can only be executed on the CPU where the event is active.
  * Returns the delta events processed.
  */
-static u64
-x86_perf_event_update(struct perf_event *event)
+u64 x86_perf_event_update(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	int shift = 64 - x86_pmu.cntval_bits;
@@ -373,30 +108,6 @@ again:
 	return new_raw_count;
 }
 
-static inline int x86_pmu_addr_offset(int index)
-{
-	int offset;
-
-	/* offset = X86_FEATURE_PERFCTR_CORE ? index << 1 : index */
-	alternative_io(ASM_NOP2,
-		       "shll $1, %%eax",
-		       X86_FEATURE_PERFCTR_CORE,
-		       "=a" (offset),
-		       "a"  (index));
-
-	return offset;
-}
-
-static inline unsigned int x86_pmu_config_addr(int index)
-{
-	return x86_pmu.eventsel + x86_pmu_addr_offset(index);
-}
-
-static inline unsigned int x86_pmu_event_addr(int index)
-{
-	return x86_pmu.perfctr + x86_pmu_addr_offset(index);
-}
-
 /*
  * Find and validate any extra registers to set up.
  */
@@ -532,9 +243,6 @@ msr_fail:
 	return false;
 }
 
-static void reserve_ds_buffers(void);
-static void release_ds_buffers(void);
-
 static void hw_perf_event_destroy(struct perf_event *event)
 {
 	if (atomic_dec_and_mutex_lock(&active_events, &pmc_reserve_mutex)) {
@@ -583,7 +291,7 @@ set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event *event)
 	return x86_pmu_extra_regs(val, event);
 }
 
-static int x86_setup_perfctr(struct perf_event *event)
+int x86_setup_perfctr(struct perf_event *event)
 {
 	struct perf_event_attr *attr = &event->attr;
 	struct hw_perf_event *hwc = &event->hw;
@@ -647,7 +355,7 @@ static int x86_setup_perfctr(struct perf_event *event)
 	return 0;
 }
 
-static int x86_pmu_hw_config(struct perf_event *event)
+int x86_pmu_hw_config(struct perf_event *event)
 {
 	if (event->attr.precise_ip) {
 		int precise = 0;
@@ -723,7 +431,7 @@ static int __x86_pmu_event_init(struct perf_event *event)
 	return x86_pmu.hw_config(event);
 }
 
-static void x86_pmu_disable_all(void)
+void x86_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
@@ -758,15 +466,7 @@ static void x86_pmu_disable(struct pmu *pmu)
 	x86_pmu.disable_all();
 }
 
-static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
-					  u64 enable_mask)
-{
-	if (hwc->extra_reg.reg)
-		wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
-	wrmsrl(hwc->config_base, hwc->config | enable_mask);
-}
-
-static void x86_pmu_enable_all(int added)
+void x86_pmu_enable_all(int added)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
@@ -788,7 +488,7 @@ static inline int is_x86_event(struct perf_event *event)
 	return event->pmu == &pmu;
 }
 
-static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
+int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
 	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
@@ -959,7 +659,6 @@ static inline int match_prev_assignment(struct hw_perf_event *hwc,
 }
 
 static void x86_pmu_start(struct perf_event *event, int flags);
-static void x86_pmu_stop(struct perf_event *event, int flags);
 
 static void x86_pmu_enable(struct pmu *pmu)
 {
@@ -1031,21 +730,13 @@ static void x86_pmu_enable(struct pmu *pmu)
 	x86_pmu.enable_all(added);
 }
 
-static inline void x86_pmu_disable_event(struct perf_event *event)
-{
-	struct hw_perf_event *hwc = &event->hw;
-
-	wrmsrl(hwc->config_base, hwc->config);
-}
-
 static DEFINE_PER_CPU(u64 [X86_PMC_IDX_MAX], pmc_prev_left);
 
 /*
  * Set the next IRQ period, based on the hwc->period_left value.
  * To be called with the event disabled in hw:
  */
-static int
-x86_perf_event_set_period(struct perf_event *event)
+int x86_perf_event_set_period(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	s64 left = local64_read(&hwc->period_left);
@@ -1105,7 +796,7 @@ x86_perf_event_set_period(struct perf_event *event)
 	return ret;
 }
 
-static void x86_pmu_enable_event(struct perf_event *event)
+void x86_pmu_enable_event(struct perf_event *event)
 {
 	if (__this_cpu_read(cpu_hw_events.enabled))
 		__x86_pmu_enable_event(&event->hw,
@@ -1244,7 +935,7 @@ void perf_event_print_debug(void)
 	local_irq_restore(flags);
 }
 
-static void x86_pmu_stop(struct perf_event *event, int flags)
+void x86_pmu_stop(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
@@ -1297,7 +988,7 @@ static void x86_pmu_del(struct perf_event *event, int flags)
 	perf_event_update_userpage(event);
 }
 
-static int x86_pmu_handle_irq(struct pt_regs *regs)
+int x86_pmu_handle_irq(struct pt_regs *regs)
 {
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc;
@@ -1437,30 +1128,8 @@ static __read_mostly struct notifier_block perf_event_nmi_notifier = {
 	.priority		= NMI_LOCAL_LOW_PRIOR,
 };
 
-static struct event_constraint unconstrained;
-static struct event_constraint emptyconstraint;
-
-static struct event_constraint *
-x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
-{
-	struct event_constraint *c;
-
-	if (x86_pmu.event_constraints) {
-		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if ((event->hw.config & c->cmask) == c->code)
-				return c;
-		}
-	}
-
-	return &unconstrained;
-}
-
-#include "perf_event_amd.c"
-#include "perf_event_p6.c"
-#include "perf_event_p4.c"
-#include "perf_event_intel_lbr.c"
-#include "perf_event_intel_ds.c"
-#include "perf_event_intel.c"
+struct event_constraint emptyconstraint;
+struct event_constraint unconstrained;
 
 static int __cpuinit
 x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
new file mode 100644
index 0000000..9381f32
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -0,0 +1,491 @@
+/*
+ * Performance events x86 architecture header
+ *
+ *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
+ *  Copyright (C) 2009 Jaswinder Singh Rajput
+ *  Copyright (C) 2009 Advanced Micro Devices, Inc., Robert Richter
+ *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2009 Intel Corporation, <markus.t.metzger@intel.com>
+ *  Copyright (C) 2009 Google, Inc., Stephane Eranian
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/perf_event.h>
+
+/*
+ *          |   NHM/WSM    |      SNB     |
+ * register -------------------------------
+ *          |  HT  | no HT |  HT  | no HT |
+ *-----------------------------------------
+ * offcore  | core | core  | cpu  | core  |
+ * lbr_sel  | core | core  | cpu  | core  |
+ * ld_lat   | cpu  | core  | cpu  | core  |
+ *-----------------------------------------
+ *
+ * Given that there is a small number of shared regs,
+ * we can pre-allocate their slot in the per-cpu
+ * per-core reg tables.
+ */
+enum extra_reg_type {
+	EXTRA_REG_NONE  = -1,	/* not used */
+
+	EXTRA_REG_RSP_0 = 0,	/* offcore_response_0 */
+	EXTRA_REG_RSP_1 = 1,	/* offcore_response_1 */
+
+	EXTRA_REG_MAX		/* number of entries needed */
+};
+
+struct event_constraint {
+	union {
+		unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+		u64		idxmsk64;
+	};
+	u64	code;
+	u64	cmask;
+	int	weight;
+};
+
+struct amd_nb {
+	int nb_id;  /* NorthBridge id */
+	int refcnt; /* reference count */
+	struct perf_event *owners[X86_PMC_IDX_MAX];
+	struct event_constraint event_constraints[X86_PMC_IDX_MAX];
+};
+
+/* The maximal number of PEBS events: */
+#define MAX_PEBS_EVENTS		4
+
+/*
+ * A debug store configuration.
+ *
+ * We only support architectures that use 64bit fields.
+ */
+struct debug_store {
+	u64	bts_buffer_base;
+	u64	bts_index;
+	u64	bts_absolute_maximum;
+	u64	bts_interrupt_threshold;
+	u64	pebs_buffer_base;
+	u64	pebs_index;
+	u64	pebs_absolute_maximum;
+	u64	pebs_interrupt_threshold;
+	u64	pebs_event_reset[MAX_PEBS_EVENTS];
+};
+
+/*
+ * Per register state.
+ */
+struct er_account {
+	raw_spinlock_t		lock;	/* per-core: protect structure */
+	u64                 config;	/* extra MSR config */
+	u64                 reg;	/* extra MSR number */
+	atomic_t            ref;	/* reference count */
+};
+
+/*
+ * Per core/cpu state
+ *
+ * Used to coordinate shared registers between HT threads or
+ * among events on a single PMU.
+ */
+struct intel_shared_regs {
+	struct er_account       regs[EXTRA_REG_MAX];
+	int                     refcnt;		/* per-core: #HT threads */
+	unsigned                core_id;	/* per-core: core id */
+};
+
+#define MAX_LBR_ENTRIES		16
+
+struct cpu_hw_events {
+	/*
+	 * Generic x86 PMC bits
+	 */
+	struct perf_event	*events[X86_PMC_IDX_MAX]; /* in counter order */
+	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long		running[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	int			enabled;
+
+	int			n_events;
+	int			n_added;
+	int			n_txn;
+	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
+	u64			tags[X86_PMC_IDX_MAX];
+	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
+
+	unsigned int		group_flag;
+
+	/*
+	 * Intel DebugStore bits
+	 */
+	struct debug_store	*ds;
+	u64			pebs_enabled;
+
+	/*
+	 * Intel LBR bits
+	 */
+	int				lbr_users;
+	void				*lbr_context;
+	struct perf_branch_stack	lbr_stack;
+	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
+
+	/*
+	 * manage shared (per-core, per-cpu) registers
+	 * used on Intel NHM/WSM/SNB
+	 */
+	struct intel_shared_regs	*shared_regs;
+
+	/*
+	 * AMD specific bits
+	 */
+	struct amd_nb		*amd_nb;
+};
+
+#define __EVENT_CONSTRAINT(c, n, m, w) {\
+	{ .idxmsk64 = (n) },		\
+	.code = (c),			\
+	.cmask = (m),			\
+	.weight = (w),			\
+}
+
+#define EVENT_CONSTRAINT(c, n, m)	\
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n))
+
+/*
+ * Constraint on the Event code.
+ */
+#define INTEL_EVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
+
+/*
+ * Constraint on the Event code + UMask + fixed-mask
+ *
+ * filter mask to validate fixed counter events.
+ * the following filters disqualify for fixed counters:
+ *  - inv
+ *  - edge
+ *  - cnt-mask
+ *  The other filters are supported by fixed counters.
+ *  The any-thread option is supported starting with v3.
+ */
+#define FIXED_EVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, (1ULL << (32+n)), X86_RAW_EVENT_MASK)
+
+/*
+ * Constraint on the Event code + UMask
+ */
+#define INTEL_UEVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
+
+#define EVENT_CONSTRAINT_END		\
+	EVENT_CONSTRAINT(0, 0, 0)
+
+#define for_each_event_constraint(e, c)	\
+	for ((e) = (c); (e)->weight; (e)++)
+
+/*
+ * Extra registers for specific events.
+ *
+ * Some events need large masks and require external MSRs.
+ * Those extra MSRs end up being shared for all events on
+ * a PMU and sometimes between PMU of sibling HT threads.
+ * In either case, the kernel needs to handle conflicting
+ * accesses to those extra, shared, regs. The data structure
+ * to manage those registers is stored in cpu_hw_event.
+ */
+struct extra_reg {
+	unsigned int		event;
+	unsigned int		msr;
+	u64			config_mask;
+	u64			valid_mask;
+	int			idx;  /* per_xxx->regs[] reg index */
+};
+
+#define EVENT_EXTRA_REG(e, ms, m, vm, i) {	\
+	.event = (e),		\
+	.msr = (ms),		\
+	.config_mask = (m),	\
+	.valid_mask = (vm),	\
+	.idx = EXTRA_REG_##i	\
+	}
+
+#define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
+	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, idx)
+
+#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, RSP_0)
+
+union perf_capabilities {
+	struct {
+		u64	lbr_format:6;
+		u64	pebs_trap:1;
+		u64	pebs_arch_reg:1;
+		u64	pebs_format:4;
+		u64	smm_freeze:1;
+	};
+	u64	capabilities;
+};
+
+/*
+ * struct x86_pmu - generic x86 pmu
+ */
+struct x86_pmu {
+	/*
+	 * Generic x86 PMC bits
+	 */
+	const char	*name;
+	int		version;
+	int		(*handle_irq)(struct pt_regs *);
+	void		(*disable_all)(void);
+	void		(*enable_all)(int added);
+	void		(*enable)(struct perf_event *);
+	void		(*disable)(struct perf_event *);
+	int		(*hw_config)(struct perf_event *event);
+	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
+	unsigned	eventsel;
+	unsigned	perfctr;
+	u64		(*event_map)(int);
+	int		max_events;
+	int		num_counters;
+	int		num_counters_fixed;
+	int		cntval_bits;
+	u64		cntval_mask;
+	int		apic;
+	u64		max_period;
+	struct event_constraint *
+			(*get_event_constraints)(struct cpu_hw_events *cpuc,
+						 struct perf_event *event);
+
+	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
+						 struct perf_event *event);
+	struct event_constraint *event_constraints;
+	void		(*quirks)(void);
+	int		perfctr_second_write;
+
+	int		(*cpu_prepare)(int cpu);
+	void		(*cpu_starting)(int cpu);
+	void		(*cpu_dying)(int cpu);
+	void		(*cpu_dead)(int cpu);
+
+	/*
+	 * Intel Arch Perfmon v2+
+	 */
+	u64			intel_ctrl;
+	union perf_capabilities intel_cap;
+
+	/*
+	 * Intel DebugStore bits
+	 */
+	int		bts, pebs;
+	int		bts_active, pebs_active;
+	int		pebs_record_size;
+	void		(*drain_pebs)(struct pt_regs *regs);
+	struct event_constraint *pebs_constraints;
+
+	/*
+	 * Intel LBR
+	 */
+	unsigned long	lbr_tos, lbr_from, lbr_to; /* MSR base regs       */
+	int		lbr_nr;			   /* hardware stack size */
+
+	/*
+	 * Extra registers for events
+	 */
+	struct extra_reg *extra_regs;
+	unsigned int er_flags;
+};
+
+#define ERF_NO_HT_SHARING	1
+#define ERF_HAS_RSP_1		2
+
+extern struct x86_pmu x86_pmu __read_mostly;
+
+DECLARE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
+
+int x86_perf_event_set_period(struct perf_event *event);
+
+/*
+ * Generalized hw caching related hw_event table, filled
+ * in on a per model basis. A value of 0 means
+ * 'not supported', -1 means 'hw_event makes no sense on
+ * this CPU', any other value means the raw hw_event
+ * ID.
+ */
+
+#define C(x) PERF_COUNT_HW_CACHE_##x
+
+extern u64 __read_mostly hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX];
+extern u64 __read_mostly hw_cache_extra_regs
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX];
+
+u64 x86_perf_event_update(struct perf_event *event);
+
+static inline int x86_pmu_addr_offset(int index)
+{
+	int offset;
+
+	/* offset = X86_FEATURE_PERFCTR_CORE ? index << 1 : index */
+	alternative_io(ASM_NOP2,
+		       "shll $1, %%eax",
+		       X86_FEATURE_PERFCTR_CORE,
+		       "=a" (offset),
+		       "a"  (index));
+
+	return offset;
+}
+
+static inline unsigned int x86_pmu_config_addr(int index)
+{
+	return x86_pmu.eventsel + x86_pmu_addr_offset(index);
+}
+
+static inline unsigned int x86_pmu_event_addr(int index)
+{
+	return x86_pmu.perfctr + x86_pmu_addr_offset(index);
+}
+
+int x86_setup_perfctr(struct perf_event *event);
+
+int x86_pmu_hw_config(struct perf_event *event);
+
+void x86_pmu_disable_all(void);
+
+static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
+					  u64 enable_mask)
+{
+	if (hwc->extra_reg.reg)
+		wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
+	wrmsrl(hwc->config_base, hwc->config | enable_mask);
+}
+
+void x86_pmu_enable_all(int added);
+
+int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign);
+
+void x86_pmu_stop(struct perf_event *event, int flags);
+
+static inline void x86_pmu_disable_event(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	wrmsrl(hwc->config_base, hwc->config);
+}
+
+void x86_pmu_enable_event(struct perf_event *event);
+
+int x86_pmu_handle_irq(struct pt_regs *regs);
+
+extern struct event_constraint emptyconstraint;
+
+extern struct event_constraint unconstrained;
+
+#ifdef CONFIG_CPU_SUP_AMD
+
+int amd_pmu_init(void);
+
+#else /* CONFIG_CPU_SUP_AMD */
+
+static inline int amd_pmu_init(void)
+{
+	return 0;
+}
+
+#endif /* CONFIG_CPU_SUP_AMD */
+
+#ifdef CONFIG_CPU_SUP_INTEL
+
+int intel_pmu_save_and_restart(struct perf_event *event);
+
+struct event_constraint *
+x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event);
+
+struct intel_shared_regs *allocate_shared_regs(int cpu);
+
+int intel_pmu_init(void);
+
+void init_debug_store_on_cpu(int cpu);
+
+void fini_debug_store_on_cpu(int cpu);
+
+void release_ds_buffers(void);
+
+void reserve_ds_buffers(void);
+
+extern struct event_constraint bts_constraint;
+
+void intel_pmu_enable_bts(u64 config);
+
+void intel_pmu_disable_bts(void);
+
+int intel_pmu_drain_bts_buffer(void);
+
+extern struct event_constraint intel_core2_pebs_event_constraints[];
+
+extern struct event_constraint intel_atom_pebs_event_constraints[];
+
+extern struct event_constraint intel_nehalem_pebs_event_constraints[];
+
+extern struct event_constraint intel_westmere_pebs_event_constraints[];
+
+extern struct event_constraint intel_snb_pebs_event_constraints[];
+
+struct event_constraint *intel_pebs_constraints(struct perf_event *event);
+
+void intel_pmu_pebs_enable(struct perf_event *event);
+
+void intel_pmu_pebs_disable(struct perf_event *event);
+
+void intel_pmu_pebs_enable_all(void);
+
+void intel_pmu_pebs_disable_all(void);
+
+void intel_ds_init(void);
+
+void intel_pmu_lbr_reset(void);
+
+void intel_pmu_lbr_enable(struct perf_event *event);
+
+void intel_pmu_lbr_disable(struct perf_event *event);
+
+void intel_pmu_lbr_enable_all(void);
+
+void intel_pmu_lbr_disable_all(void);
+
+void intel_pmu_lbr_read(void);
+
+void intel_pmu_lbr_init_core(void);
+
+void intel_pmu_lbr_init_nhm(void);
+
+void intel_pmu_lbr_init_atom(void);
+
+int p4_pmu_init(void);
+
+int p6_pmu_init(void);
+
+#else /* CONFIG_CPU_SUP_INTEL */
+
+static inline void reserve_ds_buffers(void)
+{
+}
+
+static inline void release_ds_buffers(void)
+{
+}
+
+static inline int intel_pmu_init(void)
+{
+	return 0;
+}
+
+static inline struct intel_shared_regs *allocate_shared_regs(int cpu)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 941caa2..9a526ee 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -1,4 +1,9 @@
-#ifdef CONFIG_CPU_SUP_AMD
+#include <linux/perf_event.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+
+#include "perf_event.h"
 
 static __initconst const u64 amd_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
@@ -573,7 +578,7 @@ static __initconst const struct x86_pmu amd_pmu_f15h = {
 #endif
 };
 
-static __init int amd_pmu_init(void)
+__init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
 	if (boot_cpu_data.x86 < 6)
@@ -602,12 +607,3 @@ static __init int amd_pmu_init(void)
 
 	return 0;
 }
-
-#else /* CONFIG_CPU_SUP_AMD */
-
-static int amd_pmu_init(void)
-{
-	return 0;
-}
-
-#endif
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f88af2c..277891d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1,16 +1,18 @@
-#ifdef CONFIG_CPU_SUP_INTEL
-
 /*
  * Per core/cpu state
  *
  * Used to coordinate shared registers between HT threads or
  * among events on a single PMU.
  */
-struct intel_shared_regs {
-	struct er_account       regs[EXTRA_REG_MAX];
-	int                     refcnt;		/* per-core: #HT threads */
-	unsigned                core_id;	/* per-core: core id */
-};
+
+#include <linux/stddef.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+
+#include <asm/hardirq.h>
+
+#include "perf_event.h"
 
 /*
  * Intel PerfMon, used on Core and later.
@@ -945,7 +947,7 @@ static void intel_pmu_enable_event(struct perf_event *event)
  * Save and restart an expired event. Called by NMI contexts,
  * so it has to be careful about preempting normal event ops:
  */
-static int intel_pmu_save_and_restart(struct perf_event *event)
+int intel_pmu_save_and_restart(struct perf_event *event)
 {
 	x86_perf_event_update(event);
 	return x86_perf_event_set_period(event);
@@ -1197,6 +1199,21 @@ intel_shared_regs_constraints(struct cpu_hw_events *cpuc,
 	return c;
 }
 
+struct event_constraint *
+x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct event_constraint *c;
+
+	if (x86_pmu.event_constraints) {
+		for_each_event_constraint(c, x86_pmu.event_constraints) {
+			if ((event->hw.config & c->cmask) == c->code)
+				return c;
+		}
+	}
+
+	return &unconstrained;
+}
+
 static struct event_constraint *
 intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
@@ -1309,7 +1326,7 @@ static __initconst const struct x86_pmu core_pmu = {
 	.event_constraints	= intel_core_event_constraints,
 };
 
-static struct intel_shared_regs *allocate_shared_regs(int cpu)
+struct intel_shared_regs *allocate_shared_regs(int cpu)
 {
 	struct intel_shared_regs *regs;
 	int i;
@@ -1441,7 +1458,7 @@ static void intel_clovertown_quirks(void)
 	x86_pmu.pebs_constraints = NULL;
 }
 
-static __init int intel_pmu_init(void)
+__init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
 	union cpuid10_eax eax;
@@ -1597,7 +1614,7 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
-		x86_pmu.pebs_constraints = intel_snb_pebs_events;
+		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
@@ -1628,16 +1645,3 @@ static __init int intel_pmu_init(void)
 	}
 	return 0;
 }
-
-#else /* CONFIG_CPU_SUP_INTEL */
-
-static int intel_pmu_init(void)
-{
-	return 0;
-}
-
-static struct intel_shared_regs *allocate_shared_regs(int cpu)
-{
-	return NULL;
-}
-#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 1b1ef3a..c0d238f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -1,7 +1,10 @@
-#ifdef CONFIG_CPU_SUP_INTEL
+#include <linux/bitops.h>
+#include <linux/types.h>
+#include <linux/slab.h>
 
-/* The maximal number of PEBS events: */
-#define MAX_PEBS_EVENTS		4
+#include <asm/perf_event.h>
+
+#include "perf_event.h"
 
 /* The size of a BTS record in bytes: */
 #define BTS_RECORD_SIZE		24
@@ -37,24 +40,7 @@ struct pebs_record_nhm {
 	u64 status, dla, dse, lat;
 };
 
-/*
- * A debug store configuration.
- *
- * We only support architectures that use 64bit fields.
- */
-struct debug_store {
-	u64	bts_buffer_base;
-	u64	bts_index;
-	u64	bts_absolute_maximum;
-	u64	bts_interrupt_threshold;
-	u64	pebs_buffer_base;
-	u64	pebs_index;
-	u64	pebs_absolute_maximum;
-	u64	pebs_interrupt_threshold;
-	u64	pebs_event_reset[MAX_PEBS_EVENTS];
-};
-
-static void init_debug_store_on_cpu(int cpu)
+void init_debug_store_on_cpu(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
 
@@ -66,7 +52,7 @@ static void init_debug_store_on_cpu(int cpu)
 		     (u32)((u64)(unsigned long)ds >> 32));
 }
 
-static void fini_debug_store_on_cpu(int cpu)
+void fini_debug_store_on_cpu(int cpu)
 {
 	if (!per_cpu(cpu_hw_events, cpu).ds)
 		return;
@@ -175,7 +161,7 @@ static void release_ds_buffer(int cpu)
 	kfree(ds);
 }
 
-static void release_ds_buffers(void)
+void release_ds_buffers(void)
 {
 	int cpu;
 
@@ -194,7 +180,7 @@ static void release_ds_buffers(void)
 	put_online_cpus();
 }
 
-static void reserve_ds_buffers(void)
+void reserve_ds_buffers(void)
 {
 	int bts_err = 0, pebs_err = 0;
 	int cpu;
@@ -260,10 +246,10 @@ static void reserve_ds_buffers(void)
  * BTS
  */
 
-static struct event_constraint bts_constraint =
+struct event_constraint bts_constraint =
 	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
 
-static void intel_pmu_enable_bts(u64 config)
+void intel_pmu_enable_bts(u64 config)
 {
 	unsigned long debugctlmsr;
 
@@ -282,7 +268,7 @@ static void intel_pmu_enable_bts(u64 config)
 	update_debugctlmsr(debugctlmsr);
 }
 
-static void intel_pmu_disable_bts(void)
+void intel_pmu_disable_bts(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	unsigned long debugctlmsr;
@@ -299,7 +285,7 @@ static void intel_pmu_disable_bts(void)
 	update_debugctlmsr(debugctlmsr);
 }
 
-static int intel_pmu_drain_bts_buffer(void)
+int intel_pmu_drain_bts_buffer(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
@@ -361,7 +347,7 @@ static int intel_pmu_drain_bts_buffer(void)
 /*
  * PEBS
  */
-static struct event_constraint intel_core2_pebs_event_constraints[] = {
+struct event_constraint intel_core2_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
 	INTEL_UEVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
 	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
@@ -370,14 +356,14 @@ static struct event_constraint intel_core2_pebs_event_constraints[] = {
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_atom_pebs_event_constraints[] = {
+struct event_constraint intel_atom_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
 	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
 	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_nehalem_pebs_event_constraints[] = {
+struct event_constraint intel_nehalem_pebs_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),    /* MEM_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
@@ -392,7 +378,7 @@ static struct event_constraint intel_nehalem_pebs_event_constraints[] = {
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_westmere_pebs_event_constraints[] = {
+struct event_constraint intel_westmere_pebs_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),    /* MEM_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
@@ -407,7 +393,7 @@ static struct event_constraint intel_westmere_pebs_event_constraints[] = {
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_snb_pebs_events[] = {
+struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
 	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
@@ -428,8 +414,7 @@ static struct event_constraint intel_snb_pebs_events[] = {
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint *
-intel_pebs_constraints(struct perf_event *event)
+struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 {
 	struct event_constraint *c;
 
@@ -446,7 +431,7 @@ intel_pebs_constraints(struct perf_event *event)
 	return &emptyconstraint;
 }
 
-static void intel_pmu_pebs_enable(struct perf_event *event)
+void intel_pmu_pebs_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
@@ -460,7 +445,7 @@ static void intel_pmu_pebs_enable(struct perf_event *event)
 		intel_pmu_lbr_enable(event);
 }
 
-static void intel_pmu_pebs_disable(struct perf_event *event)
+void intel_pmu_pebs_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
@@ -475,7 +460,7 @@ static void intel_pmu_pebs_disable(struct perf_event *event)
 		intel_pmu_lbr_disable(event);
 }
 
-static void intel_pmu_pebs_enable_all(void)
+void intel_pmu_pebs_enable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -483,7 +468,7 @@ static void intel_pmu_pebs_enable_all(void)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
 }
 
-static void intel_pmu_pebs_disable_all(void)
+void intel_pmu_pebs_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -576,8 +561,6 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	return 0;
 }
 
-static int intel_pmu_save_and_restart(struct perf_event *event);
-
 static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs, void *__pebs)
 {
@@ -716,7 +699,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
  * BTS, PEBS probe and setup
  */
 
-static void intel_ds_init(void)
+void intel_ds_init(void)
 {
 	/*
 	 * No support for 32bit formats
@@ -749,15 +732,3 @@ static void intel_ds_init(void)
 		}
 	}
 }
-
-#else /* CONFIG_CPU_SUP_INTEL */
-
-static void reserve_ds_buffers(void)
-{
-}
-
-static void release_ds_buffers(void)
-{
-}
-
-#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d202c1b..3fab3de 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -1,4 +1,10 @@
-#ifdef CONFIG_CPU_SUP_INTEL
+#include <linux/perf_event.h>
+#include <linux/types.h>
+
+#include <asm/perf_event.h>
+#include <asm/msr.h>
+
+#include "perf_event.h"
 
 enum {
 	LBR_FORMAT_32		= 0x00,
@@ -48,7 +54,7 @@ static void intel_pmu_lbr_reset_64(void)
 	}
 }
 
-static void intel_pmu_lbr_reset(void)
+void intel_pmu_lbr_reset(void)
 {
 	if (!x86_pmu.lbr_nr)
 		return;
@@ -59,7 +65,7 @@ static void intel_pmu_lbr_reset(void)
 		intel_pmu_lbr_reset_64();
 }
 
-static void intel_pmu_lbr_enable(struct perf_event *event)
+void intel_pmu_lbr_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -81,7 +87,7 @@ static void intel_pmu_lbr_enable(struct perf_event *event)
 	cpuc->lbr_users++;
 }
 
-static void intel_pmu_lbr_disable(struct perf_event *event)
+void intel_pmu_lbr_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -95,7 +101,7 @@ static void intel_pmu_lbr_disable(struct perf_event *event)
 		__intel_pmu_lbr_disable();
 }
 
-static void intel_pmu_lbr_enable_all(void)
+void intel_pmu_lbr_enable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -103,7 +109,7 @@ static void intel_pmu_lbr_enable_all(void)
 		__intel_pmu_lbr_enable();
 }
 
-static void intel_pmu_lbr_disable_all(void)
+void intel_pmu_lbr_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -178,7 +184,7 @@ static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 	cpuc->lbr_stack.nr = i;
 }
 
-static void intel_pmu_lbr_read(void)
+void intel_pmu_lbr_read(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -191,7 +197,7 @@ static void intel_pmu_lbr_read(void)
 		intel_pmu_lbr_read_64(cpuc);
 }
 
-static void intel_pmu_lbr_init_core(void)
+void intel_pmu_lbr_init_core(void)
 {
 	x86_pmu.lbr_nr     = 4;
 	x86_pmu.lbr_tos    = 0x01c9;
@@ -199,7 +205,7 @@ static void intel_pmu_lbr_init_core(void)
 	x86_pmu.lbr_to     = 0x60;
 }
 
-static void intel_pmu_lbr_init_nhm(void)
+void intel_pmu_lbr_init_nhm(void)
 {
 	x86_pmu.lbr_nr     = 16;
 	x86_pmu.lbr_tos    = 0x01c9;
@@ -207,12 +213,10 @@ static void intel_pmu_lbr_init_nhm(void)
 	x86_pmu.lbr_to     = 0x6c0;
 }
 
-static void intel_pmu_lbr_init_atom(void)
+void intel_pmu_lbr_init_atom(void)
 {
 	x86_pmu.lbr_nr	   = 8;
 	x86_pmu.lbr_tos    = 0x01c9;
 	x86_pmu.lbr_from   = 0x40;
 	x86_pmu.lbr_to     = 0x60;
 }
-
-#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 7809d2bc..5edb266 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -7,9 +7,12 @@
  *  For licencing details see kernel-base/COPYING
  */
 
-#ifdef CONFIG_CPU_SUP_INTEL
+#include <linux/perf_event.h>
 
 #include <asm/perf_event_p4.h>
+#include <asm/hardirq.h>
+
+#include "perf_event.h"
 
 #define P4_CNTR_LIMIT 3
 /*
@@ -1303,7 +1306,7 @@ static __initconst const struct x86_pmu p4_pmu = {
 	.perfctr_second_write	= 1,
 };
 
-static __init int p4_pmu_init(void)
+__init int p4_pmu_init(void)
 {
 	unsigned int low, high;
 
@@ -1326,5 +1329,3 @@ static __init int p4_pmu_init(void)
 
 	return 0;
 }
-
-#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 20c097e..c7181be 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -1,4 +1,7 @@
-#ifdef CONFIG_CPU_SUP_INTEL
+#include <linux/perf_event.h>
+#include <linux/types.h>
+
+#include "perf_event.h"
 
 /*
  * Not sure about some of these
@@ -114,7 +117,7 @@ static __initconst const struct x86_pmu p6_pmu = {
 	.event_constraints	= p6_event_constraints,
 };
 
-static __init int p6_pmu_init(void)
+__init int p6_pmu_init(void)
 {
 	switch (boot_cpu_data.x86_model) {
 	case 1:
@@ -138,5 +141,3 @@ static __init int p6_pmu_init(void)
 
 	return 0;
 }
-
-#endif /* CONFIG_CPU_SUP_INTEL */
-- 
1.7.6.1

