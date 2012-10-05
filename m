Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab2JEND7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 09:03:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34668 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2JEND6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 09:03:58 -0400
Date: Fri, 5 Oct 2012 06:03:43 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-2e132b12f78d88672711ae1d87624951de1089ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1347447584-28405-1-git-send-email-robert.richter@amd.com>
References: <1347447584-28405-1-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/AMD/IBS: Add sysfs support
Git-Commit-ID: 2e132b12f78d88672711ae1d87624951de1089ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 06:03:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e132b12f78d88672711ae1d87624951de1089ca
Gitweb:     http://git.kernel.org/tip/2e132b12f78d88672711ae1d87624951de1089ca
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 12 Sep 2012 12:59:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 5 Oct 2012 13:57:47 +0200

perf/AMD/IBS: Add sysfs support

Add sysfs format entries for AMD IBS PMUs:

 # find /sys/bus/event_source/devices/ibs_*/format
 /sys/bus/event_source/devices/ibs_fetch/format
 /sys/bus/event_source/devices/ibs_fetch/format/rand_en
 /sys/bus/event_source/devices/ibs_op/format
 /sys/bus/event_source/devices/ibs_op/format/cnt_ctl

This allows to specify following IBS options:

 $ perf record -e ibs_fetch/rand_en=1/GH ...
 $ perf record -e ibs_op/cnt_ctl=1/GH ...

Option cnt_ctl is only enabled if the IBS_CAPS_OPCNT bit is set in IBS
cpuid feature flags (AMD family 10h RevC and above).

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347447584-28405-1-git-send-email-robert.richter@amd.com
[ Added small readability improvements. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   61 ++++++++++++++++++++++++------
 1 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index eebd5ff..6336bcb 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -41,17 +41,22 @@ struct cpu_perf_ibs {
 };
 
 struct perf_ibs {
-	struct pmu	pmu;
-	unsigned int	msr;
-	u64		config_mask;
-	u64		cnt_mask;
-	u64		enable_mask;
-	u64		valid_mask;
-	u64		max_period;
-	unsigned long	offset_mask[1];
-	int		offset_max;
-	struct cpu_perf_ibs __percpu *pcpu;
-	u64		(*get_count)(u64 config);
+	struct pmu			pmu;
+	unsigned int			msr;
+	u64				config_mask;
+	u64				cnt_mask;
+	u64				enable_mask;
+	u64				valid_mask;
+	u64				max_period;
+	unsigned long			offset_mask[1];
+	int				offset_max;
+	struct cpu_perf_ibs __percpu	*pcpu;
+
+	struct attribute		**format_attrs;
+	struct attribute_group		format_group;
+	const struct attribute_group	*attr_groups[2];
+
+	u64				(*get_count)(u64 config);
 };
 
 struct perf_ibs_data {
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
@@ -597,6 +617,17 @@ static __init int perf_ibs_pmu_init(struct perf_ibs *perf_ibs, char *name)
 
 	perf_ibs->pcpu = pcpu;
 
+	/* register attributes */
+	if (perf_ibs->format_attrs[0]) {
+		memset(&perf_ibs->format_group, 0, sizeof(perf_ibs->format_group));
+		perf_ibs->format_group.name	= "format";
+		perf_ibs->format_group.attrs	= perf_ibs->format_attrs;
+
+		memset(&perf_ibs->attr_groups, 0, sizeof(perf_ibs->attr_groups));
+		perf_ibs->attr_groups[0]	= &perf_ibs->format_group;
+		perf_ibs->pmu.attr_groups	= perf_ibs->attr_groups;
+	}
+
 	ret = perf_pmu_register(&perf_ibs->pmu, name, -1);
 	if (ret) {
 		perf_ibs->pcpu = NULL;
@@ -608,13 +639,19 @@ static __init int perf_ibs_pmu_init(struct perf_ibs *perf_ibs, char *name)
 
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
 
