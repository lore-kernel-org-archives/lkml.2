Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1FCBIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 21:08:53 -0400
Received: from smtp-out-212.synserver.de ([212.40.185.212]:1040 "EHLO
	smtp-out-212.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab1FCBIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 21:08:30 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 8419
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/4] MIPS: JZ4740: Use generic irq chip
Date: Fri,  3 Jun 2011 03:06:49 +0200
Message-Id: <1307063211-10098-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1307063211-10098-1-git-send-email-lars@metafoo.de>
References: <1307063211-10098-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic irq chip framework to implement the jz4740 INTC and GPIO irq
chips.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mips/Kconfig       |    1 +
 arch/mips/jz4740/gpio.c |  130 +++++++++++++----------------------------------
 arch/mips/jz4740/irq.c  |   92 ++++++++++++++-------------------
 arch/mips/jz4740/irq.h  |    6 ++-
 arch/mips/jz4740/pm.c   |    3 -
 5 files changed, 79 insertions(+), 153 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 653da62..cec11bb 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -211,6 +211,7 @@ config MACH_JZ4740
 	select SYS_HAS_EARLY_PRINTK
 	select HAVE_PWM
 	select HAVE_CLK
+	select GENERIC_IRQ_CHIP
 
 config LANTIQ
 	bool "Lantiq based platforms"
diff --git a/arch/mips/jz4740/gpio.c b/arch/mips/jz4740/gpio.c
index 4397972..ab583b8 100644
--- a/arch/mips/jz4740/gpio.c
+++ b/arch/mips/jz4740/gpio.c
@@ -17,8 +17,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 
-#include <linux/spinlock.h>
-#include <linux/syscore_ops.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
@@ -30,6 +28,8 @@
 
 #include <asm/mach-jz4740/base.h>
 
+#include "irq.h"
+
 #define JZ4740_GPIO_BASE_A (32*0)
 #define JZ4740_GPIO_BASE_B (32*1)
 #define JZ4740_GPIO_BASE_C (32*2)
@@ -77,14 +77,10 @@
 struct jz_gpio_chip {
 	unsigned int irq;
 	unsigned int irq_base;
-	uint32_t wakeup;
-	uint32_t suspend_mask;
 	uint32_t edge_trigger_both;
 
 	void __iomem *base;
 
-	spinlock_t lock;
-
 	struct gpio_chip gpio_chip;
 };
 
@@ -102,7 +98,8 @@ static inline struct jz_gpio_chip *gpio_chip_to_jz_gpio_chip(struct gpio_chip *g
 
 static inline struct jz_gpio_chip *irq_to_jz_gpio_chip(struct irq_data *data)
 {
-	return irq_data_get_irq_chip_data(data);
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(data);
+	return gc->private;
 }
 
 static inline void jz_gpio_write_bit(unsigned int gpio, unsigned int reg)
@@ -329,18 +326,12 @@ static inline void jz_gpio_set_irq_bit(struct irq_data *data, unsigned int reg)
 	writel(IRQ_TO_BIT(data->irq), chip->base + reg);
 }
 
-static void jz_gpio_irq_mask(struct irq_data *data)
-{
-	jz_gpio_set_irq_bit(data, JZ_REG_GPIO_MASK_SET);
-};
-
 static void jz_gpio_irq_unmask(struct irq_data *data)
 {
 	struct jz_gpio_chip *chip = irq_to_jz_gpio_chip(data);
 
 	jz_gpio_check_trigger_both(chip, data->irq);
-
-	jz_gpio_set_irq_bit(data, JZ_REG_GPIO_MASK_CLEAR);
+	irq_gc_unmask_enable_reg(data);
 };
 
 /* TODO: Check if function is gpio */
