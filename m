Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab0HGUTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 16:19:24 -0400
Received: from mail.lang.hm ([64.81.33.126]:54128 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab0HGUTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 16:19:23 -0400
Date: Sat, 7 Aug 2010 13:17:48 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Brian Swetland <swetland@google.com>,
        kevin granade <kevin.granade@gmail.com>,
        Arve Hj?nnev?g <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100807150724.GC19600@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1008071249330.30564@asgard.lang.hm>
References: <20100805230304.GQ2447@linux.vnet.ibm.com> <20100807001431.GA3252@opensource.wolfsonmicro.com> <alpine.DEB.2.00.1008061741460.30564@asgard.lang.hm> <201008071101.25384.rjw@sisk.pl> <alpine.DEB.2.00.1008070247590.30564@asgard.lang.hm>
 <20100807150724.GC19600@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Aug 2010, Paul E. McKenney wrote:

> On Sat, Aug 07, 2010 at 03:00:48AM -0700, david@lang.hm wrote:
>> On Sat, 7 Aug 2010, Rafael J. Wysocki wrote:
>>
>>> On Saturday, August 07, 2010, david@lang.hm wrote:
>>>> On Sat, 7 Aug 2010, Mark Brown wrote:
>>>>
>>>>> On Fri, Aug 06, 2010 at 04:35:59PM -0700, david@lang.hm wrote:
>>>>>> On Fri, 6 Aug 2010, Paul E. McKenney wrote:
>>> ...
>>>> What we want to have happen in an ideal world is
>>>>
>>>> when the storage isn't needed (between reads) the storage should shutdown
>>>> to as low a power state as possible.
>>>>
>>>> when the CPU isn't needed (between decoding bursts) the CPU and as much of
>>>> the system as possible (potentially including some banks of RAM) should
>>>> shutdown to as low a power state as possible.
>>>
>>> Unfortunately, the criteria for "not being needed" are not really
>>> straightforward and one of the wakelocks' roles is to work around this issue.
>>
>> if you can ignore the activity caused by the other "unimportant"
>> processes in the system, why is this much different then just the
>> one process running, in which case standard power management sleeps
>> work pretty well.
>
> But isn't the whole point of wakelocks to permit developers to easily
> and efficiently identify which processes are "unimportant" at a given
> point in time, thereby allowing them to be ignored?
>
> I understand your position -- you believe that PM-driving applications
> should be written to remain idle any time that they aren't doing something
> "important".  This is a reasonable position to take, but it is also
> reasonable to justify your position.  Exactly -why- is this better?
> Here is my evaluation:
>
> o	You might not need suspend blockers.  This is not totally clear,
> 	and won't be until you actually build a system based
> 	on your design.
>
> o	You will be requiring that developers of PM-driving applications
> 	deal with more code that must be very carefully coded and
> 	validated.  This requirement forces the expenditure of lots
> 	of people time to save a very small amount of very inexpensive
> 	memory (that occupied by the suspend-blocker code).

the issue isn't avoiding the memory useage, the issue is avoiding the 
special API requirement that make the userspace code no longer be 
portable.

note that there are a lot of battery powered embedded devices out there 
that work just fine without wakelocks. They are able to use the existing 
idle/sleep and suspend options to get good battery life.

The key difference is that Android allows other programs to be loaded on 
the system, and the current idle/sleep/suspend triggers can't tell the 
difference between the important software and the other software.

> Keep in mind that there was a similar decision in the -rt kernel.
> One choice was similar to your proposal: all code paths must call
> schedule() sufficiently frequently.  The other choice was to allow
> almost all code paths to be preempted, which resembles suspend blockers
> (preempt_disable() being analogous to acquiring a suspend blocker,
> and preempt_enable() being analogous to releasing a suspend blocker).
>
> Then as now, there was much debate.  The choice then was preemption.
> One big reason was that the choice of preemption reduced the amount of
> real-time-aware code from the entire kernel to only that part of the
> kernel that disabled preemption, which turned out to greatly simplify
> the job of meeting aggressive scheduling-latency goals.  This experience
> does add some serious precedent against your position.  So, what do you
> believe is different in the energy-efficiency case?

for one thing, there was never any thought that any code that would have 
to have preempt written would ever run anywhere else other than inside the 
linux kernel.

If you had proposed that userspace be allowed to do preempt_enable/disable 
calls, it would have been a very different discussion.

In the case of real-time applications, we require that things that are 
given real-time priority be carefully coded to behave well, and that if 
they depend on things that are not given real-time priority they may not 
behave as expected. Priority Inheritance is a way to avoid complete system 
lockup in many cases, but it would still be possible for a badly written 
real-time app to kill the system if it does something like go into a 
busy-loop waiting for a file to be created by a non-real-time process.

wakelocks are like implementing real-time by allowing userspace to issue 
preempt_disable() calls to tell the scheduler not to take the CPU away 
from them until they make a preempt_enable() call.



In addition wakelocks cannot replace the need to write efficient code. all 
that wakelocks do is to prevent the system from doing a suspend, you still 
want to have the code written to not do unneccessary wakeups that would 
prevent you from using the low-power modes other than suspend. On the 
other hand, it _is_ possible for the idle/sleep states to be extended to 
also cover suspend.

>>>> today there are two ways of this happening, via the idle approach (on
>>>> everything except Android), or via suspend (on Android)
>>>>
>>>> Given that many platforms cannot go to into suspend while still playing
>>>> audio, the idle approach is not going to be able to be eliminated (and in
>>>> fact will be the most common approach to be used/deugged in terms of the
>>>> types of platforms), it seems to me that there may be a significant amount
>>>> of value in seeing if there is a way to change Android to use this
>>>> approach as well instead of having two different systems competing to do
>>>> the same job.
>>>
>>> There is a fundamental obstacle to that, though.  Namely, the Android
>>> developers say that the idle-based approach doesn't lead to sufficient energy
>>> savings due to periodic timers and "polling applications".
>>
>> polling applications can be solved by deciding that they aren't
>> going to be allowed to affect the power management decision (don't
>> consider their CPU useage when deciding to go to sleep, don't
>> consider their timers when deciding when to wake back up)
>
> Agreed, and the focus is on how one decides which applications need
> to be considered.  After all, the activity of a highly optimized
> audio-playback application looks exactly like that of a stupid polling
> application -- they both periodically consume some CPU.  But this is
> something that you and the Android guys are actually agreeing about.
> You are only arguing about exactly what mechanism should be used to
> make this determination.  The Android guys want suspend blockers, and
> you want to extend cgroups.

I want the kernel to be explicitly told that this application is important 
(or alternativly that these other applications are not). I suggested 
cgroups as a possible way to do this, but anything that could tell the 
kernel what processes to care about and what ones to not care about would 
work. My initial thought had actually been to do something like echo the 
pid of important processes into a /proc or /sys file, but I was under the 
impression that there were a lot of processes that would get this state 
and therefore a more general tool like cgroups (which as I understand it 
automatically puts children of a process into the same cgroup as the 
parent) seemed moreuseful

> So I believe that the next step for you is to implement your approach
> so that it can be compared in terms of energy efficiency, code size,
> intrusiveness, performance, and compatibility with existing code.
>
>>> Technically that
>>> boils down to the interrupt sources that remain active in the idle-based case
>>> and that are shut down during suspend.  If you found a way to deactivate all of
>>> them from the idle context in a non-racy fashion, that would probably satisfy
>>> the Android's needs too.
>>
>> well, we already have similar capibility for other peripherals (I
>> keep pointing to drive spin down as an example), the key to avoiding
>> the races seems to be in the drivers supporting this.
>
> The difference is that the CPU stays active in the drive spin down
> case -- if the drive turns out to be needed, the CPU can spin it up.
> The added complication in the suspend case is that the CPU goes away,
> so that you must more carefully plan for all of the power-up cases.

I agree tha the power down and restart needs to be planned, but it's not 
like you are going to wake up the drive (or the audio hardware0 without 
waking up the CPU first.

even with idle sleep modes and drive spin-down there is no provision for 
the drive to be restarted if the CPU is asleep, you first have something 
happen that wakes up the CPU and it then wakes up the drive. This same 
approach should work for other things.

>> the fact that Android is making it possible for suspend to
>> selectivly avoid disabling them makes me think that a lot of the
>> work needed to make this happen has probably been done. look at what
>> would happen in a suspend if it decided to leave everything else on
>> and just disable the one thing, that should e the same thing that
>> happens if you are just disabling that one thing for idle sleep.
>
> We already covered the differences between suspend and idle, now
> didn't we?  ;-)

we did, however at the time suspend was to stop everything, now we are 
finding that Android has multiple flavors of suspend, one of which stops 
everything, the others leave some things running.

David Lang
