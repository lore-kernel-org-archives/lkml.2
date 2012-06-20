Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2FTImc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:42:32 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:44159 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753638Ab2FTIma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:42:30 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pankaj Jangra <jangra.pankaj9@gmail.com>
Subject: [PATCH v2] pinctrl/coh901: use clk_prepare_[en|dis]able()
Date: Wed, 20 Jun 2012 10:42:12 +0200
Message-ID: <1340181732-21953-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The COH901 GPIO driver did not prepare or unprepare its
clock, so let us fix it to do so.

Cc: Pankaj Jangra <jangra.pankaj9@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Fix up to use clk_disable_unprepare() on error and exit paths,
  noticed by Pankaj Jangra.
---
 drivers/pinctrl/pinctrl-coh901.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index 55697a5..cc0f00d 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -770,7 +770,7 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 		dev_err(gpio->dev, "could not get GPIO clock\n");
 		goto err_no_clk;
 	}
-	err = clk_enable(gpio->clk);
+	err = clk_prepare_enable(gpio->clk);
 	if (err) {
 		dev_err(gpio->dev, "could not enable GPIO clock\n");
 		goto err_no_clk_enable;
@@ -912,7 +912,7 @@ err_no_ioremap:
 	release_mem_region(gpio->memres->start, resource_size(gpio->memres));
 err_no_ioregion:
 err_no_resource:
-	clk_disable(gpio->clk);
+	clk_disable_unprepare(gpio->clk);
 err_no_clk_enable:
 	clk_put(gpio->clk);
 err_no_clk:
@@ -943,7 +943,7 @@ static int __exit u300_gpio_remove(struct platform_device *pdev)
 	iounmap(gpio->base);
 	release_mem_region(gpio->memres->start,
 			   resource_size(gpio->memres));
-	clk_disable(gpio->clk);
+	clk_disable_unprepare(gpio->clk);
 	clk_put(gpio->clk);
 	platform_set_drvdata(pdev, NULL);
 	kfree(gpio);
-- 
1.7.9.2

