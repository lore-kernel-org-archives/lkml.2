Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab0FUCXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 22:23:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59487 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757796Ab0FUCXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 22:23:40 -0400
Date: Sun, 20 Jun 2010 22:23:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
In-Reply-To: <201006202350.27143.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006202154260.29532-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010, Rafael J. Wysocki wrote:

> > > Generally, there are two problems in that area.  First, if a wakeup event
> > > occurs exactly at the same time when /sys/power/state is being written to,
> > > the even may be delivered to user space right before the freezing of it,
> > > in which case the user space consumer of the event may not be able to process
> > > it before the system is suspended.
> > 
> > Indeed, the same problem arises if the event isn't delivered to
> > userspace until after userspace is frozen.
> 
> In that case the kernel should abort the suspend so that the event can be
> delivered to the user space.

Yes.

> > Of course, the underlying issue here is that the kernel has no direct way
> > to know when userspace has finished processing an event.  Userspace would
> > have to tell it, which generally would mean rewriting some large number of user
> > programs.
> 
> I'm not sure of that.  If the kernel doesn't initiate suspend, it doesn't
> really need to know whether or not user space has already consumed the event.

That's true.  But it only shifts the onus: When a userspace program has 
finished processing an event, it has to tell the power-manager process.  
Clearly this sort of thing is unavoidable, one way or another.

> > > The following patch illustrates my idea of how these two problems may be
> > > addressed.  It introduces a new global sysfs attribute,
> > > /sys/power/wakeup_count, associated with a running counter of wakeup events
> > > and a helper function, pm_wakeup_event(), that may be used by kernel subsystems
> > > to increment the wakeup events counter.
> > 
> > In what way is this better than suspend blockers?
> 
> It doesn't add any new framework and it doesn't require the users of
> pm_wakeup_event() to "unblock" suspend, so it is simpler.  It also doesn't add
> the user space interface that caused so much opposition to appear.

Okay.  A quick comparison shows that in your proposal:

	There's no need to register and unregister suspend blockers.
	But instead you create the equivalent of a suspend blocker
	inside every struct device.

	Drivers (or subsystems) don't have to activate suspend 
	blockers.  But instead they have to call pm_wakeup_event().

	Drivers don't have to deactivate suspend blockers.  You don't
	have anything equivalent, and as a result your scheme is 
	subject to the race described below.

	There are no userspace suspend blockers and no opportunistic
	suspend.  Instead a power-manager process takes care of 
	initiating or preventing suspends as needed.

In short, you have eliminated the userspace part of the suspend blocker 
approach just as in some of the proposals posted earlier, and you have 
replaced the in-kernel suspend blockers with new data in struct device 
and a new PM API.  On the whole, it doesn't seem very different from 
the in-kernel part of suspend blockers.  The most notable difference is 
the name: pm_wake_event() vs. suspend_blocker_activate(), or whatever 
it ended up being called.

This is the race I was talking about:

> > What happens if an event arrives just before you read
> > /sys/power/wakeup_count, but the userspace consumer doesn't realize
> > there is a new unprocessed event until after the power manager checks
> > it?

> I think this is not the kernel's problem.  In this approach the kernel makes it
> possible for the user space to avoid the race.  Whether or not the user space
> will use this opportunity is a different matter.

It is _not_ possible for userspace to avoid this race.  Help from the 
kernel is needed.

> >  Your plan is missing a critical step: the "handoff" whereby 
> > responsibility for handling an event passes from the kernel to 
> > userspace.

> > With suspend blockers, this handoff occurs when an event queue is 
> > emptied and its associate suspend blocker is deactivated.  Or with some 
> > kinds of events for which the Android people have not written an 
> > explicit handoff, it occurs when a timer expires (timed suspend 
> > blockers).
> 
> Well, quite frankly, I don't see any difference here.  In either case there is
> a possibility for user space to mess up things and the kernel can't really help
> that.

With suspend blockers, there is also the possibility for userspace to 
handle races correctly.  But with your scheme there isn't -- that's the 
difference.

> > This shares with the other alternatives posted recently the need for a
> > central power-manager process.  And like in-kernel suspend blockers, it
> > requires changes to wakeup-capable drivers (the wakeup-events counter
> > has to be incremented).
> 
> It doesn't really require changes to drivers, but to code that knows of wakeup
> events, like the PCI runtime wakeup code.

Just like in-kernel suspend blockers.

>  Moreover, it doesn't require kernel
> subsystems to know or even care when it is reasonable to allow suspend to
> happen.  The only thing they need to do is to call pm_wakeup_event() whenever
> they see a wakeup event.

That's just semantics.  Obviously a wakeup event should prevent suspend
from happening, so if subsystems know or care about one then they know
or care about the other.

>  I don't really think it is too much of a requirement
> (and quite frnakly I can't imagine anything simpler than that).

This is because you have omitted the part about allowing suspends again
(or if you prefer, about notifying the PM core that a wakeup event has
been handed off to userspace).  As a result of leaving this out, you
haven't eliminated all the races.

> Yes, it does, but I have an idea about how to implement such a power manager
> and I'm going to actually try it.

A logical design would be to use dbus for disseminating PM-related 
information.  Does your idea work that way?

> I don't think any of the approaches that don't use suspend blockers allows
> one to avoid the race between the process that writes to /sys/power/state
> and a wakeup event happening at the same time.  They attempt to address another
> issue, which is how to prevent untrusted user space processes from keeping the
> system out of idle, but that is a different story.

Well, there was one approach that didn't use suspend blockers and did 
solve the race: the original wakelocks proposal.  Of course, that was 
just suspend blockers under a different name.  One could make a very 
good case that your scheme is also suspend blockers under a different 
name (and with an important part missing).

Alan Stern

