Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab2CBJcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:32:05 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40409 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab2CBJb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:31:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of grant.likely@secretlab.ca designates 10.68.216.138 as permitted sender) smtp.mail=grant.likely@secretlab.ca
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2 2/2] gpio: add STA2X11 GPIO block
To: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org
Cc: giancarlo.asnaghi@st.com, alan@linux.intel.com, sameo@linux.intel.com,
        linus.walleij@stericsson.com
In-Reply-To: <5ad22021512895427a9ddee29018f5beb31a26dd.1329396583.git.rubini@gnudd.com>
References: <cover.1329396583.git.rubini@gnudd.com> <5ad22021512895427a9ddee29018f5beb31a26dd.1329396583.git.rubini@gnudd.com>
Date: Fri, 02 Mar 2012 00:48:00 -0700
Message-Id: <20120302074800.C2F973E17BE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 14:00:52 +0100, Alessandro Rubini <rubini@gnudd.com> wrote:
> This introduces 128 gpio bits (for each PCI device installed) with
> working interrupt support.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Cc: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/gpio/Kconfig        |    9 +
>  drivers/gpio/Makefile       |    1 +
>  drivers/gpio/gpio-sta2x11.c |  443 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 453 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/gpio-sta2x11.c
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index dbb1909..dbae9c2 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -149,6 +149,14 @@ config GPIO_PXA
>  	help
>  	  Say yes here to support the PXA GPIO device
>  
> +config GPIO_STA2X11
> +	bool "STA2x11/ConneXt GPIO support"
> +	depends on MFD_STA2X11
> +	select GENERIC_IRQ_CHIP
> +	help
> +	  Say yes here to support the STA2x11/ConneXt GPIO device.
> +	  The GPIO module has 128 GPIO pins with alternate functions.
> +
>  config GPIO_XILINX
>  	bool "Xilinx GPIO support"
>  	depends on PPC_OF || MICROBLAZE
> @@ -503,4 +511,5 @@ config GPIO_TPS65910
>  	help
>  	  Select this option to enable GPIO driver for the TPS65910
>  	  chip family.
> +
>  endif

Unrelated whitespace change; please remove from patch

> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 593bdcd..f72313d 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -47,6 +47,7 @@ obj-$(CONFIG_PLAT_SAMSUNG)	+= gpio-samsung.o
>  obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
>  obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
>  obj-$(CONFIG_GPIO_SODAVILLE)	+= gpio-sodaville.o
> +obj-$(CONFIG_GPIO_STA2X11)	+= gpio-sta2x11.o
>  obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
>  obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
>  obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
> diff --git a/drivers/gpio/gpio-sta2x11.c b/drivers/gpio/gpio-sta2x11.c
> new file mode 100644
> index 0000000..f1885f4
> --- /dev/null
> +++ b/drivers/gpio/gpio-sta2x11.c
> @@ -0,0 +1,443 @@
> +/*
> + * STMicroelectronics ConneXt (STA2X11) GPIO driver
> + *
> + * Copyright 2012 ST Microelectronics (Alessandro Rubini)
> + * Based on gpio-ml-ioh.c, Copyright 2010 OKI Semiconductors Ltd.
> + * Also based on previous sta2x11 work, Copyright 2011 Wind River Systems, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> + * See the GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/gpio.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/pci.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/sta2x11-mfd.h>
> +
> +struct gsta_regs {
> +	u32 dat;		/* 0x00 */
> +	u32 dats;
> +	u32 datc;
> +	u32 pdis;
> +	u32 dir;		/* 0x10 */
> +	u32 dirs;
> +	u32 dirc;
> +	u32 unused_1c;
> +	u32 afsela;		/* 0x20 */
> +	u32 unused_24[7];
> +	u32 rimsc;		/* 0x40 */
> +	u32 fimsc;
> +	u32 is;
> +	u32 ic;
> +};
> +
> +struct gsta_gpio {
> +	spinlock_t		lock;
> +	struct device		*dev;
> +	void __iomem		*reg_base;
> +	struct gsta_regs	*regs[GSTA_NR_BLOCKS];

__iomem?

> +	struct gpio_chip	gpio;
> +	int			irq_base;
> +	/* FIXME: save the whole config here (AF, ...) */
> +	unsigned		irq_type[GSTA_NR_GPIO];
> +};
> +
> +static inline struct gsta_regs __iomem *__regs(struct gsta_gpio *chip, int nr)
> +{
> +	return chip->regs[nr / GSTA_GPIO_PER_BLOCK];
> +}
> +
> +static inline u32 __bit(int nr)
> +{
> +	return 1U << (nr % GSTA_GPIO_PER_BLOCK);
> +}
> +
> +/*
> + * gpio methods
> + */
> +
> +static void gsta_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
> +{
> +	struct gsta_gpio *chip = container_of(gpio, struct gsta_gpio, gpio);
> +	struct gsta_regs __iomem *regs = __regs(chip, nr);
> +	u32 bit = __bit(nr);
> +
> +	if (val)
> +		writel(bit, &regs->dats);
> +	else
> +		writel(bit, &regs->datc);
> +}
> +
> +static int gsta_gpio_get(struct gpio_chip *gpio, unsigned nr)
> +{
> +	struct gsta_gpio *chip = container_of(gpio, struct gsta_gpio, gpio);
> +	struct gsta_regs __iomem *regs = __regs(chip, nr);
> +	u32 bit = __bit(nr);
> +
> +	return readl(&regs->dat) & bit;
> +}
> +
> +static int gsta_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
> +				      int val)
> +{
> +	struct gsta_gpio *chip = container_of(gpio, struct gsta_gpio, gpio);
> +	struct gsta_regs __iomem *regs = __regs(chip, nr);
> +	u32 bit = __bit(nr);
> +
> +	writel(bit, &regs->dirs);
> +	/* Data register after direction, otherwise pullup/down is selected */
> +	if (val)
> +		writel(bit, &regs->dats);
> +	else
> +		writel(bit, &regs->datc);
> +	return 0;
> +}
> +
> +static int gsta_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
> +{
> +	struct gsta_gpio *chip = container_of(gpio, struct gsta_gpio, gpio);
> +	struct gsta_regs __iomem *regs = __regs(chip, nr);
> +	u32 bit = __bit(nr);
> +
> +	writel(bit, &regs->dirc);
> +	return 0;

These are plain-vanilla gpio accessors.  Can you use the gpio-generic.c
library?

> +}
> +
> +static int gsta_gpio_to_irq(struct gpio_chip *gpio, unsigned offset)
> +{
> +	struct gsta_gpio *chip = container_of(gpio, struct gsta_gpio, gpio);
> +	return chip->irq_base + offset;
> +}
> +
> +static void gsta_gpio_setup(struct gsta_gpio *chip) /* called from probe */
> +{
> +	struct gpio_chip *gpio = &chip->gpio;
> +
> +	/*
> +	 * ARCH_NR_GPIOS is currently 256 and dynamic allocation starts
> +	 * from the end. However, for compatiility, we need the first
> +	 * ConneXt device to start from gpio 0: it's the main chipset
> +	 * on most boards so documents and drivers assume gpio0..gpio127
> +	 */
> +	static int gpio_base;
> +
> +	gpio->label = dev_name(chip->dev);
> +	gpio->owner = THIS_MODULE;
> +	gpio->direction_input = gsta_gpio_direction_input;
> +	gpio->get = gsta_gpio_get;
> +	gpio->direction_output = gsta_gpio_direction_output;
> +	gpio->set = gsta_gpio_set;
> +	gpio->dbg_show = NULL;
> +	gpio->base = gpio_base;
> +	gpio->base = 0;
> +	gpio->ngpio = GSTA_NR_GPIO;
> +	gpio->can_sleep = 0;
> +	gpio->to_irq = gsta_gpio_to_irq;
> +
> +
> +	/*
> +	 * After the first device, turn to dynamic gpio numbers.
> +	 * With ARCH_NR_GPIOS = 256 we can fit for example two steval cards
> +	 */
> +	if (!gpio_base)
> +		gpio_base = 1;
> +}
> +
> +/*
> + * Special method: alternate functions and pullup/pulldown. This will
> + * need to be exported to other drivers, adding a way to retrieve
> + * the gsta_gpio structure from their own pci device
> + */
> +void gsta_set_config(struct gsta_gpio *chip, int nr, unsigned cfg)
> +{
> +	struct gsta_regs __iomem *regs = __regs(chip, nr);
> +	unsigned long flags;
> +	u32 bit = __bit(nr);
> +	u32 val;
> +	int err = 0;
> +
> +	printk("%s: %p %i %i\n", __func__, chip, nr, cfg);

pr_info()

> +
> +	if (cfg == PINMUX_TYPE_NONE)
> +		return;
> +
> +	/* Alternate function or not? */
> +	spin_lock_irqsave(&chip->lock, flags);
> +	val = readl(&regs->afsela);
> +	if (cfg == PINMUX_TYPE_FUNCTION)
> +		val |= bit;
> +	else
> +		val &= ~bit;
> +	writel(val | bit, &regs->afsela);
> +	if (cfg == PINMUX_TYPE_FUNCTION) {
> +		spin_unlock_irqrestore(&chip->lock, flags);
> +		return;
> +	}
> +
> +	/* not alternate function: set details */
> +	switch(cfg) {
> +	case PINMUX_TYPE_OUTPUT_LOW:
> +		writel(bit, &regs->dirs);
> +		writel(bit, &regs->datc);
> +		break;
> +	case PINMUX_TYPE_OUTPUT_HIGH:
> +		writel(bit, &regs->dirs);
> +		writel(bit, &regs->dats);
> +		break;
> +	case PINMUX_TYPE_INPUT:
> +		writel(bit, &regs->dirc);
> +		val = readl(&regs->pdis) | bit;
> +		writel (val, &regs->pdis);
> +		break;
> +	case PINMUX_TYPE_INPUT_PULLUP:
> +		writel(bit, &regs->dirc);
> +		val = readl(&regs->pdis) &~ bit;
> +		writel (val, &regs->pdis);
> +		writel(bit, &regs->dats);
> +		break;
> +	case PINMUX_TYPE_INPUT_PULLDOWN:
> +		writel(bit, &regs->dirc);
> +		val = readl(&regs->pdis) &~ bit;
> +		writel (val, &regs->pdis);
> +		writel(bit, &regs->datc);
> +		break;
> +	default:
> +		err = 1;
> +	}
> +	spin_unlock_irqrestore(&chip->lock, flags);
> +	if (err)
> +		pr_err("%s: chip %p, pin %i, cfg %i is invalid\n",
> +		       __func__, chip, nr, cfg);
> +}
> +
> +/*
> + * Irq methods
> + */
> +
> +static void gsta_irq_disable(struct irq_data *data)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(data);
> +	struct gsta_gpio *chip = gc->private;
> +	int nr = data->irq - chip->irq_base;

