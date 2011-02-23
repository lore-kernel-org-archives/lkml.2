Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1BWBM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:12:28 -0500
Received: from smtp-out.google.com ([216.239.44.51]:15836 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab1BWBM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:12:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RTuYR+QfnYjv8h31ExGho+cVH0kxRDpoj9M/0uLyJKiuvos24RJqMBB+1kk1HVYuMD
         9qxcoiGbYQgE/lV696ag==
MIME-Version: 1.0
In-Reply-To: <1298221019.2318.62.camel@localhost>
References: <1298221019.2318.62.camel@localhost>
Date: Wed, 23 Feb 2011 02:12:23 +0100
Message-ID: <AANLkTimh9zTqBsANwROAS7vfspWVGnzn=JEKxgiisO_d@mail.gmail.com>
Subject: Re: [PATCH 1/6] perf-events: Add support for supplementary event
 registers v5
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lin,

So I tested this patch on my NHM system and it has a major event scheduling
issue. It does not ensure mutual exclusion with two offcore response events
have different extra_config values. This is demonstrated with libpfm4:

$ task -e offcore_response_0:DMND_DATA_RD:LOCAL_DRAM -e
offcore_response_0:DMND_RFO:LOCAL_DRAM  noploop 1
PERF[type=4 val=0x5001b7 e_u=0 e_k=0 e_hv=1 period=0 freq=0 precise=0
event_xtra=4001] offcore_response_0:DMND_DATA_RD:LOCAL_DRAM
PERF[type=4 val=0x5001b7 e_u=0 e_k=0 e_hv=1 period=0 freq=0 precise=0
event_xtra=4003] offcore_response_0:DMND_RFO:LOCAL_DRAM
noploop for 1 seconds
             283,537 offcore_response_0:DMND_DATA_RD:LOCAL_DRAM
(99.99% scaling, ena=995,676,390, run=119,395)
             763,110 offcore_response_0:DMND_RFO:LOCAL_DRAM (99.90%
scaling, ena=996,675,054, run=991,306)

Scaling should be 50% for 1st event, and 50% for the second. Both events are
in separate event groups here.

I tracked this down to a mismatch between intel_percore_constraints()
and the generic layer incremental scheduling approach.

The reason exclusion is not enforced is that in this case the era->ref = 2
when it should not. The reason is pretty tricky.

The scheduling algorithm schedules event groups. I illustrate this without
the offcore response event, but just regular events:

$ task -e llc_misses  -e uops_retired date noploop 1

// first group
[  397.477498] CPU0 commit_txn
[  397.477600] CPU0 get cpuc=ffff88007fc0b600 used=0
per=ffff88007f80f780 cfg=13412e xtra=0
[  397.477672] CPU0 commit_txn ret=0

// first group + second group
[  397.477703] CPU0 commit_txn
[  397.477804] CPU0 get cpuc=ffff88007fc0b600 used=0
per=ffff88007f80f780 cfg=13412e xtra=0
[  397.477877] CPU0 get cpuc=ffff88007fc0b600 used=0
per=ffff88007f80f780 cfg=1301c2 xtra=0
[  397.477949] CPU0 commit_txn ret=0

Two groups = two calls to group_sched_in() = 2 calls to commit_txn() =
2 calls to x86_schedule_events()
= 2 calls to  intel_percore_constraints().

In the second call, the first event is resubmitted because this is
incremental. The scheduler needs to revisit
the entire assignment. Thus, you have an imbalance of
get_constraints() vs. put_constraints() in the end
and it's game over.

One may wonder how come AMD NB events don't suffer from the same
problem, after all there is some shared
state. I think the reason is that we track down the owner, i.e., the
event which allocated the resource first. If we
come twice with the same event, we don't do the allocation again.

I think the problem here is slightly different, though, because you
want to allow other events with the identical
extra_config value. Given this is shared between HT threads, you don't
want to release the resource and reallocate
again because you may lose access. Maybe a solution would be to tag
events as percore allocated, and skip
those the second time around. There cannot be a ref++ on an event that
has already done ref++ once and without
callin put_constraint() in between.

Anyway, there is a scheduling problem and it needs some more thinking.....



On Sun, Feb 20, 2011 at 5:56 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Intel Nehalem/Westmere have a special OFFCORE_RESPONSE event
> that can be used to monitor any offcore accesses from a core.
> This is a very useful event for various tunings, and it's
> also needed to implement the generic LLC-* events correctly.
>
> Unfortunately this event requires programming a mask in a separate
> register. And worse this separate register is per core, not per
> CPU thread.
>
> This patch adds:
> - Teaches perf_events that OFFCORE_RESPONSE needs extra parameters.
> The extra parameters are passed by user space in the
> perf_event_attr::event_extra field.
> - Add support to the Intel perf_event core to schedule per
> core resources. This adds fairly generic infrastructure that
> can be also used for other per core resources.
> The basic code has is patterned after the similar AMD northbridge
> constraints code.
>
> Thanks to Stephane Eranian who pointed out some problems
> in the original version and suggested improvements.
>
> Cc: eranian@google.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c       |   64 ++++++++++
>  arch/x86/kernel/cpu/perf_event_intel.c |  198 ++++++++++++++++++++++++++++++++
>  include/linux/perf_event.h             |    7 +-
>  3 files changed, 268 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 10bfe24..de8e0bd 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -93,6 +93,8 @@ struct amd_nb {
>        struct event_constraint event_constraints[X86_PMC_IDX_MAX];
>  };
>
> +struct intel_percore;
> +
>  #define MAX_LBR_ENTRIES                16
>
>  struct cpu_hw_events {
> @@ -128,6 +130,13 @@ struct cpu_hw_events {
>        struct perf_branch_entry        lbr_entries[MAX_LBR_ENTRIES];
>
>        /*
> +        * Intel percore register state.
> +        * Coordinate shared resources between HT threads.
> +        */
> +       int                             percore_used; /* Used by this CPU? */
> +       struct intel_percore            *per_core;
> +
> +       /*
>         * AMD specific bits
>         */
>        struct amd_nb           *amd_nb;
> @@ -175,6 +184,28 @@ struct cpu_hw_events {
>  #define for_each_event_constraint(e, c)        \
>        for ((e) = (c); (e)->weight; (e)++)
>
> +/*
> + * Extra registers for specific events.
> + * Some events need large masks and require external MSRs.
> + * Define a mapping to these extra registers.
> + */
> +struct extra_reg {
> +       unsigned int            event;
> +       unsigned int            msr;
> +       u64                     config_mask;
> +       u64                     valid_mask;
> +};
> +
> +#define EVENT_EXTRA_REG(e, ms, m, vm) {        \
> +       .event = (e),           \
> +       .msr = (ms),            \
> +       .config_mask = (m),     \
> +       .valid_mask = (vm),     \
> +       }
> +#define INTEL_EVENT_EXTRA_REG(event, msr, vm)  \
> +       EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm)
> +#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0)
> +
>  union perf_capabilities {
>        struct {
>                u64     lbr_format    : 6;
> @@ -219,6 +250,7 @@ struct x86_pmu {
>        void            (*put_event_constraints)(struct cpu_hw_events *cpuc,
>                                                 struct perf_event *event);
>        struct event_constraint *event_constraints;
> +       struct event_constraint *percore_constraints;
>        void            (*quirks)(void);
>        int             perfctr_second_write;
>
> @@ -247,6 +279,11 @@ struct x86_pmu {
>         */
>        unsigned long   lbr_tos, lbr_from, lbr_to; /* MSR base regs       */
>        int             lbr_nr;                    /* hardware stack size */
> +
> +       /*
> +        * Extra registers for events
> +        */
> +       struct extra_reg *extra_regs;
>  };
>
>  static struct x86_pmu x86_pmu __read_mostly;
> @@ -339,6 +376,31 @@ static inline unsigned int x86_pmu_event_addr(int index)
>        return x86_pmu.perfctr + x86_pmu_addr_offset(index);
>  }
>
> +/*
> + * Find and validate any extra registers to set up.
> + */
> +static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
> +{
> +       struct extra_reg *er;
> +
> +       event->hw.extra_reg = 0;
> +       event->hw.extra_config = 0;
> +
> +       if (!x86_pmu.extra_regs)
> +               return 0;
> +
> +       for (er = x86_pmu.extra_regs; er->msr; er++) {
> +               if (er->event != (config & er->config_mask))
> +                       continue;
> +               if (event->attr.event_extra & ~er->valid_mask)
> +                       return -EINVAL;
> +               event->hw.extra_reg = er->msr;
> +               event->hw.extra_config = event->attr.event_extra;
> +               break;
> +       }
> +       return 0;
> +}
> +
>  static atomic_t active_events;
>  static DEFINE_MUTEX(pmc_reserve_mutex);
>
> @@ -663,6 +725,8 @@ static void x86_pmu_disable(struct pmu *pmu)
>  static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
>                                          u64 enable_mask)
>  {
> +       if (hwc->extra_reg)
> +               wrmsrl(hwc->extra_reg, hwc->extra_config);
>        wrmsrl(hwc->config_base, hwc->config | enable_mask);
>  }
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 084b383..cc49201 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1,5 +1,27 @@
>  #ifdef CONFIG_CPU_SUP_INTEL
>
> +#define MAX_EXTRA_REGS 2
> +
> +/*
> + * Per register state.
> + */
> +struct er_account {
> +       int                     ref;            /* reference count */
> +       unsigned int            extra_reg;      /* extra MSR number */
> +       u64                     extra_config;   /* extra MSR config */
> +};
> +
> +/*
> + * Per core state
> + * This used to coordinate shared registers for HT threads.
> + */
> +struct intel_percore {
> +       raw_spinlock_t          lock;           /* protect structure */
> +       struct er_account       regs[MAX_EXTRA_REGS];
> +       int                     refcnt;         /* number of threads */
> +       unsigned                core_id;
> +};
> +
>  /*
>  * Intel PerfMon, used on Core and later.
>  */
> @@ -64,6 +86,18 @@ static struct event_constraint intel_nehalem_event_constraints[] =
>        EVENT_CONSTRAINT_END
>  };
>
> +static struct extra_reg intel_nehalem_extra_regs[] =
> +{
> +       INTEL_EVENT_EXTRA_REG(0xb7, 0x1a6, 0xffff), /* OFFCORE_RESPONSE_0 */
> +       EVENT_EXTRA_END
> +};
> +
> +static struct event_constraint intel_nehalem_percore_constraints[] =
> +{
> +       INTEL_EVENT_CONSTRAINT(0xb7, 0),
> +       EVENT_CONSTRAINT_END
> +};
> +
>  static struct event_constraint intel_westmere_event_constraints[] =
>  {
>        FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
> @@ -76,6 +110,20 @@ static struct event_constraint intel_westmere_event_constraints[] =
>        EVENT_CONSTRAINT_END
>  };
>
> +static struct extra_reg intel_westmere_extra_regs[] =
> +{
> +       INTEL_EVENT_EXTRA_REG(0xb7, 0x1a6, 0xffff), /* OFFCORE_RESPONSE_0 */
> +       INTEL_EVENT_EXTRA_REG(0xbb, 0x1a7, 0xffff), /* OFFCORE_RESPONSE_1 */
> +       EVENT_EXTRA_END
> +};
> +
> +static struct event_constraint intel_westmere_percore_constraints[] =
> +{
> +       INTEL_EVENT_CONSTRAINT(0xb7, 0),
> +       INTEL_EVENT_CONSTRAINT(0xbb, 0),
> +       EVENT_CONSTRAINT_END
> +};
> +
>  static struct event_constraint intel_gen_event_constraints[] =
>  {
>        FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
> @@ -794,6 +842,66 @@ intel_bts_constraints(struct perf_event *event)
>  }
>
>  static struct event_constraint *
> +intel_percore_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
> +{
> +       struct hw_perf_event *hwc = &event->hw;
> +       unsigned int e = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
> +       struct event_constraint *c;
> +       struct intel_percore *pc;
> +       struct er_account *era;
> +       int i;
> +       int free_slot;
> +       int found;
> +
> +       if (!x86_pmu.percore_constraints)
> +               return NULL;
> +
> +       for (c = x86_pmu.percore_constraints; c->cmask; c++) {
> +               if (e != c->code)
> +                       continue;
> +
> +               /*
> +                * Allocate resource per core.
> +                */
> +               c = NULL;
> +               pc = cpuc->per_core;
> +               if (!pc)
> +                       break;
> +               c = &emptyconstraint;
> +               raw_spin_lock(&pc->lock);
> +               free_slot = -1;
> +               found = 0;
> +               for (i = 0; i < MAX_EXTRA_REGS; i++) {
> +                       era = &pc->regs[i];
> +                       if (era->ref > 0 && hwc->extra_reg == era->extra_reg) {
> +                               /* Allow sharing same config */
> +                               if (hwc->extra_config == era->extra_config) {
> +                                       era->ref++;
> +                                       cpuc->percore_used = 1;
> +                                       c = NULL;
> +                               }
> +                               /* else conflict */
> +                               found = 1;
> +                               break;
> +                       } else if (era->ref == 0 && free_slot == -1)
> +                               free_slot = i;
> +               }
> +               if (!found && free_slot != -1) {
> +                       era = &pc->regs[free_slot];
> +                       era->ref = 1;
> +                       era->extra_reg = hwc->extra_reg;
> +                       era->extra_config = hwc->extra_config;
> +                       cpuc->percore_used = 1;
> +                       c = NULL;
> +               }
> +               raw_spin_unlock(&pc->lock);
> +               return c;
> +       }
> +
> +       return NULL;
> +}
> +
> +static struct event_constraint *
>  intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
>  {
>        struct event_constraint *c;
> @@ -806,9 +914,50 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
>        if (c)
>                return c;
>
> +       c = intel_percore_constraints(cpuc, event);
> +       if (c)
> +               return c;
> +
>        return x86_get_event_constraints(cpuc, event);
>  }
>
> +static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
> +                                       struct perf_event *event)
> +{
> +       struct extra_reg *er;
> +       struct intel_percore *pc;
> +       struct er_account *era;
> +       struct hw_perf_event *hwc = &event->hw;
> +       int i, allref;
> +
> +       if (!cpuc->percore_used)
> +               return;
> +
> +       for (er = x86_pmu.extra_regs; er->msr; er++) {
> +               if (er->event != (hwc->config & er->config_mask))
> +                       continue;
> +
> +               pc = cpuc->per_core;
> +               raw_spin_lock(&pc->lock);
> +               for (i = 0; i < MAX_EXTRA_REGS; i++) {
> +                       era = &pc->regs[i];
> +                       if (era->ref > 0 &&
> +                           era->extra_config == hwc->extra_config &&
> +                           era->extra_reg == er->msr) {
> +                               era->ref--;
> +                               break;
> +                       }
> +               }
> +               allref = 0;
> +               for (i = 0; i < MAX_EXTRA_REGS; i++)
> +                       allref += pc->regs[i].ref;
> +               if (allref == 0)
> +                       cpuc->percore_used = 0;
> +               raw_spin_unlock(&pc->lock);
> +               break;
> +       }
> +}
> +
>  static int intel_pmu_hw_config(struct perf_event *event)
>  {
>        int ret = x86_pmu_hw_config(event);
> @@ -880,11 +1029,43 @@ static __initconst const struct x86_pmu core_pmu = {
>         */
>        .max_period             = (1ULL << 31) - 1,
>        .get_event_constraints  = intel_get_event_constraints,
> +       .put_event_constraints  = intel_put_event_constraints,
>        .event_constraints      = intel_core_event_constraints,
>  };
>
> +static int intel_pmu_cpu_prepare(int cpu)
> +{
> +       struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
> +
> +       cpuc->per_core = kzalloc_node(sizeof(struct intel_percore),
> +                                     GFP_KERNEL, cpu_to_node(cpu));
> +       if (!cpuc->per_core)
> +               return NOTIFY_BAD;
> +
> +       raw_spin_lock_init(&cpuc->per_core->lock);
> +       cpuc->per_core->core_id = -1;
> +       return NOTIFY_OK;
> +}
> +
>  static void intel_pmu_cpu_starting(int cpu)
>  {
> +       struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
> +       int core_id = topology_core_id(cpu);
> +       int i;
> +
> +       for_each_online_cpu(i) {
> +               struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
> +
> +               if (pc && pc->core_id == core_id) {
> +                       kfree(cpuc->per_core);
> +                       cpuc->per_core = pc;
> +                       break;
> +               }
> +       }
> +
> +       cpuc->per_core->core_id = core_id;
> +       cpuc->per_core->refcnt++;
> +
>        init_debug_store_on_cpu(cpu);
>        /*
>         * Deal with CPUs that don't clear their LBRs on power-up.
> @@ -894,6 +1075,15 @@ static void intel_pmu_cpu_starting(int cpu)
>
>  static void intel_pmu_cpu_dying(int cpu)
>  {
> +       struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
> +       struct intel_percore *pc = cpuc->per_core;
> +
> +       if (pc) {
> +               if (pc->core_id == -1 || --pc->refcnt == 0)
> +                       kfree(pc);
> +               cpuc->per_core = NULL;
> +       }
> +
>        fini_debug_store_on_cpu(cpu);
>  }
>
> @@ -918,7 +1108,9 @@ static __initconst const struct x86_pmu intel_pmu = {
>         */
>        .max_period             = (1ULL << 31) - 1,
>        .get_event_constraints  = intel_get_event_constraints,
> +       .put_event_constraints  = intel_put_event_constraints,
>
> +       .cpu_prepare            = intel_pmu_cpu_prepare,
>        .cpu_starting           = intel_pmu_cpu_starting,
>        .cpu_dying              = intel_pmu_cpu_dying,
>  };
> @@ -1036,7 +1228,10 @@ static __init int intel_pmu_init(void)
>                intel_pmu_lbr_init_nhm();
>
>                x86_pmu.event_constraints = intel_nehalem_event_constraints;
> +               x86_pmu.percore_constraints =
> +                       intel_nehalem_percore_constraints;
>                x86_pmu.enable_all = intel_pmu_nhm_enable_all;
> +               x86_pmu.extra_regs = intel_nehalem_extra_regs;
>                pr_cont("Nehalem events, ");
>                break;
>
> @@ -1058,7 +1253,10 @@ static __init int intel_pmu_init(void)
>                intel_pmu_lbr_init_nhm();
>
>                x86_pmu.event_constraints = intel_westmere_event_constraints;
> +               x86_pmu.percore_constraints =
> +                       intel_westmere_percore_constraints;
>                x86_pmu.enable_all = intel_pmu_nhm_enable_all;
> +               x86_pmu.extra_regs = intel_westmere_extra_regs;
>                pr_cont("Westmere events, ");
>                break;
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 8ceb5a6..f531ce3 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -225,7 +225,10 @@ struct perf_event_attr {
>        };
>
>        __u32                   bp_type;
> -       __u64                   bp_addr;
> +       union {
> +               __u64           bp_addr;
> +               __u64           event_extra; /* Extra for some events */
> +       };
>        __u64                   bp_len;
>  };
>
> @@ -541,6 +544,8 @@ struct hw_perf_event {
>                        unsigned long   event_base;
>                        int             idx;
>                        int             last_cpu;
> +                       unsigned int    extra_reg;
> +                       u64             extra_config;
>                };
>                struct { /* software */
>                        struct hrtimer  hrtimer;
> --
> 1.7.3
>
>
>
>
