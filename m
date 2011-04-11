Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1DKUgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 16:36:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34804 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab1DKUgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 16:36:14 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Andrew Morton <akpm@linux-foundation.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3] leds: provide helper to register "leds-gpio" devices
Date: Mon, 11 Apr 2011 22:35:57 +0200
Message-Id: <1302554157-24145-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1302097097.22904.41.camel@rex>
References: <1302097097.22904.41.camel@rex>
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
in init memory.
The definition cannot go into leds-gpio.c because it needs to be builtin
to be usable by platforms.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

changes since v2:
 - define gpio_led_register_device in a new file (led-register.c)
 - new parameter id for gpio_led_register_device
 - change drivers/Makefile to unconditionally include
   drivers/leds/Makefile

On Wed, Apr 06, 2011 at 06:38:17AM -0700, Richard Purdie wrote:
> It should only be built-in on platforms that both use leds-gpio and want
> to use this function at boot time. This is not the description of
> leds-core.c.
> 
> I understand the issue and the desire to move it into common code, I
> think that is good but I don't think you've found the most appropriate
> place yet.
> 
> I'm tempted to suggest making the function a static inline in leds.h (or
> create an leds-gpio.h and move the struct definition there too).
I don't like your static inline suggestion but prefer a "select
SOMETHING" to make the function available. So what about this patch?

I choosed a generic name led-register.c, maybe in the future some more
leds want a similar function.

Best regards
Uwe

 drivers/Makefile            |    2 +-
 drivers/leds/Kconfig        |    5 +++++
 drivers/leds/Makefile       |    1 +
 drivers/leds/led-register.c |   33 +++++++++++++++++++++++++++++++++
 include/linux/leds.h        |   12 ++++++++++++
 5 files changed, 52 insertions(+), 1 deletions(-)
 create mode 100644 drivers/leds/led-register.c

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
index 9bec869..e8e101e 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -14,6 +14,11 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
 
+config LED_REGISTER_GPIO
+	bool
+	help
+	  This option provides the function gpio_led_register_device.
+
 if NEW_LEDS
 
 comment "LED drivers"
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 39c80fc..ca428bd 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -3,6 +3,7 @@
 obj-$(CONFIG_NEW_LEDS)			+= led-core.o
 obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
+obj-y					+= led-register.o
 
 # LED Platform Drivers
 obj-$(CONFIG_LEDS_88PM860X)		+= leds-88pm860x.o
diff --git a/drivers/leds/led-register.c b/drivers/leds/led-register.c
new file mode 100644
index 0000000..d3731ea
--- /dev/null
+++ b/drivers/leds/led-register.c
@@ -0,0 +1,33 @@
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
+#if defined(CONFIG_LED_REGISTER_GPIO)
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
+#endif
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 61e0340..b20474d 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -207,5 +207,17 @@ struct gpio_led_platform_data {
 					unsigned long *delay_off);
 };
 
+/**
+ * gpio_led_register_device - register a gpio-led device
+ * @pdata: the platform data used for the new device
+ *
+ * Use this function instead of platform_device_add()ing a static struct
+ * platform_device.
+ *
+ * Note: as pdata and pdata->leds is copied these usually can and should be
+ * __initdata.
+ */
+struct platform_device *gpio_led_register_device(
+		int id, const struct gpio_led_platform_data *pdata);
 
 #endif		/* __LINUX_LEDS_H_INCLUDED */
-- 
1.7.2.3

