Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab2FGXTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:19:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:9289 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758223Ab2FGXTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:19:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162573349"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] perf, x86: Add basic Ivy Bridge support v2
Date: Thu,  7 Jun 2012 16:18:56 -0700
Message-Id: <1339111137-7329-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Very similar to Sandy Bridge, but there is no PEBS problem.

As Stephane pointed out .code=0xb1, .umask=0x01 is gone, so don't
do a generic backend stall event on IvyBridge.

v2: Remove stall event
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 166546e..0f58590 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1698,6 +1698,7 @@ __init int intel_pmu_init(void)
 	union cpuid10_ebx ebx;
 	unsigned int unused;
 	int version;
+	char *name;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 		switch (boot_cpu_data.x86) {
@@ -1839,9 +1840,21 @@ __init int intel_pmu_init(void)
 		pr_cont("Westmere events, ");
 		break;
 
+	case 58: /* IvyBridge */
+		name = "Ivy";
+		/* No backend stall event */
+		goto snb_ivb_common;
+
 	case 42: /* SandyBridge */
 		x86_add_quirk(intel_sandybridge_quirk);
 	case 45: /* SandyBridge, "Romely-EP" */
+		name = "Sandy";
+
+		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
+			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
+
+	snb_ivb_common:
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -1857,11 +1870,7 @@ __init int intel_pmu_init(void)
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
-		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
-		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
-			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
-
-		pr_cont("SandyBridge events, ");
+		pr_cont("%sBridge events, ", name);
 		break;
 
 	default:
-- 
1.7.7.6

