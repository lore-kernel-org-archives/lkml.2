Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935040Ab1ETOhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:37:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41434 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933843Ab1ETOhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=YMK57GysQ1ga60TDY9uF74Xr0Xqjp4tFKq8pTL9iiyG5EiTECFI8MNjvy31QwcTjD9
         rRn2emBXay/hDsBOFJXQ==
Date: Fri, 20 May 2011 16:37:11 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, andi@firstfloor.org,
        ming.m.lin@intel.com
Subject: [PATCH 1/3] perf_events: update Intel extra regs shared
 constraints management (v2)
Message-ID: <20110520143711.GA5364@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    
This patch improves the code managing the extra shared registers
used for offcore_response events on Intel Nehalem/Westmere. The
idea is to use static allocation instead of dynamic allocation.
This simplifies greatly the get and put constraint routines for
those events.
    
The patch also renames per_core to shared_regs because the same
data structure gets used whether or not HT is on. When HT is
off, those events still need to coordination because they use
a extra MSR that has to be shared within an event group.
    
The first post of this patch had an older (bogus) version of
the patch with bogus initialization of reg->idx.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3a0338b..0f8d3ff 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -45,6 +45,29 @@ do {								\
 #endif
 
 /*
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
+/*
  * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
  */
 static unsigned long
@@ -132,11 +155,10 @@ struct cpu_hw_events {
 	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
 
 	/*
-	 * Intel percore register state.
-	 * Coordinate shared resources between HT threads.
+	 * manage shared (per-core, per-cpu) registers
+	 * used on Intel NHM/WSM/SNB
 	 */
-	int				percore_used; /* Used by this CPU? */
-	struct intel_percore		*per_core;
+	struct intel_shared_regs	*shared_regs;
 
 	/*
 	 * AMD specific bits
@@ -187,26 +209,45 @@ struct cpu_hw_events {
 	for ((e) = (c); (e)->weight; (e)++)
 
 /*
+ * Per register state.
+ */
+struct er_account {
+	raw_spinlock_t		lock;	/* per-core: protect structure */
+	u64			config;	/* extra MSR config */
+	u64			reg;	/* extra MSR number */
+	atomic_t		ref;	/* reference count */
+};
+
+/*
  * Extra registers for specific events.
+ *
  * Some events need large masks and require external MSRs.
- * Define a mapping to these extra registers.
+ * Those extra MSRs end up being shared for all events on
+ * a PMU and sometimes between PMU of sibling HT threads.
+ * In either case, the kernel needs to handle conflicting
+ * accesses to those extra, shared, regs. The data structure
+ * to manage those registers is stored in cpu_hw_event.
  */
 struct extra_reg {
 	unsigned int		event;
 	unsigned int		msr;
 	u64			config_mask;
 	u64			valid_mask;
+	int			idx;  /* per_xxx->regs[] reg index */
 };
 
-#define EVENT_EXTRA_REG(e, ms, m, vm) {	\
+#define EVENT_EXTRA_REG(e, ms, m, vm, i) {	\
 	.event = (e),		\
 	.msr = (ms),		\
 	.config_mask = (m),	\
 	.valid_mask = (vm),	\
+	.idx = EXTRA_REG_##i	\
 	}
-#define INTEL_EVENT_EXTRA_REG(event, msr, vm)	\
-	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm)
-#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0)
+
+#define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
+	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, idx)
+
+#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, RSP_0)
 
 union perf_capabilities {
 	struct {
@@ -252,7 +293,6 @@ struct x86_pmu {
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
-	struct event_constraint *percore_constraints;
 	void		(*quirks)(void);
 	int		perfctr_second_write;
 
@@ -393,10 +433,10 @@ static inline unsigned int x86_pmu_event_addr(int index)
  */
 static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 {
+	struct hw_perf_event_extra *reg;
 	struct extra_reg *er;
 
-	event->hw.extra_reg = 0;
-	event->hw.extra_config = 0;
+	reg = &event->hw.extra_reg;
 
 	if (!x86_pmu.extra_regs)
 		return 0;
@@ -406,8 +446,10 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 			continue;
 		if (event->attr.config1 & ~er->valid_mask)
 			return -EINVAL;
-		event->hw.extra_reg = er->msr;
-		event->hw.extra_config = event->attr.config1;
+
+		reg->idx = er->idx;
+		reg->config = event->attr.config1;
+		reg->reg = er->msr;
 		break;
 	}
 	return 0;
@@ -706,6 +748,9 @@ static int __x86_pmu_event_init(struct perf_event *event)
 	event->hw.last_cpu = -1;
 	event->hw.last_tag = ~0ULL;
 
+	/* mark unused */
+	event->hw.extra_reg.idx = EXTRA_REG_NONE;
+
 	return x86_pmu.hw_config(event);
 }
 
@@ -747,8 +792,8 @@ static void x86_pmu_disable(struct pmu *pmu)
 static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 					  u64 enable_mask)
 {
-	if (hwc->extra_reg)
-		wrmsrl(hwc->extra_reg, hwc->extra_config);
+	if (hwc->extra_reg.reg)
+		wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
 	wrmsrl(hwc->config_base, hwc->config | enable_mask);
 }
 
@@ -1685,7 +1730,6 @@ static int validate_group(struct perf_event *event)
 	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
 	if (!fake_cpuc)
 		goto out;
-
 	/*
 	 * the event is not yet connected with its
 	 * siblings therefore we must first collect
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 41178c8..2d40f33 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1,25 +1,15 @@
 #ifdef CONFIG_CPU_SUP_INTEL
 
-#define MAX_EXTRA_REGS 2
-
-/*
- * Per register state.
- */
-struct er_account {
-	int			ref;		/* reference count */
-	unsigned int		extra_reg;	/* extra MSR number */
-	u64			extra_config;	/* extra MSR config */
-};
-
 /*
- * Per core state
- * This used to coordinate shared registers for HT threads.
+ * Per core/cpu state
+ *
+ * Used to coordinate shared registers between HT threads or
+ * among events on a single PMU.
  */
-struct intel_percore {
-	raw_spinlock_t		lock;		/* protect structure */
-	struct er_account	regs[MAX_EXTRA_REGS];
-	int			refcnt;		/* number of threads */
-	unsigned		core_id;
+struct intel_shared_regs {
+	struct er_account       regs[EXTRA_REG_MAX];
+	int                     refcnt;		/* per-core: #HT threads */
+	unsigned                core_id;	/* per-core: core id */
 };
 
 /*
@@ -88,16 +78,10 @@ static struct event_constraint intel_nehalem_event_constraints[] __read_mostly =
 
 static struct extra_reg intel_nehalem_extra_regs[] __read_mostly =
 {
-	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff),
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
 	EVENT_EXTRA_END
 };
 
-static struct event_constraint intel_nehalem_percore_constraints[] __read_mostly =
-{
-	INTEL_EVENT_CONSTRAINT(0xb7, 0),
-	EVENT_CONSTRAINT_END
-};
-
 static struct event_constraint intel_westmere_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
@@ -125,18 +109,11 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 
 static struct extra_reg intel_westmere_extra_regs[] __read_mostly =
 {
-	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff),
-	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff),
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff, RSP_1),
 	EVENT_EXTRA_END
 };
 
-static struct event_constraint intel_westmere_percore_constraints[] __read_mostly =
-{
-	INTEL_EVENT_CONSTRAINT(0xb7, 0),
-	INTEL_EVENT_CONSTRAINT(0xbb, 0),
-	EVENT_CONSTRAINT_END
-};
-
 static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
@@ -1037,67 +1014,91 @@ intel_bts_constraints(struct perf_event *event)
 	return NULL;
 }
 
+/*
+ * manage allocation of shared extra msr for certain events
+ *
+ * sharing can be:
+ * per-cpu: to be shared between the various events on a single PMU
+ * per-core: per-cpu + shared by HT threads
+ */
 static struct event_constraint *
-intel_percore_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+__intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
+				   struct hw_perf_event_extra *reg)
 {
-	struct hw_perf_event *hwc = &event->hw;
-	unsigned int e = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
-	struct event_constraint *c;
-	struct intel_percore *pc;
+	struct event_constraint *c = &emptyconstraint;
 	struct er_account *era;
-	int i;
-	int free_slot;
-	int found;
 
-	if (!x86_pmu.percore_constraints || hwc->extra_alloc)
-		return NULL;
+	/* already allocated shared msr */
+	if (reg->alloc || !cpuc->shared_regs)
+		return &unconstrained;
 
-	for (c = x86_pmu.percore_constraints; c->cmask; c++) {
-		if (e != c->code)
-			continue;
+	era = &cpuc->shared_regs->regs[reg->idx];
+
+	raw_spin_lock(&era->lock);
+
+	if (!atomic_read(&era->ref) || era->config == reg->config) {
+
+		/* lock in msr value */
+		era->config = reg->config;
+		era->reg = reg->reg;
+
+		/* one more user */
+		atomic_inc(&era->ref);
+
+		/* no need to reallocate during incremental event scheduling */
+		reg->alloc = 1;
 
 		/*
-		 * Allocate resource per core.
+		 * All events using extra_reg are unconstrained.
+		 * Avoids calling x86_get_event_constraints()
+		 *
+		 * Must revisit if extra_reg controlling events
+		 * ever have constraints. Worst case we go through
+		 * the regular event constraint table.
 		 */
-		pc = cpuc->per_core;
-		if (!pc)
-			break;
-		c = &emptyconstraint;
-		raw_spin_lock(&pc->lock);
-		free_slot = -1;
-		found = 0;
-		for (i = 0; i < MAX_EXTRA_REGS; i++) {
-			era = &pc->regs[i];
-			if (era->ref > 0 && hwc->extra_reg == era->extra_reg) {
-				/* Allow sharing same config */
-				if (hwc->extra_config == era->extra_config) {
-					era->ref++;
-					cpuc->percore_used = 1;
-					hwc->extra_alloc = 1;
-					c = NULL;
-				}
-				/* else conflict */
-				found = 1;
-				break;
-			} else if (era->ref == 0 && free_slot == -1)
-				free_slot = i;
-		}
-		if (!found && free_slot != -1) {
-			era = &pc->regs[free_slot];
-			era->ref = 1;
-			era->extra_reg = hwc->extra_reg;
-			era->extra_config = hwc->extra_config;
-			cpuc->percore_used = 1;
-			hwc->extra_alloc = 1;
-			c = NULL;
-		}
-		raw_spin_unlock(&pc->lock);
-		return c;
+		c = &unconstrained;
 	}
+	raw_spin_unlock(&era->lock);
 
-	return NULL;
+	return c;
 }
 
+static void
+__intel_shared_reg_put_constraints(struct cpu_hw_events *cpuc,
+				   struct hw_perf_event_extra *reg)
+{
+	struct er_account *era;
+
+	/*
+	 * only put constraint if extra reg was actually
+	 * allocated. Also takes care of event which do
+	 * not use an extra shared reg
+	 */
+	if (!reg->alloc)
+		return;
+
+	era = &cpuc->shared_regs->regs[reg->idx];
+
+	/* one fewer user */
+	atomic_dec(&era->ref);
+
+	/* allocate again next time */
+	reg->alloc = 0;
+}
+
+static struct event_constraint *
+intel_shared_regs_constraints(struct cpu_hw_events *cpuc,
+			      struct perf_event *event)
+{
+	struct event_constraint *c = NULL;
+	struct hw_perf_event_extra *xreg;
+
+	xreg = &event->hw.extra_reg;
+	if (xreg->idx != EXTRA_REG_NONE)
+		c = __intel_shared_reg_get_constraints(cpuc, xreg);
+	return c;
+ }
+
 static struct event_constraint *
 intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
@@ -1111,49 +1112,28 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
 	if (c)
 		return c;
 
-	c = intel_percore_constraints(cpuc, event);
+	c = intel_shared_regs_constraints(cpuc, event);
 	if (c)
 		return c;
 
 	return x86_get_event_constraints(cpuc, event);
 }
 
-static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
+static void
+intel_put_shared_regs_event_constraints(struct cpu_hw_events *cpuc,
 					struct perf_event *event)
 {
-	struct extra_reg *er;
-	struct intel_percore *pc;
-	struct er_account *era;
-	struct hw_perf_event *hwc = &event->hw;
-	int i, allref;
-
-	if (!cpuc->percore_used)
-		return;
+	struct hw_perf_event_extra *reg;
 
-	for (er = x86_pmu.extra_regs; er->msr; er++) {
-		if (er->event != (hwc->config & er->config_mask))
-			continue;
+	reg = &event->hw.extra_reg;
+	if (reg->idx != EXTRA_REG_NONE)
+		__intel_shared_reg_put_constraints(cpuc, reg);
+}
 
-		pc = cpuc->per_core;
-		raw_spin_lock(&pc->lock);
-		for (i = 0; i < MAX_EXTRA_REGS; i++) {
-			era = &pc->regs[i];
-			if (era->ref > 0 &&
-			    era->extra_config == hwc->extra_config &&
-			    era->extra_reg == er->msr) {
-				era->ref--;
-				hwc->extra_alloc = 0;
-				break;
-			}
-		}
-		allref = 0;
-		for (i = 0; i < MAX_EXTRA_REGS; i++)
-			allref += pc->regs[i].ref;
-		if (allref == 0)
-			cpuc->percore_used = 0;
-		raw_spin_unlock(&pc->lock);
-		break;
-	}
+static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
+					struct perf_event *event)
+{
+	intel_put_shared_regs_event_constraints(cpuc, event);
 }
 
 static int intel_pmu_hw_config(struct perf_event *event)
