Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0EaMR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 08:17:58 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:46564 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019Ab0EaMRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 08:17:47 -0400
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>, <STEricsson_nomadik_linux@list.st.com>,
       Rabin Vincent <rabin.vincent@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/3] gpio: add STMPExxxx GPIO driver
Date: Mon, 31 May 2010 17:47:15 +0530
Message-ID: <1275308236-1775-2-git-send-email-rabin.vincent@stericsson.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1275308236-1775-1-git-send-email-rabin.vincent@stericsson.com>
References: <1275308236-1775-1-git-send-email-rabin.vincent@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the GPIOs on the STMPExxxx I/O Expanders.

Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
 drivers/gpio/Kconfig      |    7 +
 drivers/gpio/Makefile     |    1 +
 drivers/gpio/stmpe-gpio.c |  381 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 389 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/stmpe-gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 724038d..14c6dfc 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -195,6 +195,13 @@ config GPIO_PCF857X
 	  This driver provides an in-kernel interface to those GPIOs using
 	  platform-neutral GPIO calls.
 
+config GPIO_STMPE
+	bool "STMPExxxx GPIOs"
+	depends on MFD_STMPE
+	help
+	  This enables support for the GPIOs found on the STMPExxxx
+	  I/O Expanders.
+
 config GPIO_TC35892
 	bool "TC35892 GPIOs"
 	depends on MFD_TC35892
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 51c3cdd..a9b93c3 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_PL061)	+= pl061.o
+obj-$(CONFIG_GPIO_STMPE)	+= stmpe-gpio.o
 obj-$(CONFIG_GPIO_TC35892)	+= tc35892-gpio.o
 obj-$(CONFIG_GPIO_TIMBERDALE)	+= timbgpio.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/stmpe-gpio.c
