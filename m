Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab0FVTzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:55:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46563 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754793Ab0FVTzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 15:55:53 -0400
Date: Tue, 22 Jun 2010 15:55:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Florian Mickler <florian@mickler.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
In-Reply-To: <201006221735.10467.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006221508390.1322-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010, Rafael J. Wysocki wrote:

> On Tuesday, June 22, 2010, Alan Stern wrote:
> > On Tue, 22 Jun 2010, Rafael J. Wysocki wrote:
> > 
> > > Having reconsidered that I think there's more to it.
> > > 
> > > Take the PCI subsystem as an example, specifically pcie_pme_handle_request().
> > > This is the place where wakeup events are started, but it has no idea about
> > > how they are going to be handled.  Thus in the suspend blocker scheme it would
> > > need to activate a blocker, but it wouldn't be able to release it.  So, it
> > > seems, we would need to associate a suspend blocker with each PCIe device
> > > that can generate wakeup events and require all drivers of such devices to
> > > deal with a blocker activated by someone else (PCIe PME driver in this
> > > particular case).  That sounds cumbersome to say the least.
> > 
> > Maybe this means pcie_pme_handle_request() isn't a good place to note
> > the arrival of a wakeup event.  Doing it in the individual driver might
> > work out better.
> 
> But it this case there will be an open window in which suspend may be started
> after the wakeup event is signaled, but before the PM core is told about it.

That's true but it doesn't matter, assuming the suspend can't progress 
during this window.

> > The problem in your example is that pcie_pme_handle_request() has no 
> > idea about the nature or extent of the critical section to follow.
> 
> Exactly.
>  
> > Therefore it's not in a good position to mark the beginning of the 
> > critical section, even though it is in an excellent position to mark 
> > the receipt of a wakeup event.
> 
> I think we have no choice but to regard the detection of a wakeup event as the
> beginning of a "suspend critical section".

Receipt of a wakeup event triggers a whole series of function calls,
including calls to the resume methods of every driver.  The system
should be designed so that the next suspend can't begin until those
function calls complete.  For example, the next suspend certainly can't
begin before the resume methods all complete.  Given that premise, any
one of those functions could serve as the start of a suspend critical
section.

> > > Moreover, even if we do that, it still doesn't solve the entire problem,
> > > because the event may need to be delivered to user space and processed by it.
> > > While a driver can check if user space has already read the event, it has
> > > no way to detect whether or not it has finished processing it.  In fact,
> > > processing an event may involve an interaction with a (human) user and there's
> > > no general way by which software can figure out when the user considers the
> > > event as processed.
> > 
> > Is this the kernel's problem?  Once userspace has read the event, we
> > can safely say that the kernel's critical section is over.  Perhaps a
> > userspace critical section has begun, perhaps not; either way, it's no
> > longer the kernel's responsibility.
> 
> Well, I agree here, but in the suspend blockers world it is the kernel
> responsibility, because the kernel contains the power manager part.

In the suspend blockers world (or at least, in Android's version of the
suspend blockers world), userspace would activate another suspend
blocker before reading the event.  The kernel's critical section could
then end safely once the event was read.

> > > So, even if we can say when the kernel has finished processing the event
> > > (although that would be complicated in the PCIe case above), I don't think
> > > it's generally possible to ensure that the entire processing of a wakeup event
> > > has been completed.  This leads to the question whether or not it is worth
> > > trying to detect the ending of the processing of a wakeup event.
> > 
> > As Arve pointed out, in some cases it definitely is worthwhile (the
> > gpio keypad matrix example).  In other cases there may be no reasonable
> > way to tell.  That doesn't mean we have to give up entirely.
> 
> Well, I'm not sure, because that really depends on the hardware and bus in
> question.  The necessary condition seems to be that the event be detected
> and handled entirely by the same functional unit (eg. a device driver) within
> the kernel and such that it is able to detect whether or not user space has
> acquired the event information.  That doesn't seem to be a common case to me.

It's hard to say how common this is without having a list of possible
wakeup sources.  And of course, that list will differ from one platform
to another.

> > > Now, going back to the $subject patch, I didn't really think it would be
> > > suitable for opportunistic suspend, so let's focus on the "forced" suspend
> > > instead.  It still has the problem that wakeup events occuring while
> > > /sys/power/state is written to (or even slightly before) should cause the
> > > system to cancel the suspend, but they generally won't.  With the patch
> > > applied that can be avoided by (a) reading from /sys/power/wakeup_count,
> > > (b) waiting for certain time (such that if a suspend event is not entirely
> > > processed within that time, it's worth suspending and waking up the
> > > system again) and (c) writing to /sys/power/wakeup_count right before writing
> > > to /sys/power/state (where the latter is only done if the former succeeds).
> > 
> > In other words, you could detect if a critical section begins after the 
> > user process has decided to initiate a suspend.  Yes, that's so.
> 
> Generally yes, although I think it will also detect "critical sections"
> starting exactly at the moment the suspend is started.  Which in fact is the
> purpose of the patch.

Well, the moment the suspend is started _does_ occur after the user 
process decides to initiate a suspend.  Hence critical sections 
starting exactly at that moment would indeed be detected.

> > So I'm not opposed to the new function.  But it doesn't solve the 
> > entire problem of avoiding suspends during critical sections.
> 
> Surely not and it isn't my goal at this point.
> 
> I think there are a few different issues that the suspend blockers (or
> wakelocks) framework attempts to address in one bit hammer.  To me, they are
> at least (1) deciding when to suspend, (2) detecting events that should make
> us avoid suspending (or abort suspend if already started), (3) preventing
> "untrusted" processes from making the system use too much energy.
> 
> IMO it's better to treat them as different issues and try to address them
> separately.

Certainly (3) needs to be addressed separately.  It should be handled 
completely within userspace, if at all possible.

(1) and (2) are closely related.  In fact, a reasonable criterion for 
(1) might be: Suspend whenever it is allowed.  Then (2) becomes: What 
sorts of things should disallow suspend, and for how long?


Evidently part of the problem here is that for a very long time
(predating the existence of Linux), people have been using a bad
abstraction.  We talk about "wakeup events", but an event occupies only
a single moment in time.  If the computer happens to be asleep at that
moment then it wakes up, fine.  But if it was already awake, then once
the moment is passed there's no reason not to suspend -- even if only
1 microsecond has elapsed.  Likewise, if an event causes the computer
to wake up, then once the computer is awake the moment is over and
there's nothing to prevent the computer from immediately going back to
sleep.

Instead of talking about events, we should be talking about procedures
or sections: something that happens over a non-zero period of time.  
But people have never thought in terms of wakeup procedures or suspend
critical sections, and so the kernel isn't designed to accomodate them.  
We may know when they begin, but we often have only a cloudy idea of
when they end.

Historically, people have mostly had in mind that the answer to (1)
would be: Suspend whenever the user tells the computer to suspend.  In
that kind of setting, (2) doesn't matter: When the user tells the
machine to suspend, it should obey.

But when we start to consider energy conservation and autonomous (or
opportunistic) suspend, things become more complex.  This is why, for
example, the USB subsystem has a user-selectable autosuspend delay.  
It's not an ideal solution, but it does prevent us from thrashing
between suspending and resuming a device over and over if it gets used
repeatedly during a short period of time.


We can design mechanisms until we are blue in the face (some of us may
be blue already!), but until we remedy this weakness in our thinking we
won't know how to apply them.  Which means people won't be able to
agree on a single correct approach.

Alan Stern

