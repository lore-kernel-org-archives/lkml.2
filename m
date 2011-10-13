Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1JMOEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:04:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64772 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab1JMOED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:04:03 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 1/2] pata_oldpiix: add locking for parallel scanning
Date: Thu, 13 Oct 2011 16:02:44 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131602.45265.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_oldpiix: add locking for parallel scanning

Add an extra locking for parallel scanning.

This is similar change as commit 60c3be3 ("ata_piix: parallel scanning
on PATA needs an extra locking") for ata_piix host driver and while
pata_oldpiix doesn't enable parallel scan yet the race could probably
also be triggered by requesting re-scanning of both ports at the same
time using SCSI sysfs interface.

Fix documentation while at it.

Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2011/2/8/110
https://lkml.org/lkml/2010/2/18/274

 drivers/ata/pata_oldpiix.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

Index: b/drivers/ata/pata_oldpiix.c
===================================================================
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -1,7 +1,8 @@
 /*
- *    pata_oldpiix.c - Intel PATA/SATA controllers
+ *    pata_oldpiix.c - older Intel PATA controller
  *
  *	(C) 2005 Red Hat
+ *	(C) 2011 Bartlomiej Zolnierkiewicz
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
@@ -50,6 +51,8 @@ static int oldpiix_pre_reset(struct ata_
 	return ata_sff_prereset(link, deadline);
 }
 
+static DEFINE_SPINLOCK(oldpiix_lock);
+
 /**
  *	oldpiix_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
@@ -65,6 +68,7 @@ static void oldpiix_set_piomode (struct
 {
 	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
 	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
 	u16 idetm_data;
 	int control = 0;
@@ -91,6 +95,8 @@ static void oldpiix_set_piomode (struct
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE */
 
+	spin_lock_irqsave(&oldpiix_lock, flags);
+
 	pci_read_config_word(dev, idetm_port, &idetm_data);
 
 	/*
@@ -108,6 +114,8 @@ static void oldpiix_set_piomode (struct
 			(timings[pio][1] << 8);
 	pci_write_config_word(dev, idetm_port, idetm_data);
 
+	spin_unlock_irqrestore(&oldpiix_lock, flags);
+
 	/* Track which port is configured */
 	ap->private_data = adev;
 }
@@ -126,6 +134,7 @@ static void oldpiix_set_piomode (struct
 static void oldpiix_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
 	u8 idetm_port		= ap->port_no ? 0x42 : 0x40;
 	u16 idetm_data;
 
@@ -149,6 +158,8 @@ static void oldpiix_set_dmamode (struct
 	};
 	int pio = needed_pio[mwdma] - XFER_PIO_0;
 
+	spin_lock_irqsave(&oldpiix_lock, flags);
+
 	pci_read_config_word(dev, idetm_port, &idetm_data);
 
 	control = 3;	/* IORDY|TIME0 */
@@ -175,6 +186,8 @@ static void oldpiix_set_dmamode (struct
 	idetm_data |= (timings[pio][0] << 12) | (timings[pio][1] << 8);
 	pci_write_config_word(dev, idetm_port, idetm_data);
 
+	spin_unlock_irqrestore(&oldpiix_lock, flags);
+
 	/* Track which port is configured */
 	ap->private_data = adev;
 }
