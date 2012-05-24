Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2EXWgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:36:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab2EXWgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:36:10 -0400
Message-ID: <1337898946.4714.71.camel@ul30vt>
Subject: Re: [PATCH v2 05/13] pci: Add ACS validation utility
From: Alex Williamson <alex.williamson@redhat.com>
To: Don Dutile <ddutile@redhat.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com
Date: Thu, 24 May 2012 16:35:46 -0600
In-Reply-To: <4FBEA887.6010908@redhat.com>
References: <20120522043607.5871.11340.stgit@bling.home>
	 <20120522050508.5871.96269.stgit@bling.home> <4FBEA887.6010908@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 17:30 -0400, Don Dutile wrote:
> On 05/22/2012 01:05 AM, Alex Williamson wrote:
> > In a PCI environment, transactions aren't always required to reach
> > the root bus before being re-routed.  Intermediate switches between
> > an endpoint and the root bus can redirect DMA back downstream before
> > things like IOMMUs have a chance to intervene.  Legacy PCI is always
> > susceptible to this as it operates on a shared bus.  PCIe added a
> > new capability to describe and control this behavior, Access Control
> > Services, or ACS.  The utility function pci_acs_enabled() allows us
> > to test the ACS capabilities of an individual devices against a set
> > of flags while pci_acs_path_enabled() tests a complete path from
> > a given downstream device up to the specified upstream device.  We
> > also include the ability to add device specific tests as it's
> > likely we'll see devices that do no implement ACS, but want to
> > indicate support for various capabilities in this space.
> >
> > Signed-off-by: Alex Williamson<alex.williamson@redhat.com>
> > ---
> >
> >   drivers/pci/pci.c    |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >   drivers/pci/quirks.c |   29 +++++++++++++++++++
> >   include/linux/pci.h  |   10 ++++++-
> >   3 files changed, 114 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 111569c..ab6c2a6 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -2359,6 +2359,82 @@ void pci_enable_acs(struct pci_dev *dev)
> >   }
> >
> >   /**
> > + * pci_acs_enable - test ACS against required flags for a given device
> typo:               ^^^ missing 'd'

d'oh.  fixed

> > + * @pdev: device to test
> > + * @acs_flags: required PCI ACS flags
> > + *
> > + * Return true if the device supports the provided flags.  Automatically
> > + * filters out flags that are not implemented on multifunction devices.
> > + */
> > +bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
> > +{
> > +	int pos;
> > +	u16 ctrl;
> > +
> > +	if (pci_dev_specific_acs_enabled(pdev, acs_flags))
> > +		return true;
> > +
> > +	if (!pci_is_pcie(pdev))
> > +		return false;
> > +
> > +	if (pdev->pcie_type == PCI_EXP_TYPE_DOWNSTREAM ||
> > +	    pdev->pcie_type == PCI_EXP_TYPE_ROOT_PORT) {
> > +		pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
> > +		if (!pos)
> > +			return false;
> > +
> > +		pci_read_config_word(pdev, pos + PCI_ACS_CTRL,&ctrl);
> > +		if ((ctrl&  acs_flags) != acs_flags)
> > +			return false;
> > +	} else if (pdev->multifunction) {
> > +		/* Filter out flags not applicable to multifunction */
> > +		acs_flags&= (PCI_ACS_RR | PCI_ACS_CR |
> > +			      PCI_ACS_EC | PCI_ACS_DT);
> > +
> > +		pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
> > +		if (!pos)
> > +			return false;
> > +
> > +		pci_read_config_word(pdev, pos + PCI_ACS_CTRL,&ctrl);
> > +		if ((ctrl&  acs_flags) != acs_flags)
> > +			return false;
> > +	}
> > +
> > +	return true;
> or, to reduce duplicated code (which compiler may do?):
> 
> 	/* Filter out flags not applicable to multifunction */
> 	if (pdev->multifunction)
> 		acs_flags &= (PCI_ACS_RR | PCI_ACS_CR |
> 			      PCI_ACS_EC | PCI_ACS_DT);
> 
> 	if (pdev->pcie_type == PCI_EXP_TYPE_DOWNSTREAM ||
> 	    pdev->pcie_type == PCI_EXP_TYPE_ROOT_PORT ||
>              pdev->multifunction) {
> 		pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
> 		if (!pos)
> 			return false;
> 		pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
> 		if ((ctrl & acs_flags) != acs_flags)
> 			return false;
> 	}
> 
> 	return true;

Good suggestion

> > +}
> 
> But the above doesn't handle the case where the RC does not do
> peer-to-peer btwn root ports. Per ACS spec, such a RC's root ports
> don't need to provide an ACS cap, since peer-to-peer port xfers aren't
> allowed/enabled/supported, so by design, the root port is ACS compliant.
> ATM, an IOMMU-capable system is a pre-req for VFIO,
> and all such systems have an ACS cap, but they may not always be true.

