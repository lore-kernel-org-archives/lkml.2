Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab2KNJOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:14:20 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36405 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab2KNJOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:14:16 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: linus.walleij@linaro.org
Cc: axel.lin@ingics.com, spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] Pinctrl: SPEAr: Plgpio: Don't call prepare/unprepare on request/free
Date: Wed, 14 Nov 2012 14:44:07 +0530
Message-Id: <2773e9204be54157c49811ed2d98a0de352e9c19.1352884427.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPEAr SoC's don't do anything in clk_prepare() of plgpio driver, so there is no
need to call this routine multiple times. Just call it once at probe.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Hi Linus,

This patch is rebased over https://lkml.org/lkml/2012/11/14/220

 drivers/pinctrl/spear/pinctrl-plgpio.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
index cf6d9c2..5aebbf7 100644
--- a/drivers/pinctrl/spear/pinctrl-plgpio.c
+++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
@@ -213,7 +213,7 @@ static int plgpio_request(struct gpio_chip *chip, unsigned offset)
 		return ret;
 
 	if (!IS_ERR(plgpio->clk)) {
-		ret = clk_prepare_enable(plgpio->clk);
+		ret = clk_enable(plgpio->clk);
 		if (ret)
 			goto err0;
 	}
@@ -244,7 +244,7 @@ static int plgpio_request(struct gpio_chip *chip, unsigned offset)
 
 err1:
 	if (!IS_ERR(plgpio->clk))
-		clk_disable_unprepare(plgpio->clk);
+		clk_disable(plgpio->clk);
 err0:
 	pinctrl_free_gpio(gpio);
 	return ret;
@@ -275,7 +275,7 @@ static void plgpio_free(struct gpio_chip *chip, unsigned offset)
 
 disable_clk:
 	if (!IS_ERR(plgpio->clk))
-		clk_disable_unprepare(plgpio->clk);
+		clk_disable(plgpio->clk);
 
 	pinctrl_free_gpio(gpio);
 }
@@ -584,10 +584,18 @@ static int __devinit plgpio_probe(struct platform_device *pdev)
 	plgpio->chip.dev = &pdev->dev;
 	plgpio->chip.owner = THIS_MODULE;
 
+	if (!IS_ERR(plgpio->clk)) {
+		ret = clk_prepare(plgpio->clk);
+		if (ret) {
+			dev_err(&pdev->dev, "clk prepare failed\n");
+			return ret;
+		}
+	}
+
 	ret = gpiochip_add(&plgpio->chip);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to add gpio chip\n");
-		return ret;
+		goto unprepare_clk;
 	}
 
 	irq = platform_get_irq(pdev, 0);
@@ -629,6 +637,9 @@ remove_gpiochip:
 	dev_info(&pdev->dev, "Remove gpiochip\n");
 	if (gpiochip_remove(&plgpio->chip))
 		dev_err(&pdev->dev, "unable to remove gpiochip\n");
+unprepare_clk:
+	if (!IS_ERR(plgpio->clk))
+		clk_unprepare(plgpio->clk);
 
 	return ret;
 }
-- 
1.7.12.rc2.18.g61b472e

