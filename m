Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab2KENsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:48:46 -0500
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:49611 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932414Ab2KENsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:48:42 -0500
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: linus.walleij@linaro.org
Cc: poeschel@lemonage.de, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-iio@vger.kernel.org
Subject: [PATCH v3 3/5] gpio: add viperboard gpio driver
Date: Mon,  5 Nov 2012 15:48:24 +0100
Message-Id: <1352126906-4560-3-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352126906-4560-1-git-send-email-larsi@wh2.tu-dresden.de>
References: <1352126906-4560-1-git-send-email-larsi@wh2.tu-dresden.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

This adds the mfd cell to use the gpio a and gpio b part
of the Nano River Technologies viperboard.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/gpio/Kconfig           |   13 +
 drivers/gpio/Makefile          |    1 +
 drivers/gpio/gpio-viperboard.c |  517 ++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/viperboard.c       |    3 +
 include/linux/mfd/viperboard.h |    2 +
 5 files changed, 536 insertions(+)
 create mode 100644 drivers/gpio/gpio-viperboard.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d055cee..c3bbd08 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -649,4 +649,17 @@ config GPIO_MSIC
 	  Enable support for GPIO on intel MSIC controllers found in
 	  intel MID devices
 
+comment "USB GPIO expanders:"
+
+config GPIO_VIPERBOARD
+	tristate "Viperboard GPIO a & b support"
+	depends on MFD_VIPERBOARD && USB
+	help
+	  Say yes here to access the GPIO signals of Nano River
+	  Technologies Viperboard. There are two GPIO chips on the
+	  board: gpioa and gpiob.
+          See viperboard API specification and Nano
+          River Tech's viperboard.h for detailed meaning
+          of the module parameters.
+
 endif
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 9aeed67..16a1385 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_GPIO_TPS65912)	+= gpio-tps65912.o
 obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
 obj-$(CONFIG_GPIO_TWL6040)	+= gpio-twl6040.o
 obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
+obj-$(CONFIG_GPIO_VIPERBOARD)	+= gpio-viperboard.o
 obj-$(CONFIG_GPIO_VR41XX)	+= gpio-vr41xx.o
 obj-$(CONFIG_GPIO_VT8500)	+= gpio-vt8500.o
 obj-$(CONFIG_GPIO_VX855)	+= gpio-vx855.o
