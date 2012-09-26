Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2IZRSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:18:30 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:38673 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756607Ab2IZRS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:29 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH] pinctrl/nomadik: allocate IRQ descriptors dynamically
Date: Wed, 26 Sep 2012 19:18:07 +0200
Message-ID: <1348679887-2135-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This allocates the IRQ descriptors for the Nomadik pin controller
dynamically so that we don't have to rely on some other mechanism
doing it, and moving a step closer to a linear IRQ domain.

Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 3dde653..29921d1 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1185,6 +1185,8 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	struct clk *clk;
 	int secondary_irq;
 	void __iomem *base;
+	int irq_start;
+	int irq_base;
 	int irq;
 	int ret;
 
@@ -1288,9 +1290,22 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 
 	platform_set_drvdata(dev, nmk_chip);
 
+	/*
+	 * Allocate descriptors and IRQ domain using the legacy model, this
+	 * should eventually be replaced with a linear IRQ domain as we get
+	 * independent from the irq numbers with the switch to device tree.
+	 */
+	irq_start = NOMADIK_GPIO_TO_IRQ(pdata->first_gpio);
+	irq_base = irq_alloc_descs(irq_start, 0, NMK_GPIO_PER_CHIP,
+				   numa_node_id());
+	if (IS_ERR_VALUE(irq_base)) {
+		WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
+		     irq_start);
+		irq_base = irq_start;
+	}
 	nmk_chip->domain = irq_domain_add_legacy(np, NMK_GPIO_PER_CHIP,
-						NOMADIK_GPIO_TO_IRQ(pdata->first_gpio),
-						0, &nmk_gpio_irq_simple_ops, nmk_chip);
+				irq_base, 0,
+				&nmk_gpio_irq_simple_ops, nmk_chip);
 	if (!nmk_chip->domain) {
 		dev_err(&dev->dev, "failed to create irqdomain\n");
 		ret = -ENOSYS;
-- 
1.7.11.3

