Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab0FIP3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:29:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57409 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755567Ab0FIP3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:29:37 -0400
Date: Wed, 9 Jun 2010 11:29:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: tytso@mit.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Felipe Balbi <felipe.balbi@nokia.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <AANLkTilALyvthzh8rMiDFFP_QTz_o5hxdE8tArMUonpP@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1006091031030.1728-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, Arve Hjønnevåg wrote:

> >> Wakeup event occurs, and the driver:
> >> - report wakeup event type A
> >> - queue event for delivery to user-space
> >
> > That's not really two distinct steps.  Queuing the event for delivery
> > to userspace involves waking up any tasks that are waiting to read the
> > device file; that action (calling wake_up_all() or whatever the driver
> > does) is how the event gets reported.
> >
> 
> If you want to ensure that more than one process see the event it has
> to be two steps, but it does not affect the race I was trying to
> describe.

Are you sure about that?  If two processes call poll() for the same
file descriptor, don't both calls return when data becomes available?  
But agreed, it doesn't matter -- especially since I only need one 
process (the power manager) to see the event.

> >> User space wakes up:
> >> - Calls api to block task freezing for event type A
> >
> > Again, that's a confusing way of putting it.  The API you're referring
> > to is simply the function that activates a suspend blocker.  It does
> > prevent task freezing, but you shouldn't say it prevents freezing for
> > event type A.  More like the other way around: In addition to
> > preventing freezing, the function tells the power manager that event
> > type A should no longer be considered active.  Thus, in a sense it
> > _stops_ event type A from preventing freezing.
> >
> >> Another wakeup event occurs, and the driver:
> >> - report wakeup event type A

I think this is where you misunderstood.  There is no "report wakeup
event" as such.  All that happens is that data becomes available to be
read from the input device file.  However the power manager process
isn't polling the device file at this point (because a suspend blocker
is active), so it doesn't realize that the source has become active
again.

> >> - queue event for delivery to user-space
> >
> > Same as above.
> >
> >> User space continues:
> >> - Read events
> 
> Sorry, I missed the unblock task freezing step here.
> 
> >> - Wait for more events
> >>
> >> Result: Task are not frozen again.
> >
> > Because the suspend blocker was never deactivated.  The same thing
> > happens with wakelocks: If a task activates a wakelock and never
> > deactivates it, the system won't go into opportunistic suspend again.
> 
> Yes, but with the sequence of events above task will not be frozen
> again even if the wake-lock/suspend-blocker/task-freezing-preventer is
> released.

Yes they will.  When the suspend blocker is deactivated, the power 
manager process will realize that there are no active suspend blockers 
and it will think there are no active sources.  Thus it will freeze 
processes as usual.

> > Here's how my scheme is meant to work:
> >
> >        Wakeup event for input device A occurs.
> >
> >        A's driver adds an entry to the input device queue and
> >        (if the queue was empty) does wake_up_all() on the device
> >        file's wait_queue.
> >
> >        The PM process returns from poll() and sees that device
> >        file A is now readable, so it adds A to its list of active
> >        sources and unfreezes userspace.
> >
> >        Some other process sees that device file A is now readable,
> >        so it activates a suspend blocker and reads events from A.
> >
> >        When the PM process receives the request to activate the
> >        suspend blocker, it removes A from its list of active
> >        sources.  But it doesn't freeze userspace yet, because now
> >        a suspend blocker is active.
> 
> If another event happens at this point don't you put A back on the
> list? If so, it never gets removed.

No, you don't put A back on the list.  Sources get put on the list only
when the information returned by poll() indicates they have data
available.  The power manager doesn't poll while suspend blockers are 
active.

> >        The other process consumes events from A and does other
> >        stuff.  Maybe more input data arrives while this is happening
> >        and the process reads it.  Eventually the process decides to
> >        deactivate the suspend blocker, perhaps when no more data
> >        is available from the device file, perhaps not.
> >
> >        When the PM process receives the request to deactivate the
> >        suspend blocker, it sees that now there are no active
> >        sources and no active suspend blockers.  Therefore it
> >        freezes userspace and does a big poll() on all possible
> >        sources.  (If there are still events on the input device
> >        queue, the poll() returns immediately.)
> >
> >        Rinse and repeat.
> >
> > I don't see any dangerous races there.  The scheme can be made a little
> > more efficient by having the PM process do another poll() (with 0
> > timeout) just before freezing userspace; if the result indicates that a
> > source is active then the freezing and unfreezing can be skipped.

> > There is no race.  The driver reports an event has occurred by making
> > the data available to be read from the device file, and the event is
> > processed by reading it from the device file (or at least, that's the
> > first step in processing the event).
> >
> 
> If the driver making data available to be read triggers a wakeup event
> in the power manager process

It doesn't.  Only return from a poll() causes the power manager process 
to think a wakeup event has occurred.

> that has to be cleared by the process
> reading the events, then you have a race. Since the power manager is
> selecting/polling on the same file descriptor, I don't see what you
> gain from linking the wakeup events to suspend blockers.

What I gain is the ability to know when an in-kernel wakelock _could_ 
have been released, without actually implementing in-kernel wakelocks.

With real in-kernel wakelocks, the wakelock is released when the input 
queue becomes empty.  There's no way for the power manager process to 
know exactly when that happens without modifying the kernel.  However 
we can use the activation of the corresponding userspace suspend 
blocker as a proxy.  It's nearly as good, and it gets the job done.

If you prefer, an interface could be added whereby a user process tells 
the power manager explicitly that it's going to read data from an 
input device, instead of relying on implicit notification through 
suspend blocker activation.  I don't know whether this would be simpler 
or more complex; it depends on the design of your userspace.

> If you break
> this link it think can work, but it does require us to modify all code
> that reads wakeup events from the kernel to register the file
> descriptors they get events from.

Yes.  I don't know how your user code is structured; if there is a
fixed correspondence between file descriptors and suspend blockers (the
same wakeup events are always handled by the same suspend blockers)
then this will be a simple change -- the file descriptor can be 
registered when the suspend blocker is created.

If the correspondence is more dynamic (different suspend blockers used 
for the same wakeup device at different times, or multiple wakeup 
devices handled by one suspend blocker) then the required changes will 
be more complicated.  Not tremendously more.

> It would also require adding
> poll/select support to android alarm driver,

Yes.  Is this a platform-specific driver?  (I assume so, since you 
called it the "android alarm driver".)  Then poll/select support can be 
added without provoking a lot of objections from legions of kernel 
developers.

> and any driver that
> currently uses a wakelock with a timeout would need to notify the user
> space power manager instead.

Hmm.  This is symptomatic of a deficiency in the original wakelock 
implementation -- those timeouts always were arbitrary.

The power manager would indeed have to know about wakeup devices that 
don't need to _keep_ the system awake.  Here's one way to cope: During 
those times when no suspend blockers are active but the PM process 
thinks a wakeup source is active, the PM process could poll every few 
seconds to update its list of active sources.  At those points it could 
remove wakeup sources that have timed out.


Obviously this proposal would complicate your userspace.  Not
enormously, since most of the work is confined to the power manager,
but somewhat.  That's the price to be paid for leaving the kernel
essentially untouched.  Consider the amount of resistance your
wakelock/suspend-blocker patches have already received; you'll have to
decide which approach will work out better in the end.

Alan Stern

