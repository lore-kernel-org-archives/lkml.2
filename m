Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2FSSMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:12:13 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:10204
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753101Ab2FSSLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:11:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M5VMIG-02-7QK-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 08/10] perf, amd: Enable northbridge counters on family 15h
Date: Tue, 19 Jun 2012 20:10:46 +0200
Message-ID: <1340129448-8690-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables northbridge counter support for family 15h cpus.
Northbridge counters on family 15h have a separate counter bit mask
and constraints. NB counters are enabled if the nb performance counter
extensions cpuid flag is set.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/cpufeature.h    |    2 +
 arch/x86/include/asm/perf_event.h    |    3 ++
 arch/x86/kernel/cpu/perf_event.c     |   21 +++++++++++++++-
 arch/x86/kernel/cpu/perf_event_amd.c |   42 +++++++++++++++++++++++++++------
 4 files changed, 58 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 340ee49..404bb64 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -164,6 +164,7 @@
 #define X86_FEATURE_TBM		(6*32+21) /* trailing bit manipulations */
 #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
 #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
+#define X86_FEATURE_PERFCTR_NB	(6*32+24) /* nb performance counter extensions */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
@@ -301,6 +302,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
 #define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
+#define cpu_has_perfctr_nb	boot_cpu_has(X86_FEATURE_PERFCTR_NB)
 #define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index ffdf5e0..637a72b7 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -9,6 +9,8 @@
 #define INTEL_PMC_MAX_FIXED					3
 #define INTEL_PMC_IDX_FIXED				       32
 
+#define AMD64_PMC_IDX_NB				       32
+
 #define X86_PMC_IDX_MAX					       64
 
 #define MSR_ARCH_PERFMON_PERFCTR0			      0xc1
@@ -48,6 +50,7 @@
 	 AMD64_EVENTSEL_EVENT)
 #define AMD64_NUM_COUNTERS				4
 #define AMD64_NUM_COUNTERS_CORE				6
+#define AMD64_NUM_COUNTERS_NB				4
 
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9fbf70a..1d59cac 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -805,6 +805,13 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 	return n;
 }
 
+static inline int x86_pmu_rdpmc_index(int index)
+{
+	if (cpu_has_perfctr_nb && (index >= AMD64_PMC_IDX_NB))
+		return index - AMD64_PMC_IDX_NB + AMD64_NUM_COUNTERS_CORE;
+	return index;
+}
+
 static inline void x86_assign_hw_event(struct perf_event *event,
 				struct cpu_hw_events *cpuc, int i)
 {
@@ -824,7 +831,7 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	} else {
 		hwc->config_base = x86_pmu_config_addr(hwc->idx);
 		hwc->event_base  = x86_pmu_event_addr(hwc->idx);
-		hwc->event_base_rdpmc = hwc->idx;
+		hwc->event_base_rdpmc = x86_pmu_rdpmc_index(hwc->idx);
 	}
 }
 
@@ -1194,7 +1201,17 @@ int x86_pmu_handle_irq(struct pt_regs *regs)
 			 * might still deliver spurious interrupts still
 			 * in flight. Catch them:
 			 */
-			if (__test_and_clear_bit(idx, cpuc->running))
+			if (idx >= AMD64_PMC_IDX_NB && cpuc->amd_nb && cpuc->amd_nb->owners[idx]) {
+				/*
+				 * AMD NB counters send nmis to all
+				 * cpus on the node. Fix this later:
+				 * This swallows all nmis on the node
+				 * if a nb counter is active and even
+				 * if there was no overflow.
+				 */
+				handled++;
+				__set_bit(idx, cpuc->running);
+			} else if (__test_and_clear_bit(idx, cpuc->running))
 				handled++;
 			continue;
 		}
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index e538512..7a870d2 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -7,6 +7,9 @@
 
 #include "perf_event.h"
 
+#define AMD64_COUNTERS_MASK_NB	\
+	(((1ULL << AMD64_NUM_COUNTERS_NB) - 1) << AMD64_PMC_IDX_NB)
+
 static __initconst const u64 amd_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -461,12 +464,13 @@ static struct attribute *amd_format_attr[] = {
  * (**) only one unitmask enabled at a time
  */
 
-static struct event_constraint amd_f15_PMC0  = EVENT_CONSTRAINT(0, 0x01, 0);
-static struct event_constraint amd_f15_PMC20 = EVENT_CONSTRAINT(0, 0x07, 0);
-static struct event_constraint amd_f15_PMC3  = EVENT_CONSTRAINT(0, 0x08, 0);
-static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT_OVERLAP(0, 0x09, 0);
-static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
-static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
+static struct event_constraint amd_f15_PMC0  	= EVENT_CONSTRAINT(0, 0x01, 0);
+static struct event_constraint amd_f15_PMC20	= EVENT_CONSTRAINT(0, 0x07, 0);
+static struct event_constraint amd_f15_PMC3	= EVENT_CONSTRAINT(0, 0x08, 0);
+static struct event_constraint amd_f15_PMC30	= EVENT_CONSTRAINT_OVERLAP(0, 0x09, 0);
+static struct event_constraint amd_f15_PMC50	= EVENT_CONSTRAINT(0, 0x3F, 0);
+static struct event_constraint amd_f15_PMC53	= EVENT_CONSTRAINT(0, 0x38, 0);
+static struct event_constraint amd_f15_NBPMC30	= EVENT_CONSTRAINT(0, AMD64_COUNTERS_MASK_NB, 0);
 
 static struct event_constraint *
 __amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
@@ -533,8 +537,7 @@ __amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *
 			return &amd_f15_PMC20;
 		}
 	case AMD_EVENT_NB:
-		/* not yet implemented */
-		return &emptyconstraint;
+		return &amd_f15_NBPMC30;
 	default:
 		return &emptyconstraint;
 	}
@@ -635,6 +638,28 @@ static int setup_perfctr_core(void)
 	return 0;
 }
 
+static int setup_perfctr_nb(void)
+{
+	if (!cpu_has_perfctr_nb)
+		return -ENODEV;
+
+	/* requires core perfctrs initialized first */
+	if (x86_pmu.eventsel != MSR_F15H_PERF_CTL)
+		return -ENODEV;
+
+	if (x86_pmu.get_event_constraints == amd_get_event_constraints) {
+		WARN(1, KERN_ERR "hw perf events nb counter needs constraints handler!");
+		return -ENODEV;
+	}
+
+	x86_pmu.num_counters	+= AMD64_NUM_COUNTERS_NB;
+	x86_pmu.counters_mask64	|= AMD64_COUNTERS_MASK_NB;
+
+	printk(KERN_INFO "perf: AMD northbridge performance counters detected\n");
+
+	return 0;
+}
+
 __init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
@@ -645,6 +670,7 @@ __init int amd_pmu_init(void)
 
 	setup_event_constraints();
 	setup_perfctr_core();
+	setup_perfctr_nb();
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
-- 
1.7.8.4