new file mode 100644
index 0000000..857d3f5
--- /dev/null
+++ b/drivers/gpio/stmpe-gpio.c
@@ -0,0 +1,381 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License, version 2
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
+#include <linux/mfd/stmpe.h>
+
+/*
+ * These registers are modified under the irq bus lock and cached to avoid
+ * unnecessary writes in bus_sync_unlock.
+ */
+enum { REG_RE, REG_FE, REG_IE };
+
+#define CACHE_NR_REGS	3
+#define CACHE_NR_BANKS	(STMPE_NR_GPIOS / 8)
+
+struct stmpe_gpio {
+	struct gpio_chip chip;
+	struct stmpe *stmpe;
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
+static inline struct stmpe_gpio *to_stmpe_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct stmpe_gpio, chip);
+}
+
+static int stmpe_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
+	struct stmpe *stmpe = stmpe_gpio->stmpe;
+	u8 reg = stmpe->regs[STMPE_IDX_GPMR_LSB] - (offset / 8);
+	u8 mask = 1 << (offset % 8);
+	int ret;
+
+	ret = stmpe_reg_read(stmpe, reg);
+	if (ret < 0)
+		return ret;
+
+	return ret & mask;
+}
+
+static void stmpe_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
+{
+	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
+	struct stmpe *stmpe = stmpe_gpio->stmpe;
+	int which = val ? STMPE_IDX_GPSR_LSB : STMPE_IDX_GPCR_LSB;
+	u8 reg = stmpe->regs[which] - (offset / 8);
+	u8 mask = 1 << (offset % 8);
+
+	stmpe_reg_write(stmpe, reg, mask);
+}
+
+static int stmpe_gpio_direction_output(struct gpio_chip *chip,
+					 unsigned offset, int val)
+{
+	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
+	struct stmpe *stmpe = stmpe_gpio->stmpe;
+	u8 reg = stmpe->regs[STMPE_IDX_GPDR_LSB] - (offset / 8);
+	u8 mask = 1 << (offset % 8);
+
+	stmpe_gpio_set(chip, offset, val);
+
+	return stmpe_set_bits(stmpe, reg, mask, mask);
+}
+
+static int stmpe_gpio_direction_input(struct gpio_chip *chip,
+					unsigned offset)
+{
+	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
+	struct stmpe *stmpe = stmpe_gpio->stmpe;
+	u8 reg = stmpe->regs[STMPE_IDX_GPDR_LSB] - (offset / 8);
+	u8 mask = 1 << (offset % 8);
+
+	return stmpe_set_bits(stmpe, reg, mask, mask);
+}
+
+static int stmpe_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
+
+	return stmpe_gpio->irq_base + offset;
+}
+
+static struct gpio_chip template_chip = {
+	.label			= "stmpe",
+	.owner			= THIS_MODULE,
+	.direction_input	= stmpe_gpio_direction_input,
+	.get			= stmpe_gpio_get,
+	.direction_output	= stmpe_gpio_direction_output,
+	.set			= stmpe_gpio_set,
+	.to_irq			= stmpe_gpio_to_irq,
+	.can_sleep		= 1,
+};
+
+static int stmpe_gpio_irq_set_type(unsigned int irq, unsigned int type)
+{
+	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
+	int offset = irq - stmpe_gpio->irq_base;
+	int regoffset = offset / 8;
+	int mask = 1 << (offset % 8);
+
+	if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_LEVEL_HIGH)
+		return -EINVAL;
+
+	if (type == IRQ_TYPE_EDGE_RISING)
+		stmpe_gpio->regs[REG_RE][regoffset] |= mask;
+	else
+		stmpe_gpio->regs[REG_RE][regoffset] &= ~mask;
+
+	if (type == IRQ_TYPE_EDGE_FALLING)
+		stmpe_gpio->regs[REG_FE][regoffset] |= mask;
+	else
+		stmpe_gpio->regs[REG_FE][regoffset] &= ~mask;
+
+	return 0;
+}
+
+static void stmpe_gpio_irq_lock(unsigned int irq)
+{
+	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
+
+	mutex_lock(&stmpe_gpio->irq_lock);
+}
+
+static void stmpe_gpio_irq_sync_unlock(unsigned int irq)
+{
+	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
+	struct stmpe *stmpe = stmpe_gpio->stmpe;
+	int num_banks = stmpe->num_gpios / 8;
+	static const u8 regmap[] = {
+		[REG_RE]	= STMPE_IDX_GPRER_LSB,
+		[REG_FE]	= STMPE_IDX_GPFER_LSB,
+		[REG_IE]	= STMPE_IDX_IEGPIOR_LSB,
+	};
+	int i, j;
+
+	for (i = 0; i < CACHE_NR_REGS; i++) {
+		for (j = 0; j < num_banks; j++) {
+			u8 old = stmpe_gpio->oldregs[i][j];
+			u8 new = stmpe_gpio->regs[i][j];
+
+			if (new == old)
+				continue;
+
+			stmpe_gpio->oldregs[i][j] = new;
+			stmpe_reg_write(stmpe, stmpe->regs[regmap[i]] - j, new);
+		}
+	}
+
+	mutex_unlock(&stmpe_gpio->irq_lock);
+}
+
+static void stmpe_gpio_irq_mask(unsigned int irq)
+{
+	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
+	int offset = irq - stmpe_gpio->irq_base;
+	int regoffset = offset / 8;
+	int mask = 1 << (offset % 8);
+
+	stmpe_gpio->regs[REG_IE][regoffset] &= ~mask;
+}
+
+static void stmpe_gpio_irq_unmask(unsigned int irq)
+{
+	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
+	int offset = irq - stmpe_gpio->irq_base;
+	int regoffset = offset / 8;
+	int mask = 1 << (offset % 8);
+
+	stmpe_gpio->regs[REG_IE][regoffset] |= mask;
+}
+
+static struct irq_chip stmpe_gpio_irq_chip = {
+	.name			= "stmpe-gpio",
+	.bus_lock		= stmpe_gpio_irq_lock,
+	.bus_sync_unlock	= stmpe_gpio_irq_sync_unlock,
+	.mask			= stmpe_gpio_irq_mask,
+	.unmask			= stmpe_gpio_irq_unmask,
+	.set_type		= stmpe_gpio_irq_set_type,
+};
+
+static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
+{
+	struct stmpe_gpio *stmpe_gpio = dev;
+	struct stmpe *stmpe = stmpe_gpio->stmpe;
+	u8 statmsbreg = stmpe->regs[STMPE_IDX_ISGPIOR_MSB];
+	int num_banks = stmpe->num_gpios / 8;
+	u8 status[num_banks];
+	int ret;
+	int i;
+
+	ret = stmpe_block_read(stmpe, statmsbreg, num_banks, status);
+	if (ret < 0)
+		return IRQ_NONE;
+
+	for (i = 0; i < num_banks; i++) {
+		int bank = num_banks - i - 1;
+		unsigned int enabled = stmpe_gpio->regs[REG_IE][bank];
+		unsigned int stat = status[i];
+
+		stat &= enabled;
+		if (!stat)
+			continue;
+
+		while (stat) {
+			int bit = __ffs(stat);
+			int line = bank * 8 + bit;
+
+			handle_nested_irq(stmpe_gpio->irq_base + line);
+			stat &= ~(1 << bit);
+		}
+
+		stmpe_reg_write(stmpe, statmsbreg + i, status[i]);
+		stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_GPEDR_MSB] + i,
+				status[i]);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit stmpe_gpio_irq_init(struct stmpe_gpio *stmpe_gpio)
+{
+	int base = stmpe_gpio->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + stmpe_gpio->chip.ngpio; irq++) {
+		set_irq_chip_data(irq, stmpe_gpio);
+		set_irq_chip_and_handler(irq, &stmpe_gpio_irq_chip,
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
+static void stmpe_gpio_irq_remove(struct stmpe_gpio *stmpe_gpio)
+{
+	int base = stmpe_gpio->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + stmpe_gpio->chip.ngpio; irq++) {
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, 0);
+#endif
+		set_irq_chip_and_handler(irq, NULL, NULL);
+		set_irq_chip_data(irq, NULL);
+	}
+}
+
+static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
+{
+	struct stmpe *stmpe = dev_get_drvdata(pdev->dev.parent);
+	struct stmpe_gpio_platform_data *pdata;
+	struct stmpe_gpio *stmpe_gpio;
+	int ret;
+	int irq;
+
+	pdata = stmpe->pdata->gpio;
+	if (!pdata)
+		return -ENODEV;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	stmpe_gpio = kzalloc(sizeof(struct stmpe_gpio), GFP_KERNEL);
+	if (!stmpe_gpio)
+		return -ENOMEM;
+
+	mutex_init(&stmpe_gpio->irq_lock);
+
+	stmpe_gpio->dev = &pdev->dev;
+	stmpe_gpio->stmpe = stmpe;
+
+	stmpe_gpio->chip = template_chip;
+	stmpe_gpio->chip.ngpio = stmpe->num_gpios;
+	stmpe_gpio->chip.dev = &pdev->dev;
+	stmpe_gpio->chip.base = pdata->gpio_base;
+
+	stmpe_gpio->irq_base = stmpe->irq_base + STMPE_INT_GPIO(0);
+
+	ret = stmpe_set_bits(stmpe, STMPE_SYSCON, STMPE_SYSCON_ENABLE_GPIO,
+			     STMPE_SYSCON_ENABLE_GPIO);
+	if (ret)
+		return ret;
+
+	ret = stmpe_gpio_irq_init(stmpe_gpio);
+	if (ret)
+		goto out_free;
+
+	ret = request_threaded_irq(irq, NULL, stmpe_gpio_irq, IRQF_ONESHOT,
+				   "stmpe-gpio", stmpe_gpio);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to get irq: %d\n", ret);
+		goto out_removeirq;
+	}
+
+	ret = gpiochip_add(&stmpe_gpio->chip);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to add gpiochip: %d\n", ret);
+		goto out_freeirq;
+	}
+
+	platform_set_drvdata(pdev, stmpe_gpio);
+
+	return 0;
+
+out_freeirq:
+	free_irq(irq, stmpe_gpio);
+out_removeirq:
+	stmpe_gpio_irq_remove(stmpe_gpio);
+out_free:
+	kfree(stmpe_gpio);
+	return ret;
+}
+
+static int __devexit stmpe_gpio_remove(struct platform_device *pdev)
+{
+	struct stmpe_gpio *stmpe_gpio = platform_get_drvdata(pdev);
+	int irq = platform_get_irq(pdev, 0);
+	int ret;
+
+	ret = gpiochip_remove(&stmpe_gpio->chip);
+	if (ret < 0) {
+		dev_err(stmpe_gpio->dev,
+			"unable to remove gpiochip: %d\n", ret);
+		return ret;
+	}
+
+	free_irq(irq, stmpe_gpio);
+	stmpe_gpio_irq_remove(stmpe_gpio);
+	platform_set_drvdata(pdev, NULL);
+	kfree(stmpe_gpio);
+
+	return 0;
+}
+
+static struct platform_driver stmpe_gpio_driver = {
+	.driver.name	= "stmpe-gpio",
+	.driver.owner	= THIS_MODULE,
+	.probe		= stmpe_gpio_probe,
+	.remove		= __devexit_p(stmpe_gpio_remove),
+};
+
+static int __init stmpe_gpio_init(void)
+{
+	return platform_driver_register(&stmpe_gpio_driver);
+}
+subsys_initcall(stmpe_gpio_init);
+
+static void __exit stmpe_gpio_exit(void)
+{
+	platform_driver_unregister(&stmpe_gpio_driver);
+}
+module_exit(stmpe_gpio_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("STMPExxxx GPIO driver");
+MODULE_AUTHOR("Rabin Vincent <rabin.vincent@stericsson.com>");
-- 
1.7.0

