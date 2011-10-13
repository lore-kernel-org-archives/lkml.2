Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab1JMPo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:44:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab1JMPo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:44:56 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH v2] pata_it8213: fix register naming used in it8213_set_piomode()
Date: Thu, 13 Oct 2011 17:44:22 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201110131744.23090.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH v2] pata_it8213: fix register naming used in it8213_set_piomode()

Rename 'idetm_port' and 'idetm_data' variables to 'master_port'
and 'master_data' respectively to match register naming used in
it8213_set_dmamode() and in ata_piix.c.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
v2: don't change master_port type

earlier references:
https://lkml.org/lkml/2011/2/8/103

 drivers/ata/pata_it8213.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: b/drivers/ata/pata_it8213.c
===================================================================
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -76,8 +76,8 @@ static void it8213_set_piomode (struct a
 {
 	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
-	u16 idetm_data;
+	unsigned int master_port = ap->port_no ? 0x42 : 0x40;
+	u16 master_data;
 	int control = 0;
 
 	/*
@@ -100,19 +100,19 @@ static void it8213_set_piomode (struct a
 	if (adev->class != ATA_DEV_ATA)
 		control |= 4;	/* PPE */
 
-	pci_read_config_word(dev, idetm_port, &idetm_data);
+	pci_read_config_word(dev, master_port, &master_data);
 
 	/* Set PPE, IE, and TIME as appropriate */
 	if (adev->devno == 0) {
-		idetm_data &= 0xCCF0;
-		idetm_data |= control;
-		idetm_data |= (timings[pio][0] << 12) |
+		master_data &= 0xCCF0;
+		master_data |= control;
+		master_data |= (timings[pio][0] << 12) |
 			(timings[pio][1] << 8);
 	} else {
 		u8 slave_data;
 
-		idetm_data &= 0xFF0F;
-		idetm_data |= (control << 4);
+		master_data &= 0xFF0F;
+		master_data |= (control << 4);
 
 		/* Slave timing in separate register */
 		pci_read_config_byte(dev, 0x44, &slave_data);
@@ -121,8 +121,8 @@ static void it8213_set_piomode (struct a
 		pci_write_config_byte(dev, 0x44, slave_data);
 	}
 
-	idetm_data |= 0x4000;	/* Ensure SITRE is set */
-	pci_write_config_word(dev, idetm_port, idetm_data);
+	master_data |= 0x4000;	/* Ensure SITRE is set */
+	pci_write_config_word(dev, master_port, master_data);
 }
 
 /**
