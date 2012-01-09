Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab2AIODc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:03:32 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63501 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab2AIODZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:03:25 -0500
Message-ID: <4F0AF3A4.60705@gmail.com>
Date: Mon, 09 Jan 2012 15:03:16 +0100
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Reply-To: christian.gmeiner@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, lars@metafoo.de
CC: bigeasy@linutronix.de, rpurdie@rpsys.net
Subject: [PATCH v3] add led driver for Bachmann's ot200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a7fecf3426ef98fdd19e9d2610665b9d1ce358a0 Mon Sep 17 00:00:00 2001
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de
<mailto:bigeasy@linutronix.de>>
Date: Mon, 9 Jan 2012 14:44:46 +0100
Subject: [PATCH v3] add led driver for Bachmann's ot200

This patch adds support for leds on Bachmann's ot200 visualisation device.
The device has three leds on the back panel (led_err, led_init and led_run)
and can handle up to seven leds on the front panel.

The driver was written by Linutronix on behalf of
Bachmann electronic GmbH.

Changes in v3:
- incorporated feedback from Lars-Peter Clausen

Changes in v2:
- incorporated feedback from Andrew Morton and Lars-Peter Clausen

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
 drivers/leds/Kconfig      |    7 ++
 drivers/leds/Makefile     |    1 +
 drivers/leds/leds-ot200.c |  171
+++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 179 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-ot200.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index ff203a4..71cb89b 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -387,6 +387,13 @@ config LEDS_RENESAS_TPU
 	  pin function. The latter to support brightness control.
 	  Brightness control is supported but hardware blinking is not.

+config LEDS_OT200
+	tristate "LED support for the Bachmann OT200"
+	depends on LEDS_CLASS
+	help
+	  This option enables support for the LEDs on the Bachmann OT200.
+	  Say Y to enable LEDs on the Bachmann OT200.
+
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index e4f6bf5..0814d42 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
 obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
 obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
 obj-$(CONFIG_LEDS_RENESAS_TPU)		+= leds-renesas-tpu.o
+obj-$(CONFIG_LEDS_OT200)		+= leds-ot200.o

 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c
new file mode 100644
index 0000000..c464682
--- /dev/null
+++ b/drivers/leds/leds-ot200.c
@@ -0,0 +1,171 @@
+/*
+ * Bachmann ot200 leds driver.
+ *
+ * Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
+ *         Christian Gmeiner <christian.gmeiner@gmail.com>
+ *
+ * License: GPL as published by the FSF.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
+#include <linux/io.h>
+#include <linux/module.h>
+
+
+struct ot200_led {
+	struct led_classdev cdev;
+	const char *name;
+	unsigned long port;
+	u8 mask;
+};
+
+/*
+ * The device has three leds on the back panel (led_err, led_init and
led_run)
+ * and can handle up to seven leds on the front panel.
+ */
+
+static struct ot200_led leds[] = {
+	{
+		.name = "led_run",
+		.port = 0x5a,
+		.mask = BIT(0),
+	},
+	{
+		.name = "led_init",
+		.port = 0x5a,
+		.mask = BIT(1),
+	},
+	{
+		.name = "led_err",
+		.port = 0x5a,
+		.mask = BIT(2),
+	},
+	{
+		.name = "led_1",
+		.port = 0x49,
+		.mask = BIT(7),
+	},
+	{
+		.name = "led_2",
+		.port = 0x49,
+		.mask = BIT(6),
+	},
+	{
+		.name = "led_3",
+		.port = 0x49,
+		.mask = BIT(5),
+	},
+	{
+		.name = "led_4",
+		.port = 0x49,
+		.mask = BIT(4),
+	},
+	{
+		.name = "led_5",
+		.port = 0x49,
+		.mask = BIT(3),
+	},
+	{
+		.name = "led_6",
+		.port = 0x49,
+		.mask = BIT(2),
+	},
+	{
+		.name = "led_7",
+		.port = 0x49,
+		.mask = BIT(1),
+	}
+};
+
+static DEFINE_SPINLOCK(value_lock);
+
+/*
+ * we need to store the current led states, as it is not
+ * possible to read the current led state via inb().
+ */
+static u8 leds_back;
+static u8 leds_front;
+
+static void ot200_led_brightness_set(struct led_classdev *led_cdev,
+		enum led_brightness value)
+{
+	struct ot200_led *led = container_of(led_cdev, struct ot200_led, cdev);
+	u8 *val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&value_lock, flags);
+
+	if (led->port == 0x49)
+		val = &leds_front;
+	else if (led->port == 0x5a)
+		val = &leds_back;
+	else
+		BUG();
+
+	if (value == LED_OFF)
+		*val &= ~led->mask;
+	else
+		*val |= led->mask;
+
+	outb(*val, led->port);
+	spin_unlock_irqrestore(&value_lock, flags);
+}
+
+static int __devinit ot200_led_probe(struct platform_device *pdev)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(leds); i++) {
+
+		leds[i].cdev.name = leds[i].name;
+		leds[i].cdev.brightness_set = ot200_led_brightness_set;
+
+		ret = led_classdev_register(&pdev->dev, &leds[i].cdev);
+		if (ret < 0)
+			goto err;
+	}
+
+	leds_front = 0;		/* turn off all front leds */
+	leds_back = BIT(1);	/* turn on init led */
+	outb(leds_front, 0x49);
+	outb(leds_back, 0x5a);
+
+	return 0;
+
+err:
+	for (i = i - 1; i >= 0; i--)
+		led_classdev_unregister(&leds[i].cdev);
+
+	return ret;
+}
+
+static int __devexit ot200_led_remove(struct platform_device *pdev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(leds); i++)
+		led_classdev_unregister(&leds[i].cdev);
+
+	return 0;
+}
+
+static struct platform_driver ot200_led_driver = {
+	.probe		= ot200_led_probe,
+	.remove		= __devexit_p(ot200_led_remove),
+	.driver		= {
+		.name	= "leds-ot200",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(ot200_led_driver);
+
+MODULE_AUTHOR("Sebastian A. Siewior <bigeasy@linutronix.de>");
+MODULE_DESCRIPTION("ot200 LED driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-ot200");
-- 
1.7.5.4
