Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935139Ab2JXOrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:47:12 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43786 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935060Ab2JXOpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:45:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/6] pinctrl: Update clock handling for the pinctrl-nomadik GPIO driver
Date: Wed, 24 Oct 2012 15:45:22 +0100
Message-Id: <1351089926-32161-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock framework has changed somewhat and it's now better to
invoke clock_prepare_enable() and clk_disable_unprepare() rather
than the legacy clk_enable() and clk_disable() calls. This patch
converts the Nomadik Pin Control driver to the new framework.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c |   96 ++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 01aea1c..570c753 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -448,7 +448,7 @@ static void nmk_gpio_glitch_slpm_init(unsigned int *slpm)
 		if (!chip)
 			break;
 
-		clk_enable(chip->clk);
+		clk_prepare_enable(chip->clk);
 
 		slpm[i] = readl(chip->addr + NMK_GPIO_SLPC);
 		writel(temp, chip->addr + NMK_GPIO_SLPC);
@@ -467,7 +467,7 @@ static void nmk_gpio_glitch_slpm_restore(unsigned int *slpm)
 
 		writel(slpm[i], chip->addr + NMK_GPIO_SLPC);
 
-		clk_disable(chip->clk);
+		clk_disable_unprepare(chip->clk);
 	}
 }
 
@@ -512,12 +512,12 @@ static int __nmk_config_pins(pin_cfg_t *cfgs, int num, bool sleep)
 			break;
 		}
 
-		clk_enable(nmk_chip->clk);
+		clk_prepare_enable(nmk_chip->clk);
 		spin_lock(&nmk_chip->lock);
 		__nmk_config_pin(nmk_chip, pin % NMK_GPIO_PER_CHIP,
 				 cfgs[i], sleep, glitch ? slpm : NULL);
 		spin_unlock(&nmk_chip->lock);
-		clk_disable(nmk_chip->clk);
+		clk_disable_unprepare(nmk_chip->clk);
 	}
 
 	if (glitch)
@@ -602,7 +602,7 @@ int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode)
 	if (!nmk_chip)
 		return -EINVAL;
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
 	spin_lock(&nmk_chip->lock);
 
@@ -610,7 +610,7 @@ int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode)
 
 	spin_unlock(&nmk_chip->lock);
 	spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 
 	return 0;
 }
@@ -637,11 +637,11 @@ int nmk_gpio_set_pull(int gpio, enum nmk_gpio_pull pull)
 	if (!nmk_chip)
 		return -EINVAL;
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_chip->lock, flags);
 	__nmk_gpio_set_pull(nmk_chip, gpio % NMK_GPIO_PER_CHIP, pull);
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 
 	return 0;
 }
@@ -665,11 +665,11 @@ int nmk_gpio_set_mode(int gpio, int gpio_mode)
 	if (!nmk_chip)
 		return -EINVAL;
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_chip->lock, flags);
 	__nmk_gpio_set_mode(nmk_chip, gpio % NMK_GPIO_PER_CHIP, gpio_mode);
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 
 	return 0;
 }
@@ -686,12 +686,12 @@ int nmk_gpio_get_mode(int gpio)
 
 	bit = 1 << (gpio % NMK_GPIO_PER_CHIP);
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 
 	afunc = readl(nmk_chip->addr + NMK_GPIO_AFSLA) & bit;
 	bfunc = readl(nmk_chip->addr + NMK_GPIO_AFSLB) & bit;
 
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 
 	return (afunc ? NMK_GPIO_ALT_A : 0) | (bfunc ? NMK_GPIO_ALT_B : 0);
 }
@@ -712,9 +712,9 @@ static void nmk_gpio_irq_ack(struct irq_data *d)
 	if (!nmk_chip)
 		return;
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 	writel(nmk_gpio_get_bitmask(d->hwirq), nmk_chip->addr + NMK_GPIO_IC);
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 }
 
 enum nmk_gpio_irq_type {
@@ -788,7 +788,7 @@ static int nmk_gpio_irq_maskunmask(struct irq_data *d, bool enable)
 	if (!nmk_chip)
 		return -EINVAL;
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
 	spin_lock(&nmk_chip->lock);
 
@@ -799,7 +799,7 @@ static int nmk_gpio_irq_maskunmask(struct irq_data *d, bool enable)
 
 	spin_unlock(&nmk_chip->lock);
 	spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 
 	return 0;
 }
