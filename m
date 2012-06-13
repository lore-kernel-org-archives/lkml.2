Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2FMTUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:20:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:60928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab2FMTUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:20:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="111804101"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] perf, x86: Add basic Ivy Bridge support v3
Date: Wed, 13 Jun 2012 12:20:00 -0700
Message-Id: <1339615201-7456-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Very similar to Sandy Bridge, but there is no PEBS problem.

As Stephane pointed out .code=0xb1, .umask=0x01 is gone, so don't
do a generic backend stall event on IvyBridge.

v2: Remove stall event
v3: Fork init code from Sandy Bridge
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 187c294..abb29c2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1911,7 +1911,6 @@ __init int intel_pmu_init(void)
 	case 42: /* SandyBridge */
 	case 45: /* SandyBridge, "Romely-EP" */
 		x86_add_quirk(intel_sandybridge_quirk);
-	case 58: /* IvyBridge */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -1928,11 +1927,31 @@ __init int intel_pmu_init(void)
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
+		pr_cont("SandyBridge events, ");
+		break;
+
+	case 58: /* IvyBridge */
 		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
 			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
 
-		pr_cont("SandyBridge events, ");
+		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
+
+		intel_pmu_lbr_init_snb();
+
+		x86_pmu.event_constraints = intel_snb_event_constraints;
+		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
+		x86_pmu.extra_regs = intel_snb_extra_regs;
+		/* all extra regs are per-cpu when HT is on */
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+
+		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
+			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
+		/* No backend stall event */
+		pr_cont("IvyBridge events, ");
 		break;
 
 	default:
-- 
1.7.7.6

