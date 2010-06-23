Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab0FWKK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:10:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41356 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab0FWKKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:10:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [update] Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Wed, 23 Jun 2010 12:09:08 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <Pine.LNX.4.44L0.1006222203070.10376-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006222203070.10376-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006231209.09187.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 23, 2010, Alan Stern wrote:
> On Tue, 22 Jun 2010, Rafael J. Wysocki wrote:
> 
> > > > Please tell me what you think.
> > > 
> > > I like it a lot.  It addresses the main weakness in the earlier 
> > > version.  With this, you could essentially duplicate the in-kernel part 
> > > of the wakelocks/suspend blockers stuff.  All except the timed 
> > > wakelocks -- you might want to consider adding a 
> > > pm_wakeup_begin_timeout() convenience routine.
> > 
> > That may be added in future quite easily if it really turns out to be necessary.
> > IIRC Arve said Android only used timeouts in user space wakelocks, not in the
> > kernel ones.
> 
> Didn't we agree that timeouts would be needed for Wake-on-LAN?

Yes, we did, but in the WoL case the timeout will have to be used by the user
space rather than the kernel IMO.

It would make sense to add a timeout argument to pm_wakeup_event() that would
make the system stay in the working state long enough for the driver wakeup
code to start in the PCIe case.  I think pm_wakeup_event() mght just increment
events_in_progress and the timer might simply decrement it.

So, maybe it's just better to have pm_wakeup_event(dev, timeout) that will
increment events_in_progress and set up a timer and pm_wakeup_commit(dev) that
will delete the timer, decrement events_in_progress and increment event_count
(unless the timer has already expired before).

That would cost us a (one more) timer in struct dev_pm_info, but it would
allow us to cover all of the cases identified so far.  So, if a wakeup event is
handled within one functional unit that both detects it and delivers it to
user space, it would call pm_wakeup_event(dev, 0) (ie. infinite timeout) at the
beginning and then pm_wakeup_commit(dev) when it's done with the event.
If a wakeup event it's just detected by one piece of code and is going to
be handled by another, the first one could call pm_wakeup_event(dev, tm) and
allow the other one to call pm_wakeup_commit(dev) when it's done.  However,
calling pm_wakeup_commit(dev) is not mandatory, so the second piece of code
(eg. a PCI driver) doesn't really need to do anything in the simplest case.

> > > Here's another possible enhancement (if you can figure out a way to do
> > > it without too much effort): After a suspend begins, keep track of the
> > > first wakeup event you get.  Then when the suspend is aborted, print a
> > > log message saying why and indicating which device was responsible for
> > > the wakeup.
> > 
> > Good idea, but I'd prefer to add it in a separate patch not to complicate
> > things too much to start with.
> 
> Okay.  Another thing to be considered later is whether there should be
> a way to write to /sys/power/state that would block until the active
> wakeup count drops to 0.  On the other hand polling maybe once per
> second wouldn't be so bad.  It would happen only when the kernel had
> some events outstanding and userspace didn't.

Blocking on a write to /sys/power/state wouldn't help, because if the active
wakeup count is nonzero at this point, the suspend should be aborted anyway,
so there's no need to wait.  The same applies to writing to
/sys/power/wakeup_count.  However, blocking a read from /sys/power/wakeup_count
instead of failing it when the active wakeup count is nonzero would make sense.

> One thing that stands out is the new spinlock.  It could potentially be
> a big source of contention.  Any wakeup-enabled device is liable to
> need it during every interrupt.  Do you think this could cause a
> noticeable slowdown?

That really depends on the number of wakeup devices.  However, ISTR the
original wakelocks code had exactly the same issue (it used a spinlock to
protect the lists of wakelocks).

Rafael