@@ -825,7 +825,7 @@ static int nmk_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 		return -EINVAL;
 	bitmask = nmk_gpio_get_bitmask(d->hwirq);
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
 	spin_lock(&nmk_chip->lock);
 
@@ -839,7 +839,7 @@ static int nmk_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 
 	spin_unlock(&nmk_chip->lock);
 	spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 
 	return 0;
 }
@@ -861,7 +861,7 @@ static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	if (type & IRQ_TYPE_LEVEL_LOW)
 		return -EINVAL;
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 	spin_lock_irqsave(&nmk_chip->lock, flags);
 
 	if (enabled)
@@ -885,7 +885,7 @@ static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		__nmk_gpio_irq_modify(nmk_chip, d->hwirq, WAKE, true);
 
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 
 	return 0;
 }
@@ -894,7 +894,7 @@ static unsigned int nmk_gpio_irq_startup(struct irq_data *d)
 {
 	struct nmk_gpio_chip *nmk_chip = irq_data_get_irq_chip_data(d);
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 	nmk_gpio_irq_unmask(d);
 	return 0;
 }
@@ -904,7 +904,7 @@ static void nmk_gpio_irq_shutdown(struct irq_data *d)
 	struct nmk_gpio_chip *nmk_chip = irq_data_get_irq_chip_data(d);
 
 	nmk_gpio_irq_mask(d);
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 }
 
 static struct irq_chip nmk_gpio_irq_chip = {
@@ -943,9 +943,9 @@ static void nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	struct nmk_gpio_chip *nmk_chip = irq_get_handler_data(irq);
 	u32 status;
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 	status = readl(nmk_chip->addr + NMK_GPIO_IS);
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 
 	__nmk_gpio_irq_handler(irq, desc, status);
 }
@@ -998,11 +998,11 @@ static int nmk_gpio_make_input(struct gpio_chip *chip, unsigned offset)
 	struct nmk_gpio_chip *nmk_chip =
 		container_of(chip, struct nmk_gpio_chip, chip);
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 
 	writel(1 << offset, nmk_chip->addr + NMK_GPIO_DIRC);
 
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 
 	return 0;
 }
@@ -1014,11 +1014,11 @@ static int nmk_gpio_get_input(struct gpio_chip *chip, unsigned offset)
 	u32 bit = 1 << offset;
 	int value;
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 
 	value = (readl(nmk_chip->addr + NMK_GPIO_DAT) & bit) != 0;
 
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 
 	return value;
 }
@@ -1029,11 +1029,11 @@ static void nmk_gpio_set_output(struct gpio_chip *chip, unsigned offset,
 	struct nmk_gpio_chip *nmk_chip =
 		container_of(chip, struct nmk_gpio_chip, chip);
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 
 	__nmk_gpio_set_output(nmk_chip, offset, val);
 
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 }
 
 static int nmk_gpio_make_output(struct gpio_chip *chip, unsigned offset,
@@ -1042,11 +1042,11 @@ static int nmk_gpio_make_output(struct gpio_chip *chip, unsigned offset,
 	struct nmk_gpio_chip *nmk_chip =
 		container_of(chip, struct nmk_gpio_chip, chip);
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 
 	__nmk_gpio_make_output(nmk_chip, offset, val);
 
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 
 	return 0;
 }
@@ -1080,7 +1080,7 @@ static void nmk_gpio_dbg_show_one(struct seq_file *s, struct gpio_chip *chip,
 		[NMK_GPIO_ALT_C]	= "altC",
 	};
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 	is_out = !!(readl(nmk_chip->addr + NMK_GPIO_DIR) & bit);
 	pull = !(readl(nmk_chip->addr + NMK_GPIO_PDIS) & bit);
 	mode = nmk_gpio_get_mode(gpio);
@@ -1118,7 +1118,7 @@ static void nmk_gpio_dbg_show_one(struct seq_file *s, struct gpio_chip *chip,
 				   ? " wakeup" : "");
 		}
 	}
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 }
 
 static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
