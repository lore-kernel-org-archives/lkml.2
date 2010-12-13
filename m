Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0LMEEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 23:04:32 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:60239 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636Ab0LMEE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 23:04:29 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, Sundar Iyer <sundar.iyer@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v2 4/8] mfd/tc3589x: rename tc35892 structs/registers to tc359x
Date: Mon, 13 Dec 2010 09:33:14 +0530
Message-ID: <1292212998-13066-5-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1292212998-13066-1-git-send-email-sundar.iyer@stericsson.com>
References: <1292212998-13066-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the register layout, client IRQ numbers on the TC35892 is shared also
by other variants. Make this generic as tc3589x

Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500.c |   12 +-
 drivers/gpio/tc3589x-gpio.c        |  268 ++++++++++++++++++------------------
 drivers/mfd/tc3589x.c              |  222 +++++++++++++++---------------
 include/linux/mfd/tc3589x.h        |  202 ++++++++++++++--------------
 4 files changed, 351 insertions(+), 353 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index cfcfcd3..f9e1dd9 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -19,8 +19,7 @@
 #include <linux/amba/pl022.h>
 #include <linux/spi/spi.h>
 #include <linux/mfd/ab8500.h>
-#include <linux/mfd/tc35892.h>
-#include <linux/input/matrix_keypad.h>
+#include <linux/mfd/tc3589x.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -112,24 +111,24 @@ static struct pl022_ssp_controller ssp0_platform_data = {
  * TC35892
  */
 
-static void mop500_tc35892_init(struct tc35892 *tc35892, unsigned int base)
+static void mop500_tc35892_init(struct tc3589x *tc3589x, unsigned int base)
 {
 	mop500_sdi_tc35892_init();
 }
 
