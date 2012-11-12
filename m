Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab2KLGp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 01:45:56 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61946 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2KLGpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 01:45:55 -0500
Message-ID: <1352702750.15066.4.camel@phoenix>
Subject: [PATCH 1/2] pinctrl: pxa3xx: Use devm_request_and_ioremap
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 12 Nov 2012 14:45:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use managed resources API to simplify the code.
Also ensure we do request mem_region before ioremap.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-pxa3xx.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-pxa3xx.c b/drivers/pinctrl/pinctrl-pxa3xx.c
index f14cd6b..43e3dd0 100644
--- a/drivers/pinctrl/pinctrl-pxa3xx.c
+++ b/drivers/pinctrl/pinctrl-pxa3xx.c
@@ -173,7 +173,6 @@ int pxa3xx_pinctrl_register(struct platform_device *pdev,
 {
 	struct pinctrl_desc *desc;
 	struct resource *res;
-	int ret = 0;
 
 	if (!info || !info->cputype)
 		return -EINVAL;
@@ -190,21 +189,17 @@ int pxa3xx_pinctrl_register(struct platform_device *pdev,
 		return -ENOENT;
 	info->phy_base = res->start;
 	info->phy_size = resource_size(res);
-	info->virt_base = ioremap(info->phy_base, info->phy_size);
+	info->virt_base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!info->virt_base)
 		return -ENOMEM;
 	info->pctrl = pinctrl_register(desc, &pdev->dev, info);
 	if (!info->pctrl) {
 		dev_err(&pdev->dev, "failed to register PXA pinmux driver\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 	pinctrl_add_gpio_range(info->pctrl, &pxa3xx_pinctrl_gpio_range);
 	platform_set_drvdata(pdev, info);
 	return 0;
-err:
-	iounmap(info->virt_base);
-	return ret;
 }
 
 int pxa3xx_pinctrl_unregister(struct platform_device *pdev)
@@ -212,7 +207,6 @@ int pxa3xx_pinctrl_unregister(struct platform_device *pdev)
 	struct pxa3xx_pinmux_info *info = platform_get_drvdata(pdev);
 
 	pinctrl_unregister(info->pctrl);
-	iounmap(info->virt_base);
 	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
-- 
1.7.9.5



