Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2BPQMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:12:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53546 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab2BPQMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:12:53 -0500
MIME-Version: 1.0
In-Reply-To: <20120216150004.GE2641@mudshark.cambridge.arm.com>
References: <CAMQu2gzfNAwtf1c6jrTZpfGMSqBgBrQKmFTeCFzbvMh9ESBDUg@mail.gmail.com>
	<CAMsRxfKR1ODH56BtcUT5Dv6qOVEYGVheEcW9ugXsZmLKok==bg@mail.gmail.com>
	<CAMQu2gwWt6oQPjxc1YHgOoxVkHdck_q78Xf==7ncwRj0_uS-JQ@mail.gmail.com>
	<CAMQu2gyCPtbNfBa5V8ve2JORN+sDeAY+hvR0g0_9U354JgcuiA@mail.gmail.com>
	<CAMsRxfJVEgVJoHcaPQbMg5mwz=tZUce4oibDUxtnevSF8bGY9g@mail.gmail.com>
	<CAMQu2gxVUqDF2HkPD=QeX0N_tUd=9FTd+T+1LHCR0tsCgQxC8Q@mail.gmail.com>
	<CAMsRxfJH+9MS=Svmh0BvDSb8xqsPe2HPobkeKcn8JO35npjhwQ@mail.gmail.com>
	<CACVXFVMx9Zx3ZQr6Q-17x5NVL8iuBJjOjtw39FJiWX=fGkZNZA@mail.gmail.com>
	<1329323900.2293.150.camel@twins>
	<CACVXFVPce0A3LfL=mFo3UbN-Om7xLOo_d-LfKXDjdN5dFQdhiA@mail.gmail.com>
	<20120216150004.GE2641@mudshark.cambridge.arm.com>
Date: Fri, 17 Feb 2012 00:12:49 +0800
Message-ID: <CACVXFVM472hz+na7o2wJr1CPq-W=YB7i0UwtrsUf62+ryzWp8A@mail.gmail.com>
Subject: Re: oprofile and ARM A9 hardware counter
From: Ming Lei <ming.lei@canonical.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        David Long <dave.long@linaro.org>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "mans@mansr.com" <mans@mansr.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 11:00 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Feb 16, 2012 at 10:25:05AM +0000, Ming Lei wrote:
>> On Thu, Feb 16, 2012 at 12:38 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> >
>> > So what this patch seems to do is put that filter on period in
>> > perf_ctx_adjust_freq(). Not making sense.. nor can I see a HZ
>> > dependency, perf_ctx_adjust_freq() uses TICK_NSEC as time base.
>>
>> Yes, you are right, I remembered it was observed it on -rc1, and
>> Stephane's unthrottling
>> patch was not merged at that time. Today I investigated the problem
>> further on -rc3 and found that seems the problem is caused by arm pmu code.
>
> As I reported previously, Stephane's patch is causing warnings on -rc3:
>
> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-February/084391.html
>
> so I'd like to get to the bottom of that before changing anything else.

Looks I am luck enough and not see the warning on OMAP4, either -rc3 or
-rc3--next-20120210, :-)

Maybe we have different config options.

>
> I'd also like to know why this has only been reported on OMAP4 and I can't
> reproduce it on my boards.
>
>> The patch below may fix the problem, now about 40000 sample events
>> can be generated on the command:
>>
>>       'perf record -e cycles -F 4000  ./noploop 10&& perf report -D | tail -20'
>>
>> armpmu_event_update may be called in tick path, so the running counter
>> will be overflowed and produce a great value of 'delta', then a mistaken
>> count is stored into event->count and event->hw.freq_count_stamp. Finally
>> the two variables are not synchronous, then a invalid and large period is
>> computed and written to pmu, and sample events are decreased much.
>
> Hmm, so are you observing an event overflow during the tick handler? This

Yes, I am sure I can observe it without much difficulty.

> should be fine unless the new value has wrapped past the previous one (i.e.
> more than 2^32 events have occurred). I find this extremely unlikely for
> sample-based profiling unless you have some major IRQ latency issues...

IMO, it is not so difficult to get it, suppose prev_raw_count is
1000000 and -prev_raw_count
was write to one pmu counter, then the counter will be expired and pmu
irq is not handled
quickly enough, so the pmu counter will warp and start counting from zero.

When the tick is scheduled just before handling pmu irq,
armpmu_event_update() is
called to read the pmu counter as 'new_raw_count', suppose it is 100,
then the issue
is triggered: u64 delta = 100 -  1000000 = 18446744073708551716.

Looks the higher the frequency is, the easier the problem is reproduced.

>
> The only way I can think of improving this (bearing in mind that at some
> point we're limited by 32 bits of counter) is to check for overflow in the
> tick path and then invoke the PMU irq handler if there is an overflow, but
> that's really not very nice.

Also we may remove the 'overflow' parameter from armpmu_event_update,
and introduce armpmu->is_overflow(idx) callback to check if the counter(event)
is overflow inside armpmu_event_update.

IMO, the pmu irq can't be lost, so the pmu irq handler is not needed to invoke
in tick path.

>
>> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
>> index 5bb91bf..789700a 100644
>> --- a/arch/arm/kernel/perf_event.c
>> +++ b/arch/arm/kernel/perf_event.c
>> @@ -193,13 +193,8 @@ again:
>>                            new_raw_count) != prev_raw_count)
>>               goto again;
>>
>> -     new_raw_count &= armpmu->max_period;
>> -     prev_raw_count &= armpmu->max_period;
>> -
>> -     if (overflow)
>> -             delta = armpmu->max_period - prev_raw_count + new_raw_count + 1;
>> -     else
>> -             delta = new_raw_count - prev_raw_count;
>> +     delta = (armpmu->max_period - prev_raw_count + new_raw_count
>> +                             + 1) & armpmu->max_period;
>
> This breaks when more than max_period events have passed. See a737823d
> ("ARM: 6835/1: perf: ensure overflows aren't missed due to IRQ latency").

Sorry, I didn't notice the commit and the problem addressed, so looks
the 'overflow'
information is needed for armpmu_event_update.

thanks,
--
Ming Lei
