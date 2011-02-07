Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1BGK5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 05:57:40 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62311 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab1BGK5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 05:57:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:message-id:cc
         :content-type:content-transfer-encoding;
        b=ZDeBTM4PKor+F9ke5mBh8lz/N/CgnzlOOD4lCzq4yi7F3Ep/pOqIinXEEaTU1PCOw0
         mXVxNTqw6OC+FQske+ZltRqm5N2BMV8X42Uwik8ZJOinBSiarDuESRLUNw5QlZGoxGgf
         ZbvpzOggHtkhJotQM1dDIYtkYsQIAkG5KbZ3s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] cmd640: housekeeping
Date: Mon, 7 Feb 2011 11:47:28 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
MIME-Version: 1.0
Message-Id: <201102071147.29355.bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* remove stale ChangeLog
* removed unused defines
* remove CMD640_PREFETCH_MASKS define
* removed dead STUPIDLY_TRUST_BROKEN_PCMD_ENA_BIT code
* remove legacy CMD640_DUMP_REGS debugging code

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cmd640.c |  120 
---------------------------------------------------
 1 file changed, 2 insertions(+), 118 deletions(-)

Index: b/drivers/ide/cmd640.c
===================================================================
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -31,75 +31,13 @@
  *  steve@ei.org, ulrpeg@bigcomm.gun.de, ism@tardis.ed.ac.uk, mack@cray.com
  *  liug@mama.indstate.edu, and others.
  *
- *  Version 0.01	Initial version, hacked out of ide.c,
- *			and #include'd rather than compiled separately.
- *			This will get cleaned up in a subsequent release.
- *
- *  Version 0.02	Fixes for vlb initialization code, enable prefetch
- *			for versions 'B' and 'C' of chip by default,
- *			some code cleanup.
- *
- *  Version 0.03	Added reset of secondary interface,
- *			and black list for devices which are not compatible
- *			with prefetch mode. Separate function for setting
- *			prefetch is added, possibly it will be called some
- *			day from ioctl processing code.
- *
- *  Version 0.04	Now configs/compiles separate from ide.c
- *
- *  Version 0.05	Major rewrite of interface timing code.
- *			Added new function cmd640_set_mode to set PIO mode
- *			from ioctl call. New drives added to black list.
- *
- *  Version 0.06	More code cleanup. Prefetch is enabled only for
- *			detected hard drives, not included in prefetch
- *			black list.
- *
- *  Version 0.07	Changed to more conservative drive tuning policy.
- *			Unknown drives, which report PIO < 4 are set to
- *			(reported_PIO - 1) if it is supported, or to PIO0.
- *			List of known drives extended by info provided by
- *			CMD at their ftp site.
- *
- *  Version 0.08	Added autotune/noautotune support.
- *
- *  Version 0.09	Try to be smarter about 2nd port enabling.
- *  Version 0.10	Be nice and don't reset 2nd port.
- *  Version 0.11	Try to handle more weird situations.
- *
+ * ...
  *  Version 0.12	Lots of bug fixes from Laszlo Peter
- *			irq unmasking disabled for reliability.
- *			try to be even smarter about the second port.
- *			tidy up source code formatting.
- *  Version 0.13	permit irq unmasking again.
- *  Version 0.90	massive code cleanup, some bugs fixed.
- *			defaults all drives to PIO mode0, prefetch off.
- *			autotune is OFF by default, with compile time flag.
- *			prefetch can be turned OFF/ON using "hdparm -p8/-p9"
- *			 (requires hdparm-3.1 or newer)
- *  Version 0.91	first release to linux-kernel list.
- *  Version 0.92	move initial reg dump to separate callable function
- *			change "readahead" to "prefetch" to avoid confusion
- *  Version 0.95	respect original BIOS timings unless autotuning.
- *			tons of code cleanup and rearrangement.
- *			added CONFIG_BLK_DEV_CMD640_ENHANCED option
- *			prevent use of unmask when prefetch is on
- *  Version 0.96	prevent use of io_32bit when prefetch is off
- *  Version 0.97	fix VLB secondary interface for sjd@slip.net
- *			other minor tune-ups:  0.96 was very good.
- *  Version 0.98	ignore PCI version when disabled by BIOS
- *  Version 0.99	display setup/active/recovery clocks with PIO mode
- *  Version 1.00	Mmm.. cannot depend on PCMD_ENA in all systems
- *  Version 1.01	slow/fast devsel can be selected with "hdparm -p6/-p7"
- *			 ("fast" is necessary for 32bit I/O in some systems)
+ * ...
  *  Version 1.02	fix bug that resulted in slow "setup times"
  *			 (patch courtesy of Zoltan Hidvegi)
  */
 