-static struct tc35892_gpio_platform_data mop500_tc35892_gpio_data = {
+static struct tc3589x_gpio_platform_data mop500_tc35892_gpio_data = {
 	.gpio_base	= MOP500_EGPIO(0),
 	.setup		= mop500_tc35892_init,
 };
 
-static struct tc35892_platform_data mop500_tc35892_data = {
+static struct tc3589x_platform_data mop500_tc35892_data = {
 	.gpio		= &mop500_tc35892_gpio_data,
 	.irq_base	= MOP500_EGPIO_IRQ_BASE,
 };
 
 static struct i2c_board_info mop500_i2c0_devices[] = {
 	{
-		I2C_BOARD_INFO("tc35892", 0x42),
+		I2C_BOARD_INFO("tc3589x", 0x42),
 		.irq            = NOMADIK_GPIO_TO_IRQ(217),
 		.platform_data  = &mop500_tc35892_data,
 	},
@@ -302,7 +301,6 @@ static void __init u8500_init_machine(void)
 
 	nmk_config_pins(mop500_pins, ARRAY_SIZE(mop500_pins));
 
-	ux500_ske_keypad_device.dev.platform_data = &ske_keypad_board;
 	platform_add_devices(platform_devs, ARRAY_SIZE(platform_devs));
 
 	mop500_i2c_init();
diff --git a/drivers/gpio/tc3589x-gpio.c b/drivers/gpio/tc3589x-gpio.c
index 027b857..180d584 100644
--- a/drivers/gpio/tc3589x-gpio.c
+++ b/drivers/gpio/tc3589x-gpio.c
@@ -24,9 +24,9 @@ enum { REG_IBE, REG_IEV, REG_IS, REG_IE };
 #define CACHE_NR_REGS	4
 #define CACHE_NR_BANKS	3
 
-struct tc35892_gpio {
+struct tc3589x_gpio {
 	struct gpio_chip chip;
-	struct tc35892 *tc35892;
+	struct tc3589x *tc3589x;
 	struct device *dev;
 	struct mutex irq_lock;
 
@@ -37,179 +37,179 @@ struct tc35892_gpio {
 	u8 oldregs[CACHE_NR_REGS][CACHE_NR_BANKS];
 };
 
-static inline struct tc35892_gpio *to_tc35892_gpio(struct gpio_chip *chip)
+static inline struct tc3589x_gpio *to_tc3589x_gpio(struct gpio_chip *chip)
 {
-	return container_of(chip, struct tc35892_gpio, chip);
+	return container_of(chip, struct tc3589x_gpio, chip);
 }
 
-static int tc35892_gpio_get(struct gpio_chip *chip, unsigned offset)
+static int tc3589x_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	struct tc35892_gpio *tc35892_gpio = to_tc35892_gpio(chip);
-	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
-	u8 reg = TC35892_GPIODATA0 + (offset / 8) * 2;
+	struct tc3589x_gpio *tc3589x_gpio = to_tc3589x_gpio(chip);
+	struct tc3589x *tc3589x = tc3589x_gpio->tc3589x;
+	u8 reg = TC3589x_GPIODATA0 + (offset / 8) * 2;
 	u8 mask = 1 << (offset % 8);
 	int ret;
 
-	ret = tc35892_reg_read(tc35892, reg);
+	ret = tc3589x_reg_read(tc3589x, reg);
 	if (ret < 0)
 		return ret;
 
 	return ret & mask;
 }
 
-static void tc35892_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
+static void tc3589x_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 {
-	struct tc35892_gpio *tc35892_gpio = to_tc35892_gpio(chip);
-	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
-	u8 reg = TC35892_GPIODATA0 + (offset / 8) * 2;
+	struct tc3589x_gpio *tc3589x_gpio = to_tc3589x_gpio(chip);
+	struct tc3589x *tc3589x = tc3589x_gpio->tc3589x;
+	u8 reg = TC3589x_GPIODATA0 + (offset / 8) * 2;
 	unsigned pos = offset % 8;
 	u8 data[] = {!!val << pos, 1 << pos};
 
-	tc35892_block_write(tc35892, reg, ARRAY_SIZE(data), data);
+	tc3589x_block_write(tc3589x, reg, ARRAY_SIZE(data), data);
 }
 
-static int tc35892_gpio_direction_output(struct gpio_chip *chip,
+static int tc3589x_gpio_direction_output(struct gpio_chip *chip,
 					 unsigned offset, int val)
 {
-	struct tc35892_gpio *tc35892_gpio = to_tc35892_gpio(chip);
-	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
-	u8 reg = TC35892_GPIODIR0 + offset / 8;
+	struct tc3589x_gpio *tc3589x_gpio = to_tc3589x_gpio(chip);
+	struct tc3589x *tc3589x = tc3589x_gpio->tc3589x;
+	u8 reg = TC3589x_GPIODIR0 + offset / 8;
 	unsigned pos = offset % 8;
 
-	tc35892_gpio_set(chip, offset, val);
+	tc3589x_gpio_set(chip, offset, val);
 
-	return tc35892_set_bits(tc35892, reg, 1 << pos, 1 << pos);
+	return tc3589x_set_bits(tc3589x, reg, 1 << pos, 1 << pos);
 }
 
-static int tc35892_gpio_direction_input(struct gpio_chip *chip,
+static int tc3589x_gpio_direction_input(struct gpio_chip *chip,
 					unsigned offset)
 {
-	struct tc35892_gpio *tc35892_gpio = to_tc35892_gpio(chip);
-	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
-	u8 reg = TC35892_GPIODIR0 + offset / 8;
+	struct tc3589x_gpio *tc3589x_gpio = to_tc3589x_gpio(chip);
+	struct tc3589x *tc3589x = tc3589x_gpio->tc3589x;
+	u8 reg = TC3589x_GPIODIR0 + offset / 8;
 	unsigned pos = offset % 8;
 
-	return tc35892_set_bits(tc35892, reg, 1 << pos, 0);
+	return tc3589x_set_bits(tc3589x, reg, 1 << pos, 0);
 }
 
-static int tc35892_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+static int tc3589x_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	struct tc35892_gpio *tc35892_gpio = to_tc35892_gpio(chip);
+	struct tc3589x_gpio *tc3589x_gpio = to_tc3589x_gpio(chip);
 
-	return tc35892_gpio->irq_base + offset;
+	return tc3589x_gpio->irq_base + offset;
 }
 
 static struct gpio_chip template_chip = {
-	.label			= "tc35892",
+	.label			= "tc3589x",
 	.owner			= THIS_MODULE,
-	.direction_input	= tc35892_gpio_direction_input,
-	.get			= tc35892_gpio_get,
-	.direction_output	= tc35892_gpio_direction_output,
-	.set			= tc35892_gpio_set,
-	.to_irq			= tc35892_gpio_to_irq,
+	.direction_input	= tc3589x_gpio_direction_input,
+	.get			= tc3589x_gpio_get,
+	.direction_output	= tc3589x_gpio_direction_output,
+	.set			= tc3589x_gpio_set,
+	.to_irq			= tc3589x_gpio_to_irq,
 	.can_sleep		= 1,
 };
 
-static int tc35892_gpio_irq_set_type(unsigned int irq, unsigned int type)
+static int tc3589x_gpio_irq_set_type(unsigned int irq, unsigned int type)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
-	int offset = irq - tc35892_gpio->irq_base;
+	struct tc3589x_gpio *tc3589x_gpio = get_irq_chip_data(irq);
+	int offset = irq - tc3589x_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
 	if (type == IRQ_TYPE_EDGE_BOTH) {
-		tc35892_gpio->regs[REG_IBE][regoffset] |= mask;
+		tc3589x_gpio->regs[REG_IBE][regoffset] |= mask;
 		return 0;
 	}
 
-	tc35892_gpio->regs[REG_IBE][regoffset] &= ~mask;
+	tc3589x_gpio->regs[REG_IBE][regoffset] &= ~mask;
 
 	if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_LEVEL_HIGH)
-		tc35892_gpio->regs[REG_IS][regoffset] |= mask;
+		tc3589x_gpio->regs[REG_IS][regoffset] |= mask;
 	else
-		tc35892_gpio->regs[REG_IS][regoffset] &= ~mask;
+		tc3589x_gpio->regs[REG_IS][regoffset] &= ~mask;
 
 	if (type == IRQ_TYPE_EDGE_RISING || type == IRQ_TYPE_LEVEL_HIGH)
-		tc35892_gpio->regs[REG_IEV][regoffset] |= mask;
+		tc3589x_gpio->regs[REG_IEV][regoffset] |= mask;
 	else
-		tc35892_gpio->regs[REG_IEV][regoffset] &= ~mask;
+		tc3589x_gpio->regs[REG_IEV][regoffset] &= ~mask;
 
 	return 0;
 }
 
-static void tc35892_gpio_irq_lock(unsigned int irq)
+static void tc3589x_gpio_irq_lock(unsigned int irq)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
+	struct tc3589x_gpio *tc3589x_gpio = get_irq_chip_data(irq);
 
-	mutex_lock(&tc35892_gpio->irq_lock);
+	mutex_lock(&tc3589x_gpio->irq_lock);
 }
 
-static void tc35892_gpio_irq_sync_unlock(unsigned int irq)
+static void tc3589x_gpio_irq_sync_unlock(unsigned int irq)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
-	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
+	struct tc3589x_gpio *tc3589x_gpio = get_irq_chip_data(irq);
+	struct tc3589x *tc3589x = tc3589x_gpio->tc3589x;
 	static const u8 regmap[] = {
-		[REG_IBE]	= TC35892_GPIOIBE0,
-		[REG_IEV]	= TC35892_GPIOIEV0,
-		[REG_IS]	= TC35892_GPIOIS0,
-		[REG_IE]	= TC35892_GPIOIE0,
+		[REG_IBE]	= TC3589x_GPIOIBE0,
+		[REG_IEV]	= TC3589x_GPIOIEV0,
+		[REG_IS]	= TC3589x_GPIOIS0,
+		[REG_IE]	= TC3589x_GPIOIE0,
 	};
 	int i, j;
 
 	for (i = 0; i < CACHE_NR_REGS; i++) {
 		for (j = 0; j < CACHE_NR_BANKS; j++) {
-			u8 old = tc35892_gpio->oldregs[i][j];
-			u8 new = tc35892_gpio->regs[i][j];
+			u8 old = tc3589x_gpio->oldregs[i][j];
+			u8 new = tc3589x_gpio->regs[i][j];
 
 			if (new == old)
 				continue;
 
-			tc35892_gpio->oldregs[i][j] = new;
-			tc35892_reg_write(tc35892, regmap[i] + j * 8, new);
+			tc3589x_gpio->oldregs[i][j] = new;
+			tc3589x_reg_write(tc3589x, regmap[i] + j * 8, new);
 		}
 	}
 
-	mutex_unlock(&tc35892_gpio->irq_lock);
+	mutex_unlock(&tc3589x_gpio->irq_lock);
 }
 
-static void tc35892_gpio_irq_mask(unsigned int irq)
+static void tc3589x_gpio_irq_mask(unsigned int irq)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
-	int offset = irq - tc35892_gpio->irq_base;
+	struct tc3589x_gpio *tc3589x_gpio = get_irq_chip_data(irq);
+	int offset = irq - tc3589x_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
-	tc35892_gpio->regs[REG_IE][regoffset] &= ~mask;
+	tc3589x_gpio->regs[REG_IE][regoffset] &= ~mask;
 }
 
