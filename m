Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab2BTDTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 22:19:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35607 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2BTDTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 22:19:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ming.lei@canonical.com designates 10.68.130.234 as permitted sender) smtp.mail=ming.lei@canonical.com
MIME-Version: 1.0
In-Reply-To: <20120217102643.GA17909@mudshark.cambridge.arm.com>
References: <CAMsRxfJH+9MS=Svmh0BvDSb8xqsPe2HPobkeKcn8JO35npjhwQ@mail.gmail.com>
	<CACVXFVMx9Zx3ZQr6Q-17x5NVL8iuBJjOjtw39FJiWX=fGkZNZA@mail.gmail.com>
	<1329323900.2293.150.camel@twins>
	<CACVXFVPce0A3LfL=mFo3UbN-Om7xLOo_d-LfKXDjdN5dFQdhiA@mail.gmail.com>
	<20120216150004.GE2641@mudshark.cambridge.arm.com>
	<CACVXFVM472hz+na7o2wJr1CPq-W=YB7i0UwtrsUf62+ryzWp8A@mail.gmail.com>
	<1329409183.2293.245.camel@twins>
	<CACVXFVOygObWqPMLjg6uOB6inBkvvUjsQncNW0fbmpa4Xspw0Q@mail.gmail.com>
	<20120216180841.GC31977@mudshark.cambridge.arm.com>
	<CACVXFVO4eexVK-S5TdRk2T6pyKRzpW1HxBQxo0Yfk_ziaO_U4Q@mail.gmail.com>
	<20120217102643.GA17909@mudshark.cambridge.arm.com>
Date: Mon, 20 Feb 2012 11:19:02 +0800
Message-ID: <CACVXFVOzoUYrn0SuqwBJ6rTmTNN1MxoR-45dv-owH2rcnQYLWg@mail.gmail.com>
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

Hi,

On Fri, Feb 17, 2012 at 6:26 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Feb 17, 2012 at 05:24:02AM +0000, Ming Lei wrote:
>> On Fri, Feb 17, 2012 at 2:08 AM, Will Deacon <will.deacon@arm.com> wrote:
>>
>> >
>> > The more I think about this, the more I think that the overflow parameter to
>> > armpmu_event_update needs to go. It was introduced to prevent massive event
>> > loss in non-sampling mode, but I think we can get around that by changing
>> > the default sample_period to be half of the max_period, therefore giving
>> > ourselves a much better chance of handling the interrupt before new wraps
>> > around past prev.
>> >
>> > Ming Lei - can you try the following please? If it works for you, then I'll
>> > do it properly and kill the overflow parameter altogether.
>>
>> Of course, it does work for the problem reported by Stephane since
>> it changes the delta computation basically as I did, but I am afraid that
>> it may be not good enough for the issue fixed in a737823d ("ARM: 6835/1:
>> perf: ensure overflows aren't missed due to IRQ latency").
>
> I think it does solve that problem.
>
>> >
>> >        if (!hwc->sample_period) {
>> > -               hwc->sample_period  = armpmu->max_period;
>> > +               hwc->sample_period  = armpmu->max_period >> 1;
>>
>> If you assume that the issue addressed by a737823d can only happen in
>> non-sample situation, Peter's idea of u32 cast is OK and maybe simpler.
>
> I don't want to assume that the counters are 32-bit in this code as we may
> want to plug in some other PMU with 16-bit counters, for example. That's why
> we have max_period defined for each PMU. Furthermore, it still doesn't help us
> in the stat case where prev will typically be quite small after we've had an
> overflow and new may well overtake it.

In fact, I suggested to keep the overflow information to handle the
case by reading
hw counter overflow flag, but looks it is a bit frail to sync overflow
flag with the
counter value in non-interrupt situation, so I agree with you to
remove 'overflow'
parameter from armpmu_event_update.

>
>> But I am afraid that the issue still can be triggered in sample-based situation,
>> especially in very high frequency case: suppose the sample freq is 10000,
>> 100us IRQ delay may trigger the issue.
>
> Not sure I follow. If the frequency is 10000, then we write 0xffffd8f0 to
> the counter. That means we have a 0xffffd8f0 event window to read the

The frequency I described is the 'freq' from '-F freq'. On OMAP4, when
the 'freq'
is 10000 and the interval for one samle is 100us, the observed counter
('left' variable in armpmu_event_set_period) is about 90000, so the written
value to the hw counter is 0xFFFEA06F, looks the window is wide enough,
and we may not consider the issue in a737823d for sample-based profiling.

> counter after it overflows before new overtakes prev and we get confused.
> If this passed in 100us then either your clock speed is 4.3*10^12Hz or you
> have a seriously wide issue :)

On OMAP4, I can observe that about 19800 sample events can be generated
with the below command:

 'perf record -e cycles -F 10000  ./noploop 2&& perf report -D | tail -20'

So the above result looks not bad, :-)

>
>> So we may use the overflow information to make perf more robust, IMO.
>
> There's a trade off between allowing the counter to wrap back around past
> its previous value or being able to handle overflow on a non-interrupt path.

I agree, it is not easy to read overflow flag and counter accurately
from hardware
directly on a non-interrupt path.

So do you need me to prepare a new patch, or you will do it by yourself?


thanks,
--
Ming Lei
