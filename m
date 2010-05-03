Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0ECDoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 23:44:15 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:54539 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688Ab0ECDoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 23:44:12 -0400
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>, <STEricsson_nomadik_linux@list.st.com>,
       Rabin Vincent <rabin.vincent@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/2] gpio: add TC35892 GPIO driver
Date: Mon, 3 May 2010 08:45:30 +0530
Message-ID: <1272856530-4409-2-git-send-email-rabin.vincent@stericsson.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1272856530-4409-1-git-send-email-rabin.vincent@stericsson.com>
References: <1272856530-4409-1-git-send-email-rabin.vincent@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a GPIO driver to support the GPIOs on the TC35892 I/O Expander.

Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
Resend because of the vger outage.  Apologies if you're receiving it twice.

 drivers/gpio/Kconfig        |    7 +
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/tc35892-gpio.c |  379 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 387 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/tc35892-gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 1f38ff3..bde1bad 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -188,6 +188,13 @@ config GPIO_PCF857X
 	  This driver provides an in-kernel interface to those GPIOs using
 	  platform-neutral GPIO calls.
 
+config GPIO_TC35892
+	bool "TC35892 GPIOs"
+	depends on MFD_TC35892
+	help
+	  This enables support for the GPIOs found on the TC35892
+	  I/O Expander.
+
 config GPIO_TWL4030
 	tristate "TWL4030, TWL5030, and TPS659x0 GPIOs"
 	depends on TWL4030_CORE
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 94a96c5..51c3cdd 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_PL061)	+= pl061.o
+obj-$(CONFIG_GPIO_TC35892)	+= tc35892-gpio.o
 obj-$(CONFIG_GPIO_TIMBERDALE)	+= timbgpio.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_UCB1400)	+= ucb1400_gpio.o
