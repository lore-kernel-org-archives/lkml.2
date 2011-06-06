Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1FFHrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:47:33 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:53479 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab1FFHrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:47:32 -0400
Date: Mon, 6 Jun 2011 01:47:31 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: Re: [PATCH v4 2/3] gpio/mxs: Change gpio-mxs into an upstanding gpio
 driver
Message-ID: <20110606074731.GB10410@ponder.secretlab.ca>
References: <1307289545-6993-1-git-send-email-shawn.guo@linaro.org>
 <1307289545-6993-3-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307289545-6993-3-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 11:59:04PM +0800, Shawn Guo wrote:
> The patch makes necessary changes on gpio-mxs as below to turn it
> into an upstanding gpio driver.
> 
>  * Clean up the gpio port definition stuff
> 
>  * Use readl/writel to replace mach-specific accessors
>    __raw_readl/__raw_writel
> 
>  * Change mxs_gpio_init into mxs_gpio_probe function
> 
> And it then migrates mach-mxs to the updated driver by adding
> corresponding platform devices.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks

g.

> ---
>  arch/arm/mach-mxs/devices.c                     |   11 ++
>  arch/arm/mach-mxs/devices/Makefile              |    1 +
>  arch/arm/mach-mxs/devices/platform-gpio-mxs.c   |   53 ++++++
>  arch/arm/mach-mxs/include/mach/devices-common.h |    2 +
>  arch/arm/mach-mxs/mm-mx23.c                     |    1 -
>  arch/arm/mach-mxs/mm-mx28.c                     |    1 -
>  drivers/gpio/gpio-mxs.c                         |  216 +++++++++++++----------
>  7 files changed, 191 insertions(+), 94 deletions(-)
>  create mode 100644 arch/arm/mach-mxs/devices/platform-gpio-mxs.c
> 
> diff --git a/arch/arm/mach-mxs/devices.c b/arch/arm/mach-mxs/devices.c
> index cfdb6b2..fe3e847 100644
> --- a/arch/arm/mach-mxs/devices.c
> +++ b/arch/arm/mach-mxs/devices.c
> @@ -88,3 +88,14 @@ int __init mxs_add_amba_device(const struct amba_device *dev)
>  
>  	return amba_device_register(adev, &iomem_resource);
>  }
> +
> +struct device mxs_apbh_bus = {
> +	.init_name	= "mxs_apbh",
> +	.parent         = &platform_bus,
> +};
> +
> +static int __init mxs_device_init(void)
> +{
> +	return device_register(&mxs_apbh_bus);
> +}
> +core_initcall(mxs_device_init);
> diff --git a/arch/arm/mach-mxs/devices/Makefile b/arch/arm/mach-mxs/devices/Makefile
> index 324f282..351915c 100644
> --- a/arch/arm/mach-mxs/devices/Makefile
> +++ b/arch/arm/mach-mxs/devices/Makefile
> @@ -6,4 +6,5 @@ obj-$(CONFIG_MXS_HAVE_PLATFORM_FLEXCAN) += platform-flexcan.o
>  obj-$(CONFIG_MXS_HAVE_PLATFORM_MXS_I2C) += platform-mxs-i2c.o
>  obj-$(CONFIG_MXS_HAVE_PLATFORM_MXS_MMC) += platform-mxs-mmc.o
>  obj-$(CONFIG_MXS_HAVE_PLATFORM_MXS_PWM) += platform-mxs-pwm.o
> +obj-y += platform-gpio-mxs.o
>  obj-$(CONFIG_MXS_HAVE_PLATFORM_MXSFB) += platform-mxsfb.o
> diff --git a/arch/arm/mach-mxs/devices/platform-gpio-mxs.c b/arch/arm/mach-mxs/devices/platform-gpio-mxs.c
> new file mode 100644
> index 0000000..ed0885e
> --- /dev/null
> +++ b/arch/arm/mach-mxs/devices/platform-gpio-mxs.c
> @@ -0,0 +1,53 @@
> +/*
> + * Copyright 2011 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it under
> + * the terms of the GNU General Public License version 2 as published by the
> + * Free Software Foundation.
> + */
> +#include <linux/compiler.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +
> +#include <mach/mx23.h>
> +#include <mach/mx28.h>
> +#include <mach/devices-common.h>
> +
> +struct platform_device *__init mxs_add_gpio(
> +	int id, resource_size_t iobase, int irq)
> +{
> +	struct resource res[] = {
> +		{
> +			.start = iobase,
> +			.end = iobase + SZ_8K - 1,
> +			.flags = IORESOURCE_MEM,
> +		}, {
> +			.start = irq,
> +			.end = irq,
> +			.flags = IORESOURCE_IRQ,
> +		},
> +	};
> +
> +	return platform_device_register_resndata(&mxs_apbh_bus,
> +			"gpio-mxs", id, res, ARRAY_SIZE(res), NULL, 0);
> +}
> +
> +static int __init mxs_add_mxs_gpio(void)
> +{
> +	if (cpu_is_mx23()) {
> +		mxs_add_gpio(0, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO0);
> +		mxs_add_gpio(1, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO1);
> +		mxs_add_gpio(2, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO2);
> +	}
> +
> +	if (cpu_is_mx28()) {
> +		mxs_add_gpio(0, MX28_PINCTRL_BASE_ADDR, MX28_INT_GPIO0);
> +		mxs_add_gpio(1, MX28_PINCTRL_BASE_ADDR, MX28_INT_GPIO1);
> +		mxs_add_gpio(2, MX28_PINCTRL_BASE_ADDR, MX28_INT_GPIO2);
> +		mxs_add_gpio(3, MX28_PINCTRL_BASE_ADDR, MX28_INT_GPIO3);
> +		mxs_add_gpio(4, MX28_PINCTRL_BASE_ADDR, MX28_INT_GPIO4);
> +	}
> +
> +	return 0;
> +}
> +postcore_initcall(mxs_add_mxs_gpio);
> diff --git a/arch/arm/mach-mxs/include/mach/devices-common.h b/arch/arm/mach-mxs/include/mach/devices-common.h
> index 7a37469..812d7a8 100644
> --- a/arch/arm/mach-mxs/include/mach/devices-common.h
> +++ b/arch/arm/mach-mxs/include/mach/devices-common.h
> @@ -11,6 +11,8 @@
>  #include <linux/init.h>
>  #include <linux/amba/bus.h>
>  
> +extern struct device mxs_apbh_bus;
> +
>  struct platform_device *mxs_add_platform_device_dmamask(
>  		const char *name, int id,
>  		const struct resource *res, unsigned int num_resources,
> diff --git a/arch/arm/mach-mxs/mm-mx23.c b/arch/arm/mach-mxs/mm-mx23.c
> index 5148cd6..1b2345a 100644
> --- a/arch/arm/mach-mxs/mm-mx23.c
> +++ b/arch/arm/mach-mxs/mm-mx23.c
> @@ -41,5 +41,4 @@ void __init mx23_map_io(void)
>  void __init mx23_init_irq(void)
>  {
>  	icoll_init_irq();
> -	mx23_register_gpios();
>  }
> diff --git a/arch/arm/mach-mxs/mm-mx28.c b/arch/arm/mach-mxs/mm-mx28.c
> index 7e4cea3..b6e18dd 100644
> --- a/arch/arm/mach-mxs/mm-mx28.c
> +++ b/arch/arm/mach-mxs/mm-mx28.c
> @@ -41,5 +41,4 @@ void __init mx28_map_io(void)
>  void __init mx28_init_irq(void)
>  {
>  	icoll_init_irq();
> -	mx28_register_gpios();
>  }
> diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
> index bac7b6b..6fd9f01 100644
> --- a/drivers/gpio/gpio-mxs.c
> +++ b/drivers/gpio/gpio-mxs.c
> @@ -25,13 +25,13 @@
>  #include <linux/io.h>
>  #include <linux/irq.h>
>  #include <linux/gpio.h>
> -#include <mach/mx23.h>
> -#include <mach/mx28.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <mach/mxs.h>
>  #include <mach/gpio-mxs.h>
> -#include <asm-generic/bug.h>
>  
> -static struct mxs_gpio_port *mxs_gpio_ports;
> -static int gpio_table_size;
> +#define MXS_SET		0x4
> +#define MXS_CLR		0x8
>  
>  #define PINCTRL_DOUT(n)		((cpu_is_mx23() ? 0x0500 : 0x0700) + (n) * 0x10)
>  #define PINCTRL_DIN(n)		((cpu_is_mx23() ? 0x0600 : 0x0900) + (n) * 0x10)
> @@ -53,36 +53,42 @@ static int gpio_table_size;
>  
>  static void clear_gpio_irqstatus(struct mxs_gpio_port *port, u32 index)
>  {
> -	__mxs_clrl(1 << index, port->base + PINCTRL_IRQSTAT(port->id));
> +	writel(1 << index, port->base + PINCTRL_IRQSTAT(port->id) + MXS_CLR);
>  }
>  
>  static void set_gpio_irqenable(struct mxs_gpio_port *port, u32 index,
>  				int enable)
>  {
>  	if (enable) {
> -		__mxs_setl(1 << index, port->base + PINCTRL_IRQEN(port->id));
> -		__mxs_setl(1 << index, port->base + PINCTRL_PIN2IRQ(port->id));
> +		writel(1 << index,
> +			port->base + PINCTRL_IRQEN(port->id) + MXS_SET);
> +		writel(1 << index,
> +			port->base + PINCTRL_PIN2IRQ(port->id) + MXS_SET);
>  	} else {
> -		__mxs_clrl(1 << index, port->base + PINCTRL_IRQEN(port->id));
> +		writel(1 << index,
> +			port->base + PINCTRL_IRQEN(port->id) + MXS_CLR);
>  	}
>  }
>  
>  static void mxs_gpio_ack_irq(struct irq_data *d)
>  {
> +	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
>  	u32 gpio = irq_to_gpio(d->irq);
> -	clear_gpio_irqstatus(&mxs_gpio_ports[gpio / 32], gpio & 0x1f);
> +	clear_gpio_irqstatus(port, gpio & 0x1f);
>  }
>  
>  static void mxs_gpio_mask_irq(struct irq_data *d)
>  {
> +	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
>  	u32 gpio = irq_to_gpio(d->irq);
> -	set_gpio_irqenable(&mxs_gpio_ports[gpio / 32], gpio & 0x1f, 0);
> +	set_gpio_irqenable(port, gpio & 0x1f, 0);
>  }
>  
>  static void mxs_gpio_unmask_irq(struct irq_data *d)
>  {
> +	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
>  	u32 gpio = irq_to_gpio(d->irq);
> -	set_gpio_irqenable(&mxs_gpio_ports[gpio / 32], gpio & 0x1f, 1);
> +	set_gpio_irqenable(port, gpio & 0x1f, 1);
>  }
>  
>  static int mxs_gpio_get(struct gpio_chip *chip, unsigned offset);
> @@ -91,7 +97,7 @@ static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
>  {
>  	u32 gpio = irq_to_gpio(d->irq);
>  	u32 pin_mask = 1 << (gpio & 31);
> -	struct mxs_gpio_port *port = &mxs_gpio_ports[gpio / 32];
> +	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
>  	void __iomem *pin_addr;
>  	int edge;
>  
> @@ -115,16 +121,16 @@ static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
>  	/* set level or edge */
>  	pin_addr = port->base + PINCTRL_IRQLEV(port->id);
>  	if (edge & GPIO_INT_LEV_MASK)
> -		__mxs_setl(pin_mask, pin_addr);
> +		writel(pin_mask, pin_addr + MXS_SET);
>  	else
> -		__mxs_clrl(pin_mask, pin_addr);
> +		writel(pin_mask, pin_addr + MXS_CLR);
>  
>  	/* set polarity */
>  	pin_addr = port->base + PINCTRL_IRQPOL(port->id);
>  	if (edge & GPIO_INT_POL_MASK)
> -		__mxs_setl(pin_mask, pin_addr);
> +		writel(pin_mask, pin_addr + MXS_SET);
>  	else
> -		__mxs_clrl(pin_mask, pin_addr);
> +		writel(pin_mask, pin_addr + MXS_CLR);
>  
>  	clear_gpio_irqstatus(port, gpio & 0x1f);
>  
> @@ -135,13 +141,13 @@ static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
>  static void mxs_gpio_irq_handler(u32 irq, struct irq_desc *desc)
>  {
>  	u32 irq_stat;
> -	struct mxs_gpio_port *port = (struct mxs_gpio_port *)irq_get_handler_data(irq);
> +	struct mxs_gpio_port *port = irq_get_handler_data(irq);
>  	u32 gpio_irq_no_base = port->virtual_irq_start;
>  
>  	desc->irq_data.chip->irq_ack(&desc->irq_data);
>  
> -	irq_stat = __raw_readl(port->base + PINCTRL_IRQSTAT(port->id)) &
> -			__raw_readl(port->base + PINCTRL_IRQEN(port->id));
> +	irq_stat = readl(port->base + PINCTRL_IRQSTAT(port->id)) &
> +			readl(port->base + PINCTRL_IRQEN(port->id));
>  
>  	while (irq_stat != 0) {
>  		int irqoffset = fls(irq_stat) - 1;
> @@ -163,7 +169,7 @@ static int mxs_gpio_set_wake_irq(struct irq_data *d, unsigned int enable)
>  {
>  	u32 gpio = irq_to_gpio(d->irq);
>  	u32 gpio_idx = gpio & 0x1f;
> -	struct mxs_gpio_port *port = &mxs_gpio_ports[gpio / 32];
> +	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
>  
>  	if (enable) {
>  		if (port->irq_high && (gpio_idx >= 16))
> @@ -197,9 +203,9 @@ static void mxs_set_gpio_direction(struct gpio_chip *chip, unsigned offset,
>  	void __iomem *pin_addr = port->base + PINCTRL_DOE(port->id);
>  
>  	if (dir)
> -		__mxs_setl(1 << offset, pin_addr);
> +		writel(1 << offset, pin_addr + MXS_SET);
>  	else
> -		__mxs_clrl(1 << offset, pin_addr);
> +		writel(1 << offset, pin_addr + MXS_CLR);
>  }
>  
>  static int mxs_gpio_get(struct gpio_chip *chip, unsigned offset)
> @@ -207,7 +213,7 @@ static int mxs_gpio_get(struct gpio_chip *chip, unsigned offset)
>  	struct mxs_gpio_port *port =
>  		container_of(chip, struct mxs_gpio_port, chip);
>  
> -	return (__raw_readl(port->base + PINCTRL_DIN(port->id)) >> offset) & 1;
> +	return (readl(port->base + PINCTRL_DIN(port->id)) >> offset) & 1;
>  }
>  
>  static void mxs_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> @@ -217,9 +223,9 @@ static void mxs_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
>  	void __iomem *pin_addr = port->base + PINCTRL_DOUT(port->id);
>  
>  	if (value)
> -		__mxs_setl(1 << offset, pin_addr);
> +		writel(1 << offset, pin_addr + MXS_SET);
>  	else
> -		__mxs_clrl(1 << offset, pin_addr);
> +		writel(1 << offset, pin_addr + MXS_CLR);
>  }
>  
>  static int mxs_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> @@ -244,87 +250,113 @@ static int mxs_gpio_direction_output(struct gpio_chip *chip,
>  	return 0;
>  }
>  
> -int __init mxs_gpio_init(struct mxs_gpio_port *port, int cnt)
> +static int __devinit mxs_gpio_probe(struct platform_device *pdev)
>  {
> -	int i, j;
> +	static void __iomem *base;
> +	struct mxs_gpio_port *port;
> +	struct resource *iores = NULL;
> +	int err, i;
> +
> +	port = kzalloc(sizeof(struct mxs_gpio_port), GFP_KERNEL);
> +	if (!port)
> +		return -ENOMEM;
> +
> +	port->id = pdev->id;
> +	port->virtual_irq_start = MXS_GPIO_IRQ_START + port->id * 32;
> +
> +	/*
> +	 * map memory region only once, as all the gpio ports
> +	 * share the same one
> +	 */
> +	if (!base) {
> +		iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +		if (!iores) {
> +			err = -ENODEV;
> +			goto out_kfree;
> +		}
>  
> -	/* save for local usage */
> -	mxs_gpio_ports = port;
> -	gpio_table_size = cnt;
> +		if (!request_mem_region(iores->start, resource_size(iores),
> +					pdev->name)) {
> +			err = -EBUSY;
> +			goto out_kfree;
> +		}
>  
> -	pr_info("MXS GPIO hardware\n");
> +		base = ioremap(iores->start, resource_size(iores));
> +		if (!base) {
> +			err = -ENOMEM;
> +			goto out_release_mem;
> +		}
> +	}
> +	port->base = base;
>  
> -	for (i = 0; i < cnt; i++) {
> -		/* disable the interrupt and clear the status */
> -		__raw_writel(0, port[i].base + PINCTRL_PIN2IRQ(i));
> -		__raw_writel(0, port[i].base + PINCTRL_IRQEN(i));
> +	port->irq = platform_get_irq(pdev, 0);
> +	if (port->irq < 0) {
> +		err = -EINVAL;
> +		goto out_iounmap;
> +	}
>  
> -		/* clear address has to be used to clear IRQSTAT bits */
> -		__mxs_clrl(~0U, port[i].base + PINCTRL_IRQSTAT(i));
> +	/* disable the interrupt and clear the status */
> +	writel(0, port->base + PINCTRL_PIN2IRQ(port->id));
> +	writel(0, port->base + PINCTRL_IRQEN(port->id));
>  
> -		for (j = port[i].virtual_irq_start;
> -			j < port[i].virtual_irq_start + 32; j++) {
> -			irq_set_chip_and_handler(j, &gpio_irq_chip,
> -						 handle_level_irq);
> -			set_irq_flags(j, IRQF_VALID);
> -		}
> +	/* clear address has to be used to clear IRQSTAT bits */
> +	writel(~0U, port->base + PINCTRL_IRQSTAT(port->id) + MXS_CLR);
>  
> -		/* setup one handler for each entry */
> -		irq_set_chained_handler(port[i].irq, mxs_gpio_irq_handler);
> -		irq_set_handler_data(port[i].irq, &port[i]);
> -
> -		/* register gpio chip */
> -		port[i].chip.direction_input = mxs_gpio_direction_input;
> -		port[i].chip.direction_output = mxs_gpio_direction_output;
> -		port[i].chip.get = mxs_gpio_get;
> -		port[i].chip.set = mxs_gpio_set;
> -		port[i].chip.to_irq = mxs_gpio_to_irq;
> -		port[i].chip.base = i * 32;
> -		port[i].chip.ngpio = 32;
> -
> -		/* its a serious configuration bug when it fails */
> -		BUG_ON(gpiochip_add(&port[i].chip) < 0);
> +	for (i = port->virtual_irq_start;
> +		i < port->virtual_irq_start + 32; i++) {
> +		irq_set_chip_and_handler(i, &gpio_irq_chip,
> +					 handle_level_irq);
> +		set_irq_flags(i, IRQF_VALID);
> +		irq_set_chip_data(i, port);
>  	}
>  
> -	return 0;
> -}
> +	/* setup one handler for each entry */
> +	irq_set_chained_handler(port->irq, mxs_gpio_irq_handler);
> +	irq_set_handler_data(port->irq, port);
>  
> -#define MX23_GPIO_BASE	MX23_IO_ADDRESS(MX23_PINCTRL_BASE_ADDR)
> -#define MX28_GPIO_BASE	MX28_IO_ADDRESS(MX28_PINCTRL_BASE_ADDR)
> +	/* register gpio chip */
> +	port->chip.direction_input = mxs_gpio_direction_input;
> +	port->chip.direction_output = mxs_gpio_direction_output;
> +	port->chip.get = mxs_gpio_get;
> +	port->chip.set = mxs_gpio_set;
> +	port->chip.to_irq = mxs_gpio_to_irq;
> +	port->chip.base = port->id * 32;
> +	port->chip.ngpio = 32;
>  
> -#define DEFINE_MXS_GPIO_PORT(_base, _irq, _id)				\
> -	{								\
> -		.chip.label = "gpio-" #_id,				\
> -		.id = _id,						\
> -		.irq = _irq,						\
> -		.base = _base,						\
> -		.virtual_irq_start = MXS_GPIO_IRQ_START + (_id) * 32,	\
> -	}
> +	err = gpiochip_add(&port->chip);
> +	if (err)
> +		goto out_iounmap;
>  
> -#ifdef CONFIG_SOC_IMX23
> -static struct mxs_gpio_port mx23_gpio_ports[] = {
> -	DEFINE_MXS_GPIO_PORT(MX23_GPIO_BASE, MX23_INT_GPIO0, 0),
> -	DEFINE_MXS_GPIO_PORT(MX23_GPIO_BASE, MX23_INT_GPIO1, 1),
> -	DEFINE_MXS_GPIO_PORT(MX23_GPIO_BASE, MX23_INT_GPIO2, 2),
> -};
> +	return 0;
>  
> -int __init mx23_register_gpios(void)
> -{
> -	return mxs_gpio_init(mx23_gpio_ports, ARRAY_SIZE(mx23_gpio_ports));
> +out_iounmap:
> +	if (iores)
> +		iounmap(port->base);
> +out_release_mem:
> +	if (iores)
> +		release_mem_region(iores->start, resource_size(iores));
> +out_kfree:
> +	kfree(port);
> +	dev_info(&pdev->dev, "%s failed with errno %d\n", __func__, err);
> +	return err;
>  }
> -#endif
> -
> -#ifdef CONFIG_SOC_IMX28
> -static struct mxs_gpio_port mx28_gpio_ports[] = {
> -	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO0, 0),
> -	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO1, 1),
> -	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO2, 2),
> -	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO3, 3),
> -	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO4, 4),
> +
> +static struct platform_driver mxs_gpio_driver = {
> +	.driver		= {
> +		.name	= "gpio-mxs",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= mxs_gpio_probe,
>  };
>  
> -int __init mx28_register_gpios(void)
> +static int __init mxs_gpio_init(void)
>  {
> -	return mxs_gpio_init(mx28_gpio_ports, ARRAY_SIZE(mx28_gpio_ports));
> +	return platform_driver_register(&mxs_gpio_driver);
>  }
> -#endif
> +postcore_initcall(mxs_gpio_init);
> +
> +MODULE_AUTHOR("Freescale Semiconductor, "
> +	      "Daniel Mack <danielncaiaq.de>, "
> +	      "Juergen Beisert <kernel@pengutronix.de>");
> +MODULE_DESCRIPTION("Freescale MXS GPIO");
> +MODULE_LICENSE("GPL");
> -- 
> 1.7.4.1
> 
