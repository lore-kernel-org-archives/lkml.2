Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1BHMYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:24:21 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48060 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab1BHMYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:24:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pDE8rmResJ/uh2/vzqByjm3HjyTHnDP0efORQvK1zNUJ5rvgRcn5JMovYnsjCfUV00
         grv9aFpenY9eoT/vHoaNOpJmJtxfAquNl7Xna1doSSojLaZwSdtj+hdAjf3bwltS8MSa
         mevE/QYb1FcrlcdEawLJXXgYe60SVopW8JWKY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:24:09 +0100
Message-Id: <20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCH 05/20] pata_efar: always program master_data before slave_data
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8acc9371550ce5f98da56f6888ae4b898096ed2c Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 8 Feb 2011 12:39:25 +0100
Subject: [PATCH 05/20] pata_efar: always program master_data before slave_data

We may need to set SITRE before programming slave_data.

This makes pata_efar match the behavior of IDE's slc90e66 host driver
and also of libata's ata_piix one.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_efar.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 1e2ff7d..7f564d7 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -74,10 +74,12 @@ static void efar_set_timings(struct ata_port *ap, struct ata_device *adev,
 			     u8 pio, bool use_mwdma)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned int is_slave	= (adev->devno != 0);
 	unsigned long flags;
 	u8 master_port		= ap->port_no ? 0x42 : 0x40;
 	u16 master_data;
 	u8 udma_enable;
+	u8 slave_data;
 	int control = 0;
 
 	/*
@@ -110,14 +112,13 @@ static void efar_set_timings(struct ata_port *ap, struct ata_device *adev,
 	pci_read_config_word(dev, master_port, &master_data);
 
 	/* Set PPE, IE, and TIME as appropriate */
-	if (adev->devno == 0) {
+	if (is_slave == 0) {
 		master_data &= 0xCCF0;
 		master_data |= control;
 		master_data |= (timings[pio][0] << 12) |
 			(timings[pio][1] << 8);
 	} else {
 		int shift = 4 * ap->port_no;
-		u8 slave_data;
 
 		master_data &= 0xFF0F;
 		master_data |= (control << 4);
@@ -126,12 +127,14 @@ static void efar_set_timings(struct ata_port *ap, struct ata_device *adev,
 		pci_read_config_byte(dev, 0x44, &slave_data);
 		slave_data &= ap->port_no ? 0x0F : 0xF0;
 		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << shift;
-		pci_write_config_byte(dev, 0x44, slave_data);
 	}
 
 	master_data |= 0x4000;	/* Ensure SITRE is set */
 	pci_write_config_word(dev, master_port, master_data);
 
+	if (is_slave)
+		pci_write_config_byte(dev, 0x44, slave_data);
+
 	pci_read_config_byte(dev, 0x48, &udma_enable);
 	udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
 	pci_write_config_byte(dev, 0x48, udma_enable);
-- 
1.7.1

