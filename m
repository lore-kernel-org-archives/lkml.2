Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1JMLRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:17:20 -0400
Received: from mail-dy0-f46.google.com ([209.85.220.46]:51740 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab1JMLRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:17:17 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_via: add via_fixup()
Date: Thu, 13 Oct 2011 13:10:51 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131310.51896.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_via: add via_fixup()

Factor out common code from via_[re]init_one() to via_fixup().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/381

 drivers/ata/pata_via.c |   49 +++++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

Index: b/drivers/ata/pata_via.c
===================================================================
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -491,6 +491,27 @@ static void via_config_fifo(struct pci_d
 	}
 }
 
+static void via_fixup(struct pci_dev *pdev, const struct via_isa_bridge *config)
+{
+	u32 timing;
+
+	/* Initialise the FIFO for the enabled channels. */
+	via_config_fifo(pdev, config->flags);
+
+	if (config->udma_mask == ATA_UDMA4) {
+		/* The 66 MHz devices require we enable the clock */
+		pci_read_config_dword(pdev, 0x50, &timing);
+		timing |= 0x80008;
+		pci_write_config_dword(pdev, 0x50, timing);
+	}
+	if (config->flags & VIA_BAD_CLK66) {
+		/* Disable the 66MHz clock on problem devices */
+		pci_read_config_dword(pdev, 0x50, &timing);
+		timing &= ~0x80008;
+		pci_write_config_dword(pdev, 0x50, timing);
+	}
+}
+
 /**
  *	via_init_one		-	discovery callback
  *	@pdev: PCI device
@@ -553,7 +574,6 @@ static int via_init_one(struct pci_dev *
 	const struct via_isa_bridge *config;
 	static int printed_version;
 	u8 enable;
-	u32 timing;
 	unsigned long flags = id->driver_data;
 	int rc;
 
@@ -593,9 +613,6 @@ static int via_init_one(struct pci_dev *
 			return -ENODEV;
 	}
 
-	/* Initialise the FIFO for the enabled channels. */
-	via_config_fifo(pdev, config->flags);
-
 	/* Clock set up */
 	switch (config->udma_mask) {
 	case 0x00:
@@ -621,12 +638,7 @@ static int via_init_one(struct pci_dev *
 		return -ENODEV;
  	}
 
-	if (config->flags & VIA_BAD_CLK66) {
-		/* Disable the 66MHz clock on problem devices */
-		pci_read_config_dword(pdev, 0x50, &timing);
-		timing &= ~0x80008;
-		pci_write_config_dword(pdev, 0x50, timing);
-	}
+	via_fixup(pdev, config);
 
 	/* We have established the device type, now fire it up */
 	return ata_pci_bmdma_init_one(pdev, ppi, &via_sht, (void *)config, 0);
@@ -645,29 +657,14 @@ static int via_init_one(struct pci_dev *
 
 static int via_reinit_one(struct pci_dev *pdev)
 {
-	u32 timing;
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	const struct via_isa_bridge *config = host->private_data;
 	int rc;
 
 	rc = ata_pci_device_do_resume(pdev);
 	if (rc)
 		return rc;
 
-	via_config_fifo(pdev, config->flags);
-
-	if (config->udma_mask == ATA_UDMA4) {
-		/* The 66 MHz devices require we enable the clock */
-		pci_read_config_dword(pdev, 0x50, &timing);
-		timing |= 0x80008;
-		pci_write_config_dword(pdev, 0x50, timing);
-	}
-	if (config->flags & VIA_BAD_CLK66) {
-		/* Disable the 66MHz clock on problem devices */
-		pci_read_config_dword(pdev, 0x50, &timing);
-		timing &= ~0x80008;
-		pci_write_config_dword(pdev, 0x50, timing);
-	}
+	via_fixup(pdev, host->private_data);
 
 	ata_host_resume(host);
 	return 0;
