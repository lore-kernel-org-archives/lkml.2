Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1BHCdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:33:22 -0500
Received: from smtp-out-214.synserver.de ([212.40.185.214]:1120 "HELO
	smtp-out-214.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752779Ab1BHCdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 21:33:21 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 4605
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] MIPS: JZ4740: Convert to new irq functions
Date: Tue,  8 Feb 2011 03:34:17 +0100
Message-Id: <1297132458-16883-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the JZ4740 intc and gpio irq chips to use newstyle irq functions.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/mips/jz4740/gpio.c |   93 ++++++++++++++++++++++++-----------------------
 arch/mips/jz4740/irq.c  |   32 ++++++++++------
 2 files changed, 67 insertions(+), 58 deletions(-)

diff --git a/arch/mips/jz4740/gpio.c b/arch/mips/jz4740/gpio.c
index 88e6aed..1e28b75 100644
--- a/arch/mips/jz4740/gpio.c
+++ b/arch/mips/jz4740/gpio.c
@@ -102,9 +102,9 @@ static inline struct jz_gpio_chip *gpio_chip_to_jz_gpio_chip(struct gpio_chip *g
 	return container_of(gpio_chip, struct jz_gpio_chip, gpio_chip);
 }
 
-static inline struct jz_gpio_chip *irq_to_jz_gpio_chip(unsigned int irq)
+static inline struct jz_gpio_chip *irq_to_jz_gpio_chip(struct irq_data *data)
 {
-	return get_irq_chip_data(irq);
+	return irq_data_get_irq_chip_data(data);
 }
 
 static inline void jz_gpio_write_bit(unsigned int gpio, unsigned int reg)
@@ -325,62 +325,63 @@ static void jz_gpio_irq_demux_handler(unsigned int irq, struct irq_desc *desc)
 	generic_handle_irq(gpio_irq);
 };
 
-static inline void jz_gpio_set_irq_bit(unsigned int irq, unsigned int reg)
+static inline void jz_gpio_set_irq_bit(struct irq_data *data, unsigned int reg)
 {
-	struct jz_gpio_chip *chip = irq_to_jz_gpio_chip(irq);
-	writel(IRQ_TO_BIT(irq), chip->base + reg);
+	struct jz_gpio_chip *chip = irq_to_jz_gpio_chip(data);
+	writel(IRQ_TO_BIT(data->irq), chip->base + reg);
 }
 
-static void jz_gpio_irq_mask(unsigned int irq)
+static void jz_gpio_irq_mask(struct irq_data *data)
 {
-	jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_MASK_SET);
+	jz_gpio_set_irq_bit(data, JZ_REG_GPIO_MASK_SET);
 };
 
-static void jz_gpio_irq_unmask(unsigned int irq)
+static void jz_gpio_irq_unmask(struct irq_data *data)
 {
-	struct jz_gpio_chip *chip = irq_to_jz_gpio_chip(irq);
+	struct jz_gpio_chip *chip = irq_to_jz_gpio_chip(data);
 
-	jz_gpio_check_trigger_both(chip, irq);
+	jz_gpio_check_trigger_both(chip, data->irq);
 
-	jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_MASK_CLEAR);
+	jz_gpio_set_irq_bit(data, JZ_REG_GPIO_MASK_CLEAR);
 };
 
 /* TODO: Check if function is gpio */
-static unsigned int jz_gpio_irq_startup(unsigned int irq)
+static unsigned int jz_gpio_irq_startup(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc = irq_to_desc(data->irq);
 
-	jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_SELECT_SET);
+	jz_gpio_set_irq_bit(data, JZ_REG_GPIO_SELECT_SET);
 
 	desc->status &= ~IRQ_MASKED;
-	jz_gpio_irq_unmask(irq);
+	jz_gpio_irq_unmask(data);
 
 	return 0;
 }
 
