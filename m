Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2H0IPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 04:15:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41138 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab2H0IPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 04:15:34 -0400
From: Gong Tao <gongtao0607@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gong Tao <gongtao0607@gmail.com>
Subject: [PATCH] gpio-keys: register irq buttons from devtree
Date: Mon, 27 Aug 2012 16:15:23 +0800
Message-Id: <1346055323-12941-1-git-send-email-gongtao0607@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add support for registering irq buttons from devtree

Signed-off-by: Gong Tao <gongtao0607@gmail.com>
---
 drivers/input/keyboard/gpio_keys.c | 64 +++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 5 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 62bfce4..a89f101 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -3,12 +3,60 @@
  *
  * Copyright 2005 Phil Blundell
  * Copyright 2010, 2011 David Jander <david@protonic.nl>
+ * Copyright 2012 Gong Tao <gongtao0607@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
 
+/*
+ * Device tree configuration:
+ *
+ * Properties:
+ * - compatible      : "gpio-keys"
+ * - interrupts      : all interrupt numbers used by keys
+ * - autorepeat      : optional, enable input subsystem auto repeat
+ *
+ * Child properties: please reffer to struct gpio_keys_button
+ * - label              : gpio_keys_button.desc
+ * - gpios              : gpio_keys_button.gpio
+ * - irq                : gpio_keys_button.irq
+ * - linux,code         : gpio_keys_button.code
+ * - linux,input-type   : gpio_keys_button.type
+ *                        optional, default EV_KEY
+ * - gpio-key,wakeup    : gpio_keys_button.wakeup
+ *                        optional
+ * - debounce-interval  : gpio_keys_button.debounce_interval
+ *	                      optional, default 5
+ * Example:
+ *
+ *  gpio_keys {
+ *      compatible = "gpio-keys";
+ *      interrupts = <25>;
+ *      autorepeat;
+ *
+ *      key1 { //GPIO Button
+ *          label = "key1";
+ *          gpios = <&gpio0 7 0>;
+ *          linux,code = <105>;
+ *          linux,input-type = <1>;
+ *          gpio-key,wakeup;
+ *          debounce-interval = <5>;
+ *      };
+ *
+ *      key2 { //IRQ Button
+ *          label = "key2";
+ *          irq = <25>;
+ *          linux,code = <106>;
+ *          linux,input-type = <1>;
+ *          gpio-key,wakeup;
+ *          debounce-interval = <5>;
+ *      };
+ *  };
+ *
+ */
+
 #include <linux/module.h>
 
 #include <linux/init.h>
@@ -577,12 +625,18 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
 		enum of_gpio_flags flags;
 
 		if (!of_find_property(pp, "gpios", NULL)) {
-			pdata->nbuttons--;
-			dev_warn(dev, "Found button without gpios\n");
-			continue;
+			if (of_property_read_u32(pp, "irq", &reg) == 0) {
+				buttons[i].gpio = -1;
+				buttons[i].irq = reg;
+			} else {
+				pdata->nbuttons--;
+				dev_warn(dev, "Found button without gpios and irq\n");
+				continue;
+			}
+		} else {
+			buttons[i].gpio = of_get_gpio_flags(pp, 0, &flags);
+			buttons[i].active_low = flags & OF_GPIO_ACTIVE_LOW;
 		}
-		buttons[i].gpio = of_get_gpio_flags(pp, 0, &flags);
-		buttons[i].active_low = flags & OF_GPIO_ACTIVE_LOW;
 
 		if (of_property_read_u32(pp, "linux,code", &reg)) {
 			dev_err(dev, "Button without keycode: 0x%x\n", buttons[i].gpio);
-- 
1.7.12

