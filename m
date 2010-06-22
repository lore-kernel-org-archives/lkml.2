Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab0FVKXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 06:23:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37084 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321Ab0FVKXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 06:23:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Tue, 22 Jun 2010 12:21:53 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <Pine.LNX.4.44L0.1006211814370.1687-100000@iolanthe.rowland.org> <201006220040.41524.rjw@sisk.pl>
In-Reply-To: <201006220040.41524.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006221221.53801.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010, Rafael J. Wysocki wrote:
> On Tuesday, June 22, 2010, Alan Stern wrote:
> > On Mon, 21 Jun 2010, Florian Mickler wrote:
> > 
> > > > In the end you would want to have communication in both directions:  
> > > > suspend blockers _and_ callbacks.  Polling is bad if done too often.  
> > > > But I think the idea is a good one.
> > > 
> > > Actually, I'm not so shure. 
> > > 
> > > 1. you have to roundtrip whereas in the suspend_blocker scheme you have
> > > active annotations (i.e. no further action needed) 
> > 
> > That's why it's best to use both.  The normal case is that programs
> > activate and deactivate blockers by sending one-way messages to the PM
> > process.  The exceptional case is when the PM process is about to
> > initiate a suspend; that's when it does the round-trip polling.  Since
> > the only purpose of the polling is to avoid a race, 90% of the time it
> > will succeed.
> > 
> > > 2. it may not be possible for a user to determine if a wake-event is
> > > in-flight. you would have to somehow pass the wake-event-number with
> > > it, so that the userspace process could ack it properly without
> > > confusion. Or... I don't know of anything else... 
> > > 
> > > 	1. userspace-manager (UM) reads a number (42). 
> > > 
> > > 	2. it questions userspace program X: is it ok to suspend?
> > > 
> > > 	[please fill in how userspace program X determines to block
> > > 	suspend]
> > > 
> > > 	3a. UM's roundtrip ends and it proceeds to write "42" to the
> > > 	kernel [suspending]
> > > 	3b. UM's roundtrip ends and it aborts suspend, because a
> > > 	(userspace-)suspend-blocker got activated
> > > 
> > > I'm not shure how the userspace program could determine that there is a
> > > wake-event in flight. Perhaps by storing the number of last wake-event.
> > > But then you need per-wake-event-counters... :|
> > 
> > Rafael seems to think timeouts will fix this.  I'm not so sure.
> > 
> > > Do you have some thoughts about the wake-event-in-flight detection?
> > 
> > Not really, except for something like the original wakelock scheme in
> > which the kernel tells the PM core when an event is over.
> 
> But the kernel doesn't really know that, so it really can't tell the PM core
> anything useful.  What happens with suspend blockers is that a kernel subsystem
> cooperates with a user space consumer of the event to get the story straight.
> 
> However, that will only work if the user space is not buggy and doesn't crash,
> for example, before releasing the suspend blocker it's holding.

Having reconsidered that I think there's more to it.

Take the PCI subsystem as an example, specifically pcie_pme_handle_request().
This is the place where wakeup events are started, but it has no idea about
how they are going to be handled.  Thus in the suspend blocker scheme it would
need to activate a blocker, but it wouldn't be able to release it.  So, it
seems, we would need to associate a suspend blocker with each PCIe device
that can generate wakeup events and require all drivers of such devices to
deal with a blocker activated by someone else (PCIe PME driver in this
particular case).  That sounds cumbersome to say the least.

Moreover, even if we do that, it still doesn't solve the entire problem,
because the event may need to be delivered to user space and processed by it.
While a driver can check if user space has already read the event, it has
no way to detect whether or not it has finished processing it.  In fact,
processing an event may involve an interaction with a (human) user and there's
no general way by which software can figure out when the user considers the
event as processed.

It looks like user space suspend blockers only help in some special cases
when the user space processing of a wakeup event is simple enough, but I don't
think they help in general.  For an extreme example, a user may want to wake up
a system using wake-on-LAN to log into it, do some work and log out, so
effectively the initial wakeup event has not been processed entirely until the
user finally logs out of the system.  Now, after the system wakeup (resulting
from the wake-on-LAN signal) we need to give the user some time to log in, but
if the user doesn't do that in certain time, it may be reasonable to suspend
and let the user wake up the system again. 

Similar situation takes place when the system is woken up by a lid switch.
Evidently, the user has opened the laptop lid to do something, but we don't
even know what the user is going to do, so there's no way we can say when
the wakeup event is finally processed.

So, even if we can say when the kernel has finished processing the event
(although that would be complicated in the PCIe case above), I don't think
it's generally possible to ensure that the entire processing of a wakeup event
has been completed.  This leads to the question whether or not it is worth
trying to detect the ending of the processing of a wakeup event.

Now, going back to the $subject patch, I didn't really think it would be
suitable for opportunistic suspend, so let's focus on the "forced" suspend
instead.  It still has the problem that wakeup events occuring while
/sys/power/state is written to (or even slightly before) should cause the
system to cancel the suspend, but they generally won't.  With the patch
applied that can be avoided by (a) reading from /sys/power/wakeup_count,
(b) waiting for certain time (such that if a suspend event is not entirely
processed within that time, it's worth suspending and waking up the
system again) and (c) writing to /sys/power/wakeup_count right before writing
to /sys/power/state (where the latter is only done if the former succeeds).

Rafael
