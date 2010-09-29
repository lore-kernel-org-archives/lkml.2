Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0I2Tmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:42:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2362 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab0I2Tmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:42:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JcSVLg0qVchxlExJ/4dxrowsubtHGYcR2z1zlDWLGh+y7Mm0dE7/1/OWa+w1G3/+ZB
         3VCF1T021/HP8A7n3JRg==
MIME-Version: 1.0
In-Reply-To: <20100929181207.GW26290@redhat.com>
References: <20100929125453.GH13563@erda.amd.com>
	<AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
	<AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com>
	<20100929150140.GK13563@erda.amd.com>
	<20100929151253.GL13563@erda.amd.com>
	<20100929152745.GC9440@lenovo>
	<AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com>
	<20100929154528.GD9440@lenovo>
	<AANLkTinkqTXXD5fMUYTT4zrRD6YoTi_G+uOA5CsOgxtT@mail.gmail.com>
	<20100929170924.GR13563@erda.amd.com>
	<20100929181207.GW26290@redhat.com>
Date: Wed, 29 Sep 2010 21:42:26 +0200
Message-ID: <AANLkTimp=+1GzBOYaUZWtDF6teGt6FZe+RTpb9fAyOyd@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
From: Stephane Eranian <eranian@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 8:12 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Wed, Sep 29, 2010 at 07:09:24PM +0200, Robert Richter wrote:
>> On 29.09.10 12:00:35, Stephane Eranian wrote:
>> > Here is a scenario:
>> >
>> > event A -> counter 0, cpuc->running = 0x1 active_mask = 0x1
>> > move A
>> > event A -> counter 1, cpuc->running = 0x3, active_mask = 0x2
>> >
>> > No interrupt, we are just counting for a short period.
>> > Then, you get an NMI interrupt, suppose it is not generated
>> > by the PMU, it is destined for another handler.
>> >
>> > For i=0, you have (active_mask & 0x1) == 0, but (running & 0x1) == 1,
>> > you mark the interrupt as handled, i.e., you swallow it, the actual
>> > handler never gets it.
>>
>> Yes, then changing the counters you will get *one* nmi with 2 handled
>> counters. This is valid as the disabled counter could generate a
>> spurious interrupt. But you get (handled == 2) instead of (handled ==
>> 1) which is not much impact. All following nmis have (handled == 1)
>> then again.
>
> Robert,
>
> I think you missed Stephane's point.  Say for example, kgdb is being used
> while we are doing stuff with the perf counter (and say kgdb's handler is
> a lower priority than perf; which isn't true I know, but let's say):
>
Yes, exactly my point. The reality is you cannot afford to have false positive
because you may starve another subsystem from an important notification.

I think it boils down to whether or not we need an error message (Dazed) in
case no subsystem claimed the NMI. If you were to just silently consume the
NMI when no subsystem claims it, then you would not have these issues.

What Don has done is use a heuristic which gets activated when a PMU
interrupt handler signals that more than one counter have overflowed. His
claim is that this situation is likely to trigger back-to-back.

The reason this heuristic works is because it waits until ALL the subsystems
have seen the notification before it declares that the NMI was PMU spurious.
To do that is uses the DIE_NMI_UNKNOWN callchain. Handler on this chain
get call last, after all subsystems have seen the notification once. I believe
that is the only way to safely "consume" a "spurious" NMI and avoid
the 'Dazed' message. Anything else runs the risks of starving the other
subsystems.

> perf NMI comes in, issues pmu_stop 'cleanly' (meaning no spurious
> interrupt).  The cpuc->running bit is never cleared.
>
> kgdb NMI comes in, but the die_chain dictates perf looks at it first.
> perf will see that cpuc->active == 0 and cpuc->running == 1 and bump
> handled.  Thus returning NOTIFY_STOP.  kgdb never sees the NMI. :-(
>
> Now I sent a patch last week that can prevent that extra NMI from being
> generated at the cost of another rdmsrl in the non-pmu_stop cases (which I
> will attach below again, obviously P4 would need something similar too).
>
> I think we currently don't see the problems Stephane describes because the
> only thing we test that uses NMIs are perf, which also happens to be a low
> priority on the die_chain.
>
> But it is an interesting scenario that we should look at more.
>
> Cheers,
> Don
>
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 48c6d8d..1642f48 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1175,11 +1175,22 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
>                handled++;
>                data.period     = event->hw.last_period;
>
> -               if (!x86_perf_event_set_period(event))
> -                       continue;
> +               /*
> +                * if period is over, process the overflow
> +                * before reseting the counter, otherwise
> +                * a new overflow could occur before the
> +                * event is stopped
> +                */
> +               if (local64_read(&hwc->period_left) <= 0) {
> +                       if (perf_event_overflow(event, 1, &data, regs)) {
> +                               x86_pmu_stop(event, 0);
> +                               continue;
> +                       }
> +                       /* if the overflow doesn't stop the event, resync */
> +                       x86_perf_event_update(event);
> +               }
>
> -               if (perf_event_overflow(event, 1, &data, regs))
> -                       x86_pmu_stop(event, 0);
> +               x86_perf_event_set_period(event);
>        }
>
>        if (handled)
>
