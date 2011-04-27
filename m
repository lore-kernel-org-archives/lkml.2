Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab1D0Nl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:41:29 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:45565 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758468Ab1D0Nl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:41:27 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 06/10] plat-nomadik: disable clocks when unused
Date: Wed, 27 Apr 2011 15:14:03 +0200
Message-ID: <1303910043-3470-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

The GPIO clock is required for register access and interrupt detection.
When interrupt detection is not required on any of the pin in a block,
the block's clock can be disabled when the registers are not being
accessed.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Rickard Andersson <rickard.andersson@stericsson.com>
Reviewed-by: Jonas Aberg <jonas.aberg@stericsson.com>
[Adjust for new IRQ chip core code, use only local functions]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/plat-nomadik/gpio.c              |  127 +++++++++++++++++++++++++---
 arch/arm/plat-nomadik/include/plat/gpio.h |    3 +
 2 files changed, 116 insertions(+), 14 deletions(-)

diff --git a/arch/arm/plat-nomadik/gpio.c b/arch/arm/plat-nomadik/gpio.c
index 978d26c..b81f0d5 100644
--- a/arch/arm/plat-nomadik/gpio.c
+++ b/arch/arm/plat-nomadik/gpio.c
@@ -54,7 +54,6 @@ struct nmk_gpio_chip {
 	u32 rwimsc;
 	u32 fwimsc;
 	u32 slpm;
-	u32 enabled;
 	u32 pull_up;
 };
 
@@ -272,6 +271,8 @@ static void nmk_gpio_glitch_slpm_init(unsigned int *slpm)
 		if (!chip)
 			break;
 
+		clk_enable(chip->clk);
+
 		slpm[i] = readl(chip->addr + NMK_GPIO_SLPC);
 		writel(temp, chip->addr + NMK_GPIO_SLPC);
 	}
@@ -288,6 +289,8 @@ static void nmk_gpio_glitch_slpm_restore(unsigned int *slpm)
 			break;
 
 		writel(slpm[i], chip->addr + NMK_GPIO_SLPC);
+
+		clk_disable(chip->clk);
 	}
 }
 
@@ -332,10 +335,12 @@ static int __nmk_config_pins(pin_cfg_t *cfgs, int num, bool sleep)
 			break;
 		}
 
+		clk_enable(nmk_chip->clk);
 		spin_lock(&nmk_chip->lock);
 		__nmk_config_pin(nmk_chip, pin - nmk_chip->chip.base,
 				 cfgs[i], sleep, glitch ? slpm : NULL);
 		spin_unlock(&nmk_chip->lock);
+		clk_disable(nmk_chip->clk);
 	}
 
 	if (glitch)
@@ -409,6 +414,7 @@ int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode)
 	if (!nmk_chip)
 		return -EINVAL;
 
+	clk_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
 	spin_lock(&nmk_chip->lock);
 
@@ -416,6 +422,7 @@ int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode)
 
 	spin_unlock(&nmk_chip->lock);
 	spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
+	clk_disable(nmk_chip->clk);
 
 	return 0;
 }
@@ -442,9 +449,11 @@ int nmk_gpio_set_pull(int gpio, enum nmk_gpio_pull pull)
 	if (!nmk_chip)
 		return -EINVAL;
 
+	clk_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_chip->lock, flags);
 	__nmk_gpio_set_pull(nmk_chip, gpio - nmk_chip->chip.base, pull);
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
+	clk_disable(nmk_chip->clk);
 
 	return 0;
 }
@@ -468,9 +477,11 @@ int nmk_gpio_set_mode(int gpio, int gpio_mode)
 	if (!nmk_chip)
 		return -EINVAL;
 
+	clk_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_chip->lock, flags);
 	__nmk_gpio_set_mode(nmk_chip, gpio - nmk_chip->chip.base, gpio_mode);
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
+	clk_disable(nmk_chip->clk);
 
 	return 0;
 }
@@ -487,9 +498,13 @@ int nmk_gpio_get_mode(int gpio)
 
 	bit = 1 << (gpio - nmk_chip->chip.base);
 
+	clk_enable(nmk_chip->clk);
+
 	afunc = readl(nmk_chip->addr + NMK_GPIO_AFSLA) & bit;
 	bfunc = readl(nmk_chip->addr + NMK_GPIO_AFSLB) & bit;
 
+	clk_disable(nmk_chip->clk);
+
 	return (afunc ? NMK_GPIO_ALT_A : 0) | (bfunc ? NMK_GPIO_ALT_B : 0);
 }
 EXPORT_SYMBOL(nmk_gpio_get_mode);
@@ -510,7 +525,10 @@ static void nmk_gpio_irq_ack(struct irq_data *d)
 	nmk_chip = irq_data_get_irq_chip_data(d);
 	if (!nmk_chip)
 		return;
+
+	clk_enable(nmk_chip->clk);
 	writel(nmk_gpio_get_bitmask(gpio), nmk_chip->addr + NMK_GPIO_IC);