-static void tc35892_gpio_irq_unmask(unsigned int irq)
+static void tc3589x_gpio_irq_unmask(unsigned int irq)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
-	int offset = irq - tc35892_gpio->irq_base;
+	struct tc3589x_gpio *tc3589x_gpio = get_irq_chip_data(irq);
+	int offset = irq - tc3589x_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
-	tc35892_gpio->regs[REG_IE][regoffset] |= mask;
+	tc3589x_gpio->regs[REG_IE][regoffset] |= mask;
 }
 
-static struct irq_chip tc35892_gpio_irq_chip = {
-	.name			= "tc35892-gpio",
-	.bus_lock		= tc35892_gpio_irq_lock,
-	.bus_sync_unlock	= tc35892_gpio_irq_sync_unlock,
-	.mask			= tc35892_gpio_irq_mask,
-	.unmask			= tc35892_gpio_irq_unmask,
-	.set_type		= tc35892_gpio_irq_set_type,
+static struct irq_chip tc3589x_gpio_irq_chip = {
+	.name			= "tc3589x-gpio",
+	.bus_lock		= tc3589x_gpio_irq_lock,
+	.bus_sync_unlock	= tc3589x_gpio_irq_sync_unlock,
+	.mask			= tc3589x_gpio_irq_mask,
+	.unmask			= tc3589x_gpio_irq_unmask,
+	.set_type		= tc3589x_gpio_irq_set_type,
 };
 
-static irqreturn_t tc35892_gpio_irq(int irq, void *dev)
+static irqreturn_t tc3589x_gpio_irq(int irq, void *dev)
 {
-	struct tc35892_gpio *tc35892_gpio = dev;
-	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
+	struct tc3589x_gpio *tc3589x_gpio = dev;
+	struct tc3589x *tc3589x = tc3589x_gpio->tc3589x;
 	u8 status[CACHE_NR_BANKS];
 	int ret;
 	int i;
 
-	ret = tc35892_block_read(tc35892, TC35892_GPIOMIS0,
+	ret = tc3589x_block_read(tc3589x, TC3589x_GPIOMIS0,
 				 ARRAY_SIZE(status), status);
 	if (ret < 0)
 		return IRQ_NONE;
@@ -223,24 +223,24 @@ static irqreturn_t tc35892_gpio_irq(int irq, void *dev)
 			int bit = __ffs(stat);
 			int line = i * 8 + bit;
 
-			handle_nested_irq(tc35892_gpio->irq_base + line);
+			handle_nested_irq(tc3589x_gpio->irq_base + line);
 			stat &= ~(1 << bit);
 		}
 
-		tc35892_reg_write(tc35892, TC35892_GPIOIC0 + i, status[i]);
+		tc3589x_reg_write(tc3589x, TC3589x_GPIOIC0 + i, status[i]);
 	}
 
 	return IRQ_HANDLED;
 }
 
