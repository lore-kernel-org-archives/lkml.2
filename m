Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab1JKS2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:28:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab1JKSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:28 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_atiixp: add proper ->prereset method
Date: Tue, 11 Oct 2011 19:55:09 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110111955.09320.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_atiixp: add proper ->prereset method

Fixes PCI access before PCI resources are allocated.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/320

 drivers/ata/pata_atiixp.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

Index: b/drivers/ata/pata_atiixp.c
===================================================================
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -49,6 +49,31 @@ static int atiixp_cable_detect(struct at
 static DEFINE_SPINLOCK(atiixp_lock);
 
 /**
+ *	atiixp_prereset	-	perform reset handling
+ *	@link: ATA link
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	Reset sequence checking enable bits to see which ports are
+ *	active.
+ */
+
+static int atiixp_prereset(struct ata_link *link, unsigned long deadline)
+{
+	static const struct pci_bits atiixp_enable_bits[] = {
+		{ 0x48, 1, 0x01, 0x00 },
+		{ 0x48, 1, 0x08, 0x00 }
+	};
+
+	struct ata_port *ap = link->ap;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	if (!pci_test_config_bits(pdev, &atiixp_enable_bits[ap->port_no]))
+		return -ENOENT;
+
+	return ata_sff_prereset(link, deadline);
+}
+
+/**
  *	atiixp_set_pio_timing	-	set initial PIO mode data
  *	@ap: ATA interface
  *	@adev: ATA device
@@ -221,6 +246,7 @@ static struct ata_port_operations atiixp
 	.bmdma_start 	= atiixp_bmdma_start,
 	.bmdma_stop	= atiixp_bmdma_stop,
 
+	.prereset	= atiixp_prereset,
 	.cable_detect	= atiixp_cable_detect,
 	.set_piomode	= atiixp_set_piomode,
 	.set_dmamode	= atiixp_set_dmamode,
@@ -235,16 +261,7 @@ static int atiixp_init_one(struct pci_de
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &atiixp_port_ops
 	};
-	static const struct pci_bits atiixp_enable_bits[] = {
-		{ 0x48, 1, 0x01, 0x00 },
-		{ 0x48, 1, 0x08, 0x00 }
-	};
 	const struct ata_port_info *ppi[] = { &info, &info };
-	int i;
-
-	for (i = 0; i < 2; i++)
-		if (!pci_test_config_bits(pdev, &atiixp_enable_bits[i]))
-			ppi[i] = &ata_dummy_port_info;
 
 	return ata_pci_bmdma_init_one(pdev, ppi, &atiixp_sht, NULL,
 				      ATA_HOST_PARALLEL_SCAN);
