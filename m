Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab0DVTh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:37:57 -0400
Received: from kroah.org ([198.145.64.141]:41454 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642Ab0DVT3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:41 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:22 2010
Message-Id: <20100422190922.060534166@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Stephane Eranian <eranian@google.com>,
       Ingo Molnar <mingo@elte.hu>, Vince Weaver <vweaver1@eecs.utk.edu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>,
       Youquan Song <youquan.song@linux.intel.com>
Subject: [164/197] perf_events, x86: Implement Intel Westmere/Nehalem-EX support
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

original patch commit ids: 452a339a976e7f782c786eb3f73080401e2fa3a6 and
134fbadf028a5977a1b06b0253d3ee33e6f0c642 

perf_events, x86: Implement Intel Westmere support

The new Intel documentation includes Westmere arch specific
event maps that are significantly different from the Nehalem
ones. Add support for this generation.

Found the CPUID model numbers on wikipedia.

Also ammend some Nehalem constraints, spotted those when looking
for the differences between Nehalem and Westmere.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100127221122.151865645@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

perf, x86: Enable Nehalem-EX support

According to Intel Software Devel Manual Volume 3B, the
Nehalem-EX PMU is just like regular Nehalem (except for the
uncore support, which is completely different).

Signed-off-by:  Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>
LKML-Reference: <alpine.DEB.2.00.1004060956580.1417@cl320.eecs.utk.edu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Youquan Song <youquan.song@linux.intel.com>
---


---
 arch/x86/kernel/cpu/perf_event.c |  104 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 103 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -190,6 +190,97 @@ static u64 __read_mostly hw_cache_event_
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
+static const u64 westmere_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x010b, /* MEM_INST_RETIRED.LOADS       */
+		[ C(RESULT_MISS)   ] = 0x0151, /* L1D.REPL                     */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x020b, /* MEM_INST_RETURED.STORES      */
+		[ C(RESULT_MISS)   ] = 0x0251, /* L1D.M_REPL                   */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x014e, /* L1D_PREFETCH.REQUESTS        */
+		[ C(RESULT_MISS)   ] = 0x024e, /* L1D_PREFETCH.MISS            */
+	},
+ },
+ [ C(L1I ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0380, /* L1I.READS                    */
+		[ C(RESULT_MISS)   ] = 0x0280, /* L1I.MISSES                   */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0324, /* L2_RQSTS.LOADS               */
+		[ C(RESULT_MISS)   ] = 0x0224, /* L2_RQSTS.LD_MISS             */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0c24, /* L2_RQSTS.RFOS                */
+		[ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS            */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x4f2e, /* LLC Reference                */
+		[ C(RESULT_MISS)   ] = 0x412e, /* LLC Misses                   */
+	},
+ },
+ [ C(DTLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x010b, /* MEM_INST_RETIRED.LOADS       */
+		[ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.ANY         */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x020b, /* MEM_INST_RETURED.STORES      */
+		[ C(RESULT_MISS)   ] = 0x010c, /* MEM_STORE_RETIRED.DTLB_MISS  */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0,
+		[ C(RESULT_MISS)   ] = 0x0,
+	},
+ },
+ [ C(ITLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01c0, /* INST_RETIRED.ANY_P           */
+		[ C(RESULT_MISS)   ] = 0x0185, /* ITLB_MISSES.ANY              */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+ [ C(BPU ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ALL_BRANCHES */
+		[ C(RESULT_MISS)   ] = 0x03e8, /* BPU_CLEARS.ANY               */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+};
+
 static const u64 nehalem_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -1999,6 +2090,7 @@ static int intel_pmu_init(void)
 	 * Install the hw-cache-events table:
 	 */
 	switch (boot_cpu_data.x86_model) {
+
 	case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
 	case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
 	case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
@@ -2009,7 +2101,9 @@ static int intel_pmu_init(void)
 		pr_cont("Core2 events, ");
 		break;
 	default:
-	case 26:
+	case 26: /* 45 nm nehalem, "Bloomfield" */
+	case 30: /* 45 nm nehalem, "Lynnfield" */
+	case 46: /* 45 nm nehalem-ex, "Beckton" */
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -2021,6 +2115,14 @@ static int intel_pmu_init(void)
 
 		pr_cont("Atom events, ");
 		break;
+
+	case 37: /* 32 nm nehalem, "Clarkdale" */
+	case 44: /* 32 nm nehalem, "Gulftown" */
+		memcpy(hw_cache_event_ids, westmere_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
+
+		pr_cont("Westmere events, ");
+		break;
 	}
 	return 0;
 }


