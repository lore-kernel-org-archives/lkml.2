Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab2FSSML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:12:11 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:8437 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184Ab2FSSLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:11:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 7
X-BigFish: VPS7(z1039ozzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M5VMIG-02-7QJ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 03/10] perf, x86: Use bitmasks for generic counters
Date: Tue, 19 Jun 2012 20:10:41 +0200
Message-ID: <1340129448-8690-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will have non-countinous counter masks with the AMD family 15h pmu.
Introduce bitmasks for generic counters to support this.

This patch introduces the for_each_generic_counter(idx) macro to
iterate over all existing generic counters.

We update all the code to use that macro. Thus we are able to
configure a x86 pmu (struct members counters_mask/counters_mask64) to
have counter bit masks with holes in it.

The maximum number of generic counters is expanded to 64 now. If a pmu
has fixed counters (Intel), its number remains 32. Conflicts are
possible with generic counters and X86_PMC_IDX_FIXED_BTS. However, no
current pmu is affected. Moving BTS code to Intel only code could be
subject of another patch set.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   39 +++++++++++++++++++++----------
 arch/x86/kernel/cpu/perf_event.h       |    7 +++++
 arch/x86/kernel/cpu/perf_event_amd.c   |    6 ++--
 arch/x86/kernel/cpu/perf_event_intel.c |    6 ++--
 arch/x86/kernel/cpu/perf_event_p4.c    |    6 ++--
 5 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ac1cb32..7edea06 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -134,7 +134,7 @@ static bool reserve_pmc_hardware(void)
 {
 	int idx1, idx2;
 
-	for (idx1 = 0; idx1 < x86_pmu.num_counters; idx1++) {
+	for_each_generic_counter(idx1) {
 		if (!reserve_perfctr_nmi(x86_pmu_event_addr(idx1)))
 			goto perfctr_fail;
 		if (!reserve_evntsel_nmi(x86_pmu_config_addr(idx1)))
@@ -146,7 +146,7 @@ static bool reserve_pmc_hardware(void)
 eventsel_fail:
 	release_perfctr_nmi(x86_pmu_event_addr(idx1));
 perfctr_fail:
-	for (idx2 = 0; idx2 < x86_pmu.num_counters; idx2++) {
+	for_each_generic_counter(idx2) {
 		if (idx2 >= idx1)
 			break;
 		release_evntsel_nmi(x86_pmu_config_addr(idx2));
@@ -160,7 +160,7 @@ static void release_pmc_hardware(void)
 {
 	int i;
 
-	for (i = 0; i < x86_pmu.num_counters; i++) {
+	for_each_generic_counter(i) {
 		release_perfctr_nmi(x86_pmu_event_addr(i));
 		release_evntsel_nmi(x86_pmu_config_addr(i));
 	}
@@ -182,7 +182,7 @@ static bool check_hw_exists(void)
 	 * Check to see if the BIOS enabled any of the counters, if so
 	 * complain and bail.
 	 */
-	for (i = 0; i < x86_pmu.num_counters; i++) {
+	for_each_generic_counter(i) {
 		reg = x86_pmu_config_addr(i);
 		ret = rdmsrl_safe(reg, &val);
 		if (ret)
@@ -480,7 +480,7 @@ void x86_pmu_disable_all(void)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
-	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+	for_each_generic_counter(idx) {
 		u64 val;
 
 		if (!test_bit(idx, cpuc->active_mask))
@@ -515,7 +515,7 @@ void x86_pmu_enable_all(int added)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
-	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+	for_each_generic_counter(idx) {
 		struct hw_perf_event *hwc = &cpuc->events[idx]->hw;
 
 		if (!test_bit(idx, cpuc->active_mask))
@@ -612,7 +612,7 @@ static bool perf_sched_restore_state(struct perf_sched *sched)
 static bool __perf_sched_find_counter(struct perf_sched *sched)
 {
 	struct event_constraint *c;
-	int idx;
+	int idx, max;
 
 	if (!sched->state.unassigned)
 		return false;
@@ -629,10 +629,14 @@ static bool __perf_sched_find_counter(struct perf_sched *sched)
 			if (!__test_and_set_bit(idx, sched->state.used))
 				goto done;
 		}
+		max = X86_PMC_IDX_FIXED;
+	} else {
+		max = X86_PMC_IDX_MAX;
 	}
+
 	/* Grab the first unused counter starting with idx */
 	idx = sched->state.counter;
-	for_each_set_bit_from(idx, c->idxmsk, X86_PMC_IDX_FIXED) {
+	for_each_set_bit_from(idx, c->idxmsk, max) {
 		if (!__test_and_set_bit(idx, sched->state.used))
 			goto done;
 	}
@@ -813,7 +817,7 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	if (hwc->idx == X86_PMC_IDX_FIXED_BTS) {
 		hwc->config_base = 0;
 		hwc->event_base	= 0;
-	} else if (hwc->idx >= X86_PMC_IDX_FIXED) {
+	} else if (x86_pmu.num_counters_fixed && hwc->idx >= X86_PMC_IDX_FIXED) {
 		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
 		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0 + (hwc->idx - X86_PMC_IDX_FIXED);
 		hwc->event_base_rdpmc = (hwc->idx - X86_PMC_IDX_FIXED) | 1<<30;
@@ -1088,7 +1092,7 @@ void perf_event_print_debug(void)
 	}
 	pr_info("CPU#%d: active:     %016llx\n", cpu, *(u64 *)cpuc->active_mask);
 
-	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+	for_each_generic_counter(idx) {
 		rdmsrl(x86_pmu_config_addr(idx), pmc_ctrl);
 		rdmsrl(x86_pmu_event_addr(idx), pmc_count);
 
@@ -1183,7 +1187,7 @@ int x86_pmu_handle_irq(struct pt_regs *regs)
 	 */
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 
-	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+	for_each_generic_counter(idx) {
 		if (!test_bit(idx, cpuc->active_mask)) {
 			/*
 			 * Though we deactivated the counter some cpus
@@ -1351,11 +1355,19 @@ static int __init init_hw_perf_events(void)
 	x86_pmu.intel_ctrl |=
 		((1LL << x86_pmu.num_counters_fixed)-1) << X86_PMC_IDX_FIXED;
 
+	if (!x86_pmu.counters_mask64)
+		x86_pmu.counters_mask64 = (1ULL << x86_pmu.num_counters) - 1;
+	if (x86_pmu.num_counters != hweight64(x86_pmu.counters_mask64)) {
+		WARN(1, KERN_ERR "hw perf events counter mask and number don't match: 0x%016Lx/%d!",
+		     x86_pmu.counters_mask64, x86_pmu.num_counters);
+		x86_pmu.num_counters = hweight64(x86_pmu.counters_mask64);
+	}
+
 	perf_events_lapic_init();
 	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI");
 
 	unconstrained = (struct event_constraint)
-		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
+		__EVENT_CONSTRAINT(0, x86_pmu.counters_mask64,
 				   0, x86_pmu.num_counters, 0);
 
 	if (x86_pmu.event_constraints) {
@@ -1383,7 +1395,8 @@ static int __init init_hw_perf_events(void)
 	pr_info("... value mask:             %016Lx\n", x86_pmu.cntval_mask);
 	pr_info("... max period:             %016Lx\n", x86_pmu.max_period);
 	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_counters_fixed);
-	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
+	pr_info("... event mask:             %016Lx\n",
+		x86_pmu.intel_ctrl ? x86_pmu.intel_ctrl : x86_pmu.counters_mask64);
 
 	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 	perf_cpu_notifier(x86_pmu_notifier);
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3df3de9..eb14b76 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -237,6 +237,9 @@ struct cpu_hw_events {
 #define for_each_event_constraint(e, c)	\
 	for ((e) = (c); (e)->weight; (e)++)
 
+#define for_each_generic_counter(idx)	\
+	for_each_set_bit((idx), x86_pmu.counters_mask, X86_PMC_IDX_MAX)
+
 /*
  * Extra registers for specific events.
  *
@@ -327,6 +330,10 @@ struct x86_pmu {
 	unsigned	perfctr;
 	u64		(*event_map)(int);
 	int		max_events;
+	union {		/* generic counter mask, no fixed counters: */
+			unsigned long counters_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+			u64 counters_mask64;
+	};
 	int		num_counters;
 	int		num_counters_fixed;
 	int		cntval_bits;
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 194ca0b..b5ed2e1 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -209,7 +209,7 @@ static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
 	 * be removed on one CPU at a time AND PMU is disabled
 	 * when we come here
 	 */
-	for (i = 0; i < x86_pmu.num_counters; i++) {
+	for_each_generic_counter(i) {
 		if (cmpxchg(nb->owners + i, event, NULL) == event)
 			break;
 	}
@@ -275,7 +275,7 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	 * because of successive calls to x86_schedule_events() from
 	 * hw_perf_group_sched_in() without hw_perf_enable()
 	 */
-	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+	for_each_generic_counter(idx) {
 		if (new == -1 || hwc->idx == idx)
 			/* assign free slot, prefer hwc->idx */
 			old = cmpxchg(nb->owners + idx, NULL, event);
@@ -319,7 +319,7 @@ static struct amd_nb *amd_alloc_nb(int cpu)
 	/*
 	 * initialize all possible NB constraints
 	 */
-	for (i = 0; i < x86_pmu.num_counters; i++) {
+	for_each_generic_counter(i) {
 		__set_bit(i, nb->event_constraints[i].idxmsk);
 		nb->event_constraints[i].weight = 1;
 	}
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e23e71f..e8c2eae 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1002,7 +1002,7 @@ static void intel_pmu_reset(void)
 
 	printk("clearing PMU state on CPU#%d\n", smp_processor_id());
 
-	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+	for_each_generic_counter(idx) {
 		checking_wrmsrl(x86_pmu_config_addr(idx), 0ull);
 		checking_wrmsrl(x86_pmu_event_addr(idx),  0ull);
 	}
@@ -1453,7 +1453,7 @@ static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr)
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
 	int idx;
 
-	for (idx = 0; idx < x86_pmu.num_counters; idx++)  {
+	for_each_generic_counter(idx) {
 		struct perf_event *event = cpuc->events[idx];
 
 		arr[idx].msr = x86_pmu_config_addr(idx);
@@ -1486,7 +1486,7 @@ static void core_pmu_enable_all(int added)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
-	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+	for_each_generic_counter(idx) {
 		struct hw_perf_event *hwc = &cpuc->events[idx]->hw;
 
 		if (!test_bit(idx, cpuc->active_mask) ||
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 47124a7..1019049 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -919,7 +919,7 @@ static void p4_pmu_disable_all(void)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
-	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+	for_each_generic_counter(idx) {
 		struct perf_event *event = cpuc->events[idx];
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
@@ -988,7 +988,7 @@ static void p4_pmu_enable_all(int added)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
-	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+	for_each_generic_counter(idx) {
 		struct perf_event *event = cpuc->events[idx];
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
@@ -1007,7 +1007,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
-	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+	for_each_generic_counter(idx) {
 		int overflow;
 
 		if (!test_bit(idx, cpuc->active_mask)) {
-- 
1.7.8.4


