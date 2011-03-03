Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab1CCC0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:26:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:26958 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058Ab1CCC0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:26:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,256,1297065600"; 
   d="scan'208";a="663266686"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/4] perf: Fix LLC-* events on Intel Nehalem/Westmere
Date: Thu,  3 Mar 2011 10:34:48 +0800
Message-Id: <1299119690-13991-3-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1299119690-13991-2-git-send-email-ming.m.lin@intel.com>
References: <1299119690-13991-1-git-send-email-ming.m.lin@intel.com>
 <1299119690-13991-2-git-send-email-ming.m.lin@intel.com>
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
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   15 ++++--
 arch/x86/kernel/cpu/perf_event_intel.c |   81 +++++++++++++++++++++++++++-----
 2 files changed, 79 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ec6a6db..4d6ce5d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -310,6 +310,10 @@ static u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
+static u64 __read_mostly hw_cache_extra_regs
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
 /*
  * Propagate event elapsed time into the generic event.
@@ -524,8 +528,9 @@ static inline int x86_pmu_initialized(void)
 }
 
 static inline int
-set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event_attr *attr)
+set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event *event)
 {
+	struct perf_event_attr *attr = &event->attr;
 	unsigned int cache_type, cache_op, cache_result;
 	u64 config, val;
 
@@ -552,8 +557,8 @@ set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event_attr *attr)
 		return -EINVAL;
 
 	hwc->config |= val;
-
-	return 0;
+	attr->config1 = hw_cache_extra_regs[cache_type][cache_op][cache_result];
+	return x86_pmu_extra_regs(val, event);
 }
 
 static int x86_setup_perfctr(struct perf_event *event)
@@ -578,10 +583,10 @@ static int x86_setup_perfctr(struct perf_event *event)
 	}
 
 	if (attr->type == PERF_TYPE_RAW)
-		return 0;
+		return x86_pmu_extra_regs(event->attr.config, event);
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
-		return set_ext_hw_attr(hwc, attr);
+		return set_ext_hw_attr(hwc, event);
 
 	if (attr->config >= x86_pmu.max_events)
 		return -EINVAL;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index af0c6a2..aaac4a9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -285,16 +285,26 @@ static __initconst const u64 westmere_hw_cache_event_ids
  },
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0324, /* L2_RQSTS.LOADS               */
-		[ C(RESULT_MISS)   ] = 0x0224, /* L2_RQSTS.LD_MISS             */
+		/* OFFCORE_RESPONSE_0.ANY_DATA.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		/* OFFCORE_RESPONSE_1.ANY_DATA.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01bb,
 	},
+	/*
+	 * Use RFO, not WRITEBACK, because a write miss would typically occur
+	 * on RFO.
+	 */
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0c24, /* L2_RQSTS.RFOS                */
-		[ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS            */
+		/* OFFCORE_RESPONSE_1.ANY_RFO.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x01bb,
+		/* OFFCORE_RESPONSE_0.ANY_RFO.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f2e, /* LLC Reference                */
-		[ C(RESULT_MISS)   ] = 0x412e, /* LLC Misses                   */
+		/* OFFCORE_RESPONSE_0.PREFETCH.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		/* OFFCORE_RESPONSE_1.PREFETCH.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01bb,
 	},
  },
  [ C(DTLB) ] = {
@@ -341,6 +351,39 @@ static __initconst const u64 westmere_hw_cache_event_ids
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
@@ -376,16 +419,26 @@ static __initconst const u64 nehalem_hw_cache_event_ids
  },
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0324, /* L2_RQSTS.LOADS               */
-		[ C(RESULT_MISS)   ] = 0x0224, /* L2_RQSTS.LD_MISS             */
+		/* OFFCORE_RESPONSE.ANY_DATA.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		/* OFFCORE_RESPONSE.ANY_DATA.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
+	/*
+	 * Use RFO, not WRITEBACK, because a write miss would typically occur
+	 * on RFO.
+	 */
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0c24, /* L2_RQSTS.RFOS                */
-		[ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS            */
+		/* OFFCORE_RESPONSE.ANY_RFO.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		/* OFFCORE_RESPONSE.ANY_RFO.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f2e, /* LLC Reference                */
-		[ C(RESULT_MISS)   ] = 0x412e, /* LLC Misses                   */
+		/* OFFCORE_RESPONSE.PREFETCH.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		/* OFFCORE_RESPONSE.PREFETCH.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
  },
  [ C(DTLB) ] = {
@@ -1339,6 +1392,8 @@ static __init int intel_pmu_init(void)
 	case 46: /* 45 nm nehalem-ex, "Beckton" */
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, nehalem_hw_cache_extra_regs,
+		       sizeof(hw_cache_extra_regs));
 
 		intel_pmu_lbr_init_nhm();
 
@@ -1364,6 +1419,8 @@ static __init int intel_pmu_init(void)
 	case 44: /* 32 nm nehalem, "Gulftown" */
 		memcpy(hw_cache_event_ids, westmere_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, nehalem_hw_cache_extra_regs,
+		       sizeof(hw_cache_extra_regs));
 
 		intel_pmu_lbr_init_nhm();
 
-- 
1.7.3

