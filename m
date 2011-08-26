Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1HZXlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:41:18 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:56251 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab1HZXkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:40:49 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Subject: [v2 2/4] platform: (TS-5500) add GPIO support
Date: Fri, 26 Aug 2011 19:40:25 -0400
Message-Id: <1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>


Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 MAINTAINERS                            |    2 +
 arch/x86/platform/ts5500/Kconfig       |    7 +
 arch/x86/platform/ts5500/Makefile      |    1 +
 arch/x86/platform/ts5500/ts5500.c      |   21 ++
 arch/x86/platform/ts5500/ts5500_gpio.c |  421 ++++++++++++++++++++++++++++++++
 arch/x86/platform/ts5500/ts5500_gpio.h |   60 +++++
 6 files changed, 512 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/platform/ts5500/ts5500_gpio.c
 create mode 100644 arch/x86/platform/ts5500/ts5500_gpio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 3baf6bb..cc42a4b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6360,6 +6360,8 @@ S:	Maintained
 F:  arch/x86/platform/ts5500/Kconfig
 F:  arch/x86/platform/ts5500/Makefile
 F:  arch/x86/platform/ts5500/ts5500.c
+F:  arch/x86/platform/ts5500/ts5500_gpio.c
+F:  arch/x86/platform/ts5500/ts5500_gpio.h
 
 TEGRA SUPPORT
 M:	Colin Cross <ccross@android.com>
diff --git a/arch/x86/platform/ts5500/Kconfig b/arch/x86/platform/ts5500/Kconfig
index 90c257a..7e56737 100644
--- a/arch/x86/platform/ts5500/Kconfig
+++ b/arch/x86/platform/ts5500/Kconfig
@@ -6,3 +6,10 @@ config TS5500
 	  Add support for the Technologic Systems TS-5500 platform features.
 
 	  If you have a TS-5500, say Y here.
+
+config TS5500_GPIO
+	bool "TS-5500 GPIO support"
+	depends on TS5500
+	default y
+	help
+	  This enables support for the DIO headers for GPIO usage.
diff --git a/arch/x86/platform/ts5500/Makefile b/arch/x86/platform/ts5500/Makefile
index 0a689a7..9eb93fe 100644
--- a/arch/x86/platform/ts5500/Makefile
+++ b/arch/x86/platform/ts5500/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_TS5500)			+= ts5500.o
+obj-$(CONFIG_TS5500_GPIO)		+= ts5500_gpio.o
\ No newline at end of file
diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
index d4e0580..6a09648 100644
--- a/arch/x86/platform/ts5500/ts5500.c
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -24,6 +24,8 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <asm/processor.h>
+#include <linux/gpio.h>
+#include "ts5500_gpio.h"
 
 /* Hardware info for pre-detection */
 #define AMD_ELAN_FAMILY			4
@@ -168,7 +170,26 @@ error:
 
 #define TS5500_IS_JP_SET(sbc, jmp) (!!(sbc->jumpers & TS5500_JP##jmp))
 
