Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1BBQqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:46:53 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:37032
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581Ab1BBQqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:46:51 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LG019T-02-KFL-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/5] perf, x86: Add support for AMD family 15h core counters
Date: Wed, 2 Feb 2011 17:41:00 +0100
Message-ID: <1296664860-10886-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
References: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for AMD family 15h core counters. There are
major changes compared to family 10h. First, there is a new perfctr
msr range for up to 6 counters. Northbridge counters are separate
now. This patch only adds support for core counters. Second, certain
events may only be scheduled on certain counters. For this we need to
extend the event scheduling and constraints.

This patch implements table lookups for pmc/msr mappings that can be
reused for other models. I have chosen this approach in favor of
calculating the addresses from the index because it is more flexible,
esp. for later addition of northbridge counters which resides in
another msr range.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c     |   12 ++-
 arch/x86/kernel/cpu/perf_event_amd.c |  189 +++++++++++++++++++++++++++++++++-
 2 files changed, 198 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3161943..08643da 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -202,8 +202,10 @@ struct x86_pmu {
 	void		(*disable)(struct perf_event *);
 	int		(*hw_config)(struct perf_event *event);
 	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
-	unsigned	eventsel;
-	unsigned	perfctr;
+	unsigned int	eventsel;
+	unsigned int	perfctr;
+	unsigned int	*eventsel_map;
+	unsigned int	*perfctr_map;
 	u64		(*event_map)(int);
 	int		max_events;
 	int		num_counters;
@@ -323,11 +325,17 @@ again:
 
 static inline unsigned int x86_pmu_config_addr(int index)
 {
+	if (x86_pmu.eventsel_map)
+		return x86_pmu.eventsel_map[index];
+
 	return x86_pmu.eventsel + index;
 }
 
 static inline unsigned int x86_pmu_event_addr(int index)
 {
+	if (x86_pmu.perfctr_map)
+		return x86_pmu.perfctr_map[index];
+
 	return x86_pmu.perfctr + index;
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 67e2202..8c233c4 100644
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
@@ -385,13 +390,195 @@ static __initconst const struct x86_pmu amd_pmu = {
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
+ * AMD family 15h PMC/MSR address mapping:
+ */
+
+unsigned int eventsel_f15h[] = {
+	MSR_F15H_PERF_CTL,
+	MSR_F15H_PERF_CTL + 2,
+	MSR_F15H_PERF_CTL + 4,
+	MSR_F15H_PERF_CTL + 6,
+	MSR_F15H_PERF_CTL + 8,
+	MSR_F15H_PERF_CTL + 10,
+};
+
+unsigned int perfctr_f15h[] = {
+	MSR_F15H_PERF_CTR,
+	MSR_F15H_PERF_CTR + 2,
+	MSR_F15H_PERF_CTR + 4,
+	MSR_F15H_PERF_CTR + 6,
+	MSR_F15H_PERF_CTR + 8,
+	MSR_F15H_PERF_CTR + 10,
+};
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
+	.eventsel_map		= eventsel_f15h,
+	.perfctr_map		= perfctr_f15h,
+	.event_map		= amd_pmu_event_map,
+	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
+	.num_counters		= ARRAY_SIZE(eventsel_f15h),
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
+	switch (boot_cpu_data.x86) {
+	case 0x15:
+		x86_pmu = amd_pmu_f15h;
+		break;
+	default:
+		x86_pmu = amd_pmu;
+		break;
+	}
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
-- 
1.7.3.4


