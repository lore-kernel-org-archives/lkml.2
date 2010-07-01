Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab0GAUU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:20:27 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58940 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848Ab0GAUUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:20:25 -0400
Date: Thu, 1 Jul 2010 16:20:24 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20100701202024.GA16133@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Some MacBook Pro's don't like ahci, prefer ata_generic for these

2) fix ABI-visible signedness bug for AHCI Enclosure Management (EM)
   messages


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |   10 ++++++++++
 drivers/ata/ata_generic.c |   30 ++++++++++++++++++++++++------
 drivers/ata/libahci.c     |    5 +++--
 include/linux/pci_ids.h   |    1 +
 4 files changed, 38 insertions(+), 8 deletions(-)

Harry Zhang (1):
      libahci: Fix bug in storing EM messages

Tejun Heo (2):
      ahci,ata_generic: let ata_generic handle new MBP w/ MCP89
      ata_generic: implement ATA_GEN_* flags and force enable DMA on MBP 7,1

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 8ca16f5..f252253 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1053,6 +1053,16 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pdev->vendor == PCI_VENDOR_ID_MARVELL && !marvell_enable)
 		return -ENODEV;
 
+	/*
+	 * For some reason, MCP89 on MacBook 7,1 doesn't work with
+	 * ahci, use ata_generic instead.
+	 */
+	if (pdev->vendor == PCI_VENDOR_ID_NVIDIA &&
+	    pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP89_SATA &&
+	    pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE &&
+	    pdev->subsystem_device == 0xcb89)
+		return -ENODEV;
+
 	/* Promise's PDC42819 is a SAS/SATA controller that has an AHCI mode.
 	 * At the moment, we can only use the AHCI mode. Let the users know
 	 * that for SAS drives they're out of luck.
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 573158a..7107a69 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -32,6 +32,11 @@
  *	A generic parallel ATA driver using libata
  */
 
+enum {
+	ATA_GEN_CLASS_MATCH		= (1 << 0),
+	ATA_GEN_FORCE_DMA		= (1 << 1),
+};
+
 /**
  *	generic_set_mode	-	mode setting
  *	@link: link to set up
@@ -46,13 +51,17 @@
 static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 {
 	struct ata_port *ap = link->ap;
+	const struct pci_device_id *id = ap->host->private_data;
 	int dma_enabled = 0;
 	struct ata_device *dev;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
-	/* Bits 5 and 6 indicate if DMA is active on master/slave */
-	if (ap->ioaddr.bmdma_addr)
+	if (id->driver_data & ATA_GEN_FORCE_DMA) {
+		dma_enabled = 0xff;
+	} else if (ap->ioaddr.bmdma_addr) {
+		/* Bits 5 and 6 indicate if DMA is active on master/slave */
 		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_CENATEK)
 		dma_enabled = 0xFF;
@@ -126,7 +135,7 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	/* Don't use the generic entry unless instructed to do so */
-	if (id->driver_data == 1 && all_generic_ide == 0)
+	if ((id->driver_data & ATA_GEN_CLASS_MATCH) && all_generic_ide == 0)
 		return -ENODEV;
 
 	/* Devices that need care */
@@ -155,7 +164,7 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 			return rc;
 		pcim_pin_device(dev);
 	}
-	return ata_pci_bmdma_init_one(dev, ppi, &generic_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &generic_sht, (void *)id, 0);
 }
 
 static struct pci_device_id ata_generic[] = {
@@ -167,7 +176,15 @@ static struct pci_device_id ata_generic[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_HINT,   PCI_DEVICE_ID_HINT_VXPROII_IDE), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA,    PCI_DEVICE_ID_VIA_82C561), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_OPTI,   PCI_DEVICE_ID_OPTI_82C558), },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CENATEK,PCI_DEVICE_ID_CENATEK_IDE), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CENATEK,PCI_DEVICE_ID_CENATEK_IDE),
+	  .driver_data = ATA_GEN_FORCE_DMA },
+	/*
+	 * For some reason, MCP89 on MacBook 7,1 doesn't work with
+	 * ahci, use ata_generic instead.
+	 */
+	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP89_SATA,
+	  PCI_VENDOR_ID_APPLE, 0xcb89,
+	  .driver_data = ATA_GEN_FORCE_DMA },
 #if !defined(CONFIG_PATA_TOSHIBA) && !defined(CONFIG_PATA_TOSHIBA_MODULE)
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
@@ -175,7 +192,8 @@ static struct pci_device_id ata_generic[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_5),  },
 #endif	
 	/* Must come last. If you add entries adjust this table appropriately */
-	{ PCI_ANY_ID,		PCI_ANY_ID,			   PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL, 1},
+	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL),
+	  .driver_data = ATA_GEN_CLASS_MATCH },
 	{ 0, },
 };
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 261f86d..81e772a 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -324,6 +324,7 @@ static ssize_t ahci_store_em_buffer(struct device *dev,
 	struct ahci_host_priv *hpriv = ap->host->private_data;
 	void __iomem *mmio = hpriv->mmio;
 	void __iomem *em_mmio = mmio + hpriv->em_loc;
+	const unsigned char *msg_buf = buf;
 	u32 em_ctl, msg;
 	unsigned long flags;
 	int i;
@@ -343,8 +344,8 @@ static ssize_t ahci_store_em_buffer(struct device *dev,
 	}
 
 	for (i = 0; i < size; i += 4) {
-		msg = buf[i] | buf[i + 1] << 8 |
-		      buf[i + 2] << 16 | buf[i + 3] << 24;
+		msg = msg_buf[i] | msg_buf[i + 1] << 8 |
+		      msg_buf[i + 2] << 16 | msg_buf[i + 3] << 24;
 		writel(msg, em_mmio + i);
 	}
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 4eb4679..3bedcc1 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1261,6 +1261,7 @@
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE       0x0759
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_SMBUS     0x07D8
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP79_SMBUS     0x0AA2
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP89_SATA	    0x0D85
 
 #define PCI_VENDOR_ID_IMS		0x10e0
 #define PCI_DEVICE_ID_IMS_TT128		0x9128
