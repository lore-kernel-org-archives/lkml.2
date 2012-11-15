Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab2KOVd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:33:27 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:39261
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048Ab2KOVcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:32:11 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1155h)
X-WSS-ID: 0MDJT5I-01-3EK-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <rric@kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 4/4] perf, amd: Enable northbridge performance counters on AMD family 15h
Date: Thu, 15 Nov 2012 15:31:53 -0600
Message-ID: <1353015113-13262-5-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353015113-13262-1-git-send-email-jacob.shin@amd.com>
References: <1353015113-13262-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On AMD family 15h processors, there are 4 new performance counters
(in addition to 6 core performance counters) that can be used for
counting northbridge events (i.e. DRAM accesses). Their bit fields are
almost identical to the core performance counters. However, unlike the
core performance counters, these MSRs are shared between multiple
cores (that share the same northbridge). We will reuse the same code
path as existing family 10h northbridge event constraints handler
logic to enforce this sharing.

These new counters are indexed contiguously right above the existing
core performance counters, and their indexes correspond to RDPMC ECX
values.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/include/asm/cpufeature.h    |    2 +
 arch/x86/include/asm/msr-index.h     |    2 +
 arch/x86/include/asm/perf_event.h    |    6 ++
 arch/x86/kernel/cpu/perf_event_amd.c |  116 +++++++++++++++++++++++++++-------
 4 files changed, 104 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 8c297aa..b05c722 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -167,6 +167,7 @@
 #define X86_FEATURE_TBM		(6*32+21) /* trailing bit manipulations */
 #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
 #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
+#define X86_FEATURE_PERFCTR_NB  (6*32+24) /* core performance counter extensions */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
@@ -308,6 +309,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
 #define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
+#define cpu_has_perfctr_nb	boot_cpu_has(X86_FEATURE_PERFCTR_NB)
 #define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 7f0edce..e67ff1e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -157,6 +157,8 @@
 /* Fam 15h MSRs */
 #define MSR_F15H_PERF_CTL		0xc0010200
 #define MSR_F15H_PERF_CTR		0xc0010201
+#define MSR_F15H_NB_PERF_CTL		0xc0010240
+#define MSR_F15H_NB_PERF_CTR		0xc0010241
 
 /* Fam 10h MSRs */
 #define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 4fabcdf..a610ddb 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -29,9 +29,14 @@
 #define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
 #define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
 
+#define AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE		(1ULL << 36)
 #define AMD_PERFMON_EVENTSEL_GUESTONLY			(1ULL << 40)
 #define AMD_PERFMON_EVENTSEL_HOSTONLY			(1ULL << 41)
 
+#define AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT		37
+#define AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK		\
+	(0xFULL << AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT)
+
 #define AMD64_EVENTSEL_EVENT	\
 	(ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
 #define INTEL_ARCH_EVENT_MASK	\
@@ -48,6 +53,7 @@
 	 AMD64_EVENTSEL_EVENT)
 #define AMD64_NUM_COUNTERS				4
 #define AMD64_NUM_COUNTERS_CORE				6
+#define AMD64_NUM_COUNTERS_NB				4
 
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index d6e3337..2fb7b8c 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -143,10 +143,15 @@ static unsigned int addr_offsets[X86_PMC_IDX_MAX] __read_mostly;
  *
  * CPUs with core performance counter extensions:
  *   6 counters starting at 0xc0010200 each offset by 2
+ *
+ * CPUs with north bridge performance counter extensions:
+ *   4 additional counters starting at 0xc0010240 each offset by 2
+ *   (indexed right above either one of the above core counters)
  */
 static inline int amd_pmu_addr_offset(int index)
 {
 	int offset;
+	int ncore;
 
 	if (!index)
 		return index;
@@ -156,31 +161,28 @@ static inline int amd_pmu_addr_offset(int index)
 	if (offset)
 		return offset;
 
-	if (!cpu_has_perfctr_core)
+	if (!cpu_has_perfctr_core) {
 		offset = index;
-	else
+		ncore = AMD64_NUM_COUNTERS;
+	} else {
 		offset = index << 1;
+		ncore = AMD64_NUM_COUNTERS_CORE;
+	}
+
+	/* find offset of NB counters with respect to x86_pmu.eventsel */
+	if (cpu_has_perfctr_nb) {
+		if (index >= ncore && index < (ncore + AMD64_NUM_COUNTERS_NB))
+			offset = (MSR_F15H_NB_PERF_CTL - x86_pmu.eventsel) +
+				 ((index - ncore) << 1);
+	}
 
 	addr_offsets[index] = offset;
 
 	return offset;
 }
 
