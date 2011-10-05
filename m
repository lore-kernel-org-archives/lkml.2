Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532Ab1JEOTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:19:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58322 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab1JEOTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:19:01 -0400
Subject: Re: [PATCH v2 6/9] perf, intel: Use GO/HO bits in perf-ctr
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
        joerg.roedel@amd.com, mingo@elte.hu
Date: Wed, 05 Oct 2011 16:18:48 +0200
In-Reply-To: <1317816084-18026-7-git-send-email-gleb@redhat.com>
References: <1317816084-18026-1-git-send-email-gleb@redhat.com>
	 <1317816084-18026-7-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317824328.6766.29.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Had some serious conflicts with tip/master, queued the below merge.

---
Subject: perf, intel: Use GO/HO bits in perf-ctr
From: Gleb Natapov <gleb@redhat.com>
Date: Wed, 5 Oct 2011 14:01:21 +0200

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1317816084-18026-7-git-send-email-gleb@redhat.com
---
 arch/x86/include/asm/perf_event.h      |   12 ++++
 arch/x86/kernel/cpu/perf_event.h       |   12 ++++
 arch/x86/kernel/cpu/perf_event_intel.c |   91 +++++++++++++++++++++++++++++++--
 3 files changed, 112 insertions(+), 3 deletions(-)
Index: linux-2.6/arch/x86/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/perf_event.h
+++ linux-2.6/arch/x86/include/asm/perf_event.h
@@ -162,7 +162,19 @@ extern unsigned long perf_misc_flags(str
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
 
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -749,7 +749,8 @@ static void intel_pmu_enable_all(int add
 
 	intel_pmu_pebs_enable_all();
 	intel_pmu_lbr_enable_all();
-	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL,
+			x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask);
 
 	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
 		struct perf_event *event =
@@ -872,6 +873,7 @@ static void intel_pmu_disable_fixed(stru
 static void intel_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
 		intel_pmu_disable_bts();
@@ -879,6 +881,9 @@ static void intel_pmu_disable_event(stru
 		return;
 	}
 
+	cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
+	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
+
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
 		intel_pmu_disable_fixed(hwc);
 		return;
@@ -924,6 +929,7 @@ static void intel_pmu_enable_fixed(struc
 static void intel_pmu_enable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
 		if (!__this_cpu_read(cpu_hw_events.enabled))
@@ -933,6 +939,11 @@ static void intel_pmu_enable_event(struc
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
@@ -1302,12 +1313,84 @@ static int intel_pmu_hw_config(struct pe
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
+
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
@@ -1325,6 +1408,7 @@ static __initconst const struct x86_pmu 
 	.get_event_constraints	= intel_get_event_constraints,
 	.put_event_constraints	= intel_put_event_constraints,
 	.event_constraints	= intel_core_event_constraints,
+	.guest_get_msrs		= core_guest_get_msrs,
 };
 
 struct intel_shared_regs *allocate_shared_regs(int cpu)
@@ -1431,6 +1515,7 @@ static __initconst const struct x86_pmu 
 	.cpu_prepare		= intel_pmu_cpu_prepare,
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
+	.guest_get_msrs		= intel_guest_get_msrs,
 };
 
 static void intel_clovertown_quirks(void)
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.h
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.h
@@ -131,6 +131,13 @@ struct cpu_hw_events {
 	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
 
 	/*
+	 * Intel host/guest exclude bits
+	 */
+	u64				intel_ctrl_guest_mask;
+	u64				intel_ctrl_host_mask;
+	struct perf_guest_switch_msr	guest_switch_msrs[X86_PMC_IDX_MAX];
+
+	/*
 	 * manage shared (per-core, per-cpu) registers
 	 * used on Intel NHM/WSM/SNB
 	 */
@@ -295,6 +302,11 @@ struct x86_pmu {
 	 */
 	struct extra_reg *extra_regs;
 	unsigned int er_flags;
+
+	/*
+	 * Intel host/guest support (KVM)
+	 */
+	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
 };
 
 #define ERF_NO_HT_SHARING	1

