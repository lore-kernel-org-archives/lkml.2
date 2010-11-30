Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0K3F5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 00:57:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44387 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab0K3F5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 00:57:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LFWTjrO/dxWGGM8fu8uEa40McuZN2XjNIJKnrrKLmWbA9EKrILosj3xOQYsuJ0Bgtw
         KjgqgINID4vkDmW3HKSH34Z8LAvWpLQxMLxLqbryZ+S3a+7vFGWa+Y53Xiow1GoDPdgD
         QP9/7+tlo7VFoEdlZSMyLf2YK8s9k0v0G8YlA=
MIME-Version: 1.0
In-Reply-To: <1291050395.2697.259.camel@Palantir>
References: <1286237003-12406-7-git-send-email-venki@google.com>
	<tip-305e6835e05513406fa12820e40e4a8ecb63743c@git.kernel.org>
	<AANLkTin-U-kzr27ArR60K=eE5Jq+sPdTQ7JNhQg711c7@mail.gmail.com>
	<1291031990.32004.24.camel@laptop>
	<20101129142213.GA2573@zhy>
	<1291050395.2697.259.camel@Palantir>
Date: Tue, 30 Nov 2010 13:57:35 +0800
Message-ID: <AANLkTikRh0mKkPY=m+kX47+5QNxE-hHSoRbQST3hnDUq@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Do not account irq time to current task
From: Yong Zhang <yong.zhang0@gmail.com>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, venki@google.com,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 1:06 AM, Raistlin <raistlin@linux.it> wrote:
> On Mon, 2010-11-29 at 22:22 +0800, Yong Zhang wrote:
>> > If you still want to throttle RT tasks simply ensure their bandwidth
>> > constraint is lower than the available time.
>>
>> But the available time is harder to calculated than before.
>>
> Well, it shouldn't... I would say it makes it easier! :-P

It depends on the way how we see it.
>From the side that we can just focus on task time, it's easy
and well understood.  :)

Now I think we need a way to export the irq_time to user,
then the user can determine the average time spending
on IRQ.
Maybe Venkatesh Pallipadi's patchset titled "Proper
kernel irq time reporting" is the one.

>
>> IRQ is random, so as to the irq_time.
>>
> Well, that's definitely true, as it is true that the time needed to deal
> with IRQ is now somehow "lost" or "hidden" (meaning that it is not
> accounted to anyone).
>
>> But the unthrottle(do_sched_rt_period_timer()) runs in fixed
>> period which is based on hard clock.
>>
>> Is that what we want?
>>
> I'm not sure I'm getting what the issue is here... Do you have an
> example do discuss?

I was just thinking about pulling out irq_time from rt_period, but
it seems that it's not so easy.

By comparing current unthrottle mechanism and the before one,
there is no difference. IRQ can happen at any time, regardless
who its time will be accounted to. So it's still fair for now.

> Because, referring to the one in your first e-mail, if in the last
> period (of 1sec) we spent 900ms running -rt tasks and 50ms servicing
> interrupts, given a limit was 950ms for sched_rt, why should we throttle
> them? :-O

In the previous version, rt is throttled because irq_time is accounted
to the task.
So in the new version, I should set rt_runtime to 900ms to make it
sensible.

>
> Well, I see that this could mean that all we'd do in that period will be
> servicing interrupts and running -rt tasks (for _their_ last 50ms) but,
> also means (at least to me) that your system needs some more design
> effort.
> Then I can also agree on the point that it might make sense to think a
> bit on how to take the 50ms from interrupts somehow into account, but
> just charging -rt tasks for that time seems quite arbitrary... :-O

Sure.

>
> Something that I've done recently is trying to figure out, if interrupts
> handler have their own threads (as in PREEMPT_RT), what happens if you
> try constraining the bandwidth of those thread, using proper scheduling
> mechanisms (such as deadline scheduling, but rt-throttling could also be
> a "reasonable approximation" :-P)... But it's just preliminary research
> results.

Interesting. Will keep eye on that. :)

>
> BTW, having handlers in threads could actually be the solution per-se
> here, since they would then consume -rt bandwidth (if set to -rt) and
> contribute to throttling... :-)

Agree. This will make time arrangement more accurate.

But as you said above, we must evaluate the side effect to
irq when constraining the bandwidth of irq thread.

Thanks,
Yong
