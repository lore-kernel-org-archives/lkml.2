Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab2JTKWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 06:22:30 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:51756 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754883Ab2JTKW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 06:22:27 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 5/5 v6] gpio: Add block gpio to several gpio drivers
Date: Sat, 20 Oct 2012 12:21:48 +0200
Message-Id: <1350728508-22508-6-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350728508-22508-1-git-send-email-stigge@antcom.de>
References: <1350728508-22508-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds block GPIO support to several gpio drivers.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/gpio/gpio-em.c      |   23 ++++++++++++
 drivers/gpio/gpio-generic.c |   56 ++++++++++++++++++++++++++++++
 drivers/gpio/gpio-lpc32xx.c |   82 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/gpio-max730x.c |   61 ++++++++++++++++++++++++++++++++
 drivers/gpio/gpio-max732x.c |   59 +++++++++++++++++++++++++++++++
 drivers/gpio/gpio-pca953x.c |   64 ++++++++++++++++++++++++++++++++++
 drivers/gpio/gpio-pcf857x.c |   24 ++++++++++++
 drivers/gpio/gpio-pch.c     |   27 ++++++++++++++
 drivers/gpio/gpio-pl061.c   |   17 +++++++++
 drivers/gpio/gpio-twl6040.c |   32 +++++++++++++++++
 drivers/gpio/gpio-ucb1400.c |   23 ++++++++++++
 drivers/gpio/gpio-vt8500.c  |   24 ++++++++++++
 drivers/gpio/gpio-xilinx.c  |   44 +++++++++++++++++++++++
 13 files changed, 536 insertions(+)

--- linux-2.6.orig/drivers/gpio/gpio-em.c
+++ linux-2.6/drivers/gpio/gpio-em.c
@@ -203,6 +203,27 @@ static void em_gio_set(struct gpio_chip
 		__em_gio_set(chip, GIO_OH, offset - 16, value);
 }
 
