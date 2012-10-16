Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2JPT2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:28:10 -0400
Received: from mail.df.lth.se ([194.47.250.12]:44876 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919Ab2JPT2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:28:07 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <damm@opensource.se>
Subject: [PATCH 2/7] gpio/em: convert to linear IRQ domain
Date: Tue, 16 Oct 2012 21:22:20 +0200
Message-Id: <1350415340-2825-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in the em driver seems to want to try to do the job of
the linear IRQ domain (allocate descriptors and grab a virtual
range). So why not just use the linear IRQ domain?

Also fixed the FIXME to remove the domain after use.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Magnus Damm <damm@opensource.se>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-em.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/gpio/gpio-em.c b/drivers/gpio/gpio-em.c
index efb4c2d..aac5c75 100644
--- a/drivers/gpio/gpio-em.c
+++ b/drivers/gpio/gpio-em.c
@@ -35,7 +35,6 @@
 struct em_gio_priv {
 	void __iomem *base0;
 	void __iomem *base1;
-	unsigned int irq_base;
 	spinlock_t sense_lock;
 	struct platform_device *pdev;
 	struct gpio_chip gpio_chip;
@@ -239,33 +238,18 @@ static int __devinit em_gio_irq_domain_init(struct em_gio_priv *p)
 	struct platform_device *pdev = p->pdev;
 	struct gpio_em_config *pdata = pdev->dev.platform_data;
 
-	p->irq_base = irq_alloc_descs(pdata->irq_base, 0,
-				      pdata->number_of_pins, numa_node_id());
-	if (p->irq_base < 0) {
-		dev_err(&pdev->dev, "cannot get irq_desc\n");
-		return p->irq_base;
-	}
-	pr_debug("gio: hw base = %d, nr = %d, sw base = %d\n",
-		 pdata->gpio_base, pdata->number_of_pins, p->irq_base);
-
-	p->irq_domain = irq_domain_add_legacy(pdev->dev.of_node,
+	p->irq_domain = irq_domain_add_linear(pdev->dev.of_node,
 					      pdata->number_of_pins,
-					      p->irq_base, 0,
 					      &em_gio_irq_domain_ops, p);
-	if (!p->irq_domain) {
-		irq_free_descs(p->irq_base, pdata->number_of_pins);
+	if (!p->irq_domain)
 		return -ENXIO;
-	}
 
 	return 0;
 }
 
 static void em_gio_irq_domain_cleanup(struct em_gio_priv *p)
 {
-	struct gpio_em_config *pdata = p->pdev->dev.platform_data;
-
-	irq_free_descs(p->irq_base, pdata->number_of_pins);
-	/* FIXME: irq domain wants to be freed! */
+	irq_domain_remove(p->irq_domain);
 }
 
 static int __devinit em_gio_probe(struct platform_device *pdev)
-- 
1.7.11.7

