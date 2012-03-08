Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab2CHMXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 07:23:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51652 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2CHMXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 07:23:14 -0500
Date: Thu, 8 Mar 2012 04:22:20 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-510419435c6948fb32959d691bf84eaba41ca474@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, robert.richter@amd.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323968199-9326-2-git-send-email-robert.richter@amd.com>
References: <1323968199-9326-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/x86-ibs] perf/x86: Implement IBS event configuration
Git-Commit-ID: 510419435c6948fb32959d691bf84eaba41ca474
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 08 Mar 2012 04:22:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  510419435c6948fb32959d691bf84eaba41ca474
Gitweb:     http://git.kernel.org/tip/510419435c6948fb32959d691bf84eaba41ca474
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 15 Dec 2011 17:56:36 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Mar 2012 11:35:21 +0100

perf/x86: Implement IBS event configuration

This patch implements perf configuration for AMD IBS. The IBS
pmu is selected using the type attribute in sysfs. There are two
types of ibs pmus, for instruction fetch (IBS_FETCH) and for
instruction execution (IBS_OP):

 /sys/bus/event_source/devices/ibs_fetch/type
 /sys/bus/event_source/devices/ibs_op/type

Except for the sample period IBS can only be set up with raw
config values and raw data samples. The event attributes for the
syscall should be programmed like this (IBS_FETCH):

        type = get_pmu_type("/sys/bus/event_source/devices/ibs_fetch/type");

        memset(&attr, 0, sizeof(attr));
        attr.type        = type;
        attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
        attr.config      = IBS_FETCH_CONFIG_DEFAULT;

This implementation does not yet support 64 bit counters. It is
limited to the hardware counter bit width which is 20 bits. 64
bit support can be added later.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1323968199-9326-2-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   92 +++++++++++++++++++++++++++--
 1 files changed, 85 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 3b8a2d3..36684eb 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -16,12 +16,67 @@ static u32 ibs_caps;
 
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
 
@@ -34,10 +89,32 @@ static void perf_ibs_del(struct perf_event *event, int flags)
 {
 }
 
-static struct pmu perf_ibs = {
-	.event_init= perf_ibs_init,
-	.add= perf_ibs_add,
-	.del= perf_ibs_del,
+static struct perf_ibs perf_ibs_fetch = {
+	.pmu = {
+		.task_ctx_nr	= perf_invalid_context,
+
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
+		.task_ctx_nr	= perf_invalid_context,
+
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
@@ -45,7 +122,8 @@ static __init int perf_event_ibs_init(void)
 	if (!ibs_caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
-	perf_pmu_register(&perf_ibs, "ibs", -1);
+	perf_pmu_register(&perf_ibs_fetch.pmu, "ibs_fetch", -1);
+	perf_pmu_register(&perf_ibs_op.pmu, "ibs_op", -1);
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", ibs_caps);
 
 	return 0;