+static unsigned long em_gio_get_block(struct gpio_chip *chip,
+				      unsigned long mask)
+{
+	return (int)(em_gio_read(gpio_to_priv(chip), GIO_I) & mask);
+}
+
+static void em_gio_set_block(struct gpio_chip *chip, unsigned long mask,
+			     unsigned long values)
+{
+	unsigned long mask_ol = mask & 0xFFFF;
+	unsigned long mask_oh = mask >> 16;
+
+	unsigned long values_ol = values & mask_ol;
+	unsigned long values_oh = (values >> 16) & mask_oh;
+
+	em_gio_write(gpio_to_priv(chip), GIO_OL,
+		     mask_ol << 16 | values_ol);
+	em_gio_write(gpio_to_priv(chip), GIO_OH,
+		     mask_oh << 16 | values_oh);
+}
+
 static int em_gio_direction_output(struct gpio_chip *chip, unsigned offset,
 				   int value)
 {
@@ -317,8 +338,10 @@ static int __devinit em_gio_probe(struct
 	gpio_chip = &p->gpio_chip;
 	gpio_chip->direction_input = em_gio_direction_input;
 	gpio_chip->get = em_gio_get;
+	gpio_chip->get_block = em_gio_get_block;
 	gpio_chip->direction_output = em_gio_direction_output;
 	gpio_chip->set = em_gio_set;
+	gpio_chip->set_block = em_gio_set_block;
 	gpio_chip->to_irq = em_gio_to_irq;
 	gpio_chip->label = name;
 	gpio_chip->owner = THIS_MODULE;
--- linux-2.6.orig/drivers/gpio/gpio-generic.c
+++ linux-2.6/drivers/gpio/gpio-generic.c
@@ -122,6 +122,13 @@ static int bgpio_get(struct gpio_chip *g
 	return bgc->read_reg(bgc->reg_dat) & bgc->pin2mask(bgc, gpio);
 }
 
+static unsigned long bgpio_get_block(struct gpio_chip *gc, unsigned long mask)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+
+	return bgc->read_reg(bgc->reg_dat) & mask;
+}
+
 static void bgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 {
 	struct bgpio_chip *bgc = to_bgpio_chip(gc);
@@ -170,6 +177,51 @@ static void bgpio_set_set(struct gpio_ch
 	spin_unlock_irqrestore(&bgc->lock, flags);
 }
 
+static void bgpio_set_block(struct gpio_chip *gc, unsigned long mask,
+			    unsigned long values)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	bgc->data &= ~mask;
+	bgc->data |= values & mask;
+
+	bgc->write_reg(bgc->reg_dat, bgc->data);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
+static void bgpio_set_with_clear_block(struct gpio_chip *gc, unsigned long mask,
+				       unsigned long values)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long set_bits = values & mask;
+	unsigned long clr_bits = ~values & mask;
+
+	if (set_bits)
+		bgc->write_reg(bgc->reg_set, set_bits);
+	if (clr_bits)
+		bgc->write_reg(bgc->reg_set, clr_bits);
+}
+
+static void bgpio_set_set_block(struct gpio_chip *gc, unsigned long mask,
+				unsigned long values)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	bgc->data &= ~mask;
+	bgc->data |= values & mask;
+
+	bgc->write_reg(bgc->reg_set, bgc->data);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
 static int bgpio_simple_dir_in(struct gpio_chip *gc, unsigned int gpio)
 {
 	return 0;
@@ -317,14 +369,18 @@ static int bgpio_setup_io(struct bgpio_c
 		bgc->reg_set = set;
 		bgc->reg_clr = clr;
 		bgc->gc.set = bgpio_set_with_clear;
+		bgc->gc.set_block = bgpio_set_with_clear_block;
 	} else if (set && !clr) {
 		bgc->reg_set = set;
 		bgc->gc.set = bgpio_set_set;
+		bgc->gc.set_block = bgpio_set_set_block;
 	} else {
 		bgc->gc.set = bgpio_set;
+		bgc->gc.set_block = bgpio_set_block;
 	}
 
 	bgc->gc.get = bgpio_get;
+	bgc->gc.get_block = bgpio_get_block;
 
 	return 0;
 }
--- linux-2.6.orig/drivers/gpio/gpio-lpc32xx.c
+++ linux-2.6/drivers/gpio/gpio-lpc32xx.c
@@ -297,6 +297,22 @@ static int lpc32xx_gpio_get_value_p3(str
 	return __get_gpio_state_p3(group, pin);
 }
 
+static unsigned long lpc32xx_gpio_get_block_p3(struct gpio_chip *chip,
+					       unsigned long mask)
+{
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+	u32 bits = __raw_readl(group->gpio_grp->inp_state);
+
+	/* In P3_INP_STATE, the 6 GPIOs are scattered over the register,
+	 * rearranging to bits 0-5
+	 */
+	bits >>= 10;
+	bits &= 0x401F;
+	bits |= (bits & 0x4000) >> 9;
+
+	return bits & mask & 0x3F;
+}
+
 static int lpc32xx_gpi_get_value(struct gpio_chip *chip, unsigned pin)
 {
 	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
@@ -304,6 +320,15 @@ static int lpc32xx_gpi_get_value(struct
 	return __get_gpi_state_p3(group, pin);
 }
 
+static unsigned long lpc32xx_gpi_get_block(struct gpio_chip *chip,
+					   unsigned long mask)
+{
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+	u32 bits = __raw_readl(group->gpio_grp->inp_state);
+
+	return bits & mask;
+}
+
 static int lpc32xx_gpio_dir_output_p012(struct gpio_chip *chip, unsigned pin,
 	int value)
 {
@@ -351,6 +376,27 @@ static void lpc32xx_gpio_set_value_p3(st
 	__set_gpio_level_p3(group, pin, value);
 }
 
+static void lpc32xx_gpio_set_block_p3(struct gpio_chip *chip,
+				      unsigned long mask,
+				      unsigned long values)
+{
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+	u32 set_bits = values & mask;
+	u32 clr_bits = ~values & mask;
+
+	/* States of GPIO 0-5 start at bit 25 */
+	set_bits <<= 25;
+	clr_bits <<= 25;
+
+	/* Note: On LPC32xx, GPOs can only be set at once or cleared at once,
+	 *       but not set and cleared at once
+	 */
+	if (set_bits)
+		__raw_writel(set_bits, group->gpio_grp->outp_set);
+	if (clr_bits)
+		__raw_writel(clr_bits, group->gpio_grp->outp_clr);
+}
+
 static void lpc32xx_gpo_set_value(struct gpio_chip *chip, unsigned pin,
 	int value)
 {
@@ -366,6 +412,31 @@ static int lpc32xx_gpo_get_value(struct
 	return __get_gpo_state_p3(group, pin);
 }
 
+static void lpc32xx_gpo_set_block(struct gpio_chip *chip, unsigned long mask,
+				  unsigned long values)
+{
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+	u32 set_bits = values & mask;
+	u32 clr_bits = ~values & mask;
+
+	/* Note: On LPC32xx, GPOs can only be set at once or cleared at once,
+	 *       but not set and cleared at once
+	 */
+	if (set_bits)
+		__raw_writel(set_bits, group->gpio_grp->outp_set);
+	if (clr_bits)
+		__raw_writel(clr_bits, group->gpio_grp->outp_clr);
+}
+
+static unsigned long lpc32xx_gpo_get_block(struct gpio_chip *chip,
+					   unsigned long mask)
+{
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+	u32 bits = __raw_readl(group->gpio_grp->outp_state);
+
+	return bits & mask;
+}
+
 static int lpc32xx_gpio_request(struct gpio_chip *chip, unsigned pin)
 {
 	if (pin < chip->ngpio)
@@ -440,8 +511,10 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpio_p0",
 			.direction_input	= lpc32xx_gpio_dir_input_p012,
 			.get			= lpc32xx_gpio_get_value_p012,
+			.get_block		= lpc32xx_gpi_get_block,
 			.direction_output	= lpc32xx_gpio_dir_output_p012,
 			.set			= lpc32xx_gpio_set_value_p012,
+			.set_block		= lpc32xx_gpo_set_block,
 			.request		= lpc32xx_gpio_request,
 			.to_irq			= lpc32xx_gpio_to_irq_p01,
 			.base			= LPC32XX_GPIO_P0_GRP,
@@ -456,8 +529,10 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpio_p1",
 			.direction_input	= lpc32xx_gpio_dir_input_p012,
 			.get			= lpc32xx_gpio_get_value_p012,
+			.get_block		= lpc32xx_gpi_get_block,
 			.direction_output	= lpc32xx_gpio_dir_output_p012,
 			.set			= lpc32xx_gpio_set_value_p012,
+			.set_block		= lpc32xx_gpo_set_block,
 			.request		= lpc32xx_gpio_request,
 			.to_irq			= lpc32xx_gpio_to_irq_p01,
 			.base			= LPC32XX_GPIO_P1_GRP,
@@ -472,8 +547,10 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpio_p2",
 			.direction_input	= lpc32xx_gpio_dir_input_p012,
 			.get			= lpc32xx_gpio_get_value_p012,
+			.get_block		= lpc32xx_gpi_get_block,
 			.direction_output	= lpc32xx_gpio_dir_output_p012,
 			.set			= lpc32xx_gpio_set_value_p012,
+			.set_block		= lpc32xx_gpo_set_block,
 			.request		= lpc32xx_gpio_request,
 			.base			= LPC32XX_GPIO_P2_GRP,
 			.ngpio			= LPC32XX_GPIO_P2_MAX,
@@ -487,8 +564,10 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpio_p3",
 			.direction_input	= lpc32xx_gpio_dir_input_p3,
 			.get			= lpc32xx_gpio_get_value_p3,
+			.get_block		= lpc32xx_gpio_get_block_p3,
 			.direction_output	= lpc32xx_gpio_dir_output_p3,
 			.set			= lpc32xx_gpio_set_value_p3,
+			.set_block		= lpc32xx_gpio_set_block_p3,
 			.request		= lpc32xx_gpio_request,
 			.to_irq			= lpc32xx_gpio_to_irq_gpio_p3,
 			.base			= LPC32XX_GPIO_P3_GRP,
@@ -503,6 +582,7 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpi_p3",
 			.direction_input	= lpc32xx_gpio_dir_in_always,
 			.get			= lpc32xx_gpi_get_value,
+			.get_block		= lpc32xx_gpi_get_block,
 			.request		= lpc32xx_gpio_request,
 			.to_irq			= lpc32xx_gpio_to_irq_gpi_p3,
 			.base			= LPC32XX_GPI_P3_GRP,
@@ -517,7 +597,9 @@ static struct lpc32xx_gpio_chip lpc32xx_
 			.label			= "gpo_p3",
 			.direction_output	= lpc32xx_gpio_dir_out_always,
 			.set			= lpc32xx_gpo_set_value,
+			.set_block		= lpc32xx_gpo_set_block,
 			.get			= lpc32xx_gpo_get_value,
+			.get_block		= lpc32xx_gpo_get_block,
 			.request		= lpc32xx_gpio_request,
 			.base			= LPC32XX_GPO_P3_GRP,
 			.ngpio			= LPC32XX_GPO_P3_MAX,
--- linux-2.6.orig/drivers/gpio/gpio-max730x.c
+++ linux-2.6/drivers/gpio/gpio-max730x.c
@@ -146,6 +146,44 @@ static int max7301_get(struct gpio_chip
 	return level;
 }
 
+static unsigned long max7301_get_block(struct gpio_chip *chip,
+				       unsigned long mask)
+{
+	struct max7301 *ts = container_of(chip, struct max7301, chip);
+	int i, j;
+	unsigned long result = 0;
+
+	for (i = 0; i < 4; i++) {
+		if ((mask >> (i * 8)) & 0xFF) { /* i/o only if necessary */
+			u8 in_level = ts->read(ts->dev, 0x44 + i * 8);
+			u8 in_mask = 0;
+			u8 out_level = (ts->out_level >> (i * 8 + 4)) & 0xFF;
+			u8 out_mask = 0;
+
+			for (j = 0; j < 8; j++) {
+				int offset = 4 + i * 8 + j;
+				int config = (ts->port_config[offset >> 2] >>
+					      ((offset & 3) << 1)) &
+					PIN_CONFIG_MASK;
+
+				switch (config) {
+				case PIN_CONFIG_OUT:
+					out_mask |= BIT(j);
+					break;
+				case PIN_CONFIG_IN_WO_PULLUP:
+				case PIN_CONFIG_IN_PULLUP:
+					in_mask |= BIT(j);
+				}
+			}
+
+			result |= ((unsigned long)(in_level & in_mask) |
+				   (out_level & out_mask)) << (i * 8);
+		}
+	}
+
+	return result & mask;
+}
+
 static void max7301_set(struct gpio_chip *chip, unsigned offset, int value)
 {
 	struct max7301 *ts = container_of(chip, struct max7301, chip);
@@ -160,6 +198,27 @@ static void max7301_set(struct gpio_chip
 	mutex_unlock(&ts->lock);
 }
 
+static void max7301_set_block(struct gpio_chip *chip, unsigned long mask,
+			      unsigned long values)
+{
+	struct max7301 *ts = container_of(chip, struct max7301, chip);
+	unsigned long changes;
+	int i;
+
+	mutex_lock(&ts->lock);
+
+	changes = (ts->out_level ^ (values << 4)) & (mask << 4);
+	ts->out_level ^= changes;
+
+	for (i = 0; i < 4; i++) {
+		if ((changes >> (i * 8 + 4)) & 0xFF) /* i/o only on change */
+			ts->write(ts->dev, 0x44 + i * 8,
+				  (ts->out_level >> (i * 8 + 4)) & 0xFF);
+	}
+
+	mutex_unlock(&ts->lock);
+}
+
 int __devinit __max730x_probe(struct max7301 *ts)
 {
 	struct device *dev = ts->dev;
@@ -183,8 +242,10 @@ int __devinit __max730x_probe(struct max
 
 	ts->chip.direction_input = max7301_direction_input;
 	ts->chip.get = max7301_get;
+	ts->chip.get_block = max7301_get_block;
 	ts->chip.direction_output = max7301_direction_output;
 	ts->chip.set = max7301_set;
+	ts->chip.set_block = max7301_set_block;
 
 	ts->chip.base = pdata->base;
 	ts->chip.ngpio = PIN_NUMBER;
--- linux-2.6.orig/drivers/gpio/gpio-max732x.c
+++ linux-2.6/drivers/gpio/gpio-max732x.c
@@ -219,6 +219,63 @@ out:
 	mutex_unlock(&chip->lock);
 }
 
+static unsigned long max732x_gpio_get_block(struct gpio_chip *gc,
+					    unsigned long mask)
+{
+	struct max732x_chip *chip;
+	uint8_t lo = 0;
+	uint8_t hi = 0;
+	int ret;
+
+	chip = container_of(gc, struct max732x_chip, gpio_chip);
+
+	if (mask & 0xFF) {
+		ret = max732x_readb(chip, is_group_a(chip, 0), &lo);
+		if (ret < 0)
+			return 0;
+	}
+	if (mask & 0xFF00) {
+		ret = max732x_readb(chip, is_group_a(chip, 8), &hi);
+		if (ret < 0)
+			return 0;
+	}
+
+	return (((unsigned long)hi << 8) | lo) & mask;
+}
+
+static void max732x_gpio_set_block(struct gpio_chip *gc, unsigned long mask,
+				   unsigned long values)
+{
+	struct max732x_chip *chip;
+	uint8_t reg_out;
+	uint8_t lo_mask = mask & 0xFF;
+	uint8_t hi_mask = (mask >> 8) & 0xFF;
+	int ret;
+
+	chip = container_of(gc, struct max732x_chip, gpio_chip);
+
+	mutex_lock(&chip->lock);
+
+	if (lo_mask) {
+		reg_out = (chip->reg_out[0] & ~lo_mask) | (values & lo_mask);
+		ret = max732x_writeb(chip, is_group_a(chip, 0), reg_out);
+		if (ret < 0)
+			goto out;
+		chip->reg_out[0] = reg_out;
+	}
+	if (hi_mask) {
+		reg_out = (chip->reg_out[1] & ~hi_mask) |
+			((values >> 8) & hi_mask);
+		ret = max732x_writeb(chip, is_group_a(chip, 8), reg_out);
+		if (ret < 0)
+			goto out;
+		chip->reg_out[1] = reg_out;
+	}
+
+out:
+	mutex_unlock(&chip->lock);
+}
+
 static int max732x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
 {
 	struct max732x_chip *chip;
@@ -562,8 +619,10 @@ static int __devinit max732x_setup_gpio(
 	if (chip->dir_output) {
 		gc->direction_output = max732x_gpio_direction_output;
 		gc->set = max732x_gpio_set_value;
+		gc->set_block = max732x_gpio_set_block;
 	}
 	gc->get = max732x_gpio_get_value;
+	gc->get_block = max732x_gpio_get_block;
 	gc->can_sleep = 1;
 
 	gc->base = gpio_start;
--- linux-2.6.orig/drivers/gpio/gpio-pca953x.c
+++ linux-2.6/drivers/gpio/gpio-pca953x.c
@@ -300,6 +300,68 @@ exit:
 	mutex_unlock(&chip->i2c_lock);
 }
 
+static unsigned long pca953x_gpio_get_block(struct gpio_chip *gc,
+					    unsigned long mask)
+{
+	struct pca953x_chip *chip;
+	u32 reg_val;
+	int ret, offset = 0;
+
+	chip = container_of(gc, struct pca953x_chip, gpio_chip);
+
+	mutex_lock(&chip->i2c_lock);
+	switch (chip->chip_type) {
+	case PCA953X_TYPE:
+		offset = PCA953X_INPUT;
+		break;
+	case PCA957X_TYPE:
+		offset = PCA957X_IN;
+		break;
+	}
+	ret = pca953x_read_reg(chip, offset, &reg_val);
+	mutex_unlock(&chip->i2c_lock);
+	if (ret < 0) {
+		/* NOTE:  diagnostic already emitted; that's all we should
+		 * do unless gpio_*_value_cansleep() calls become different
+		 * from their nonsleeping siblings (and report faults).
+		 */
+		return 0;
+	}
+
+	return reg_val & mask;
+}
+
+static void pca953x_gpio_set_block(struct gpio_chip *gc, unsigned long mask,
+				   unsigned long values)
+{
+	struct pca953x_chip *chip;
+	u32 reg_val;
+	int ret, offset = 0;
+
+	chip = container_of(gc, struct pca953x_chip, gpio_chip);
+
+	mutex_lock(&chip->i2c_lock);
+
+	reg_val = chip->reg_output & ~mask;
+	reg_val |= values & mask;
+
+	switch (chip->chip_type) {
+	case PCA953X_TYPE:
+		offset = PCA953X_OUTPUT;
+		break;
+	case PCA957X_TYPE:
+		offset = PCA957X_OUT;
+		break;
+	}
+	ret = pca953x_write_reg(chip, offset, reg_val);
+	if (ret)
+		goto exit;
+
+	chip->reg_output = reg_val;
+exit:
+	mutex_unlock(&chip->i2c_lock);
+}
+
 static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 {
 	struct gpio_chip *gc;
@@ -310,6 +372,8 @@ static void pca953x_setup_gpio(struct pc
 	gc->direction_output = pca953x_gpio_direction_output;
 	gc->get = pca953x_gpio_get_value;
 	gc->set = pca953x_gpio_set_value;
+	gc->get_block = pca953x_gpio_get_block;
+	gc->set_block = pca953x_gpio_set_block;
 	gc->can_sleep = 1;
 
 	gc->base = chip->gpio_start;
--- linux-2.6.orig/drivers/gpio/gpio-pcf857x.c
+++ linux-2.6/drivers/gpio/gpio-pcf857x.c
@@ -158,6 +158,28 @@ static void pcf857x_set(struct gpio_chip
 	pcf857x_output(chip, offset, value);
 }
 
+static unsigned long pcf857x_get_block(struct gpio_chip *chip,
+				       unsigned long mask)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	int		value;
+
+	value = gpio->read(gpio->client);
+	return (value < 0) ? 0 : (value & mask);
+}
+
+static void pcf857x_set_block(struct gpio_chip *chip, unsigned long mask,
+			      unsigned long values)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+
+	mutex_lock(&gpio->lock);
+	gpio->out &= ~mask;
+	gpio->out |= values & mask;
+	gpio->write(gpio->client, gpio->out);
+	mutex_unlock(&gpio->lock);
+}
+
 /*-------------------------------------------------------------------------*/
 
 static int pcf857x_to_irq(struct gpio_chip *chip, unsigned offset)
@@ -280,6 +302,8 @@ static int pcf857x_probe(struct i2c_clie
 	gpio->chip.owner		= THIS_MODULE;
 	gpio->chip.get			= pcf857x_get;
 	gpio->chip.set			= pcf857x_set;
+	gpio->chip.get_block		= pcf857x_get_block;
+	gpio->chip.set_block		= pcf857x_set_block;
 	gpio->chip.direction_input	= pcf857x_input;
 	gpio->chip.direction_output	= pcf857x_output;
 	gpio->chip.ngpio		= id->driver_data;
--- linux-2.6.orig/drivers/gpio/gpio-pch.c
+++ linux-2.6/drivers/gpio/gpio-pch.c
@@ -122,6 +122,23 @@ static void pch_gpio_set(struct gpio_chi
 	spin_unlock_irqrestore(&chip->spinlock, flags);
 }
 
+static void pch_gpio_set_block(struct gpio_chip *gpio, unsigned long mask,
+			       unsigned long values)
+{
+	u32 reg_val;
+	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->spinlock, flags);
+	reg_val = ioread32(&chip->reg->po);
+
+	reg_val &= ~mask;
+	reg_val |= values & mask;
+
+	iowrite32(reg_val, &chip->reg->po);
+	spin_unlock_irqrestore(&chip->spinlock, flags);
+}
+
 static int pch_gpio_get(struct gpio_chip *gpio, unsigned nr)
 {
 	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
@@ -129,6 +146,14 @@ static int pch_gpio_get(struct gpio_chip
 	return ioread32(&chip->reg->pi) & (1 << nr);
 }
 
+static unsigned long pch_gpio_get_block(struct gpio_chip *gpio,
+					unsigned long mask)
+{
+	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
+
+	return ioread32(&chip->reg->pi) & mask;
+}
+
 static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 				     int val)
 {
@@ -218,8 +243,10 @@ static void pch_gpio_setup(struct pch_gp
 	gpio->owner = THIS_MODULE;
 	gpio->direction_input = pch_gpio_direction_input;
 	gpio->get = pch_gpio_get;
+	gpio->get_block = pch_gpio_get_block;
 	gpio->direction_output = pch_gpio_direction_output;
 	gpio->set = pch_gpio_set;
+	gpio->set_block = pch_gpio_set_block;
 	gpio->dbg_show = NULL;
 	gpio->base = -1;
 	gpio->ngpio = gpio_pins[chip->ioh];
--- linux-2.6.orig/drivers/gpio/gpio-pl061.c
+++ linux-2.6/drivers/gpio/gpio-pl061.c
@@ -123,6 +123,21 @@ static void pl061_set_value(struct gpio_
 	writeb(!!value << offset, chip->base + (1 << (offset + 2)));
 }
 
+static unsigned long pl061_get_block(struct gpio_chip *gc, unsigned long mask)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+
+	return !!readb(chip->base + (mask << 2));
+}
+
+static void pl061_set_block(struct gpio_chip *gc, unsigned long mask,
+			    unsigned long values)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+
+	writeb(values & mask, chip->base + (mask << 2));
+}
+
 static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
 {
 	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
@@ -256,6 +271,8 @@ static int pl061_probe(struct amba_devic
 	chip->gc.direction_output = pl061_direction_output;
 	chip->gc.get = pl061_get_value;
 	chip->gc.set = pl061_set_value;
+	chip->gc.get_block = pl061_get_block;
+	chip->gc.set_block = pl061_set_block;
 	chip->gc.to_irq = pl061_to_irq;
 	chip->gc.ngpio = PL061_GPIO_NR;
 	chip->gc.label = dev_name(&dev->dev);
--- linux-2.6.orig/drivers/gpio/gpio-twl6040.c
+++ linux-2.6/drivers/gpio/gpio-twl6040.c
@@ -46,6 +46,19 @@ static int twl6040gpo_get(struct gpio_ch
 	return (ret >> offset) & 1;
 }
 
+static unsigned long twl6040gpo_get_block(struct gpio_chip *chip,
+					  unsigned long mask)
+{
+	struct twl6040 *twl6040 = dev_get_drvdata(chip->dev->parent);
+	int ret = 0;
+
+	ret = twl6040_reg_read(twl6040, TWL6040_REG_GPOCTL);
+	if (ret < 0)
+		return 0;
+
+	return ret & mask;
+}
+
 static int twl6040gpo_direction_out(struct gpio_chip *chip, unsigned offset,
 				    int value)
 {
@@ -71,12 +84,31 @@ static void twl6040gpo_set(struct gpio_c
 	twl6040_reg_write(twl6040, TWL6040_REG_GPOCTL, gpoctl);
 }
 
+static void twl6040gpo_set_block(struct gpio_chip *chip, unsigned long mask,
+				 unsigned long values)
+{
+	struct twl6040 *twl6040 = dev_get_drvdata(chip->dev->parent);
+	int ret;
+	u8 gpoctl;
+
+	ret = twl6040_reg_read(twl6040, TWL6040_REG_GPOCTL);
+	if (ret < 0)
+		return;
+
+	gpoctl = ret & ~mask;
+	gpoctl |= values & mask;
+
+	twl6040_reg_write(twl6040, TWL6040_REG_GPOCTL, gpoctl);
+}
+
 static struct gpio_chip twl6040gpo_chip = {
 	.label			= "twl6040",
 	.owner			= THIS_MODULE,
 	.get			= twl6040gpo_get,
+	.get_block		= twl6040gpo_get_block,
 	.direction_output	= twl6040gpo_direction_out,
 	.set			= twl6040gpo_set,
+	.set_block		= twl6040gpo_set_block,
 	.can_sleep		= 1,
 };
 
--- linux-2.6.orig/drivers/gpio/gpio-ucb1400.c
+++ linux-2.6/drivers/gpio/gpio-ucb1400.c
@@ -45,6 +45,27 @@ static void ucb1400_gpio_set(struct gpio
 	ucb1400_gpio_set_value(gpio->ac97, off, val);
 }
 
+static unsigned long ucb1400_gpio_get_block(struct gpio_chip *gc,
+					    unsigned long mask)
+{
+	struct ucb1400_gpio *gpio;
+	gpio = container_of(gc, struct ucb1400_gpio, gc);
+	return ucb1400_reg_read(gpio->ac97, UCB_IO_DATA) & mask;
+}
+
+static void ucb1400_gpio_set_block(struct gpio_chip *gc, unsigned long mask,
+				   unsigned long values)
+{
+	struct ucb1400_gpio *gpio;
+	u16 tmp;
+	gpio = container_of(gc, struct ucb1400_gpio, gc);
+
+	tmp = ucb1400_reg_read(gpio->ac97, UCB_IO_DATA) & ~mask;
+	tmp |= values & mask;
+
+	ucb1400_reg_write(gpio->ac97, UCB_IO_DATA, tmp);
+}
+
 static int ucb1400_gpio_probe(struct platform_device *dev)
 {
 	struct ucb1400_gpio *ucb = dev->dev.platform_data;
@@ -66,6 +87,8 @@ static int ucb1400_gpio_probe(struct pla
 	ucb->gc.direction_output = ucb1400_gpio_dir_out;
 	ucb->gc.get = ucb1400_gpio_get;
 	ucb->gc.set = ucb1400_gpio_set;
+	ucb->gc.get_block = ucb1400_gpio_get_block;
+	ucb->gc.set_block = ucb1400_gpio_set_block;
 	ucb->gc.can_sleep = 1;
 
 	err = gpiochip_add(&ucb->gc);
--- linux-2.6.orig/drivers/gpio/gpio-vt8500.c
+++ linux-2.6/drivers/gpio/gpio-vt8500.c
@@ -209,6 +209,28 @@ static void vt8500_gpio_set_value(struct
 	writel_relaxed(val, vt8500_chip->base + vt8500_chip->regs->data_out);
 }
 
+static unsigned long vt8500_gpio_get_block(struct gpio_chip *chip,
+					   unsigned long mask)
+{
+	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
+
+	return readl_relaxed(vt8500_chip->base + vt8500_chip->regs->data_in) &
+								mask;
+}
+
+static void vt8500_gpio_set_block(struct gpio_chip *chip, unsigned long mask,
+				  unsigned long  values)
+{
+	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
+
+	u32 val = readl_relaxed(vt8500_chip->base +
+				vt8500_chip->regs->data_out);
+	val &= ~mask;
+	val |= values & mask;
+
+	writel_relaxed(val, vt8500_chip->base + vt8500_chip->regs->data_out);
+}
+
 static int vt8500_of_xlate(struct gpio_chip *gc,
 			    const struct of_phandle_args *gpiospec, u32 *flags)
 {
@@ -251,6 +273,8 @@ static int vt8500_add_chips(struct platf
 		chip->direction_output = vt8500_gpio_direction_output;
 		chip->get = vt8500_gpio_get_value;
 		chip->set = vt8500_gpio_set_value;
+		chip->get_block = vt8500_gpio_get_block;
+		chip->set_block = vt8500_gpio_set_block;
 		chip->can_sleep = 0;
 		chip->base = pin_cnt;
 		chip->ngpio = data->banks[i].ngpio;
--- linux-2.6.orig/drivers/gpio/gpio-xilinx.c
+++ linux-2.6/drivers/gpio/gpio-xilinx.c
@@ -49,6 +49,21 @@ static int xgpio_get(struct gpio_chip *g
 }
 
 /**
+ * xgpio_get_block - Read a block of specified signals of the GPIO device.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @mask:   Bit mask (bit 0 == 0th GPIO) for GPIOs to get
+ *
+ * This function reads a block of specified signal of the GPIO device, returned
+ * as a bit mask, each bit representing a GPIO
+ */
+static unsigned long xgpio_get_block(struct gpio_chip *gc, unsigned long mask)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+
+	return in_be32(mm_gc->regs + XGPIO_DATA_OFFSET) & mask;
+}
+
+/**
  * xgpio_set - Write the specified signal of the GPIO device.
  * @gc:     Pointer to gpio_chip device structure.
  * @gpio:   GPIO signal number.
@@ -77,6 +92,33 @@ static void xgpio_set(struct gpio_chip *
 }
 
 /**
+ * xgpio_set_block - Write a block of specified signals of the GPIO device.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @mask:   Bit mask (bit 0 == 0th GPIO) for GPIOs to set
+ * @values: Bit mapped values
+ *
+ * This function writes the specified values in to the specified signals of the
+ * GPIO device.
+ */
+static void xgpio_set_block(struct gpio_chip *gc, unsigned long mask,
+			    unsigned long values)
+{
+	unsigned long flags;
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct xgpio_instance *chip =
+	    container_of(mm_gc, struct xgpio_instance, mmchip);
+
+	spin_lock_irqsave(&chip->gpio_lock, flags);
+
+	chip->gpio_state &= ~mask;
+	chip->gpio_state |= mask & values;
+
+	out_be32(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+
+	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+}
+
+/**
  * xgpio_dir_in - Set the direction of the specified GPIO signal as input.
  * @gc:     Pointer to gpio_chip device structure.
  * @gpio:   GPIO signal number.
@@ -195,6 +237,8 @@ static int __devinit xgpio_of_probe(stru
 	chip->mmchip.gc.direction_output = xgpio_dir_out;
 	chip->mmchip.gc.get = xgpio_get;
 	chip->mmchip.gc.set = xgpio_set;
+	chip->mmchip.gc.get_block = xgpio_get_block;
+	chip->mmchip.gc.set_block = xgpio_set_block;
 
 	chip->mmchip.save_regs = xgpio_save_regs;
 
