Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2FMUVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:21:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:54723 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab2FMUUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:20:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="111821410"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, eranian@google.com, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/4] perf, x86: check ucode before disabling PEBS on SandyBridge v3
Date: Wed, 13 Jun 2012 13:20:41 -0700
Message-Id: <1339618842-26636-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

[AK: Updated version of Stephane's patch, now using the new global
tracking microcode number and with the correct microcode revision
for SandyBridge-E*. Also use pr_warn_once and checkpatch fixes.]

This patch checks the microcode version before disabling
PEBS on SandyBridge model 42 (desktop, mobile), and 45 (SNB-EP).
PEBS was disabled for both models due to an erratum.

A workaround is implemented by micro-code 0x28. This patch checks
the microcode version and disables PEBS support if version < 0x28.
The check is done each time a PEBS event is created and NOT at boot
time because the micro-code update may only be done after the kernel
has booted.

Go to downloadcenter.intel.com to download microcode updates.
Need microcode update 6/6/2012 or later.

v2: Was Stephane's old revision
v3: Use boot_cpu_data.microcode (H. Peter Anvin)
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   37 +++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 187c294..102d153 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -13,6 +13,7 @@
 
 #include <asm/hardirq.h>
 #include <asm/apic.h>
+#include <asm/processor.h>
 
 #include "perf_event.h"
 
@@ -1392,6 +1393,25 @@ static void intel_pebs_aliases_snb(struct perf_event *event)
 	}
 }
 
+static int check_pebs_quirks(void)
+{
+	int model = cpu_data(smp_processor_id()).x86_model;
+
+	/* do not have PEBS to begin with */
+	if (!x86_pmu.pebs)
+		return 0;
+
+	/*
+	 * check ucode version for SNB, SNB-EP
+	 */
+	if ((model == 42 && boot_cpu_data.microcode < 0x28) ||
+		(model == 45 && boot_cpu_data.microcode < 0x618)) {
+		pr_warn_once("SandyBridge PEBS unavailable due to CPU erratum, update microcode\n");
+		return -ENOTSUPP;
+	}
+	return 0;
+}
+
 static int intel_pmu_hw_config(struct perf_event *event)
 {
 	int ret = x86_pmu_hw_config(event);
@@ -1399,8 +1419,13 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
-	if (event->attr.precise_ip && x86_pmu.pebs_aliases)
-		x86_pmu.pebs_aliases(event);
+	if (event->attr.precise_ip) {
+		if (check_pebs_quirks())
+			return -ENOTSUPP;
+
+		if (x86_pmu.pebs_aliases)
+			x86_pmu.pebs_aliases(event);
+	}
 
 	if (intel_pmu_needs_lbr_smpl(event)) {
 		ret = intel_pmu_setup_lbr_filter(event);
@@ -1712,13 +1737,6 @@ static __init void intel_clovertown_quirk(void)
 	x86_pmu.pebs_constraints = NULL;
 }
 
-static __init void intel_sandybridge_quirk(void)
-{
-	printk(KERN_WARNING "PEBS disabled due to CPU errata.\n");
-	x86_pmu.pebs = 0;
-	x86_pmu.pebs_constraints = NULL;
-}
-
 static const struct { int id; char *name; } intel_arch_events_map[] __initconst = {
 	{ PERF_COUNT_HW_CPU_CYCLES, "cpu cycles" },
 	{ PERF_COUNT_HW_INSTRUCTIONS, "instructions" },
@@ -1910,7 +1928,6 @@ __init int intel_pmu_init(void)
 
 	case 42: /* SandyBridge */
 	case 45: /* SandyBridge, "Romely-EP" */
-		x86_add_quirk(intel_sandybridge_quirk);
 	case 58: /* IvyBridge */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
-- 
1.7.7.6

