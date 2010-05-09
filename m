Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab0EIWAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 18:00:15 -0400
Received: from mga10.intel.com ([192.55.52.92]:1461 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752699Ab0EIWAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 18:00:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,358,1270450800"; 
   d="scan'208";a="796830093"
Date: Mon, 10 May 2010 00:00:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/2] mfd: add TC35892 MFD core
Message-ID: <20100509220050.GD3269@sortiz.org>
References: <1272514380-8160-1-git-send-email-rabin.vincent@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272514380-8160-1-git-send-email-rabin.vincent@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On Thu, Apr 29, 2010 at 09:42:59AM +0530, Rabin Vincent wrote:
> The TC35892 I/O Expander provides 24 GPIOs, a keypad controller, timers,
> and a rotator wheel interface.  This patch adds the MFD core.
Both this one and the GPIO patch applied, many thanks.

Cheers,
Samuel.


> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> ---
>  drivers/mfd/Kconfig         |   11 ++
>  drivers/mfd/Makefile        |    1 +
>  drivers/mfd/tc35892.c       |  345 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/tc35892.h |  132 ++++++++++++++++
>  4 files changed, 489 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/tc35892.c
>  create mode 100644 include/linux/mfd/tc35892.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 2515b6a..5d21e21 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -170,6 +170,17 @@ config TWL4030_CODEC
>  	select MFD_CORE
>  	default n
>  
> +config MFD_TC35892
> +	bool "Support Toshiba TC35892"
> +	depends on I2C=y && GENERIC_HARDIRQS
> +	select MFD_CORE
> +	help
> +	  Support for the Toshiba TC35892 I/O Expander.
> +
> +	  This driver provides common support for accessing the device,
> +	  additional drivers must be enabled in order to use the
> +	  functionality of the device.
> +
>  config MFD_TMIO
>  	bool
>  	default n
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index abf6f17..5eb7979 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -15,6 +15,7 @@ obj-$(CONFIG_HTC_I2CPLD)	+= htc-i2cpld.o
>  obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+= davinci_voicecodec.o
>  obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
>  
> +obj-$(CONFIG_MFD_TC35892)	+= tc35892.o
>  obj-$(CONFIG_MFD_T7L66XB)	+= t7l66xb.o tmio_core.o
>  obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o tmio_core.o
>  obj-$(CONFIG_MFD_TC6393XB)	+= tc6393xb.o tmio_core.o
> diff --git a/drivers/mfd/tc35892.c b/drivers/mfd/tc35892.c
> new file mode 100644
> index 0000000..bf31960
> --- /dev/null
> +++ b/drivers/mfd/tc35892.c
> @@ -0,0 +1,345 @@
> +/*
> + * Copyright (C) ST-Ericsson SA 2010
> + *
> + * License Terms: GNU General Public License, version 2
> + * Author: Hanumath Prasad <hanumath.prasad@stericsson.com> for ST-Ericsson
> + * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
> + */
> +
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/tc35892.h>
> +
> +/**
> + * tc35892_reg_read() - read a single TC35892 register
> + * @tc35892:	Device to read from
> + * @reg:	Register to read
> + */
> +int tc35892_reg_read(struct tc35892 *tc35892, u8 reg)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_read_byte_data(tc35892->i2c, reg);
> +	if (ret < 0)
> +		dev_err(tc35892->dev, "failed to read reg %#x: %d\n",
> +			reg, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tc35892_reg_read);
> +
> +/**
> + * tc35892_reg_read() - write a single TC35892 register
> + * @tc35892:	Device to write to
> + * @reg:	Register to read
> + * @data:	Value to write
> + */
> +int tc35892_reg_write(struct tc35892 *tc35892, u8 reg, u8 data)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_write_byte_data(tc35892->i2c, reg, data);
> +	if (ret < 0)
> +		dev_err(tc35892->dev, "failed to write reg %#x: %d\n",
> +			reg, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tc35892_reg_write);
> +
> +/**
> + * tc35892_block_read() - read multiple TC35892 registers
> + * @tc35892:	Device to read from
> + * @reg:	First register
> + * @length:	Number of registers
> + * @values:	Buffer to write to
> + */
> +int tc35892_block_read(struct tc35892 *tc35892, u8 reg, u8 length, u8 *values)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_read_i2c_block_data(tc35892->i2c, reg, length, values);
> +	if (ret < 0)
> +		dev_err(tc35892->dev, "failed to read regs %#x: %d\n",
> +			reg, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tc35892_block_read);
> +
> +/**
> + * tc35892_block_write() - write multiple TC35892 registers
> + * @tc35892:	Device to write to
> + * @reg:	First register
> + * @length:	Number of registers
> + * @values:	Values to write
> + */
> +int tc35892_block_write(struct tc35892 *tc35892, u8 reg, u8 length,
> +			const u8 *values)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_write_i2c_block_data(tc35892->i2c, reg, length,
> +					     values);
> +	if (ret < 0)
> +		dev_err(tc35892->dev, "failed to write regs %#x: %d\n",
> +			reg, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tc35892_block_write);
> +
> +/**
> + * tc35892_set_bits() - set the value of a bitfield in a TC35892 register
> + * @tc35892:	Device to write to
> + * @reg:	Register to write
> + * @mask:	Mask of bits to set
> + * @values:	Value to set
> + */
> +int tc35892_set_bits(struct tc35892 *tc35892, u8 reg, u8 mask, u8 val)
> +{
> +	int ret;
> +
> +	mutex_lock(&tc35892->lock);
> +
> +	ret = tc35892_reg_read(tc35892, reg);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret &= ~mask;
> +	ret |= val;
> +
> +	ret = tc35892_reg_write(tc35892, reg, ret);
> +
> +out:
> +	mutex_unlock(&tc35892->lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tc35892_set_bits);
> +
> +static struct resource gpio_resources[] = {
> +	{
> +		.start	= TC35892_INT_GPIIRQ,
> +		.end	= TC35892_INT_GPIIRQ,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct mfd_cell tc35892_devs[] = {
> +	{
> +		.name		= "tc35892-gpio",
> +		.num_resources	= ARRAY_SIZE(gpio_resources),
> +		.resources	= &gpio_resources[0],
> +	},
> +};
> +
> +static irqreturn_t tc35892_irq(int irq, void *data)
> +{
> +	struct tc35892 *tc35892 = data;
> +	int status;
> +
> +	status = tc35892_reg_read(tc35892, TC35892_IRQST);
> +	if (status < 0)
> +		return IRQ_NONE;
> +
> +	while (status) {
> +		int bit = __ffs(status);
> +
> +		handle_nested_irq(tc35892->irq_base + bit);
> +		status &= ~(1 << bit);
> +	}
> +
> +	/*
> +	 * A dummy read or write (to any register) appears to be necessary to
> +	 * have the last interrupt clear (for example, GPIO IC write) take
> +	 * effect.
> +	 */
> +	tc35892_reg_read(tc35892, TC35892_IRQST);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void tc35892_irq_dummy(unsigned int irq)
> +{
> +	/* No mask/unmask at this level */
> +}
> +
> +static struct irq_chip tc35892_irq_chip = {
> +	.name	= "tc35892",
> +	.mask	= tc35892_irq_dummy,
> +	.unmask	= tc35892_irq_dummy,
> +};
> +
> +static int tc35892_irq_init(struct tc35892 *tc35892)
> +{
> +	int base = tc35892->irq_base;
> +	int irq;
> +
> +	for (irq = base; irq < base + TC35892_NR_INTERNAL_IRQS; irq++) {
> +		set_irq_chip_data(irq, tc35892);
> +		set_irq_chip_and_handler(irq, &tc35892_irq_chip,
> +					 handle_edge_irq);
> +		set_irq_nested_thread(irq, 1);
> +#ifdef CONFIG_ARM
> +		set_irq_flags(irq, IRQF_VALID);
> +#else
> +		set_irq_noprobe(irq);
> +#endif
> +	}
> +
> +	return 0;
> +}
> +
> +static void tc35892_irq_remove(struct tc35892 *tc35892)
> +{
> +	int base = tc35892->irq_base;
> +	int irq;
> +
> +	for (irq = base; irq < base + TC35892_NR_INTERNAL_IRQS; irq++) {
> +		set_irq_flags(irq, 0);
> +		set_irq_chip_and_handler(irq, NULL, NULL);
> +		set_irq_chip_data(irq, NULL);
> +	}
> +}
> +
> +static int tc35892_chip_init(struct tc35892 *tc35892)
> +{
> +	int manf, ver, ret;
> +
> +	manf = tc35892_reg_read(tc35892, TC35892_MANFCODE);
> +	if (manf < 0)
> +		return manf;
> +
> +	ver = tc35892_reg_read(tc35892, TC35892_VERSION);
> +	if (ver < 0)
> +		return ver;
> +
> +	if (manf != TC35892_MANFCODE_MAGIC) {
> +		dev_err(tc35892->dev, "unknown manufacturer: %#x\n", manf);
> +		return -EINVAL;
> +	}
> +
> +	dev_info(tc35892->dev, "manufacturer: %#x, version: %#x\n", manf, ver);
> +
> +	/* Put everything except the IRQ module into reset */
> +	ret = tc35892_reg_write(tc35892, TC35892_RSTCTRL,
> +				TC35892_RSTCTRL_TIMRST
> +				| TC35892_RSTCTRL_ROTRST
> +				| TC35892_RSTCTRL_KBDRST
> +				| TC35892_RSTCTRL_GPIRST);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Clear the reset interrupt. */
> +	return tc35892_reg_write(tc35892, TC35892_RSTINTCLR, 0x1);
> +}
> +
> +static int __devinit tc35892_probe(struct i2c_client *i2c,
> +				   const struct i2c_device_id *id)
> +{
> +	struct tc35892_platform_data *pdata = i2c->dev.platform_data;
> +	struct tc35892 *tc35892;
> +	int ret;
> +
> +	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_SMBUS_BYTE_DATA
> +				     | I2C_FUNC_SMBUS_I2C_BLOCK))
> +		return -EIO;
> +
> +	tc35892 = kzalloc(sizeof(struct tc35892), GFP_KERNEL);
> +	if (!tc35892)
> +		return -ENOMEM;
> +
> +	mutex_init(&tc35892->lock);
> +
> +	tc35892->dev = &i2c->dev;
> +	tc35892->i2c = i2c;
> +	tc35892->pdata = pdata;
> +	tc35892->irq_base = pdata->irq_base;
> +	tc35892->num_gpio = id->driver_data;
> +
> +	i2c_set_clientdata(i2c, tc35892);
> +
> +	ret = tc35892_chip_init(tc35892);
> +	if (ret)
> +		goto out_free;
> +
> +	ret = tc35892_irq_init(tc35892);
> +	if (ret)
> +		goto out_free;
> +
> +	ret = request_threaded_irq(tc35892->i2c->irq, NULL, tc35892_irq,
> +				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +				   "tc35892", tc35892);
> +	if (ret) {
> +		dev_err(tc35892->dev, "failed to request IRQ: %d\n", ret);
> +		goto out_removeirq;
> +	}
> +
> +	ret = mfd_add_devices(tc35892->dev, -1, tc35892_devs,
> +			      ARRAY_SIZE(tc35892_devs), NULL,
> +			      tc35892->irq_base);
> +	if (ret) {
> +		dev_err(tc35892->dev, "failed to add children\n");
> +		goto out_freeirq;
> +	}
> +
> +	return 0;
> +
> +out_freeirq:
> +	free_irq(tc35892->i2c->irq, tc35892);
> +out_removeirq:
> +	tc35892_irq_remove(tc35892);
> +out_free:
> +	i2c_set_clientdata(i2c, NULL);
> +	kfree(tc35892);
> +	return ret;
> +}
> +
> +static int __devexit tc35892_remove(struct i2c_client *client)
> +{
> +	struct tc35892 *tc35892 = i2c_get_clientdata(client);
> +
> +	mfd_remove_devices(tc35892->dev);
> +
> +	free_irq(tc35892->i2c->irq, tc35892);
> +	tc35892_irq_remove(tc35892);
> +
> +	i2c_set_clientdata(client, NULL);
> +	kfree(tc35892);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id tc35892_id[] = {
> +	{ "tc35892", 24 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, tc35892_id);
> +
> +static struct i2c_driver tc35892_driver = {
> +	.driver.name	= "tc35892",
> +	.driver.owner	= THIS_MODULE,
> +	.probe		= tc35892_probe,
> +	.remove		= __devexit_p(tc35892_remove),
> +	.id_table	= tc35892_id,
> +};
> +
> +static int __init tc35892_init(void)
> +{
> +	return i2c_add_driver(&tc35892_driver);
> +}
> +subsys_initcall(tc35892_init);
> +
> +static void __exit tc35892_exit(void)
> +{
> +	i2c_del_driver(&tc35892_driver);
> +}
> +module_exit(tc35892_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("TC35892 MFD core driver");
> +MODULE_AUTHOR("Hanumath Prasad, Rabin Vincent");
> diff --git a/include/linux/mfd/tc35892.h b/include/linux/mfd/tc35892.h
> new file mode 100644
> index 0000000..e47f770
> --- /dev/null
> +++ b/include/linux/mfd/tc35892.h
> @@ -0,0 +1,132 @@
> +/*
> + * Copyright (C) ST-Ericsson SA 2010
> + *
> + * License Terms: GNU General Public License, version 2
> + */
> +
> +#ifndef __LINUX_MFD_TC35892_H
> +#define __LINUX_MFD_TC35892_H
> +
> +#include <linux/device.h>
> +
> +#define TC35892_RSTCTRL_IRQRST	(1 << 4)
> +#define TC35892_RSTCTRL_TIMRST	(1 << 3)
> +#define TC35892_RSTCTRL_ROTRST	(1 << 2)
> +#define TC35892_RSTCTRL_KBDRST	(1 << 1)
> +#define TC35892_RSTCTRL_GPIRST	(1 << 0)
> +
> +#define TC35892_IRQST		0x91
> +
> +#define TC35892_MANFCODE_MAGIC	0x03
> +#define TC35892_MANFCODE	0x80
> +#define TC35892_VERSION		0x81
> +#define TC35892_IOCFG		0xA7
> +
> +#define TC35892_CLKMODE		0x88
> +#define TC35892_CLKCFG		0x89
> +#define TC35892_CLKEN		0x8A
> +
> +#define TC35892_RSTCTRL		0x82
> +#define TC35892_EXTRSTN		0x83
> +#define TC35892_RSTINTCLR	0x84
> +
> +#define TC35892_GPIOIS0		0xC9
> +#define TC35892_GPIOIS1		0xCA
> +#define TC35892_GPIOIS2		0xCB
> +#define TC35892_GPIOIBE0	0xCC
> +#define TC35892_GPIOIBE1	0xCD
> +#define TC35892_GPIOIBE2	0xCE
> +#define TC35892_GPIOIEV0	0xCF
> +#define TC35892_GPIOIEV1	0xD0
> +#define TC35892_GPIOIEV2	0xD1
> +#define TC35892_GPIOIE0		0xD2
> +#define TC35892_GPIOIE1		0xD3
> +#define TC35892_GPIOIE2		0xD4
> +#define TC35892_GPIORIS0	0xD6
> +#define TC35892_GPIORIS1	0xD7
> +#define TC35892_GPIORIS2	0xD8
> +#define TC35892_GPIOMIS0	0xD9
> +#define TC35892_GPIOMIS1	0xDA
> +#define TC35892_GPIOMIS2	0xDB
> +#define TC35892_GPIOIC0		0xDC
> +#define TC35892_GPIOIC1		0xDD
> +#define TC35892_GPIOIC2		0xDE
> +
> +#define TC35892_GPIODATA0	0xC0
> +#define TC35892_GPIOMASK0	0xc1
> +#define TC35892_GPIODATA1	0xC2
> +#define TC35892_GPIOMASK1	0xc3
> +#define TC35892_GPIODATA2	0xC4
> +#define TC35892_GPIOMASK2	0xC5
> +
> +#define TC35892_GPIODIR0	0xC6
> +#define TC35892_GPIODIR1	0xC7
> +#define TC35892_GPIODIR2	0xC8
> +
> +#define TC35892_GPIOSYNC0	0xE6
> +#define TC35892_GPIOSYNC1	0xE7
> +#define TC35892_GPIOSYNC2	0xE8
> +
> +#define TC35892_GPIOWAKE0	0xE9
> +#define TC35892_GPIOWAKE1	0xEA
> +#define TC35892_GPIOWAKE2	0xEB
> +
> +#define TC35892_GPIOODM0	0xE0
> +#define TC35892_GPIOODE0	0xE1
> +#define TC35892_GPIOODM1	0xE2
> +#define TC35892_GPIOODE1	0xE3
> +#define TC35892_GPIOODM2	0xE4
> +#define TC35892_GPIOODE2	0xE5
> +
> +#define TC35892_INT_GPIIRQ	0
> +#define TC35892_INT_TI0IRQ	1
> +#define TC35892_INT_TI1IRQ	2
> +#define TC35892_INT_TI2IRQ	3
> +#define TC35892_INT_ROTIRQ	5
> +#define TC35892_INT_KBDIRQ	6
> +#define TC35892_INT_PORIRQ	7
> +
> +#define TC35892_NR_INTERNAL_IRQS	8
> +#define TC35892_INT_GPIO(x)	(TC35892_NR_INTERNAL_IRQS + (x))
> +
> +struct tc35892 {
> +	struct mutex lock;
> +	struct device *dev;
> +	struct i2c_client *i2c;
> +
> +	int irq_base;
> +	int num_gpio;
> +	struct tc35892_platform_data *pdata;
> +};
> +
> +extern int tc35892_reg_write(struct tc35892 *tc35892, u8 reg, u8 data);
> +extern int tc35892_reg_read(struct tc35892 *tc35892, u8 reg);
> +extern int tc35892_block_read(struct tc35892 *tc35892, u8 reg, u8 length,
> +			      u8 *values);
> +extern int tc35892_block_write(struct tc35892 *tc35892, u8 reg, u8 length,
> +			       const u8 *values);
> +extern int tc35892_set_bits(struct tc35892 *tc35892, u8 reg, u8 mask, u8 val);
> +
> +/**
> + * struct tc35892_gpio_platform_data - TC35892 GPIO platform data
> + * @gpio_base: first gpio number assigned to TC35892.  A maximum of
> + *	       %TC35892_NR_GPIOS GPIOs will be allocated.
> + */
> +struct tc35892_gpio_platform_data {
> +	int gpio_base;
> +};
> +
> +/**
> + * struct tc35892_platform_data - TC35892 platform data
> + * @irq_base: base IRQ number.  %TC35892_NR_IRQS irqs will be used.
> + * @gpio: GPIO-specific platform data
> + */
> +struct tc35892_platform_data {
> +	int irq_base;
> +	struct tc35892_gpio_platform_data *gpio;
> +};
> +
> +#define TC35892_NR_GPIOS	24
> +#define TC35892_NR_IRQS		TC35892_INT_GPIO(TC35892_NR_GPIOS)
> +
> +#endif
> -- 
> 1.7.0
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
