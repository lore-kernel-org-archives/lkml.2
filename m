Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab0DSMUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 08:20:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2770 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab0DSMUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:20:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Si13E2k8i8fvPGdlHtHDFgvESrWyYhlPOIN2LOtcBtamnLQBQA5v0kT8CynvFdxHR
	/3Omun+jZa0sn+53U304Q==
MIME-Version: 1.0
In-Reply-To: <1271190201-25705-13-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
	 <1271190201-25705-13-git-send-email-robert.richter@amd.com>
Date: Mon, 19 Apr 2010 14:19:57 +0200
Message-ID: <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com>
Subject: Re: [PATCH 12/12] perf, x86: implement the ibs interrupt handler
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

Robert,

Some comments below.

On Tue, Apr 13, 2010 at 10:23 PM, Robert Richter <robert.richter@amd.com> wrote:
> This patch implements code to handle ibs interrupts. If ibs data is
> available a raw perf_event data sample is created and sent back to the
> userland. Currently only the data is stored only in the raw data, but
> this could be extended in a later patch by generating generic event
> data such as the rip from the ibs sampling data.
>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/include/asm/msr-index.h     |    3 ++
>  arch/x86/kernel/cpu/perf_event_amd.c |   65 +++++++++++++++++++++++++++++++++-
>  2 files changed, 67 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index bc473ac..a7e4aa5 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -113,6 +113,7 @@
>  #define MSR_AMD64_IBSFETCHCTL          0xc0011030
>  #define MSR_AMD64_IBSFETCHLINAD                0xc0011031
>  #define MSR_AMD64_IBSFETCHPHYSAD       0xc0011032
> +#define MSR_AMD64_IBSFETCH_SIZE                3

I would use COUNT instead of size given the unit is registers not bytes.

>  #define MSR_AMD64_IBSOPCTL             0xc0011033
>  #define MSR_AMD64_IBSOPRIP             0xc0011034
>  #define MSR_AMD64_IBSOPDATA            0xc0011035
> @@ -120,7 +121,9 @@
>  #define MSR_AMD64_IBSOPDATA3           0xc0011037
>  #define MSR_AMD64_IBSDCLINAD           0xc0011038
>  #define MSR_AMD64_IBSDCPHYSAD          0xc0011039
> +#define MSR_AMD64_IBSOP_SIZE           7

Idem here for IBSOP.

>  #define MSR_AMD64_IBSCTL               0xc001103a
> +#define MSR_AMD64_IBS_SIZE_MAX         MSR_AMD64_IBSOP_SIZE
>
Idem.

>  /* Fam 10h MSRs */
>  #define MSR_FAM10H_MMIO_CONF_BASE      0xc0010058
> diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> index 3dc327c..78b0b34 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -283,6 +283,69 @@ static inline void __amd_pmu_enable_ibs_event(struct hw_perf_event *hwc)
>                __x86_pmu_enable_event(hwc, IBS_OP_ENABLE);
>  }
>
> +static int amd_pmu_check_ibs(int idx, unsigned int msr, u64 valid,
> +                            u64 reenable, int size, struct pt_regs *iregs)
> +{
> +       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +       struct perf_event *event = cpuc->events[idx];
> +       struct perf_sample_data data;
> +       struct perf_raw_record raw;
> +       struct pt_regs regs;
> +       u64 buffer[MSR_AMD64_IBS_SIZE_MAX];
> +       u64 *buf = buffer;
> +       int i;
> +
> +       if (!test_bit(idx, cpuc->active_mask))
> +               return 0;
> +
> +       rdmsrl(msr++, *buf);
> +       if (!(*buf++ & valid))
> +               return 0;
> +
> +       perf_sample_data_init(&data, 0);
> +       if (event->attr.sample_type & PERF_SAMPLE_RAW) {
> +               for (i = 1; i < size; i++)
> +                       rdmsrl(msr++, *buf++);
> +               raw.size = sizeof(u64) * size;
> +               raw.data = buffer;
> +               data.raw = &raw;
> +       }
> +

Need to add the padding: raw.size = sizeof(u64) * size + sizeof(u32);

> +       regs = *iregs; /* later: update ip from ibs sample */
> +
> +       if (perf_event_overflow(event, 1, &data, &regs))
> +               x86_pmu_stop(event);
> +       else
> +               __x86_pmu_enable_event(&event->hw, reenable);
> +
> +       return 1;
> +}
> +
> +static int amd_pmu_handle_irq(struct pt_regs *regs)
> +{
> +       int handled, handled2;
> +
> +       handled = x86_pmu_handle_irq(regs);
> +
> +       if (!x86_pmu.ibs)
> +               return handled;
> +
> +       handled2 = 0;
> +       handled2 += amd_pmu_check_ibs(X86_PMC_IDX_SPECIAL_IBS_FETCH,
> +                                     MSR_AMD64_IBSFETCHCTL, IBS_FETCH_VAL,
> +                                     IBS_FETCH_ENABLE, MSR_AMD64_IBSFETCH_SIZE,
> +                                     regs);
> +       handled2 += amd_pmu_check_ibs(X86_PMC_IDX_SPECIAL_IBS_OP,
> +                                     MSR_AMD64_IBSOPCTL, IBS_OP_VAL,
> +                                     IBS_OP_ENABLE, MSR_AMD64_IBSOP_SIZE,
> +                                     regs);
> +
> +       if (handled2)
> +               inc_irq_stat(apic_perf_irqs);
> +

If you have both regular counter intr + IBS you will double-count
apic_perf_irqs.
I would do: if (handled2 && !handled) inc_irq_stat().
