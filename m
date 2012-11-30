Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab2K3CBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:01:11 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53023 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2K3CBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:01:08 -0500
Date: Thu, 29 Nov 2012 18:01:04 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [ 02/38] PCI/PM: Fix deadlock when unbinding device if parent in
 D3cold
Message-ID: <20121130020104.GJ13478@kroah.com>
References: <20121122003904.262382971@linuxfoundation.org>
 <20121122003904.516735571@linuxfoundation.org>
 <1353638130.4764.4.camel@deadeye.wl.decadent.org.uk>
 <1353640177.28789.21.camel@yhuang-dev>
 <1353656862.28789.57.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353656862.28789.57.camel@yhuang-dev>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 03:47:42PM +0800, Huang Ying wrote:
> On Fri, 2012-11-23 at 11:09 +0800, Huang Ying wrote:
> > On Fri, 2012-11-23 at 02:35 +0000, Ben Hutchings wrote:
> > > On Wed, 2012-11-21 at 16:39 -0800, Greg Kroah-Hartman wrote:
> > > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Huang Ying <ying.huang@intel.com>
> > > > 
> > > > commit 90b5c1d7c45eeb622302680ff96ed30c1a2b6f0e upstream.
> > > > 
> > > > If a PCI device and its parents are put into D3cold, unbinding the
> > > > device will trigger deadlock as follow:
> > > > 
> > > > - driver_unbind
> > > >   - device_release_driver
> > > >     - device_lock(dev)				<--- previous lock here
> > > >     - __device_release_driver
> > > >       - pm_runtime_get_sync
> > > >         ...
> > > >           - rpm_resume(dev)
> > > >             - rpm_resume(dev->parent)
> > > >               ...
> > > >                 - pci_pm_runtime_resume
> > > >                   ...
> > > >                   - pci_set_power_state
> > > >                     - __pci_start_power_transition
> > > >                       - pci_wakeup_bus(dev->parent->subordinate)
> > > >                         - pci_walk_bus
> > > >                           - device_lock(dev)	<--- deadlock here
> > > > 
> > > > 
> > > > If we do not do device_lock in pci_walk_bus, we can avoid deadlock.
> > > > Device_lock in pci_walk_bus is introduced in commit:
> > > > d71374dafbba7ec3f67371d3b7e9f6310a588808, corresponding email thread
> > > > is: https://lkml.org/lkml/2006/5/26/38.  The patch author Zhang Yanmin
> > > > said device_lock is added to pci_walk_bus because:
> > > > 
> > > >   Some error handling functions call pci_walk_bus. For example, PCIe
> > > >   aer. Here we lock the device, so the driver wouldn't detach from the
> > > >   device, as the cb might call driver's callback function.
> > > > 
> > > > So I fixed the deadlock as follows:
> > > > 
> > > > - remove device_lock from pci_walk_bus
> > > > - add device_lock into callback if callback will call driver's callback
> > > > 
> > > > I checked pci_walk_bus users one by one, and found only PCIe aer needs
> > > > device lock.
> > > [...]
> > > 
> > > What about eeh_report_error() in
> > > arch/powerpc/platforms/pseries/eeh_driver.c?
> > 
> > En...  Because pci_walk_bus() invocation is removed in 3.7, so this
> > patch is only valid for 3.7.  We need another version for 3.6.
> 
> Here is the patch for 3.6.  I have no powerpc machine, so build test
> only.
> 
> Subject: [BUGFIX] PCI/PM: Fix deadlock when unbind device if its parent in D3cold
> 
> If a PCI device and its parents are put into D3cold, unbinding the
> device will trigger deadlock as follow:
> 
> - driver_unbind
>   - device_release_driver
>     - device_lock(dev)				<--- previous lock here
>     - __device_release_driver
>       - pm_runtime_get_sync
>         ...
>           - rpm_resume(dev)
>             - rpm_resume(dev->parent)
>               ...
>                 - pci_pm_runtime_resume
>                   ...
>                   - pci_set_power_state
>                     - __pci_start_power_transition
>                       - pci_wakeup_bus(dev->parent->subordinate)
>                         - pci_walk_bus
>                           - device_lock(dev)	<--- dead lock here
> 
> 
> If we do not do device_lock in pci_walk_bus, we can avoid dead lock.
> Device_lock in pci_walk_bus is introduced in commit:
> d71374dafbba7ec3f67371d3b7e9f6310a588808, corresponding email thread
> is: https://lkml.org/lkml/2006/5/26/38.  The patch author Zhang Yanmin
> said device_lock is added to pci_walk_bus because:
> 
>   Some error handling functions call pci_walk_bus. For example, PCIe
>   aer. Here we lock the device, so the driver wouldn't detach from the
>   device, as the cb might call driver's callback function.
> 
> So I fixed the dead lock as follow:
> 
> - remove device_lock from pci_walk_bus
> - add device_lock into callback if callback will call driver's callback
> 
> I checked pci_walk_bus users one by one, and found only PCIe aer needs
> device lock.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Cc: Zhang Yanmin <yanmin.zhang@intel.com>
> ---
>  arch/powerpc/platforms/pseries/eeh_driver.c |   51 ++++++++++++++++++----------

Due to me applying a power pci patch,
feadf7c0a1a7c08c74bebb4a13b755f8c40e3bbc in Linus's tree to 3.6-stable,
this patch doesn't apply here anymore.

Because that patch is in the tree, is it now just safe to take your
original, unmodified, version of this patch for 3.6-stable?

thanks,

greg k-h
