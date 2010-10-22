Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0JVXea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:34:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38803 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0JVXe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HDZlDl0JteWyewuppKryp24ELFotVhPFMIf5/6nuR0hURDNPsmvoQhi55/V4BrMM7l
         Yv5BXRGc0t7Qoa4oHV5A==
MIME-Version: 1.0
In-Reply-To: <1287750199.15336.32.camel@twins>
References: <1287614941-32325-1-git-send-email-venki@google.com>
	<1287614941-32325-5-git-send-email-venki@google.com>
	<1287672271.3488.139.camel@twins>
	<AANLkTi=Yi4U_TjJZLGo4v1f6fjLYesO9GCxLnT42qkt0@mail.gmail.com>
	<1287750199.15336.32.camel@twins>
Date: Fri, 22 Oct 2010 16:34:25 -0700
Message-ID: <AANLkTi=2ADcnHB86re3UHtgdSZSjyehmU-iiPauYyDuF@mail.gmail.com>
Subject: Re: [PATCH 4/6] Export ns irqtimes from IRQ_TIME_ACCOUNTING through /proc/stat
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 5:23 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-10-21 at 12:25 -0700, Venkatesh Pallipadi wrote:
>> > I'd do:
>> >
>> >  - hardirq
>> >  - softirq
>> >  - user
>> >  - system
>> >     - guest
>> >     - really system
>> >  - idle
>> >
>> > Since otherwise tiny slices of softirq would need to wait for a system
>> > tick to happen before you fold them.
>> >
>> > Also, it is possible that in a single tick multiple counters overflow
>> > the jiffy boundary, so something like:
>> >
>> >  if (irqtime_account_hi_update())
>> >        cpustat->irq = ...
>> >
>> >  if (irqtime_account_si_update())
>> >        cpustate->softirq = ...
>> >
>> >  if (user_tick) {
>> >  } else if (...) {
>> >
>> >  } else ...
>> >
>> > would seem like the better approach.
>> >
>>
>> I am not sure about checking for both si and hi. That would result in
>> double accounting a tick and have some side-effects.
>
> Depends on how you look at it I guess, in order for this to occur a
> previous tick would have to be not reported, eg. consider the case where
> during two consecutive ticks the time is 50% for both sirq and hirq.
>
> Then, after the first tick, nothing will have progressed because they're
> both at 50% of a tick, after the second tick both will have reached a
> full jiffy's worth of time and need to roll over.
>
> In total two ticks happened, two ticks got accounted, {0,2}, your
> approach would make it look like {0,1,1} two ticks worth of work
> happened, two ticks got accounted, but it takes 3 ticks for that to
> happen.

Yes. But, the initial 50-50 tick would not be accounted to hirq or sirq, but to
system/idle/user depending on other conditions. So, I think it is better to keep
accounting a tick to one bucket, everytime we are called.

>> Regarding moving si above user: Yes. That seems good.
>> idle after system, That may not make so much of a difference, as there
>> is no special way to check for system time, other than !idle.
>
> Right, so about user and system... we have a bit of a problem there.
> There is overlap between si/hi and system. ksoftirqd time would be
> accounted as system and si.

Yes. In general this cannot be accurate, as long as we have fine
granularity user/system. But,
that involves system call path, where any overhead is not desirable.
If only we had
hardware counters for user/system on x86.

overlap between ksoftirq and si, again it is kind of depending on
sampling freq. We can probably change the logic to not include
ksoftirqd time in softirqd folding. Instead, we can fallback to
sampling model, and if ksoftirqd is running when we get this tick, we
can account it as softirq. This still has a problem when hirq/sirq
folding happens on the same tick then ksoftirqd may not get its
chance. Anyways, this whole stat is sampling based. I think we have
some flexibility to hand-wave-stuff :-).

> Then there is the whole issue of per-task accounting not actually using
> the system/user ticks. They use the ticks as a ratio for
> se.sum_exec_runtime.
>

Yes. That was the reason why I removed hirq/sirq changing p->stime.
So, we have a clearer user/system split. But, again its not accurate.

Thanks,
Venki
