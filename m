Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3AGOYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:24:04 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:50411 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884Ab3AGOYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:24:01 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] pinctrl/nomadik: simplify GPIO probe
Date: Mon, 7 Jan 2013 15:23:45 +0100
Message-ID: <1357568625-5979-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Instead of jumping to a label later in the probe just return
with an error code whenever probe() fails. Make sure to remove
the gpiochip on irqdomain error now that we're at it.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 52 +++++++++++++--------------------------
 1 file changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 0355786..66cce5f 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1343,8 +1343,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 
 		if (of_property_read_u32(np, "gpio-bank", &dev->id)) {
 			dev_err(&dev->dev, "gpio-bank property not found\n");
-			ret = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 
 		pdata->first_gpio = dev->id * NMK_GPIO_PER_CHIP;
@@ -1352,41 +1351,29 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	}
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENOENT;
-		goto out;
-	}
+	if (!res)
+		return -ENOENT;
 
 	irq = platform_get_irq(dev, 0);
-	if (irq < 0) {
-		ret = irq;
-		goto out;
-	}
+	if (irq < 0)
+		return irq;
 
 	secondary_irq = platform_get_irq(dev, 1);
-	if (secondary_irq >= 0 && !pdata->get_secondary_status) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (secondary_irq >= 0 && !pdata->get_secondary_status)
+		return -EINVAL;
 
 	base = devm_request_and_ioremap(&dev->dev, res);
-	if (!base) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!base)
+		return -ENOMEM;
 
 	clk = devm_clk_get(&dev->dev, NULL);
-	if (IS_ERR(clk)) {
-		ret = PTR_ERR(clk);
-		goto out;
-	}
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
 	clk_prepare(clk);
 
 	nmk_chip = devm_kzalloc(&dev->dev, sizeof(*nmk_chip), GFP_KERNEL);
-	if (!nmk_chip) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!nmk_chip)
+		return -ENOMEM;
 
 	/*
 	 * The virt address in nmk_chip->addr is in the nomadik register space,
@@ -1420,7 +1407,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 
 	ret = gpiochip_add(&nmk_chip->chip);
 	if (ret)
-		goto out;
+		return ret;
 
 	BUG_ON(nmk_chip->bank >= ARRAY_SIZE(nmk_gpio_chips));
 
@@ -1435,8 +1422,9 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 				&nmk_gpio_irq_simple_ops, nmk_chip);
 	if (!nmk_chip->domain) {
 		dev_err(&dev->dev, "failed to create irqdomain\n");
-		ret = -ENOSYS;
-		goto out;
+		/* Just do this, no matter if it fails */
+		ret = gpiochip_remove(&nmk_chip->chip);
+		return -ENOSYS;
 	}
 
 	nmk_gpio_init_irq(nmk_chip);
@@ -1444,12 +1432,6 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	dev_info(&dev->dev, "at address %p\n", nmk_chip->addr);
 
 	return 0;
-
-out:
-	dev_err(&dev->dev, "Failure %i for GPIO %i-%i\n", ret,
-		  pdata->first_gpio, pdata->first_gpio+31);
-
-	return ret;
 }
 
 static int nmk_get_groups_cnt(struct pinctrl_dev *pctldev)
-- 
1.7.11.3

