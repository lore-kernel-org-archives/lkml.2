Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1BHM0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:26:20 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48060 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab1BHM0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:26:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=s/pDuAR8FyYM95hnw+X2ZJh5TI4GyitLk4mjMKvVkPQyFYpQQqN/YHo1HyZUBhpwzj
         KIo8p7exZZpTIqN++gzijgW0ZfEwbVfLAuDubM5mAlmQyCc6v75T9itolFNvnwJEWZHC
         FPWTsymiG1IbGxD6+7Zz+PEDMS4kJXpksLkz8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:26:05 +0100
Message-Id: <20110208122605.19110.40414.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCH 20/20] ata_piix: add Radisys R82600 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2172ad66e1ad14599fe08d4fe898d392f10962d3 Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 8 Feb 2011 12:39:28 +0100
Subject: [PATCH 20/20] ata_piix: add Radisys R82600 support

Add Radisys R82600 support to ata_piix and remove no longer
needed pata_radisys driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/Kconfig        |    1 +
 drivers/ata/Makefile       |    1 -
 drivers/ata/ata_piix.c     |   84 ++++++++++++---
 drivers/ata/pata_radisys.c |  252 --------------------------------------------
 4 files changed, 72 insertions(+), 266 deletions(-)
 delete mode 100644 drivers/ata/pata_radisys.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 0e6d193..43bbf74 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -559,6 +559,7 @@ config PATA_PDC_OLD
 config PATA_RADISYS
 	tristate "RADISYS 82600 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_PIIX
 	help
 	  This option enables support for the RADISYS 82600
 	  PATA controllers via the new ATA layer
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 55272af..cddef6e 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -56,7 +56,6 @@ obj-$(CONFIG_PATA_NS87415)	+= pata_ns87415.o
 obj-$(CONFIG_PATA_OPTIDMA)	+= pata_optidma.o
 obj-$(CONFIG_PATA_PDC2027X)	+= pata_pdc2027x.o
 obj-$(CONFIG_PATA_PDC_OLD)	+= pata_pdc202xx_old.o
-obj-$(CONFIG_PATA_RADISYS)	+= pata_radisys.o
 obj-$(CONFIG_PATA_SC1200)	+= pata_sc1200.o
 obj-$(CONFIG_PATA_SCC)		+= pata_scc.o
 obj-$(CONFIG_PATA_SCH)		+= pata_sch.o
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 5afa57a..4b00e26 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -99,6 +99,12 @@
  *    SITRE and the slave timing registers. This means that you have to
  *    set timing per channel, or be clever. Libata tells us whenever it
  *    does drive selection and we use this to reload the timings.
+ *
+ *    Radisys R82600 - a PIIX relative, this device has a single ATA channel
+ *    and no slave timings, SITRE or PPE. In that sense it is a close relative
+ *    of the original PIIX. It does however support UDMA 33/66 per channel
+ *    although no other modes/timings. Also lacking is 32bit I/O on the ATA
+ *    port.
  */
 
 #include <linux/kernel.h>
