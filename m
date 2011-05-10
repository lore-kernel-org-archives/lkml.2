Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab1EJIvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:51:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39404 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab1EJIvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:51:35 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>, kernel@pengutronix.de,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4] leds: provide helper to register "leds-gpio" devices
Date: Tue, 10 May 2011 10:50:55 +0200
Message-Id: <1305017456-10910-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110510073152.GF29089@pengutronix.de>
References: <20110510073152.GF29089@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function makes a deep copy of the platform data to allow it to live
in init memory. For a kernel that supports several machines and so
includes the definition for several leds-gpio devices this saves quite
some memory because all but one definition can be free'd after boot.

As the function is used by arch code it must be builtin and so cannot go
into leds-gpio.c.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Changes since v3:
- new commit log
- improved documentation and moved it to .c file
- used obj-$(CONFIG..) and renamed source file
- provide an example usage (in a seperate patch)

 drivers/Makefile                  |    2 +-
 drivers/leds/Kconfig              |    7 ++++++
 drivers/leds/Makefile             |    1 +
 drivers/leds/leds-gpio-register.c |   42 +++++++++++++++++++++++++++++++++++++
 include/linux/leds.h              |    2 +
 5 files changed, 53 insertions(+), 1 deletions(-)
 create mode 100644 drivers/leds/leds-gpio-register.c

diff --git a/drivers/Makefile b/drivers/Makefile
index 3f135b6..4a4f425 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -95,7 +95,7 @@ obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_MMC)		+= mmc/
 obj-$(CONFIG_MEMSTICK)		+= memstick/
-obj-$(CONFIG_NEW_LEDS)		+= leds/
+obj-y				+= leds/
 obj-$(CONFIG_INFINIBAND)	+= infiniband/
 obj-$(CONFIG_SGI_SN)		+= sn/
 obj-y				+= firmware/
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 9bec869..eb832dc 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -14,6 +14,13 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
 
+config LEDS_GPIO_REGISTER
+	bool
+	help
+	  This option provides the function gpio_led_register_device.
+	  As this function is used by arch code it must not be compiled as a
+	  module.
+
 if NEW_LEDS
 
 comment "LED drivers"
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 39c80fc..8439ce5 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
 obj-$(CONFIG_LEDS_SUNFIRE)		+= leds-sunfire.o
 obj-$(CONFIG_LEDS_PCA9532)		+= leds-pca9532.o
+obj-$(CONFIG_LEDS_GPIO_REGISTER)	+= leds-gpio-register.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
 obj-$(CONFIG_LEDS_LP3944)		+= leds-lp3944.o
 obj-$(CONFIG_LEDS_LP5521)		+= leds-lp5521.o
diff --git a/drivers/leds/leds-gpio-register.c b/drivers/leds/leds-gpio-register.c
new file mode 100644
index 0000000..1c4ed55
--- /dev/null
+++ b/drivers/leds/leds-gpio-register.c
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2011 Pengutronix
+ * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
+
+/**
+ * gpio_led_register_device - register a gpio-led device
+ * @pdata: the platform data used for the new device
+ *
+ * Makes a copy of pdata and pdata->leds and registers a new leds-gpio device
+ * with the result. This allows to have pdata and pdata-leds in .init.rodata
+ * and so saves some bytes compared to a static struct platform_device with
+ * static platform data.
+ *
+ * Returns the registered device or an error pointer.
+ */
+struct platform_device *__init gpio_led_register_device(
+		int id, const struct gpio_led_platform_data *pdata)
+{
+	struct platform_device *ret;
+	struct gpio_led_platform_data _pdata = *pdata;
+
+	_pdata.leds = kmemdup(pdata->leds,
+			pdata->num_leds * sizeof(*pdata->leds), GFP_KERNEL);
+	if (!_pdata.leds)
+		return ERR_PTR(-ENOMEM);
+
+	ret = platform_device_register_resndata(NULL, "leds-gpio", id,
+			NULL, 0, &_pdata, sizeof(_pdata));
+	if (IS_ERR(ret))
+		kfree(_pdata.leds);
+
+	return ret;
+}
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 61e0340..5884def 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -207,5 +207,7 @@ struct gpio_led_platform_data {
 					unsigned long *delay_off);
 };
 
+struct platform_device *gpio_led_register_device(
+		int id, const struct gpio_led_platform_data *pdata);
 
 #endif		/* __LINUX_LEDS_H_INCLUDED */
-- 
1.7.4.1

