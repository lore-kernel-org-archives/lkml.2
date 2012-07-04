Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab2GDJGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:06:42 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:42181 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541Ab2GDJGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:06:41 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/nomadik: use devm_* allocators for gpio probe
Date: Wed, 4 Jul 2012 11:05:48 +0200
Message-ID: <1341392748-9904-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO portions of the Nomadik pinctrl driver was not using
the managed devm_* interfaces, lets' use them consequently and
cut down the error path and special case handling.

Acked-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c |   35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 3e7e47d..095bbc6 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1194,7 +1194,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	}
 
 	if (np) {
-		pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+		pdata = devm_kzalloc(&dev->dev, sizeof(*pdata), GFP_KERNEL);
 		if (!pdata)
 			return -ENOMEM;
 
@@ -1229,29 +1229,23 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 		goto out;
 	}
 
-	if (request_mem_region(res->start, resource_size(res),
-			       dev_name(&dev->dev)) == NULL) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	base = ioremap(res->start, resource_size(res));
+	base = devm_request_and_ioremap(&dev->dev, res);
 	if (!base) {
 		ret = -ENOMEM;
-		goto out_release;
+		goto out;
 	}
 
-	clk = clk_get(&dev->dev, NULL);
+	clk = devm_clk_get(&dev->dev, NULL);
 	if (IS_ERR(clk)) {
 		ret = PTR_ERR(clk);
-		goto out_unmap;
+		goto out;
 	}
 	clk_prepare(clk);
 
-	nmk_chip = kzalloc(sizeof(*nmk_chip), GFP_KERNEL);
+	nmk_chip = devm_kzalloc(&dev->dev, sizeof(*nmk_chip), GFP_KERNEL);
 	if (!nmk_chip) {
 		ret = -ENOMEM;
-		goto out_clk;
+		goto out;
 	}
 
 	/*
@@ -1286,7 +1280,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 
 	ret = gpiochip_add(&nmk_chip->chip);
 	if (ret)
-		goto out_free;
+		goto out;
 
 	BUG_ON(nmk_chip->bank >= ARRAY_SIZE(nmk_gpio_chips));
 
@@ -1300,7 +1294,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	if (!nmk_chip->domain) {
 		pr_err("%s: Failed to create irqdomain\n", np->full_name);
 		ret = -ENOSYS;
-		goto out_free;
+		goto out;
 	}
 
 	nmk_gpio_init_irq(nmk_chip);
@@ -1309,20 +1303,9 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 
 	return 0;
 
-out_free:
-	kfree(nmk_chip);
-out_clk:
-	clk_disable(clk);
-	clk_put(clk);
-out_unmap:
-	iounmap(base);
-out_release:
-	release_mem_region(res->start, resource_size(res));
 out:
 	dev_err(&dev->dev, "Failure %i for GPIO %i-%i\n", ret,
 		  pdata->first_gpio, pdata->first_gpio+31);
-	if (np)
-		kfree(pdata);
 
 	return ret;
 }
-- 
1.7.9.2

