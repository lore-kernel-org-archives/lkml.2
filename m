Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2FSSME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:12:04 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:10204
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549Ab2FSSLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:11:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M5VMII-01-1OM-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 04/10] perf, x86: Rename Intel specific macros
Date: Tue, 19 Jun 2012 20:10:42 +0200
Message-ID: <1340129448-8690-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are macros that are Intel specific and not x86 generic. Rename
them into INTEL_*.

This patch removes X86_PMC_IDX_GENERIC and does:

 $ sed -i -e 's/X86_PMC_MAX_/INTEL_PMC_MAX_/g'           \
         arch/x86/include/asm/kvm_host.h                 \
         arch/x86/include/asm/perf_event.h               \
         arch/x86/kernel/cpu/perf_event.c                \
         arch/x86/kernel/cpu/perf_event_p4.c             \
         arch/x86/kvm/pmu.c
 $ sed -i -e 's/X86_PMC_IDX_FIXED/INTEL_PMC_IDX_FIXED/g' \
         arch/x86/include/asm/perf_event.h               \
         arch/x86/kernel/cpu/perf_event.c                \
         arch/x86/kernel/cpu/perf_event_intel.c          \
         arch/x86/kernel/cpu/perf_event_intel_ds.c       \
         arch/x86/kvm/pmu.c
 $ sed -i -e 's/X86_PMC_MSK_/INTEL_PMC_MSK_/g'           \
         arch/x86/include/asm/perf_event.h               \
         arch/x86/kernel/cpu/perf_event.c

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/kvm_host.h           |    4 +-
 arch/x86/include/asm/perf_event.h         |   17 ++++++-------
 arch/x86/kernel/cpu/perf_event.c          |   36 ++++++++++++++--------------
 arch/x86/kernel/cpu/perf_event_intel.c    |   14 +++++-----
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    4 +-
 arch/x86/kernel/cpu/perf_event_p4.c       |    2 +-
 arch/x86/kvm/pmu.c                        |   22 +++++++++---------
 7 files changed, 49 insertions(+), 50 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index db7c1f2..2da88c0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -313,8 +313,8 @@ struct kvm_pmu {
 	u64 counter_bitmask[2];
 	u64 global_ctrl_mask;
 	u8 version;
-	struct kvm_pmc gp_counters[X86_PMC_MAX_GENERIC];
-	struct kvm_pmc fixed_counters[X86_PMC_MAX_FIXED];
+	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
+	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
 	struct irq_work irq_work;
 	u64 reprogram_pmi;
 };
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 588f52e..3b31248 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -5,11 +5,10 @@
  * Performance event hw details:
  */
 
-#define X86_PMC_MAX_GENERIC				       32
-#define X86_PMC_MAX_FIXED					3
+#define INTEL_PMC_MAX_GENERIC				       32
+#define INTEL_PMC_MAX_FIXED					3
+#define INTEL_PMC_IDX_FIXED				       32
 
-#define X86_PMC_IDX_GENERIC				        0
-#define X86_PMC_IDX_FIXED				       32
 #define X86_PMC_IDX_MAX					       64
 
 #define MSR_ARCH_PERFMON_PERFCTR0			      0xc1
