Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab1BHMYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:24:07 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61026 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab1BHMYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:24:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=edB6rq2NJP+B266+4NWD0ekqQUoy3MvegUkCywkZMC5IkpDxPLtXQ0CDM2vszD4JbM
         rXJLFNzMrJ2C6ddBslpjfRcK2TiBp0vEzL9+XLjt1uihoeUJ4td90k0gykOQNHo9F9WK
         w3xJdyqa0oEbsOIrlNe0Xld45t1Td9sHzg510=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:23:53 +0100
Message-Id: <20110208122353.19110.75537.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCH 03/20] pata_efar: fix register naming used in efar_set_piomode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From efbad2a0611e47772c8696a2c5b2037c78554378 Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 8 Feb 2011 12:39:25 +0100
Subject: [PATCH 03/20] pata_efar: fix register naming used in efar_set_piomode()

Rename 'idetm_port' and 'idetm_data' variables to 'master_port'
and 'master_data' respectively to match register naming used in
efar_set_dma_mode() and in ata_piix.c.

Fix efar_set_piomode() documentation and 'master_port' type
while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_efar.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index a088347..afe92b7 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -73,7 +73,7 @@ static DEFINE_SPINLOCK(efar_lock);
 /**
  *	efar_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
- *	@adev: um
+ *	@adev: Device to program
  *
  *	Set PIO mode for device, in host controller PCI config space.
  *
@@ -85,9 +85,9 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
 	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
 	unsigned long flags;
-	u16 idetm_data;
+	u8 master_port		= ap->port_no ? 0x42 : 0x40;
+	u16 master_data;
 	u8 udma_enable;
 	int control = 0;
 
@@ -113,20 +113,20 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 
 	spin_lock_irqsave(&efar_lock, flags);
 
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
 		int shift = 4 * ap->port_no;
 		u8 slave_data;
 
-		idetm_data &= 0xFF0F;
-		idetm_data |= (control << 4);
+		master_data &= 0xFF0F;
+		master_data |= (control << 4);
 
 		/* Slave timing in separate register */
 		pci_read_config_byte(dev, 0x44, &slave_data);
@@ -135,8 +135,8 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 		pci_write_config_byte(dev, 0x44, slave_data);
 	}
 
-	idetm_data |= 0x4000;	/* Ensure SITRE is set */
-	pci_write_config_word(dev, idetm_port, idetm_data);
+	master_data |= 0x4000;	/* Ensure SITRE is set */
+	pci_write_config_word(dev, master_port, master_data);
 
 	pci_read_config_byte(dev, 0x48, &udma_enable);
 	udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
-- 
1.7.1

