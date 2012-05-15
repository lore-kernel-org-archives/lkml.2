Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab2EOPvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:51:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36392 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab2EOPvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:51:50 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rjw@sisk.pl, linus.walleij@stericsson.com, arnd@arndb.de,
        linux-sh@vger.kernel.org, horms@verge.net.au,
        grant.likely@secretlab.ca, lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 16 May 2012 00:52:49 +0900
Message-Id: <20120515155249.6690.62293.sendpatchset@w520>
Subject: [PATCH/RFC] gpio: Emma Mobile GPIO DT prototype
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Here is my first attempt on EMEV2 GPIO DT support.

More or less only dry coded at this point - only tested
with platform devices using pdata->irq_base = 0.

The IRQ bits seem quite fine to me, but perhaps some
people will dislike the idea of runtime selection if
linear or legacy irq domain should be used. The reason
for both is that the linear irq domain is used in the
case when we want to have a static preallocated range
of IRQs configurable via platform data, and the linear
range is used for DT together with the ->xlate feature.

I am yet to try to tie in the actual GPIO pins using DT.
So please consider this as an early preview of DT support.

Pointers in any direction would be greatly appreciated.

Not-yet-signed-off-by: Magnus Damm <damm@opensource.se>
---

 Applies on top of:
 "[PATCH] gpio: Emma Mobile GPIO driver V2"

 drivers/gpio/gpio-em.c |   44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

--- 0011/drivers/gpio/gpio-em.c
+++ work/drivers/gpio/gpio-em.c	2012-05-16 00:24:30.000000000 +0900
@@ -41,6 +41,11 @@ struct em_gio_priv {
 	struct gpio_chip gpio_chip;
 	struct irq_chip irq_chip;
 	struct irq_domain *irq_domain;
+
+	unsigned int (*hook_irq)(struct irq_domain *domain,
+				 irq_hw_number_t hwirq);
+	unsigned int (*demux_irq)(struct irq_domain *domain,
+				  irq_hw_number_t hwirq);
 };
 
 #define GIO_E1 0x00
@@ -169,7 +174,7 @@ static irqreturn_t em_gio_irq_handler(in
 	while ((pending = em_gio_read(p, GIO_MST))) {
 		offset = __ffs(pending);
 		em_gio_write(p, GIO_IIR, BIT(offset));
-		generic_handle_irq(irq_find_mapping(p->irq_domain, offset));
+		generic_handle_irq(p->demux_irq(p->irq_domain, offset));
 		irqs_handled++;
 	}
 
@@ -220,7 +225,9 @@ static int em_gio_direction_output(struc
 
 static int em_gio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	return irq_find_mapping(gpio_to_priv(chip)->irq_domain, offset);
+	struct em_gio_priv *p = gpio_to_priv(chip);
+
+	return p->hook_irq(p->irq_domain, offset);
 }
 
 static int em_gio_irq_domain_map(struct irq_domain *h, unsigned int virq,
@@ -238,9 +245,10 @@ static int em_gio_irq_domain_map(struct
 
 static struct irq_domain_ops em_gio_irq_domain_ops = {
 	.map	= em_gio_irq_domain_map,
+	.xlate	= irq_domain_xlate_twocell,
 };
 
-static int __devinit em_gio_irq_domain_init(struct em_gio_priv *p)
+static int __devinit em_gio_irq_domain_init_legacy(struct em_gio_priv *p)
 {
 	struct platform_device *pdev = p->pdev;
 	struct gpio_em_config *pdata = pdev->dev.platform_data;
@@ -263,6 +271,27 @@ static int __devinit em_gio_irq_domain_i
 		return -ENXIO;
 	}
 
+	p->hook_irq = irq_find_mapping;
+	p->demux_irq = irq_find_mapping;
+	return 0;
+}
+
+static int __devinit em_gio_irq_domain_init_linear(struct em_gio_priv *p)
+{
+	struct platform_device *pdev = p->pdev;
+	struct gpio_em_config *pdata = pdev->dev.platform_data;
+
+	pr_debug("gio: hw base = %d, nr = %d, sw base = dynamic\n",
+		 pdata->gpio_base, pdata->number_of_pins);
+
+	p->irq_domain = irq_domain_add_linear(pdev->dev.of_node,
+					      pdata->number_of_pins,
+					      &em_gio_irq_domain_ops, p);
+	if (!p->irq_domain)
+		return -ENXIO;
+
+	p->hook_irq = irq_create_mapping;
+	p->demux_irq = irq_linear_revmap;
 	return 0;
 }
 
@@ -270,7 +299,8 @@ static void __devexit em_gio_irq_domain_
 {
 	struct gpio_em_config *pdata = p->pdev->dev.platform_data;
 
-	irq_free_descs(p->irq_base, pdata->number_of_pins);
+	if (p->irq_base)
+		irq_free_descs(p->irq_base, pdata->number_of_pins);
 	/* FIXME: irq domain wants to be freed! */
 }
 
@@ -340,7 +370,11 @@ static int __devinit em_gio_probe(struct
 	irq_chip->irq_set_type = em_gio_irq_set_type;
 	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE;
 
-	ret = em_gio_irq_domain_init(p);
+	if (pdata->irq_base)
+		ret = em_gio_irq_domain_init_legacy(p); /* static */
+	else
+		ret = em_gio_irq_domain_init_linear(p); /* dynamic */
+
 	if (ret) {
 		dev_err(&pdev->dev, "cannot initialize irq domain\n");
 		goto err3;
