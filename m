Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab2ENWCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:02:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43987 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2ENWCe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:02:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120511225602.30496.80438.stgit@bling.home>
References: <20120511222148.30496.68571.stgit@bling.home> <20120511225602.30496.80438.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 14 May 2012 16:02:11 -0600
Message-ID: <CAErSpo58hKPFb5duOi64sWuR5AJDTVp0rRHkQLotYE3CMXRRhA@mail.gmail.com>
Subject: Re: [PATCH 05/13] pci: New pci_acs_enabled()
To: Alex Williamson <alex.williamson@redhat.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 4:56 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> In a PCIe environment, transactions aren't always required to
> reach the root bus before being re-routed.  Peer-to-peer DMA
> may actually not be seen by the IOMMU in these cases.  For
> IOMMU groups, we want to provide IOMMU drivers a way to detect
> these restrictions.  Provided with a PCI device, pci_acs_enabled
> returns the furthest downstream device with a complete PCI ACS
> chain.  This information can then be used in grouping to create
> fully isolated groups.  ACS chain logic extracted from libvirt.

The name "pci_acs_enabled()" sounds like it returns a boolean, but it doesn't.

I'm not sure what "a complete PCI ACS chain" means.

The function starts from "dev" and searches *upstream*, so I'm
guessing it returns the root of a subtree that must be contained in a
group.

> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>
>  drivers/pci/pci.c   |   43 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h |    1 +
>  2 files changed, 44 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 111569c..d7f05ce 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2358,6 +2358,49 @@ void pci_enable_acs(struct pci_dev *dev)
>        pci_write_config_word(dev, pos + PCI_ACS_CTRL, ctrl);
>  }
>
> +#define PCI_EXT_CAP_ACS_ENABLED                (PCI_ACS_SV | PCI_ACS_RR | \
> +                                        PCI_ACS_CR | PCI_ACS_UF)
> +
> +/**
> + * pci_acs_enabled - test ACS support in downstream chain
> + * @dev: starting PCI device
> + *
> + * Returns the furthest downstream device with an unbroken ACS chain.  If
> + * ACS is enabled throughout the chain, the returned device is the same as
> + * the one passed in.
> + */
> +struct pci_dev *pci_acs_enabled(struct pci_dev *dev)
> +{
> +       struct pci_dev *acs_dev;
> +       int pos;
> +       u16 ctrl;
> +
> +       if (!pci_is_root_bus(dev->bus))
> +               acs_dev = pci_acs_enabled(dev->bus->self);
> +       else
> +               return dev;
> +
> +       /* If the chain is already broken, pass on the device */
> +       if (acs_dev != dev->bus->self)
> +               return acs_dev;
> +
> +       if (!pci_is_pcie(dev) || (dev->class >> 8) != PCI_CLASS_BRIDGE_PCI)
> +               return dev;
> +
> +       if (dev->pcie_type != PCI_EXP_TYPE_DOWNSTREAM)
> +               return dev;
> +
> +       pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS);
> +       if (!pos)
> +               return acs_dev;
> +
> +       pci_read_config_word(dev, pos + PCI_ACS_CTRL, &ctrl);
> +       if ((ctrl & PCI_EXT_CAP_ACS_ENABLED) != PCI_EXT_CAP_ACS_ENABLED)
> +               return acs_dev;
> +
> +       return dev;
> +}
> +
>  /**
>  * pci_swizzle_interrupt_pin - swizzle INTx for device behind bridge
>  * @dev: the PCI device
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 9910b5c..dc25da3 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1586,6 +1586,7 @@ static inline bool pci_is_pcie(struct pci_dev *dev)
>  }
>
>  void pci_request_acs(void);
> +struct pci_dev *pci_acs_enabled(struct pci_dev *dev);
>
>
>  #define PCI_VPD_LRDT                   0x80    /* Large Resource Data Type */
>