@@ -121,16 +120,16 @@ struct x86_pmu_capability {
 
 /* Instr_Retired.Any: */
 #define MSR_ARCH_PERFMON_FIXED_CTR0	0x309
-#define X86_PMC_IDX_FIXED_INSTRUCTIONS	(X86_PMC_IDX_FIXED + 0)
+#define INTEL_PMC_IDX_FIXED_INSTRUCTIONS	(INTEL_PMC_IDX_FIXED + 0)
 
 /* CPU_CLK_Unhalted.Core: */
 #define MSR_ARCH_PERFMON_FIXED_CTR1	0x30a
-#define X86_PMC_IDX_FIXED_CPU_CYCLES	(X86_PMC_IDX_FIXED + 1)
+#define INTEL_PMC_IDX_FIXED_CPU_CYCLES	(INTEL_PMC_IDX_FIXED + 1)
 
 /* CPU_CLK_Unhalted.Ref: */
 #define MSR_ARCH_PERFMON_FIXED_CTR2	0x30b
-#define X86_PMC_IDX_FIXED_REF_CYCLES	(X86_PMC_IDX_FIXED + 2)
-#define X86_PMC_MSK_FIXED_REF_CYCLES	(1ULL << X86_PMC_IDX_FIXED_REF_CYCLES)
+#define INTEL_PMC_IDX_FIXED_REF_CYCLES	(INTEL_PMC_IDX_FIXED + 2)
+#define INTEL_PMC_MSK_FIXED_REF_CYCLES	(1ULL << INTEL_PMC_IDX_FIXED_REF_CYCLES)
 
 /*
  * We model BTS tracing as another fixed-mode PMC.
@@ -139,7 +138,7 @@ struct x86_pmu_capability {
  * values are used by actual fixed events and higher values are used
  * to indicate other overflow conditions in the PERF_GLOBAL_STATUS msr.
  */
-#define X86_PMC_IDX_FIXED_BTS				(X86_PMC_IDX_FIXED + 16)
+#define INTEL_PMC_IDX_FIXED_BTS				(INTEL_PMC_IDX_FIXED + 16)
 
 /*
  * IBS cpuid feature detection
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 7edea06..2874059 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -63,7 +63,7 @@ u64 x86_perf_event_update(struct perf_event *event)
 	int idx = hwc->idx;
 	s64 delta;
 
-	if (idx == X86_PMC_IDX_FIXED_BTS)
+	if (idx == INTEL_PMC_IDX_FIXED_BTS)
 		return 0;
 
 	/*
@@ -624,12 +624,12 @@ static bool __perf_sched_find_counter(struct perf_sched *sched)
 
 	/* Prefer fixed purpose counters */
 	if (x86_pmu.num_counters_fixed) {
-		idx = X86_PMC_IDX_FIXED;
+		idx = INTEL_PMC_IDX_FIXED;
 		for_each_set_bit_from(idx, c->idxmsk, X86_PMC_IDX_MAX) {
 			if (!__test_and_set_bit(idx, sched->state.used))
 				goto done;
 		}
-		max = X86_PMC_IDX_FIXED;
+		max = INTEL_PMC_IDX_FIXED;
 	} else {
 		max = X86_PMC_IDX_MAX;
 	}
@@ -814,13 +814,13 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	hwc->last_cpu = smp_processor_id();
 	hwc->last_tag = ++cpuc->tags[i];
 
-	if (hwc->idx == X86_PMC_IDX_FIXED_BTS) {
+	if (hwc->idx == INTEL_PMC_IDX_FIXED_BTS) {
 		hwc->config_base = 0;
 		hwc->event_base	= 0;
-	} else if (x86_pmu.num_counters_fixed && hwc->idx >= X86_PMC_IDX_FIXED) {
+	} else if (x86_pmu.num_counters_fixed && hwc->idx >= INTEL_PMC_IDX_FIXED) {
 		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
-		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0 + (hwc->idx - X86_PMC_IDX_FIXED);
-		hwc->event_base_rdpmc = (hwc->idx - X86_PMC_IDX_FIXED) | 1<<30;
+		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0 + (hwc->idx - INTEL_PMC_IDX_FIXED);
+		hwc->event_base_rdpmc = (hwc->idx - INTEL_PMC_IDX_FIXED) | 1<<30;
 	} else {
 		hwc->config_base = x86_pmu_config_addr(hwc->idx);
 		hwc->event_base  = x86_pmu_event_addr(hwc->idx);
@@ -922,7 +922,7 @@ int x86_perf_event_set_period(struct perf_event *event)
 	s64 period = hwc->sample_period;
 	int ret = 0, idx = hwc->idx;
 
-	if (idx == X86_PMC_IDX_FIXED_BTS)
+	if (idx == INTEL_PMC_IDX_FIXED_BTS)
 		return 0;
 
 	/*
@@ -1339,21 +1339,21 @@ static int __init init_hw_perf_events(void)
 	for (quirk = x86_pmu.quirks; quirk; quirk = quirk->next)
 		quirk->func();
 
-	if (x86_pmu.num_counters > X86_PMC_MAX_GENERIC) {
+	if (x86_pmu.num_counters > INTEL_PMC_MAX_GENERIC) {
 		WARN(1, KERN_ERR "hw perf events %d > max(%d), clipping!",
-		     x86_pmu.num_counters, X86_PMC_MAX_GENERIC);
-		x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
+		     x86_pmu.num_counters, INTEL_PMC_MAX_GENERIC);
+		x86_pmu.num_counters = INTEL_PMC_MAX_GENERIC;
 	}
 	x86_pmu.intel_ctrl = (1 << x86_pmu.num_counters) - 1;
 
-	if (x86_pmu.num_counters_fixed > X86_PMC_MAX_FIXED) {
+	if (x86_pmu.num_counters_fixed > INTEL_PMC_MAX_FIXED) {
 		WARN(1, KERN_ERR "hw perf events fixed %d > max(%d), clipping!",
-		     x86_pmu.num_counters_fixed, X86_PMC_MAX_FIXED);
-		x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
+		     x86_pmu.num_counters_fixed, INTEL_PMC_MAX_FIXED);
+		x86_pmu.num_counters_fixed = INTEL_PMC_MAX_FIXED;
 	}
 
 	x86_pmu.intel_ctrl |=
-		((1LL << x86_pmu.num_counters_fixed)-1) << X86_PMC_IDX_FIXED;
+		((1LL << x86_pmu.num_counters_fixed)-1) << INTEL_PMC_IDX_FIXED;
 
 	if (!x86_pmu.counters_mask64)
 		x86_pmu.counters_mask64 = (1ULL << x86_pmu.num_counters) - 1;
@@ -1377,7 +1377,7 @@ static int __init init_hw_perf_events(void)
 		 */
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
 			if (c->cmask != X86_RAW_EVENT_MASK
-			    || c->idxmsk64 == X86_PMC_MSK_FIXED_REF_CYCLES) {
+			    || c->idxmsk64 == INTEL_PMC_MSK_FIXED_REF_CYCLES) {
 				continue;
 			}
 
@@ -1621,8 +1621,8 @@ static int x86_pmu_event_idx(struct perf_event *event)
 	if (!x86_pmu.attr_rdpmc)
 		return 0;
 
-	if (x86_pmu.num_counters_fixed && idx >= X86_PMC_IDX_FIXED) {
-		idx -= X86_PMC_IDX_FIXED;
+	if (x86_pmu.num_counters_fixed && idx >= INTEL_PMC_IDX_FIXED) {
+		idx -= INTEL_PMC_IDX_FIXED;
 		idx |= 1 << 30;
 	}
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e8c2eae..1eb9f00 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -747,7 +747,7 @@ static void intel_pmu_disable_all(void)
 
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 
-	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask))
+	if (test_bit(INTEL_PMC_IDX_FIXED_BTS, cpuc->active_mask))
 		intel_pmu_disable_bts();
 
 	intel_pmu_pebs_disable_all();
@@ -763,9 +763,9 @@ static void intel_pmu_enable_all(int added)
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL,
 			x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask);
 
-	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
+	if (test_bit(INTEL_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
 		struct perf_event *event =
-			cpuc->events[X86_PMC_IDX_FIXED_BTS];
+			cpuc->events[INTEL_PMC_IDX_FIXED_BTS];
 
 		if (WARN_ON_ONCE(!event))
 			return;
@@ -871,7 +871,7 @@ static inline void intel_pmu_ack_status(u64 ack)
 
 static void intel_pmu_disable_fixed(struct hw_perf_event *hwc)
 {
-	int idx = hwc->idx - X86_PMC_IDX_FIXED;
+	int idx = hwc->idx - INTEL_PMC_IDX_FIXED;
 	u64 ctrl_val, mask;
 
 	mask = 0xfULL << (idx * 4);
@@ -886,7 +886,7 @@ static void intel_pmu_disable_event(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
+	if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_BTS)) {
 		intel_pmu_disable_bts();
 		intel_pmu_drain_bts_buffer();
 		return;
@@ -915,7 +915,7 @@ static void intel_pmu_disable_event(struct perf_event *event)
 
 static void intel_pmu_enable_fixed(struct hw_perf_event *hwc)
 {
-	int idx = hwc->idx - X86_PMC_IDX_FIXED;
+	int idx = hwc->idx - INTEL_PMC_IDX_FIXED;
 	u64 ctrl_val, bits, mask;
 
 	/*
@@ -949,7 +949,7 @@ static void intel_pmu_enable_event(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
+	if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_BTS)) {
 		if (!__this_cpu_read(cpu_hw_events.enabled))
 			return;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 026373e..629ae0b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -248,7 +248,7 @@ void reserve_ds_buffers(void)
  */
 
 struct event_constraint bts_constraint =
-	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
+	EVENT_CONSTRAINT(0, 1ULL << INTEL_PMC_IDX_FIXED_BTS, 0);
 
 void intel_pmu_enable_bts(u64 config)
 {
@@ -295,7 +295,7 @@ int intel_pmu_drain_bts_buffer(void)
 		u64	to;
 		u64	flags;
 	};
-	struct perf_event *event = cpuc->events[X86_PMC_IDX_FIXED_BTS];
+	struct perf_event *event = cpuc->events[INTEL_PMC_IDX_FIXED_BTS];
 	struct bts_record *at, *top;
 	struct perf_output_handle handle;
 	struct perf_event_header header;
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 1019049..f3e73b8 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1325,7 +1325,7 @@ __init int p4_pmu_init(void)
 	unsigned int low, high;
 
 	/* If we get stripped -- indexing fails */
-	BUILD_BUG_ON(ARCH_P4_MAX_CCCR > X86_PMC_MAX_GENERIC);
+	BUILD_BUG_ON(ARCH_P4_MAX_CCCR > INTEL_PMC_MAX_GENERIC);
 
 	rdmsr(MSR_IA32_MISC_ENABLE, low, high);
 	if (!(low & (1 << 7))) {
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 2e88438..9b7ec11 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -80,10 +80,10 @@ static inline struct kvm_pmc *get_fixed_pmc_idx(struct kvm_pmu *pmu, int idx)
 
 static struct kvm_pmc *global_idx_to_pmc(struct kvm_pmu *pmu, int idx)
 {
-	if (idx < X86_PMC_IDX_FIXED)
+	if (idx < INTEL_PMC_IDX_FIXED)
 		return get_gp_pmc(pmu, MSR_P6_EVNTSEL0 + idx, MSR_P6_EVNTSEL0);
 	else
-		return get_fixed_pmc_idx(pmu, idx - X86_PMC_IDX_FIXED);
+		return get_fixed_pmc_idx(pmu, idx - INTEL_PMC_IDX_FIXED);
 }
 
 void kvm_deliver_pmi(struct kvm_vcpu *vcpu)
@@ -291,7 +291,7 @@ static void reprogram_idx(struct kvm_pmu *pmu, int idx)
 	if (pmc_is_gp(pmc))
 		reprogram_gp_counter(pmc, pmc->eventsel);
 	else {
-		int fidx = idx - X86_PMC_IDX_FIXED;
+		int fidx = idx - INTEL_PMC_IDX_FIXED;
 		reprogram_fixed_counter(pmc,
 				fixed_en_pmi(pmu->fixed_ctr_ctrl, fidx), fidx);
 	}
@@ -452,7 +452,7 @@ void kvm_pmu_cpuid_update(struct kvm_vcpu *vcpu)
 		return;
 
 	pmu->nr_arch_gp_counters = min((int)(entry->eax >> 8) & 0xff,
-			X86_PMC_MAX_GENERIC);
+			INTEL_PMC_MAX_GENERIC);
 	pmu->counter_bitmask[KVM_PMC_GP] =
 		((u64)1 << ((entry->eax >> 16) & 0xff)) - 1;
 	bitmap_len = (entry->eax >> 24) & 0xff;
@@ -462,13 +462,13 @@ void kvm_pmu_cpuid_update(struct kvm_vcpu *vcpu)
 		pmu->nr_arch_fixed_counters = 0;
 	} else {
 		pmu->nr_arch_fixed_counters = min((int)(entry->edx & 0x1f),
-				X86_PMC_MAX_FIXED);
+				INTEL_PMC_MAX_FIXED);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << ((entry->edx >> 5) & 0xff)) - 1;
 	}
 
 	pmu->global_ctrl = ((1 << pmu->nr_arch_gp_counters) - 1) |
-		(((1ull << pmu->nr_arch_fixed_counters) - 1) << X86_PMC_IDX_FIXED);
+		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED);
 	pmu->global_ctrl_mask = ~pmu->global_ctrl;
 }
 
