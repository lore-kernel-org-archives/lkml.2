Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0FWPVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:21:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37155 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753387Ab0FWPVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:21:33 -0400
Date: Wed, 23 Jun 2010 11:21:32 -0400 (EDT)
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
Subject: Re: [update] Re: [RFC][PATCH] PM: Avoid losing wakeup events during
 suspend
In-Reply-To: <201006231209.09187.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006231038510.1617-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010, Rafael J. Wysocki wrote:

> > Didn't we agree that timeouts would be needed for Wake-on-LAN?
> 
> Yes, we did, but in the WoL case the timeout will have to be used by the user
> space rather than the kernel IMO.

The kernel will still have to specify some small initial timeout.  Just 
long enough for userspace to realize what has happened and start its 
own critical section.

> It would make sense to add a timeout argument to pm_wakeup_event() that would
> make the system stay in the working state long enough for the driver wakeup
> code to start in the PCIe case.  I think pm_wakeup_event() mght just increment
> events_in_progress and the timer might simply decrement it.

Hmm.  I was thinking about a similar problem with the USB hub driver.

Maybe a better answer for this particular issue is to change the
workqueue code.  Don't allow a work thread to enter the freezer until
its queue is empty.  Then you wouldn't need a timeout.

> So, maybe it's just better to have pm_wakeup_event(dev, timeout) that will
> increment events_in_progress and set up a timer and pm_wakeup_commit(dev) that
> will delete the timer, decrement events_in_progress and increment event_count
> (unless the timer has already expired before).
> 
> That would cost us a (one more) timer in struct dev_pm_info, but it would
> allow us to cover all of the cases identified so far.  So, if a wakeup event is
> handled within one functional unit that both detects it and delivers it to
> user space, it would call pm_wakeup_event(dev, 0) (ie. infinite timeout) at the
> beginning and then pm_wakeup_commit(dev) when it's done with the event.
> If a wakeup event it's just detected by one piece of code and is going to
> be handled by another, the first one could call pm_wakeup_event(dev, tm) and
> allow the other one to call pm_wakeup_commit(dev) when it's done.  However,
> calling pm_wakeup_commit(dev) is not mandatory, so the second piece of code
> (eg. a PCI driver) doesn't really need to do anything in the simplest case.

You have to handle the case where pm_wakeup_commit() gets called after
the timer expires (it should do nothing).  And what happens if the
device gets a second wakeup event before the timer for the first one
expires?  dev_pm_info would need to store a count of pending events.

In fact, this gets even worse.  What if the second event causes you to
move the timeout forward, but then you get a commit for the second
event before the original timer would have expired?  It's not clear 
that timeouts and early commit work well together.

You could consider changing some of the new function names.  Instead of 
"wakeup" (which implies that the system was asleep previously) use 
"awake" (which implies that you want to prevent the system from going 
to sleep, as in "stay awake").

> > One thing that stands out is the new spinlock.  It could potentially be
> > a big source of contention.  Any wakeup-enabled device is liable to
> > need it during every interrupt.  Do you think this could cause a
> > noticeable slowdown?
> 
> That really depends on the number of wakeup devices.  However, ISTR the
> original wakelocks code had exactly the same issue (it used a spinlock to
> protect the lists of wakelocks).

Yeah, that's right.  I have already forgotten the details of how that
original design worked.

Alan Stern


