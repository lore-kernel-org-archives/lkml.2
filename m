Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1BHMYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:24:15 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61026 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab1BHMYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:24:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pwE7iKibWWobAlJb4LLhUTba6u5UrcWdMmaqm9OQgYp6FdTv3unB2TQ/X7mvf4tDju
         cSYd7302Bpo7l6U01uf4SYR2MfUJV69lwph8Jkakc6mD+D8vm69pbhr0V6yq5FgcYaXC
         DMP1DAkE14QVKsZQAYjkZGqzxMaTvv0db7Xto=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:24:01 +0100
Message-Id: <20110208122401.19110.20615.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCH 04/20] pata_efar: unify code for programming PIO and MWDMA timings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2de7db4bcc16b7e95cca9ceb5921a6f620be76b7 Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 8 Feb 2011 12:39:25 +0100
Subject: [PATCH 04/20] pata_efar: unify code for programming PIO and MWDMA timings

Besides making things noticably simpler it results in ~10% decrease in
the driver LOC count and also ~8% decrease in the driver binary size
(as measured on x86-32).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_efar.c |  104 +++++++++++++++++------------------------------
 1 files changed, 37 insertions(+), 67 deletions(-)

diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index afe92b7..1e2ff7d 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -70,20 +70,9 @@ static int efar_cable_detect(struct ata_port *ap)
 
 static DEFINE_SPINLOCK(efar_lock);
 
-/**
- *	efar_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device to program
- *
- *	Set PIO mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
+static void efar_set_timings(struct ata_port *ap, struct ata_device *adev,
+			     u8 pio, bool use_mwdma)
 {
-	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	unsigned long flags;
 	u8 master_port		= ap->port_no ? 0x42 : 0x40;
@@ -103,13 +92,18 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 			    { 2, 1 },
 			    { 2, 3 }, };
 
-	if (pio > 1)
+	if (pio > 1 || use_mwdma)
 		control |= 1;	/* TIME */
-	if (ata_pio_need_iordy(adev))	/* PIO 3/4 require IORDY */
+	if (ata_pio_need_iordy(adev) || use_mwdma)
 		control |= 2;	/* IE */
 	/* Intel specifies that the prefetch/posting is for disk only */
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE */
+	/* If the drive MWDMA is faster than it can do PIO then
+	   we must force PIO into PIO0 */
+	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
+		/* Enable DMA timing only */
+		control |= 8;	/* PIO cycles in PIO0 */
 
 	spin_lock_irqsave(&efar_lock, flags);
 
@@ -145,6 +139,22 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
+ *	efar_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device to program
+ *
+ *	Set PIO mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void efar_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	efar_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
+}
+
+/**
  *	efar_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device to program
@@ -158,29 +168,19 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	u8 master_port		= ap->port_no ? 0x42 : 0x40;
-	u16 master_data;
 	u8 speed		= adev->dma_mode;
 	int devid		= adev->devno + 2 * ap->port_no;
 	unsigned long flags;
 	u8 udma_enable;
 
-	static const	 /* ISP  RTC */
-	u8 timings[][2]	= { { 0, 0 },
-			    { 0, 0 },
-			    { 1, 0 },
-			    { 2, 1 },
-			    { 2, 3 }, };
-
-	spin_lock_irqsave(&efar_lock, flags);
-
-	pci_read_config_word(dev, master_port, &master_data);
-	pci_read_config_byte(dev, 0x48, &udma_enable);
-
 	if (speed >= XFER_UDMA_0) {
-		unsigned int udma	= adev->dma_mode - XFER_UDMA_0;
+		unsigned int udma = speed - XFER_UDMA_0;
 		u16 udma_timing;
 
+		spin_lock_irqsave(&efar_lock, flags);
+
+		pci_read_config_byte(dev, 0x48, &udma_enable);
+
 		udma_enable |= (1 << devid);
 
 		/* Load the UDMA mode number */
@@ -188,50 +188,20 @@ static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 		udma_timing &= ~(7 << (4 * devid));
 		udma_timing |= udma << (4 * devid);
 		pci_write_config_word(dev, 0x4A, udma_timing);
+
+		pci_write_config_byte(dev, 0x48, udma_enable);
+
+		spin_unlock_irqrestore(&efar_lock, flags);
 	} else {
-		/*
-		 * MWDMA is driven by the PIO timings. We must also enable
-		 * IORDY unconditionally along with TIME1. PPE has already
-		 * been set when the PIO timing was set.
-		 */
-		unsigned int mwdma	= adev->dma_mode - XFER_MW_DMA_0;
-		unsigned int control;
-		u8 slave_data;
+		/* MWDMA is driven by the PIO timings. */
+		unsigned int mwdma = speed - XFER_MW_DMA_0;
 		const unsigned int needed_pio[3] = {
 			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
 		};
 		int pio = needed_pio[mwdma] - XFER_PIO_0;
 
-		control = 3;	/* IORDY|TIME1 */
-
-		/* If the drive MWDMA is faster than it can do PIO then
-		   we must force PIO into PIO0 */
-
-		if (adev->pio_mode < needed_pio[mwdma])
-			/* Enable DMA timing only */
-			control |= 8;	/* PIO cycles in PIO0 */
-
-		if (adev->devno) {	/* Slave */
-			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
-			master_data |= control << 4;
-			pci_read_config_byte(dev, 0x44, &slave_data);
-			slave_data &= ap->port_no ? 0x0F : 0xF0;
-			/* Load the matching timing */
-			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
-			pci_write_config_byte(dev, 0x44, slave_data);
-		} else { 	/* Master */
-			master_data &= 0xCCF4;	/* Mask out IORDY|TIME1|DMAONLY
-						   and master timing bits */
-			master_data |= control;
-			master_data |=
-				(timings[pio][0] << 12) |
-				(timings[pio][1] << 8);
-		}
-		udma_enable &= ~(1 << devid);
-		pci_write_config_word(dev, master_port, master_data);
+		efar_set_timings(ap, adev, pio, 1);
 	}
-	pci_write_config_byte(dev, 0x48, udma_enable);
-	spin_unlock_irqrestore(&efar_lock, flags);
 }
 
 static struct scsi_host_template efar_sht = {
-- 
1.7.1