@@ -478,15 +478,15 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 
 	memset(pmu, 0, sizeof(*pmu));
-	for (i = 0; i < X86_PMC_MAX_GENERIC; i++) {
+	for (i = 0; i < INTEL_PMC_MAX_GENERIC; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
 	}
-	for (i = 0; i < X86_PMC_MAX_FIXED; i++) {
+	for (i = 0; i < INTEL_PMC_MAX_FIXED; i++) {
 		pmu->fixed_counters[i].type = KVM_PMC_FIXED;
 		pmu->fixed_counters[i].vcpu = vcpu;
-		pmu->fixed_counters[i].idx = i + X86_PMC_IDX_FIXED;
+		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
 	}
 	init_irq_work(&pmu->irq_work, trigger_pmi);
 	kvm_pmu_cpuid_update(vcpu);
@@ -498,13 +498,13 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 	int i;
 
 	irq_work_sync(&pmu->irq_work);
-	for (i = 0; i < X86_PMC_MAX_GENERIC; i++) {
+	for (i = 0; i < INTEL_PMC_MAX_GENERIC; i++) {
 		struct kvm_pmc *pmc = &pmu->gp_counters[i];
 		stop_counter(pmc);
 		pmc->counter = pmc->eventsel = 0;
 	}
 
-	for (i = 0; i < X86_PMC_MAX_FIXED; i++)
+	for (i = 0; i < INTEL_PMC_MAX_FIXED; i++)
 		stop_counter(&pmu->fixed_counters[i]);
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
-- 
1.7.8.4


