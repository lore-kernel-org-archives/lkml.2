Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2KJB2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:28:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:14144 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab2KJB17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:27:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="166588281"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/32] perf, x86: Support the TSX intx/intx_cp qualifiers v2
Date: Fri,  9 Nov 2012 17:27:20 -0800
Message-Id: <1352510868-7911-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
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
v2: Moved bad hunk. Forbid some bad combinations.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   61 ++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 634f639..44e18c02 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 
+#include <asm/cpufeature.h>
 #include <asm/hardirq.h>
 #include <asm/apic.h>
 
@@ -1597,6 +1598,44 @@ static void core_pmu_enable_all(int added)
 	}
 }
 
+static int hsw_hw_config(struct perf_event *event)
+{
+	int ret = intel_pmu_hw_config(event);
+
+	if (ret)
+		return ret;
+	if (!boot_cpu_has(X86_FEATURE_RTM) && !boot_cpu_has(X86_FEATURE_HLE))
+		return 0;
+	event->hw.config |= event->attr.config & (HSW_INTX|HSW_INTX_CHECKPOINTED);
+
+	/* 
+	 * INTX/INTX-CP do not play well with PEBS or ANY thread mode.
+	 */
+	if ((event->hw.config & (HSW_INTX|HSW_INTX_CHECKPOINTED)) &&
+	     ((event->hw.config & ARCH_PERFMON_EVENTSEL_ANY) ||
+	      event->attr.precise_ip > 0))
+		return -EIO;
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
 PMU_FORMAT_ATTR(event,	"config:0-7"	);
 PMU_FORMAT_ATTR(umask,	"config:8-15"	);
 PMU_FORMAT_ATTR(edge,	"config:18"	);
@@ -1604,6 +1643,8 @@ PMU_FORMAT_ATTR(pc,	"config:19"	);
 PMU_FORMAT_ATTR(any,	"config:21"	); /* v3 + */
 PMU_FORMAT_ATTR(inv,	"config:23"	);
 PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+PMU_FORMAT_ATTR(intx,	"config:32"	);
+PMU_FORMAT_ATTR(intx_cp,"config:33"	);
 
 static struct attribute *intel_arch_formats_attr[] = {
 	&format_attr_event.attr,
@@ -1761,6 +1802,23 @@ static struct attribute *intel_arch3_formats_attr[] = {
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
@@ -2135,6 +2193,9 @@ __init int intel_pmu_init(void)
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
 
+		x86_pmu.hw_config = hsw_hw_config;
+		x86_pmu.get_event_constraints = hsw_get_event_constraints;
+		x86_pmu.format_attrs = intel_hsw_formats_attr;
 		pr_cont("Haswell events, ");
 		break;
 
-- 
1.7.7.6

