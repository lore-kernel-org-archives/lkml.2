Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2IZAmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 20:42:50 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:47536 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2IZAmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 20:42:49 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-kernel@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Subject: [PATCH] gpio: add TS-5500 DIO headers support
Date: Tue, 25 Sep 2012 20:42:10 -0400
Message-Id: <1348620130-25987-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Technologic Systems TS-5500 platform provides 3 digital I/O headers:
DIO1, DIO2, and the LCD port, that may be used as a DIO header.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Signed-off-by: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
---
 drivers/gpio/Kconfig                      |   8 +
 drivers/gpio/Makefile                     |   1 +
 drivers/gpio/gpio-ts5500.c                | 344 ++++++++++++++++++++++++++++++
 include/linux/platform_data/gpio-ts5500.h |  34 +++
 4 files changed, 387 insertions(+)
 create mode 100644 drivers/gpio/gpio-ts5500.c
 create mode 100644 include/linux/platform_data/gpio-ts5500.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index ba7926f5..f8bf8e1 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -395,6 +395,14 @@ config GPIO_TPS65912
 	help
 	  This driver supports TPS65912 gpio chip
 
+config GPIO_TS5500
+	tristate "TS-5500 DIO Headers"
+	depends on TS5500
+	help
+	  This driver supports the 3 Digital I/O headers of the Technologic
+	  Systems TS-5500 platform: DIO1, DIO2, and the LCD port which may be
+	  used as a DIO header.
+
 config GPIO_TWL4030
 	tristate "TWL4030, TWL5030, and TPS659x0 GPIOs"
 	depends on TWL4030_CORE
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 153cace..48e8670 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -66,6 +66,7 @@ obj-$(CONFIG_ARCH_DAVINCI_TNETV107X) += gpio-tnetv107x.o
 obj-$(CONFIG_GPIO_TPS6586X)	+= gpio-tps6586x.o
 obj-$(CONFIG_GPIO_TPS65910)	+= gpio-tps65910.o
 obj-$(CONFIG_GPIO_TPS65912)	+= gpio-tps65912.o
+obj-$(CONFIG_GPIO_TS5500)	+= gpio-ts5500.o
 obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
 obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
 obj-$(CONFIG_GPIO_VR41XX)	+= gpio-vr41xx.o
