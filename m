Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2BBMzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:55:41 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63223 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab2BBMzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:55:37 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: [PATCH v5 03/18] perf: add Intel X86 LBR sharing logic
Date: Thu,  2 Feb 2012 13:54:33 +0100
Message-Id: <1328187288-24395-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1328187288-24395-1-git-send-email-eranian@google.com>
References: <1328187288-24395-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel LBR on some recent processor is capable
of filtering branches by type. The filter is configurable
via the LBR_SELECT MSR register.

There are limitation on how this register can be used.

On Nehalem/Westmere, the LBR_SELECT is shared by the two HT threads
when HT is on. It is private to each core when HT is off.

On SandyBridge, the LBR_SELECT register is private to each thread
when HT is on. It is private to each core when HT is off.

The kernel must manage the sharing of LBR_SELECT. It allows
multiple users on the same logical CPU to use LBR_SELECT as
long as they program it with the same value. Across sibling
CPUs (HT threads), the same restriction applies on NHM/WSM.

This patch implements this sharing logic by leveraging the
mechanism put in place for managing the offcore_response
shared MSR.

We modify __intel_shared_reg_get_constraints() to cause
x86_get_event_constraint() to be called because LBR may
be associated with events that may be counter constrained.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c       |    4 ++
 arch/x86/kernel/cpu/perf_event.h       |    4 ++
 arch/x86/kernel/cpu/perf_event_intel.c |   70 ++++++++++++++++++++------------
 3 files changed, 52 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f8bddb5..3779313 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -426,6 +426,10 @@ static int __x86_pmu_event_init(struct perf_event *event)
 	/* mark unused */
 	event->hw.extra_reg.idx = EXTRA_REG_NONE;
 
+	/* mark not used */
+	event->hw.extra_reg.idx = EXTRA_REG_NONE;
+	event->hw.branch_reg.idx = EXTRA_REG_NONE;
+
 	return x86_pmu.hw_config(event);
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 513d617..4535ada 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -33,6 +33,7 @@ enum extra_reg_type {
 
 	EXTRA_REG_RSP_0 = 0,	/* offcore_response_0 */
 	EXTRA_REG_RSP_1 = 1,	/* offcore_response_1 */
+	EXTRA_REG_LBR   = 2,	/* lbr_select */
 
 	EXTRA_REG_MAX		/* number of entries needed */
 };
