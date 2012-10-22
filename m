Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab2JVF50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 01:57:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:39696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab2JVF5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 01:57:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,628,1344236400"; 
   d="scan'208";a="230478471"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.n
Cc: eranian@google.com, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 1/6] perf, x86: Basic Haswell LBR call stack support
Date: Mon, 22 Oct 2012 13:57:11 +0800
Message-Id: <1350885436-5540-2-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1350885436-5540-1-git-send-email-zheng.z.yan@intel.com>
References: <1350885436-5540-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

The new HSW call stack feature provides a facility such that
unfiltered call data will be collected as normal, but as return
instructions are executed the last captured branch record is
popped from the LBR stack. Thus, branch information relative to
leaf functions will not be captured, while preserving the call
stack information of the main line execution path.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.h           |  2 +
 arch/x86/kernel/cpu/perf_event_intel.c     |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 91 ++++++++++++++++++++++--------
 include/uapi/linux/perf_event.h            |  3 +-
 4 files changed, 74 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index d3b3bb7..370df32 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -631,6 +631,8 @@ void intel_pmu_lbr_init_atom(void);
 
 void intel_pmu_lbr_init_snb(void);
 
+void intel_pmu_lbr_init_hsw(void);
+
 int intel_pmu_setup_lbr_filter(struct perf_event *event);
 
 int p4_pmu_init(void);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a734b6a..3e59612 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2349,7 +2349,7 @@ __init int intel_pmu_init(void)
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
-		intel_pmu_lbr_init_nhm();
+		intel_pmu_lbr_init_hsw();
 
 		x86_pmu.event_constraints = intel_hsw_event_constraints;
 		x86_pmu.pebs_constraints = intel_hsw_pebs_event_constraints;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 31fe046..99f64fe 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -31,6 +31,7 @@ enum {
 #define LBR_IND_JMP_BIT		6 /* do not capture indirect jumps */
 #define LBR_REL_JMP_BIT		7 /* do not capture relative jumps */
 #define LBR_FAR_BIT		8 /* do not capture far branches */
+#define LBR_CALL_STACK_BIT	9 /* enable call stack */
 
 #define LBR_KERNEL	(1 << LBR_KERNEL_BIT)
 #define LBR_USER	(1 << LBR_USER_BIT)
@@ -41,6 +42,7 @@ enum {
 #define LBR_REL_JMP	(1 << LBR_REL_JMP_BIT)
 #define LBR_IND_JMP	(1 << LBR_IND_JMP_BIT)
 #define LBR_FAR		(1 << LBR_FAR_BIT)
+#define LBR_CALL_STACK	(1 << LBR_CALL_STACK_BIT)
 
 #define LBR_PLM (LBR_KERNEL | LBR_USER)
 
@@ -70,24 +72,25 @@ enum {
  * x86control flow changes include branches, interrupts, traps, faults
  */
 enum {
-	X86_BR_NONE     = 0,      /* unknown */
-
-	X86_BR_USER     = 1 << 0, /* branch target is user */
-	X86_BR_KERNEL   = 1 << 1, /* branch target is kernel */
-
-	X86_BR_CALL     = 1 << 2, /* call */
-	X86_BR_RET      = 1 << 3, /* return */
-	X86_BR_SYSCALL  = 1 << 4, /* syscall */
-	X86_BR_SYSRET   = 1 << 5, /* syscall return */
-	X86_BR_INT      = 1 << 6, /* sw interrupt */
-	X86_BR_IRET     = 1 << 7, /* return from interrupt */
-	X86_BR_JCC      = 1 << 8, /* conditional */
-	X86_BR_JMP      = 1 << 9, /* jump */
-	X86_BR_IRQ      = 1 << 10,/* hw interrupt or trap or fault */
-	X86_BR_IND_CALL = 1 << 11,/* indirect calls */
-	X86_BR_ABORT    = 1 << 12,/* transaction abort */
-	X86_BR_INTX     = 1 << 13,/* in transaction */
-	X86_BR_NOTX     = 1 << 14,/* not in transaction */
+	X86_BR_NONE		= 0,      /* unknown */
+
+	X86_BR_USER		= 1 << 0, /* branch target is user */
+	X86_BR_KERNEL		= 1 << 1, /* branch target is kernel */
+
+	X86_BR_CALL		= 1 << 2, /* call */
+	X86_BR_RET		= 1 << 3, /* return */
+	X86_BR_SYSCALL		= 1 << 4, /* syscall */
+	X86_BR_SYSRET		= 1 << 5, /* syscall return */
+	X86_BR_INT		= 1 << 6, /* sw interrupt */
+	X86_BR_IRET		= 1 << 7, /* return from interrupt */
+	X86_BR_JCC		= 1 << 8, /* conditional */
+	X86_BR_JMP		= 1 << 9, /* jump */
+	X86_BR_IRQ		= 1 << 10,/* hw interrupt or trap or fault */
+	X86_BR_IND_CALL		= 1 << 11,/* indirect calls */
+	X86_BR_ABORT		= 1 << 12,/* transaction abort */
+	X86_BR_INTX		= 1 << 13,/* in transaction */
+	X86_BR_NOTX		= 1 << 14,/* not in transaction */
+	X86_BR_CALL_STACK	= 1 << 15,/* call stack */
 };
 
 #define X86_BR_PLM (X86_BR_USER | X86_BR_KERNEL)
@@ -131,7 +134,10 @@ static void __intel_pmu_lbr_enable(void)
 		wrmsrl(MSR_LBR_SELECT, cpuc->lbr_sel->config);
 
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
-	debugctl |= (DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
+	debugctl |= DEBUGCTLMSR_LBR;
+	/* LBR callstack does not work well with FREEZE_LBRS_ON_PMI */
+	if (!cpuc->lbr_sel || !(cpuc->lbr_sel->config & LBR_CALL_STACK))
+		debugctl |= DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
 }
 
@@ -328,7 +334,7 @@ void intel_pmu_lbr_read(void)
  * - in case there is no HW filter
  * - in case the HW filter has errata or limitations
  */
-static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
+static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 {
 	u64 br_type = event->attr.branch_sample_type;
 	int mask = 0;
@@ -362,11 +368,21 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	if (br_type & PERF_SAMPLE_BRANCH_NOTX)
 		mask |= X86_BR_NOTX;
 
+	if (br_type & PERF_SAMPLE_BRANCH_CALL_STACK) {
+		if (!x86_pmu.lbr_sel_map)
+			return -EOPNOTSUPP;
+		if (mask & ~(X86_BR_USER | X86_BR_KERNEL))
+			return -EINVAL;
+		mask |= X86_BR_CALL | X86_BR_IND_CALL | X86_BR_RET |
+			X86_BR_CALL_STACK;
+	}
+
 	/*
 	 * stash actual user request into reg, it may
 	 * be used by fixup code for some CPU
 	 */
 	event->hw.branch_reg.reg = mask;
+	return 0;
 }
 
 /*
@@ -396,7 +412,7 @@ static int intel_pmu_setup_hw_lbr_filter(struct perf_event *event)
 	reg->idx = EXTRA_REG_LBR;
 
 	/* LBR_SELECT operates in suppress mode so invert mask */
-	reg->config = ~mask & x86_pmu.lbr_sel_mask;
+	reg->config = mask ^ x86_pmu.lbr_sel_mask;
 
 	return 0;
 }
@@ -415,7 +431,9 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
 	/*
 	 * setup SW LBR filter
 	 */
-	intel_pmu_setup_sw_lbr_filter(event);
+	ret = intel_pmu_setup_sw_lbr_filter(event);
+	if (ret)
+		return ret;
 
 	/*
 	 * setup HW LBR filter, if any
@@ -647,6 +665,7 @@ static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
 	 * NHM/WSM erratum: must include IND_JMP to capture IND_CALL
 	 */
 	[PERF_SAMPLE_BRANCH_IND_CALL] = LBR_IND_CALL | LBR_IND_JMP,
+	[PERF_SAMPLE_BRANCH_CALL_STACK] = LBR_NOT_SUPP,
 };
 
 static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
@@ -658,6 +677,20 @@ static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
 	[PERF_SAMPLE_BRANCH_ANY_CALL]	= LBR_REL_CALL | LBR_IND_CALL
 					| LBR_FAR,
 	[PERF_SAMPLE_BRANCH_IND_CALL]	= LBR_IND_CALL,
+	[PERF_SAMPLE_BRANCH_CALL_STACK] = LBR_NOT_SUPP,
+};
+
+static const int hsw_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
+	[PERF_SAMPLE_BRANCH_ANY]	= LBR_ANY,
+	[PERF_SAMPLE_BRANCH_USER]	= LBR_USER,
+	[PERF_SAMPLE_BRANCH_KERNEL]	= LBR_KERNEL,
+	[PERF_SAMPLE_BRANCH_HV]		= LBR_IGN,
+	[PERF_SAMPLE_BRANCH_ANY_RETURN]	= LBR_RETURN | LBR_FAR,
+	[PERF_SAMPLE_BRANCH_ANY_CALL]	= LBR_REL_CALL | LBR_IND_CALL
+					| LBR_FAR,
+	[PERF_SAMPLE_BRANCH_IND_CALL]	= LBR_IND_CALL,
+	[PERF_SAMPLE_BRANCH_CALL_STACK] = LBR_REL_CALL | LBR_IND_CALL
+					| LBR_RETURN | LBR_CALL_STACK,
 };
 
 /* core */
