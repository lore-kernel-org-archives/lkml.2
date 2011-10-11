Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab1JKSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:25:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65369 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1JKSZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:26 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_hpt366: add hpt36x_find_mode() helper
Date: Tue, 11 Oct 2011 19:52:31 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110111952.31615.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_hpt366: add hpt36x_find_mode() helper

Factor out code for finding the register programming information
from hpt366_set_mode() to hpt36x_find_mode().

This makes pata_hpt366 driver more similar to pata_{37x,3x2n} ones.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
pata_hpt{37x,3x2n} drivers can also be made to use *set_mode()

earlier references:
https://lkml.org/lkml/2009/11/27/241

 drivers/ata/pata_hpt366.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

Index: b/drivers/ata/pata_hpt366.c
===================================================================
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -111,6 +111,28 @@ static const struct hpt_clock hpt366_25[
 	{	0,		0x01208585	}
 };
 
+/**
+ *	hpt36x_find_mode	-	find the hpt36x timing
+ *	@ap: ATA port
+ *	@speed: transfer mode
+ *
+ *	Return the 32bit register programming information for this channel
+ *	that matches the speed provided.
+ */
+
+static u32 hpt36x_find_mode(struct ata_port *ap, int speed)
+{
+	struct hpt_clock *clocks = ap->host->private_data;
+
+	while (clocks->xfer_mode) {
+		if (clocks->xfer_mode == speed)
+			return clocks->timing;
+		clocks++;
+	}
+	BUG();
+	return 0xffffffffU;	/* silence compiler warning */
+}
+
 static const char * const bad_ata33[] = {
 	"Maxtor 92720U8", "Maxtor 92040U6", "Maxtor 91360U4", "Maxtor 91020U3",
 	"Maxtor 90845U3", "Maxtor 90650U2",
@@ -210,10 +232,9 @@ static int hpt36x_cable_detect(struct at
 static void hpt366_set_mode(struct ata_port *ap, struct ata_device *adev,
 			    u8 mode)
 {
-	struct hpt_clock *clocks = ap->host->private_data;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 addr = 0x40 + 4 * adev->devno;
-	u32 mask, reg;
+	u32 mask, reg, t;
 
 	/* determine timing mask and find matching clock entry */
 	if (mode < XFER_MW_DMA_0)
@@ -223,13 +244,7 @@ static void hpt366_set_mode(struct ata_p
 	else
 		mask = 0x30070000;
 
-	while (clocks->xfer_mode) {
-		if (clocks->xfer_mode == mode)
-			break;
-		clocks++;
-	}
-	if (!clocks->xfer_mode)
-		BUG();
+	t = hpt36x_find_mode(ap, mode);
 
 	/*
 	 * Combine new mode bits with old config bits and disable
@@ -237,7 +252,7 @@ static void hpt366_set_mode(struct ata_p
 	 * problems handling I/O errors later.
 	 */
 	pci_read_config_dword(pdev, addr, &reg);
-	reg = ((reg & ~mask) | (clocks->timing & mask)) & ~0xc0000000;
+	reg = ((reg & ~mask) | (t & mask)) & ~0xc0000000;
 	pci_write_config_dword(pdev, addr, reg);
 }
 
