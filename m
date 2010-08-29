Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0H2Pgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:36:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51342 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab0H2Pga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:36:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:reply-to:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=Qo77RzqynKJUeqbwak/Krco7+KV41V0JY3X9qgCGwU9LY+z2C6d1VxVE8SL52v+tN6
         eXqnUXkP2cMfkn655lirqmtmJYMqCKFXTaQePFCh29A/wwfjaP946UqgqCJdIf7P8Vdy
         y+CKdiKI1IA2ysShRx1+Yn1IREw2711ozdS7A=
From: Florian Fainelli <florian@openwrt.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
To: Willy Tarreau <w@1wt.eu>
Subject: [PATCH v2] GPIO: add support for 74HC164 serial-in/parallel-out 8-bit shift register
Date: Sun, 29 Aug 2010 17:37:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-1-amd64; KDE/4.4.5; x86_64; ; )
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, Juhos Gabor <juhosg@openwrt.org>,
        David Brownell <dbrownell@users.sourceforge.net>
References: <461057.78283.qm@web180310.mail.gq1.yahoo.com> <20100829101034.GB16004@1wt.eu>
In-Reply-To: <20100829101034.GB16004@1wt.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008291737.32433.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the second version of the patch:
--
From: Miguel Gaio <miguel.gaio@efixo.com>

This patch adds support for generic 74HC164 serial-in/parallel-out 8-bits
shift register. This driver can be used as a GPIO output expander.

Signed-off-by: Miguel Gaio <miguel.gaio@efixo.com>
Signed-off-by: Juhos Gabor <juhosg@openwrt.org>
Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes since v1:
- renamed nxp_ to gen_ since this driver is generic to all 74HC164 chips
- added comment on this driver not handling the 74HC164 daisy-chaining
- renamed misused GPIO expanders to Shift registers

