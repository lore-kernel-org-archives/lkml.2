Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab2LFBzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 20:55:45 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:37291 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751980Ab2LFBzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 20:55:44 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, sameo@linux.intel.com, haojian.zhuang@gmail.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        zhouqiao@marvell.com, cxie4@marvell.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: 88pm80x: add dt support
Date: Thu,  6 Dec 2012 09:55:49 +0800
Message-Id: <1354758949-29186-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 06 Dec 2012 01:55:39.0785 (UTC) FILETIME=[CADDA790:01CDD354]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

add dt support for 88pm800 and 88pm805

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 Documentation/devicetree/bindings/mfd/88pm80x.txt |   52 +++++++++++++++++++++
 drivers/mfd/88pm800.c                             |   26 +++++++++-
 drivers/mfd/88pm805.c                             |   26 +++++++++-
 drivers/mfd/88pm80x.c                             |   32 +++++++++++++
 include/linux/mfd/88pm80x.h                       |    3 +
 5 files changed, 133 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/88pm80x.txt

diff --git a/Documentation/devicetree/bindings/mfd/88pm80x.txt b/Documentation/devicetree/bindings/mfd/88pm80x.txt
new file mode 100644
index 0000000..8a0ed07
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/88pm80x.txt
@@ -0,0 +1,52 @@
+* Marvell 88pm80x Power Management IC
+
+Required parent device properties:
+- compatible : "marvell,88pm80x"
+- reg : the I2C slave address for the 88pm80x chip
+- interrupts : IRQ line for the 88pm80x chip
+- interrupt-controller: describes the 88pm80x as an interrupt controller (has its own domain)
+- #interrupt-cells : should be 1.
+	- The cell is the 88pm80x local IRQ number
+
+Optional parent device properties:
+- marvell,88pm80x-irqmode: inicates whether interrupt status is cleared by read
+- marvell,88pm80x-poweraddr: 88pm80x are multi-chips solution. <reg> stores the I2C address
+				of one chip, and this property stores the I2C address of
+				power related chip.
+- marvell,88pm80x-gpadcaddr: 88pm80x are multi-chips solution. <reg> stores the I2C address
+				of one chip, and this property stores the I2C address of
+				gpadc related chip.
+
+88pm80x consists of various groups of sub-devices:
+
+Device			 Supply Names	 Description
+------			 ------------	 -----------
+88pm80x-onkey		:		: On key
+88pm80x-rtc		:		: RTC
+
+Example:
+	pmic: 88pm800@30 {
+		compatible = "marvell,88pm80x";
+		reg = <0x30>;
+		interrupts = <4>;
+		interrupt-parent = <&intc>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+
+		marvell,88pm80x-irqmode = 0;
+		marvell,88pm80x-poweraddr = <0x31>;
+		marvell,88pm80x-gpadcaddr = <0x32>;
+	};
+
+
+	pmic: 88pm805@38 {
+		compatible = "marvell,88pm80x";
+		reg = <0x38>;
+		interrupts = <124>;
+		interrupt-parent = <&gpio>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+
+		marvell,88pm80x-irqmode = 0;
+	};
+
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
index 1adb355..ad42d2a 100644
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
+		return 0;
+	}
+
+	ret = of_property_read_u32(np, "marvell,88pm80x-gpadcaddr",
+				   (u32*)(&pdata->gpadc_page_addr));
+	if (ret) {
+		dev_err(dev, "Not found \"marvell,88pm80x-gpadcaddr\" "
+			"property\n");
+		return 0;
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

