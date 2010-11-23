Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab0KWRpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 12:45:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43079 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab0KWRpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 12:45:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=tNP6AU2Y8iHKX7fXi0FsxF1lKAsE/WSbo5qjP5dozVO+N53yNd42lmk6OsdWTzSAQw
         jGlax3QVGTDl8/OKH/BQzQUiktGMS18gArNANV6vG6SrYqTI5KKMKJHRHLpQR0Wjszp3
         xAJ/HXA4wUZJaaOX4pLO7hn5YTuuXVdHjeHk8=
Date: Tue, 23 Nov 2010 20:45:12 +0300
From: Dan Carpenter <error27@gmail.com>
To: Fabien Marteau <fabien.marteau@armadeus.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: joystick:   Adding Austria Microsystem AS5011
 joystick driver
Message-ID: <20101123174512.GE8882@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Fabien Marteau <fabien.marteau@armadeus.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <4CEBED7E.7010101@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEBED7E.7010101@armadeus.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 05:36:14PM +0100, Fabien Marteau wrote:
> Driver for EasyPoint AS5011 2 axis joystick chip. This chip is plugged
> on an I2C bus. It as been tested on ARM processor (i.MX27).
> 
> Signed-off-by: Fabien Marteau <fabien.marteau@armadeus.com>
> ---
>  drivers/input/joystick/Kconfig  |    9 +
>  drivers/input/joystick/Makefile |    1 +
>  drivers/input/joystick/as5011.c |  454
> +++++++++++++++++++++++++++++++++++++++
>  include/linux/as5011.h          |   72 ++++++
>  4 files changed, 536 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/joystick/as5011.c
>  create mode 100644 include/linux/as5011.h
> 
> diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
> index 5b59616..5fad03e 100644
> --- a/drivers/input/joystick/Kconfig
> +++ b/drivers/input/joystick/Kconfig
> @@ -255,6 +255,15 @@ config JOYSTICK_AMIGA
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called amijoy.
> 
> +config JOYSTICK_AS5011
> +	tristate "Austria Microsystem AS5011 joystick"
> +	depends on I2C
> +	help
> +	  Say Y here if you have an AS5011 digital joystick.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called as5011.
> +
>  config JOYSTICK_JOYDUMP
>  	tristate "Gameport data dumper"
>  	select GAMEPORT
> diff --git a/drivers/input/joystick/Makefile
> b/drivers/input/joystick/Makefile
> index f3a8cbe..92dc0de 100644
> --- a/drivers/input/joystick/Makefile
> +++ b/drivers/input/joystick/Makefile
> @@ -7,6 +7,7 @@
>  obj-$(CONFIG_JOYSTICK_A3D)		+= a3d.o
>  obj-$(CONFIG_JOYSTICK_ADI)		+= adi.o
>  obj-$(CONFIG_JOYSTICK_AMIGA)		+= amijoy.o
> +obj-$(CONFIG_JOYSTICK_AS5011)		+= as5011.o
>  obj-$(CONFIG_JOYSTICK_ANALOG)		+= analog.o
>  obj-$(CONFIG_JOYSTICK_COBRA)		+= cobra.o
>  obj-$(CONFIG_JOYSTICK_DB9)		+= db9.o
> diff --git a/drivers/input/joystick/as5011.c
> b/drivers/input/joystick/as5011.c
> new file mode 100644
> index 0000000..db0f129
> --- /dev/null
> +++ b/drivers/input/joystick/as5011.c
> @@ -0,0 +1,454 @@
> +/*
> + * Copyright (c) 2010 Fabien Marteau <fabien.marteau@armadeus.com>
> + *
> + * Sponsored by ARMadeus Systems
> + */
> +
> +/*
> + * Driver for Austria Microsystems joysticks AS5011
> + */
> +
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *
> + * TODO:
> + *	- Manage power mode
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/string.h>
> +#include <linux/list.h>
> +#include <linux/sysfs.h>
> +#include <linux/ctype.h>
> +#include <linux/hwmon-sysfs.h>
> +
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/mutex.h>
> +
> +#include <linux/input.h>
> +#include <linux/gpio.h>
> +#include <linux/workqueue.h>
> +
> +#include <linux/as5011.h>
> +#define DRIVER_DESC "Driver for Austria Microsystems AS5011 joystick"
> +
> +MODULE_AUTHOR("Fabien Marteau <fabien.marteau@armadeus.com>");
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_LICENSE("GPL");
> +
> +#define SIZE_NAME 30
> +#define AS5011_MAX_AXIS	80
> +#define AS5011_MIN_AXIS	(-80)
> +#define AS5011_FUZZ	8
> +#define AS5011_FLAT	40
> +
> +static int g_num = 1; /* device counter */
> +
> +static signed char as5011_i2c_read(struct i2c_client *client,
> +			   uint8_t aRegAddr);
> +static int as5011_i2c_write(struct i2c_client *client,
> +			    uint8_t aRegAddr,
> +			    uint8_t aValue);
> +
> +/*
> + * interrupts operations
> + */
> +
> +static irqreturn_t button_interrupt(int irq, void *dev_id)
> +{
> +	struct as5011_platform_data *plat_dat =
> +		(struct as5011_platform_data *)dev_id;
> +	int ret;
> +
> +	ret = gpio_get_value(plat_dat->button_gpio);
> +	if (ret)
> +		input_report_key(plat_dat->input_dev, BTN_JOYSTICK, 0);
> +	else
> +		input_report_key(plat_dat->input_dev, BTN_JOYSTICK, 1);
> +	input_sync(plat_dat->input_dev);
> +	return IRQ_HANDLED;
> +}
> +
> +static void as5011_update_axes(struct work_struct *work)
> +{
> +	struct as5011_platform_data *plat_dat =
> +		container_of(work,
> +			     struct as5011_platform_data,
> +			     update_axes_work);
> +	signed char x, y;
> +
> +	x = as5011_i2c_read(plat_dat->i2c_client, AS5011_X_RES_INT);
> +	y = as5011_i2c_read(plat_dat->i2c_client, AS5011_Y_RES_INT);
> +	input_report_abs(plat_dat->input_dev, ABS_X, x);
> +	input_report_abs(plat_dat->input_dev, ABS_Y, y);
> +	input_sync(plat_dat->input_dev);
> +}
> +
> +static irqreturn_t as5011_int_interrupt(int irq, void *dev_id)
> +{
> +	struct as5011_platform_data *plat_dat =
> +		(struct as5011_platform_data *)dev_id;
> +
> +	queue_work(plat_dat->workqueue, &plat_dat->update_axes_work);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * I2C bus operation
> + */
> +
> +static int as5011_i2c_write(struct i2c_client *client,
> +			    uint8_t aRegAddr,
> +			    uint8_t aValue)
> +{
> +	int ret;
> +	uint8_t data[2] = { aRegAddr, aValue };
> +	struct i2c_msg msg = {	client->addr,
> +				I2C_M_IGNORE_NAK,
> +				2,
> +				(uint8_t *)data };
> +
> +	ret = i2c_transfer(client->adapter, &msg, 1);
> +	if (ret < 0)
> +		return -EINVAL;

	Return ret here.

> +	return 1;
> +}
> +
> +static signed char as5011_i2c_read(struct i2c_client *client,
> +			   uint8_t aRegAddr)
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
> +	data[0] = aRegAddr;
> +	msg_set[0] = msg1;
> +	msg_set[1] = msg2;
> +
> +	ret = i2c_transfer(client->adapter, msg_set, 2);
> +	if (ret < 0)
> +		return -EINVAL;

	Return ret here.

> +
> +	if (data[0] & 0x80)
> +		return -1*(1+(~data[0]));
> +	else
> +		return data[0];
> +}
> +
> +static int as5011_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct as5011_platform_data *plat_dat = client->dev.platform_data;
> +	int retval = 0;
> +
> +	plat_dat->num = g_num;
> +	g_num++;
> +
> +	retval = snprintf(plat_dat->workqueue_name,
> +			  SIZE_NAME,
> +			  "as5011_%d_workqueue", plat_dat->num);
> +	if (retval < 0) {

	The kernel version of snprintf() will never return less than zero.
	This is relied on and can't change.

> +		dev_err(&client->dev, "as5011: Failed to give workqueue name\n");
> +		retval = -1;

	-1 is -EPERM and that's the wrong error code.


> +		goto workqueue_name_error;
> +	}
> +	plat_dat->workqueue =
> +		create_singlethread_workqueue(plat_dat->workqueue_name);
> +	if (plat_dat->workqueue == NULL) {
> +		dev_err(&client->dev, "as5011: Failed to create workqueue\n");
                                       ^^^^^^

	You don't need that.  dev_err() adds it to the front of your
	printks automatically.

> +		retval = -EINVAL;
> +		goto workqueue_create_error;
> +	}
> +
> +	INIT_WORK(&plat_dat->update_axes_work, as5011_update_axes);
> +
> +	if (!i2c_check_functionality(client->adapter,
> +				     I2C_FUNC_PROTOCOL_MANGLING)) {
> +		dev_err(&client->dev,
> +		"i2c bus does not support protocol mangling, as5011 can't work\n");
> +		retval = -ENODEV;
> +		goto i2c_protocol_error;
> +	}
> +	plat_dat->i2c_client = client;
> +
> +	plat_dat->input_dev = input_allocate_device();
> +	if (plat_dat->input_dev < 0) {

	This should be testing for NULL instead of negative.

> +		dev_err(&client->dev,
> +		"not enough memory for input devices structure\n");
> +		retval = -ENOMEM;
> +		goto input_allocate_device_error;
> +	}
> +
> +	plat_dat->input_dev->name = "Austria Microsystem as5011 joystick";
> +	plat_dat->input_dev->uniq = "Austria0";
> +	plat_dat->input_dev->id.bustype = BUS_I2C;
> +	plat_dat->input_dev->phys = "/dev/input/event0";

	Don't hard code /dev/input/event0.

