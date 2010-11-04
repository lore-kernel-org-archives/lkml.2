Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab0KDTqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:46:52 -0400
Received: from smtp-out.google.com ([74.125.121.35]:34566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab0KDTqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=isS4CxBtBg7sB1wN5N9miiaoPeK8bfYoKQHyWzrU/8Zs+BL4/81iaraKTDsngUoFou
         d6wnc3zDri2F2dsd1Ebg==
MIME-Version: 1.0
In-Reply-To: <AANLkTikCYjENib2zfz-rmAM2fZbZEzK-9jgL4D-b40xs@mail.gmail.com>
References: <AANLkTikCYjENib2zfz-rmAM2fZbZEzK-9jgL4D-b40xs@mail.gmail.com>
Date: Thu, 4 Nov 2010 12:46:42 -0700
Message-ID: <AANLkTikukr3d+GmWDdPB9jfwAAuMUgNwb06WXPZgRFwc@mail.gmail.com>
Subject: Re: [RFD] Perf generic context based exclusion/inclusion (was Re:
 [PATCH 0/4] Finer granularity and task/cgroup irq time accounting)
From: Venkatesh Pallipadi <venki@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 4, 2010 at 8:40 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Le 24 août 2010 10:14, Ingo Molnar <mingo@elte.hu> a écrit :
>>
>> * Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> On Thu, 2010-07-22 at 19:12 -0700, Venkatesh Pallipadi wrote:
>>> > >
>>> > > Well, the task and cgroup information is there but what does it really
>>> > > tell me? As long as the irq & softirq time can be caused by any other
>>> > > process I don't see the value of this incorrect data point.
>>> > >
>>> >
>>> > Data point will be correct. How it gets used is a different qn. This
>>> > interface will be useful for Alert/Paranoid/Annoyed user/admin who
>>> > sees that the job exec_time is high but it is not doing any useful
>>> > work.
>>>
>>> I'm very sympathetic with Martin's POV. irq/softirq times per task
>>> don't really make sense. In the case you provide above the solution
>>> would be to subtract these times from the task execution time, not
>>> break it out. In that case he would see his task not do much, and end
>>> up with the same action list.
>>
>> Right, andthis connects to something Frederic sent a few RFC patches for
>> some time ago: finegrained irq/softirq perf stat support. If we do
>> something in this area we need a facility that enables both types of
>> statistics gathering.
>>
>> Frederic's model is based on exclusion - so you could do a perf stat run
>> that excluded softirq and hardirq execution from a workload's runtime.
>> It's nifty, as it allows the reduction of measurement noise. (IRQ and
>> softirq execution can be regarded as random noise added (or not added)
>> to execution times)
>>
>> Thanks,
>>
>>        Ingo
>>
>
>
> (Answering thousand years later)
>
> Concerning the softirq/hardirq filtering in perf, this is still
> something I want to do,
> but now I think we should do it differently, especially we should
> extend the idea of exclusion to the generic level.
>
> A "context" is a generic idea: this is something that starts and ends
> at specific events. It means this can be expressed with
> perf events, for example:
>
> - a context of "lock X held" starts when X is acquired and stops when
> X is released
> - a context of "irq" starts when we enter irq and ends when we exits irq.
>

I think this is will be a useful abstraction to have, mostly beyond
just irq/softirq. Couple of comments:
- For locks, we may want to track both "wait context" and "hold context"
- This may be a bit odd and probably there is some other way of doing
this better. But, one other context we may want to track is the sleep
or wait at certain points. What I am thinking is something like how
long are we waiting on this kmalloc when we are holding this mutex
kind of info. May be it is best to do this as having sleep in kmalloc
as a context.
- Few other examples of this being useful is to count events only when
these two or more locks are held together or how long we were waiting
on one spinlock while we are holding one spinlock.

Thanks,
Venki

> There are tons of other examples. And considering how much we can tune
> any perf event already (think about
> filters) and the variety of events flavour we have (static
> tracepoints, breakpoints, dyn probes), we can define very
> precise contexts and count whatever inside:
>
> - count cycles while we hold rq lock
>
> If you consider that events that delimit contexts can, themselves, run
> under exclusion/inclusion contexts, you can do
> complex things like in this scenario:
>
> - create a enter_irq event and a exit_irq events
> - create a lock_acquired and a lock_release event, make them
> counting/sampling only under enter_irq --- exit_irq above perf events
> based defined context
> - attach filter to these lock events, to only trigger if X is the lock name
> - create a cycles counting event, make it running under the
> lock_acquired -- lock_released above perf events based defined context
>
> The result is that you will only count cycles when we hold X under irq.
>
> I think this is definetely the direction we need to take. When the
> function tracers will be available as
> trace events, this could become intensely powerful (counting cycles
> inside some functions only, or if you hold lock X
> under function Y in softirq and.....).
>
> I'm just not sure yet about the interface, perhaps an ioctl to attach
> an event to another one
> through their fds and tell whether we want the event to enable or
> disable the counting/sampling
> on the other.
> We could have as much "enabler" or "disabler" as we want, or only one
> each, not sure yet.
> Or may be we want to create the abstraction of "contexts" using fds
> for them. Not sure.
>
> We probably also want an attr->enable_on_schedule.
>
> Anyway, I'll certainly work on that after the dwarf unwinding is good enough.
>
