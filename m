Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1IGQlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:41:19 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:17656
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860Ab1IGQlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:41:14 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LR5VN3-02-27J-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/7] perf, x86: Implement IBS event configuration
Date: Wed, 7 Sep 2011 18:36:12 +0200
Message-ID: <1315413376-769-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1315413376-769-1-git-send-email-robert.richter@amd.com>
References: <1315413376-769-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements perf configuration for AMD IBS. The IBS pmu is
selected using the type attribute in sysfs. There are two types of ibs
pmus, for instruction fetch (IBS_FETCH) and for instruction execution
(IBS_OP):

 /sys/bus/event_source/devices/ibs_fetch/type
 /sys/bus/event_source/devices/ibs_op/type

Except for the sample period IBS can only be set up with raw config
values and raw data samples. The event attributes for the syscall
should be programmed like this (IBS_FETCH):

        type = get_pmu_type("/sys/bus/event_source/devices/ibs_fetch/type");

        memset(&attr, 0, sizeof(attr));
        attr.type        = type;
        attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
        attr.config      = IBS_FETCH_CONFIG_DEFAULT;

This implementation does not yet support 64 bit counters. It is
limited to the hardware counter bit width which is 20 bits. 64 bit
support can be added later.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   88 +++++++++++++++++++++++++++---
 1 files changed, 81 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 1ae5154..3b477ad 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -14,12 +14,67 @@ static u32 ibs_caps;
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
 
-static struct pmu perf_ibs;
+#define IBS_FETCH_CONFIG_MASK	(IBS_FETCH_RAND_EN | IBS_FETCH_MAX_CNT)
+#define IBS_OP_CONFIG_MASK	IBS_OP_MAX_CNT
+
+struct perf_ibs {
+	struct pmu	pmu;
+	unsigned int	msr;
+	u64		config_mask;
+	u64		cnt_mask;
+	u64		enable_mask;
+};
+
+static struct perf_ibs perf_ibs_fetch;
+static struct perf_ibs perf_ibs_op;
+
+static struct perf_ibs *get_ibs_pmu(int type)
+{
+	if (perf_ibs_fetch.pmu.type == type)
+		return &perf_ibs_fetch;
+	if (perf_ibs_op.pmu.type == type)
+		return &perf_ibs_op;
+	return NULL;
+}
 
 static int perf_ibs_init(struct perf_event *event)
 {
-	if (perf_ibs.type != event->attr.type)
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_ibs *perf_ibs;
+	u64 max_cnt, config;
+
+	perf_ibs = get_ibs_pmu(event->attr.type);
+	if (!perf_ibs)
 		return -ENOENT;
+
+	config = event->attr.config;
+	if (config & ~perf_ibs->config_mask)
+		return -EINVAL;
+
+	if (hwc->sample_period) {
+		if (config & perf_ibs->cnt_mask)
+			/* raw max_cnt may not be set */
+			return -EINVAL;
+		if (hwc->sample_period & 0x0f)
+			/* lower 4 bits can not be set in ibs max cnt */
+			return -EINVAL;
+		max_cnt = hwc->sample_period >> 4;
+		if (max_cnt & ~perf_ibs->cnt_mask)
+			/* out of range */
+			return -EINVAL;
+		config |= max_cnt;
+	} else {
+		max_cnt = config & perf_ibs->cnt_mask;
+		event->attr.sample_period = max_cnt << 4;
+		hwc->sample_period = event->attr.sample_period;
+	}
+
+	if (!max_cnt)
+		return -EINVAL;
+
+	hwc->config_base = perf_ibs->msr;
+	hwc->config = config;
+
 	return 0;
 }
 
@@ -32,10 +87,28 @@ static void perf_ibs_del(struct perf_event *event, int flags)
 {
 }
 
-static struct pmu perf_ibs = {
-	.event_init= perf_ibs_init,
-	.add= perf_ibs_add,
-	.del= perf_ibs_del,
+static struct perf_ibs perf_ibs_fetch = {
+	.pmu = {
+		.event_init	= perf_ibs_init,
+		.add		= perf_ibs_add,
+		.del		= perf_ibs_del,
+	},
+	.msr			= MSR_AMD64_IBSFETCHCTL,
+	.config_mask		= IBS_FETCH_CONFIG_MASK,
+	.cnt_mask		= IBS_FETCH_MAX_CNT,
+	.enable_mask		= IBS_FETCH_ENABLE,
+};
+
+static struct perf_ibs perf_ibs_op = {
+	.pmu = {
+		.event_init	= perf_ibs_init,
+		.add		= perf_ibs_add,
+		.del		= perf_ibs_del,
+	},
+	.msr			= MSR_AMD64_IBSOPCTL,
+	.config_mask		= IBS_OP_CONFIG_MASK,
+	.cnt_mask		= IBS_OP_MAX_CNT,
+	.enable_mask		= IBS_OP_ENABLE,
 };
 
 static __init int perf_event_ibs_init(void)
@@ -43,7 +116,8 @@ static __init int perf_event_ibs_init(void)
 	if (!ibs_caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
-	perf_pmu_register(&perf_ibs, "ibs", -1);
+	perf_pmu_register(&perf_ibs_fetch.pmu, "ibs_fetch", -1);
+	perf_pmu_register(&perf_ibs_op.pmu, "ibs_op", -1);
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", ibs_caps);
 
 	return 0;
-- 
1.7.6.1