-static int tc35892_gpio_irq_init(struct tc35892_gpio *tc35892_gpio)
+static int tc3589x_gpio_irq_init(struct tc3589x_gpio *tc3589x_gpio)
 {
-	int base = tc35892_gpio->irq_base;
+	int base = tc3589x_gpio->irq_base;
 	int irq;
 
-	for (irq = base; irq < base + tc35892_gpio->chip.ngpio; irq++) {
-		set_irq_chip_data(irq, tc35892_gpio);
-		set_irq_chip_and_handler(irq, &tc35892_gpio_irq_chip,
+	for (irq = base; irq < base + tc3589x_gpio->chip.ngpio; irq++) {
+		set_irq_chip_data(irq, tc3589x_gpio);
+		set_irq_chip_and_handler(irq, &tc3589x_gpio_irq_chip,
 					 handle_simple_irq);
 		set_irq_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
@@ -253,12 +253,12 @@ static int tc35892_gpio_irq_init(struct tc35892_gpio *tc35892_gpio)
 	return 0;
 }
 
-static void tc35892_gpio_irq_remove(struct tc35892_gpio *tc35892_gpio)
+static void tc3589x_gpio_irq_remove(struct tc3589x_gpio *tc3589x_gpio)
 {
-	int base = tc35892_gpio->irq_base;
+	int base = tc3589x_gpio->irq_base;
 	int irq;
 
-	for (irq = base; irq < base + tc35892_gpio->chip.ngpio; irq++) {
+	for (irq = base; irq < base + tc3589x_gpio->chip.ngpio; irq++) {
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
@@ -267,15 +267,15 @@ static void tc35892_gpio_irq_remove(struct tc35892_gpio *tc35892_gpio)
 	}
 }
 
-static int __devinit tc35892_gpio_probe(struct platform_device *pdev)
+static int __devinit tc3589x_gpio_probe(struct platform_device *pdev)
 {
-	struct tc35892 *tc35892 = dev_get_drvdata(pdev->dev.parent);
-	struct tc35892_gpio_platform_data *pdata;
-	struct tc35892_gpio *tc35892_gpio;
+	struct tc3589x *tc3589x = dev_get_drvdata(pdev->dev.parent);
+	struct tc3589x_gpio_platform_data *pdata;
+	struct tc3589x_gpio *tc3589x_gpio;
 	int ret;
 	int irq;
 
-	pdata = tc35892->pdata->gpio;
+	pdata = tc3589x->pdata->gpio;
 	if (!pdata)
 		return -ENODEV;
 
@@ -283,107 +283,107 @@ static int __devinit tc35892_gpio_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	tc35892_gpio = kzalloc(sizeof(struct tc35892_gpio), GFP_KERNEL);
-	if (!tc35892_gpio)
+	tc3589x_gpio = kzalloc(sizeof(struct tc3589x_gpio), GFP_KERNEL);
+	if (!tc3589x_gpio)
 		return -ENOMEM;
 
-	mutex_init(&tc35892_gpio->irq_lock);
+	mutex_init(&tc3589x_gpio->irq_lock);
 
-	tc35892_gpio->dev = &pdev->dev;
-	tc35892_gpio->tc35892 = tc35892;
+	tc3589x_gpio->dev = &pdev->dev;
+	tc3589x_gpio->tc3589x = tc3589x;
 
-	tc35892_gpio->chip = template_chip;
-	tc35892_gpio->chip.ngpio = tc35892->num_gpio;
-	tc35892_gpio->chip.dev = &pdev->dev;
-	tc35892_gpio->chip.base = pdata->gpio_base;
+	tc3589x_gpio->chip = template_chip;
+	tc3589x_gpio->chip.ngpio = tc3589x->num_gpio;
+	tc3589x_gpio->chip.dev = &pdev->dev;
+	tc3589x_gpio->chip.base = pdata->gpio_base;
 
-	tc35892_gpio->irq_base = tc35892->irq_base + TC35892_INT_GPIO(0);
+	tc3589x_gpio->irq_base = tc3589x->irq_base + TC3589x_INT_GPIO(0);
 
 	/* Bring the GPIO module out of reset */
-	ret = tc35892_set_bits(tc35892, TC35892_RSTCTRL,
-			       TC35892_RSTCTRL_GPIRST, 0);
+	ret = tc3589x_set_bits(tc3589x, TC3589x_RSTCTRL,
+			       TC3589x_RSTCTRL_GPIRST, 0);
 	if (ret < 0)
 		goto out_free;
 
-	ret = tc35892_gpio_irq_init(tc35892_gpio);
+	ret = tc3589x_gpio_irq_init(tc3589x_gpio);
 	if (ret)
 		goto out_free;
 
-	ret = request_threaded_irq(irq, NULL, tc35892_gpio_irq, IRQF_ONESHOT,
-				   "tc35892-gpio", tc35892_gpio);
+	ret = request_threaded_irq(irq, NULL, tc3589x_gpio_irq, IRQF_ONESHOT,
+				   "tc3589x-gpio", tc3589x_gpio);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to get irq: %d\n", ret);
 		goto out_removeirq;
 	}
 
-	ret = gpiochip_add(&tc35892_gpio->chip);
+	ret = gpiochip_add(&tc3589x_gpio->chip);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to add gpiochip: %d\n", ret);
 		goto out_freeirq;
 	}
 
 	if (pdata->setup)
-		pdata->setup(tc35892, tc35892_gpio->chip.base);
+		pdata->setup(tc3589x, tc3589x_gpio->chip.base);
 
-	platform_set_drvdata(pdev, tc35892_gpio);
+	platform_set_drvdata(pdev, tc3589x_gpio);
 
 	return 0;
 
 out_freeirq:
-	free_irq(irq, tc35892_gpio);
+	free_irq(irq, tc3589x_gpio);
 out_removeirq:
-	tc35892_gpio_irq_remove(tc35892_gpio);
+	tc3589x_gpio_irq_remove(tc3589x_gpio);
 out_free:
-	kfree(tc35892_gpio);
+	kfree(tc3589x_gpio);
 	return ret;
 }
 
-static int __devexit tc35892_gpio_remove(struct platform_device *pdev)
+static int __devexit tc3589x_gpio_remove(struct platform_device *pdev)
 {
-	struct tc35892_gpio *tc35892_gpio = platform_get_drvdata(pdev);
-	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
-	struct tc35892_gpio_platform_data *pdata = tc35892->pdata->gpio;
+	struct tc3589x_gpio *tc3589x_gpio = platform_get_drvdata(pdev);
+	struct tc3589x *tc3589x = tc3589x_gpio->tc3589x;
+	struct tc3589x_gpio_platform_data *pdata = tc3589x->pdata->gpio;
 	int irq = platform_get_irq(pdev, 0);
 	int ret;
 
 	if (pdata->remove)
-		pdata->remove(tc35892, tc35892_gpio->chip.base);
+		pdata->remove(tc3589x, tc3589x_gpio->chip.base);
 
-	ret = gpiochip_remove(&tc35892_gpio->chip);
+	ret = gpiochip_remove(&tc3589x_gpio->chip);
 	if (ret < 0) {
-		dev_err(tc35892_gpio->dev,
+		dev_err(tc3589x_gpio->dev,
 			"unable to remove gpiochip: %d\n", ret);
 		return ret;
 	}
 
-	free_irq(irq, tc35892_gpio);
-	tc35892_gpio_irq_remove(tc35892_gpio);
+	free_irq(irq, tc3589x_gpio);
+	tc3589x_gpio_irq_remove(tc3589x_gpio);
 
 	platform_set_drvdata(pdev, NULL);
-	kfree(tc35892_gpio);
+	kfree(tc3589x_gpio);
 
 	return 0;
 }
 
-static struct platform_driver tc35892_gpio_driver = {
-	.driver.name	= "tc35892-gpio",
+static struct platform_driver tc3589x_gpio_driver = {
+	.driver.name	= "tc3589x-gpio",
 	.driver.owner	= THIS_MODULE,
-	.probe		= tc35892_gpio_probe,
-	.remove		= __devexit_p(tc35892_gpio_remove),
+	.probe		= tc3589x_gpio_probe,
+	.remove		= __devexit_p(tc3589x_gpio_remove),
 };
 
-static int __init tc35892_gpio_init(void)
+static int __init tc3589x_gpio_init(void)
 {
-	return platform_driver_register(&tc35892_gpio_driver);
+	return platform_driver_register(&tc3589x_gpio_driver);
 }
-subsys_initcall(tc35892_gpio_init);
+subsys_initcall(tc3589x_gpio_init);
 
-static void __exit tc35892_gpio_exit(void)
+static void __exit tc3589x_gpio_exit(void)
 {
-	platform_driver_unregister(&tc35892_gpio_driver);
+	platform_driver_unregister(&tc3589x_gpio_driver);
 }
-module_exit(tc35892_gpio_exit);
+module_exit(tc3589x_gpio_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("TC35892 GPIO driver");
+MODULE_DESCRIPTION("TC3589x GPIO driver");
 MODULE_AUTHOR("Hanumath Prasad, Rabin Vincent");
diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index f230235..7deff53 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -15,141 +15,141 @@
 #include <linux/mfd/tc3589x.h>
 
 /**
- * tc35892_reg_read() - read a single TC35892 register
- * @tc35892:	Device to read from
+ * tc3589x_reg_read() - read a single TC3589x register
+ * @tc3589x:	Device to read from
  * @reg:	Register to read
  */
-int tc35892_reg_read(struct tc35892 *tc35892, u8 reg)
+int tc3589x_reg_read(struct tc3589x *tc3589x, u8 reg)
 {
 	int ret;
 
-	ret = i2c_smbus_read_byte_data(tc35892->i2c, reg);
+	ret = i2c_smbus_read_byte_data(tc3589x->i2c, reg);
 	if (ret < 0)
-		dev_err(tc35892->dev, "failed to read reg %#x: %d\n",
+		dev_err(tc3589x->dev, "failed to read reg %#x: %d\n",
 			reg, ret);
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tc35892_reg_read);
+EXPORT_SYMBOL_GPL(tc3589x_reg_read);
 
 /**
- * tc35892_reg_read() - write a single TC35892 register
- * @tc35892:	Device to write to
+ * tc3589x_reg_read() - write a single TC3589x register
+ * @tc3589x:	Device to write to
  * @reg:	Register to read
  * @data:	Value to write
  */
-int tc35892_reg_write(struct tc35892 *tc35892, u8 reg, u8 data)
+int tc3589x_reg_write(struct tc3589x *tc3589x, u8 reg, u8 data)
 {
 	int ret;
 
-	ret = i2c_smbus_write_byte_data(tc35892->i2c, reg, data);
+	ret = i2c_smbus_write_byte_data(tc3589x->i2c, reg, data);
 	if (ret < 0)
-		dev_err(tc35892->dev, "failed to write reg %#x: %d\n",
+		dev_err(tc3589x->dev, "failed to write reg %#x: %d\n",
 			reg, ret);
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tc35892_reg_write);
+EXPORT_SYMBOL_GPL(tc3589x_reg_write);
 
 /**
- * tc35892_block_read() - read multiple TC35892 registers
- * @tc35892:	Device to read from
+ * tc3589x_block_read() - read multiple TC3589x registers
+ * @tc3589x:	Device to read from
  * @reg:	First register
  * @length:	Number of registers
  * @values:	Buffer to write to
  */
-int tc35892_block_read(struct tc35892 *tc35892, u8 reg, u8 length, u8 *values)
+int tc3589x_block_read(struct tc3589x *tc3589x, u8 reg, u8 length, u8 *values)
 {
 	int ret;
 
-	ret = i2c_smbus_read_i2c_block_data(tc35892->i2c, reg, length, values);
+	ret = i2c_smbus_read_i2c_block_data(tc3589x->i2c, reg, length, values);
 	if (ret < 0)
-		dev_err(tc35892->dev, "failed to read regs %#x: %d\n",
+		dev_err(tc3589x->dev, "failed to read regs %#x: %d\n",
 			reg, ret);
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tc35892_block_read);
+EXPORT_SYMBOL_GPL(tc3589x_block_read);
 
 /**
- * tc35892_block_write() - write multiple TC35892 registers
- * @tc35892:	Device to write to
+ * tc3589x_block_write() - write multiple TC3589x registers
+ * @tc3589x:	Device to write to
  * @reg:	First register
  * @length:	Number of registers
  * @values:	Values to write
  */
-int tc35892_block_write(struct tc35892 *tc35892, u8 reg, u8 length,
+int tc3589x_block_write(struct tc3589x *tc3589x, u8 reg, u8 length,
 			const u8 *values)
 {
 	int ret;
 
-	ret = i2c_smbus_write_i2c_block_data(tc35892->i2c, reg, length,
+	ret = i2c_smbus_write_i2c_block_data(tc3589x->i2c, reg, length,
 					     values);
 	if (ret < 0)
-		dev_err(tc35892->dev, "failed to write regs %#x: %d\n",
+		dev_err(tc3589x->dev, "failed to write regs %#x: %d\n",
 			reg, ret);
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tc35892_block_write);
+EXPORT_SYMBOL_GPL(tc3589x_block_write);
 
 /**
- * tc35892_set_bits() - set the value of a bitfield in a TC35892 register
- * @tc35892:	Device to write to
+ * tc3589x_set_bits() - set the value of a bitfield in a TC3589x register
+ * @tc3589x:	Device to write to
  * @reg:	Register to write
  * @mask:	Mask of bits to set
  * @values:	Value to set
  */
-int tc35892_set_bits(struct tc35892 *tc35892, u8 reg, u8 mask, u8 val)
+int tc3589x_set_bits(struct tc3589x *tc3589x, u8 reg, u8 mask, u8 val)
 {
 	int ret;
 
-	mutex_lock(&tc35892->lock);
+	mutex_lock(&tc3589x->lock);
 
-	ret = tc35892_reg_read(tc35892, reg);
+	ret = tc3589x_reg_read(tc3589x, reg);
 	if (ret < 0)
 		goto out;
 
 	ret &= ~mask;
 	ret |= val;
 
-	ret = tc35892_reg_write(tc35892, reg, ret);
+	ret = tc3589x_reg_write(tc3589x, reg, ret);
 
 out:
-	mutex_unlock(&tc35892->lock);
+	mutex_unlock(&tc3589x->lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(tc35892_set_bits);
+EXPORT_SYMBOL_GPL(tc3589x_set_bits);
 
 static struct resource gpio_resources[] = {
 	{
-		.start	= TC35892_INT_GPIIRQ,
-		.end	= TC35892_INT_GPIIRQ,
+		.start	= TC3589x_INT_GPIIRQ,
+		.end	= TC3589x_INT_GPIIRQ,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
 
-static struct mfd_cell tc35892_devs[] = {
+static struct mfd_cell tc3589x_devs[] = {
 	{
-		.name		= "tc35892-gpio",
+		.name		= "tc3589x-gpio",
 		.num_resources	= ARRAY_SIZE(gpio_resources),
 		.resources	= &gpio_resources[0],
 	},
 };
 
-static irqreturn_t tc35892_irq(int irq, void *data)
+static irqreturn_t tc3589x_irq(int irq, void *data)
 {
-	struct tc35892 *tc35892 = data;
+	struct tc3589x *tc3589x = data;
 	int status;
 
-	status = tc35892_reg_read(tc35892, TC35892_IRQST);
+	status = tc3589x_reg_read(tc3589x, TC3589x_IRQST);
 	if (status < 0)
 		return IRQ_NONE;
 
 	while (status) {
 		int bit = __ffs(status);
 
-		handle_nested_irq(tc35892->irq_base + bit);
+		handle_nested_irq(tc3589x->irq_base + bit);
 		status &= ~(1 << bit);
 	}
 
@@ -158,30 +158,30 @@ static irqreturn_t tc35892_irq(int irq, void *data)
 	 * have the last interrupt clear (for example, GPIO IC write) take
 	 * effect.
 	 */
-	tc35892_reg_read(tc35892, TC35892_IRQST);
+	tc3589x_reg_read(tc3589x, TC3589x_IRQST);
 
 	return IRQ_HANDLED;
 }
 
-static void tc35892_irq_dummy(unsigned int irq)
+static void tc3589x_irq_dummy(unsigned int irq)
 {
 	/* No mask/unmask at this level */
 }
 
-static struct irq_chip tc35892_irq_chip = {
-	.name	= "tc35892",
-	.mask	= tc35892_irq_dummy,
-	.unmask	= tc35892_irq_dummy,
+static struct irq_chip tc3589x_irq_chip = {
+	.name	= "tc3589x",
+	.mask	= tc3589x_irq_dummy,
+	.unmask	= tc3589x_irq_dummy,
 };
 
-static int tc35892_irq_init(struct tc35892 *tc35892)
+static int tc3589x_irq_init(struct tc3589x *tc3589x)
 {
-	int base = tc35892->irq_base;
+	int base = tc3589x->irq_base;
 	int irq;
 
-	for (irq = base; irq < base + TC35892_NR_INTERNAL_IRQS; irq++) {
-		set_irq_chip_data(irq, tc35892);
-		set_irq_chip_and_handler(irq, &tc35892_irq_chip,
+	for (irq = base; irq < base + TC3589x_NR_INTERNAL_IRQS; irq++) {
+		set_irq_chip_data(irq, tc3589x);
+		set_irq_chip_and_handler(irq, &tc3589x_irq_chip,
 					 handle_edge_irq);
 		set_irq_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
@@ -194,12 +194,12 @@ static int tc35892_irq_init(struct tc35892 *tc35892)
 	return 0;
 }
 
-static void tc35892_irq_remove(struct tc35892 *tc35892)
+static void tc3589x_irq_remove(struct tc3589x *tc3589x)
 {
-	int base = tc35892->irq_base;
+	int base = tc3589x->irq_base;
 	int irq;
 
-	for (irq = base; irq < base + TC35892_NR_INTERNAL_IRQS; irq++) {
+	for (irq = base; irq < base + TC3589x_NR_INTERNAL_IRQS; irq++) {
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
@@ -208,138 +208,138 @@ static void tc35892_irq_remove(struct tc35892 *tc35892)
 	}
 }
 
-static int tc35892_chip_init(struct tc35892 *tc35892)
+static int tc3589x_chip_init(struct tc3589x *tc3589x)
 {
 	int manf, ver, ret;
 
-	manf = tc35892_reg_read(tc35892, TC35892_MANFCODE);
+	manf = tc3589x_reg_read(tc3589x, TC3589x_MANFCODE);
 	if (manf < 0)
 		return manf;
 
-	ver = tc35892_reg_read(tc35892, TC35892_VERSION);
+	ver = tc3589x_reg_read(tc3589x, TC3589x_VERSION);
 	if (ver < 0)
 		return ver;
 
-	if (manf != TC35892_MANFCODE_MAGIC) {
-		dev_err(tc35892->dev, "unknown manufacturer: %#x\n", manf);
+	if (manf != TC3589x_MANFCODE_MAGIC) {
+		dev_err(tc3589x->dev, "unknown manufacturer: %#x\n", manf);
 		return -EINVAL;
 	}
 
-	dev_info(tc35892->dev, "manufacturer: %#x, version: %#x\n", manf, ver);
+	dev_info(tc3589x->dev, "manufacturer: %#x, version: %#x\n", manf, ver);
 
 	/* Put everything except the IRQ module into reset */
-	ret = tc35892_reg_write(tc35892, TC35892_RSTCTRL,
-				TC35892_RSTCTRL_TIMRST
-				| TC35892_RSTCTRL_ROTRST
-				| TC35892_RSTCTRL_KBDRST
-				| TC35892_RSTCTRL_GPIRST);
+	ret = tc3589x_reg_write(tc3589x, TC3589x_RSTCTRL,
+				TC3589x_RSTCTRL_TIMRST
+				| TC3589x_RSTCTRL_ROTRST
+				| TC3589x_RSTCTRL_KBDRST
+				| TC3589x_RSTCTRL_GPIRST);
 	if (ret < 0)
 		return ret;
 
 	/* Clear the reset interrupt. */
-	return tc35892_reg_write(tc35892, TC35892_RSTINTCLR, 0x1);
+	return tc3589x_reg_write(tc3589x, TC3589x_RSTINTCLR, 0x1);
 }
 
-static int __devinit tc35892_probe(struct i2c_client *i2c,
+static int __devinit tc3589x_probe(struct i2c_client *i2c,
 				   const struct i2c_device_id *id)
 {
-	struct tc35892_platform_data *pdata = i2c->dev.platform_data;
-	struct tc35892 *tc35892;
+	struct tc3589x_platform_data *pdata = i2c->dev.platform_data;
+	struct tc3589x *tc3589x;
 	int ret;
 
 	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_SMBUS_BYTE_DATA
 				     | I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
-	tc35892 = kzalloc(sizeof(struct tc35892), GFP_KERNEL);
-	if (!tc35892)
+	tc3589x = kzalloc(sizeof(struct tc3589x), GFP_KERNEL);
+	if (!tc3589x)
 		return -ENOMEM;
 
-	mutex_init(&tc35892->lock);
+	mutex_init(&tc3589x->lock);
 
-	tc35892->dev = &i2c->dev;
-	tc35892->i2c = i2c;
-	tc35892->pdata = pdata;
-	tc35892->irq_base = pdata->irq_base;
-	tc35892->num_gpio = id->driver_data;
+	tc3589x->dev = &i2c->dev;
+	tc3589x->i2c = i2c;
+	tc3589x->pdata = pdata;
+	tc3589x->irq_base = pdata->irq_base;
+	tc3589x->num_gpio = id->driver_data;
 
-	i2c_set_clientdata(i2c, tc35892);
+	i2c_set_clientdata(i2c, tc3589x);
 
-	ret = tc35892_chip_init(tc35892);
+	ret = tc3589x_chip_init(tc3589x);
 	if (ret)
 		goto out_free;
 
-	ret = tc35892_irq_init(tc35892);
+	ret = tc3589x_irq_init(tc3589x);
 	if (ret)
 		goto out_free;
 
-	ret = request_threaded_irq(tc35892->i2c->irq, NULL, tc35892_irq,
+	ret = request_threaded_irq(tc3589x->i2c->irq, NULL, tc3589x_irq,
 				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				   "tc35892", tc35892);
+				   "tc3589x", tc3589x);
 	if (ret) {
-		dev_err(tc35892->dev, "failed to request IRQ: %d\n", ret);
+		dev_err(tc3589x->dev, "failed to request IRQ: %d\n", ret);
 		goto out_removeirq;
 	}
 
-	ret = mfd_add_devices(tc35892->dev, -1, tc35892_devs,
-			      ARRAY_SIZE(tc35892_devs), NULL,
-			      tc35892->irq_base);
+	ret = mfd_add_devices(tc3589x->dev, -1, tc3589x_devs,
+			      ARRAY_SIZE(tc3589x_devs), NULL,
+			      tc3589x->irq_base);
 	if (ret) {
-		dev_err(tc35892->dev, "failed to add children\n");
+		dev_err(tc3589x->dev, "failed to add children\n");
 		goto out_freeirq;
 	}
 
 	return 0;
 
 out_freeirq:
-	free_irq(tc35892->i2c->irq, tc35892);
+	free_irq(tc3589x->i2c->irq, tc3589x);
 out_removeirq:
-	tc35892_irq_remove(tc35892);
+	tc3589x_irq_remove(tc3589x);
 out_free:
-	kfree(tc35892);
+	kfree(tc3589x);
 	return ret;
 }
 
-static int __devexit tc35892_remove(struct i2c_client *client)
+static int __devexit tc3589x_remove(struct i2c_client *client)
 {
-	struct tc35892 *tc35892 = i2c_get_clientdata(client);
+	struct tc3589x *tc3589x = i2c_get_clientdata(client);
 
-	mfd_remove_devices(tc35892->dev);
+	mfd_remove_devices(tc3589x->dev);
 
-	free_irq(tc35892->i2c->irq, tc35892);
-	tc35892_irq_remove(tc35892);
+	free_irq(tc3589x->i2c->irq, tc3589x);
+	tc3589x_irq_remove(tc3589x);
 
-	kfree(tc35892);
+	kfree(tc3589x);
 
 	return 0;
 }
 
-static const struct i2c_device_id tc35892_id[] = {
-	{ "tc35892", 24 },
+static const struct i2c_device_id tc3589x_id[] = {
+	{ "tc3589x", 24 },
 	{ }
 };
-MODULE_DEVICE_TABLE(i2c, tc35892_id);
+MODULE_DEVICE_TABLE(i2c, tc3589x_id);
 
-static struct i2c_driver tc35892_driver = {
-	.driver.name	= "tc35892",
+static struct i2c_driver tc3589x_driver = {
+	.driver.name	= "tc3589x",
 	.driver.owner	= THIS_MODULE,
-	.probe		= tc35892_probe,
-	.remove		= __devexit_p(tc35892_remove),
-	.id_table	= tc35892_id,
+	.probe		= tc3589x_probe,
+	.remove		= __devexit_p(tc3589x_remove),
+	.id_table	= tc3589x_id,
 };
 
-static int __init tc35892_init(void)
+static int __init tc3589x_init(void)
 {
-	return i2c_add_driver(&tc35892_driver);
+	return i2c_add_driver(&tc3589x_driver);
 }
-subsys_initcall(tc35892_init);
+subsys_initcall(tc3589x_init);
 
-static void __exit tc35892_exit(void)
+static void __exit tc3589x_exit(void)
 {
-	i2c_del_driver(&tc35892_driver);
+	i2c_del_driver(&tc3589x_driver);
 }
-module_exit(tc35892_exit);
+module_exit(tc3589x_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("TC35892 MFD core driver");
+MODULE_DESCRIPTION("TC3589x MFD core driver");
 MODULE_AUTHOR("Hanumath Prasad, Rabin Vincent");
diff --git a/include/linux/mfd/tc3589x.h b/include/linux/mfd/tc3589x.h
index eff3094..ea19188 100644
--- a/include/linux/mfd/tc3589x.h
+++ b/include/linux/mfd/tc3589x.h
@@ -4,133 +4,133 @@
  * License Terms: GNU General Public License, version 2
  */
 
-#ifndef __LINUX_MFD_TC35892_H
-#define __LINUX_MFD_TC35892_H
+#ifndef __LINUX_MFD_TC3589x_H
+#define __LINUX_MFD_TC3589x_H
 
 #include <linux/device.h>
 
-#define TC35892_RSTCTRL_IRQRST	(1 << 4)
-#define TC35892_RSTCTRL_TIMRST	(1 << 3)
-#define TC35892_RSTCTRL_ROTRST	(1 << 2)
-#define TC35892_RSTCTRL_KBDRST	(1 << 1)
-#define TC35892_RSTCTRL_GPIRST	(1 << 0)
-
-#define TC35892_IRQST		0x91
-
-#define TC35892_MANFCODE_MAGIC	0x03
-#define TC35892_MANFCODE	0x80
-#define TC35892_VERSION		0x81
-#define TC35892_IOCFG		0xA7
-
-#define TC35892_CLKMODE		0x88
-#define TC35892_CLKCFG		0x89
-#define TC35892_CLKEN		0x8A
-
-#define TC35892_RSTCTRL		0x82
-#define TC35892_EXTRSTN		0x83
-#define TC35892_RSTINTCLR	0x84
-
-#define TC35892_GPIOIS0		0xC9
-#define TC35892_GPIOIS1		0xCA
-#define TC35892_GPIOIS2		0xCB
-#define TC35892_GPIOIBE0	0xCC
-#define TC35892_GPIOIBE1	0xCD
-#define TC35892_GPIOIBE2	0xCE
-#define TC35892_GPIOIEV0	0xCF
-#define TC35892_GPIOIEV1	0xD0
-#define TC35892_GPIOIEV2	0xD1
-#define TC35892_GPIOIE0		0xD2
-#define TC35892_GPIOIE1		0xD3
-#define TC35892_GPIOIE2		0xD4
-#define TC35892_GPIORIS0	0xD6
-#define TC35892_GPIORIS1	0xD7
-#define TC35892_GPIORIS2	0xD8
-#define TC35892_GPIOMIS0	0xD9
-#define TC35892_GPIOMIS1	0xDA
-#define TC35892_GPIOMIS2	0xDB
-#define TC35892_GPIOIC0		0xDC
-#define TC35892_GPIOIC1		0xDD
-#define TC35892_GPIOIC2		0xDE
-
-#define TC35892_GPIODATA0	0xC0
-#define TC35892_GPIOMASK0	0xc1
-#define TC35892_GPIODATA1	0xC2
-#define TC35892_GPIOMASK1	0xc3
-#define TC35892_GPIODATA2	0xC4
-#define TC35892_GPIOMASK2	0xC5
-
-#define TC35892_GPIODIR0	0xC6
-#define TC35892_GPIODIR1	0xC7
-#define TC35892_GPIODIR2	0xC8
-
-#define TC35892_GPIOSYNC0	0xE6
-#define TC35892_GPIOSYNC1	0xE7
-#define TC35892_GPIOSYNC2	0xE8
-
-#define TC35892_GPIOWAKE0	0xE9
-#define TC35892_GPIOWAKE1	0xEA
-#define TC35892_GPIOWAKE2	0xEB
-
-#define TC35892_GPIOODM0	0xE0
-#define TC35892_GPIOODE0	0xE1
-#define TC35892_GPIOODM1	0xE2
-#define TC35892_GPIOODE1	0xE3
-#define TC35892_GPIOODM2	0xE4
-#define TC35892_GPIOODE2	0xE5
-
-#define TC35892_INT_GPIIRQ	0
-#define TC35892_INT_TI0IRQ	1
-#define TC35892_INT_TI1IRQ	2
-#define TC35892_INT_TI2IRQ	3
-#define TC35892_INT_ROTIRQ	5
-#define TC35892_INT_KBDIRQ	6
-#define TC35892_INT_PORIRQ	7
-
-#define TC35892_NR_INTERNAL_IRQS	8
-#define TC35892_INT_GPIO(x)	(TC35892_NR_INTERNAL_IRQS + (x))
-
-struct tc35892 {
+#define TC3589x_RSTCTRL_IRQRST	(1 << 4)
+#define TC3589x_RSTCTRL_TIMRST	(1 << 3)
+#define TC3589x_RSTCTRL_ROTRST	(1 << 2)
+#define TC3589x_RSTCTRL_KBDRST	(1 << 1)
+#define TC3589x_RSTCTRL_GPIRST	(1 << 0)
+
+#define TC3589x_IRQST		0x91
+
+#define TC3589x_MANFCODE_MAGIC	0x03
+#define TC3589x_MANFCODE	0x80
+#define TC3589x_VERSION		0x81
+#define TC3589x_IOCFG		0xA7
+
+#define TC3589x_CLKMODE		0x88
+#define TC3589x_CLKCFG		0x89
+#define TC3589x_CLKEN		0x8A
+
+#define TC3589x_RSTCTRL		0x82
+#define TC3589x_EXTRSTN		0x83
+#define TC3589x_RSTINTCLR	0x84
+
+#define TC3589x_GPIOIS0		0xC9
+#define TC3589x_GPIOIS1		0xCA
+#define TC3589x_GPIOIS2		0xCB
+#define TC3589x_GPIOIBE0	0xCC
+#define TC3589x_GPIOIBE1	0xCD
+#define TC3589x_GPIOIBE2	0xCE
+#define TC3589x_GPIOIEV0	0xCF
+#define TC3589x_GPIOIEV1	0xD0
+#define TC3589x_GPIOIEV2	0xD1
+#define TC3589x_GPIOIE0		0xD2
+#define TC3589x_GPIOIE1		0xD3
+#define TC3589x_GPIOIE2		0xD4
+#define TC3589x_GPIORIS0	0xD6
+#define TC3589x_GPIORIS1	0xD7
+#define TC3589x_GPIORIS2	0xD8
+#define TC3589x_GPIOMIS0	0xD9
+#define TC3589x_GPIOMIS1	0xDA
+#define TC3589x_GPIOMIS2	0xDB
+#define TC3589x_GPIOIC0		0xDC
+#define TC3589x_GPIOIC1		0xDD
+#define TC3589x_GPIOIC2		0xDE
+
+#define TC3589x_GPIODATA0	0xC0
+#define TC3589x_GPIOMASK0	0xc1
+#define TC3589x_GPIODATA1	0xC2
+#define TC3589x_GPIOMASK1	0xc3
+#define TC3589x_GPIODATA2	0xC4
+#define TC3589x_GPIOMASK2	0xC5
+
+#define TC3589x_GPIODIR0	0xC6
+#define TC3589x_GPIODIR1	0xC7
+#define TC3589x_GPIODIR2	0xC8
+
+#define TC3589x_GPIOSYNC0	0xE6
+#define TC3589x_GPIOSYNC1	0xE7
+#define TC3589x_GPIOSYNC2	0xE8
+
+#define TC3589x_GPIOWAKE0	0xE9
+#define TC3589x_GPIOWAKE1	0xEA
+#define TC3589x_GPIOWAKE2	0xEB
+
+#define TC3589x_GPIOODM0	0xE0
+#define TC3589x_GPIOODE0	0xE1
+#define TC3589x_GPIOODM1	0xE2
+#define TC3589x_GPIOODE1	0xE3
+#define TC3589x_GPIOODM2	0xE4
+#define TC3589x_GPIOODE2	0xE5
+
+#define TC3589x_INT_GPIIRQ	0
+#define TC3589x_INT_TI0IRQ	1
+#define TC3589x_INT_TI1IRQ	2
+#define TC3589x_INT_TI2IRQ	3
+#define TC3589x_INT_ROTIRQ	5
+#define TC3589x_INT_KBDIRQ	6
+#define TC3589x_INT_PORIRQ	7
+
+#define TC3589x_NR_INTERNAL_IRQS	8
+#define TC3589x_INT_GPIO(x)	(TC3589x_NR_INTERNAL_IRQS + (x))
+
+struct tc3589x {
 	struct mutex lock;
 	struct device *dev;
 	struct i2c_client *i2c;
 
 	int irq_base;
 	int num_gpio;
-	struct tc35892_platform_data *pdata;
+	struct tc3589x_platform_data *pdata;
 };
 
-extern int tc35892_reg_write(struct tc35892 *tc35892, u8 reg, u8 data);
-extern int tc35892_reg_read(struct tc35892 *tc35892, u8 reg);
-extern int tc35892_block_read(struct tc35892 *tc35892, u8 reg, u8 length,
+extern int tc3589x_reg_write(struct tc3589x *tc3589x, u8 reg, u8 data);
+extern int tc3589x_reg_read(struct tc3589x *tc3589x, u8 reg);
+extern int tc3589x_block_read(struct tc3589x *tc3589x, u8 reg, u8 length,
 			      u8 *values);
-extern int tc35892_block_write(struct tc35892 *tc35892, u8 reg, u8 length,
+extern int tc3589x_block_write(struct tc3589x *tc3589x, u8 reg, u8 length,
 			       const u8 *values);
-extern int tc35892_set_bits(struct tc35892 *tc35892, u8 reg, u8 mask, u8 val);
+extern int tc3589x_set_bits(struct tc3589x *tc3589x, u8 reg, u8 mask, u8 val);
 
 /**
- * struct tc35892_gpio_platform_data - TC35892 GPIO platform data
- * @gpio_base: first gpio number assigned to TC35892.  A maximum of
- *	       %TC35892_NR_GPIOS GPIOs will be allocated.
+ * struct tc3589x_gpio_platform_data - TC3589x GPIO platform data
+ * @gpio_base: first gpio number assigned to TC3589x.  A maximum of
+ *	       %TC3589x_NR_GPIOS GPIOs will be allocated.
  * @setup: callback for board-specific initialization
  * @remove: callback for board-specific teardown
  */
-struct tc35892_gpio_platform_data {
+struct tc3589x_gpio_platform_data {
 	int gpio_base;
-	void (*setup)(struct tc35892 *tc35892, unsigned gpio_base);
-	void (*remove)(struct tc35892 *tc35892, unsigned gpio_base);
+	void (*setup)(struct tc3589x *tc3589x, unsigned gpio_base);
+	void (*remove)(struct tc3589x *tc3589x, unsigned gpio_base);
 };
 
 /**
- * struct tc35892_platform_data - TC35892 platform data
- * @irq_base: base IRQ number.  %TC35892_NR_IRQS irqs will be used.
+ * struct tc3589x_platform_data - TC3589x platform data
+ * @irq_base: base IRQ number.  %TC3589x_NR_IRQS irqs will be used.
  * @gpio: GPIO-specific platform data
  */
-struct tc35892_platform_data {
+struct tc3589x_platform_data {
 	int irq_base;
-	struct tc35892_gpio_platform_data *gpio;
+	struct tc3589x_gpio_platform_data *gpio;
 };
 
-#define TC35892_NR_GPIOS	24
-#define TC35892_NR_IRQS		TC35892_INT_GPIO(TC35892_NR_GPIOS)
+#define TC3589x_NR_GPIOS	24
+#define TC3589x_NR_IRQS		TC3589x_INT_GPIO(TC3589x_NR_GPIOS)
 
 #endif
-- 
1.7.2.dirty

