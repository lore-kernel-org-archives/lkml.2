Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2GBSnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:43:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:53665 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab2GBSnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:43:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172626617"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/5] perf, x86: check ucode before disabling PEBS on SandyBridge v4
Date: Mon,  2 Jul 2012 11:43:17 -0700
Message-Id: <1341254598-1379-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
References: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

[AK: Updated version of Stephane's patch with various changes.
This version now relies on the global microcode update that
has been implemented in another patch. It also assumes that
the BIOS puts the same microcode version on every CPU.]

This patch checks the microcode version before disabling
PEBS on SandyBridge model 42 (desktop, mobile), and 45 (SNB-EP).
PEBS was disabled for both models due to an erratum.

A workaround is implemented by micro-code specific to different models.
This patch checks the microcode version and disables PEBS support
only if the needed fixes are not available.

The check is done each time a PEBS event is created and NOT at boot
time because the micro-code update may only be done after the kernel
has booted.

Go to downloadcenter.intel.com to download microcode updates.
Need microcode update 6/6/2012 or later.

v2: Was Stephane's old revision
v3: Use boot_cpu_data.microcode (H. Peter Anvin)
v4: Various updates. Now improved model check that handles both
C1 and C2 steppings.
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   41 ++++++++++++++++++++++++-------
 1 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e09a4ad..b255da3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -13,6 +13,7 @@
 
 #include <asm/hardirq.h>
 #include <asm/apic.h>
+#include <asm/processor.h>
 
 #include "perf_event.h"
 
@@ -1392,6 +1393,29 @@ static void intel_pebs_aliases_snb(struct perf_event *event)
 	}
 }
 
+static int check_pebs_quirks(void)
+{
+	/* With different CPUs boot_cpu_data ucode will be 0 */
+	int model = boot_cpu_data.x86_model;
+	int ucode = boot_cpu_data.microcode;
+	int stepping = boot_cpu_data.x86_mask;
+
+	/* do not have PEBS to begin with */
+	if (!x86_pmu.pebs)
+		return 0;
+
+	/*
+	 * check ucode version for SNB, SNB-EP
+	 */
+	if ((model == 42 && ucode < 0x28) ||
+		(model == 45 && ucode < 0x70c) ||
+		(model == 45 && stepping == 6 && ucode < 0x618)) {
+		pr_warn_once("SandyBridge PEBS unavailable due to CPU erratum, update microcode\n");
+		return -ENOTSUPP;
+	}
+	return 0;
+}
+
 static int intel_pmu_hw_config(struct perf_event *event)
 {
 	int ret = x86_pmu_hw_config(event);
@@ -1399,8 +1423,13 @@ static int intel_pmu_hw_config(struct perf_event *event)
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
@@ -1735,13 +1764,6 @@ static __init void intel_clovertown_quirk(void)
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
@@ -1935,7 +1957,6 @@ __init int intel_pmu_init(void)
 
 	case 42: /* SandyBridge */
 	case 45: /* SandyBridge, "Romely-EP" */
-		x86_add_quirk(intel_sandybridge_quirk);
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
-- 
1.7.7.6

