Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2E3UIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:08:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab2E3UIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:08:51 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 1/5] pci: Add PCI DMA source ID quirk
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, konrad.wilk@oracle.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        ddutile@redhat.com, alex.williamson@redhat.com,
        shangw@linux.vnet.ibm.com, liuj97@gmail.com
Date: Wed, 30 May 2012 14:08:29 -0600
Message-ID: <20120530200829.31085.95978.stgit@bling.home>
In-Reply-To: <20120530200343.31085.78920.stgit@bling.home>
References: <20120530200343.31085.78920.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA transactions are tagged with the source ID of the device making
the request.  Occasionally hardware screws this up and uses the
source ID of a different device (often the wrong function number of
a multifunction device).  A specific Ricoh multifunction device is
a prime example of this problem and included in this patch.  The
purpose of this function is that given a pci_dev, return the pci_dev
to use as the source ID for DMA.  When hardware works correctly,
this returns the input device.  For the components of the Ricoh
multifunction device, return the pci_dev for function 0.

This will be used by IOMMU drivers for determining the boundaries
of IOMMU groups as multiple devices using the same source ID must
be contained within the same group.  This can also be used by
existing streaming DMA paths for the same purpose.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/quirks.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h  |    5 +++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 2a75216..acd3956 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3179,3 +3179,54 @@ int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 
 	return -ENOTTY;
 }
+
+static struct pci_dev *pci_func_0_dma_source(struct pci_dev *dev)
+{
+	if (!PCI_FUNC(dev->devfn))
+		return pci_dev_get(dev);
+
+	return pci_get_slot(dev->bus, PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
+}
+
+static const struct pci_dev_dma_source {
+	u16 vendor;
+	u16 device;
+	struct pci_dev *(*dma_source)(struct pci_dev *dev);
+} pci_dev_dma_source[] = {
+	/*
+	 * https://bugzilla.redhat.com/show_bug.cgi?id=605888
+	 *
+	 * Some Ricoh devices use the function 0 source ID for DMA on
+	 * other functions of a multifunction device.  The DMA devices
+	 * is therefore function 0, which will have implications of the
+	 * iommu grouping of these devices.
+	 */
+	{ PCI_VENDOR_ID_RICOH, 0xe822, pci_func_0_dma_source },
+	{ PCI_VENDOR_ID_RICOH, 0xe230, pci_func_0_dma_source },
+	{ PCI_VENDOR_ID_RICOH, 0xe832, pci_func_0_dma_source },
+	{ PCI_VENDOR_ID_RICOH, 0xe476, pci_func_0_dma_source },
+	{ 0 }
+};
+
+/*
+ * IOMMUs with isolation capabilities need to be programmed with the
+ * correct source ID of a device.  In most cases, the source ID matches
+ * the device doing the DMA, but sometimes hardware is broken and will
+ * tag the DMA as being sourced from a different device.  This function
+ * allows that translation.  Note that the reference count of the
+ * returned device is incremented on all paths.
+ */
+struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
+{
+	const struct pci_dev_dma_source *i;
+
+	for (i = pci_dev_dma_source; i->dma_source; i++) {
+		if ((i->vendor == dev->vendor ||
+		     i->vendor == (u16)PCI_ANY_ID) &&
+		    (i->device == dev->device ||
+		     i->device == (u16)PCI_ANY_ID))
+			return i->dma_source(dev);
+	}
+
+	return pci_dev_get(dev);
+}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d8c379d..6badba3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1486,9 +1486,14 @@ enum pci_fixup_pass {
 
 #ifdef CONFIG_PCI_QUIRKS
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
+struct pci_dev *pci_get_dma_source(struct pci_dev *dev);
 #else
 static inline void pci_fixup_device(enum pci_fixup_pass pass,
 				    struct pci_dev *dev) {}
+static inline struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
+{
+	return pci_dev_get(dev);
+}
 #endif
 
 void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);

