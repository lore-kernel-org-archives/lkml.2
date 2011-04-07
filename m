Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab1DGV1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:27:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42854 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab1DGV12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:27:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to;
	b=Gj3FiNEZoRXNVMrJJt8mDJWbSQsHMm8SBqZ12HhVaq9J2VwWrTmXkG1fRu5J6Wm8Q
	CTxic3SvX3g+w9Al+gowQ==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v2 2/3] Change IT87 drivers to use it87_io_lock.
Date: Thu,  7 Apr 2011 14:26:47 -0700
Message-Id: <1302211607-8121-1-git-send-email-natg@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: [PATCH v2 0/3] Make all it87 drivers SMP safe.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02 - Adds changes to watchdog drivers to use the new lock.
   This patch changes it8712f_wdt.c and it87_wdt.c to use the new
it87_io_lock to serialize access to the hardware.
   The routines accessing the hardware are being called from module init,
open, ioctl and module exit routines and hence it is sufficient to use
calls to spin_lock and spin_unlock to acquire and release the locks. For
the same reasons it87_wdt.c has extensive changes to remove calls to
spin_lock_irqsave and spin_unlock_irqrestore. The lock is now acquired
in superio_enter and released in superio_exit. This is now identical
to the code in drivers/hwmon/it87.c and drivers/watchdog/it8712f_wdt.c.
Added __acquire and __release annotations wherever needed.

Signed-off-by: Nat Gurumoorthy <natg@google.com>
---

diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index b32c6c0..03a3e89 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -32,6 +32,7 @@
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/it87_lock.h>
 
 #define NAME "it8712f_wdt"
 
@@ -51,7 +52,6 @@ MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
 
 static unsigned long wdt_open;
 static unsigned expect_close;
-static spinlock_t io_lock;
 static unsigned char revision;
 
 /* Dog Food address - We use the game port address */
@@ -122,8 +122,9 @@ static inline void superio_select(int ldn)
 }
 
 static inline void superio_enter(void)
+__acquires(&it87_io_lock)
 {
-	spin_lock(&io_lock);
+	spin_lock(&it87_io_lock);
 	outb(0x87, REG);
 	outb(0x01, REG);
 	outb(0x55, REG);
@@ -131,10 +132,11 @@ static inline void superio_enter(void)
 }
 
 static inline void superio_exit(void)
+__releases(&it87_io_lock)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
-	spin_unlock(&io_lock);
+	spin_unlock(&it87_io_lock);
 }
 
 static inline void it8712f_wdt_ping(void)
@@ -382,8 +384,6 @@ static int __init it8712f_wdt_init(void)
 {
 	int err = 0;
 
-	spin_lock_init(&io_lock);
-
 	if (it8712f_wdt_find(&address))
 		return -ENODEV;
 
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index dad2924..87ac31d 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -42,6 +42,7 @@
 #include <linux/reboot.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/it87_lock.h>
 
 #include <asm/system.h>
 
@@ -136,7 +137,6 @@
 
 static	unsigned int base, gpact, ciract, max_units;
 static	unsigned long wdt_status;
-static	DEFINE_SPINLOCK(spinlock);
 
 static	int nogameport = DEFAULT_NOGAMEPORT;
 static	int exclusive  = DEFAULT_EXCLUSIVE;
@@ -163,7 +163,9 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started, default="
 /* Superio Chip */
 
 static inline void superio_enter(void)
+__acquires(&it87_io_lock)
 {
+	spin_lock(&it87_io_lock);
 	outb(0x87, REG);
 	outb(0x01, REG);
 	outb(0x55, REG);
@@ -171,9 +173,11 @@ static inline void superio_enter(void)
 }
 
 static inline void superio_exit(void)
+__releases(&it87_io_lock)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
+	spin_unlock(&it87_io_lock);
 }
 
 static inline void superio_select(int ldn)
@@ -253,9 +257,6 @@ static void wdt_keepalive(void)
 
 static void wdt_start(void)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&spinlock, flags);
 	superio_enter();
 
 	superio_select(GPIO);
@@ -266,14 +267,10 @@ static void wdt_start(void)
 	wdt_update_timeout();
 
 	superio_exit();
-	spin_unlock_irqrestore(&spinlock, flags);
 }
 
 static void wdt_stop(void)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&spinlock, flags);
 	superio_enter();
 
 	superio_select(GPIO);
@@ -284,7 +281,6 @@ static void wdt_stop(void)
 		superio_outb(0x00, WDTVALMSB);
 
 	superio_exit();
