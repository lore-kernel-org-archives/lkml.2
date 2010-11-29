Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0K2DFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 22:05:45 -0500
Received: from netrider.rowland.org ([192.131.102.5]:35324 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754505Ab0K2DFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 22:05:44 -0500
Date: Sun, 28 Nov 2010 22:05:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM: Prevent dpm_prepare() from returning errors
 unnecessarily
In-Reply-To: <201011282352.10498.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1011282153560.3447-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Nov 2010, Rafael J. Wysocki wrote:

> On Sunday, November 28, 2010, Alan Stern wrote:
> > On Sun, 28 Nov 2010, Rafael J. Wysocki wrote:
> > 
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Currently dpm_prepare() returns error code if it finds that a device
> > > being suspended has a pending runtime resume request.  However, it
> > > should not do that if the checking for wakeup events is not enabled.
> > 
> > It doesn't.  The line you changed _does_ check device_may_wakeup().
> 
> That's not the point.  The problem is that it shouldn't abort suspend
> when events_check_enabled is unset.

Oh, I see.  This is a tricky issue.  Every driver for a device that can
have wakeup-enabled children needs to worry about the race between
suspending the device and receiving a wakeup request from a child.  
For example, in drivers/usb/core/hcd-pci.c, the suspend_common()
routine goes out of its way to return -EBUSY if device_may_wakeup() is
true and the controller's root hub has a pending wakeup request.

How should drivers handle this in general?  Should we make an effort to
convert them to use the wakeup framework so they they can let the PM
core take care of these races?  Do we have to consider similar races
during runtime suspend?

> > > On the other hand, if the checking for wakeup events is enabled, it
> > > can return error when a wakeup event is detected, regardless of its
> > > source.
> > 
> > Will adding this call to pm_wakeup_event() end up double-counting some 
> > events?
> 
> Yes, it will, if the event has already been reported by the subsystem or driver.
> 
> I don't think it's a very big issue and I'm not sure trying to avoid it is
> worth the effort (we can check if the device's wakeup source object is active
> and skip reporting the wakeup event in that case, but that doesn't guarantee
> that the event won't be counted twice anyway).

I agree that it's not a big issue.  Wakeups reported twice because they 
occur just before a system sleep won't cause serious accounting 
problems and probably won't happen very often anyway.  I just wanted to 
make sure that the issue wasn't being ignored by mistake.

Alan Stern

