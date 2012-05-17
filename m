Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966290Ab2EQDvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 23:51:21 -0400
Received: from ozlabs.org ([203.10.76.45]:51253 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966147Ab2EQDuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 23:50:55 -0400
Date: Thu, 17 May 2012 13:39:14 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, joerg.roedel@amd.com,
        dwmw2@infradead.org, chrisw@sous-sol.org, agraf@suse.de,
        benve@cisco.com, aafabbri@cisco.com, B08248@freescale.com,
        B07421@freescale.com, avi@redhat.com, konrad.wilk@oracle.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com
Subject: Re: [PATCH 04/13] pci: New pci_dma_quirk()
Message-ID: <20120517033914.GF22069@truffala.fritz.box>
Mail-Followup-To: Alex Williamson <alex.williamson@redhat.com>,
	benh@kernel.crashing.org, aik@ozlabs.ru, joerg.roedel@amd.com,
	dwmw2@infradead.org, chrisw@sous-sol.org, agraf@suse.de,
	benve@cisco.com, aafabbri@cisco.com, B08248@freescale.com,
	B07421@freescale.com, avi@redhat.com, konrad.wilk@oracle.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org,
	iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
	bhelgaas@google.com
References: <20120511222148.30496.68571.stgit@bling.home>
 <20120511225555.30496.80525.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511225555.30496.80525.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 04:55:55PM -0600, Alex Williamson wrote:
> Integrating IOMMU groups more closely into the driver core allows
> us to more easily work around DMA quirks.  The Ricoh multifunction
> controller is a favorite example of devices that are currently
> incompatible with IOMMU isolation as all the functions use the
> requestor ID of function 0 for DMA.  Passing this device into
> pci_dma_quirk returns the PCI device to use for DMA.  The IOMMU
> driver can then construct an IOMMU group including both devices.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  drivers/pci/quirks.c |   22 ++++++++++++++++++++++
>  include/linux/pci.h  |    2 ++
>  2 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 4bf7102..6f9f7f9 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3109,3 +3109,25 @@ int pci_dev_specific_reset(struct pci_dev *dev, int probe)
>  
>  	return -ENOTTY;
>  }
> +
> +struct pci_dev *pci_dma_quirk(struct pci_dev *dev)
> +{
> +	struct pci_dev *dma_dev = dev;
> +
> +	/*
> +	 * https://bugzilla.redhat.com/show_bug.cgi?id=605888
> +	 *
> +	 * Some Ricoh devices use the function 0 source ID for DMA on
> +	 * other functions of a multifunction device.  The DMA devices
> +	 * is therefore function 0, which will have implications of the
> +	 * iommu grouping of these devices.
> +	 */
> +	if (dev->vendor == PCI_VENDOR_ID_RICOH &&
> +	    (dev->device == 0xe822 || dev->device == 0xe230 ||
> +	     dev->device == 0xe832 || dev->device == 0xe476)) {
> +		dma_dev = pci_get_slot(dev->bus,
> +				       PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
> +	}

Hrm.  This seems like a very generic name for a function performing a
very specific test.  We could well have devices with the same problem
in future, so shouldn't this be set up so the same quirk can be easily
added to new device ids without changing the function code itself.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
