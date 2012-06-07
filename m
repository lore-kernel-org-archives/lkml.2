Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2FGHPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 03:15:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54106 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2FGHPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 03:15:41 -0400
Date: Thu, 7 Jun 2012 09:15:31 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com
Subject: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
Message-ID: <20120607071531.GA4849@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
    
Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 5ec146c..9c905bd 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1394,6 +1394,27 @@ static void intel_pebs_aliases_snb(struct perf_event *event)
 	}
 }
 
+static int check_pebs_quirks(void)
+{
+	int uversion = cpu_data(smp_processor_id()).microcode;
+	int model = cpu_data(smp_processor_id()).x86_model;
+
+	/* do not have PEBS to begin with */
+	if (!x86_pmu.pebs)
+		return 0;
+
+	/*
+	 * check ucode version for SNB, SNB-EP
+	 */
+	if ((model == 42 || model == 45) && uversion < 0x28) {
+		pr_warn("SandyBridge PEBS unavailable due to CPU erratum, "
+			" update microcode (was 0x%x, needs at least 0x28).\n",
+			uversion);
+		return -ENOTSUPP;
+	}
+	return 0;
+}
+
 static int intel_pmu_hw_config(struct perf_event *event)
 {
 	int ret = x86_pmu_hw_config(event);
@@ -1401,8 +1422,14 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
-	if (event->attr.precise_ip && x86_pmu.pebs_aliases)
-		x86_pmu.pebs_aliases(event);
+	if (event->attr.precise_ip) {
+
+		if (check_pebs_quirks())
+			return -ENOTSUPP;
+
+		if (x86_pmu.pebs_aliases)
+			x86_pmu.pebs_aliases(event);
+	}
 
 	if (intel_pmu_needs_lbr_smpl(event)) {
 		ret = intel_pmu_setup_lbr_filter(event);
@@ -1714,13 +1741,6 @@ static __init void intel_clovertown_quirk(void)
 	x86_pmu.pebs_constraints = NULL;
 }
 
-static __init void intel_sandybridge_quirk(void)
-{
-	pr_warn("PEBS disabled due to CPU errata\n");
-	x86_pmu.pebs = 0;
-	x86_pmu.pebs_constraints = NULL;
-}
-
 static const struct { int id; char *name; } intel_arch_events_map[] __initconst = {
 	{ PERF_COUNT_HW_CPU_CYCLES, "cpu cycles" },
 	{ PERF_COUNT_HW_INSTRUCTIONS, "instructions" },
@@ -1914,7 +1934,6 @@ __init int intel_pmu_init(void)
 
 	case 42: /* SandyBridge */
 	case 45: /* SandyBridge, "Romely-EP" */
-		x86_add_quirk(intel_sandybridge_quirk);
 	case 58: /* IvyBridge */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
