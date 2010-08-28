Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab0H1USS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 16:18:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52852 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0H1USR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 16:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length:to
         :reply-to:content-type:content-transfer-encoding:message-id;
        b=cY6GJmgSKzVCKp+JtxWSeRdln6VV3jU5HLQ+fHK/jdMLdUz+P8nq/AR74HciD447pk
         gP8Q2LwptjJDpnJqXGgCof3OmNsf2wYBr81LQGoQL1Rwkd8EGiQPuMJqrW0qLYnaQVcD
         Yu0TR2+F+rXskOH0Bz4rskLyYPBDY9B51gFjA=
From: Florian Fainelli <florian@openwrt.org>
Date: Sat, 28 Aug 2010 22:19:16 +0200
Subject: [PATCH] GPIO: add support for NXP 74HC164 GPIO expander
MIME-Version: 1.0
X-TUID: 6cb6a5d67120277f
X-Length: 9069
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, Juhos Gabor <juhosg@openwrt.org>,
        David Brownell <dbrownell@users.sourceforge.net>
Reply-To: Florian Fainelli <florian@openwrt.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008282219.17578.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miguel Gaio <miguel.gaio@efixo.com>

This patch adds support for NXP's 74HC164 GPIO expander.

Signed-off-by: Miguel Gaio <miguel.gaio@efixo.com>
Signed-off-by: Juhos Gabor <jushog@openwrt.org>
Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 510aa20..1008901 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -361,4 +361,12 @@ config GPIO_JANZ_TTL
 	  This driver provides support for driving the pins in output
 	  mode only. Input mode is not supported.
 
+comment "Other GPIO expanders"
+
+config GPIO_NXP_74HC164
+       tristate "NXP 74HC164 Output expanders"
+       help
+         Platform driver for NXP 74HC164 8-output Expanders. This
+         provides a GPIO interface supporting outputs.
+
 endif
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index fc6019d..63221bf 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
 obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
