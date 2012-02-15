Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab2BOXr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:47:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54636 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab2BOXrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:47:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH] Input: Add ioctl to block suspend while event queue is not empty.
Date: Thu, 16 Feb 2012 00:51:15 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
References: <1327112659-31145-1-git-send-email-arve@android.com> <201202120028.23364.rjw@sisk.pl> <CAMP5XgfrG=3qeFasg4prBu88-Ox59_PtFw-rpgb=PN=uo6VPuw@mail.gmail.com>
In-Reply-To: <CAMP5XgfrG=3qeFasg4prBu88-Ox59_PtFw-rpgb=PN=uo6VPuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202160051.16011.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, February 14, 2012, Arve Hjønnevåg wrote:
> 2012/2/11 Rafael J. Wysocki <rjw@sisk.pl>:
> > Hi,
> >
> > On Saturday, January 21, 2012, Arve Hjønnevåg wrote:
> >> Add an ioctl, EVIOCSSUSPENDBLOCK, to block suspend while the event
> >> queue is not empty. This allows userspace code to process input
> >> events while the device appears to be asleep.
> >
> > I have two questions to start with, if you don't mind:
> >
> > (1) Does Android user space use an analogous interface right now or is it
> >    a prototype?
> >
> 
> Yes (for the next version), but with a wakelock based implementation.

That's exactly what I wanted to know. :-)

> > (2) What exactly are the use cases for it (ie. what problem does it address
> >    that cannot be addressed in a different way)?
> >
> 
> The reason for adding an ioctl versus the old android version with
> used a wakelock for all input events, is that not all input events are
> wakeup events. Specifically some sensors generate input events at such
> a high rate that they prevent suspend while the sensor is on even
> though the driver has a suspend hook that turns the sensor off.
> 
> If you are asking why input events need to block suspend at all, this
> was the example used in the suspend blocker documentation:
> - The Keypad driver gets an interrupt. It then calls suspend_block on the
>   keypad-scan suspend_blocker and starts scanning the keypad matrix.
> - The keypad-scan code detects a key change and reports it to the input-event
>   driver.
> - The input-event driver sees the key change, enqueues an event, and calls
>   suspend_block on the input-event-queue suspend_blocker.
> - The keypad-scan code detects that no keys are held and calls suspend_unblock
>   on the keypad-scan suspend_blocker.
> - The user-space input-event thread returns from select/poll, calls
>   suspend_block on the process-input-events suspend_blocker and then calls read
>   on the input-event device.
> - The input-event driver dequeues the key-event and, since the queue is now
>   empty, it calls suspend_unblock on the input-event-queue suspend_blocker.
> - The user-space input-event thread returns from read. If it determines that
>   the key should be ignored, it calls suspend_unblock on the
>   process_input_events suspend_blocker and then calls select or poll. The
>   system will automatically suspend again, since now no suspend blockers are
>   active.

That looks reasonable to me.

Still, I have one issue with adding those ioctls.  Namely, wouldn't it be
simpler to treat all events coming from wakeup devices as wakeup events?

With the new ioctls user space can "mark" a queue of events coming out of
a device that's not a wakeup one as a "wakeup source", which doesn't seem to
be correct.

Conversely, with those ioctls user space can effectively turn events coming
out of a wakeup device into non-wakeup ones, which doesn't seem to be correct
either.

So, I think evdev client queue's wakeup source (or wakelock) should stay active
if there are any events in the queue and the underlying device is a wakeup one,
i.e. device_may_wakeup() returns true for it.  Then, we won't need the new
ioctls at all and user space will still be able to control which events are to
be regarded as wakeup ones by changing the wakeup settings of the devices that
generate them.

Thanks,
Rafael
