Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2GUUjP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 16:39:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38205 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab2GUUjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 16:39:14 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVPupumYqeBwTwgK3C04VQBxOjkFMbaKQ-Gsz3teCWqQ=w@mail.gmail.com>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
 <CA+55aFwZRvtpE2e3zNqvtobpPROqw_bOwNt+=DBzmScV0_rq=w@mail.gmail.com> <CACVXFVPupumYqeBwTwgK3C04VQBxOjkFMbaKQ-Gsz3teCWqQ=w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 21 Jul 2012 13:38:52 -0700
X-Google-Sender-Auth: aY8fNDjw9miOnYMC6XJ4udn1WdQ
Message-ID: <CA+55aFwte5bc-4FC758pBN3FbrtKQfwm_Mv_banekhL=kSF8kg@mail.gmail.com>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot and resume
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2012 at 12:55 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>
> Suppose it is not good for resume case, I think it still makes sense
> for early boot situation, at least the patch will support to request
> firmware inside init call, and allow drivers to be built in kernel i
> case of requesting firmware from probe().

I agree that this is a problem. At the same time, early boot has some
of the exact same problems as resume has, and I do wish that people
would ask themselves: "why do I try to load the firmware at early boot
time"?

There is really only *one* real reason to load firmware at device
probe time, and that's because the device is needed for the boot. But
in that case, deferral is wrong, isn't it?

And if the device isn't needed for boot, then why is it loading so
early? For network devices, for example (and this is a *common*
issue), firmware should be loaded not at device init, but at device
*open* time, exactly because we don't want to load it too early when
it might not even be available yet.

So I would prefer if people basically just understood that "if you're
trying to load firmware at module init time, you are almost certainly
doing something wrong".

Delaying the firmware load as much as possible (and here "delaying"
does *not* mean your kind of "deferred" load, but explicitly doing it
only when really needed) allows things like "boot the system, copy the
new firmware from a USB stick in single-user mode, then bring up
networking". It also simply avoids the whole module load ordering
issue.

So I really think you are looking (again) too much at working around
the symptoms, rather than fixing the deeper issue.

> It is a good idea to let the driver defer request explicitly, but still need
> some changes in generic code to support it.

That's fine. I am not arguing against making core driver core changes,
I'm just arguing against making them so that you facilitate bad
behavior and work around the symptoms of bad choices.

In fact, I'd actually want to argue for *bigger* core device layer
changes to make it easier to do the right thing. Right now, one of the
reasons why driver writers load the firmware at init time is that it's
often _easiest_ for them to do it there, even if it's the wrong point
to do it. And that is partly because I think the device layer doesn't
help enough in making it really convenient to do later.

> In my opinion,  we should cache firmware data for all hotplug
> devices or devices which may experience power loss automatically
> in kernel during suspend-resume cycle because all such devices may be
> disconnected and connected again during suspend-resume cycle.

Yes. *THAT* is absolutely the kind of change I'd love to see. The core
device layer doesn't really make it easy to handle firmware sanely
over suspend/resume, which is kind of sad. Why does every driver have
to have its own "let me remember my firmware over the suspend/resume
event" and have extra code in suspend/resume, when it's really a
pretty generic situation: if the device has firmware, wouldn't it be
really nice if the core driver layer just knew about that and kept
track of it?

> Looks it is not difficult to cache firmware data by kernel, for example, just
> call the
>
>            cache_firmware(fw_name)
>
> for each device which need firmware before suspending,
> then call the below to uncache firmware after resume:
>
>            uncache_firmware(fw_name)

Exactly. But we should make it automatic, and we should only do it if
the device is actually *active*. If nobody is using the device over
the suspend-resume event, the firmware shouldn't be loaded in the
first place, and resume obviously shouldn't need to re-load it.
Wouldn't it be nice if something like the PCI layer (or the USB layer)
just knew to do the rigth thing for the device on its own?

I would also suggest that the firmware caching have some internal
timeout, so that for the (fairly common) case where a suspend/resume
event might look like a unplug/replug event, the caching would
actually still remember the firmware despite the fact that it looked
(for a short while) like the device went away.

So *this* is where I think we could improve on the generic code. Make
it really easy for devices to do the right thing. Make sure that
firmware caches work, even if it looks like devices disappeared
momentarily. Maybe add a few callbacks from generic code to say "you
can load your firmware now, because the system is up".

So I'm really not against improving the situation with firmware
loading. What I'm against is making it easy for device drivers to do
all the wrong things - like loading firmware in their init routines,
or trying to load firmware at resume time. Because those are both
fundamentally *BAD* things to do.

Don't try to help people do bad things.

> The problem is that many firmwares may consume much
> memory

This tends to come up as an argument, but is it actually true?

I don't think so. Especially for suspend-resume, if the device is
active, you *KNOW* that you will want to load the firmware at resume
time. But at the same time, resume time is when you want to be really
quick: you want to aim for a model where the resume has fully
*completed* by the time the user has opened the lid of the laptop
fully (just as an example). And what does that imply? It implies that
you really want to do as much of the expensive stuff at *suspend*
time.

Who cares if you use memory for firmware while the device is
suspended? NOBODY. And if it takes two extra seconds for the laptop to
really suspend after you close the lid, that's fine too. You'd much
rather spend the time then (when the user clearly doesn't care about
using his device), than at resume time.

So it's really FUNDAMENTALLY WRONG to load firmware at resume time.
It's fundamentally wrong not just because it can be hard to do (the
machine isn't really fully functional yet), but it's fundamentally
wrong because it's STUPID. You want to load the firmware at suspend
time because that's better for the user interface too!

> So saving memory space is another advantage of the deferral
> of request_firmware.

I agree, but see above: I think that argument is only true for the
"the device is not actually in use".

So I really think the rules should always be:

 - firmware should NEVER be loaded at module init time, because it's
the wrong time to do it - the device may never be needed at all.
Slowing down the init sequence is just stupid.

   For example, you may have both a wired and a wireless network in
your laptop, but if you have turned off wireless (airplane mode, for
example), maybe you shouldn't be loading the firmware at all. Or
conversely, maybe you *did* load the firmware of both the wired and
wireless networking when you booted, but the wired network then
noticed that there's no cable attached (after you loaded the firmware
- maybe the driver cannot even tell without the firmware), so the
wired network is not in use, and is not opened. When a suspend
happens, in a perfect world, we should just notice. So we wouldn't
preload the firmware for suspend, because the device isn't even *open*
while suspended, so resume doesn't need to load the firmware.

   Of course, after resume, maybe networkmanager wakes up and checks
the cables, and at that point we load the wired firmware too (*after*
resume, and as a result of opening the device). But then it's the
*correct* thing to load the firmware only after resume, because it
wasn't loaded as *part* of the resume. See what I'm saying.

 - If firmware is needed for resume, it should be loaded by the
suspend logic and cached in memory.

   The reason for this is not just that loading it at resume time
might be hard (so load it when you know the system is fully working),
but also the user interface issue I already mentioned.

Sure, sometimes firmware is a few megabytes in size. But machines
where a few megabytes is a big deal will *not* be running those kinds
of devices. Plus if you load it at suspend-time, nobody really cares
if it takes a while to load and wastes memory while the machine isn't
doing anything. Why would they care?

                Linus
