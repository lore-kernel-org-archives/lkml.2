Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab1FTTxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:53:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43062 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab1FTTxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:53:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] calling runtime PM from system PM methods
Date: Mon, 20 Jun 2011 21:53:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
References: <Pine.LNX.4.44L0.1106201028470.2113-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106201028470.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106202153.59329.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 20, 2011, Alan Stern wrote:
> On Sun, 19 Jun 2011, Rafael J. Wysocki wrote:
> 
> > In the meantime I rethought the __pm_runtime_disable() part of my previous
> > patch and I now think it's not necessary to complicate it any more.  Of course,
> > we need not check if runtime resume is pending in __device_suspend(), because
> > we've done it already in dpm_prepare(), but the barrier part should better be
> > done in there too.
> 
> Does this really make sense?  What use is a barrier in dpm_prepare() if 
> runtime PM is allowed to continue functioning up to the 
> suspend callback?

It checks if a resume request is pending and executes runtime resume in that
case.

> As I see it, we never want a suspend or suspend_noirq callback to call 
> pm_runtime_suspend().  However it's okay for the suspend callback to 
> invoke pm_runtime_resume(), as long as this is all done in subsystem 
> code.

First off, I don't really see a reason for a subsystem to call
pm_runtime_resume() from its .suspend_noirq() callback.  Now, if
pm_runtime_resume() is to be called concurrently with the subsystem's
.suspend_noirq() callback, I'd rather won't let that happen. :-)

> And in between the prepare and suspend callbacks, runtime PM should be
> more or less fully functional, right?  For most devices it will never
> be triggered, because it has to run in process context and both
> userspace and pm_wq are frozen.  It may trigger for devices marked as
> IRQ-safe, though.

It also may trigger for drivers using non-freezable workqueues and calling
runtime PM synchronously from there.

> Maybe the barrier should be moved into __device_suspend().

I _really_ think that the initial approach, i.e. before commit
e8665002477f0278f84f898145b1f141ba26ee26, made the most sense.  It didn't
cover the "pm_runtime_resume() called during system suspend" case, but
it did cover everything else.

So, I think there are serious technical arguments for reverting that commit.

I think we went really far trying to avoid that, but I'm not sure I want to go
any further.

Thanks,
Rafael
