Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab2EKW4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:56:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496Ab2EKW4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:56:19 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 04/13] pci: New pci_dma_quirk()
To: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org
Cc: chrisw@sous-sol.org, agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, alex.williamson@redhat.com
Date: Fri, 11 May 2012 16:55:55 -0600
Message-ID: <20120511225555.30496.80525.stgit@bling.home>
In-Reply-To: <20120511222148.30496.68571.stgit@bling.home>
References: <20120511222148.30496.68571.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrating IOMMU groups more closely into the driver core allows
us to more easily work around DMA quirks.  The Ricoh multifunction
controller is a favorite example of devices that are currently
incompatible with IOMMU isolation as all the functions use the
requestor ID of function 0 for DMA.  Passing this device into
pci_dma_quirk returns the PCI device to use for DMA.  The IOMMU
driver can then construct an IOMMU group including both devices.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/quirks.c |   22 ++++++++++++++++++++++
 include/linux/pci.h  |    2 ++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 4bf7102..6f9f7f9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3109,3 +3109,25 @@ int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 
 	return -ENOTTY;
 }
+
+struct pci_dev *pci_dma_quirk(struct pci_dev *dev)
+{
+	struct pci_dev *dma_dev = dev;
+
+	/*
+	 * https://bugzilla.redhat.com/show_bug.cgi?id=605888
+	 *
+	 * Some Ricoh devices use the function 0 source ID for DMA on
+	 * other functions of a multifunction device.  The DMA devices
+	 * is therefore function 0, which will have implications of the
+	 * iommu grouping of these devices.
+	 */
+	if (dev->vendor == PCI_VENDOR_ID_RICOH &&
+	    (dev->device == 0xe822 || dev->device == 0xe230 ||
+	     dev->device == 0xe832 || dev->device == 0xe476)) {
+		dma_dev = pci_get_slot(dev->bus,
+				       PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
+	}
+
+	return dma_dev;
+}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index e444f5b..9910b5c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1479,9 +1479,11 @@ enum pci_fixup_pass {
 
 #ifdef CONFIG_PCI_QUIRKS
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
+struct pci_dev *pci_dma_quirk(struct pci_dev *dev);
 #else
 static inline void pci_fixup_device(enum pci_fixup_pass pass,
 				    struct pci_dev *dev) {}
+struct pci_dev *pci_dma_quirk(struct pci_dev *dev) { return dev }
 #endif
 
 void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);

