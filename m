Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab2EVFFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:05:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452Ab2EVFFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:05:19 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 04/13] pci: Add PCI DMA source ID quirk
To: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org
Cc: chrisw@sous-sol.org, agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, ddutile@redhat.com, alex.williamson@redhat.com
Date: Mon, 21 May 2012 23:05:01 -0600
Message-ID: <20120522050501.5871.89639.stgit@bling.home>
In-Reply-To: <20120522043607.5871.11340.stgit@bling.home>
References: <20120522043607.5871.11340.stgit@bling.home>
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

 drivers/pci/quirks.c |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h  |    5 +++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 4bf7102..a2dd77f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3109,3 +3109,43 @@ int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 
 	return -ENOTTY;
 }
+
+static struct pci_dev *pci_func_0_dma_source(struct pci_dev *dev)
+{
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
+	{ PCI_VENDOR_ID_RICOH, 0xe832, pci_func_0_dma_source },
+	{ 0 }
+};
+
+struct pci_dev *pci_dma_source(struct pci_dev *dev)
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
+	return dev;
+}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index e444f5b..02dbfed 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1479,9 +1479,14 @@ enum pci_fixup_pass {
 
 #ifdef CONFIG_PCI_QUIRKS
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
+struct pci_dev *pci_dma_source(struct pci_dev *dev);
 #else
 static inline void pci_fixup_device(enum pci_fixup_pass pass,
 				    struct pci_dev *dev) {}
+static inline struct pci_dev *pci_dma_source(struct pci_dev *dev)
+{
+	return dev;
+}
 #endif
 
 void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);

