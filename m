Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab0LVKII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:08:08 -0500
Received: from smtp-out.google.com ([216.239.44.51]:27923 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab0LVKIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:08:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uVAb8/tnDCPh+fagHL2IRdFfbrFc+vPHIN6TmE/wthveiiJfWSKc+q/RzJ5loYZYmi
         +xIHmgM/6BgaQsOPOrgw==
MIME-Version: 1.0
In-Reply-To: <1293008431.2170.63.camel@laptop>
References: <1293005543.2565.156.camel@minggr.sh.intel.com>
	<1293008431.2170.63.camel@laptop>
Date: Wed, 22 Dec 2010 11:08:02 +0100
Message-ID: <AANLkTintfpyvx=Pj1+uu8kCkFn3zT6b36h27Hb7pm=ZF@mail.gmail.com>
Subject: Re: [RFC PATCH] perf: Add load latency monitoring on Intel Nehalem/Westmere
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, paulus <paulus@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 22, 2010 at 10:00 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2010-12-22 at 16:12 +0800, Lin Ming wrote:
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
>> index ed6ff11..2a02529 100644
>> --- a/arch/x86/kernel/cpu/perf_event.c
>> +++ b/arch/x86/kernel/cpu/perf_event.c
>> @@ -197,18 +197,25 @@ struct extra_reg {
>>         unsigned int            extra_shift;
>>         u64                     config_mask;
>>         u64                     valid_mask;
>> +       u64                     flags;
>>  };
>>
>> -#define EVENT_EXTRA_REG(e, ms, m, vm, es) {    \
>> +#define EVENT_EXTRA_REG(e, ms, m, vm, es, f) { \
>>         .event = (e),           \
>>         .msr = (ms),            \
>>         .config_mask = (m),     \
>>         .valid_mask = (vm),     \
>>         .extra_shift = (es),    \
>> +       .flags = (f),   \
>>         }
>>  #define INTEL_EVENT_EXTRA_REG(event, msr, vm, es)      \
>> -       EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, es)
>> -#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, 0)
>> +       EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, es, 0)
>> +#define INTEL_EVENT_EXTRA_REG2(event, msr, vm, es, f)  \
>> +       EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT | \
>> +                       ARCH_PERFMON_EVENTSEL_UMASK, vm, es, f)
>> +#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, 0, 0)
>
> You'll need to increment MAX_EXTRA_REGS to 3 I think.
>
>> +#define EXTRA_REG_LD_LAT 0x1
>
> I'm not quite sure we actually need the whole flags business.
>
>>  union perf_capabilities {
>>         struct {
>> @@ -384,6 +391,11 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
>>                 if (extra & ~er->valid_mask)
>>                         return -EINVAL;
>>                 event->hw.extra_config = extra;
>> +               event->hw.extra_flags = er->flags;
>> +
>> +               /* The minimum value that may be programmed into MSR_PEBS_LD_LAT is 3 */
>> +               if ((er->flags & EXTRA_REG_LD_LAT) && extra < 3)
>> +                       event->hw.extra_config = 3;
>
>        if (er->msr == MSR_PEBS_LD_LAT_THRESHOLD && extra < 3)
>                event->hw.extra_config = 3;
>
>>                 break;
>>         }
>>         return 0;
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
>> index bc4afb1..7e2b873 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
>> @@ -89,6 +89,8 @@ static struct event_constraint intel_nehalem_event_constraints[] =
>>  static struct extra_reg intel_nehalem_extra_regs[] =
>>  {
>>         INTEL_EVENT_EXTRA_REG(0xb7, 0x1a6, 0xffff, 32), /* OFFCORE_RESPONSE */
>> +       /* MEM_INST_RETIRED.LATENCY_ABOVE_THRESHOLD */
>> +       INTEL_EVENT_EXTRA_REG2(0x100b, 0x3f6, 0xffff, 32, EXTRA_REG_LD_LAT),
>>         EVENT_EXTRA_END
>>  };
>
> Maybe use the MSR names instead of the numbers.
>
>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> index b7dcd9f..d008c40 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> @@ -376,6 +376,7 @@ static struct event_constraint intel_core_pebs_events[] = {
>>  };
>>
>>  static struct event_constraint intel_nehalem_pebs_events[] = {
>> +       PEBS_EVENT_CONSTRAINT(0x100b, 0xf), /* MEM_INST_RETIRED.LATENCY_ABOVE_THRESHOLD */
>>         PEBS_EVENT_CONSTRAINT(0x00c0, 0xf), /* INSTR_RETIRED.ANY */
>>         PEBS_EVENT_CONSTRAINT(0xfec1, 0xf), /* X87_OPS_RETIRED.ANY */
>>         PEBS_EVENT_CONSTRAINT(0x00c5, 0xf), /* BR_INST_RETIRED.MISPRED */
>> @@ -414,6 +415,8 @@ static void intel_pmu_pebs_enable(struct perf_event *event)
>>         hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
>>
>>         cpuc->pebs_enabled |= 1ULL << hwc->idx;
>> +       if (hwc->extra_flags & EXTRA_REG_LD_LAT)
>> +               cpuc->pebs_enabled |= 1ULL << (hwc->idx + 32);
>
>        if (hwc->extra_reg == MSR_PEBS_LD_LAT_THRESHOLD)
>                cpuc->pebs_enabled |= 1ULL << (hwc->idx + 32);
>
>>         WARN_ON_ONCE(cpuc->enabled);
>>
>>         if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
>> @@ -426,6 +429,8 @@ static void intel_pmu_pebs_disable(struct perf_event *event)
>>         struct hw_perf_event *hwc = &event->hw;
>>
>>         cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
>> +       if (hwc->extra_flags & EXTRA_REG_LD_LAT)
>> +               cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
>
>        if (hwx->extra_reg == MSR_PEBS_LD_LAT_THRESHOLD)
>                cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
>
>>         if (cpuc->enabled)
>>                 wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
>>
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index d24d9ab..38bffa4 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -541,6 +541,7 @@ struct hw_perf_event {
>>                         int             last_cpu;
>>                         unsigned int    extra_reg;
>>                         u64             extra_config;
>> +                       u64             extra_flags;
>>                 };
>>                 struct { /* software */
>>                         struct hrtimer  hrtimer;
>>
>
> Which then also obviates the need for this extra field.
>
> You also need some extra goo in intel_pmu_drain_pebs_nhm(), we can
> already use the PERF_SAMPLE_ADDR for the linear data address provided by
> the pebs-ll thing, and we might need to add:
>
>  PERF_SAMPLE_LATENCY -- Stephane said other archs can also use this
>
Extracting the instruction address is not so useful. You need the
instruction and data addresses, the latency and data source. As Peter
pointed out, you can use PERF_SAMPLE_ADDR for the data address.

True. And also we would need a PERF_SAMPLE_DATA_SRC to extract
the data source information. Other archs also have that.

Note that PEBS-Load latency needs the IP+1 correction. It points to the
instruction address after the load/lfetch. But I suspect your patch already
takes care of that.

> Not quite sure what to do for the source bits, POWER also has some extra
> bits, but I'm not sure they qualify as purely source bits. And
> interpreting them is going to be inherently arch specific, which
> sucks :/
>
>
Yes, I think there is more to it than just data source, unfortunately.
If you want to avoid returning an opaque u64 (PERF_SAMPLE_EXTRA), then
you need to break it down: PERF_SAMPLE_DATA_SRC, PERF_SAMPLE_XX
and so on.
