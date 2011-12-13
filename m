Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1LMJ5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:57:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52747 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1LMJ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:57:51 -0500
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Tue, 13 Dec 2011 10:57:30 +0100
Message-ID: <CAH9NwWfMXKQ5DUeHfXaMzEKK_Zn6TS6E44AdqhcOj-jMuAeGQw@mail.gmail.com>
Subject: [PATCH RESEND] add led driver for Bachmann's ot200
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, rpurdie@rpsys.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a7fecf3426ef98fdd19e9d2610665b9d1ce358a0 Mon Sep 17 00:00:00 2001
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Fri, 18 Nov 2011 10:21:48 +0100
Subject: [PATCH] add led driver for Bachmann's ot200

This patch adds support for leds on Bachmann's ot200 visualisation device.
The device has three leds on the back panel (led_err, led_init and led_run)
and can handle up to seven leds on the front panel.

The driver was written by Linutronix on behalf of
Bachmann electronic GmbH.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
 drivers/leds/Kconfig      |    8 ++
 drivers/leds/Makefile     |    1 +
 drivers/leds/leds-ot200.c |  204 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 213 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-ot200.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index ff203a4..6cf0dd6 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -387,6 +387,14 @@ config LEDS_RENESAS_TPU
         pin function. The latter to support brightness control.
         Brightness control is supported but hardware blinking is not.

+config LEDS_OT200
+       tristate "LED support for Bachmann OT200"
+       depends on LEDS_CLASS
+       help
+         This option enables support for the LEDs on the Bachmann OT200. The
+         LEDs are controlled through LPC bus.
+         Say Y to enable LEDs on the Bachmann OT200.
+
 config LEDS_TRIGGERS
       bool "LED Trigger support"
       depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index e4f6bf5..0814d42 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_LEDS_NS2)                        += leds-ns2.o
 obj-$(CONFIG_LEDS_NETXBIG)             += leds-netxbig.o
 obj-$(CONFIG_LEDS_ASIC3)               += leds-asic3.o
 obj-$(CONFIG_LEDS_RENESAS_TPU)         += leds-renesas-tpu.o
+obj-$(CONFIG_LEDS_OT200)               += leds-ot200.o

 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)          += leds-dac124s085.o
diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c
new file mode 100644
index 0000000..60f118b
--- /dev/null
+++ b/drivers/leds/leds-ot200.c
@@ -0,0 +1,204 @@
+/*
+ * Bachmann ot200 leds driver.
+ *
+ * Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
+ * License: GPL as published by the FSF.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
+#include <linux/io.h>
+#include <linux/module.h>
+
+struct ot200_led {
+       struct led_classdev cdev;
+       char name[8];
+       unsigned int num;
+};
+
+static u8 old_val;
+static u8 old_val_back;
+DEFINE_SPINLOCK(value_lock);
+
+static void ot200_led_set(struct led_classdev *led_cdev,
+                       enum led_brightness value)
+{
+       struct ot200_led *led = container_of(led_cdev, struct ot200_led, cdev);
+       u8 val;
+       u8 mask;
+       unsigned long flags;
+
+       mask = 1 << led->num;
+
+       spin_lock_irqsave(&value_lock, flags);
+       val = old_val;
+
+       if (value == LED_OFF)
+               val &= ~mask;
+       else
+               val |= mask;
+
+       old_val = val;
+       spin_unlock_irqrestore(&value_lock, flags);
+       outb(val, 0x49);
+}
+
+static void ot200_led_back_set(struct led_classdev *led_cdev,
+                       enum led_brightness value)
+{
+       struct ot200_led *led = container_of(led_cdev, struct ot200_led, cdev);
+       u8 val;
+       u8 mask;
+       unsigned long flags;
+
+       mask = 1 << led->num;
+
+       spin_lock_irqsave(&value_lock, flags);
+       val = old_val_back;
+
+       if (value == LED_OFF)
+               val &= ~mask;
+       else
+               val |= mask;
+
+       old_val_back = val;
+       spin_unlock_irqrestore(&value_lock, flags);
+       outb(val, 0x5a);
+}
+
+static int __devinit create_ot200_led(struct platform_device *pdev, int num,
+               struct ot200_led *led)
+{
+       int ret;
+
+       num += 1;
+       snprintf(led->name, sizeof(led->name), "led%d", num);
+       led->num = 7 - num;
+       led->cdev.name = led->name;
+       led->cdev.default_trigger = NULL;
+       led->cdev.blink_set = NULL;
+       led->cdev.brightness_set = ot200_led_set;
+
+       ret = led_classdev_register(&pdev->dev, &led->cdev);
+       if (ret < 0)
+               goto out;
+
+       dev_set_drvdata(led->cdev.dev, led);
+       return 0;
+
+       led_classdev_unregister(&led->cdev);
+out:
+       return ret;
+}
+
+static int __devinit create_ot200_led_back(struct platform_device *pdev,
+               int num, struct ot200_led *led)
+{
+       char *led_name;
+       int ret;
+
+       switch (num) {
+       case 0:
+               led_name = "run";
+               break;
+       case 1:
+               led_name = "init";
+               break;
+       case 2:
+               led_name = "err";
+               break;
+       default:
+               BUG();
+       };
+
+       snprintf(led->name, sizeof(led->name), "led_%s", led_name);
+       led->num = num;
+       led->cdev.name = led->name;
+       led->cdev.blink_set = NULL;
+       led->cdev.brightness_set = ot200_led_back_set;
+
+       ret = led_classdev_register(&pdev->dev, &led->cdev);
+       if (ret < 0)
+               goto out;
+
+       dev_set_drvdata(led->cdev.dev, led);
+       return 0;
+
+       led_classdev_unregister(&led->cdev);
+out:
+       return ret;
+
+}
+
+#define NUM_LEDS       7
+#define NUM_LEDS_BACK  3
+#define NUM_LEDS_TOTAL (NUM_LEDS + NUM_LEDS_BACK)
+
+static int __devinit ot200_led_probe(struct platform_device *pdev)
+{
+       struct ot200_led *leds;
+       int i;
+       int ret;
+
+       leds = kzalloc(sizeof(struct ot200_led) * NUM_LEDS_TOTAL, GFP_KERNEL);
+       if (!leds)
+               return -ENOMEM;
+
+       for (i = 0; i < NUM_LEDS; i++) {
+               ret = create_ot200_led(pdev, i, &leds[i]);
+               if (ret < 0)
+                       goto err;
+       }
+
+       for (i = NUM_LEDS; i < NUM_LEDS + NUM_LEDS_BACK; i++) {
+               ret = create_ot200_led_back(pdev, i - NUM_LEDS, &leds[i]);
+               if (ret < 0)
+                       goto err;
+       }
+
+       platform_set_drvdata(pdev, leds);
+       outb(0x0, 0x49);        /* turn of all front leds */
+       outb(0x2, 0x5a);        /* turn on init led */
+       return 0;
+
+err:
+       for (i = i - 1; i >= 0; i--)
+               led_classdev_unregister(&leds[i].cdev);
+
+       kfree(leds);
+
+       return ret;
+}
+
+static int __devexit ot200_led_remove(struct platform_device *pdev)
+{
+       int i;
+       struct ot200_led *leds;
+
+       leds = platform_get_drvdata(pdev);
+
+       for (i = 0; i < NUM_LEDS_TOTAL; i++)
+               led_classdev_unregister(&leds[i].cdev);
+
+       kfree(leds);
+       platform_set_drvdata(pdev, NULL);
+
+       return 0;
+}
+
+static struct platform_driver ot200_led_driver = {
+       .probe          = ot200_led_probe,
+       .remove         = __devexit_p(ot200_led_remove),
+       .driver         = {
+               .name   = "leds-ot200",
+               .owner  = THIS_MODULE,
+       },
+};
+
+module_platform_driver(ot200_led_driver);
+
+MODULE_AUTHOR("Sebastian A. Siewior <bigeasy@linutronix.de>");
+MODULE_DESCRIPTION("ot200 LED driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-ot200");
