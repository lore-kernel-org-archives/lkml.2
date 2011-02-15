Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1BONwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:52:21 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:22156 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1BONwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:52:17 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGNVUY-01-7J6-02
X-M-MSG: 
Date: Tue, 15 Feb 2011 14:52:10 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf, x86: Add support for AMD family 15h core counters
Message-ID: <20110215135210.GB5874@erda.amd.com>
References: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
 <1296664860-10886-6-git-send-email-robert.richter@amd.com>
 <1296666198.26581.343.camel@laptop>
 <20110202172419.GB5874@erda.amd.com>
 <1296667777.26581.349.camel@laptop>
 <AANLkTikdLUkv3y6-g=OegtJD5bXS0vPPjLMR1jmQjCZz@mail.gmail.com>
 <20110203090001.GG5874@erda.amd.com>
 <1296725883.26581.359.camel@laptop>
 <20110203140650.GI5874@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110203140650.GI5874@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.02.11 15:06:50, Robert Richter wrote:
> On 03.02.11 04:38:03, Peter Zijlstra wrote:
> > I think the alternatives thing is probably nicest, except for having to
> > write the bits in asm.
> 
> Will send an updated version.

Below there is an updated version of my recent patch submission of

 [PATCH 5/5] perf, x86: Add support for AMD family 15h core counters

It now generates the msr offset by shifting the index. I wrote the
code so that it can easily be replaced with a faster ALTERNATIVE()
version that uses binary patching. Thus, I have introduced and used
cpu feature flags for it.

I will work on an ALTERNATIVE() version, but wont be able for ig
before mid of March because I will be travelling the next weeks.

-Robert


--

>From 1b5a6061fceae47a8b7ddd6d24ae9a4909358fe8 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Wed, 2 Feb 2011 17:36:12 +0100
Subject: [PATCH] perf, x86: Add support for AMD family 15h core counters

This patch adds support for AMD family 15h core counters. There are
major changes compared to family 10h. First, there is a new perfctr
msr range for up to 6 counters. Northbridge counters are separate
now. This patch only adds support for core counters. Second, certain
events may only be scheduled on certain counters. For this we need to
extend the event scheduling and constraints.

We use cpu feature flags to calculate family 15h msr address offsets.
This way we later can implement a faster ALTERNATIVE() version for
this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/cpufeature.h    |    2 +
 arch/x86/kernel/cpu/perf_event.c     |   12 ++-
 arch/x86/kernel/cpu/perf_event_amd.c |  175 +++++++++++++++++++++++++++++++++-
 3 files changed, 186 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 220e2ea..91f3e087 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -160,6 +160,7 @@
 #define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
 #define X86_FEATURE_TBM		(6*32+21) /* trailing bit manipulations */
 #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
+#define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
@@ -279,6 +280,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
+#define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3161943..10bfe247 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -321,14 +321,22 @@ again:
 	return new_raw_count;
 }
 
