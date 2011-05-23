Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1EWJMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:12:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43186 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1EWJML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:12:11 -0400
Subject: Re: [PATCH 0/3] perf_events: update extra shared registers
 management (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
        ming.m.lin@intel.com
In-Reply-To: <20110520143707.GA5347@quad>
References: <20110520143707.GA5347@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 May 2011 11:11:37 +0200
Message-ID: <1306141897.18455.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How about something like the below on top of your patches?

---
Subject: perf, intel: Try alternative OFFCORE encoding
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon May 23 11:08:15 CEST 2011

Since the OFFCORE registers are fully symmetric, try the other when the
speficied one is already taken.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c       |    5 ++-
 arch/x86/kernel/cpu/perf_event_intel.c |   45 ++++++++++++++++++++++++++-------
 2 files changed, 40 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -326,9 +326,12 @@ struct x86_pmu {
 	 * Extra registers for events
 	 */
 	struct extra_reg *extra_regs;
-	bool regs_no_ht_sharing;
+	unsigned int er_flags;
 };
 
+#define ERF_NO_HT_SHARING	1
+#define ERF_HAS_RSP_1		2
+
 static struct x86_pmu x86_pmu __read_mostly;
 
 static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1019,6 +1019,27 @@ intel_bts_constraints(struct perf_event
 	return NULL;
 }
 
+static bool intel_try_alt_er(struct perf_event *event, int idx)
+{
+	if (!(x86_pmu.er_flags & ERF_HAS_RSP_1))
+		return false;
+
+	if (event->hw.extra_reg.idx == EXTRA_REG_RSP_0) {
+		event->attr.config = 0x01bb;
+		event->hw.extra_reg.idx = EXTRA_REG_RSP_1;
+		event->hw.extra_reg.msr = MSR_OFFCORE_RSP_1;
+	} else if (event->hw.extra_reg.idx == EXTRA_REG_RSP_1) {
+		event->attr.config = 0x01b7;
+		event->hw.extra_reg.idx = EXTRA_REG_RSP_0;
+		event->hw.extra_reg.msr = MSR_OFFCORE_RSP_0;
+	}
+
+	if (event->hw.extra_reg.idx == idx)
+		return false;
+
+	return true;
+}
+
 /*
  * manage allocation of shared extra msr for certain events
  *
@@ -1028,19 +1049,21 @@ intel_bts_constraints(struct perf_event
  */
 static struct event_constraint *
 __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
-				   struct hw_perf_event_extra *reg)
+				   struct perf_event *event)
 {
 	struct event_constraint *c = &emptyconstraint;
+	struct hw_perf_event_extra *reg = &event->hw.extra_reg;
 	struct er_account *era;
+	int idx = reg->idx;
 
 	/* already allocated shared msr */
 	if (reg->alloc)
 		return &unconstrained;
 
+again:
 	era = &cpuc->shared_regs->regs[reg->idx];
 
 	raw_spin_lock(&era->lock);
-
 	if (!atomic_read(&era->ref) || era->config == reg->config) {
 
 		/* lock in msr value */
@@ -1062,6 +1085,9 @@ __intel_shared_reg_get_constraints(struc
 		 * the regular event constraint table.
 		 */
 		c = &unconstrained;
+	} else if (intel_try_alt_er(event, idx)) {
+		raw_spin_unlock(&era->lock);
+		goto again;
 	}
 	raw_spin_unlock(&era->lock);
 
@@ -1096,13 +1122,12 @@ intel_shared_regs_constraints(struct cpu
 			      struct perf_event *event)
 {
 	struct event_constraint *c = NULL;
-	struct hw_perf_event_extra *xreg;
 
-	xreg = &event->hw.extra_reg;
-	if (xreg->idx != EXTRA_REG_NONE)
-		c = __intel_shared_reg_get_constraints(cpuc, xreg);
+	if (event->hw.extra_reg.idx != EXTRA_REG_NONE)
+		c = __intel_shared_reg_get_contraints(cpuc, event);
+
 	return c;
- }
+}
 
 static struct event_constraint *
 intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
@@ -1261,7 +1286,7 @@ static void intel_pmu_cpu_starting(int c
 	 */
 	intel_pmu_lbr_reset();
 
-	if (!cpuc->shared_regs || x86_pmu.regs_no_ht_sharing)
+	if (!cpuc->shared_regs || (x86_pmu.er_flags & ERF_NO_HT_SHARING))
 		return;
 
 	for_each_cpu(i, topology_thread_cpumask(cpu)) {
@@ -1486,6 +1511,7 @@ static __init int intel_pmu_init(void)
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.pebs_constraints = intel_westmere_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_westmere_extra_regs;
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 
 		/* UOPS_ISSUED.STALLED_CYCLES */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
@@ -1505,7 +1531,8 @@ static __init int intel_pmu_init(void)
 		x86_pmu.pebs_constraints = intel_snb_pebs_events;
 		x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
-		x86_pmu.regs_no_ht_sharing = true;
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
 
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;

