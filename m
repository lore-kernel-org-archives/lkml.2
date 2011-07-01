Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab1GAPXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:23:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:57619 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab1GAPXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:23:44 -0400
Date: Fri, 1 Jul 2011 15:23:32 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-b79e8941fb9af07d810da91b4e29da2bba331b6e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1306141897.18455.8.camel@twins>
References: <1306141897.18455.8.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, intel: Try alternative OFFCORE encodings
Git-Commit-ID: b79e8941fb9af07d810da91b4e29da2bba331b6e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:23:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b79e8941fb9af07d810da91b4e29da2bba331b6e
Gitweb:     http://git.kernel.org/tip/b79e8941fb9af07d810da91b4e29da2bba331b6e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 23 May 2011 11:08:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:06:37 +0200

perf, intel: Try alternative OFFCORE encodings

Since the OFFCORE registers are fully symmetric, try the other one
when the specified one is already in use.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1306141897.18455.8.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |    5 +++-
 arch/x86/kernel/cpu/perf_event_intel.c |   44 ++++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 583f311..c53d433 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -327,9 +327,12 @@ struct x86_pmu {
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
index a674ae4..5c44862 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1018,6 +1018,29 @@ intel_bts_constraints(struct perf_event *event)
 	return NULL;
 }
 
+static bool intel_try_alt_er(struct perf_event *event, int orig_idx)
+{
+	if (!(x86_pmu.er_flags & ERF_HAS_RSP_1))
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
+
+	if (event->hw.extra_reg.idx == orig_idx)
+		return false;
+
+	return true;
+}
+
 /*
  * manage allocation of shared extra msr for certain events
  *
@@ -1027,16 +1050,19 @@ intel_bts_constraints(struct perf_event *event)
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
+	int orig_idx = reg->idx;
 
 	/* already allocated shared msr */
 	if (reg->alloc)
 		return &unconstrained;
 
+again:
 	era = &cpuc->shared_regs->regs[reg->idx];
 	/*
 	 * we use spin_lock_irqsave() to avoid lockdep issues when
@@ -1065,6 +1091,9 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
 		 * the regular event constraint table.
 		 */
 		c = &unconstrained;
+	} else if (intel_try_alt_er(event, orig_idx)) {
+		raw_spin_unlock(&era->lock);
+		goto again;
 	}
 	raw_spin_unlock_irqrestore(&era->lock, flags);
 
@@ -1099,11 +1128,10 @@ intel_shared_regs_constraints(struct cpu_hw_events *cpuc,
 			      struct perf_event *event)
 {
 	struct event_constraint *c = NULL;
-	struct hw_perf_event_extra *xreg;
 
-	xreg = &event->hw.extra_reg;
-	if (xreg->idx != EXTRA_REG_NONE)
-		c = __intel_shared_reg_get_constraints(cpuc, xreg);
+	if (event->hw.extra_reg.idx != EXTRA_REG_NONE)
+		c = __intel_shared_reg_get_constraints(cpuc, event);
+
 	return c;
 }
 
@@ -1264,7 +1292,7 @@ static void intel_pmu_cpu_starting(int cpu)
 	 */
 	intel_pmu_lbr_reset();
 
-	if (!cpuc->shared_regs || x86_pmu.regs_no_ht_sharing)
+	if (!cpuc->shared_regs || (x86_pmu.er_flags & ERF_NO_HT_SHARING))
 		return;
 
 	for_each_cpu(i, topology_thread_cpumask(cpu)) {
@@ -1489,6 +1517,7 @@ static __init int intel_pmu_init(void)
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.pebs_constraints = intel_westmere_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_westmere_extra_regs;
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 
 		/* UOPS_ISSUED.STALLED_CYCLES */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
@@ -1508,7 +1537,8 @@ static __init int intel_pmu_init(void)
 		x86_pmu.pebs_constraints = intel_snb_pebs_events;
 		x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
-		x86_pmu.regs_no_ht_sharing = true;
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
 
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