-static void jz_gpio_irq_shutdown(unsigned int irq)
+static void jz_gpio_irq_shutdown(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc = irq_to_desc(data->irq);
 
-	jz_gpio_irq_mask(irq);
+	jz_gpio_irq_mask(data);
 	desc->status |= IRQ_MASKED;
 
 	/* Set direction to input */
-	jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_DIRECTION_CLEAR);
-	jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_SELECT_CLEAR);
+	jz_gpio_set_irq_bit(data, JZ_REG_GPIO_DIRECTION_CLEAR);
+	jz_gpio_set_irq_bit(data, JZ_REG_GPIO_SELECT_CLEAR);
 }
 
-static void jz_gpio_irq_ack(unsigned int irq)
+static void jz_gpio_irq_ack(struct irq_data *data)
 {
-	jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_FLAG_CLEAR);
+	jz_gpio_set_irq_bit(data, JZ_REG_GPIO_FLAG_CLEAR);
 };
 
-static int jz_gpio_irq_set_type(unsigned int irq, unsigned int flow_type)
+static int jz_gpio_irq_set_type(struct irq_data *data, unsigned int flow_type)
 {
-	struct jz_gpio_chip *chip = irq_to_jz_gpio_chip(irq);
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct jz_gpio_chip *chip = irq_to_jz_gpio_chip(data);
+	struct irq_desc *desc = irq_to_desc(data->irq);
+	unsigned int irq = data->irq;
 
-	jz_gpio_irq_mask(irq);
+	jz_gpio_irq_mask(data);
 
 	if (flow_type == IRQ_TYPE_EDGE_BOTH) {
 		uint32_t value = readl(chip->base + JZ_REG_GPIO_PIN);
@@ -395,39 +396,39 @@ static int jz_gpio_irq_set_type(unsigned int irq, unsigned int flow_type)
 
 	switch (flow_type) {
 	case IRQ_TYPE_EDGE_RISING:
-		jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_DIRECTION_SET);
-		jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_TRIGGER_SET);
+		jz_gpio_set_irq_bit(data, JZ_REG_GPIO_DIRECTION_SET);
+		jz_gpio_set_irq_bit(data, JZ_REG_GPIO_TRIGGER_SET);
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
-		jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_DIRECTION_CLEAR);
-		jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_TRIGGER_SET);
+		jz_gpio_set_irq_bit(data, JZ_REG_GPIO_DIRECTION_CLEAR);
+		jz_gpio_set_irq_bit(data, JZ_REG_GPIO_TRIGGER_SET);
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
-		jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_DIRECTION_SET);
-		jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_TRIGGER_CLEAR);
+		jz_gpio_set_irq_bit(data, JZ_REG_GPIO_DIRECTION_SET);
+		jz_gpio_set_irq_bit(data, JZ_REG_GPIO_TRIGGER_CLEAR);
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
-		jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_DIRECTION_CLEAR);
-		jz_gpio_set_irq_bit(irq, JZ_REG_GPIO_TRIGGER_CLEAR);
+		jz_gpio_set_irq_bit(data, JZ_REG_GPIO_DIRECTION_CLEAR);
+		jz_gpio_set_irq_bit(data, JZ_REG_GPIO_TRIGGER_CLEAR);
 		break;
 	default:
 		return -EINVAL;
 	}
 
 	if (!(desc->status & IRQ_MASKED))
-		jz_gpio_irq_unmask(irq);
+		jz_gpio_irq_unmask(data);
 
 	return 0;
 }
 
