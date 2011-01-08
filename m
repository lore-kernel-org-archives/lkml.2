Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab1AHJav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 04:30:51 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52601 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1AHJas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 04:30:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gP0Tqx9ReA9rgfqsdCY2ZHS5+X/Us2H2G5Bgjuo8wLW1F2Bh9rCXYpSG3iGvuR7WJq
         tayGwtEVBLK90RwBewm8WKfYEN3R2DJkP+4kY6EEv4uAihysLfow4efSVk6ZSge3sW1E
         oawK3WGzEz4Jqi2Wl0suoNm+CaM68Ijz//alM=
Date: Sat, 8 Jan 2011 01:30:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Fabien Marteau <fabien.marteau@armadeus.com>
Cc: Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: joystick:   Adding Austria Microsystem AS5011
 joystick driver (fourth version)
Message-ID: <20110108093040.GA8671@core.coreip.homeip.net>
References: <4D27735C.6000105@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D27735C.6000105@armadeus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabien,
On Fri, Jan 07, 2011 at 09:11:08PM +0100, Fabien Marteau wrote:
> Driver for EasyPoint AS5011 2 axis joystick chip. This chip is plugged  on an I2C bus.
> It has been tested on ARM processor (i.MX27).
> 
> 

Some more comments and a patch for you  to try...

> +
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/mutex.h>

Not needed anymore.

