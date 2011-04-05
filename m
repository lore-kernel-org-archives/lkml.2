Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1DEV0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 17:26:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62187 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab1DEV0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 17:26:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=qhv9+VCFyfcCQ/X6pPVZLezIKzAi5izyjhU7MS7j+cvD9D6Y3SVsnGB4saMm8Q3n4
	/NOZ3Rrxd59ZMOMt85GUg==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH] Make all it87 drivers SMP safe.
Date: Tue,  5 Apr 2011 14:24:57 -0700
Message-Id: <1302038697-28985-1-git-send-email-natg@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 3 different drivers that touch the it87 hardware registers.
The 3 drivers have been written independently and access the it87 hardware
registers assuming they are the only driver accessing it. This change
attempts to serialize access to the hardware by defining a global spinlock
it87_io_lock in a file it87_lock.c. This lock has to be acquired by each
of the it87 drivers before it can access the hardware. We have defined
a new Kconfig option IT87_LOCK. When it is selected it87_lock.c is compiled
into the kernel thereby making the lock global and accessable to the it87
drivers which are typically built as loadable modules. All the it87 drivers
select IT87_LOCK to compile the lock into the kernel.
The routines accessing the hardware are being called from module init,
open, ioctl and module exit routines and hence it is sufficient to use
calls to spin_lock and spin_unlock to acquire and release the locks. For
the same reasons it87_wdt.c has extensive changes to remove calls to
spin_lock_irqsave and spin_unlock_irqrestore. The lock is now acquired
in superio_enter and released in superio_exit. This is now identical
to the code in drivers/hwmon/it87.c and drivers/watchdog/it8712f_wdt.c.
Added __acquire and __release annotations wherever needed.
---
 drivers/hwmon/Kconfig          |    1 +
 drivers/hwmon/it87.c           |   14 ++++++++++++-
 drivers/watchdog/Kconfig       |   12 +++++++++++
 drivers/watchdog/Makefile      |    1 +
 drivers/watchdog/it8712f_wdt.c |   10 ++++----
 drivers/watchdog/it87_lock.c   |   27 +++++++++++++++++++++++++
 drivers/watchdog/it87_wdt.c    |   42 ++++++---------------------------------
 include/linux/it87_lock.h      |   28 ++++++++++++++++++++++++++
 8 files changed, 94 insertions(+), 41 deletions(-)
 create mode 100644 drivers/watchdog/it87_lock.c
 create mode 100644 include/linux/it87_lock.h

Signed-off-by: Nat Gurumoorthy <natg@google.com>

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 297bc9a..afe671a 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -436,6 +436,7 @@ config SENSORS_IBMPEX
 config SENSORS_IT87
 	tristate "ITE IT87xx and compatibles"
 	select HWMON_VID
+	select IT87_LOCK
 	help
 	  If you say yes here you get support for ITE IT8705F, IT8712F,
 	  IT8716F, IT8718F, IT8720F, IT8721F, IT8726F and IT8758E sensor
diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index 316b648..bc32535 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -55,6 +55,8 @@
 #include <linux/dmi.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/it87_lock.h>
 
 #define DRVNAME "it87"
 
@@ -110,7 +112,9 @@ superio_select(int ldn)
 
 static inline void
 superio_enter(void)
+__acquires(&it87_io_lock)
 {
+	spin_lock(&it87_io_lock);
 	outb(0x87, REG);
 	outb(0x01, REG);
 	outb(0x55, REG);
@@ -119,9 +123,11 @@ superio_enter(void)
 
 static inline void
 superio_exit(void)
+__releases(&it87_io_lock)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
+	spin_unlock(&it87_io_lock);
 }
 
 /* Logical device 4 registers */
@@ -1899,8 +1905,12 @@ static int __devexit it87_remove(struct platform_device *pdev)
    would slow down the IT87 access and should not be necessary. */
 static int it87_read_value(struct it87_data *data, u8 reg)
 {
+	int ret;
+	spin_lock(&it87_io_lock);
 	outb_p(reg, data->addr + IT87_ADDR_REG_OFFSET);
-	return inb_p(data->addr + IT87_DATA_REG_OFFSET);
+	ret = inb_p(data->addr + IT87_DATA_REG_OFFSET);
+	spin_unlock(&it87_io_lock);
+	return ret;
 }
 
 /* Must be called with data->update_lock held, except during initialization.
@@ -1908,8 +1918,10 @@ static int it87_read_value(struct it87_data *data, u8 reg)
    would slow down the IT87 access and should not be necessary. */
 static void it87_write_value(struct it87_data *data, u8 reg, u8 value)
 {
+	spin_lock(&it87_io_lock);
 	outb_p(reg, data->addr + IT87_ADDR_REG_OFFSET);
 	outb_p(value, data->addr + IT87_DATA_REG_OFFSET);
+	spin_unlock(&it87_io_lock);
 }
 
 /* Return 1 if and only if the PWM interface is safe to use */
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 31649b7..6ffc682 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -562,9 +562,20 @@ config ITCO_VENDOR_SUPPORT
 	  devices. At this moment we only have additional support for some
 	  SuperMicro Inc. motherboards.
 
