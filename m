Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab2KCHoc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 03:44:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:28949 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab2KCHo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 03:44:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,704,1344236400"; 
   d="scan'208";a="164064507"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 1/3] gpio / ACPI: add ACPI support
Date: Sat,  3 Nov 2012 09:46:31 +0200
Message-Id: <1351928793-14375-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

Add support for translating ACPI GPIO pin numbers to Linux GPIO API pins.
Needs a gpio controller driver with the acpi handler hook set.

Drivers can use acpi_get_gpio() to translate ACPI5 GpioIO and GpioInt
resources to Linux GPIO's.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/gpio/Kconfig        |    4 +++
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/gpiolib-acpi.c |   60 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi_gpio.h   |   19 ++++++++++++++
 4 files changed, 84 insertions(+)
 create mode 100644 drivers/gpio/gpiolib-acpi.c
 create mode 100644 include/linux/acpi_gpio.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d055cee..2f1905b 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -49,6 +49,10 @@ config OF_GPIO
 	def_bool y
 	depends on OF && !SPARC
 
+config ACPI_GPIO
+	def_bool y
+	depends on ACPI
+
 config DEBUG_GPIO
 	bool "Debug GPIO calls"
 	depends on DEBUG_KERNEL
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 9aeed67..5254b6d 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -4,6 +4,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_GPIOLIB)		+= gpiolib.o devres.o
 obj-$(CONFIG_OF_GPIO)		+= gpiolib-of.o
+obj-$(CONFIG_ACPI_GPIO)		+= gpiolib-acpi.o
 
 # Device drivers. Generally keep list sorted alphabetically
 obj-$(CONFIG_GPIO_GENERIC)	+= gpio-generic.o
diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
new file mode 100644
index 0000000..ef56ea4
--- /dev/null
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -0,0 +1,60 @@
+/*
+ * ACPI helpers for GPIO API
+ *
+ * Copyright (C) 2012, Intel Corporation
+ * Author: Mathias Nyman <mathias.nyman@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/module.h>
+#include <linux/acpi_gpio.h>
+#include <linux/acpi.h>
+
+static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
+{
+	acpi_handle handle = data;
+	acpi_handle gc_handle;
+
+	if (!gc->dev)
+		return false;
+
+	gc_handle = gc->dev->acpi_handle;
+	if (!gc_handle)
+		return false;
+
+	return gc_handle == handle;
+}
+
+/**
+ * acpi_get_gpio() - Translate ACPI GPIO pin to GPIO number usable with GPIO API
+ * @path:	ACPI GPIO controller full path name, (e.g. "\\_SB.GPO1")
+ * @pin:	ACPI GPIO pin number (0-based, controller-relative)
+ *
+ * Returns GPIO number to use with Linux generic GPIO API, or errno error value
+ */
+
+int acpi_get_gpio(char *path, int pin)
+{
+	struct gpio_chip *chip;
+	acpi_handle handle;
+	acpi_status status;
+
+	status = acpi_get_handle(NULL, path, &handle);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	chip = gpiochip_find(handle, acpi_gpiochip_find);
+	if (!chip)
+		return -ENODEV;
+
+	if (!gpio_is_valid(chip->base + pin))
+		return -EINVAL;
+
+	return chip->base + pin;
+}
+EXPORT_SYMBOL(acpi_get_gpio);
diff --git a/include/linux/acpi_gpio.h b/include/linux/acpi_gpio.h
new file mode 100644
index 0000000..e025664
--- /dev/null
+++ b/include/linux/acpi_gpio.h
@@ -0,0 +1,19 @@
+#ifndef _LINUX_ACPI_GPIO_H_
+#define _LINUX_ACPI_GPIO_H_
+
+#include <linux/errno.h>
+
+#ifdef CONFIG_ACPI_GPIO
+
+int acpi_get_gpio(char *path, int pin);
+
+#else /* CONFIG_ACPI_GPIO */
+
+static inline int acpi_get_gpio(char *path, int pin)
+{
+	return -ENODEV;
+}
+
+#endif /* CONFIG_ACPI_GPIO */
+
+#endif /* _LINUX_ACPI_GPIO_H_ */
-- 
1.7.10.4

