Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab1IHImB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:42:01 -0400
Received: from 8bytes.org ([88.198.83.132]:36386 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365Ab1IHIl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:41:56 -0400
Date: Thu, 8 Sep 2011 10:41:54 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Greg KH <gregkh@suse.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110908084154.GC31674@8bytes.org>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com> <1315410113-26608-3-git-send-email-joerg.roedel@amd.com> <20110907184750.GA920@suse.de> <20110907191919.GA31674@8bytes.org> <20110907194445.GA2526@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907194445.GA2526@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 12:44:45PM -0700, Greg KH wrote:
> On Wed, Sep 07, 2011 at 09:19:19PM +0200, Joerg Roedel wrote:
> > Hi Greg,
> > 
> > the bus_set_iommu() function will be called by the IOMMU driver. There
> > can be different drivers for the same bus, depending on the hardware. On
> > PCI for example, there can be the Intel or the AMD IOMMU driver that
> > implement the iommu-api and that register for that bus.
> 
> Why are you pushing this down into the driver core?  What other busses
> becides PCI use/need this?

Currently it is the platform_bus besides pci. The pci iommus are on x86
and ia64 while all arm iommus use the platform_bus (by 'iommus' I only
mean those implementing the iommu-api). Currently there are two drivers
for arm iommus in /drivers/iommu.

> If you can have a different IOMMU driver on the same bus, then wouldn't
> this be a per-device thing instead of a per-bus thing?

Well, I havn't seen a system yet where multiple iommus are on the same
bus. Or to state it better, multiple iommus of different type that
require different drivers. There is no 1-1 mapping between real hardware
iommus and iommu_ops. There is only such a mapping for iommu drivers and
iommu_ops. An iommu driver usually handles all hardware iommus of the
same type in the system.

So having iommu_ops per-device doesn't make much sense at this point.
With this patch-set they are accessible by dev->bus->iommu_ops anyway.
But if I am wrong on this I can change this of course.

This patch-set improves the current situation where only on active
iommu-driver is allowed to be active on a system (because of the global
iommu_ops). But the main reason to put this into the bus_type structure
is that it allows to generalize the device-handling on a bus between
iommu drivers.


> 
> 
> > On Wed, Sep 07, 2011 at 11:47:50AM -0700, Greg KH wrote:
> > > > +#ifdef CONFIG_IOMMU_API
> > > > +int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops)
> > > > +{
> > > > +	if (bus->iommu_ops != NULL)
> > > > +		return -EBUSY;
> > > 
> > > Busy?
> > 
> > Yes, it signals to the IOMMU driver that another driver has already
> > registered for that bus. In the previous register_iommu() interface this
> > was just a BUG(), but I think returning an error to the caller is
> > better. It can be turned back into a BUG() if it is considered better,
> > though.
> 
> Can you ever have more than one IOMMU driver per bus?  If so, this seems
> wrong (see above.)

As I said, I havn't seen such systems. But if they exist or are planned
I am happy to redesign the whole thing.

> > The IOMMUs are usually devices on the bus itself, so they are
> > initialized after the bus is set up and the devices on it are
> > populated.  So the function can not be called on bus initialization
> > because the IOMMU is not ready at this point.
> 
> Ok, that makes more sense, please state as much in the documentation.

Will do, thanks.


	Joerg

