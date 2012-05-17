Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2EQEao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 00:30:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab2EQEam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 00:30:42 -0400
Message-ID: <1337227613.6954.306.camel@bling.home>
Subject: Re: [PATCH 04/13] pci: New pci_dma_quirk()
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, joerg.roedel@amd.com,
        dwmw2@infradead.org, chrisw@sous-sol.org, agraf@suse.de,
        benve@cisco.com, aafabbri@cisco.com, B08248@freescale.com,
        B07421@freescale.com, avi@redhat.com, konrad.wilk@oracle.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com
Date: Wed, 16 May 2012 22:06:53 -0600
In-Reply-To: <20120517033914.GF22069@truffala.fritz.box>
References: <20120511222148.30496.68571.stgit@bling.home>
	 <20120511225555.30496.80525.stgit@bling.home>
	 <20120517033914.GF22069@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 13:39 +1000, David Gibson wrote:
> On Fri, May 11, 2012 at 04:55:55PM -0600, Alex Williamson wrote:
> > Integrating IOMMU groups more closely into the driver core allows
> > us to more easily work around DMA quirks.  The Ricoh multifunction
> > controller is a favorite example of devices that are currently
> > incompatible with IOMMU isolation as all the functions use the
> > requestor ID of function 0 for DMA.  Passing this device into
> > pci_dma_quirk returns the PCI device to use for DMA.  The IOMMU
> > driver can then construct an IOMMU group including both devices.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> >  drivers/pci/quirks.c |   22 ++++++++++++++++++++++
> >  include/linux/pci.h  |    2 ++
> >  2 files changed, 24 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 4bf7102..6f9f7f9 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -3109,3 +3109,25 @@ int pci_dev_specific_reset(struct pci_dev *dev, int probe)
> >  
> >  	return -ENOTTY;
> >  }
> > +
> > +struct pci_dev *pci_dma_quirk(struct pci_dev *dev)
> > +{
> > +	struct pci_dev *dma_dev = dev;
> > +
> > +	/*
> > +	 * https://bugzilla.redhat.com/show_bug.cgi?id=605888
> > +	 *
> > +	 * Some Ricoh devices use the function 0 source ID for DMA on
> > +	 * other functions of a multifunction device.  The DMA devices
> > +	 * is therefore function 0, which will have implications of the
> > +	 * iommu grouping of these devices.
> > +	 */
> > +	if (dev->vendor == PCI_VENDOR_ID_RICOH &&
> > +	    (dev->device == 0xe822 || dev->device == 0xe230 ||
> > +	     dev->device == 0xe832 || dev->device == 0xe476)) {
> > +		dma_dev = pci_get_slot(dev->bus,
> > +				       PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
> > +	}
> 
> Hrm.  This seems like a very generic name for a function performing a
> very specific test.  We could well have devices with the same problem
> in future, so shouldn't this be set up so the same quirk can be easily
> added to new device ids without changing the function code itself.

I've since added a USB quirk here to group all the USB functions in a
slot.  I'll take a closer look at the quirk helpers to see if anything
makes this easier, but I didn't see much point in spending a lot of time
over-optimizing this for 1 or 2 quirks that we can just step through in
a monolithic function.  Thanks,

Alex

