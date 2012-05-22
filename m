Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2EVLt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 07:49:58 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47163 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720Ab2EVLt5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 07:49:57 -0400
MIME-Version: 1.0
In-Reply-To: <4FBB7419.8090909@linux.vnet.ibm.com>
References: <4FBB7419.8090909@linux.vnet.ibm.com>
Date: Tue, 22 May 2012 13:49:55 +0200
Message-ID: <CABPqkBQOTVHnQ1CUs+cRwnAH5wyQt1_8pGTdDjd-FEoQ6YEhCQ@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Optimal way of reading LBR entries inside
 Intel PMU interrupt handler
From: Stephane Eranian <eranian@google.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 1:10 PM, Anshuman Khandual
<khandual@linux.vnet.ibm.com> wrote:
> perf, x86: Optimal way of reading LBR entries inside Intel PMU interrupt handler
>
>        We read LBR entries even if no event has requested for it either explicitly
>        through branch sampling or implicitly through precise IP. This patch would
>        fix this potential unnecessary read by moving the intel_pmu_lbr_read function.
>
But that's not quite the case because intel_pmu_lbr_read() checks:

       if (!cpuc->lbr_users)
                return;

> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 26b3e2f..c50da47 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1026,6 +1026,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
>        int bit, loops;
>        u64 status;
>        int handled;
> +       int lbr_read;
>
>        perf_sample_data_init(&data, 0);
>
> @@ -1061,16 +1062,16 @@ again:
>
>        inc_irq_stat(apic_perf_irqs);
>
> -       intel_pmu_lbr_read();
> -
>        /*
>         * PEBS overflow sets bit 62 in the global status register
>         */
>        if (__test_and_clear_bit(62, (unsigned long *)&status)) {
>                handled++;
> +               intel_pmu_lbr_read();
>                x86_pmu.drain_pebs(regs);
>        }
>
> +       lbr_read = 0;
>        for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
>                struct perf_event *event = cpuc->events[bit];
>
> @@ -1084,8 +1085,13 @@ again:
>
>                data.period = event->hw.last_period;
>
> -               if (has_branch_stack(event))
> +               if (has_branch_stack(event)) {
> +                       if(lbr_read == 0) {
> +                               intel_pmu_lbr_read();
> +                               lbr_read = 1;
> +                       }
>                        data.br_stack = &cpuc->lbr_stack;
> +               }
>
>                if (perf_event_overflow(event, &data, regs))
>                        x86_pmu_stop(event, 0);
>
