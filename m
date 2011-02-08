Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab1BHMZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:25:47 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48060 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab1BHMZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:25:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tRJ/SuxzvoOvvaylEDglks6NQUzSopcaamBYtezklsxBsuKgmH8vz4qg0a5PzsXZFA
         iRlVZvBTYeZM9b0EYW9jLOiXeLkZh7AuNfYFYzHzUIUqOvh8kSm/HBVtajNdEtUyIMj1
         U47LsXQLgeoEi13Uk47EltnUThS0+Pl8tR05U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:25:34 +0100
Message-Id: <20110208122534.19110.89437.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCH 16/20] ata_piix: add EFAR SLC90E66 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 11bed7feff5de752c9440ca58b232846b20e2ed6 Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 8 Feb 2011 12:39:28 +0100
Subject: [PATCH 16/20] ata_piix: add EFAR SLC90E66 support

Add EFAR SLC90E66 support to ata_piix and remove no longer
needed pata_efar driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/Kconfig     |    1 +
 drivers/ata/Makefile    |    1 -
 drivers/ata/ata_piix.c  |   74 ++++++++++--
 drivers/ata/pata_efar.c |  292 -----------------------------------------------
 4 files changed, 65 insertions(+), 303 deletions(-)
 delete mode 100644 drivers/ata/pata_efar.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 36e2319..402c90c 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -375,6 +375,7 @@ config PATA_CYPRESS
 config PATA_EFAR
 	tristate "EFAR SLC90E66 support"
 	depends on PCI
+	select ATA_PIIX
 	help
 	  This option enables support for the EFAR SLC90E66
 	  IDE controller found on some older machines.
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 2b67c90..b4252bc 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -40,7 +40,6 @@ obj-$(CONFIG_PATA_CS5530)	+= pata_cs5530.o
 obj-$(CONFIG_PATA_CS5535)	+= pata_cs5535.o
 obj-$(CONFIG_PATA_CS5536)	+= pata_cs5536.o
 obj-$(CONFIG_PATA_CYPRESS)	+= pata_cypress.o
-obj-$(CONFIG_PATA_EFAR)		+= pata_efar.o
 obj-$(CONFIG_PATA_HPT366)	+= pata_hpt366.o
 obj-$(CONFIG_PATA_HPT37X)	+= pata_hpt37x.o
 obj-$(CONFIG_PATA_HPT3X2N)	+= pata_hpt3x2n.o
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index c954f91..3ce77d3 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -6,6 +6,7 @@
  *		    on emails.
  *
  *
+ *	Copyright 2009-2011 Bartlomiej Zolnierkiewicz
  *	Copyright 2003-2005 Red Hat Inc
  *	Copyright 2003-2005 Jeff Garzik
  *
@@ -81,6 +82,10 @@
  *	ICH3    errata #15      - IDE deadlock under high load
  *				  (BIOS must set dev 31 fn 0 bit 23)
  *	ICH3	errata #18	- Don't use native mode
+ *
+ *    EFAR - a PIIX4 clone with UDMA66 support. Unlike the later
+ *    Intel ICH controllers the EFAR widened the UDMA mode register bits
+ *    and doesn't require the funky clock selection.
  */
 
 #include <linux/kernel.h>
@@ -139,6 +144,7 @@ enum piix_controller_ids {
 	ich_pata_66,		/* ICH up to 66 Mhz */
 	ich_pata_100,		/* ICH up to UDMA 100 */
 	ich_pata_100_nomwdma1,	/* ICH up to UDMA 100 but with no MWDMA1*/
+	efar_pata,
 	ich5_sata,
 	ich6_sata,
 	ich6m_sata,
@@ -169,6 +175,7 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev);
 static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static int ich_pata_cable_detect(struct ata_port *ap);
+static int efar_pata_cable_detect(struct ata_port *ap);
 static u8 piix_vmw_bmdma_status(struct ata_port *ap);
 static int piix_sidpr_scr_read(struct ata_link *link,
 			       unsigned int reg, u32 *val);
