Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab2GMUqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:46:36 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4928 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758086Ab2GMUqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:46:14 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Al Cooper" <alcooperx@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
cc: "Al Cooper" <alcooperx@gmail.com>
Subject: [PATCH 1/5] MIPS: perf: Change the "mips_perf_event" table
 unsupported indicator.
Date: Fri, 13 Jul 2012 16:44:50 -0400
Message-ID: <1342212294-23014-1-git-send-email-alcooperx@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
X-WSS-ID: 7C1E573D4989539313-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the indicator from 0xffffffff in the "event_id" member to
zero in the "cntr_mask" member. This removes the need to initialize
entries that are unsupported. This also solves a problem where the
number of entries in the table was increased based on a globel enum
used for all platforms, but the new unsupported entries were not added
for mips. This was leaving new table entries of all zeros that we not
marked UNSUPPORTED.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
---
 arch/mips/kernel/perf_event_mipsxx.c |  154 +---------------------------------
 1 files changed, 4 insertions(+), 150 deletions(-)

diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 2f28d3b..8451f04 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -78,7 +78,6 @@ struct mips_perf_event {
 static struct mips_perf_event raw_event;
 static DEFINE_MUTEX(raw_event_mutex);
 
-#define UNSUPPORTED_PERF_EVENT_ID 0xffffffff
 #define C(x) PERF_COUNT_HW_CACHE_##x
 
 struct mips_pmu {
@@ -664,13 +663,10 @@ static unsigned int mipspmu_perf_event_encode(const struct mips_perf_event *pev)
 
 static const struct mips_perf_event *mipspmu_map_general_event(int idx)
 {
-	const struct mips_perf_event *pev;
-
-	pev = ((*mipspmu.general_event_map)[idx].event_id ==
-		UNSUPPORTED_PERF_EVENT_ID ? ERR_PTR(-EOPNOTSUPP) :
-		&(*mipspmu.general_event_map)[idx]);
 
-	return pev;
+	if ((*mipspmu.general_event_map)[idx].cntr_mask == 0)
+		return ERR_PTR(-EOPNOTSUPP);
+	return &(*mipspmu.general_event_map)[idx];
 }
 
 static const struct mips_perf_event *mipspmu_map_cache_event(u64 config)
@@ -695,7 +691,7 @@ static const struct mips_perf_event *mipspmu_map_cache_event(u64 config)
 					[cache_op]
 					[cache_result]);
 
-	if (pev->event_id == UNSUPPORTED_PERF_EVENT_ID)
+	if (pev->cntr_mask == 0)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	return pev;
@@ -800,11 +796,8 @@ static const struct mips_perf_event mipsxxcore_event_map
 				[PERF_COUNT_HW_MAX] = {
 	[PERF_COUNT_HW_CPU_CYCLES] = { 0x00, CNTR_EVEN | CNTR_ODD, P },
 	[PERF_COUNT_HW_INSTRUCTIONS] = { 0x01, CNTR_EVEN | CNTR_ODD, T },
-	[PERF_COUNT_HW_CACHE_REFERENCES] = { UNSUPPORTED_PERF_EVENT_ID },
-	[PERF_COUNT_HW_CACHE_MISSES] = { UNSUPPORTED_PERF_EVENT_ID },
 	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = { 0x02, CNTR_EVEN, T },
 	[PERF_COUNT_HW_BRANCH_MISSES] = { 0x02, CNTR_ODD, T },
-	[PERF_COUNT_HW_BUS_CYCLES] = { UNSUPPORTED_PERF_EVENT_ID },
 };
 
 /* 74K core has different branch event code. */
@@ -812,11 +805,8 @@ static const struct mips_perf_event mipsxx74Kcore_event_map
 				[PERF_COUNT_HW_MAX] = {
 	[PERF_COUNT_HW_CPU_CYCLES] = { 0x00, CNTR_EVEN | CNTR_ODD, P },
 	[PERF_COUNT_HW_INSTRUCTIONS] = { 0x01, CNTR_EVEN | CNTR_ODD, T },
-	[PERF_COUNT_HW_CACHE_REFERENCES] = { UNSUPPORTED_PERF_EVENT_ID },
-	[PERF_COUNT_HW_CACHE_MISSES] = { UNSUPPORTED_PERF_EVENT_ID },
 	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = { 0x27, CNTR_EVEN, T },
 	[PERF_COUNT_HW_BRANCH_MISSES] = { 0x27, CNTR_ODD, T },
-	[PERF_COUNT_HW_BUS_CYCLES] = { UNSUPPORTED_PERF_EVENT_ID },
 };
 
 static const struct mips_perf_event octeon_event_map[PERF_COUNT_HW_MAX] = {
@@ -849,10 +839,6 @@ static const struct mips_perf_event mipsxxcore_cache_map
 		[C(RESULT_ACCESS)]	= { 0x0a, CNTR_EVEN, T },
 		[C(RESULT_MISS)]	= { 0x0b, CNTR_EVEN | CNTR_ODD, T },
 	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
 },
 [C(L1I)] = {
 	[C(OP_READ)] = {
@@ -869,7 +855,6 @@ static const struct mips_perf_event mipsxxcore_cache_map
 		 * Note that MIPS has only "hit" events countable for
 		 * the prefetch operation.
 		 */
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
 	},
 },
 [C(LL)] = {
@@ -881,10 +866,6 @@ static const struct mips_perf_event mipsxxcore_cache_map
 		[C(RESULT_ACCESS)]	= { 0x15, CNTR_ODD, P },
 		[C(RESULT_MISS)]	= { 0x16, CNTR_EVEN, P },
 	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
 },
 [C(DTLB)] = {
 	[C(OP_READ)] = {
@@ -895,10 +876,6 @@ static const struct mips_perf_event mipsxxcore_cache_map
 		[C(RESULT_ACCESS)]	= { 0x06, CNTR_EVEN, T },
 		[C(RESULT_MISS)]	= { 0x06, CNTR_ODD, T },
 	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
 },
 [C(ITLB)] = {
 	[C(OP_READ)] = {
@@ -909,10 +886,6 @@ static const struct mips_perf_event mipsxxcore_cache_map
 		[C(RESULT_ACCESS)]	= { 0x05, CNTR_EVEN, T },
 		[C(RESULT_MISS)]	= { 0x05, CNTR_ODD, T },
 	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
 },
 [C(BPU)] = {
 	/* Using the same code for *HW_BRANCH* */
@@ -924,24 +897,6 @@ static const struct mips_perf_event mipsxxcore_cache_map
 		[C(RESULT_ACCESS)]	= { 0x02, CNTR_EVEN, T },
 		[C(RESULT_MISS)]	= { 0x02, CNTR_ODD, T },
 	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-},
-[C(NODE)] = {
-	[C(OP_READ)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-	[C(OP_WRITE)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
 },
 };
 
@@ -965,10 +920,6 @@ static const struct mips_perf_event mipsxx74Kcore_cache_map
 		[C(RESULT_ACCESS)]	= { 0x17, CNTR_ODD, T },
 		[C(RESULT_MISS)]	= { 0x18, CNTR_ODD, T },
 	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
 },
 [C(L1I)] = {
 	[C(OP_READ)] = {
@@ -985,7 +936,6 @@ static const struct mips_perf_event mipsxx74Kcore_cache_map
 		 * Note that MIPS has only "hit" events countable for
 		 * the prefetch operation.
 		 */
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
 	},
 },
 [C(LL)] = {
@@ -997,25 +947,6 @@ static const struct mips_perf_event mipsxx74Kcore_cache_map
 		[C(RESULT_ACCESS)]	= { 0x1c, CNTR_ODD, P },
 		[C(RESULT_MISS)]	= { 0x1d, CNTR_EVEN | CNTR_ODD, P },
 	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-},
-[C(DTLB)] = {
-	/* 74K core does not have specific DTLB events. */
-	[C(OP_READ)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-	[C(OP_WRITE)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
 },
 [C(ITLB)] = {
 	[C(OP_READ)] = {
@@ -1026,10 +957,6 @@ static const struct mips_perf_event mipsxx74Kcore_cache_map
 		[C(RESULT_ACCESS)]	= { 0x04, CNTR_EVEN, T },
 		[C(RESULT_MISS)]	= { 0x04, CNTR_ODD, T },
 	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
 },
 [C(BPU)] = {
 	/* Using the same code for *HW_BRANCH* */
@@ -1041,24 +968,6 @@ static const struct mips_perf_event mipsxx74Kcore_cache_map
 		[C(RESULT_ACCESS)]	= { 0x27, CNTR_EVEN, T },
 		[C(RESULT_MISS)]	= { 0x27, CNTR_ODD, T },
 	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-},
-[C(NODE)] = {
-	[C(OP_READ)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-	[C(OP_WRITE)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
 },
 };
 
@@ -1074,39 +983,14 @@ static const struct mips_perf_event octeon_cache_map
 	},
 	[C(OP_WRITE)] = {
 		[C(RESULT_ACCESS)]	= { 0x30, CNTR_ALL },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
 	},
 },
 [C(L1I)] = {
 	[C(OP_READ)] = {
 		[C(RESULT_ACCESS)]	= { 0x18, CNTR_ALL },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-	[C(OP_WRITE)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
 	},
 	[C(OP_PREFETCH)] = {
 		[C(RESULT_ACCESS)]	= { 0x19, CNTR_ALL },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-},
-[C(LL)] = {
-	[C(OP_READ)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-	[C(OP_WRITE)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
 	},
 },
 [C(DTLB)] = {
@@ -1115,46 +999,16 @@ static const struct mips_perf_event octeon_cache_map
 	 * read and write.
 	 */
 	[C(OP_READ)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
 		[C(RESULT_MISS)]	= { 0x35, CNTR_ALL },
 	},
 	[C(OP_WRITE)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
 		[C(RESULT_MISS)]	= { 0x35, CNTR_ALL },
 	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
 },
 [C(ITLB)] = {
 	[C(OP_READ)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
 		[C(RESULT_MISS)]	= { 0x37, CNTR_ALL },
 	},
-	[C(OP_WRITE)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-},
-[C(BPU)] = {
-	/* Using the same code for *HW_BRANCH* */
-	[C(OP_READ)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-	[C(OP_WRITE)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
-	[C(OP_PREFETCH)] = {
-		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
-	},
 },
 };
 
-- 
1.7.6


