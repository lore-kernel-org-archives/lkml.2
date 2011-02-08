Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab1BHM0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:26:15 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61026 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab1BHM0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:26:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=JhL9CJ+vULxGx0APfxgnsm9fevRLk0EUl/ldezrDmhoTbjsJ5S0H4jjQEjsEHs/2os
         iazqWXO1LAyMgFe5FAtgo9tWLOb37J3s+32tXQLtywVG3rsCotdRlSaPySeJo4UDuwzd
         osds856f9iT1dbIh5Fl33HyzDWPlQ+IDjuK24=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:25:57 +0100
Message-Id: <20110208122557.19110.50743.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCH 19/20] ata_piix: add Intel old PIIX support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From dc3181ebc3a8735bcd6ba334f2ad7945654e1189 Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 8 Feb 2011 12:39:28 +0100
Subject: [PATCH 19/20] ata_piix: add Intel old PIIX support

Add Intel old PIIX support to ata_piix and remove no longer
needed pata_oldpiix driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/Kconfig        |    1 +
 drivers/ata/Makefile       |    1 -
 drivers/ata/ata_piix.c     |   86 +++++++++++++--
 drivers/ata/pata_oldpiix.c |  264 --------------------------------------------
 4 files changed, 78 insertions(+), 274 deletions(-)
 delete mode 100644 drivers/ata/pata_oldpiix.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index dc9038d..0e6d193 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -523,6 +523,7 @@ config PATA_NS87415
 config PATA_OLDPIIX
 	tristate "Intel PATA old PIIX support"
 	depends on PCI
+	select ATA_PIIX
 	help
 	  This option enables support for early PIIX PATA support.
 
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index e627f6d..55272af 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -53,7 +53,6 @@ obj-$(CONFIG_PATA_MPC52xx)	+= pata_mpc52xx.o
 obj-$(CONFIG_PATA_NETCELL)	+= pata_netcell.o
 obj-$(CONFIG_PATA_NINJA32)	+= pata_ninja32.o
 obj-$(CONFIG_PATA_NS87415)	+= pata_ns87415.o
-obj-$(CONFIG_PATA_OLDPIIX)	+= pata_oldpiix.o
 obj-$(CONFIG_PATA_OPTIDMA)	+= pata_optidma.o
 obj-$(CONFIG_PATA_PDC2027X)	+= pata_pdc2027x.o
 obj-$(CONFIG_PATA_PDC_OLD)	+= pata_pdc202xx_old.o
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 86d12c2..5afa57a 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -52,8 +52,8 @@
  * is fixed in Triton II. With the odd mobile exception the chips then
  * change little except in gaining more modes until SATA arrives. This
  * driver supports only the chips with independant timing (that is those
- * with SITRE and the 0x44 timing register). See pata_oldpiix and pata_mpiix
- * for the early chip drivers.
+ * with SITRE and the 0x44 timing register). See pata_mpiix for the very
+ * early chip support.
  *
  * Errata of note:
  *
@@ -94,6 +94,11 @@
  *    a similar register layout and the same split clock arrangement. Cable
  *    detection is different, and it does not have slave channels or all the
  *    clutter of later ICH/SATA setups.
+ *
+ *    Early PIIX differs significantly from the later PIIX as it lacks
+ *    SITRE and the slave timing registers. This means that you have to
+ *    set timing per channel, or be clever. Libata tells us whenever it
+ *    does drive selection and we use this to reload the timings.
  */
 
 #include <linux/kernel.h>
