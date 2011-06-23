Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab1FWMMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:12:45 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:50243 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757947Ab1FWMMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:12:41 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4] gpio/nomadik: disable clocks when unused
Date: Thu, 23 Jun 2011 14:12:19 +0200
Message-ID: <1308831139-10653-1-git-send-email-linus.walleij@stericsson.com>
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
 drivers/gpio/gpio-nomadik.c  |  120 +++++++++++++++++++++++++++++++++++++++---
 include/linux/gpio/nomadik.h |    3 +
 2 files changed, 116 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
index efc7560..4300b9f 100644
--- a/drivers/gpio/gpio-nomadik.c
+++ b/drivers/gpio/gpio-nomadik.c
@@ -276,6 +276,8 @@ static void nmk_gpio_glitch_slpm_init(unsigned int *slpm)
 		if (!chip)
 			break;
 
+		clk_enable(chip->clk);
+
 		slpm[i] = readl(chip->addr + NMK_GPIO_SLPC);
 		writel(temp, chip->addr + NMK_GPIO_SLPC);
 	}
@@ -292,6 +294,8 @@ static void nmk_gpio_glitch_slpm_restore(unsigned int *slpm)
 			break;
 
 		writel(slpm[i], chip->addr + NMK_GPIO_SLPC);
+
+		clk_disable(chip->clk);
 	}
 }
 
@@ -336,10 +340,12 @@ static int __nmk_config_pins(pin_cfg_t *cfgs, int num, bool sleep)
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
@@ -424,6 +430,7 @@ int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode)
 	if (!nmk_chip)
 		return -EINVAL;
 
+	clk_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
 	spin_lock(&nmk_chip->lock);
 
@@ -431,6 +438,7 @@ int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode)
 
 	spin_unlock(&nmk_chip->lock);
 	spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
+	clk_disable(nmk_chip->clk);
 
 	return 0;
 }
@@ -457,9 +465,11 @@ int nmk_gpio_set_pull(int gpio, enum nmk_gpio_pull pull)
 	if (!nmk_chip)
 		return -EINVAL;
 
+	clk_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_chip->lock, flags);
 	__nmk_gpio_set_pull(nmk_chip, gpio - nmk_chip->chip.base, pull);
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
+	clk_disable(nmk_chip->clk);
 
 	return 0;
 }
@@ -483,9 +493,11 @@ int nmk_gpio_set_mode(int gpio, int gpio_mode)
 	if (!nmk_chip)
 		return -EINVAL;
 
+	clk_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_chip->lock, flags);
 	__nmk_gpio_set_mode(nmk_chip, gpio - nmk_chip->chip.base, gpio_mode);
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
+	clk_disable(nmk_chip->clk);
 
 	return 0;
 }
@@ -502,9 +514,13 @@ int nmk_gpio_get_mode(int gpio)
 
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
@@ -525,7 +541,10 @@ static void nmk_gpio_irq_ack(struct irq_data *d)
 	nmk_chip = irq_data_get_irq_chip_data(d);
 	if (!nmk_chip)
 		return;
+
+	clk_enable(nmk_chip->clk);
 	writel(nmk_gpio_get_bitmask(gpio), nmk_chip->addr + NMK_GPIO_IC);
+	clk_disable(nmk_chip->clk);
 }
 
 enum nmk_gpio_irq_type {
@@ -591,6 +610,7 @@ static int nmk_gpio_irq_maskunmask(struct irq_data *d, bool enable)
 	else
 		nmk_chip->enabled &= ~bitmask;
 
+	clk_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
 	spin_lock(&nmk_chip->lock);
 
@@ -601,6 +621,7 @@ static int nmk_gpio_irq_maskunmask(struct irq_data *d, bool enable)
 
 	spin_unlock(&nmk_chip->lock);
 	spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
+	clk_disable(nmk_chip->clk);
 
 	return 0;
 }
@@ -628,6 +649,7 @@ static int nmk_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 		return -EINVAL;
 	bitmask = nmk_gpio_get_bitmask(gpio);
 
+	clk_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
 	spin_lock(&nmk_chip->lock);
 
@@ -641,13 +663,15 @@ static int nmk_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 
 	spin_unlock(&nmk_chip->lock);
 	spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
+	clk_disable(nmk_chip->clk);
 
 	return 0;
 }
 
 static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	bool enabled, wake = irqd_is_wakeup_set(d);
+	bool enabled;
+	bool wake = irqd_is_wakeup_set(d);
 	int gpio;
 	struct nmk_gpio_chip *nmk_chip;
 	unsigned long flags;
@@ -664,10 +688,10 @@ static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	if (type & IRQ_TYPE_LEVEL_LOW)
 		return -EINVAL;
 
-	enabled = nmk_chip->enabled & bitmask;
-
+	clk_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_chip->lock, flags);
 
+	enabled = !!(nmk_chip->enabled & bitmask);
 	if (enabled)
 		__nmk_gpio_irq_modify(nmk_chip, gpio, NORMAL, false);
 
