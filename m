Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934596Ab1JEMCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:02:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934513Ab1JEMBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:01:52 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, kvm@vger.kernel.org, joerg.roedel@amd.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl
Subject: [PATCH v2 6/9] perf, intel: Use GO/HO bits in perf-ctr
Date: Wed,  5 Oct 2011 14:01:21 +0200
Message-Id: <1317816084-18026-7-git-send-email-gleb@redhat.com>
In-Reply-To: <1317816084-18026-1-git-send-email-gleb@redhat.com>
References: <1317816084-18026-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel does not have guest/host-only bit in perf counters like AMD
does.  To support GO/HO bits KVM needs to switch EVENTSELn values
(or PERF_GLOBAL_CTRL if available) at a guest entry. If a counter is
configured to count only in a guest mode it stays disabled in a host,
but VMX is configured to switch it to enabled value during guest entry.

This patch adds GO/HO tracking to Intel perf code and provides interface
for KVM to get a list of MSRs that need to be switched on a guest entry.

Only cpus with architectural PMU (v1 or later) are supported with this
patch.  To my knowledge there is not p6 models with VMX but without
architectural PMU and p4 with VMX are rare and the interface is general
enough to support them if need arise.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/include/asm/perf_event.h      |   12 ++++
 arch/x86/kernel/cpu/perf_event.c       |   14 +++++
 arch/x86/kernel/cpu/perf_event_intel.c |   90 ++++++++++++++++++++++++++++++-
 3 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index ce2bfb3..e47cb61 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -162,7 +162,19 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
 	);							\
 }
 
+struct perf_guest_switch_msr {
+	unsigned msr;
+	u64 host, guest;
+};
+
+extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
 #else
+static inline perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
+{
+	*nr = 0;
+	return NULL;
+}
+
 static inline void perf_events_lapic_init(void)	{ }
 #endif
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index cfa62ec..531f5c6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -119,6 +119,10 @@ struct cpu_hw_events {
 	struct perf_branch_stack	lbr_stack;
 	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
 
+	/* Intel host/guest exclude bits */
+	u64			intel_ctrl_guest_mask;
+	u64			intel_ctrl_host_mask;
+
 	/*
 	 * manage shared (per-core, per-cpu) registers
 	 * used on Intel NHM/WSM/SNB
@@ -129,6 +133,11 @@ struct cpu_hw_events {
 	 * AMD specific bits
 	 */
 	struct amd_nb		*amd_nb;
+
+	/*
+	 * Intel guest/host-only support
+	 */
+	struct perf_guest_switch_msr guest_switch_msrs[X86_PMC_IDX_MAX];
 };
 
 #define __EVENT_CONSTRAINT(c, n, m, w) {\
@@ -292,6 +301,11 @@ struct x86_pmu {
 	 */
 	struct extra_reg *extra_regs;
 	unsigned int er_flags;
+
+	/*
+	 * Guest event support
+	 */
+	struct perf_guest_switch_msr* (*guest_get_msrs)(int *nr);
 };
 
 #define ERF_NO_HT_SHARING	1
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f88af2c..e35b916 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -746,7 +746,8 @@ static void intel_pmu_enable_all(int added)
 
 	intel_pmu_pebs_enable_all();
 	intel_pmu_lbr_enable_all();
-	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL,
+			x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask);
 
 	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
 		struct perf_event *event =
@@ -869,6 +870,7 @@ static void intel_pmu_disable_fixed(struct hw_perf_event *hwc)
 static void intel_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
 		intel_pmu_disable_bts();
@@ -876,6 +878,9 @@ static void intel_pmu_disable_event(struct perf_event *event)
 		return;
 	}
 
+	cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
+	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
+
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
 		intel_pmu_disable_fixed(hwc);
 		return;
@@ -921,6 +926,7 @@ static void intel_pmu_enable_fixed(struct hw_perf_event *hwc)
 static void intel_pmu_enable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
 		if (!__this_cpu_read(cpu_hw_events.enabled))
@@ -930,6 +936,11 @@ static void intel_pmu_enable_event(struct perf_event *event)
 		return;
 	}
 
+	if (event->attr.exclude_host)
+		cpuc->intel_ctrl_guest_mask |= (1ull << hwc->idx);
+	if (event->attr.exclude_guest)
+		cpuc->intel_ctrl_host_mask |= (1ull << hwc->idx);
+
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
 		intel_pmu_enable_fixed(hwc);
 		return;
@@ -1284,12 +1295,75 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
+static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
+
+	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
+	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
+	arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
+
+	*nr = 1;
+	return arr;
+}
+
+static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
+	int idx;
+
+	for (idx = 0; idx < x86_pmu.num_counters; idx++)  {
+		struct perf_event *event = cpuc->events[idx];
+
+		arr[idx].msr = x86_pmu_config_addr(idx);
+		arr[idx].host = arr[idx].guest = 0;
+
+		if (!test_bit(idx, cpuc->active_mask))
+			continue;
+
+		arr[idx].host = arr[idx].guest =
+			event->hw.config | ARCH_PERFMON_EVENTSEL_ENABLE;
+
+		if (event->attr.exclude_host)
+			arr[idx].host &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+		else if (event->attr.exclude_guest)
+			arr[idx].guest &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+	}
+
+	*nr = x86_pmu.num_counters;
+	return arr;
+}
+
+static void core_pmu_enable_event(struct perf_event *event)
+{
+	if (!event->attr.exclude_host)
+		x86_pmu_enable_event(event);
+}
+
+static void core_pmu_enable_all(int added)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx;
+
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		struct hw_perf_event *hwc = &cpuc->events[idx]->hw;
+
+		if (!test_bit(idx, cpuc->active_mask) ||
+				cpuc->events[idx]->attr.exclude_host)
+			continue;
+
+		__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
+	}
+}
+
 static __initconst const struct x86_pmu core_pmu = {
 	.name			= "core",
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= x86_pmu_disable_all,
-	.enable_all		= x86_pmu_enable_all,
-	.enable			= x86_pmu_enable_event,
+	.enable_all		= core_pmu_enable_all,
+	.enable			= core_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
 	.hw_config		= x86_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
@@ -1307,6 +1381,7 @@ static __initconst const struct x86_pmu core_pmu = {
 	.get_event_constraints	= intel_get_event_constraints,
 	.put_event_constraints	= intel_put_event_constraints,
 	.event_constraints	= intel_core_event_constraints,
+	.guest_get_msrs		= core_guest_get_msrs,
 };
 
 static struct intel_shared_regs *allocate_shared_regs(int cpu)
@@ -1413,6 +1488,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.cpu_prepare		= intel_pmu_cpu_prepare,
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
+	.guest_get_msrs		= intel_guest_get_msrs,
 };
 
 static void intel_clovertown_quirks(void)
@@ -1629,6 +1705,14 @@ static __init int intel_pmu_init(void)
 	return 0;
 }
 
+struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
+{
+	if (x86_pmu.guest_get_msrs)
+		return x86_pmu.guest_get_msrs(nr);
+	*nr = 0;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
 #else /* CONFIG_CPU_SUP_INTEL */
 
 static int intel_pmu_init(void)
-- 
1.7.5.3

