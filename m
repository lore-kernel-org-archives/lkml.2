Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab1F3IE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:04:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:57684 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab1F3IDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:03:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,449,1304319600"; 
   d="scan'208";a="20764695"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] perf, x86: Add Intel SandyBridge uncore pmu
Date: Thu, 30 Jun 2011 08:09:54 +0000
Message-Id: <1309421396-17438-3-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Intel SandyBridge uncore pmu support.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   49 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   40 ++++++++++++++++++++
 2 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 01060ce..fdfe7e6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -57,6 +57,51 @@ static __initconst const struct intel_uncore_pmu nhm_uncore_pmu = {
 	.cntval_bits		= 48,
 };
 
+/* SandyBridge uncore pmu */
+
+static struct uncore_config {
+	unsigned long config_base;
+	unsigned long event_base;
+} snb_uncore_configs[SNB_UNCORE_NUM_COUNTERS] = {
+	{SNB_MSR_UNC_CBO_0_PERFEVTSEL0, SNB_MSR_UNC_CBO_0_PER_CTR0},
+	{SNB_MSR_UNC_CBO_0_PERFEVTSEL1, SNB_MSR_UNC_CBO_0_PER_CTR1},
+	{SNB_MSR_UNC_CBO_1_PERFEVTSEL0, SNB_MSR_UNC_CBO_1_PER_CTR0},
+	{SNB_MSR_UNC_CBO_1_PERFEVTSEL1, SNB_MSR_UNC_CBO_1_PER_CTR1},
+	{SNB_MSR_UNC_CBO_2_PERFEVTSEL0, SNB_MSR_UNC_CBO_2_PER_CTR0},
+	{SNB_MSR_UNC_CBO_2_PERFEVTSEL1, SNB_MSR_UNC_CBO_2_PER_CTR1},
+	{SNB_MSR_UNC_CBO_3_PERFEVTSEL0, SNB_MSR_UNC_CBO_3_PER_CTR0},
+	{SNB_MSR_UNC_CBO_3_PERFEVTSEL1, SNB_MSR_UNC_CBO_3_PER_CTR1},
+};
+
+static void snb_uncore_pmu_enable_all(void)
+{
+	wrmsrl(SNB_MSR_UNCORE_PERF_GLOBAL_CTRL,
+		SNB_MSR_UNCORE_PERF_GLOBAL_CTRL_EN);
+}
+
+static int snb_uncore_pmu_hw_config(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	int i = hwc->idx;
+
+	hwc->config = event->attr.config & SNB_UNCORE_RAW_EVENT_MASK;
+	hwc->config_base = snb_uncore_configs[i].config_base;
+	hwc->event_base = snb_uncore_configs[i].event_base;
+
+	return 0;
+}
+
+static __initconst const struct intel_uncore_pmu snb_uncore_pmu = {
+	.name			= "SandyBridge",
+	.disable_all		= nhm_uncore_pmu_disable_all,
+	.enable_all		= snb_uncore_pmu_enable_all,
+	.enable			= nhm_uncore_pmu_enable_event,
+	.disable		= nhm_uncore_pmu_disable_event,
+	.hw_config		= snb_uncore_pmu_hw_config,
+	.num_counters		= 8,
+	.cntval_bits		= 48,
+};
+
 static u64 uncore_perf_event_update(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -337,6 +382,10 @@ static int __init uncore_pmu_init(void)
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
index f622f97..9ba152b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -23,6 +23,46 @@
 	 NHM_UNCORE_EVENTSEL_INV   |	\
 	 NHM_UNCORE_EVENTSEL_CMASK)
 
+/* SandyBridge uncore MSR */
+
+#define SNB_MSR_UNC_CBO_0_PERFEVTSEL0		0x700
+#define SNB_MSR_UNC_CBO_0_PERFEVTSEL1		0x701
+#define SNB_MSR_UNC_CBO_0_UNIT_STATUS		0x705
+#define SNB_MSR_UNC_CBO_0_PER_CTR0		0x706
+#define SNB_MSR_UNC_CBO_0_PER_CTR1		0x707
+
+#define SNB_MSR_UNC_CBO_1_PERFEVTSEL0		0x710
+#define SNB_MSR_UNC_CBO_1_PERFEVTSEL1		0x711
+#define SNB_MSR_UNC_CBO_1_UNIT_STATUS		0x715
+#define SNB_MSR_UNC_CBO_1_PER_CTR0		0x716
+#define SNB_MSR_UNC_CBO_1_PER_CTR1		0x717
+
+#define SNB_MSR_UNC_CBO_2_PERFEVTSEL0		0x720
+#define SNB_MSR_UNC_CBO_2_PERFEVTSEL1		0x721
+#define SNB_MSR_UNC_CBO_2_UNIT_STATUS		0x725
+#define SNB_MSR_UNC_CBO_2_PER_CTR0		0x726
+#define SNB_MSR_UNC_CBO_2_PER_CTR1		0x727
+
+#define SNB_MSR_UNC_CBO_3_PERFEVTSEL0		0x730
+#define SNB_MSR_UNC_CBO_3_PERFEVTSEL1		0x731
+#define SNB_MSR_UNC_CBO_3_UNIT_STATUS		0x735
+#define SNB_MSR_UNC_CBO_3_PER_CTR0		0x736
+#define SNB_MSR_UNC_CBO_3_PER_CTR1		0x737
+
+#define SNB_MSR_UNCORE_PERF_GLOBAL_CTRL		0x391
+#define SNB_MSR_UNCORE_PERF_GLOBAL_CTRL_EN	(1ULL << 29)
+
+#define SNB_UNCORE_EVENTSEL_CMASK		0x1F000000ULL
+
+#define SNB_UNCORE_RAW_EVENT_MASK	\
+	(NHM_UNCORE_EVENTSEL_EVENT |	\
+	 NHM_UNCORE_EVENTSEL_UMASK |	\
+	 NHM_UNCORE_EVENTSEL_EDGE  |	\
+	 NHM_UNCORE_EVENTSEL_INV   |	\
+	 SNB_UNCORE_EVENTSEL_CMASK)
+
+#define SNB_UNCORE_NUM_COUNTERS			8
+
 struct intel_uncore {
 	int id;			/* uncore id */
 	int refcnt;		/* reference count */
-- 
1.7.5.1

