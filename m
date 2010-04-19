Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0DSNqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 09:46:36 -0400
Received: from smtp-out.google.com ([74.125.121.35]:10822 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0DSNqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 09:46:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=KMy2usHeFSuu47jZPs9OoYn7PqQYupSS2mPdCOBUsNOamCp/tp5oI7YM6/vCK5cK3
	vi80djIEjy9D/+G/7CpuQ==
MIME-Version: 1.0
In-Reply-To: <1271190201-25705-12-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
	 <1271190201-25705-12-git-send-email-robert.richter@amd.com>
Date: Mon, 19 Apr 2010 15:46:29 +0200
Message-ID: <h2obd4cb8901004190646v8231b6a1sf47d0cff6481cc5e@mail.gmail.com>
Subject: Re: [PATCH 11/12] perf, x86: implement AMD IBS event configuration
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comments below:

On Tue, Apr 13, 2010 at 10:23 PM, Robert Richter <robert.richter@amd.com> wrote:
> This patch implements IBS for perf_event. It extends the AMD pmu to
> handle model specific IBS events.
>
> With the attr.model_spec bit set we can setup hardware events others
> than generic performance counters. A special PMU 64 bit config value
> can be passed through the perf_event interface. The concept of PMU
> model-specific arguments was practiced already in Perfmon2. The type
> of event (8 bits) is determinded from the config value too, bit 32-39
> are reserved for this.
>
> There are two types of IBS events for instruction fetch (IBS_FETCH)
> and instruction execution (IBS_OP). Both events are implemented as
> special x86 events. The event allocation is implemented by using
> special event constraints for ibs. This way, the generic event
> scheduler can be used to allocate ibs events.
>
> IBS can only be set up with raw (model specific) config values and raw
> data samples. The event attributes for the syscall should be
> programmed like this (IBS_FETCH):
>
>        memset(&attr, 0, sizeof(attr));
>        attr.type        = PERF_TYPE_RAW;
>        attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
>        attr.config      = IBS_FETCH_CONFIG_DEFAULT
>        attr.config     |=
>                ((unsigned long long)MODEL_SPEC_TYPE_IBS_FETCH << 32)
>                & MODEL_SPEC_TYPE_MASK;
>        attr.model_spec  = 1;
>
> The whole ibs example will be part of libpfm4.
>
> The next patch implements the ibs interrupt handler.
>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/include/asm/perf_event.h    |    4 +-
>  arch/x86/kernel/cpu/perf_event.c     |   20 ++++
>  arch/x86/kernel/cpu/perf_event_amd.c |  161 ++++++++++++++++++++++++++++++++-
>  3 files changed, 179 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 9f10215..fd5c326 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -102,13 +102,15 @@ union cpuid10_edx {
>  #define X86_PMC_IDX_FIXED_BUS_CYCLES                   (X86_PMC_IDX_FIXED + 2)
>
>  /*
> - * We model BTS tracing as another fixed-mode PMC.
> + * Masks for special PMU features
>  *
>  * We choose a value in the middle of the fixed event range, since lower
>  * values are used by actual fixed events and higher values are used
>  * to indicate other overflow conditions in the PERF_GLOBAL_STATUS msr.
>  */
>  #define X86_PMC_IDX_SPECIAL_BTS                                (X86_PMC_IDX_SPECIAL + 0)
> +#define X86_PMC_IDX_SPECIAL_IBS_FETCH                  (X86_PMC_IDX_SPECIAL + 1)
> +#define X86_PMC_IDX_SPECIAL_IBS_OP                     (X86_PMC_IDX_SPECIAL + 2)
>
>  /* IbsFetchCtl bits/masks */
>  #define IBS_FETCH_RAND_EN              (1ULL<<57)
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 8f9674f..e2328f4 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -184,6 +184,26 @@ union perf_capabilities {
>  };
>
>  /*
> + * Model specific hardware events
> + *
> + * With the attr.model_spec bit set we can setup hardware events
> + * others than generic performance counters. A special PMU 64 bit
> + * config value can be passed through the perf_event interface. The
> + * concept of PMU model-specific arguments was practiced already in
> + * Perfmon2. The type of event (8 bits) is determinded from the config
> + * value too, bit 32-39 are reserved for this.
> + */
> +#define MODEL_SPEC_TYPE_IBS_FETCH      0
> +#define MODEL_SPEC_TYPE_IBS_OP         1
> +
> +#define MODEL_SPEC_TYPE_MASK           (0xFFULL << 32)
> +
> +static inline int get_model_spec_type(u64 config)
> +{
> +       return (config & MODEL_SPEC_TYPE_MASK) >> 32;
> +}
> +
> +/*
>  * struct x86_pmu - generic x86 pmu
>  */
>  struct x86_pmu {
> diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> index 27daead..3dc327c 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -2,6 +2,10 @@
>
>  #include <linux/pci.h>
>
> +#define IBS_FETCH_CONFIG_MASK  (IBS_FETCH_RAND_EN | IBS_FETCH_MAX_CNT)
> +#define IBS_OP_CONFIG_MASK     (IBS_OP_CNT_CTL | IBS_OP_MAX_CNT)
> +#define AMD64_NUM_COUNTERS     4
> +
>  static DEFINE_RAW_SPINLOCK(amd_nb_lock);
>
>  static __initconst const u64 amd_hw_cache_event_ids
> @@ -193,6 +197,118 @@ static void release_ibs_hardware(void)
>        clear_ibs_nmi();
>  }
>
> +static inline void amd_pmu_disable_ibs(void)
> +{
> +       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +       u64 val;
> +
> +       if (test_bit(X86_PMC_IDX_SPECIAL_IBS_FETCH, cpuc->active_mask)) {
> +               rdmsrl(MSR_AMD64_IBSFETCHCTL, val);
> +               val &= ~IBS_FETCH_ENABLE;
> +               wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
> +       }
> +       if (test_bit(X86_PMC_IDX_SPECIAL_IBS_OP, cpuc->active_mask)) {
> +               rdmsrl(MSR_AMD64_IBSOPCTL, val);
> +               val &= ~IBS_OP_ENABLE;
> +               wrmsrl(MSR_AMD64_IBSOPCTL, val);
> +       }
> +}
> +
> +static inline void amd_pmu_enable_ibs(void)
> +{
> +       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +       u64 val;
> +
> +       if (test_bit(X86_PMC_IDX_SPECIAL_IBS_FETCH, cpuc->active_mask)) {
> +               rdmsrl(MSR_AMD64_IBSFETCHCTL, val);
> +               val |= IBS_FETCH_ENABLE;
> +               wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
> +       }
> +       if (test_bit(X86_PMC_IDX_SPECIAL_IBS_OP, cpuc->active_mask)) {
> +               rdmsrl(MSR_AMD64_IBSOPCTL, val);
> +               val |= IBS_OP_ENABLE;
> +               wrmsrl(MSR_AMD64_IBSOPCTL, val);
> +       }
> +}

Aren't you picking up stale state by using read-modify-write here?

> +
> +static int amd_pmu_ibs_config(struct perf_event *event)
> +{
> +       int type;
> +
> +       if (!x86_pmu.ibs)
> +               return -ENODEV;
> +
> +       if (event->hw.sample_period)
> +               /*
> +                * The usage of the sample period attribute to
> +                * calculate the IBS max count value is not yet
> +                * supported, the max count must be in the raw config
> +                * value.
> +                */
> +               return -ENOSYS;
> +
What is the problem with directly using the period here, rejecting
any value that is off range or with bottom 4 bits set?

> +       if (event->attr.type != PERF_TYPE_RAW)
> +               /* only raw sample types are supported */
> +               return -EINVAL;
> +
> +       type = get_model_spec_type(event->attr.config);
> +       switch (type) {
> +       case MODEL_SPEC_TYPE_IBS_FETCH:
> +               event->hw.config = IBS_FETCH_CONFIG_MASK & event->attr.config;
> +               event->hw.idx = X86_PMC_IDX_SPECIAL_IBS_FETCH;
> +               /*
> +                * dirty hack, needed for __x86_pmu_enable_event(), we
> +                * should better change event->hw.config_base into
> +                * event->hw.config_msr that already includes the index
> +                */
> +               event->hw.config_base = MSR_AMD64_IBSFETCHCTL - event->hw.idx;
> +               break;
> +       case MODEL_SPEC_TYPE_IBS_OP:
> +               event->hw.config = IBS_OP_CONFIG_MASK & event->attr.config;
> +               event->hw.idx = X86_PMC_IDX_SPECIAL_IBS_OP;
> +               event->hw.config_base = MSR_AMD64_IBSOPCTL - event->hw.idx;
> +               break;

IBSOP.cnt_ctl only available from RevC, need to check and reject if older.


> +       default:
> +               return -ENODEV;
> +       }
> +
> +       return 0;
> +}
> +
> +static inline void __amd_pmu_enable_ibs_event(struct hw_perf_event *hwc)
> +{
> +       if (hwc->idx == X86_PMC_IDX_SPECIAL_IBS_FETCH)
> +               __x86_pmu_enable_event(hwc, IBS_FETCH_ENABLE);
> +       else if (hwc->idx == X86_PMC_IDX_SPECIAL_IBS_OP)
> +               __x86_pmu_enable_event(hwc, IBS_OP_ENABLE);
> +}
> +
> +static void amd_pmu_disable_all(void)
> +{
> +       x86_pmu_disable_all();
> +       amd_pmu_disable_ibs();
> +}
> +
> +static void amd_pmu_enable_all(int added)
> +{
> +       x86_pmu_enable_all(added);
> +       amd_pmu_enable_ibs();
> +}
> +
> +static void amd_pmu_enable_event(struct perf_event *event)
> +{
> +       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +       struct hw_perf_event *hwc = &event->hw;
> +
> +       if (!cpuc->enabled)
> +               return;
> +
> +       if (hwc->idx < X86_PMC_IDX_SPECIAL)
> +               __x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
> +       else
> +               __amd_pmu_enable_ibs_event(hwc);
> +}
> +
>  static u64 amd_pmu_event_map(int hw_event)
>  {
>        return amd_perfmon_event_map[hw_event];
> @@ -200,7 +316,12 @@ static u64 amd_pmu_event_map(int hw_event)
>
>  static int amd_pmu_hw_config(struct perf_event *event)
>  {
> -       int ret = x86_pmu_hw_config(event);
> +       int ret;
> +
> +       if (event->attr.model_spec)
> +               return amd_pmu_ibs_config(event);
> +
> +       ret = x86_pmu_hw_config(event);
>
>        if (ret)
>                return ret;
> @@ -214,6 +335,23 @@ static int amd_pmu_hw_config(struct perf_event *event)
>  }
>
>  /*
> + * AMD64 events - list of special events (IBS)
> + */
> +static struct event_constraint amd_event_constraints[] =
> +{
> +       /*
> +        * The value for the weight of these constraints is higher
> +        * than in the unconstrainted case to process ibs after the
> +        * generic counters in x86_schedule_events().
> +        */
> +       __EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_SPECIAL_IBS_FETCH, 0,
> +                          AMD64_NUM_COUNTERS + 1),
> +       __EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_SPECIAL_IBS_OP, 0,
> +                          AMD64_NUM_COUNTERS + 1),
> +       EVENT_CONSTRAINT_END
> +};
> +
I think you could define EVENT_IBS_CONSTRAINT() and shorten
the definitions here. You could pass FETCH or OP and the macro
would do the bit shifting. This is how it's done for fixed counters on Intel.
