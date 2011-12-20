Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab1LTUks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:40:48 -0500
Received: from nbd.name ([46.4.11.11]:54413 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab1LTUko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:40:44 -0500
From: John Crispin <blogic@openwrt.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, John Crispin <blogic@openwrt.org>
Subject: [PATCH] GPIO: add bindings for managed devices
Date: Tue, 20 Dec 2011 21:40:21 +0100
Message-Id: <1324413621-11630-1-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds 2 functions that allow managed devices to request GPIOs.
These GPIOs will then be managed by drivers/base/devres.c.

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/gpio/Makefile      |    2 +-
 drivers/gpio/devres.c      |   90 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |    4 ++
 3 files changed, 95 insertions(+), 1 deletions(-)
 create mode 100644 drivers/gpio/devres.c

diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index dbcb0bc..da60964 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -2,7 +2,7 @@
 
 ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
-obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
+obj-$(CONFIG_GPIOLIB)		+= gpiolib.o devres.o
 
 # Device drivers. Generally keep list sorted alphabetically
 obj-$(CONFIG_GPIO_GENERIC)	+= gpio-generic.o
diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
new file mode 100644
index 0000000..3dd2939
--- /dev/null
+++ b/drivers/gpio/devres.c
@@ -0,0 +1,90 @@
+/*
+ * drivers/gpio/devres.c - managed gpio resources
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * This file is based on kernel/irq/devres.c
+ *
+ * Copyright (c) 2011 John Crispin <blogic@openwrt.org>
+ */
+
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/device.h>
+#include <linux/gfp.h>
+
+static void devm_gpio_release(struct device *dev, void *res)
+{
+	unsigned *gpio = res;
+
+	gpio_free(*gpio);
+}
+
+static int devm_gpio_match(struct device *dev, void *res, void *data)
+{
+	unsigned *this = res, *gpio = data;
+
+	return *this == *gpio;
+}
+
+/**
+ *      devm_gpio_request - request a gpio for a managed device
+ *      @dev: device to request the gpio for
+ *      @gpio: gpio to allocate
+ *      @label: the name of the requested gpio
+ *
+ *      Except for the extra @dev argument, this function takes the
+ *      same arguments and performs the same function as
+ *      gpio_request().  GPIOs requested with this function will be
+ *      automatically freed on driver detach.
+ *
+ *      If an GPIO allocated with this function needs to be freed
+ *      separately, devm_gpio_free() must be used.
+ */
+
+int devm_gpio_request(struct device *dev, unsigned gpio, const char *label)
+{
+	unsigned *dr;
+	int rc;
+
+	dr = devres_alloc(devm_gpio_release, sizeof(unsigned), GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	rc = gpio_request(gpio, label);
+	if (rc) {
+		devres_free(dr);
+		return rc;
+	}
+
+	*dr = gpio;
+	devres_add(dev, dr);
+
+	return 0;
+}
+EXPORT_SYMBOL(devm_gpio_request);
+
+/**
+ *      devm_gpio_free - free an interrupt
+ *      @dev: device to free gpio for
+ *      @gpio: gpio to free
+ *
+ *      Except for the extra @dev argument, this function takes the
+ *      same arguments and performs the same function as gpio_free().
+ *      This function instead of gpio_free() should be used to manually
+ *      free GPIOs allocated with devm_gpio_request().
+ */
+void devm_gpio_free(struct device *dev, unsigned int gpio)
+{
+
+	WARN_ON(devres_destroy(dev, devm_gpio_release, devm_gpio_match,
+		&gpio));
+	gpio_free(gpio);
+}
+EXPORT_SYMBOL(devm_gpio_free);
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 8c86210..8601a02 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -175,6 +175,10 @@ extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *labe
 extern int gpio_request_array(const struct gpio *array, size_t num);
 extern void gpio_free_array(const struct gpio *array, size_t num);
 
+/* bindings for managed devices that want to request gpios */
+int devm_gpio_request(struct device *dev, unsigned gpio, const char *label);
+void devm_gpio_free(struct device *dev, unsigned int gpio);
+
 #ifdef CONFIG_GPIO_SYSFS
 
 /*
-- 
1.7.7.1

