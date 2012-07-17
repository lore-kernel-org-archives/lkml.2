Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab2GQJ2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:28:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:2921 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab2GQJ17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:27:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="173081973"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] perf/x86: Fix LLC-* and node-* events on Intel SandyBridge
Date: Tue, 17 Jul 2012 17:27:55 +0800
Message-Id: <1342517275-2875-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

LLC-* and node-* events require using the OFFCORE_RESPONSE events
on SandyBridge, but the hw_cache_extra_regs is left uninitialized.
This patch adds the missing extra register configure table for
SandyBridge.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   92 +++++++++++++++++++++++++++++---
 1 file changed, 86 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 7a8b9d0..3823669 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -138,6 +138,84 @@ static u64 intel_pmu_event_map(int hw_event)
 	return intel_perfmon_event_map[hw_event];
 }
 
+#define SNB_DMND_DATA_RD	(1ULL << 0)
+#define SNB_DMND_RFO		(1ULL << 1)
+#define SNB_DMND_IFETCH		(1ULL << 2)
+#define SNB_DMND_WB		(1ULL << 3)
+#define SNB_PF_DATA_RD		(1ULL << 4)
+#define SNB_PF_RFO		(1ULL << 5)
+#define SNB_PF_IFETCH		(1ULL << 6)
+#define SNB_LLC_DATA_RD		(1ULL << 7)
+#define SNB_LLC_RFO		(1ULL << 8)
+#define SNB_LLC_IFETCH		(1ULL << 9)
+#define SNB_BUS_LOCKS		(1ULL << 10)
+#define SNB_STRM_ST		(1ULL << 11)
+#define SNB_OTHER		(1ULL << 15)
+#define SNB_RESP_ANY		(1ULL << 16)
+#define SNB_NO_SUPP		(1ULL << 17)
+#define SNB_LLC_HITM		(1ULL << 18)
+#define SNB_LLC_HITE		(1ULL << 19)
+#define SNB_LLC_HITS		(1ULL << 20)
+#define SNB_LLC_HITF		(1ULL << 21)
+#define SNB_LOCAL		(1ULL << 22)
+#define SNB_REMOTE		(0xffULL << 23)
+#define SNB_SNP_NONE		(1ULL << 31)
+#define SNB_SNP_NOT_NEEDED	(1ULL << 32)
+#define SNB_SNP_MISS		(1ULL << 33)
+#define SNB_NO_FWD		(1ULL << 34)
+#define SNB_SNP_FWD		(1ULL << 35)
+#define SNB_HITM		(1ULL << 36)
+#define SNB_NON_DRAM		(1ULL << 37)
+
+#define SNB_DMND_READ		(SNB_DMND_DATA_RD|SNB_LLC_DATA_RD)
+#define SNB_DMND_WRITE		(SNB_DMND_RFO|SNB_LLC_RFO)
+#define SNB_DMND_PREFETCH	(SNB_PF_DATA_RD|SNB_PF_RFO)
+
+#define SNB_SNP_ANY		(SNB_SNP_NONE|SNB_SNP_NOT_NEEDED| \
+				 SNB_SNP_MISS|SNB_NO_FWD|SNB_SNP_FWD| \
+				 SNB_HITM)
+
+#define SNB_DRAM_ANY		(SNB_LOCAL|SNB_REMOTE|SNB_SNP_ANY)
+#define SNB_DRAM_REMOTE		(SNB_REMOTE|SNB_SNP_ANY)
+
+#define SNB_L3_ACCESS		SNB_RESP_ANY
+#define SNB_L3_MISS		(SNB_DRAM_ANY|SNB_NON_DRAM)
+
+static __initconst const u64 snb_hw_cache_extra_regs
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_READ|SNB_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = SNB_DMND_READ|SNB_L3_MISS,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_WRITE|SNB_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = SNB_DMND_WRITE|SNB_L3_MISS,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_PREFETCH|SNB_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = SNB_DMND_PREFETCH|SNB_L3_MISS,
+	},
+ },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_READ|SNB_DRAM_ANY,
+		[ C(RESULT_MISS)   ] = SNB_DMND_READ|SNB_DRAM_REMOTE,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_WRITE|SNB_DRAM_ANY,
+		[ C(RESULT_MISS)   ] = SNB_DMND_WRITE|SNB_DRAM_REMOTE,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_PREFETCH|SNB_DRAM_ANY,
+		[ C(RESULT_MISS)   ] = SNB_DMND_PREFETCH|SNB_DRAM_REMOTE,
+	},
+ },
+};
+
 static __initconst const u64 snb_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -235,16 +313,16 @@ static __initconst const u64 snb_hw_cache_event_ids
  },
  [ C(NODE) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = -1,
-		[ C(RESULT_MISS)   ] = -1,
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
  },
 
@@ -1964,6 +2042,8 @@ __init int intel_pmu_init(void)
 	case 58: /* IvyBridge */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
+		       sizeof(hw_cache_extra_regs));
 
 		intel_pmu_lbr_init_snb();
 
-- 
1.7.10.4

