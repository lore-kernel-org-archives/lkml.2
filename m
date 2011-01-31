Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1AaQcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:32:25 -0500
Received: from smtp-out.google.com ([74.125.121.67]:13270 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab1AaQcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:32:24 -0500
From: Vincent Palatin <vpalatin@chromium.org>
To: Samuel Ortiz <sameo@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] mfd: tps6586x: Invert GPIO and subdevices initialization
Date: Mon, 31 Jan 2011 11:31:49 -0500
Message-Id: <1296491509-22495-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <AANLkTikxfvHMHWjy=y14wwj3f+V-NfcjtUnQ=6QOh_2R@mail.gmail.com>
References: <AANLkTikxfvHMHWjy=y14wwj3f+V-NfcjtUnQ=6QOh_2R@mail.gmail.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using a fixed voltage regulator triggered by a TPS6586x GPIO,
this allows to declare and initialize it conveniently from the "subdev" list.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 drivers/mfd/tps6586x.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 627cf57..c937742 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -288,12 +288,10 @@ static int tps6586x_gpio_output(struct gpio_chip *gc, unsigned offset,
 	return tps6586x_update(tps6586x->dev, TPS6586X_GPIOSET1, val, mask);
 }
 
-static void tps6586x_gpio_init(struct tps6586x *tps6586x, int gpio_base)
+static int tps6586x_gpio_init(struct tps6586x *tps6586x, int gpio_base)
 {
-	int ret;
-
 	if (!gpio_base)
-		return;
+		return 0;
 
 	tps6586x->gpio.owner		= THIS_MODULE;
 	tps6586x->gpio.label		= tps6586x->client->name;
@@ -307,9 +305,7 @@ static void tps6586x_gpio_init(struct tps6586x *tps6586x, int gpio_base)
 	tps6586x->gpio.set		= tps6586x_gpio_set;
 	tps6586x->gpio.get		= tps6586x_gpio_get;
 
-	ret = gpiochip_add(&tps6586x->gpio);
-	if (ret)
-		dev_warn(tps6586x->dev, "GPIO registration failed: %d\n", ret);
+	return gpiochip_add(&tps6586x->gpio);
 }
 
 static int __remove_subdev(struct device *dev, void *unused)
@@ -517,17 +513,28 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 		}
 	}
 
+	ret = tps6586x_gpio_init(tps6586x, pdata->gpio_base);
+	if (ret) {
+		dev_err(&client->dev, "GPIO registration failed: %d\n", ret);
+		goto err_gpio_init;
+	}
+
 	ret = tps6586x_add_subdevs(tps6586x, pdata);
 	if (ret) {
 		dev_err(&client->dev, "add devices failed: %d\n", ret);
 		goto err_add_devs;
 	}
 
-	tps6586x_gpio_init(tps6586x, pdata->gpio_base);
-
 	return 0;
 
 err_add_devs:
+	if (pdata->gpio_base) {
+		ret = gpiochip_remove(&tps6586x->gpio);
+		if (ret)
+			dev_err(&client->dev, "Can't remove gpio chip: %d\n",
+				ret);
+	}
+err_gpio_init:
 	if (client->irq)
 		free_irq(client->irq, tps6586x);
 err_irq_init:
@@ -587,4 +594,3 @@ module_exit(tps6586x_exit);
 MODULE_DESCRIPTION("TPS6586X core driver");
 MODULE_AUTHOR("Mike Rapoport <mike@compulab.co.il>");
 MODULE_LICENSE("GPL");
-
-- 
1.7.3.1

