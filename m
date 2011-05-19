Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375Ab1EST2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:28:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35707 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933896Ab1EST2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:28:16 -0400
Date: Thu, 19 May 2011 13:28:13 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCHv2] basic_mmio_gpio: split into a gpio library and
 platform device
Message-ID: <20110519192813.GO5109@ponder.secretlab.ca>
References: <1305383955-32346-1-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305383955-32346-1-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 03:39:15PM +0100, Jamie Iles wrote:
> Allow GPIO_BASIC_MMIO_CORE to be used to provide an accessor library
> for implementing GPIO drivers whilst abstracting the register access
> detail.  Based on a patch from Anton Vorontsov[1] and adapted to allow
> bgpio_chip to be embedded in another structure.
> 
> Changes since v1:
> 	- Register the gpio_chip in the platform device probe
> 
> 1. https://lkml.org/lkml/2011/4/19/401
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Merged, thanks.

g.

> ---
>  drivers/gpio/Kconfig            |    6 +
>  drivers/gpio/Makefile           |    1 +
>  drivers/gpio/basic_mmio_gpio.c  |  317 +++++++++++++++++++++------------------
>  include/linux/basic_mmio_gpio.h |   55 +++++++
>  4 files changed, 231 insertions(+), 148 deletions(-)
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index b7fac15..ca16a30 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -70,8 +70,14 @@ config GPIO_MAX730X
>  
>  comment "Memory mapped GPIO drivers:"
>  
> +config GPIO_BASIC_MMIO_CORE
> +	tristate
> +	help
> +	  Provides core functionality for basic memory-mapped GPIO controllers.
> +
>  config GPIO_BASIC_MMIO
>  	tristate "Basic memory-mapped GPIO controllers support"
> +	select GPIO_BASIC_MMIO_CORE
>  	help
>  	  Say yes here to support basic memory-mapped GPIO controllers.
>  
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index cfbdef1..91a295d 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -6,6 +6,7 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
>  
>  obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
>  obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
> +obj-$(CONFIG_GPIO_BASIC_MMIO_CORE)	+= basic_mmio_gpio.o
>  obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
>  obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
>  obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
> diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
> index b2ec45f..8152e9f 100644
> --- a/drivers/gpio/basic_mmio_gpio.c
> +++ b/drivers/gpio/basic_mmio_gpio.c
> @@ -45,6 +45,7 @@ o        `                     ~~~~\___/~~~~    ` controller in FPGA is ,.`
>   */
>  
>  #include <linux/init.h>
> +#include <linux/err.h>
>  #include <linux/bug.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> @@ -61,44 +62,6 @@ o        `                     ~~~~\___/~~~~    ` controller in FPGA is ,.`
>  #include <linux/mod_devicetable.h>
>  #include <linux/basic_mmio_gpio.h>
>  
> -struct bgpio_chip {
> -	struct gpio_chip gc;
> -
> -	unsigned long (*read_reg)(void __iomem *reg);
> -	void (*write_reg)(void __iomem *reg, unsigned long data);
> -
> -	void __iomem *reg_dat;
> -	void __iomem *reg_set;
> -	void __iomem *reg_clr;
> -	void __iomem *reg_dir;
> -
> -	/* Number of bits (GPIOs): <register width> * 8. */
> -	int bits;
> -
> -	/*
> -	 * Some GPIO controllers work with the big-endian bits notation,
> -	 * e.g. in a 8-bits register, GPIO7 is the least significant bit.
> -	 */
> -	unsigned long (*pin2mask)(struct bgpio_chip *bgc, unsigned int pin);
> -
> -	/*
> -	 * Used to lock bgpio_chip->data. Also, this is needed to keep
> -	 * shadowed and real data registers writes together.
> -	 */
> -	spinlock_t lock;
> -
> -	/* Shadowed data register to clear/set bits safely. */
> -	unsigned long data;
> -
> -	/* Shadowed direction registers to clear/set direction safely. */
> -	unsigned long dir;
> -};
> -
> -static struct bgpio_chip *to_bgpio_chip(struct gpio_chip *gc)
> -{
> -	return container_of(gc, struct bgpio_chip, gc);
> -}
> -
>  static void bgpio_write8(void __iomem *reg, unsigned long data)
>  {
>  	writeb(data, reg);
> @@ -284,20 +247,10 @@ static int bgpio_dir_out_inv(struct gpio_chip *gc, unsigned int gpio, int val)
>  	return 0;
>  }
>  
> -static void __iomem *bgpio_request_and_map(struct device *dev,
> -					   struct resource *res)
> -{
> -	if (!devm_request_mem_region(dev, res->start, resource_size(res),
> -				     res->name ?: "mmio_gpio"))
> -		return NULL;
> -
> -	return devm_ioremap(dev, res->start, resource_size(res));
> -}
> -
> -static int bgpio_setup_accessors(struct platform_device *pdev,
> -				 struct bgpio_chip *bgc)
> +static int bgpio_setup_accessors(struct device *dev,
> +				 struct bgpio_chip *bgc,
> +				 bool be)
>  {
> -	const struct platform_device_id *platid = platform_get_device_id(pdev);
>  
>  	switch (bgc->bits) {
>  	case 8:
> @@ -319,13 +272,11 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
>  		break;
>  #endif /* BITS_PER_LONG >= 64 */
>  	default:
> -		dev_err(&pdev->dev, "unsupported data width %u bits\n",
> -			bgc->bits);
> +		dev_err(dev, "unsupported data width %u bits\n", bgc->bits);
>  		return -EINVAL;
>  	}
>  
> -	bgc->pin2mask = strcmp(platid->name, "basic-mmio-gpio-be") ?
> -		bgpio_pin2mask : bgpio_pin2mask_be;
> +	bgc->pin2mask = be ? bgpio_pin2mask_be : bgpio_pin2mask;
>  
>  	return 0;
>  }
> @@ -352,51 +303,22 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
>   *	- an input direction register (named "dirin") where a 1 bit indicates
>   *	the GPIO is an input.
>   */
> -static int bgpio_setup_io(struct platform_device *pdev,
> -			  struct bgpio_chip *bgc)
> +static int bgpio_setup_io(struct bgpio_chip *bgc,
> +			  void __iomem *dat,
> +			  void __iomem *set,
> +			  void __iomem *clr)
>  {
> -	struct resource *res_set;
> -	struct resource *res_clr;
> -	struct resource *res_dat;
> -	resource_size_t dat_sz;
>  
> -	res_dat = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
> -	if (!res_dat)
> -		return -EINVAL;
> -
> -	dat_sz = resource_size(res_dat);
> -	if (!is_power_of_2(dat_sz))
> -		return -EINVAL;
> -
> -	bgc->bits = dat_sz * 8;
> -	if (bgc->bits > BITS_PER_LONG)
> -		return -EINVAL;
> -
> -	bgc->reg_dat = bgpio_request_and_map(&pdev->dev, res_dat);
> +	bgc->reg_dat = dat;
>  	if (!bgc->reg_dat)
> -		return -ENOMEM;
> -
> -	res_set = platform_get_resource_byname(pdev, IORESOURCE_MEM, "set");
> -	res_clr = platform_get_resource_byname(pdev, IORESOURCE_MEM, "clr");
> -	if (res_set && res_clr) {
> -		if (resource_size(res_set) != resource_size(res_clr) ||
> -		    resource_size(res_set) != resource_size(res_dat))
> -			return -EINVAL;
> -
> -		bgc->reg_set = bgpio_request_and_map(&pdev->dev, res_set);
> -		bgc->reg_clr = bgpio_request_and_map(&pdev->dev, res_clr);
> -		if (!bgc->reg_set || !bgc->reg_clr)
> -			return -ENOMEM;
> +		return -EINVAL;
>  
> +	if (set && clr) {
> +		bgc->reg_set = set;
> +		bgc->reg_clr = clr;
>  		bgc->gc.set = bgpio_set_with_clear;
> -	} else if (res_set && !res_clr) {
> -		if (resource_size(res_set) != resource_size(res_dat))
> -			return -EINVAL;
> -
> -		bgc->reg_set = bgpio_request_and_map(&pdev->dev, res_set);
> -		if (!bgc->reg_set)
> -			return -ENOMEM;
> -
> +	} else if (set && !clr) {
> +		bgc->reg_set = set;
>  		bgc->gc.set = bgpio_set_set;
>  	} else {
>  		bgc->gc.set = bgpio_set;
> @@ -407,27 +329,18 @@ static int bgpio_setup_io(struct platform_device *pdev,
>  	return 0;
>  }
>  
> -static int bgpio_setup_direction(struct platform_device *pdev,
> -				 struct bgpio_chip *bgc)
> +static int bgpio_setup_direction(struct bgpio_chip *bgc,
> +				 void __iomem *dirout,
> +				 void __iomem *dirin)
>  {
> -	struct resource *res_dirout;
> -	struct resource *res_dirin;
> -
> -	res_dirout = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> -						  "dirout");
> -	res_dirin = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirin");
> -	if (res_dirout && res_dirin) {
> +	if (dirout && dirin) {
>  		return -EINVAL;
> -	} else if (res_dirout) {
> -		bgc->reg_dir = bgpio_request_and_map(&pdev->dev, res_dirout);
> -		if (!bgc->reg_dir)
> -			return -ENOMEM;
> +	} else if (dirout) {
> +		bgc->reg_dir = dirout;
>  		bgc->gc.direction_output = bgpio_dir_out;
>  		bgc->gc.direction_input = bgpio_dir_in;
> -	} else if (res_dirin) {
> -		bgc->reg_dir = bgpio_request_and_map(&pdev->dev, res_dirin);
> -		if (!bgc->reg_dir)
> -			return -ENOMEM;
> +	} else if (dirin) {
> +		bgc->reg_dir = dirin;
>  		bgc->gc.direction_output = bgpio_dir_out_inv;
>  		bgc->gc.direction_input = bgpio_dir_in_inv;
>  	} else {
> @@ -438,60 +351,166 @@ static int bgpio_setup_direction(struct platform_device *pdev,
>  	return 0;
>  }
>  
> -static int __devinit bgpio_probe(struct platform_device *pdev)
> +int __devexit bgpio_remove(struct bgpio_chip *bgc)
> +{
> +	int err = gpiochip_remove(&bgc->gc);
> +
> +	kfree(bgc);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(bgpio_remove);
> +
> +int __devinit bgpio_init(struct bgpio_chip *bgc,
> +			 struct device *dev,
> +			 unsigned long sz,
> +			 void __iomem *dat,
> +			 void __iomem *set,
> +			 void __iomem *clr,
> +			 void __iomem *dirout,
> +			 void __iomem *dirin,
> +			 bool big_endian)
>  {
> -	struct device *dev = &pdev->dev;
> -	struct bgpio_pdata *pdata = dev_get_platdata(dev);
> -	struct bgpio_chip *bgc;
>  	int ret;
> -	int ngpio;
>  
> -	bgc = devm_kzalloc(dev, sizeof(*bgc), GFP_KERNEL);
> -	if (!bgc)
> -		return -ENOMEM;
> +	if (!is_power_of_2(sz))
> +		return -EINVAL;
>  
> -	ret = bgpio_setup_io(pdev, bgc);
> +	bgc->bits = sz * 8;
> +	if (bgc->bits > BITS_PER_LONG)
> +		return -EINVAL;
> +
> +	spin_lock_init(&bgc->lock);
> +	bgc->gc.dev = dev;
> +	bgc->gc.label = dev_name(dev);
> +	bgc->gc.base = -1;
> +	bgc->gc.ngpio = bgc->bits;
> +
> +	ret = bgpio_setup_io(bgc, dat, set, clr);
>  	if (ret)
>  		return ret;
>  
> -	ngpio = bgc->bits;
> -	if (pdata) {
> -		bgc->gc.base = pdata->base;
> -		if (pdata->ngpio > 0)
> -			ngpio = pdata->ngpio;
> -	} else {
> -		bgc->gc.base = -1;
> -	}
> -
> -	ret = bgpio_setup_accessors(pdev, bgc);
> +	ret = bgpio_setup_accessors(dev, bgc, big_endian);
>  	if (ret)
>  		return ret;
>  
> -	spin_lock_init(&bgc->lock);
> -	ret = bgpio_setup_direction(pdev, bgc);
> +	ret = bgpio_setup_direction(bgc, dirout, dirin);
>  	if (ret)
>  		return ret;
>  
>  	bgc->data = bgc->read_reg(bgc->reg_dat);
>  
> -	bgc->gc.ngpio = ngpio;
> -	bgc->gc.dev = dev;
> -	bgc->gc.label = dev_name(dev);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(bgpio_init);
>  
> -	platform_set_drvdata(pdev, bgc);
> +#ifdef CONFIG_GPIO_BASIC_MMIO
>  
> -	ret = gpiochip_add(&bgc->gc);
> -	if (ret)
> -		dev_err(dev, "gpiochip_add() failed: %d\n", ret);
> +static void __iomem *bgpio_map(struct platform_device *pdev,
> +			       const char *name,
> +			       resource_size_t sane_sz,
> +			       int *err)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct resource *r;
> +	resource_size_t start;
> +	resource_size_t sz;
> +	void __iomem *ret;
> +
> +	*err = 0;
> +
> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
> +	if (!r)
> +		return NULL;
> +
> +	sz = resource_size(r);
> +	if (sz != sane_sz) {
> +		*err = -EINVAL;
> +		return NULL;
> +	}
> +
> +	start = r->start;
> +	if (!devm_request_mem_region(dev, start, sz, r->name)) {
> +		*err = -EBUSY;
> +		return NULL;
> +	}
> +
> +	ret = devm_ioremap(dev, start, sz);
> +	if (!ret) {
> +		*err = -ENOMEM;
> +		return NULL;
> +	}
>  
>  	return ret;
>  }
>  
> -static int __devexit bgpio_remove(struct platform_device *pdev)
> +static int __devinit bgpio_pdev_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct resource *r;
> +	void __iomem *dat;
> +	void __iomem *set;
> +	void __iomem *clr;
> +	void __iomem *dirout;
> +	void __iomem *dirin;
> +	unsigned long sz;
> +	bool be;
> +	int err;
> +	struct bgpio_chip *bgc;
> +	struct bgpio_pdata *pdata = dev_get_platdata(dev);
> +
> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
> +	if (!r)
> +		return -EINVAL;
> +
> +	sz = resource_size(r);
> +
> +	dat = bgpio_map(pdev, "dat", sz, &err);
> +	if (!dat)
> +		return err ? err : -EINVAL;
> +
> +	set = bgpio_map(pdev, "set", sz, &err);
> +	if (err)
> +		return err;
> +
> +	clr = bgpio_map(pdev, "clr", sz, &err);
> +	if (err)
> +		return err;
> +
> +	dirout = bgpio_map(pdev, "dirout", sz, &err);
> +	if (err)
> +		return err;
> +
> +	dirin = bgpio_map(pdev, "dirin", sz, &err);
> +	if (err)
> +		return err;
> +
> +	be = !strcmp(platform_get_device_id(pdev)->name, "basic-mmio-gpio-be");
> +
> +	bgc = devm_kzalloc(&pdev->dev, sizeof(*bgc), GFP_KERNEL);
> +	if (!bgc)
> +		return -ENOMEM;
> +
> +	err = bgpio_init(bgc, dev, sz, dat, set, clr, dirout, dirin, be);
> +	if (err)
> +		return err;
> +
> +	if (pdata) {
> +		bgc->gc.base = pdata->base;
> +		if (pdata->ngpio > 0)
> +			bgc->gc.ngpio = pdata->ngpio;
> +	}
> +
> +	platform_set_drvdata(pdev, bgc);
> +
> +	return gpiochip_add(&bgc->gc);
> +}
> +
> +static int __devexit bgpio_pdev_remove(struct platform_device *pdev)
>  {
>  	struct bgpio_chip *bgc = platform_get_drvdata(pdev);
>  
> -	return gpiochip_remove(&bgc->gc);
> +	return bgpio_remove(bgc);
>  }
>  
>  static const struct platform_device_id bgpio_id_table[] = {
> @@ -506,21 +525,23 @@ static struct platform_driver bgpio_driver = {
>  		.name = "basic-mmio-gpio",
>  	},
>  	.id_table = bgpio_id_table,
> -	.probe = bgpio_probe,
> -	.remove = __devexit_p(bgpio_remove),
> +	.probe = bgpio_pdev_probe,
> +	.remove = __devexit_p(bgpio_pdev_remove),
>  };
>  
> -static int __init bgpio_init(void)
> +static int __init bgpio_platform_init(void)
>  {
>  	return platform_driver_register(&bgpio_driver);
>  }
> -module_init(bgpio_init);
> +module_init(bgpio_platform_init);
>  
> -static void __exit bgpio_exit(void)
> +static void __exit bgpio_platform_exit(void)
>  {
>  	platform_driver_unregister(&bgpio_driver);
>  }
> -module_exit(bgpio_exit);
> +module_exit(bgpio_platform_exit);
> +
> +#endif /* CONFIG_GPIO_BASIC_MMIO */
>  
>  MODULE_DESCRIPTION("Driver for basic memory-mapped GPIO controllers");
>  MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
> diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
> index f23ec73..1ae1271 100644
> --- a/include/linux/basic_mmio_gpio.h
> +++ b/include/linux/basic_mmio_gpio.h
> @@ -13,9 +13,64 @@
>  #ifndef __BASIC_MMIO_GPIO_H
>  #define __BASIC_MMIO_GPIO_H
>  
> +#include <linux/gpio.h>
> +#include <linux/types.h>
> +#include <linux/compiler.h>
> +
>  struct bgpio_pdata {
>  	int base;
>  	int ngpio;
>  };
>  
> +struct device;
> +
> +struct bgpio_chip {
> +	struct gpio_chip gc;
> +
> +	unsigned long (*read_reg)(void __iomem *reg);
> +	void (*write_reg)(void __iomem *reg, unsigned long data);
> +
> +	void __iomem *reg_dat;
> +	void __iomem *reg_set;
> +	void __iomem *reg_clr;
> +	void __iomem *reg_dir;
> +
> +	/* Number of bits (GPIOs): <register width> * 8. */
> +	int bits;
> +
> +	/*
> +	 * Some GPIO controllers work with the big-endian bits notation,
> +	 * e.g. in a 8-bits register, GPIO7 is the least significant bit.
> +	 */
> +	unsigned long (*pin2mask)(struct bgpio_chip *bgc, unsigned int pin);
> +
> +	/*
> +	 * Used to lock bgpio_chip->data. Also, this is needed to keep
> +	 * shadowed and real data registers writes together.
> +	 */
> +	spinlock_t lock;
> +
> +	/* Shadowed data register to clear/set bits safely. */
> +	unsigned long data;
> +
> +	/* Shadowed direction registers to clear/set direction safely. */
> +	unsigned long dir;
> +};
> +
> +static inline struct bgpio_chip *to_bgpio_chip(struct gpio_chip *gc)
> +{
> +	return container_of(gc, struct bgpio_chip, gc);
> +}
> +
> +int __devexit bgpio_remove(struct bgpio_chip *bgc);
> +int __devinit bgpio_init(struct bgpio_chip *bgc,
> +			 struct device *dev,
> +			 unsigned long sz,
> +			 void __iomem *dat,
> +			 void __iomem *set,
> +			 void __iomem *clr,
> +			 void __iomem *dirout,
> +			 void __iomem *dirin,
> +			 bool big_endian);
> +
>  #endif /* __BASIC_MMIO_GPIO_H */
> -- 
> 1.7.4.4
> 