-	spin_unlock_irqrestore(&spinlock, flags);
 }
 
 /**
@@ -299,8 +295,6 @@ static void wdt_stop(void)
 
 static int wdt_set_timeout(int t)
 {
-	unsigned long flags;
-
 	if (t < 1 || t > max_units * 60)
 		return -EINVAL;
 
@@ -309,14 +303,12 @@ static int wdt_set_timeout(int t)
 	else
 		timeout = t;
 
-	spin_lock_irqsave(&spinlock, flags);
 	if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
 		superio_enter();
 		superio_select(GPIO);
 		wdt_update_timeout();
 		superio_exit();
 	}
-	spin_unlock_irqrestore(&spinlock, flags);
 	return 0;
 }
 
@@ -335,11 +327,8 @@ static int wdt_set_timeout(int t)
 
 static int wdt_get_status(int *status)
 {
-	unsigned long flags;
-
 	*status = 0;
 	if (testmode) {
-		spin_lock_irqsave(&spinlock, flags);
 		superio_enter();
 		superio_select(GPIO);
 		if (superio_inb(WDTCTRL) & WDT_ZERO) {
@@ -349,7 +338,6 @@ static int wdt_get_status(int *status)
 		}
 
 		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 	if (test_and_clear_bit(WDTS_KEEPALIVE, &wdt_status))
 		*status |= WDIOF_KEEPALIVEPING;
@@ -557,16 +545,13 @@ static int __init it87_wdt_init(void)
 	int try_gameport = !nogameport;
 	u16 chip_type;
 	u8  chip_rev;
-	unsigned long flags;
 
 	wdt_status = 0;
 
-	spin_lock_irqsave(&spinlock, flags);
 	superio_enter();
 	chip_type = superio_inw(CHIPID);
 	chip_rev  = superio_inb(CHIPREV) & 0x0f;
 	superio_exit();
-	spin_unlock_irqrestore(&spinlock, flags);
 
 	switch (chip_type) {
 	case IT8702_ID:
@@ -599,7 +584,6 @@ static int __init it87_wdt_init(void)
 		return -ENODEV;
 	}
 
-	spin_lock_irqsave(&spinlock, flags);
 	superio_enter();
 
 	superio_select(GPIO);
@@ -617,14 +601,12 @@ static int __init it87_wdt_init(void)
 		gpact = superio_inb(ACTREG);
 		superio_outb(0x01, ACTREG);
 		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 		if (request_region(base, 1, WATCHDOG_NAME))
 			set_bit(WDTS_USE_GP, &wdt_status);
 		else
 			rc = -EIO;
 	} else {
 		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 
 	/* If we haven't Gameport support, try to get CIR support */
@@ -642,7 +624,6 @@ static int __init it87_wdt_init(void)
 			goto err_out;
 		}
 		base = CIR_BASE;
-		spin_lock_irqsave(&spinlock, flags);
 		superio_enter();
 
 		superio_select(CIR);
@@ -656,7 +637,6 @@ static int __init it87_wdt_init(void)
 		}
 
 		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 
 	if (timeout < 1 || timeout > max_units * 60) {
@@ -686,6 +666,7 @@ static int __init it87_wdt_init(void)
 
 	/* Initialize CIR to use it as keepalive source */
 	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
+		spin_lock(&it87_io_lock);
 		outb(0x00, CIR_RCR(base));
 		outb(0xc0, CIR_TCR1(base));
 		outb(0x5c, CIR_TCR2(base));
@@ -693,6 +674,7 @@ static int __init it87_wdt_init(void)
 		outb(0x00, CIR_BDHR(base));
 		outb(0x01, CIR_BDLR(base));
 		outb(0x09, CIR_IER(base));
+		spin_unlock(&it87_io_lock);
 	}
 
 	printk(KERN_INFO PFX "Chip IT%04x revision %d initialized. "
@@ -707,21 +689,17 @@ err_out_reboot:
 err_out_region:
 	release_region(base, test_bit(WDTS_USE_GP, &wdt_status) ? 1 : 8);
 	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
-		spin_lock_irqsave(&spinlock, flags);
 		superio_enter();
 		superio_select(CIR);
 		superio_outb(ciract, ACTREG);
 		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 err_out:
 	if (try_gameport) {
-		spin_lock_irqsave(&spinlock, flags);
 		superio_enter();
 		superio_select(GAMEPORT);
 		superio_outb(gpact, ACTREG);
 		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 
 	return rc;
@@ -729,10 +707,6 @@ err_out:
 
 static void __exit it87_wdt_exit(void)
 {
-	unsigned long flags;
-	int nolock;
-
-	nolock = !spin_trylock_irqsave(&spinlock, flags);
 	superio_enter();
 	superio_select(GPIO);
 	superio_outb(0x00, WDTCTRL);
@@ -748,8 +722,6 @@ static void __exit it87_wdt_exit(void)
 		superio_outb(ciract, ACTREG);
 	}
 	superio_exit();
-	if (!nolock)
-		spin_unlock_irqrestore(&spinlock, flags);
 
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
-- 