+	clk_disable(nmk_chip->clk);
 }
 
 enum nmk_gpio_irq_type {
@@ -565,11 +583,7 @@ static int nmk_gpio_irq_maskunmask(struct irq_data *d, bool enable)
 	if (!nmk_chip)
 		return -EINVAL;
 
-	if (enable)
-		nmk_chip->enabled |= bitmask;
-	else
-		nmk_chip->enabled &= ~bitmask;
-
+	clk_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
 	spin_lock(&nmk_chip->lock);
 
@@ -580,6 +594,7 @@ static int nmk_gpio_irq_maskunmask(struct irq_data *d, bool enable)
 
 	spin_unlock(&nmk_chip->lock);
 	spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
+	clk_disable(nmk_chip->clk);
 
 	return 0;
 }
@@ -607,10 +622,11 @@ static int nmk_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 		return -EINVAL;
 	bitmask = nmk_gpio_get_bitmask(gpio);
 
+	clk_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
 	spin_lock(&nmk_chip->lock);
 
-	if (!(nmk_chip->enabled & bitmask))
+	if (irqd_irq_disabled(d))
 		__nmk_gpio_set_wake(nmk_chip, gpio, on);
 
 	if (on)
@@ -620,13 +636,15 @@ static int nmk_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 
 	spin_unlock(&nmk_chip->lock);
 	spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
+	clk_disable(nmk_chip->clk);
 
 	return 0;
 }
 
 static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	bool enabled, wake = irqd_is_wakeup_set(d);
+	bool enabled = !irqd_irq_disabled(d);
+	bool wake = irqd_is_wakeup_set(d);
 	int gpio;
 	struct nmk_gpio_chip *nmk_chip;
 	unsigned long flags;
@@ -643,8 +661,7 @@ static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	if (type & IRQ_TYPE_LEVEL_LOW)
 		return -EINVAL;
 
-	enabled = nmk_chip->enabled & bitmask;
-
+	clk_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_chip->lock, flags);
 
 	if (enabled)
@@ -668,10 +685,28 @@ static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		__nmk_gpio_irq_modify(nmk_chip, gpio, WAKE, true);
 
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
+	clk_disable(nmk_chip->clk);
 
 	return 0;
 }
 
+static unsigned int nmk_gpio_irq_startup(struct irq_data *d)
+{
+	struct nmk_gpio_chip *nmk_chip = irq_data_get_irq_chip_data(d);
+
+	clk_enable(nmk_chip->clk);
+	nmk_gpio_irq_unmask(d);
+	return 0;
+}
+
+static void nmk_gpio_irq_shutdown(struct irq_data *d)
+{
+	struct nmk_gpio_chip *nmk_chip = irq_data_get_irq_chip_data(d);
+
+	nmk_gpio_irq_mask(d);
+	clk_disable(nmk_chip->clk);
+}
+
 static struct irq_chip nmk_gpio_irq_chip = {
 	.name		= "Nomadik-GPIO",
 	.irq_ack	= nmk_gpio_irq_ack,
@@ -679,6 +714,8 @@ static struct irq_chip nmk_gpio_irq_chip = {
 	.irq_unmask	= nmk_gpio_irq_unmask,
 	.irq_set_type	= nmk_gpio_irq_set_type,
 	.irq_set_wake	= nmk_gpio_irq_set_wake,
+	.irq_startup	= nmk_gpio_irq_startup,
+	.irq_shutdown	= nmk_gpio_irq_shutdown,
 };
 
 static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
@@ -711,7 +748,11 @@ static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
 static void nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
 	struct nmk_gpio_chip *nmk_chip = irq_get_handler_data(irq);
-	u32 status = readl(nmk_chip->addr + NMK_GPIO_IS);
+	u32 status;
+
+	clk_enable(nmk_chip->clk);
+	status = readl(nmk_chip->addr + NMK_GPIO_IS);
+	clk_disable(nmk_chip->clk);
 
 	__nmk_gpio_irq_handler(irq, desc, status);
 }
@@ -757,7 +798,12 @@ static int nmk_gpio_make_input(struct gpio_chip *chip, unsigned offset)
 	struct nmk_gpio_chip *nmk_chip =
 		container_of(chip, struct nmk_gpio_chip, chip);
 
+	clk_enable(nmk_chip->clk);
+
 	writel(1 << offset, nmk_chip->addr + NMK_GPIO_DIRC);
+
+	clk_disable(nmk_chip->clk);
+
 	return 0;
 }
 
@@ -766,8 +812,15 @@ static int nmk_gpio_get_input(struct gpio_chip *chip, unsigned offset)
 	struct nmk_gpio_chip *nmk_chip =
 		container_of(chip, struct nmk_gpio_chip, chip);
 	u32 bit = 1 << offset;
+	int value;
+
+	clk_enable(nmk_chip->clk);
 