@@ -1231,20 +1211,36 @@ static __initconst const struct x86_pmu core_pmu = {
 	.event_constraints	= intel_core_event_constraints,
 };
 
+static struct intel_shared_regs *allocate_shared_regs(int cpu)
+{
+	struct intel_shared_regs *regs;
+	int i;
+
+	regs = kzalloc_node(sizeof(struct intel_shared_regs),
+			    GFP_KERNEL, cpu_to_node(cpu));
+	if (regs) {
+		/*
+		 * initialize the locks to keep lockdep happy
+		 */
+		for (i = 0; i < EXTRA_REG_MAX; i++)
+			raw_spin_lock_init(&regs->regs[i].lock);
+
+		regs->core_id = -1;
+	}
+	return regs;
+}
+
 static int intel_pmu_cpu_prepare(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
 
-	if (!cpu_has_ht_siblings())
+	if (!x86_pmu.extra_regs)
 		return NOTIFY_OK;
 
-	cpuc->per_core = kzalloc_node(sizeof(struct intel_percore),
-				      GFP_KERNEL, cpu_to_node(cpu));
-	if (!cpuc->per_core)
+	cpuc->shared_regs = allocate_shared_regs(cpu);
+	if (!cpuc->shared_regs)
 		return NOTIFY_BAD;
 
-	raw_spin_lock_init(&cpuc->per_core->lock);
-	cpuc->per_core->core_id = -1;
 	return NOTIFY_OK;
 }
 
