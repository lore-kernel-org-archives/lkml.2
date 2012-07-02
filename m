Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab2GBUlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:41:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:26476 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab2GBUku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:40:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163260505"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: x86@kernel.org, eranian@google.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/5] perf, x86: Improve basic Ivy Bridge support v4
Date: Mon,  2 Jul 2012 13:40:42 -0700
Message-Id: <1341261646-3171-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341261646-3171-1-git-send-email-andi@firstfloor.org>
References: <1341261646-3171-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Fork the IvyBridge support from the Sandy Bridge support to enable
some ivy specific features.

Very similar to Sandy Bridge, but:
- there is no PEBS problem.
- more changes in the next patch

v2: Remove stall event (Stephane)
v3: rebase to new code. completely separate switch case statement as shared
code was deemed obfuscated.
v4: Readd stall event to make Peter happy (Peter)
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e23e71f..f060dd5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1913,7 +1913,6 @@ __init int intel_pmu_init(void)
 	case 42: /* SandyBridge */
 	case 45: /* SandyBridge, "Romely-EP" */
 		x86_add_quirk(intel_sandybridge_quirk);
-	case 58: /* IvyBridge */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -1937,6 +1936,32 @@ __init int intel_pmu_init(void)
 		pr_cont("SandyBridge events, ");
 		break;
 
+	case 58: /* IvyBridge */
+		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
+
+		intel_pmu_lbr_init_snb();
+
+		x86_pmu.event_constraints = intel_snb_event_constraints;
+		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
+		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
+		x86_pmu.extra_regs = intel_snb_extra_regs;
+		/* all extra regs are per-cpu when HT is on */
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+
+		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
+			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
+	      	/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
+			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
+
+		x86_pmu.hw_config = pdir_hw_config;
+
+		pr_cont("IvyBridge events, ");
+		break;
+
 	default:
 		switch (x86_pmu.version) {
 		case 1:
-- 
1.7.7.6

