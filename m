Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab0INAp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 20:45:59 -0400
Received: from gateway.crfreenet.org ([81.92.146.254]:38238 "EHLO
	mail.crfreenet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab0INAp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 20:45:58 -0400
Date: Tue, 14 Sep 2010 02:54:16 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: olivers137@aol.com, wim@iguana.be, linux-kernel@vger.kernel.org
Subject: [PATCH] it87_wdt: Add support for watchdogs with 8b timers
Message-ID: <20100914005416.GB25251@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for watchdogs with 8b timers, like ones in
IT8702F and older revisions of IT8712F Super IO chip, to it87_wdt
driver. This patch should be used after the patch
'it87_wdt: Add support for IT8720F watchdog'.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>

---

diff -uprN b/drivers/watchdog/Kconfig c/drivers/watchdog/Kconfig
--- b/drivers/watchdog/Kconfig	2010-09-13 19:03:43.000000000 +0200
+++ c/drivers/watchdog/Kconfig	2010-09-14 01:46:50.000000000 +0200
@@ -547,11 +547,11 @@ config IT87_WDT
 	tristate "IT87 Watchdog Timer"
 	depends on X86 && EXPERIMENTAL
 	---help---
-	  This is the driver for the hardware watchdog on the ITE
-	  IT8716, IT8718, IT8720, IT8726, IT8712(Version J,K) Super I/O
-	  chips. This watchdog simply watches your kernel to make sure
-	  it doesn't freeze, and if it does, it reboots your computer
-	  after a certain amount of time.
+	  This is the driver for the hardware watchdog on the ITE IT8702,
+	  IT8712, IT8716, IT8718, IT8720, IT8726, IT8712 Super I/O chips.
+	  This watchdog simply watches your kernel to make sure it doesn't
+	  freeze, and if it does, it reboots your computer after a certain
+	  amount of time.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called it87_wdt.
diff -uprN b/drivers/watchdog/it87_wdt.c c/drivers/watchdog/it87_wdt.c
--- b/drivers/watchdog/it87_wdt.c	2010-09-13 22:31:48.000000000 +0200
+++ c/drivers/watchdog/it87_wdt.c	2010-09-14 02:11:44.000000000 +0200
@@ -12,7 +12,7 @@
  *		    http://www.ite.com.tw/
  *
  *	Support of the watchdog timers, which are available on
- *	IT8716, IT8718, IT8720, IT8726 and IT8712 (J,K version).
+ *	IT8702, IT8712, IT8716, IT8718, IT8720 and IT8726.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -76,6 +76,7 @@
 
 /* Chip Id numbers */
 #define NO_DEV_ID	0xffff
+#define IT8702_ID	0x8702
 #define IT8705_ID	0x8705
 #define IT8712_ID	0x8712
 #define IT8716_ID	0x8716
@@ -133,7 +134,7 @@
 #define WDTS_USE_GP	4
 #define WDTS_EXPECTED	5
 
-static	unsigned int base, gpact, ciract;
+static	unsigned int base, gpact, ciract, max_units;
 static	unsigned long wdt_status;
 static	DEFINE_SPINLOCK(spinlock);
 
@@ -211,6 +212,33 @@ static inline void superio_outw(int val,
 	outb(val, VAL);
 }
 
+/* Internal function, should be called after superio_select(GPIO) */
+static void wdt_update_timeout(void)
+{
+	unsigned char cfg = WDT_KRST | WDT_PWROK;
+	int tm = timeout;
+
+	if (testmode)
+		cfg = 0;
+
+	if (tm <= max_units)
+		cfg |= WDT_TOV1;
+	else
+		tm /= 60;
+
+	superio_outb(cfg, WDTCFG);
+	superio_outb(tm, WDTVALLSB);
+	if (max_units > 255)
+		superio_outb(tm>>8, WDTVALMSB);
+}
+
+static int wdt_round_time(int t)
+{
+	t += 59;
+	t -= t % 60;
+	return t;
+}
+
 /* watchdog timer handling */
 
 static void wdt_keepalive(void)
@@ -235,12 +263,7 @@ static void wdt_start(void)
 		superio_outb(WDT_GAMEPORT, WDTCTRL);
 	else
 		superio_outb(WDT_CIRINT, WDTCTRL);
-	if (!testmode)
-		superio_outb(WDT_TOV1 | WDT_KRST | WDT_PWROK, WDTCFG);
-	else
-		superio_outb(WDT_TOV1, WDTCFG);
-	superio_outb(timeout>>8, WDTVALMSB);
-	superio_outb(timeout, WDTVALLSB);
+	wdt_update_timeout();
 
 	superio_exit();
 	spin_unlock_irqrestore(&spinlock, flags);
@@ -256,8 +279,9 @@ static void wdt_stop(void)
 	superio_select(GPIO);
 	superio_outb(0x00, WDTCTRL);
 	superio_outb(WDT_TOV1, WDTCFG);
-	superio_outb(0x00, WDTVALMSB);
 	superio_outb(0x00, WDTVALLSB);
+	if (max_units > 255)
+		superio_outb(0x00, WDTVALMSB);
 
 	superio_exit();
 	spin_unlock_irqrestore(&spinlock, flags);
@@ -267,8 +291,8 @@ static void wdt_stop(void)
  *	wdt_set_timeout - set a new timeout value with watchdog ioctl
  *	@t: timeout value in seconds
  *
- *	The hardware device has a 16 bit watchdog timer, thus the
- *	timeout time ranges between 1 and 65535 seconds.
+ *	The hardware device has a 8 or 16 bit watchdog timer (depends on
+ *	chip version) that can be configured to count seconds or minutes.
  *
  *	Used within WDIOC_SETTIMEOUT watchdog device ioctl.
  */
@@ -277,19 +301,19 @@ static int wdt_set_timeout(int t)
 {
 	unsigned long flags;
 
-	if (t < 1 || t > 65535)
+	if (t < 1 || t > max_units * 60)
 		return -EINVAL;
 
-	timeout = t;
+	if (t > max_units)
+		timeout = wdt_round_time(t);
+	else
+		timeout = t;
 
 	spin_lock_irqsave(&spinlock, flags);
 	if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
 		superio_enter();
-
 		superio_select(GPIO);
-		superio_outb(t>>8, WDTVALMSB);
-		superio_outb(t, WDTVALLSB);
-
+		wdt_update_timeout();
 		superio_exit();
 	}
 	spin_unlock_irqrestore(&spinlock, flags);
@@ -535,6 +559,8 @@ static int __init it87_wdt_init(void)
 	u8  chip_rev;
 	unsigned long flags;
 
+	wdt_status = 0;
+
 	spin_lock_irqsave(&spinlock, flags);
 	superio_enter();
 	chip_type = superio_inw(CHIPID);
@@ -543,16 +569,21 @@ static int __init it87_wdt_init(void)
 	spin_unlock_irqrestore(&spinlock, flags);
 
 	switch (chip_type) {
+	case IT8702_ID:
+		max_units = 255;
+		break;
+	case IT8712_ID:
+		max_units = (chip_rev < 8) ? 255 : 65535;
+		break;
 	case IT8716_ID:
 	case IT8726_ID:
+		max_units = 65535;
 		break;
 	case IT8718_ID:
 	case IT8720_ID:
+		max_units = 65535;
 		try_gameport = 0;
 		break;
-	case IT8712_ID:
-		if (chip_rev > 7)
-			break;
 	case IT8705_ID:
 		printk(KERN_ERR PFX
 		       "Unsupported Chip found, Chip %04x Revision %02x\n",
@@ -628,13 +659,16 @@ static int __init it87_wdt_init(void)
 		spin_unlock_irqrestore(&spinlock, flags);
 	}
 
-	if (timeout < 1 || timeout > 65535) {
+	if (timeout < 1 || timeout > max_units * 60) {
 		timeout = DEFAULT_TIMEOUT;
 		printk(KERN_WARNING PFX
 		       "Timeout value out of range, use default %d sec\n",
 		       DEFAULT_TIMEOUT);
 	}
 
+	if (timeout > max_units)
+		timeout = wdt_round_time(timeout);
+
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
 		printk(KERN_ERR PFX
@@ -661,7 +695,7 @@ static int __init it87_wdt_init(void)
 		outb(0x09, CIR_IER(base));
 	}
 
-	printk(KERN_INFO PFX "Chip it%04x revision %d initialized. "
+	printk(KERN_INFO PFX "Chip IT%04x revision %d initialized. "
 		"timeout=%d sec (nowayout=%d testmode=%d exclusive=%d "
 		"nogameport=%d)\n", chip_type, chip_rev, timeout,
 		nowayout, testmode, exclusive, nogameport);
@@ -703,8 +737,9 @@ static void __exit it87_wdt_exit(void)
 	superio_select(GPIO);
 	superio_outb(0x00, WDTCTRL);
 	superio_outb(0x00, WDTCFG);
-	superio_outb(0x00, WDTVALMSB);
 	superio_outb(0x00, WDTVALLSB);
+	if (max_units > 255)
+		superio_outb(0x00, WDTVALMSB);
 	if (test_bit(WDTS_USE_GP, &wdt_status)) {
 		superio_select(GAMEPORT);
 		superio_outb(gpact, ACTREG);


-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
