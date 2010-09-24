Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab0IXNiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:38:21 -0400
Received: from smtp-out.google.com ([74.125.121.35]:11274 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab0IXNiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=POF06uvwhrSHhxF51LDRkekuEtcl9BBQmrc0Ymr+qNdXK8El85Zx2F8J60DK5F0t7P
         G39So3H2OLDNpzRNRKug==
MIME-Version: 1.0
In-Reply-To: <20100924100345.GE13563@erda.amd.com>
References: <20100910155659.GD13563@erda.amd.com>
	<20100911094157.GA11521@elte.hu>
	<20100911114404.GE13563@erda.amd.com>
	<20100911124537.GA22850@elte.hu>
	<20100912095202.GF13563@erda.amd.com>
	<20100913143713.GK13563@erda.amd.com>
	<20100914174132.GN13563@erda.amd.com>
	<20100915162034.GO13563@erda.amd.com>
	<20100924000234.GO26290@redhat.com>
	<20100924031834.GP26290@redhat.com>
	<20100924100345.GE13563@erda.amd.com>
Date: Fri, 24 Sep 2010 15:38:15 +0200
Message-ID: <AANLkTimeAbm6eHsf++-5OO6ba9zDYehw=W_zfbi+2Z=g@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling counters
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 12:03 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 23.09.10 23:18:34, Don Zickus wrote:
>
>> > I was able to duplicate the problem and can confirm this patch fixes the
>> > issue for me.  I tried poking around (similar to things Robert probably
>> > did) and had no luck.  Something just doesn't make sense, but I guess for
>> > now this patch is good enough for me. :-)
>>
>> Ah ha!  I figured out what the problem was, need to disable the pmu while
>> processing the nmi. :-)   Finally something simple in this crazy unknown
>> NMI spree.
>>
>> Oh yeah and trace_printk is now my new favorite tool!
>>
>> From: Don Zickus <dzickus@redhat.com>
>> Date: Thu, 23 Sep 2010 22:52:09 -0400
>> Subject: [PATCH] x86, perf: disable pmu from counting when processing irq
>>
>> On certain AMD and Intel machines, the pmu was left enabled
>> while the counters were reset during handling of the NMI.
>> After the counters are reset, code continues to process an
>> overflow.  During this time another counter overflow interrupt
>> could happen because the counter is still ticking.  This leads to
>> an unknown NMI.
>
> I don't like the approach of disabling all counters in the nmi
> handler. First, it stops counting and thus may falsify
> measurement. Second, it introduces much overhead doing a rd-/wrmsrl()
> for each counter.
>
But that's exactly what is going on the Intel side. PMU is stopped on interrupt.
An argument for this is that you don't necessarily want to monitor across
the PMU handler, i.e., the overhead you introduce.

> Does your patch below solve something that my patch doesn't?
>
> Btw, Ingo, my patch should be applied to tip/perf/urgent as it fixes
> the regression you discovered on AMD systems.
>
> Thanks,
>
> -Robert
>
>>
>> static int x86_pmu_handle_irq(struct pt_regs *regs)
>> {
>>
>> <snip..>
>>
>>         for (idx = 0; idx < x86_pmu.num_counters; idx++) {
>>                 if (!test_bit(idx, cpuc->active_mask))
>>                         continue;
>>
>> <snip..>
>>
>> counter reset--> if (!x86_perf_event_set_period(event))
>>                         continue;
>>
>> still ticking--> if (perf_event_overflow(event, 1, &data, regs))
>> <boom overflow>
>> stopped here -->        x86_pmu_stop(event);
>>
>> The way to solve this is to disable the pmu while processing the
>> overflows and re-enable when done.
>>
>> Signed-off-by: Don Zickus <dzickus@redhat.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
>> index 48c6d8d..d4fe95d 100644
>> --- a/arch/x86/kernel/cpu/perf_event.c
>> +++ b/arch/x86/kernel/cpu/perf_event.c
>> @@ -1158,6 +1158,8 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
>>
>>       cpuc = &__get_cpu_var(cpu_hw_events);
>>
>> +     x86_pmu_disable_all();
>> +
>>       for (idx = 0; idx < x86_pmu.num_counters; idx++) {
>>               if (!test_bit(idx, cpuc->active_mask))
>>                       continue;
>> @@ -1182,6 +1184,8 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
>>                       x86_pmu_stop(event, 0);
>>       }
>>
>> +     x86_pmu_enable_all(0);
>> +
>>       if (handled)
>>               inc_irq_stat(apic_perf_irqs);
>>
>> --
>> 1.7.2.3
>>
>>
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
>
>
