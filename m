Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab2IJMQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:16:32 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60098 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab2IJMQb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 10 Sep 2012 08:16:31 -0400
Message-Id: <504DF63A020000780009A30B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 10 Sep 2012 13:16:26 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <linus.walleij@linaro.org>, <grant.likely@secretlab.ca>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] allow gpiolib to be a module
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without ARCH_REQUIRE_GPIOLIB there's no reason to force this code, when
enabled, to always be built into the kernel, which requires only minor
Makefile and source code adjustments.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/gpio/Kconfig       |    2 +-
 drivers/gpio/Makefile      |    3 ++-
 drivers/gpio/gpiolib.c     |   15 +++++++++++++++
 include/asm-generic/gpio.h |    3 ++-
 4 files changed, 20 insertions(+), 3 deletions(-)

--- 3.6-rc5/drivers/gpio/Kconfig
+++ 3.6-rc5-gpiolib-module/drivers/gpio/Kconfig
@@ -33,7 +33,7 @@ config ARCH_REQUIRE_GPIOLIB
 
 
 menuconfig GPIOLIB
-	bool "GPIO Support"
+	tristate "GPIO Support"
 	depends on ARCH_WANT_OPTIONAL_GPIOLIB || ARCH_REQUIRE_GPIOLIB
 	select GENERIC_GPIO
 	help
--- 3.6-rc5/drivers/gpio/Makefile
+++ 3.6-rc5-gpiolib-module/drivers/gpio/Makefile
@@ -2,7 +2,8 @@
 
 ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
-obj-$(CONFIG_GPIOLIB)		+= gpiolib.o devres.o
+gpio-lib-y			:= gpiolib.o devres.o
+obj-$(CONFIG_GPIOLIB)		+= gpio-lib.o
 obj-$(CONFIG_OF_GPIO)		+= gpiolib-of.o
 
 # Device drivers. Generally keep list sorted alphabetically
--- 3.6-rc5/drivers/gpio/gpiolib.c
+++ 3.6-rc5-gpiolib-module/drivers/gpio/gpiolib.c
@@ -1003,7 +1003,9 @@ static int __init gpiolib_sysfs_init(voi
 
 	return status;
 }
+#ifndef MODULE
 postcore_initcall(gpiolib_sysfs_init);
+#endif
 
 #else
 static inline int gpiochip_export(struct gpio_chip *chip)
@@ -1832,6 +1834,19 @@ static int __init gpiolib_debugfs_init(v
 				NULL, NULL, &gpiolib_operations);
 	return 0;
 }
+#ifndef MODULE
 subsys_initcall(gpiolib_debugfs_init);
+#endif
 
 #endif	/* DEBUG_FS */
+
+#ifdef MODULE
+int __init gpiolib_init(void)
+{
+	return gpiolib_sysfs_init() ?: gpiolib_debugfs_init();
+}
+module_init(gpiolib_init);
+
+MODULE_DESCRIPTION("GPIO library");
+MODULE_LICENSE("GPL");
+#endif
--- 3.6-rc5/include/asm-generic/gpio.h
+++ 3.6-rc5-gpiolib-module/include/asm-generic/gpio.h
@@ -4,9 +4,10 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/kconfig.h>
 #include <linux/of.h>
 
-#ifdef CONFIG_GPIOLIB
+#if IS_ENABLED(CONFIG_GPIOLIB)
 
 #include <linux/compiler.h>
 