@@ -689,10 +713,28 @@ static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		__nmk_gpio_irq_modify(nmk_chip, gpio, WAKE, true);
 
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
+	clk_disable(nmk_chip->clk);
+
+	return 0;
+}
+
+static unsigned int nmk_gpio_irq_startup(struct irq_data *d)
+{
+	struct nmk_gpio_chip *nmk_chip = irq_data_get_irq_chip_data(d);
 
+	clk_enable(nmk_chip->clk);
+	nmk_gpio_irq_unmask(d);
 	return 0;
 }
 
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
@@ -700,6 +742,8 @@ static struct irq_chip nmk_gpio_irq_chip = {
 	.irq_unmask	= nmk_gpio_irq_unmask,
 	.irq_set_type	= nmk_gpio_irq_set_type,
 	.irq_set_wake	= nmk_gpio_irq_set_wake,
+	.irq_startup	= nmk_gpio_irq_startup,
+	.irq_shutdown	= nmk_gpio_irq_shutdown,
 };
 
 static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
@@ -726,7 +770,11 @@ static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
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
@@ -772,7 +820,12 @@ static int nmk_gpio_make_input(struct gpio_chip *chip, unsigned offset)
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
 
@@ -781,8 +834,15 @@ static int nmk_gpio_get_input(struct gpio_chip *chip, unsigned offset)
 	struct nmk_gpio_chip *nmk_chip =
 		container_of(chip, struct nmk_gpio_chip, chip);
 	u32 bit = 1 << offset;
+	int value;
+
+	clk_enable(nmk_chip->clk);
+
+	value = (readl(nmk_chip->addr + NMK_GPIO_DAT) & bit) != 0;
 
-	return (readl(nmk_chip->addr + NMK_GPIO_DAT) & bit) != 0;
+	clk_disable(nmk_chip->clk);
+
+	return value;
 }
 
 static void nmk_gpio_set_output(struct gpio_chip *chip, unsigned offset,
@@ -791,7 +851,11 @@ static void nmk_gpio_set_output(struct gpio_chip *chip, unsigned offset,
 	struct nmk_gpio_chip *nmk_chip =
 		container_of(chip, struct nmk_gpio_chip, chip);
 
+	clk_enable(nmk_chip->clk);
+
 	__nmk_gpio_set_output(nmk_chip, offset, val);
+
+	clk_disable(nmk_chip->clk);
 }
 
 static int nmk_gpio_make_output(struct gpio_chip *chip, unsigned offset,
@@ -800,8 +864,12 @@ static int nmk_gpio_make_output(struct gpio_chip *chip, unsigned offset,
 	struct nmk_gpio_chip *nmk_chip =
 		container_of(chip, struct nmk_gpio_chip, chip);
 
+	clk_enable(nmk_chip->clk);
+
 	__nmk_gpio_make_output(nmk_chip, offset, val);
 
+	clk_disable(nmk_chip->clk);
+
 	return 0;
 }
 
@@ -832,6 +900,8 @@ static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 		[NMK_GPIO_ALT_C]	= "altC",
 	};
 
+	clk_enable(nmk_chip->clk);
+
 	for (i = 0; i < chip->ngpio; i++, gpio++) {
 		const char *label = gpiochip_is_requested(chip, i);
 		bool pull;
@@ -876,6 +946,8 @@ static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 
 		seq_printf(s, "\n");
 	}
+
+	clk_disable(nmk_chip->clk);
 }
 
 #else
@@ -893,6 +965,34 @@ static struct gpio_chip nmk_gpio_template = {
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
@@ -912,6 +1012,8 @@ void nmk_gpio_wakeups_suspend(void)
 		if (!chip)
 			break;
 
+		clk_enable(chip->clk);
+
 		chip->rwimsc = readl(chip->addr + NMK_GPIO_RWIMSC);
 		chip->fwimsc = readl(chip->addr + NMK_GPIO_FWIMSC);
 
@@ -926,6 +1028,8 @@ void nmk_gpio_wakeups_suspend(void)
 			/* 0 -> wakeup enable */
 			writel(~chip->real_wake, chip->addr + NMK_GPIO_SLPC);
 		}
+
+		clk_disable(chip->clk);
 	}
 }
 
@@ -939,11 +1043,15 @@ void nmk_gpio_wakeups_resume(void)
 		if (!chip)
 			break;
 
+		clk_enable(chip->clk);
+
 		writel(chip->rwimsc, chip->addr + NMK_GPIO_RWIMSC);
 		writel(chip->fwimsc, chip->addr + NMK_GPIO_FWIMSC);
 
 		if (chip->sleepmode)
 			writel(chip->slpm, chip->addr + NMK_GPIO_SLPC);
+
+		clk_disable(chip->clk);
 	}
 }
 
@@ -1010,8 +1118,6 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 		goto out_release;
 	}
 
-	clk_enable(clk);
-
 	nmk_chip = kzalloc(sizeof(*nmk_chip), GFP_KERNEL);
 	if (!nmk_chip) {
 		ret = -ENOMEM;
diff --git a/include/linux/gpio/nomadik.h b/include/linux/gpio/nomadik.h
index 0cfe96e..cc956d1 100644
--- a/include/linux/gpio/nomadik.h
+++ b/include/linux/gpio/nomadik.h
@@ -66,6 +66,9 @@ extern int nmk_gpio_get_mode(int gpio);
 extern void nmk_gpio_wakeups_suspend(void);
 extern void nmk_gpio_wakeups_resume(void);
 
+extern void nmk_gpio_clocks_enable(void);
+extern void nmk_gpio_clocks_disable(void);
+
 extern void nmk_gpio_read_pull(int gpio_bank, u32 *pull_up);
 
 /*
-- 
1.7.3.2

