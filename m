Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab1G1Nuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:50:54 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:54859
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755546Ab1G1Num (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:50:42 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP1QGC-01-3TZ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/7] perf, x86: Implement IBS event configuration
Date: Thu, 28 Jul 2011 15:46:48 +0200
Message-ID: <1311860812-28748-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
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
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   99 ++++++++++++++++++++++++++----
 1 files changed, 87 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index cae9528..bd77209 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -12,34 +12,108 @@
 
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
 	pr_info("Found event %p (config=%016llx) for pmu %s (type=%d) on cpu %d\n",
-		event, event->attr.config, perf_ibs.name, event->attr.type, event->oncpu);
+		event, event->attr.config, event->pmu->name, event->attr.type, event->oncpu);
+
 	return 0;
 }
 
 static int perf_ibs_add(struct perf_event *event, int flags)
 {
-	pr_info("Adding event %p (config=%016llx) to pmu %s (type=%d) on cpu %d\n",
-		event, event->attr.config, perf_ibs.name, event->attr.type, event->oncpu);
+	pr_info("Adding event %p (config=%016llx) for pmu %p (name='%s', type=%d) on cpu %d\n",
+		event, event->attr.config, event->pmu, event->pmu->name, event->attr.type, event->oncpu);
 	return 0;
 }
 
 static void perf_ibs_del(struct perf_event *event, int flags)
 {
-	pr_info("Removing event %p (config=%016llx) to pmu %s (type=%d) on cpu %d\n",
-		event, event->attr.config, perf_ibs.name, event->attr.type, event->oncpu);
+	pr_info("Removing event %p (config=%016llx) for pmu %p (name='%s', type=%d) on cpu %d\n",
+		event, event->attr.config, event->pmu, event->pmu->name, event->attr.type, event->oncpu);
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
@@ -50,7 +124,8 @@ static __init int perf_event_ibs_init(void)
 	if (!caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
-	perf_pmu_register(&perf_ibs, "ibs", -1);
+	perf_pmu_register(&perf_ibs_fetch.pmu, "ibs_fetch", -1);
+	perf_pmu_register(&perf_ibs_op.pmu, "ibs_op", -1);
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", caps);
 
 	return 0;
-- 
1.7.5.3


