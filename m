Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab1IGTTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:19:24 -0400
Received: from 8bytes.org ([88.198.83.132]:54876 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab1IGTTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:19:21 -0400
Date: Wed, 7 Sep 2011 21:19:19 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Greg KH <gregkh@suse.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110907191919.GA31674@8bytes.org>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com> <1315410113-26608-3-git-send-email-joerg.roedel@amd.com> <20110907184750.GA920@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907184750.GA920@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

the bus_set_iommu() function will be called by the IOMMU driver. There
can be different drivers for the same bus, depending on the hardware. On
PCI for example, there can be the Intel or the AMD IOMMU driver that
implement the iommu-api and that register for that bus.

On Wed, Sep 07, 2011 at 11:47:50AM -0700, Greg KH wrote:
> > +#ifdef CONFIG_IOMMU_API
> > +int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops)
> > +{
> > +	if (bus->iommu_ops != NULL)
> > +		return -EBUSY;
> 
> Busy?

Yes, it signals to the IOMMU driver that another driver has already
registered for that bus. In the previous register_iommu() interface this
was just a BUG(), but I think returning an error to the caller is
better. It can be turned back into a BUG() if it is considered better,
though.

> > +
> > +	bus->iommu_ops = ops;
> > +
> > +	/* Do IOMMU specific setup for this bus-type */
> > +	iommu_bus_init(bus, ops);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(bus_set_iommu);
> 
> I don't understand what this function is for, and who would call it.

It is called by the IOMMU driver.

> Please provide kerneldoc that explains this.

Will do.

> > @@ -67,6 +68,9 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
> >   * @resume:	Called to bring a device on this bus out of sleep mode.
> >   * @pm:		Power management operations of this bus, callback the specific
> >   *		device driver's pm-ops.
> > + * @iommu_ops   IOMMU specific operations for this bus, used to attach IOMMU
> > + *              driver implementations to a bus and allow the driver to do
> > + *              bus-specific setup
> 
> So why is this just not set by the bus itself, making the above function
> not needed at all?

The IOMMUs are usually devices on the bus itself, so they are
initialized after the bus is set up and the devices on it are
populated.  So the function can not be called on bus initialization
because the IOMMU is not ready at this point.

Regards,

	Joerg

