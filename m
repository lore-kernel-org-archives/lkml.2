Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab0KLQzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:55:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59864 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab0KLQzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:55:54 -0500
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] perf-events: Fix LLC-* events on Intel Nehalem/Westmere v2
Date: Fri, 12 Nov 2010 17:55:41 +0100
Message-Id: <1289580941-29744-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
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
 arch/x86/kernel/cpu/perf_event.c       |   12 ++++----
 arch/x86/kernel/cpu/perf_event_intel.c |   48 ++++++++++++++++++++++---------
 2 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 346006a..b1abe89 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -467,8 +467,9 @@ static inline int x86_pmu_initialized(void)
 }
 
 static inline int
-set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event_attr *attr)
+set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event *event)
 {
+	struct perf_event_attr *attr = &event->attr;
 	unsigned int cache_type, cache_op, cache_result;
 	u64 config, val;
 
@@ -494,9 +495,8 @@ set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event_attr *attr)
 	if (val == -1)
 		return -EINVAL;
 
-	hwc->config |= val;
-
-	return 0;
+	hwc->config |= val & X86_RAW_EVENT_MASK;
+	return x86_pmu_extra_regs(val, event);
 }
 
 static int x86_setup_perfctr(struct perf_event *event)
@@ -521,10 +521,10 @@ static int x86_setup_perfctr(struct perf_event *event)
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
index a84de7e..2ed1e9d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -165,16 +165,26 @@ static __initconst const u64 westmere_hw_cache_event_ids
  },
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0324, /* L2_RQSTS.LOADS               */
-		[ C(RESULT_MISS)   ] = 0x0224, /* L2_RQSTS.LD_MISS             */
-	},
+		/* OFFCORE_RESPONSE_0.ANY_DATA.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x00000711004301b7,
+		/* OFFCORE_RESPONSE_0.ANY_DATA.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x0000f811004301b7, 
+	},
+	/* 
+	 * Use RFO, not WRITEBACK, because a write miss would typically occur 
+	 * on RFO. 
+	 */
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0c24, /* L2_RQSTS.RFOS                */
-		[ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS            */
+		/* OFFCORE_RESPONSE_0.ANY_RFO.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x00000722004301b7,
+		/* OFFCORE_RESPONSE_0.ANY_RFO.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x0000f822004301b7,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f2e, /* LLC Reference                */
-		[ C(RESULT_MISS)   ] = 0x412e, /* LLC Misses                   */
+		/* OFFCORE_RESPONSE_0.PREFETCH.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x00000770004301b7,
+		/* OFFCORE_RESPONSE_0.PREFETCH.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x0000f870004301b7,
 	},
  },
  [ C(DTLB) ] = {
@@ -256,16 +266,26 @@ static __initconst const u64 nehalem_hw_cache_event_ids
  },
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0324, /* L2_RQSTS.LOADS               */
-		[ C(RESULT_MISS)   ] = 0x0224, /* L2_RQSTS.LD_MISS             */
-	},
+		/* OFFCORE_RESPONSE_0.ANY_DATA.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x00000711004301b7,
+		/* OFFCORE_RESPONSE_0.ANY_DATA.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x0000f811004301b7, 
+	},
+	/* 
+	 * Use RFO, not WRITEBACK, because a write miss would typically occur 
+	 * on RFO. 
+	 */
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0c24, /* L2_RQSTS.RFOS                */
-		[ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS            */
+		/* OFFCORE_RESPONSE_0.ANY_RFO.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x00000722004301b7,
+		/* OFFCORE_RESPONSE_0.ANY_RFO.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x0000f822004301b7,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x4f2e, /* LLC Reference                */
-		[ C(RESULT_MISS)   ] = 0x412e, /* LLC Misses                   */
+		/* OFFCORE_RESPONSE_0.PREFETCH.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x00000770004301b7,
+		/* OFFCORE_RESPONSE_0.PREFETCH.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x0000f870004301b7,
 	},
  },
  [ C(DTLB) ] = {
-- 
1.7.1

