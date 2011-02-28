Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab1B1IvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 03:51:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:22701 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab1B1IvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 03:51:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,238,1297065600"; 
   d="scan'208";a="607169895"
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimAkCtPwEMzHM3A_=kWs+HbYMJ_OBvxcHo46RJg@mail.gmail.com>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	 <AANLkTimAkCtPwEMzHM3A_=kWs+HbYMJ_OBvxcHo46RJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 16:51:27 +0800
Message-ID: <1298883087.4937.42.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 16:20 +0800, Stephane Eranian wrote:
> On Mon, Feb 28, 2011 at 8:22 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > This patch adds basic SandyBridge support, including hardware cache
> > events and PEBS events support.
> >
> > LLC-* hareware cache events don't work for now, it depends on the
> > offcore patches.
> >
> > All PEBS events are tested on my SandyBridge machine and work well.
> > Note that SandyBridge does not support INSTR_RETIRED.ANY(0x00c0) PEBS
> > event, instead it supports INST_RETIRED.PRECDIST(0x01c0) event and PMC1
> > only.
> >
> > v1 -> v2:
> > - add more raw and PEBS events constraints
> > - use offcore events for LLC-* cache events
> > - remove the call to Nehalem workaround enable_all function
> >
> > todo:
> > - precise store
> > - precise distribution of instructions retired
> >
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  arch/x86/kernel/cpu/perf_event.c          |    2 +
> >  arch/x86/kernel/cpu/perf_event_intel.c    |  123 +++++++++++++++++++++++++++++
> >  arch/x86/kernel/cpu/perf_event_intel_ds.c |   44 ++++++++++-
> >  3 files changed, 168 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index 10bfe24..49d51be 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -148,6 +148,8 @@ struct cpu_hw_events {
> >  */
> >  #define INTEL_EVENT_CONSTRAINT(c, n)   \
> >        EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
> > +#define INTEL_EVENT_CONSTRAINT2(c, n)  \
> > +       EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
> >
> >  /*
> >  * Constraint on the Event code + UMask + fixed-mask
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> > index 084b383..3085868 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > @@ -76,6 +76,19 @@ static struct event_constraint intel_westmere_event_constraints[] =
> >        EVENT_CONSTRAINT_END
> >  };
> >
> > +static struct event_constraint intel_snb_event_constraints[] =
> > +{
> > +       FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
> > +       FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
> > +       /* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
> > +       INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
> > +       INTEL_EVENT_CONSTRAINT(0xb7, 0x1), /* OFF_CORE_RESPONSE_0 */
> > +       INTEL_EVENT_CONSTRAINT(0xbb, 0x8), /* OFF_CORE_RESPONSE_1 */
> > +       INTEL_EVENT_CONSTRAINT2(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
> > +       INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
> > +       EVENT_CONSTRAINT_END
> > +};
> > +
> >  static struct event_constraint intel_gen_event_constraints[] =
> >  {
> >        FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
> > @@ -89,6 +102,106 @@ static u64 intel_pmu_event_map(int hw_event)
> >        return intel_perfmon_event_map[hw_event];
> >  }
> >
> > +static __initconst const u64 snb_hw_cache_event_ids
> > +                               [PERF_COUNT_HW_CACHE_MAX]
> > +                               [PERF_COUNT_HW_CACHE_OP_MAX]
> > +                               [PERF_COUNT_HW_CACHE_RESULT_MAX] =
> > +{
> > + [ C(L1D) ] = {
> > +       [ C(OP_READ) ] = {
> > +               [ C(RESULT_ACCESS) ] = 0xf1d0, /* MEM_UOP_RETIRED.LOADS        */
> > +               [ C(RESULT_MISS)   ] = 0x0151, /* L1D.REPLACEMENT              */
> > +       },
> > +       [ C(OP_WRITE) ] = {
> > +               [ C(RESULT_ACCESS) ] = 0xf2d0, /* MEM_UOP_RETIRED.STORES       */
> > +               [ C(RESULT_MISS)   ] = 0x0851, /* L1D.ALL_M_REPLACEMENT        */
> > +       },
> > +       [ C(OP_PREFETCH) ] = {
> > +               [ C(RESULT_ACCESS) ] = 0x0,
> > +               [ C(RESULT_MISS)   ] = 0x024e, /* HW_PRE_REQ.DL1_MISS          */
> > +       },
> > + },
> > + [ C(L1I ) ] = {
> > +       [ C(OP_READ) ] = {
> > +               [ C(RESULT_ACCESS) ] = 0x0,
> > +               [ C(RESULT_MISS)   ] = 0x0280, /* ICACHE.MISSES */
> > +       },
> > +       [ C(OP_WRITE) ] = {
> > +               [ C(RESULT_ACCESS) ] = -1,
> > +               [ C(RESULT_MISS)   ] = -1,
> > +       },
> > +       [ C(OP_PREFETCH) ] = {
> > +               [ C(RESULT_ACCESS) ] = 0x0,
> > +               [ C(RESULT_MISS)   ] = 0x0,
> > +       },
> > + },
> > + [ C(LL  ) ] = {
> > +       /*
> > +        * TBD: Need Off-core Response Performance Monitoring support
> > +        */
> > +       [ C(OP_READ) ] = {
> > +               /* OFFCORE_RESPONSE_0.ANY_DATA.LOCAL_CACHE */
> > +               [ C(RESULT_ACCESS) ] = 0x01b7,
> > +               /* OFFCORE_RESPONSE_1.ANY_DATA.ANY_LLC_MISS */
> > +               [ C(RESULT_MISS)   ] = 0x01bb,
> > +       },
> > +       [ C(OP_WRITE) ] = {
> > +               /* OFFCORE_RESPONSE_0.ANY_RFO.LOCAL_CACHE */
> > +               [ C(RESULT_ACCESS) ] = 0x01b7,
> > +               /* OFFCORE_RESPONSE_1.ANY_RFO.ANY_LLC_MISS */
> > +               [ C(RESULT_MISS)   ] = 0x01bb,
> > +       },
> > +       [ C(OP_PREFETCH) ] = {
> > +               /* OFFCORE_RESPONSE_0.PREFETCH.LOCAL_CACHE */
> > +               [ C(RESULT_ACCESS) ] = 0x01b7,
> > +               /* OFFCORE_RESPONSE_1.PREFETCH.ANY_LLC_MISS */
> > +               [ C(RESULT_MISS)   ] = 0x01bb,
> > +       },
> > + },
> > + [ C(DTLB) ] = {
> > +       [ C(OP_READ) ] = {
> > +               [ C(RESULT_ACCESS) ] = 0x01d0, /* MEM_UOP_RETIRED.LOADS */
> > +               [ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.CAUSES_A_WALK */
> > +       },
> > +       [ C(OP_WRITE) ] = {
> > +               [ C(RESULT_ACCESS) ] = 0x02d0, /* MEM_UOP_RETIRED.STORES */
> > +               [ C(RESULT_MISS)   ] = 0x0149, /* DTLB_STORE_MISSES.MISS_CAUSES_A_WALK */
> > +       },
> > +       [ C(OP_PREFETCH) ] = {
> > +               [ C(RESULT_ACCESS) ] = 0x0,
> > +               [ C(RESULT_MISS)   ] = 0x0,
> > +       },
> > + },
> > + [ C(ITLB) ] = {
> > +       [ C(OP_READ) ] = {
> > +               [ C(RESULT_ACCESS) ] = 0x1085, /* ITLB_MISSES.STLB_HIT         */
> > +               [ C(RESULT_MISS)   ] = 0x0185, /* ITLB_MISSES.CAUSES_A_WALK    */
> > +       },
> > +       [ C(OP_WRITE) ] = {
> > +               [ C(RESULT_ACCESS) ] = -1,
> > +               [ C(RESULT_MISS)   ] = -1,
> > +       },
> > +       [ C(OP_PREFETCH) ] = {
> > +               [ C(RESULT_ACCESS) ] = -1,
> > +               [ C(RESULT_MISS)   ] = -1,
> > +       },
> > + },
> > + [ C(BPU ) ] = {
> > +       [ C(OP_READ) ] = {
> > +               [ C(RESULT_ACCESS) ] = 0x00c4, /* BR_INST_RETIRED.ALL_BRANCHES */
> > +               [ C(RESULT_MISS)   ] = 0x00c5, /* BR_MISP_RETIRED.ALL_BRANCHES */
> > +       },
> > +       [ C(OP_WRITE) ] = {
> > +               [ C(RESULT_ACCESS) ] = -1,
> > +               [ C(RESULT_MISS)   ] = -1,
> > +       },
> > +       [ C(OP_PREFETCH) ] = {
> > +               [ C(RESULT_ACCESS) ] = -1,
> > +               [ C(RESULT_MISS)   ] = -1,
> > +       },
> > + },
> > +};
> > +
> >  static __initconst const u64 westmere_hw_cache_event_ids
> >                                [PERF_COUNT_HW_CACHE_MAX]
> >                                [PERF_COUNT_HW_CACHE_OP_MAX]
> > @@ -1062,6 +1175,16 @@ static __init int intel_pmu_init(void)
> >                pr_cont("Westmere events, ");
> >                break;
> >
> > +       case 42: /* SandyBridge */
> > +               memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
> > +                      sizeof(hw_cache_event_ids));
> > +
> > +               intel_pmu_lbr_init_nhm();
> > +
> > +               x86_pmu.event_constraints = intel_snb_event_constraints;
> > +               pr_cont("SandyBridge events, ");
> > +               break;
> > +
> >        default:
> >                /*
> >                 * default constraints for v2 and up
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> > index b7dcd9f..e60f91b 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> > @@ -388,6 +388,42 @@ static struct event_constraint intel_nehalem_pebs_events[] = {
> >        EVENT_CONSTRAINT_END
> >  };
> >
> > +static struct event_constraint intel_snb_pebs_events[] = {
> > +       PEBS_EVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
> > +       PEBS_EVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
> > +       PEBS_EVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
> > +       PEBS_EVENT_CONSTRAINT(0x01c4, 0xf), /* BR_INST_RETIRED.CONDITIONAL */
> > +       PEBS_EVENT_CONSTRAINT(0x02c4, 0xf), /* BR_INST_RETIRED.NEAR_CALL */
> > +       PEBS_EVENT_CONSTRAINT(0x04c4, 0xf), /* BR_INST_RETIRED.ALL_BRANCHES */
> > +       PEBS_EVENT_CONSTRAINT(0x08c4, 0xf), /* BR_INST_RETIRED.NEAR_RETURN */
> > +       PEBS_EVENT_CONSTRAINT(0x10c4, 0xf), /* BR_INST_RETIRED.NOT_TAKEN */
> > +       PEBS_EVENT_CONSTRAINT(0x20c4, 0xf), /* BR_INST_RETIRED.NEAR_TAKEN */
> > +       PEBS_EVENT_CONSTRAINT(0x40c4, 0xf), /* BR_INST_RETIRED.FAR_BRANCH */
> > +       PEBS_EVENT_CONSTRAINT(0x01c5, 0xf), /* BR_MISP_RETIRED.CONDITIONAL */
> > +       PEBS_EVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
> > +       PEBS_EVENT_CONSTRAINT(0x04c5, 0xf), /* BR_MISP_RETIRED.ALL_BRANCHES */
> > +       PEBS_EVENT_CONSTRAINT(0x10c5, 0xf), /* BR_MISP_RETIRED.NOT_TAKEN */
> > +       PEBS_EVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.TAKEN */
> > +       PEBS_EVENT_CONSTRAINT(0x01cd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
> > +       PEBS_EVENT_CONSTRAINT(0x02cd, 0x8), /* MEM_TRANS_RETIRED.PRECISE_STORE */
> 
> > +       PEBS_EVENT_CONSTRAINT(0x01d0, 0xf), /* MEM_UOP_RETIRED.LOADS */
> > +       PEBS_EVENT_CONSTRAINT(0x02d0, 0xf), /* MEM_UOP_RETIRED.STORES */
> > +       PEBS_EVENT_CONSTRAINT(0x10d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS */
> > +       PEBS_EVENT_CONSTRAINT(0x20d0, 0xf), /* MEM_UOP_RETIRED.LOCK */
> > +       PEBS_EVENT_CONSTRAINT(0x40d0, 0xf), /* MEM_UOP_RETIRED.SPLIT */
> > +       PEBS_EVENT_CONSTRAINT(0x80d0, 0xf), /* MEM_UOP_RETIRED.ALL */
> 
> Not quite. For event 0xd0, you are not listing the right umask combinations.
> The following combinations are supported for event 0xd0:
> 
> 0x5381d0	snb::MEM_UOP_RETIRED:ANY_LOADS
> 0x5382d0	snb::MEM_UOP_RETIRED:ANY_STORES
> 0x5321d0	snb::MEM_UOP_RETIRED:LOCK_LOADS
> 0x5322d0	snb::MEM_UOP_RETIRED:LOCK_STORES
> 0x5341d0	snb::MEM_UOP_RETIRED:SPLIT_LOADS
> 0x5342d0	snb::MEM_UOP_RETIRED:SPLIT_STORES
> 0x5311d0	snb::MEM_UOP_RETIRED:STLB_MISS_LOADS
> 0x5312d0	snb::MEM_UOP_RETIRED:STLB_MISS_STORES
> 
> In other words, bit 0-3 of the umask cannot be zero.

I got the umask from "Table 30-20. PEBS Performance Events for Intel
microarchitecture code name Sandy Bridge".

But from "Table A-2. Non-Architectural Performance Events In the
Processor Core for Intel Core Processor 2xxx Series", the combinations
are needed as you show above.

Which one is correct?







