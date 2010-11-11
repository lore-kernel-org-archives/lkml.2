Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0KKQPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 11:15:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44839 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab0KKQPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 11:15:36 -0500
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/3] perf-events: Fix LLC-* events on Intel Nehalem/Westmere
Date: Thu, 11 Nov 2010 17:15:17 +0100
Message-Id: <1289492117-18066-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The generic perf LLC-* events do count the L2 caches, not the real
L3 LLC on Intel Nehalem and Westmere. This lead to quite some confusion.

Fixing this properly requires use of the special OFFCORE_RESPONSE
events which need a separate mask register. This has been implemented
in a earlier patch.

Now use this infrastructure to set correct events for the LLC-*
on Nehalem and Westmere

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       |    7 +++++-
 arch/x86/kernel/cpu/perf_event_intel.c |   37 ++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 97133ec..3e429a1 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -299,6 +299,10 @@ static u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
+static u64 __read_mostly hw_cache_extra_regs
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
 /*
  * Propagate event elapsed time into the generic event.
@@ -455,7 +459,8 @@ set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event_attr *attr)
 		return -EINVAL;
 
 	hwc->config |= val;
-
+	hwc->extra_config =
+		hw_cache_extra_regs[cache_type][cache_op][cache_result];
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index bbe7fba..a06dae3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -215,6 +215,39 @@ static __initconst const u64 westmere_hw_cache_event_ids
  },
 };
 
+/*
+ * OFFCORE_RESPONSE MSR bits (subset), See IA32 SDM Vol 3 30.6.1.3
+ */
+
+#define DMND_DATA_RD     (1 << 0)
+#define DMND_RFO         (1 << 1)
+#define DMND_WB          (1 << 3)
+#define PF_DATA_RD       (1 << 4)
+#define PF_DATA_RFO      (1 << 5)
+#define RESP_UNCORE_HIT  (1 << 8)
+#define RESP_MISS        (0xf600) /* non uncore hit */
+
+static __initconst const u64 nehalem_hw_cache_extra_regs
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = DMND_DATA_RD|RESP_UNCORE_HIT,
+		[ C(RESULT_MISS)   ] = DMND_DATA_RD|RESP_MISS,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = DMND_RFO|DMND_WB|RESP_UNCORE_HIT,
+		[ C(RESULT_MISS)   ] = DMND_RFO|DMND_WB|RESP_MISS,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = PF_DATA_RD|PF_DATA_RFO|RESP_UNCORE_HIT,
+		[ C(RESULT_MISS)   ] = PF_DATA_RD|PF_DATA_RFO|RESP_MISS,
+	},
+ }
+};
+
 static __initconst const u64 nehalem_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -1113,6 +1146,8 @@ static __init int intel_pmu_init(void)
 	case 46: /* 45 nm nehalem-ex, "Beckton" */
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, nehalem_hw_cache_extra_regs,
+		       sizeof(hw_cache_extra_regs));
 
 		intel_pmu_lbr_init_nhm();
 
@@ -1138,6 +1173,8 @@ static __init int intel_pmu_init(void)
 	case 44: /* 32 nm nehalem, "Gulftown" */
 		memcpy(hw_cache_event_ids, westmere_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, nehalem_hw_cache_extra_regs,
+		       sizeof(hw_cache_extra_regs));
 
 		intel_pmu_lbr_init_nhm();
 
-- 
1.7.1

