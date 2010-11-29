Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0K2WFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:05:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39164 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab0K2WFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:05:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Prevent dpm_prepare() from returning errors unnecessarily
Date: Mon, 29 Nov 2010 23:04:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1011282153560.3447-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011282153560.3447-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011292304.11856.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 29, 2010, Alan Stern wrote:
> On Sun, 28 Nov 2010, Rafael J. Wysocki wrote:
> 
> > On Sunday, November 28, 2010, Alan Stern wrote:
> > > On Sun, 28 Nov 2010, Rafael J. Wysocki wrote:
> > > 
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > Currently dpm_prepare() returns error code if it finds that a device
> > > > being suspended has a pending runtime resume request.  However, it
> > > > should not do that if the checking for wakeup events is not enabled.
> > > 
> > > It doesn't.  The line you changed _does_ check device_may_wakeup().
> > 
> > That's not the point.  The problem is that it shouldn't abort suspend
> > when events_check_enabled is unset.
> 
> Oh, I see.  This is a tricky issue.  Every driver for a device that can
> have wakeup-enabled children needs to worry about the race between
> suspending the device and receiving a wakeup request from a child.  
> For example, in drivers/usb/core/hcd-pci.c, the suspend_common()
> routine goes out of its way to return -EBUSY if device_may_wakeup() is
> true and the controller's root hub has a pending wakeup request.
> 
> How should drivers handle this in general?  Should we make an effort to
> convert them to use the wakeup framework so they they can let the PM
> core take care of these races?

I think so.

We also need to put a pm_check_wakeup_events() check into dpm_suspend() IMO,
so that we abort the suspending of devices as soon as a wakeup event is
reported.

> Do we have to consider similar races during runtime suspend?

Ideally, yes, but I'm not sure if that's generally possible.  IMO, it won't be
a big deal if a parent device is suspended and immediately resumed occasionally
due to a pending wakeup signal from one of its children.  It may be a problem
if that happens too often, though.

> > > > On the other hand, if the checking for wakeup events is enabled, it
> > > > can return error when a wakeup event is detected, regardless of its
> > > > source.
> > > 
> > > Will adding this call to pm_wakeup_event() end up double-counting some 
> > > events?
> > 
> > Yes, it will, if the event has already been reported by the subsystem or driver.
> > 
> > I don't think it's a very big issue and I'm not sure trying to avoid it is
> > worth the effort (we can check if the device's wakeup source object is active
> > and skip reporting the wakeup event in that case, but that doesn't guarantee
> > that the event won't be counted twice anyway).
> 
> I agree that it's not a big issue.  Wakeups reported twice because they 
> occur just before a system sleep won't cause serious accounting 
> problems and probably won't happen very often anyway.  I just wanted to 
> make sure that the issue wasn't being ignored by mistake.

OK

Does it mean you're fine with the patch?

Rafael
