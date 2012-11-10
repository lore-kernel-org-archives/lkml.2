Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab2KJB2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:28:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:5882 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2KJB2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:28:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="215766614"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>, avi@redhat.com, gleb@redhat.com
Subject: [PATCH 05/32] perf, kvm: Support the intx/intx_cp modifiers in KVM arch perfmon emulation v4
Date: Fri,  9 Nov 2012 17:27:21 -0800
Message-Id: <1352510868-7911-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This is not arch perfmon, but older CPUs will just ignore it. This makes
it possible to do at least some TSX measurements from a KVM guest

Cc: avi@redhat.com
Cc: gleb@redhat.com
v2: Various fixes to address review feedback
v3: Ignore the bits when no CPUID. No #GP. Force raw events with TSX bits.
v4: Use reserved bits for #GP
Cc: gleb@redhat.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/pmu.c              |   32 ++++++++++++++++++++++++--------
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b2e11f4..63d4be4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -318,6 +318,7 @@ struct kvm_pmu {
 	u64 global_ovf_ctrl;
 	u64 counter_bitmask[2];
 	u64 global_ctrl_mask;
+	u64 reserved_bits;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index cfc258a..89405d0 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -160,7 +160,7 @@ static void stop_counter(struct kvm_pmc *pmc)
 
 static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		unsigned config, bool exclude_user, bool exclude_kernel,
-		bool intr)
+		bool intr, bool intx, bool intx_cp)
 {
 	struct perf_event *event;
 	struct perf_event_attr attr = {
@@ -173,6 +173,10 @@ static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.exclude_kernel = exclude_kernel,
 		.config = config,
 	};
+	if (intx)
+		attr.config |= HSW_INTX;
+	if (intx_cp)
+		attr.config |= HSW_INTX_CHECKPOINTED;
 
 	attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
 
@@ -206,7 +210,8 @@ static unsigned find_arch_event(struct kvm_pmu *pmu, u8 event_select,
 	return arch_events[i].event_type;
 }
 
-static void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
+static void reprogram_gp_counter(struct kvm_pmu *pmu, struct kvm_pmc *pmc, 
+				 u64 eventsel)
 {
 	unsigned config, type = PERF_TYPE_RAW;
 	u8 event_select, unit_mask;
@@ -226,7 +231,9 @@ static void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 
 	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
 				ARCH_PERFMON_EVENTSEL_INV |
-				ARCH_PERFMON_EVENTSEL_CMASK))) {
+				ARCH_PERFMON_EVENTSEL_CMASK |
+				HSW_INTX |
+				HSW_INTX_CHECKPOINTED))) {
 		config = find_arch_event(&pmc->vcpu->arch.pmu, event_select,
 				unit_mask);
 		if (config != PERF_COUNT_HW_MAX)
@@ -239,7 +246,9 @@ static void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	reprogram_counter(pmc, type, config,
 			!(eventsel & ARCH_PERFMON_EVENTSEL_USR),
 			!(eventsel & ARCH_PERFMON_EVENTSEL_OS),
-			eventsel & ARCH_PERFMON_EVENTSEL_INT);
+			eventsel & ARCH_PERFMON_EVENTSEL_INT,
+			(eventsel & HSW_INTX),
+			(eventsel & HSW_INTX_CHECKPOINTED));
 }
 
 static void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 en_pmi, int idx)
@@ -256,7 +265,7 @@ static void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 en_pmi, int idx)
 			arch_events[fixed_pmc_events[idx]].event_type,
 			!(en & 0x2), /* exclude user */
 			!(en & 0x1), /* exclude kernel */
-			pmi);
+			pmi, false, false);
 }
 
 static inline u8 fixed_en_pmi(u64 ctrl, int idx)
@@ -289,7 +298,7 @@ static void reprogram_idx(struct kvm_pmu *pmu, int idx)
 		return;
 
 	if (pmc_is_gp(pmc))
-		reprogram_gp_counter(pmc, pmc->eventsel);
+		reprogram_gp_counter(pmu, pmc, pmc->eventsel);
 	else {
 		int fidx = idx - INTEL_PMC_IDX_FIXED;
 		reprogram_fixed_counter(pmc,
@@ -400,8 +409,8 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
 		} else if ((pmc = get_gp_pmc(pmu, index, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)
 				return 0;
-			if (!(data & 0xffffffff00200000ull)) {
-				reprogram_gp_counter(pmc, data);
+			if (!(data & pmu->reserved_bits)) {
+				reprogram_gp_counter(pmu, pmc, data);
 				return 0;
 			}
 		}
@@ -442,6 +451,7 @@ void kvm_pmu_cpuid_update(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_GP] = 0;
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
+	pmu->reserved_bits = 0xffffffff00200000ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -470,6 +480,12 @@ void kvm_pmu_cpuid_update(struct kvm_vcpu *vcpu)
 	pmu->global_ctrl = ((1 << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED);
 	pmu->global_ctrl_mask = ~pmu->global_ctrl;
+
+	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
+	if (entry &&
+	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
+	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
+		pmu->reserved_bits ^= HSW_INTX|HSW_INTX_CHECKPOINTED;
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
-- 
1.7.7.6

