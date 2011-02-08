Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1BHMZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:25:54 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61026 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab1BHMZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:25:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ryz8ZneqT4ZthUVdB8ytoGj57Z50iGUbTbr11iEwUewYZ1HfY3IABQkH2L7R3IknvG
         24LpLja1pp6wZG/0KK3hMj4XwjFAqkGMQYk90zbHZtFhI2pMkDF9kO50DBZ6pgkSYnub
         ZU+kkejwj4B3I5UvqKavK3OO8E0V+TI0BbLGc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:25:42 +0100
Message-Id: <20110208122542.19110.63060.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCH 17/20] ata_piix: add IT8213 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ecf383059c866b4ab646a4bf1fae4abe4fade58a Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 8 Feb 2011 12:39:28 +0100
Subject: [PATCH 17/20] ata_piix: add IT8213 support

Add IT8213 support to ata_piix and remove no longer
needed pata_it8213 driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/Kconfig       |    1 +
 drivers/ata/Makefile      |    1 -
 drivers/ata/ata_piix.c    |   65 ++++++++++-
 drivers/ata/pata_it8213.c |  284 ---------------------------------------------
 4 files changed, 62 insertions(+), 289 deletions(-)
 delete mode 100644 drivers/ata/pata_it8213.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 402c90c..5a92f24 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -437,6 +437,7 @@ config PATA_ICSIDE
 config PATA_IT8213
 	tristate "IT8213 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	select ATA_PIIX
 	help
 	  This option enables support for the ITE 821 PATA
           controllers via the new ATA layer.
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index b4252bc..7e78491 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -45,7 +45,6 @@ obj-$(CONFIG_PATA_HPT37X)	+= pata_hpt37x.o
 obj-$(CONFIG_PATA_HPT3X2N)	+= pata_hpt3x2n.o
 obj-$(CONFIG_PATA_HPT3X3)	+= pata_hpt3x3.o
 obj-$(CONFIG_PATA_ICSIDE)	+= pata_icside.o
-obj-$(CONFIG_PATA_IT8213)	+= pata_it8213.o
 obj-$(CONFIG_PATA_IT821X)	+= pata_it821x.o
 obj-$(CONFIG_PATA_JMICRON)	+= pata_jmicron.o
 obj-$(CONFIG_PATA_MACIO)	+= pata_macio.o
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 3ce77d3..deb7c96 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -86,6 +86,11 @@
  *    EFAR - a PIIX4 clone with UDMA66 support. Unlike the later
  *    Intel ICH controllers the EFAR widened the UDMA mode register bits
  *    and doesn't require the funky clock selection.
+ *
+ *    IT8213 - a very Intel ICH like device for timing purposes, having
+ *    a similar register layout and the same split clock arrangement. Cable
+ *    detection is different, and it does not have slave channels or all the
+ *    clutter of later ICH/SATA setups.
  */
 
 #include <linux/kernel.h>