-#define CMD640_PREFETCH_MASKS 1
-
-/*#define CMD640_DUMP_REGS */
-
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
@@ -116,29 +54,10 @@ static int cmd640_vlb;
  * CMD640 specific registers definition.
  */
 
-#define VID		0x00
-#define DID		0x02
-#define PCMD		0x04
-#define   PCMD_ENA	0x01
-#define PSTTS		0x06
-#define REVID		0x08
-#define PROGIF		0x09
-#define SUBCL		0x0a
-#define BASCL		0x0b
-#define BaseA0		0x10
-#define BaseA1		0x14
-#define BaseA2		0x18
-#define BaseA3		0x1c
-#define INTLINE		0x3c
-#define INPINE		0x3d
-
 #define	CFR		0x50
 #define   CFR_DEVREV		0x03
 #define   CFR_IDE01INTR		0x04
-#define	  CFR_DEVID		0x18
 #define	  CFR_AT_VESA_078h	0x20
-#define	  CFR_DSA1		0x40
-#define	  CFR_DSA0		0x80
 
 #define CNTRL		0x51
 #define	  CNTRL_DIS_RA0		0x40
@@ -273,12 +192,6 @@ static int __init match_pci_cmd640_devic
 		if (get_cmd640_reg(i) != ven_dev[i])
 			return 0;
 	}
-#ifdef STUPIDLY_TRUST_BROKEN_PCMD_ENA_BIT
-	if ((get_cmd640_reg(PCMD) & PCMD_ENA) == 0) {
-		printk("ide: cmd640 on PCI disabled by BIOS\n");
-		return 0;
-	}
-#endif /* STUPIDLY_TRUST_BROKEN_PCMD_ENA_BIT */
 	return 1; /* success */
 }
 
@@ -356,32 +269,11 @@ static int __init secondary_port_respond
 	return 1; /* success */
 }
 
-#ifdef CMD640_DUMP_REGS
-/*
- * Dump out all cmd640 registers.  May be called from ide.c
- */
-static void cmd640_dump_regs(void)
-{
-	unsigned int reg = cmd640_vlb ? 0x50 : 0x00;
-
-	/* Dump current state of chip registers */
-	printk("ide: cmd640 internal register dump:");
-	for (; reg <= 0x59; reg++) {
-		if (!(reg & 0x0f))
-			printk("\n%04x:", reg);
-		printk(" %02x", get_cmd640_reg(reg));
-	}
-	printk("\n");
-}
-#endif
-
 static void __set_prefetch_mode(ide_drive_t *drive, int mode)
 {
 	if (mode) {	/* want prefetch on? */
-#if CMD640_PREFETCH_MASKS
 		drive->dev_flags |= IDE_DFLAG_NO_UNMASK;
 		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
-#endif
 		drive->dev_flags &= ~IDE_DFLAG_NO_IO_32BIT;
 	} else {
 		drive->dev_flags &= ~IDE_DFLAG_NO_UNMASK;
@@ -745,10 +637,6 @@ static int __init cmd640x_init(void)
 	}
 	put_cmd640_reg(0x5b, 0);
 
-#ifdef CMD640_DUMP_REGS
-	cmd640_dump_regs();
-#endif
-
 	/*
 	 * Documented magic begins here
 	 */
@@ -830,10 +718,6 @@ static int __init cmd640x_init(void)
 	printk(KERN_INFO "cmd640: %sserialized, secondary interface %s\n",
 			 second_port_cmd640 ? "" : "not ", port2);
 
-#ifdef CMD640_DUMP_REGS
-	cmd640_dump_regs();
-#endif
-
 	return ide_host_add(&cmd640_port_info, hws, second_port_cmd640 ? 2 : 1,
 			    NULL);
 }
