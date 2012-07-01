Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab2GAFA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 01:00:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63134 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab2GAFA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 01:00:56 -0400
Message-ID: <1341118851.8998.4.camel@phoenix>
Subject: [PATCH] pwm: Convert pwm-tegra to use devm_clk_get()
From: Axel Lin <axel.lin@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Date: Sun, 01 Jul 2012 13:00:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also return proper error in tegra_pwm_remove() if pwmchip_remove() fails.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/pwm/pwm-tegra.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index 472b74e..02ce18d 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -194,7 +194,7 @@ static int tegra_pwm_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pwm);
 
-	pwm->clk = clk_get(&pdev->dev, NULL);
+	pwm->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pwm->clk))
 		return PTR_ERR(pwm->clk);
 
@@ -206,7 +206,6 @@ static int tegra_pwm_probe(struct platform_device *pdev)
 	ret = pwmchip_add(&pwm->chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
-		clk_put(pwm->clk);
 		return ret;
 	}
 
@@ -233,10 +232,7 @@ static int __devexit tegra_pwm_remove(struct platform_device *pdev)
 		clk_disable_unprepare(pc->clk);
 	}
 
-	pwmchip_remove(&pc->chip);
-	clk_put(pc->clk);
-
-	return 0;
+	return pwmchip_remove(&pc->chip);
 }
 
 #ifdef CONFIG_OF
-- 
1.7.9.5



