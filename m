Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab1FTTmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:42:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43026 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1FTTmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:42:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PCI / PM: Block races between runtime PM and system sleep
Date: Mon, 20 Jun 2011 21:42:45 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.1106201039580.2113-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106201039580.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106202142.45802.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 20, 2011, Alan Stern wrote:
> On Sun, 19 Jun 2011, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > After commit e8665002477f0278f84f898145b1f141ba26ee26
> > (PM: Allow pm_runtime_suspend() to succeed during system suspend) it
> > is possible that a device resumed by the pm_runtime_resume(dev) in
> > pci_pm_prepare() will be suspended immediately from a work item,
> > timer function or otherwise, defeating the very purpose of calling
> > pm_runtime_resume(dev) from there.  To prevent that from happening
> > it is necessary to increment the runtime PM usage counter of the
> > device by replacing pm_runtime_resume() with pm_runtime_get_sync().
> > Moreover, the incremented runtime PM usage counter has to be
> > decremented by the corresponding pci_pm_complete(), via
> > pm_runtime_put_noidle().
> 
> In both this and the previous patch, the final decrement should be done 
> by pm_runtime_put_sync() instead of pm_runtime_put_idle().  Otherwise 
> you face the possibility that the usage_count may go to 0 but the 
> device will be left active.

OK, that's how the old code worked, BTW, I overlooked that.

> Furthermore, since we're going to disable runtime PM as soon as the
> suspend callback returns anyway, why not increment usage_count before
> invoking the callback?  This will prevent runtime suspends from 
> occurring while the callback runs, so no changes will be needed in the 
> PCI or USB subsystems.

The PCI case is different from the USB one.  PCI needs to resume devices
before calling their drivers' .suspend() callbacks, so it does that in
.prepare().  If the core acquired a reference to every device  before executing
the subsystem .suspend(), then pm_runtime_resume() could be moved from
pci_pm_prepare() to pci_prepare_suspend(), but then additionally it would
have to be called from pci_pm_freeze() and pci_pm_poweroff().  It simply is
more efficient to call it once from pci_pm_prepare(), but then PCI needs to
take the reference by itself.

Also the core doesn't call the subsystem-level .runtime_idle() after the
subsystem-level .complete() has run, which is useful as you pointed out above. :-)

> It also will prevent Kevin from calling pm_runtime_suspend from within
> his suspend callbacks, but you have already determined that subsystems
> and drivers should never do that in any case.

Then reverting commit e8665002477f0278f84f898145b1f141ba26ee26 would be
even better. :-)

Thanks,
Rafael
