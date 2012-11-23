Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946Ab2KWDJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 22:09:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:9623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758923Ab2KWDJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 22:09:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,304,1352102400"; 
   d="scan'208";a="221267245"
Message-ID: <1353640177.28789.21.camel@yhuang-dev>
Subject: Re: [ 02/38] PCI/PM: Fix deadlock when unbinding device if parent
 in D3cold
From: Huang Ying <ying.huang@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Date: Fri, 23 Nov 2012 11:09:37 +0800
In-Reply-To: <1353638130.4764.4.camel@deadeye.wl.decadent.org.uk>
References: <20121122003904.262382971@linuxfoundation.org>
	 <20121122003904.516735571@linuxfoundation.org>
	 <1353638130.4764.4.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-23 at 02:35 +0000, Ben Hutchings wrote:
> On Wed, 2012-11-21 at 16:39 -0800, Greg Kroah-Hartman wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Huang Ying <ying.huang@intel.com>
> > 
> > commit 90b5c1d7c45eeb622302680ff96ed30c1a2b6f0e upstream.
> > 
> > If a PCI device and its parents are put into D3cold, unbinding the
> > device will trigger deadlock as follow:
> > 
> > - driver_unbind
> >   - device_release_driver
> >     - device_lock(dev)				<--- previous lock here
> >     - __device_release_driver
> >       - pm_runtime_get_sync
> >         ...
> >           - rpm_resume(dev)
> >             - rpm_resume(dev->parent)
> >               ...
> >                 - pci_pm_runtime_resume
> >                   ...
> >                   - pci_set_power_state
> >                     - __pci_start_power_transition
> >                       - pci_wakeup_bus(dev->parent->subordinate)
> >                         - pci_walk_bus
> >                           - device_lock(dev)	<--- deadlock here
> > 
> > 
> > If we do not do device_lock in pci_walk_bus, we can avoid deadlock.
> > Device_lock in pci_walk_bus is introduced in commit:
> > d71374dafbba7ec3f67371d3b7e9f6310a588808, corresponding email thread
> > is: https://lkml.org/lkml/2006/5/26/38.  The patch author Zhang Yanmin
> > said device_lock is added to pci_walk_bus because:
> > 
> >   Some error handling functions call pci_walk_bus. For example, PCIe
> >   aer. Here we lock the device, so the driver wouldn't detach from the
> >   device, as the cb might call driver's callback function.
> > 
> > So I fixed the deadlock as follows:
> > 
> > - remove device_lock from pci_walk_bus
> > - add device_lock into callback if callback will call driver's callback
> > 
> > I checked pci_walk_bus users one by one, and found only PCIe aer needs
> > device lock.
> [...]
> 
> What about eeh_report_error() in
> arch/powerpc/platforms/pseries/eeh_driver.c?

En...  Because pci_walk_bus() invocation is removed in 3.7, so this
patch is only valid for 3.7.  We need another version for 3.6.

> Also, is the deadlock even possible before this change in Linux 3.6?
> 
> commit 448bd857d48e69b33ef323739dc6d8ca20d4cda7
> Author: Huang Ying <ying.huang@intel.com>
> Date:   Sat Jun 23 10:23:51 2012 +0800
> 
>     PCI/PM: add PCIe runtime D3cold support

Before this, there will be no deadlock.  So we do not need fixes before
Linux 3.6.

Best Regards,
Huang Ying


