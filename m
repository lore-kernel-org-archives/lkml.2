Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab2JSKyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:54:03 -0400
Received: from mail.df.lth.se ([194.47.250.12]:21805 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab2JSKyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:54:00 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <damm@opensource.se>
Subject: [PATCH 2/4 v2] gpio/em: convert to linear IRQ domain
Date: Fri, 19 Oct 2012 12:53:56 +0200
Message-Id: <1350644036-31656-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in the em driver seems to want to try to do the job of
the linear IRQ domain (allocate descriptors and grab a virtual
range). So why not just use the linear IRQ domain? The code is
now cut down so we don't need isolated functions for this.

Also note that we use irq_create_mapping() to make sure
descriptors are allocated for these IRQs.

Also fixed the FIXME to remove the domain after use.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Magnus Damm <damm@opensource.se>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Use irq_create_mapping() so that descriptors get allocated at
  runtime for the linear domain.
- factor the irqdomain stuff into the probe() function.
---
 drivers/gpio/gpio-em.c | 48 ++++++++----------------------------------------
 1 file changed, 8 insertions(+), 40 deletions(-)

diff --git a/drivers/gpio/gpio-em.c b/drivers/gpio/gpio-em.c
index efb4c2d..f6d74e1 100644
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
@@ -163,7 +162,7 @@ static irqreturn_t em_gio_irq_handler(int irq, void *dev_id)
 	while ((pending = em_gio_read(p, GIO_MST))) {
 		offset = __ffs(pending);
 		em_gio_write(p, GIO_IIR, BIT(offset));
-		generic_handle_irq(irq_find_mapping(p->irq_domain, offset));
+		generic_handle_irq(irq_create_mapping(p->irq_domain, offset));
 		irqs_handled++;
 	}
 
@@ -214,7 +213,7 @@ static int em_gio_direction_output(struct gpio_chip *chip, unsigned offset,
 
 static int em_gio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	return irq_find_mapping(gpio_to_priv(chip)->irq_domain, offset);
+	return irq_create_mapping(gpio_to_priv(chip)->irq_domain, offset);
 }
 
 static int em_gio_irq_domain_map(struct irq_domain *h, unsigned int virq,
@@ -234,40 +233,6 @@ static struct irq_domain_ops em_gio_irq_domain_ops = {
 	.map	= em_gio_irq_domain_map,
 };
 
-static int __devinit em_gio_irq_domain_init(struct em_gio_priv *p)
-{
-	struct platform_device *pdev = p->pdev;
-	struct gpio_em_config *pdata = pdev->dev.platform_data;
-
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
-					      pdata->number_of_pins,
-					      p->irq_base, 0,
-					      &em_gio_irq_domain_ops, p);
-	if (!p->irq_domain) {
-		irq_free_descs(p->irq_base, pdata->number_of_pins);
-		return -ENXIO;
-	}
-
-	return 0;
-}
-
-static void em_gio_irq_domain_cleanup(struct em_gio_priv *p)
-{
-	struct gpio_em_config *pdata = p->pdev->dev.platform_data;
-
-	irq_free_descs(p->irq_base, pdata->number_of_pins);
-	/* FIXME: irq domain wants to be freed! */
-}
-
 static int __devinit em_gio_probe(struct platform_device *pdev)
 {
 	struct gpio_em_config *pdata = pdev->dev.platform_data;
@@ -334,8 +299,11 @@ static int __devinit em_gio_probe(struct platform_device *pdev)
 	irq_chip->irq_set_type = em_gio_irq_set_type;
 	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE;
 
-	ret = em_gio_irq_domain_init(p);
-	if (ret) {
+	p->irq_domain = irq_domain_add_linear(pdev->dev.of_node,
+					      pdata->number_of_pins,
+					      &em_gio_irq_domain_ops, p);
+	if (!p->irq_domain)
+		err = -ENXIO;
 		dev_err(&pdev->dev, "cannot initialize irq domain\n");
 		goto err3;
 	}
@@ -364,7 +332,7 @@ err6:
 err5:
 	free_irq(irq[0]->start, pdev);
 err4:
-	em_gio_irq_domain_cleanup(p);
+	irq_domain_remove(p->irq_domain);
 err3:
 	iounmap(p->base1);
 err2:
-- 
1.7.11.7