> +	plat_dat->input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +	plat_dat->input_dev->keybit[BIT_WORD(BTN_JOYSTICK)] =
> +					BIT_MASK(BTN_JOYSTICK);
> +
> +	input_set_abs_params(plat_dat->input_dev,
> +			     ABS_X,
> +			     AS5011_MIN_AXIS,
> +			     AS5011_MAX_AXIS,
> +			     AS5011_FUZZ,
> +			     AS5011_FLAT);
> +	input_set_abs_params(plat_dat->input_dev,
> +			     ABS_Y,
> +			     AS5011_MIN_AXIS,
> +			     AS5011_MAX_AXIS,
> +			     AS5011_FUZZ,
> +			     AS5011_FLAT);
> +
> +	plat_dat->button_irq_name =
> +		kmalloc(sizeof(unsigned char)*SIZE_NAME,

	char is always 1.  You can remove it.  Otherwise put spaces
	around the '*'.

> +					 GFP_KERNEL);
> +	if (plat_dat->button_irq_name == NULL) {
> +		dev_err(&client->dev,
> +		"not enough memory for input devices irq name\n");
> +		retval = -ENOMEM;
> +		goto input_allocate_device_name_error;
> +	}
> +
> +
> +	retval = snprintf(plat_dat->button_irq_name,
> +			  SIZE_NAME,
> +			  "as5011_%d_button",
> +			  plat_dat->num);
> +	if (retval < 0) {
> +		dev_err(&client->dev, "as5011: Failed to give button irq name\n");
> +		retval = -EINVAL;
> +		goto button_irq_name_error;
> +	}
> +
> +	if (request_irq(plat_dat->button_irq, button_interrupt,
> +			0, plat_dat->button_irq_name, (void *)plat_dat)) {
> +		dev_err(&client->dev, "as5011: Can't allocate irq %d\n",
> +			plat_dat->button_irq);
> +		retval = -EBUSY;
> +		goto request_irq_error;
> +	}
> +
> +	plat_dat->int_irq_name =
> +		kmalloc(sizeof(unsigned char)*SIZE_NAME,
> +					 GFP_KERNEL);
> +	if (plat_dat->int_irq_name == NULL) {
> +		dev_err(&client->dev,
> +		"not enough memory for input devices int irq name\n");
> +		retval = -ENOMEM;
> +		goto input_allocate_int_device_name_error;
> +	}
> +
> +	retval = snprintf(plat_dat->int_irq_name,
> +			  SIZE_NAME,
> +			  "as5011_%d_int",
> +			  plat_dat->num);
> +	if (retval < 0) {
> +		dev_err(&client->dev, "as5011: Failed to give int irq name\n");
> +		retval = -EINVAL;
> +		goto int_irq_name_error;
> +	}
> +
> +
	retval = request_irq();
	if (retval) {
		...

> +	if (request_irq(plat_dat->int_irq, as5011_int_interrupt,
> +			0, plat_dat->int_irq_name, (void *)plat_dat)) {
> +		dev_err(&client->dev, "as5011: Can't allocate int irq %d\n",
> +			plat_dat->int_irq);
> +		retval = -EBUSY;
> +		goto request_int_irq_error;
> +	}
> +
> +	retval = input_register_device(plat_dat->input_dev);
> +	if (retval) {
> +		dev_err(&client->dev, "as5011: Failed to register device\n");
> +		retval = -EINVAL;

	Retval is already set with the correct error code.

> +		goto input_register_device_error;
> +	}
> +
> +	retval = plat_dat->init_gpio();
> +	if (retval < 0) {
> +		dev_err(&client->dev, "as5011: Failed to init gpios\n");
> +		retval = -EINVAL;

	Again.

> +		goto init_gpio_error;
> +	}
> +
> +	/* chip soft reset */
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_CTRL1,
> +				  AS5011_CTRL1_SOFT_RST);
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"as5011: soft reset failed\n");
> +		retval = -EINVAL;

	Again.

