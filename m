Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1A1I3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:29:35 -0500
Received: from havoc.gtf.org ([69.61.125.42]:38487 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab1A1I3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:29:33 -0500
Date: Fri, 28 Jan 2011 03:29:31 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20110128082931.GA20696@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1. DMA alignment fix for PIO + ATAPI.

2. various other minor fixes and PCI IDs

3. And a couple pata_hpt* cosmetics.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c         |    3 +
 drivers/ata/libata-core.c  |    1 +
 drivers/ata/libata-scsi.c  |   24 +++++++--
 drivers/ata/pata_hpt366.c  |    6 +-
 drivers/ata/pata_hpt37x.c  |  112 +++++++++++++++++++++-----------------------
 drivers/ata/pata_hpt3x2n.c |   12 ++---
 drivers/ata/pata_mpc52xx.c |    2 +-
 7 files changed, 85 insertions(+), 75 deletions(-)

Anssi Hannula (1):
      ahci: add HFLAG_YES_FBS and apply it to 88SE9128

Francesco Antonacci (1):
      libata: DVR-212D can't do SETXFER DVD-RW DVR-212D

Sergei Shtylyov (4):
      pata_hpt{366|37x}: use pr_warning(...) instead of printk(KERN_WARNING ...)
      pata_hpt{37x|3x2n}: use pr_*(DRV_NAME ...) instead of printk(KERN_* ...)
      pata_hpt37x: fold 'if' statement into 'switch'
      pata_hpt37x: inherit prereset() method for HPT374

Seth Heasley (1):
      ahci: AHCI mode SATA patch for Intel DH89xxCC DeviceIDs

Tejun Heo (2):
      pata_mpc52xx: inherit from ata_bmdma_port_ops
      libata: set queue DMA alignment to sector size for ATAPI too

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 3288263..b8d96ce 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -260,6 +260,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
 	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x2323), board_ahci }, /* DH89xxCC AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
@@ -379,6 +380,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
 	{ PCI_DEVICE(0x1b4b, 0x9123),
+	  .class = PCI_CLASS_STORAGE_SATA_AHCI,
+	  .class_mask = 0xffffff,
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
 
 	/* Promise */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a31fe96..d4e52e2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4138,6 +4138,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	 * device and controller are SATA.
 	 */
 	{ "PIONEER DVD-RW  DVRTD08",	"1.00",	ATA_HORKAGE_NOSETXFER },
+	{ "PIONEER DVD-RW  DVR-212D",	"1.28", ATA_HORKAGE_NOSETXFER },
 
 	/* End Marker */
 	{ }
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5defc74..600f635 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1099,9 +1099,9 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		struct request_queue *q = sdev->request_queue;
 		void *buf;
 
-		/* set the min alignment and padding */
-		blk_queue_update_dma_alignment(sdev->request_queue,
-					       ATA_DMA_PAD_SZ - 1);
+		sdev->sector_size = ATA_SECT_SIZE;
+
+		/* set DMA padding */
 		blk_queue_update_dma_pad(sdev->request_queue,
 					 ATA_DMA_PAD_SZ - 1);
 
@@ -1115,13 +1115,25 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 
 		blk_queue_dma_drain(q, atapi_drain_needed, buf, ATAPI_MAX_DRAIN);
 	} else {
-		/* ATA devices must be sector aligned */
 		sdev->sector_size = ata_id_logical_sector_size(dev->id);
-		blk_queue_update_dma_alignment(sdev->request_queue,
-					       sdev->sector_size - 1);
 		sdev->manage_start_stop = 1;
 	}
 
