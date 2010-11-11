Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0KKSG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:06:58 -0500
Received: from smtp-out.google.com ([216.239.44.51]:20724 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab0KKSG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:06:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T22SXw6q/cFN3HaZKnwkOIUAb3wxeW9h8jO4N7CQZHgs2pDWpGKbLenDkMgwEXiOhD
         /KVKt2/Pgl/eA5UgWX2Q==
MIME-Version: 1.0
In-Reply-To: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
Date: Thu, 11 Nov 2010 19:06:53 +0100
Message-ID: <AANLkTi=3xQd-anvwXryXASr1+Th1HSjTn8j-ZcRZko3b@mail.gmail.com>
Subject: Re: [PATCH 1/3] perf-events: Add support for supplementary event registers
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, acme@redhat.com, Andi Kleen <ak@linux.intel.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

Thanks for creating this patch. It was on my TODO list for a while.
OFFCORE_RESPONSE is indeed a very useful event.

One thing I noticed in your patch is that you don't special
case the configuration where HT is off. In that case, the
sharing problem goes away. I think you could override
either way during init.

Some more tidbits:
- OFFCORE_RESPONSE_0 is 0x01b7
- OFFCORE_RESPONSE_1 is 0x01bb

The umask is not zero but 1. Dont' know if you get
something meaningful is you pass a umask of zero.
But that's the user's responsibility to set this right.

An alternative approach could have been to stash the
extra MSR value in the upper 32-bit value of the config.
It's 16-bit wide today. OFFCORE_RESPONSE is a
model specific event. There is no guarantee it will be
there in future CPU, so it would be safe to do that as well.

On Thu, Nov 11, 2010 at 5:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
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
> - Teaches perf_events that OFFCORE_RESPONSE need extra parameters.
> - Adds a new field to the user interface to pass the extra mask.
> This reuses one of the unused fields for perf events. The change
> is ABI neutral because noone is likely to have used OFFCORE_RESPONSE
> before (with zero mask it wouldn't count anything)
> - Add support to the Intel perf_event core to schedule the per
> core resource. I tried to add generic infrastructure for this
> that could be also used for other core resources.
> The basic code has is patterned after the similar AMD northbridge
> constraints code.
>
> Thanks to Stephane Eranian who pointed out some problems
> in the original version and suggested improvements.
>
> Cc: eranian@google.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c       |   56 +++++++++++++++
>  arch/x86/kernel/cpu/perf_event_intel.c |  120 ++++++++++++++++++++++++++++++++
>  include/linux/perf_event.h             |    7 ++-
>  3 files changed, 182 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index ed63101..97133ec 100644
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
> @@ -126,6 +128,8 @@ struct cpu_hw_events {
>        void                            *lbr_context;
>        struct perf_branch_stack        lbr_stack;
>        struct perf_branch_entry        lbr_entries[MAX_LBR_ENTRIES];
> +       int                             percore_used;
> +       struct intel_percore            *per_core;
>
>        /*
>         * AMD specific bits
> @@ -175,6 +179,24 @@ struct cpu_hw_events {
>  #define for_each_event_constraint(e, c)        \
>        for ((e) = (c); (e)->weight; (e)++)
>
> +/*
> + * Extra registers for specific events.
> + * Some events need large masks and require external MSRs.
> + * Define a mapping to these extra registers.
> + */
> +
> +struct extra_reg {
> +       unsigned event;
> +       unsigned msr;
> +       u64 config_mask;
> +       u64 valid_mask;
> +};
> +
> +#define EVENT_EXTRA_REG(event, msr, m, vm) { event, msr, m, vm }
> +#define INTEL_EVENT_EXTRA_REG(event, msr, vm) \
> +       EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm)
> +#define EVENT_EXTRA_END {}
> +
>  union perf_capabilities {
>        struct {
>                u64     lbr_format    : 6;
> @@ -219,6 +241,7 @@ struct x86_pmu {
>        void            (*put_event_constraints)(struct cpu_hw_events *cpuc,
>                                                 struct perf_event *event);
>        struct event_constraint *event_constraints;
> +       struct event_constraint *percore_constraints;
>        void            (*quirks)(void);
>        int             perfctr_second_write;
>
> @@ -247,6 +270,11 @@ struct x86_pmu {
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
> @@ -530,6 +558,28 @@ static int x86_pmu_hw_config(struct perf_event *event)
>  }
>
>  /*
> + * Find and validate any extra registers to set up.
> + */
> +static int x86_pmu_extra_regs(struct perf_event *event)
> +{
> +       struct extra_reg *er;
> +
> +       if (!x86_pmu.extra_regs)
> +               return 0;
> +
> +       for (er = x86_pmu.extra_regs; er->msr; er++) {
> +               if (er->event != (event->attr.config & er->config_mask))
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
> +/*
>  * Setup the hardware configuration for a given attr_type
>  */
>  static int __x86_pmu_event_init(struct perf_event *event)
> @@ -561,6 +611,10 @@ static int __x86_pmu_event_init(struct perf_event *event)
>        event->hw.last_cpu = -1;
>        event->hw.last_tag = ~0ULL;
>
> +       err = x86_pmu_extra_regs(event);
> +       if (err)
> +               return err;
> +
>        return x86_pmu.hw_config(event);
>  }
>
> @@ -876,6 +930,8 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
>                                          u64 enable_mask)
>  {
>        wrmsrl(hwc->config_base + hwc->idx, hwc->config | enable_mask);
> +       if (hwc->extra_reg)
> +               wrmsrl(hwc->extra_reg, hwc->extra_config);
>  }
>
>  static inline void x86_pmu_disable_event(struct perf_event *event)
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index c8f5c08..bbe7fba 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1,5 +1,14 @@
>  #ifdef CONFIG_CPU_SUP_INTEL
>
> +struct intel_percore {
> +       raw_spinlock_t lock;
> +       int ref;
> +       u64 config;
> +       unsigned extra_reg;
> +       u64 extra_config;
> +};
> +static DEFINE_PER_CPU(struct intel_percore, intel_percore);
> +
>  /*
>  * Intel PerfMon, used on Core and later.
>  */
> @@ -64,6 +73,18 @@ static struct event_constraint intel_nehalem_event_constraints[] =
>        EVENT_CONSTRAINT_END
>  };
>
> +static struct extra_reg intel_nehalem_extra_regs[] =
> +{
> +       INTEL_EVENT_EXTRA_REG(0xb7, 0x1a6, 0xffff), /* OFFCORE_RESPONSE1 */
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
> @@ -76,6 +97,20 @@ static struct event_constraint intel_westmere_event_constraints[] =
>        EVENT_CONSTRAINT_END
>  };
>
> +static struct extra_reg intel_westmere_extra_regs[] =
> +{
> +       INTEL_EVENT_EXTRA_REG(0xb7, 0x1a6, 0xffff), /* OFFCORE_RESPONSE1 */
> +       INTEL_EVENT_EXTRA_REG(0xbb, 0x1a7, 0xffff), /* OFFCORE_RESPONSE2 */
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
> @@ -794,6 +829,56 @@ intel_bts_constraints(struct perf_event *event)
>  }
>
>  static struct event_constraint *
> +intel_percore_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
> +{
> +       struct hw_perf_event *hwc = &event->hw;
> +       unsigned e = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
> +       struct event_constraint *c;
> +       struct intel_percore *pc;
> +
> +       if (!x86_pmu.percore_constraints)
> +               return NULL;
> +
> +       for (c = x86_pmu.percore_constraints; c->cmask; c++) {
> +               if (e != c->code)
> +                       continue;
> +
> +               c = NULL;
> +
> +               /*
> +                * Allocate resource per core.
> +                * Currently only one such per core resource can be allocated.
> +                */
> +               pc = cpuc->per_core;
> +               if (!pc)
> +                       break;
> +               raw_spin_lock(&pc->lock);
> +               if (pc->ref > 0) {
> +                       /* Allow identical settings */
> +                       if (hwc->config == pc->config &&
> +                           hwc->extra_reg == pc->extra_reg &&
> +                           hwc->extra_config == pc->extra_config) {
> +                               pc->ref++;
> +                               cpuc->percore_used = 1;
> +                       } else {
> +                               /* Deny due to conflict */
> +                               c = &emptyconstraint;
> +                       }
> +               } else {
> +                       pc->config = hwc->config;
> +                       pc->extra_reg = hwc->extra_reg;
> +                       pc->extra_config = hwc->extra_config;
> +                       pc->ref = 1;
> +                       cpuc->percore_used = 1;
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
> @@ -806,9 +891,29 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
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
> +       struct intel_percore *pc;
> +
> +       if (!cpuc->percore_used)
> +               return;
> +
> +       pc = cpuc->per_core;
> +       raw_spin_lock(&pc->lock);
> +       pc->ref--;
> +       BUG_ON(pc->ref < 0);
> +       raw_spin_unlock(&pc->lock);
> +       cpuc->percore_used = 0;
> +}
> +
>  static int intel_pmu_hw_config(struct perf_event *event)
>  {
>        int ret = x86_pmu_hw_config(event);
> @@ -854,6 +959,7 @@ static __initconst const struct x86_pmu core_pmu = {
>         */
>        .max_period             = (1ULL << 31) - 1,
>        .get_event_constraints  = intel_get_event_constraints,
> +       .put_event_constraints  = intel_put_event_constraints,
>        .event_constraints      = intel_core_event_constraints,
>  };
>
> @@ -929,6 +1035,7 @@ static __init int intel_pmu_init(void)
>        union cpuid10_eax eax;
>        unsigned int unused;
>        unsigned int ebx;
> +       int cpu;
>        int version;
>
>        if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
> @@ -1010,7 +1117,10 @@ static __init int intel_pmu_init(void)
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
> @@ -1032,7 +1142,10 @@ static __init int intel_pmu_init(void)
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
> @@ -1043,6 +1156,13 @@ static __init int intel_pmu_init(void)
>                x86_pmu.event_constraints = intel_gen_event_constraints;
>                pr_cont("generic architected perfmon, ");
>        }
> +
> +       for_each_possible_cpu(cpu) {
> +               raw_spin_lock_init(&per_cpu(intel_percore, cpu).lock);
> +               per_cpu(cpu_hw_events, cpu).per_core =
> +                       &per_cpu(intel_percore,
> +                                cpumask_first(topology_core_cpumask(cpu)));
> +       }
>        return 0;
>  }
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 057bf22..a353594 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -224,7 +224,10 @@ struct perf_event_attr {
>        };
>
>        __u32                   bp_type;
> -       __u64                   bp_addr;
> +       union {
> +               __u64                   bp_addr;
> +               __u64                   event_extra; /* Extra for some events */
> +       };
>        __u64                   bp_len;
>  };
>
> @@ -529,6 +532,8 @@ struct hw_perf_event {
>                        unsigned long   event_base;
>                        int             idx;
>                        int             last_cpu;
> +                       unsigned        extra_reg;
> +                       u64             extra_config;
>                };
>                struct { /* software */
>                        struct hrtimer  hrtimer;
> --
> 1.7.1
>
>
