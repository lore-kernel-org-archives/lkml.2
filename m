Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab2JBXxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:53:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:47790 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab2JBXtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:49:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,525,1344236400"; 
   d="scan'208";a="200845774"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, x86@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/31] perf, x86: Support the TSX intx/intx_cp qualifiers
Date: Tue,  2 Oct 2012 16:48:24 -0700
Message-Id: <1349221731-15665-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Implement the TSX transaction and checkpointed transaction qualifiers for
Haswell. This allows e.g. to profile the number of cycles in transactions.

The checkpointed qualifier requires forcing the event to
counter 2, implement this with a custom constraint for Haswell.

Also add sysfs format attributes for intx/intx_cp

[Updated from earlier version that used generic attributes, now does
raw + sysfs formats]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   56 +++++++++++++++++++++++++++++++-
 1 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index ea06a4b..bd50116 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 
+#include <asm/cpufeature.h>
 #include <asm/hardirq.h>
 #include <asm/apic.h>
 
@@ -826,7 +827,8 @@ static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
 		return true;
 
 	/* implicit branch sampling to correct PEBS skid */
-	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
+	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1 &&
+	    x86_pmu.intel_cap.pebs_format < 2)
 		return true;
 
 	return false;
@@ -1603,6 +1605,8 @@ PMU_FORMAT_ATTR(pc,	"config:19"	);
 PMU_FORMAT_ATTR(any,	"config:21"	); /* v3 + */
 PMU_FORMAT_ATTR(inv,	"config:23"	);
 PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+PMU_FORMAT_ATTR(intx,	"config:32"	);
+PMU_FORMAT_ATTR(intx_cp,"config:33"	);
 
 static struct attribute *intel_arch_formats_attr[] = {
 	&format_attr_event.attr,
@@ -1614,6 +1618,36 @@ static struct attribute *intel_arch_formats_attr[] = {
 	NULL,
 };
 
+static int hsw_hw_config(struct perf_event *event)
+{
+	int ret = intel_pmu_hw_config(event);
+
+	if (ret)
+		return ret;
+	if (!boot_cpu_has(X86_FEATURE_RTM) && !boot_cpu_has(X86_FEATURE_HLE))
+		return 0;
+	event->hw.config |= event->attr.config & (HSW_INTX|HSW_INTX_CHECKPOINTED);
+	return 0;
+}
+
+static struct event_constraint counter2_constraint = 
+			EVENT_CONSTRAINT(0, 0x4, 0);
+
+static struct event_constraint *
+hsw_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct event_constraint *c = intel_get_event_constraints(cpuc, event);
+
+	/* Handle special quirk on intx_checkpointed only in counter 2 */
+	if (event->hw.config & HSW_INTX_CHECKPOINTED) {
+		if (c->idxmsk64 & (1U << 2))
+			return &counter2_constraint;
+		return &emptyconstraint;
+	}
+
+	return c;
+}
+
 static __initconst const struct x86_pmu core_pmu = {
 	.name			= "core",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -1752,6 +1786,23 @@ static struct attribute *intel_arch3_formats_attr[] = {
 	NULL,
 };
 
+/* Arch3 + TSX support */
+static struct attribute *intel_hsw_formats_attr[] __read_mostly = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_pc.attr,
+	&format_attr_any.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	&format_attr_intx.attr,
+	&format_attr_intx_cp.attr,
+
+	&format_attr_offcore_rsp.attr, /* XXX do NHM/WSM + SNB breakout */
+	NULL,
+};
+
+
 static __initconst const struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
@@ -2122,6 +2173,9 @@ __init int intel_pmu_init(void)
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
 
+		x86_pmu.hw_config = hsw_hw_config;
+		x86_pmu.get_event_constraints = hsw_get_event_constraints;
+		x86_pmu.format_attrs = intel_hsw_formats_attr;
 		pr_cont("Haswell events, ");
 		break;
 
-- 
1.7.7.6

