Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1BGK6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 05:58:40 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54970 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab1BGK5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 05:57:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=Ri5ux7TLmdUJ89hLj5F9PMfY52V158Nzr4F1GBAJGtVuxec5fOhCY6w3RWRacJURqA
         p3muSRh3VSEvUXD4urDSiD1C6xRwyBJWw7IZe3KFwIXhZwPOnXgYJp8J5HBIWfd3B+k/
         OPiivzSmEh8h2fjn+gy3jSdna1UNr7pB0pp20=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] trm290: housekeeping
Date: Mon, 7 Feb 2011 11:49:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102071149.17811.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* remove dead DMA support (it has been dead for a long, long
  time and despite stale comments in the driver it couldn't be
  enabled at runtime)
* remove needless ifdefs

Compile-tested only.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma-sff.c |    8 ---
 drivers/ide/trm290.c      |  108 
+---------------------------------------------
 include/linux/ide.h       |    2 
 3 files changed, 6 insertions(+), 112 deletions(-)

Index: b/drivers/ide/ide-dma-sff.c
===================================================================
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -117,7 +117,6 @@ int ide_build_dmatable(ide_drive_t *driv
 	unsigned int count = 0;
 	int i;
 	struct scatterlist *sg;
-	u8 is_trm290 = !!(hwif->host_flags & IDE_HFLAG_TRM290);
 
 	for_each_sg(hwif->sg_table, sg, cmd->sg_nents, i) {
 		u32 cur_addr, cur_len, xcount, bcount;
@@ -140,9 +139,7 @@ int ide_build_dmatable(ide_drive_t *driv
 				bcount = cur_len;
 			*table++ = cpu_to_le32(cur_addr);
 			xcount = bcount & 0xffff;
-			if (is_trm290)
-				xcount = ((xcount >> 2) - 1) << 16;
-			else if (xcount == 0x0000) {
+			if (xcount == 0x0000) {
 				if (count++ >= PRD_ENTRIES)
 					goto use_pio_instead;
 				*table++ = cpu_to_le32(0x8000);
@@ -156,8 +153,7 @@ int ide_build_dmatable(ide_drive_t *driv
 	}
 
 	if (count) {
-		if (!is_trm290)
-			*--table |= cpu_to_le32(0x80000000);
+		*--table |= cpu_to_le32(0x80000000);
 		return count;
 	}
 
Index: b/drivers/ide/trm290.c
===================================================================
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -7,32 +7,11 @@
  *  June 22, 2004 - get rid of check_region
  *                   - Jesper Juhl
  *
+ * TODO:
+ * - DMA support (the TRM290 pre-dates the SFF-8038 standard by a few months)
  */
 
 /*
- * This module provides support for the bus-master IDE DMA function
- * of the Tekram TRM290 chip, used on a variety of PCI IDE add-on boards,
- * including a "Precision Instruments" board.  The TRM290 pre-dates
- * the sff-8038 standard (ide-dma.c) by a few months, and differs
- * significantly enough to warrant separate routines for some functions,
- * while re-using others from ide-dma.c.
- *
- * EXPERIMENTAL!  It works for me (a sample of one).
- *
- * Works reliably for me in DMA mode (READs only),
- * DMA WRITEs are disabled by default (see #define below);
- *
- * DMA is not enabled automatically for this chipset,
- * but can be turned on manually (with "hdparm -d1") at run time.
- *
- * I need volunteers with "spare" drives for further testing
- * and development, and maybe to help figure out the peculiarities.
- * Even knowing the registers (below), some things behave strangely.
- */
-
-#define TRM290_NO_DMA_WRITES	/* DMA writes seem unreliable sometimes */
-
-/*
  * TRM-290 PCI-IDE2 Bus Master Chip
  * ================================
  * The configuration registers are addressed in normal I/O port space
@@ -173,62 +152,9 @@ static void trm290_prepare_drive (ide_dr
 
 static void trm290_dev_select(ide_drive_t *drive)
 {
-	trm290_prepare_drive(drive, !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
-
-	outb(drive->select | ATA_DEVICE_OBS, drive->hwif->io_ports.device_addr);
-}
-
-static int trm290_dma_check(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	if (cmd->tf_flags & IDE_TFLAG_WRITE) {
-#ifdef TRM290_NO_DMA_WRITES
-		/* always use PIO for writes */
-		return 1;
-#endif
-	}
-	return 0;
-}
-
-static int trm290_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	unsigned int count, rw = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 1 : 2;
-
-	count = ide_build_dmatable(drive, cmd);
-	if (count == 0)
-		/* try PIO instead of DMA */
-		return 1;
-
-	outl(hwif->dmatable_dma | rw, hwif->dma_base);
-	/* start DMA */
-	outw(count * 2 - 1, hwif->dma_base + 2);
-
-	return 0;
-}
-
-static void trm290_dma_start(ide_drive_t *drive)
-{
-	trm290_prepare_drive(drive, 1);
-}
-
-static int trm290_dma_end(ide_drive_t *drive)
-{
-	u16 status = inw(drive->hwif->dma_base + 2);
-
 	trm290_prepare_drive(drive, 0);
 
-	return status != 0x00ff;
-}
-
-static int trm290_dma_test_irq(ide_drive_t *drive)
-{
-	u16 status = inw(drive->hwif->dma_base + 2);
-
-	return status == 0x00ff;
-}
-
-static void trm290_dma_host_set(ide_drive_t *drive, int on)
-{
+	outb(drive->select | ATA_DEVICE_OBS, drive->hwif->io_ports.device_addr);
 }
 
 static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
@@ -246,13 +172,6 @@ static void __devinit init_hwif_trm290(i
 	}
 	printk(KERN_CONT " config base at 0x%04x\n", cfg_base);
 	hwif->config_data = cfg_base;
-	hwif->dma_base = (cfg_base + 4) ^ (hwif->channel ? 0x80 : 0);
-
-	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
-	       hwif->name, hwif->dma_base, hwif->dma_base + 3);
-
-	if (ide_allocate_dma_engine(hwif))
-		return;
 
 	local_irq_save(flags);
 	/* put config reg into first byte of hwif->select_data */
@@ -271,7 +190,6 @@ static void __devinit init_hwif_trm290(i
 		/* legacy mode */
 		hwif->irq = hwif->channel ? 15 : 14;
 
-#if 1
 	{
 	/*
 	 * My trm290-based card doesn't seem to work with all possible values
@@ -297,7 +215,6 @@ static void __devinit init_hwif_trm290(i
 				hwif->name, old, new & ~1);
 		}
 	}
-#endif
 }
 
 static const struct ide_tp_ops trm290_tp_ops = {
@@ -314,28 +231,11 @@ static const struct ide_tp_ops trm290_tp
 	.output_data		= ide_output_data,
 };
 
-static struct ide_dma_ops trm290_dma_ops = {
-	.dma_host_set		= trm290_dma_host_set,
-	.dma_setup 		= trm290_dma_setup,
-	.dma_start 		= trm290_dma_start,
-	.dma_end		= trm290_dma_end,
-	.dma_test_irq		= trm290_dma_test_irq,
-	.dma_lost_irq		= ide_dma_lost_irq,
-	.dma_check		= trm290_dma_check,
-};
-
 static const struct ide_port_info trm290_chipset __devinitdata = {
 	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_trm290,
 	.tp_ops 	= &trm290_tp_ops,
-	.dma_ops	= &trm290_dma_ops,
-	.host_flags	= IDE_HFLAG_TRM290 |
-			  IDE_HFLAG_NO_ATAPI_DMA |
-#if 0 /* play it safe for now */
-			  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
-#endif
-			  IDE_HFLAG_NO_AUTODMA |
-			  IDE_HFLAG_NO_LBA48,
+	.host_flags	= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_LBA48,
 };
 
 static int __devinit trm290_init_one(struct pci_dev *dev, const struct 
pci_device_id *id)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1260,8 +1260,6 @@ enum {
 	IDE_HFLAG_DTC2278		= (1 << 21),
 	/* 4 devices on a single set of I/O ports */
 	IDE_HFLAG_4DRIVES		= (1 << 22),
-	/* host is TRM290 */
-	IDE_HFLAG_TRM290		= (1 << 23),
 	/* use 32-bit I/O ops */
 	IDE_HFLAG_IO_32BIT		= (1 << 24),
 	/* unmask IRQs */
