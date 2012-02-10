Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347Ab2BJWgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:36:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46974 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab2BJWgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:36:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PCI / PM: Disable wakeup during shutdown for devices not enabled to wake up
Date: Fri, 10 Feb 2012 23:40:29 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
References: <201202070050.35931.rjw@sisk.pl> <20120210123407.7087d6a4@jbarnes-desktop>
In-Reply-To: <20120210123407.7087d6a4@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201202102340.29644.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 10, 2012, Jesse Barnes wrote:
> On Tue, 7 Feb 2012 00:50:35 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > If a PCI device is enabled to generate wakeup signals (PME) when put
> > into a low-power state by runtime PM, it will be still enabled to
> > generate those signals after the system shutdown, unless its driver's
> > .shutdown() callback takes care of the wakeup signals generation
> > setting.  Moreover, there are devices that are not enabled to wake
> > up the system and that are configured by runtime PM to generate
> > wakeup signals so that (runtime) remote wakeup works with them.
> > Those devices should be reconfigured during system shutdown so that
> > they don't generate wakeup signals, but at least some drivers don't
> > do that.  However, that very well may be done by the PCI core so
> > that drivers don't have to worry about it.  For this reason, modify
> > pci_device_shutdown() to disable the generation of wakeup events for
> > devices not supposed to wake up the system.
> > 
> > References: https://bugzilla.kernel.org/show_bug.cgi?id=37952
> > Reported-and-tested-by: Kamil Iskra <kamil.54002@iskra.name>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/pci/pci-driver.c |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > Index: linux/drivers/pci/pci-driver.c
> > ===================================================================
> > --- linux.orig/drivers/pci/pci-driver.c
> > +++ linux/drivers/pci/pci-driver.c
> > @@ -430,6 +430,16 @@ static void pci_device_shutdown(struct d
> >  		drv->shutdown(pci_dev);
> >  	pci_msi_shutdown(pci_dev);
> >  	pci_msix_shutdown(pci_dev);
> > +
> > +	/*
> > +	 * Devices may be enabled to wake up by runtime PM, but they need not
> > +	 * be supposed to wake up the system from its "power off" state (e.g.
> > +	 * ACPI S5).  Therefore disable wakeup for all devices that aren't
> > +	 * supposed to wake up the system at this point.  The state argument
> > +	 * will be ignored by pci_enable_wake().
> > +	 */
> > +	if (!device_may_wakeup(dev))
> > +		pci_enable_wake(pci_dev, PCI_UNKNOWN, false);
> >  }
> >  
> >  #ifdef CONFIG_PM
> > 
> 
> So where do we end up setting the right wakeup state for devices we
> actually *do* want to wake the system from S5?  Presumably later in the
> shutdown sequence?

Yes, in general.  However, device_may_wakeup(dev) has to return true for those
devices, so they aren't affected by this change.

Thanks,
Rafael
