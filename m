Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab2H0NPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 09:15:42 -0400
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:47218 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732Ab2H0NPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 09:15:40 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2012 09:15:40 EDT
From: larsi@wh2.tu-dresden.de
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Lars Poeschel <poeschel@lemonage.de>
Subject: [PATCH] mfd: viperboard driver added
Date: Mon, 27 Aug 2012 15:08:38 +0200
Message-Id: <1346072918-3982-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

First version of the driver for Nano River Tech's
viperboard added.
It supports i2c, adc, gpio a and gpio b. spi and pwm on
the first gpio a pins is not supported yet.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/mfd/Kconfig      |   17 +
 drivers/mfd/Makefile     |    1 +
 drivers/mfd/viperboard.c | 1084 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1102 insertions(+)
 create mode 100644 drivers/mfd/viperboard.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index d1facef..da0a1ed 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1002,6 +1002,23 @@ config MFD_PALMAS
 	  If you say yes here you get support for the Palmas
 	  series of PMIC chips from Texas Instruments.
 
+config MFD_VIPERBOARD
+        tristate "Support for Nano River Technologies Viperboard"
+	depends on GPIOLIB && IIO && I2C && USB
+        default n
+        help
+          Say yes here if you want support for Nano River Technologies
+          Viperboard.
+          This driver provides support for i2c, adc and
+          both gpios found on the board. The spi part is
+          currently not supported. pwm on the first gpio a
+          pins is also not supported.
+          The driver does not support all features the
+          board exposes.
+          See viperboard API specification and Nano
+          River Tech's viperboard.h for detailed meaning
+          of the module parameters.
+
 endmenu
 endif
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 79dd22d..6ab6b64 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -128,6 +128,7 @@ obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
 obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
 obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
 obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
+obj-$(CONFIG_MFD_VIPERBOARD)    += viperboard.o
 obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
 obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
 obj-$(CONFIG_MFD_ANATOP)	+= anatop-mfd.o
diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
new file mode 100644
index 0000000..7fa688e
--- /dev/null
+++ b/drivers/mfd/viperboard.c
@@ -0,0 +1,1084 @@
+/*  Nano River Technologies viperboard driver
+ *
+ *  The driver does support I2C, ADC and both GPIOs. SPI is not yet supported
+ *  PWM on the first GPIO A pins is also not supported.
+ *  See viperboard API specification and Nano River Tech's viperboard.h for
+ *  the detailed meaning of the module parameters.
+ *
+ *  (C) 2012 by Lemonage GmbH
+ *  Author: Lars Poeschel <poeschel@lemonage.de>
+ *  All rights reserved.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
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
+
+/* include interfaces to usb layer */
+#include <linux/usb.h>
+
+/* include interface to i2c layer */
+#include <linux/i2c.h>
+
+/* include interface to gpio layer */
+#include <linux/gpio.h>
+
+/* include interface to iio layer */
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+
+/* max length of a msg on USB level */
+#define VIPERBOARD_I2C_MSG_LEN          512
+
+#define VIPERBOARD_EP_OUT               0x02
+#define VIPERBOARD_EP_IN                0x86
+
+#define VIPERBOARD_I2C_FREQ_6MHZ        1                   /*   6 MBit/s */
+#define VIPERBOARD_I2C_FREQ_3MHZ        2                   /*   3 MBit/s */
+#define VIPERBOARD_I2C_FREQ_1MHZ        3                   /*   1 MBit/s */
+#define VIPERBOARD_I2C_FREQ_FAST        4                   /* 400 kbit/s */
+#define VIPERBOARD_I2C_FREQ_400KHZ      VIPERBOARD_I2C_FREQ_FAST
+#define VIPERBOARD_I2C_FREQ_200KHZ      5                   /* 200 kbit/s */
+#define VIPERBOARD_I2C_FREQ_STD         6                   /* 100 kbit/s */
+#define VIPERBOARD_I2C_FREQ_100KHZ      VIPERBOARD_I2C_FREQ_STD
+#define VIPERBOARD_I2C_FREQ_10KHZ       7                   /*  10 kbit/s */
+
+#define VIPERBOARD_I2C_CMD_WRITE        0x00
+#define VIPERBOARD_I2C_CMD_READ         0x01
+#define VIPERBOARD_I2C_CMD_ADDR         0x02
+
+#define VPRBRD_GPIOA_CLK_1              0           /* (1us   = 1MHz) */
+#define VPRBRD_GPIOA_CLK_10             1           /* (10us  = 100kHz) */
+#define VPRBRD_GPIOA_CLK_100            2           /* (100us = 10kHz) */
+#define VPRBRD_GPIOA_CLK_1000           3           /* (1ms   = 1kHz) */
+#define VPRBRD_GPIOA_CLK_10000          4           /* (10ms  = 100Hz) */
+#define VPRBRD_GPIOA_CLK_100000         5           /* (100ms = 10Hz) */
+
+#define VPRBRD_GPIOA_CMD_CONT           0x00
+#define VPRBRD_GPIOA_CMD_PULSE          0x01
+#define VPRBRD_GPIOA_CMD_PWM            0x02
+#define VPRBRD_GPIOA_CMD_SETOUT         0x03
+#define VPRBRD_GPIOA_CMD_SETIN          0x04
+#define VPRBRD_GPIOA_CMD_SETINT         0x05
+#define VPRBRD_GPIOA_CMD_GETIN          0x06
+
+#define VPRBRD_GPIOB_CMD_SETDIR         0x00
+#define VPRBRD_GPIOB_CMD_SETVAL         0x01
+
+#define VPRBRD_ADC_CMD_GET              0x00
+
+struct __packed vprbrd_i2c_write_hdr {
+	u8 cmd;
+	u16 addr;
+	u8 len1;
+	u8 len2;
+	u8 last;
+	u8 chan;
+	u16 spi;
+};
+
+struct __packed vprbrd_i2c_read_hdr {
+	u8 cmd;
+	u16 addr;
+	u8 len0;
+	u8 len1;
+	u8 len2;
+	u8 len3;
+	u8 len4;
+	u8 len5;
+	u16 tf1;                        /* transfer 1 length */
+	u16 tf2;                        /* transfer 2 length */
+};
+
+struct __packed vprbrd_i2c_status {
+	u8 unknown[11];
+	u8 status;
+};
+
+struct __packed vprbrd_i2c_write_msg {
+	struct vprbrd_i2c_write_hdr header;
+	u8 data[VIPERBOARD_I2C_MSG_LEN - sizeof(struct vprbrd_i2c_write_hdr)];
+};
+
+struct __packed vprbrd_i2c_read_msg {
+	struct vprbrd_i2c_read_hdr header;
+	u8 data[VIPERBOARD_I2C_MSG_LEN - sizeof(struct vprbrd_i2c_read_hdr)];
+};
+
+struct __packed vprbrd_i2c_addr_msg {
+	u8 cmd;
+	u8 addr;
+	u8 unknown1;
+	u16 len;
+	u8 unknown2;
+	u8 unknown3;
+};
+
+struct __packed vprbrd_gpioa_msg {
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
+};
+
+struct __packed vprbrd_gpiob_msg {
+	u8 cmd;
+	u16 val;
+	u16 mask;
+};
+
+struct __packed vprbrd_adc_msg {
+	u8 cmd;
+	u8 chan;
+	u8 val;
+};
+
+/* Structure to hold all of our device specific stuff */
+struct vprbrd {
+	struct usb_device *usb_dev; /* the usb device for this device */
+	struct i2c_adapter i2c; /* i2c related things */
+	struct gpio_chip gpioa; /* gpio a related things */
+	u32 gpioa_out;
+	u32 gpioa_val;
+	struct gpio_chip gpiob; /* gpio b related things */
+	u32 gpiob_out;
+	u32 gpiob_val;
+	struct iio_dev *iio; /* iio related things */
+	struct mutex lock;
+	u8 buf[sizeof(struct vprbrd_i2c_write_msg)];
+};
+
+/* i2c bus frequency module parameter */
+static unsigned char i2c_bus_freq = 6;
+module_param(i2c_bus_freq, byte, 0);
+MODULE_PARM_DESC(i2c_bus_freq, "i2c bus frequency (default is 6 for 100kHz)");
+/* gpioa sampling clock module parameter */
+static unsigned char gpioa_clk = 3;
+module_param(gpioa_clk, byte, 0);
+MODULE_PARM_DESC(gpioa_clk, "gpio a sampling clk (default is 3 for 1 kHz)");
+
+/* ----- begin of iio layer ---------------------------------------------- */
+
+struct vprbrd_adc_info {
+	struct vprbrd *vb;
+};
+
+#define VPRBRD_ADC_CHANNEL(_index) {			\
+		.type = IIO_VOLTAGE,				\
+		.indexed = 1,					\
+		.channel = _index,				\
+		.info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT,	\
+		.scan_index = _index,				\
+		.scan_type.sign = 'u',                          \
+		.scan_type.realbits = 8,                        \
+		.scan_type.storagebits = 8,                     \
+}
+
+static struct iio_chan_spec vprbrd_adc_iio_channels[] = {
+		VPRBRD_ADC_CHANNEL(0),
+		VPRBRD_ADC_CHANNEL(1),
+		VPRBRD_ADC_CHANNEL(2),
+		VPRBRD_ADC_CHANNEL(3),
+};
+
+static int vprbrd_iio_read_raw(struct iio_dev *iio_dev,
+		struct iio_chan_spec const *chan,
+		int *val,
+		int *val2,
+		long mask)
+{
+	int ret, error = 0;
+	struct vprbrd_adc_info *adc = iio_priv(iio_dev);
+	struct vprbrd *vb = adc->vb;
+	struct vprbrd_adc_msg *admsg = (struct vprbrd_adc_msg *)vb->buf;
+
+	if (mask == IIO_CHAN_INFO_RAW) {
+
+		mutex_lock(&vb->lock);
+
+		admsg->cmd = VPRBRD_ADC_CMD_GET;
+		admsg->chan = chan->scan_index;
+		admsg->val = 0x00;
+
+		ret = usb_control_msg(vb->usb_dev,
+				usb_sndctrlpipe(vb->usb_dev, 0), 0xec, 0x40,
+				0x0000, 0x0000, admsg,
+				sizeof(struct vprbrd_adc_msg), 100);
+		if (ret != sizeof(struct vprbrd_adc_msg)) {
+			dev_err(&iio_dev->dev, "usb send error on adc read\n");
+			error = -EREMOTEIO;
+		}
+
+		ret = usb_control_msg(vb->usb_dev,
+				usb_rcvctrlpipe(vb->usb_dev, 0), 0xec, 0xc0,
+				0x0000, 0x0000, admsg,
+				sizeof(struct vprbrd_adc_msg), 100);
+
+		*val = admsg->val;
+
+		mutex_unlock(&vb->lock);
+
+		if (ret != sizeof(struct vprbrd_adc_msg)) {
+			dev_err(&iio_dev->dev, "usb recv error on adc read\n");
+			error = -EREMOTEIO;
+		}
+
+		if (error)
+			goto error;
+
+		return IIO_VAL_INT;
+	}
+	error =  -EINVAL;
+error:
+	return error;
+}
+
+static const struct iio_info vprbrd_adc_iio_info = {
+		.read_raw = &vprbrd_iio_read_raw,
+		.driver_module = THIS_MODULE,
+};
+
+/* ----- end of iio layer ------------------------------------------------ */
+
+/* ----- begin of gipo a layer ------------------------------------------- */
+
+static int vprbrd_gpioa_get(struct gpio_chip *chip,
+		unsigned offset)
+{
+	int ret, answer, error = 0;
+	struct vprbrd *vb = container_of(chip, struct vprbrd, gpioa);
+	struct vprbrd_gpioa_msg *gamsg = (struct vprbrd_gpioa_msg *)vb->buf;
+
+	/* if io is set to output, just return the saved value */
+	if (vb->gpioa_out & (1 << offset))
+		return vb->gpioa_val & (1 << offset);
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
+			0xed, 0x40, 0x0000, 0x0000, gamsg,
+			sizeof(struct vprbrd_gpioa_msg), 100);
+	if (ret != sizeof(struct vprbrd_gpioa_msg))
+		error = -EREMOTEIO;
+
+	ret = usb_control_msg(vb->usb_dev, usb_rcvctrlpipe(vb->usb_dev, 0),
+			0xed, 0xc0, 0x0000, 0x0000, gamsg,
+			sizeof(struct vprbrd_gpioa_msg), 100);
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
+	struct vprbrd *vb = container_of(chip, struct vprbrd, gpioa);
+	struct vprbrd_gpioa_msg *gamsg = (struct vprbrd_gpioa_msg *)vb->buf;
+
+	if (vb->gpioa_out & (1 << offset)) {
+		if (value)
+			vb->gpioa_val |= (1 << offset);
+		else
+			vb->gpioa_val &= ~(1 << offset);
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
+			usb_sndctrlpipe(vb->usb_dev, 0), 0xed, 0x40, 0x0000,
+			0x0000, gamsg, sizeof(struct vprbrd_gpioa_msg), 100);
+
+		mutex_unlock(&vb->lock);
+
+		if (ret != sizeof(struct vprbrd_gpioa_msg))
+			dev_err(chip->dev, "usb error setting pin value\n");
+	}
+}
+
+static int vprbrd_gpioa_direction_input(struct gpio_chip *chip,
+		unsigned offset)
+{
+	int ret;
+	struct vprbrd *vb = container_of(chip, struct vprbrd, gpioa);
+	struct vprbrd_gpioa_msg *gamsg = (struct vprbrd_gpioa_msg *)vb->buf;
+
+	vb->gpioa_out &= ~(1 << offset);
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
+			0xed, 0x40, 0x0000, 0x0000, gamsg,
+			sizeof(struct vprbrd_gpioa_msg), 100);
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
+		unsigned offset, int value)
+{
+	int ret;
+	struct vprbrd *vb = container_of(chip, struct vprbrd, gpioa);
+	struct vprbrd_gpioa_msg *gamsg = (struct vprbrd_gpioa_msg *)vb->buf;
+
+	vb->gpioa_out |= (1 << offset);
+	if (value)
+		vb->gpioa_val |= (1 << offset);
+	else
+		vb->gpioa_val &= ~(1 << offset);
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
+			0xed, 0x40, 0x0000, 0x0000, gamsg,
+			sizeof(struct vprbrd_gpioa_msg), 100);
+
+	mutex_unlock(&vb->lock);
+
+	if (ret != sizeof(struct vprbrd_gpioa_msg))
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+/* ----- end of gpio a layer --------------------------------------------- */
+
+/* ----- begin of gipo b layer ------------------------------------------- */
+
+static int vprbrd_gpiob_setdir(struct vprbrd *vb, unsigned offset,
+		unsigned dir)
+{
+	struct vprbrd_gpiob_msg *gbmsg = (struct vprbrd_gpiob_msg *)vb->buf;
+	int ret;
+
+	gbmsg->cmd = VPRBRD_GPIOB_CMD_SETDIR;
+	gbmsg->val = cpu_to_be16(dir << offset);
+	gbmsg->mask = cpu_to_be16(0x0001 << offset);
+
+	ret = usb_control_msg(vb->usb_dev, usb_sndctrlpipe(vb->usb_dev, 0),
+			0xdd, 0x40, 0x0000, 0x0000, gbmsg,
+			sizeof(struct vprbrd_gpiob_msg), 100);
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
+	struct vprbrd *vb = container_of(chip, struct vprbrd, gpiob);
+	struct vprbrd_gpiob_msg *gbmsg = (struct vprbrd_gpiob_msg *)vb->buf;
+
+	/* if io is set to output, just return the saved value */
+	if (vb->gpiob_out & (1 << offset))
+		return vb->gpiob_val & (1 << offset);
+
+	mutex_lock(&vb->lock);
+
+	ret = usb_control_msg(vb->usb_dev, usb_rcvctrlpipe(vb->usb_dev, 0),
+			0xdd, 0xc0, 0x0000, 0x0000, gbmsg,
+			sizeof(struct vprbrd_gpiob_msg), 100);
+	val = gbmsg->val;
+
+	mutex_unlock(&vb->lock);
+
+	if (ret != sizeof(struct vprbrd_gpiob_msg))
+		return ret;
+
+	/* cache the read values */
+	vb->gpiob_val = be16_to_cpu(val);
+
+	return (vb->gpiob_val >> offset) & 0x1;
+}
+
+static void vprbrd_gpiob_set(struct gpio_chip *chip,
+		unsigned offset, int value)
+{
+	int ret;
+	struct vprbrd *vb = container_of(chip, struct vprbrd, gpiob);
+	struct vprbrd_gpiob_msg *gbmsg = (struct vprbrd_gpiob_msg *)vb->buf;
+
+	if (vb->gpiob_out & (1 << offset)) {
+		if (value)
+			vb->gpiob_val |= (1 << offset);
+		else
+			vb->gpiob_val &= ~(1 << offset);
+
+		mutex_lock(&vb->lock);
+
+		gbmsg->cmd = VPRBRD_GPIOB_CMD_SETVAL;
+		gbmsg->val = cpu_to_be16(value << offset);
+		gbmsg->mask = cpu_to_be16(0x0001 << offset);
+
+		ret = usb_control_msg(vb->usb_dev,
+			usb_sndctrlpipe(vb->usb_dev, 0), 0xdd, 0x40, 0x0000,
+			0x0000, gbmsg, sizeof(struct vprbrd_gpiob_msg), 100);
+
+		mutex_unlock(&vb->lock);
+
+		if (ret != sizeof(struct vprbrd_gpiob_msg))
+			dev_err(chip->dev, "usb error setting pin value\n");
+	}
+}
+
+static int vprbrd_gpiob_direction_input(struct gpio_chip *chip,
+		unsigned offset)
+{
+	int ret;
+	struct vprbrd *vb = container_of(chip, struct vprbrd, gpiob);
+
+	vb->gpiob_out &= ~(1 << offset);
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
+		unsigned offset, int value)
+{
+	int ret;
+	struct vprbrd *vb = container_of(chip, struct vprbrd, gpiob);
+
+	vb->gpiob_out |= (1 << offset);
+	if (value)
+		vb->gpiob_val |= (1 << offset);
+	else
+		vb->gpiob_val &= ~(1 << offset);
+
+	mutex_lock(&vb->lock);
+
+	ret = vprbrd_gpiob_setdir(vb, offset, 1);
+	if (ret)
+		dev_err(chip->dev, "usb error setting pin to output\n");
+
+	vprbrd_gpiob_set(chip, offset, value);
+
+	mutex_unlock(&vb->lock);
+
+	return ret;
+}
+
+/* ----- end of gpio b layer --------------------------------------------- */
+
+/* ----- begin of i2c layer ---------------------------------------------- */
+
+static int vprbrd_i2c_status(struct i2c_adapter *i2c,
+		struct vprbrd_i2c_status *status, bool prev_error)
+{
+	u16 bytes_xfer;
+	int ret;
+	struct vprbrd *vb = (struct vprbrd *)i2c->algo_data;
+
+	/* check for protocol error */
+	bytes_xfer = sizeof(struct vprbrd_i2c_status);
+
+	ret = usb_control_msg(vb->usb_dev, usb_rcvctrlpipe(vb->usb_dev, 0),
+			0xe9, 0xc0, 0x0000, 0x0000, status, bytes_xfer, 100);
+
+	if (ret != bytes_xfer)
+		prev_error = true;
+
+	if (prev_error) {
+		dev_err(&i2c->dev, "failure in usb communication\n");
+		return -EREMOTEIO;
+	}
+
+	dev_dbg(&i2c->dev, "  status = %d\n", status->status);
+	if (status->status != 0x00) {
+		dev_err(&i2c->dev, "failure: i2c protocol error\n");
+		return -EPROTO;
+	}
+	return 0;
+}
+
+static int vprbrd_i2c_receive(struct usb_device *usb_dev,
+		struct vprbrd_i2c_read_msg *rmsg, int bytes_xfer)
+{
+	int ret, bytes_actual;
+	int error = 0;
+
+	/* send the read request */
+	ret = usb_bulk_msg(usb_dev,
+			usb_sndbulkpipe(usb_dev, VIPERBOARD_EP_OUT), rmsg,
+			sizeof(struct vprbrd_i2c_read_hdr), &bytes_actual,
+			100);
+
+	if ((ret < 0) ||
+	    (bytes_actual != sizeof(struct vprbrd_i2c_read_hdr))) {
+		dev_err(&usb_dev->dev, "failure transmitting usb\n");
+		error = -EREMOTEIO;
+	}
+
+	/* read the actual data */
+	ret = usb_bulk_msg(usb_dev,
+			usb_rcvbulkpipe(usb_dev, VIPERBOARD_EP_IN),
+			rmsg, bytes_xfer, &bytes_actual, 100);
+
+	if ((ret < 0) ||
+		(bytes_xfer != bytes_actual)) {
+		dev_err(&usb_dev->dev, "failure receiving usb\n");
+		error = -EREMOTEIO;
+	}
+	return error;
+}
+
+static int vprbrd_i2c_addr(struct usb_device *usb_dev,
+		struct vprbrd_i2c_addr_msg *amsg)
+{
+	int ret, bytes_actual;
+
+	ret = usb_bulk_msg(usb_dev,
+			usb_sndbulkpipe(usb_dev, VIPERBOARD_EP_OUT),
+			amsg, sizeof(struct vprbrd_i2c_addr_msg),
+			&bytes_actual, 100);
+
+	if ((ret < 0) ||
+		(sizeof(struct vprbrd_i2c_addr_msg) != bytes_actual)) {
+		dev_err(&usb_dev->dev, "failure transmitting usb\n");
+		return -EREMOTEIO;
+	}
+	return 0;
+}
+
+static int vprbrd_i2c_read(struct vprbrd *vb, struct i2c_msg *msg)
+{
+	int ret;
+	u16 remain_len, bytes_xfer, len1, len2,
+	start = 0x0000;
+	struct vprbrd_i2c_read_msg *rmsg =
+			(struct vprbrd_i2c_read_msg *)vb->buf;
+
+	remain_len = msg->len;
+	rmsg->header.cmd = VIPERBOARD_I2C_CMD_READ;
+	while (remain_len > 0) {
+		rmsg->header.addr = cpu_to_le16(start + 0x4000);
+		if (remain_len <= 255) {
+			len1 = remain_len;
+			len2 = 0x00;
+			rmsg->header.len0 = remain_len;
+			rmsg->header.len1 = 0x00;
+			rmsg->header.len2 = 0x00;
+			rmsg->header.len3 = 0x00;
+			rmsg->header.len4 = 0x00;
+			rmsg->header.len5 = 0x00;
+			remain_len = 0;
+		} else if (remain_len <= 510) {
+			len1 = remain_len;
+			len2 = 0x00;
+			rmsg->header.len0 = remain_len - 255;
+			rmsg->header.len1 = 0xff;
+			rmsg->header.len2 = 0x00;
+			rmsg->header.len3 = 0x00;
+			rmsg->header.len4 = 0x00;
+			rmsg->header.len5 = 0x00;
+			remain_len = 0;
+		} else if (remain_len <= 512) {
+			len1 = remain_len;
+			len2 = 0x00;
+			rmsg->header.len0 = remain_len - 510;
+			rmsg->header.len1 = 0xff;
+			rmsg->header.len2 = 0xff;
+			rmsg->header.len3 = 0x00;
+			rmsg->header.len4 = 0x00;
+			rmsg->header.len5 = 0x00;
+			remain_len = 0;
+		} else if (remain_len <= 767) {
+			len1 = 512;
+			len2 = remain_len - 512;
+			rmsg->header.len0 = 0x02;
+			rmsg->header.len1 = 0xff;
+			rmsg->header.len2 = 0xff;
+			rmsg->header.len3 = remain_len - 512;
+			rmsg->header.len4 = 0x00;
+			rmsg->header.len5 = 0x00;
+			bytes_xfer = remain_len;
+			remain_len = 0;
+		} else if (remain_len <= 1022) {
+			len1 = 512;
+			len2 = remain_len - 512;
+			rmsg->header.len0 = 0x02;
+			rmsg->header.len1 = 0xff;
+			rmsg->header.len2 = 0xff;
+			rmsg->header.len3 = remain_len - 767;
+			rmsg->header.len4 = 0xff;
+			rmsg->header.len5 = 0x00;
+			remain_len = 0;
+		} else if (remain_len <= 1024) {
+			len1 = 512;
+			len2 = remain_len - 512;
+			rmsg->header.len0 = 0x02;
+			rmsg->header.len1 = 0xff;
+			rmsg->header.len2 = 0xff;
+			rmsg->header.len3 = remain_len - 1022;
+			rmsg->header.len4 = 0xff;
+			rmsg->header.len5 = 0xff;
+			remain_len = 0;
+		} else {
+			len1 = 512;
+			len2 = 512;
+			rmsg->header.len0 = 0x02;
+			rmsg->header.len1 = 0xff;
+			rmsg->header.len2 = 0xff;
+			rmsg->header.len3 = 0x02;
+			rmsg->header.len4 = 0xff;
+			rmsg->header.len5 = 0xff;
+			remain_len -= 1024;
+			start += 1024;
+		}
+		rmsg->header.tf1 = cpu_to_le16(len1);
+		rmsg->header.tf2 = cpu_to_le16(len2);
+
+		/* first read transfer */
+		ret = vprbrd_i2c_receive(vb->usb_dev, rmsg, len1);
+		if (ret < 0)
+			return ret;
+		/* copy the received data */
+		memcpy(msg->buf + start, rmsg, len1);
+
+		/* second read transfer if neccessary */
+		if (len2 > 0) {
+			ret = vprbrd_i2c_receive(vb->usb_dev, rmsg, len2);
+			if (ret < 0)
+				return ret;
+			/* copy the received data */
+			memcpy(msg->buf + start + 512, rmsg, len2);
+		}
+	}
+	return 0;
+}
+
+static int vprbrd_i2c_write(struct vprbrd *vb, struct i2c_msg *msg)
+{
+	int ret, bytes_actual;
+	u16 remain_len, bytes_xfer,
+	start = 0x0000;
+	struct vprbrd_i2c_write_msg *wmsg =
+			(struct vprbrd_i2c_write_msg *)vb->buf;
+
+	remain_len = msg->len;
+	wmsg->header.cmd = VIPERBOARD_I2C_CMD_WRITE;
+	wmsg->header.last = 0x00;
+	wmsg->header.chan = 0x00;
+	wmsg->header.spi = 0x0000;
+	while (remain_len > 0) {
+		wmsg->header.addr = cpu_to_le16(start + 0x4000);
+		if (remain_len > 503) {
+			wmsg->header.len1 = 0xff;
+			wmsg->header.len2 = 0xf8;
+			remain_len -= 503;
+			bytes_xfer = 503 + sizeof(struct vprbrd_i2c_write_hdr);
+			start += 503;
+		} else if (remain_len > 255) {
+			wmsg->header.len1 = 0xff;
+			wmsg->header.len2 = (remain_len - 255);
+			bytes_xfer = remain_len +
+					sizeof(struct vprbrd_i2c_write_hdr);
+			remain_len = 0;
+		} else {
+			wmsg->header.len1 = remain_len;
+			wmsg->header.len2 = 0x00;
+			bytes_xfer = remain_len +
+					sizeof(struct vprbrd_i2c_write_hdr);
+			remain_len = 0;
+		}
+		memcpy(wmsg->data, msg->buf + start,
+				bytes_xfer -
+				sizeof(struct vprbrd_i2c_write_hdr));
+
+		ret = usb_bulk_msg(vb->usb_dev,
+				usb_sndbulkpipe(vb->usb_dev,
+						VIPERBOARD_EP_OUT),
+				wmsg, bytes_xfer, &bytes_actual, 100);
+		if ((ret < 0) || (bytes_xfer != bytes_actual))
+			return -EREMOTEIO;
+	}
+	return 0;
+}
+
+static int vprbrd_i2c_xfer(struct i2c_adapter *i2c, struct i2c_msg *msgs,
+		int num)
+{
+	struct i2c_msg *pmsg;
+	int i, ret,
+	error = 0;
+	struct vprbrd *vb = (struct vprbrd *)i2c->algo_data;
+	struct vprbrd_i2c_addr_msg *amsg =
+			(struct vprbrd_i2c_addr_msg *)vb->buf;
+	struct vprbrd_i2c_status *smsg = (struct vprbrd_i2c_status *)vb->buf;
+
+	dev_dbg(&i2c->dev, "master xfer %d messages:\n", num);
+
+	for (i = 0 ; i < num ; i++) {
+		pmsg = &msgs[i];
+
+		dev_dbg(&i2c->dev,
+				"  %d: %s (flags %d) %d bytes to 0x%02x\n",
+				i, pmsg->flags & I2C_M_RD ? "read" : "write",
+				pmsg->flags, pmsg->len, pmsg->addr);
+
+		/* msgs longer than 2048 bytes are not supported by adapter */
+		if (pmsg->len > 2048)
+			return -EINVAL;
+
+		mutex_lock(&vb->lock);
+		/* directly send the message */
+		if (pmsg->flags & I2C_M_RD) {
+			/* read data */
+			amsg->cmd = VIPERBOARD_I2C_CMD_ADDR;
+			amsg->unknown2 = 0x00;
+			amsg->unknown3 = 0x00;
+			amsg->addr = pmsg->addr;
+			amsg->unknown1 = 0x01;
+			amsg->len = cpu_to_le16(pmsg->len);
+			/* send the addr and len, we're interested to board */
+			ret = vprbrd_i2c_addr(vb->usb_dev, amsg);
+			if (ret < 0)
+				error = ret;
+
+			ret = vprbrd_i2c_read(vb, pmsg);
+			if (ret < 0)
+				error = ret;
+
+			ret = vprbrd_i2c_status(i2c, smsg, error);
+			if (ret < 0)
+				error = ret;
+			/* in case of protocol error, return the error */
+					if (error < 0)
+						goto error;
+		} else {
+			/* write data */
+			ret = vprbrd_i2c_write(vb, pmsg);
+
+			amsg->cmd = VIPERBOARD_I2C_CMD_ADDR;
+			amsg->unknown2 = 0x00;
+			amsg->unknown3 = 0x00;
+			amsg->addr = pmsg->addr;
+			amsg->unknown1 = 0x00;
+			amsg->len = cpu_to_le16(pmsg->len);
+			/* send the addr, the data goes to to board */
+			ret = vprbrd_i2c_addr(vb->usb_dev, amsg);
+			if (ret < 0)
+				error = ret;
+
+			ret = vprbrd_i2c_status(i2c, smsg, error);
+			if (ret < 0)
+				error = ret;
+
+			if (error < 0)
+				goto error;
+		}
+		mutex_unlock(&vb->lock);
+	}
+	return 0;
+error:
+	mutex_unlock(&vb->lock);
+	return error;
+}
+
+static u32 vprbrd_i2c_func(struct i2c_adapter *i2c)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+/* This is the actual algorithm we define */
+static const struct i2c_algorithm vprbrd_algorithm = {
+		.master_xfer	= vprbrd_i2c_xfer,
+		.functionality	= vprbrd_i2c_func,
+};
+
+/* ----- end of i2c layer ------------------------------------------------ */
+
+/* ----- begin of usb layer ---------------------------------------------- */
+
+static const struct usb_device_id vprbrd_table[] = {
+		{ USB_DEVICE(0x2058, 0x1005) },   /* Nano River Technologies */
+		{ }                               /* Terminating entry */
+};
+
+MODULE_DEVICE_TABLE(usb, vprbrd_table);
+
+static void vprbrd_free(struct vprbrd *dev)
+{
+	usb_put_dev(dev->usb_dev);
+	kfree(dev);
+}
+
+static int vprbrd_probe(struct usb_interface *interface,
+		const struct usb_device_id *id)
+{
+	struct vprbrd *vb;
+	struct vprbrd_adc_info *adc;
+	struct iio_dev *iodev;
+
+	int retval = -ENOMEM;
+	u16 version = 0;
+	int pipe;
+	unsigned char buf[1];
+
+	/* allocate memory for our device state and initialize it */
+	vb = kzalloc(sizeof(*vb), GFP_KERNEL);
+	if (vb == NULL) {
+		dev_err(&interface->dev, "Out of memory\n");
+		goto error;
+	}
+
+	mutex_init(&vb->lock);
+
+	vb->usb_dev = usb_get_dev(interface_to_usbdev(interface));
+
+	/* save our data pointer in this interface device */
+	usb_set_intfdata(interface, vb);
+
+	/* get version information, major first, minor then */
+	pipe = usb_rcvctrlpipe(vb->usb_dev, 0);
+	retval = usb_control_msg(vb->usb_dev, pipe, 0xea, 0xc0, 0x0000,
+			0x0000, buf, 1, 100);
+	if (retval == 1)
+		version = buf[0];
+	retval = usb_control_msg(vb->usb_dev, pipe, 0xeb, 0xc0, 0x0000,
+			0x0000, buf, 1, 100);
+	if (retval == 1) {
+		version <<= 8;
+		version = version | buf[0];
+	}
+
+	dev_info(&interface->dev,
+			"version %x.%02x found at bus %03d address %03d\n",
+			version >> 8, version & 0xff,
+			vb->usb_dev->bus->busnum, vb->usb_dev->devnum);
+
+	/* setup i2c adapter description */
+	vb->i2c.owner = THIS_MODULE;
+	vb->i2c.class = I2C_CLASS_HWMON;
+	vb->i2c.algo = &vprbrd_algorithm;
+	vb->i2c.algo_data = vb;
+	snprintf(vb->i2c.name, sizeof(vb->i2c.name),
+			"viperboard at bus %03d device %03d",
+			vb->usb_dev->bus->busnum, vb->usb_dev->devnum);
+
+	/* setting the bus frequency */
+	if ((i2c_bus_freq <= VIPERBOARD_I2C_FREQ_10KHZ)
+			&& (i2c_bus_freq >= VIPERBOARD_I2C_FREQ_6MHZ)) {
+		pipe = usb_sndctrlpipe(vb->usb_dev, 0);
+		retval = usb_control_msg(vb->usb_dev, pipe, 0xe6, 0x40,
+				0x0000, 0x0000, &i2c_bus_freq, 1, 100);
+		if (retval != 1) {
+			dev_err(&vb->i2c.dev,
+					"failure setting i2c_bus_freq to %d\n",
+					i2c_bus_freq);
+			retval = -EIO;
+			goto error;
+		}
+	} else {
+		dev_err(&vb->i2c.dev,
+				"invalid i2c_bus_freq setting:%d\n",
+				i2c_bus_freq);
+		retval = -EIO;
+		goto error;
+	}
+
+	vb->i2c.dev.parent = &interface->dev;
+
+	/* and finally attach to i2c layer */
+	i2c_add_adapter(&vb->i2c);
+
+	/* registering gpio a */
+	vb->gpioa.label = "viperboard gpio a";
+	vb->gpioa.dev = &interface->dev;
+	vb->gpioa.owner = THIS_MODULE;
+	vb->gpioa.base = -1;
+	vb->gpioa.ngpio = 16;
+	vb->gpioa.can_sleep = 1;
+	vb->gpioa.set = vprbrd_gpioa_set;
+	vb->gpioa.get = vprbrd_gpioa_get;
+	vb->gpioa.direction_input = vprbrd_gpioa_direction_input;
+	vb->gpioa.direction_output = vprbrd_gpioa_direction_output;
+	retval = gpiochip_add(&vb->gpioa);
+	if (retval < 0) {
+		dev_err(vb->gpioa.dev, "could not add gpio a");
+		retval = -EIO;
+		goto err_gpioa;
+	}
+
+	/* registering gpio b */
+	vb->gpiob.label = "viperboard gpio b";
+	vb->gpiob.dev = &interface->dev;
+	vb->gpiob.owner = THIS_MODULE;
+	vb->gpiob.base = -1;
+	vb->gpiob.ngpio = 16;
+	vb->gpiob.can_sleep = 1;
+	vb->gpiob.set = vprbrd_gpiob_set;
+	vb->gpiob.get = vprbrd_gpiob_get;
+	vb->gpiob.direction_input = vprbrd_gpiob_direction_input;
+	vb->gpiob.direction_output = vprbrd_gpiob_direction_output;
+	retval = gpiochip_add(&vb->gpiob);
+	if (retval < 0) {
+		dev_err(vb->gpiob.dev, "could not add gpio b");
+		retval = -EIO;
+		goto err_gpiob;
+	}
+
+	/* registering iio */
+	iodev = iio_device_alloc(sizeof(struct vprbrd_adc_info));
+	if (!iodev) {
+		dev_err(&interface->dev, "failed allocating iio device\n");
+		retval = -ENOMEM;
+		goto err_gpioa;
+	}
+
+	adc = iio_priv(iodev);
+	adc->vb = vb;
+	iodev->name = "viperboard adc";
+	iodev->dev.parent = &interface->dev;
+	iodev->info = &vprbrd_adc_iio_info;
+	iodev->modes = INDIO_DIRECT_MODE;
+	iodev->channels = vprbrd_adc_iio_channels;
+	iodev->num_channels = ARRAY_SIZE(vprbrd_adc_iio_channels);
+
+	retval = iio_device_register(iodev);
+	if (retval) {
+		dev_err(&interface->dev, "could not register iio (adc)");
+		goto err_iio;
+	}
+	vb->iio = iodev;
+
+	return 0;
+err_iio:
+	iio_device_free(iodev);
+
+err_gpiob:
+	if (vb->gpiob.base >= 0)
+		pipe = gpiochip_remove(&vb->gpiob);
+
+err_gpioa:
+	if (vb->gpioa.base >= 0)
+		pipe = gpiochip_remove(&vb->gpioa);
+
+error:
+	if (vb)
+		vprbrd_free(vb);
+
+	return retval;
+}
+
+static void vprbrd_disconnect(struct usb_interface *interface)
+{
+	int retval;
+	struct vprbrd *vb = usb_get_intfdata(interface);
+
+	iio_device_unregister(vb->iio);
+	iio_device_free(vb->iio);
+	if (vb->gpiob.base >= 0)
+		retval = gpiochip_remove(&vb->gpiob);
+	if (vb->gpioa.base >= 0)
+		retval = gpiochip_remove(&vb->gpioa);
+	i2c_del_adapter(&vb->i2c);
+	usb_set_intfdata(interface, NULL);
+	vprbrd_free(vb);
+
+	dev_dbg(&interface->dev, "disconnected\n");
+}
+
+static struct usb_driver vprbrd_driver = {
+		.name		= "viperboard",
+		.probe		= vprbrd_probe,
+		.disconnect	= vprbrd_disconnect,
+		.id_table	= vprbrd_table,
+};
+
+module_usb_driver(vprbrd_driver);
+
+/* ----- end of usb layer ------------------------------------------------ */
+
+
+MODULE_DESCRIPTION("Nano River Technologies viperboard driver");
+MODULE_AUTHOR("Lars Poeschel <poeschel@lemonage.de>");
+MODULE_LICENSE("GPL");
-- 
1.7.10.4