@@ -716,6 +749,20 @@ void intel_pmu_lbr_init_snb(void)
 	pr_cont("16-deep LBR, ");
 }
 
+/* haswell */
+void intel_pmu_lbr_init_hsw(void)
+{
+	x86_pmu.lbr_nr	 = 16;
+	x86_pmu.lbr_tos	 = MSR_LBR_TOS;
+	x86_pmu.lbr_from = MSR_LBR_NHM_FROM;
+	x86_pmu.lbr_to   = MSR_LBR_NHM_TO;
+
+	x86_pmu.lbr_sel_mask = LBR_SEL_MASK;
+	x86_pmu.lbr_sel_map  = hsw_lbr_sel_map;
+
+	pr_cont("16-deep LBR, ");
+}
+
 /* atom */
 void intel_pmu_lbr_init_atom(void)
 {
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index d1ffdb6..af0a6e6 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -160,8 +160,9 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_ABORT	= 1U << 7, /* transaction aborts */
 	PERF_SAMPLE_BRANCH_INTX		= 1U << 8, /* in transaction (flag) */
 	PERF_SAMPLE_BRANCH_NOTX		= 1U << 9, /* not in transaction (flag) */
+	PERF_SAMPLE_BRANCH_CALL_STACK	= 1U << 10, /* call stack */
 
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 10, /* non-ABI */
+	PERF_SAMPLE_BRANCH_MAX		= 1U << 11, /* non-ABI */
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
-- 
1.7.11.7

