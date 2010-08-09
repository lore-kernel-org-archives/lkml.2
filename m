Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab0HIEwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 00:52:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35294 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0HIEwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 00:52:18 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1008081507510.6810-100000@netrider.rowland.org>
References: <AANLkTinebiC=9Xd-D_sOwmvA8w_YPWMdhTYz2NRbZ7jH@mail.gmail.com>
	<Pine.LNX.4.44L0.1008081507510.6810-100000@netrider.rowland.org>
Date: Sun, 8 Aug 2010 21:52:17 -0700
Message-ID: <AANLkTimgJUAW9TU37XE4BqYWf3yCWvg-vgk3E0YLqcm9@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
        david@lang.hm, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/8 Alan Stern <stern@rowland.harvard.edu>:
> On Sat, 7 Aug 2010, Arve Hjønnevåg wrote:
>
>> The suspend blockers I added I my suspend blocker patchset were not
>> directly associated with a device.
>
> For the benefit of those who don't remember the details of that
> patchset, can you list again the suspend blockers/wakelocks that aren't
> directly associated with a device?  (No need to mention things coming
> from userspace -- those are obviously unrelated to any device.)

Other than the user space interface and the internal main suspend
blocker that patchset modified evdev, and added suspend blocking work.

>
>> The evdev changes could be modified
>> to share a device, but it would give less detail since a separate
>> queue is created for each client that opens the device.
>
> I don't understand enough about how the input layer works.  Does it
> create a new queue each time an input device file is opened?  And each
> input event gets added to all of the queues?  And each queue gets a
> corresponding wakelock?
>
Yes, yes and yes.

> If these surmises are right then I can see how relying on devices alone
> wouldn't give enough information.  There could be two separate programs
> both reading input events, and you wouldn't know which one was
> responsible for failing to drain its queue.
>
We don't know which one now either since we don't give them unique
names, but we know that one of them is not reading (and it is usually
not the normal input path).

>> The suspend
>> blocking work api would have to change so the caller to passes a
>> device in, which I think would make that api less flexible.
>
> Maybe.  There aren't enough examples coded up yet to be sure.  At this
> point we could easily make the device argument required instead of
> optional, and we could add a device argument to pm_relax.
>
I think that would be a good start. I can create dummy devices for now
where I don't already have a device.

>> Mostly the
>> problem is that we need separate stats for wakelocks created by a
>> single driver. For instance we will still need a user-space interface
>> to block suspend on android devices (lower level services than the
>> power manager need to block suspend), with the stats in the device
>> struct we have to create a new device for every wakelock user space
>> creates in the kernel.
>
> In the scheme we're talking about, the suspend-blocking interface for
> uesrspace would be located entirely in the power manager.  Hence it
> could maintain all the necessary statistics, without involving the
> kernel.  During early stages of system startup, before the power
> manager is running, lower-level services would not be able to block
> suspend.  This wouldn't matter because at those times the system simply
> would not ever suspend -- because suspends have to be initiated by the
> power manager.

If we do that, a low level process could try to block suspend while
the power manager is not running. Then the power manager could start
and decide to suspend not knowing that a low level process wanted to
block suspend.

>
>> There is also the issue of reading the stats. It is a lot easier to
>> read a single stats file, than looping though every device on the
>> system (when most of the devices never block suspend).
>
> I agree, it should be possible to simplify this and perhaps at the same
> time avoid adding all the wakeup-related fields to every device
> structure.
>
>> >> > Does Android use any kernel-internal wakelocks both with a timer and
>> >> > with active cancellation?
>> >> >
>> >>
>> >> I don't know if they are all kernel-internal but these drivers appear
>> >> to use timeouts and active cancellation on the same wakelock:
>> >> wifi driver, mmc core, alarm driver, evdev (suspend blocker version
>> >> removes the timeout).
>
> Roughly speaking, what do the timings work out to be?  That is, how
> long are the timeouts for these wakelocks, how long does it usually
> take for one of them to be actively cancelled, and what percentage of
> them end up timing out?
>
The evdev timeout is a few seconds, and never timeout unless user
space is misbehaving. I don't know how the wifi and mmc wakelocks are
used. The alarm driver uses a 1 or 2 second timeout to abort suspend
when an alarm is set to close to program an rtc alarm. I think this
one is cancelled when the alarm triggers, and the timeout only handles
the case where the client cancelled the alarm before it trigger, but I
don't remember for sure.

>> >> The wakelock code has an active flag. If we want to keep the
>> >> pm_stay_wake nesting (which I would argue against), we would need an
>> >> active count. It would also require a handle, which is a change Rafael
>> >> said would not fly.
>
> Never mind the handles for now.  As for the nesting, we effectively
> don't have it when the pm_wakeup_event interface is used.  The
> pm_stay_awake/pm_relax interface _is_ nested, but since that interface
> isn't used anywhere yet, we can't say whether it really should be
> nested or not.  Maybe we'll find out in the end that it shouldn't be.
>

You cannot easily mix timeouts, cancellations and nesting.
Wakelocks/suspend blockers allow you to mix timeouts and
cancellations.

> Consider an input event queue as a typical case.  You would call
> pm_stay_awake when an item is added to an empty queue, and you would
> call pm_relax when the last item is removed from a queue.  The nesting
> count would never be > 1, so it wouldn't make any difference either
> way.
>

The cleanup is a little simpler when you don't nest and there is less
chance that a missed edge case prevents suspend forever (we had a few
of those bugs in our userspace code that used nested wakelocks). If
the above is all you do, then you block suspend forever if someone
closes an non-empty input device.

>> >> >> sleep_time, total time the wake lock has been active when the screen was off.
>> >> >
>> >> > Not applicable to general systems.  Is there anything like it that
>> >> > _would_ apply in general?
>> >> >
>> >>
>> >> The screen off is how it is used on android, the stats is keyed of
>> >> what user space wrote to /sys/power/state. If "on" was written the
>> >> sleep time is not updated.
>
> I guess we could keep track of pm_stay_awake or pm_wakeup_event calls
> made between a read and write of /sys/power/wakeup_count (i.e., while
> events_check_enabled is set).  Would that be roughly equivalent?
>
Roughly, yes. (or even just while blocking the read from
/sys/power/wakeup_count).

>> >> The merged user space interface makes this unclear to me. When I first
>> >> used suspend on android I had a power manager process that opened all
>> >> the input devices and reset a screen off timeout every time there was
>> >> an input event. If the input layer uses pm_stay_awake to block suspend
>> >> when the queue is not empty, this will deadlock with the current
>> >> interface since reading the wake count will block forever if an input
>> >> event occurred right after the power manager decides to suspend.
>> >
>> > No, in that case suspend will be aborted, IIUC.
>> >
>>
>> How? Your pm_get_wakeup_count function loops until events_in_progress becomes 0.
>
> The problem is that the same task is reading /sys/power/wakeup_count
> (thus waiting for an input event queue to drain) and also reading an
> input event queue.  Clearly this will result in deadlock, but there
> must be a reasonably simple way around it.  For example, carry out
> those two activities in separate threads.
>
Yes, but my point is that user-space code that is safe if the driver
does not block suspend until the queue is empty becomes unsafe if it
does. Also note that it is not enough to just use two separate threads
for this, the thread that reads /sys/power/wakeup_count cannot hold a
lock while reading, or directly provide the user space wakelock api.

I do think it is possible to use this api and provide a user space
wakelock api (by having a dedicated thread that suspends), but it is
more complicated than using the asynchronous wakelock/suspend blocker
api.

-- 
Arve Hjønnevåg