> +		goto soft_reset_error;
> +	}
> +
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_CTRL1,
> +				  AS5011_CTRL1_LP_PULSED |
> +				  AS5011_CTRL1_LP_ACTIVE |
> +				  AS5011_CTRL1_INT_ACT_EN
> +				  );
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"as5011: power config failed\n");
> +		retval = -EINVAL;

	Etc.

> +		goto soft_reset_error;
> +	}
> +
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_CTRL2,
> +				  AS5011_CTRL2_INV_SPINNING);
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"as5011: can't invert spinning\n");
> +		retval = -EINVAL;
> +		goto invert_spinning_error;
> +	}
> +
> +	/* write threshold */
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_XP,
> +				  plat_dat->Xp);
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"as5011: can't write threshold\n");
> +		retval = -EINVAL;
> +		goto threshold_error;
> +	}
> +
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_XN,
> +				  plat_dat->Xn);
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"as5011: can't write threshold\n");
> +		retval = -EINVAL;
> +		goto threshold_error;
> +	}
> +
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_YP,
> +				  plat_dat->Yp);
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"as5011: can't write threshold\n");
> +		retval = -EINVAL;
> +		goto threshold_error;
> +	}
> +
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_YN,
> +				  plat_dat->Yn);
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"as5011: can't write threshold\n");
> +		retval = -EINVAL;
> +		goto threshold_error;
> +	}
> +
> +	/* to free irq gpio in chip*/
> +	as5011_i2c_read(plat_dat->i2c_client, AS5011_X_RES_INT);
> +
> +	queue_work(plat_dat->workqueue, &plat_dat->update_axes_work);
> +
> +	return 0;
> +
> +	/* Error management */

	It's better to name your labels according to what happens
	when you arrive.  So the first label would be err_exit_gpio
	and the last label would be err_out.

	You have too many labels here and they point to the same
	things.  The way people read code is from top to bottom
	so when they first hit a label and it's err_free_irq they
	already know what it does without scrolling down.

