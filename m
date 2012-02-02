Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab2BBMzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:55:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51147 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab2BBMzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:55:51 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: [PATCH v5 07/18] perf: implement PERF_SAMPLE_BRANCH for Intel X86
Date: Thu,  2 Feb 2012 13:54:37 +0100
Message-Id: <1328187288-24395-8-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1328187288-24395-1-git-send-email-eranian@google.com>
References: <1328187288-24395-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements PERF_SAMPLE_BRANCH support for Intel
X86 processors. It connects PERF_SAMPLE_BRANCH to the actual LBR.

The patch adds the hooks in the PMU irq handler to save the LBR
on counter overflow for both regular and PEBS modes.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.h           |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c     |   35 +++++++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |   10 +--
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   86 +++++++++++++++++++++++++++-
 4 files changed, 125 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 776fb5a..adbe80a 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -537,6 +537,8 @@ void intel_pmu_lbr_init_atom(void);
 
 void intel_pmu_lbr_init_snb(void);
 
+int intel_pmu_setup_lbr_filter(struct perf_event *event);
+
 int p4_pmu_init(void);
 
 int p6_pmu_init(void);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index b0db016..7cc1e2d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -727,6 +727,19 @@ static __initconst const u64 atom_hw_cache_event_ids
  },
 };
 
+static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
+{
+	/* user explicitly requested branch sampling */
+	if (has_branch_stack(event))
+		return true;
+
+	/* implicit branch sampling to correct PEBS skid */
+	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
+		return true;
+
+	return false;
+}
+
 static void intel_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -881,6 +894,13 @@ static void intel_pmu_disable_event(struct perf_event *event)
 	cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
 
+	/*
+	 * must disable before any actual event
+	 * because any event may be combined with LBR
+	 */
+	if (intel_pmu_needs_lbr_smpl(event))
+		intel_pmu_lbr_disable(event);
+
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
 		intel_pmu_disable_fixed(hwc);
 		return;
@@ -935,6 +955,12 @@ static void intel_pmu_enable_event(struct perf_event *event)
 		intel_pmu_enable_bts(hwc->config);
 		return;
 	}
+	/*
+	 * must enabled before any actual event
+	 * because any event may be combined with LBR
+	 */
+	if (intel_pmu_needs_lbr_smpl(event))
+		intel_pmu_lbr_enable(event);
 
 	if (event->attr.exclude_host)
 		cpuc->intel_ctrl_guest_mask |= (1ull << hwc->idx);
@@ -1057,6 +1083,9 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 
 		data.period = event->hw.last_period;
 
+		if (has_branch_stack(event))
+			data.br_stack = &cpuc->lbr_stack;
+
 		if (perf_event_overflow(event, &data, regs))
 			x86_pmu_stop(event, 0);
 	}
@@ -1305,6 +1334,12 @@ static int intel_pmu_hw_config(struct perf_event *event)
 		event->hw.config = alt_config;
 	}
 
+	if (intel_pmu_needs_lbr_smpl(event)) {
+		ret = intel_pmu_setup_lbr_filter(event);
+		if (ret)
+			return ret;
+	}
+
 	if (event->attr.type != PERF_TYPE_RAW)
 		return 0;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 73da6b6..04c71ea 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -440,9 +440,6 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
 	WARN_ON_ONCE(cpuc->enabled);
-
-	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
-		intel_pmu_lbr_enable(event);
 }
 
 void intel_pmu_pebs_disable(struct perf_event *event)
@@ -455,9 +452,6 @@ void intel_pmu_pebs_disable(struct perf_event *event)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
 
 	hwc->config |= ARCH_PERFMON_EVENTSEL_INT;
-
-	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
-		intel_pmu_lbr_disable(event);
 }
 
 void intel_pmu_pebs_enable_all(void)
