Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0HGKDA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 06:03:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45996 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab0HGKC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 06:02:58 -0400
MIME-Version: 1.0
In-Reply-To: <201008071044.37486.rjw@sisk.pl>
References: <AANLkTinQD3ggLFVd2KvX95U2B_j=ZJquZgiBGieukJ+r@mail.gmail.com>
	<Pine.LNX.4.44L0.1008061505070.9303-100000@netrider.rowland.org>
	<AANLkTinS_UyhRNMnViK_4aA4ve3thHhLthC+OM7cUMZc@mail.gmail.com>
	<201008071044.37486.rjw@sisk.pl>
Date: Sat, 7 Aug 2010 03:02:56 -0700
Message-ID: <AANLkTinebiC=9Xd-D_sOwmvA8w_YPWMdhTYz2NRbZ7jH@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/7 Rafael J. Wysocki <rjw@sisk.pl>:
> On Saturday, August 07, 2010, Arve Hjønnevåg wrote:
>> 2010/8/6 Alan Stern <stern@rowland.harvard.edu>:
>> > On Thu, 5 Aug 2010, Arve Hjønnevåg wrote:
>> >
>> >> count, tells you how many times the wakelock was activated. If a
>> >> wakelock prevented suspend for a long time a large count tells you it
>> >> handled a lot of events while a small count tells you it took a long
>> >> time to process the events, or the wakelock was not released properly.
>> >
>> > As noted, we already have this.
>> >
>>
>> Almost. We have it when a device is passed in.
>
> Sure.  And what are the other cases (details, please)?
>

The suspend blockers I added I my suspend blocker patchset were not
directly associated with a device. The evdev changes could be modified
to share a device, but it would give less detail since a separate
queue is created for each client that opens the device. The suspend
blocking work api would have to change so the caller to passes a
device in, which I think would make that api less flexible. Mostly the
problem is that we need separate stats for wakelocks created by a
single driver. For instance we will still need a user-space interface
to block suspend on android devices (lower level services than the
power manager need to block suspend), with the stats in the device
struct we have to create a new device for every wakelock user space
creates in the kernel.

There is also the issue of reading the stats. It is a lot easier to
read a single stats file, than looping though every device on the
system (when most of the devices never block suspend).

>> >> expire_count, tells you how many times the timeout expired. For the
>> >> input event wakelock in the android kernel (which has a timeout) an
>> >> expire count that matches the count tells you that someone opened an
>> >> input device but is not reading from it (this has happened several
>> >> times).
>> >
>> > This is a little tricky.  Rafael's model currently does not allow
>> > wakeup events started by pm_wakeup_event() to be cancelled any way
>> > other than by having their timer expire.  This essentially means that
>> > for some devices, expire_count will always be the same as count and for
>> > others it will always be 0.  To change this would require adding an
>> > extra timer struct, which could be done (in fact, an earlier version of
>> > the code included it).  It would be nice if we could avoid the need.
>> >
>> > Does Android use any kernel-internal wakelocks both with a timer and
>> > with active cancellation?
>> >
>>
>> I don't know if they are all kernel-internal but these drivers appear
>> to use timeouts and active cancellation on the same wakelock:
>> wifi driver, mmc core, alarm driver, evdev (suspend blocker version
>> removes the timeout).
>
> You previously said you didn't need timeouted wakelocks in the kernel, so
> I guess that was incorrect.
>

I don't know what you are reffering to. We have always stated that we
need timeouts in the kernel to pass events through other kernel layers
that do not use wakelocks (that list is much longer than the list
above which mixes timeouts and unlock on the same wakelock). The only
feature we do not use is the timeout feature in the user space
interface to kernel wakelocks.

>> >> wake_count, tells you that this is the first wakelock that was
>> >> acquired in the resume path. This is currently less useful than I
>> >> would like on the Nexus One since it is usually "SMD_RPCCALL" which
>> >> does not tell me a lot.
>> >
>> > This could be done easily enough, but if it's not very useful then
>> > there's no point.
>> >
>> It is useful there is no other way to tell what triggered a wakeup,
>> but it would probably be better to just track wakeup interrupts/events
>> elsewhere.
>>
>> >> active_since, tells you how long a a still active wakelock has been
>> >> active. If someone activated a wakelock and never released it, it will
>> >> be obvious here.
>> >
>> > Easily added.  But you didn't mention any field saying whether the
>> > wakelock is currently active.  That could be added too (although it
>> > would be racy -- but for detecting unreleased wakelocks you wouldn't
>> > care).
>> >
>>
>> These are the reported stats, not the fields in the stats structure.
>> The wakelock code has an active flag. If we want to keep the
>> pm_stay_wake nesting (which I would argue against), we would need an
>> active count. It would also require a handle, which is a change Rafael
>> said would not fly.
>>
>> >> total_time, total time the wake lock has been active. This one should
>> >> be obvious.
>> >
>> > Also easily added.
>> >
>> Only with a handle passed to all the calls.
>
> Well, I'm kind of tired of this "my solution is the only acceptable one"
> mindset.  IMHO, it's totally counter productive.
>

How do you propose to track how long a driver has blocked suspend when
you have an unblock call that takes no arguments.

>> >> sleep_time, total time the wake lock has been active when the screen was off.
>> >
>> > Not applicable to general systems.  Is there anything like it that
>> > _would_ apply in general?
>> >
>>
>> The screen off is how it is used on android, the stats is keyed of
>> what user space wrote to /sys/power/state. If "on" was written the
>> sleep time is not updated.
>>
>> >> max_time, longest time the wakelock was active uninterrupted. This
>> >> used less often, but the battery on a device was draining fast, but
>> >> the problem went away before looking at the stats this will show if a
>> >> wakelock was active for a long time.
>> >
>> > Again, easily added.  The only drawback is that all these additions
>> > will bloat the size of struct device.  Of course, that's why you used
>> > separately-allocated structures for your wakelocks.  Maybe we can
>> > change to do the same; it seems likely that the majority of device
>> > structures won't ever be used for wakeup events.
>> >
>>
>> Since many wakelocks are not associated with s struct device we need a
>> separate object for this anyway.
>>
>> >> >> and I would prefer that the kernel interfaces would
>> >> >> encourage drivers to block suspend until user space has consumed the
>> >> >> event, which works for the android user space, instead of just long
>> >> >> enough to work with a hypothetical user space power manager.
>> >
>> > Rafael doesn't _discourage_ drivers from doing this.  However you have
>> > to keep in mind that many kernel developers are accustomed to working
>> > on systems (mostly PCs) with a different range of hardware devices from
>> > embedded systems like your phones.  With PCI devices(*), for example,
>> > there's no clear point where a wakeup event gets handed off to
>> > userspace.
>> >
>> > On the other hand, there's no reason the input layer shouldn't use
>> > pm_stay_awake and pm_relax.  It simply hasn't been implemented yet.
>> ...
>>
>> The merged user space interface makes this unclear to me. When I first
>> used suspend on android I had a power manager process that opened all
>> the input devices and reset a screen off timeout every time there was
>> an input event. If the input layer uses pm_stay_awake to block suspend
>> when the queue is not empty, this will deadlock with the current
>> interface since reading the wake count will block forever if an input
>> event occurred right after the power manager decides to suspend.
>
> No, in that case suspend will be aborted, IIUC.
>

How? Your pm_get_wakeup_count function loops until events_in_progress becomes 0.

-- 
Arve Hjønnevåg