@@ -229,6 +236,9 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* ICH8 Mobile PATA Controller */
 	{ 0x8086, 0x2850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 
+	/* EFAR */
+	{ 0x1055, 0x9130, PCI_ANY_ID, PCI_ANY_ID, 0, 0, efar_pata },
+
 	/* SATA ports */
 	
 	/* 82801EB (ICH5) */
@@ -369,6 +379,14 @@ static struct ata_port_operations piix_sidpr_sata_ops = {
 	.set_lpm		= piix_sidpr_set_lpm,
 };
 
+static struct ata_port_operations efar_pata_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+	.set_piomode		= piix_set_piomode,
+	.set_dmamode		= piix_set_dmamode,
+	.prereset		= piix_pata_prereset,
+	.cable_detect		= efar_pata_cable_detect,
+};
+
 static const struct piix_map_db ich5_map_db = {
 	.mask = 0x7,
 	.port_enable = 0x3,
@@ -598,6 +616,14 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_vmw_ops,
 	},
 
+	[efar_pata] =
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.udma_mask	= ATA_UDMA4,
+		.port_ops	= &efar_pata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {
@@ -610,6 +636,7 @@ MODULE_DESCRIPTION("SCSI low-level driver for Intel PIIX/ICH ATA controllers");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("pata_efar");
 
 struct ich_laptop {
 	u16 device;
@@ -677,6 +704,25 @@ static int ich_pata_cable_detect(struct ata_port *ap)
 }
 
 /**
+ *	efar_pata_cable_detect	-	check for 40/80 pin
+ *	@ap: Port
+ *
+ *	Perform cable detection for the EFAR ATA interface. This is
+ *	different to the PIIX arrangement
+ */
+
+static int efar_pata_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 tmp;
+
+	pci_read_config_byte(pdev, 0x47, &tmp);
+	if (tmp & (2 >> ap->port_no))
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
+}
+
+/**
  *	piix_pata_prereset - prereset for PATA host controller
  *	@link: Target link
  *	@deadline: deadline jiffies for the operation
@@ -797,12 +843,12 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
- *	do_pata_set_dmamode - Initialize host controller PATA PIO timings
+ *	do_pata_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Drive in question
  *	@isich: set if the chip is an ICH device
  *
- *	Set UDMA mode for device, in host controller PCI config space.
+ *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
  *
  *	LOCKING:
  *	None (inherited from caller).
@@ -843,10 +889,16 @@ static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, in
 
 		udma_enable |= (1 << devid);
 
-		/* Load the CT/RP selection */
 		pci_read_config_word(dev, 0x4A, &udma_timing);