@@ -573,6 +567,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	 * both formats and we don't use the other fields in this
 	 * routine.
 	 */
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct pebs_record_core *pebs = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
@@ -603,6 +598,9 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
+	if (has_branch_stack(event))
+		data.br_stack = &cpuc->lbr_stack;
+
 	if (perf_event_overflow(event, &data, &regs))
 		x86_pmu_stop(event, 0);
 }
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 5cf86b4..94ad84d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -56,6 +56,10 @@ enum {
 
 #define LBR_FROM_FLAG_MISPRED  (1ULL << 63)
 
+#define for_each_branch_sample_type(x) \
+	for ((x) = PERF_SAMPLE_BRANCH_USER; \
+	     (x) < PERF_SAMPLE_BRANCH_MAX; (x) <<= 1)
+
 /*
  * We only support LBR implementations that have FREEZE_LBRS_ON_PMI
  * otherwise it becomes near impossible to get a reliable stack.
@@ -64,6 +68,10 @@ enum {
 static void __intel_pmu_lbr_enable(void)
 {
 	u64 debugctl;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (cpuc->lbr_sel)
+		wrmsrl(MSR_LBR_SELECT, cpuc->lbr_sel->config);
 
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
 	debugctl |= (DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
@@ -121,7 +129,6 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 	 * Reset the LBR stack if we changed task context to
 	 * avoid data leaks.
 	 */
-
 	if (event->ctx->task && cpuc->lbr_context != event->ctx) {
 		intel_pmu_lbr_reset();
 		cpuc->lbr_context = event->ctx;
@@ -140,8 +147,11 @@ void intel_pmu_lbr_disable(struct perf_event *event)
 	cpuc->lbr_users--;
 	WARN_ON_ONCE(cpuc->lbr_users < 0);
 
-	if (cpuc->enabled && !cpuc->lbr_users)
+	if (cpuc->enabled && !cpuc->lbr_users) {
 		__intel_pmu_lbr_disable();
+		/* avoid stale pointer */
+		cpuc->lbr_context = NULL;
+	}
 }
 
 void intel_pmu_lbr_enable_all(void)
@@ -160,6 +170,9 @@ void intel_pmu_lbr_disable_all(void)
 		__intel_pmu_lbr_disable();
 }
 
+/*
+ * TOS = most recently recorded branch
+ */
 static inline u64 intel_pmu_lbr_tos(void)
 {
 	u64 tos;
@@ -244,6 +257,75 @@ void intel_pmu_lbr_read(void)
 }
 
 /*
+ * setup the HW LBR filter
+ * Used only when available, may not be enough to disambiguate
+ * all branches, may need the help of the SW filter
+ */
+static int intel_pmu_setup_hw_lbr_filter(struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg;
+	u64 br_type = event->attr.branch_sample_type;
+	u64 mask = 0, m;
+	u64 v;
+
+	for_each_branch_sample_type(m) {
+		if (!(br_type & m))
+			continue;
+
+		v = x86_pmu.lbr_sel_map[m];
+		if (v == LBR_NOT_SUPP)
+			return -EOPNOTSUPP;
+		mask |= v;
+
+		if (m == PERF_SAMPLE_BRANCH_ANY)
+			break;
+	}
+	reg = &event->hw.branch_reg;
+	reg->idx = EXTRA_REG_LBR;
+
+	/* LBR_SELECT operates in suppress mode so invert mask */
+	reg->config = ~mask & x86_pmu.lbr_sel_mask;
+
+	return 0;
+}
+
+/*
+ * all the bits supported on some flavor of X86 LBR
+ * we ignore BRANCH_HV because it is not supported
+ */
+#define PERF_SAMPLE_BRANCH_X86_ALL	\
+	(PERF_SAMPLE_BRANCH_ANY		|\
+	 PERF_SAMPLE_BRANCH_USER	|\
+	 PERF_SAMPLE_BRANCH_KERNEL)
+
+int intel_pmu_setup_lbr_filter(struct perf_event *event)
+{
+	u64 br_type = event->attr.branch_sample_type;
+
+	/*
+	 * no LBR on this PMU
+	 */
+	if (!x86_pmu.lbr_nr)
+		return -EOPNOTSUPP;
+
+	/*
+	 * if no LBR HW filter, users can only
+	 * capture all branches
+	 */
+	if (!x86_pmu.lbr_sel_map) {
+		if (br_type != PERF_SAMPLE_BRANCH_X86_ALL)
+			return -EOPNOTSUPP;
+		return 0;
+	}
+	/*
+	 * we ignore branch priv levels we do not
+	 * know about: BRANCH_HV
+	 */
+
+	return intel_pmu_setup_hw_lbr_filter(event);
+}
+
+/*
  * Map interface branch filters onto LBR filters
  */
 static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
-- 
1.7.4.1

