Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1FMImm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 04:42:42 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:39812 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459Ab1FMIml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 04:42:41 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Eric Miao <eric.miao@linaro.org>
Subject: [PATCH] gpio/plat-pxa: fix clash with gpiolib namespace
Date: Mon, 13 Jun 2011 10:42:19 +0200
Message-ID: <1307954539-5681-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The PXA platform code has a static inline helper called
gpio_to_chip which clashes with the gpiolib namespace if we
try to expose the function with the same name from gpiolib,
and it's still confusing even if we don't do that. So rename
it to gpio_to_pxachip().

Reported-by: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Eric Miao <eric.miao@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/plat-pxa/gpio.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/plat-pxa/gpio.c b/arch/arm/plat-pxa/gpio.c
index 48ebb94..a11dc36 100644
--- a/arch/arm/plat-pxa/gpio.c
+++ b/arch/arm/plat-pxa/gpio.c
@@ -50,7 +50,7 @@ static inline void __iomem *gpio_chip_base(struct gpio_chip *c)
 	return container_of(c, struct pxa_gpio_chip, chip)->regbase;
 }
 
-static inline struct pxa_gpio_chip *gpio_to_chip(unsigned gpio)
+static inline struct pxa_gpio_chip *gpio_to_pxachip(unsigned gpio)
 {
 	return &pxa_gpio_chips[gpio_to_bank(gpio)];
 }
@@ -161,7 +161,7 @@ static int pxa_gpio_irq_type(struct irq_data *d, unsigned int type)
 	int gpio = irq_to_gpio(d->irq);
 	unsigned long gpdr, mask = GPIO_bit(gpio);
 
-	c = gpio_to_chip(gpio);
+	c = gpio_to_pxachip(gpio);
 
 	if (type == IRQ_TYPE_PROBE) {
 		/* Don't mess with enabled GPIOs using preconfigured edges or
@@ -230,7 +230,7 @@ static void pxa_gpio_demux_handler(unsigned int irq, struct irq_desc *desc)
 static void pxa_ack_muxed_gpio(struct irq_data *d)
 {
 	int gpio = irq_to_gpio(d->irq);
-	struct pxa_gpio_chip *c = gpio_to_chip(gpio);
+	struct pxa_gpio_chip *c = gpio_to_pxachip(gpio);
 
 	__raw_writel(GPIO_bit(gpio), c->regbase + GEDR_OFFSET);
 }
@@ -238,7 +238,7 @@ static void pxa_ack_muxed_gpio(struct irq_data *d)
 static void pxa_mask_muxed_gpio(struct irq_data *d)
 {
 	int gpio = irq_to_gpio(d->irq);
-	struct pxa_gpio_chip *c = gpio_to_chip(gpio);
+	struct pxa_gpio_chip *c = gpio_to_pxachip(gpio);
 	uint32_t grer, gfer;
 
 	c->irq_mask &= ~GPIO_bit(gpio);
@@ -252,7 +252,7 @@ static void pxa_mask_muxed_gpio(struct irq_data *d)
 static void pxa_unmask_muxed_gpio(struct irq_data *d)
 {
 	int gpio = irq_to_gpio(d->irq);
-	struct pxa_gpio_chip *c = gpio_to_chip(gpio);
+	struct pxa_gpio_chip *c = gpio_to_pxachip(gpio);
 
 	c->irq_mask |= GPIO_bit(gpio);
 	update_edge_detect(c);
-- 
1.7.3.2

