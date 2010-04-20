Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0DTNKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 09:10:46 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:48848 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab0DTNKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:10:44 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lab9bhzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0L16F9I-01-AI2-02
X-M-MSG: 
Date: Tue, 20 Apr 2010 15:10:28 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/12] perf, x86: implement the ibs interrupt handler
Message-ID: <20100420131028.GS11907@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-13-git-send-email-robert.richter@amd.com>
 <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Apr 2010 13:10:29.0190 (UTC) FILETIME=[D974CE60:01CAE08A]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.04.10 14:19:57, Stephane Eranian wrote:
> > diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> > index bc473ac..a7e4aa5 100644
> > --- a/arch/x86/include/asm/msr-index.h
> > +++ b/arch/x86/include/asm/msr-index.h
> > @@ -113,6 +113,7 @@
> >  #define MSR_AMD64_IBSFETCHCTL          0xc0011030
> >  #define MSR_AMD64_IBSFETCHLINAD                0xc0011031
> >  #define MSR_AMD64_IBSFETCHPHYSAD       0xc0011032
> > +#define MSR_AMD64_IBSFETCH_SIZE                3
> 
> I would use COUNT instead of size given the unit is registers not bytes.

I will change the naming for all macros.

> > +static int amd_pmu_check_ibs(int idx, unsigned int msr, u64 valid,
> > +                            u64 reenable, int size, struct pt_regs *iregs)
> > +{
> > +       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> > +       struct perf_event *event = cpuc->events[idx];
> > +       struct perf_sample_data data;
> > +       struct perf_raw_record raw;
> > +       struct pt_regs regs;
> > +       u64 buffer[MSR_AMD64_IBS_SIZE_MAX];
> > +       u64 *buf = buffer;
> > +       int i;
> > +
> > +       if (!test_bit(idx, cpuc->active_mask))
> > +               return 0;
> > +
> > +       rdmsrl(msr++, *buf);
> > +       if (!(*buf++ & valid))
> > +               return 0;
> > +
> > +       perf_sample_data_init(&data, 0);
> > +       if (event->attr.sample_type & PERF_SAMPLE_RAW) {
> > +               for (i = 1; i < size; i++)
> > +                       rdmsrl(msr++, *buf++);
> > +               raw.size = sizeof(u64) * size;
> > +               raw.data = buffer;
> > +               data.raw = &raw;
> > +       }
> > +
> 
> Need to add the padding: raw.size = sizeof(u64) * size + sizeof(u32);

Yes, this triggers a warning. Will change it and add 4 padding bytes
at the buffer start (to be also 8 byte aligned).

> > +static int amd_pmu_handle_irq(struct pt_regs *regs)
> > +{
> > +       int handled, handled2;
> > +
> > +       handled = x86_pmu_handle_irq(regs);
> > +
> > +       if (!x86_pmu.ibs)
> > +               return handled;
> > +
> > +       handled2 = 0;
> > +       handled2 += amd_pmu_check_ibs(X86_PMC_IDX_SPECIAL_IBS_FETCH,
> > +                                     MSR_AMD64_IBSFETCHCTL, IBS_FETCH_VAL,
> > +                                     IBS_FETCH_ENABLE, MSR_AMD64_IBSFETCH_SIZE,
> > +                                     regs);
> > +       handled2 += amd_pmu_check_ibs(X86_PMC_IDX_SPECIAL_IBS_OP,
> > +                                     MSR_AMD64_IBSOPCTL, IBS_OP_VAL,
> > +                                     IBS_OP_ENABLE, MSR_AMD64_IBSOP_SIZE,
> > +                                     regs);
> > +
> > +       if (handled2)
> > +               inc_irq_stat(apic_perf_irqs);
> > +
> 
> If you have both regular counter intr + IBS you will double-count
> apic_perf_irqs.
> I would do: if (handled2 && !handled) inc_irq_stat().
> 

True, will change this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

