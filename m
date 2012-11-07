Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2KGA0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 19:26:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:50730 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab2KGA0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 19:26:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,725,1344236400"; 
   d="scan'208";a="245056444"
Message-ID: <1352248006.31033.192.camel@yhuang-dev>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and
 forbidden
From: Huang Ying <ying.huang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Wed, 07 Nov 2012 08:26:46 +0800
In-Reply-To: <Pine.LNX.4.44L0.1211061010390.1430-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1211061010390.1430-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-06 at 10:17 -0500, Alan Stern wrote:
> On Tue, 6 Nov 2012, Huang Ying wrote:
> 
> > On Sun, 2012-11-04 at 20:56 -0500, Alan Stern wrote:
> > > On Mon, 5 Nov 2012, Huang Ying wrote:
> > > 
> > > > In current runtime PM implementation, the active child count of the
> > > > parent device may be decreased if the runtime PM of the child device
> > > > is disabled and forbidden.  For example, to unbind a PCI driver with a
> > > > PCI device, the following code path is possible:
> > > > 
> > > >   pci_device_remove
> > > >     pm_runtime_set_suspended
> > > >       __pm_runtime_set_status
> > > >         atomic_add_unless(&parent->power.child_count, -1, 0)
> > > > 
> > > > That is, the parent device may be suspended, even if the runtime PM of
> > > > child device is forbidden to be suspended.  This violate the rule that
> > > > parent is allowed to be suspended only after all its children are
> > > > suspended, and may cause issue.
> > > 
> > > This doesn't sound like a correct description of the situation.  The 
> > > rule is not violated.  After pm_runtime_set_suspended runs, the child 
> > > _is_ suspended.  Thus there's no reason not to allow the parent to be 
> > > suspended.
> > > 
> > > The problem -- if there really is one -- is that a driver can put a 
> > > device into the suspended state by calling pm_runtime_disable followed 
> > > by pm_runtime_set_suspended, even if the usage count is > 0.
> > > 
> > > I'm not so sure this should count as a problem.  Generally devices 
> > > aren't disabled for runtime PM unless something is wrong.
> > 
> > Devices will be disabled if the PCI driver is unbound from the PCI
> > device.
> 
> Yes.  But without a PCI driver, nothing will call 
> pm_runtime_set_suspended.

pm_runtime_set_suspended will be called in pci_device_remove or error
path of local_pci_probe.

>   And even if something does call 
> pm_runtime_set_suspended, it's still not a problem -- the device can't 
> be used without a driver.

The VGA device can be used without a driver.

Best Regards,
Huang Ying


> > So I think the rule could be: even if the device is suspended, the
> > device can be put into suspended state only if its usage count == 0.  In
> > this way, we can solve the issue for PCI driver unbound and that looks
> > more reasonable.
> 
> You still have not shown that there really is a problem.  Do you have 
> any particular use case in mind?
> 
> Alan Stern
> 


