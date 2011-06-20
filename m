Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab1FTOqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:46:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59595 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755151Ab1FTOqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:46:14 -0400
Date: Mon, 20 Jun 2011 10:46:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI / PM: Block races between runtime PM and system
 sleep
In-Reply-To: <201106192149.19401.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1106201039580.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> After commit e8665002477f0278f84f898145b1f141ba26ee26
> (PM: Allow pm_runtime_suspend() to succeed during system suspend) it
> is possible that a device resumed by the pm_runtime_resume(dev) in
> pci_pm_prepare() will be suspended immediately from a work item,
> timer function or otherwise, defeating the very purpose of calling
> pm_runtime_resume(dev) from there.  To prevent that from happening
> it is necessary to increment the runtime PM usage counter of the
> device by replacing pm_runtime_resume() with pm_runtime_get_sync().
> Moreover, the incremented runtime PM usage counter has to be
> decremented by the corresponding pci_pm_complete(), via
> pm_runtime_put_noidle().

In both this and the previous patch, the final decrement should be done 
by pm_runtime_put_sync() instead of pm_runtime_put_idle().  Otherwise 
you face the possibility that the usage_count may go to 0 but the 
device will be left active.

Furthermore, since we're going to disable runtime PM as soon as the
suspend callback returns anyway, why not increment usage_count before
invoking the callback?  This will prevent runtime suspends from 
occurring while the callback runs, so no changes will be needed in the 
PCI or USB subsystems.

It also will prevent Kevin from calling pm_runtime_suspend from within
his suspend callbacks, but you have already determined that subsystems
and drivers should never do that in any case.

Alan Stern

