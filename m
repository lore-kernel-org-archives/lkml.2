Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab0HGVDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 17:03:46 -0400
Received: from mail.lang.hm ([64.81.33.126]:35639 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab0HGVDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 17:03:45 -0400
Date: Sat, 7 Aug 2010 14:01:52 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, menage@google.com,
        David Brownell <david-b@pacbell.net>, James.Bottomley@suse.de,
        tytso@mit.edu, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
In-Reply-To: <Pine.LNX.4.44L0.1008070857120.20673-100000@netrider.rowland.org>
Message-ID: <alpine.DEB.2.00.1008071338480.30564@asgard.lang.hm>
References: <Pine.LNX.4.44L0.1008070857120.20673-100000@netrider.rowland.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Aug 2010, Alan Stern wrote:

> On Fri, 6 Aug 2010 david@lang.hm wrote:
>
>>>> 1. the ability to decide to suspend while there are still some
>>>> 'unimportant' apps running.
>>>
>>> While this may be true in some literal sense, it certainly is not the
>>> best way to view the situation.  Linux already has the ability to
>>> suspend (or to decide to suspend) whenever you want.  What Android has
>>> added is the ability to suspend conditionally, based on whether or not
>>> some applications or drivers want to keep the system running.
>>
>> Ok, aside from possibly drivers, what' stopping this from being done on a
>> valilla system today?
>
> Nothing much.  Mainly just the fact that Rafael's code is so new.  It
> hasn't yet been integrated into the drivers that should use it.

makes sense.

>>> Furthermore, this statement leaves out the primary purpose of
>>> wakelocks: to avoid races between suspending and wakeup events.  And it
>>> also ignores a very important distinction: the difference between
>>> drivers and applications.  Wakelocks are used by both, but it has been
>>> shown that only the wakelocks used by drivers need to be implemented in
>>> the kernel -- the others can be implemented entirely in userspace.
>>
>> Ok, this is the first I've heard in this discussion that wakelocks would
>> not be available to userspace. In fact it was explicitly stated that
>> userspace applications called IOCTLs to get/release the wakelock.
>
> Android's wakelock implementation does make wakelocks available to
> userspace.  In Rafael's approach there is nothing comparable.  Instead
> "userspace wakelock"-equivalents have to be handled by a power manager
> program.

And the question to the Android people is if they consider this acceptable 
or think that this means that the vanilla can't support them.

>> many of my objections (voiced in another thread) about Android specific
>> features are not relavent if the wakelock in userspace is just part of
>> that application framework and not tied into the kernel.
>>
>>> All of these issues are addressed by Raphael's new wakeup_events code.
>>
>> Ok, then why is there still discussion about wakelocks at all if Raphael
>> has implemnetd the needed kernel functionality and userspace is Android
>> SDK specific?
>
> This thread started when Paul posted his list of requirements for
> Android power management (or power management in general).  It wasn't
> really specific to wakelocks, but people brought them up when
> discussing how those requirements are currently being met.
>
> In fact, it seems to me that _you_ are the person most responsible for
> prolonging this discussion.

I'll admit to that, but it seems like there is still new information 
comeing up about the requirements, as well as the current implementation.

>>>> If these two features were available, I think that the rest of what they
>>>> are looking for could be built up without requireing other changes.
>>>
>>> They already _are_ available.  Admittedly, only since quite recently.
>>> (Rafael's new code was accepted during the 2.6.36 merge window.)
>>
>> Do Brian and Arve agree that this solves their problem?
>
> I think you should ask them instead of asking me.

Since they are following this thread, this was intended to be asking them 
torespond.

>> to be fair, there have been numerous complaints about suspend being
>> separate from deep sleep long before Android. Linus' blow-up that resulted
>> in Hibernation and Suspend being separated from each other is a case in
>> point. He was making the point that there shouldn't be a difference
>> between the deepest sleep and suspend.
>
> This may be controversial, but I think Rafael will agree when I say
> that (in this one respect) Linus was wrong.  Separating hibernation
> from suspend makes sense, and I agree that the differences between
> deepest idle and suspend should be minimized.  But to get rid of them
> altogether would be wrong (and probably not possible anyway).

if you thing the differences should be minimized, why do you think that 
getting rid of them would be wrong?

I know that Rafael disagrees with Linus, because he has not implemented 
what Linus suggested.

>> As deep sleep gains the ability to use even less power and as suspend
>> gains the ability to leave things on sometimes, the difference between
>> them is dissapearing. I wouldn't be at all surprised to see them start
>> overlaping soon. So it's not that I think Android should use deep sleeps
>> instead of suspend, but rather that suspend should just be the deepest
>> sleep, one mechanism instead of two.
>
> I disagree.  There are critical differences between them:
>
> 	Suspend uses the freezer and idle doesn't.
>
> 	Suspend generally forces devices to go into their low-power
> 	states immediately, whereas idle tends to leave unused devices
> 	at full power for some time before going to low power (to
> 	minimize average latency).

this sounds like policy, not capability.

> 	Overall, suspend generally has longer latency than idle.  (This
> 	varies among platforms.)

even different idle modes have different latency

> 	The set of wakeup sources (including timers) is different.

I agree that they are different, but don't they also vary within sleep or 
suspend as well?

> 	On some systems, suspend uses platform-specific mechanisms to
> 	go into lower power states than are available to idle.

the exact mechanism to go into low-power states is platform specific to 
start with (there are some very popular platforms admittedly, like the PC 
ACPI modes)

as I see it

Sleep

a policy engine to decide when to sleep, how deeply to sleep, what to 
disable, what will wake you up (this includes taking into account desired 
latency, and the amount of power/time needed to get in and out of the 
various modes)

platform specific mechanisms for transitioning in and out of the modes.


Suspend

a policy engine to decide when to suspend, what to leave enabled when you 
supend, what will wake you i[

platform specific mechanisms for transition in and out of suspend. I view 
use of the freezer to be one of these mechansims.


Somewhere amoung this mess are things like spinning down drives, disabling 
inactive network interfaces, etc. I don't knwo if those are run from the 
sleep policy engine, or if there is a third policy engine to decide these 
things.


why should there be multiple different policy engines making power 
management decisions? it seems to me like these policy engines can and 
should be merged, with the resulting engine able to trigger all the 
existing mechanisms for transitioning between modes.

David Lang