> +threshold_error:
> +invert_spinning_error:
> +soft_reset_error:
> +	plat_dat->exit_gpio();
> +init_gpio_error:
> +	input_unregister_device(plat_dat->input_dev);
> +input_register_device_error:
> +	free_irq(plat_dat->int_irq, as5011_int_interrupt);
> +request_int_irq_error:
> +int_irq_name_error:
> +	kfree(plat_dat->int_irq_name);
> +input_allocate_int_device_name_error:
> +	free_irq(plat_dat->button_irq, button_interrupt);
> +request_irq_error:
> +button_irq_name_error:
> +	kfree(plat_dat->button_irq_name);
> +input_allocate_device_name_error:
> +	input_free_device(plat_dat->input_dev);

	input_unregister_device() frees this so the call to input_free_device()
	is a double free.  This is documented in the comments for
	input_unregister_device().  Normally people make the register the last
	call in the probe function which can fail...

> +input_allocate_device_error:
> +i2c_protocol_error:
> +	destroy_workqueue(plat_dat->workqueue);
> +workqueue_create_error:
> +workqueue_name_error:
> +	return retval;
> +}
> +static int as5011_remove(struct i2c_client *client)
> +{
> +	struct as5011_platform_data *plat_dat = client->dev.platform_data;
> +
> +	destroy_workqueue(plat_dat->workqueue);
> +	input_unregister_device(plat_dat->input_dev);
> +	free_irq(plat_dat->button_irq, plat_dat);
> +	free_irq(plat_dat->int_irq, plat_dat);
> +	kfree(plat_dat->button_irq_name);
> +	input_free_device(plat_dat->input_dev);

	The input_free_device() is a double free.  Just remove it.

> +	plat_dat->exit_gpio();
> +
> +	return 0;
> +}
> +static const struct i2c_device_id as5011_id[] = {
> +	{ "as5011", 0 },
> +	{ }
> +};
> +
> +static struct i2c_driver as5011_driver = {
> +	.driver = {
> +		.name = "as5011",
> +	},
> +	.probe		= as5011_probe,
> +	.remove		= as5011_remove,
> +	.id_table	= as5011_id,
> +};
> +
> +/*
> + * Module initialization
> + */
> +
> +static int __init as5011_init(void)
> +{
> +	return i2c_add_driver(&as5011_driver);
> +}
> +
> +static void __exit as5011_exit(void)
> +{
> +	i2c_del_driver(&as5011_driver);
> +}
> +
> +module_init(as5011_init);
> +module_exit(as5011_exit);
> diff --git a/include/linux/as5011.h b/include/linux/as5011.h
> new file mode 100644
> index 0000000..7db0a75
> --- /dev/null
> +++ b/include/linux/as5011.h
> @@ -0,0 +1,72 @@
> +#ifndef _AS5011_H
> +#define _AS5011_H
> +
> +/*
> + * Copyright (c) 2010 Fabien Marteau
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as
> published by

Your email client wrapped the long line.  Read
Documentation/email-clients.txt

> + * the Free Software Foundation.
> + */
> +

regards,
dan carpenter
