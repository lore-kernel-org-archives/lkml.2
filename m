Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3AGWv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:51:57 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:41992 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab3AGWv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:51:56 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH V2 1/3] gpio: pca953x: make the register access by GPIO bank
Date: Mon,  7 Jan 2013 23:51:35 +0100
Message-Id: <1357599097-19053-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357599097-19053-1-git-send-email-gregory.clement@free-electrons.com>
References: <1357599097-19053-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now the pca953x driver accessed all the bank of a given register
in a single command using only a 32 bits variable. New expanders from
the pca53x family come with 40 GPIOs which no more fit in a 32
variable. This patch make access to the registers more generic by
relying on an array of u8 variables. This fits exactly the way the
registers are represented in the hardware.

It also adds helpers to access to a single register of a bank instead
of reading or writing all the banks for a given register.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/gpio/gpio-pca953x.c |  281 +++++++++++++++++++++++++++----------------
 1 file changed, 175 insertions(+), 106 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index cc102d2..544a52f 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -71,18 +71,23 @@ static const struct i2c_device_id pca953x_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, pca953x_id);
 
+#define MAX_BANK 5
+#define BANK_SZ 8
+
+#define NBANK(chip) (chip->gpio_chip.ngpio / BANK_SZ)
+
 struct pca953x_chip {
 	unsigned gpio_start;
-	u32 reg_output;
-	u32 reg_direction;
+	u8 reg_output[MAX_BANK];
+	u8 reg_direction[MAX_BANK];
 	struct mutex i2c_lock;
 
 #ifdef CONFIG_GPIO_PCA953X_IRQ
 	struct mutex irq_lock;
-	u32 irq_mask;
-	u32 irq_stat;
-	u32 irq_trig_raise;
-	u32 irq_trig_fall;
+	u8 irq_mask[MAX_BANK];
+	u8 irq_stat[MAX_BANK];
+	u8 irq_trig_raise[MAX_BANK];
+	u8 irq_trig_fall[MAX_BANK];
 	int	 irq_base;
 	struct irq_domain *domain;
 #endif
@@ -93,33 +98,69 @@ struct pca953x_chip {
 	int	chip_type;
 };
 
-static int pca953x_write_reg(struct pca953x_chip *chip, int reg, u32 val)
+static int pca953x_read_single(struct pca953x_chip *chip, int reg, u32 *val,
+				int off)
+{
+	int ret;
+	int bank_shift = fls((chip->gpio_chip.ngpio - 1) / BANK_SZ);
+	int offset = off / BANK_SZ;
+
+	ret = i2c_smbus_read_byte_data(chip->client,
+				(reg << bank_shift) + offset);
+	*val = ret;
+
+	if (ret < 0) {
+		dev_err(&chip->client->dev, "failed reading register\n", reg);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int pca953x_write_single(struct pca953x_chip *chip, int reg, u32 val,
+				int off)
+{
+	int ret = 0;
+	int bank_shift = fls((chip->gpio_chip.ngpio - 1) / BANK_SZ);
+	int offset = off / BANK_SZ;
+
+	ret = i2c_smbus_write_byte_data(chip->client,
+					(reg << bank_shift) + offset, val);
+
+	if (ret < 0) {
+		dev_err(&chip->client->dev, "failed writing register\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int pca953x_write_regs(struct pca953x_chip *chip, int reg, u8 *val)
 {
 	int ret = 0;
 
 	if (chip->gpio_chip.ngpio <= 8)
-		ret = i2c_smbus_write_byte_data(chip->client, reg, val);
-	else if (chip->gpio_chip.ngpio == 24) {
-		cpu_to_le32s(&val);
+		ret = i2c_smbus_write_byte_data(chip->client, reg, *val);
+	else if (chip->gpio_chip.ngpio >= 24) {
+		int bank_shift = fls((chip->gpio_chip.ngpio - 1) / BANK_SZ);
 		ret = i2c_smbus_write_i2c_block_data(chip->client,
-						(reg << 2) | REG_ADDR_AI,
-						3,
-						(u8 *) &val);
+					(reg << bank_shift) | REG_ADDR_AI,
+					NBANK(chip), val);
 	}
 	else {
 		switch (chip->chip_type) {
 		case PCA953X_TYPE:
 			ret = i2c_smbus_write_word_data(chip->client,
-							reg << 1, val);
+							reg << 1, (u16) *val);
 			break;
 		case PCA957X_TYPE:
 			ret = i2c_smbus_write_byte_data(chip->client, reg << 1,
-							val & 0xff);
+							val[0]);
 			if (ret < 0)
 				break;
 			ret = i2c_smbus_write_byte_data(chip->client,
 							(reg << 1) + 1,
-							(val & 0xff00) >> 8);
+							val[1]);
 			break;
 		}
 	}
@@ -132,26 +173,24 @@ static int pca953x_write_reg(struct pca953x_chip *chip, int reg, u32 val)
 	return 0;
 }
 
-static int pca953x_read_reg(struct pca953x_chip *chip, int reg, u32 *val)
+static int pca953x_read_regs(struct pca953x_chip *chip, int reg, u8 *val)
 {
 	int ret;
 
 	if (chip->gpio_chip.ngpio <= 8) {
 		ret = i2c_smbus_read_byte_data(chip->client, reg);
 		*val = ret;
-	}
-	else if (chip->gpio_chip.ngpio == 24) {
-		*val = 0;
+	} else if (chip->gpio_chip.ngpio >= 24) {
+		int bank_shift = fls((chip->gpio_chip.ngpio - 1) / BANK_SZ);
+
 		ret = i2c_smbus_read_i2c_block_data(chip->client,
-						(reg << 2) | REG_ADDR_AI,
-						3,
-						(u8 *) val);
-		le32_to_cpus(val);
+					(reg << bank_shift) | REG_ADDR_AI,
+					NBANK(chip), val);
 	} else {
 		ret = i2c_smbus_read_word_data(chip->client, reg << 1);
-		*val = ret;
+		val[0] = (u16)ret & 0xFF;
+		val[1] = (u16)ret >> 8;
 	}
-
 	if (ret < 0) {
 		dev_err(&chip->client->dev, "failed reading register\n");
 		return ret;
@@ -163,13 +202,13 @@ static int pca953x_read_reg(struct pca953x_chip *chip, int reg, u32 *val)
 static int pca953x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
 {
 	struct pca953x_chip *chip;
-	uint reg_val;
+	u8 reg_val;
 	int ret, offset = 0;
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
 	mutex_lock(&chip->i2c_lock);
-	reg_val = chip->reg_direction | (1u << off);
+	reg_val = chip->reg_direction[off / BANK_SZ] | (1u << (off % BANK_SZ));
 
 	switch (chip->chip_type) {
 	case PCA953X_TYPE:
@@ -179,11 +218,11 @@ static int pca953x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
 		offset = PCA957X_CFG;
 		break;
 	}
-	ret = pca953x_write_reg(chip, offset, reg_val);
+	ret = pca953x_write_single(chip, offset, reg_val, off);
 	if (ret)
 		goto exit;
 
-	chip->reg_direction = reg_val;
+	chip->reg_direction[off / BANK_SZ] = reg_val;
 	ret = 0;
 exit:
 	mutex_unlock(&chip->i2c_lock);
@@ -194,7 +233,7 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 		unsigned off, int val)
 {
 	struct pca953x_chip *chip;
-	uint reg_val;
+	u8 reg_val;
 	int ret, offset = 0;
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
@@ -202,9 +241,11 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 	mutex_lock(&chip->i2c_lock);
 	/* set output level */
 	if (val)
-		reg_val = chip->reg_output | (1u << off);
+		reg_val = chip->reg_output[off / BANK_SZ]
+			| (1u << (off % BANK_SZ));
 	else
-		reg_val = chip->reg_output & ~(1u << off);
+		reg_val = chip->reg_output[off / BANK_SZ]
+			& ~(1u << (off % BANK_SZ));
 
 	switch (chip->chip_type) {
 	case PCA953X_TYPE:
@@ -214,14 +255,14 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 		offset = PCA957X_OUT;
 		break;
 	}
-	ret = pca953x_write_reg(chip, offset, reg_val);
+	ret = pca953x_write_single(chip, offset, reg_val, off);
 	if (ret)
 		goto exit;
 
-	chip->reg_output = reg_val;
+	chip->reg_output[off / BANK_SZ] = reg_val;
 
 	/* then direction */
-	reg_val = chip->reg_direction & ~(1u << off);
+	reg_val = chip->reg_direction[off / BANK_SZ] & ~(1u << (off % BANK_SZ));
 	switch (chip->chip_type) {
 	case PCA953X_TYPE:
 		offset = PCA953X_DIRECTION;
@@ -230,11 +271,11 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 		offset = PCA957X_CFG;
 		break;
 	}
-	ret = pca953x_write_reg(chip, offset, reg_val);
+	ret = pca953x_write_single(chip, offset, reg_val, off);
 	if (ret)
 		goto exit;
 
-	chip->reg_direction = reg_val;
+	chip->reg_direction[off / BANK_SZ] = reg_val;
 	ret = 0;
 exit:
 	mutex_unlock(&chip->i2c_lock);
@@ -258,7 +299,7 @@ static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
 		offset = PCA957X_IN;
 		break;
 	}
-	ret = pca953x_read_reg(chip, offset, &reg_val);
+	ret = pca953x_read_single(chip, offset, &reg_val, off);
 	mutex_unlock(&chip->i2c_lock);
 	if (ret < 0) {
 		/* NOTE:  diagnostic already emitted; that's all we should
@@ -274,16 +315,18 @@ static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
 static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
 {
 	struct pca953x_chip *chip;
-	u32 reg_val;
+	u8 reg_val;
 	int ret, offset = 0;
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
 	mutex_lock(&chip->i2c_lock);
 	if (val)
-		reg_val = chip->reg_output | (1u << off);
+		reg_val = chip->reg_output[off / BANK_SZ]
+			| (1u << (off % BANK_SZ));
 	else
-		reg_val = chip->reg_output & ~(1u << off);
+		reg_val = chip->reg_output[off / BANK_SZ]
+			& ~(1u << (off % BANK_SZ));
 
 	switch (chip->chip_type) {
 	case PCA953X_TYPE:
@@ -293,11 +336,11 @@ static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
 		offset = PCA957X_OUT;
 		break;
 	}
-	ret = pca953x_write_reg(chip, offset, reg_val);
+	ret = pca953x_write_single(chip, offset, reg_val, off);
 	if (ret)
 		goto exit;
 
-	chip->reg_output = reg_val;
+	chip->reg_output[off / BANK_SZ] = reg_val;
 exit:
 	mutex_unlock(&chip->i2c_lock);
 }
@@ -335,14 +378,14 @@ static void pca953x_irq_mask(struct irq_data *d)
 {
 	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
 
-	chip->irq_mask &= ~(1 << d->hwirq);
+	chip->irq_mask[d->hwirq / BANK_SZ] &= ~(1 << (d->hwirq % BANK_SZ));
 }
 
 static void pca953x_irq_unmask(struct irq_data *d)
 {
 	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
 
-	chip->irq_mask |= 1 << d->hwirq;
+	chip->irq_mask[d->hwirq / BANK_SZ] |= 1 << (d->hwirq % BANK_SZ);
 }
 
 static void pca953x_irq_bus_lock(struct irq_data *d)
@@ -355,17 +398,20 @@ static void pca953x_irq_bus_lock(struct irq_data *d)
 static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 {
 	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
-	u32 new_irqs;
-	u32 level;
+	u8 new_irqs;
+	int level, i;
 
 	/* Look for any newly setup interrupt */
-	new_irqs = chip->irq_trig_fall | chip->irq_trig_raise;
-	new_irqs &= ~chip->reg_direction;
-
-	while (new_irqs) {
-		level = __ffs(new_irqs);
-		pca953x_gpio_direction_input(&chip->gpio_chip, level);
-		new_irqs &= ~(1 << level);
+	for (i = 0; i < NBANK(chip); i++) {
+		new_irqs = chip->irq_trig_fall[i] | chip->irq_trig_raise[i];
+		new_irqs &= ~chip->reg_direction[i];
+
+		while (new_irqs) {
+			level = __ffs(new_irqs);
+			pca953x_gpio_direction_input(&chip->gpio_chip,
+							level + (BANK_SZ * i));
+			new_irqs &= ~(1 << level);
+		}
 	}
 
 	mutex_unlock(&chip->irq_lock);
@@ -374,7 +420,8 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 static int pca953x_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << d->hwirq;
+	int bank_nb = d->hwirq / BANK_SZ;
+	u8 mask = 1 << (d->hwirq % BANK_SZ);
 
 	if (!(type & IRQ_TYPE_EDGE_BOTH)) {
 		dev_err(&chip->client->dev, "irq %d: unsupported type %d\n",
@@ -383,14 +430,14 @@ static int pca953x_irq_set_type(struct irq_data *d, unsigned int type)
 	}
 
 	if (type & IRQ_TYPE_EDGE_FALLING)
-		chip->irq_trig_fall |= mask;
+		chip->irq_trig_fall[bank_nb] |= mask;
 	else
-		chip->irq_trig_fall &= ~mask;
+		chip->irq_trig_fall[bank_nb] &= ~mask;
 
 	if (type & IRQ_TYPE_EDGE_RISING)
-		chip->irq_trig_raise |= mask;
+		chip->irq_trig_raise[bank_nb] |= mask;
 	else
-		chip->irq_trig_raise &= ~mask;
+		chip->irq_trig_raise[bank_nb] &= ~mask;
 
 	return 0;
 }
@@ -404,13 +451,13 @@ static struct irq_chip pca953x_irq_chip = {
 	.irq_set_type		= pca953x_irq_set_type,
 };
 
-static u32 pca953x_irq_pending(struct pca953x_chip *chip)
+static u8 pca953x_irq_pending(struct pca953x_chip *chip, u8 *pending)
 {
-	u32 cur_stat;
-	u32 old_stat;
-	u32 pending;
-	u32 trigger;
-	int ret, offset = 0;
+	u8 cur_stat[MAX_BANK];
+	u8 old_stat[MAX_BANK];
+	u8 pendings = 0;
+	u8 trigger[MAX_BANK], triggers = 0;
+	int ret, i, offset = 0;
 
 	switch (chip->chip_type) {
 	case PCA953X_TYPE:
@@ -420,45 +467,54 @@ static u32 pca953x_irq_pending(struct pca953x_chip *chip)
 		offset = PCA957X_IN;
 		break;
 	}
-	ret = pca953x_read_reg(chip, offset, &cur_stat);
+	ret = pca953x_read_regs(chip, offset, cur_stat);
 	if (ret)
 		return 0;
 
 	/* Remove output pins from the equation */
-	cur_stat &= chip->reg_direction;
+	for (i = 0; i < NBANK(chip); i++)
+		cur_stat[i] &= chip->reg_direction[i];
 
-	old_stat = chip->irq_stat;
-	trigger = (cur_stat ^ old_stat) & chip->irq_mask;
+	memcpy(old_stat, chip->irq_stat, NBANK(chip));
 
-	if (!trigger)
+	for (i = 0; i < NBANK(chip); i++) {
+		trigger[i] = (cur_stat[i] ^ old_stat[i]) & chip->irq_mask[i];
+		triggers += trigger[i];
+	}
+
+	if (!triggers)
 		return 0;
 
-	chip->irq_stat = cur_stat;
+	memcpy(chip->irq_stat, cur_stat, NBANK(chip));
 
-	pending = (old_stat & chip->irq_trig_fall) |
-		  (cur_stat & chip->irq_trig_raise);
-	pending &= trigger;
+	for (i = 0; i < NBANK(chip); i++) {
+		pending[i] = (old_stat[i] & chip->irq_trig_fall[i]) |
+			(cur_stat[i] & chip->irq_trig_raise[i]);
+		pending[i] &= trigger[i];
+		pendings += pending[i];
+	}
 
-	return pending;
+	return pendings;
 }
 
 static irqreturn_t pca953x_irq_handler(int irq, void *devid)
 {
 	struct pca953x_chip *chip = devid;
-	u32 pending;
-	u32 level;
+	u8 pending[MAX_BANK];
+	u8 level;
+	int i;
 
-	pending = pca953x_irq_pending(chip);
-
-	if (!pending)
+	if (!pca953x_irq_pending(chip, pending))
 		return IRQ_HANDLED;
 
-	do {
-		level = __ffs(pending);
-		handle_nested_irq(irq_find_mapping(chip->domain, level));
-
-		pending &= ~(1 << level);
-	} while (pending);
+	for (i = 0; i < NBANK(chip); i++) {
+		do {
+			level = __ffs(pending[i]);
+			handle_nested_irq(irq_find_mapping(chip->domain,
+							level + (BANK_SZ * i)));
+			pending[i] &= ~(1 << level);
+		} while (pending[i]);
+	}
 
 	return IRQ_HANDLED;
 }
@@ -468,8 +524,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 			     int irq_base)
 {
 	struct i2c_client *client = chip->client;
-	int ret, offset = 0;
-	u32 temporary;
+	int ret, i, offset = 0;
 
 	if (irq_base != -1
 			&& (id->driver_data & PCA_INT)) {
@@ -483,8 +538,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 			offset = PCA957X_IN;
 			break;
 		}
-		ret = pca953x_read_reg(chip, offset, &temporary);
-		chip->irq_stat = temporary;
+		ret = pca953x_read_regs(chip, offset, chip->irq_stat);
 		if (ret)
 			goto out_failed;
 
@@ -493,7 +547,8 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 		 * interrupt.  We have to rely on the previous read for
 		 * this purpose.
 		 */
-		chip->irq_stat &= chip->reg_direction;
+		for (i = 0; i < NBANK(chip); i++)
+			chip->irq_stat[i] &= chip->reg_direction[i];
 		mutex_init(&chip->irq_lock);
 
 		chip->irq_base = irq_alloc_descs(-1, irq_base, chip->gpio_chip.ngpio, -1);
@@ -619,18 +674,24 @@ pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, u32 *invert)
 static int device_pca953x_init(struct pca953x_chip *chip, u32 invert)
 {
 	int ret;
+	u8 val[MAX_BANK];
 
-	ret = pca953x_read_reg(chip, PCA953X_OUTPUT, &chip->reg_output);
+	ret = pca953x_read_regs(chip, PCA953X_OUTPUT, chip->reg_output);
 	if (ret)
 		goto out;
 
-	ret = pca953x_read_reg(chip, PCA953X_DIRECTION,
-			       &chip->reg_direction);
+	ret = pca953x_read_regs(chip, PCA953X_DIRECTION,
+			       chip->reg_direction);
 	if (ret)
 		goto out;
 
 	/* set platform specific polarity inversion */
-	ret = pca953x_write_reg(chip, PCA953X_INVERT, invert);
+	if (invert)
+		memset(val, 0xFF, NBANK(chip));
+	else
+		memset(val, 0, NBANK(chip));
+
+	ret = pca953x_write_regs(chip, PCA953X_INVERT, val);
 out:
 	return ret;
 }
@@ -638,28 +699,36 @@ out:
 static int device_pca957x_init(struct pca953x_chip *chip, u32 invert)
 {
 	int ret;
-	u32 val = 0;
+	u8 val[MAX_BANK];
 
 	/* Let every port in proper state, that could save power */
-	pca953x_write_reg(chip, PCA957X_PUPD, 0x0);
-	pca953x_write_reg(chip, PCA957X_CFG, 0xffff);
-	pca953x_write_reg(chip, PCA957X_OUT, 0x0);
-
-	ret = pca953x_read_reg(chip, PCA957X_IN, &val);
+	memset(val, 0, NBANK(chip));
+	pca953x_write_regs(chip, PCA957X_PUPD, val);
+	memset(val, 0xFF, NBANK(chip));
+	pca953x_write_regs(chip, PCA957X_CFG, val);
+	memset(val, 0, NBANK(chip));
+	pca953x_write_regs(chip, PCA957X_OUT, val);
+
+	ret = pca953x_read_regs(chip, PCA957X_IN, val);
 	if (ret)
 		goto out;
-	ret = pca953x_read_reg(chip, PCA957X_OUT, &chip->reg_output);
+	ret = pca953x_read_regs(chip, PCA957X_OUT, chip->reg_output);
 	if (ret)
 		goto out;
-	ret = pca953x_read_reg(chip, PCA957X_CFG, &chip->reg_direction);
+	ret = pca953x_read_regs(chip, PCA957X_CFG, chip->reg_direction);
 	if (ret)
 		goto out;
 
 	/* set platform specific polarity inversion */
-	pca953x_write_reg(chip, PCA957X_INVRT, invert);
+	if (invert)
+		memset(val, 0xFF, NBANK(chip));
+	else
+		memset(val, 0, NBANK(chip));
+	pca953x_write_regs(chip, PCA957X_INVRT, val);
 
 	/* To enable register 6, 7 to controll pull up and pull down */
-	pca953x_write_reg(chip, PCA957X_BKEN, 0x202);
+	memset(val, 0x02, NBANK(chip));
+	pca953x_write_regs(chip, PCA957X_BKEN, val);
 
 	return 0;
 out:
-- 
1.7.9.5