> +
> +struct as5011_device {
> +	int button_irq;
> +	struct input_dev *input_dev;
> +	struct i2c_client *i2c_client;
> +	char name[AS5011_MAX_NAME_LENGTH];

Name is not used.

> +
> +static int as5011_i2c_read(struct i2c_client *client,
> +			   uint8_t aregaddr, signed char *value)
> +{
> +	int ret;
> +	uint8_t data[2];
> +	struct i2c_msg msg_set[2];
> +	struct i2c_msg msg1 = {	client->addr,
> +				I2C_M_REV_DIR_ADDR,
> +				1,
> +				(uint8_t *)data};
> +	struct i2c_msg msg2 = {	client->addr,
> +				I2C_M_RD|I2C_M_NOSTART,
> +				1,
> +				(uint8_t *)data};
> +
> +	data[0] = aregaddr;
> +	msg_set[0] = msg1;
> +	msg_set[1] = msg2;
> +

You do not need both the array and individual variables.

> +	ret = i2c_transfer(client->adapter, msg_set, 2);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (data[0] & 0x80) {
> +		*value = -1*(1+(~data[0]));
> +		return 0;
> +	} else {
> +		*value = data[0];
> +		return 0;
> +	}
> +}
> +
> +static irqreturn_t button_interrupt(int irq, void *dev_id)
> +{
> +	 struct as5011_device *dev = dev_id;
> +	 struct as5011_platform_data *plat_dat =
> +				dev->i2c_client->dev.platform_data;

Looks like indented with spaces.

> +	int ret;
> +
> +	ret = gpio_get_value(plat_dat->button_gpio);

We should call gpio_get_value_cansleep() to avoid warnings if gpio
operations require sleep - we can sleep here since we are using threaded
interrupt.

> +	if (ret)
> +		input_report_key(dev->input_dev, BTN_JOYSTICK, 0);
> +	else
> +		input_report_key(dev->input_dev, BTN_JOYSTICK, 1);
> +	input_sync(dev->input_dev);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int as5011_update_axes(struct as5011_device *dev)
> +{
> +	int ret;
> +	signed char x, y;
> +
> +	ret = as5011_i2c_read(dev->i2c_client, AS5011_X_RES_INT, &x);
> +	if (ret < 0)
> +		return ret;
> +	ret = as5011_i2c_read(dev->i2c_client, AS5011_Y_RES_INT, &y);
> +	if (ret < 0)
> +		return ret;
> +	input_report_abs(dev->input_dev, ABS_X, x);
> +	input_report_abs(dev->input_dev, ABS_Y, y);
> +	input_sync(dev->input_dev);
> +	return 0;
> +}
> +
> +static irqreturn_t as5011_int_interrupt(int irq, void *dev_id)
> +{
> +	int ret;
> +	 struct as5011_device *dev = dev_id;
> +
> +	ret = as5011_update_axes(dev);
> +	if (ret < 0)
> +		return ret;

Negative result is not a valid irqreturn_t value, we should not try to
return it here.

> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit as5011_probe(struct i2c_client *client,
> +				const struct i2c_device_id *id)
> +{
> +	struct as5011_device *dev;
> +	struct as5011_platform_data *plat_dat = client->dev.platform_data;

Platform data should be const.

> +	int retval = 0;

Do not initialize error codes like this - it quite often masks problem
like forgetting to update to proper error code in error handling branch
and unintentionally returning success.

> +	signed char value;
> +
> +	if (plat_dat == NULL)
> +		return -EINVAL;
> +
> +	dev = kmalloc(sizeof(struct as5011_device), GFP_KERNEL);
> +	if (dev == NULL) {
> +		dev_err(&client->dev,
> +			"Can't allocate memory for device structure\n");
> +		goto err_out;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter,
> +				     I2C_FUNC_PROTOCOL_MANGLING)) {
> +		dev_err(&client->dev,
> +		"i2c bus does not support protocol mangling, as5011 can't work\n");
> +		retval = -ENODEV;
> +		goto err_free_device_structure;
> +	}
> +	dev->i2c_client = client;
> +
> +	dev->input_dev = input_allocate_device();
> +	if (dev->input_dev == NULL) {
> +		dev_err(&client->dev,
> +		"not enough memory for input devices structure\n");
> +		retval = -ENOMEM;
> +		goto err_free_device_structure;
> +	}
> +
> +	dev->input_dev->name = "Austria Microsystem as5011 joystick";
> +	dev->input_dev->id.bustype = BUS_I2C;

You also should be setting input_dev->dev.parent = &client->dev to
ensure that the input device gets placed in proper place in sysfs tree.

> +	__set_bit(EV_KEY, dev->input_dev->evbit);
> +	__set_bit(EV_ABS, dev->input_dev->evbit);
> +	__set_bit(BTN_JOYSTICK, dev->input_dev->keybit);
> +
> +	input_set_abs_params(dev->input_dev,
> +			     ABS_X,
> +			     AS5011_MIN_AXIS,
> +			     AS5011_MAX_AXIS,
> +			     AS5011_FUZZ,
> +			     AS5011_FLAT);
> +	input_set_abs_params(dev->input_dev,
> +			     ABS_Y,
> +			     AS5011_MIN_AXIS,
> +			     AS5011_MAX_AXIS,
> +			     AS5011_FUZZ,
> +			     AS5011_FLAT);
> +
> +	retval = gpio_request(plat_dat->button_gpio, "AS5011 button");
> +	if (retval < 0) {
> +		dev_err(&client->dev, "Failed to request button gpio\n");
> +		goto err_input_free_device;
> +	}
> +
> +
> +	dev->button_irq = gpio_to_irq(plat_dat->button_gpio);
> +	if (dev->button_irq < 0) {
> +		dev_err(&client->dev,
> +			"Failed to get irq number for button gpio\n");
> +		goto err_free_button_gpio;
> +	}
> +
> +	set_irq_type(dev->button_irq, IRQ_TYPE_EDGE_BOTH);
> +
> +	retval = request_threaded_irq(dev->button_irq,
> +					NULL, button_interrupt,
> +					0, "as5011_button",
> +					dev);

Normally you just supply IRQF_TRIGGER_XXX flags to request_irq instead
of calling set_irq_type().

> +
> +	retval = input_register_device(dev->input_dev);
> +	if (retval) {
> +		dev_err(&client->dev, "Failed to register device\n");
> +		goto err_free_irq_int;
> +	}
> +	i2c_set_clientdata(client, dev);
> +
> +	return 0;
> +
> +	/* Error management */
> +err_free_irq_int:
> +	set_irq_type(plat_dat->int_irq, IRQ_TYPE_NONE);

I do not believe you need to reset IRQ type here, free_irq() should
suffice.

> +	free_irq(plat_dat->int_irq, dev);
> +err_free_irq_button_interrupt:
> +	set_irq_type(dev->button_irq, IRQ_TYPE_NONE);
> +	free_irq(dev->button_irq, dev);
> +err_free_button_gpio:
> +	gpio_free(plat_dat->button_gpio);
> +err_input_free_device:
> +	input_unregister_device(dev->input_dev);

Unregistered devices should be freed with call to input_free_device()
instead of input_unregister_device().

> +err_free_device_structure:
> +	kfree(dev);
> +err_out:
> +	return retval;
> +}
> +static int as5011_remove(struct i2c_client *client)
> +{

__devexit

> +	struct as5011_device *dev;
> +	struct as5011_platform_data *plat_dat = client->dev.platform_data;
> +
> +	dev = i2c_get_clientdata(client);
> +
> +	set_irq_type(plat_dat->int_irq, IRQ_TYPE_NONE);
> +	free_irq(plat_dat->int_irq, dev);
> +	set_irq_type(dev->button_irq, IRQ_TYPE_NONE);
> +	free_irq(dev->button_irq, dev);
> +	gpio_free(plat_dat->button_gpio);
> +	input_unregister_device(dev->input_dev);
> +	kfree(dev);
> +	return 0;
> +}
> +static const struct i2c_device_id as5011_id[] = {
> +	{ MODULE_DEVICE_ALIAS, 0 },
> +	{ }
> +};

Also needs MODULE_DEVICE_TABLE(i2c, as5011_id);

> +
> +static struct i2c_driver as5011_driver = {
> +	.driver = {
> +		.name = "as5011",
> +	},
> +	.probe		= as5011_probe,
> +	.remove		= __devexit_p(as5011_remove),
> +	.id_table	= as5011_id,
> +};
> +
> +static int __init as5011_init(void)
> +{
> +	return i2c_add_driver(&as5011_driver);
> +}
> +module_init(as5011_init);
> +
> +static void __exit as5011_exit(void)
> +{
> +	i2c_del_driver(&as5011_driver);
> +}
> +module_exit(as5011_exit);
> +
> diff --git a/include/linux/input/as5011.h b/include/linux/input/as5011.h
> new file mode 100644
> index 0000000..250b7bf
> --- /dev/null
> +++ b/include/linux/input/as5011.h
> @@ -0,0 +1,24 @@
> +#ifndef _AS5011_H
> +#define _AS5011_H
> +
> +/*
> + * Copyright (c) 2010, 2011 Fabien Marteau <fabien.marteau@armadeus.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/mutex.h>

Not needed.

> +
> +#define AS5011_MAX_NAME_LENGTH	64

Not needed.

> +
> +struct as5011_platform_data {
> +	int button_gpio;
> +	int int_irq; /* irq number */
> +	int int_edge;/* irq edge IRQ_TYPE_EDGE_[FALLING,RISING,BOTH] */
> +	char xp, xn; /* threshold for x axis */
> +	char yp, yn; /* threshold for y axis */
> +};
> +
> +#endif /* _AS5011_H */
> -- 
> 1.7.0.4
> 

Does the patch below work for you or did I break it horribly?

Thanks,

-- 
Dmitry


Input: add Austria Microsystem AS5011 joystick driver

From: Fabien Marteau <fabien.marteau@armadeus.com>

This is driver for EasyPoint AS5011 2 axis joystick chip. This chip is
plugged on an I2C bus.

Tested on ARM processor (i.MX27).

Signed-off-by: Fabien Marteau <fabien.marteau@armadeus.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/joystick/Kconfig  |   10 +
 drivers/input/joystick/Makefile |    1 
 drivers/input/joystick/as5011.c |  367 +++++++++++++++++++++++++++++++++++++++
 include/linux/input/as5011.h    |   20 ++
 4 files changed, 398 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/joystick/as5011.c
 create mode 100644 include/linux/input/as5011.h


diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 5b59616..56eb471 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -255,6 +255,16 @@ config JOYSTICK_AMIGA
 	  To compile this driver as a module, choose M here: the
 	  module will be called amijoy.
 
+config JOYSTICK_AS5011
+	tristate "Austria Microsystem AS5011 joystick"
+	depends on I2C
+	help
+	  Say Y here if you have an AS5011 digital joystick connected to your
+	  system.
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
index 0000000..5037932
--- /dev/null
+++ b/drivers/input/joystick/as5011.c
@@ -0,0 +1,367 @@
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
+#include <linux/input.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/input/as5011.h>
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
+	struct input_dev *input_dev;
+	struct i2c_client *i2c_client;
+	unsigned int button_gpio;
+	unsigned int button_irq;
+	unsigned int axis_irq;
+};
+
+static int as5011_i2c_write(struct i2c_client *client,
+			    uint8_t aregaddr,
+			    uint8_t avalue)
+{
+	uint8_t data[2] = { aregaddr, avalue };
+	struct i2c_msg msg = {
+		client->addr, I2C_M_IGNORE_NAK, 2, (uint8_t *)data
+	};
+	int error;
+
+	error = i2c_transfer(client->adapter, &msg, 1);
+	return error < 0 ? error : 0;
+}
+
+static int as5011_i2c_read(struct i2c_client *client,
+			   uint8_t aregaddr, signed char *value)
+{
+	uint8_t data[2] = { aregaddr };
+	struct i2c_msg msg_set[2] = {
+		{ client->addr, I2C_M_REV_DIR_ADDR, 1, (uint8_t *)data },
+		{ client->addr, I2C_M_RD | I2C_M_NOSTART, 1, (uint8_t *)data }
+	};
+	int error;
+
+	error = i2c_transfer(client->adapter, msg_set, 2);
+	if (error < 0)
+		return error;
+
+	*value = data[0] & 0x80 ? -1 * (1 + ~data[0]) : data[0];
+	return 0;
+}
+
+static irqreturn_t as5011_button_interrupt(int irq, void *dev_id)
+{
+	struct as5011_device *as5011 = dev_id;
+	int val = gpio_get_value_cansleep(as5011->button_gpio);
+
+	input_report_key(as5011->input_dev, BTN_JOYSTICK, !val);
+	input_sync(as5011->input_dev);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t as5011_axis_interrupt(int irq, void *dev_id)
+{
+	struct as5011_device *as5011 = dev_id;
+	int error;
+	signed char x, y;
+
+	error = as5011_i2c_read(as5011->i2c_client, AS5011_X_RES_INT, &x);
+	if (error < 0)
+		goto out;
+
+	error = as5011_i2c_read(as5011->i2c_client, AS5011_Y_RES_INT, &y);
+	if (error < 0)
+		goto out;
+
+	input_report_abs(as5011->input_dev, ABS_X, x);
+	input_report_abs(as5011->input_dev, ABS_Y, y);
+	input_sync(as5011->input_dev);
+
+out:
+	return IRQ_HANDLED;
+}
+
+static int __devinit as5011_configure_chip(struct as5011_device *as5011,
+				const struct as5011_platform_data *plat_dat)
+{
+	struct i2c_client *client = as5011->i2c_client;
+	int error;
+	signed char value;
+
+	/* chip soft reset */
+	error = as5011_i2c_write(client, AS5011_CTRL1,
+				 AS5011_CTRL1_SOFT_RST);
+	if (error < 0) {
+		dev_err(&client->dev, "Soft reset failed\n");
+		return error;
+	}
+
+	mdelay(10);
+
+	error = as5011_i2c_write(client, AS5011_CTRL1,
+				 AS5011_CTRL1_LP_PULSED |
+				 AS5011_CTRL1_LP_ACTIVE |
+				 AS5011_CTRL1_INT_ACT_EN);
+	if (error < 0) {
+		dev_err(&client->dev, "Power config failed\n");
+		return error;
+	}
+
+	error = as5011_i2c_write(client, AS5011_CTRL2,
+				 AS5011_CTRL2_INV_SPINNING);
+	if (error < 0) {
+		dev_err(&client->dev, "Can't invert spinning\n");
+		return error;
+	}
+
+	/* write threshold */
+	error = as5011_i2c_write(client, AS5011_XP, plat_dat->xp);
+	if (error < 0) {
+		dev_err(&client->dev, "Can't write threshold\n");
+		return error;
+	}
+
+	error = as5011_i2c_write(client, AS5011_XN, plat_dat->xn);
+	if (error < 0) {
+		dev_err(&client->dev, "Can't write threshold\n");
+		return error;
+	}
+
+	error = as5011_i2c_write(client, AS5011_YP, plat_dat->yp);
+	if (error < 0) {
+		dev_err(&client->dev, "Can't write threshold\n");
+		return error;
+	}
+
+	error = as5011_i2c_write(client, AS5011_YN, plat_dat->yn);
+	if (error < 0) {
+		dev_err(&client->dev, "Can't write threshold\n");
+		return error;
+	}
+
+	/* to free irq gpio in chip */
+	error = as5011_i2c_read(client, AS5011_X_RES_INT, &value);
+	if (error < 0) {
+		dev_err(&client->dev, "Can't read i2c X resolution value\n");
+		return error;
+	}
+
+	return 0;
+}
+
+static int __devinit as5011_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	const struct as5011_platform_data *plat_data;
+	struct as5011_device *as5011;
+	struct input_dev *input_dev;
+	int irq;
+	int error;
+
+	plat_data = client->dev.platform_data;
+	if (!plat_data)
+		return -EINVAL;
+
+	if (!plat_data->axis_irq) {
+		dev_err(&client->dev, "No axis IRQ?\n");
+		return -EINVAL;
+	}
+
+	if (!i2c_check_functionality(client->adapter,
+				     I2C_FUNC_PROTOCOL_MANGLING)) {
+		dev_err(&client->dev,
+			"need i2c bus that supports protocol mangling\n");
+		return -ENODEV;
+	}
+
+	as5011 = kmalloc(sizeof(struct as5011_device), GFP_KERNEL);
+	input_dev = input_allocate_device();
+	if (!as5011 || !input_dev) {
+		dev_err(&client->dev,
+			"Can't allocate memory for device structure\n");
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	as5011->i2c_client = client;
+	as5011->input_dev = input_dev;
+	as5011->button_gpio = plat_data->button_gpio;
+	as5011->axis_irq = plat_data->axis_irq;
+
+	input_dev->name = "Austria Microsystem as5011 joystick";
+	input_dev->id.bustype = BUS_I2C;
+	input_dev->dev.parent = &client->dev;
+
+	__set_bit(EV_KEY, input_dev->evbit);
+	__set_bit(EV_ABS, input_dev->evbit);
+	__set_bit(BTN_JOYSTICK, input_dev->keybit);
+
+	input_set_abs_params(input_dev, ABS_X,
+		AS5011_MIN_AXIS, AS5011_MAX_AXIS, AS5011_FUZZ, AS5011_FLAT);
+	input_set_abs_params(as5011->input_dev, ABS_Y,
+		AS5011_MIN_AXIS, AS5011_MAX_AXIS, AS5011_FUZZ, AS5011_FLAT);
+
+	error = gpio_request(as5011->button_gpio, "AS5011 button");
+	if (error < 0) {
+		dev_err(&client->dev, "Failed to request button gpio\n");
+		goto err_free_mem;
+	}
+
+	irq = gpio_to_irq(as5011->button_gpio);
+	if (irq < 0) {
+		dev_err(&client->dev,
+			"Failed to get irq number for button gpio\n");
+		goto err_free_button_gpio;
+	}
+
+	as5011->button_irq = irq;
+
+	error = request_threaded_irq(as5011->button_irq,
+				     NULL, as5011_button_interrupt,
+				     IRQF_TRIGGER_RISING | IRQF_TRIGGER_RISING,
+				     "as5011_button", as5011);
+	if (error < 0) {
+		dev_err(&client->dev,
+			"Can't allocate button irq %d\n", as5011->button_irq);
+		goto err_free_button_gpio;
+	}
+
+	error = as5011_configure_chip(as5011, plat_data);
+	if (error)
+		goto err_free_button_irq;
+
+	error = request_threaded_irq(as5011->axis_irq, NULL,
+				     as5011_axis_interrupt,
+				     plat_data->axis_irqflags,
+				     "as5011_joystick", as5011);
+	if (error) {
+		dev_err(&client->dev,
+			"Can't allocate axis irq %d\n", plat_data->axis_irq);
+		goto err_free_button_irq;
+	}
+
+	error = input_register_device(as5011->input_dev);
+	if (error) {
+		dev_err(&client->dev, "Failed to register input device\n");
+		goto err_free_axis_irq;
+	}
+
+	i2c_set_clientdata(client, as5011);
+
+	return 0;
+
+err_free_axis_irq:
+	free_irq(as5011->axis_irq, as5011);
+err_free_button_irq:
+	free_irq(as5011->button_irq, as5011);
+err_free_button_gpio:
+	gpio_free(as5011->button_gpio);
+err_free_mem:
+	input_free_device(input_dev);
+	kfree(as5011);
+
+	return error;
+}
+
+static int __devexit as5011_remove(struct i2c_client *client)
+{
+	struct as5011_device *as5011 = i2c_get_clientdata(client);
+
+	free_irq(as5011->axis_irq, as5011);
+	free_irq(as5011->button_irq, as5011);
+	gpio_free(as5011->button_gpio);
+
+	input_unregister_device(as5011->input_dev);
+	kfree(as5011);
+
+	return 0;
+}
+
+static const struct i2c_device_id as5011_id[] = {
+	{ MODULE_DEVICE_ALIAS, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, as5011_id);
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
diff --git a/include/linux/input/as5011.h b/include/linux/input/as5011.h
new file mode 100644
index 0000000..1affd0d
--- /dev/null
+++ b/include/linux/input/as5011.h
@@ -0,0 +1,20 @@
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
+struct as5011_platform_data {
+	unsigned int button_gpio;
+	unsigned int axis_irq; /* irq number */
+	unsigned long axis_irqflags;
+	char xp, xn; /* threshold for x axis */
+	char yp, yn; /* threshold for y axis */
+};
+
+#endif /* _AS5011_H */