+obj-$(CONFIG_GPIO_NXP_74HC164)	+= nxp_74hc164.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_PL061)	+= pl061.o
diff --git a/drivers/gpio/nxp_74hc164.c b/drivers/gpio/nxp_74hc164.c
new file mode 100644
index 0000000..88cfe8a
--- /dev/null
+++ b/drivers/gpio/nxp_74hc164.c
@@ -0,0 +1,227 @@
+/*
+ *  NXP 74HC164 - output expander  GPIO driver
+ *
+ *  Copyright (C) 2010 Gabor Juhos <juhosg@openwrt.org>
+ *  Copyright (C) 2010 Miguel Gaio <miguel.gaio@efixo.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  Copy from nxp_74hc153.c code
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/bitops.h>
+#include <linux/platform_device.h>
+#include <linux/nxp_74hc164.h>
+
+#define NXP_74HC164_NUM_GPIOS	8
+
+struct nxp_74hc164_chip {
+	struct device		*parent;
+	struct gpio_chip	gpio_chip;
+	struct mutex		lock;
+	long			mask;
+};
+
+static void nxp_74hc164_set_value(struct gpio_chip *, unsigned, int);
+
+static struct nxp_74hc164_chip *gpio_to_nxp(struct gpio_chip *gc)
+{
+	return container_of(gc, struct nxp_74hc164_chip, gpio_chip);
+}
+
+static int nxp_74hc164_direction_input(struct gpio_chip *gc, unsigned offset)
+{
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+static int nxp_74hc164_direction_output(struct gpio_chip *gc,
+					unsigned offset, int val)
+{
+	nxp_74hc164_set_value(gc, offset, val);
+	return 0;
+}
+
+static int nxp_74hc164_get_value(struct gpio_chip *gc, unsigned offset)
+{
+	struct nxp_74hc164_chip *nxp = gpio_to_nxp(gc);
+	int ret;
+
+	mutex_lock(&nxp->lock);
+	ret = test_bit(offset, &nxp->mask);
+	mutex_unlock(&nxp->lock);
+
+	return ret;
+}
+
+static void nxp_74hc164_set_value(struct gpio_chip *gc,
+				  unsigned offset, int val)
+{
+	struct nxp_74hc164_chip *nxp;
+	struct nxp_74hc164_platform_data *pdata;
+	long mask;
+	int refresh;
+	int i;
+
+	nxp = gpio_to_nxp(gc);
+	pdata = nxp->parent->platform_data;
+
+	mutex_lock(&nxp->lock);
+	if (val)
+		refresh = (test_and_set_bit(offset, &nxp->mask) != val);
+	else
+		refresh = (test_and_clear_bit(offset, &nxp->mask) != val);
+
+	if (refresh) {
+		mask = nxp->mask;
+		for (i = 8; i > 0; --i, mask <<= 1) {
+			gpio_set_value(pdata->gpio_pin_data, mask & 0x80);
+			gpio_set_value(pdata->gpio_pin_clk, 1);
+			gpio_set_value(pdata->gpio_pin_clk, 0);
+		}
+	}
+	mutex_unlock(&nxp->lock);
+}
+
+static int __devinit nxp_74hc164_probe(struct platform_device *pdev)
+{
+	struct nxp_74hc164_platform_data *pdata;
+	struct nxp_74hc164_chip *nxp;
+	struct gpio_chip *gc;
+	int err;
+
+	pdata = pdev->dev.platform_data;
+	if (pdata == NULL) {
+		dev_dbg(&pdev->dev, "no platform data specified\n");
+		return -EINVAL;
+	}
+
+	nxp = kzalloc(sizeof(struct nxp_74hc164_chip), GFP_KERNEL);
+	if (nxp == NULL) {
+		dev_err(&pdev->dev, "no memory for private data\n");
+		return -ENOMEM;
+	}
+
+	err = gpio_request(pdata->gpio_pin_clk, dev_name(&pdev->dev));
+	if (err) {
+		dev_err(&pdev->dev, "unable to claim gpio %u, err=%d\n",
+			pdata->gpio_pin_clk, err);
+		goto err_free_nxp;
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
+	nxp->parent = &pdev->dev;
+	mutex_init(&nxp->lock);
+
+	gc = &nxp->gpio_chip;
+
+	gc->direction_input  = nxp_74hc164_direction_input;
+	gc->direction_output = nxp_74hc164_direction_output;
+	gc->get = nxp_74hc164_get_value;
+	gc->set = nxp_74hc164_set_value;
+	gc->can_sleep = 1;
+
+	gc->base = pdata->gpio_base;
+	gc->ngpio = NXP_74HC164_NUM_GPIOS;
+	gc->label = dev_name(nxp->parent);
+	gc->dev = nxp->parent;
+	gc->owner = THIS_MODULE;
+
+	err = gpiochip_add(&nxp->gpio_chip);
+	if (err) {
+		dev_err(&pdev->dev, "unable to add gpio chip, err=%d\n", err);
+		goto err_free_data;
+	}
+
+	platform_set_drvdata(pdev, nxp);
+	return 0;
+
+err_free_data:
+	gpio_free(pdata->gpio_pin_data);
+err_free_clk:
+	gpio_free(pdata->gpio_pin_clk);
+err_free_nxp:
+	kfree(nxp);
+	return err;
+}
+
+static int nxp_74hc164_remove(struct platform_device *pdev)
+{
+	struct nxp_74hc164_chip *nxp = platform_get_drvdata(pdev);
+	struct nxp_74hc164_platform_data *pdata = pdev->dev.platform_data;
+
+	if (nxp) {
+		int err;
+
+		err = gpiochip_remove(&nxp->gpio_chip);
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
+		kfree(nxp);
+		platform_set_drvdata(pdev, NULL);
+	}
+
+	return 0;
+}
+
+static struct platform_driver nxp_74hc164_driver = {
+	.probe		= nxp_74hc164_probe,
+	.remove		= __devexit_p(nxp_74hc164_remove),
+	.driver = {
+		.name	= NXP_74HC164_DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init nxp_74hc164_init(void)
+{
+	return platform_driver_register(&nxp_74hc164_driver);
+}
+subsys_initcall(nxp_74hc164_init);
+
+static void __exit nxp_74hc164_exit(void)
+{
+	platform_driver_unregister(&nxp_74hc164_driver);
+}
+module_exit(nxp_74hc164_exit);
+
+MODULE_AUTHOR("Gabor Juhos <juhosg@openwrt.org>");
+MODULE_AUTHOR("Miguel Gaio <miguel.gaio@efixo.com>");
+MODULE_DESCRIPTION("GPIO expander driver for NXP 74HC164");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" NXP_74HC164_DRIVER_NAME);
diff --git a/include/linux/nxp_74hc164.h b/include/linux/nxp_74hc164.h
new file mode 100644
index 0000000..eb0201f
--- /dev/null
+++ b/include/linux/nxp_74hc164.h
@@ -0,0 +1,22 @@
+/*
+ *  NXP 74HC164 - Dual 4-input multiplexer defines
+ *
+ *  Copyright (C) 2010 Gabor Juhos <juhosg@openwrt.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#ifndef _NXP_74HC164_H
+#define _NXP_74HC164_H
+
+#define NXP_74HC164_DRIVER_NAME "nxp-74hc164"
+
+struct nxp_74hc164_platform_data {
+	unsigned	gpio_base;
+	unsigned	gpio_pin_data;
+	unsigned	gpio_pin_clk;
+};
+
+#endif /* _NXP_74HC164_H */