-		udma_timing &= ~(3 << (4 * devid));
-		udma_timing |= u_speed << (4 * devid);
+		if (dev->vendor == PCI_VENDOR_ID_EFAR) {
+			/* Load the UDMA mode number */
+			udma_timing &= ~(7 << (4 * devid));
+			udma_timing |= udma << (4 * devid);
+		} else {
+			/* Load the CT/RP selection */
+			udma_timing &= ~(3 << (4 * devid));
+			udma_timing |= u_speed << (4 * devid);
+		}
 		pci_write_config_word(dev, 0x4A, udma_timing);
 
 		if (isich) {
@@ -877,7 +929,7 @@ static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, in
 /**
  *	piix_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
- *	@adev: um
+ *	@adev: Device to program
  *
  *	Set MW/UDMA mode for device, in host controller PCI config space.
  *
@@ -893,7 +945,7 @@ static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 /**
  *	ich_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
- *	@adev: um
+ *	@adev: Device to program
  *
  *	Set MW/UDMA mode for device, in host controller PCI config space.
  *
@@ -1561,7 +1613,8 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	 * because some ACPI implementations mess up cable related
 	 * bits on _STM.  Reported on kernel bz#11879.
 	 */
-	pci_read_config_dword(pdev, PIIX_IOCFG, &hpriv->saved_iocfg);
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL)
+		pci_read_config_dword(pdev, PIIX_IOCFG, &hpriv->saved_iocfg);
 
 	/* ICH6R may be driven by either ata_piix or ahci driver
 	 * regardless of BIOS configuration.  Make sure AHCI mode is
@@ -1625,7 +1678,8 @@ static void piix_remove_one(struct pci_dev *pdev)
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	struct piix_host_priv *hpriv = host->private_data;
 
-	pci_write_config_dword(pdev, PIIX_IOCFG, hpriv->saved_iocfg);
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL)
+		pci_write_config_dword(pdev, PIIX_IOCFG, hpriv->saved_iocfg);
 
 	ata_pci_remove_one(pdev);
 }
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
deleted file mode 100644
index 7f564d7..0000000
--- a/drivers/ata/pata_efar.c
+++ /dev/null
@@ -1,292 +0,0 @@
-/*
- *    pata_efar.c - EFAR PIIX clone controller driver
- *
- *	(C) 2005 Red Hat
- *	(C) 2009-2010 Bartlomiej Zolnierkiewicz
- *
- *    Some parts based on ata_piix.c by Jeff Garzik and others.
- *
- *    The EFAR is a PIIX4 clone with UDMA66 support. Unlike the later
- *    Intel ICH controllers the EFAR widened the UDMA mode register bits
- *    and doesn't require the funky clock selection.
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
-#define DRV_NAME	"pata_efar"
-#define DRV_VERSION	"0.4.5"
-
-/**
- *	efar_pre_reset	-	Enable bits
- *	@link: ATA link
- *	@deadline: deadline jiffies for the operation
- *
- *	Perform cable detection for the EFAR ATA interface. This is
- *	different to the PIIX arrangement
- */
-
-static int efar_pre_reset(struct ata_link *link, unsigned long deadline)
-{
-	static const struct pci_bits efar_enable_bits[] = {
-		{ 0x41U, 1U, 0x80UL, 0x80UL },	/* port 0 */
-		{ 0x43U, 1U, 0x80UL, 0x80UL },	/* port 1 */
-	};
-	struct ata_port *ap = link->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-	if (!pci_test_config_bits(pdev, &efar_enable_bits[ap->port_no]))
-		return -ENOENT;
-
-	return ata_sff_prereset(link, deadline);
-}
-
-/**
- *	efar_cable_detect	-	check for 40/80 pin
- *	@ap: Port
- *
- *	Perform cable detection for the EFAR ATA interface. This is
- *	different to the PIIX arrangement
- */
-
-static int efar_cable_detect(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 tmp;
-
-	pci_read_config_byte(pdev, 0x47, &tmp);
-	if (tmp & (2 >> ap->port_no))
-		return ATA_CBL_PATA40;
-	return ATA_CBL_PATA80;
-}
-
-static DEFINE_SPINLOCK(efar_lock);
-
-static void efar_set_timings(struct ata_port *ap, struct ata_device *adev,
-			     u8 pio, bool use_mwdma)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	unsigned int is_slave	= (adev->devno != 0);
-	unsigned long flags;
-	u8 master_port		= ap->port_no ? 0x42 : 0x40;
-	u16 master_data;
-	u8 udma_enable;
-	u8 slave_data;
-	int control = 0;
-
-	/*
-	 *	See Intel Document 298600-004 for the timing programing rules
-	 *	for PIIX/ICH. The EFAR is a clone so very similar
-	 */
-
-	static const	 /* ISP  RTC */
-	u8 timings[][2]	= { { 0, 0 },
-			    { 0, 0 },
-			    { 1, 0 },
-			    { 2, 1 },
-			    { 2, 3 }, };
-
-	if (pio > 1 || use_mwdma)
-		control |= 1;	/* TIME */
-	if (ata_pio_need_iordy(adev) || use_mwdma)
-		control |= 2;	/* IE */
-	/* Intel specifies that the prefetch/posting is for disk only */
-	if (adev->class == ATA_DEV_ATA)
-		control |= 4;	/* PPE */
-	/* If the drive MWDMA is faster than it can do PIO then
-	   we must force PIO into PIO0 */
-	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
-		/* Enable DMA timing only */
-		control |= 8;	/* PIO cycles in PIO0 */
-
-	spin_lock_irqsave(&efar_lock, flags);
-
-	pci_read_config_word(dev, master_port, &master_data);
-
-	/* Set PPE, IE, and TIME as appropriate */
-	if (is_slave == 0) {
-		master_data &= 0xCCF0;
-		master_data |= control;
-		master_data |= (timings[pio][0] << 12) |
-			(timings[pio][1] << 8);
-	} else {
-		int shift = 4 * ap->port_no;
-
-		master_data &= 0xFF0F;
-		master_data |= (control << 4);
-
-		/* Slave timing in separate register */
-		pci_read_config_byte(dev, 0x44, &slave_data);
-		slave_data &= ap->port_no ? 0x0F : 0xF0;
-		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << shift;
-	}
-
-	master_data |= 0x4000;	/* Ensure SITRE is set */
-	pci_write_config_word(dev, master_port, master_data);
-
-	if (is_slave)
-		pci_write_config_byte(dev, 0x44, slave_data);
-
-	pci_read_config_byte(dev, 0x48, &udma_enable);
-	udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
-	pci_write_config_byte(dev, 0x48, udma_enable);
-	spin_unlock_irqrestore(&efar_lock, flags);
-}
-
-/**
- *	efar_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device to program
- *
- *	Set PIO mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void efar_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	efar_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
-}
-
-/**
- *	efar_set_dmamode - Initialize host controller PATA DMA timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device to program
- *
- *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	u8 speed		= adev->dma_mode;
-	int devid		= adev->devno + 2 * ap->port_no;
-	unsigned long flags;
-	u8 udma_enable;
-
-	if (speed >= XFER_UDMA_0) {
-		unsigned int udma = speed - XFER_UDMA_0;
-		u16 udma_timing;
-
-		spin_lock_irqsave(&efar_lock, flags);
-
-		pci_read_config_byte(dev, 0x48, &udma_enable);
-
-		udma_enable |= (1 << devid);
-
-		/* Load the UDMA mode number */
-		pci_read_config_word(dev, 0x4A, &udma_timing);
-		udma_timing &= ~(7 << (4 * devid));
-		udma_timing |= udma << (4 * devid);
-		pci_write_config_word(dev, 0x4A, udma_timing);
-
-		pci_write_config_byte(dev, 0x48, udma_enable);
-
-		spin_unlock_irqrestore(&efar_lock, flags);
-	} else {
-		/* MWDMA is driven by the PIO timings. */
-		unsigned int mwdma = speed - XFER_MW_DMA_0;
-		const unsigned int needed_pio[3] = {
-			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
-		};
-		int pio = needed_pio[mwdma] - XFER_PIO_0;
-
-		efar_set_timings(ap, adev, pio, 1);
-	}
-}
-
-static struct scsi_host_template efar_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
-};
-
-static struct ata_port_operations efar_ops = {
-	.inherits		= &ata_bmdma_port_ops,
-	.cable_detect		= efar_cable_detect,
-	.set_piomode		= efar_set_piomode,
-	.set_dmamode		= efar_set_dmamode,
-	.prereset		= efar_pre_reset,
-};
-
-
-/**
- *	efar_init_one - Register EFAR ATA PCI device with kernel services
- *	@pdev: PCI device to register
- *	@ent: Entry in efar_pci_tbl matching with @pdev
- *
- *	Called from kernel PCI layer.
- *
- *	LOCKING:
- *	Inherited from PCI layer (may sleep).
- *
- *	RETURNS:
- *	Zero on success, or -ERRNO value.
- */
-
-static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
-{
-	static int printed_version;
-	static const struct ata_port_info info = {
-		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY,
-		.udma_mask 	= ATA_UDMA4,
-		.port_ops	= &efar_ops,
-	};
-	const struct ata_port_info *ppi[] = { &info, &info };
-
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
-
-	return ata_pci_bmdma_init_one(pdev, ppi, &efar_sht, NULL,
-				      ATA_HOST_PARALLEL_SCAN);
-}
-
-static const struct pci_device_id efar_pci_tbl[] = {
-	{ PCI_VDEVICE(EFAR, 0x9130), },
-
-	{ }	/* terminate list */
-};
-
-static struct pci_driver efar_pci_driver = {
-	.name			= DRV_NAME,
-	.id_table		= efar_pci_tbl,
-	.probe			= efar_init_one,
-	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
-	.suspend		= ata_pci_device_suspend,
-	.resume			= ata_pci_device_resume,
-#endif
-};
-
-static int __init efar_init(void)
-{
-	return pci_register_driver(&efar_pci_driver);
-}
-
-static void __exit efar_exit(void)
-{
-	pci_unregister_driver(&efar_pci_driver);
-}
-
-module_init(efar_init);
-module_exit(efar_exit);
-
-MODULE_AUTHOR("Alan Cox");
-MODULE_DESCRIPTION("SCSI low-level driver for EFAR PIIX clones");
-MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(pci, efar_pci_tbl);
-MODULE_VERSION(DRV_VERSION);
-
-- 
1.7.1

