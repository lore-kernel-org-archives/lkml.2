Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2GZPNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:13:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab2GZPNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:13:10 -0400
Date: Thu, 26 Jul 2012 08:12:52 -0700
From: "tip-bot for Yan, Zheng" <zheng.z.yan@intel.com>
Message-ID: <tip-74e6543fdc4e7553f572f7898ade649a09d85049@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1342517275-2875-1-git-send-email-zheng.z.yan@intel.com>
References: <1342517275-2875-1-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Fix LLC-* and node-* events on Intel SandyBridge
Git-Commit-ID: 74e6543fdc4e7553f572f7898ade649a09d85049
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jul 2012 08:12:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74e6543fdc4e7553f572f7898ade649a09d85049
Gitweb:     http://git.kernel.org/tip/74e6543fdc4e7553f572f7898ade649a09d85049
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Tue, 17 Jul 2012 17:27:55 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Jul 2012 12:23:12 +0200

perf/x86: Fix LLC-* and node-* events on Intel SandyBridge

LLC-* and node-* events require using the OFFCORE_RESPONSE events
on SandyBridge, but the hw_cache_extra_regs is left uninitialized.
This patch adds the missing extra register configure table for
SandyBridge.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1342517275-2875-1-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   92 +++++++++++++++++++++++++++++--
 1 files changed, 86 insertions(+), 6 deletions(-)

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
 
