Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1DGV1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:27:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42761 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab1DGV1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:27:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to;
	b=hBMM+NcylHu58xMnswai14h9EEg8wqWjgRsPRlVDA1hVnMoP3hjHmVEUGDQm2gbBN
	Fb8jroEWnlokxXNjM+09g==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v2 1/3] Add it87_io_lock to serialize hardware access.
Date: Thu,  7 Apr 2011 14:26:25 -0700
Message-Id: <1302211585-8088-1-git-send-email-natg@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: [PATCH v2 0/3] Make all it87 drivers SMP safe.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

01 - Adds it87 lock files.
   This patch creates it87_io_lock spinlock. All it87 drivers will have
to acquire this lock before they can touch the hardware.
   This patch also creates a IT87_LOCK Kconfig option that is not human
selectable. This will get selected when any of the it87 drivers are
selected into existance. IT87_LOCK has to be placed before the
menuconfig WATCHDOG entry as it can be selected by drivers/hwmon/it87.c
even if all of watchdog is disabled.
   All it87 driver entries in drivers/watchdog/Kconfig have been
modified with "select IT87_LOCK" directive.

Signed-off-by: Nat Gurumoorthy <natg@google.com>
---
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 31649b7..562f345 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -2,6 +2,18 @@
 # Watchdog device configuration
 #
 
+# This has to come before the WATCHDOG menuconfig
+# because it can be selected by drivers/hwmon/it87.c
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
 menuconfig WATCHDOG
 	bool "Watchdog Timer Support"
 	---help---
@@ -565,6 +577,7 @@ config ITCO_VENDOR_SUPPORT
 config IT8712F_WDT
 	tristate "IT8712F (Smart Guardian) Watchdog Timer"
 	depends on X86
+	select IT87_LOCK
 	---help---
 	  This is the driver for the built-in watchdog timer on the IT8712F
 	  Super I/0 chipset used on many motherboards.
@@ -578,6 +591,7 @@ config IT8712F_WDT
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
---