How do we know the behavior of the RC?  This is why I allowed the NULL
bailout below so we don't have to check the RC and can assume the iommu
driver knows something about it.

> > +EXPORT_SYMBOL_GPL(pci_acs_enabled);
> > +
> > +/**
> > + * pci_acs_path_enable - test ACS flags from start to end in a hierarchy
> > + * @start: starting downstream device
> > + * @end: ending upstream device or NULL to search to the root bus
> > + * @acs_flags: required flags
> > + *
> > + * Walk up a device tree from start to end testing PCI ACS support.  If
> > + * any step along the way does not support the required flags, return false.
> > + */
> > +bool pci_acs_path_enabled(struct pci_dev *start,
> > +			  struct pci_dev *end, u16 acs_flags)
> > +{
> > +	struct pci_dev *pdev, *parent = start;
> > +
> > +	do {
> > +		pdev = parent;
> > +
> > +		if (!pci_acs_enabled(pdev, acs_flags))
> > +			return false;
> > +
> > +		if (pci_is_root_bus(pdev->bus))
> > +			return (end == NULL);
> doesn't this mean that a caller can't pass the pdev of the root port?
> I would think that is a valid call, albeit not the common one.

I think there's nothing to step up to after this point, IIRC
pdev->bus->self segfaults from here.  So if we reach the end and you
didn't ask for the end and haven't found your end device, we're done
either way.  Is that not true?

> Also worried that the above code may be true on Intel machines, but not on AMD
> machines (the latter reps its IOMMU as a pdev of root bus, doesn't it?)

I hope it would be the usage in the respective iommu drivers that would
need to account for this.  I've designed this code to not care.  Patch
06/13 does a search to NULL for both AMD and Intel, which seems to work.
AMD does expose the IOMMU as a PCI device, but it's just a peer device
of everything else on the root bus, not a parent, so we can't search
with it as the end device.

> > +
> > +		parent = pdev->bus->self;
> > +	} while (pdev != end);
> > +
> > +	return true;
> > +}
> > +EXPORT_SYMBOL_GPL(pci_acs_path_enabled);
> > +
> > +/**
> >    * pci_swizzle_interrupt_pin - swizzle INTx for device behind bridge
> >    * @dev: the PCI device
> >    * @pin: the INTx pin (1=INTA, 2=INTB, 3=INTD, 4=INTD)
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index a2dd77f..4ed6aa6 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -3149,3 +3149,32 @@ struct pci_dev *pci_dma_source(struct pci_dev *dev)
> >
> >   	return dev;
> >   }
> > +
> > +static const struct pci_dev_acs_enabled {
> > +	u16 vendor;
> > +	u16 device;
> > +	bool (*acs_enabled)(struct pci_dev *dev, u16 acs_flags);
> > +} pci_dev_acs_enabled[] = {
> > +	{ 0 }
> > +};
> > +
> > +bool pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags)
> > +{
> > +	const struct pci_dev_acs_enabled *i;
> > +
> > +	/*
> > +	 * Allow devices that do not expose standard PCI ACS capabilities
> > +	 * or control to indicate their support here.  Multi-function devices
> > +	 * which do not allow internal peer-to-peer between functions, but
> > +	 * do not implement PCI ACS may wish to return true here.
> > +	 */
> > +	for (i = pci_dev_acs_enabled; i->acs_enabled; i++) {
> > +		if ((i->vendor == dev->vendor ||
> > +		     i->vendor == (u16)PCI_ANY_ID)&&
> > +		    (i->device == dev->device ||
> > +		     i->device == (u16)PCI_ANY_ID))
> > +			return i->acs_enabled(dev, acs_flags);
> > +	}
> > +
> > +	return false;
> > +}
> I can't wait until these quirks are filled in! :)

The list could get long...

Thanks,
Alex

