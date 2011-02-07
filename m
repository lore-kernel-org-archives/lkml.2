Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab1BGK56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 05:57:58 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59026 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab1BGK5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 05:57:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=PHQeYVvMgalCirIqXfqg9AE1MfKuy9ODOCjbqVpsUntEb8zEXA9swTFHOqowOhPH5q
         fbgESy8QkBI6dXwCkAst+ldKdoIWCoCW3lT+Mz+6PI/Vt9JB5pfiszzKB2lF1izDOJFz
         J21/0jtNVaKGtmEimsDEBOQvNiwm021/6D1gA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: legacy VLB drivers housekeeping
Date: Mon, 7 Feb 2011 11:53:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102071153.37633.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* remove stale documentation
* remove dead ALWAYS_SET_DTC2278_PIO_MODE code from dtc2278
* remove legacy debugging code from ht6560b

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ali14xx.c |   28 +----------------
 drivers/ide/dtc2278.c |   50 +++++++-------------------------
 drivers/ide/ht6560b.c |   78 
+-------------------------------------------------
 drivers/ide/qd65xx.c  |   43 ---------------------------
 drivers/ide/umc8672.c |   20 ------------
 5 files changed, 17 insertions(+), 202 deletions(-)

Index: b/drivers/ide/ali14xx.c
===================================================================
--- a/drivers/ide/ali14xx.c
+++ b/drivers/ide/ali14xx.c
@@ -7,32 +7,7 @@
  *
  * Works for ALI M1439/1443/1445/1487/1489 chipsets.
  *
- * Adapted from code developed by derekn@vw.ece.cmu.edu.  -ml
- * Derek's notes follow:
- *
- * I think the code should be pretty understandable,
- * but I'll be happy to (try to) answer questions.
- *
- * The critical part is in the setupDrive function.  The initRegisters
- * function doesn't seem to be necessary, but the DOS driver does it, so
- * I threw it in.
- *
- * I've only tested this on my system, which only has one disk.  I posted
- * it to comp.sys.linux.hardware, so maybe some other people will try it
- * out.
- *
- * Derek Noonburg  (derekn@ece.cmu.edu)
- * 95-sep-26
- *
- * Update 96-jul-13:
- *
- * I've since upgraded to two disks and a CD-ROM, with no trouble, and
- * I've also heard from several others who have used it successfully.
- * This driver appears to work with both the 1443/1445 and the 1487/1489
- * chipsets.  I've added support for PIO mode 4 for the 1487.  This
- * seems to work just fine on the 1443 also, although I'm not sure it's
- * advertised as supporting mode 4.  (I've been running a WDC AC21200 in
- * mode 4 for a while now with no trouble.)  -Derek
+ * Adapted from code developed by Derek Noonburg <derekn@vw.ece.cmu.edu>.  -
ml
  */
 
 #include <linux/module.h>
