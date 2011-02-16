Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab1BPNtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:49:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:40060 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab1BPNtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:49:39 -0500
Date: Wed, 16 Feb 2011 13:49:16 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110215135210.GB5874@erda.amd.com>
References: <20110215135210.GB5874@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Add support for AMD family 15h core counters
Message-ID: <tip-4979d2729af22f6ce8faa325fc60a85a2c2daa02@git.kernel.org>
Git-Commit-ID: 4979d2729af22f6ce8faa325fc60a85a2c2daa02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 13:49:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4979d2729af22f6ce8faa325fc60a85a2c2daa02
Gitweb:     http://git.kernel.org/tip/4979d2729af22f6ce8faa325fc60a85a2c2daa02
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 2 Feb 2011 17:36:12 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Feb 2011 13:30:53 +0100

perf, x86: Add support for AMD family 15h core counters

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110215135210.GB5874@erda.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 3161943..10bfe24 100644
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
