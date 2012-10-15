Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab2JOJFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:05:08 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:55030 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866Ab2JOJFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:05:06 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/nomadik: debugfs display of other alternate-C functions
Date: Mon, 15 Oct 2012 11:04:30 +0200
Message-ID: <1350291870-3966-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>

In pinctrl debug pins file, enable display of AltCx functions.

Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 45 +++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 2bf6049..0a712c2 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -658,6 +658,35 @@ int nmk_gpio_set_mode(int gpio, int gpio_mode)
 }
 EXPORT_SYMBOL(nmk_gpio_set_mode);
 
+static int nmk_prcm_gpiocr_get_mode(struct pinctrl_dev *pctldev, int gpio)
+{
+	int i;
+	u16 reg;
+	u8 bit;
+	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
+	const struct prcm_gpiocr_altcx_pin_desc *pin_desc;
+	const u16 *gpiocr_regs;
+
+	for (i = 0; i < npct->soc->npins_altcx; i++) {
+		if (npct->soc->altcx_pins[i].pin == gpio)
+			break;
+	}
+	if (i == npct->soc->npins_altcx)
+		return NMK_GPIO_ALT_C;
+
+	pin_desc = npct->soc->altcx_pins + i;
+	gpiocr_regs = npct->soc->prcm_gpiocr_registers;
+	for (i = 0; i < PRCM_IDX_GPIOCR_ALTC_MAX; i++) {
+		if (pin_desc->altcx[i].used == true) {
+			reg = gpiocr_regs[pin_desc->altcx[i].reg_index];
+			bit = pin_desc->altcx[i].control_bit;
+			if (prcmu_read(reg) & BIT(bit))
+				return NMK_GPIO_ALT_C+i+1;
+		}
+	}
+	return NMK_GPIO_ALT_C;
+}
+
 int nmk_gpio_get_mode(int gpio)
 {
 	struct nmk_gpio_chip *nmk_chip;
@@ -1046,8 +1075,9 @@ static int nmk_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 
 #include <linux/seq_file.h>
 
-static void nmk_gpio_dbg_show_one(struct seq_file *s, struct gpio_chip *chip,
-				  unsigned offset, unsigned gpio)
+static void nmk_gpio_dbg_show_one(struct seq_file *s,
+	struct pinctrl_dev *pctldev, struct gpio_chip *chip,
+	unsigned offset, unsigned gpio)
 {
 	const char *label = gpiochip_is_requested(chip, offset);
 	struct nmk_gpio_chip *nmk_chip =
@@ -1061,12 +1091,18 @@ static void nmk_gpio_dbg_show_one(struct seq_file *s, struct gpio_chip *chip,
 		[NMK_GPIO_ALT_A]	= "altA",
 		[NMK_GPIO_ALT_B]	= "altB",
 		[NMK_GPIO_ALT_C]	= "altC",
+		[NMK_GPIO_ALT_C+1]	= "altC1",
+		[NMK_GPIO_ALT_C+2]	= "altC2",
+		[NMK_GPIO_ALT_C+3]	= "altC3",
+		[NMK_GPIO_ALT_C+4]	= "altC4",
 	};
 
 	clk_enable(nmk_chip->clk);
 	is_out = !!(readl(nmk_chip->addr + NMK_GPIO_DIR) & bit);
 	pull = !(readl(nmk_chip->addr + NMK_GPIO_PDIS) & bit);
 	mode = nmk_gpio_get_mode(gpio);
+	if ((mode == NMK_GPIO_ALT_C) && pctldev)
+		mode = nmk_prcm_gpiocr_get_mode(pctldev, gpio);
 
 	seq_printf(s, " gpio-%-3d (%-20.20s) %s %s %s %s",
 		   gpio, label ?: "(none)",
@@ -1110,13 +1146,14 @@ static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 	unsigned		gpio = chip->base;
 
 	for (i = 0; i < chip->ngpio; i++, gpio++) {
-		nmk_gpio_dbg_show_one(s, chip, i, gpio);
+		nmk_gpio_dbg_show_one(s, NULL, chip, i, gpio);
 		seq_printf(s, "\n");
 	}
 }
 
 #else
 static inline void nmk_gpio_dbg_show_one(struct seq_file *s,
+					 struct pinctrl_dev *pctldev,
 					 struct gpio_chip *chip,
 					 unsigned offset, unsigned gpio)
 {
@@ -1454,7 +1491,7 @@ static void nmk_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
 		return;
 	}
 	chip = range->gc;
-	nmk_gpio_dbg_show_one(s, chip, offset - chip->base, offset);
+	nmk_gpio_dbg_show_one(s, pctldev, chip, offset - chip->base, offset);
 }
 
 static struct pinctrl_ops nmk_pinctrl_ops = {
-- 
1.7.11.3