+
+#ifdef CONFIG_TS5500_GPIO
+/* Callback for releasing resources */
+static void ts5500_gpio_device_release(struct device *dev)
+{
+	/* noop */
+}
+
+static struct platform_device ts5500_gpio_device = {
+	.name = "ts5500_gpio",
+	.id = -1,
+	.dev = {
+		.release = ts5500_gpio_device_release,
+	}
+};
+#endif
 static struct platform_device *ts5500_devices[] __initdata = {
+#ifdef CONFIG_TS5500_GPIO
+	&ts5500_gpio_device,
+#endif
 };
 
 static ssize_t ts5500_show_id(struct device *dev,
diff --git a/arch/x86/platform/ts5500/ts5500_gpio.c b/arch/x86/platform/ts5500/ts5500_gpio.c
new file mode 100644
index 0000000..0250973
--- /dev/null
+++ b/arch/x86/platform/ts5500/ts5500_gpio.c
@@ -0,0 +1,421 @@
+/*
+ * GPIO (DIO) driver for Technologic Systems TS-5500
+ *
+ * Copyright (c) 2010 Savoir-faire Linux Inc.
+ *	Jerome Oufella <jerome.oufella@savoirfairelinux.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * TS-5500 board has 38 GPIOs referred to as DIOs in the product's literature.
+ */
+
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include "ts5500_gpio.h"
+
+static void port_bit_set(u8 addr, int bit)
+{
+	u8 var;
+	var = inb(addr);
+	var |= (1 << bit);
+	outb(var, addr);
+}
+
+static void port_bit_clear(u8 addr, int bit)
+{
+	u8 var;
+	var = inb(addr);
+	var &= ~(1 << bit);
+	outb(var, addr);
+}
+
+/* "DIO" line to IO port mapping table for line's value */
+static const unsigned long line_to_port_map[] = {
+	0x7B, 0x7B, 0x7B, 0x7B, 0x7B, 0x7B, 0x7B, 0x7B,		/* DIO1_0~7  */
+	0x7C, 0x7C, 0x7C, 0x7C, 0x7C, 0x7C,			/* DIO1_8~13 */
+	0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E,		/* DIO2_0~7  */
+	0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F,			/* DIO2_8~13 */
+	0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72,		/* LCD_0~7   */
+	0x73, 0x73, 0x73			   /* LCD_EN, LCD_RS, LCD_WR */
+};
+
+/* "DIO" line to IO port's bit map for line's value */
+static const int line_to_bit_map[] = {
+	0, 1, 2, 3, 4, 5, 6, 7,		/* DIO1_0~7  */
+	0, 1, 2, 3, 4, 5,		/* DIO1_8~13 */
+	0, 1, 2, 3, 4, 5, 6, 7,		/* DIO2_0~7  */
+	0, 1, 2, 3, 4, 5,		/* DIO2_8~13 */
+	0, 1, 2, 3, 4, 5, 6, 7,		/* LCD_0~7   */
+	0, 7, 6				/* LCD_EN, LCD_RS, LCD_WR */
+};
+
+/* "DIO" line's direction control mapping table */
+static const unsigned long line_to_dir_map[] = {
+	0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A,		/* DIO1_0~7  */
+	0x7A, 0x7A, 0x7A, 0x7A, 0, 0,				/* DIO1_8~13 */
+	0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D,		/* DIO2_0~7  */
+	0x7D, 0x7D, 0x7D, 0x7D, 0, 0,				/* DIO2_8~13 */
+	0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D,		/* LCD_0~7   */
+	0, 0, 0					   /* LCD_EN, LCD_RS, LCD_WR */
+};
+
+/* "DIO" line's direction control bit-mapping table */
+static const int line_to_dir_bit_map[] = {
+	0, 0, 0, 0,  1,  1, 1, 1,	/* DIO1_0~7  */
+	5, 5, 5, 5, -1, -1,		/* DIO1_8~13 */
+	0, 0, 0, 0,  1,  1, 1, 1,	/* DIO2_0~7  */
+	5, 5, 5, 5, -1, -1,		/* DIO2_8~13 */
+	2, 2, 2, 2,  3,  3, 3, 3,	/* LCD_0~7   */
+	-1, -1, -1			/* LCD_EN, LCD_RS, LCD_WR */
+};
+
+/* This array is used to track requests for our GPIO lines */
+static int requested_gpios[TS5500_LCD_WR + 1];
+
+static int dio1_irq = 1;
+module_param(dio1_irq, int, 0644);
+MODULE_PARM_DESC(dio1_irq,
+		 "Enable usage of IRQ7 for any DIO1 line (default 1).");
+
+static int dio2_irq = 0;
+module_param(dio2_irq, int, 0644);
+MODULE_PARM_DESC(dio2_irq,
+		 "Enable usage of IRQ6 for any DIO2 line (default 0).");
+
+static int lcd_irq = 0;
+module_param(lcd_irq, int, 0644);
+MODULE_PARM_DESC(lcd_irq, "Enable usage of IRQ1 for any LCD line (default 0).");
+
+static int use_lcdio = 0;
+module_param(use_lcdio, int, 0644);
+MODULE_PARM_DESC(use_lcdio, "Enable usage of the LCD header for DIO operation"
+		 " (default 0).");
+
+/**
+ * struct ts5500_drvdata - Driver data
+ * @master:		Device.
+ * @gpio_chip:		GPIO chip.
+ * @gpio_lock:		Read/Write Mutex.
+ */
+struct ts5500_drvdata {
+	struct device *master;
+	struct gpio_chip gpio_chip;
+	struct mutex gpio_lock;
+};
+
+static int ts5500_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct ts5500_drvdata *drvdata;
+
+	drvdata = container_of(chip, struct ts5500_drvdata, gpio_chip);
+
+	mutex_lock(&drvdata->gpio_lock);
+	if (requested_gpios[offset]) {
+		mutex_unlock(&drvdata->gpio_lock);
+		return -EBUSY;
+	}
+	requested_gpios[offset] = 1;
+	mutex_unlock(&drvdata->gpio_lock);
+
+	return 0;
+}
+
+static void ts5500_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	struct ts5500_drvdata *drvdata;
+
+	drvdata = container_of(chip, struct ts5500_drvdata, gpio_chip);
+
+	mutex_lock(&drvdata->gpio_lock);
+	requested_gpios[offset] = 0;
+	mutex_unlock(&drvdata->gpio_lock);
+}
+
+static int ts5500_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	unsigned long ioaddr;
+	u8 byte;
+	int bitno;
+	struct ts5500_drvdata *drvdata;
+
+	drvdata = container_of(chip, struct ts5500_drvdata, gpio_chip);
+
+	/* Some lines are output-only and cannot be read */
+	switch (offset) {
+	case TS5500_LCD_EN:
+		return -ENXIO;
+	default:
+		if (offset > chip->ngpio)
+			return -ENXIO;
+	}
+
+	ioaddr = line_to_port_map[offset];
+	bitno = line_to_bit_map[offset];
+
+	mutex_lock(&drvdata->gpio_lock);
+	byte = inb(ioaddr);
+	mutex_unlock(&drvdata->gpio_lock);
+
+	return (byte >> bitno) & 0x1;
+}
+
+static void ts5500_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
+{
+	int bitno;
+	unsigned long ioaddr;
+	struct ts5500_drvdata *drvdata;
+
+	drvdata = container_of(chip, struct ts5500_drvdata, gpio_chip);
+
+	/* Some lines just can't be set */
+	switch (offset) {
+	case TS5500_DIO1_12:
+	case TS5500_DIO1_13:
+	case TS5500_DIO2_13:
+	case TS5500_LCD_RS:
+	case TS5500_LCD_WR:
+		return;
+	default:
+		if (offset > chip->ngpio)
+			return;
+		break;
+	}
+
+	/* Get io port and bit for 'offset' */
+	ioaddr = line_to_port_map[offset];
+	bitno = line_to_bit_map[offset];
+
+	mutex_lock(&drvdata->gpio_lock);
+	if (val == 0)
+		port_bit_clear(ioaddr, bitno);
+	else
+		port_bit_set(ioaddr, bitno);
+	mutex_unlock(&drvdata->gpio_lock);
+}
+
+static int ts5500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	/* Only a few lines are IRQ-Capable */
+	switch (offset) {
+	case TS5500_DIO1_13:
+		return TS5500_DIO1_13_IRQ;
+	case TS5500_DIO2_13:
+		return TS5500_DIO2_13_IRQ;
+	case TS5500_LCD_RS:
+		return TS5500_LCD_RS_IRQ;
+	default:
+		break;
+	}
+
+	/*
+	 * Handle the case where the user bridged the IRQ line with another
+	 * DIO line from the same header.
+	 */
+	if (dio1_irq && offset >= TS5500_DIO1_0 && offset < TS5500_DIO1_13)
+		return TS5500_DIO1_13_IRQ;
+
+	if (dio2_irq && offset >= TS5500_DIO2_0 && offset < TS5500_DIO2_13)
+		return TS5500_DIO2_13_IRQ;
+
+	if (lcd_irq && offset >= TS5500_LCD_0 && offset <= TS5500_LCD_WR)
+		return TS5500_LCD_RS_IRQ;
+
+	return -ENXIO;
+}
+
+static int ts5500_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	unsigned long dir_reg;
+	int dir_bit;
+	struct ts5500_drvdata *drvdata;
+
+	drvdata = container_of(chip, struct ts5500_drvdata, gpio_chip);
+
+	/* Some lines cannot be set as inputs */
+	switch (offset) {
+	case TS5500_LCD_EN:
+		return -ENXIO;
+	default:
+		if (offset > chip->ngpio)
+			return -ENXIO;
+		break;
+	}
+
+	dir_reg = line_to_dir_map[offset];
+	dir_bit = line_to_dir_bit_map[offset];
+
+	mutex_lock(&drvdata->gpio_lock);
+	port_bit_clear(dir_reg, dir_bit);
+	mutex_unlock(&drvdata->gpio_lock);
+
+	return 0;
+}
+
+static int ts5500_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
+					int val)
+{
+	unsigned long dir_reg, ioaddr;
+	int dir_bit, bitno;
+	struct ts5500_drvdata *drvdata;
+
+	drvdata = container_of(chip, struct ts5500_drvdata, gpio_chip);
+
+	/* Some lines cannot be set as outputs */
+	switch (offset) {
+	case TS5500_DIO1_12:
+	case TS5500_DIO1_13:
+	case TS5500_DIO2_13:
+	case TS5500_LCD_RS:
+	case TS5500_LCD_WR:
+		return -ENXIO;
+	default:
+		if (offset > chip->ngpio)
+			return -ENXIO;
+		break;
+	}
+
+	/* Get direction and value registers infos */
+	dir_reg = line_to_dir_map[offset];
+	dir_bit = line_to_dir_bit_map[offset];
+	ioaddr = line_to_port_map[offset];
+	bitno = line_to_bit_map[offset];
+
+	mutex_lock(&drvdata->gpio_lock);
+	if (val == 0)
+		port_bit_clear(ioaddr, bitno); /* Set initial line value */
+	else
+		port_bit_set(ioaddr, bitno);
+	port_bit_set(dir_reg, dir_bit); /* Set output direction for line */
+
+	/*
+	 * Confirm initial line output value
+	 * (might have been changed by input)
+	 */
+	if (val == 0)
+		port_bit_clear(ioaddr, bitno);
+	else
+		port_bit_set(ioaddr, bitno);
+	mutex_unlock(&drvdata->gpio_lock);
+
+	return 0;
+}
+
+static int __devinit ts5500_gpio_probe(struct platform_device *pdev)
+{
+	struct ts5500_drvdata *drvdata;
+	struct gpio_chip *chip;
+	int ret;
+
+	if (pdev == NULL) {
+		dev_err(&pdev->dev, "Platform device not available!\n");
+		return -ENODEV;
+	}
+
+	/* Request DIO1 */
+	if (!request_region(0x7A, 3, "ts5500-gpio-DIO1")) {
+		dev_err(&pdev->dev, "Cannot request I/O port 0x7A-7C\n");
+		goto err_req_dio1;
+	}
+
+	/* Request DIO2 */
+	if (!request_region(0x7D, 3, "ts5500-gpio-DIO2")) {
+		dev_err(&pdev->dev, "Cannot request I/O port 0x7D-7F\n");
+		goto err_req_dio2;
+	}
+
+	/* Request LCDIO if wanted */
+	if (use_lcdio && !request_region(0x72, 2, "ts5500-gpio-LCD")) {
+		dev_err(&pdev->dev, "Cannot request I/O port 0x72-73\n");
+		goto err_req_lcdio;
+	}
+
+	/* Setup the gpio_chip structure */
+	drvdata = kzalloc(sizeof(struct ts5500_drvdata), GFP_KERNEL);
+	if (drvdata == NULL)
+		goto err_alloc_dev;
+
+	memset(requested_gpios, 0, sizeof(requested_gpios));
+	mutex_init(&drvdata->gpio_lock);
+
+	drvdata->master = pdev->dev.parent;
+	chip = &drvdata->gpio_chip;
+	chip->request = ts5500_gpio_request;
+	chip->free = ts5500_gpio_free;
+	chip->to_irq = ts5500_gpio_to_irq;
+	chip->direction_input = ts5500_gpio_direction_input;
+	chip->direction_output = ts5500_gpio_direction_output;
+	chip->get = ts5500_gpio_get;
+	chip->set = ts5500_gpio_set;
+	chip->can_sleep = 0;
+	chip->base = TS5500_DIO1_0;
+	chip->label = pdev->name;
+	chip->ngpio = (use_lcdio ? TS5500_LCD_WR + 1 : TS5500_DIO2_13 + 1);
+
+	/* Enable IRQ generation */
+	mutex_lock(&drvdata->gpio_lock);
+	port_bit_set(0x7A, 7); /* DIO1_13 on IRQ7 */
+	port_bit_set(0x7D, 7); /* DIO2_13 on IRQ6 */
+	if (use_lcdio) {
+		port_bit_clear(0x7D, 4); /* Enable LCD header usage as DIO */
+		port_bit_set(0x7D, 6);   /* LCD_RS on IRQ1 */
+	}
+	mutex_unlock(&drvdata->gpio_lock);
+
+	/* Register chip */
+	ret = gpiochip_add(&drvdata->gpio_chip);
+	if (ret)
+		goto err_gpiochip_add;
+
+	platform_set_drvdata(pdev, drvdata);
+
+	return 0;
+
+err_gpiochip_add:
+	dev_err(&pdev->dev, "Failed to register the gpio chip.\n");
+	kfree(drvdata);
+
+err_alloc_dev:
+	if (use_lcdio)
+		release_region(0x72, 2);	/* Release LCD's region */
+
+err_req_lcdio:
+	release_region(0x7D, 3);		/* Release DIO2's region */
+
+err_req_dio2:
+	release_region(0x7A, 3);		/* Release DIO1's region */
+
+err_req_dio1:
+	ret = -EBUSY;
+
+	return ret;
+}
+
+static struct platform_driver ts5500_gpio_driver = {
+	.driver = {
+		.name = "ts5500_gpio",
+		.owner = THIS_MODULE,
+	},
+	.probe = ts5500_gpio_probe
+};
+
+static const struct platform_device_id ts5500_devices[] = {
+	{ "ts5500_gpio", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(platform, ts5500_devices);
+
+static int __init ts5500_gpio_init(void)
+{
+	return platform_driver_register(&ts5500_gpio_driver);
+}
+module_init(ts5500_gpio_init);
+
+MODULE_AUTHOR("Jerome Oufella <jerome.oufella@savoirfairelinux.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Technologic Systems TS-5500, GPIO/DIO driver");
diff --git a/arch/x86/platform/ts5500/ts5500_gpio.h b/arch/x86/platform/ts5500/ts5500_gpio.h
new file mode 100644
index 0000000..7090263
--- /dev/null
+++ b/arch/x86/platform/ts5500/ts5500_gpio.h
@@ -0,0 +1,60 @@
+/*
+ * GPIO (DIO) driver for Technologic Systems TS-5500
+ *
+ * Copyright (c) 2010 Savoir-faire Linux Inc.
+ *	Jerome Oufella <jerome.oufella@savoirfairelinux.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _TS5500_GPIO_H
+#define _TS5500_GPIO_H
+
+#define TS5500_DIO1_0		0
+#define TS5500_DIO1_1		1
+#define TS5500_DIO1_2		2
+#define TS5500_DIO1_3		3
+#define TS5500_DIO1_4		4
+#define TS5500_DIO1_5		5
+#define TS5500_DIO1_6		6
+#define TS5500_DIO1_7		7
+#define TS5500_DIO1_8		8
+#define TS5500_DIO1_9		9
+#define TS5500_DIO1_10		10
+#define TS5500_DIO1_11		11
+#define TS5500_DIO1_12		12
+#define TS5500_DIO1_13		13
+#define TS5500_DIO2_0		14
+#define TS5500_DIO2_1		15
+#define TS5500_DIO2_2		16
+#define TS5500_DIO2_3		17
+#define TS5500_DIO2_4		18
+#define TS5500_DIO2_5		19
+#define TS5500_DIO2_6		20
+#define TS5500_DIO2_7		21
+#define TS5500_DIO2_8		22
+#define TS5500_DIO2_9		23
+#define TS5500_DIO2_10		24
+#define TS5500_DIO2_11		25
+/* #define TS5500_DIO2_12 - Keep commented out as it simply doesn't exist. */
+#define TS5500_DIO2_13		26
+#define TS5500_LCD_0		27
+#define TS5500_LCD_1		28
+#define TS5500_LCD_2		29
+#define TS5500_LCD_3		30
+#define TS5500_LCD_4		31
+#define TS5500_LCD_5		32
+#define TS5500_LCD_6		33
+#define TS5500_LCD_7		34
+#define TS5500_LCD_EN		35
+#define TS5500_LCD_RS		36
+#define TS5500_LCD_WR		37
+
+/* Lines that can trigger IRQs */
+#define TS5500_DIO1_13_IRQ	7
+#define TS5500_DIO2_13_IRQ	6
+#define TS5500_LCD_RS_IRQ	1
+
+#endif /* _TS5500_GPIO_H */
-- 
1.7.6

