Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2ILQme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:42:34 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50923 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410Ab2ILQmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:42:32 -0400
MIME-Version: 1.0
In-Reply-To: <1347466967.15764.63.camel@twins>
References: <1347466967.15764.63.camel@twins>
Date: Wed, 12 Sep 2012 18:42:30 +0200
Message-ID: <CABPqkBQsJr_Cp36Df-etOaHhGh8T6XVngraDQt52ZtKahr6KBQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf, intel: Don't touch MSR_IA32_DEBUGCTLMSR from
 NMI context
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 6:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Oleg and Sebastian found that touching MSR_IA32_DEBUGCTLMSR from NMI
> context is problematic since the only way to change the various
> unrelated bits in there is:
>
>   debugctl = get_debugctlmsr()
>   /* frob flags in debugctl */
>   update_debugctlmsr(debugctl);
>
> Which is entirely unsafe if we prod at the MSR from NMI context.
>
> In particular the path that is responsible is:
>
>   x86_pmu_handle_irq() (NMI handler)
>     x86_pmu_stop()
>       x86_pmu.disable -> intel_pmu_disable_event()
>         intel_pmu_lbr_disable()
>           __intel_pmu_lbr_disable()
>             wrmsrl(MSR_IA32_DEBUGCTLMSR,... );
>
> So remove intel_pmu_lbr_{en,dis}able() from
> intel_pmu_{en,dis}able_event() and stick them in
> intel_{get,put}_event_constraints() which are only ever called from
> regular contexts.
>
Not sure this is going to work for LBR.

We use FREEZE_LBR_ON_PMI to sync LBR data with counter overflows.
That means, LBR is already frozen by the time we get to the handler. But
that means we need to re-enable LBR when we leave the handler. I don't
think EOI is going to magically re-enable it. So we need to touch DEBUGCTL
in the irq handler.



> We combine intel_pmu_needs_lbr_smpl(), which tells us if the events
> wants LBR data, with event->hw.branch_reg.alloc, which given
> intel_shared_regs_constraints() is set if our event got the shared
> resource, to give us a correctly balanced condition in
> {get,put}_event_constraints() for intel_pmu_lbr_{en,dis}able().
>
> Also change core_pmu to only use x86_get_event_constraints since it
> doesn't support any of the fancy DS (BTS,PEBS), LBR and OFFCORE features
> that make up intel_{get,put}_event_constraints.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 48 ++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 0d3d63a..ef4cd36 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -821,6 +821,11 @@ static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
>         return false;
>  }
>
> +static inline bool intel_pmu_has_lbr(struct perf_event *event)
> +{
> +       return intel_pmu_needs_lbr_smpl(event) && event->hw.branch_reg.alloc;
> +}
> +
>  static void intel_pmu_disable_all(void)
>  {
>         struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> @@ -975,13 +980,6 @@ static void intel_pmu_disable_event(struct perf_event *event)
>         cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
>         cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
>
> -       /*
> -        * must disable before any actual event
> -        * because any event may be combined with LBR
> -        */
> -       if (intel_pmu_needs_lbr_smpl(event))
> -               intel_pmu_lbr_disable(event);
> -
>         if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
>                 intel_pmu_disable_fixed(hwc);
>                 return;
> @@ -1036,12 +1034,6 @@ static void intel_pmu_enable_event(struct perf_event *event)
>                 intel_pmu_enable_bts(hwc->config);
>                 return;
>         }
> -       /*
> -        * must enabled before any actual event
> -        * because any event may be combined with LBR
> -        */
> -       if (intel_pmu_needs_lbr_smpl(event))
> -               intel_pmu_lbr_enable(event);
>
>         if (event->attr.exclude_host)
>                 cpuc->intel_ctrl_guest_mask |= (1ull << hwc->idx);
> @@ -1382,17 +1374,28 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
>
>         c = intel_bts_constraints(event);
>         if (c)
> -               return c;
> +               goto got_constraint;
>
>         c = intel_pebs_constraints(event);
>         if (c)
> -               return c;
> +               goto got_constraint;
>
>         c = intel_shared_regs_constraints(cpuc, event);
>         if (c)
> -               return c;
> +               goto got_constraint;
> +
> +       c = x86_get_event_constraints(cpuc, event);
> +
> +got_constraint:
>
> -       return x86_get_event_constraints(cpuc, event);
> +       /*
> +        * Must enabled before any actual event because any event may be
> +        * combined with LBR.
> +        */
> +       if (intel_pmu_has_lbr(event))
> +               intel_pmu_lbr_enable(event);
> +
> +       return c;
>  }
>
>  static void
> @@ -1413,6 +1416,14 @@ intel_put_shared_regs_event_constraints(struct cpu_hw_events *cpuc,
>  static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
>                                         struct perf_event *event)
>  {
> +       /*
> +        * Must disabled after any actual event because any event may be
> +        * combined with LBR, but must be done before releasing the shared
> +        * regs resource since that protects the LBR state.
> +        */
> +       if (intel_pmu_has_lbr(event))
> +               intel_pmu_lbr_disable(event);
> +
>         intel_put_shared_regs_event_constraints(cpuc, event);
>  }
>
> @@ -1623,8 +1634,7 @@ static __initconst const struct x86_pmu core_pmu = {
>          * the generic event period:
>          */
>         .max_period             = (1ULL << 31) - 1,
> -       .get_event_constraints  = intel_get_event_constraints,
> -       .put_event_constraints  = intel_put_event_constraints,
> +       .get_event_constraints  = x86_get_event_constraints,
>         .event_constraints      = intel_core_event_constraints,
>         .guest_get_msrs         = core_guest_get_msrs,
>         .format_attrs           = intel_arch_formats_attr,
>