+config IT87_LOCK
+	bool
+	default n
+	---help---
+	  This defines the global lock needed by all IT87 drivers that
+	  touch the Super I/0 chipset used on many motherboards. This
+	  is needed to serialize access to the registers in SMP
+	  systems. All it87 drivers will select this Kconfig option to compile
+	  the lock into the kernel.
+
 config IT8712F_WDT
 	tristate "IT8712F (Smart Guardian) Watchdog Timer"
 	depends on X86
+	select IT87_LOCK
 	---help---
 	  This is the driver for the built-in watchdog timer on the IT8712F
 	  Super I/0 chipset used on many motherboards.
@@ -578,6 +589,7 @@ config IT8712F_WDT
 config IT87_WDT
 	tristate "IT87 Watchdog Timer"
 	depends on X86 && EXPERIMENTAL
+	select IT87_LOCK
 	---help---
 	  This is the driver for the hardware watchdog on the ITE IT8702,
 	  IT8712, IT8716, IT8718, IT8720, IT8726, IT8712 Super I/O chips.
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 20e44c4..6895445 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -81,6 +81,7 @@ obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o
 ifeq ($(CONFIG_ITCO_VENDOR_SUPPORT),y)
 obj-$(CONFIG_ITCO_WDT) += iTCO_vendor_support.o
 endif
+obj-$(CONFIG_IT87_LOCK) += it87_lock.o
 obj-$(CONFIG_IT8712F_WDT) += it8712f_wdt.o
 obj-$(CONFIG_IT87_WDT) += it87_wdt.o
 obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
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
 
diff --git a/drivers/watchdog/it87_lock.c b/drivers/watchdog/it87_lock.c
new file mode 100644
index 0000000..06c0b49
--- /dev/null
+++ b/drivers/watchdog/it87_lock.c
@@ -0,0 +1,27 @@
+/*
+ *      IT87xxx super IO chipset access lock
+ *
+ *      Copyright (c) 2011 Nat Gurumoorthy <natg@google.com>
+ *
+ *      Based on info and code taken from:
+ *
+ *      drivers/char/watchdog/scx200_wdt.c
+ *      drivers/hwmon/it87.c
+ *      IT8712F EC-LPC I/O Preliminary Specification 0.8.2
+ *      IT8712F EC-LPC I/O Preliminary Specification 0.9.3
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License as
+ *      published by the Free Software Foundation; either version 2 of the
+ *      License, or (at your option) any later version.
+ *
+ *      The author(s) of this software shall not be held liable for damages
+ *      of any nature resulting due to the use of this software. This
+ *      software is provided AS-IS with no warranties.
+ */
+
+#include <linux/module.h>
+#include <linux/spinlock.h>
+
+DEFINE_SPINLOCK(it87_io_lock);
+EXPORT_SYMBOL(it87_io_lock);
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
diff --git a/include/linux/it87_lock.h b/include/linux/it87_lock.h
new file mode 100644
index 0000000..ae91ce5
--- /dev/null
+++ b/include/linux/it87_lock.h
@@ -0,0 +1,28 @@
+/*
+ *      IT87xxx super IO chipset access lock
+ *
+ *      Copyright (c) 2011 Nat Gurumoorthy <natg@google.com>
+ *
+ *      Based on info and code taken from:
+ *
+ *      drivers/char/watchdog/scx200_wdt.c
+ *      drivers/hwmon/it87.c
+ *      IT8712F EC-LPC I/O Preliminary Specification 0.8.2
+ *      IT8712F EC-LPC I/O Preliminary Specification 0.9.3
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License as
+ *      published by the Free Software Foundation; either version 2 of the
+ *      License, or (at your option) any later version.
+ *
+ *      The author(s) of this software shall not be held liable for damages
+ *      of any nature resulting due to the use of this software. This
+ *      software is provided AS-IS with no warranties.
+ */
+
+#include <linux/spinlock.h>
+
+/*
+ * Global lock used by all it87 drivers to serialize access to hardware.
+ */
+extern spinlock_t it87_io_lock;
-- 
1.7.3.1

