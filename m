Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab2KJBCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:02:18 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:34834
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142Ab2KJBCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:02:01 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h1155h)
X-WSS-ID: 0MD8YV5-01-03P-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <rric@kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 4/4] perf, amd: Enable northbridge performance counters on AMD family 15h
Date: Fri, 9 Nov 2012 19:01:38 -0600
Message-ID: <1352509298-7319-5-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352509298-7319-1-git-send-email-jacob.shin@amd.com>
References: <1352509298-7319-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On AMD family 15h processors, there are 4 new performance counters
(in addition to 6 core performance counters) that can be used for
counting northbridge events (i.e. DRAM accesses). Their bit fields are
almost identical to the core performance counters. However, the same
set of MSRs are shared between multiple cores (that share the same
northbridge). We will reuse the same code path as existing family 10h
northbridge event constraints handler logic to enforce sharing.

Based on previous patch by Robert Richter <rric@kernel.org>

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 arch/x86/include/asm/cpufeature.h    |    2 +
 arch/x86/include/asm/msr-index.h     |    2 +
 arch/x86/include/asm/perf_event.h    |    6 ++
 arch/x86/kernel/cpu/perf_event_amd.c |  142 ++++++++++++++++++++++++++--------
 4 files changed, 120 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 8c297aa..17f75b8 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -167,6 +167,7 @@
 #define X86_FEATURE_TBM		(6*32+21) /* trailing bit manipulations */
 #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
 #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
+#define X86_FEATURE_PERFCTR_NB	(6*32+24) /* nb performance counter extensions */
 
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
index 4fabcdf..75e039c 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -29,6 +29,8 @@
 #define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
 #define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
 
+#define AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE		(1ULL << 36)
+#define AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK		(0x0FULL << 37)
 #define AMD_PERFMON_EVENTSEL_GUESTONLY			(1ULL << 40)
 #define AMD_PERFMON_EVENTSEL_HOSTONLY			(1ULL << 41)
 
@@ -46,8 +48,12 @@
 #define AMD64_RAW_EVENT_MASK		\
 	(X86_RAW_EVENT_MASK          |  \
 	 AMD64_EVENTSEL_EVENT)
+#define AMD64_NB_EVENT_MASK		\
+	(AMD64_EVENTSEL_EVENT        |  \
+	 ARCH_PERFMON_EVENTSEL_UMASK)
 #define AMD64_NUM_COUNTERS				4
 #define AMD64_NUM_COUNTERS_CORE				6
+#define AMD64_NUM_COUNTERS_NB				4
 
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 078beb5..adf4026 100644
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
@@ -158,8 +163,17 @@ static inline int amd_pmu_addr_offset(int index)
 
 	if (!cpu_has_perfctr_core) {
 		offset = index;
+		ncore = AMD64_NUM_COUNTERS;
 	} else {
 		offset = index << 1;
+		ncore = AMD64_NUM_COUNTERS_CORE;
+	}
+
+	/* find offset of NB counters with respect to x86_pmu.eventsel */
+	if (cpu_has_perfctr_nb) {
+		if (index >= ncore && index < (ncore + AMD64_NUM_COUNTERS_NB))
+			offset = (MSR_F15H_NB_PERF_CTL - x86_pmu.eventsel) +
+				 ((index - ncore) << 1);
 	}
 
 	addr_offsets[index] = offset;
@@ -167,6 +181,66 @@ static inline int amd_pmu_addr_offset(int index)
 	return offset;
 }
 