diff --git a/drivers/gpio/gpio-ts5500.c b/drivers/gpio/gpio-ts5500.c
new file mode 100644
index 0000000..d91fee9
--- /dev/null
+++ b/drivers/gpio/gpio-ts5500.c
@@ -0,0 +1,344 @@
+/*
+ * GPIO (DIO) driver for Technologic Systems TS-5500
+ *
+ * Copyright (c) 2010-2012 Savoir-faire Linux Inc.
+ *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * The TS-5500 platform has 38 Digital Input/Output lines (DIO), exposed by 3
+ * DIO headers: DIO1, DIO2, and the LCD port which may be used as a DIO header.
+ *
+ * The datasheet is available at:
+ * http://embeddedx86.com/documentation/ts-5500-manual.pdf.
+ * See section 6 "Digital I/O" for details about the pinout.
+ */
+
+#include <linux/bitops.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_data/gpio-ts5500.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+/*
+ * This array describes the names of the DIO lines, but also the mapping between
+ * the datasheet, and corresponding offsets exposed by the driver.
+ */
+static const char * const ts5500_pinout[38] = {
+	/* DIO1 Header (offset 0-13) */
+	[0]  = "DIO1_0",  /* pin 1  */
+	[1]  = "DIO1_1",  /* pin 3  */
+	[2]  = "DIO1_2",  /* pin 5  */
+	[3]  = "DIO1_3",  /* pin 7  */
+	[4]  = "DIO1_4",  /* pin 9  */
+	[5]  = "DIO1_5",  /* pin 11 */
+	[6]  = "DIO1_6",  /* pin 13 */
+	[7]  = "DIO1_7",  /* pin 15 */
+	[8]  = "DIO1_8",  /* pin 4  */
+	[9]  = "DIO1_9",  /* pin 6  */
+	[10] = "DIO1_10", /* pin 8  */
+	[11] = "DIO1_11", /* pin 10 */
+	[12] = "DIO1_12", /* pin 12 */
+	[13] = "DIO1_13", /* pin 14 */
+
+	/* DIO2 Header (offset 14-26) */
+	[14] = "DIO2_0",  /* pin 1  */
+	[15] = "DIO2_1",  /* pin 3  */
+	[16] = "DIO2_2",  /* pin 5  */
+	[17] = "DIO2_3",  /* pin 7  */
+	[18] = "DIO2_4",  /* pin 9  */
+	[19] = "DIO2_5",  /* pin 11 */
+	[20] = "DIO2_6",  /* pin 13 */
+	[21] = "DIO2_7",  /* pin 15 */
+	[22] = "DIO2_8",  /* pin 4  */
+	[23] = "DIO2_9",  /* pin 6  */
+	[24] = "DIO2_10", /* pin 8  */
+	[25] = "DIO2_11", /* pin 10 */
+	[26] = "DIO2_13", /* pin 14 */
+
+	/* LCD Port as DIO (offset 27-37) */
+	[27] = "LCD_0",   /* pin 8  */
+	[28] = "LCD_1",   /* pin 7  */
+	[29] = "LCD_2",   /* pin 10 */
+	[30] = "LCD_3",   /* pin 9  */
+	[31] = "LCD_4",   /* pin 12 */
+	[32] = "LCD_5",   /* pin 11 */
+	[33] = "LCD_6",   /* pin 14 */
+	[34] = "LCD_7",   /* pin 13 */
+	[35] = "LCD_EN",  /* pin 5  */
+	[36] = "LCD_WR",  /* pin 6  */
+	[37] = "LCD_RS",  /* pin 3  */
+};
+
+#define IN	(1 << 0)
+#define OUT	(1 << 1)
+#ifndef NO_IRQ
+#define NO_IRQ	-1
+#endif
+
+/*
+ * This structure is used to describe capabilities of DIO lines,
+ * such as available directions, and mapped IRQ (if any).
+ */
+struct ts5500_dio {
+	const unsigned long value_addr;
+	const int value_bit;
+	const unsigned long control_addr;
+	const int control_bit;
+	const int irq;
+	const int direction;
+};
+
+static const struct ts5500_dio ts5500_dios[] = {
+	/* DIO1 Header (offset 0-13) */
+	[0]  = { 0x7b, 0, 0x7a, 0,  NO_IRQ, IN | OUT },
+	[1]  = { 0x7b, 1, 0x7a, 0,  NO_IRQ, IN | OUT },
+	[2]  = { 0x7b, 2, 0x7a, 0,  NO_IRQ, IN | OUT },
+	[3]  = { 0x7b, 3, 0x7a, 0,  NO_IRQ, IN | OUT },
+	[4]  = { 0x7b, 4, 0x7a, 1,  NO_IRQ, IN | OUT },
+	[5]  = { 0x7b, 5, 0x7a, 1,  NO_IRQ, IN | OUT },
+	[6]  = { 0x7b, 6, 0x7a, 1,  NO_IRQ, IN | OUT },
+	[7]  = { 0x7b, 7, 0x7a, 1,  NO_IRQ, IN | OUT },
+	[8]  = { 0x7c, 0, 0x7a, 5,  NO_IRQ, IN | OUT },
+	[9]  = { 0x7c, 1, 0x7a, 5,  NO_IRQ, IN | OUT },
+	[10] = { 0x7c, 2, 0x7a, 5,  NO_IRQ, IN | OUT },
+	[11] = { 0x7c, 3, 0x7a, 5,  NO_IRQ, IN | OUT },
+	[12] = { 0x7c, 4, 0,    -1, NO_IRQ, IN       },
+	[13] = { 0x7c, 5, 0,    -1, 7,      IN       },
+
+	/* DIO2 Header (offset 14-26) */
+	[14] = { 0x7e, 0, 0x7d, 0,  NO_IRQ, IN | OUT },
+	[15] = { 0x7e, 1, 0x7d, 0,  NO_IRQ, IN | OUT },
+	[16] = { 0x7e, 2, 0x7d, 0,  NO_IRQ, IN | OUT },
+	[17] = { 0x7e, 3, 0x7d, 0,  NO_IRQ, IN | OUT },
+	[18] = { 0x7e, 4, 0x7d, 1,  NO_IRQ, IN | OUT },
+	[19] = { 0x7e, 5, 0x7d, 1,  NO_IRQ, IN | OUT },
+	[20] = { 0x7e, 6, 0x7d, 1,  NO_IRQ, IN | OUT },
+	[21] = { 0x7e, 7, 0x7d, 1,  NO_IRQ, IN | OUT },
+	[22] = { 0x7f, 0, 0x7d, 5,  NO_IRQ, IN | OUT },
+	[23] = { 0x7f, 1, 0x7d, 5,  NO_IRQ, IN | OUT },
+	[24] = { 0x7f, 2, 0x7d, 5,  NO_IRQ, IN | OUT },
+	[25] = { 0x7f, 3, 0x7d, 5,  NO_IRQ, IN | OUT },
+	[26] = { 0x7f, 4, 0,    -1, 6,      IN       },
+
+	/* LCD Port as DIO (offset 27-37) */
+	[27] = { 0x72, 0, 0x7d, 2,  NO_IRQ, IN | OUT },
+	[28] = { 0x72, 1, 0x7d, 2,  NO_IRQ, IN | OUT },
+	[29] = { 0x72, 2, 0x7d, 2,  NO_IRQ, IN | OUT },
+	[30] = { 0x72, 3, 0x7d, 2,  NO_IRQ, IN | OUT },
+	[31] = { 0x72, 4, 0x7d, 3,  NO_IRQ, IN | OUT },
+	[32] = { 0x72, 5, 0x7d, 3,  NO_IRQ, IN | OUT },
+	[33] = { 0x72, 6, 0x7d, 3,  NO_IRQ, IN | OUT },
+	[34] = { 0x72, 7, 0x7d, 3,  NO_IRQ, IN | OUT },
+	[35] = { 0x73, 0, 0,    -1, NO_IRQ,      OUT },
+	[36] = { 0x73, 6, 0,    -1, NO_IRQ, IN       },
+	[37] = { 0x73, 7, 0,    -1, 1,      IN       },
+};
+
+static bool lcd_dio;
+static bool lcd_irq;
+static bool dio1_irq;
+static bool dio2_irq;
+
+static DEFINE_SPINLOCK(lock);
+
+static inline void io_set_bit(int bit, unsigned long addr)
+{
+	unsigned long val = inb(addr);
+	__set_bit(bit, &val);
+	outb(val, addr);
+}
+
+static inline void io_clear_bit(int bit, unsigned long addr)
+{
+	unsigned long val = inb(addr);
+	__clear_bit(bit, &val);
+	outb(val, addr);
+}
+
+static int ts5500_gpio_input(struct gpio_chip *chip, unsigned offset)
+{
+	unsigned long flags;
+	const struct ts5500_dio line = ts5500_dios[offset];
+
+	/* Some lines cannot be configured as input */
+	if (!(line.direction & IN))
+		return -ENXIO;
+
+	/* Some others are input only */
+	if (line.direction & OUT) {
+		spin_lock_irqsave(&lock, flags);
+		io_clear_bit(line.control_bit, line.control_addr);
+		spin_unlock_irqrestore(&lock, flags);
+	}
+
+	return 0;
+}
+
+static int ts5500_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	const struct ts5500_dio line = ts5500_dios[offset];
+
+	return (inb(line.value_addr) >> line.value_bit) & 1;
+}
+
+static int ts5500_gpio_output(struct gpio_chip *chip, unsigned offset, int val)
+{
+	unsigned long flags;
+	const struct ts5500_dio line = ts5500_dios[offset];
+
+	/* Some lines cannot be configured as output */
+	if (!(line.direction & OUT))
+		return -ENXIO;
+
+	spin_lock_irqsave(&lock, flags);
+	/* Some lines are output only */
+	if (line.direction & IN)
+		io_set_bit(line.control_bit, line.control_addr);
+
+	if (val)
+		io_set_bit(line.value_bit, line.value_addr);
+	else
+		io_clear_bit(line.value_bit, line.value_addr);
+	spin_unlock_irqrestore(&lock, flags);
+
+	return 0;
+}
+
+static void ts5500_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
+{
+	unsigned long flags;
+	const struct ts5500_dio line = ts5500_dios[offset];
+
+	spin_lock_irqsave(&lock, flags);
+	if (val)
+		io_set_bit(line.value_bit, line.value_addr);
+	else
+		io_clear_bit(line.value_bit, line.value_addr);
+	spin_unlock_irqrestore(&lock, flags);
+}
+
+static int ts5500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	const struct ts5500_dio line = ts5500_dios[offset];
+
+	/* Only a few lines are IRQ-capable */
+	if (line.irq != NO_IRQ)
+		return line.irq;
+
+	/* This allows to bridge a line with the IRQ line of the same header */
+	if (dio1_irq && offset < 13)
+		return ts5500_dios[13].irq;
+	if (dio2_irq && offset > 13 && offset < 26)
+		return ts5500_dios[26].irq;
+	if (lcd_irq && offset > 26 && offset < 37)
+		return ts5500_dios[37].irq;
+
+	return -ENXIO;
+}
+
+static struct gpio_chip ts5500_gc = {
+	.label = "TS-5500 DIO Headers",
+	.owner = THIS_MODULE,
+	.direction_input = ts5500_gpio_input,
+	.get = ts5500_gpio_get,
+	.direction_output = ts5500_gpio_output,
+	.set = ts5500_gpio_set,
+	.to_irq = ts5500_gpio_to_irq,
+	.names = ts5500_pinout,
+	.ngpio = 27,
+	.base = -1,
+};
+
+static int __devinit ts5500_gpio_probe(struct platform_device *pdev)
+{
+	int ret;
+	unsigned long flags;
+	struct ts5500_gpio_platform_data *pdata = pdev->dev.platform_data;
+
+	if (pdata) {
+		ts5500_gc.base = pdata->base;
+		dio1_irq = pdata->dio1_irq;
+		dio2_irq = pdata->dio2_irq;
+		if (pdata->lcd_dio) {
+			lcd_dio = true;
+			lcd_irq = pdata->lcd_irq;
+			ts5500_gc.ngpio = 38;
+		}
+	}
+
+	if (!devm_request_region(&pdev->dev, 0x7a, 3, "DIO1 Header")) {
+		dev_err(&pdev->dev, "failed to request DIO1 ports (0x7a-7c)\n");
+		return -EBUSY;
+	}
+
+	if (!devm_request_region(&pdev->dev, 0x7d, 3, "DIO2 Header")) {
+		dev_err(&pdev->dev, "failed to request DIO2 ports (0x7d-7f)\n");
+		return -EBUSY;
+	}
+
+	if (lcd_dio &&
+	    !devm_request_region(&pdev->dev, 0x72, 2, "LCD Port as DIO")) {
+		dev_err(&pdev->dev, "failed to request LCD ports (0x72-73)\n");
+		return -EBUSY;
+	}
+
+	platform_set_drvdata(pdev, &ts5500_gc);
+
+	ret = gpiochip_add(&ts5500_gc);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register the gpio chip\n");
+		return ret;
+	}
+
+	/* Enable IRQ generation */
+	spin_lock_irqsave(&lock, flags);
+	io_set_bit(7, 0x7a); /* DIO1_13 on IRQ7 */
+	io_set_bit(7, 0x7d); /* DIO2_13 on IRQ6 */
+	if (lcd_dio) {
+		io_clear_bit(4, 0x7d); /* LCD Header usage as DIO */
+		io_set_bit(6, 0x7d); /* LCD_RS on IRQ1 */
+	}
+	spin_unlock_irqrestore(&lock, flags);
+
+	return 0;
+}
+
+static int __devexit ts5500_gpio_remove(struct platform_device *pdev)
+{
+	int ret;
+	unsigned long flags;
+
+	/* Disable IRQ generation */
+	spin_lock_irqsave(&lock, flags);
+	io_clear_bit(7, 0x7a);
+	io_clear_bit(7, 0x7d);
+	if (lcd_dio)
+		io_clear_bit(6, 0x7d);
+	spin_unlock_irqrestore(&lock, flags);
+
+	ret = gpiochip_remove(&ts5500_gc);
+	if (ret)
+		dev_err(&pdev->dev, "failed to remove the gpio chip\n");
+
+	return ret;
+}
+
+static struct platform_driver ts5500_gpio_driver = {
+	.driver = {
+		.name = "gpio-ts5500",
+		.owner = THIS_MODULE,
+	},
+	.probe = ts5500_gpio_probe,
+	.remove = __devexit_p(ts5500_gpio_remove),
+};
+
+module_platform_driver(ts5500_gpio_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>");
+MODULE_DESCRIPTION("Technologic Systems TS-5500 Digital I/O driver");
diff --git a/include/linux/platform_data/gpio-ts5500.h b/include/linux/platform_data/gpio-ts5500.h
new file mode 100644
index 0000000..9efd4c3
--- /dev/null
+++ b/include/linux/platform_data/gpio-ts5500.h
@@ -0,0 +1,34 @@
+/*
+ * GPIO (DIO) header for Technologic Systems TS-5500
+ *
+ * Copyright (c) 2012 Savoir-faire Linux Inc.
+ *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * The TS-5500 board has 38 Digital Input/Output lines, referred to as DIO in
+ * the product's literature. See section 6 "Digital I/O" of the datasheet:
+ * http://embeddedx86.com/documentation/ts-5500-manual.pdf
+ *
+ * As each IRQable line is input only, the platform data has an option for each
+ * header to return the corresponding IRQ line on request. This might be useful
+ * to bind a bidirectional line with the IRQ line of the same header.
+ */
+
+/**
+ * struct ts5500_gpio_platform_data - TS-5500 GPIO configuration
+ * @base:	The GPIO base number to use.
+ * @lcd_dio:	Use the LCD port as 11 additional digital I/O lines.
+ * @lcd_irq:	Return IRQ1 for every line of LCD DIO header.
+ * @dio1_irq:	Return IRQ7 for every line of DIO1 header.
+ * @dio2_irq:	Return IRQ6 for every line of DIO2 header.
+ */
+struct ts5500_gpio_platform_data {
+	int base;
+	bool lcd_dio;
+	bool lcd_irq;
+	bool dio1_irq;
+	bool dio2_irq;
+};
-- 
1.7.11.4

