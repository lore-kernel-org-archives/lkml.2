Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1JMLRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:17:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57141 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab1JMLRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:17:09 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_artop: add Power Management support
Date: Thu, 13 Oct 2011 12:59:35 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201110131259.35664.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_artop: add Power Management support

Fixes IDE -> libata regression.

There shouldn't be any problems with it as corresponding IDE's host
driver (aec62xx) has been supporting PCI Power Management since
Oct 10 2008 (commit feb22b7f "ide: add proper PCI PM support (v2)")
and IDE PM since Jun 14 2003 (patch v2.5.73 "ide: Power Management").

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/314

 drivers/ata/pata_artop.c |   81 +++++++++++++++++++++++++++++++----------------
 1 file changed, 54 insertions(+), 27 deletions(-)

Index: b/drivers/ata/pata_artop.c
===================================================================
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -2,7 +2,7 @@
  *    pata_artop.c - ARTOP ATA controller driver
  *
  *	(C) 2006 Red Hat
- *	(C) 2007 Bartlomiej Zolnierkiewicz
+ *	(C) 2007,2011 Bartlomiej Zolnierkiewicz
  *
  *    Based in part on drivers/ide/pci/aec62xx.c
  *	Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
@@ -28,7 +28,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_artop"
-#define DRV_VERSION	"0.4.5"
+#define DRV_VERSION	"0.4.6"
 
 /*
  *	The ARTOP has 33 Mhz and "over clocked" timing tables. Until we
@@ -313,6 +313,33 @@ static struct ata_port_operations artop6
 	.prereset		= artop62x0_pre_reset,
 };
 
+static void atp8xx_fixup(struct pci_dev *pdev)
+{
+	if (pdev->device == 0x0005)
+		/* BIOS may have left us in UDMA, clear it before libata probe */
+		pci_write_config_byte(pdev, 0x54, 0);
+	else if (pdev->device == 0x0008 || pdev->device == 0x0009) {
+		u8 reg;
+
+		/* Mac systems come up with some registers not set as we
+		   will need them */
+
+		/* Clear reset & test bits */
+		pci_read_config_byte(pdev, 0x49, &reg);
+		pci_write_config_byte(pdev, 0x49, reg & ~0x30);
+
+		/* PCI latency must be > 0x80 for burst mode, tweak it
+		 * if required.
+		 */
+		pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &reg);
+		if (reg <= 0x80)
+			pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x90);
+
+		/* Enable IRQ output and burst mode */
+		pci_read_config_byte(pdev, 0x4a, &reg);
+		pci_write_config_byte(pdev, 0x4a, (reg & ~0x01) | 0x80);
+	}
+}
 
 /**
  *	artop_init_one - Register ARTOP ATA PCI device with kernel services
@@ -370,42 +397,22 @@ static int artop_init_one (struct pci_de
 	if (rc)
 		return rc;
 
-	if (id->driver_data == 0) {	/* 6210 variant */
+	if (id->driver_data == 0)	/* 6210 variant */
 		ppi[0] = &info_6210;
-		/* BIOS may have left us in UDMA, clear it before libata probe */
-		pci_write_config_byte(pdev, 0x54, 0);
-	}
 	else if (id->driver_data == 1)	/* 6260 */
 		ppi[0] = &info_626x;
 	else if (id->driver_data == 2)	{ /* 6280 or 6280 + fast */
 		unsigned long io = pci_resource_start(pdev, 4);
-		u8 reg;
 
 		ppi[0] = &info_628x;
 		if (inb(io) & 0x10)
 			ppi[0] = &info_628x_fast;
-		/* Mac systems come up with some registers not set as we
-		   will need them */
-
-		/* Clear reset & test bits */
-		pci_read_config_byte(pdev, 0x49, &reg);
-		pci_write_config_byte(pdev, 0x49, reg & ~ 0x30);
-
-		/* PCI latency must be > 0x80 for burst mode, tweak it
-		 * if required.
-		 */
-		pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &reg);
-		if (reg <= 0x80)
-			pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x90);
-
-		/* Enable IRQ output and burst mode */
-		pci_read_config_byte(pdev, 0x4a, &reg);
-		pci_write_config_byte(pdev, 0x4a, (reg & ~0x01) | 0x80);
-
 	}
 
 	BUG_ON(ppi[0] == NULL);
 
+	atp8xx_fixup(pdev);
+
 	return ata_pci_bmdma_init_one(pdev, ppi, &artop_sht, NULL, 0);
 }
 
@@ -419,11 +426,32 @@ static const struct pci_device_id artop_
 	{ }	/* terminate list */
 };
 
+#ifdef CONFIG_PM
+static int atp8xx_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	atp8xx_fixup(pdev);
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 static struct pci_driver artop_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= artop_pci_tbl,
 	.probe			= artop_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= ata_pci_device_suspend,
+	.resume			= atp8xx_reinit_one,
+#endif
 };
 
 static int __init artop_init(void)
@@ -439,9 +467,8 @@ static void __exit artop_exit(void)
 module_init(artop_init);
 module_exit(artop_exit);
 
-MODULE_AUTHOR("Alan Cox");
+MODULE_AUTHOR("Alan Cox, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("SCSI low-level driver for ARTOP PATA");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, artop_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
