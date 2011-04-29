Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab1D2W2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:28:55 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:49369 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab1D2W2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:28:15 -0400
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "To"
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-kernel@vger.kernel.org
Cc: Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        platform-driver-x86@vger.kernel.org, linux-serial@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: [RFC 2/5] gpio: add support for Technologic Systems TS-5500 GPIOs
Date: Fri, 29 Apr 2011 18:21:49 -0400
Message-Id: <1304115712-5299-3-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>


Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 MAINTAINERS                 |    2 +
 drivers/gpio/Kconfig        |   10 +
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/ts5500-gpio.c  |  528 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/ts5500-gpio.h |   68 ++++++
 5 files changed, 609 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/ts5500-gpio.c
 create mode 100644 include/linux/ts5500-gpio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index b077e6d..32c2c57 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6058,6 +6058,8 @@ M:	Savoir-faire Linux Inc. <ts-kernel@savoirfairelinux.com>
 S:	Maintained
 F:	drivers/platform/x86/ts5xxx-sbcinfo.c
 F:	include/linux/ts5xxx-sbcinfo.h
+F:	drivers/gpio/ts5500-gpio.c
+F:	include/linux/ts5500-gpio.h
 
 TEGRA SUPPORT
 M:	Colin Cross <ccross@android.com>
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d3b2953..d707e42 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -322,6 +322,16 @@ config GPIO_BT8XX
 
 	  If unsure, say N.
 
+config GPIO_TS5500
+	tristate "TS-5500 GPIO support"
+	depends on TS5500_SBC
+	help
+	  This enables support for the Technologic Systems TS-5500 DIO
+	  headers for GPIO usage.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ts5500-gpio.
+
 config GPIO_LANGWELL
 	bool "Intel Langwell/Penwell GPIO support"
 	depends on PCI && X86
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index becef59..f5bd65f 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -43,3 +43,4 @@ obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
 obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
 obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
