Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2KZTaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:30:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:58484 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563Ab2KZTaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:30:17 -0500
Date: Mon, 26 Nov 2012 11:30:14 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [ 02/38] PCI/PM: Fix deadlock when unbinding device if parent in
 D3cold
Message-ID: <20121126193014.GA3413@kroah.com>
References: <20121122003904.262382971@linuxfoundation.org>
 <20121122003904.516735571@linuxfoundation.org>
 <1353638130.4764.4.camel@deadeye.wl.decadent.org.uk>
 <1353640177.28789.21.camel@yhuang-dev>
 <20121126185505.GE21012@kroah.com>
 <20121126190818.GA22409@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126190818.GA22409@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 11:08:18AM -0800, Greg Kroah-Hartman wrote:
> On Mon, Nov 26, 2012 at 10:55:05AM -0800, Greg Kroah-Hartman wrote:
> > On Fri, Nov 23, 2012 at 11:09:37AM +0800, Huang Ying wrote:
> > > On Fri, 2012-11-23 at 02:35 +0000, Ben Hutchings wrote:
> > > > On Wed, 2012-11-21 at 16:39 -0800, Greg Kroah-Hartman wrote:
> > > > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > > > > 
> > > > > ------------------
> > > > > 
> > > > > From: Huang Ying <ying.huang@intel.com>
> > > > > 
> > > > > commit 90b5c1d7c45eeb622302680ff96ed30c1a2b6f0e upstream.
> > > > > 
> > > > > If a PCI device and its parents are put into D3cold, unbinding the
> > > > > device will trigger deadlock as follow:
> > > > > 
> > > > > - driver_unbind
> > > > >   - device_release_driver
> > > > >     - device_lock(dev)				<--- previous lock here
> > > > >     - __device_release_driver
> > > > >       - pm_runtime_get_sync
> > > > >         ...
> > > > >           - rpm_resume(dev)
> > > > >             - rpm_resume(dev->parent)
> > > > >               ...
> > > > >                 - pci_pm_runtime_resume
> > > > >                   ...
> > > > >                   - pci_set_power_state
> > > > >                     - __pci_start_power_transition
> > > > >                       - pci_wakeup_bus(dev->parent->subordinate)
> > > > >                         - pci_walk_bus
> > > > >                           - device_lock(dev)	<--- deadlock here
> > > > > 
> > > > > 
> > > > > If we do not do device_lock in pci_walk_bus, we can avoid deadlock.
> > > > > Device_lock in pci_walk_bus is introduced in commit:
> > > > > d71374dafbba7ec3f67371d3b7e9f6310a588808, corresponding email thread
> > > > > is: https://lkml.org/lkml/2006/5/26/38.  The patch author Zhang Yanmin
> > > > > said device_lock is added to pci_walk_bus because:
> > > > > 
> > > > >   Some error handling functions call pci_walk_bus. For example, PCIe
> > > > >   aer. Here we lock the device, so the driver wouldn't detach from the
> > > > >   device, as the cb might call driver's callback function.
> > > > > 
> > > > > So I fixed the deadlock as follows:
> > > > > 
> > > > > - remove device_lock from pci_walk_bus
> > > > > - add device_lock into callback if callback will call driver's callback
> > > > > 
> > > > > I checked pci_walk_bus users one by one, and found only PCIe aer needs
> > > > > device lock.
> > > > [...]
> > > > 
> > > > What about eeh_report_error() in
> > > > arch/powerpc/platforms/pseries/eeh_driver.c?
> > > 
> > > En...  Because pci_walk_bus() invocation is removed in 3.7, so this
> > > patch is only valid for 3.7.  We need another version for 3.6.
> > > 
> > > > Also, is the deadlock even possible before this change in Linux 3.6?
> > > > 
> > > > commit 448bd857d48e69b33ef323739dc6d8ca20d4cda7
> > > > Author: Huang Ying <ying.huang@intel.com>
> > > > Date:   Sat Jun 23 10:23:51 2012 +0800
> > > > 
> > > >     PCI/PM: add PCIe runtime D3cold support
> > > 
> > > Before this, there will be no deadlock.  So we do not need fixes before
> > > Linux 3.6.
> > 
> > So the first patch mentioned here should not be included in the 3.0 and
> > 3.4 stable kernel releases?
> 
> Ok, I've dropped the patch from 3.0 and 3.4-stable trees now.
> 
> For 3.6, what should I do?

Ok, for now, I've dropped this patch from 3.6-stable as well.  If you
think it still needs to go there, can you provide something that works?
I see you posted one patch in this thread, but I don't understand if
that is what needs to go upstream in Linus's tree, or if it is for the
3.6-stable tree.  Please clarify.

thanks,

greg k-h
