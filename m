Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1EIIie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:38:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:35694 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab1EIIid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:38:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,339,1301900400"; 
   d="scan'208";a="432830485"
Subject: [PATCH] perf events, x86: Implement Sandybridge last-level cache
 events
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 16:39:42 +0800
Message-ID: <1304930382.3924.303.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally from: Peter Zijlstra <peterz@infradead.org>

Implement Sandybridge last-level cache events with offcore events.

$ ./perf stat -e LLC-loads -e LLC-load-misses \
    -e LLC-stores -e LLC-store-misses \
    -e LLC-prefetches -e LLC-prefetch-misses \
	-- dd if=/dev/zero of=/dev/null

 Performance counter stats for 'dd if=/dev/zero of=/dev/null':

            21,150 LLC-loads            
               191 LLC-load-misses      
             4,749 LLC-stores          
             1,919 LLC-store-misses   
            11,584 LLC-prefetches     
               174 LLC-prefetch-misses  

        6.155113700  seconds time elapsed


Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   77 ++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 41178c8..b39b819 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -137,6 +137,13 @@ static struct event_constraint intel_westmere_percore_constraints[] __read_mostl
 	EVENT_CONSTRAINT_END
 };
 
+static struct extra_reg intel_snb_extra_regs[] __read_mostly =
+{
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffffffff),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffffffff),
+	EVENT_EXTRA_END
+};
+
 static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
@@ -150,6 +157,72 @@ static u64 intel_pmu_event_map(int hw_event)
 	return intel_perfmon_event_map[hw_event];
 }
 
+/*
+ * Sandy Bridge MSR_OFFCORE_RESPONSE bits;
+ * See IA32 SDM Vol 3B 30.8.5
+ */
+
+#define SNB_DMND_DATA_RD	(1ULL << 0)
+#define SNB_DMND_RFO		(1ULL << 1)
+#define SNB_DMND_IFETCH		(1ULL << 2)
+#define SNB_DMND_WB		(1ULL << 3)
+#define SNB_PF_DATA_RD		(1ULL << 4)
+#define SNB_PF_DATA_RFO		(1ULL << 5)
+#define SNB_PF_IFETCH		(1ULL << 6)
+#define SNB_PF_LLC_DATA_RD	(1ULL << 7)
+#define SNB_PF_LLC_RFO		(1ULL << 8)
+#define SNB_PF_LLC_IFETCH	(1ULL << 9)
+#define SNB_BUS_LOCKS		(1ULL << 10)
+#define SNB_STRM_ST		(1ULL << 11)
+				/* hole */
+#define SNB_OFFCORE_OTHER	(1ULL << 15)
+#define SNB_COMMON		(1ULL << 16)
+#define SNB_NO_SUPP		(1ULL << 17)
+#define SNB_LLC_HITM		(1ULL << 18)
+#define SNB_LLC_HITE		(1ULL << 19)
+#define SNB_LLC_HITS		(1ULL << 20)
+#define SNB_LLC_HITF		(1ULL << 21)
+				/* hole */
+#define SNB_SNP_NONE		(1ULL << 31)
+#define SNB_SNP_NOT_NEEDED	(1ULL << 32)
+#define SNB_SNP_MISS		(1ULL << 33)
+#define SNB_SNP_NO_FWD		(1ULL << 34)
+#define SNB_SNP_FWD		(1ULL << 35)
+#define SNB_HITM		(1ULL << 36)
+#define SNB_NON_DRAM		(1ULL << 37)
+
+#define SNB_DMND_READ		(SNB_DMND_DATA_RD)
+#define SNB_DMND_WRITE		(SNB_DMND_RFO | SNB_DMND_WB|SNB_STRM_ST)
+#define SNB_DMND_PREFETCH	(SNB_PF_DATA_RD | SNB_PF_DATA_RFO)
+
+#define SNB_SUPPLIER_INFO	(SNB_NO_SUPP | SNB_LLC_HITM | SNB_LLC_HITE | \
+				 SNB_LLC_HITS | SNB_LLC_HITF)
+
+#define SNB_L3_HIT		(SNB_SUPPLIER_INFO | SNB_SNP_NOT_NEEDED | SNB_SNP_NO_FWD | SNB_HITM)
+#define SNB_L3_MISS		(SNB_SUPPLIER_INFO | SNB_SNP_MISS | SNB_SNP_FWD | SNB_NON_DRAM)
+#define SNB_L3_ACCESS		(SNB_L3_HIT | SNB_L3_MISS)
+
+static __initconst const u64 snb_hw_cache_extra_regs
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_READ | SNB_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = SNB_DMND_READ | SNB_L3_MISS,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_WRITE | SNB_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = SNB_DMND_WRITE | SNB_L3_MISS,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_PREFETCH | SNB_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = SNB_DMND_PREFETCH | SNB_L3_MISS,
+	},
+ }
+};
+
 static __initconst const u64 snb_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -1497,11 +1570,15 @@ static __init int intel_pmu_init(void)
 	case 42: /* SandyBridge */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
+		       sizeof(hw_cache_extra_regs));
 
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
+		x86_pmu.percore_constraints = intel_westmere_percore_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_events;
+		x86_pmu.extra_regs = intel_snb_extra_regs;
 
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
-- 
1.7.4.4