-static int amd_pmu_hw_config(struct perf_event *event)
+static int __amd_core_hw_config(struct perf_event *event)
 {
-	int ret;
-
-	/* pass precise event sampling to ibs: */
-	if (event->attr.precise_ip && get_ibs_caps())
-		return -ENOENT;
-
-	ret = x86_pmu_hw_config(event);
-	if (ret)
-		return ret;
-
-	if (has_branch_stack(event))
-		return -EOPNOTSUPP;
-
 	if (event->attr.exclude_host && event->attr.exclude_guest)
 		/*
 		 * When HO == GO == 1 the hardware treats that as GO == HO == 0
@@ -194,10 +196,24 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	else if (event->attr.exclude_guest)
 		event->hw.config |= AMD_PERFMON_EVENTSEL_HOSTONLY;
 
-	if (event->attr.type != PERF_TYPE_RAW)
-		return 0;
+	return 0;
+}
+
+static int __amd_nb_hw_config(struct perf_event *event)
+{
+	if (event->attr.exclude_user || event->attr.exclude_kernel ||
+	    event->attr.exclude_host || event->attr.exclude_guest)
+		return -EINVAL;
 
-	event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
+	event->hw.config &= ~ARCH_PERFMON_EVENTSEL_USR;
+	event->hw.config &= ~ARCH_PERFMON_EVENTSEL_OS;
+
+	if (event->hw.config & ~(AMD64_EVENTSEL_EVENT        |
+				 ARCH_PERFMON_EVENTSEL_UMASK |
+				 ARCH_PERFMON_EVENTSEL_INT   |
+				 AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE |
+				 AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK))
+		return -EINVAL;
 
 	return 0;
 }
@@ -215,6 +231,11 @@ static inline int amd_is_nb_event(struct hw_perf_event *hwc)
 	return (hwc->config & 0xe0) == 0xe0;
 }
 
+static inline int amd_is_perfctr_nb_event(struct hw_perf_event *hwc)
+{
+	return cpu_has_perfctr_nb && amd_is_nb_event(hwc);
+}
+
 static inline int amd_has_nb(struct cpu_hw_events *cpuc)
 {
 	struct amd_nb *nb = cpuc->amd_nb;
@@ -222,6 +243,30 @@ static inline int amd_has_nb(struct cpu_hw_events *cpuc)
 	return nb && nb->nb_id != -1;
 }
 
+static int amd_pmu_hw_config(struct perf_event *event)
+{
+	int ret;
+
+	/* pass precise event sampling to ibs: */
+	if (event->attr.precise_ip && get_ibs_caps())
+		return -ENOENT;
+
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
+	ret = x86_pmu_hw_config(event);
+	if (ret)
+		return ret;
+
+	if (event->attr.type == PERF_TYPE_RAW)
+		event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
+
+	if (amd_is_perfctr_nb_event(&event->hw))
+		return __amd_nb_hw_config(event);
+
+	return __amd_core_hw_config(event);
+}
+
 static void __amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
 					   struct perf_event *event)
 {
@@ -323,6 +368,16 @@ __amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *ev
 	if (new == -1)
 		return &emptyconstraint;
 
+	/* set up interrupts to be delivered only to this core */
+	if (cpu_has_perfctr_nb) {
+		struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+
+		hwc->config |= AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE;
+		hwc->config &= ~AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK;
+		hwc->config |= (0ULL | (c->cpu_core_id)) <<
+			AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT;
+	}
+
 	return &nb->event_constraints[new];
 }
 
@@ -520,6 +575,7 @@ static struct event_constraint amd_f15_PMC3  = EVENT_CONSTRAINT(0, 0x08, 0);
 static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT_OVERLAP(0, 0x09, 0);
 static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
 static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
+static struct event_constraint amd_f15_NBPMC30 = EVENT_CONSTRAINT(0, 0x3C0, 0);
 
 static struct event_constraint *
 amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
@@ -586,8 +642,11 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *ev
 			return &amd_f15_PMC20;
 		}
 	case AMD_EVENT_NB:
-		/* not yet implemented */
-		return &emptyconstraint;
+		if (cpuc->is_fake)
+			return &amd_f15_NBPMC30;
+
+		return __amd_get_nb_event_constraints(cpuc, event,
+						      &amd_f15_NBPMC30);
 	default:
 		return &emptyconstraint;
 	}
@@ -625,7 +684,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 
 static int setup_event_constraints(void)
 {
-	if (boot_cpu_data.x86 >= 0x15)
+	if (boot_cpu_data.x86 == 0x15)
 		x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;
 	return 0;
 }
@@ -655,6 +714,18 @@ static int setup_perfctr_core(void)
 	return 0;
 }
 
+static int setup_perfctr_nb(void)
+{
+	if (!cpu_has_perfctr_nb)
+		return -ENODEV;
+
+	x86_pmu.num_counters += AMD64_NUM_COUNTERS_NB;
+
+	printk(KERN_INFO "perf: AMD northbridge performance counters detected\n");
+
+	return 0;
+}
+
 __init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
@@ -665,6 +736,7 @@ __init int amd_pmu_init(void)
 
 	setup_event_constraints();
 	setup_perfctr_core();
+	setup_perfctr_nb();
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
-- 
1.7.9.5


