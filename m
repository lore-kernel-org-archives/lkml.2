Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1DEIhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:37:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46539 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1DEIhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:37:50 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kernel@pengutronix.de
Subject: [PATCH] leds: provide helper to register "leds-gpio" devices
Date: Tue,  5 Apr 2011 10:37:35 +0200
Message-Id: <1301992655-8514-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110405073030.GI13963@pengutronix.de>
References: <20110405073030.GI13963@pengutronix.de>
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

I choosed to put this into drivers/leds/led-core.c because I consider
drivers/leds/leds-register.c or even something leds-gpio specific overkill.

But I'm open to discuss where to put it best.

Best regards
Uwe

 drivers/leds/led-core.c |   27 ++++++++++++++++++++++++++-
 include/linux/leds.h    |   12 ++++++++++++
 2 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 016d19f..a9a762e 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -2,8 +2,10 @@
  * LED Class Core
  *
  * Copyright 2005-2006 Openedhand Ltd.
+ * Richard Purdie <rpurdie@openedhand.com>
  *
- * Author: Richard Purdie <rpurdie@openedhand.com>
+ * Copyright (C) 2009-2010 Pengutronix
+ * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -16,6 +18,9 @@
 #include <linux/module.h>
 #include <linux/rwsem.h>
 #include <linux/leds.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
 #include "leds.h"
 
 DECLARE_RWSEM(leds_list_lock);
@@ -23,3 +28,23 @@ EXPORT_SYMBOL_GPL(leds_list_lock);
 
 LIST_HEAD(leds_list);
 EXPORT_SYMBOL_GPL(leds_list);
+
+struct platform_device *__init gpio_led_register_device(
+                const struct gpio_led_platform_data *pdata)
+{
+	struct platform_device *ret = ERR_PTR(-ENOMEM);
+	struct gpio_led_platform_data _pdata = *pdata;
+	_pdata.leds = kmemdup(pdata->leds,
+			pdata->num_leds * sizeof(*pdata->leds), GFP_KERNEL);
+
+	if (!_pdata.leds)
+		return ERR_PTR(-ENOMEM);
+
+	ret = platform_device_register_resndata(NULL, "leds-gpio", -1,
+			NULL, 0, &_pdata, sizeof(_pdata));
+
+	if (IS_ERR(ret))
+		kfree(_pdata.leds);
+
+	return ret;
+}
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 61e0340..e6897d9 100644
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
+struct platform_device *__init gpio_led_register_device(
+		const struct gpio_led_platform_data *pdata);
 
 #endif		/* __LINUX_LEDS_H_INCLUDED */
-- 
1.7.2.3

