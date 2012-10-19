Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab2JSKjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:39:09 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:57847 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab2JSKjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:39:03 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Thierry Reding <thierry.reding@avionic-design.de>, arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 2/3] PWM: vt8500: Update vt8500 PWM driver support
Date: Fri, 19 Oct 2012 23:38:54 +1300
Message-Id: <1350643135-13197-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates pwm-vt8500.c to support devicetree probing and
make use of the common clock subsystem.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/pwm/pwm-vt8500.c |   79 ++++++++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 28 deletions(-)

diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
index ad14389..c2a71ee 100644
--- a/drivers/pwm/pwm-vt8500.c
+++ b/drivers/pwm/pwm-vt8500.c
@@ -1,7 +1,8 @@
 /*
  * drivers/pwm/pwm-vt8500.c
  *
- *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ * Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
+ * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -21,14 +22,24 @@
 #include <linux/io.h>
 #include <linux/pwm.h>
 #include <linux/delay.h>
+#include <linux/clk.h>
 
 #include <asm/div64.h>
 
-#define VT8500_NR_PWMS 4
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+
+/*
+ * SoC architecture allocates register space for 4 PWMs but only
+ * 2 are currently implemented.
+ */
+#define VT8500_NR_PWMS	2
 
 struct vt8500_chip {
 	struct pwm_chip chip;
 	void __iomem *base;
+	struct clk *clk;
 };
 
 #define to_vt8500_chip(chip)	container_of(chip, struct vt8500_chip, chip)
@@ -52,7 +63,7 @@ static int vt8500_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long long c;
 	unsigned long period_cycles, prescale, pv, dc;
 
-	c = 25000000/2; /* wild guess --- need to implement clocks */
+	c = clk_get_rate(vt8500->clk);
 	c = c * period_ns;
 	do_div(c, 1000000000);
 	period_cycles = c;
@@ -107,12 +118,22 @@ static struct pwm_ops vt8500_pwm_ops = {
 	.owner = THIS_MODULE,
 };
 
-static int __devinit pwm_probe(struct platform_device *pdev)
+static const struct of_device_id vt8500_pwm_dt_ids[] = {
+	{ .compatible = "via,vt8500-pwm", },
+	{ /* Sentinel */ }
+};
+
+static int __devinit vt8500_pwm_probe(struct platform_device *pdev)
 {
 	struct vt8500_chip *chip;
-	struct resource *r;
+	struct device_node *np = pdev->dev.of_node;
 	int ret;
 
+	if (!np) {
+		dev_err(&pdev->dev, "invalid devicetree node\n");
+		return -EINVAL;
+	}
+
 	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
 	if (chip == NULL) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
@@ -123,26 +144,32 @@ static int __devinit pwm_probe(struct platform_device *pdev)
 	chip->chip.ops = &vt8500_pwm_ops;
 	chip->chip.base = -1;
 	chip->chip.npwm = VT8500_NR_PWMS;
+	chip->clk = of_clk_get(np, 0);
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (r == NULL) {
-		dev_err(&pdev->dev, "no memory resource defined\n");
-		return -ENODEV;
+	if (!chip->clk) {
+		dev_err(&pdev->dev, "clock source not specified\n");
+		return -EINVAL;
 	}
 
-	chip->base = devm_request_and_ioremap(&pdev->dev, r);
-	if (chip->base == NULL)
+	chip->base = of_iomap(np, 0);
+	if (!chip->base) {
+		dev_err(&pdev->dev, "memory resource not available\n");
 		return -EADDRNOTAVAIL;
+	}
+
+	clk_prepare_enable(chip->clk);
 
 	ret = pwmchip_add(&chip->chip);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to add pwmchip\n");
 		return ret;
+	}
 
 	platform_set_drvdata(pdev, chip);
 	return ret;
 }
 
-static int __devexit pwm_remove(struct platform_device *pdev)
+static int __devexit vt8500_pwm_remove(struct platform_device *pdev)
 {
 	struct vt8500_chip *chip;
 
@@ -150,28 +177,24 @@ static int __devexit pwm_remove(struct platform_device *pdev)
 	if (chip == NULL)
 		return -ENODEV;
 
+	clk_disable_unprepare(chip->clk);
+
 	return pwmchip_remove(&chip->chip);
 }
 
-static struct platform_driver pwm_driver = {
+static struct platform_driver vt8500_pwm_driver = {
+	.probe		= vt8500_pwm_probe,
+	.remove		= __devexit_p(vt8500_pwm_remove),
 	.driver		= {
 		.name	= "vt8500-pwm",
 		.owner	= THIS_MODULE,
+		.of_match_table = vt8500_pwm_dt_ids,
 	},
-	.probe		= pwm_probe,
-	.remove		= __devexit_p(pwm_remove),
 };
 
-static int __init pwm_init(void)
-{
-	return platform_driver_register(&pwm_driver);
-}
-arch_initcall(pwm_init);
-
-static void __exit pwm_exit(void)
-{
-	platform_driver_unregister(&pwm_driver);
-}
-module_exit(pwm_exit);
+module_platform_driver(vt8500_pwm_driver);
 
-MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("VT8500 PWM Driver");
+MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, vt8500_pwm_dt_ids);
-- 
1.7.9.5

