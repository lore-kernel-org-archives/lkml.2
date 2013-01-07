Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3AGQr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:47:59 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:60459 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab3AGQr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:47:57 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] usb: musb: ux500: use clk_prepare_enable and clk_disable_unprepare
Date: Mon,  7 Jan 2013 17:47:41 +0100
Message-Id: <1357577261-31536-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the module to use clk_prepare_enable and
clk_disable_unprepare variants as required by common clock framework.

Without this the system crash during probe function.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/musb/ux500.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index a27ca1a..0804661 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -108,7 +108,7 @@ static int ux500_probe(struct platform_device *pdev)
 		goto err3;
 	}
 
-	ret = clk_enable(clk);
+	ret = clk_prepare_enable(clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
 		goto err4;
@@ -148,7 +148,7 @@ static int ux500_probe(struct platform_device *pdev)
 	return 0;
 
 err5:
-	clk_disable(clk);
+	clk_disable_unprepare(clk);
 
 err4:
 	clk_put(clk);
@@ -168,7 +168,7 @@ static int ux500_remove(struct platform_device *pdev)
 	struct ux500_glue	*glue = platform_get_drvdata(pdev);
 
 	platform_device_unregister(glue->musb);
-	clk_disable(glue->clk);
+	clk_disable_unprepare(glue->clk);
 	clk_put(glue->clk);
 	kfree(glue);
 
@@ -182,7 +182,7 @@ static int ux500_suspend(struct device *dev)
 	struct musb		*musb = glue_to_musb(glue);
 
 	usb_phy_set_suspend(musb->xceiv, 1);
-	clk_disable(glue->clk);
+	clk_disable_unprepare(glue->clk);
 
 	return 0;
 }
@@ -193,7 +193,7 @@ static int ux500_resume(struct device *dev)
 	struct musb		*musb = glue_to_musb(glue);
 	int			ret;
 
-	ret = clk_enable(glue->clk);
+	ret = clk_prepare_enable(glue->clk);
 	if (ret) {
 		dev_err(dev, "failed to enable clock\n");
 		return ret;
-- 
1.7.12.1

