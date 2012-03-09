Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab2CINY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:24:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58684 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2CINY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:24:57 -0500
Date: Fri, 9 Mar 2012 05:24:23 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-60ce0fbd072695866cb27b729690ab59dce705a5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1328826068-11713-8-git-send-email-eranian@google.com>
References: <1328826068-11713-8-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf/x86:
  Implement PERF_SAMPLE_BRANCH for Intel CPUs
Git-Commit-ID: 60ce0fbd072695866cb27b729690ab59dce705a5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:24:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60ce0fbd072695866cb27b729690ab59dce705a5
Gitweb:     http://git.kernel.org/tip/60ce0fbd072695866cb27b729690ab59dce705a5
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 9 Feb 2012 23:20:57 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Mar 2012 14:55:41 +0100

perf/x86: Implement PERF_SAMPLE_BRANCH for Intel CPUs

This patch implements PERF_SAMPLE_BRANCH support for Intel
x86processors. It connects PERF_SAMPLE_BRANCH to the actual LBR.

The patch adds the hooks in the PMU irq handler to save the LBR
on counter overflow for both regular and PEBS modes.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328826068-11713-8-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.h           |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c     |   35 +++++++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |   10 +--
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   86 +++++++++++++++++++++++++++-
 4 files changed, 125 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 4e94897..ef7419c 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -541,6 +541,8 @@ void intel_pmu_lbr_init_atom(void);
 
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
@@ -1057,6 +1083,9 @@ again:
 
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
index d6bd49f..ee7e3c8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -439,9 +439,6 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
-
-	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
-		intel_pmu_lbr_enable(event);
 }
 
 void intel_pmu_pebs_disable(struct perf_event *event)
@@ -454,9 +451,6 @@ void intel_pmu_pebs_disable(struct perf_event *event)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
 
 	hwc->config |= ARCH_PERFMON_EVENTSEL_INT;
-
-	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
-		intel_pmu_lbr_disable(event);
 }
 
 void intel_pmu_pebs_enable_all(void)
@@ -572,6 +566,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	 * both formats and we don't use the other fields in this
 	 * routine.
 	 */
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct pebs_record_core *pebs = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
@@ -602,6 +597,9 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
+	if (has_branch_stack(event))
+		data.br_stack = &cpuc->lbr_stack;
+
 	if (perf_event_overflow(event, &data, &regs))
 		x86_pmu_stop(event, 0);
 }
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 07f0ff8..d0fb864 100644
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
@@ -119,7 +127,6 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 	 * Reset the LBR stack if we changed task context to
 	 * avoid data leaks.
 	 */
-
 	if (event->ctx->task && cpuc->lbr_context != event->ctx) {
 		intel_pmu_lbr_reset();
 		cpuc->lbr_context = event->ctx;
@@ -138,8 +145,11 @@ void intel_pmu_lbr_disable(struct perf_event *event)
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
@@ -158,6 +168,9 @@ void intel_pmu_lbr_disable_all(void)
 		__intel_pmu_lbr_disable();
 }
 
+/*
+ * TOS = most recently recorded branch
+ */
 static inline u64 intel_pmu_lbr_tos(void)
 {
 	u64 tos;
@@ -242,6 +255,75 @@ void intel_pmu_lbr_read(void)
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
+ * all the bits supported on some flavor of x86LBR
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