-	return (readl(nmk_chip->addr + NMK_GPIO_DAT) & bit) != 0;
+	value = (readl(nmk_chip->addr + NMK_GPIO_DAT) & bit) != 0;
+
+	clk_disable(nmk_chip->clk);
+
+	return value;
 }
 
 static void nmk_gpio_set_output(struct gpio_chip *chip, unsigned offset,
@@ -776,7 +829,11 @@ static void nmk_gpio_set_output(struct gpio_chip *chip, unsigned offset,
 	struct nmk_gpio_chip *nmk_chip =
 		container_of(chip, struct nmk_gpio_chip, chip);
 
+	clk_enable(nmk_chip->clk);
+
 	__nmk_gpio_set_output(nmk_chip, offset, val);
+
+	clk_disable(nmk_chip->clk);
 }
 
 static int nmk_gpio_make_output(struct gpio_chip *chip, unsigned offset,
@@ -785,8 +842,12 @@ static int nmk_gpio_make_output(struct gpio_chip *chip, unsigned offset,
 	struct nmk_gpio_chip *nmk_chip =
 		container_of(chip, struct nmk_gpio_chip, chip);
 
+	clk_enable(nmk_chip->clk);
+
 	__nmk_gpio_make_output(nmk_chip, offset, val);
 
+	clk_disable(nmk_chip->clk);
+
 	return 0;
 }
 
@@ -817,6 +878,8 @@ static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 		[NMK_GPIO_ALT_C]	= "altC",
 	};
 
+	clk_enable(nmk_chip->clk);
+
 	for (i = 0; i < chip->ngpio; i++, gpio++) {
 		const char *label = gpiochip_is_requested(chip, i);
 		bool pull;
@@ -861,6 +924,8 @@ static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 
 		seq_printf(s, "\n");
 	}
+
+	clk_disable(nmk_chip->clk);
 }
 
 #else
@@ -878,6 +943,34 @@ static struct gpio_chip nmk_gpio_template = {
 	.can_sleep		= 0,
 };
 
+void nmk_gpio_clocks_enable(void)
+{
+	int i;
+
+	for (i = 0; i < NUM_BANKS; i++) {
+		struct nmk_gpio_chip *chip = nmk_gpio_chips[i];
+
+		if (!chip)
+			continue;
+
+		clk_enable(chip->clk);
+	}
+}
+
+void nmk_gpio_clocks_disable(void)
+{
+	int i;
+
+	for (i = 0; i < NUM_BANKS; i++) {
+		struct nmk_gpio_chip *chip = nmk_gpio_chips[i];
+
+		if (!chip)
+			continue;
+
+		clk_disable(chip->clk);
+	}
+}
+
 /*
  * Called from the suspend/resume path to only keep the real wakeup interrupts
  * (those that have had set_irq_wake() called on them) as wakeup interrupts,
@@ -897,6 +990,8 @@ void nmk_gpio_wakeups_suspend(void)
 		if (!chip)
 			break;
 
+		clk_enable(chip->clk);
+
 		chip->rwimsc = readl(chip->addr + NMK_GPIO_RWIMSC);
 		chip->fwimsc = readl(chip->addr + NMK_GPIO_FWIMSC);
 
@@ -911,6 +1006,8 @@ void nmk_gpio_wakeups_suspend(void)
 			/* 0 -> wakeup enable */
 			writel(~chip->real_wake, chip->addr + NMK_GPIO_SLPC);
 		}
+
+		clk_disable(chip->clk);
 	}
 }
 
@@ -924,11 +1021,15 @@ void nmk_gpio_wakeups_resume(void)
 		if (!chip)
 			break;
 
+		clk_enable(chip->clk);
+
 		writel(chip->rwimsc, chip->addr + NMK_GPIO_RWIMSC);
 		writel(chip->fwimsc, chip->addr + NMK_GPIO_FWIMSC);
 
 		if (cpu_is_u8500v2())
 			writel(chip->slpm, chip->addr + NMK_GPIO_SLPC);
+
+		clk_disable(chip->clk);
 	}
 }
 
@@ -995,8 +1096,6 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 		goto out_release;
 	}
 
-	clk_enable(clk);
-
 	nmk_chip = kzalloc(sizeof(*nmk_chip), GFP_KERNEL);
 	if (!nmk_chip) {
 		ret = -ENOMEM;
diff --git a/arch/arm/plat-nomadik/include/plat/gpio.h b/arch/arm/plat-nomadik/include/plat/gpio.h
index ea19a5b..dfdd4e7 100644
--- a/arch/arm/plat-nomadik/include/plat/gpio.h
+++ b/arch/arm/plat-nomadik/include/plat/gpio.h
@@ -78,6 +78,9 @@ extern int nmk_gpio_get_mode(int gpio);
 extern void nmk_gpio_wakeups_suspend(void);
 extern void nmk_gpio_wakeups_resume(void);
 
+extern void nmk_gpio_clocks_enable(void);
+extern void nmk_gpio_clocks_disable(void);
+
 extern void nmk_gpio_read_pull(int gpio_bank, u32 *pull_up);
 
 /*
-- 
1.7.3.2