+/* using X86_FEATURE_PERFCTR_CORE to later implement ALTERNATIVE() here */
+static inline int x86_pmu_addr_offset(int index)
+{
+	if (boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
+		return index << 1;
+	return index;
+}
+
 static inline unsigned int x86_pmu_config_addr(int index)
 {
-	return x86_pmu.eventsel + index;
+	return x86_pmu.eventsel + x86_pmu_addr_offset(index);
 }
 
 static inline unsigned int x86_pmu_event_addr(int index)
 {
-	return x86_pmu.perfctr + index;
+	return x86_pmu.perfctr + x86_pmu_addr_offset(index);
 }
 
 static atomic_t active_events;
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 67e2202..461f62b 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -127,6 +127,11 @@ static int amd_pmu_hw_config(struct perf_event *event)
 /*
  * AMD64 events are detected based on their event codes.
  */
+static inline unsigned int amd_get_event_code(struct hw_perf_event *hwc)
+{
+	return ((hwc->config >> 24) & 0x0f00) | (hwc->config & 0x00ff);
+}
+
 static inline int amd_is_nb_event(struct hw_perf_event *hwc)
 {
 	return (hwc->config & 0xe0) == 0xe0;
@@ -385,13 +390,181 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.cpu_dead		= amd_pmu_cpu_dead,
 };
 
+/* AMD Family 15h */
+
+#define AMD_EVENT_TYPE_MASK	0x000000F0ULL
+
+#define AMD_EVENT_FP		0x00000000ULL ... 0x00000010ULL
+#define AMD_EVENT_LS		0x00000020ULL ... 0x00000030ULL
+#define AMD_EVENT_DC		0x00000040ULL ... 0x00000050ULL
+#define AMD_EVENT_CU		0x00000060ULL ... 0x00000070ULL
+#define AMD_EVENT_IC_DE		0x00000080ULL ... 0x00000090ULL
+#define AMD_EVENT_EX_LS		0x000000C0ULL
+#define AMD_EVENT_DE		0x000000D0ULL
+#define AMD_EVENT_NB		0x000000E0ULL ... 0x000000F0ULL
+
+/*
+ * AMD family 15h event code/PMC mappings:
+ *
+ * type = event_code & 0x0F0:
+ *
+ * 0x000	FP	PERF_CTL[5:3]
+ * 0x010	FP	PERF_CTL[5:3]
+ * 0x020	LS	PERF_CTL[5:0]
+ * 0x030	LS	PERF_CTL[5:0]
+ * 0x040	DC	PERF_CTL[5:0]
+ * 0x050	DC	PERF_CTL[5:0]
+ * 0x060	CU	PERF_CTL[2:0]
+ * 0x070	CU	PERF_CTL[2:0]
+ * 0x080	IC/DE	PERF_CTL[2:0]
+ * 0x090	IC/DE	PERF_CTL[2:0]
+ * 0x0A0	---
+ * 0x0B0	---
+ * 0x0C0	EX/LS	PERF_CTL[5:0]
+ * 0x0D0	DE	PERF_CTL[2:0]
+ * 0x0E0	NB	NB_PERF_CTL[3:0]
+ * 0x0F0	NB	NB_PERF_CTL[3:0]
+ *
+ * Exceptions:
+ *
+ * 0x003	FP	PERF_CTL[3]
+ * 0x00B	FP	PERF_CTL[3]
+ * 0x00D	FP	PERF_CTL[3]
+ * 0x023	DE	PERF_CTL[2:0]
+ * 0x02D	LS	PERF_CTL[3]
+ * 0x02E	LS	PERF_CTL[3,0]
+ * 0x043	CU	PERF_CTL[2:0]
+ * 0x045	CU	PERF_CTL[2:0]
+ * 0x046	CU	PERF_CTL[2:0]
+ * 0x054	CU	PERF_CTL[2:0]
+ * 0x055	CU	PERF_CTL[2:0]
+ * 0x08F	IC	PERF_CTL[0]
+ * 0x187	DE	PERF_CTL[0]
+ * 0x188	DE	PERF_CTL[0]
+ * 0x0DB	EX	PERF_CTL[5:0]
+ * 0x0DC	LS	PERF_CTL[5:0]
+ * 0x0DD	LS	PERF_CTL[5:0]
+ * 0x0DE	LS	PERF_CTL[5:0]
+ * 0x0DF	LS	PERF_CTL[5:0]
+ * 0x1D6	EX	PERF_CTL[5:0]
+ * 0x1D8	EX	PERF_CTL[5:0]
+ */
+
+static struct event_constraint amd_f15_PMC0  = EVENT_CONSTRAINT(0, 0x01, 0);
+static struct event_constraint amd_f15_PMC20 = EVENT_CONSTRAINT(0, 0x07, 0);
+static struct event_constraint amd_f15_PMC3  = EVENT_CONSTRAINT(0, 0x08, 0);
+static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT(0, 0x09, 0);
+static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
+static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
+
+static struct event_constraint *
+amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	unsigned int event_code = amd_get_event_code(&event->hw);
+
+	switch (event_code & AMD_EVENT_TYPE_MASK) {
+	case AMD_EVENT_FP:
+		switch (event_code) {
+		case 0x003:
+		case 0x00B:
+		case 0x00D:
+			return &amd_f15_PMC3;
+		default:
+			return &amd_f15_PMC53;
+		}
+	case AMD_EVENT_LS:
+	case AMD_EVENT_DC:
+	case AMD_EVENT_EX_LS:
+		switch (event_code) {
+		case 0x023:
+		case 0x043:
+		case 0x045:
+		case 0x046:
+		case 0x054:
+		case 0x055:
+			return &amd_f15_PMC20;
+		case 0x02D:
+			return &amd_f15_PMC3;
+		case 0x02E:
+			return &amd_f15_PMC30;
+		default:
+			return &amd_f15_PMC50;
+		}
+	case AMD_EVENT_CU:
+	case AMD_EVENT_IC_DE:
+	case AMD_EVENT_DE:
+		switch (event_code) {
+		case 0x08F:
+		case 0x187:
+		case 0x188:
+			return &amd_f15_PMC0;
+		case 0x0DB ... 0x0DF:
+		case 0x1D6:
+		case 0x1D8:
+			return &amd_f15_PMC50;
+		default:
+			return &amd_f15_PMC20;
+		}
+	case AMD_EVENT_NB:
+		/* not yet implemented */
+		return &emptyconstraint;
+	default:
+		return &emptyconstraint;
+	}
+}
+
+static __initconst const struct x86_pmu amd_pmu_f15h = {
+	.name			= "AMD Family 15h",
+	.handle_irq		= x86_pmu_handle_irq,
+	.disable_all		= x86_pmu_disable_all,
+	.enable_all		= x86_pmu_enable_all,
+	.enable			= x86_pmu_enable_event,
+	.disable		= x86_pmu_disable_event,
+	.hw_config		= amd_pmu_hw_config,
+	.schedule_events	= x86_schedule_events,
+	.eventsel		= MSR_F15H_PERF_CTL,
+	.perfctr		= MSR_F15H_PERF_CTR,
+	.event_map		= amd_pmu_event_map,
+	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
+	.num_counters		= 6,
+	.cntval_bits		= 48,
+	.cntval_mask		= (1ULL << 48) - 1,
+	.apic			= 1,
+	/* use highest bit to detect overflow */
+	.max_period		= (1ULL << 47) - 1,
+	.get_event_constraints	= amd_get_event_constraints_f15h,
+	/* nortbridge counters not yet implemented: */
+#if 0
+	.put_event_constraints	= amd_put_event_constraints,
+
+	.cpu_prepare		= amd_pmu_cpu_prepare,
+	.cpu_starting		= amd_pmu_cpu_starting,
+	.cpu_dead		= amd_pmu_cpu_dead,
+#endif
+};
+
 static __init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
 	if (boot_cpu_data.x86 < 6)
 		return -ENODEV;
 
-	x86_pmu = amd_pmu;
+	/*
+	 * If core performance counter extensions exists, it must be
+	 * family 15h, otherwise fail. See x86_pmu_addr_offset().
+	 */
+	switch (boot_cpu_data.x86) {
+	case 0x15:
+		if (!cpu_has_perfctr_core)
+			return -ENODEV;
+		x86_pmu = amd_pmu_f15h;
+		break;
+	default:
+		if (cpu_has_perfctr_core)
+			return -ENODEV;
+		x86_pmu = amd_pmu;
+		break;
+	}
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
-- 
1.7.3.4


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

