Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1IFTWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:22:07 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52070 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab1IFTWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:22:04 -0400
From: Dan McGee <dpmcgee@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 1/2] pata_sis: extract a sis_port_base() method
Date: Tue,  6 Sep 2011 14:21:58 -0500
Message-Id: <1315336919-2737-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is similar to the existing sis_old_port_base() method. We do this
same calculation and logic in multiple places (with one more to come in
a future patch), so extracting it into a method makes sense.

Reviewed-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 drivers/ata/pata_sis.c |   46 ++++++++++++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 533f2ae..9374400 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -89,6 +89,29 @@ static int sis_old_port_base(struct ata_device *adev)
 }
 
 /**
+ *	sis_port_base		-	return PCI configuration base for dev
+ *	@adev: device
+ *
+ *	Returns the base of the PCI configuration registers for this port
+ *	number.
+ */
+
+static int sis_port_base(struct ata_device *adev)
+{
+	struct ata_port *ap = adev->link->ap;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int port = 0x40;
+	u32 reg54;
+
+	/* If bit 14 is set then the registers are mapped at 0x70 not 0x40 */
+	pci_read_config_dword(pdev, 0x54, &reg54);
+	if (reg54 & 0x40000000)
+		port = 0x70;
+
+	return  port + (8 * ap->port_no) +  (4 * adev->devno);
+}
+
+/**
  *	sis_133_cable_detect	-	check for 40/80 pin
  *	@ap: Port
  *	@deadline: deadline jiffies for the operation
@@ -266,9 +289,8 @@ static void sis_100_set_piomode (struct ata_port *ap, struct ata_device *adev)
 static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	int port = 0x40;
+	int port;
 	u32 t1;
-	u32 reg54;
 	int speed = adev->pio_mode - XFER_PIO_0;
 
 	const u32 timing133[] = {
@@ -288,12 +310,7 @@ static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
 
 	sis_set_fifo(ap, adev);
 
-	/* If bit 14 is set then the registers are mapped at 0x70 not 0x40 */
-	pci_read_config_dword(pdev, 0x54, &reg54);
-	if (reg54 & 0x40000000)
-		port = 0x70;
-	port += 8 * ap->port_no +  4 * adev->devno;
-
+	port = sis_port_base(adev);
 	pci_read_config_dword(pdev, port, &t1);
 	t1 &= 0xC0C00FFF;	/* Mask out timing */
 
@@ -465,21 +482,14 @@ static void sis_133_early_set_dmamode (struct ata_port *ap, struct ata_device *a
 static void sis_133_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	int speed = adev->dma_mode - XFER_MW_DMA_0;
-	int port = 0x40;
+	int port;
 	u32 t1;
-	u32 reg54;
 
 	/* bits 4- cycle time 8 - cvs time */
 	static const u32 timing_u100[] = { 0x6B0, 0x470, 0x350, 0x140, 0x120, 0x110, 0x000 };
 	static const u32 timing_u133[] = { 0x9F0, 0x6A0, 0x470, 0x250, 0x230, 0x220, 0x210 };
 
-	/* If bit 14 is set then the registers are mapped at 0x70 not 0x40 */
-	pci_read_config_dword(pdev, 0x54, &reg54);
-	if (reg54 & 0x40000000)
-		port = 0x70;
-	port += (8 * ap->port_no) +  (4 * adev->devno);
-
+	port = sis_port_base(adev);
 	pci_read_config_dword(pdev, port, &t1);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
@@ -487,7 +497,7 @@ static void sis_133_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 		/* FIXME: need data sheet to add MWDMA here. Also lacking on
 		   ide/pci driver */
 	} else {
-		speed = adev->dma_mode - XFER_UDMA_0;
+		int speed = adev->dma_mode - XFER_UDMA_0;
 		/* if & 8 no UDMA133 - need info for ... */
 		t1 &= ~0x00000FF0;
 		t1 |= 0x00000004;
-- 
1.7.6.1

