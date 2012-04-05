Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2DEJOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 05:14:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:29567 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab2DEJOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 05:14:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="128953051"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 3/3] gpio: langwell: clear IRQ edge detect registers at init
Date: Thu,  5 Apr 2012 12:15:17 +0300
Message-Id: <1333617317-28437-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333617317-28437-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1333617317-28437-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The boot firmware might leave the registers configured causing interrupts
to happen even when no handler for them is yet registered. Fix this by
clearing the IRQ edge detect registers at init.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpio-langwell.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index bc15ae3..52f00d3 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -263,6 +263,24 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 	chip->irq_eoi(data);
 }
 
+static void lnw_irq_init_hw(struct lnw_gpio *lnw)
+{
+	void __iomem *reg;
+	unsigned base;
+
+	for (base = 0; base < lnw->chip.ngpio; base += 32) {
+		/* Clear the rising-edge detect register */
+		reg = gpio_reg(&lnw->chip, base, GRER);
+		writel(0, reg);
+		/* Clear the falling-edge detect register */
+		reg = gpio_reg(&lnw->chip, base, GFER);
+		writel(0, reg);
+		/* Clear the edge detect status register */
+		reg = gpio_reg(&lnw->chip, base, GEDR);
+		writel(~0, reg);
+	}
+}
+
 #ifdef CONFIG_PM
 static int lnw_gpio_runtime_resume(struct device *dev)
 {
@@ -371,6 +389,9 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "langwell gpiochip_add error %d\n", retval);
 		goto err4;
 	}
+
+	lnw_irq_init_hw(lnw);
+
 	irq_set_handler_data(pdev->irq, lnw);
 	irq_set_chained_handler(pdev->irq, lnw_irq_handler);
 	for (i = 0; i < lnw->chip.ngpio; i++) {
-- 
1.7.9.1

