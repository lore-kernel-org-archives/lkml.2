Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3ABVri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 16:47:38 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:62918 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3ABVre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 16:47:34 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] gpio: vt8500: memory cleanup missing
Date: Thu,  3 Jan 2013 10:47:20 +1300
Message-Id: <1357163240-23131-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is missing a .remove callback, and the fail path on
probe is incomplete.

If an error occurs in vt8500_add_chips, gpio_base is not unmapped.
The driver is also ignoring the return value from this function so
if a chip fails to register it completes as successful.

Replaced pr_err with dev_err in vt8500_add_chips since the device is
available.

There is also no .remove callback defined. To allow removing the
registered chips, I have moved *vtchip to be a static global.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/gpio/gpio-vt8500.c |   53 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-vt8500.c b/drivers/gpio/gpio-vt8500.c
index b53320a..a147b33 100644
--- a/drivers/gpio/gpio-vt8500.c
+++ b/drivers/gpio/gpio-vt8500.c
@@ -122,11 +122,13 @@ static struct vt8500_gpio_data wm8650_data = {
 
 struct vt8500_gpio_chip {
 	struct gpio_chip		chip;
-
 	const struct vt8500_gpio_bank_regoffsets *regs;
 	void __iomem	*base;
 };
 
+/* Pointer to our array of chips */
+static struct vt8500_gpio_chip *vtchip;
+
 
 #define to_vt8500(__chip) container_of(__chip, struct vt8500_gpio_chip, chip)
 
@@ -224,7 +226,6 @@ static int vt8500_of_xlate(struct gpio_chip *gc,
 static int vt8500_add_chips(struct platform_device *pdev, void __iomem *base,
 				const struct vt8500_gpio_data *data)
 {
-	struct vt8500_gpio_chip *vtchip;
 	struct gpio_chip *chip;
 	int i;
 	int pin_cnt = 0;
@@ -233,7 +234,7 @@ static int vt8500_add_chips(struct platform_device *pdev, void __iomem *base,
 			sizeof(struct vt8500_gpio_chip) * data->num_banks,
 			GFP_KERNEL);
 	if (!vtchip) {
-		pr_err("%s: failed to allocate chip memory\n", __func__);
+		dev_err(&pdev->dev, "failed to allocate chip memory\n");
 		return -ENOMEM;
 	}
 
@@ -261,6 +262,7 @@ static int vt8500_add_chips(struct platform_device *pdev, void __iomem *base,
 
 		gpiochip_add(chip);
 	}
+
 	return 0;
 }
 
@@ -273,36 +275,63 @@ static struct of_device_id vt8500_gpio_dt_ids[] = {
 
 static int vt8500_gpio_probe(struct platform_device *pdev)
 {
+	int ret;
 	void __iomem *gpio_base;
-	struct device_node *np;
+	struct device_node *np = pdev->dev.of_node;
 	const struct of_device_id *of_id =
 				of_match_device(vt8500_gpio_dt_ids, &pdev->dev);
 
-	if (!of_id) {
-		dev_err(&pdev->dev, "Failed to find gpio controller\n");
+	if (!np) {
+		dev_err(&pdev->dev, "GPIO node missing in devicetree\n");
 		return -ENODEV;
 	}
 
-	np = pdev->dev.of_node;
-	if (!np) {
-		dev_err(&pdev->dev, "Missing GPIO description in devicetree\n");
-		return -EFAULT;
+	if (!of_id) {
+		dev_err(&pdev->dev, "No matching driver data\n");
+		return -ENODEV;
 	}
 
 	gpio_base = of_iomap(np, 0);
 	if (!gpio_base) {
 		dev_err(&pdev->dev, "Unable to map GPIO registers\n");
-		of_node_put(np);
 		return -ENOMEM;
 	}
 
-	vt8500_add_chips(pdev, gpio_base, of_id->data);
+	ret = vt8500_add_chips(pdev, gpio_base, of_id->data);
+	if (ret) {
+		iounmap(gpio_base);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int vt8500_gpio_remove(struct platform_device *pdev)
+{
+	int i;
+	int ret;
+	const struct vt8500_gpio_data *data;
+	void __iomem *gpio_base = vtchip[0].base;
+	const struct of_device_id *of_id =
+				of_match_device(vt8500_gpio_dt_ids, &pdev->dev);
+
+	data = of_id->data;
+
+	for (i = 0; i < data->num_banks; i++) {
+		ret = gpiochip_remove(&vtchip[i].chip);
+		if (ret)
+			dev_warn(&pdev->dev, "gpiochip_remove returned %d\n",
+				 ret);
+	}
+
+	iounmap(gpio_base);
 
 	return 0;
 }
 
 static struct platform_driver vt8500_gpio_driver = {
 	.probe		= vt8500_gpio_probe,
+	.remove		= vt8500_gpio_remove,
 	.driver		= {
 		.name	= "vt8500-gpio",
 		.owner	= THIS_MODULE,
-- 
1.7.9.5

