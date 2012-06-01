Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab2FAJfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:35:52 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42797 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759312Ab2FAJfu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:35:50 -0400
MIME-Version: 1.0
In-Reply-To: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>
Date: Fri, 1 Jun 2012 11:35:48 +0200
Message-ID: <CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>
Subject: Re: [PATCH] perf: Fix intel shared extra msr allocation
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 5:20 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>
> intel_shared_reg_get/put_constraints() can be indirectly called
> by validate_group(). In that case, they should avoid modifying
> the perf_event date structure because the event can be already
> in active state. Otherwise the shared extra msr's reference
> count will be left in inconsistent state.
>
I understand the problem but I am wondering if you actually saw
it in real life. The reason I am asking is because  of the way
validate_group() collects the events and how they are added
to sibling_list. The new event is added at the tail. Thus it will
come last, and will get to __intel_shared_reg_get_constraints()
last, thus I am wondering if it can really modify the programming
on the existing events.

See more comments inline.

> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |   31 +++++++++++++++++++++++--------
>  1 files changed, 23 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 166546e..10840d0 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1119,11 +1119,21 @@ intel_bts_constraints(struct perf_event *event)
>        return NULL;
>  }
>
> -static bool intel_try_alt_er(struct perf_event *event, int orig_idx)
> +static bool intel_try_alt_er(struct perf_event *event, int *idx,
> +                            int orig_idx, bool fake_cpuc)
>  {
> -       if (!(x86_pmu.er_flags & ERF_HAS_RSP_1))
> +       if (!(x86_pmu.er_flags & ERF_HAS_RSP_1) || *idx != orig_idx)
>                return false;
>
> +       /* don't modify the event structure if the cpuc is faked */
> +       if (fake_cpuc) {
> +               if (*idx == EXTRA_REG_RSP_0)
> +                       *idx = EXTRA_REG_RSP_1;
> +               else if (*idx == EXTRA_REG_RSP_1)
> +                       *idx = EXTRA_REG_RSP_0;
> +               return (*idx != orig_idx);
> +       }
> +
I understand that.

>        if (event->hw.extra_reg.idx == EXTRA_REG_RSP_0) {
>                event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
>                event->hw.config |= 0x01bb;
> @@ -1139,6 +1149,7 @@ static bool intel_try_alt_er(struct perf_event *event, int orig_idx)
>        if (event->hw.extra_reg.idx == orig_idx)
>                return false;
>
> +       *idx = event->hw.extra_reg.idx;
>        return true;
>  }
>
> @@ -1155,16 +1166,18 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
>                                   struct hw_perf_event_extra *reg)
>  {
>        struct event_constraint *c = &emptyconstraint;
> +       struct intel_shared_regs *shared_regs = cpuc->shared_regs;
>        struct er_account *era;
>        unsigned long flags;
>        int orig_idx = reg->idx;
> +       int idx = orig_idx;
>
> -       /* already allocated shared msr */
> -       if (reg->alloc)
> +       /* shared msr is already allocated and cpuc is not faked */
> +       if (reg->alloc && shared_regs->core_id != -1)
>                return NULL; /* call x86_get_event_constraint() */
>
I don't understand what you need this stuff. Shared_regs is faked as well.

>  again:
> -       era = &cpuc->shared_regs->regs[reg->idx];
> +       era = &shared_regs->regs[idx];
>        /*
>         * we use spin_lock_irqsave() to avoid lockdep issues when
>         * passing a fake cpuc
> @@ -1181,14 +1194,16 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
>                atomic_inc(&era->ref);
>
>                /* no need to reallocate during incremental event scheduling */
> -               reg->alloc = 1;
> +               if (shared_regs->core_id != -1)
> +                       reg->alloc = 1;
>
>                /*
>                 * need to call x86_get_event_constraint()
>                 * to check if associated event has constraints
>                 */
>                c = NULL;
> -       } else if (intel_try_alt_er(event, orig_idx)) {
> +       } else if (intel_try_alt_er(event, &idx, orig_idx,
> +                                   shared_regs->core_id == -1)) {
>                raw_spin_unlock_irqrestore(&era->lock, flags);
>                goto again;
>        }
> @@ -1208,7 +1223,7 @@ __intel_shared_reg_put_constraints(struct cpu_hw_events *cpuc,
>         * allocated. Also takes care of event which do
>         * not use an extra shared reg
>         */
> -       if (!reg->alloc)
> +       if (!reg->alloc || cpuc->shared_regs->core_id == -1)
>                return;
>
>        era = &cpuc->shared_regs->regs[reg->idx];
> --
> 1.7.7.6
>
