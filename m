Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965229Ab2J3SMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:12:47 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59042 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965212Ab2J3SMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:41 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH] w1-gpio: Simplify & get rid of defines
Date: Wed, 31 Oct 2012 17:57:44 +0200
Message-Id: <1351699064-4619-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to have the OF defines; it complicates the driver.
There's also no need for the funky platform_driver_probe.

Add a few warnings in case there's a failure; helps us find out
what went wrong.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/w1/masters/w1-gpio.c | 58 ++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index aec35bd..85b363a 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -18,6 +18,7 @@
 #include <linux/of_gpio.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/err.h>
+#include <linux/of.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
@@ -46,7 +47,6 @@ static u8 w1_gpio_read_bit(void *data)
 	return gpio_get_value(pdata->pin) ? 1 : 0;
 }
 
-#ifdef CONFIG_OF
 static struct of_device_id w1_gpio_dt_ids[] = {
 	{ .compatible = "w1-gpio" },
 	{}
@@ -57,11 +57,6 @@ static int w1_gpio_probe_dt(struct platform_device *pdev)
 {
 	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
 	struct device_node *np = pdev->dev.of_node;
-	const struct of_device_id *of_id =
-			of_match_device(w1_gpio_dt_ids, &pdev->dev);
-
-	if (!of_id)
-		return 0;
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
@@ -76,12 +71,6 @@ static int w1_gpio_probe_dt(struct platform_device *pdev)
 
 	return 0;
 }
-#else
-static int w1_gpio_probe_dt(struct platform_device *pdev)
-{
-	return 0;
-}
-#endif
 
 static int __init w1_gpio_probe(struct platform_device *pdev)
 {
@@ -94,28 +83,41 @@ static int __init w1_gpio_probe(struct platform_device *pdev)
 	if (IS_ERR(pinctrl))
 		dev_warn(&pdev->dev, "unable to select pin group\n");
 
-	err = w1_gpio_probe_dt(pdev);
-	if (err < 0)
-		return err;
+	if (of_have_populated_dt()) {
+		err = w1_gpio_probe_dt(pdev);
+		if (err < 0) {
+			dev_err(&pdev->dev, "Failed to parse DT\n");
+			return err;
+		}
+	}
 
 	pdata = pdev->dev.platform_data;
 
-	if (!pdata)
+	if (!pdata) {
+		dev_err(&pdev->dev, "No configuration data\n");
 		return -ENXIO;
+	}
 
 	master = kzalloc(sizeof(struct w1_bus_master), GFP_KERNEL);
-	if (!master)
+	if (!master) {
+		dev_err(&pdev->dev, "Out of memory\n");
 		return -ENOMEM;
+	}
 
 	err = gpio_request(pdata->pin, "w1");
-	if (err)
+	if (err) {
+		dev_err(&pdev->dev, "gpio_request (pin) failed\n");
 		goto free_master;
+	}
 
 	if (gpio_is_valid(pdata->ext_pullup_enable_pin)) {
 		err = gpio_request_one(pdata->ext_pullup_enable_pin,
 				       GPIOF_INIT_LOW, "w1 pullup");
-		if (err < 0)
+		if (err < 0) {
+			dev_err(&pdev->dev, "gpio_request_one "
+					"(ext_pullup_enable_pin) failed\n");
 			goto free_gpio;
+		}
 	}
 
 	master->data = pdata;
@@ -130,8 +132,10 @@ static int __init w1_gpio_probe(struct platform_device *pdev)
 	}
 
 	err = w1_add_master_device(master);
-	if (err)
+	if (err) {
+		dev_err(&pdev->dev, "w1_add_master device failed\n");
 		goto free_gpio_ext_pu;
+	}
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(1);
@@ -205,23 +209,13 @@ static struct platform_driver w1_gpio_driver = {
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(w1_gpio_dt_ids),
 	},
+	.probe = w1_gpio_probe,
 	.remove	= __exit_p(w1_gpio_remove),
 	.suspend = w1_gpio_suspend,
 	.resume = w1_gpio_resume,
 };
 
-static int __init w1_gpio_init(void)
-{
-	return platform_driver_probe(&w1_gpio_driver, w1_gpio_probe);
-}
-
-static void __exit w1_gpio_exit(void)
-{
-	platform_driver_unregister(&w1_gpio_driver);
-}
-
-module_init(w1_gpio_init);
-module_exit(w1_gpio_exit);
+module_platform_driver(w1_gpio_driver);
 
 MODULE_DESCRIPTION("GPIO w1 bus master driver");
 MODULE_AUTHOR("Ville Syrjala <syrjala@sci.fi>");
-- 
1.7.12