@@ -130,6 +131,7 @@ struct cpu_hw_events {
 	void				*lbr_context;
 	struct perf_branch_stack	lbr_stack;
 	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
+	struct er_account		*lbr_sel;
 
 	/*
 	 * Intel host/guest exclude bits
@@ -340,6 +342,8 @@ struct x86_pmu {
 	 */
 	unsigned long	lbr_tos, lbr_from, lbr_to; /* MSR base regs       */
 	int		lbr_nr;			   /* hardware stack size */
+	u64		lbr_sel_mask;		   /* LBR_SELECT valid bits */
+	const int	*lbr_sel_map;		   /* lbr_select mappings */
 
 	/*
 	 * Extra registers for events
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 3bd37bd..97f7bb5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1123,17 +1123,17 @@ static bool intel_try_alt_er(struct perf_event *event, int orig_idx)
  */
 static struct event_constraint *
 __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
-				   struct perf_event *event)
+				   struct perf_event *event,
+				   struct hw_perf_event_extra *reg)
 {
 	struct event_constraint *c = &emptyconstraint;
-	struct hw_perf_event_extra *reg = &event->hw.extra_reg;
 	struct er_account *era;
 	unsigned long flags;
 	int orig_idx = reg->idx;
 
 	/* already allocated shared msr */
 	if (reg->alloc)
-		return &unconstrained;
+		return NULL; /* call x86_get_event_constraint() */
 
 again:
 	era = &cpuc->shared_regs->regs[reg->idx];
@@ -1156,14 +1156,10 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
 		reg->alloc = 1;
 
 		/*
-		 * All events using extra_reg are unconstrained.
-		 * Avoids calling x86_get_event_constraints()
-		 *
-		 * Must revisit if extra_reg controlling events
-		 * ever have constraints. Worst case we go through
-		 * the regular event constraint table.
+		 * need to call x86_get_event_constraint()
+		 * to check if associated event has constraints
 		 */
-		c = &unconstrained;
+		c = NULL;
 	} else if (intel_try_alt_er(event, orig_idx)) {
 		raw_spin_unlock_irqrestore(&era->lock, flags);
 		goto again;
@@ -1200,11 +1196,23 @@ static struct event_constraint *
 intel_shared_regs_constraints(struct cpu_hw_events *cpuc,
 			      struct perf_event *event)
 {
-	struct event_constraint *c = NULL;
-
-	if (event->hw.extra_reg.idx != EXTRA_REG_NONE)
-		c = __intel_shared_reg_get_constraints(cpuc, event);
-
+	struct event_constraint *c = NULL, *d;
+	struct hw_perf_event_extra *xreg, *breg;
+
+	xreg = &event->hw.extra_reg;
+	if (xreg->idx != EXTRA_REG_NONE) {
+		c = __intel_shared_reg_get_constraints(cpuc, event, xreg);
+		if (c == &emptyconstraint)
+			return c;
+	}
+	breg = &event->hw.branch_reg;
+	if (breg->idx != EXTRA_REG_NONE) {
+		d = __intel_shared_reg_get_constraints(cpuc, event, breg);
+		if (d == &emptyconstraint) {
+			__intel_shared_reg_put_constraints(cpuc, xreg);
+			c = d;
+		}
+	}
 	return c;
 }
 
@@ -1252,6 +1260,10 @@ intel_put_shared_regs_event_constraints(struct cpu_hw_events *cpuc,
 	reg = &event->hw.extra_reg;
 	if (reg->idx != EXTRA_REG_NONE)
 		__intel_shared_reg_put_constraints(cpuc, reg);
+
+	reg = &event->hw.branch_reg;
+	if (reg->idx != EXTRA_REG_NONE)
+		__intel_shared_reg_put_constraints(cpuc, reg);
 }
 
 static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
@@ -1431,7 +1443,7 @@ static int intel_pmu_cpu_prepare(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
 
-	if (!x86_pmu.extra_regs)
+	if (!(x86_pmu.extra_regs || x86_pmu.lbr_sel_map))
 		return NOTIFY_OK;
 
 	cpuc->shared_regs = allocate_shared_regs(cpu);
@@ -1453,22 +1465,28 @@ static void intel_pmu_cpu_starting(int cpu)
 	 */
 	intel_pmu_lbr_reset();
 
-	if (!cpuc->shared_regs || (x86_pmu.er_flags & ERF_NO_HT_SHARING))
+	cpuc->lbr_sel = NULL;
+
+	if (!cpuc->shared_regs)
 		return;
 
-	for_each_cpu(i, topology_thread_cpumask(cpu)) {
-		struct intel_shared_regs *pc;
+	if (!(x86_pmu.er_flags & ERF_NO_HT_SHARING)) {
+		for_each_cpu(i, topology_thread_cpumask(cpu)) {
+			struct intel_shared_regs *pc;
 
-		pc = per_cpu(cpu_hw_events, i).shared_regs;
-		if (pc && pc->core_id == core_id) {
-			cpuc->kfree_on_online = cpuc->shared_regs;
-			cpuc->shared_regs = pc;
-			break;
+			pc = per_cpu(cpu_hw_events, i).shared_regs;
+			if (pc && pc->core_id == core_id) {
+				cpuc->kfree_on_online = cpuc->shared_regs;
+				cpuc->shared_regs = pc;
+				break;
+			}
 		}
+		cpuc->shared_regs->core_id = core_id;
+		cpuc->shared_regs->refcnt++;
 	}
 
-	cpuc->shared_regs->core_id = core_id;
-	cpuc->shared_regs->refcnt++;
+	if (x86_pmu.lbr_sel_map)
+		cpuc->lbr_sel = &cpuc->shared_regs->regs[EXTRA_REG_LBR];
 }
 
 static void intel_pmu_cpu_dying(int cpu)
-- 
1.7.4.1