@@ -145,6 +150,7 @@ enum piix_controller_ids {
 	ich_pata_100,		/* ICH up to UDMA 100 */
 	ich_pata_100_nomwdma1,	/* ICH up to UDMA 100 but with no MWDMA1*/
 	efar_pata,
+	it8213_pata,
 	ich5_sata,
 	ich6_sata,
 	ich6m_sata,
@@ -176,6 +182,7 @@ static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static int ich_pata_cable_detect(struct ata_port *ap);
 static int efar_pata_cable_detect(struct ata_port *ap);
+static int it8213_pata_cable_detect(struct ata_port *ap);
 static u8 piix_vmw_bmdma_status(struct ata_port *ap);
 static int piix_sidpr_scr_read(struct ata_link *link,
 			       unsigned int reg, u32 *val);
@@ -239,6 +246,9 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* EFAR */
 	{ 0x1055, 0x9130, PCI_ANY_ID, PCI_ANY_ID, 0, 0, efar_pata },
 
+	/* IT8213 */
+	{ 0x1283, 0x8213, PCI_ANY_ID, PCI_ANY_ID, 0, 0, it8213_pata },
+
 	/* SATA ports */
 	
 	/* 82801EB (ICH5) */
@@ -387,6 +397,14 @@ static struct ata_port_operations efar_pata_ops = {
 	.cable_detect		= efar_pata_cable_detect,
 };
 
+static struct ata_port_operations it8213_pata_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+	.set_piomode		= piix_set_piomode,
+	.set_dmamode		= ich_set_dmamode,
+	.prereset		= piix_pata_prereset,
+	.cable_detect		= it8213_pata_cable_detect,
+};
+
 static const struct piix_map_db ich5_map_db = {
 	.mask = 0x7,
 	.port_enable = 0x3,
@@ -624,6 +642,15 @@ static struct ata_port_info piix_port_info[] = {
 		.udma_mask	= ATA_UDMA4,
 		.port_ops	= &efar_pata_ops,
 	},
+
+	[it8213_pata] =
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &it8213_pata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {
@@ -637,6 +664,7 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("pata_efar");
+MODULE_ALIAS("pata_it8213");
 
 struct ich_laptop {
 	u16 device;
@@ -723,6 +751,25 @@ static int efar_pata_cable_detect(struct ata_port *ap)
 }
 
 /**
+ *	it8213_pata_cable_detect	-	check for 40/80 pin
+ *	@ap: Port
+ *
+ *	Perform cable detection for the 8213 ATA interface. This is
+ *	different to the PIIX arrangement
+ */
+
+static int it8213_pata_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 tmp;
+
+	pci_read_config_byte(pdev, 0x42, &tmp);
+	if (tmp & 2)	/* The initial docs are incorrect */
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
+}
+
+/**
  *	piix_pata_prereset - prereset for PATA host controller
  *	@link: Target link
  *	@deadline: deadline jiffies for the operation
@@ -771,9 +818,15 @@ static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
 		control |= 1;	/* TIME1 enable */
 	if (ata_pio_need_iordy(adev) || use_mwdma)
 		control |= 2;	/* IE enable */
-	/* Intel specifies that the PPE functionality is for disk only */
-	if (adev->class == ATA_DEV_ATA)
-		control |= 4;	/* PPE enable */
+	if (dev->vendor != PCI_VENDOR_ID_ITE) {
+		/* PPE functionality is for disk only */
+		if (adev->class == ATA_DEV_ATA)
+			control |= 4;	/* PPE enable */
+	} else {
+		/* Bit 2 is set for ATAPI on the IT8213 - reverse of ICH/PIIX */
+		if (adev->class != ATA_DEV_ATA)
+			control |= 4;	/* PPE enable */
+	}
 	/* If the drive MWDMA is faster than it can do PIO then
 	   we must force PIO into PIO0 */
 	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
@@ -880,7 +933,7 @@ static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, in
 		 *	       except UDMA0 which is 00
 		 */
 		u_speed = min(2 - (udma & 1), udma);
-		if (udma == 5)
+		if (udma > 4)
 			u_clock = 0x1000;	/* 100Mhz */
 		else if (udma > 2)
 			u_clock = 1;		/* 66Mhz */
@@ -1597,6 +1650,10 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	port_info[0] = piix_port_info[ent->driver_data];
 	port_info[1] = piix_port_info[ent->driver_data];
 
+	/* IT8213 is a single port device. */
+	if (pdev->vendor == PCI_VENDOR_ID_ITE)
+		port_info[1] = ata_dummy_port_info;
+
 	port_flags = port_info[0].flags;
 
 	/* enable device and prepare host */
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
deleted file mode 100644
index e045eab..0000000
--- a/drivers/ata/pata_it8213.c
+++ /dev/null
@@ -1,284 +0,0 @@
-/*
- *    pata_it8213.c - iTE Tech. Inc.  IT8213 PATA driver
- *
- *    The IT8213 is a very Intel ICH like device for timing purposes, having
- *    a similar register layout and the same split clock arrangement. Cable
- *    detection is different, and it does not have slave channels or all the
- *    clutter of later ICH/SATA setups.
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
-#define DRV_NAME	"pata_it8213"
-#define DRV_VERSION	"0.0.3"
-
-/**
- *	it8213_pre_reset	-	probe begin
- *	@link: link
- *	@deadline: deadline jiffies for the operation
- *
- *	Filter out ports by the enable bits before doing the normal reset
- *	and probe.
- */
-
-static int it8213_pre_reset(struct ata_link *link, unsigned long deadline)
-{
-	static const struct pci_bits it8213_enable_bits[] = {
-		{ 0x41U, 1U, 0x80UL, 0x80UL },	/* port 0 */
-	};
-	struct ata_port *ap = link->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	if (!pci_test_config_bits(pdev, &it8213_enable_bits[ap->port_no]))
-		return -ENOENT;
-
-	return ata_sff_prereset(link, deadline);
-}
-
-/**
- *	it8213_cable_detect	-	check for 40/80 pin
- *	@ap: Port
- *
- *	Perform cable detection for the 8213 ATA interface. This is
- *	different to the PIIX arrangement
- */
-
-static int it8213_cable_detect(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 tmp;
-	pci_read_config_byte(pdev, 0x42, &tmp);
-	if (tmp & 2)	/* The initial docs are incorrect */
-		return ATA_CBL_PATA40;
-	return ATA_CBL_PATA80;
-}
-
-static void it8213_set_timings(struct ata_port *ap, struct ata_device *adev,
-			       u8 pio, bool use_mwdma)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	u8 master_port		= ap->port_no ? 0x42 : 0x40;
-	u16 master_data;
-	int control = 0;
-
-	/*
-	 *	See Intel Document 298600-004 for the timing programing rules
-	 *	for PIIX/ICH. The 8213 is a clone so very similar
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
-	/* Bit 2 is set for ATAPI on the IT8213 - reverse of ICH/PIIX */
-	if (adev->class != ATA_DEV_ATA)
-		control |= 4;	/* PPE */
-	/* If the drive MWDMA is faster than it can do PIO then
-	   we must force PIO into PIO0 */
-	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
-		/* Enable DMA timing only */
-		control |= 8;	/* PIO cycles in PIO0 */
-
-	pci_read_config_word(dev, master_port, &master_data);
-
-	/* Set PPE, IE, and TIME as appropriate */
-	if (adev->devno == 0) {
-		master_data &= 0xCCF0;
-		master_data |= control;
-		master_data |= (timings[pio][0] << 12) |
-			(timings[pio][1] << 8);
-	} else {
-		u8 slave_data;
-
-		master_data &= 0xFF0F;
-		master_data |= (control << 4);
-
-		/* Slave timing in separate register */
-		pci_read_config_byte(dev, 0x44, &slave_data);
-		slave_data &= 0xF0;
-		slave_data |= (timings[pio][0] << 2) | timings[pio][1];
-		pci_write_config_byte(dev, 0x44, slave_data);
-	}
-
-	master_data |= 0x4000;	/* Ensure SITRE is set */
-	pci_write_config_word(dev, master_port, master_data);
-}
-
-/**
- *	it8213_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device whose timings we are configuring
- *
- *	Set PIO mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void it8213_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	it8213_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
-}
-
-/**
- *	it8213_set_dmamode - Initialize host controller PATA DMA timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device to program
- *
- *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
- *	This device is basically an ICH alike.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void it8213_set_dmamode (struct ata_port *ap, struct ata_device *adev)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	u8 speed		= adev->dma_mode;
-	int devid		= adev->devno;
-	u8 udma_enable;
-
-	pci_read_config_byte(dev, 0x48, &udma_enable);
-
-	if (speed >= XFER_UDMA_0) {
-		unsigned int udma = speed - XFER_UDMA_0;
-		u16 udma_timing;
-		u16 ideconf;
-		int u_clock, u_speed;
-
-		/* Clocks follow the PIIX style */
-		u_speed = min(2 - (udma & 1), udma);
-		if (udma > 4)
-			u_clock = 0x1000;	/* 100Mhz */
-		else if (udma > 2)
-			u_clock = 1;		/* 66Mhz */
-		else
-			u_clock = 0;		/* 33Mhz */
-
-		udma_enable |= (1 << devid);
-
-		/* Load the UDMA cycle time */
-		pci_read_config_word(dev, 0x4A, &udma_timing);
-		udma_timing &= ~(3 << (4 * devid));
-		udma_timing |= u_speed << (4 * devid);
-		pci_write_config_word(dev, 0x4A, udma_timing);
-
-		/* Load the clock selection */
-		pci_read_config_word(dev, 0x54, &ideconf);
-		ideconf &= ~(0x1001 << devid);
-		ideconf |= u_clock << devid;
-		pci_write_config_word(dev, 0x54, ideconf);
-	} else {
-		/* MWDMA is driven by the PIO timings. */
-		unsigned int mwdma = speed - XFER_MW_DMA_0;
-		static const unsigned int needed_pio[3] = {
-			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
-		};
-		int pio = needed_pio[mwdma] - XFER_PIO_0;
-
-		it8213_set_timings(ap, adev, pio, 1);
-
-		udma_enable &= ~(1 << devid);
-	}
-	pci_write_config_byte(dev, 0x48, udma_enable);
-}
-
-static struct scsi_host_template it8213_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
-};
-
-
-static struct ata_port_operations it8213_ops = {
-	.inherits		= &ata_bmdma_port_ops,
-	.cable_detect		= it8213_cable_detect,
-	.set_piomode		= it8213_set_piomode,
-	.set_dmamode		= it8213_set_dmamode,
-	.prereset		= it8213_pre_reset,
-};
-
-
-/**
- *	it8213_init_one - Register 8213 ATA PCI device with kernel services
- *	@pdev: PCI device to register
- *	@ent: Entry in it8213_pci_tbl matching with @pdev
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
-static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
-{
-	static int printed_version;
-	static const struct ata_port_info info = {
-		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &it8213_ops,
-	};
-	/* Current IT8213 stuff is single port */
-	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
-
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
-
-	return ata_pci_bmdma_init_one(pdev, ppi, &it8213_sht, NULL, 0);
-}
-
-static const struct pci_device_id it8213_pci_tbl[] = {
-	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8213), },
-
-	{ }	/* terminate list */
-};
-
-static struct pci_driver it8213_pci_driver = {
-	.name			= DRV_NAME,
-	.id_table		= it8213_pci_tbl,
-	.probe			= it8213_init_one,
-	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
-	.suspend		= ata_pci_device_suspend,
-	.resume			= ata_pci_device_resume,
-#endif
-};
-
-static int __init it8213_init(void)
-{
-	return pci_register_driver(&it8213_pci_driver);
-}
-
-static void __exit it8213_exit(void)
-{
-	pci_unregister_driver(&it8213_pci_driver);
-}
-
-module_init(it8213_init);
-module_exit(it8213_exit);
-
-MODULE_AUTHOR("Alan Cox");
-MODULE_DESCRIPTION("SCSI low-level driver for the ITE 8213");
-MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(pci, it8213_pci_tbl);
-MODULE_VERSION(DRV_VERSION);
-- 
1.7.1

