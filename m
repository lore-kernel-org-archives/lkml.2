Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab1GOOaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:30:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:62765 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1GOO36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:29:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,535,1304319600"; 
   d="scan'208";a="26267122"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/6] perf, x86: Add Intel SandyBridge uncore pmu
Date: Fri, 15 Jul 2011 14:35:00 +0000
Message-Id: <1310740503-15608-4-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Intel SandyBridge uncore pmu support.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/include/asm/msr-index.h              |   26 +++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   57 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   11 +++++
 3 files changed, 93 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index e66011e..fa0e9e6 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -421,7 +421,7 @@
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
 
-/* Intel Nehalem/Westmere uncore performance counters */
+/* Intel Nehalem/Westmere/SandyBridge uncore performance counters */
 #define MSR_UNCORE_PERF_GLOBAL_CTRL	0x00000391
 #define MSR_UNCORE_FIXED_CTR_CTRL	0x00000394
 #define MSR_UNCORE_FIXED_CTR0		0x00000395
@@ -429,6 +429,30 @@
 #define MSR_NHM_UNCORE_PMC0		0x000003b0
 #define MSR_NHM_UNCORE_PERFEVTSEL0	0x000003c0
 
+#define MSR_SNB_UNCORE_CBO_0_PERFEVTSEL0	0x00000700
+#define MSR_SNB_UNCORE_CBO_0_PERFEVTSEL1	0x00000701
+#define MSR_SNB_UNCORE_CBO_0_UNIT_STATUS	0x00000705
+#define MSR_SNB_UNCORE_CBO_0_PER_CTR0		0x00000706
+#define MSR_SNB_UNCORE_CBO_0_PER_CTR1		0x00000707
+
+#define MSR_SNB_UNCORE_CBO_1_PERFEVTSEL0	0x00000710
+#define MSR_SNB_UNCORE_CBO_1_PERFEVTSEL1	0x00000711
+#define MSR_SNB_UNCORE_CBO_1_UNIT_STATUS	0x00000715
+#define MSR_SNB_UNCORE_CBO_1_PER_CTR0		0x00000716
+#define MSR_SNB_UNCORE_CBO_1_PER_CTR1		0x00000717
+
+#define MSR_SNB_UNCORE_CBO_2_PERFEVTSEL0	0x00000720
+#define MSR_SNB_UNCORE_CBO_2_PERFEVTSEL1	0x00000721
+#define MSR_SNB_UNCORE_CBO_2_UNIT_STATUS	0x00000725
+#define MSR_SNB_UNCORE_CBO_2_PER_CTR0		0x00000726
+#define MSR_SNB_UNCORE_CBO_2_PER_CTR1		0x00000727
+
+#define MSR_SNB_UNCORE_CBO_3_PERFEVTSEL0	0x00000730
+#define MSR_SNB_UNCORE_CBO_3_PERFEVTSEL1	0x00000731
+#define MSR_SNB_UNCORE_CBO_3_UNIT_STATUS	0x00000735
+#define MSR_SNB_UNCORE_CBO_3_PER_CTR0		0x00000736
+#define MSR_SNB_UNCORE_CBO_3_PER_CTR1		0x00000737
+
 /* Geode defined MSRs */
 #define MSR_GEODE_BUSCONT_CONF0		0x00001900
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 79a501e..1100589 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -98,6 +98,59 @@ static __initconst const struct intel_uncore_pmu nhm_uncore_pmu = {
 	.cntval_bits_fixed	= 48,
 };
 
