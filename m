Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1BHMY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:24:29 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61026 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab1BHMY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:24:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=W+c8XddRzzoAfkZnoXQYJTDQTPBErbH4ATTXf99TkTcGTGPf5Qk6ibF35zevrTyc9h
         rNJgPr6lNcdg0HP4wpXWhG9aCXc1zSuB4/yagGzUQxS+nbxorbo7kWFwtr1EshEaN2/+
         XG2Of6Rv7xKSGMELwohaITisOVMcXKyu60uy0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:24:16 +0100
Message-Id: <20110208122416.19110.33098.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCH 06/20] pata_it8213: fix register naming used in it8213_set_piomode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fd377660531ca5b5d0802fa282ae7c964d0fddd7 Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 8 Feb 2011 12:39:25 +0100
Subject: [PATCH 06/20] pata_it8213: fix register naming used in it8213_set_piomode()

Rename 'idetm_port' and 'idetm_data' variables to 'master_port'
and 'master_data' respectively to match register naming used in
it8213_set_dma_mode() and in ata_piix.c.

Fix 'master_port' type while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it8213.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 4d142a2..911f50b 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -76,8 +76,8 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
 	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
-	u16 idetm_data;
+	u8 master_port		= ap->port_no ? 0x42 : 0x40;
+	u16 master_data;
 	int control = 0;
 
 	/*
@@ -100,19 +100,19 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
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
@@ -121,8 +121,8 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
 		pci_write_config_byte(dev, 0x44, slave_data);
 	}
 
-	idetm_data |= 0x4000;	/* Ensure SITRE is set */
-	pci_write_config_word(dev, idetm_port, idetm_data);
+	master_data |= 0x4000;	/* Ensure SITRE is set */
+	pci_write_config_word(dev, master_port, master_data);
 }
 
 /**
-- 
1.7.1

