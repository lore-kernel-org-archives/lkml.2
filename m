Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1CCAuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:50:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:63045 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab1CCAuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:50:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,256,1297065600"; 
   d="scan'208";a="396663264"
Subject: Re: [PATCH v3 -tip/perf/urgent] perf: x86, add SandyBridge support
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinGUyQCS-T=jTSyr7uv_wGT9JBpvNLs7VH=-Gax@mail.gmail.com>
References: <1299072424.2175.24.camel@localhost>
	 <AANLkTinGUyQCS-T=jTSyr7uv_wGT9JBpvNLs7VH=-Gax@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 08:50:31 +0800
Message-ID: <1299113431.8642.44.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 22:17 +0800, Stephane Eranian wrote:
> On Wed, Mar 2, 2011 at 2:27 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> > This patch adds basic SandyBridge support, including hardware cache
> > events and PEBS events support.
> >
> > v2 -> v3:
> > - fix PEBS event 0xd0 with right umask combinations
> > - move snb pebs constraint assignment to intel_pmu_init
> >
> > v1 -> v2:
> > - add more raw and PEBS events constraints
> > - use offcore events for LLC-* cache events
> > - remove the call to Nehalem workaround enable_all function
> >
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  arch/x86/kernel/cpu/perf_event.c          |    4 +-
> >  arch/x86/kernel/cpu/perf_event_intel.c    |  124 +++++++++++++++++++++++++++++
> >  arch/x86/kernel/cpu/perf_event_intel_ds.c |   38 +++++++++
> >  3 files changed, 165 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index 9d977a2..390fa6d 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -166,8 +166,10 @@ struct cpu_hw_events {
> >  /*
> >  * Constraint on the Event code + UMask
> >  */
> > -#define PEBS_EVENT_CONSTRAINT(c, n)    \
> > +#define INTEL_UEVENT_CONSTRAINT(c, n)  \
> >        EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
> > +#define PEBS_EVENT_CONSTRAINT(c, n)    \
> > +       INTEL_UEVENT_CONSTRAINT(c, n)
> >
> >  #define EVENT_CONSTRAINT_END           \
> >        EVENT_CONSTRAINT(0, 0, 0)
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> > index 008835c..d00f386 100644
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
> > +       INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
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
> > +               [ C(RESULT_ACCESS) ] = 0x81d0, /* MEM_UOP_RETIRED.ALL_LOADS */
> > +               [ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.CAUSES_A_WALK */
> > +       },
> > +       [ C(OP_WRITE) ] = {
> > +               [ C(RESULT_ACCESS) ] = 0x82d0, /* MEM_UOP_RETIRED.ALL_STORES */
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
> > @@ -1062,6 +1175,17 @@ static __init int intel_pmu_init(void)
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
> > +               x86_pmu.pebs_constraints = intel_snb_pebs_events;
> > +               pr_cont("SandyBridge events, ");
> > +               break;
> > +
> >        default:
> >                /*
> >                 * default constraints for v2 and up
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> > index b7dcd9f..8251998 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> > @@ -388,6 +388,44 @@ static struct event_constraint intel_nehalem_pebs_events[] = {
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
> > +       PEBS_EVENT_CONSTRAINT(0x11d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_LOADS */
> > +       PEBS_EVENT_CONSTRAINT(0x12d0, 0xf), /* MEM_UOP_RETIRED.STLB_MISS_STORES */
> > +       PEBS_EVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOP_RETIRED.LOCK_LOADS */
> > +       PEBS_EVENT_CONSTRAINT(0x22d0, 0xf), /* MEM_UOP_RETIRED.LOCK_STORES */
> > +       PEBS_EVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_LOADS */
> > +       PEBS_EVENT_CONSTRAINT(0x42d0, 0xf), /* MEM_UOP_RETIRED.SPLIT_STORES */
> > +       PEBS_EVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOP_RETIRED.ANY_LOADS */
> > +       PEBS_EVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOP_RETIRED.ANY_STORES */
> > +       PEBS_EVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
> > +       PEBS_EVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
> > +       PEBS_EVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.LLC_HIT */
> > +       PEBS_EVENT_CONSTRAINT(0x40d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.HIT_LFB */
> > +       PEBS_EVENT_CONSTRAINT(0x01d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS */
> > +       PEBS_EVENT_CONSTRAINT(0x02d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT */
> > +       PEBS_EVENT_CONSTRAINT(0x04d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HITM */
> > +       PEBS_EVENT_CONSTRAINT(0x08d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_NONE */
> > +       PEBS_EVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
> > +       EVENT_CONSTRAINT_END
> > +};
> > +
> Why didn't you use INTEL_EVENT_CONSTRAINT() for the events where all
> umasks support
> PEBS? This is what I did in my PEBS patch.

OK, will do it in later cleanup patches.