+/* SandyBridge uncore pmu */
+
+static struct uncore_config {
+	unsigned long config_base;
+	unsigned long event_base;
+} snb_uncore_configs[UNCORE_NUM_GENERIC_COUNTERS] = {
+	{MSR_SNB_UNCORE_CBO_0_PERFEVTSEL0, MSR_SNB_UNCORE_CBO_0_PER_CTR0},
+	{MSR_SNB_UNCORE_CBO_0_PERFEVTSEL1, MSR_SNB_UNCORE_CBO_0_PER_CTR1},
+	{MSR_SNB_UNCORE_CBO_1_PERFEVTSEL0, MSR_SNB_UNCORE_CBO_1_PER_CTR0},
+	{MSR_SNB_UNCORE_CBO_1_PERFEVTSEL1, MSR_SNB_UNCORE_CBO_1_PER_CTR1},
+	{MSR_SNB_UNCORE_CBO_2_PERFEVTSEL0, MSR_SNB_UNCORE_CBO_2_PER_CTR0},
+	{MSR_SNB_UNCORE_CBO_2_PERFEVTSEL1, MSR_SNB_UNCORE_CBO_2_PER_CTR1},
+	{MSR_SNB_UNCORE_CBO_3_PERFEVTSEL0, MSR_SNB_UNCORE_CBO_3_PER_CTR0},
+	{MSR_SNB_UNCORE_CBO_3_PERFEVTSEL1, MSR_SNB_UNCORE_CBO_3_PER_CTR1},
+};
+
+static void snb_uncore_pmu_enable_all(void)
+{
+	wrmsrl(MSR_UNCORE_PERF_GLOBAL_CTRL,
+		SNB_UNCORE_PERF_GLOBAL_CTRL_EN);
+}
+
+static void snb_uncore_pmu_hw_config(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	int i = hwc->idx;
+
+	if (event->hw.idx == X86_PMC_IDX_FIXED) {
+		uncore_fixed_hw_config(event);
+		return;
+	}
+
+	hwc->config = event->attr.config & SNB_UNCORE_RAW_EVENT_MASK;
+	hwc->config_base = snb_uncore_configs[i].config_base;
+	hwc->event_base = snb_uncore_configs[i].event_base;
+}
+
+static void snb_uncore_pmu_enable_event(struct perf_event *event)
+{
+	uncore_pmu_enable_event(event, SNB_UNCORE_FIXED_CTR_CTRL_EN);
+}
+
+static __initconst const struct intel_uncore_pmu snb_uncore_pmu = {
+	.name			= "SandyBridge",
+	.disable_all		= uncore_pmu_disable_all,
+	.enable_all		= snb_uncore_pmu_enable_all,
+	.enable			= snb_uncore_pmu_enable_event,
+	.disable		= uncore_pmu_disable_event,
+	.hw_config		= snb_uncore_pmu_hw_config,
+	.cntval_bits		= 44,
+	.cntval_bits_fixed	= 48,
+};
+
 static u64 uncore_perf_event_update(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -436,6 +489,10 @@ static int __init uncore_pmu_init(void)
 		intel_uncore_pmu = nhm_uncore_pmu;
 		break;
 
+	case 42: /* SandyBridge */
+		intel_uncore_pmu = snb_uncore_pmu;
+		break;
+
 	default:
 		return 0;
 	}
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 431c8b4..c7392aa 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -5,6 +5,9 @@
 
 #define UNCORE_FIXED_EVENT			0xFFFF
 #define NHM_UNCORE_FIXED_CTR_CTRL_EN		(1ULL << 0)
+#define SNB_UNCORE_FIXED_CTR_CTRL_EN		(1ULL << 22)
+
+#define SNB_UNCORE_PERF_GLOBAL_CTRL_EN		(1ULL << 29)
 
 #define UNCORE_EVENTSEL_EVENT			0x000000FFULL
 #define UNCORE_EVENTSEL_UMASK			0x0000FF00ULL
@@ -12,6 +15,7 @@
 #define UNCORE_EVENTSEL_ENABLE			(1ULL << 22)
 #define UNCORE_EVENTSEL_INV			(1ULL << 23)
 #define NHM_UNCORE_EVENTSEL_CMASK		0xFF000000ULL
+#define SNB_UNCORE_EVENTSEL_CMASK		0x1F000000ULL
 
 #define NHM_UNCORE_RAW_EVENT_MASK	\
 	(UNCORE_EVENTSEL_EVENT |	\
@@ -20,6 +24,13 @@
 	 UNCORE_EVENTSEL_INV   |	\
 	 NHM_UNCORE_EVENTSEL_CMASK)
 
+#define SNB_UNCORE_RAW_EVENT_MASK	\
+	(UNCORE_EVENTSEL_EVENT |	\
+	 UNCORE_EVENTSEL_UMASK |	\
+	 UNCORE_EVENTSEL_EDGE  |	\
+	 UNCORE_EVENTSEL_INV   |	\
+	 SNB_UNCORE_EVENTSEL_CMASK)
+
 /* 8 generic counters + 1 fixed counter */
 #define UNCORE_NUM_GENERIC_COUNTERS		8
 #define UNCORE_NUM_FIXED_COUNTERS		1
-- 
1.7.5.1

