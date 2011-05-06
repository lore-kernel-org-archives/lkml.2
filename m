Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab1EFJUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 05:20:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42514 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab1EFJUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 05:20:07 -0400
Date: Fri, 6 May 2011 11:19:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] perf events, x86: Implement Sandybridge last-level cache
 events
Message-ID: <20110506091950.GA5081@elte.hu>
References: <1304666042-17577-1-git-send-email-ming.m.lin@intel.com>
 <20110506073832.GG23166@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506073832.GG23166@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Btw., there's another missing Intel SandyBridge related perf events feature as 
well which was not implemented with the Intel offcore bits.

Peter did a raw first cut - entirely untested, see it below. Would you be 
interested in testing it on Intel SandyBridge hw and sending (the working 
version) to lkml with your Signed-off-by if the events looks good to you in 
some real tests (i.e. are counting real LL cache events)?

Thanks,

	Ingo

------------------->
Subject: perf events, x86: Implement Sandybridge last-level cache events
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri May 06 11:15:30 CEST 2011

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   68 +++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

Index: tip/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ tip/arch/x86/kernel/cpu/perf_event_intel.c
@@ -150,6 +150,72 @@ static u64 intel_pmu_event_map(int hw_ev
 	return intel_perfmon_event_map[hw_event];
 }
 
+/*
+ * Sandy Bridge MSR_OFFCORE_RESPONSE bits;
+ * See IA32 SDM Vol 3B 30.8.5
+ */
+
+#define SNB_DMND_DATA_RD	(1 << 0)
+#define SNB_DMND_RFO		(1 << 1)
+#define SNB_DMND_IFETCH		(1 << 2)
+#define SNB_DMND_WB		(1 << 3)
+#define SNB_PF_DATA_RD		(1 << 4)
+#define SNB_PF_DATA_RFO		(1 << 5)
+#define SNB_PF_IFETCH		(1 << 6)
+#define SNB_PF_LLC_DATA_RD	(1 << 7)
+#define SNB_PF_LLC_RFO		(1 << 8)
+#define SNB_PF_LLC_IFETCH	(1 << 9)
+#define SNB_BUS_LOCKS		(1 << 10)
+#define SNB_STRM_ST		(1 << 11)
+				/* hole */
+#define SNB_OFFCORE_OTHER	(1 << 15)
+#define SNB_COMMON		(1 << 16)
+#define SNB_NO_SUPP		(1 << 17)
+#define SNB_LLC_HITM		(1 << 18)
+#define SNB_LLC_HITE		(1 << 19)
+#define SNB_LLC_HITS		(1 << 20)
+#define SNB_LLC_HITF		(1 << 21)
+				/* hole */
+#define SNB_SNP_NONE		(1 << 31)
+#define SNB_SNP_NOT_NEEDED	(1 << 32)
+#define SNB_SNP_MISS		(1 << 33)
+#define SNB_SNP_NO_FWD		(1 << 34)
+#define SNB_SNP_FWD		(1 << 35)
+#define SNB_HITM		(1 << 36)
+#define SNB_NON_DRAM		(1 << 37)
+
+#define SNB_DMND_READ		(SNB_DMND_DATA_RD)
+#define SNB_DMND_WRITE		(SNB_DMND_RFO|SNB_DMND_WB|SNB_STRM_ST)
+#define SNB_DMND_PREFETCH	(SNB_PF_DATA_RD|SNB_PF_DATA_RFO)
+
+#define SNB_L3_HIT		()
+#define SNB_L3_MISS		()
+#define SNB_L3_ACCESS		(SNB_L3_HIT|SNB_L3_MISS)
+
+#define SNB_ALL_DRAM		()
+#define SNB_REMOTE_DRAM		()
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
+ }
+};
+
 static __initconst const u64 snb_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -1497,6 +1563,8 @@ static __init int intel_pmu_init(void)
 	case 42: /* SandyBridge */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
+		       sizeof(hw_cache_extra_regs));
 
 		intel_pmu_lbr_init_nhm();
 
