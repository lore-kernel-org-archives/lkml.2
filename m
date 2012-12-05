Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab2LEC0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 21:26:21 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:38765 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451Ab2LEC0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 21:26:20 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, sameo@linux.intel.com, haojian.zhuang@gmail.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        zhouqiao@marvell.com, cxie4@marvell.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: 88pm80x: add dt support
Date: Wed,  5 Dec 2012 10:23:16 +0800
Message-Id: <1354674196-1998-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 05 Dec 2012 02:23:16.0058 (UTC) FILETIME=[7BAB1BA0:01CDD28F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

add dt support for 88pm800 and 88pm805

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/mfd/88pm800.c       |   26 +++++++++++++++++++++++---
 drivers/mfd/88pm805.c       |   26 +++++++++++++++++++++++---
 drivers/mfd/88pm80x.c       |   32 ++++++++++++++++++++++++++++++++
 include/linux/mfd/88pm80x.h |    3 +++
 4 files changed, 81 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 3fcc8dd..20b67d7 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -506,6 +506,22 @@ static int __devinit pm800_probe(struct i2c_client *client,
 	struct pm80x_chip *chip;
 	struct pm80x_platform_data *pdata = client->dev.platform_data;
 	struct pm80x_subchip *subchip;
+	struct device_node *node = client->dev.of_node;
+
+	if (node && !pdata) {
+		/* parse DT to get platform data */
+		pdata = devm_kzalloc(&client->dev,
+				     sizeof(struct pm80x_platform_data),
+				     GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+		ret = pm80x_dt_init(node, &client->dev, pdata);
+		if (ret)
+			return -EINVAL;
+	} else if (!pdata) {
+		pr_info("No platform data in %s!\n", __func__);
+		return -EINVAL;
+	}
 
 	ret = pm80x_init(client, id);
 	if (ret) {
@@ -540,9 +556,6 @@ static int __devinit pm800_probe(struct i2c_client *client,
 		goto err_800_init;
 	}
 
-	if (pdata->plat_config)
-		pdata->plat_config(chip, pdata);
-
 	return 0;
 
 err_800_init:
@@ -570,11 +583,18 @@ static int __devexit pm800_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct of_device_id pm800_dt_ids[] = {
+	{ .compatible = "marvell,88pm800", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pm800_dt_ids);
+
 static struct i2c_driver pm800_driver = {
 	.driver = {
 		.name = "88PM800",
 		.owner = THIS_MODULE,
 		.pm = &pm80x_pm_ops,
+		.of_match_table	= of_match_ptr(pm800_dt_ids),
 		},
 	.probe = pm800_probe,
 	.remove = __devexit_p(pm800_remove),
diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index 39a91bd..b0fb3ff 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -239,6 +239,22 @@ static int __devinit pm805_probe(struct i2c_client *client,
 	int ret = 0;
 	struct pm80x_chip *chip;
 	struct pm80x_platform_data *pdata = client->dev.platform_data;
+	struct device_node *node = client->dev.of_node;
+
+	if (node && !pdata) {
+		/* parse DT to get platform data */
+		pdata = devm_kzalloc(&client->dev,
+				     sizeof(struct pm80x_platform_data),
+				     GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+		ret = pm80x_dt_init(node, &client->dev, pdata);
+		if (ret)
+			return -EINVAL;
+	} else if (!pdata) {
+		pr_info("No platform data in %s!\n", __func__);
+		return -EINVAL;
+	}
 
 	ret = pm80x_init(client, id);
 	if (ret) {
@@ -254,9 +270,6 @@ static int __devinit pm805_probe(struct i2c_client *client,
 		goto err_805_init;
 	}
 
-	if (pdata->plat_config)
-		pdata->plat_config(chip, pdata);
-
 	return 0;
 
 err_805_init:
@@ -277,11 +290,18 @@ static int __devexit pm805_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct of_device_id pm805_dt_ids[] = {
+	{ .compatible = "marvell,88pm805", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pm805_dt_ids);
+
 static struct i2c_driver pm805_driver = {
 	.driver = {
 		.name = "88PM805",
 		.owner = THIS_MODULE,
 		.pm = &pm80x_pm_ops,
+		.of_match_table	= of_match_ptr(pm805_dt_ids),
 		},
 	.probe = pm805_probe,
 	.remove = __devexit_p(pm805_remove),
diff --git a/drivers/mfd/88pm80x.c b/drivers/mfd/88pm80x.c
index 1adb355..bd59202 100644
--- a/drivers/mfd/88pm80x.c
+++ b/drivers/mfd/88pm80x.c
@@ -111,6 +111,38 @@ int pm80x_deinit(struct i2c_client *client)
 }
 EXPORT_SYMBOL_GPL(pm80x_deinit);
 
+int pm80x_dt_init(struct device_node *np,
+				    struct device *dev,
+				    struct pm80x_platform_data *pdata)
+{
+	int ret;
+	ret = of_property_read_u32(np, "marvell,88pm80x-irqmode",
+				   &pdata->irq_mode);
+	if (ret) {
+		dev_err(dev, "Not found \"marvell,88pm80x-irqmode\" "
+			"property\n");
+		return -EINVAL;
+	}
+
+	ret = of_property_read_u32(np, "marvell,88pm80x-poweraddr",
+				   (u32*)(&pdata->power_page_addr));
+	if (ret) {
+		dev_err(dev, "Not found \"marvell,88pm80x-poweraddr\" "
+			"property\n");
+		return -EINVAL;
+	}
+
+	ret = of_property_read_u32(np, "marvell,88pm80x-gpadcaddr",
+				   (u32*)(&pdata->gpadc_page_addr));
+	if (ret) {
+		dev_err(dev, "Not found \"marvell,88pm80x-gpadcaddr\" "
+			"property\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pm80x_dt_init);
+
 #ifdef CONFIG_PM_SLEEP
 static int pm80x_suspend(struct device *dev)
 {
diff --git a/include/linux/mfd/88pm80x.h b/include/linux/mfd/88pm80x.h
index 904efb9..153f492 100644
--- a/include/linux/mfd/88pm80x.h
+++ b/include/linux/mfd/88pm80x.h
@@ -367,4 +367,7 @@ static inline int pm80x_dev_resume(struct device *dev)
 extern int pm80x_init(struct i2c_client *client,
 			     const struct i2c_device_id *id) __devinit;
 extern int pm80x_deinit(struct i2c_client *client);
+extern int pm80x_dt_init(struct device_node *np,
+						struct device *dev,
+						struct pm80x_platform_data *pdata);
 #endif /* __LINUX_MFD_88PM80X_H */
-- 
1.7.0.4