diff --git a/drivers/gpio/74hc164.c b/drivers/gpio/74hc164.c
new file mode 100644
index 0000000..fa63215
--- /dev/null
+++ b/drivers/gpio/74hc164.c
@@ -0,0 +1,228 @@
+/*
+ *  74HC164 - Serial-in/parallel-out 8-bits shift register GPIO driver
+ *
+ *  Copyright (C) 2010 Gabor Juhos <juhosg@openwrt.org>
+ *  Copyright (C) 2010 Miguel Gaio <miguel.gaio@efixo.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  Note: this driver does not support the way 74HC164 chips can be
+ *  daisy-chained.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/bitops.h>
+#include <linux/platform_device.h>
+#include <linux/74hc164.h>
+
+#define GEN_74HC164_NUM_GPIOS	8
+
+struct gen_74hc164_chip {
+	struct device		*parent;
+	struct gpio_chip	gpio_chip;
+	struct mutex		lock;
+	long			mask;
+};
+
+static void gen_74hc164_set_value(struct gpio_chip *, unsigned, int);
+
+static struct gen_74hc164_chip *gpio_to_chip(struct gpio_chip *gc)
+{
+	return container_of(gc, struct gen_74hc164_chip, gpio_chip);
+}
+
+static int gen_74hc164_direction_input(struct gpio_chip *gc, unsigned offset)
+{
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+static int gen_74hc164_direction_output(struct gpio_chip *gc,
+					unsigned offset, int val)
+{
+	gen_74hc164_set_value(gc, offset, val);
+	return 0;
+}
+
+static int gen_74hc164_get_value(struct gpio_chip *gc, unsigned offset)
+{
+	struct gen_74hc164_chip *chip = gpio_to_chip(gc);
+	int ret;
+
+	mutex_lock(&chip->lock);
+	ret = test_bit(offset, &chip->mask);
+	mutex_unlock(&chip->lock);
+
+	return ret;
+}
+
+static void gen_74hc164_set_value(struct gpio_chip *gc,
+				  unsigned offset, int val)
+{
+	struct gen_74hc164_chip *chip;
+	struct gen_74hc164_platform_data *pdata;
+	long mask;
+	int refresh;
+	int i;
+
+	chip = gpio_to_chip(gc);
+	pdata = chip->parent->platform_data;
+
+	mutex_lock(&chip->lock);
+	if (val)
+		refresh = (test_and_set_bit(offset, &chip->mask) != val);
+	else
+		refresh = (test_and_clear_bit(offset, &chip->mask) != val);
+
+	if (refresh) {
+		mask = chip->mask;
+		for (i = 8; i > 0; --i, mask <<= 1) {
+			gpio_set_value(pdata->gpio_pin_data, mask & 0x80);
+			gpio_set_value(pdata->gpio_pin_clk, 1);
+			gpio_set_value(pdata->gpio_pin_clk, 0);
+		}
+	}
+	mutex_unlock(&chip->lock);
+}
+
+static int __devinit gen_74hc164_probe(struct platform_device *pdev)
+{
+	struct gen_74hc164_platform_data *pdata;
+	struct gen_74hc164_chip *chip;
+	struct gpio_chip *gc;
+	int err;
+
+	pdata = pdev->dev.platform_data;
+	if (pdata == NULL) {
+		dev_dbg(&pdev->dev, "no platform data specified\n");
+		return -EINVAL;
+	}
+
+	chip = kzalloc(sizeof(struct gen_74hc164_chip), GFP_KERNEL);
+	if (chip == NULL) {
+		dev_err(&pdev->dev, "no memory for private data\n");
+		return -ENOMEM;
+	}
+
+	err = gpio_request(pdata->gpio_pin_clk, dev_name(&pdev->dev));
+	if (err) {
+		dev_err(&pdev->dev, "unable to claim gpio %u, err=%d\n",
+			pdata->gpio_pin_clk, err);
+		goto err_free_chip;
+	}
+
+	err = gpio_request(pdata->gpio_pin_data, dev_name(&pdev->dev));
+	if (err) {
+		dev_err(&pdev->dev, "unable to claim gpio %u, err=%d\n",
+			pdata->gpio_pin_data, err);
+		goto err_free_clk;
+	}
+
+	err = gpio_direction_output(pdata->gpio_pin_clk, 0);
+	if (err) {
+		dev_err(&pdev->dev,
+			"unable to set direction of gpio %u, err=%d\n",
+			pdata->gpio_pin_clk, err);
+		goto err_free_data;
+	}
+
+	err = gpio_direction_output(pdata->gpio_pin_data, 0);
+	if (err) {
+		dev_err(&pdev->dev,
+			"unable to set direction of gpio %u, err=%d\n",
+			pdata->gpio_pin_data, err);
+		goto err_free_data;
+	}
+
+	chip->parent = &pdev->dev;
+	mutex_init(&chip->lock);
+
+	gc = &chip->gpio_chip;
+
+	gc->direction_input  = gen_74hc164_direction_input;
+	gc->direction_output = gen_74hc164_direction_output;
+	gc->get = gen_74hc164_get_value;
+	gc->set = gen_74hc164_set_value;
+	gc->can_sleep = 1;
+
+	gc->base = pdata->gpio_base;
+	gc->ngpio = GEN_74HC164_NUM_GPIOS;
+	gc->label = dev_name(chip->parent);
+	gc->dev = chip->parent;
+	gc->owner = THIS_MODULE;
+
+	err = gpiochip_add(&chip->gpio_chip);
+	if (err) {
+		dev_err(&pdev->dev, "unable to add gpio chip, err=%d\n", err);
+		goto err_free_data;
+	}
+
+	platform_set_drvdata(pdev, chip);
+	return 0;
+
+err_free_data:
+	gpio_free(pdata->gpio_pin_data);
+err_free_clk:
+	gpio_free(pdata->gpio_pin_clk);
+err_free_chip:
+	kfree(chip);
+	return err;
+}
+
+static int gen_74hc164_remove(struct platform_device *pdev)
+{
+	struct gen_74hc164_chip *chip = platform_get_drvdata(pdev);
+	struct gen_74hc164_platform_data *pdata = pdev->dev.platform_data;
+
+	if (chip) {
+		int err;
+
+		err = gpiochip_remove(&chip->gpio_chip);
+		if (err) {
+			dev_err(&pdev->dev,
+				"unable to remove gpio chip, err=%d\n",
+				err);
+			return err;
+		}
+
+		gpio_free(pdata->gpio_pin_clk);
+		gpio_free(pdata->gpio_pin_data);
+
+		kfree(chip);
+		platform_set_drvdata(pdev, NULL);
+	}
+
+	return 0;
+}
+
+static struct platform_driver gen_74hc164_driver = {
+	.probe		= gen_74hc164_probe,
+	.remove		= __devexit_p(gen_74hc164_remove),
+	.driver = {
+		.name	= GEN_74HC164_DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init gen_74hc164_init(void)
+{
+	return platform_driver_register(&gen_74hc164_driver);
+}
+subsys_initcall(gen_74hc164_init);
+
+static void __exit gen_74hc164_exit(void)
+{
+	platform_driver_unregister(&gen_74hc164_driver);
+}
+module_exit(gen_74hc164_exit);
+
+MODULE_AUTHOR("Gabor Juhos <juhosg@openwrt.org>");
+MODULE_AUTHOR("Miguel Gaio <miguel.gaio@efixo.com>");
+MODULE_DESCRIPTION("GPIO expander driver for 74HC164 8-bits shift register");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" GEN_74HC164_DRIVER_NAME);
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 510aa20..ec27ab6 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -361,4 +361,13 @@ config GPIO_JANZ_TTL
 	  This driver provides support for driving the pins in output
 	  mode only. Input mode is not supported.
 
+comment "Shift registers:"
+
+config GPIO_74HC164
+       tristate "74HC164 serial-in/parallel-out 8-bit shift register"
+       help
+         Platform driver for 74HC164 serial-in/parallel-out 8-outputs shift
+	 registers. This driver can be used to provide access to more gpio
+	 outputs.
+
 endif
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index fc6019d..2fcb2b8 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
 obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
+obj-$(CONFIG_GPIO_74HC164)	+= 74hc164.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_PL061)	+= pl061.o
diff --git a/include/linux/74hc164.h b/include/linux/74hc164.h
new file mode 100644
index 0000000..dae3d46
--- /dev/null
+++ b/include/linux/74hc164.h
@@ -0,0 +1,22 @@
+/*
+ *  74HC164 - Serial-in/parallel-out 8-bits shift register
+ *
+ *  Copyright (C) 2010 Gabor Juhos <juhosg@openwrt.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#ifndef __74HC164_H
+#define __74HC164_H
+
+#define GEN_74HC164_DRIVER_NAME "74hc164"
+
+struct gen_74hc164_platform_data {
+	unsigned	gpio_base;
+	unsigned	gpio_pin_data;
+	unsigned	gpio_pin_clk;
+};
+
+#endif /* __74HC164_H */


