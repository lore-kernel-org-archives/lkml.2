Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935560Ab1ETJoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:44:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63379 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935549Ab1ETJoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:44:38 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 2/4] gpio: gpio-mxs: drop mach-specific accessors
Date: Fri, 20 May 2011 17:51:27 +0800
Message-Id: <1305885089-27343-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305885089-27343-1-git-send-email-shawn.guo@linaro.org>
References: <1305885089-27343-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use readl/writel to replace __raw_readl/__raw_writel.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/gpio/gpio-mxs.c |   42 ++++++++++++++++++++++++------------------
 1 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
index 2c950fe..260d7ed 100644
--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -34,6 +34,9 @@
 static struct mxs_gpio_port *mxs_gpio_ports;
 static int gpio_table_size;
 
+#define MXS_SET		0x4
+#define MXS_CLR		0x8
+
 #define PINCTRL_DOUT(n)		((cpu_is_mx23() ? 0x0500 : 0x0700) + (n) * 0x10)
 #define PINCTRL_DIN(n)		((cpu_is_mx23() ? 0x0600 : 0x0900) + (n) * 0x10)
 #define PINCTRL_DOE(n)		((cpu_is_mx23() ? 0x0700 : 0x0b00) + (n) * 0x10)
@@ -54,17 +57,20 @@ static int gpio_table_size;
 
 static void clear_gpio_irqstatus(struct mxs_gpio_port *port, u32 index)
 {
-	__mxs_clrl(1 << index, port->base + PINCTRL_IRQSTAT(port->id));
+	writel(1 << index, port->base + PINCTRL_IRQSTAT(port->id) + MXS_CLR);
 }
 
 static void set_gpio_irqenable(struct mxs_gpio_port *port, u32 index,
 				int enable)
 {
 	if (enable) {
-		__mxs_setl(1 << index, port->base + PINCTRL_IRQEN(port->id));
-		__mxs_setl(1 << index, port->base + PINCTRL_PIN2IRQ(port->id));
+		writel(1 << index,
+			port->base + PINCTRL_IRQEN(port->id) + MXS_SET);
+		writel(1 << index,
+			port->base + PINCTRL_PIN2IRQ(port->id) + MXS_SET);
 	} else {
-		__mxs_clrl(1 << index, port->base + PINCTRL_IRQEN(port->id));
+		writel(1 << index,
+			port->base + PINCTRL_IRQEN(port->id) + MXS_CLR);
 	}
 }
 
@@ -116,16 +122,16 @@ static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
 	/* set level or edge */
 	pin_addr = port->base + PINCTRL_IRQLEV(port->id);
 	if (edge & GPIO_INT_LEV_MASK)
-		__mxs_setl(pin_mask, pin_addr);
+		writel(pin_mask, pin_addr + MXS_SET);
 	else
-		__mxs_clrl(pin_mask, pin_addr);
+		writel(pin_mask, pin_addr + MXS_CLR);
 
 	/* set polarity */
 	pin_addr = port->base + PINCTRL_IRQPOL(port->id);
 	if (edge & GPIO_INT_POL_MASK)
-		__mxs_setl(pin_mask, pin_addr);
+		writel(pin_mask, pin_addr + MXS_SET);
 	else
-		__mxs_clrl(pin_mask, pin_addr);
+		writel(pin_mask, pin_addr + MXS_CLR);
 
 	clear_gpio_irqstatus(port, gpio & 0x1f);
 
@@ -141,8 +147,8 @@ static void mxs_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
 
-	irq_stat = __raw_readl(port->base + PINCTRL_IRQSTAT(port->id)) &
-			__raw_readl(port->base + PINCTRL_IRQEN(port->id));
+	irq_stat = readl(port->base + PINCTRL_IRQSTAT(port->id)) &
+			readl(port->base + PINCTRL_IRQEN(port->id));
 
 	while (irq_stat != 0) {
 		int irqoffset = fls(irq_stat) - 1;
@@ -198,9 +204,9 @@ static void mxs_set_gpio_direction(struct gpio_chip *chip, unsigned offset,
 	void __iomem *pin_addr = port->base + PINCTRL_DOE(port->id);
 
 	if (dir)
-		__mxs_setl(1 << offset, pin_addr);
+		writel(1 << offset, pin_addr + MXS_SET);
 	else
-		__mxs_clrl(1 << offset, pin_addr);
+		writel(1 << offset, pin_addr + MXS_CLR);
 }
 
 static int mxs_gpio_get(struct gpio_chip *chip, unsigned offset)
@@ -208,7 +214,7 @@ static int mxs_gpio_get(struct gpio_chip *chip, unsigned offset)
 	struct mxs_gpio_port *port =
 		container_of(chip, struct mxs_gpio_port, chip);
 
-	return (__raw_readl(port->base + PINCTRL_DIN(port->id)) >> offset) & 1;
+	return (readl(port->base + PINCTRL_DIN(port->id)) >> offset) & 1;
 }
 
 static void mxs_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
@@ -218,9 +224,9 @@ static void mxs_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	void __iomem *pin_addr = port->base + PINCTRL_DOUT(port->id);
 
 	if (value)
-		__mxs_setl(1 << offset, pin_addr);
+		writel(1 << offset, pin_addr + MXS_SET);
 	else
-		__mxs_clrl(1 << offset, pin_addr);
+		writel(1 << offset, pin_addr + MXS_CLR);
 }
 
 static int mxs_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
@@ -257,11 +263,11 @@ int __init mxs_gpio_init(struct mxs_gpio_port *port, int cnt)
 
 	for (i = 0; i < cnt; i++) {
 		/* disable the interrupt and clear the status */
-		__raw_writel(0, port[i].base + PINCTRL_PIN2IRQ(i));
-		__raw_writel(0, port[i].base + PINCTRL_IRQEN(i));
+		writel(0, port[i].base + PINCTRL_PIN2IRQ(i));
+		writel(0, port[i].base + PINCTRL_IRQEN(i));
 
 		/* clear address has to be used to clear IRQSTAT bits */
-		__mxs_clrl(~0U, port[i].base + PINCTRL_IRQSTAT(i));
+		writel(~0U, port[i].base + PINCTRL_IRQSTAT(i) + MXS_CLR);
 
 		for (j = port[i].virtual_irq_start;
 			j < port[i].virtual_irq_start + 32; j++) {
-- 
1.7.4.1