@@ -154,6 +159,7 @@ enum piix_controller_ids {
 	ich_pata_100_nomwdma1,	/* ICH up to UDMA 100 but with no MWDMA1*/
 	efar_pata,
 	it8213_pata,
+	oldpiix_pata,
 	ich5_sata,
 	ich6_sata,
 	ich6m_sata,
@@ -186,6 +192,7 @@ static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static int ich_pata_cable_detect(struct ata_port *ap);
 static int efar_pata_cable_detect(struct ata_port *ap);
 static int it8213_pata_cable_detect(struct ata_port *ap);
+static unsigned int oldpiix_qc_issue(struct ata_queued_cmd *qc);
 static u8 piix_vmw_bmdma_status(struct ata_port *ap);
 static int piix_sidpr_scr_read(struct ata_link *link,
 			       unsigned int reg, u32 *val);
@@ -256,6 +263,9 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x17F3, 0x1011, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	{ 0x17F3, 0x1012, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 
+	/* PIIXb (a.k.a. oldpiix) */
+	{ 0x8086, 0x1230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, oldpiix_pata },
+
 	/* SATA ports */
 	
 	/* 82801EB (ICH5) */
@@ -412,6 +422,15 @@ static struct ata_port_operations it8213_pata_ops = {
 	.cable_detect		= it8213_pata_cable_detect,
 };
 
+static struct ata_port_operations oldpiix_pata_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+	.qc_issue		= oldpiix_qc_issue,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= piix_set_piomode,
+	.set_dmamode		= piix_set_dmamode,
+	.prereset		= piix_pata_prereset,
+};
+
 static const struct piix_map_db ich5_map_db = {
 	.mask = 0x7,
 	.port_enable = 0x3,
@@ -658,6 +677,14 @@ static struct ata_port_info piix_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &it8213_pata_ops,
 	},
+
+	[oldpiix_pata] =
+	{
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
+		.port_ops	= &oldpiix_pata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {
@@ -673,6 +700,7 @@ MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("pata_efar");
 MODULE_ALIAS("pata_it8213");
 MODULE_ALIAS("pata_rdc");
+MODULE_ALIAS("pata_oldpiix");
 
 struct ich_laptop {
 	u16 device;
@@ -803,6 +831,8 @@ static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	unsigned long flags;
 	unsigned int is_slave	= (adev->devno != 0);
+	unsigned int has_sitre	= (dev->vendor != 0x8086 ||
+				   dev->device != 0x1230);
 	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
 	unsigned int slave_port	= 0x44;
 	u16 master_data;
@@ -848,7 +878,7 @@ static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
 	 * after set_piomode if any DMA mode is available.
 	 */
 	pci_read_config_word(dev, master_port, &master_data);
-	if (is_slave) {
+	if (is_slave && has_sitre) {
 		/* clear TIME1|IE1|PPE1|DTE1 */
 		master_data &= 0xff0f;
 		/* enable PPE1, IE1 and TIME1 as needed */
@@ -859,10 +889,20 @@ static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
 		slave_data |= ((timings[pio][0] << 2) | timings[pio][1])
 						<< (ap->port_no ? 4 : 0);
 	} else {
-		/* clear ISP|RCT|TIME0|IE0|PPE0|DTE0 */
-		master_data &= 0xccf0;
-		/* Enable PPE, IE and TIME as appropriate */
-		master_data |= control;
+		if (has_sitre) {
+			/* clear ISP|RCT|TIME0|IE0|PPE0|DTE0 */
+			master_data &= 0xccf0;
+			/* Enable PPE, IE and TIME as appropriate */
+			master_data |= control;
+		} else {
+			if (!is_slave) {
+				master_data &= 0xCCE0;
+				master_data |= control;
+			} else {
+				master_data &= 0xCC0E;
+				master_data |= (control << 4);
+			}
+		}
 		/* load ISP and RCT */
 		master_data |=
 			(timings[pio][0] << 12) |
@@ -870,9 +910,10 @@ static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
 	}
 
 	/* Enable SITRE (separate slave timing register) */
-	master_data |= 0x4000;
+	if (has_sitre)
+		master_data |= 0x4000;
 	pci_write_config_word(dev, master_port, master_data);
-	if (is_slave)
+	if (is_slave && has_sitre)
 		pci_write_config_byte(dev, slave_port, slave_data);
 
 	/* Ensure the UDMA bit is off - it will be turned back on if
@@ -885,6 +926,9 @@ static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
 	}
 
 	spin_unlock_irqrestore(&piix_lock, flags);
+
+	/* Track which port is configured */
+	ap->private_data = adev;
 }
 
 /**
@@ -1019,6 +1063,30 @@ static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	do_pata_set_dmamode(ap, adev, 1);
 }
 
+/**
+ *	oldpiix_qc_issue	-	command issue
+ *	@qc: command pending
+ *
+ *	Called when the libata layer is about to issue a command. We wrap
+ *	this interface so that we can load the correct ATA timings if
+ *	necessary. Our logic also clears TIME0/TIME1 for the other device so
+ *	that, even if we get this wrong, cycles to the other device will
+ *	be made PIO0.
+ */
+
+static unsigned int oldpiix_qc_issue(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ata_device *adev = qc->dev;
+
+	if (adev != ap->private_data) {
+		piix_set_piomode(ap, adev);
+		if (ata_dma_enabled(adev))
+			piix_set_dmamode(ap, adev);
+	}
+	return ata_bmdma_qc_issue(qc);
+}
+
 /*
  * Serial ATA Index/Data Pair Superset Registers access
  *
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
deleted file mode 100644
index 819192d..0000000
--- a/drivers/ata/pata_oldpiix.c
+++ /dev/null
@@ -1,264 +0,0 @@
-/*
- *    pata_oldpiix.c - older Intel PATA controllers
- *
- *	(C) 2005 Red Hat
- *	(C) 2010 Bartlomiej Zolnierkiewicz
- *
- *    Some parts based on ata_piix.c by Jeff Garzik and others.
- *
- *    Early PIIX differs significantly from the later PIIX as it lacks
- *    SITRE and the slave timing registers. This means that you have to
- *    set timing per channel, or be clever. Libata tells us whenever it
- *    does drive selection and we use this to reload the timings.
- *
- *    Because of these behaviour differences PIIX gets its own driver module.
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
-#define DRV_NAME	"pata_oldpiix"
-#define DRV_VERSION	"0.5.5"
-
-/**
- *	oldpiix_pre_reset		-	probe begin
- *	@link: ATA link
- *	@deadline: deadline jiffies for the operation
- *
- *	Set up cable type and use generic probe init
- */
-
-static int oldpiix_pre_reset(struct ata_link *link, unsigned long deadline)
-{
-	struct ata_port *ap = link->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	static const struct pci_bits oldpiix_enable_bits[] = {
-		{ 0x41U, 1U, 0x80UL, 0x80UL },	/* port 0 */
-		{ 0x43U, 1U, 0x80UL, 0x80UL },	/* port 1 */
-	};
-
-	if (!pci_test_config_bits(pdev, &oldpiix_enable_bits[ap->port_no]))
-		return -ENOENT;
-
-	return ata_sff_prereset(link, deadline);
-}
-
-static DEFINE_SPINLOCK(piix_lock);
-
-static void oldpiix_set_timings(struct ata_port *ap, struct ata_device *adev,
-				u8 pio, bool use_mwdma)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	unsigned long flags;
-	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
-	u16 idetm_data;
-	int control = 0;
-
-	/*
-	 *	See Intel Document 298600-004 for the timing programing rules
-	 *	for PIIX/ICH. Note that the early PIIX does not have the slave
-	 *	timing port at 0x44.
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
-	spin_lock_irqsave(&piix_lock, flags);
-
-	pci_read_config_word(dev, idetm_port, &idetm_data);
-
-	/*
-	 * Set PPE, IE and TIME as appropriate.
-	 * Clear the other drive's timing bits.
-	 */
-	if (adev->devno == 0) {
-		idetm_data &= 0xCCE0;
-		idetm_data |= control;
-	} else {
-		idetm_data &= 0xCC0E;
-		idetm_data |= (control << 4);
-	}
-	idetm_data |= (timings[pio][0] << 12) |
-			(timings[pio][1] << 8);
-	pci_write_config_word(dev, idetm_port, idetm_data);
-
-	spin_unlock_irqrestore(&piix_lock, flags);
-
-	/* Track which port is configured */
-	ap->private_data = adev;
-}
-
-/**
- *	oldpiix_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device whose timings we are configuring
- *
- *	Set PIO mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void oldpiix_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	oldpiix_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
-}
-
-/**
- *	oldpiix_set_dmamode - Initialize host controller PATA DMA timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device to program
- *
- *	Set MWDMA mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void oldpiix_set_dmamode (struct ata_port *ap, struct ata_device *adev)
-{
-	/* MWDMA is driven by the PIO timings. */
-
-	unsigned int mwdma	= adev->dma_mode - XFER_MW_DMA_0;
-	const unsigned int needed_pio[3] = {
-		XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
-	};
-	int pio = needed_pio[mwdma] - XFER_PIO_0;
-
-	oldpiix_set_timings(ap, adev, pio, 1);
-}
-
-/**
- *	oldpiix_qc_issue	-	command issue
- *	@qc: command pending
- *
- *	Called when the libata layer is about to issue a command. We wrap
- *	this interface so that we can load the correct ATA timings if
- *	necessary. Our logic also clears TIME0/TIME1 for the other device so
- *	that, even if we get this wrong, cycles to the other device will
- *	be made PIO0.
- */
-
-static unsigned int oldpiix_qc_issue(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct ata_device *adev = qc->dev;
-
-	if (adev != ap->private_data) {
-		oldpiix_set_piomode(ap, adev);
-		if (ata_dma_enabled(adev))
-			oldpiix_set_dmamode(ap, adev);
-	}
-	return ata_bmdma_qc_issue(qc);
-}
-
-
-static struct scsi_host_template oldpiix_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
-};
-
-static struct ata_port_operations oldpiix_pata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
-	.qc_issue		= oldpiix_qc_issue,
-	.cable_detect		= ata_cable_40wire,
-	.set_piomode		= oldpiix_set_piomode,
-	.set_dmamode		= oldpiix_set_dmamode,
-	.prereset		= oldpiix_pre_reset,
-};
-
-
-/**
- *	oldpiix_init_one - Register PIIX ATA PCI device with kernel services
- *	@pdev: PCI device to register
- *	@ent: Entry in oldpiix_pci_tbl matching with @pdev
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
-static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
-{
-	static int printed_version;
-	static const struct ata_port_info info = {
-		.flags		= ATA_FLAG_SLAVE_POSS,
-		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA12_ONLY,
-		.port_ops	= &oldpiix_pata_ops,
-	};
-	const struct ata_port_info *ppi[] = { &info, NULL };
-
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			   "version " DRV_VERSION "\n");
-
-	return ata_pci_bmdma_init_one(pdev, ppi, &oldpiix_sht, NULL,
-				      ATA_HOST_PARALLEL_SCAN);
-}
-
-static const struct pci_device_id oldpiix_pci_tbl[] = {
-	{ PCI_VDEVICE(INTEL, 0x1230), },
-
-	{ }	/* terminate list */
-};
-
-static struct pci_driver oldpiix_pci_driver = {
-	.name			= DRV_NAME,
-	.id_table		= oldpiix_pci_tbl,
-	.probe			= oldpiix_init_one,
-	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
-	.suspend		= ata_pci_device_suspend,
-	.resume			= ata_pci_device_resume,
-#endif
-};
-
-static int __init oldpiix_init(void)
-{
-	return pci_register_driver(&oldpiix_pci_driver);
-}
-
-static void __exit oldpiix_exit(void)
-{
-	pci_unregister_driver(&oldpiix_pci_driver);
-}
-
-module_init(oldpiix_init);
-module_exit(oldpiix_exit);
-
-MODULE_AUTHOR("Alan Cox");
-MODULE_DESCRIPTION("SCSI low-level driver for early PIIX series controllers");
-MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(pci, oldpiix_pci_tbl);
-MODULE_VERSION(DRV_VERSION);
-
-- 
1.7.1

