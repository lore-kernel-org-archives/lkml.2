Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab2JKOP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:15:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44069 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab2JKOPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:15:54 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: [PATCH 2/2] input: gpio-keys: Add runtime support
Date: Thu, 11 Oct 2012 15:15:27 +0100
Message-Id: <1349964927-18619-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349964927-18619-1-git-send-email-lee.jones@linaro.org>
References: <1349964927-18619-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
Reviewed-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
---
 drivers/input/keyboard/gpio_keys.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 7947315..78de557 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -29,6 +29,7 @@
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
 #include <linux/spinlock.h>
+#include <linux/pm_runtime.h>
 
 struct gpio_button_data {
 	const struct gpio_keys_button *button;
@@ -526,6 +527,7 @@ static int gpio_keys_open(struct input_dev *input)
 {
 	struct gpio_keys_drvdata *ddata = input_get_drvdata(input);
 
+	pm_runtime_get_sync(input->dev.parent);
 	ddata->enabled = true;
 	return ddata->enable ? ddata->enable(input->dev.parent) : 0;
 }
@@ -537,6 +539,7 @@ static void gpio_keys_close(struct input_dev *input)
 	if (ddata->disable)
 		ddata->disable(input->dev.parent);
 	ddata->enabled = false;
+	pm_runtime_put(input->dev.parent);
 }
 
 /*
@@ -695,6 +698,8 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 	input->id.product = 0x0001;
 	input->id.version = 0x0100;
 
+	pm_runtime_enable(&pdev->dev);
+
 	/* Enable auto repeat feature of Linux input subsystem */
 	if (pdata->rep)
 		__set_bit(EV_REP, input->evbit);
@@ -760,6 +765,8 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
 	struct input_dev *input = ddata->input;
 	int i;
 
+	pm_runtime_disable(&pdev->dev);
+
 	sysfs_remove_group(&pdev->dev.kobj, &gpio_keys_attr_group);
 
 	device_init_wakeup(&pdev->dev, 0);
@@ -796,8 +803,8 @@ static int gpio_keys_suspend(struct device *dev)
 		}
 	} else {
 		ddata->enable_after_suspend = ddata->enabled;
-		if (ddata->enabled)
-			gpio_keys_close(ddata->input);
+		if (ddata->enabled && ddata->disable)
+			ddata->disable(dev);
 	}
 
 	return 0;
@@ -817,8 +824,9 @@ static int gpio_keys_resume(struct device *dev)
 			gpio_keys_gpio_report_event(bdata);
 	}
 
-	if (!device_may_wakeup(dev) && ddata->enable_after_suspend)
-		gpio_keys_open(ddata->input);
+	if (!device_may_wakeup(dev) && ddata->enable_after_suspend
+	    && ddata->enable)
+		ddata->enable(dev);
 
 	input_sync(ddata->input);
 
-- 
1.7.9.5