@@ -1260,32 +1256,34 @@ static void intel_pmu_cpu_starting(int cpu)
 	 */
 	intel_pmu_lbr_reset();
 
-	if (!cpu_has_ht_siblings())
+	if (!cpuc->shared_regs)
 		return;
 
 	for_each_cpu(i, topology_thread_cpumask(cpu)) {
-		struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
+		struct intel_shared_regs *pc;
 
+		pc = per_cpu(cpu_hw_events, i).shared_regs;
 		if (pc && pc->core_id == core_id) {
-			kfree(cpuc->per_core);
-			cpuc->per_core = pc;
+			kfree(cpuc->shared_regs);
+			cpuc->shared_regs = pc;
 			break;
 		}
 	}
 
-	cpuc->per_core->core_id = core_id;
-	cpuc->per_core->refcnt++;
+	cpuc->shared_regs->core_id = core_id;
+	cpuc->shared_regs->refcnt++;
 }
 
 static void intel_pmu_cpu_dying(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
-	struct intel_percore *pc = cpuc->per_core;
+	struct intel_shared_regs *pc;
 
+	pc = cpuc->shared_regs;
 	if (pc) {
 		if (pc->core_id == -1 || --pc->refcnt == 0)
 			kfree(pc);
-		cpuc->per_core = NULL;
+		cpuc->shared_regs = NULL;
 	}
 
 	fini_debug_store_on_cpu(cpu);
@@ -1436,7 +1434,6 @@ static __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_nehalem_event_constraints;
 		x86_pmu.pebs_constraints = intel_nehalem_pebs_event_constraints;
-		x86_pmu.percore_constraints = intel_nehalem_percore_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
 
@@ -1481,7 +1478,6 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_westmere_event_constraints;
-		x86_pmu.percore_constraints = intel_westmere_percore_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.pebs_constraints = intel_westmere_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_westmere_extra_regs;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3412684..941f40d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -536,6 +536,16 @@ struct perf_branch_stack {
 
 struct task_struct;
 
+/*
+ * extra PMU register associated with an event
+ */
+struct hw_perf_event_extra {
+	u64		config;	/* register value */
+	unsigned int	reg;	/* register address or index */
+	int		alloc;	/* extra register already allocated */
+	int		idx;	/* index in shared_regs->regs[] */
+};
+
 /**
  * struct hw_perf_event - performance event hardware details:
  */
@@ -549,9 +559,7 @@ struct hw_perf_event {
 			unsigned long	event_base;
 			int		idx;
 			int		last_cpu;
-			unsigned int	extra_reg;
-			u64		extra_config;
-			int		extra_alloc;
+			struct hw_perf_event_extra extra_reg;
 		};
 		struct { /* software */
 			struct hrtimer	hrtimer;
