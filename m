Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab2E3Phi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:37:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329Ab2E3Phg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:37:36 -0400
Message-ID: <1338392205.23475.4.camel@bling.home>
Subject: Re: [PATCH 1/5] pci: Add PCI DMA source ID quirk
From: Alex Williamson <alex.williamson@redhat.com>
To: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, benh@kernel.crashing.org,
        aik@ozlabs.ru, david@gibson.dropbear.id.au, joerg.roedel@amd.com,
        dwmw2@infradead.org, konrad.wilk@oracle.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        ddutile@redhat.com
Date: Wed, 30 May 2012 09:36:45 -0600
In-Reply-To: <20120530083457.GB7364@shangw>
References: <20120530043142.1164.63415.stgit@bling.home>
	 <20120530044834.1164.9081.stgit@bling.home> <20120530083457.GB7364@shangw>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 16:34 +0800, Gavin Shan wrote:
> Hi Alex,
> 
> >DMA transactions are tagged with the source ID of the device making
> >the request.  Occasionally hardware screws this up and uses the
> >source ID of a different device (often the wrong function number of
> >a multifunction device).  A specific Ricoh multifunction device is
> >a prime example of this problem and included in this patch.  The
> >purpose of this function is that given a pci_dev, return the pci_dev
> >to use as the source ID for DMA.  When hardware works correctly,
> >this returns the input device.  For the components of the Ricoh
> >multifunction device, return the pci_dev for function 0.
> >
> >This will be used by IOMMU drivers for determining the boundaries
> >of IOMMU groups as multiple devices using the same source ID must
> >be contained within the same group.  This can also be used by
> >existing streaming DMA paths for the same purpose.
> >
> >Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >---
> >
> > drivers/pci/quirks.c |   40 ++++++++++++++++++++++++++++++++++++++++
> > include/linux/pci.h  |    5 +++++
> > 2 files changed, 45 insertions(+)
> >
> >diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> >index 2a75216..004e167 100644
> >--- a/drivers/pci/quirks.c
> >+++ b/drivers/pci/quirks.c
> >@@ -3179,3 +3179,43 @@ int pci_dev_specific_reset(struct pci_dev *dev, int probe)
> >
> > 	return -ENOTTY;
> > }
> >+
> >+static struct pci_dev *pci_func_0_dma_source(struct pci_dev *dev)
> >+{
> >+	return pci_get_slot(dev->bus, PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
> >+}
> 
> I think we needn't retrieve the PCI device passed in again from the list
> of PCI devices if its function number is zero.
> 
> 	if (!PCI_FUNC(dev->devfn))
> 		return dev;

I guess I was expecting we wouldn't quirk a function 0 device, but
looking again at the bug below I see that I am including the func 0
vendor/device.  I've also got a bad cut-n-paste as I'm including the
same device twice.  I'll take your suggestion.  Thanks,

Alex

> >+
> >+static const struct pci_dev_dma_source {
> >+	u16 vendor;
> >+	u16 device;
> >+	struct pci_dev *(*dma_source)(struct pci_dev *dev);
> >+} pci_dev_dma_source[] = {
> >+	/*
> >+	 * https://bugzilla.redhat.com/show_bug.cgi?id=605888
> >+	 *
> >+	 * Some Ricoh devices use the function 0 source ID for DMA on
> >+	 * other functions of a multifunction device.  The DMA devices
> >+	 * is therefore function 0, which will have implications of the
> >+	 * iommu grouping of these devices.
> >+	 */
> >+	{ PCI_VENDOR_ID_RICOH, 0xe822, pci_func_0_dma_source },
> >+	{ PCI_VENDOR_ID_RICOH, 0xe230, pci_func_0_dma_source },
> >+	{ PCI_VENDOR_ID_RICOH, 0xe832, pci_func_0_dma_source },
> >+	{ PCI_VENDOR_ID_RICOH, 0xe832, pci_func_0_dma_source },
> >+	{ 0 }
> >+};
> >+
> >+struct pci_dev *pci_dma_source(struct pci_dev *dev)
> >+{
> >+	const struct pci_dev_dma_source *i;
> >+
> >+	for (i = pci_dev_dma_source; i->dma_source; i++) {
> >+		if ((i->vendor == dev->vendor ||
> >+		     i->vendor == (u16)PCI_ANY_ID) &&
> >+		    (i->device == dev->device ||
> >+		     i->device == (u16)PCI_ANY_ID))
> >+			return i->dma_source(dev);
> >+	}
> >+
> >+	return dev;
> >+}
> >diff --git a/include/linux/pci.h b/include/linux/pci.h
> >index d8c379d..5bc7502 100644
> >--- a/include/linux/pci.h
> >+++ b/include/linux/pci.h
> >@@ -1486,9 +1486,14 @@ enum pci_fixup_pass {
> >
> > #ifdef CONFIG_PCI_QUIRKS
> > void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
> >+struct pci_dev *pci_dma_source(struct pci_dev *dev);
> > #else
> > static inline void pci_fixup_device(enum pci_fixup_pass pass,
> > 				    struct pci_dev *dev) {}
> >+static inline struct pci_dev *pci_dma_source(struct pci_dev *dev)
> >+{
> >+	return dev;
> >+}
> > #endif
> >
> > void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 



