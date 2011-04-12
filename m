Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab1DLUuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:50:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56889 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab1DLUud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:50:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=sF8pv37OFDVT06jKVvHgWbHQR6+nkcvXLycl7bEx5KG27a3kQtZjXWOrCIEg3G4JF
	C0WtH/tdQgXej+eC+Nklw==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v5 1/2] Use "request_muxed_region" in it87 watchdog drivers
Date: Tue, 12 Apr 2011 13:49:47 -0700
Message-Id: <1302641387-30264-1-git-send-email-natg@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1302641290-30212-1-git-send-email-natg@google.com>
References: <1302641290-30212-1-git-send-email-natg@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

01 - Changes to it87 watchdog driver to use "request_muxed_region"
Serialize access to the hardware by using "request_muxed_region" macro defined
by Alan Cox. Call to this macro will hold off the requestor if the resource is
currently busy.

The use of the above macro makes it possible to get rid of
spinlocks in it8712f_wdt.c and it87_wdt.c watchdog drivers.
This also greatly simplifies the implementation of it87_wdt.c driver.

Signed-off-by: Nat Gurumoorthy <natg@google.com>
---

diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index 6143f52..51bfbc0 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -51,7 +51,6 @@ MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
 
 static unsigned long wdt_open;
 static unsigned expect_close;
-static spinlock_t io_lock;
 static unsigned char revision;
 
 /* Dog Food address - We use the game port address */
@@ -123,7 +122,11 @@ static inline void superio_select(int ldn)
 
 static inline void superio_enter(void)
 {
-	spin_lock(&io_lock);
+	/*
+	 * Reserve REG and REG + 1 for exclusive access.
+	 */
+	(void) request_muxed_region(REG, 2, NAME);
+
 	outb(0x87, REG);
 	outb(0x01, REG);
 	outb(0x55, REG);
@@ -134,7 +137,7 @@ static inline void superio_exit(void)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
-	spin_unlock(&io_lock);
+	release_region(REG, 2);
 }
 
 static inline void it8712f_wdt_ping(void)
@@ -382,8 +385,6 @@ static int __init it8712f_wdt_init(void)
 {
 	int err = 0;
 
-	spin_lock_init(&io_lock);
-
 	if (it8712f_wdt_find(&address))
 		return -ENODEV;
 
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index b1bc72f..ac7d26a 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -137,7 +137,6 @@
 
 static	unsigned int base, gpact, ciract, max_units, chip_type;
 static	unsigned long wdt_status;
-static	DEFINE_SPINLOCK(spinlock);
 
 static	int nogameport = DEFAULT_NOGAMEPORT;
 static	int exclusive  = DEFAULT_EXCLUSIVE;
@@ -165,6 +164,11 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started, default="
 
 static inline void superio_enter(void)
 {
+	/*
+	 * Reserve REG and REG + 1 for exclusive access.
+	 */
+	(void) request_muxed_region(REG, 2, WATCHDOG_NAME);
+
 	outb(0x87, REG);
 	outb(0x01, REG);
 	outb(0x55, REG);
@@ -175,6 +179,7 @@ static inline void superio_exit(void)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
+	release_region(REG, 2);
 }
 
 static inline void superio_select(int ldn)
@@ -257,9 +262,6 @@ static void wdt_keepalive(void)
 
 static void wdt_start(void)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&spinlock, flags);
 	superio_enter();
 
 	superio_select(GPIO);
@@ -270,14 +272,10 @@ static void wdt_start(void)
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
@@ -288,7 +286,6 @@ static void wdt_stop(void)
 		superio_outb(0x00, WDTVALMSB);
 
 	superio_exit();
-	spin_unlock_irqrestore(&spinlock, flags);
 }
 
 /**
@@ -303,8 +300,6 @@ static void wdt_stop(void)
 
 static int wdt_set_timeout(int t)
 {
-	unsigned long flags;
-
 	if (t < 1 || t > max_units * 60)
 		return -EINVAL;
 
@@ -313,14 +308,12 @@ static int wdt_set_timeout(int t)
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
 
@@ -339,11 +332,8 @@ static int wdt_set_timeout(int t)
 
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
@@ -353,7 +343,6 @@ static int wdt_get_status(int *status)
 		}
 
 		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 	if (test_and_clear_bit(WDTS_KEEPALIVE, &wdt_status))
 		*status |= WDIOF_KEEPALIVEPING;
@@ -560,16 +549,13 @@ static int __init it87_wdt_init(void)
 	int rc = 0;
 	int try_gameport = !nogameport;
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
@@ -603,7 +589,6 @@ static int __init it87_wdt_init(void)
 		return -ENODEV;
 	}
 
-	spin_lock_irqsave(&spinlock, flags);
 	superio_enter();
 
 	superio_select(GPIO);
@@ -621,14 +606,12 @@ static int __init it87_wdt_init(void)
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
@@ -646,7 +629,6 @@ static int __init it87_wdt_init(void)
 			goto err_out;
 		}
 		base = CIR_BASE;
-		spin_lock_irqsave(&spinlock, flags);
 		superio_enter();
 
 		superio_select(CIR);
@@ -660,7 +642,6 @@ static int __init it87_wdt_init(void)
 		}
 
 		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 
 	if (timeout < 1 || timeout > max_units * 60) {
@@ -711,21 +692,17 @@ err_out_reboot:
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
@@ -733,10 +710,6 @@ err_out:
 
 static void __exit it87_wdt_exit(void)
 {
-	unsigned long flags;
-	int nolock;
-
-	nolock = !spin_trylock_irqsave(&spinlock, flags);
 	superio_enter();
 	superio_select(GPIO);
 	superio_outb(0x00, WDTCTRL);
@@ -752,8 +725,6 @@ static void __exit it87_wdt_exit(void)
 		superio_outb(ciract, ACTREG);
 	}
 	superio_exit();
-	if (!nolock)
-		spin_unlock_irqrestore(&spinlock, flags);
 
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
-- 
1.7.3.1

