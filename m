Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab2JPTdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:33:12 -0400
Received: from mail.df.lth.se ([194.47.250.12]:44920 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958Ab2JPTdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:33:08 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 4/7] gpio/mxs: convert to use linear irqdomain
Date: Tue, 16 Oct 2012 21:22:56 +0200
Message-Id: <1350415376-3217-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MXS driver tries to do the work of irq_domain_add_linear()
by reserving a bunch of descriptors somewhere and keeping track
of the base offset, then calling irq_domain_add_legacy(). Let's
stop doing that and simply use the linear IRQ domain.

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-mxs.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
index 796fb13..71fd5b1 100644
--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -223,7 +223,6 @@ static int __devinit mxs_gpio_probe(struct platform_device *pdev)
 	static void __iomem *base;
 	struct mxs_gpio_port *port;
 	struct resource *iores = NULL;
-	int irq_base;
 	int err;
 
 	port = devm_kzalloc(&pdev->dev, sizeof(*port), GFP_KERNEL);
@@ -272,16 +271,10 @@ static int __devinit mxs_gpio_probe(struct platform_device *pdev)
 	/* clear address has to be used to clear IRQSTAT bits */
 	writel(~0U, port->base + PINCTRL_IRQSTAT(port) + MXS_CLR);
 
-	irq_base = irq_alloc_descs(-1, 0, 32, numa_node_id());
-	if (irq_base < 0)
-		return irq_base;
-
-	port->domain = irq_domain_add_legacy(np, 32, irq_base, 0,
+	port->domain = irq_domain_add_linear(np, 32,
 					     &irq_domain_simple_ops, NULL);
-	if (!port->domain) {
-		err = -ENODEV;
-		goto out_irqdesc_free;
-	}
+	if (!port->domain)
+		return -ENODEV;
 
 	/* gpio-mxs can be a generic irq chip */
 	mxs_gpio_init_gc(port, irq_base);
@@ -295,7 +288,7 @@ static int __devinit mxs_gpio_probe(struct platform_device *pdev)
 			 port->base + PINCTRL_DOUT(port), NULL,
 			 port->base + PINCTRL_DOE(port), NULL, 0);
 	if (err)
-		goto out_irqdesc_free;
+		goto out_irqdomain_remove;
 
 	port->bgc.gc.to_irq = mxs_gpio_to_irq;
 	port->bgc.gc.base = port->id * 32;
@@ -308,8 +301,8 @@ static int __devinit mxs_gpio_probe(struct platform_device *pdev)
 
 out_bgpio_remove:
 	bgpio_remove(&port->bgc);
-out_irqdesc_free:
-	irq_free_descs(irq_base, 32);
+out_irqdomain_remove:
+	irq_domain_remove(port->domain);
 	return err;
 }
 
-- 
1.7.11.7

