Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0FXPIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:08:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46098 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab0FXPI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:08:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [update 2] Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Thu, 24 Jun 2010 17:06:44 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <Pine.LNX.4.44L0.1006231038510.1617-100000@iolanthe.rowland.org> <201006240017.58665.rjw@sisk.pl> <201006241513.06116.rjw@sisk.pl>
In-Reply-To: <201006241513.06116.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006241706.45094.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 24, 2010, Rafael J. Wysocki wrote:
> On Thursday, June 24, 2010, Rafael J. Wysocki wrote:
> > On Wednesday, June 23, 2010, Alan Stern wrote:
> > > On Wed, 23 Jun 2010, Rafael J. Wysocki wrote:
> > > 
> > > > > Didn't we agree that timeouts would be needed for Wake-on-LAN?
> > > > 
> > > > Yes, we did, but in the WoL case the timeout will have to be used by the user
> > > > space rather than the kernel IMO.
> > > 
> > > The kernel will still have to specify some small initial timeout.  Just 
> > > long enough for userspace to realize what has happened and start its 
> > > own critical section.
> > > 
> > > > It would make sense to add a timeout argument to pm_wakeup_event() that would
> > > > make the system stay in the working state long enough for the driver wakeup
> > > > code to start in the PCIe case.  I think pm_wakeup_event() mght just increment
> > > > events_in_progress and the timer might simply decrement it.
> > > 
> > > Hmm.  I was thinking about a similar problem with the USB hub driver.
> > > 
> > > Maybe a better answer for this particular issue is to change the
> > > workqueue code.  Don't allow a work thread to enter the freezer until
> > > its queue is empty.  Then you wouldn't need a timeout.
> > > 
> > > > So, maybe it's just better to have pm_wakeup_event(dev, timeout) that will
> > > > increment events_in_progress and set up a timer and pm_wakeup_commit(dev) that
> > > > will delete the timer, decrement events_in_progress and increment event_count
> > > > (unless the timer has already expired before).
> > > > 
> > > > That would cost us a (one more) timer in struct dev_pm_info, but it would
> > > > allow us to cover all of the cases identified so far.  So, if a wakeup event is
> > > > handled within one functional unit that both detects it and delivers it to
> > > > user space, it would call pm_wakeup_event(dev, 0) (ie. infinite timeout) at the
> > > > beginning and then pm_wakeup_commit(dev) when it's done with the event.
> > > > If a wakeup event it's just detected by one piece of code and is going to
> > > > be handled by another, the first one could call pm_wakeup_event(dev, tm) and
> > > > allow the other one to call pm_wakeup_commit(dev) when it's done.  However,
> > > > calling pm_wakeup_commit(dev) is not mandatory, so the second piece of code
> > > > (eg. a PCI driver) doesn't really need to do anything in the simplest case.
> > > 
> > > You have to handle the case where pm_wakeup_commit() gets called after
> > > the timer expires (it should do nothing).
> > 
> > Yup.
> > 
> > > And what happens if the device gets a second wakeup event before the timer
> > > for the first one expires?
> > 
> > Good question.  I don't have an answer to it at the moment, but it seems to
> > arise from using a single timer for all events.
> > 
> > It looks like it's simpler to make pm_wakeup_event() allocate a timer for each
> > event and make the timer function remove it.  That would cause suspend to
> > be blocked until the timer expires without a way to cancel it earlier, though.
> 
> So, I decided to try this after all.
> 
> Below is a new version of the patch.  It introduces pm_stay_awake(dev) and
> pm_relax() that play the roles of the "old" pm_wakeup_begin() and
> pm_wakeup_end().
> 
> pm_wakeup_event() now takes an extra timeout argument and uses it for
> deferred execution of pm_relax().  So, one can either use the
> pm_stay_awake(dev) / pm_relax() pair, or use pm_wakeup_event(dev, timeout)
> if the ending is under someone else's control.
> 
> In addition to that, pm_get_wakeup_count() blocks until events_in_progress is
> zero.
> 
> Please tell me what you think.

Ah, one piece is missing.  Namely, the waiting /sys/power/wakeup_count reader
needs to be woken up when events_in_progress goes down to zero.

I'll send a new version with this bug fixed later today.

Rafael
