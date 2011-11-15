Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab1KOWou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:44:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40207 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab1KOWot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:44:49 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] gpio: add flags to export GPIOs when requesting
Date: Tue, 15 Nov 2011 23:44:34 +0100
Message-Id: <1321397074-6526-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce new flags to automatically export GPIOs when using the convenience
functions gpio_request_one() or gpio_request_array(). This eases support for
custom boards where lots of GPIOs need to be exported for customer
applications.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
---

Based on 3.2-rc2

 Documentation/gpio.txt |    3 +++
 drivers/gpio/gpiolib.c |   12 +++++++++++-
 include/linux/gpio.h   |    5 +++++
 3 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index 792faa3..9e28c05 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -303,6 +303,9 @@ where 'flags' is currently defined to specify the following properties:
 	* GPIOF_INIT_LOW	- as output, set initial level to LOW
 	* GPIOF_INIT_HIGH	- as output, set initial level to HIGH
 
+	* GPIOF_EXPORT_DIR_FIXED	- export gpio to sysfs, keep direction
+	* GPIOF_EXPORT_DIR_CHANGEABLE	- also export, allow changing direction
+
 since GPIOF_INIT_* are only valid when configured as output, so group valid
 combinations as:
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a971e3d..65ba047 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1285,8 +1285,18 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
 				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
 
 	if (err)
-		gpio_free(gpio);
+		goto free_gpio;
+
+	if (flags & GPIOF_EXPORT) {
+		err = gpio_export(gpio, flags & GPIOF_EXPORT_CHANGEABLE);
+		if (err)
+			goto free_gpio;
+	}
+
+	return 0;
 
+ free_gpio:
+	gpio_free(gpio);
 	return err;
 }
 EXPORT_SYMBOL_GPL(gpio_request_one);
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 38ac48b..38afe24 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -14,6 +14,11 @@
 #define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
 #define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
 
+#define GPIOF_EXPORT		(1 << 2)
+#define GPIOF_EXPORT_CHANGEABLE	(1 << 3)
+#define GPIOF_EXPORT_DIR_FIXED	(GPIOF_EXPORT)
+#define GPIOF_EXPORT_DIR_CHANGEABLE (GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE)
+
 /**
  * struct gpio - a structure describing a GPIO with configuration
  * @gpio:	the GPIO number
-- 
1.7.2.5

