Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1EFJoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 05:44:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:59801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867Ab1EFJoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 05:44:00 -0400
Date: Fri, 6 May 2011 09:43:32 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-63b6a6758eede2f9283c3594265b6e32e75d7456@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
        fweisbec@gmail.com, rostedt@goodmis.org, ak@linux.intel.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, rostedt@goodmis.org, ak@linux.intel.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1299119690-13991-3-git-send-email-ming.m.lin@intel.com>
References: <1299119690-13991-3-git-send-email-ming.m.lin@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf events, x86: Fix Intel Nehalem and Westmere last level cache event definitions
Git-Commit-ID: 63b6a6758eede2f9283c3594265b6e32e75d7456
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 May 2011 09:43:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63b6a6758eede2f9283c3594265b6e32e75d7456
Gitweb:     http://git.kernel.org/tip/63b6a6758eede2f9283c3594265b6e32e75d7456
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sat, 23 Apr 2011 00:57:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 May 2011 11:24:48 +0200

perf events, x86: Fix Intel Nehalem and Westmere last level cache event definitions

The Intel Nehalem offcore bits implemented in:

  e994d7d23a0b: perf: Fix LLC-* events on Intel Nehalem/Westmere

... are wrong: they implemented _ACCESS as _HIT and counted OTHER_CORE_HIT* as
MISS even though its clearly documented as an L3 hit ...

Fix them and the Westmere definitions as well.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1299119690-13991-3-git-send-email-ming.m.lin@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   87 +++++++++++++++++++-------------
 1 files changed, 52 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e61539b..447a28d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -184,26 +184,23 @@ static __initconst const u64 snb_hw_cache_event_ids
 	},
  },
  [ C(LL  ) ] = {
-	/*
-	 * TBD: Need Off-core Response Performance Monitoring support
-	 */
 	[ C(OP_READ) ] = {
-		/* OFFCORE_RESPONSE_0.ANY_DATA.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.ANY_DATA.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.ANY_DATA.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.ANY_DATA.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	[ C(OP_WRITE) ] = {
-		/* OFFCORE_RESPONSE_0.ANY_RFO.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.ANY_RFO.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.ANY_RFO.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.ANY_RFO.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	[ C(OP_PREFETCH) ] = {
-		/* OFFCORE_RESPONSE_0.PREFETCH.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.PREFETCH.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.PREFETCH.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.PREFETCH.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
  },
  [ C(DTLB) ] = {
@@ -285,26 +282,26 @@ static __initconst const u64 westmere_hw_cache_event_ids
  },
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		/* OFFCORE_RESPONSE_0.ANY_DATA.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.ANY_DATA.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.ANY_DATA.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.ANY_DATA.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	/*
 	 * Use RFO, not WRITEBACK, because a write miss would typically occur
 	 * on RFO.
 	 */
 	[ C(OP_WRITE) ] = {
-		/* OFFCORE_RESPONSE_1.ANY_RFO.LOCAL_CACHE */
-		[ C(RESULT_ACCESS) ] = 0x01bb,
-		/* OFFCORE_RESPONSE_0.ANY_RFO.ANY_LLC_MISS */
+		/* OFFCORE_RESPONSE.ANY_RFO.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		/* OFFCORE_RESPONSE.ANY_RFO.ANY_LLC_MISS */
 		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	[ C(OP_PREFETCH) ] = {
-		/* OFFCORE_RESPONSE_0.PREFETCH.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.PREFETCH.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.PREFETCH.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.PREFETCH.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
  },
  [ C(DTLB) ] = {
@@ -352,16 +349,36 @@ static __initconst const u64 westmere_hw_cache_event_ids
 };
 
 /*
- * OFFCORE_RESPONSE MSR bits (subset), See IA32 SDM Vol 3 30.6.1.3
+ * Nehalem/Westmere MSR_OFFCORE_RESPONSE bits;
+ * See IA32 SDM Vol 3B 30.6.1.3
  */
 
-#define DMND_DATA_RD     (1 << 0)
-#define DMND_RFO         (1 << 1)
-#define DMND_WB          (1 << 3)
-#define PF_DATA_RD       (1 << 4)
-#define PF_DATA_RFO      (1 << 5)
-#define RESP_UNCORE_HIT  (1 << 8)
-#define RESP_MISS        (0xf600) /* non uncore hit */
+#define NHM_DMND_DATA_RD	(1 << 0)
+#define NHM_DMND_RFO		(1 << 1)
+#define NHM_DMND_IFETCH		(1 << 2)
+#define NHM_DMND_WB		(1 << 3)
+#define NHM_PF_DATA_RD		(1 << 4)
+#define NHM_PF_DATA_RFO		(1 << 5)
+#define NHM_PF_IFETCH		(1 << 6)
+#define NHM_OFFCORE_OTHER	(1 << 7)
+#define NHM_UNCORE_HIT		(1 << 8)
+#define NHM_OTHER_CORE_HIT_SNP	(1 << 9)
+#define NHM_OTHER_CORE_HITM	(1 << 10)
+        			/* reserved */
+#define NHM_REMOTE_CACHE_FWD	(1 << 12)
+#define NHM_REMOTE_DRAM		(1 << 13)
+#define NHM_LOCAL_DRAM		(1 << 14)
+#define NHM_NON_DRAM		(1 << 15)
+
+#define NHM_ALL_DRAM		(NHM_REMOTE_DRAM|NHM_LOCAL_DRAM)
+
+#define NHM_DMND_READ		(NHM_DMND_DATA_RD)
+#define NHM_DMND_WRITE		(NHM_DMND_RFO|NHM_DMND_WB)
+#define NHM_DMND_PREFETCH	(NHM_PF_DATA_RD|NHM_PF_DATA_RFO)
+
+#define NHM_L3_HIT	(NHM_UNCORE_HIT|NHM_OTHER_CORE_HIT_SNP|NHM_OTHER_CORE_HITM)
+#define NHM_L3_MISS	(NHM_NON_DRAM|NHM_ALL_DRAM|NHM_REMOTE_CACHE_FWD)
+#define NHM_L3_ACCESS	(NHM_L3_HIT|NHM_L3_MISS)
 
 static __initconst const u64 nehalem_hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_MAX]
@@ -370,16 +387,16 @@ static __initconst const u64 nehalem_hw_cache_extra_regs
 {
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = DMND_DATA_RD|RESP_UNCORE_HIT,
-		[ C(RESULT_MISS)   ] = DMND_DATA_RD|RESP_MISS,
+		[ C(RESULT_ACCESS) ] = NHM_DMND_READ|NHM_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = NHM_DMND_READ|NHM_L3_MISS,
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = DMND_RFO|DMND_WB|RESP_UNCORE_HIT,
-		[ C(RESULT_MISS)   ] = DMND_RFO|DMND_WB|RESP_MISS,
+		[ C(RESULT_ACCESS) ] = NHM_DMND_WRITE|NHM_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = NHM_DMND_WRITE|NHM_L3_MISS,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = PF_DATA_RD|PF_DATA_RFO|RESP_UNCORE_HIT,
-		[ C(RESULT_MISS)   ] = PF_DATA_RD|PF_DATA_RFO|RESP_MISS,
+		[ C(RESULT_ACCESS) ] = NHM_DMND_PREFETCH|NHM_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = NHM_DMND_PREFETCH|NHM_L3_MISS,
 	},
  }
 };
