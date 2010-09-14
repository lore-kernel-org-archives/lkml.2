Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab0INAjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 20:39:14 -0400
Received: from gateway.crfreenet.org ([81.92.146.254]:38235 "EHLO
	mail.crfreenet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab0INAjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 20:39:13 -0400
Date: Tue, 14 Sep 2010 02:47:28 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: olivers137@aol.com, wim@iguana.be, linux-kernel@vger.kernel.org
Subject: [PATCH] it87_wdt: Add support for IT8720F watchdog
Message-ID: <20100914004728.GA25251@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple patch adds support for a watchdog in IT8720F Super IO chip
to it87_wdt driver.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>

---

diff -uprN a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig	2010-08-27 01:47:12.000000000 +0200
+++ b/drivers/watchdog/Kconfig	2010-09-13 19:03:43.000000000 +0200
@@ -547,10 +547,11 @@ config IT87_WDT
 	tristate "IT87 Watchdog Timer"
 	depends on X86 && EXPERIMENTAL
 	---help---
-	  This is the driver for the hardware watchdog on the ITE IT8716,
-	  IT8718, IT8726, IT8712(Version J,K) Super I/O chips. This watchdog
-	  simply watches your kernel to make sure it doesn't freeze, and if
-	  it does, it reboots your computer after a certain amount of time.
+	  This is the driver for the hardware watchdog on the ITE
+	  IT8716, IT8718, IT8720, IT8726, IT8712(Version J,K) Super I/O
+	  chips. This watchdog simply watches your kernel to make sure
+	  it doesn't freeze, and if it does, it reboots your computer
+	  after a certain amount of time.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called it87_wdt.
diff -uprN a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
--- a/drivers/watchdog/it87_wdt.c	2010-08-27 01:47:12.000000000 +0200
+++ b/drivers/watchdog/it87_wdt.c	2010-09-13 22:31:48.000000000 +0200
@@ -12,7 +12,7 @@
  *		    http://www.ite.com.tw/
  *
  *	Support of the watchdog timers, which are available on
- *	IT8716, IT8718, IT8726 and IT8712 (J,K version).
+ *	IT8716, IT8718, IT8720, IT8726 and IT8712 (J,K version).
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -45,7 +45,7 @@
 
 #include <asm/system.h>
 
-#define WATCHDOG_VERSION	"1.12"
+#define WATCHDOG_VERSION	"1.13"
 #define WATCHDOG_NAME		"IT87 WDT"
 #define PFX			WATCHDOG_NAME ": "
 #define DRIVER_VERSION		WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
@@ -80,6 +80,7 @@
 #define IT8712_ID	0x8712
 #define IT8716_ID	0x8716
 #define IT8718_ID	0x8718
+#define IT8720_ID	0x8720
 #define IT8726_ID	0x8726	/* the data sheet suggest wrongly 0x8716 */
 
 /* GPIO Configuration Registers LDN=0x07 */
@@ -92,7 +93,7 @@
 #define WDT_CIRINT	0x80
 #define WDT_MOUSEINT	0x40
 #define WDT_KYBINT	0x20
-#define WDT_GAMEPORT	0x10 /* not it8718 */
+#define WDT_GAMEPORT	0x10 /* not in it8718, it8720 */
 #define WDT_FORCE	0x02
 #define WDT_ZERO	0x01
 
@@ -529,6 +530,7 @@ static struct notifier_block wdt_notifie
 static int __init it87_wdt_init(void)
 {
 	int rc = 0;
+	int try_gameport = !nogameport;
 	u16 chip_type;
 	u8  chip_rev;
 	unsigned long flags;
@@ -542,9 +544,12 @@ static int __init it87_wdt_init(void)
 
 	switch (chip_type) {
 	case IT8716_ID:
-	case IT8718_ID:
 	case IT8726_ID:
 		break;
+	case IT8718_ID:
+	case IT8720_ID:
+		try_gameport = 0;
+		break;
 	case IT8712_ID:
 		if (chip_rev > 7)
 			break;
@@ -571,7 +576,7 @@ static int __init it87_wdt_init(void)
 	superio_outb(0x00, WDTCTRL);
 
 	/* First try to get Gameport support */
-	if (chip_type != IT8718_ID && !nogameport) {
+	if (try_gameport) {
 		superio_select(GAMEPORT);
 		base = superio_inw(BASEREG);
 		if (!base) {
@@ -676,7 +681,7 @@ err_out_region:
 		spin_unlock_irqrestore(&spinlock, flags);
 	}
 err_out:
-	if (chip_type != IT8718_ID && !nogameport) {
+	if (try_gameport) {
 		spin_lock_irqsave(&spinlock, flags);
 		superio_enter();
 		superio_select(GAMEPORT);


-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
