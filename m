Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2I1EgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:36:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:42307 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab2I1Eby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="215093227"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/31] perf, x86: Implement the :t and :c qualifiers for Haswell
Date: Thu, 27 Sep 2012 21:31:12 -0700
Message-Id: <1348806696-31170-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Implement the TSX transaction and checkpointed transaction qualifiers for
Haswell. This allows e.g. to profile the number of cycles in transactions.
The checkpointed qualifier requires forcing the event to
counter 2, implement this with a custom constraint for Haswell.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   38 +++++++++++++++++++++++++++++++-
 1 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 695abd1..7dab353 100644
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
@@ -1614,6 +1616,38 @@ static struct attribute *intel_arch_formats_attr[] = {
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
+	if (event->attr.intx)
+		event->hw.config |= HSW_INTX;
+	if (event->attr.intx_checkpointed)
+		event->hw.config |= HSW_INTX_CHECKPOINTED;
+	return 0;
+}
+
+static struct event_constraint counter2_constraint = EVENT_CONSTRAINT(0, 0x4, 0);
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
@@ -2100,6 +2134,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
 
+		x86_pmu.hw_config = hsw_hw_config;
+		x86_pmu.get_event_constraints = hsw_get_event_constraints;
 		pr_cont("Haswell events, ");
 		break;
 
-- 
1.7.7.6

