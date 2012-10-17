Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2JQRUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:20:12 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:60200 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757549Ab2JQRUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:20:09 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/3] pinctrl/u300: use managed resources
Date: Wed, 17 Oct 2012 19:19:51 +0200
Message-ID: <1350494391-16093-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This converts the U300 pin controller to use managed resources
(devm_*) for it's memory region.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-u300.c | 32 ++++----------------------------
 1 file changed, 4 insertions(+), 28 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index 309f5b9..2e9825e 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -663,8 +663,6 @@ static const struct pinctrl_pin_desc u300_pads[] = {
 struct u300_pmx {
 	struct device *dev;
 	struct pinctrl_dev *pctl;
-	u32 phybase;
-	u32 physize;
 	void __iomem *virtbase;
 };
 
@@ -1110,7 +1108,6 @@ static int __devinit u300_pmx_probe(struct platform_device *pdev)
 	struct u300_pmx *upmx;
 	struct resource *res;
 	struct gpio_chip *gpio_chip = dev_get_platdata(&pdev->dev);
-	int ret;
 	int i;
 
 	/* Create state holders etc for this driver */
@@ -1123,26 +1120,15 @@ static int __devinit u300_pmx_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENOENT;
-	upmx->phybase = res->start;
-	upmx->physize = resource_size(res);
-
-	if (request_mem_region(upmx->phybase, upmx->physize,
-			       DRIVER_NAME) == NULL) {
-		ret = -ENOMEM;
-		goto out_no_memregion;
-	}
 
-	upmx->virtbase = ioremap(upmx->phybase, upmx->physize);
-	if (!upmx->virtbase) {
-		ret = -ENOMEM;
-		goto out_no_remap;
-	}
+	upmx->virtbase = devm_request_and_ioremap(&pdev->dev, res);
+	if (!upmx->virtbase)
+		return -ENOMEM;
 
 	upmx->pctl = pinctrl_register(&u300_pmx_desc, &pdev->dev, upmx);
 	if (!upmx->pctl) {
 		dev_err(&pdev->dev, "could not register U300 pinmux driver\n");
-		ret = -EINVAL;
-		goto out_no_pmx;
+		return -EINVAL;
 	}
 
 	/* We will handle a range of GPIO pins */
@@ -1156,14 +1142,6 @@ static int __devinit u300_pmx_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "initialized U300 pin control driver\n");
 
 	return 0;
-
-out_no_pmx:
-	iounmap(upmx->virtbase);
-out_no_remap:
-	platform_set_drvdata(pdev, NULL);
-out_no_memregion:
-	release_mem_region(upmx->phybase, upmx->physize);
-	return ret;
 }
 
 static int __devexit u300_pmx_remove(struct platform_device *pdev)
@@ -1171,8 +1149,6 @@ static int __devexit u300_pmx_remove(struct platform_device *pdev)
 	struct u300_pmx *upmx = platform_get_drvdata(pdev);
 
 	pinctrl_unregister(upmx->pctl);
-	iounmap(upmx->virtbase);
-	release_mem_region(upmx->phybase, upmx->physize);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.11.3