we have data->hwirq now.  Use it.  In fact, you should look at using irqdomain to manage the
hwirq to linuxirq number mapping for you.  irqdomain will be merged for v3.4.

> +	struct gsta_regs __iomem *regs = __regs(chip, nr);
> +	u32 bit = __bit(nr);
> +	u32 val;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&chip->lock, flags);
> +	if (chip->irq_type[nr] & IRQ_TYPE_EDGE_RISING) {
> +		val = readl(&regs->rimsc) & ~bit;
> +		writel(val, &regs->rimsc);
> +	}
> +	if (chip->irq_type[nr] & IRQ_TYPE_EDGE_FALLING) {
> +		val = readl(&regs->fimsc) & ~bit;
> +		writel(val, &regs->fimsc);
> +	}
> +	spin_unlock_irqrestore(&chip->lock, flags);
> +	return;
> +}
> +
> +static void gsta_irq_enable(struct irq_data *data)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(data);
> +	struct gsta_gpio *chip = gc->private;
> +	int nr = data->irq - chip->irq_base;
> +	struct gsta_regs __iomem *regs = __regs(chip, nr);
> +	u32 bit = __bit(nr);
> +	u32 val;
> +	int type;
> +	unsigned long flags;
> +
> +	type = chip->irq_type[nr];
> +
> +	spin_lock_irqsave(&chip->lock, flags);
> +	val = readl(&regs->rimsc);
> +	if (type & IRQ_TYPE_EDGE_RISING)
> +		writel(val | bit, &regs->rimsc);
> +	else
> +		writel(val & ~bit, &regs->rimsc);
> +	val = readl(&regs->rimsc);
> +	if (type & IRQ_TYPE_EDGE_FALLING)
> +		writel(val | bit, &regs->fimsc);
> +	else
> +		writel(val & ~bit, &regs->fimsc);
> +	spin_unlock_irqrestore(&chip->lock, flags);
> +	return;
> +}
> +
> +static int gsta_irq_type(struct irq_data *d, unsigned int type)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct gsta_gpio *chip = gc->private;
> +	int nr = d->irq - chip->irq_base;
> +
> +	/* We only support edge interrupts */
> +	if (!(type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))) {
> +		pr_debug("%s: unsupported type 0x%x\n", __func__, type);
> +		return -EINVAL;
> +	}
> +
> +	chip->irq_type[nr] = type; /* used for enable/disable */
> +
> +	gsta_irq_enable(d);
> +	return 0;
> +}
> +
> +static irqreturn_t gsta_gpio_handler(int irq, void *dev_id)
> +{
> +	struct gsta_gpio *chip = dev_id;
> +	struct gsta_regs __iomem *regs;
> +	u32 is;
> +	int i, nr, base;
> +	irqreturn_t ret = IRQ_NONE;
> +
> +	for (i = 0; i < GSTA_NR_BLOCKS; i++) {
> +		regs = chip->regs[i];
> +		base = chip->irq_base + i * GSTA_GPIO_PER_BLOCK;
> +		while ((is = readl(&regs->is))) {
> +			nr = __ffs(is);
> +			irq = base + nr;
> +			generic_handle_irq(irq);
> +			writel(1 << nr, &regs->ic);
> +			ret = IRQ_HANDLED;
> +		}
> +	}
> +	return ret;
> +}
> +
> +static __devinit void gsta_alloc_irq_chip(struct gsta_gpio *chip)
> +{
> +	struct irq_chip_generic *gc;
> +	struct irq_chip_type *ct;
> +
> +	gc = irq_alloc_generic_chip(KBUILD_MODNAME, 1, chip->irq_base,
> +				     chip->reg_base, handle_simple_irq);
> +	gc->private = chip;
> +	ct = gc->chip_types;
> +
> +	ct->chip.irq_set_type = gsta_irq_type;
> +	ct->chip.irq_disable = gsta_irq_disable;
> +	ct->chip.irq_enable = gsta_irq_enable;
> +
> +	/* FIXME: this makes at most 32 interrupts. Request 0 by now */
> +	irq_setup_generic_chip(gc, 0 /* IRQ_MSK(GSTA_GPIO_PER_BLOCK) */, 0,
> +			       IRQ_NOREQUEST | IRQ_NOPROBE, 0);
> +
> +	/* Set up all all 128 interrupts: code from setup_generic_chip */
> +	{
> +		struct irq_chip_type *ct = gc->chip_types;
> +		int i, j;
> +		for (j = 0; j < GSTA_NR_GPIO; j++) {
> +			i = chip->irq_base + j;
> +			irq_set_chip_and_handler(i, &ct->chip, ct->handler);
> +			irq_set_chip_data(i, gc);
> +			irq_modify_status(i, IRQ_NOREQUEST | IRQ_NOPROBE, 0);
> +		}
> +		gc->irq_cnt = i - gc->irq_base;
> +	}
> +}
> +
> +/* The platform device used here is instantiated by the MFD device */
> +static int __devinit gsta_probe(struct platform_device *dev)
> +{
> +	int i, err;
> +	struct pci_dev *pdev;
> +	struct sta2x11_gpio_pdata *gpio_pdata;
> +	struct gsta_gpio *chip;
> +	struct resource *res;
> +
> +	pdev = *(struct pci_dev **)(dev->dev.platform_data);
> +	gpio_pdata = dev_get_platdata(&pdev->dev);
> +
> +	if (gpio_pdata == NULL)
> +		dev_err(&dev->dev, "no gpio config\n");
> +	printk("gpio config: %p\n", gpio_pdata);
> +
> +	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
> +	request_mem_region(res->start, resource_size(res), KBUILD_MODNAME);
> +
> +
> +	chip = kzalloc(sizeof(*chip), GFP_KERNEL);

devm_kzalloc() will make this code simpler (don't need to kfree on
error or remove).

> +	chip->dev = &dev->dev;
> +	chip->reg_base = ioremap(res->start, resource_size(res));
> +	chip->irq_base = -1;

This line is meaningless.

> +	for (i = 0; i < GSTA_NR_BLOCKS; i++) {
> +		chip->regs[i] = chip->reg_base + i * 4096;
> +		/* disable all irqs */
> +		writel(0, &chip->regs[i]->rimsc);
> +		writel(0, &chip->regs[i]->fimsc);
> +		writel(~0, &chip->regs[i]->ic);
> +	}
> +	spin_lock_init(&chip->lock);
> +	gsta_gpio_setup(chip);
> +	for (i = 0; i < GSTA_NR_GPIO; i++)
> +		     gsta_set_config(chip, i, gpio_pdata->pinconfig[i]);
> +	err = gpiochip_add(&chip->gpio);
> +	if (err < 0) {
> +		dev_err(&dev->dev, "sta2x11 gpio: Can't register (%i)\n",
> +			-err);
> +		kfree(chip);
> +		return err;
> +	}
> +	/* 384 was used in previous code: be compatible for other drivers */
> +	err = irq_alloc_descs(-1, 384, GSTA_NR_GPIO, NUMA_NO_NODE);

That's a lot of irqs.  Will they all be used?  How do other drivers
determine which irq number to use (is it statically assigned, or is there
a dynamic mechanism)?  If only a portion are used, then the irq_domain
linear mapping would be a win here.

> +
> +	if (err < 0) {
> +		dev_warn(&dev->dev, "sta2x11 gpio: Can't get irq base (%i)\n",
> +			 -err);
> +		goto err_out;
> +	}
> +	chip->irq_base = err;
> +	gsta_alloc_irq_chip(chip);
> +
> +	err = request_irq(pdev->irq, gsta_gpio_handler,
> +			     IRQF_SHARED, KBUILD_MODNAME, chip);
> +	if (err < 0) {
> +		dev_err(&dev->dev, "sta2x11 gpio: Can't request irq (%i)\n",
> +			-err);
> +		goto err_out;
> +	}
> +
> +	platform_set_drvdata(dev, chip);
> +	return 0;
> +
> +err_out:
> +	if (chip->irq_base > 0)
> +		irq_free_descs(chip->irq_base, GSTA_NR_GPIO);
> +	kfree(chip);
> +	return err;
> +}
> +
> +static struct platform_driver sta2x11_gpio_platform_driver = {
> +	.driver = {
> +		.name	= "sta2x11-gpio",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe = gsta_probe,
> +};
> +
> +static int __init sta2x11_gpio_init(void)
> +{
> +	return platform_driver_register(&sta2x11_gpio_platform_driver);
> +}
> +
> +module_init(sta2x11_gpio_init);

module_platform_driver()

> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("sta2x11_gpio GPIO driver");
> -- 
> 1.7.7.2

-- 
email sent from notmuch.vim plugin