+obj-$(CONFIG_GPIO_TS5500)	+= ts5500-gpio.o
diff --git a/drivers/gpio/ts5500-gpio.c b/drivers/gpio/ts5500-gpio.c
new file mode 100644
index 0000000..9d75d1c
--- /dev/null
+++ b/drivers/gpio/ts5500-gpio.c
@@ -0,0 +1,528 @@
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
+ * The TS-5500 board has 38 GPIOs referred to as DIOs in the product's
+ * litterature.
+ *
+ */
+
+#include <linux/gpio.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/ts5xxx-sbcinfo.h>
+#include <linux/ts5500-gpio.h>
+#include <linux/io.h>
+
+#define MODULE_NAME "ts5500-gpio"
+
+#define PORT_BIT_SET(addr, bit)		\
+	do {				\
+		u8 var;			\
+		var = inb(addr);	\
+		var |= (1 << bit);	\
+		outb(var, addr);	\
+	} while (0)
+
+#define PORT_BIT_CLEAR(addr, bit)	\
+	do {				\
+		u8 var;			\
+		var = inb(addr);	\
+		var &= ~(1 << bit);	\
+		outb(var, addr);	\
+	} while (0)
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
+static int requested_gpios[LCD_WR + 1];
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
+ * @pdata:		GPIO platform data.
+ * @gpio_lock:		Read/Write Mutex.
+ */
+struct ts5500_drvdata {
+	struct device *master;
+	struct gpio_chip gpio_chip;
+	struct ts5500_gpio_platform_data *pdata;
+	struct mutex gpio_lock;
+};
+
+static struct ts5500_gpio_platform_data gpio_pdata = {
+	.name = MODULE_NAME
+};
+
+static void ts5500_gpio_device_release(struct device *dev);
+static int __devinit ts5500_gpio_probe(struct platform_device *pdev);
+static int __devexit ts5500_gpio_remove(struct platform_device *pdev);
+
+static struct platform_device gpio_device = {
+	.name = MODULE_NAME,
+	.id = -1,
+	.dev = {
+		.platform_data = &gpio_pdata,
+		.release = ts5500_gpio_device_release,
+	}
+};
+
+static struct platform_driver ts5500_gpio_driver = {
+	.driver = {
+		.name	= MODULE_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ts5500_gpio_probe,
+	.remove		= __devexit_p(ts5500_gpio_remove)
+};
+
+/**
+ * ts5500_gpio_device_release() - callback for releasing resources
+ * @dev:		Device.
+ */
+static void ts5500_gpio_device_release(struct device *dev)
+{
+	/* noop */
+}
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
+	case LCD_EN:
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
+	case DIO1_12:
+	case DIO1_13:
+	case DIO2_13:
+	case LCD_RS:
+	case LCD_WR:
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
+		PORT_BIT_CLEAR(ioaddr, bitno);
+	else
+		PORT_BIT_SET(ioaddr, bitno);
+	mutex_unlock(&drvdata->gpio_lock);
+}
+
+static int ts5500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct ts5500_drvdata *drvdata;
+
+	drvdata = container_of(chip, struct ts5500_drvdata, gpio_chip);
+
+	/* Only a few lines are IRQ-Capable */
+	switch (offset) {
+	case DIO1_13:
+		return DIO1_13_IRQ;
+	case DIO2_13:
+		return DIO2_13_IRQ;
+	case LCD_RS:
+		return LCD_RS_IRQ;
+	default:
+		break;
+	}
+
+	/*
+	 * Handle the case where the user bridged the IRQ line with another
+	 * DIO line from the same header.
+	 */
+	if (dio1_irq && offset >= DIO1_0 && offset < DIO1_13)
+		return DIO1_13_IRQ;
+
+	if (dio2_irq && offset >= DIO2_0 && offset < DIO2_13)
+		return DIO2_13_IRQ;
+
+	if (lcd_irq && offset >= LCD_0 && offset <= LCD_WR)
+		return LCD_RS_IRQ;
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
+	case LCD_EN:
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
+	PORT_BIT_CLEAR(dir_reg, dir_bit);
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
+	case DIO1_12:
+	case DIO1_13:
+	case DIO2_13:
+	case LCD_RS:
+	case LCD_WR:
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
+		PORT_BIT_CLEAR(ioaddr, bitno); /* Set initial line value */
+	else
+		PORT_BIT_SET(ioaddr, bitno);
+	PORT_BIT_SET(dir_reg, dir_bit); /* Set output direction for line */
+
+	/*
+	 * Confirm initial line output value
+	 * (might have been changed by input)
+	 */
+	if (val == 0)
+		PORT_BIT_CLEAR(ioaddr, bitno);
+	else
+		PORT_BIT_SET(ioaddr, bitno);
+	mutex_unlock(&drvdata->gpio_lock);
+
+	return 0;
+}
+
+static int __devinit ts5500_gpio_probe(struct platform_device *pdev)
+{
+	struct ts5500_drvdata *drvdata;
+	struct ts5500_gpio_platform_data *pdata;
+	struct ts5xxx_sbcinfo sbcinfo;
+	struct gpio_chip *chip;
+	int ret;
+
+	if (pdev == NULL) {
+		printk(MODULE_NAME ": Platform device not available!\n");
+		return -ENODEV;
+	}
+
+	ts5xxx_sbcinfo_set(&sbcinfo);
+	if (5500 != sbcinfo.board_id) {
+		printk(MODULE_NAME ": Incompatible TS Board.\n");
+		return -ENODEV;
+	}
+
+	pdata = (struct ts5500_gpio_platform_data *) pdev->dev.platform_data;
+	if (pdata == NULL) {
+		printk(MODULE_NAME ": Platform data not available!\n");
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
+	drvdata->pdata = pdata;
+	chip =  &drvdata->gpio_chip;
+	chip->request = ts5500_gpio_request;
+	chip->free = ts5500_gpio_free;
+	chip->to_irq = ts5500_gpio_to_irq;
+	chip->direction_input = ts5500_gpio_direction_input;
+	chip->direction_output = ts5500_gpio_direction_output;
+	chip->get = ts5500_gpio_get;
+	chip->set = ts5500_gpio_set;
+	chip->can_sleep = 0;
+	chip->base = DIO1_0;
+	chip->label = pdata->name;
+	chip->ngpio = (use_lcdio ? LCD_WR + 1 : DIO2_13 + 1);
+
+	/* Enable IRQ generation */
+	mutex_lock(&drvdata->gpio_lock);
+	PORT_BIT_SET(0x7A, 7); /* DIO1_13 on IRQ7 */
+	PORT_BIT_SET(0x7D, 7); /* DIO2_13 on IRQ6 */
+	if (use_lcdio) {
+		PORT_BIT_CLEAR(0x7D, 4); /* Enable LCD header usage as DIO */
+		PORT_BIT_SET(0x7D, 6);   /* LCD_RS on IRQ1 */
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
+	printk(KERN_ERR "gpio: Failed registering gpio chip.\n");
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
+static int __devexit ts5500_gpio_remove(struct platform_device *pdev)
+{
+	struct ts5500_gpio_platform_data *pdata;
+	struct ts5500_drvdata *drvdata;
+	int ret, i;
+
+	pdata = (struct ts5500_gpio_platform_data *) pdev->dev.platform_data;
+	drvdata = platform_get_drvdata(pdev);
+
+	/* Release GPIO lines */
+	for (i = 0; i < ARRAY_SIZE(requested_gpios); i++) {
+		if (requested_gpios[i])
+			gpio_free(i);
+	}
+
+	mutex_lock(&drvdata->gpio_lock);
+	/* Disable IRQs generation */
+	PORT_BIT_CLEAR(0x7A, 7);
+	PORT_BIT_CLEAR(0x7D, 7);
+	if (use_lcdio)
+		PORT_BIT_CLEAR(0x7D, 6);
+
+	/* Release IO regions */
+	release_region(0x7A, 3);
+	release_region(0x7D, 3);
+	if (use_lcdio)
+		release_region(0x72, 2);
+	mutex_unlock(&drvdata->gpio_lock);
+
+	ret = gpiochip_remove(&drvdata->gpio_chip);
+	if (ret)
+		dev_err(&pdev->dev, "gpiochip_remove() failed, retcode %d\n",
+			ret);
+
+	kfree(drvdata);
+	return ret;
+}
+
+static int __init ts5500_gpio_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&ts5500_gpio_driver);
+	if (ret)
+		return ret;
+
+	ret = platform_device_register(&gpio_device);
+	if (ret) {
+		printk(MODULE_NAME ": Failed to register platform device\n");
+		platform_driver_unregister(&ts5500_gpio_driver);
+		return ret;
+	}
+
+	printk(MODULE_NAME ": GPIO/DIO driver loaded.\n");
+	return 0;
+}
+module_init(ts5500_gpio_init);
+
+static void __exit ts5500_gpio_exit(void)
+{
+	platform_device_unregister(&gpio_device);
+	platform_driver_unregister(&ts5500_gpio_driver);
+	printk(MODULE_NAME ": unloaded.\n");
+}
+module_exit(ts5500_gpio_exit);
+
+MODULE_AUTHOR("Jerome Oufella");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Technologic Systems TS5500, GPIO/DIO driver");
diff --git a/include/linux/ts5500-gpio.h b/include/linux/ts5500-gpio.h
new file mode 100644
index 0000000..387039b
--- /dev/null
+++ b/include/linux/ts5500-gpio.h
@@ -0,0 +1,68 @@
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
+#ifndef TS5500_GPIO_H_
+#define TS5500_GPIO_H_
+
+#define DIO1_0		0
+#define DIO1_1		1
+#define DIO1_2		2
+#define DIO1_3		3
+#define DIO1_4		4
+#define DIO1_5		5
+#define DIO1_6		6
+#define DIO1_7		7
+#define DIO1_8		8
+#define DIO1_9		9
+#define DIO1_10		10
+#define DIO1_11		11
+#define DIO1_12		12
+#define DIO1_13		13
+#define DIO2_0		14
+#define DIO2_1		15
+#define DIO2_2		16
+#define DIO2_3		17
+#define DIO2_4		18
+#define DIO2_5		19
+#define DIO2_6		20
+#define DIO2_7		21
+#define DIO2_8		22
+#define DIO2_9		23
+#define DIO2_10		24
+#define DIO2_11		25
+/* #define DIO2_12 - Leave commented out as this line simply doesn't exist */
+#define DIO2_13		26
+#define LCD_0		27
+#define LCD_1		28
+#define LCD_2		29
+#define LCD_3		30
+#define LCD_4		31
+#define LCD_5		32
+#define LCD_6		33
+#define LCD_7		34
+#define LCD_EN		35
+#define LCD_RS		36
+#define LCD_WR		37
+
+/* Lines that can trigger IRQs */
+#define DIO1_13_IRQ	7
+#define DIO2_13_IRQ	6
+#define LCD_RS_IRQ	1
+
+/**
+ * struct ts5500_gpio_platform_data - platform data for ts-5500 gpio usage
+ * @name:	Name of the resource in /sys/class/gpio/gpiochip%d/label
+ */
+struct ts5500_gpio_platform_data {
+	const char *name;
+};
+
+#endif /* TS5500_GPIO_H_ */
-- 
1.7.1

