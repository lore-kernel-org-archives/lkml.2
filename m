Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1BHWoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:44:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58908 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab1BHWox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:44:53 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>, Dmitry Torokhov <dtor@mail.ru>,
        Arnd Bergmann <arnd@arndb.de> (maintainer:GENERIC INCLUDE/A...),
        Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/8=50%),
        Mark Brown <broonie@opensource.wolfsonmicro.com> (commit_signer:1/8=12%),
        Anton Vorontsov <cbouatmailru@gmail.com> (commit_signer:1/8=12%),
        Greg Kroah-Hartman <greg@kroah.com> (commit_signer:1/8=12%),
        linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/A...)
Subject: [PATCH] gpio: make newer functionality available outside of GPIOLIB
Date: Tue,  8 Feb 2011 23:44:33 +0100
Message-Id: <1297205075-11396-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio subsystems offers an API which requires a dependency on GENERIC_GPIO
when used by drivers. There is also implementation framework of this API, so
archs can select GPIOLIB if they intend to use it. But they don't have to, they
can still provide GENERIC_GPIO without GPIOLIB using custom routines.

Commit 3e45f1d1155894e6f4291f5536b224874d52d8e2 (gpio: introduce
gpio_request_one() and friends) added some functions, defines and a struct to
the API, but made them available only for GPIOLIB. So, drivers using these new
functions will fail in the case of GENERIC_GPIO && !GPIOLIB.

The new functions have already been added to the fallback in <linux/gpio.h>,
but the data structure were still not available. Change this by reorganizing
the include-files.

Fixes issues like (in linux-next currently):

drivers/input/touchscreen/ads7846.c:959: error: 'GPIOF_DIR_IN' undeclared (first use in this function)

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---

Based on 2.6.38-rc4. Compile tested on x86.

 include/asm-generic/gpio.h   |   31 +++++--------------------------
 include/linux/gpio.h         |    2 +-
 include/linux/gpio_generic.h |   26 ++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 27 deletions(-)
 create mode 100644 include/linux/gpio_generic.h

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index ff5c660..ebc73bc 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/gpio_generic.h>
 
 #ifdef CONFIG_GPIOLIB
 
@@ -158,6 +159,10 @@ extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
 extern int gpio_get_value_cansleep(unsigned gpio);
 extern void gpio_set_value_cansleep(unsigned gpio, int value);
 
+extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
+extern int gpio_request_array(struct gpio *array, size_t num);
+extern void gpio_free_array(struct gpio *array, size_t num);
+
 
 /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
  * the GPIO is constant and refers to some always-present controller,
@@ -170,32 +175,6 @@ extern int __gpio_cansleep(unsigned gpio);
 
 extern int __gpio_to_irq(unsigned gpio);
 
-#define GPIOF_DIR_OUT	(0 << 0)
-#define GPIOF_DIR_IN	(1 << 0)
-
-#define GPIOF_INIT_LOW	(0 << 1)
-#define GPIOF_INIT_HIGH	(1 << 1)
-
-#define GPIOF_IN		(GPIOF_DIR_IN)
-#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
-#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
-
-/**
- * struct gpio - a structure describing a GPIO with configuration
- * @gpio:	the GPIO number
- * @flags:	GPIO configuration as specified by GPIOF_*
- * @label:	a literal description string of this GPIO
- */
-struct gpio {
-	unsigned	gpio;
-	unsigned long	flags;
-	const char	*label;
-};
-
-extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
-extern int gpio_request_array(struct gpio *array, size_t num);
-extern void gpio_free_array(struct gpio *array, size_t num);
-
 #ifdef CONFIG_GPIO_SYSFS
 
 /*
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 32720ba..584ceb6 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -11,9 +11,9 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/gpio_generic.h>
 
 struct device;
-struct gpio;
 struct gpio_chip;
 
 /*
diff --git a/include/linux/gpio_generic.h b/include/linux/gpio_generic.h
new file mode 100644
index 0000000..d662697
--- /dev/null
+++ b/include/linux/gpio_generic.h
@@ -0,0 +1,26 @@
+#ifndef __LINUX_GPIO_GENERIC_H
+#define __LINUX_GPIO_GENERIC_H
+
+/**
+ * struct gpio - a structure describing a GPIO with configuration
+ * @gpio:	the GPIO number
+ * @flags:	GPIO configuration as specified by GPIOF_*
+ * @label:	a literal description string of this GPIO
+ */
+struct gpio {
+	unsigned	gpio;
+	unsigned long	flags;
+	const char	*label;
+};
+
+#define GPIOF_DIR_OUT	(0 << 0)
+#define GPIOF_DIR_IN	(1 << 0)
+
+#define GPIOF_INIT_LOW	(0 << 1)
+#define GPIOF_INIT_HIGH	(1 << 1)
+
+#define GPIOF_IN		(GPIOF_DIR_IN)
+#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
+#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
+
+#endif /* __LINUX_GPIO_GENERIC_H */
-- 
1.7.2.3