diff --git a/drivers/gpio/tc35892-gpio.c b/drivers/gpio/tc35892-gpio.c
new file mode 100644
index 0000000..46aa4cf
--- /dev/null
+++ b/drivers/gpio/tc35892-gpio.c
@@ -0,0 +1,379 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License, version 2
+ * Author: Hanumath Prasad <hanumath.prasad@stericsson.com> for ST-Ericsson
+ * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/tc35892.h>
+
+/*
+ * These registers are modified under the irq bus lock and cached to avoid
+ * unnecessary writes in bus_sync_unlock.
+ */
+enum { REG_IBE, REG_IEV, REG_IS, REG_IE };
+
+#define CACHE_NR_REGS	4
+#define CACHE_NR_BANKS	3
+
+struct tc35892_gpio {
+	struct gpio_chip chip;
+	struct tc35892 *tc35892;
+	struct device *dev;
+	struct mutex irq_lock;
+
+	int irq_base;
+
+	/* Caches of interrupt control registers for bus_lock */
+	u8 regs[CACHE_NR_REGS][CACHE_NR_BANKS];
+	u8 oldregs[CACHE_NR_REGS][CACHE_NR_BANKS];
+};
+
+static inline struct tc35892_gpio *to_tc35892_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct tc35892_gpio, chip);
+}
+
+static int tc35892_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct tc35892_gpio *tc35892_gpio = to_tc35892_gpio(chip);
+	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
+	u8 reg = TC35892_GPIODATA0 + (offset / 8) * 2;
+	u8 mask = 1 << (offset % 8);
+	int ret;
+
+	ret = tc35892_reg_read(tc35892, reg);
+	if (ret < 0)
+		return ret;
+
+	return ret & mask;
+}
+
+static void tc35892_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
+{
+	struct tc35892_gpio *tc35892_gpio = to_tc35892_gpio(chip);
+	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
+	u8 reg = TC35892_GPIODATA0 + (offset / 8) * 2;
+	unsigned pos = offset % 8;
+	u8 data[] = {!!val << pos, 1 << pos};
+
+	tc35892_block_write(tc35892, reg, ARRAY_SIZE(data), data);
+}
+
+static int tc35892_gpio_direction_output(struct gpio_chip *chip,
+					 unsigned offset, int val)
+{
+	struct tc35892_gpio *tc35892_gpio = to_tc35892_gpio(chip);
+	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
+	u8 reg = TC35892_GPIODIR0 + offset / 8;
+	unsigned pos = offset % 8;
+
+	tc35892_gpio_set(chip, offset, val);
+
+	return tc35892_set_bits(tc35892, reg, 1 << pos, 1 << pos);
+}
+
+static int tc35892_gpio_direction_input(struct gpio_chip *chip,
+					unsigned offset)
+{
+	struct tc35892_gpio *tc35892_gpio = to_tc35892_gpio(chip);
+	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
+	u8 reg = TC35892_GPIODIR0 + offset / 8;
+	unsigned pos = offset % 8;
+
+	return tc35892_set_bits(tc35892, reg, 1 << pos, 0);
+}
+
+static int tc35892_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct tc35892_gpio *tc35892_gpio = to_tc35892_gpio(chip);
+
+	return tc35892_gpio->irq_base + offset;
+}
+
+static struct gpio_chip template_chip = {
+	.label			= "tc35892",
+	.owner			= THIS_MODULE,
+	.direction_input	= tc35892_gpio_direction_input,
+	.get			= tc35892_gpio_get,
+	.direction_output	= tc35892_gpio_direction_output,
+	.set			= tc35892_gpio_set,
+	.to_irq			= tc35892_gpio_to_irq,
+	.can_sleep		= 1,
+};
+
+static int tc35892_gpio_irq_set_type(unsigned int irq, unsigned int type)
+{
+	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
+	int offset = irq - tc35892_gpio->irq_base;
+	int regoffset = offset / 8;
+	int mask = 1 << (offset % 8);
+
+	if (type == IRQ_TYPE_EDGE_BOTH) {
+		tc35892_gpio->regs[REG_IBE][regoffset] |= mask;
+		return 0;
+	}
+
+	tc35892_gpio->regs[REG_IBE][regoffset] &= ~mask;
+
+	if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_LEVEL_HIGH)
+		tc35892_gpio->regs[REG_IS][regoffset] |= mask;
+	else
+		tc35892_gpio->regs[REG_IS][regoffset] &= ~mask;
+
+	if (type == IRQ_TYPE_EDGE_RISING || type == IRQ_TYPE_LEVEL_HIGH)
+		tc35892_gpio->regs[REG_IEV][regoffset] |= mask;
+	else
+		tc35892_gpio->regs[REG_IEV][regoffset] &= ~mask;
+
+	return 0;
+}
+
+static void tc35892_gpio_irq_lock(unsigned int irq)
+{
+	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
+
+	mutex_lock(&tc35892_gpio->irq_lock);
+}
+
+static void tc35892_gpio_irq_sync_unlock(unsigned int irq)
+{
+	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
+	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
+	static const u8 regmap[] = {
+		[REG_IBE]	= TC35892_GPIOIBE0,
+		[REG_IEV]	= TC35892_GPIOIEV0,
+		[REG_IS]	= TC35892_GPIOIS0,
+		[REG_IE]	= TC35892_GPIOIE0,
+	};
+	int i, j;
+
+	for (i = 0; i < CACHE_NR_REGS; i++) {
+		for (j = 0; j < CACHE_NR_BANKS; j++) {
+			u8 old = tc35892_gpio->oldregs[i][j];
+			u8 new = tc35892_gpio->regs[i][j];
+
+			if (new == old)
+				continue;
+
+			tc35892_gpio->oldregs[i][j] = new;
+			tc35892_reg_write(tc35892, regmap[i] + j * 8, new);
+		}
+	}
+
+	mutex_unlock(&tc35892_gpio->irq_lock);
+}
+
+static void tc35892_gpio_irq_mask(unsigned int irq)
+{
+	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
+	int offset = irq - tc35892_gpio->irq_base;
+	int regoffset = offset / 8;
+	int mask = 1 << (offset % 8);
+
+	tc35892_gpio->regs[REG_IE][regoffset] &= ~mask;
+}
+
+static void tc35892_gpio_irq_unmask(unsigned int irq)
+{
+	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
+	int offset = irq - tc35892_gpio->irq_base;
+	int regoffset = offset / 8;
+	int mask = 1 << (offset % 8);
+
+	tc35892_gpio->regs[REG_IE][regoffset] |= mask;
+}
+
+static struct irq_chip tc35892_gpio_irq_chip = {
+	.name			= "tc35892-gpio",
+	.bus_lock		= tc35892_gpio_irq_lock,
+	.bus_sync_unlock	= tc35892_gpio_irq_sync_unlock,
+	.mask			= tc35892_gpio_irq_mask,
+	.unmask			= tc35892_gpio_irq_unmask,
+	.set_type		= tc35892_gpio_irq_set_type,
+};
+
+static irqreturn_t tc35892_gpio_irq(int irq, void *dev)
+{
+	struct tc35892_gpio *tc35892_gpio = dev;
+	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
+	u8 status[CACHE_NR_BANKS];
+	int ret;
+	int i;
+
+	ret = tc35892_block_read(tc35892, TC35892_GPIOMIS0,
+				 ARRAY_SIZE(status), status);
+	if (ret < 0)
+		return IRQ_NONE;
+
+	for (i = 0; i < ARRAY_SIZE(status); i++) {
+		unsigned int stat = status[i];
+		if (!stat)
+			continue;
+
+		while (stat) {
+			int bit = __ffs(stat);
+			int line = i * 8 + bit;
+
+			handle_nested_irq(tc35892_gpio->irq_base + line);
+			stat &= ~(1 << bit);
+		}
+
+		tc35892_reg_write(tc35892, TC35892_GPIOIC0 + i, status[i]);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int tc35892_gpio_irq_init(struct tc35892_gpio *tc35892_gpio)
+{
+	int base = tc35892_gpio->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + tc35892_gpio->chip.ngpio; irq++) {
+		set_irq_chip_data(irq, tc35892_gpio);
+		set_irq_chip_and_handler(irq, &tc35892_gpio_irq_chip,
+					 handle_simple_irq);
+		set_irq_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, IRQF_VALID);
+#else
+		set_irq_noprobe(irq);
+#endif
+	}
+
+	return 0;
+}
+
+static void tc35892_gpio_irq_remove(struct tc35892_gpio *tc35892_gpio)
+{
+	int base = tc35892_gpio->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + tc35892_gpio->chip.ngpio; irq++) {
+		set_irq_flags(irq, 0);
+		set_irq_chip_and_handler(irq, NULL, NULL);
+		set_irq_chip_data(irq, NULL);
+	}
+}
+
+static int __devinit tc35892_gpio_probe(struct platform_device *pdev)
+{
+	struct tc35892 *tc35892 = dev_get_drvdata(pdev->dev.parent);
+	struct tc35892_gpio_platform_data *pdata;
+	struct tc35892_gpio *tc35892_gpio;
+	int ret;
+	int irq;
+
+	pdata = tc35892->pdata->gpio;
+	if (!pdata)
+		return -ENODEV;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	tc35892_gpio = kzalloc(sizeof(struct tc35892_gpio), GFP_KERNEL);
+	if (!tc35892_gpio)
+		return -ENOMEM;
+
+	mutex_init(&tc35892_gpio->irq_lock);
+
+	tc35892_gpio->dev = &pdev->dev;
+	tc35892_gpio->tc35892 = tc35892;
+
+	tc35892_gpio->chip = template_chip;
+	tc35892_gpio->chip.ngpio = tc35892->num_gpio;
+	tc35892_gpio->chip.dev = &pdev->dev;
+	tc35892_gpio->chip.base = pdata->gpio_base;
+
+	tc35892_gpio->irq_base = tc35892->irq_base + TC35892_INT_GPIO(0);
+
+	/* Bring the GPIO module out of reset */
+	ret = tc35892_set_bits(tc35892, TC35892_RSTCTRL,
+			       TC35892_RSTCTRL_GPIRST, 0);
+	if (ret < 0)
+		goto out_free;
+
+	ret = tc35892_gpio_irq_init(tc35892_gpio);
+	if (ret)
+		goto out_free;
+
+	ret = request_threaded_irq(irq, NULL, tc35892_gpio_irq, IRQF_ONESHOT,
+				   "tc35892-gpio", tc35892_gpio);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to get irq: %d\n", ret);
+		goto out_removeirq;
+	}
+
+	ret = gpiochip_add(&tc35892_gpio->chip);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to add gpiochip: %d\n", ret);
+		goto out_freeirq;
+	}
+
+	platform_set_drvdata(pdev, tc35892_gpio);
+
+	return 0;
+
+out_freeirq:
+	free_irq(irq, tc35892_gpio);
+out_removeirq:
+	tc35892_gpio_irq_remove(tc35892_gpio);
+out_free:
+	kfree(tc35892_gpio);
+	return ret;
+}
+
+static int __devexit tc35892_gpio_remove(struct platform_device *pdev)
+{
+	struct tc35892_gpio *tc35892_gpio = platform_get_drvdata(pdev);
+	int irq = platform_get_irq(pdev, 0);
+	int ret;
+
+	ret = gpiochip_remove(&tc35892_gpio->chip);
+	if (ret < 0) {
+		dev_err(tc35892_gpio->dev,
+			"unable to remove gpiochip: %d\n", ret);
+		return ret;
+	}
+
+	free_irq(irq, tc35892_gpio);
+	tc35892_gpio_irq_remove(tc35892_gpio);
+
+	platform_set_drvdata(pdev, NULL);
+	kfree(tc35892_gpio);
+
+	return 0;
+}
+
+static struct platform_driver tc35892_gpio_driver = {
+	.driver.name	= "tc35892-gpio",
+	.driver.owner	= THIS_MODULE,
+	.probe		= tc35892_gpio_probe,
+	.remove		= __devexit_p(tc35892_gpio_remove),
+};
+
+static int __init tc35892_gpio_init(void)
+{
+	return platform_driver_register(&tc35892_gpio_driver);
+}
+subsys_initcall(tc35892_gpio_init);
+
+static void __exit tc35892_gpio_exit(void)
+{
+	platform_driver_unregister(&tc35892_gpio_driver);
+}
+module_exit(tc35892_gpio_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("TC35892 GPIO driver");
+MODULE_AUTHOR("Hanumath Prasad, Rabin Vincent");
-- 
1.7.0

