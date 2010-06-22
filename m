Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab0FVPhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:37:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38184 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab0FVPhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 11:37:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Tue, 22 Jun 2010 17:35:10 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <Pine.LNX.4.44L0.1006220952290.1631-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006220952290.1631-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006221735.10467.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010, Alan Stern wrote:
> On Tue, 22 Jun 2010, Rafael J. Wysocki wrote:
> 
> > Having reconsidered that I think there's more to it.
> > 
> > Take the PCI subsystem as an example, specifically pcie_pme_handle_request().
> > This is the place where wakeup events are started, but it has no idea about
> > how they are going to be handled.  Thus in the suspend blocker scheme it would
> > need to activate a blocker, but it wouldn't be able to release it.  So, it
> > seems, we would need to associate a suspend blocker with each PCIe device
> > that can generate wakeup events and require all drivers of such devices to
> > deal with a blocker activated by someone else (PCIe PME driver in this
> > particular case).  That sounds cumbersome to say the least.
> 
> Maybe this means pcie_pme_handle_request() isn't a good place to note
> the arrival of a wakeup event.  Doing it in the individual driver might
> work out better.

But it this case there will be an open window in which suspend may be started
after the wakeup event is signaled, but before the PM core is told about it.

> Or look at this from a different point of view.  Adopting Mark's 
> terminology, let's say that the kernel is in a "critical section" at 
> times when we don't want the system to suspend.  Currently there's no 
> way to tell the PM core when the kernel enters or leaves a critical 
> section, so there's no way to prevent the system from suspending at the 
> wrong time.
> 
> Most wakeup events indicate the start of a critical section, in the 
> sense that you hardly ever say: "I want the computer to wake up when I 
> press this button, but I don't care what it does afterward -- it can go 
> right back to sleep without doing anything if it wants."  Much more 
> common is that a wakeup event requires a certain amount of processing, 
> and you don't want the system to go back to sleep until the processing 
> is over.  Of course, if the processing is simple enough that it can all 
> be done in an interrupt handler or a resume method, then nothing 
> extra is needed since obviously the system won't suspend while an 
> interrupt handler or a resume method is running.  But for more 
> complicated cases, we need to do more.
> 
> The problem in your example is that pcie_pme_handle_request() has no 
> idea about the nature or extent of the critical section to follow.

Exactly.
 
> Therefore it's not in a good position to mark the beginning of the 
> critical section, even though it is in an excellent position to mark 
> the receipt of a wakeup event.

I think we have no choice but to regard the detection of a wakeup event as the
beginning of a "suspend critical section".

> > Moreover, even if we do that, it still doesn't solve the entire problem,
> > because the event may need to be delivered to user space and processed by it.
> > While a driver can check if user space has already read the event, it has
> > no way to detect whether or not it has finished processing it.  In fact,
> > processing an event may involve an interaction with a (human) user and there's
> > no general way by which software can figure out when the user considers the
> > event as processed.
> 
> Is this the kernel's problem?  Once userspace has read the event, we
> can safely say that the kernel's critical section is over.  Perhaps a
> userspace critical section has begun, perhaps not; either way, it's no
> longer the kernel's responsibility.

Well, I agree here, but in the suspend blockers world it is the kernel
responsibility, because the kernel contains the power manager part.

> > It looks like user space suspend blockers only help in some special cases
> > when the user space processing of a wakeup event is simple enough, but I don't
> > think they help in general.  For an extreme example, a user may want to wake up
> > a system using wake-on-LAN to log into it, do some work and log out, so
> > effectively the initial wakeup event has not been processed entirely until the
> > user finally logs out of the system.  Now, after the system wakeup (resulting
> > from the wake-on-LAN signal) we need to give the user some time to log in, but
> > if the user doesn't do that in certain time, it may be reasonable to suspend
> > and let the user wake up the system again. 
> 
> I agree.  This is a case where there is no clear-cut end to the
> kernel's critical section, because the event is not handed over to
> userspace.  A reasonable approach would be to use a timeout, perhaps
> also with some heuristic like: End the critical section early if we
> receive 100(?) more network packets before the timeout expires.

Exactly.

> > Similar situation takes place when the system is woken up by a lid switch.
> > Evidently, the user has opened the laptop lid to do something, but we don't
> > even know what the user is going to do, so there's no way we can say when
> > the wakeup event is finally processed.
> 
> In this case, the kernel could inform an appropriate user process (some
> part of DeviceKit? or the power-manager process?) about the lid-switch
> event.  Once that information had been passed on, the kernel's critical
> section would be over.  The process could start its own critical
> section or not, as it sees fit.
> 
> If there is no process to send the information to, the kernel could 
> again end the critical section after a reasonable timeout (1 minute?).

Agreed.

> > So, even if we can say when the kernel has finished processing the event
> > (although that would be complicated in the PCIe case above), I don't think
> > it's generally possible to ensure that the entire processing of a wakeup event
> > has been completed.  This leads to the question whether or not it is worth
> > trying to detect the ending of the processing of a wakeup event.
> 
> As Arve pointed out, in some cases it definitely is worthwhile (the
> gpio keypad matrix example).  In other cases there may be no reasonable
> way to tell.  That doesn't mean we have to give up entirely.

Well, I'm not sure, because that really depends on the hardware and bus in
question.  The necessary condition seems to be that the event be detected
and handled entirely by the same functional unit (eg. a device driver) within
the kernel and such that it is able to detect whether or not user space has
acquired the event information.  That doesn't seem to be a common case to me.

> > Now, going back to the $subject patch, I didn't really think it would be
> > suitable for opportunistic suspend, so let's focus on the "forced" suspend
> > instead.  It still has the problem that wakeup events occuring while
> > /sys/power/state is written to (or even slightly before) should cause the
> > system to cancel the suspend, but they generally won't.  With the patch
> > applied that can be avoided by (a) reading from /sys/power/wakeup_count,
> > (b) waiting for certain time (such that if a suspend event is not entirely
> > processed within that time, it's worth suspending and waking up the
> > system again) and (c) writing to /sys/power/wakeup_count right before writing
> > to /sys/power/state (where the latter is only done if the former succeeds).
> 
> In other words, you could detect if a critical section begins after the 
> user process has decided to initiate a suspend.  Yes, that's so.

Generally yes, although I think it will also detect "critical sections"
starting exactly at the moment the suspend is started.  Which in fact is the
purpose of the patch.

> On the other hand, we should already be able to abort a suspend if a
> wakeup event arrives after tasks are frozen (to pick a reasonable
> boundary point).  If we can't -- if some wakeup events are able to slip
> through our fingers -- I would say it's a bug and the relevant drivers
> need to be fixed.  In the end this probably will require adding a
> function to notify the PM core that a wakeup event occurred and
> therefore a suspend-in-progress should be aborted -- almost exactly
> what pm_wakeup_event() does.

That's correct.

> So I'm not opposed to the new function.  But it doesn't solve the 
> entire problem of avoiding suspends during critical sections.

Surely not and it isn't my goal at this point.

I think there are a few different issues that the suspend blockers (or
wakelocks) framework attempts to address in one bit hammer.  To me, they are
at least (1) deciding when to suspend, (2) detecting events that should make
us avoid suspending (or abort suspend if already started), (3) preventing
"untrusted" processes from making the system use too much energy.

IMO it's better to treat them as different issues and try to address them
separately.

Rafael