diff --git a/drivers/gpio/gpio-viperboard.c b/drivers/gpio/gpio-viperboard.c
new file mode 100644
index 0000000..1377299
--- /dev/null
+++ b/drivers/gpio/gpio-viperboard.c
@@ -0,0 +1,517 @@
+/*
+ *  Nano River Technologies viperboard GPIO lib driver
+ *
+ *  (C) 2012 by Lemonage GmbH
+ *  Author: Lars Poeschel <poeschel@lemonage.de>
+ *  All rights reserved.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the	License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+
+#include <linux/usb.h>
+#include <linux/gpio.h>
+
+#include <linux/mfd/viperboard.h>
+
+#define VPRBRD_GPIOA_CLK_1MHZ		0
+#define VPRBRD_GPIOA_CLK_100KHZ		1
+#define VPRBRD_GPIOA_CLK_10KHZ		2
+#define VPRBRD_GPIOA_CLK_1KHZ		3
+#define VPRBRD_GPIOA_CLK_100HZ		4
+#define VPRBRD_GPIOA_CLK_10HZ		5
+
+#define VPRBRD_GPIOA_FREQ_DEFAULT	1000
+
+#define VPRBRD_GPIOA_CMD_CONT		0x00
+#define VPRBRD_GPIOA_CMD_PULSE		0x01
+#define VPRBRD_GPIOA_CMD_PWM		0x02
+#define VPRBRD_GPIOA_CMD_SETOUT		0x03
+#define VPRBRD_GPIOA_CMD_SETIN		0x04
+#define VPRBRD_GPIOA_CMD_SETINT		0x05
+#define VPRBRD_GPIOA_CMD_GETIN		0x06
+
+#define VPRBRD_GPIOB_CMD_SETDIR		0x00
+#define VPRBRD_GPIOB_CMD_SETVAL		0x01
+
+struct vprbrd_gpioa_msg {
+	u8 cmd;
+	u8 clk;
+	u8 offset;
+	u8 t1;
+	u8 t2;
+	u8 invert;
+	u8 pwmlevel;
+	u8 outval;
+	u8 risefall;
+	u8 answer;
+	u8 __fill;
+} __packed;
+
+struct vprbrd_gpiob_msg {
+	u8 cmd;
+	u16 val;
+	u16 mask;
+} __packed;
+
+struct vprbrd_gpio {
+	struct gpio_chip gpioa; /* gpio a related things */
+	u32 gpioa_out;
+	u32 gpioa_val;
+	struct gpio_chip gpiob; /* gpio b related things */
+	u32 gpiob_out;
+	u32 gpiob_val;
+	struct vprbrd *vb;
+};
+
+/* gpioa sampling clock module parameter */
+static unsigned char gpioa_clk;
+static unsigned int gpioa_freq = VPRBRD_GPIOA_FREQ_DEFAULT;
+module_param(gpioa_freq, uint, 0);
+MODULE_PARM_DESC(gpioa_freq,
+	"gpio-a sampling freq in Hz (default is 1000Hz) valid values: 10, 100, 1000, 10000, 100000, 1000000");
+
+/* ----- begin of gipo a chip -------------------------------------------- */
+
+static int vprbrd_gpioa_get(struct gpio_chip *chip,
+		unsigned offset)
+{
+	int ret, answer, error = 0;
+	struct vprbrd_gpio *gpio =
+			container_of(chip, struct vprbrd_gpio, gpioa);
+	struct vprbrd *vb = gpio->vb;
+	struct vprbrd_gpioa_msg *gamsg = (struct vprbrd_gpioa_msg *)vb->buf;
+
+	/* if io is set to output, just return the saved value */
+	if (gpio->gpioa_out & (1 << offset))
+		return gpio->gpioa_val & (1 << offset);
+
+	mutex_lock(&vb->lock);
+
+	gamsg->cmd = VPRBRD_GPIOA_CMD_GETIN;
+	gamsg->clk = 0x00;
+	gamsg->offset = offset;
+	gamsg->t1 = 0x00;
+	gamsg->t2 = 0x00;
+	gamsg->invert = 0x00;
+	gamsg->pwmlevel = 0x00;
+	gamsg->outval = 0x00;
+	gamsg->risefall = 0x00;
+	gamsg->answer = 0x00;
+	gamsg->__fill = 0x00;
+
+	ret = usb_control_msg(vb->usb_dev, usb_sndctrlpipe(vb->usb_dev, 0),
+		VPRBRD_USB_REQUEST_GPIOA, VPRBRD_USB_TYPE_OUT, 0x0000,
+		0x0000, gamsg, sizeof(struct vprbrd_gpioa_msg),
+		VPRBRD_USB_TIMEOUT_MS);
+	if (ret != sizeof(struct vprbrd_gpioa_msg))
+		error = -EREMOTEIO;
+
+	ret = usb_control_msg(vb->usb_dev, usb_rcvctrlpipe(vb->usb_dev, 0),
+		VPRBRD_USB_REQUEST_GPIOA, VPRBRD_USB_TYPE_IN, 0x0000,
+		0x0000, gamsg, sizeof(struct vprbrd_gpioa_msg),
+		VPRBRD_USB_TIMEOUT_MS);
+	answer = gamsg->answer & 0x01;
+
+	mutex_unlock(&vb->lock);
+
+	if (ret != sizeof(struct vprbrd_gpioa_msg))
+		error = -EREMOTEIO;
+
+	if (error)
+		return error;
+
+	return answer;
+}
+
+static void vprbrd_gpioa_set(struct gpio_chip *chip,
+		unsigned offset, int value)
+{
+	int ret;
+	struct vprbrd_gpio *gpio =
+			container_of(chip, struct vprbrd_gpio, gpioa);
+	struct vprbrd *vb = gpio->vb;
+	struct vprbrd_gpioa_msg *gamsg = (struct vprbrd_gpioa_msg *)vb->buf;
+
+	if (gpio->gpioa_out & (1 << offset)) {
+		if (value)
+			gpio->gpioa_val |= (1 << offset);
+		else
+			gpio->gpioa_val &= ~(1 << offset);
+
+		mutex_lock(&vb->lock);
+
+		gamsg->cmd = VPRBRD_GPIOA_CMD_SETOUT;
+		gamsg->clk = 0x00;
+		gamsg->offset = offset;
+		gamsg->t1 = 0x00;
+		gamsg->t2 = 0x00;
+		gamsg->invert = 0x00;
+		gamsg->pwmlevel = 0x00;
+		gamsg->outval = value;
+		gamsg->risefall = 0x00;
+		gamsg->answer = 0x00;
+		gamsg->__fill = 0x00;
+
+		ret = usb_control_msg(vb->usb_dev,
+			usb_sndctrlpipe(vb->usb_dev, 0),
+			VPRBRD_USB_REQUEST_GPIOA, VPRBRD_USB_TYPE_OUT,
+			0x0000,	0x0000, gamsg,
+			sizeof(struct vprbrd_gpioa_msg), VPRBRD_USB_TIMEOUT_MS);
+
+		mutex_unlock(&vb->lock);
+
+		if (ret != sizeof(struct vprbrd_gpioa_msg))
+			dev_err(chip->dev, "usb error setting pin value\n");
+	}
+}
+
+static int vprbrd_gpioa_direction_input(struct gpio_chip *chip,
+			unsigned offset)
+{
+	int ret;
+	struct vprbrd_gpio *gpio =
+			container_of(chip, struct vprbrd_gpio, gpioa);
+	struct vprbrd *vb = gpio->vb;
+	struct vprbrd_gpioa_msg *gamsg = (struct vprbrd_gpioa_msg *)vb->buf;
+
+	gpio->gpioa_out &= ~(1 << offset);
+
+	mutex_lock(&vb->lock);
+
+	gamsg->cmd = VPRBRD_GPIOA_CMD_SETIN;
+	gamsg->clk = gpioa_clk;
+	gamsg->offset = offset;
+	gamsg->t1 = 0x00;
+	gamsg->t2 = 0x00;
+	gamsg->invert = 0x00;
+	gamsg->pwmlevel = 0x00;
+	gamsg->outval = 0x00;
+	gamsg->risefall = 0x00;
+	gamsg->answer = 0x00;
+	gamsg->__fill = 0x00;
+
+	ret = usb_control_msg(vb->usb_dev, usb_sndctrlpipe(vb->usb_dev, 0),
+		VPRBRD_USB_REQUEST_GPIOA, VPRBRD_USB_TYPE_OUT, 0x0000,
+		0x0000, gamsg, sizeof(struct vprbrd_gpioa_msg),
+		VPRBRD_USB_TIMEOUT_MS);
+
+	mutex_unlock(&vb->lock);
+
+	if (ret != sizeof(struct vprbrd_gpioa_msg))
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int vprbrd_gpioa_direction_output(struct gpio_chip *chip,
+			unsigned offset, int value)
+{
+	int ret;
+	struct vprbrd_gpio *gpio =
+			container_of(chip, struct vprbrd_gpio, gpioa);
+	struct vprbrd *vb = gpio->vb;
+	struct vprbrd_gpioa_msg *gamsg = (struct vprbrd_gpioa_msg *)vb->buf;
+
+	gpio->gpioa_out |= (1 << offset);
+	if (value)
+		gpio->gpioa_val |= (1 << offset);
+	else
+		gpio->gpioa_val &= ~(1 << offset);
+
+	mutex_lock(&vb->lock);
+
+	gamsg->cmd = VPRBRD_GPIOA_CMD_SETOUT;
+	gamsg->clk = 0x00;
+	gamsg->offset = offset;
+	gamsg->t1 = 0x00;
+	gamsg->t2 = 0x00;
+	gamsg->invert = 0x00;
+	gamsg->pwmlevel = 0x00;
+	gamsg->outval = value;
+	gamsg->risefall = 0x00;
+	gamsg->answer = 0x00;
+	gamsg->__fill = 0x00;
+
+	ret = usb_control_msg(vb->usb_dev, usb_sndctrlpipe(vb->usb_dev, 0),
+		VPRBRD_USB_REQUEST_GPIOA, VPRBRD_USB_TYPE_OUT, 0x0000,
+		0x0000, gamsg, sizeof(struct vprbrd_gpioa_msg),
+		VPRBRD_USB_TIMEOUT_MS);
+
+	mutex_unlock(&vb->lock);
+
+	if (ret != sizeof(struct vprbrd_gpioa_msg))
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+/* ----- end of gpio a chip ---------------------------------------------- */
+
+/* ----- begin of gipo b chip -------------------------------------------- */
+
+static int vprbrd_gpiob_setdir(struct vprbrd *vb, unsigned offset,
+	unsigned dir)
+{
+	struct vprbrd_gpiob_msg *gbmsg = (struct vprbrd_gpiob_msg *)vb->buf;
+	int ret;
+
+	gbmsg->cmd = VPRBRD_GPIOB_CMD_SETDIR;
+	gbmsg->val = cpu_to_be16(dir << offset);
+	gbmsg->mask = cpu_to_be16(0x0001 << offset);
+
+	ret = usb_control_msg(vb->usb_dev, usb_sndctrlpipe(vb->usb_dev, 0),
+		VPRBRD_USB_REQUEST_GPIOB, VPRBRD_USB_TYPE_OUT, 0x0000,
+		0x0000, gbmsg, sizeof(struct vprbrd_gpiob_msg),
+		VPRBRD_USB_TIMEOUT_MS);
+
+	if (ret != sizeof(struct vprbrd_gpiob_msg))
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int vprbrd_gpiob_get(struct gpio_chip *chip,
+		unsigned offset)
+{
+	int ret;
+	u16 val;
+	struct vprbrd_gpio *gpio =
+			container_of(chip, struct vprbrd_gpio, gpiob);
+	struct vprbrd *vb = gpio->vb;
+	struct vprbrd_gpiob_msg *gbmsg = (struct vprbrd_gpiob_msg *)vb->buf;
+
+	/* if io is set to output, just return the saved value */
+	if (gpio->gpiob_out & (1 << offset))
+		return gpio->gpiob_val & (1 << offset);
+
+	mutex_lock(&vb->lock);
+
+	ret = usb_control_msg(vb->usb_dev, usb_rcvctrlpipe(vb->usb_dev, 0),
+		VPRBRD_USB_REQUEST_GPIOB, VPRBRD_USB_TYPE_IN, 0x0000,
+		0x0000, gbmsg,	sizeof(struct vprbrd_gpiob_msg),
+		VPRBRD_USB_TIMEOUT_MS);
+	val = gbmsg->val;
+
+	mutex_unlock(&vb->lock);
+
+	if (ret != sizeof(struct vprbrd_gpiob_msg))
+		return ret;
+
+	/* cache the read values */
+	gpio->gpiob_val = be16_to_cpu(val);
+
+	return (gpio->gpiob_val >> offset) & 0x1;
+}
+
+static void vprbrd_gpiob_set(struct gpio_chip *chip,
+		unsigned offset, int value)
+{
+	int ret;
+	struct vprbrd_gpio *gpio =
+			container_of(chip, struct vprbrd_gpio, gpiob);
+	struct vprbrd *vb = gpio->vb;
+	struct vprbrd_gpiob_msg *gbmsg = (struct vprbrd_gpiob_msg *)vb->buf;
+
+	if (gpio->gpiob_out & (1 << offset)) {
+		if (value)
+			gpio->gpiob_val |= (1 << offset);
+		else
+			gpio->gpiob_val &= ~(1 << offset);
+
+		mutex_lock(&vb->lock);
+
+		gbmsg->cmd = VPRBRD_GPIOB_CMD_SETVAL;
+		gbmsg->val = cpu_to_be16(value << offset);
+		gbmsg->mask = cpu_to_be16(0x0001 << offset);
+
+		ret = usb_control_msg(vb->usb_dev,
+			usb_sndctrlpipe(vb->usb_dev, 0),
+			VPRBRD_USB_REQUEST_GPIOB, VPRBRD_USB_TYPE_OUT,
+			0x0000,	0x0000, gbmsg,
+			sizeof(struct vprbrd_gpiob_msg), VPRBRD_USB_TIMEOUT_MS);
+
+		mutex_unlock(&vb->lock);
+
+		if (ret != sizeof(struct vprbrd_gpiob_msg))
+			dev_err(chip->dev, "usb error setting pin value\n");
+	}
+}
+
+static int vprbrd_gpiob_direction_input(struct gpio_chip *chip,
+			unsigned offset)
+{
+	int ret;
+	struct vprbrd_gpio *gpio =
+			container_of(chip, struct vprbrd_gpio, gpiob);
+	struct vprbrd *vb = gpio->vb;
+
+	gpio->gpiob_out &= ~(1 << offset);
+
+	mutex_lock(&vb->lock);
+
+	ret = vprbrd_gpiob_setdir(vb, offset, 0);
+
+	mutex_unlock(&vb->lock);
+
+	if (ret)
+		dev_err(chip->dev, "usb error setting pin to input\n");
+
+	return ret;
+}
+
+static int vprbrd_gpiob_direction_output(struct gpio_chip *chip,
+			unsigned offset, int value)
+{
+	int ret;
+	struct vprbrd_gpio *gpio =
+			container_of(chip, struct vprbrd_gpio, gpiob);
+	struct vprbrd *vb = gpio->vb;
+
+	gpio->gpiob_out |= (1 << offset);
+	if (value)
+		gpio->gpiob_val |= (1 << offset);
+	else
+		gpio->gpiob_val &= ~(1 << offset);
+
+	mutex_lock(&vb->lock);
+
+	ret = vprbrd_gpiob_setdir(vb, offset, 1);
+	if (ret)
+		dev_err(chip->dev, "usb error setting pin to output\n");
+
+	mutex_unlock(&vb->lock);
+
+	vprbrd_gpiob_set(chip, offset, value);
+
+	return ret;
+}
+
+/* ----- end of gpio b chip ---------------------------------------------- */
+
+static int __devinit vprbrd_gpio_probe(struct platform_device *pdev)
+{
+	struct vprbrd *vb = dev_get_drvdata(pdev->dev.parent);
+	struct vprbrd_gpio *vb_gpio;
+	int ret;
+
+	vb_gpio = devm_kzalloc(&pdev->dev, sizeof(*vb_gpio), GFP_KERNEL);
+	if (vb_gpio == NULL)
+		return -ENOMEM;
+
+	vb_gpio->vb = vb;
+	/* registering gpio a */
+	vb_gpio->gpioa.label = "viperboard gpio a";
+	vb_gpio->gpioa.dev = &pdev->dev;
+	vb_gpio->gpioa.owner = THIS_MODULE;
+	vb_gpio->gpioa.base = -1;
+	vb_gpio->gpioa.ngpio = 16;
+	vb_gpio->gpioa.can_sleep = 1;
+	vb_gpio->gpioa.set = vprbrd_gpioa_set;
+	vb_gpio->gpioa.get = vprbrd_gpioa_get;
+	vb_gpio->gpioa.direction_input = vprbrd_gpioa_direction_input;
+	vb_gpio->gpioa.direction_output = vprbrd_gpioa_direction_output;
+	ret = gpiochip_add(&vb_gpio->gpioa);
+	if (ret < 0) {
+		dev_err(vb_gpio->gpioa.dev, "could not add gpio a");
+		goto err_gpioa;
+	}
+
+	/* registering gpio b */
+	vb_gpio->gpiob.label = "viperboard gpio b";
+	vb_gpio->gpiob.dev = &pdev->dev;
+	vb_gpio->gpiob.owner = THIS_MODULE;
+	vb_gpio->gpiob.base = -1;
+	vb_gpio->gpiob.ngpio = 16;
+	vb_gpio->gpiob.can_sleep = 1;
+	vb_gpio->gpiob.set = vprbrd_gpiob_set;
+	vb_gpio->gpiob.get = vprbrd_gpiob_get;
+	vb_gpio->gpiob.direction_input = vprbrd_gpiob_direction_input;
+	vb_gpio->gpiob.direction_output = vprbrd_gpiob_direction_output;
+	ret = gpiochip_add(&vb_gpio->gpiob);
+	if (ret < 0) {
+		dev_err(vb_gpio->gpiob.dev, "could not add gpio b");
+		goto err_gpiob;
+	}
+
+	platform_set_drvdata(pdev, vb_gpio);
+
+	return ret;
+
+err_gpiob:
+	ret = gpiochip_remove(&vb_gpio->gpioa);
+
+err_gpioa:
+	return ret;
+}
+
+static int __devexit vprbrd_gpio_remove(struct platform_device *pdev)
+{
+	struct vprbrd_gpio *vb_gpio = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = gpiochip_remove(&vb_gpio->gpiob);
+	if (ret == 0)
+		ret = gpiochip_remove(&vb_gpio->gpioa);
+
+	return ret;
+}
+
+static struct platform_driver vprbrd_gpio_driver = {
+	.driver.name	= "viperboard-gpio",
+	.driver.owner	= THIS_MODULE,
+	.probe		= vprbrd_gpio_probe,
+	.remove		= __devexit_p(vprbrd_gpio_remove),
+};
+
+static int __init vprbrd_gpio_init(void)
+{
+	switch (gpioa_freq) {
+	case 1000000:
+		gpioa_clk = VPRBRD_GPIOA_CLK_1MHZ;
+		break;
+	case 100000:
+		gpioa_clk = VPRBRD_GPIOA_CLK_100KHZ;
+		break;
+	case 10000:
+		gpioa_clk = VPRBRD_GPIOA_CLK_10KHZ;
+		break;
+	case 1000:
+		gpioa_clk = VPRBRD_GPIOA_CLK_1KHZ;
+		break;
+	case 100:
+		gpioa_clk = VPRBRD_GPIOA_CLK_100HZ;
+		break;
+	case 10:
+		gpioa_clk = VPRBRD_GPIOA_CLK_10HZ;
+		break;
+	default:
+		pr_warn("invalid gpioa_freq (%d)\n", gpioa_freq);
+		gpioa_clk = VPRBRD_GPIOA_CLK_1KHZ;
+	}
+
+	return platform_driver_register(&vprbrd_gpio_driver);
+}
+subsys_initcall(vprbrd_gpio_init);
+
+static void __exit vprbrd_gpio_exit(void)
+{
+	platform_driver_unregister(&vprbrd_gpio_driver);
+}
+module_exit(vprbrd_gpio_exit);
+
+MODULE_AUTHOR("Lars Poeschel <poeschel@lemonage.de>");
+MODULE_DESCRIPTION("GPIO driver for Nano River Techs Viperboard");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:viperboard-gpio");
diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index 34bc372..4b2ffbf 100644
--- a/drivers/mfd/viperboard.c
+++ b/drivers/mfd/viperboard.c
@@ -38,6 +38,9 @@ static const struct usb_device_id vprbrd_table[] = {
 MODULE_DEVICE_TABLE(usb, vprbrd_table);
 
 static struct mfd_cell vprbrd_devs[] = {
+	{
+		.name = "viperboard-gpio",
+	},
 };
 
 static int vprbrd_probe(struct usb_interface *interface,
diff --git a/include/linux/mfd/viperboard.h b/include/linux/mfd/viperboard.h
index 0d13424..42d339f 100644
--- a/include/linux/mfd/viperboard.h
+++ b/include/linux/mfd/viperboard.h
@@ -44,6 +44,8 @@
 #define VPRBRD_USB_TIMEOUT_MS       100
 #define VPRBRD_USB_REQUEST_MAJOR    0xea
 #define VPRBRD_USB_REQUEST_MINOR    0xeb
+#define VPRBRD_USB_REQUEST_GPIOA    0xed
+#define VPRBRD_USB_REQUEST_GPIOB    0xdd
 
 struct vprbrd_i2c_write_hdr {
 	u8 cmd;
-- 
1.7.10.4