@@ -177,6 +152,7 @@ static int __init findPort(void)
 
 /*
  * Initialize controller registers with default values.
+ * (doesn't seem to be necessary but the DOS driver does it).
  */
 static int __init initRegisters(void)
 {
Index: b/drivers/ide/dtc2278.c
===================================================================
--- a/drivers/ide/dtc2278.c
+++ b/drivers/ide/dtc2278.c
@@ -2,6 +2,17 @@
  *  Copyright (C) 1996  Linus Torvalds & author (see below)
  */
 
+/*
+ * Initial DTC-2278 support from Dyan Wile <andy@cercle.cts.com>.
+ */
+
+/*
+ * DTC2278S has only a single IDE interface
+ * DTC2278D has two IDE interfaces and is otherwise identical to the S 
version
+ * DTC2278E also has serial ports and a printer port
+ * DTC2278EB: has onboard BIOS
+ */
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -17,37 +28,6 @@
 
 #define DRV_NAME "dtc2278"
 
-/*
- * Changing this #undef to #define may solve start up problems in some 
systems.
- */
-#undef ALWAYS_SET_DTC2278_PIO_MODE
-
-/*
- * From: andy@cercle.cts.com (Dyan Wile)
- *
- * Below is a patch for DTC-2278 - alike software-programmable controllers
- * The code enables the secondary IDE controller and the PIO4 (3?) timings on
- * the primary (EIDE). You may probably have to enable the 32-bit support to
- * get the full speed. You better get the disk interrupts disabled ( hdparm -
u0
- * /dev/hd.. ) for the drives connected to the EIDE interface. (I get my
- * filesystem  corrupted with -u1, but under heavy disk load only :-)
- *
- * This card is now forced to use the "serialize" feature,
- * and irq-unmasking is disallowed.  If io_32bit is enabled,
- * it must be done for BOTH drives on each interface.
- *
- * This code was written for the DTC2278E, but might work with any of these:
- *
- * DTC2278S has only a single IDE interface.
- * DTC2278D has two IDE interfaces and is otherwise identical to the S 
version.
- * DTC2278E also has serial ports and a printer port
- * DTC2278EB: has onboard BIOS, and "works like a charm" -- Kent Bradford 
<kent@theory.caltech.edu>
- *
- * There may be a fourth controller type. The S and D versions use the
- * Winbond chip, and I think the E version does also.
- *
- */
-
 static void sub22 (char b, char c)
 {
 	int i;
@@ -117,14 +97,6 @@ static int __init dtc2278_probe(void)
 	inb(0x3f6);
 	outb_p(0x20,0xb4);
 	inb(0x3f6);
-#ifdef ALWAYS_SET_DTC2278_PIO_MODE
-	/*
-	 * This enables PIO mode4 (3?) on the first interface
-	 * and may solve start-up problems for some people.
-	 */
-	sub22(1,0xc3);
-	sub22(0,0xa0);
-#endif
 	local_irq_restore(flags);
 
 	return ide_legacy_device_add(&dtc2278_port_info, 0);
Index: b/drivers/ide/ht6560b.c
===================================================================
--- a/drivers/ide/ht6560b.c
+++ b/drivers/ide/ht6560b.c
@@ -4,8 +4,6 @@
 
 /*
  *  HT-6560B EIDE-controller support
- *  To activate controller support use kernel parameter "ide0=ht6560b".
- *  Use hdparm utility to enable PIO mode support.
  *
  *  Author:    Mikko Ala-Fossi            <maf@iki.fi>
  *             Jan Evert van Grootheest   <j.e.van.grootheest@caiway.nl>
@@ -28,8 +26,6 @@
 
 #include <asm/io.h>
 
-/* #define DEBUG */  /* remove comments for DEBUG messages */
-
 /*
  * The special i/o-port that HT-6560B uses to configuration:
  *    bit0 (0x01): "1" selects secondary interface
@@ -53,47 +49,9 @@ static inline u8 HT_CONFIG(ide_drive_t *
  * FIFO + PREFETCH (both a/b-model)
  */
 #define HT_CONFIG_DEFAULT 0x1c /* no prefetch */
-/* #define HT_CONFIG_DEFAULT 0x3c */ /* with prefetch */
 #define HT_SECONDARY_IF	  0x01
 #define HT_PREFETCH_MODE  0x20
 
-/*
- * ht6560b Timing values:
- *
- * I reviewed some assembler source listings of htide drivers and found
- * out how they setup those cycle time interfacing values, as they at Holtek
- * call them. IDESETUP.COM that is supplied with the drivers figures out
- * optimal values and fetches those values to drivers. I found out that
- * they use Select register to fetch timings to the ide board right after
- * interface switching. After that it was quite easy to add code to
- * ht6560b.c.
- *
- * IDESETUP.COM gave me values 0x24, 0x45, 0xaa, 0xff that worked fine
- * for hda and hdc. But hdb needed higher values to work, so I guess
- * that sometimes it is necessary to give higher value than IDESETUP
- * gives.   [see cmd640.c for an extreme example of this. -ml]
- *
- * Perhaps I should explain something about these timing values:
- * The higher nibble of value is the Recovery Time  (rt) and the lower nibble
- * of the value is the Active Time  (at). Minimum value 2 is the fastest and
- * the maximum value 15 is the slowest. Default values should be 15 for both.
- * So 0x24 means 2 for rt and 4 for at. Each of the drives should have
- * both values, and IDESETUP gives automatically rt=15 st=15 for CDROMs or
- * similar. If value is too small there will be all sorts of failures.
- *
- * Timing byte consists of
- *	High nibble:  Recovery Cycle Time  (rt)
- *	     The valid values range from 2 to 15. The default is 15.
- *
- *	Low nibble:   Active Cycle Time	   (at)
- *	     The valid values range from 2 to 15. The default is 15.
- *
- * You can obtain optimized timing values by running Holtek IDESETUP.COM
- * for DOS. DOS drivers get their timing values from command line, where
- * the first value is the Recovery Time and the second value is the
- * Active Time for each drive. Smaller value gives higher speed.
- * In case of failures you should probably fall back to a higher value.
- */
 static inline u8 HT_TIMING(ide_drive_t *drive)
 {
 	return (unsigned long)ide_get_drivedata(drive) & 0x00ff;
@@ -107,10 +65,6 @@ static inline u8 HT_TIMING(ide_drive_t *
  * The HT-6560B can only enable one IDE port at a time, and requires a
  * silly sequence (below) whenever we switch between primary and secondary.
  */
-
-/*
- * This routine is invoked from ide.c to prepare for access to a given drive.
- */
 static void ht6560b_dev_select(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -145,10 +99,6 @@ static void ht6560b_dev_select(ide_drive
 		 */
 		outb(timing, hwif->io_ports.device_addr);
 		(void)inb(hwif->io_ports.status_addr);
-#ifdef DEBUG
-		printk("ht6560b: %s: select=%#x timing=%#x\n",
-			drive->name, select, timing);
-#endif
 	}
 	local_irq_restore(flags);
 
@@ -187,11 +137,7 @@ static int __init try_to_init_ht6560b(vo
 	(void)inb(0x1f7);		/* Status register */
 
 	printk("ht6560b " HT6560B_VERSION
-	       ": chipset detected and initialized"
-#ifdef DEBUG
-	       " with debug enabled"
-#endif
-	       "\n"
+	       ": chipset detected and initialized\n"
 		);
 	return 1;
 }
@@ -227,20 +173,10 @@ static u8 ht_pio2timings(ide_drive_t *dr
 		if (recovery_cycles < 2)  recovery_cycles = 2;
 		if (active_cycles   > 15) active_cycles   = 15;
 		if (recovery_cycles > 15) recovery_cycles = 0;  /* 0==16 */
-		
-#ifdef DEBUG
-		printk("ht6560b: drive %s setting pio=%d recovery=%d (%dns) 
active=%d (%dns)\n", drive->name, pio, recovery_cycles, recovery_time, 
active_cycles, active_time);
-#endif
-		
+
 		return (u8)((recovery_cycles << 4) | active_cycles);
-	} else {
-		
-#ifdef DEBUG
-		printk("ht6560b: drive %s setting pio=0\n", drive->name);
-#endif
-		
+	} else
 		return HT_TIMING_DEFAULT;    /* default setting */
-	}
 }
 
 static DEFINE_SPINLOCK(ht6560b_lock);
@@ -272,10 +208,6 @@ static void ht_set_prefetch(ide_drive_t
 	ide_set_drivedata(drive, (void *)config);
 
 	spin_unlock_irqrestore(&ht6560b_lock, flags);
-
-#ifdef DEBUG
-	printk("ht6560b: drive %s prefetch mode %sabled\n", drive->name, (state ? 
"en" : "dis"));
-#endif
 }
 
 static void ht6560b_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
@@ -299,10 +231,6 @@ static void ht6560b_set_pio_mode(ide_hwi
 	config |= timing;
 	ide_set_drivedata(drive, (void *)config);
 	spin_unlock_irqrestore(&ht6560b_lock, flags);
-
-#ifdef DEBUG
-	printk("ht6560b: drive %s tuned to pio mode %#x timing=%#x\n", drive-
>name, pio, timing);
-#endif
 }
 
 static void __init ht6560b_init_dev(ide_drive_t *drive)
Index: b/drivers/ide/qd65xx.c
===================================================================
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -3,15 +3,7 @@
  */
 
 /*
- *  Version 0.03	Cleaned auto-tune, added probe
- *  Version 0.04	Added second channel tuning
- *  Version 0.05	Enhanced tuning ; added qd6500 support
- *  Version 0.06	Added dos driver's list
- *  Version 0.07	Second channel bug fix 
- *
  * QDI QD6500/QD6580 EIDE controller fast support
- *
- * To activate controller support, use "ide0=qd65xx"
  */
 
 /*
@@ -47,41 +39,6 @@
  * http://www.ryston.cz/petr/vlb
  */
 
-/*
- * base: Timer1
- *
- *
- * base+0x01: Config (R/O)
- *
- * bit 0: ide baseport: 1 = 0x1f0 ; 0 = 0x170 (only useful for qd6500)
- * bit 1: qd65xx baseport: 1 = 0xb0 ; 0 = 0x30
- * bit 2: ID3: bus speed: 1 = <=33MHz ; 0 = >33MHz
- * bit 3: qd6500: 1 = disabled, 0 = enabled
- *        qd6580: 1
- * upper nibble:
- *        qd6500: 1100
- *        qd6580: either 1010 or 0101
- *
- *
- * base+0x02: Timer2 (qd6580 only)
- *
- *
- * base+0x03: Control (qd6580 only)
- *
- * bits 0-3 must always be set 1
- * bit 4 must be set 1, but is set 0 by dos driver while measuring vlb clock
- * bit 0 : 1 = Only primary port enabled : channel 0 for hda, channel 1 for 
hdb
- *         0 = Primary and Secondary ports enabled : channel 0 for hda & hdb
- *                                                   channel 1 for hdc & hdd
- * bit 1 : 1 = only disks on primary port
- *         0 = disks & ATAPI devices on primary port
- * bit 2-4 : always 0
- * bit 5 : status, but of what ?
- * bit 6 : always set 1 by dos driver
- * bit 7 : set 1 for non-ATAPI devices on primary port
- *	(maybe read-ahead and post-write buffer ?)
- */
-
 static int timings[4]={-1,-1,-1,-1}; /* stores current timing for each timer 
*/
 
 /*
Index: b/drivers/ide/umc8672.c
===================================================================
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -5,8 +5,7 @@
 /*
  *  Principal Author/Maintainer:  PODIEN@hml2.atlas.de (Wolfram Podien)
  *
- *  This file provides support for the advanced features
- *  of the UMC 8672 IDE interface.
+ *  UMC 8672 IDE interface
  *
  *  Version 0.01	Initial version, hacked out of ide.c,
  *			and #include'd rather than compiled separately.
@@ -18,23 +17,6 @@
  *			add detection of possible race condition  -ml
  */
 
-/*
- * VLB Controller Support from
- * Wolfram Podien
- * Rohoefe 3
- * D28832 Achim
- * Germany
- *
- * To enable UMC8672 support there must a lilo line like
- * append="ide0=umc8672"...
- * To set the speed according to the abilities of the hardware there must be 
a
- * line like
- * #define UMC_DRIVE0 11
- * in the beginning of the driver, which sets the speed of drive 0 to 11 
(there
- * are some lines present). 0 - 11 are allowed speed values. These values are
- * the results from the DOS speed test program supplied from UMC. 11 is the
- * highest speed (about PIO mode 3)
- */
 #define REALLY_SLOW_IO		/* some systems can safely undef this */
 
 #include <linux/module.h>
