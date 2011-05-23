Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab1EWPNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:13:39 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab1EWPNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=V0smOtp9lZZYYjlhLNl5rw8htXcG7ELC0hT2cXG8W7k4UfUQUdYM/KlV1Yxlb9uSAV
         BikayGycLEvRySa6b1+A==
Date: Mon, 23 May 2011 17:13:30 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, andi@firstfloor.org,
        ming.m.lin@intel.com
Subject: Re: [PATCH 0/3] perf_events: update extra shared registers
 management
Message-ID: <20110523151330.GA11181@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

The following revised patch seems to work for me on top of my
series (well, the modified one with irqsave):

$ syst_count -c 0 -p  -e offcore_response_0:dmnd_data_rd:k,\
		    offcore_response_0:dmnd_rfo:u,\
		    offcore_response_0:dmnd_rfo:k,\
		    offcore_response_0:dmnd_data_rd:u

CPU0   G0  478  offcore_response_0:dmnd_data_rd:k (scaling 0.00%, ena=997285681, run=997285681) 
CPU0   G0  163  offcore_response_0:dmnd_rfo (scaling 0.00%, ena=997285681, run=997285681) 
CPU0   G0  163  offcore_response_0:dmnd_rfo (scaling 0.00%, ena=997285681, run=997285681) 
CPU0   G0  0    offcore_response_0:dmnd_data_rd:u (scaling 0.00%, ena=997285681, run=997285681) 

Subject: perf, intel: Try alternative OFFCORE encoding
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon May 23 11:08:15 CEST 2011

Since the OFFCORE registers are fully symmetric, try the other when the
speficied one is already taken.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index d6ad9c2..59e7004 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
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
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 9904205..9d1dd2b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1019,6 +1019,35 @@ intel_bts_constraints(struct perf_event *event)
 	return NULL;
 }
 
+static bool intel_try_alt_er(struct perf_event *event, int idx)
+{
+	if (!(x86_pmu.er_flags & ERF_HAS_RSP_1))
+		return false;
+
+	/*
+	 * there are at most 2 offcore_response registers
+	 * if we come here for the secodn time, then it
+	 * means we have exhausted all possible alternatives
+	 */
+	if (event->hw.extra_reg.alt_cnt == 1)
+		return false;
+
+	if (event->hw.extra_reg.idx == EXTRA_REG_RSP_0) {
+		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
+		event->hw.config |= 0x01bb;
+		event->hw.extra_reg.idx = EXTRA_REG_RSP_1;
+		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
+	} else if (event->hw.extra_reg.idx == EXTRA_REG_RSP_1) {
+		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
+		event->hw.config |= 0x01b7;
+		event->hw.extra_reg.idx = EXTRA_REG_RSP_0;
+		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_0;
+	}
+	event->hw.extra_reg.alt_cnt++;
+
+	return true;
+}
+
 /*
  * manage allocation of shared extra msr for certain events
  *
@@ -1028,9 +1057,10 @@ intel_bts_constraints(struct perf_event *event)
  */
 static struct event_constraint *
 __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
-				   struct hw_perf_event_extra *reg)
+				   struct perf_event *event)
 {
 	struct event_constraint *c = &emptyconstraint;
+	struct hw_perf_event_extra *reg = &event->hw.extra_reg;
 	struct er_account *era;
 	unsigned long flags;
 
@@ -1038,6 +1068,9 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
 	if (reg->alloc)
 		return &unconstrained;
 
+	/* reset alternate indexes tried */
+	reg->alt_cnt = 0;
+again:
 	era = &cpuc->shared_regs->regs[reg->idx];
 	/*
 	 * we use spin_lock_irqsave() to avoid lockdep issues when
@@ -1066,6 +1099,9 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
 		 * the regular event constraint table.
 		 */
 		c = &unconstrained;
+	} else if (intel_try_alt_er(event, reg->idx)) {
+		raw_spin_unlock_irqrestore(&era->lock, flags);
+		goto again;
 	}
 	raw_spin_unlock_irqrestore(&era->lock, flags);
 
@@ -1100,11 +1136,9 @@ intel_shared_regs_constraints(struct cpu_hw_events *cpuc,
 			      struct perf_event *event)
 {
 	struct event_constraint *c = NULL;
-	struct hw_perf_event_extra *xreg;
 
-	xreg = &event->hw.extra_reg;
-	if (xreg->idx != EXTRA_REG_NONE)
-		c = __intel_shared_reg_get_constraints(cpuc, xreg);
+	if (event->hw.extra_reg.idx != EXTRA_REG_NONE)
+		c = __intel_shared_reg_get_constraints(cpuc, event);
 	return c;
  }
 
@@ -1265,7 +1299,7 @@ static void intel_pmu_cpu_starting(int cpu)
 	 */
 	intel_pmu_lbr_reset();
 
-	if (!cpuc->shared_regs || x86_pmu.regs_no_ht_sharing)
+	if (!cpuc->shared_regs || (x86_pmu.er_flags & ERF_NO_HT_SHARING))
 		return;
 
 	for_each_cpu(i, topology_thread_cpumask(cpu)) {
@@ -1490,6 +1524,7 @@ static __init int intel_pmu_init(void)
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.pebs_constraints = intel_westmere_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_westmere_extra_regs;
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 
 		/* UOPS_ISSUED.STALLED_CYCLES */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
@@ -1509,7 +1544,8 @@ static __init int intel_pmu_init(void)
 		x86_pmu.pebs_constraints = intel_snb_pebs_events;
 		x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
-		x86_pmu.regs_no_ht_sharing = true;
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
 
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 941f40d..1671cd8 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -544,6 +544,7 @@ struct hw_perf_event_extra {
 	unsigned int	reg;	/* register address or index */
 	int		alloc;	/* extra register already allocated */
 	int		idx;	/* index in shared_regs->regs[] */
+	int		alt_cnt;/* number of alternate indexes tried */
 };
 
 /**
