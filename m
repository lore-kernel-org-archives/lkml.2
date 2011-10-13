Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1JMLSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:18:35 -0400
Received: from mail-dy0-f46.google.com ([209.85.220.46]:63132 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab1JMLRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:17:10 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_cs5536: forward port changes from cs5536
Date: Thu, 13 Oct 2011 13:05:24 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <mkp@mkp.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131305.25001.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5536: forward port changes from cs5536

* Fix cable detection to also account for the slave device cable bit.

* Disable UDMA when programming MWDMA in cs5536_set_dmamode().

* Don't change UDMA settings in cs5536_set_piomode().

* Add cs5536_program_dtc() helper.

* Cleanup and uninline cs5536_[read,write]() methods.

Cc: Martin K. Petersen <mkp@mkp.net>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5536.c |   99 +++++++++++++++++++---------------------------
 1 file changed, 42 insertions(+), 57 deletions(-)

Index: b/drivers/ata/pata_cs5536.c
===================================================================
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -1,6 +1,7 @@
 /*
  * pata_cs5536.c	- CS5536 PATA for new ATA layer
  *			  (C) 2007 Martin K. Petersen <mkp@mkp.net>
+ *			  (C) 2011 Bartlomiej Zolnierkiewicz
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -55,24 +56,16 @@ MODULE_PARM_DESC(msr, "Force using MSR t
 #define DRV_VERSION	"0.0.8"
 
 enum {
-	CFG			= 0,
-	DTC			= 1,
-	CAST			= 2,
-	ETC			= 3,
-
-	MSR_IDE_BASE		= 0x51300000,
-	MSR_IDE_CFG		= (MSR_IDE_BASE + 0x10),
-	MSR_IDE_DTC		= (MSR_IDE_BASE + 0x12),
-	MSR_IDE_CAST		= (MSR_IDE_BASE + 0x13),
-	MSR_IDE_ETC		= (MSR_IDE_BASE + 0x14),
-
+	MSR_IDE_CFG		= 0x51300010,
 	PCI_IDE_CFG		= 0x40,
-	PCI_IDE_DTC		= 0x48,
-	PCI_IDE_CAST		= 0x4c,
-	PCI_IDE_ETC		= 0x50,
 
-	IDE_CFG_CHANEN		= 0x2,
-	IDE_CFG_CABLE		= 0x10000,
+	CFG			= 0,
+	DTC			= 2,
+	CAST			= 3,
+	ETC			= 4,
+
+	IDE_CFG_CHANEN		= (1 << 1),
+	IDE_CFG_CABLE		= (1 << 17) | (1 << 16),
 
 	IDE_D0_SHIFT		= 24,
 	IDE_D1_SHIFT		= 16,
@@ -84,45 +77,50 @@ enum {
 	IDE_CAST_CMD_MASK	= 0xff,
 	IDE_CAST_CMD_SHIFT	= 24,
 
-	IDE_ETC_NODMA		= 0x03,
+	IDE_ETC_UDMA_MASK	= 0xc0,
 };
 
-static const u32 msr_reg[4] = {
-	MSR_IDE_CFG, MSR_IDE_DTC, MSR_IDE_CAST, MSR_IDE_ETC,
-};
-
-static const u8 pci_reg[4] = {
-	PCI_IDE_CFG, PCI_IDE_DTC, PCI_IDE_CAST, PCI_IDE_ETC,
-};
-
-static inline int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
+static int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
 {
 	if (unlikely(use_msr)) {
 		u32 dummy __maybe_unused;
 
-		rdmsr(msr_reg[reg], *val, dummy);
+		rdmsr(MSR_IDE_CFG + reg, *val, dummy);
 		return 0;
 	}
 
-	return pci_read_config_dword(pdev, pci_reg[reg], val);
+	return pci_read_config_dword(pdev, PCI_IDE_CFG + reg * 4, val);
 }
 
-static inline int cs5536_write(struct pci_dev *pdev, int reg, int val)
+static int cs5536_write(struct pci_dev *pdev, int reg, int val)
 {
 	if (unlikely(use_msr)) {
-		wrmsr(msr_reg[reg], val, 0);
+		wrmsr(MSR_IDE_CFG + reg, val, 0);
 		return 0;
 	}
 
-	return pci_write_config_dword(pdev, pci_reg[reg], val);
+	return pci_write_config_dword(pdev, PCI_IDE_CFG + reg * 4, val);
+}
+
+static void cs5536_program_dtc(struct ata_device *adev, u8 tim)
+{
+	struct pci_dev *pdev = to_pci_dev(adev->link->ap->host->dev);
+	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
+	u32 dtc;
+
+	cs5536_read(pdev, DTC, &dtc);
+	dtc &= ~(IDE_DRV_MASK << dshift);
+	dtc |= tim << dshift;
+	cs5536_write(pdev, DTC, dtc);
 }
 
 /**
  *	cs5536_cable_detect	-	detect cable type
  *	@ap: Port to detect on
  *
- *	Perform cable detection for ATA66 capable cable. Return a libata
- *	cable type.
+ *	Perform cable detection for ATA66 capable cable.
+ *
+ *	Returns a cable type.
  */
 
 static int cs5536_cable_detect(struct ata_port *ap)
@@ -132,7 +130,7 @@ static int cs5536_cable_detect(struct at
 
 	cs5536_read(pdev, CFG, &cfg);
 
-	if (cfg & (IDE_CFG_CABLE << ap->port_no))
+	if (cfg & IDE_CFG_CABLE)
 		return ATA_CBL_PATA80;
 	else
 		return ATA_CBL_PATA40;
@@ -162,19 +160,15 @@ static void cs5536_set_piomode(struct at
 	struct ata_device *pair = ata_dev_pair(adev);
 	int mode = adev->pio_mode - XFER_PIO_0;
 	int cmdmode = mode;
-	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
 	int cshift = adev->devno ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
-	u32 dtc, cast, etc;
+	u32 cast;
 
 	if (pair)
 		cmdmode = min(mode, pair->pio_mode - XFER_PIO_0);
 
-	cs5536_read(pdev, DTC, &dtc);
-	cs5536_read(pdev, CAST, &cast);
-	cs5536_read(pdev, ETC, &etc);
+	cs5536_program_dtc(adev, drv_timings[mode]);
 
-	dtc &= ~(IDE_DRV_MASK << dshift);
-	dtc |= drv_timings[mode] << dshift;
+	cs5536_read(pdev, CAST, &cast);
 
 	cast &= ~(IDE_CAST_DRV_MASK << cshift);
 	cast |= addr_timings[mode] << cshift;
@@ -182,12 +176,7 @@ static void cs5536_set_piomode(struct at
 	cast &= ~(IDE_CAST_CMD_MASK << IDE_CAST_CMD_SHIFT);
 	cast |= cmd_timings[cmdmode] << IDE_CAST_CMD_SHIFT;
 
-	etc &= ~(IDE_DRV_MASK << dshift);
-	etc |= IDE_ETC_NODMA << dshift;
-
-	cs5536_write(pdev, DTC, dtc);
 	cs5536_write(pdev, CAST, cast);
-	cs5536_write(pdev, ETC, etc);
 }
 
 /**
@@ -208,25 +197,21 @@ static void cs5536_set_dmamode(struct at
 	};
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u32 dtc, etc;
+	u32 etc;
 	int mode = adev->dma_mode;
 	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
 
-	if (mode >= XFER_UDMA_0) {
-		cs5536_read(pdev, ETC, &etc);
+	cs5536_read(pdev, ETC, &etc);
 
+	if (mode >= XFER_UDMA_0) {
 		etc &= ~(IDE_DRV_MASK << dshift);
 		etc |= udma_timings[mode - XFER_UDMA_0] << dshift;
-
-		cs5536_write(pdev, ETC, etc);
 	} else { /* MWDMA */
-		cs5536_read(pdev, DTC, &dtc);
-
-		dtc &= ~(IDE_DRV_MASK << dshift);
-		dtc |= mwdma_timings[mode - XFER_MW_DMA_0] << dshift;
-
-		cs5536_write(pdev, DTC, dtc);
+		etc &= ~(IDE_ETC_UDMA_MASK << dshift);
+		cs5536_program_dtc(adev, mwdma_timings[mode - XFER_MW_DMA_0]);
 	}
+
+	cs5536_write(pdev, ETC, etc);
 }
 
 static struct scsi_host_template cs5536_sht = {
