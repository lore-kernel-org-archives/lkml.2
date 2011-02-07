Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1BGND6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 08:03:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65130 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1BGND4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 08:03:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=WvD0Dna5jshuUtYx0YbPF4sze0cOkEKLPpm907Zm+TR22dewtmwePxV3yYiEubrZmL
         JBiDiwnu04TEVVRejjU5BYUBZAj0x7/GjjtwemNz7zDbBxf0Fg0bcPLgdbvbM1/7H27R
         uDZ/QvREMQFylhZLIhovCTTkD70slRnX9miDc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2 fixed] cmd640: always use enhanced support
Date: Mon, 7 Feb 2011 14:02:56 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201102071402.57357.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
fixed word-wrapping

 drivers/ide/Kconfig  |   10 ----------
 drivers/ide/cmd640.c |   29 -----------------------------
 2 files changed, 39 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -249,16 +249,6 @@ config BLK_DEV_CMD640
 	  the "CSA-6400E PCI to IDE controller" that some people have. For
 	  details, read <file:Documentation/ide/ide.txt>.
 
-config BLK_DEV_CMD640_ENHANCED
-	bool "CMD640 enhanced support"
-	depends on BLK_DEV_CMD640
-	help
-	  This option includes support for setting/autotuning PIO modes and
-	  prefetch on CMD640 IDE interfaces.  For details, read
-	  <file:Documentation/ide/ide.txt>. If you have a CMD640 IDE interface
-	  and your BIOS does not already do this for you, then say Y here.
-	  Otherwise say N.
-
 config BLK_DEV_IDEPNP
 	tristate "PNP EIDE support"
 	depends on PNP
Index: b/drivers/ide/cmd640.c
===================================================================
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -82,8 +82,6 @@ static int cmd640_vlb;
 static u8 prefetch_regs[4]  = {CNTRL, CNTRL, ARTTIM23, ARTTIM23};
 static u8 prefetch_masks[4] = {CNTRL_DIS_RA0, CNTRL_DIS_RA1, ARTTIM23_DIS_RA2, ARTTIM23_DIS_RA3};
 
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-
 static u8 arttim_regs[4] = {ARTTIM0, ARTTIM1, ARTTIM23, ARTTIM23};
 static u8 drwtim_regs[4] = {DRWTIM0, DRWTIM1, DRWTIM23, DRWTIM23};
 
@@ -95,8 +93,6 @@ static u8 setup_counts[4]    = {4, 4, 4,
 static u8 active_counts[4]   = {16, 16, 16, 16}; /* Active count   (encoded) */
 static u8 recovery_counts[4] = {16, 16, 16, 16}; /* Recovery count (encoded) */
 
-#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
-
 static DEFINE_SPINLOCK(cmd640_lock);
 
 /*
@@ -282,19 +278,6 @@ static void __set_prefetch_mode(ide_driv
 	}
 }
 
-#ifndef CONFIG_BLK_DEV_CMD640_ENHANCED
-/*
- * Check whether prefetch is on for a drive,
- * and initialize the unmask flags for safe operation.
- */
-static void __init check_prefetch(ide_drive_t *drive, unsigned int index)
-{
-	u8 b = get_cmd640_reg(prefetch_regs[index]);
-
-	__set_prefetch_mode(drive, (b & prefetch_masks[index]) ? 0 : 1);
-}
-#else
-
 /*
  * Sets prefetch mode for a drive.
  */
@@ -496,13 +479,11 @@ static void cmd640_set_pio_mode(ide_hwif
 
 	display_clocks(index);
 }
-#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
 static void __init cmd640_init_dev(ide_drive_t *drive)
 {
 	unsigned int i = drive->hwif->channel * 2 + (drive->dn & 1);
 
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 	/*
 	 * Reset timing to the slowest speed and turn off prefetch.
 	 * This way, the drive identify code has a better chance.
@@ -513,14 +494,6 @@ static void __init cmd640_init_dev(ide_d
 	program_drive_counts(drive, i);
 	set_prefetch_mode(drive, i, 0);
 	printk(KERN_INFO DRV_NAME ": drive%d timings/prefetch cleared\n", i);
-#else
-	/*
-	 * Set the drive unmask flags to match the prefetch setting.
-	 */
-	check_prefetch(drive, i);
-	printk(KERN_INFO DRV_NAME ": drive%d timings/prefetch(%s) preserved\n",
-		i, (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT) ? "off" : "on");
-#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 }
 
 static int cmd640_test_irq(ide_hwif_t *hwif)
@@ -535,9 +508,7 @@ static int cmd640_test_irq(ide_hwif_t *h
 
 static const struct ide_port_ops cmd640_port_ops = {
 	.init_dev		= cmd640_init_dev,
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 	.set_pio_mode		= cmd640_set_pio_mode,
-#endif
 	.test_irq		= cmd640_test_irq,
 };
 