@@ -353,18 +344,13 @@ static unsigned int jz_gpio_irq_startup(struct irq_data *data)
 
 static void jz_gpio_irq_shutdown(struct irq_data *data)
 {
-	jz_gpio_irq_mask(data);
+	irq_gc_mask_disable_reg(data);
 
 	/* Set direction to input */
 	jz_gpio_set_irq_bit(data, JZ_REG_GPIO_DIRECTION_CLEAR);
 	jz_gpio_set_irq_bit(data, JZ_REG_GPIO_SELECT_CLEAR);
 }
 
-static void jz_gpio_irq_ack(struct irq_data *data)
-{
-	jz_gpio_set_irq_bit(data, JZ_REG_GPIO_FLAG_CLEAR);
-};
-
 static int jz_gpio_irq_set_type(struct irq_data *data, unsigned int flow_type)
 {
 	struct jz_gpio_chip *chip = irq_to_jz_gpio_chip(data);
@@ -408,35 +394,13 @@ static int jz_gpio_irq_set_type(struct irq_data *data, unsigned int flow_type)
 static int jz_gpio_irq_set_wake(struct irq_data *data, unsigned int on)
 {
 	struct jz_gpio_chip *chip = irq_to_jz_gpio_chip(data);
-	spin_lock(&chip->lock);
-	if (on)
-		chip->wakeup |= IRQ_TO_BIT(data->irq);
-	else
-		chip->wakeup &= ~IRQ_TO_BIT(data->irq);
-	spin_unlock(&chip->lock);
 
+	irq_gc_set_wake(data, on);
 	irq_set_irq_wake(chip->irq, on);
+
 	return 0;
 }
 
-static struct irq_chip jz_gpio_irq_chip = {
-	.name = "GPIO",
-	.irq_mask = jz_gpio_irq_mask,
-	.irq_unmask = jz_gpio_irq_unmask,
-	.irq_ack = jz_gpio_irq_ack,
-	.irq_startup = jz_gpio_irq_startup,
-	.irq_shutdown = jz_gpio_irq_shutdown,
-	.irq_set_type = jz_gpio_irq_set_type,
-	.irq_set_wake = jz_gpio_irq_set_wake,
-	.flags = IRQCHIP_SET_TYPE_MASKED,
-};
-
-/*
- * This lock class tells lockdep that GPIO irqs are in a different
- * category than their parents, so it won't report false recursion.
- */
-static struct lock_class_key gpio_lock_class;
-
 #define JZ4740_GPIO_CHIP(_bank) { \
 	.irq_base = JZ4740_IRQ_GPIO_BASE_ ## _bank, \
 	.gpio_chip = { \
@@ -458,64 +422,44 @@ static struct jz_gpio_chip jz4740_gpio_chips[] = {
 	JZ4740_GPIO_CHIP(D),
 };
 
-static void jz4740_gpio_suspend_chip(struct jz_gpio_chip *chip)
-{
-	chip->suspend_mask = readl(chip->base + JZ_REG_GPIO_MASK);
-	writel(~(chip->wakeup), chip->base + JZ_REG_GPIO_MASK_SET);
-	writel(chip->wakeup, chip->base + JZ_REG_GPIO_MASK_CLEAR);
-}
-
-static int jz4740_gpio_suspend(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(jz4740_gpio_chips); i++)
-		jz4740_gpio_suspend_chip(&jz4740_gpio_chips[i]);
-
-	return 0;
-}
-
-static void jz4740_gpio_resume_chip(struct jz_gpio_chip *chip)
+static void jz4740_gpio_chip_init(struct jz_gpio_chip *chip, unsigned int id)
 {
-	uint32_t mask = chip->suspend_mask;
+	struct irq_chip_generic *gc;
+	struct irq_chip_type *ct;
 
-	writel(~mask, chip->base + JZ_REG_GPIO_MASK_CLEAR);
-	writel(mask, chip->base + JZ_REG_GPIO_MASK_SET);
-}
+	chip->base = ioremap(JZ4740_GPIO_BASE_ADDR + (id * 0x100), 0x100);
 
-static void jz4740_gpio_resume(void)
-{
-	int i;
+	chip->irq = JZ4740_IRQ_INTC_GPIO(id);
+	irq_set_handler_data(chip->irq, chip);
+	irq_set_chained_handler(chip->irq, jz_gpio_irq_demux_handler);
 
-	for (i = ARRAY_SIZE(jz4740_gpio_chips) - 1; i >= 0 ; i--)
-		jz4740_gpio_resume_chip(&jz4740_gpio_chips[i]);
-}
+	gc = irq_alloc_generic_chip(chip->gpio_chip.label, 1, chip->irq_base,
+		chip->base, handle_level_irq);
 
-static struct syscore_ops jz4740_gpio_syscore_ops = {
-	.suspend = jz4740_gpio_suspend,
-	.resume = jz4740_gpio_resume,
-};
+	gc->wake_enabled = IRQ_MSK(chip->gpio_chip.ngpio);
+	gc->private = chip;
 
-static void jz4740_gpio_chip_init(struct jz_gpio_chip *chip, unsigned int id)
-{
-	int irq;
+	ct = gc->chip_types;
+	ct->regs.enable = JZ_REG_GPIO_MASK_CLEAR;
+	ct->regs.disable = JZ_REG_GPIO_MASK_SET;
+	ct->regs.ack = JZ_REG_GPIO_FLAG_CLEAR;
 
-	spin_lock_init(&chip->lock);
+	ct->chip.name = "GPIO";
+	ct->chip.irq_mask = irq_gc_mask_disable_reg;
+	ct->chip.irq_unmask = jz_gpio_irq_unmask;
+	ct->chip.irq_ack = irq_gc_ack;
+	ct->chip.irq_suspend = jz4740_irq_suspend;
+	ct->chip.irq_resume = jz4740_irq_resume;
+	ct->chip.irq_startup = jz_gpio_irq_startup;
+	ct->chip.irq_shutdown = jz_gpio_irq_shutdown;
+	ct->chip.irq_set_type = jz_gpio_irq_set_type;
+	ct->chip.irq_set_wake = jz_gpio_irq_set_wake;
+	ct->chip.flags = IRQCHIP_SET_TYPE_MASKED;
 
-	chip->base = ioremap(JZ4740_GPIO_BASE_ADDR + (id * 0x100), 0x100);
+	irq_setup_generic_chip(gc, IRQ_MSK(chip->gpio_chip.ngpio),
+		IRQ_GC_INIT_NESTED_LOCK, 0, IRQ_NOPROBE | IRQ_LEVEL);
 
 	gpiochip_add(&chip->gpio_chip);
-
-	chip->irq = JZ4740_IRQ_INTC_GPIO(id);
-	irq_set_handler_data(chip->irq, chip);
-	irq_set_chained_handler(chip->irq, jz_gpio_irq_demux_handler);
-
-	for (irq = chip->irq_base; irq < chip->irq_base + chip->gpio_chip.ngpio; ++irq) {
-		irq_set_lockdep_class(irq, &gpio_lock_class);
-		irq_set_chip_data(irq, chip);
-		irq_set_chip_and_handler(irq, &jz_gpio_irq_chip,
-					 handle_level_irq);
-	}
 }
 
 static int __init jz4740_gpio_init(void)
@@ -525,8 +469,6 @@ static int __init jz4740_gpio_init(void)
 	for (i = 0; i < ARRAY_SIZE(jz4740_gpio_chips); ++i)
 		jz4740_gpio_chip_init(&jz4740_gpio_chips[i], i);
 
-	register_syscore_ops(&jz4740_gpio_syscore_ops);
-
 	printk(KERN_INFO "JZ4740 GPIO initialized\n");
 
 	return 0;
diff --git a/arch/mips/jz4740/irq.c b/arch/mips/jz4740/irq.c
index d82c0c4..fc57ded 100644
--- a/arch/mips/jz4740/irq.c
+++ b/arch/mips/jz4740/irq.c
@@ -32,8 +32,6 @@
 #include <asm/mach-jz4740/base.h>
 
 static void __iomem *jz_intc_base;
-static uint32_t jz_intc_wakeup;
-static uint32_t jz_intc_saved;
 
 #define JZ_REG_INTC_STATUS	0x00
 #define JZ_REG_INTC_MASK	0x04
@@ -41,51 +39,36 @@ static uint32_t jz_intc_saved;
 #define JZ_REG_INTC_CLEAR_MASK	0x0c
 #define JZ_REG_INTC_PENDING	0x10
 
-#define IRQ_BIT(x) BIT((x) - JZ4740_IRQ_BASE)
-
-static inline unsigned long intc_irq_bit(struct irq_data *data)
+static irqreturn_t jz4740_cascade(int irq, void *data)
 {
-	return (unsigned long)irq_data_get_irq_chip_data(data);
-}
+	uint32_t irq_reg;
 
-static void intc_irq_unmask(struct irq_data *data)
-{
-	writel(intc_irq_bit(data), jz_intc_base + JZ_REG_INTC_CLEAR_MASK);
-}
+	irq_reg = readl(jz_intc_base + JZ_REG_INTC_PENDING);
 
-static void intc_irq_mask(struct irq_data *data)
-{
-	writel(intc_irq_bit(data), jz_intc_base + JZ_REG_INTC_SET_MASK);
+	if (irq_reg)
+		generic_handle_irq(__fls(irq_reg) + JZ4740_IRQ_BASE);
+
+	return IRQ_HANDLED;
 }
 
-static int intc_irq_set_wake(struct irq_data *data, unsigned int on)
+static void jz4740_irq_set_mask(struct irq_chip_generic *gc, uint32_t mask)
 {
-	if (on)
-		jz_intc_wakeup |= intc_irq_bit(data);
-	else
-		jz_intc_wakeup &= ~intc_irq_bit(data);
+	struct irq_chip_regs *regs = &gc->chip_types->regs;
 
-	return 0;
+	writel(mask, gc->reg_base + regs->enable);
+	writel(~mask, gc->reg_base + regs->disable);
 }
 
-static struct irq_chip intc_irq_type = {
-	.name =		"INTC",
-	.irq_mask =	intc_irq_mask,
-	.irq_mask_ack =	intc_irq_mask,
-	.irq_unmask =	intc_irq_unmask,
-	.irq_set_wake =	intc_irq_set_wake,
-};
-
-static irqreturn_t jz4740_cascade(int irq, void *data)
+void jz4740_irq_suspend(struct irq_data *data)
 {
-	uint32_t irq_reg;
-
-	irq_reg = readl(jz_intc_base + JZ_REG_INTC_PENDING);
-
-	if (irq_reg)
-		generic_handle_irq(__fls(irq_reg) + JZ4740_IRQ_BASE);
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(data);
+	jz4740_irq_set_mask(gc, gc->wake_active);
+}
 
-	return IRQ_HANDLED;
+void jz4740_irq_resume(struct irq_data *data)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(data);
+	jz4740_irq_set_mask(gc, gc->mask_cache);
 }
 
 static struct irqaction jz4740_cascade_action = {
@@ -95,7 +78,9 @@ static struct irqaction jz4740_cascade_action = {
 
 void __init arch_init_irq(void)
 {
-	int i;
+	struct irq_chip_generic *gc;
+	struct irq_chip_type *ct;
+
 	mips_cpu_irq_init();
 
 	jz_intc_base = ioremap(JZ4740_INTC_BASE_ADDR, 0x14);
@@ -103,10 +88,22 @@ void __init arch_init_irq(void)
 	/* Mask all irqs */
 	writel(0xffffffff, jz_intc_base + JZ_REG_INTC_SET_MASK);
 
-	for (i = JZ4740_IRQ_BASE; i < JZ4740_IRQ_BASE + 32; i++) {
-		irq_set_chip_data(i, (void *)IRQ_BIT(i));
-		irq_set_chip_and_handler(i, &intc_irq_type, handle_level_irq);
-	}
+	gc = irq_alloc_generic_chip("INTC", 1, JZ4740_IRQ_BASE, jz_intc_base,
+		handle_level_irq);
+
+	gc->wake_enabled = IRQ_MSK(32);
+
+	ct = gc->chip_types;
+	ct->regs.enable = JZ_REG_INTC_CLEAR_MASK;
+	ct->regs.disable = JZ_REG_INTC_SET_MASK;
+	ct->chip.irq_unmask = irq_gc_unmask_enable_reg;
+	ct->chip.irq_mask = irq_gc_mask_disable_reg;
+	ct->chip.irq_mask_ack = irq_gc_mask_disable_reg;
+	ct->chip.irq_set_wake = irq_gc_set_wake;
+	ct->chip.irq_suspend = jz4740_irq_suspend;
+	ct->chip.irq_resume = jz4740_irq_resume;
+
+	irq_setup_generic_chip(gc, IRQ_MSK(32), 0, 0, IRQ_NOPROBE | IRQ_LEVEL);
 
 	setup_irq(2, &jz4740_cascade_action);
 }
@@ -122,19 +119,6 @@ asmlinkage void plat_irq_dispatch(void)
 		spurious_interrupt();
 }
 
-void jz4740_intc_suspend(void)
-{
-	jz_intc_saved = readl(jz_intc_base + JZ_REG_INTC_MASK);
-	writel(~jz_intc_wakeup, jz_intc_base + JZ_REG_INTC_SET_MASK);
-	writel(jz_intc_wakeup, jz_intc_base + JZ_REG_INTC_CLEAR_MASK);
-}
-
-void jz4740_intc_resume(void)
-{
-	writel(~jz_intc_saved, jz_intc_base + JZ_REG_INTC_CLEAR_MASK);
-	writel(jz_intc_saved, jz_intc_base + JZ_REG_INTC_SET_MASK);
-}
-
 #ifdef CONFIG_DEBUG_FS
 
 static inline void intc_seq_reg(struct seq_file *s, const char *name,
diff --git a/arch/mips/jz4740/irq.h b/arch/mips/jz4740/irq.h
index 56b5ead..f75e39d 100644
--- a/arch/mips/jz4740/irq.h
+++ b/arch/mips/jz4740/irq.h
@@ -15,7 +15,9 @@
 #ifndef __MIPS_JZ4740_IRQ_H__
 #define __MIPS_JZ4740_IRQ_H__
 
-extern void jz4740_intc_suspend(void);
-extern void jz4740_intc_resume(void);
+#include <linux/irq.h>
+
+extern void jz4740_irq_suspend(struct irq_data *data);
+extern void jz4740_irq_resume(struct irq_data *data);
 
 #endif
diff --git a/arch/mips/jz4740/pm.c b/arch/mips/jz4740/pm.c
index 902d5b5..6744fa7 100644
--- a/arch/mips/jz4740/pm.c
+++ b/arch/mips/jz4740/pm.c
@@ -21,11 +21,9 @@
 #include <asm/mach-jz4740/clock.h>
 
 #include "clock.h"
-#include "irq.h"
 
 static int jz4740_pm_enter(suspend_state_t state)
 {
-	jz4740_intc_suspend();
 	jz4740_clock_suspend();
 
 	jz4740_clock_set_wait_mode(JZ4740_WAIT_MODE_SLEEP);
@@ -37,7 +35,6 @@ static int jz4740_pm_enter(suspend_state_t state)
 	jz4740_clock_set_wait_mode(JZ4740_WAIT_MODE_IDLE);
 
 	jz4740_clock_resume();
-	jz4740_intc_resume();
 
 	return 0;
 }
-- 
1.7.2.5

