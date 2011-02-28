Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1B1O2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:28:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:23489 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab1B1O2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:28:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,239,1297065600"; 
   d="scan'208";a="607266666"
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1298901821.2169.36.camel@localhost>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	 <AANLkTimAkCtPwEMzHM3A_=kWs+HbYMJ_OBvxcHo46RJg@mail.gmail.com>
	 <1298883087.4937.42.camel@minggr.sh.intel.com>
	 <AANLkTim_2ZgZTwJw_fSOdeyvAC96e5H4scGp+byuk6ZD@mail.gmail.com>
	 <1298901821.2169.36.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 22:28:48 +0800
Message-Id: <1298903328.2169.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 22:03 +0800, Lin Ming wrote:
> > >>
> > >> Not quite. For event 0xd0, you are not listing the right umask combinations.
> > >> The following combinations are supported for event 0xd0:
> > >>
> > >> 0x5381d0      snb::MEM_UOP_RETIRED:ANY_LOADS
> > >> 0x5382d0      snb::MEM_UOP_RETIRED:ANY_STORES
> > >> 0x5321d0      snb::MEM_UOP_RETIRED:LOCK_LOADS
> > >> 0x5322d0      snb::MEM_UOP_RETIRED:LOCK_STORES
> > >> 0x5341d0      snb::MEM_UOP_RETIRED:SPLIT_LOADS
> > >> 0x5342d0      snb::MEM_UOP_RETIRED:SPLIT_STORES
> > >> 0x5311d0      snb::MEM_UOP_RETIRED:STLB_MISS_LOADS
> > >> 0x5312d0      snb::MEM_UOP_RETIRED:STLB_MISS_STORES
> > >>
> > >> In other words, bit 0-3 of the umask cannot be zero.
> > >
> > > I got the umask from "Table 30-20. PEBS Performance Events for Intel
> > > microarchitecture code name Sandy Bridge".
> > >
> > > But from "Table A-2. Non-Architectural Performance Events In the
> > > Processor Core for Intel Core Processor 2xxx Series", the combinations
> > > are needed as you show above.
> > >
> > > Which one is correct?
> > >
> > I think Table A-2 is correct. Umasks 10h, 20h, 40h, 80h MUST be combined
> > to collect something meaningful.
> 
> Yes, thanks for figuring this out.

I also fix the dTLB-loads/stores events.

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 3085868..66712dd 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -160,11 +160,11 @@ static __initconst const u64 snb_hw_cache_event_ids
  },
  [ C(DTLB) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x01d0, /* MEM_UOP_RETIRED.LOADS */
+		[ C(RESULT_ACCESS) ] = 0x81d0, /* MEM_UOP_RETIRED.ANY_LOADS */
 		[ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.CAUSES_A_WALK */
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x02d0, /* MEM_UOP_RETIRED.STORES */
+		[ C(RESULT_ACCESS) ] = 0x82d0, /* MEM_UOP_RETIRED.ANY_STORES */
 		[ C(RESULT_MISS)   ] = 0x0149, /* DTLB_STORE_MISSES.MISS_CAUSES_A_WALK */
 	},
 	[ C(OP_PREFETCH) ] = {
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index e60f91b..2128755 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -406,12 +406,14 @@ static struct event_constraint intel_snb_pebs_events[] = {
 	PEBS_EVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.TAKEN */
 	PEBS_EVENT_CONSTRAINT(0x01cd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
 	PEBS_EVENT_CONSTRAINT(0x02cd, 0x8), /* MEM_TRANS_RETIRED.PRECISE_STORE */
-	PEBS_EVENT_CONSTRAINT(0x01d0, 0xf), /* MEM_UOP_RETIRED.LOADS */
-	PEBS_EVENT_CONSTRAINT(0x02d0, 0xf), /* MEM_UOP_RETIRED.STORES */
-	PEBS_EVENT_CONSTRAINT(0x10d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS */
-	PEBS_EVENT_CONSTRAINT(0x20d0, 0xf), /* MEM_UOP_RETIRED.LOCK */
-	PEBS_EVENT_CONSTRAINT(0x40d0, 0xf), /* MEM_UOP_RETIRED.SPLIT */
-	PEBS_EVENT_CONSTRAINT(0x80d0, 0xf), /* MEM_UOP_RETIRED.ALL */
+	PEBS_EVENT_CONSTRAINT(0x11d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_LOADS */
+	PEBS_EVENT_CONSTRAINT(0x12d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_STORES */
+	PEBS_EVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOP_RETIRED.LOCK_LOADS */
+	PEBS_EVENT_CONSTRAINT(0x22d0, 0xf), /* MEM_UOP_RETIRED.LOCK_STORES */
+	PEBS_EVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_LOADS */
+	PEBS_EVENT_CONSTRAINT(0x42d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_STORES */
+	PEBS_EVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOP_RETIRED.ANY_LOADS */
+	PEBS_EVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOP_RETIRED.ANY_STORES */
 	PEBS_EVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
 	PEBS_EVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
 	PEBS_EVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.LLC_HIT */



