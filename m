Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1EEJBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:01:10 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:54663 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1EEJBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:01:07 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DC267E3.6080206@cam.ac.uk>
Date: Thu, 05 May 2011 10:03:31 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonathan McDowell <noodles@earth.li>
CC: Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add support for VSC055 Enhanced Two-Wire Serial Backplane
 controller
References: <20110505041205.GY4835@earth.li>
In-Reply-To: <20110505041205.GY4835@earth.li>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Jonathan and Grant. I accidentally sent this only to you and
not to lkml, hence the resend.

On 05/05/11 05:12, Jonathan McDowell wrote:
> I'd been holding off on sending this until I got some feedback about the
> PC8741x driver I sent a couple of weeks ago, but seeing as I have it
> sitting around I figured I may as well send it anyway.
Looks mostly fine to me.

Couple of suggestions for minor tidying up inline.

Main one is that I'm anti wrappers around bus functions that do
very little.

Jonathan
> 
> -----
> Add support for the GPIOs on Maxim VSC055 I2C Enhanced Two-Wire Serial
> Backplane controller.
> 
> This chip features 64 bits of user-definable, bidirectional GPIOs. It also
> has the ability to do PWM fan control output and LED flashing, but support
> for that functionality is not included at present.
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>
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
> index 0000000..c218dac
> --- /dev/null
> +++ b/drivers/gpio/vsc055.c
> @@ -0,0 +1,326 @@
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
> +	uint8_t reg_output[8];
> +	uint8_t reg_direction[8];
> +	struct mutex i2c_lock;
> +
> +	struct i2c_client *client;
> +	struct gpio_chip gpio_chip;
> +	const char *const *names;
> +};
> +
> +static int vsc055_write_reg(struct vsc055_chip *chip, int reg, uint8_t val)
kernel type is u8, uint8_t is for userspace bits and bobs.
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_write_byte_data(chip->client, reg, val);
Why bother wrapping these functions? To my mind the debug message
is overkill.
> +
> +	if (ret < 0) {
> +		dev_err(&chip->client->dev, "failed writing register\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vsc055_read_reg(struct vsc055_chip *chip, int reg, uint8_t *val)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_read_byte_data(chip->client, reg);
> +
> +	if (ret < 0) {
> +		dev_err(&chip->client->dev, "failed reading register\n");
> +		return ret;
> +	}
> +
> +	*val = (uint8_t)ret;
no need for the type cast. Again, why is the wrapper needed. Trivial bit of
reorganization and it goes away for no real cost.
> +	return 0;
> +}
> +
> +static int vsc055_gpio_direction_input(struct gpio_chip *gc, unsigned off)
> +{
> +	struct vsc055_chip *chip;
> +	uint8_t reg_val;
> +	int ret;
> +	int block, pin;
> +
> +	chip = container_of(gc, struct vsc055_chip, gpio_chip);
> +
> +	block = off >> 3;

Roll pin into the one place it is used? It's rather confusingly named anyway!
> +	pin = off & 7;
> +
> +	mutex_lock(&chip->i2c_lock);
> +	reg_val = chip->reg_direction[block] | (1u << pin);
> +	ret = vsc055_write_reg(chip, VSC055_DDP0 + block, reg_val);
> +	if (ret)
> +		goto exit;
> +
> +	chip->reg_direction[block] = reg_val;
> +	ret = 0;
why ret = 0?  It's already zero if you got here.
> +exit:
> +	mutex_unlock(&chip->i2c_lock);
> +	return ret;
> +}
> +
> +static int vsc055_gpio_direction_output(struct gpio_chip *gc,
> +		unsigned off, int val)
> +{
> +	struct vsc055_chip *chip;
> +	uint8_t reg_val;
> +	int ret;
> +	int block, pin;
> +
> +	chip = container_of(gc, struct vsc055_chip, gpio_chip);
> +
> +	block = off >> 3;
> +	pin = off & 7;
Again, I'd just put this in the places pin is used.
> +
> +	mutex_lock(&chip->i2c_lock);
> +	/* set output level */
> +	if (val)
> +		reg_val = chip->reg_output[block] | (1u << pin);
> +	else
> +		reg_val = chip->reg_output[block] & ~(1u << pin);
> +
> +	ret = vsc055_write_reg(chip, VSC055_GPD0 + block, reg_val);
> +	if (ret)
> +		goto exit;
> +
> +	chip->reg_output[block] = reg_val;
> +
> +	/* then direction */
> +	reg_val = chip->reg_direction[block] & ~(1u << off);
> +	ret = vsc055_write_reg(chip, VSC055_DDP0 + block, reg_val);
> +	if (ret)
> +		goto exit;
> +
> +	chip->reg_direction[block] = reg_val;
> +	ret = 0;
> +exit:
> +	mutex_unlock(&chip->i2c_lock);
> +	return ret;
> +}
> +
> +static int vsc055_gpio_get_value(struct gpio_chip *gc, unsigned off)
> +{
> +	struct vsc055_chip *chip;
> +	uint8_t reg_val;
> +	int ret;
> +
> +	chip = container_of(gc, struct vsc055_chip, gpio_chip);
Given this is just compile time pointer magic, I'd roll it into one
line as:
struct vsc055_chip *chip = container_of(gc, struct vsc055_chip, gpio_chip);

That's just personal taste though so feel free to ignore!

> +
> +	mutex_lock(&chip->i2c_lock);
> +	ret = vsc055_read_reg(chip, VSC055_GPD0 + (off >> 3), &reg_val);
make this:
ret = i2c_smbus_read_byte_data(chip->client, reg);
> +	mutex_unlock(&chip->i2c_lock);
> +	if (ret < 0) {
> +		/* NOTE:  diagnostic already emitted; that's all we should
> +		 * do unless gpio_*_value_cansleep() calls become different
> +		 * from their nonsleeping siblings (and report faults).
> +		 */
then spurt some message here (as no longer in the function). That's uggly
that the gpio funcs don't return errors...
> +		return 0;
> +	}
> +
then given you've already checked it was zero you can do the following as
return  !!(ret & (1u  << (off & 7)));
(!! is really handy for this sort of case)

> +     return (reg_val & (1u << (off & 7))) ? 1 : 0;
> +}
> +
> +static void vsc055_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
> +{
> +	struct vsc055_chip *chip;
> +	uint8_t reg_val;
> +	int ret;
> +	int block, pin;
> +
> +	chip = container_of(gc, struct vsc055_chip, gpio_chip);
> +
> +	block = off >> 3;
> +	pin = off & 7;
> +
> +	mutex_lock(&chip->i2c_lock);
This lock is a little misleading. It doesn't lock the i2c bus. I'd be
more tempted to call it reg_lock to indicate it is preventing others
reading / writing the chip registers.
> +	if (val)
> +		reg_val = chip->reg_output[block] | (1u << pin);
> +	else
> +		reg_val = chip->reg_output[block] & ~(1u << pin);
> +
> +	ret = vsc055_write_reg(chip, VSC055_GPD0 + block, reg_val);
> +	if (ret)
> +		goto exit;
> +
> +	chip->reg_output[block] = reg_val;
> +exit:
> +	mutex_unlock(&chip->i2c_lock);
> +}
> +
> +static void vsc055_setup_gpio(struct vsc055_chip *chip)
> +{
> +	struct gpio_chip *gc;
> +
> +	gc = &chip->gpio_chip;
Personally I'd just do this long hand. 

More general question for gpio subsystem is whether an ops
type strucutre containing the bits that tend to be fixed
for a given gpio_chip implementation would make for cleaner
code?
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
> +	uint8_t ver;
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
> +	mutex_init(&chip->i2c_lock);
> +
> +	/* initialize cached registers from their original values.
> +	 * we can't share this chip with another i2c master.
> +	 */
I think the comment needs to be below the next line.

> +	vsc055_setup_gpio(chip);
> +
> +	for (i = 0; i < 8; i++) {
> +		ret = vsc055_read_reg(chip, VSC055_GPD0 + i,
> +			&chip->reg_output[i]);
> +		if (ret)
> +			goto out_failed;
> +		ret = vsc055_read_reg(chip, VSC055_DDP0 + i,
> +			&chip->reg_direction[i]);
> +		if (ret)
> +			goto out_failed;
> +	}
> +
> +	ret = vsc055_read_reg(chip, VSC055_VER, &ver);
> +	if (ret)
> +		goto out_failed;
> +	dev_info(&client->dev, "Found VSC055 revision %d.%d\n", ver >> 4, ver & 0xF);
Silly question but is there any reason to care about the version number?
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
> 
> J.
> 