+/*
+ * AMD64 events are detected based on their event codes.
+ */
+static inline unsigned int amd_get_event_code(struct hw_perf_event *hwc)
+{
+	return ((hwc->config >> 24) & 0x0f00) | (hwc->config & 0x00ff);
+}
+
+static inline int amd_is_nb_event(struct hw_perf_event *hwc)
+{
+	return (hwc->config & 0xe0) == 0xe0;
+}
+
+static inline int amd_is_nb_perfctr_event(struct hw_perf_event *hwc)
+{
+	return cpu_has_perfctr_nb && amd_is_nb_event(hwc);
+}
+
+static inline int amd_has_nb(struct cpu_hw_events *cpuc)
+{
+	struct amd_nb *nb = cpuc->amd_nb;
+
+	return nb && nb->nb_id != -1;
+}
+
+/*
+ * AMD NB counters (MSRs 0xc0010240 etc.) do not support the following
+ * flags:
+ *
+ *  Host/Guest Only
+ *  Counter Mask
+ *  Invert Comparison
+ *  Edge Detect
+ *  Operating-System Mode
+ *  User Mode
+ *
+ * Try to fix the config for default settings, otherwise fail.
+ */
+static int amd_nb_event_config(struct perf_event *event)
+{
+	if (!amd_is_nb_perfctr_event(&event->hw))
+		return 0;
+
+	if (event->attr.exclude_host || event->attr.exclude_guest
+	    || event->attr.exclude_user || event->attr.exclude_kernel)
+		goto fail;
+
+	event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR | ARCH_PERFMON_EVENTSEL_OS);
+
+	if (event->hw.config & ~(AMD64_NB_EVENT_MASK | ARCH_PERFMON_EVENTSEL_INT |
+				 AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE |
+				 AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK))
+		goto fail;
+
+	return 0;
+fail:
+	pr_debug("Invalid nb counter config value: %016Lx\n", event->hw.config);
+	return -EINVAL;
+}
+
 static int amd_pmu_hw_config(struct perf_event *event)
 {
 	int ret;
@@ -175,13 +249,13 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (event->attr.precise_ip && get_ibs_caps())
 		return -ENOENT;
 
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	ret = x86_pmu_hw_config(event);
 	if (ret)
 		return ret;
 
-	if (has_branch_stack(event))
-		return -EOPNOTSUPP;
-
 	if (event->attr.exclude_host && event->attr.exclude_guest)
 		/*
 		 * When HO == GO == 1 the hardware treats that as GO == HO == 0
@@ -195,32 +269,10 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	else if (event->attr.exclude_guest)
 		event->hw.config |= AMD_PERFMON_EVENTSEL_HOSTONLY;
 
-	if (event->attr.type != PERF_TYPE_RAW)
-		return 0;
-
-	event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
-
-	return 0;
-}
-
-/*
- * AMD64 events are detected based on their event codes.
- */
-static inline unsigned int amd_get_event_code(struct hw_perf_event *hwc)
-{
-	return ((hwc->config >> 24) & 0x0f00) | (hwc->config & 0x00ff);
-}
-
-static inline int amd_is_nb_event(struct hw_perf_event *hwc)
-{
-	return (hwc->config & 0xe0) == 0xe0;
-}
-
-static inline int amd_has_nb(struct cpu_hw_events *cpuc)
-{
-	struct amd_nb *nb = cpuc->amd_nb;
+	if (event->attr.type == PERF_TYPE_RAW)
+		event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
 
-	return nb && nb->nb_id != -1;
+	return amd_nb_event_config(event);
 }
 
 static void __amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
@@ -324,6 +376,15 @@ __amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *ev
 	if (new == -1)
 		return &emptyconstraint;
 
+	/* set up interrupts to be delivered only to this core */
+	if (cpu_has_perfctr_nb) {
+		struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+
+		hwc->config |= AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE;
+		hwc->config &= ~AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK;
+		hwc->config |= (0ULL | (c->cpu_core_id)) << 37;
+	}
+
 	return &nb->event_constraints[new];
 }
 
@@ -420,7 +481,7 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	/*
 	 * if not NB event or no NB, then no constraints
 	 */
-	if ((amd_has_nb(cpuc) && amd_is_nb_event(&event->hw)))
+	if (!(amd_has_nb(cpuc) && amd_is_nb_event(&event->hw)))
 		return &unconstrained;
 
 	return __amd_get_nb_event_constraints(cpuc, event, &unconstrained);
@@ -521,6 +582,7 @@ static struct event_constraint amd_f15_PMC3  = EVENT_CONSTRAINT(0, 0x08, 0);
 static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT_OVERLAP(0, 0x09, 0);
 static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
 static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
+static struct event_constraint amd_f15_NBPMC30 = EVENT_CONSTRAINT(0, 0x3C0, 0);
 
 static struct event_constraint *
 amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
@@ -587,8 +649,11 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *ev
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
@@ -626,7 +691,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 
 static int setup_event_constraints(void)
 {
-	if (boot_cpu_data.x86 >= 0x15)
+	if (boot_cpu_data.x86 == 0x15)
 		x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;
 	return 0;
 }
@@ -656,6 +721,18 @@ static int setup_perfctr_core(void)
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
@@ -666,6 +743,7 @@ __init int amd_pmu_init(void)
 
 	setup_event_constraints();
 	setup_perfctr_core();
+	setup_perfctr_nb();
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
-- 
1.7.9.5


