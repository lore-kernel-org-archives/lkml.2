Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264Ab2FENbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:31:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43167 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934202Ab2FENbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:31:20 -0400
MIME-Version: 1.0
In-Reply-To: <1338901490.28282.167.camel@twins>
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>
	<CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com>
	<1338891271.28282.155.camel@twins>
	<CABPqkBSv8CbMzUiRsN2uOF1v6rFTpzhQqNbo7OKe-nzsus0GDg@mail.gmail.com>
	<1338892071.28282.157.camel@twins>
	<CABPqkBSqLpa4X-WbR0PkouYvhODT78r3pxWq70=PTj1j=a307Q@mail.gmail.com>
	<1338898024.28282.160.camel@twins>
	<1338899999.28282.164.camel@twins>
	<CABPqkBRCMAnPH3UW0=afMw4-YXgwQ5D-NLMEtnNWde_Tzh3aew@mail.gmail.com>
	<1338901490.28282.167.camel@twins>
Date: Tue, 5 Jun 2012 15:31:18 +0200
Message-ID: <CABPqkBRF_2LXE-54tLMBnQgLKbKyR9qo+4VohQiOchpqe1pgyw@mail.gmail.com>
Subject: Re: [PATCH] perf: Fix intel shared extra msr allocation
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks nicer, still missing this little piece + is_fake definition and
setting is allocate_fakecpuc())

@@ -1210,7 +1210,7 @@ __intel_shared_reg_put_constraints(struct
cpu_hw_events *cpuc,
         * allocated. Also takes care of event which do
         * not use an extra shared reg
         */
-       if (!reg->alloc)
+       if (!reg->alloc || cpuc->is_fake)
                return;


On Tue, Jun 5, 2012 at 3:04 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-06-05 at 14:51 +0200, Stephane Eranian wrote:
>> So I think if you say in:
>> __intel_shared_reg_put_constraints()
>>
>>      if (!cpuc->is_fake)
>>            reg->alloc = 1;
>>
>> That should do it given that:
>>
>> __intel_shared_reg_put_constraints(struct cpu_hw_events *cpuc,
>>                                    struct hw_perf_event_extra *reg)
>> {
>>         struct er_account *era;
>>         if (!reg->alloc)
>>                 return;
>>
>> }
>>
>> But then, if reg->alloc was already set to 1, you will have a problem
>> if you leave
>> it as is. So I think in __intel_shared_reg_put_constraints(), you still need:
>>
>> __intel_shared_reg_put_constraints(struct cpu_hw_events *cpuc,
>>                                    struct hw_perf_event_extra *reg)
>> {
>>        if (!reg->alloc || cpuc->is_fake)
>>           return;
>>
>> Or something like that.
>
> Right, and then something slightly less hideous for intel_try_alt_er().
>
> How does something like this look?
>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |   43 +++++++++++++++++++++-----------
>  1 file changed, 28 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 166546e..a3b7eb3 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1119,27 +1119,33 @@ intel_bts_constraints(struct perf_event *event)
>        return NULL;
>  }
>
> -static bool intel_try_alt_er(struct perf_event *event, int orig_idx)
> +static int intel_alt_er(int idx)
>  {
>        if (!(x86_pmu.er_flags & ERF_HAS_RSP_1))
> -               return false;
> +               return idx;
>
> -       if (event->hw.extra_reg.idx == EXTRA_REG_RSP_0) {
> +       if (idx == EXTRA_REG_RSP_0)
> +               return EXTRA_REG_RSP_1;
> +
> +       if (idx == EXTRA_REG_RSP_1)
> +               return EXTRA_REG_RSP_0;
> +
> +       return idx;
> +}
> +
> +static void intel_fixup_er(struct perf_event *event, int idx)
> +{
> +       if (idx == EXTRA_REG_RSP_0) {
>                event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
>                event->hw.config |= 0x01bb;
>                event->hw.extra_reg.idx = EXTRA_REG_RSP_1;
>                event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
> -       } else if (event->hw.extra_reg.idx == EXTRA_REG_RSP_1) {
> +       } else if (idx == EXTRA_REG_RSP_1) {
>                event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
>                event->hw.config |= 0x01b7;
>                event->hw.extra_reg.idx = EXTRA_REG_RSP_0;
>                event->hw.extra_reg.reg = MSR_OFFCORE_RSP_0;
>        }
> -
> -       if (event->hw.extra_reg.idx == orig_idx)
> -               return false;
> -
> -       return true;
>  }
>
>  /*
> @@ -1157,14 +1163,14 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
>        struct event_constraint *c = &emptyconstraint;
>        struct er_account *era;
>        unsigned long flags;
> -       int orig_idx = reg->idx;
> +       int idx = reg->idx;
>
>        /* already allocated shared msr */
>        if (reg->alloc)
>                return NULL; /* call x86_get_event_constraint() */
>
>  again:
> -       era = &cpuc->shared_regs->regs[reg->idx];
> +       era = &cpuc->shared_regs->regs[idx];
>        /*
>         * we use spin_lock_irqsave() to avoid lockdep issues when
>         * passing a fake cpuc
> @@ -1181,16 +1187,23 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
>                atomic_inc(&era->ref);
>
>                /* no need to reallocate during incremental event scheduling */
> -               reg->alloc = 1;
> +               if (!cpuc->is_fake) {
> +                       if (idx != reg->idx)
> +                               intel_fixup_er(event, idx);
> +                       reg->alloc = 1;
> +               }
>
>                /*
>                 * need to call x86_get_event_constraint()
>                 * to check if associated event has constraints
>                 */
>                c = NULL;
> -       } else if (intel_try_alt_er(event, orig_idx)) {
> -               raw_spin_unlock_irqrestore(&era->lock, flags);
> -               goto again;
> +       } else {
> +               idx = intel_alt_er(idx);
> +               if (idx != reg->idx) {
> +                       raw_spin_unlock_irqrestore(&era->lock, flags);
> +                       goto again;
> +               }
>        }
>        raw_spin_unlock_irqrestore(&era->lock, flags);
>
>
