Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2KFPRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:17:21 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34932 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752375Ab2KFPRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:17:18 -0500
Date: Tue, 6 Nov 2012 10:17:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Huang Ying <ying.huang@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
In-Reply-To: <1352162625.31033.127.camel@yhuang-dev>
Message-ID: <Pine.LNX.4.44L0.1211061010390.1430-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012, Huang Ying wrote:

> On Sun, 2012-11-04 at 20:56 -0500, Alan Stern wrote:
> > On Mon, 5 Nov 2012, Huang Ying wrote:
> > 
> > > In current runtime PM implementation, the active child count of the
> > > parent device may be decreased if the runtime PM of the child device
> > > is disabled and forbidden.  For example, to unbind a PCI driver with a
> > > PCI device, the following code path is possible:
> > > 
> > >   pci_device_remove
> > >     pm_runtime_set_suspended
> > >       __pm_runtime_set_status
> > >         atomic_add_unless(&parent->power.child_count, -1, 0)
> > > 
> > > That is, the parent device may be suspended, even if the runtime PM of
> > > child device is forbidden to be suspended.  This violate the rule that
> > > parent is allowed to be suspended only after all its children are
> > > suspended, and may cause issue.
> > 
> > This doesn't sound like a correct description of the situation.  The 
> > rule is not violated.  After pm_runtime_set_suspended runs, the child 
> > _is_ suspended.  Thus there's no reason not to allow the parent to be 
> > suspended.
> > 
> > The problem -- if there really is one -- is that a driver can put a 
> > device into the suspended state by calling pm_runtime_disable followed 
> > by pm_runtime_set_suspended, even if the usage count is > 0.
> > 
> > I'm not so sure this should count as a problem.  Generally devices 
> > aren't disabled for runtime PM unless something is wrong.
> 
> Devices will be disabled if the PCI driver is unbound from the PCI
> device.

Yes.  But without a PCI driver, nothing will call 
pm_runtime_set_suspended.  And even if something does call 
pm_runtime_set_suspended, it's still not a problem -- the device can't 
be used without a driver.

> So I think the rule could be: even if the device is suspended, the
> device can be put into suspended state only if its usage count == 0.  In
> this way, we can solve the issue for PCI driver unbound and that looks
> more reasonable.

You still have not shown that there really is a problem.  Do you have 
any particular use case in mind?

Alan Stern

