Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab1EFNhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:37:47 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:39533 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab1EFNhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:37:45 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DC3FA3B.5050201@cam.ac.uk>
Date: Fri, 06 May 2011 14:40:11 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonathan McDowell <noodles@earth.li>
CC: Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add support for VSC055 Enhanced Two-Wire Serial Backplane
 controller
References: <20110505041205.GY4835@earth.li> <4DC267E3.6080206@cam.ac.uk> <20110505220018.GF28362@earth.li>
In-Reply-To: <20110505220018.GF28362@earth.li>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/11 23:00, Jonathan McDowell wrote:
> On Thu, May 05, 2011 at 10:03:31AM +0100, Jonathan Cameron wrote:
>> Sorry Jonathan and Grant. I accidentally sent this only to you and
>> not to lkml, hence the resend.
> 
> That's my fault; I sent the initial revision to Grant and missed the
> lkml CC, then just bounced it to lkml.
> 
>> Couple of suggestions for minor tidying up inline.
> 
> Thanks. Things I've taken on board and updated:
> 
>  * Use u8, not uint8_t for 8 bit types.
>  * Remove read_reg/write_reg wrappers and use i2c_smbus functions
>    directly.
>  * Fold container_of usage into struct vsc055_chip variable definition.
>  * Use !! instead of ? 1 : 0.
>  * Rename i2c_lock to reg_lock.
>  * Move comment about cached status to correct location.
> 
> Things I left:
> 
>  * pin/block - when they're used multiple times I think this is clearer
>    and reflects how the data sheet talks about the GPIO lines.
>  * Display version number - I think this is useful to indicate the
>    device has been correctly found (I'd prefer it if there was a
>    certain way to ID I2C devices).
Fair enough to both of those.
> 
> -----
> 
> Add support for the GPIOs on Maxim VSC055 I2C Enhanced Two-Wire Serial
> Backplane controller.
> 
> This chip features 64 bits of user-definable, bidirectional GPIOs. It also
> has the ability to do PWM fan control output and LED flashing, but support
> for that functionality is not included at present.
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index cc150db..4c5de65 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -255,6 +255,13 @@ config GPIO_TWL4030
>  	  Say yes here to access the GPIO signals of various multi-function
>  	  power management chips from Texas Instruments.
>  
> +config GPIO_VSC055
> +	tristate "VSC055 GPIOs"
> +	depends on I2C
> +	help
> +	  Say yes here to access the GPIOs found on the Maxim VSC055 Enhanced
> +	  Two-Wire Serial Backplane controller.
> +
>  config GPIO_WM831X
>  	tristate "WM831x GPIOs"
>  	depends on MFD_WM831X
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index d2752b2..f82491d 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -42,4 +42,5 @@ obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
>  obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
>  obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
>  obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
> +obj-$(CONFIG_GPIO_VSC055)	+= vsc055.o
>  obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
> diff --git a/drivers/gpio/vsc055.c b/drivers/gpio/vsc055.c
> new file mode 100644
> index 0000000..1ca6ae0
> --- /dev/null
> +++ b/drivers/gpio/vsc055.c
> @@ -0,0 +1,283 @@
> +/*
> + *  vsc055.c - Enhanced Two-Wire Serial Backplane Control with 64 I/O lines.
> + *
> + *  Copyright (C) 2011 Jonathan McDowell <noodles@earth.li>
> + *
> + *  Derived from drivers/gpio/pca953x.c
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; version 2 of the License.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/gpio.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c/vsc055.h>
> +#include <linux/slab.h>
> +
> +#define VSC055_GPD0		0x00
> +#define VSC055_DDP0		0x10
> +#define VSC055_BCIS		0xF8
> +#define VSC055_BCT		0xFC
> +#define VSC055_VER		0xFF
> +
> +static const struct i2c_device_id vsc055_id[] = {
> +	{ "vsc055" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, vsc055_id);
> +
> +struct vsc055_chip {
> +	unsigned gpio_start;
> +	u8 reg_output[8];
> +	u8 reg_direction[8];
> +	struct mutex reg_lock;
> +
> +	struct i2c_client *client;
> +	struct gpio_chip gpio_chip;
> +	const char *const *names;
> +};
> +
> +static int vsc055_gpio_direction_input(struct gpio_chip *gc, unsigned off)
> +{
> +	struct vsc055_chip *chip = container_of(gc, struct vsc055_chip, gpio_chip);
> +	u8 reg_val;
> +	int ret;
> +	int block, pin;
> +
> +	block = off >> 3;
> +	pin = off & 7;
> +
> +	mutex_lock(&chip->reg_lock);
> +	reg_val = chip->reg_direction[block] | (1u << pin);
> +	ret = i2c_smbus_write_byte_data(chip->client, VSC055_DDP0 + block, reg_val);
> +	if (ret)
> +		goto exit;
> +
> +	chip->reg_direction[block] = reg_val;
> +exit:
> +	mutex_unlock(&chip->reg_lock);
> +	return ret;
> +}
> +
> +static int vsc055_gpio_direction_output(struct gpio_chip *gc,
> +		unsigned off, int val)
> +{
> +	struct vsc055_chip *chip = container_of(gc, struct vsc055_chip, gpio_chip);
> +	u8 reg_val;
> +	int ret;
> +	int block, pin;
> +
> +	block = off >> 3;
> +	pin = off & 7;
> +
> +	mutex_lock(&chip->reg_lock);
> +	/* set output level */
> +	if (val)
> +		reg_val = chip->reg_output[block] | (1u << pin);
> +	else
> +		reg_val = chip->reg_output[block] & ~(1u << pin);
> +
> +	ret = i2c_smbus_write_byte_data(chip->client, VSC055_GPD0 + block, reg_val);
> +	if (ret)
> +		goto exit;
> +
> +	chip->reg_output[block] = reg_val;
> +
> +	/* then direction */
> +	reg_val = chip->reg_direction[block] & ~(1u << off);
> +	ret = i2c_smbus_write_byte_data(chip->client, VSC055_DDP0 + block, reg_val);
> +	if (ret)
> +		goto exit;
> +
> +	chip->reg_direction[block] = reg_val;
> +	ret = 0;
> +exit:
> +	mutex_unlock(&chip->reg_lock);
> +	return ret;
> +}
> +
> +static int vsc055_gpio_get_value(struct gpio_chip *gc, unsigned off)
> +{
> +	struct vsc055_chip *chip = container_of(gc, struct vsc055_chip, gpio_chip);
> +	u8 reg_val;
> +
> +	mutex_lock(&chip->reg_lock);
> +	reg_val = i2c_smbus_read_byte_data(chip->client, VSC055_GPD0 + (off >> 3));
> +	mutex_unlock(&chip->reg_lock);
> +	if (reg_val < 0) {
> +		dev_err(&chip->client->dev, "failed to read GPIO value.\n");
> +		return 0;
> +	}
> +
> +	return !!(reg_val & (1u << (off & 7)));
> +}
> +
> +static void vsc055_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
> +{
> +	struct vsc055_chip *chip = container_of(gc, struct vsc055_chip, gpio_chip);
> +	u8 reg_val;
> +	int ret;
> +	int block, pin;
> +
> +	block = off >> 3;
> +	pin = off & 7;
> +
> +	mutex_lock(&chip->reg_lock);
> +	if (val)
> +		reg_val = chip->reg_output[block] | (1u << pin);
> +	else
> +		reg_val = chip->reg_output[block] & ~(1u << pin);
> +
> +	ret = i2c_smbus_write_byte_data(chip->client, VSC055_GPD0 + block, reg_val);
> +	if (ret)
> +		goto exit;
> +
> +	chip->reg_output[block] = reg_val;
> +exit:
> +	mutex_unlock(&chip->reg_lock);
> +}
> +
> +static void vsc055_setup_gpio(struct vsc055_chip *chip)
> +{
> +	struct gpio_chip *gc = &chip->gpio_chip;;
> +
> +	gc->direction_input  = vsc055_gpio_direction_input;
> +	gc->direction_output = vsc055_gpio_direction_output;
> +	gc->get = vsc055_gpio_get_value;
> +	gc->set = vsc055_gpio_set_value;
> +	gc->can_sleep = 1;
> +
> +	gc->base = chip->gpio_start;
> +	gc->ngpio = 64;
> +	gc->label = chip->client->name;
> +	gc->dev = &chip->client->dev;
> +	gc->owner = THIS_MODULE;
> +	gc->names = chip->names;
> +}
> +
> +static int __devinit vsc055_probe(struct i2c_client *client,
> +				   const struct i2c_device_id *id)
> +{
> +	struct vsc055_platform_data *pdata;
> +	struct vsc055_chip *chip;
> +	int ret;
> +	int i;
> +
> +	chip = kzalloc(sizeof(struct vsc055_chip), GFP_KERNEL);
> +	if (chip == NULL)
> +		return -ENOMEM;
> +
> +	pdata = client->dev.platform_data;
> +	if (pdata == NULL) {
> +		dev_dbg(&client->dev, "no platform data\n");
> +		ret = -EINVAL;
> +		goto out_failed;
> +	}
> +
> +	chip->client = client;
> +
> +	chip->gpio_start = pdata->gpio_base;
> +
> +	chip->names = pdata->names;
> +
> +	mutex_init(&chip->reg_lock);
> +
> +	vsc055_setup_gpio(chip);
> +
> +	/*
> +	 * Initialize cached registers from their original values.
> +	 * We can't share this chip with another i2c master.
> +	 */
> +	for (i = 0; i < 8; i++) {
> +		ret = i2c_smbus_read_byte_data(chip->client, VSC055_GPD0 + i);
> +		if (ret < 0)
> +			goto out_failed;
> +		chip->reg_output[i] = ret;
> +
> +		ret = i2c_smbus_read_byte_data(chip->client, VSC055_DDP0 + i);
> +		if (ret < 0)
> +			goto out_failed;
> +		chip->reg_direction[i] = ret;
> +	}
> +
> +	ret = i2c_smbus_read_byte_data(chip->client, VSC055_VER);
> +	if (ret < 0)
> +		goto out_failed;
> +	dev_info(&client->dev, "Found VSC055 revision %d.%d\n", ret >> 4, ret & 0xF);
> +
> +	ret = gpiochip_add(&chip->gpio_chip);
> +	if (ret)
> +		goto out_failed;
> +
> +	if (pdata->setup) {
> +		ret = pdata->setup(client, chip->gpio_chip.base,
> +				chip->gpio_chip.ngpio, pdata->context);
> +		if (ret < 0)
> +			dev_warn(&client->dev, "setup failed, %d\n", ret);
> +	}
> +
> +	i2c_set_clientdata(client, chip);
> +	return 0;
> +
> +out_failed:
> +	kfree(chip);
> +	return ret;
> +}
> +
> +static int vsc055_remove(struct i2c_client *client)
> +{
> +	struct vsc055_platform_data *pdata = client->dev.platform_data;
> +	struct vsc055_chip *chip = i2c_get_clientdata(client);
> +	int ret = 0;
> +
> +	if (pdata->teardown) {
> +		ret = pdata->teardown(client, chip->gpio_chip.base,
> +				chip->gpio_chip.ngpio, pdata->context);
> +		if (ret < 0) {
> +			dev_err(&client->dev, "%s failed, %d\n",
> +					"teardown", ret);
> +			return ret;
> +		}
> +	}
> +
> +	ret = gpiochip_remove(&chip->gpio_chip);
> +	if (ret) {
> +		dev_err(&client->dev, "%s failed, %d\n",
> +				"gpiochip_remove()", ret);
> +		return ret;
> +	}
> +
> +	kfree(chip);
> +	return 0;
> +}
> +
> +static struct i2c_driver vsc055_driver = {
> +	.driver = {
> +		.name	= "vsc055",
> +	},
> +	.probe		= vsc055_probe,
> +	.remove		= vsc055_remove,
> +	.id_table	= vsc055_id,
> +};
> +
> +static int __init vsc055_init(void)
> +{
> +	return i2c_add_driver(&vsc055_driver);
> +}
> +/* register after i2c postcore initcall and before
> + * subsys initcalls that may rely on these GPIOs
> + */
> +subsys_initcall(vsc055_init);
> +
> +static void __exit vsc055_exit(void)
> +{
> +	i2c_del_driver(&vsc055_driver);
> +}
> +module_exit(vsc055_exit);
> +
> +MODULE_AUTHOR("Jonathan McDowell <noodles@earth.li>");
> +MODULE_DESCRIPTION("GPIO driver for VSC055");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/i2c/vsc055.h b/include/linux/i2c/vsc055.h
> new file mode 100644
> index 0000000..dc1462b
> --- /dev/null
> +++ b/include/linux/i2c/vsc055.h
> @@ -0,0 +1,22 @@
> +#ifndef _LINUX_VSC055_H
> +#define _LINUX_VSC055_H
> +
> +#include <linux/types.h>
> +#include <linux/i2c.h>
> +
> +/* Platform data for the VSC055 64-bit I/O expander driver */
> +
> +struct vsc055_platform_data {
> +	unsigned	gpio_base;	/* number of the first GPIO */
> +	void		*context;	/* param to setup/teardown */
> +
> +	int		(*setup)(struct i2c_client *client,
> +				unsigned gpio, unsigned ngpio,
> +				void *context);
> +	int		(*teardown)(struct i2c_client *client,
> +				unsigned gpio, unsigned ngpio,
> +				void *context);
> +	const char	*const *names;
> +};
> +
> +#endif /* _LINUX_VSC055_H */
> -----
> J.
> 

