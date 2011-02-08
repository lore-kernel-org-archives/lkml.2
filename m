Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1BHMZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:25:33 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48060 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab1BHMZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:25:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=oiMxaKKvcqXb/behdBDb3Q5HWibBbnab3bQ+sibUOnElLOcg/0oOqeBWiR4SlGdoy2
         NMGnqH87/rwaDd2Jtvm0SFqk9Oj8qkdsV1DOUCZUgFmpeihyAKMr6Rvyvhfux4jevlby
         DT/9yzZgosK+RZxL2q9N0TsHUkOA5yVSN0SPE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:25:19 +0100
Message-Id: <20110208122519.19110.76776.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCH 14/20] pata_oldpiix: add locking for parallel scanning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bad44bb254a6f81776a373e9d46d30c67ef8f124 Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 8 Feb 2011 12:39:27 +0100
Subject: [PATCH 14/20] pata_oldpiix: add locking for parallel scanning

Add an extra locking for parallel scanning.

This is similar change as commit 60c3be3 for ata_piix host driver
and while pata_oldpiix doesn't enable parallel scan yet the race
could probably also be triggered by requesting re-scanning of both
ports at the same time using SCSI sysfs interface.

Fix documentation while at it.

Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_oldpiix.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 433d2fc..845ede1 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -1,7 +1,8 @@
 /*
- *    pata_oldpiix.c - Intel PATA/SATA controllers
+ *    pata_oldpiix.c - older Intel PATA controllers
  *
  *	(C) 2005 Red Hat
+ *	(C) 2010 Bartlomiej Zolnierkiewicz
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
@@ -50,10 +51,13 @@ static int oldpiix_pre_reset(struct ata_link *link, unsigned long deadline)
 	return ata_sff_prereset(link, deadline);
 }
 
+static DEFINE_SPINLOCK(piix_lock);
+
 static void oldpiix_set_timings(struct ata_port *ap, struct ata_device *adev,
 				u8 pio, bool use_mwdma)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
 	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
 	u16 idetm_data;
 	int control = 0;
@@ -84,6 +88,8 @@ static void oldpiix_set_timings(struct ata_port *ap, struct ata_device *adev,
 		/* Enable DMA timing only */
 		control |= 8;	/* PIO cycles in PIO0 */
 
+	spin_lock_irqsave(&piix_lock, flags);
+
 	pci_read_config_word(dev, idetm_port, &idetm_data);
 
 	/*
@@ -101,6 +107,8 @@ static void oldpiix_set_timings(struct ata_port *ap, struct ata_device *adev,
 			(timings[pio][1] << 8);
 	pci_write_config_word(dev, idetm_port, idetm_data);
 
+	spin_unlock_irqrestore(&piix_lock, flags);
+
 	/* Track which port is configured */
 	ap->private_data = adev;
 }
-- 
1.7.1

