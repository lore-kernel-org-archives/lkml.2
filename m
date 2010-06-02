Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab0FBAnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 20:43:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab0FBAnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 20:43:32 -0400
Date: Wed, 2 Jun 2010 10:43:18 +1000
From: Neil Brown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100602104318.0c41b3cd@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1006011032150.2949-100000@iolanthe.rowland.org>
References: <20100601123846.14d0535b@notabene.brown>
	<Pine.LNX.4.44L0.1006011032150.2949-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 10:47:49 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 1 Jun 2010, Neil Brown wrote:
> 
> > > With wakeup events the problem isn't so bad.  Wakeup events are always
> > > noticed, and if the system is designed properly they will either abort
> > > a suspend-in-progress or else cause the system to resume as soon as the
> > > suspend is complete.  (Linux is not yet properly designed in this
> > > sense.)
> > 
> > This is exactly the issue.  Linux doesn't get this right.  A wakeup that is
> > processed by the driver just before suspend may not get all the way out to
> > it's final destination (possibly in meat-space) until after some other event
> > wakes the device.  It is not possible to guarantee full delivery of a wakeup
> > event with Linux in its current state.  This is a bug.
> 
> That wasn't what I meant.  An important requirement is that a wakeup 
> event received after the device has been suspended, but before the 
> system suspend is complete, should cause the system suspend to abort.  
> This is one of the things suspend blockers were meant to help with.  In 
> theory it should already work correctly -- but it doesn't.  That's a 
> real bug.
> 
> The other things you're talking about aren't really bugs.  That is,
> they are things which the kernel _ought_ to do but it wasn't _intended_
> to do.  They are misfeatures: failures of design, not failures of 
> execution.

A fairly subtle distinction, but I can accept it.  We are working with a
design failure.
But when a design failure results in a feature not being usable in a
race-free way, I would still call that failure of design a bug - a bug in the
design.

> 
> > I don't think I'm missing that.  Wakeup events are the only events of
> > interest.  But wakeup events are more than just low-level hardware events.
> > They are also the virtual events that are a direct consequence of the
> > original hardware event.
> 
> This is a matter of semantics and it is highly debatable.
> 
> > A UART asserts 'data ready' which is routed to an IO interrupt line that
> > wakes the device.  This is a wakeup event.
> 
> Yes.
> 
> > So are the bits that appear on the data line which represent the data
> > So are the characters that appear on the serial port
> > So is the "here is a message from the GSM processor" event
> > So is the "there is a new TXT message" event
> > So is the "'beep beep beep' out the speaker" event
> 
> None of those things can cause the system to wake up after it is
> suspended.  Indeed, they can't happen at all if the CPU isn't running
> (unless the GSM processor runs autonomously -- let's ignore such
> details).  Hence it makes little sense to call them "wakeup" events.
> 

I think we are seeing this very differently.  In my mind these are in one
sense all the same event, just represented in different ways.

One of the reasons that we have an OS is to support levels of abstraction.
A disk drives stores sectors, but I want to store files
A monitor displays pixels, but I want to display text
A network sends packets, but I want to send Email.

The OS (including but not only the kernel) handles the conversion.
It is still my Email that is going out over the network even though the
network card has no concept of 'email'.

Similarly the event of importance above in the notification that a TXT has
arrived.
At the lowest level, it appears as 'data-ready' on a UART.  At the highest
level is it sound-waves in the air.  But it is the same event.  And the role
of the OS is to allow me to treat it all as one event - one abstract concept.

Obviously the involvement of the kernel ends when the event reaches or
crosses the boundary to user-space, and user-space must be responsible for
taking it to the boundary to meat-space.
But the kernel needs to ensure that this holistic wake-up event can be
handled without racing with a suspend request.
If you just protect the lowest level representation of the event, but don't
allow the higher level representations to be protected, then it is a bit like
a filesystem that requires you to send SCSI commands to the disk drive if you
want to be sure your data is safe.

> > All these events are wakeup events, and should abort or instant-resume the
> > system.  Currently only the first can be guaranteed to do this (... and maybe
> > the second, depending on the details of the implementation).
> > suspend-blocks effectively pass a lock from one event to the next to ensure
> > that all of these event block the suspend.  There are various other ways to
> > achieve the same thing, and I think it can be done with no significant change
> > to the API.  But some how we need to allow all of these events to be
> > linked wake-up events, not just the first one.
> 
> That's not entirely clear.  Yes, for Android's use case that's what you 
> want.  But in other situations maybe you don't.  Consider the example 
> of someone who closes the lid of their laptop and throws it in a 
> backpack.  The computer should suspend immediately; it shouldn't be 
> delayed by these "virtual wakeup" events.

Completely agree.  Old behaviour must remain unchanged, new behaviour must be
explicitly requested.

At each level, it must be explicitly stated that an event is to be treated
like a wake-up event.  I believe that is already the case in drivers - they
need to explicitly configure the interrupt to cause a wake-from-suspend.

I've considered several possibilities for how user-space could explicitly say
that events are wake-event.  My current favourite is to use fcntl(F_SETOWN)
to request a signal be sent to the process that is initiating the suspend
when the relevant events are ready to be consumed by user-space.
This would work for events that come through the input system (button press)
or through the network, or rtc alarm events.  I suspect all potential
wake-events could be made to use this scheme, but I don't have an exhausting
list at present.

So a suspend request waits just long enough to close any race, checks if
there are signals pending, and proceeds with the suspend if there aren't.
The "just long enough" is a little tricky to measure, though the in-kernel
part of suspend-blockers presumably can be used to get that right.

If the suspending process hasn't requested the delivery of these signals, the
suspend will possibly pause to make sure that any events-in-transit in the
kernel have reached their in-kernel destination (milliseconds at most) and
then proceed with the suspend as normal.

So yes, there are different use cases and we should support all of them,
both "I shut the lid and my laptop really stays asleep" and "I never miss a
TXT because my phone went to sleep at a bad time".  The process that
initiates the suspend has a role in choosing what can wake it up.

Thanks,
NeilBrown