@@ -160,6 +166,7 @@ enum piix_controller_ids {
 	efar_pata,
 	it8213_pata,
 	oldpiix_pata,
+	radisys_pata,
 	ich5_sata,
 	ich6_sata,
 	ich6m_sata,
@@ -266,6 +273,9 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* PIIXb (a.k.a. oldpiix) */
 	{ 0x8086, 0x1230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, oldpiix_pata },
 
+	/* Radisys R82600 */
+	{ 0x1331, 0x8201, PCI_ANY_ID, PCI_ANY_ID, 0, 0, radisys_pata },
+
 	/* SATA ports */
 	
 	/* 82801EB (ICH5) */
@@ -431,6 +441,14 @@ static struct ata_port_operations oldpiix_pata_ops = {
 	.prereset		= piix_pata_prereset,
 };
 
+static struct ata_port_operations radisys_pata_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+	.qc_issue		= oldpiix_qc_issue,
+	.cable_detect		= ata_cable_unknown,
+	.set_piomode		= piix_set_piomode,
+	.set_dmamode		= piix_set_dmamode,
+};
+
 static const struct piix_map_db ich5_map_db = {
 	.mask = 0x7,
 	.port_enable = 0x3,
@@ -685,6 +703,15 @@ static struct ata_port_info piix_port_info[] = {
 		.mwdma_mask	= ATA_MWDMA12_ONLY,
 		.port_ops	= &oldpiix_pata_ops,
 	},
+
+	[radisys_pata] =
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.udma_mask	= ATA_UDMA24_ONLY,
+		.port_ops	= &radisys_pata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {
@@ -701,6 +728,7 @@ MODULE_ALIAS("pata_efar");
 MODULE_ALIAS("pata_it8213");
 MODULE_ALIAS("pata_rdc");
 MODULE_ALIAS("pata_oldpiix");
+MODULE_ALIAS("pata_radisys");
 
 struct ich_laptop {
 	u16 device;
@@ -831,8 +859,10 @@ static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	unsigned long flags;
 	unsigned int is_slave	= (adev->devno != 0);
-	unsigned int has_sitre	= (dev->vendor != 0x8086 ||
-				   dev->device != 0x1230);
+	unsigned int is_radisys	= (dev->vendor == PCI_VENDOR_ID_RADISYS &&
+				   dev->device == 0x8201);
+	unsigned int has_sitre	= (dev->vendor != PCI_VENDOR_ID_INTEL ||
+				   dev->device != 0x1230) && !is_radisys;
 	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
 	unsigned int slave_port	= 0x44;
 	u16 master_data;
@@ -851,14 +881,21 @@ static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
 			    { 1, 0 },
 			    { 2, 1 },
 			    { 2, 3 }, };
+	static const u8 timings_radisys[][2] = {
+			    { 0, 0 },
+			    { 0, 0 },
+			    { 1, 1 },
+			    { 2, 2 },
+			    { 3, 3 }, };
 
-	if (pio >= 2 || use_mwdma)
+	if (pio >= 2 || (pio == 1 && is_radisys) ||
+	    (use_mwdma && !is_radisys))
 		control |= 1;	/* TIME1 enable */
-	if (ata_pio_need_iordy(adev) || use_mwdma)
+	if (ata_pio_need_iordy(adev) || (use_mwdma && !is_radisys))
 		control |= 2;	/* IE enable */
 	if (dev->vendor != PCI_VENDOR_ID_ITE) {
 		/* PPE functionality is for disk only */
-		if (adev->class == ATA_DEV_ATA)
+		if (adev->class == ATA_DEV_ATA && !is_radisys)
 			control |= 4;	/* PPE enable */
 	} else {
 		/* Bit 2 is set for ATAPI on the IT8213 - reverse of ICH/PIIX */
@@ -867,9 +904,13 @@ static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
 	}
 	/* If the drive MWDMA is faster than it can do PIO then
 	   we must force PIO into PIO0 */
-	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
-		/* Enable DMA timing only */
-		control |= 8;	/* PIO cycles in PIO0 */
+	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio)) {
+		if (!is_radisys) {
+			/* Enable DMA timing only */
+			control |= 8;	/* PIO cycles in PIO0 */
+		} else
+			control = 1;
+	}
 
 	spin_lock_irqsave(&piix_lock, flags);
 
@@ -888,7 +929,7 @@ static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
 		/* Load the timing nibble for this slave */
 		slave_data |= ((timings[pio][0] << 2) | timings[pio][1])
 						<< (ap->port_no ? 4 : 0);