+	/*
+	 * ata_pio_sectors() expects buffer for each sector to not cross
+	 * page boundary.  Enforce it by requiring buffers to be sector
+	 * aligned, which works iff sector_size is not larger than
+	 * PAGE_SIZE.  ATAPI devices also need the alignment as
+	 * IDENTIFY_PACKET is executed as ATA_PROT_PIO.
+	 */
+	if (sdev->sector_size > PAGE_SIZE)
+		ata_dev_printk(dev, KERN_WARNING,
+			"sector_size=%u > PAGE_SIZE, PIO may malfunction\n",
+			sdev->sector_size);
+
+	blk_queue_update_dma_alignment(sdev->request_queue,
+				       sdev->sector_size - 1);
+
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
 
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index d7e57db..538ec38 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt366"
-#define DRV_VERSION	"0.6.9"
+#define DRV_VERSION	"0.6.10"
 
 struct hpt_clock {
 	u8	xfer_mode;
@@ -160,8 +160,8 @@ static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr,
 
 	while (list[i] != NULL) {
 		if (!strcmp(list[i], model_num)) {
-			printk(KERN_WARNING DRV_NAME ": %s is not supported for %s.\n",
-				modestr, list[i]);
+			pr_warning(DRV_NAME ": %s is not supported for %s.\n",
+				   modestr, list[i]);
 			return 1;
 		}
 		i++;
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index efdd18b..4c5b518 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.18"
+#define DRV_VERSION	"0.6.22"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -229,8 +229,8 @@ static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr,
 
 	while (list[i] != NULL) {
 		if (!strcmp(list[i], model_num)) {
-			printk(KERN_WARNING DRV_NAME ": %s is not supported for %s.\n",
-				modestr, list[i]);
+			pr_warning(DRV_NAME ": %s is not supported for %s.\n",
+				   modestr, list[i]);
 			return 1;
 		}
 		i++;
@@ -642,7 +642,6 @@ static struct ata_port_operations hpt372_port_ops = {
 static struct ata_port_operations hpt374_fn1_port_ops = {
 	.inherits	= &hpt372_port_ops,
 	.cable_detect	= hpt374_fn1_cable_detect,
-	.prereset	= hpt37x_pre_reset,
 };
 
 /**
@@ -803,7 +802,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = ATA_UDMA6,
 		.port_ops = &hpt302_port_ops
 	};
-	/* HPT374 - UDMA100, function 1 uses different prereset method */
+	/* HPT374 - UDMA100, function 1 uses different cable_detect method */
 	static const struct ata_port_info info_hpt374_fn0 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = ATA_PIO4,
@@ -838,7 +837,8 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
-	if (dev->device == PCI_DEVICE_ID_TTI_HPT366) {
+	switch (dev->device) {
+	case PCI_DEVICE_ID_TTI_HPT366:
 		/* May be a later chip in disguise. Check */
 		/* Older chips are in the HPT366 driver. Ignore them */
 		if (rev < 3)
@@ -863,54 +863,50 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			chip_table = &hpt372;
 			break;
 		default:
-			printk(KERN_ERR "pata_hpt37x: Unknown HPT366 subtype, "
+			pr_err(DRV_NAME ": Unknown HPT366 subtype, "
 			       "please report (%d).\n", rev);
 			return -ENODEV;
 		}
-	} else {
-		switch (dev->device) {
-		case PCI_DEVICE_ID_TTI_HPT372:
-			/* 372N if rev >= 2 */
-			if (rev >= 2)
-				return -ENODEV;
-			ppi[0] = &info_hpt372;
-			chip_table = &hpt372a;
-			break;
-		case PCI_DEVICE_ID_TTI_HPT302:
-			/* 302N if rev > 1 */
-			if (rev > 1)
-				return -ENODEV;
-			ppi[0] = &info_hpt302;
-			/* Check this */
-			chip_table = &hpt302;
-			break;
-		case PCI_DEVICE_ID_TTI_HPT371:
-			if (rev > 1)
-				return -ENODEV;
-			ppi[0] = &info_hpt302;
-			chip_table = &hpt371;
-			/*
-			 * Single channel device, master is not present
-			 * but the BIOS (or us for non x86) must mark it
-			 * absent
-			 */
-			pci_read_config_byte(dev, 0x50, &mcr1);
-			mcr1 &= ~0x04;
-			pci_write_config_byte(dev, 0x50, mcr1);
-			break;
-		case PCI_DEVICE_ID_TTI_HPT374:
-			chip_table = &hpt374;
-			if (!(PCI_FUNC(dev->devfn) & 1))
-				*ppi = &info_hpt374_fn0;
-			else
-				*ppi = &info_hpt374_fn1;
-			break;
-		default:
-			printk(KERN_ERR
-			       "pata_hpt37x: PCI table is bogus, please report (%d).\n",
-			       dev->device);
-				return -ENODEV;
-		}
+		break;
+	case PCI_DEVICE_ID_TTI_HPT372:
+		/* 372N if rev >= 2 */
+		if (rev >= 2)
+			return -ENODEV;
+		ppi[0] = &info_hpt372;
+		chip_table = &hpt372a;
+		break;
+	case PCI_DEVICE_ID_TTI_HPT302:
+		/* 302N if rev > 1 */
+		if (rev > 1)
+			return -ENODEV;
+		ppi[0] = &info_hpt302;
+		/* Check this */
+		chip_table = &hpt302;
+		break;
+	case PCI_DEVICE_ID_TTI_HPT371:
+		if (rev > 1)
+			return -ENODEV;
+		ppi[0] = &info_hpt302;
+		chip_table = &hpt371;
+		/*
+		 * Single channel device, master is not present but the BIOS
+		 * (or us for non x86) must mark it absent
+		 */
+		pci_read_config_byte(dev, 0x50, &mcr1);
+		mcr1 &= ~0x04;
+		pci_write_config_byte(dev, 0x50, mcr1);
+		break;
+	case PCI_DEVICE_ID_TTI_HPT374:
+		chip_table = &hpt374;
+		if (!(PCI_FUNC(dev->devfn) & 1))
+			*ppi = &info_hpt374_fn0;
+		else
+			*ppi = &info_hpt374_fn1;
+		break;
+	default:
+		pr_err(DRV_NAME ": PCI table is bogus, please report (%d).\n",
+		       dev->device);
+		return -ENODEV;
 	}
 	/* Ok so this is a chip we support */
 
@@ -957,8 +953,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		u8 sr;
 		u32 total = 0;
 
-		printk(KERN_WARNING
-		       "pata_hpt37x: BIOS has not set timing clocks.\n");
+		pr_warning(DRV_NAME ": BIOS has not set timing clocks.\n");
 
 		/* This is the process the HPT371 BIOS is reported to use */
 		for (i = 0; i < 128; i++) {
@@ -1014,7 +1009,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 					       (f_high << 16) | f_low | 0x100);
 		}
 		if (adjust == 8) {
-			printk(KERN_ERR "pata_hpt37x: DPLL did not stabilize!\n");
+			pr_err(DRV_NAME ": DPLL did not stabilize!\n");
 			return -ENODEV;
 		}
 		if (dpll == 3)
@@ -1022,8 +1017,8 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		else
 			private_data = (void *)hpt37x_timings_50;
 
-		printk(KERN_INFO "pata_hpt37x: bus clock %dMHz, using %dMHz DPLL.\n",
-		       MHz[clock_slot], MHz[dpll]);
+		pr_info(DRV_NAME ": bus clock %dMHz, using %dMHz DPLL.\n",
+			MHz[clock_slot], MHz[dpll]);
 	} else {
 		private_data = (void *)chip_table->clocks[clock_slot];
 		/*
@@ -1036,8 +1031,9 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			ppi[0] = &info_hpt370_33;
 		if (clock_slot < 2 && ppi[0] == &info_hpt370a)
 			ppi[0] = &info_hpt370a_33;
-		printk(KERN_INFO "pata_hpt37x: %s using %dMHz bus clock.\n",
-		       chip_table->name, MHz[clock_slot]);
+
+		pr_info(DRV_NAME ": %s using %dMHz bus clock.\n",
+			chip_table->name, MHz[clock_slot]);
 	}
 
 	/* Now kick off ATA set up */
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index d2239bb..eca68ca 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x2n"
-#define DRV_VERSION	"0.3.13"
+#define DRV_VERSION	"0.3.14"
 
 enum {
 	HPT_PCI_FAST	=	(1 << 31),
@@ -418,7 +418,7 @@ static int hpt3x2n_pci_clock(struct pci_dev *pdev)
 		u16 sr;
 		u32 total = 0;
 
-		printk(KERN_WARNING "pata_hpt3x2n: BIOS clock data not set.\n");
+		pr_warning(DRV_NAME ": BIOS clock data not set.\n");
 
 		/* This is the process the HPT371 BIOS is reported to use */
 		for (i = 0; i < 128; i++) {
@@ -528,8 +528,7 @@ hpt372n:
 		ppi[0] = &info_hpt372n;
 		break;
 	default:
-		printk(KERN_ERR
-		       "pata_hpt3x2n: PCI table is bogus please report (%d).\n",
+		pr_err(DRV_NAME ": PCI table is bogus, please report (%d).\n",
 		       dev->device);
 		return -ENODEV;
 	}
@@ -579,12 +578,11 @@ hpt372n:
 		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
 	}
 	if (adjust == 8) {
-		printk(KERN_ERR "pata_hpt3x2n: DPLL did not stabilize!\n");
+		pr_err(DRV_NAME ": DPLL did not stabilize!\n");
 		return -ENODEV;
 	}
 
-	printk(KERN_INFO "pata_hpt37x: bus clock %dMHz, using 66MHz DPLL.\n",
-	       pci_mhz);
+	pr_info(DRV_NAME ": bus clock %dMHz, using 66MHz DPLL.\n", pci_mhz);
 
 	/*
 	 * Set our private data up. We only need a few flags
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 8cc536e..d7d8026 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -610,7 +610,7 @@ static struct scsi_host_template mpc52xx_ata_sht = {
 };
 
 static struct ata_port_operations mpc52xx_ata_port_ops = {
-	.inherits		= &ata_sff_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 	.sff_dev_select		= mpc52xx_ata_dev_select,
 	.set_piomode		= mpc52xx_ata_set_piomode,
 	.set_dmamode		= mpc52xx_ata_set_dmamode,