@@ -1164,7 +1164,7 @@ void nmk_gpio_clocks_enable(void)
 		if (!chip)
 			continue;
 
-		clk_enable(chip->clk);
+		clk_prepare_enable(chip->clk);
 	}
 }
 
@@ -1178,7 +1178,7 @@ void nmk_gpio_clocks_disable(void)
 		if (!chip)
 			continue;
 
-		clk_disable(chip->clk);
+		clk_disable_unprepare(chip->clk);
 	}
 }
 
@@ -1201,14 +1201,14 @@ void nmk_gpio_wakeups_suspend(void)
 		if (!chip)
 			break;
 
-		clk_enable(chip->clk);
+		clk_prepare_enable(chip->clk);
 
 		writel(chip->rwimsc & chip->real_wake,
 		       chip->addr + NMK_GPIO_RWIMSC);
 		writel(chip->fwimsc & chip->real_wake,
 		       chip->addr + NMK_GPIO_FWIMSC);
 
-		clk_disable(chip->clk);
+		clk_disable_unprepare(chip->clk);
 	}
 }
 
@@ -1222,12 +1222,12 @@ void nmk_gpio_wakeups_resume(void)
 		if (!chip)
 			break;
 
-		clk_enable(chip->clk);
+		clk_prepare_enable(chip->clk);
 
 		writel(chip->rwimsc, chip->addr + NMK_GPIO_RWIMSC);
 		writel(chip->fwimsc, chip->addr + NMK_GPIO_FWIMSC);
 
-		clk_disable(chip->clk);
+		clk_disable_unprepare(chip->clk);
 	}
 }
 
@@ -1367,9 +1367,9 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	chip->dev = &dev->dev;
 	chip->owner = THIS_MODULE;
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 	nmk_chip->lowemi = readl_relaxed(nmk_chip->addr + NMK_GPIO_LOWEMI);
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 
 #ifdef CONFIG_OF_GPIO
 	chip->of_node = np;
@@ -1580,7 +1580,7 @@ static int nmk_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
 		nmk_chip = container_of(chip, struct nmk_gpio_chip, chip);
 		dev_dbg(npct->dev, "setting pin %d to altsetting %d\n", g->pins[i], g->altsetting);
 
-		clk_enable(nmk_chip->clk);
+		clk_prepare_enable(nmk_chip->clk);
 		bit = g->pins[i] % NMK_GPIO_PER_CHIP;
 		/*
 		 * If the pin is switching to altfunc, and there was an
@@ -1593,7 +1593,7 @@ static int nmk_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
 
 		__nmk_gpio_set_mode_safe(nmk_chip, bit,
 			(g->altsetting & NMK_GPIO_ALT_C), glitch);
-		clk_disable(nmk_chip->clk);
+		clk_disable_unprepare(nmk_chip->clk);
 
 		/*
 		 * Call PRCM GPIOCR config function in case ALTC
@@ -1657,11 +1657,11 @@ int nmk_gpio_request_enable(struct pinctrl_dev *pctldev,
 
 	dev_dbg(npct->dev, "enable pin %u as GPIO\n", offset);
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 	bit = offset % NMK_GPIO_PER_CHIP;
 	/* There is no glitch when converting any pin to GPIO */
 	__nmk_gpio_set_mode(nmk_chip, bit, NMK_GPIO_ALT_GPIO);
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 
 	return 0;
 }
@@ -1773,7 +1773,7 @@ int nmk_pin_config_set(struct pinctrl_dev *pctldev,
 		output ? (val ? "high" : "low") : "",
 		lowemi ? "on" : "off" );
 
-	clk_enable(nmk_chip->clk);
+	clk_prepare_enable(nmk_chip->clk);
 	bit = pin % NMK_GPIO_PER_CHIP;
 	if (gpiomode)
 		/* No glitch when going to GPIO mode */
@@ -1788,7 +1788,7 @@ int nmk_pin_config_set(struct pinctrl_dev *pctldev,
 	__nmk_gpio_set_lowemi(nmk_chip, bit, lowemi);
 
 	__nmk_gpio_set_slpm(nmk_chip, bit, slpm);
-	clk_disable(nmk_chip->clk);
+	clk_disable_unprepare(nmk_chip->clk);
 	return 0;
 }
 
-- 
1.7.9.5