-	} else {
+	} else if (!is_radisys) {
 		if (has_sitre) {
 			/* clear ISP|RCT|TIME0|IE0|PPE0|DTE0 */
 			master_data &= 0xccf0;
@@ -907,6 +948,14 @@ static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
 		master_data |=
 			(timings[pio][0] << 12) |
 			(timings[pio][1] << 8);
+	} else { /* radisys */
+		/* Enable IE and TIME as appropriate. Clear the other
+		   drive timing bits */
+		master_data &= 0xCCCC;
+		master_data |= (control << (4 * adev->devno));
+		master_data |=
+			(timings_radisys[pio][0] << 12) |
+			(timings_radisys[pio][1] << 8);
 	}
 
 	/* Enable SITRE (separate slave timing register) */
@@ -995,7 +1044,12 @@ static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, in
 		udma_enable |= (1 << devid);
 
 		pci_read_config_word(dev, 0x4A, &udma_timing);
-		if (dev->vendor == PCI_VENDOR_ID_EFAR) {
+		if (dev->vendor == PCI_VENDOR_ID_RADISYS) {
+			if (udma == 2)
+				udma_timing &= ~(2 << (adev->devno * 4));
+			else /* UDMA 4 */
+				udma_timing |= (2 << (adev->devno * 4));
+		} else if (dev->vendor == PCI_VENDOR_ID_EFAR) {
 			/* Load the UDMA mode number */
 			udma_timing &= ~(7 << (4 * devid));
 			udma_timing |= udma << (4 * devid);
@@ -1080,9 +1134,13 @@ static unsigned int oldpiix_qc_issue(struct ata_queued_cmd *qc)
 	struct ata_device *adev = qc->dev;
 
 	if (adev != ap->private_data) {
-		piix_set_piomode(ap, adev);
-		if (ata_dma_enabled(adev))
-			piix_set_dmamode(ap, adev);
+		/* UDMA timing is not shared */
+		if (adev->dma_mode < XFER_UDMA_0) {
+			if (adev->dma_mode)
+				piix_set_dmamode(ap, adev);
+			else if (adev->pio_mode)
+				piix_set_piomode(ap, adev);
+		}
 	}
 	return ata_bmdma_qc_issue(qc);
 }
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
deleted file mode 100644
index e85bb38..0000000
--- a/drivers/ata/pata_radisys.c
+++ /dev/null
@@ -1,252 +0,0 @@
-/*
- *    pata_radisys.c - Intel PATA/SATA controllers
- *
- *	(C) 2006 Red Hat <alan@lxorguk.ukuu.org.uk>
- *
- *    Some parts based on ata_piix.c by Jeff Garzik and others.
- *
- *    A PIIX relative, this device has a single ATA channel and no
- *    slave timings, SITRE or PPE. In that sense it is a close relative
- *    of the original PIIX. It does however support UDMA 33/66 per channel
- *    although no other modes/timings. Also lacking is 32bit I/O on the ATA
- *    port.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/init.h>
-#include <linux/blkdev.h>
-#include <linux/delay.h>
-#include <linux/device.h>
-#include <scsi/scsi_host.h>
-#include <linux/libata.h>
-#include <linux/ata.h>
-
-#define DRV_NAME	"pata_radisys"
-#define DRV_VERSION	"0.4.4"
-
-static void radisys_set_timings(struct ata_port *ap, struct ata_device *adev,
-				u8 pio, bool use_mwdma)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	u16 idetm_data;
-	int control = 0;
-
-	/*
-	 *	See Intel Document 298600-004 for the timing programing rules
-	 *	for PIIX/ICH. Note that the early PIIX does not have the slave
-	 *	timing port at 0x44. The Radisys is a relative of the PIIX
-	 *	but not the same so be careful.
-	 */
-
-	static const	 /* ISP  RTC */
-	u8 timings[][2]	= { { 0, 0 },
-			    { 0, 0 },
-			    { 1, 1 },
-			    { 2, 2 },
-			    { 3, 3 }, };
-
-	if (pio > 0)
-		control |= 1;	/* TIME1 enable */
-	if (ata_pio_need_iordy(adev))
-		control |= 2;	/* IE IORDY */
-	/* If the drive MWDMA is faster than it can do PIO then
-	   we must force PIO0 for PIO cycles. */
-	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
-		control = 1;
-
-	pci_read_config_word(dev, 0x40, &idetm_data);
-
-	/* Enable IE and TIME as appropriate. Clear the other
-	   drive timing bits */
-	idetm_data &= 0xCCCC;
-	idetm_data |= (control << (4 * adev->devno));
-	idetm_data |= (timings[pio][0] << 12) |
-			(timings[pio][1] << 8);
-	pci_write_config_word(dev, 0x40, idetm_data);
-
-	/* Track which port is configured */
-	ap->private_data = adev;
-}
-
-/**
- *	radisys_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: ATA port
- *	@adev: Device whose timings we are configuring
- *
- *	Set PIO mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void radisys_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	radisys_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
-}
-
-/**
- *	radisys_set_dmamode - Initialize host controller PATA DMA timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device to program
- *
- *	Set MWDMA mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void radisys_set_dmamode (struct ata_port *ap, struct ata_device *adev)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	u8 udma_enable;
-
-	/* MWDMA is driven by the PIO timings. */
-
-	pci_read_config_byte(dev, 0x48, &udma_enable);
-
-	if (adev->dma_mode < XFER_UDMA_0) {
-		unsigned int mwdma	= adev->dma_mode - XFER_MW_DMA_0;
-		const unsigned int needed_pio[3] = {
-			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
-		};
-		int pio = needed_pio[mwdma] - XFER_PIO_0;
-
-		radisys_set_timings(ap, adev, pio, 1);
-
-		udma_enable &= ~(1 << adev->devno);
-	} else {
-		u8 udma_mode;
-
-		/* UDMA66 on: UDMA 33 and 66 are switchable via register 0x4A */
-
-		pci_read_config_byte(dev, 0x4A, &udma_mode);
-
-		if (adev->xfer_mode == XFER_UDMA_2)
-			udma_mode &= ~(2 << (adev->devno * 4));
-		else /* UDMA 4 */
-			udma_mode |= (2 << (adev->devno * 4));
-
-		pci_write_config_byte(dev, 0x4A, udma_mode);
-
-		udma_enable |= (1 << adev->devno);
-	}
-	pci_write_config_byte(dev, 0x48, udma_enable);
-
-	/* Track which port is configured */
-	ap->private_data = adev;
-}
-
-/**
- *	radisys_qc_issue	-	command issue
- *	@qc: command pending
- *
- *	Called when the libata layer is about to issue a command. We wrap
- *	this interface so that we can load the correct ATA timings if
- *	necessary. Our logic also clears TIME0/TIME1 for the other device so
- *	that, even if we get this wrong, cycles to the other device will
- *	be made PIO0.
- */
-
-static unsigned int radisys_qc_issue(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct ata_device *adev = qc->dev;
-
-	if (adev != ap->private_data) {
-		/* UDMA timing is not shared */
-		if (adev->dma_mode < XFER_UDMA_0) {
-			if (adev->dma_mode)
-				radisys_set_dmamode(ap, adev);
-			else if (adev->pio_mode)
-				radisys_set_piomode(ap, adev);
-		}
-	}
-	return ata_bmdma_qc_issue(qc);
-}
-
-
-static struct scsi_host_template radisys_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
-};
-
-static struct ata_port_operations radisys_pata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
-	.qc_issue		= radisys_qc_issue,
-	.cable_detect		= ata_cable_unknown,
-	.set_piomode		= radisys_set_piomode,
-	.set_dmamode		= radisys_set_dmamode,
-};
-
-
-/**
- *	radisys_init_one - Register PIIX ATA PCI device with kernel services
- *	@pdev: PCI device to register
- *	@ent: Entry in radisys_pci_tbl matching with @pdev
- *
- *	Called from kernel PCI layer.  We probe for combined mode (sigh),
- *	and then hand over control to libata, for it to do the rest.
- *
- *	LOCKING:
- *	Inherited from PCI layer (may sleep).
- *
- *	RETURNS:
- *	Zero on success, or -ERRNO value.
- */
-
-static int radisys_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
-{
-	static int printed_version;
-	static const struct ata_port_info info = {
-		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY,
-		.udma_mask	= ATA_UDMA24_ONLY,
-		.port_ops	= &radisys_pata_ops,
-	};
-	const struct ata_port_info *ppi[] = { &info, NULL };
-
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
-
-	return ata_pci_bmdma_init_one(pdev, ppi, &radisys_sht, NULL, 0);
-}
-
-static const struct pci_device_id radisys_pci_tbl[] = {
-	{ PCI_VDEVICE(RADISYS, 0x8201), },
-
-	{ }	/* terminate list */
-};
-
-static struct pci_driver radisys_pci_driver = {
-	.name			= DRV_NAME,
-	.id_table		= radisys_pci_tbl,
-	.probe			= radisys_init_one,
-	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
-	.suspend		= ata_pci_device_suspend,
-	.resume			= ata_pci_device_resume,
-#endif
-};
-
-static int __init radisys_init(void)
-{
-	return pci_register_driver(&radisys_pci_driver);
-}
-
-static void __exit radisys_exit(void)
-{
-	pci_unregister_driver(&radisys_pci_driver);
-}
-
-module_init(radisys_init);
-module_exit(radisys_exit);
-
-MODULE_AUTHOR("Alan Cox");
-MODULE_DESCRIPTION("SCSI low-level driver for Radisys R82600 controllers");
-MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(pci, radisys_pci_tbl);
-MODULE_VERSION(DRV_VERSION);
-
-- 
1.7.1

