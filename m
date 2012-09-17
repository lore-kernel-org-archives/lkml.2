Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2IQEUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 00:20:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59558 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2IQEUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 00:20:18 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 5/9] mfd: 88pm860x: move initilization code
Date: Mon, 17 Sep 2012 12:19:08 +0800
Message-Id: <1347855552-26213-6-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
References: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move probe() and other functions from 88pm860x-i2c.c to 88pm860x-core.c.
Since it could benefit to handle DT information.

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/mfd/88pm860x-core.c  |  162 +++++++++++++++++++++++++++++++++++++++++-
 drivers/mfd/88pm860x-i2c.c   |  160 -----------------------------------------
 include/linux/mfd/88pm860x.h |    4 --
 3 files changed, 159 insertions(+), 167 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index d2b0bf8..797bdb3 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -11,10 +11,13 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/88pm860x.h>
 #include <linux/regulator/machine.h>
@@ -1064,8 +1067,8 @@ static void __devinit device_8606_init(struct pm860x_chip *chip,
 	device_led_init(chip, pdata);
 }
 
-int __devinit pm860x_device_init(struct pm860x_chip *chip,
-		       struct pm860x_platform_data *pdata)
+static int __devinit pm860x_device_init(struct pm860x_chip *chip,
+					struct pm860x_platform_data *pdata)
 {
 	chip->core_irq = 0;
 
@@ -1092,12 +1095,165 @@ int __devinit pm860x_device_init(struct pm860x_chip *chip,
 	return 0;
 }
 
-void __devexit pm860x_device_exit(struct pm860x_chip *chip)
+static void __devexit pm860x_device_exit(struct pm860x_chip *chip)
 {
 	device_irq_exit(chip);
 	mfd_remove_devices(chip->dev);
 }
 
+static const struct i2c_device_id pm860x_id_table[] = {
+	{ "88PM860x", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, pm860x_id_table);
+
+static int verify_addr(struct i2c_client *i2c)
+{
+	unsigned short addr_8607[] = {0x30, 0x34};
+	unsigned short addr_8606[] = {0x10, 0x11};
+	int size, i;
+
+	if (i2c == NULL)
+		return 0;
+	size = ARRAY_SIZE(addr_8606);
+	for (i = 0; i < size; i++) {
+		if (i2c->addr == *(addr_8606 + i))
+			return CHIP_PM8606;
+	}
+	size = ARRAY_SIZE(addr_8607);
+	for (i = 0; i < size; i++) {
+		if (i2c->addr == *(addr_8607 + i))
+			return CHIP_PM8607;
+	}
+	return 0;
+}
+
+static struct regmap_config pm860x_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int __devinit pm860x_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
+{
+	struct pm860x_platform_data *pdata = client->dev.platform_data;
+	struct pm860x_chip *chip;
+	int ret;
+
+	if (!pdata) {
+		pr_info("No platform data in %s!\n", __func__);
+		return -EINVAL;
+	}
+
+	chip = kzalloc(sizeof(struct pm860x_chip), GFP_KERNEL);
+	if (chip == NULL)
+		return -ENOMEM;
+
+	chip->id = verify_addr(client);
+	chip->regmap = regmap_init_i2c(client, &pm860x_regmap_config);
+	if (IS_ERR(chip->regmap)) {
+		ret = PTR_ERR(chip->regmap);
+		dev_err(&client->dev, "Failed to allocate register map: %d\n",
+				ret);
+		kfree(chip);
+		return ret;
+	}
+	chip->client = client;
+	i2c_set_clientdata(client, chip);
+	chip->dev = &client->dev;
+	dev_set_drvdata(chip->dev, chip);
+
+	/*
+	 * Both client and companion client shares same platform driver.
+	 * Driver distinguishes them by pdata->companion_addr.
+	 * pdata->companion_addr is only assigned if companion chip exists.
+	 * At the same time, the companion_addr shouldn't equal to client
+	 * address.
+	 */
+	if (pdata->companion_addr && (pdata->companion_addr != client->addr)) {
+		chip->companion_addr = pdata->companion_addr;
+		chip->companion = i2c_new_dummy(chip->client->adapter,
+						chip->companion_addr);
+		chip->regmap_companion = regmap_init_i2c(chip->companion,
+							&pm860x_regmap_config);
+		if (IS_ERR(chip->regmap_companion)) {
+			ret = PTR_ERR(chip->regmap_companion);
+			dev_err(&chip->companion->dev,
+				"Failed to allocate register map: %d\n", ret);
+			return ret;
+		}
+		i2c_set_clientdata(chip->companion, chip);
+	}
+
+	pm860x_device_init(chip, pdata);
+	return 0;
+}
+
+static int __devexit pm860x_remove(struct i2c_client *client)
+{
+	struct pm860x_chip *chip = i2c_get_clientdata(client);
+
+	pm860x_device_exit(chip);
+	if (chip->companion) {
+		regmap_exit(chip->regmap_companion);
+		i2c_unregister_device(chip->companion);
+	}
+	regmap_exit(chip->regmap);
+	kfree(chip);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int pm860x_suspend(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct pm860x_chip *chip = i2c_get_clientdata(client);
+
+	if (device_may_wakeup(dev) && chip->wakeup_flag)
+		enable_irq_wake(chip->core_irq);
+	return 0;
+}
+
+static int pm860x_resume(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct pm860x_chip *chip = i2c_get_clientdata(client);
+
+	if (device_may_wakeup(dev) && chip->wakeup_flag)
+		disable_irq_wake(chip->core_irq);
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(pm860x_pm_ops, pm860x_suspend, pm860x_resume);
+
+static struct i2c_driver pm860x_driver = {
+	.driver	= {
+		.name	= "88PM860x",
+		.owner	= THIS_MODULE,
+		.pm     = &pm860x_pm_ops,
+	},
+	.probe		= pm860x_probe,
+	.remove		= __devexit_p(pm860x_remove),
+	.id_table	= pm860x_id_table,
+};
+
+static int __init pm860x_i2c_init(void)
+{
+	int ret;
+	ret = i2c_add_driver(&pm860x_driver);
+	if (ret != 0)
+		pr_err("Failed to register 88PM860x I2C driver: %d\n", ret);
+	return ret;
+}
+subsys_initcall(pm860x_i2c_init);
+
+static void __exit pm860x_i2c_exit(void)
+{
+	i2c_del_driver(&pm860x_driver);
+}
+module_exit(pm860x_i2c_exit);
+
 MODULE_DESCRIPTION("PMIC Driver for Marvell 88PM860x");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/88pm860x-i2c.c b/drivers/mfd/88pm860x-i2c.c
index b2cfdc4..cd53a82 100644
--- a/drivers/mfd/88pm860x-i2c.c
+++ b/drivers/mfd/88pm860x-i2c.c
@@ -10,12 +10,9 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
 #include <linux/i2c.h>
-#include <linux/err.h>
 #include <linux/regmap.h>
 #include <linux/mfd/88pm860x.h>
-#include <linux/slab.h>
 
 int pm860x_reg_read(struct i2c_client *i2c, int reg)
 {
@@ -231,160 +228,3 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL(pm860x_page_set_bits);
-
-static const struct i2c_device_id pm860x_id_table[] = {
-	{ "88PM860x", 0 },
-	{}
-};
-MODULE_DEVICE_TABLE(i2c, pm860x_id_table);
-
-static int verify_addr(struct i2c_client *i2c)
-{
-	unsigned short addr_8607[] = {0x30, 0x34};
-	unsigned short addr_8606[] = {0x10, 0x11};
-	int size, i;
-
-	if (i2c == NULL)
-		return 0;
-	size = ARRAY_SIZE(addr_8606);
-	for (i = 0; i < size; i++) {
-		if (i2c->addr == *(addr_8606 + i))
-			return CHIP_PM8606;
-	}
-	size = ARRAY_SIZE(addr_8607);
-	for (i = 0; i < size; i++) {
-		if (i2c->addr == *(addr_8607 + i))
-			return CHIP_PM8607;
-	}
-	return 0;
-}
-
-static struct regmap_config pm860x_regmap_config = {
-	.reg_bits = 8,
-	.val_bits = 8,
-};
-
-static int __devinit pm860x_probe(struct i2c_client *client,
-				  const struct i2c_device_id *id)
-{
-	struct pm860x_platform_data *pdata = client->dev.platform_data;
-	struct pm860x_chip *chip;
-	int ret;
-
-	if (!pdata) {
-		pr_info("No platform data in %s!\n", __func__);
-		return -EINVAL;
-	}
-
-	chip = kzalloc(sizeof(struct pm860x_chip), GFP_KERNEL);
-	if (chip == NULL)
-		return -ENOMEM;
-
-	chip->id = verify_addr(client);
-	chip->regmap = regmap_init_i2c(client, &pm860x_regmap_config);
-	if (IS_ERR(chip->regmap)) {
-		ret = PTR_ERR(chip->regmap);
-		dev_err(&client->dev, "Failed to allocate register map: %d\n",
-				ret);
-		kfree(chip);
-		return ret;
-	}
-	chip->client = client;
-	i2c_set_clientdata(client, chip);
-	chip->dev = &client->dev;
-	dev_set_drvdata(chip->dev, chip);
-
-	/*
-	 * Both client and companion client shares same platform driver.
-	 * Driver distinguishes them by pdata->companion_addr.
-	 * pdata->companion_addr is only assigned if companion chip exists.
-	 * At the same time, the companion_addr shouldn't equal to client
-	 * address.
-	 */
-	if (pdata->companion_addr && (pdata->companion_addr != client->addr)) {
-		chip->companion_addr = pdata->companion_addr;
-		chip->companion = i2c_new_dummy(chip->client->adapter,
-						chip->companion_addr);
-		chip->regmap_companion = regmap_init_i2c(chip->companion,
-							&pm860x_regmap_config);
-		if (IS_ERR(chip->regmap_companion)) {
-			ret = PTR_ERR(chip->regmap_companion);
-			dev_err(&chip->companion->dev,
-				"Failed to allocate register map: %d\n", ret);
-			return ret;
-		}
-		i2c_set_clientdata(chip->companion, chip);
-	}
-
-	pm860x_device_init(chip, pdata);
-	return 0;
-}
-
-static int __devexit pm860x_remove(struct i2c_client *client)
-{
-	struct pm860x_chip *chip = i2c_get_clientdata(client);
-
-	pm860x_device_exit(chip);
-	if (chip->companion) {
-		regmap_exit(chip->regmap_companion);
-		i2c_unregister_device(chip->companion);
-	}
-	regmap_exit(chip->regmap);
-	kfree(chip);
-	return 0;
-}
-
-#ifdef CONFIG_PM_SLEEP
-static int pm860x_suspend(struct device *dev)
-{
-	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
-	struct pm860x_chip *chip = i2c_get_clientdata(client);
-
-	if (device_may_wakeup(dev) && chip->wakeup_flag)
-		enable_irq_wake(chip->core_irq);
-	return 0;
-}
-
-static int pm860x_resume(struct device *dev)
-{
-	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
-	struct pm860x_chip *chip = i2c_get_clientdata(client);
-
-	if (device_may_wakeup(dev) && chip->wakeup_flag)
-		disable_irq_wake(chip->core_irq);
-	return 0;
-}
-#endif
-
-static SIMPLE_DEV_PM_OPS(pm860x_pm_ops, pm860x_suspend, pm860x_resume);
-
-static struct i2c_driver pm860x_driver = {
-	.driver	= {
-		.name	= "88PM860x",
-		.owner	= THIS_MODULE,
-		.pm     = &pm860x_pm_ops,
-	},
-	.probe		= pm860x_probe,
-	.remove		= __devexit_p(pm860x_remove),
-	.id_table	= pm860x_id_table,
-};
-
-static int __init pm860x_i2c_init(void)
-{
-	int ret;
-	ret = i2c_add_driver(&pm860x_driver);
-	if (ret != 0)
-		pr_err("Failed to register 88PM860x I2C driver: %d\n", ret);
-	return ret;
-}
-subsys_initcall(pm860x_i2c_init);
-
-static void __exit pm860x_i2c_exit(void)
-{
-	i2c_del_driver(&pm860x_driver);
-}
-module_exit(pm860x_i2c_exit);
-
-MODULE_DESCRIPTION("I2C Driver for Marvell 88PM860x");
-MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
-MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/88pm860x.h b/include/linux/mfd/88pm860x.h
index 87c933d..d515e5c 100644
--- a/include/linux/mfd/88pm860x.h
+++ b/include/linux/mfd/88pm860x.h
@@ -402,8 +402,4 @@ extern int pm860x_page_bulk_write(struct i2c_client *, int, int,
 extern int pm860x_page_set_bits(struct i2c_client *, int, unsigned char,
 				unsigned char);
 
-extern int pm860x_device_init(struct pm860x_chip *chip,
-			      struct pm860x_platform_data *pdata) __devinit ;
-extern void pm860x_device_exit(struct pm860x_chip *chip) __devexit ;
-
 #endif /* __LINUX_MFD_88PM860X_H */
-- 
1.7.9.5

