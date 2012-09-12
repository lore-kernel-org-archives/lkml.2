Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab2ILLBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:01:15 -0400
Received: from [216.32.180.186] ([216.32.180.186]:32473 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757802Ab2ILLBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:01:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275bh84d07hz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12bdh1155h)
X-WSS-ID: 0MA8H7V-01-3B2-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH] perf, ibs: Add sysfs support
Date: Wed, 12 Sep 2012 12:59:44 +0200
Message-ID: <1347447584-28405-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysfs format entries for ibs pmus:

 # find /sys/bus/event_source/devices/ibs_*/format
 /sys/bus/event_source/devices/ibs_fetch/format
 /sys/bus/event_source/devices/ibs_fetch/format/rand_en
 /sys/bus/event_source/devices/ibs_op/format
 /sys/bus/event_source/devices/ibs_op/format/cnt_ctl

This allows to specify following ibs options:

 $ perf record -e ibs_fetch/rand_en=1/GH ...
 $ perf record -e ibs_op/cnt_ctl=1/GH ...

Option cnt_ctl is only enabled if the IBS_CAPS_OPCNT bit is set in ibs
cpuid feature flags (family 10h RevC and above).

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   38 +++++++++++++++++++++++++++++-
 1 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index eebd5ff..4af8275 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -51,6 +51,11 @@ struct perf_ibs {
 	unsigned long	offset_mask[1];
 	int		offset_max;
 	struct cpu_perf_ibs __percpu *pcpu;
+
+	struct attribute **format_attrs;
+	struct attribute_group format_group;
+	const struct attribute_group *attr_groups[2];
+
 	u64		(*get_count)(u64 config);
 };
 
@@ -446,6 +451,19 @@ static void perf_ibs_del(struct perf_event *event, int flags)
 
 static void perf_ibs_read(struct perf_event *event) { }
 
+PMU_FORMAT_ATTR(rand_en,	"config:57");
+PMU_FORMAT_ATTR(cnt_ctl,	"config:19");
+
+static struct attribute *ibs_fetch_format_attrs[] = {
+	&format_attr_rand_en.attr,
+	NULL,
+};
+
+static struct attribute *ibs_op_format_attrs[] = {
+	NULL,	/* &format_attr_cnt_ctl.attr if IBS_CAPS_OPCNT */
+	NULL,
+};
+
 static struct perf_ibs perf_ibs_fetch = {
 	.pmu = {
 		.task_ctx_nr	= perf_invalid_context,
@@ -465,6 +483,7 @@ static struct perf_ibs perf_ibs_fetch = {
 	.max_period		= IBS_FETCH_MAX_CNT << 4,
 	.offset_mask		= { MSR_AMD64_IBSFETCH_REG_MASK },
 	.offset_max		= MSR_AMD64_IBSFETCH_REG_COUNT,
+	.format_attrs		= ibs_fetch_format_attrs,
 
 	.get_count		= get_ibs_fetch_count,
 };
@@ -488,6 +507,7 @@ static struct perf_ibs perf_ibs_op = {
 	.max_period		= IBS_OP_MAX_CNT << 4,
 	.offset_mask		= { MSR_AMD64_IBSOP_REG_MASK },
 	.offset_max		= MSR_AMD64_IBSOP_REG_COUNT,
+	.format_attrs		= ibs_op_format_attrs,
 
 	.get_count		= get_ibs_op_count,
 };
@@ -597,6 +617,16 @@ static __init int perf_ibs_pmu_init(struct perf_ibs *perf_ibs, char *name)
 
 	perf_ibs->pcpu = pcpu;
 
+	/* register attributes */
+	if (perf_ibs->format_attrs[0]) {
+		memset(&perf_ibs->format_group, 0, sizeof(perf_ibs->format_group));
+		perf_ibs->format_group.name = "format";
+		perf_ibs->format_group.attrs = perf_ibs->format_attrs;
+		memset(&perf_ibs->attr_groups, 0, sizeof(perf_ibs->attr_groups));
+		perf_ibs->attr_groups[0] = &perf_ibs->format_group;
+		perf_ibs->pmu.attr_groups = perf_ibs->attr_groups;
+	}
+
 	ret = perf_pmu_register(&perf_ibs->pmu, name, -1);
 	if (ret) {
 		perf_ibs->pcpu = NULL;
@@ -608,13 +638,19 @@ static __init int perf_ibs_pmu_init(struct perf_ibs *perf_ibs, char *name)
 
 static __init int perf_event_ibs_init(void)
 {
+	struct attribute **attr = ibs_op_format_attrs;
+
 	if (!ibs_caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
 	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
-	if (ibs_caps & IBS_CAPS_OPCNT)
+
+	if (ibs_caps & IBS_CAPS_OPCNT) {
 		perf_ibs_op.config_mask |= IBS_OP_CNT_CTL;
+		*attr++ = &format_attr_cnt_ctl.attr;
+	}
 	perf_ibs_pmu_init(&perf_ibs_op, "ibs_op");
+
 	register_nmi_handler(NMI_LOCAL, perf_ibs_nmi_handler, 0, "perf_ibs");
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", ibs_caps);
 
-- 
1.7.8.6