-static int jz_gpio_irq_set_wake(unsigned int irq, unsigned int on)
+static int jz_gpio_irq_set_wake(struct irq_data *data, unsigned int on)
 {
-	struct jz_gpio_chip *chip = irq_to_jz_gpio_chip(irq);
+	struct jz_gpio_chip *chip = irq_to_jz_gpio_chip(data);
 	spin_lock(&chip->lock);
 	if (on)
-		chip->wakeup |= IRQ_TO_BIT(irq);
+		chip->wakeup |= IRQ_TO_BIT(data->irq);
 	else
-		chip->wakeup &= ~IRQ_TO_BIT(irq);
+		chip->wakeup &= ~IRQ_TO_BIT(data->irq);
 	spin_unlock(&chip->lock);
 
 	set_irq_wake(chip->irq, on);
@@ -454,13 +455,13 @@ static struct lock_class_key gpio_lock_class;
 	}, \
 	.irq_chip =  { \
 		.name = "GPIO Bank " # _bank, \
-		.mask = jz_gpio_irq_mask, \
-		.unmask = jz_gpio_irq_unmask, \
-		.ack = jz_gpio_irq_ack, \
-		.startup = jz_gpio_irq_startup, \
-		.shutdown = jz_gpio_irq_shutdown, \
-		.set_type = jz_gpio_irq_set_type, \
-		.set_wake = jz_gpio_irq_set_wake, \
+		.irq_mask = jz_gpio_irq_mask, \
+		.irq_unmask = jz_gpio_irq_unmask, \
+		.irq_ack = jz_gpio_irq_ack, \
+		.irq_startup = jz_gpio_irq_startup, \
+		.irq_shutdown = jz_gpio_irq_shutdown, \
+		.irq_set_type = jz_gpio_irq_set_type, \
+		.irq_set_wake = jz_gpio_irq_set_wake, \
 	}, \
 }
 
diff --git a/arch/mips/jz4740/irq.c b/arch/mips/jz4740/irq.c
index 7d33ff8..dcc5593 100644
--- a/arch/mips/jz4740/irq.c
+++ b/arch/mips/jz4740/irq.c
@@ -43,32 +43,37 @@ static uint32_t jz_intc_saved;
 
 #define IRQ_BIT(x) BIT((x) - JZ4740_IRQ_BASE)
 
-static void intc_irq_unmask(unsigned int irq)
+static inline unsigned long intc_irq_bit(struct irq_data *data)
 {
-	writel(IRQ_BIT(irq), jz_intc_base + JZ_REG_INTC_CLEAR_MASK);
+	return (unsigned long)irq_data_get_irq_chip_data(data);
 }
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_unmask(struct irq_data *data)
 {
-	writel(IRQ_BIT(irq), jz_intc_base + JZ_REG_INTC_SET_MASK);
+	writel(intc_irq_bit(data), jz_intc_base + JZ_REG_INTC_CLEAR_MASK);
 }
 
-static int intc_irq_set_wake(unsigned int irq, unsigned int on)
+static void intc_irq_mask(struct irq_data *data)
+{
+	writel(intc_irq_bit(data), jz_intc_base + JZ_REG_INTC_SET_MASK);
+}
+
+static int intc_irq_set_wake(struct irq_data *data, unsigned int on)
 {
 	if (on)
-		jz_intc_wakeup |= IRQ_BIT(irq);
+		jz_intc_wakeup |= intc_irq_bit(data);
 	else
-		jz_intc_wakeup &= ~IRQ_BIT(irq);
+		jz_intc_wakeup &= ~intc_irq_bit(data);
 
 	return 0;
 }
 
 static struct irq_chip intc_irq_type = {
 	.name =		"INTC",
-	.mask =		intc_irq_mask,
-	.mask_ack =	intc_irq_mask,
-	.unmask =	intc_irq_unmask,
-	.set_wake =	intc_irq_set_wake,
+	.irq_mask =	intc_irq_mask,
+	.irq_mask_ack =	intc_irq_mask,
+	.irq_unmask =	intc_irq_unmask,
+	.irq_set_wake =	intc_irq_set_wake,
 };
 
 static irqreturn_t jz4740_cascade(int irq, void *data)
@@ -95,8 +100,11 @@ void __init arch_init_irq(void)
 
 	jz_intc_base = ioremap(JZ4740_INTC_BASE_ADDR, 0x14);
 
+	/* Mask all irqs */
+	writel(0xffffffff, jz_intc_base + JZ_REG_INTC_SET_MASK);
+
 	for (i = JZ4740_IRQ_BASE; i < JZ4740_IRQ_BASE + 32; i++) {
-		intc_irq_mask(i);
+		set_irq_chip_data(i, (void *)IRQ_BIT(i));
 		set_irq_chip_and_handler(i, &intc_irq_type, handle_level_irq);
 	}
 
-- 
1.7.2.3

