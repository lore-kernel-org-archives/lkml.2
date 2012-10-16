Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2JPTdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:33:09 -0400
Received: from mail.df.lth.se ([194.47.250.12]:44917 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925Ab2JPTdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:33:08 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 3/7] gpio/mvebu: convert to use irq_domain_add_simple()
Date: Tue, 16 Oct 2012 21:22:27 +0200
Message-Id: <1350415347-2857-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MVEBU driver probably just wants a few IRQs. Using the simple
domain has the upside of allocating IRQ descriptors if need be,
especially in a SPARSE_IRQ environment.

Also replace one instance of irq_create_mapping() with
irq_find_mapping(), the domain is registered in probe() so
the irq is sure there to be found, no reason to ask for
on-the-fly remappings here.

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-mvebu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 902af43..8fdeed2 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -257,7 +257,7 @@ static int mvebu_gpio_to_irq(struct gpio_chip *chip, unsigned pin)
 {
 	struct mvebu_gpio_chip *mvchip =
 		container_of(chip, struct mvebu_gpio_chip, chip);
-	return irq_create_mapping(mvchip->domain, pin);
+	return irq_find_mapping(mvchip->domain, pin);
 }
 
 /*
@@ -645,8 +645,8 @@ static int __devinit mvebu_gpio_probe(struct platform_device *pdev)
 			       IRQ_NOREQUEST, IRQ_LEVEL | IRQ_NOPROBE);
 
 	/* Setup irq domain on top of the generic chip. */
-	mvchip->domain = irq_domain_add_legacy(np, mvchip->chip.ngpio,
-					       mvchip->irqbase, 0,
+	mvchip->domain = irq_domain_add_simple(np, mvchip->chip.ngpio,
+					       mvchip->irqbase,
 					       &irq_domain_simple_ops,
 					       mvchip);
 	if (!mvchip->domain) {
-- 
1.7.11.7

