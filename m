Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab2I0NO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:14:28 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:48924 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab2I0NO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:14:26 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 3/4] pinctrl/nomadik: use simple or linear IRQ domain
Date: Thu, 27 Sep 2012 15:13:59 +0200
Message-ID: <1348751639-17457-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This alters the Nomadik pinctrl driver to:

- Call irqdomain_add_linear() for the DT case so we get
  all independent from IRQ numbers in this case.
- Call irqdomain_add_simple() for the legacy case, which
  allocates the IRQ descriptors for the Nomadik pin controller
  dynamically.

Cc: Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index e031c84..6aab107 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1286,9 +1286,19 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 
 	platform_set_drvdata(dev, nmk_chip);
 
-	nmk_chip->domain = irq_domain_add_legacy(np, NMK_GPIO_PER_CHIP,
-						NOMADIK_GPIO_TO_IRQ(pdata->first_gpio),
-						0, &nmk_gpio_irq_simple_ops, nmk_chip);
+	if (np) {
+		/* The DT case will just grab a set of IRQ numbers */
+		nmk_chip->domain = irq_domain_add_linear(np, NMK_GPIO_PER_CHIP,
+				&nmk_gpio_irq_simple_ops, nmk_chip);
+	} else {
+		/* Non-DT legacy mode, use hardwired IRQ numbers */
+		int irq_start;
+
+		irq_start = NOMADIK_GPIO_TO_IRQ(pdata->first_gpio);
+		nmk_chip->domain = irq_domain_add_simple(NULL,
+				NMK_GPIO_PER_CHIP, irq_start,
+				&nmk_gpio_irq_simple_ops, nmk_chip);
+	}
 	if (!nmk_chip->domain) {
 		dev_err(&dev->dev, "failed to create irqdomain\n");
 		ret = -ENOSYS;
-- 
1.7.11.3

