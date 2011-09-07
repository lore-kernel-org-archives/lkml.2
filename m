Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1IGTpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:45:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab1IGTpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:45:52 -0400
Date: Wed, 7 Sep 2011 12:44:45 -0700
From: Greg KH <gregkh@suse.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110907194445.GA2526@suse.de>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
 <1315410113-26608-3-git-send-email-joerg.roedel@amd.com>
 <20110907184750.GA920@suse.de>
 <20110907191919.GA31674@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907191919.GA31674@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 09:19:19PM +0200, Joerg Roedel wrote:
> Hi Greg,
> 
> the bus_set_iommu() function will be called by the IOMMU driver. There
> can be different drivers for the same bus, depending on the hardware. On
> PCI for example, there can be the Intel or the AMD IOMMU driver that
> implement the iommu-api and that register for that bus.

Why are you pushing this down into the driver core?  What other busses
becides PCI use/need this?

If you can have a different IOMMU driver on the same bus, then wouldn't
this be a per-device thing instead of a per-bus thing?


> On Wed, Sep 07, 2011 at 11:47:50AM -0700, Greg KH wrote:
> > > +#ifdef CONFIG_IOMMU_API
> > > +int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops)
> > > +{
> > > +	if (bus->iommu_ops != NULL)
> > > +		return -EBUSY;
> > 
> > Busy?
> 
> Yes, it signals to the IOMMU driver that another driver has already
> registered for that bus. In the previous register_iommu() interface this
> was just a BUG(), but I think returning an error to the caller is
> better. It can be turned back into a BUG() if it is considered better,
> though.

Can you ever have more than one IOMMU driver per bus?  If so, this seems
wrong (see above.)

> > > +
> > > +	bus->iommu_ops = ops;
> > > +
> > > +	/* Do IOMMU specific setup for this bus-type */
> > > +	iommu_bus_init(bus, ops);
> > > +
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(bus_set_iommu);
> > 
> > I don't understand what this function is for, and who would call it.
> 
> It is called by the IOMMU driver.
> 
> > Please provide kerneldoc that explains this.
> 
> Will do.
> 
> > > @@ -67,6 +68,9 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
> > >   * @resume:	Called to bring a device on this bus out of sleep mode.
> > >   * @pm:		Power management operations of this bus, callback the specific
> > >   *		device driver's pm-ops.
> > > + * @iommu_ops   IOMMU specific operations for this bus, used to attach IOMMU
> > > + *              driver implementations to a bus and allow the driver to do
> > > + *              bus-specific setup
> > 
> > So why is this just not set by the bus itself, making the above function
> > not needed at all?
> 
> The IOMMUs are usually devices on the bus itself, so they are
> initialized after the bus is set up and the devices on it are
> populated.  So the function can not be called on bus initialization
> because the IOMMU is not ready at this point.

Ok, that makes more sense, please state as much in the documentation.

thanks,

greg k-h
