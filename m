Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab1AGUL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:11:26 -0500
Received: from 27.mail-out.ovh.net ([91.121.30.210]:48775 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752552Ab1AGULY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:11:24 -0500
Message-ID: <4D27735C.6000105@armadeus.com>
Date: Fri, 07 Jan 2011 21:11:08 +0100
From: Fabien Marteau <fabien.marteau@armadeus.com>
Reply-To: fabien.marteau@armadeus.com
Organization: ARMadeus Systems
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Scott Moreau <oreaus@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] input: joystick:   Adding Austria Microsystem AS5011 joystick
 driver (fourth version)
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8313926388454678939
X-Ovh-Remote: 82.232.255.99 (arc68-6-82-232-255-99.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for EasyPoint AS5011 2 axis joystick chip. This chip is plugged  on an I2C bus.
It has been tested on ARM processor (i.MX27).


Signed-off-by: Fabien Marteau <fabien.marteau@armadeus.com>
---
 drivers/input/joystick/Kconfig  |    9 +
 drivers/input/joystick/Makefile |    1 +
 drivers/input/joystick/as5011.c |  414 +++++++++++++++++++++++++++++++++++++++
 include/linux/input/as5011.h    |   24 +++
 4 files changed, 448 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/joystick/as5011.c
 create mode 100644 include/linux/input/as5011.h

diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 5b59616..5fad03e 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -255,6 +255,15 @@ config JOYSTICK_AMIGA
 	  To compile this driver as a module, choose M here: the
 	  module will be called amijoy.

+config JOYSTICK_AS5011
+	tristate "Austria Microsystem AS5011 joystick"
+	depends on I2C
+	help
+	  Say Y here if you have an AS5011 digital joystick.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called as5011.
+
 config JOYSTICK_JOYDUMP
 	tristate "Gameport data dumper"
 	select GAMEPORT
diff --git a/drivers/input/joystick/Makefile b/drivers/input/joystick/Makefile
index f3a8cbe..92dc0de 100644
--- a/drivers/input/joystick/Makefile
+++ b/drivers/input/joystick/Makefile
@@ -7,6 +7,7 @@
 obj-$(CONFIG_JOYSTICK_A3D)		+= a3d.o
 obj-$(CONFIG_JOYSTICK_ADI)		+= adi.o
 obj-$(CONFIG_JOYSTICK_AMIGA)		+= amijoy.o
+obj-$(CONFIG_JOYSTICK_AS5011)		+= as5011.o
 obj-$(CONFIG_JOYSTICK_ANALOG)		+= analog.o
 obj-$(CONFIG_JOYSTICK_COBRA)		+= cobra.o
 obj-$(CONFIG_JOYSTICK_DB9)		+= db9.o
diff --git a/drivers/input/joystick/as5011.c b/drivers/input/joystick/as5011.c
new file mode 100644
index 0000000..d42e74b
--- /dev/null
+++ b/drivers/input/joystick/as5011.c
@@ -0,0 +1,414 @@
+/*
+ * Copyright (c) 2010, 2011 Fabien Marteau <fabien.marteau@armadeus.com>
+ * Sponsored by ARMadeus Systems
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Driver for Austria Microsystems joysticks AS5011
+ *
+ * TODO:
+ *	- Power on the chip when open() and power down when close()
+ *	- Manage power mode
+ */
+
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/mutex.h>
+#include <linux/input.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/input/as5011.h>
+#include <linux/irq.h>
+#include <linux/slab.h>
+
+#define DRIVER_DESC "Driver for Austria Microsystems AS5011 joystick"
+#define MODULE_DEVICE_ALIAS "as5011"
+
+MODULE_AUTHOR("Fabien Marteau <fabien.marteau@armadeus.com>");
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
+
+/* registers */
+#define AS5011_CTRL1		0x76
+#define AS5011_CTRL2		0x75
+#define AS5011_XP		0x43
+#define AS5011_XN		0x44
+#define AS5011_YP		0x53
+#define AS5011_YN		0x54
+#define AS5011_X_REG		0x41
+#define AS5011_Y_REG		0x42
+#define AS5011_X_RES_INT	0x51
+#define AS5011_Y_RES_INT	0x52
+
+/* CTRL1 bits */
+#define AS5011_CTRL1_LP_PULSED		0x80
+#define AS5011_CTRL1_LP_ACTIVE		0x40
+#define AS5011_CTRL1_LP_CONTINUE	0x20
+#define AS5011_CTRL1_INT_WUP_EN		0x10
+#define AS5011_CTRL1_INT_ACT_EN		0x08
+#define AS5011_CTRL1_EXT_CLK_EN		0x04
+#define AS5011_CTRL1_SOFT_RST		0x02
+#define AS5011_CTRL1_DATA_VALID		0x01
+
+/* CTRL2 bits */
+#define AS5011_CTRL2_EXT_SAMPLE_EN	0x08
+#define AS5011_CTRL2_RC_BIAS_ON		0x04
+#define AS5011_CTRL2_INV_SPINNING	0x02
+
+#define AS5011_MAX_AXIS	80
+#define AS5011_MIN_AXIS	(-80)
+#define AS5011_FUZZ	8
+#define AS5011_FLAT	40
+
+struct as5011_device {
+	int button_irq;
+	struct input_dev *input_dev;
+	struct i2c_client *i2c_client;
+	char name[AS5011_MAX_NAME_LENGTH];
+};
+
+static int as5011_i2c_write(struct i2c_client *client,
+			    uint8_t aregaddr,
+			    uint8_t avalue)
+{
+	int ret;
+	uint8_t data[2] = { aregaddr, avalue };
+	struct i2c_msg msg = {	client->addr,
+				I2C_M_IGNORE_NAK,
+				2,
+				(uint8_t *)data };
+
+	ret = i2c_transfer(client->adapter, &msg, 1);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int as5011_i2c_read(struct i2c_client *client,
+			   uint8_t aregaddr, signed char *value)
+{
+	int ret;
+	uint8_t data[2];
+	struct i2c_msg msg_set[2];
+	struct i2c_msg msg1 = {	client->addr,
+				I2C_M_REV_DIR_ADDR,
+				1,
+				(uint8_t *)data};
+	struct i2c_msg msg2 = {	client->addr,
+				I2C_M_RD|I2C_M_NOSTART,
+				1,
+				(uint8_t *)data};
+
+	data[0] = aregaddr;
+	msg_set[0] = msg1;
+	msg_set[1] = msg2;
+
+	ret = i2c_transfer(client->adapter, msg_set, 2);
+	if (ret < 0)
+		return ret;
+
+	if (data[0] & 0x80) {
+		*value = -1*(1+(~data[0]));
+		return 0;
+	} else {
+		*value = data[0];
+		return 0;
+	}
+}
+
+static irqreturn_t button_interrupt(int irq, void *dev_id)
+{
+	 struct as5011_device *dev = dev_id;
+	 struct as5011_platform_data *plat_dat =
+				dev->i2c_client->dev.platform_data;
+	int ret;
+
+	ret = gpio_get_value(plat_dat->button_gpio);
+	if (ret)
+		input_report_key(dev->input_dev, BTN_JOYSTICK, 0);
+	else
+		input_report_key(dev->input_dev, BTN_JOYSTICK, 1);
+	input_sync(dev->input_dev);
+
+	return IRQ_HANDLED;
+}
+
+static int as5011_update_axes(struct as5011_device *dev)
+{
+	int ret;
+	signed char x, y;
+
+	ret = as5011_i2c_read(dev->i2c_client, AS5011_X_RES_INT, &x);
+	if (ret < 0)
+		return ret;
+	ret = as5011_i2c_read(dev->i2c_client, AS5011_Y_RES_INT, &y);
+	if (ret < 0)
+		return ret;
+	input_report_abs(dev->input_dev, ABS_X, x);
+	input_report_abs(dev->input_dev, ABS_Y, y);
+	input_sync(dev->input_dev);
+	return 0;
+}
+
+static irqreturn_t as5011_int_interrupt(int irq, void *dev_id)
+{
+	int ret;
+	 struct as5011_device *dev = dev_id;
+
+	ret = as5011_update_axes(dev);
+	if (ret < 0)
+		return ret;
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit as5011_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct as5011_device *dev;
+	struct as5011_platform_data *plat_dat = client->dev.platform_data;
+	int retval = 0;
+	signed char value;
+
+	if (plat_dat == NULL)
+		return -EINVAL;
+
+	dev = kmalloc(sizeof(struct as5011_device), GFP_KERNEL);
+	if (dev == NULL) {
+		dev_err(&client->dev,
+			"Can't allocate memory for device structure\n");
+		goto err_out;
+	}
+
+	if (!i2c_check_functionality(client->adapter,
+				     I2C_FUNC_PROTOCOL_MANGLING)) {
+		dev_err(&client->dev,
+		"i2c bus does not support protocol mangling, as5011 can't work\n");
+		retval = -ENODEV;
+		goto err_free_device_structure;
+	}
+	dev->i2c_client = client;
+
+	dev->input_dev = input_allocate_device();
+	if (dev->input_dev == NULL) {
+		dev_err(&client->dev,
+		"not enough memory for input devices structure\n");
+		retval = -ENOMEM;
+		goto err_free_device_structure;
+	}
+
+	dev->input_dev->name = "Austria Microsystem as5011 joystick";
+	dev->input_dev->id.bustype = BUS_I2C;
+	__set_bit(EV_KEY, dev->input_dev->evbit);
+	__set_bit(EV_ABS, dev->input_dev->evbit);
+	__set_bit(BTN_JOYSTICK, dev->input_dev->keybit);
+
+	input_set_abs_params(dev->input_dev,
+			     ABS_X,
+			     AS5011_MIN_AXIS,
+			     AS5011_MAX_AXIS,
+			     AS5011_FUZZ,
+			     AS5011_FLAT);
+	input_set_abs_params(dev->input_dev,
+			     ABS_Y,
+			     AS5011_MIN_AXIS,
+			     AS5011_MAX_AXIS,
+			     AS5011_FUZZ,
+			     AS5011_FLAT);
+
+	retval = gpio_request(plat_dat->button_gpio, "AS5011 button");
+	if (retval < 0) {
+		dev_err(&client->dev, "Failed to request button gpio\n");
+		goto err_input_free_device;
+	}
+
+
+	dev->button_irq = gpio_to_irq(plat_dat->button_gpio);
+	if (dev->button_irq < 0) {
+		dev_err(&client->dev,
+			"Failed to get irq number for button gpio\n");
+		goto err_free_button_gpio;
+	}
+
+	set_irq_type(dev->button_irq, IRQ_TYPE_EDGE_BOTH);
+
+	retval = request_threaded_irq(dev->button_irq,
+					NULL, button_interrupt,
+					0, "as5011_button",
+					dev);
+	if (retval < 0) {
+		dev_err(&client->dev, "Can't allocate irq %d\n",
+			dev->button_irq);
+		goto err_free_button_gpio;
+	}
+
+	/* chip soft reset */
+	retval = as5011_i2c_write(dev->i2c_client,
+				  AS5011_CTRL1,
+				  AS5011_CTRL1_SOFT_RST);
+	if (retval < 0) {
+		dev_err(&dev->i2c_client->dev,
+			"Soft reset failed\n");
+		goto err_free_irq_button_interrupt;
+	}
+
+	mdelay(10);
+
+	retval = as5011_i2c_write(dev->i2c_client,
+				  AS5011_CTRL1,
+				  AS5011_CTRL1_LP_PULSED |
+				  AS5011_CTRL1_LP_ACTIVE |
+				  AS5011_CTRL1_INT_ACT_EN
+				  );
+	if (retval < 0) {
+		dev_err(&dev->i2c_client->dev,
+			"Power config failed\n");
+		goto err_free_irq_button_interrupt;
+	}
+
+	retval = as5011_i2c_write(dev->i2c_client,
+				  AS5011_CTRL2,
+				  AS5011_CTRL2_INV_SPINNING);
+	if (retval < 0) {
+		dev_err(&dev->i2c_client->dev,
+			"Can't invert spinning\n");
+		goto err_free_irq_button_interrupt;
+	}
+
+	/* write threshold */
+	retval = as5011_i2c_write(dev->i2c_client,
+				  AS5011_XP,
+				  plat_dat->xp);
+	if (retval < 0) {
+		dev_err(&dev->i2c_client->dev,
+			"Can't write threshold\n");
+		goto err_free_irq_button_interrupt;
+	}
+
+	retval = as5011_i2c_write(dev->i2c_client,
+				  AS5011_XN,
+				  plat_dat->xn);
+	if (retval < 0) {
+		dev_err(&dev->i2c_client->dev,
+			"Can't write threshold\n");
+		goto err_free_irq_button_interrupt;
+	}
+
+	retval = as5011_i2c_write(dev->i2c_client,
+				  AS5011_YP,
+				  plat_dat->yp);
+	if (retval < 0) {
+		dev_err(&dev->i2c_client->dev,
+			"Can't write threshold\n");
+		goto err_free_irq_button_interrupt;
+	}
+
+	retval = as5011_i2c_write(dev->i2c_client,
+				  AS5011_YN,
+				  plat_dat->yn);
+	if (retval < 0) {
+		dev_err(&dev->i2c_client->dev,
+			"Can't write threshold\n");
+		goto err_free_irq_button_interrupt;
+	}
+
+	/* request irq */
+
+	/* to free irq gpio in chip*/
+	retval = as5011_i2c_read(dev->i2c_client, AS5011_X_RES_INT, &value);
+	if (retval < 0) {
+		dev_err(&dev->i2c_client->dev,
+			"Can't read i2c X resolution value\n");
+		goto err_free_irq_button_interrupt;
+	}
+
+	set_irq_type(plat_dat->int_irq, plat_dat->int_edge);
+
+	if (request_threaded_irq(plat_dat->int_irq, NULL,
+				as5011_int_interrupt,
+				0, "as5011_joystick", dev)) {
+		dev_err(&client->dev, "Can't allocate int irq %d\n",
+			plat_dat->int_irq);
+		goto err_free_irq_button_interrupt;
+	}
+
+	retval = input_register_device(dev->input_dev);
+	if (retval) {
+		dev_err(&client->dev, "Failed to register device\n");
+		goto err_free_irq_int;
+	}
+	i2c_set_clientdata(client, dev);
+
+	return 0;
+
+	/* Error management */
+err_free_irq_int:
+	set_irq_type(plat_dat->int_irq, IRQ_TYPE_NONE);
+	free_irq(plat_dat->int_irq, dev);
+err_free_irq_button_interrupt:
+	set_irq_type(dev->button_irq, IRQ_TYPE_NONE);
+	free_irq(dev->button_irq, dev);
+err_free_button_gpio:
+	gpio_free(plat_dat->button_gpio);
+err_input_free_device:
+	input_unregister_device(dev->input_dev);
+err_free_device_structure:
+	kfree(dev);
+err_out:
+	return retval;
+}
+static int as5011_remove(struct i2c_client *client)
+{
+	struct as5011_device *dev;
+	struct as5011_platform_data *plat_dat = client->dev.platform_data;
+
+	dev = i2c_get_clientdata(client);
+
+	set_irq_type(plat_dat->int_irq, IRQ_TYPE_NONE);
+	free_irq(plat_dat->int_irq, dev);
+	set_irq_type(dev->button_irq, IRQ_TYPE_NONE);
+	free_irq(dev->button_irq, dev);
+	gpio_free(plat_dat->button_gpio);
+	input_unregister_device(dev->input_dev);
+	kfree(dev);
+	return 0;
+}
+static const struct i2c_device_id as5011_id[] = {
+	{ MODULE_DEVICE_ALIAS, 0 },
+	{ }
+};
+
+static struct i2c_driver as5011_driver = {
+	.driver = {
+		.name = "as5011",
+	},
+	.probe		= as5011_probe,
+	.remove		= __devexit_p(as5011_remove),
+	.id_table	= as5011_id,
+};
+
+static int __init as5011_init(void)
+{
+	return i2c_add_driver(&as5011_driver);
+}
+module_init(as5011_init);
+
+static void __exit as5011_exit(void)
+{
+	i2c_del_driver(&as5011_driver);
+}
+module_exit(as5011_exit);
+
diff --git a/include/linux/input/as5011.h b/include/linux/input/as5011.h
new file mode 100644
index 0000000..250b7bf
--- /dev/null
+++ b/include/linux/input/as5011.h
@@ -0,0 +1,24 @@
+#ifndef _AS5011_H
+#define _AS5011_H
+
+/*
+ * Copyright (c) 2010, 2011 Fabien Marteau <fabien.marteau@armadeus.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/mutex.h>
+
+#define AS5011_MAX_NAME_LENGTH	64
+
+struct as5011_platform_data {
+	int button_gpio;
+	int int_irq; /* irq number */
+	int int_edge;/* irq edge IRQ_TYPE_EDGE_[FALLING,RISING,BOTH] */
+	char xp, xn; /* threshold for x axis */
+	char yp, yn; /* threshold for y axis */
+};
+
+#endif /* _AS5011_H */
-- 
1.7.0.4

