Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2JKOhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:37:00 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:39932 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890Ab2JKOg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:36:57 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH] pinctrl/nomadik: always use the simple irqdomain
Date: Thu, 11 Oct 2012 16:36:37 +0200
Message-ID: <1349966197-18777-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Since the simple irqdomain will fall back to a linear domain
if the first_irq provided is <= 0, just use this, just make
sure the first_irq is negative in the device tree case.

Cc: Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 992982c..a4a4247 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1277,6 +1277,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	struct clk *clk;
 	int secondary_irq;
 	void __iomem *base;
+	int irq_start = -1;
 	int irq;
 	int ret;
 
@@ -1380,19 +1381,11 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 
 	platform_set_drvdata(dev, nmk_chip);
 
-	if (np) {
-		/* The DT case will just grab a set of IRQ numbers */
-		nmk_chip->domain = irq_domain_add_linear(np, NMK_GPIO_PER_CHIP,
-				&nmk_gpio_irq_simple_ops, nmk_chip);
-	} else {
-		/* Non-DT legacy mode, use hardwired IRQ numbers */
-		int irq_start;
-
+	if (!np)
 		irq_start = NOMADIK_GPIO_TO_IRQ(pdata->first_gpio);
-		nmk_chip->domain = irq_domain_add_simple(NULL,
+	nmk_chip->domain = irq_domain_add_simple(NULL,
 				NMK_GPIO_PER_CHIP, irq_start,
 				&nmk_gpio_irq_simple_ops, nmk_chip);
-	}
 	if (!nmk_chip->domain) {
 		dev_err(&dev->dev, "failed to create irqdomain\n");
 		ret = -ENOSYS;
-- 
1.7.11.3

