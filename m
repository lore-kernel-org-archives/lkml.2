Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2BZXiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:38:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:33414 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab2BZXiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:38:14 -0500
Message-ID: <1330299464.20389.58.camel@pasglop>
Subject: Re: [PATCH 1/2] powerpc: Move GE GPIO and PIC drivers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: linuxppc-dev@lists.ozlabs.org, Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org
Date: Mon, 27 Feb 2012 10:37:44 +1100
In-Reply-To: <1328614121-17803-2-git-send-email-martyn.welch@ge.com>
References: <1328614121-17803-1-git-send-email-martyn.welch@ge.com>
	 <1328614121-17803-2-git-send-email-martyn.welch@ge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 11:28 +0000, Martyn Welch wrote:
> Move the GE GPIO and PIC drivers to allow these to be used by non-86xx
> boards.

Hi, Sorry for the late review...

> Signed-off-by: Martyn Welch <martyn.welch@ge.com>
> ---
>  arch/powerpc/platforms/86xx/Kconfig      |    3 +
>  arch/powerpc/platforms/86xx/Makefile     |    7 +-
>  arch/powerpc/platforms/86xx/gef_gpio.c   |  171 --------------------
>  arch/powerpc/platforms/86xx/gef_pic.c    |  252 ------------------------------
>  arch/powerpc/platforms/86xx/gef_pic.h    |   11 --
>  arch/powerpc/platforms/86xx/gef_ppc9a.c  |    3 +-
>  arch/powerpc/platforms/86xx/gef_sbc310.c |    3 +-
>  arch/powerpc/platforms/86xx/gef_sbc610.c |    3 +-
>  arch/powerpc/platforms/Kconfig           |    7 +
>  arch/powerpc/platforms/Makefile          |    3 +
>  arch/powerpc/platforms/ge_gpio.c         |  171 ++++++++++++++++++++
>  arch/powerpc/platforms/ge_pic.c          |  252 ++++++++++++++++++++++++++++++
>  arch/powerpc/platforms/ge_pic.h          |   11 ++

So I don't like having files showing up there. In fact, I want to move
the only other one here, it's not the right place for it
(fsl_uli1575.c).

Please contemplate using arch/powerpc/sysdev instead. Maybe make a
subdir in there (geip or something like that ?)

Also, use git mv so that the file moves appear as such in the history,
this will make review easier by clearly separating the move from actual
changes to the files.

Cheers,
Ben.

>  drivers/watchdog/Kconfig                 |    2 +-
>  14 files changed, 457 insertions(+), 442 deletions(-)
>  delete mode 100644 arch/powerpc/platforms/86xx/gef_gpio.c
>  delete mode 100644 arch/powerpc/platforms/86xx/gef_pic.c
>  delete mode 100644 arch/powerpc/platforms/86xx/gef_pic.h
>  create mode 100644 arch/powerpc/platforms/ge_gpio.c
>  create mode 100644 arch/powerpc/platforms/ge_pic.c
>  create mode 100644 arch/powerpc/platforms/ge_pic.h
> 
> diff --git a/arch/powerpc/platforms/86xx/Kconfig b/arch/powerpc/platforms/86xx/Kconfig
> index 8d6599d..2015022 100644
> --- a/arch/powerpc/platforms/86xx/Kconfig
> +++ b/arch/powerpc/platforms/86xx/Kconfig
> @@ -39,6 +39,7 @@ config GEF_PPC9A
>  	select MMIO_NVRAM
>  	select GENERIC_GPIO
>  	select ARCH_REQUIRE_GPIOLIB
> +	select GE_FPGA
>  	help
>  	  This option enables support for the GE PPC9A.
>  
> @@ -48,6 +49,7 @@ config GEF_SBC310
>  	select MMIO_NVRAM
>  	select GENERIC_GPIO
>  	select ARCH_REQUIRE_GPIOLIB
> +	select GE_FPGA
>  	help
>  	  This option enables support for the GE SBC310.
>  
> @@ -58,6 +60,7 @@ config GEF_SBC610
>  	select GENERIC_GPIO
>  	select ARCH_REQUIRE_GPIOLIB
>  	select HAS_RAPIDIO
> +	select GE_FPGA
>  	help
>  	  This option enables support for the GE SBC610.
>  
> diff --git a/arch/powerpc/platforms/86xx/Makefile b/arch/powerpc/platforms/86xx/Makefile
> index 4b0d7b1..ede815d 100644
> --- a/arch/powerpc/platforms/86xx/Makefile
> +++ b/arch/powerpc/platforms/86xx/Makefile
> @@ -7,7 +7,6 @@ obj-$(CONFIG_SMP)		+= mpc86xx_smp.o
>  obj-$(CONFIG_MPC8641_HPCN)	+= mpc86xx_hpcn.o
>  obj-$(CONFIG_SBC8641D)		+= sbc8641d.o
>  obj-$(CONFIG_MPC8610_HPCD)	+= mpc8610_hpcd.o
> -gef-gpio-$(CONFIG_GPIOLIB)	+= gef_gpio.o
> -obj-$(CONFIG_GEF_SBC610)	+= gef_sbc610.o gef_pic.o $(gef-gpio-y)
> -obj-$(CONFIG_GEF_SBC310)	+= gef_sbc310.o gef_pic.o $(gef-gpio-y)
> -obj-$(CONFIG_GEF_PPC9A)		+= gef_ppc9a.o gef_pic.o $(gef-gpio-y)
> +obj-$(CONFIG_GEF_SBC610)	+= gef_sbc610.o
> +obj-$(CONFIG_GEF_SBC310)	+= gef_sbc310.o
> +obj-$(CONFIG_GEF_PPC9A)		+= gef_ppc9a.o
> diff --git a/arch/powerpc/platforms/86xx/gef_gpio.c b/arch/powerpc/platforms/86xx/gef_gpio.c
> deleted file mode 100644
> index 2a70336..0000000
> --- a/arch/powerpc/platforms/86xx/gef_gpio.c
> +++ /dev/null
> @@ -1,171 +0,0 @@
> -/*
> - * Driver for GE FPGA based GPIO
> - *
> - * Author: Martyn Welch <martyn.welch@ge.com>
> - *
> - * 2008 (c) GE Intelligent Platforms Embedded Systems, Inc.
> - *
> - * This file is licensed under the terms of the GNU General Public License
> - * version 2.  This program is licensed "as is" without any warranty of any
> - * kind, whether express or implied.
> - */
> -
> -/* TODO
> - *
> - * Configuration of output modes (totem-pole/open-drain)
> - * Interrupt configuration - interrupts are always generated the FPGA relies on
> - * 	the I/O interrupt controllers mask to stop them propergating
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/compiler.h>
> -#include <linux/init.h>
> -#include <linux/io.h>
> -#include <linux/of.h>
> -#include <linux/of_device.h>
> -#include <linux/of_platform.h>
> -#include <linux/of_gpio.h>
> -#include <linux/gpio.h>
> -#include <linux/slab.h>
> -#include <linux/module.h>
> -
> -#define GEF_GPIO_DIRECT		0x00
> -#define GEF_GPIO_IN		0x04
> -#define GEF_GPIO_OUT		0x08
> -#define GEF_GPIO_TRIG		0x0C
> -#define GEF_GPIO_POLAR_A	0x10
> -#define GEF_GPIO_POLAR_B	0x14
> -#define GEF_GPIO_INT_STAT	0x18
> -#define GEF_GPIO_OVERRUN	0x1C
> -#define GEF_GPIO_MODE		0x20
> -
> -static void _gef_gpio_set(void __iomem *reg, unsigned int offset, int value)
> -{
> -	unsigned int data;
> -
> -	data = ioread32be(reg);
> -	/* value: 0=low; 1=high */
> -	if (value & 0x1)
> -		data = data | (0x1 << offset);
> -	else
> -		data = data & ~(0x1 << offset);
> -
> -	iowrite32be(data, reg);
> -}
> -
> -
> -static int gef_gpio_dir_in(struct gpio_chip *chip, unsigned offset)
> -{
> -	unsigned int data;
> -	struct of_mm_gpio_chip *mmchip = to_of_mm_gpio_chip(chip);
> -
> -	data = ioread32be(mmchip->regs + GEF_GPIO_DIRECT);
> -	data = data | (0x1 << offset);
> -	iowrite32be(data, mmchip->regs + GEF_GPIO_DIRECT);
> -
> -	return 0;
> -}
> -
> -static int gef_gpio_dir_out(struct gpio_chip *chip, unsigned offset, int value)
> -{
> -	unsigned int data;
> -	struct of_mm_gpio_chip *mmchip = to_of_mm_gpio_chip(chip);
> -
> -	/* Set direction before switching to input */
> -	_gef_gpio_set(mmchip->regs + GEF_GPIO_OUT, offset, value);
> -
> -	data = ioread32be(mmchip->regs + GEF_GPIO_DIRECT);
> -	data = data & ~(0x1 << offset);
> -	iowrite32be(data, mmchip->regs + GEF_GPIO_DIRECT);
> -
> -	return 0;
> -}
> -
> -static int gef_gpio_get(struct gpio_chip *chip, unsigned offset)
> -{
> -	unsigned int data;
> -	int state = 0;
> -	struct of_mm_gpio_chip *mmchip = to_of_mm_gpio_chip(chip);
> -
> -	data = ioread32be(mmchip->regs + GEF_GPIO_IN);
> -	state = (int)((data >> offset) & 0x1);
> -
> -	return state;
> -}
> -
> -static void gef_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> -{
> -	struct of_mm_gpio_chip *mmchip = to_of_mm_gpio_chip(chip);
> -
> -	_gef_gpio_set(mmchip->regs + GEF_GPIO_OUT, offset, value);
> -}
> -
> -static int __init gef_gpio_init(void)
> -{
> -	struct device_node *np;
> -	int retval;
> -	struct of_mm_gpio_chip *gef_gpio_chip;
> -
> -	for_each_compatible_node(np, NULL, "gef,sbc610-gpio") {
> -
> -		pr_debug("%s: Initialising GEF GPIO\n", np->full_name);
> -
> -		/* Allocate chip structure */
> -		gef_gpio_chip = kzalloc(sizeof(*gef_gpio_chip), GFP_KERNEL);
> -		if (!gef_gpio_chip) {
> -			pr_err("%s: Unable to allocate structure\n",
> -				np->full_name);
> -			continue;
> -		}
> -
> -		/* Setup pointers to chip functions */
> -		gef_gpio_chip->gc.of_gpio_n_cells = 2;
> -		gef_gpio_chip->gc.ngpio = 19;
> -		gef_gpio_chip->gc.direction_input = gef_gpio_dir_in;
> -		gef_gpio_chip->gc.direction_output = gef_gpio_dir_out;
> -		gef_gpio_chip->gc.get = gef_gpio_get;
> -		gef_gpio_chip->gc.set = gef_gpio_set;
> -
> -		/* This function adds a memory mapped GPIO chip */
> -		retval = of_mm_gpiochip_add(np, gef_gpio_chip);
> -		if (retval) {
> -			kfree(gef_gpio_chip);
> -			pr_err("%s: Unable to add GPIO\n", np->full_name);
> -		}
> -	}
> -
> -	for_each_compatible_node(np, NULL, "gef,sbc310-gpio") {
> -
> -		pr_debug("%s: Initialising GEF GPIO\n", np->full_name);
> -
> -		/* Allocate chip structure */
> -		gef_gpio_chip = kzalloc(sizeof(*gef_gpio_chip), GFP_KERNEL);
> -		if (!gef_gpio_chip) {
> -			pr_err("%s: Unable to allocate structure\n",
> -				np->full_name);
> -			continue;
> -		}
> -
> -		/* Setup pointers to chip functions */
> -		gef_gpio_chip->gc.of_gpio_n_cells = 2;
> -		gef_gpio_chip->gc.ngpio = 6;
> -		gef_gpio_chip->gc.direction_input = gef_gpio_dir_in;
> -		gef_gpio_chip->gc.direction_output = gef_gpio_dir_out;
> -		gef_gpio_chip->gc.get = gef_gpio_get;
> -		gef_gpio_chip->gc.set = gef_gpio_set;
> -
> -		/* This function adds a memory mapped GPIO chip */
> -		retval = of_mm_gpiochip_add(np, gef_gpio_chip);
> -		if (retval) {
> -			kfree(gef_gpio_chip);
> -			pr_err("%s: Unable to add GPIO\n", np->full_name);
> -		}
> -	}
> -
> -	return 0;
> -};
> -arch_initcall(gef_gpio_init);
> -
> -MODULE_DESCRIPTION("GE I/O FPGA GPIO driver");
> -MODULE_AUTHOR("Martyn Welch <martyn.welch@ge.com");
> -MODULE_LICENSE("GPL");
> diff --git a/arch/powerpc/platforms/86xx/gef_pic.c b/arch/powerpc/platforms/86xx/gef_pic.c
> deleted file mode 100644
> index 94594e5..0000000
> --- a/arch/powerpc/platforms/86xx/gef_pic.c
> +++ /dev/null
> @@ -1,252 +0,0 @@
> -/*
> - * Interrupt handling for GE FPGA based PIC
> - *
> - * Author: Martyn Welch <martyn.welch@ge.com>
> - *
> - * 2008 (c) GE Intelligent Platforms Embedded Systems, Inc.
> - *
> - * This file is licensed under the terms of the GNU General Public License
> - * version 2.  This program is licensed "as is" without any warranty of any
> - * kind, whether express or implied.
> - */
> -
> -#include <linux/stddef.h>
> -#include <linux/kernel.h>
> -#include <linux/init.h>
> -#include <linux/irq.h>
> -#include <linux/interrupt.h>
> -#include <linux/spinlock.h>
> -
> -#include <asm/byteorder.h>
> -#include <asm/io.h>
> -#include <asm/prom.h>
> -#include <asm/irq.h>
> -
> -#include "gef_pic.h"
> -
> -#define DEBUG
> -#undef DEBUG
> -
> -#ifdef DEBUG
> -#define DBG(fmt...) do { printk(KERN_DEBUG "gef_pic: " fmt); } while (0)
> -#else
> -#define DBG(fmt...) do { } while (0)
> -#endif
> -
> -#define GEF_PIC_NUM_IRQS	32
> -
> -/* Interrupt Controller Interface Registers */
> -#define GEF_PIC_INTR_STATUS	0x0000
> -
> -#define GEF_PIC_INTR_MASK(cpu)	(0x0010 + (0x4 * cpu))
> -#define GEF_PIC_CPU0_INTR_MASK	GEF_PIC_INTR_MASK(0)
> -#define GEF_PIC_CPU1_INTR_MASK	GEF_PIC_INTR_MASK(1)
> -
> -#define GEF_PIC_MCP_MASK(cpu)	(0x0018 + (0x4 * cpu))
> -#define GEF_PIC_CPU0_MCP_MASK	GEF_PIC_MCP_MASK(0)
> -#define GEF_PIC_CPU1_MCP_MASK	GEF_PIC_MCP_MASK(1)
> -
> -
> -static DEFINE_RAW_SPINLOCK(gef_pic_lock);
> -
> -static void __iomem *gef_pic_irq_reg_base;
> -static struct irq_host *gef_pic_irq_host;
> -static int gef_pic_cascade_irq;
> -
> -/*
> - * Interrupt Controller Handling
> - *
> - * The interrupt controller handles interrupts for most on board interrupts,
> - * apart from PCI interrupts. For example on SBC610:
> - *
> - * 17:31 RO Reserved
> - * 16    RO PCI Express Doorbell 3 Status
> - * 15    RO PCI Express Doorbell 2 Status
> - * 14    RO PCI Express Doorbell 1 Status
> - * 13    RO PCI Express Doorbell 0 Status
> - * 12    RO Real Time Clock Interrupt Status
> - * 11    RO Temperature Interrupt Status
> - * 10    RO Temperature Critical Interrupt Status
> - * 9     RO Ethernet PHY1 Interrupt Status
> - * 8     RO Ethernet PHY3 Interrupt Status
> - * 7     RO PEX8548 Interrupt Status
> - * 6     RO Reserved
> - * 5     RO Watchdog 0 Interrupt Status
> - * 4     RO Watchdog 1 Interrupt Status
> - * 3     RO AXIS Message FIFO A Interrupt Status
> - * 2     RO AXIS Message FIFO B Interrupt Status
> - * 1     RO AXIS Message FIFO C Interrupt Status
> - * 0     RO AXIS Message FIFO D Interrupt Status
> - *
> - * Interrupts can be forwarded to one of two output lines. Nothing
> - * clever is done, so if the masks are incorrectly set, a single input
> - * interrupt could generate interrupts on both output lines!
> - *
> - * The dual lines are there to allow the chained interrupts to be easily
> - * passed into two different cores. We currently do not use this functionality
> - * in this driver.
> - *
> - * Controller can also be configured to generate Machine checks (MCP), again on
> - * two lines, to be attached to two different cores. It is suggested that these
> - * should be masked out.
> - */
> -
> -void gef_pic_cascade(unsigned int irq, struct irq_desc *desc)
> -{
> -	struct irq_chip *chip = irq_desc_get_chip(desc);
> -	unsigned int cascade_irq;
> -
> -	/*
> -	 * See if we actually have an interrupt, call generic handling code if
> -	 * we do.
> -	 */
> -	cascade_irq = gef_pic_get_irq();
> -
> -	if (cascade_irq != NO_IRQ)
> -		generic_handle_irq(cascade_irq);
> -
> -	chip->irq_eoi(&desc->irq_data);
> -}
> -
> -static void gef_pic_mask(struct irq_data *d)
> -{
> -	unsigned long flags;
> -	unsigned int hwirq = irqd_to_hwirq(d);
> -	u32 mask;
> -
> -	raw_spin_lock_irqsave(&gef_pic_lock, flags);
> -	mask = in_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_MASK(0));
> -	mask &= ~(1 << hwirq);
> -	out_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_MASK(0), mask);
> -	raw_spin_unlock_irqrestore(&gef_pic_lock, flags);
> -}
> -
> -static void gef_pic_mask_ack(struct irq_data *d)
> -{
> -	/* Don't think we actually have to do anything to ack an interrupt,
> -	 * we just need to clear down the devices interrupt and it will go away
> -	 */
> -	gef_pic_mask(d);
> -}
> -
> -static void gef_pic_unmask(struct irq_data *d)
> -{
> -	unsigned long flags;
> -	unsigned int hwirq = irqd_to_hwirq(d);
> -	u32 mask;
> -
> -	raw_spin_lock_irqsave(&gef_pic_lock, flags);
> -	mask = in_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_MASK(0));
> -	mask |= (1 << hwirq);
> -	out_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_MASK(0), mask);
> -	raw_spin_unlock_irqrestore(&gef_pic_lock, flags);
> -}
> -
> -static struct irq_chip gef_pic_chip = {
> -	.name		= "gefp",
> -	.irq_mask	= gef_pic_mask,
> -	.irq_mask_ack	= gef_pic_mask_ack,
> -	.irq_unmask	= gef_pic_unmask,
> -};
> -
> -
> -/* When an interrupt is being configured, this call allows some flexibilty
> - * in deciding which irq_chip structure is used
> - */
> -static int gef_pic_host_map(struct irq_host *h, unsigned int virq,
> -			  irq_hw_number_t hwirq)
> -{
> -	/* All interrupts are LEVEL sensitive */
> -	irq_set_status_flags(virq, IRQ_LEVEL);
> -	irq_set_chip_and_handler(virq, &gef_pic_chip, handle_level_irq);
> -
> -	return 0;
> -}
> -
> -static int gef_pic_host_xlate(struct irq_host *h, struct device_node *ct,
> -			    const u32 *intspec, unsigned int intsize,
> -			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
> -{
> -
> -	*out_hwirq = intspec[0];
> -	if (intsize > 1)
> -		*out_flags = intspec[1];
> -	else
> -		*out_flags = IRQ_TYPE_LEVEL_HIGH;
> -
> -	return 0;
> -}
> -
> -static struct irq_host_ops gef_pic_host_ops = {
> -	.map	= gef_pic_host_map,
> -	.xlate	= gef_pic_host_xlate,
> -};
> -
> -
> -/*
> - * Initialisation of PIC, this should be called in BSP
> - */
> -void __init gef_pic_init(struct device_node *np)
> -{
> -	unsigned long flags;
> -
> -	/* Map the devices registers into memory */
> -	gef_pic_irq_reg_base = of_iomap(np, 0);
> -
> -	raw_spin_lock_irqsave(&gef_pic_lock, flags);
> -
> -	/* Initialise everything as masked. */
> -	out_be32(gef_pic_irq_reg_base + GEF_PIC_CPU0_INTR_MASK, 0);
> -	out_be32(gef_pic_irq_reg_base + GEF_PIC_CPU1_INTR_MASK, 0);
> -
> -	out_be32(gef_pic_irq_reg_base + GEF_PIC_CPU0_MCP_MASK, 0);
> -	out_be32(gef_pic_irq_reg_base + GEF_PIC_CPU1_MCP_MASK, 0);
> -
> -	raw_spin_unlock_irqrestore(&gef_pic_lock, flags);
> -
> -	/* Map controller */
> -	gef_pic_cascade_irq = irq_of_parse_and_map(np, 0);
> -	if (gef_pic_cascade_irq == NO_IRQ) {
> -		printk(KERN_ERR "SBC610: failed to map cascade interrupt");
> -		return;
> -	}
> -
> -	/* Setup an irq_host structure */
> -	gef_pic_irq_host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR,
> -					  GEF_PIC_NUM_IRQS,
> -					  &gef_pic_host_ops, NO_IRQ);
> -	if (gef_pic_irq_host == NULL)
> -		return;
> -
> -	/* Chain with parent controller */
> -	irq_set_chained_handler(gef_pic_cascade_irq, gef_pic_cascade);
> -}
> -
> -/*
> - * This is called when we receive an interrupt with apparently comes from this
> - * chip - check, returning the highest interrupt generated or return NO_IRQ
> - */
> -unsigned int gef_pic_get_irq(void)
> -{
> -	u32 cause, mask, active;
> -	unsigned int virq = NO_IRQ;
> -	int hwirq;
> -
> -	cause = in_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_STATUS);
> -
> -	mask = in_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_MASK(0));
> -
> -	active = cause & mask;
> -
> -	if (active) {
> -		for (hwirq = GEF_PIC_NUM_IRQS - 1; hwirq > -1; hwirq--) {
> -			if (active & (0x1 << hwirq))
> -				break;
> -		}
> -		virq = irq_linear_revmap(gef_pic_irq_host,
> -			(irq_hw_number_t)hwirq);
> -	}
> -
> -	return virq;
> -}
> -
> diff --git a/arch/powerpc/platforms/86xx/gef_pic.h b/arch/powerpc/platforms/86xx/gef_pic.h
> deleted file mode 100644
> index 6149916..0000000
> --- a/arch/powerpc/platforms/86xx/gef_pic.h
> +++ /dev/null
> @@ -1,11 +0,0 @@
> -#ifndef __GEF_PIC_H__
> -#define __GEF_PIC_H__
> -
> -#include <linux/init.h>
> -
> -void gef_pic_cascade(unsigned int, struct irq_desc *);
> -unsigned int gef_pic_get_irq(void);
> -void gef_pic_init(struct device_node *);
> -
> -#endif /* __GEF_PIC_H__ */
> -
> diff --git a/arch/powerpc/platforms/86xx/gef_ppc9a.c b/arch/powerpc/platforms/86xx/gef_ppc9a.c
> index 60ce07e..132917d 100644
> --- a/arch/powerpc/platforms/86xx/gef_ppc9a.c
> +++ b/arch/powerpc/platforms/86xx/gef_ppc9a.c
> @@ -38,8 +38,9 @@
>  #include <sysdev/fsl_pci.h>
>  #include <sysdev/fsl_soc.h>
>  
> +#include <platforms/ge_pic.h>
> +
>  #include "mpc86xx.h"
> -#include "gef_pic.h"
>  
>  #undef DEBUG
>  
> diff --git a/arch/powerpc/platforms/86xx/gef_sbc310.c b/arch/powerpc/platforms/86xx/gef_sbc310.c
> index 3ecee25..3d7894d 100644
> --- a/arch/powerpc/platforms/86xx/gef_sbc310.c
> +++ b/arch/powerpc/platforms/86xx/gef_sbc310.c
> @@ -38,8 +38,9 @@
>  #include <sysdev/fsl_pci.h>
>  #include <sysdev/fsl_soc.h>
>  
> +#include <platforms/ge_pic.h>
> +
>  #include "mpc86xx.h"
> -#include "gef_pic.h"
>  
>  #undef DEBUG
>  
> diff --git a/arch/powerpc/platforms/86xx/gef_sbc610.c b/arch/powerpc/platforms/86xx/gef_sbc610.c
> index 5090d60..4f6b6a4 100644
> --- a/arch/powerpc/platforms/86xx/gef_sbc610.c
> +++ b/arch/powerpc/platforms/86xx/gef_sbc610.c
> @@ -38,8 +38,9 @@
>  #include <sysdev/fsl_pci.h>
>  #include <sysdev/fsl_soc.h>
>  
> +#include <platforms/ge_pic.h>
> +
>  #include "mpc86xx.h"
> -#include "gef_pic.h"
>  
>  #undef DEBUG
>  
> diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
> index 0cfb46d..2578e82 100644
> --- a/arch/powerpc/platforms/Kconfig
> +++ b/arch/powerpc/platforms/Kconfig
> @@ -363,4 +363,11 @@ config XILINX_PCI
>  	bool "Xilinx PCI host bridge support"
>  	depends on PCI && XILINX_VIRTEX
>  
> +config GE_FPGA
> +	bool
> +	default n
> +	help
> +	  Support for common GPIO and interrupt routing functionality provided
> +	  on some GE Single Board Computers.
> +
>  endmenu
> diff --git a/arch/powerpc/platforms/Makefile b/arch/powerpc/platforms/Makefile
> index 2635a22..38742cf 100644
> --- a/arch/powerpc/platforms/Makefile
> +++ b/arch/powerpc/platforms/Makefile
> @@ -3,6 +3,9 @@ subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
>  
>  obj-$(CONFIG_FSL_ULI1575)	+= fsl_uli1575.o
>  
> +gef-gpio-$(CONFIG_GPIOLIB)	+= ge_gpio.o
> +obj-$(CONFIG_GE_FPGA)		+= ge_pic.o $(gef-gpio-y)
> +
>  obj-$(CONFIG_PPC_PMAC)		+= powermac/
>  obj-$(CONFIG_PPC_CHRP)		+= chrp/
>  obj-$(CONFIG_40x)		+= 40x/
> diff --git a/arch/powerpc/platforms/ge_gpio.c b/arch/powerpc/platforms/ge_gpio.c
> new file mode 100644
> index 0000000..2a70336
> --- /dev/null
> +++ b/arch/powerpc/platforms/ge_gpio.c
> @@ -0,0 +1,171 @@
> +/*
> + * Driver for GE FPGA based GPIO
> + *
> + * Author: Martyn Welch <martyn.welch@ge.com>
> + *
> + * 2008 (c) GE Intelligent Platforms Embedded Systems, Inc.
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2.  This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +/* TODO
> + *
> + * Configuration of output modes (totem-pole/open-drain)
> + * Interrupt configuration - interrupts are always generated the FPGA relies on
> + * 	the I/O interrupt controllers mask to stop them propergating
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/compiler.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_gpio.h>
> +#include <linux/gpio.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +
> +#define GEF_GPIO_DIRECT		0x00
> +#define GEF_GPIO_IN		0x04
> +#define GEF_GPIO_OUT		0x08
> +#define GEF_GPIO_TRIG		0x0C
> +#define GEF_GPIO_POLAR_A	0x10
> +#define GEF_GPIO_POLAR_B	0x14
> +#define GEF_GPIO_INT_STAT	0x18
> +#define GEF_GPIO_OVERRUN	0x1C
> +#define GEF_GPIO_MODE		0x20
> +
> +static void _gef_gpio_set(void __iomem *reg, unsigned int offset, int value)
> +{
> +	unsigned int data;
> +
> +	data = ioread32be(reg);
> +	/* value: 0=low; 1=high */
> +	if (value & 0x1)
> +		data = data | (0x1 << offset);
> +	else
> +		data = data & ~(0x1 << offset);
> +
> +	iowrite32be(data, reg);
> +}
> +
> +
> +static int gef_gpio_dir_in(struct gpio_chip *chip, unsigned offset)
> +{
> +	unsigned int data;
> +	struct of_mm_gpio_chip *mmchip = to_of_mm_gpio_chip(chip);
> +
> +	data = ioread32be(mmchip->regs + GEF_GPIO_DIRECT);
> +	data = data | (0x1 << offset);
> +	iowrite32be(data, mmchip->regs + GEF_GPIO_DIRECT);
> +
> +	return 0;
> +}
> +
> +static int gef_gpio_dir_out(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	unsigned int data;
> +	struct of_mm_gpio_chip *mmchip = to_of_mm_gpio_chip(chip);
> +
> +	/* Set direction before switching to input */
> +	_gef_gpio_set(mmchip->regs + GEF_GPIO_OUT, offset, value);
> +
> +	data = ioread32be(mmchip->regs + GEF_GPIO_DIRECT);
> +	data = data & ~(0x1 << offset);
> +	iowrite32be(data, mmchip->regs + GEF_GPIO_DIRECT);
> +
> +	return 0;
> +}
> +
> +static int gef_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	unsigned int data;
> +	int state = 0;
> +	struct of_mm_gpio_chip *mmchip = to_of_mm_gpio_chip(chip);
> +
> +	data = ioread32be(mmchip->regs + GEF_GPIO_IN);
> +	state = (int)((data >> offset) & 0x1);
> +
> +	return state;
> +}
> +
> +static void gef_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	struct of_mm_gpio_chip *mmchip = to_of_mm_gpio_chip(chip);
> +
> +	_gef_gpio_set(mmchip->regs + GEF_GPIO_OUT, offset, value);
> +}
> +
> +static int __init gef_gpio_init(void)
> +{
> +	struct device_node *np;
> +	int retval;
> +	struct of_mm_gpio_chip *gef_gpio_chip;
> +
> +	for_each_compatible_node(np, NULL, "gef,sbc610-gpio") {
> +
> +		pr_debug("%s: Initialising GEF GPIO\n", np->full_name);
> +
> +		/* Allocate chip structure */
> +		gef_gpio_chip = kzalloc(sizeof(*gef_gpio_chip), GFP_KERNEL);
> +		if (!gef_gpio_chip) {
> +			pr_err("%s: Unable to allocate structure\n",
> +				np->full_name);
> +			continue;
> +		}
> +
> +		/* Setup pointers to chip functions */
> +		gef_gpio_chip->gc.of_gpio_n_cells = 2;
> +		gef_gpio_chip->gc.ngpio = 19;
> +		gef_gpio_chip->gc.direction_input = gef_gpio_dir_in;
> +		gef_gpio_chip->gc.direction_output = gef_gpio_dir_out;
> +		gef_gpio_chip->gc.get = gef_gpio_get;
> +		gef_gpio_chip->gc.set = gef_gpio_set;
> +
> +		/* This function adds a memory mapped GPIO chip */
> +		retval = of_mm_gpiochip_add(np, gef_gpio_chip);
> +		if (retval) {
> +			kfree(gef_gpio_chip);
> +			pr_err("%s: Unable to add GPIO\n", np->full_name);
> +		}
> +	}
> +
> +	for_each_compatible_node(np, NULL, "gef,sbc310-gpio") {
> +
> +		pr_debug("%s: Initialising GEF GPIO\n", np->full_name);
> +
> +		/* Allocate chip structure */
> +		gef_gpio_chip = kzalloc(sizeof(*gef_gpio_chip), GFP_KERNEL);
> +		if (!gef_gpio_chip) {
> +			pr_err("%s: Unable to allocate structure\n",
> +				np->full_name);
> +			continue;
> +		}
> +
> +		/* Setup pointers to chip functions */
> +		gef_gpio_chip->gc.of_gpio_n_cells = 2;
> +		gef_gpio_chip->gc.ngpio = 6;
> +		gef_gpio_chip->gc.direction_input = gef_gpio_dir_in;
> +		gef_gpio_chip->gc.direction_output = gef_gpio_dir_out;
> +		gef_gpio_chip->gc.get = gef_gpio_get;
> +		gef_gpio_chip->gc.set = gef_gpio_set;
> +
> +		/* This function adds a memory mapped GPIO chip */
> +		retval = of_mm_gpiochip_add(np, gef_gpio_chip);
> +		if (retval) {
> +			kfree(gef_gpio_chip);
> +			pr_err("%s: Unable to add GPIO\n", np->full_name);
> +		}
> +	}
> +
> +	return 0;
> +};
> +arch_initcall(gef_gpio_init);
> +
> +MODULE_DESCRIPTION("GE I/O FPGA GPIO driver");
> +MODULE_AUTHOR("Martyn Welch <martyn.welch@ge.com");
> +MODULE_LICENSE("GPL");
> diff --git a/arch/powerpc/platforms/ge_pic.c b/arch/powerpc/platforms/ge_pic.c
> new file mode 100644
> index 0000000..a1ccef2
> --- /dev/null
> +++ b/arch/powerpc/platforms/ge_pic.c
> @@ -0,0 +1,252 @@
> +/*
> + * Interrupt handling for GE FPGA based PIC
> + *
> + * Author: Martyn Welch <martyn.welch@ge.com>
> + *
> + * 2008 (c) GE Intelligent Platforms Embedded Systems, Inc.
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2.  This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +#include <linux/stddef.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +
> +#include <asm/byteorder.h>
> +#include <asm/io.h>
> +#include <asm/prom.h>
> +#include <asm/irq.h>
> +
> +#include <platforms/ge_pic.h>
> +
> +#define DEBUG
> +#undef DEBUG
> +
> +#ifdef DEBUG
> +#define DBG(fmt...) do { printk(KERN_DEBUG "gef_pic: " fmt); } while (0)
> +#else
> +#define DBG(fmt...) do { } while (0)
> +#endif
> +
> +#define GEF_PIC_NUM_IRQS	32
> +
> +/* Interrupt Controller Interface Registers */
> +#define GEF_PIC_INTR_STATUS	0x0000
> +
> +#define GEF_PIC_INTR_MASK(cpu)	(0x0010 + (0x4 * cpu))
> +#define GEF_PIC_CPU0_INTR_MASK	GEF_PIC_INTR_MASK(0)
> +#define GEF_PIC_CPU1_INTR_MASK	GEF_PIC_INTR_MASK(1)
> +
> +#define GEF_PIC_MCP_MASK(cpu)	(0x0018 + (0x4 * cpu))
> +#define GEF_PIC_CPU0_MCP_MASK	GEF_PIC_MCP_MASK(0)
> +#define GEF_PIC_CPU1_MCP_MASK	GEF_PIC_MCP_MASK(1)
> +
> +
> +static DEFINE_RAW_SPINLOCK(gef_pic_lock);
> +
> +static void __iomem *gef_pic_irq_reg_base;
> +static struct irq_host *gef_pic_irq_host;
> +static int gef_pic_cascade_irq;
> +
> +/*
> + * Interrupt Controller Handling
> + *
> + * The interrupt controller handles interrupts for most on board interrupts,
> + * apart from PCI interrupts. For example on SBC610:
> + *
> + * 17:31 RO Reserved
> + * 16    RO PCI Express Doorbell 3 Status
> + * 15    RO PCI Express Doorbell 2 Status
> + * 14    RO PCI Express Doorbell 1 Status
> + * 13    RO PCI Express Doorbell 0 Status
> + * 12    RO Real Time Clock Interrupt Status
> + * 11    RO Temperature Interrupt Status
> + * 10    RO Temperature Critical Interrupt Status
> + * 9     RO Ethernet PHY1 Interrupt Status
> + * 8     RO Ethernet PHY3 Interrupt Status
> + * 7     RO PEX8548 Interrupt Status
> + * 6     RO Reserved
> + * 5     RO Watchdog 0 Interrupt Status
> + * 4     RO Watchdog 1 Interrupt Status
> + * 3     RO AXIS Message FIFO A Interrupt Status
> + * 2     RO AXIS Message FIFO B Interrupt Status
> + * 1     RO AXIS Message FIFO C Interrupt Status
> + * 0     RO AXIS Message FIFO D Interrupt Status
> + *
> + * Interrupts can be forwarded to one of two output lines. Nothing
> + * clever is done, so if the masks are incorrectly set, a single input
> + * interrupt could generate interrupts on both output lines!
> + *
> + * The dual lines are there to allow the chained interrupts to be easily
> + * passed into two different cores. We currently do not use this functionality
> + * in this driver.
> + *
> + * Controller can also be configured to generate Machine checks (MCP), again on
> + * two lines, to be attached to two different cores. It is suggested that these
> + * should be masked out.
> + */
> +
> +void gef_pic_cascade(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct irq_chip *chip = irq_desc_get_chip(desc);
> +	unsigned int cascade_irq;
> +
> +	/*
> +	 * See if we actually have an interrupt, call generic handling code if
> +	 * we do.
> +	 */
> +	cascade_irq = gef_pic_get_irq();
> +
> +	if (cascade_irq != NO_IRQ)
> +		generic_handle_irq(cascade_irq);
> +
> +	chip->irq_eoi(&desc->irq_data);
> +}
> +
> +static void gef_pic_mask(struct irq_data *d)
> +{
> +	unsigned long flags;
> +	unsigned int hwirq = irqd_to_hwirq(d);
> +	u32 mask;
> +
> +	raw_spin_lock_irqsave(&gef_pic_lock, flags);
> +	mask = in_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_MASK(0));
> +	mask &= ~(1 << hwirq);
> +	out_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_MASK(0), mask);
> +	raw_spin_unlock_irqrestore(&gef_pic_lock, flags);
> +}
> +
> +static void gef_pic_mask_ack(struct irq_data *d)
> +{
> +	/* Don't think we actually have to do anything to ack an interrupt,
> +	 * we just need to clear down the devices interrupt and it will go away
> +	 */
> +	gef_pic_mask(d);
> +}
> +
> +static void gef_pic_unmask(struct irq_data *d)
> +{
> +	unsigned long flags;
> +	unsigned int hwirq = irqd_to_hwirq(d);
> +	u32 mask;
> +
> +	raw_spin_lock_irqsave(&gef_pic_lock, flags);
> +	mask = in_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_MASK(0));
> +	mask |= (1 << hwirq);
> +	out_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_MASK(0), mask);
> +	raw_spin_unlock_irqrestore(&gef_pic_lock, flags);
> +}
> +
> +static struct irq_chip gef_pic_chip = {
> +	.name		= "gefp",
> +	.irq_mask	= gef_pic_mask,
> +	.irq_mask_ack	= gef_pic_mask_ack,
> +	.irq_unmask	= gef_pic_unmask,
> +};
> +
> +
> +/* When an interrupt is being configured, this call allows some flexibilty
> + * in deciding which irq_chip structure is used
> + */
> +static int gef_pic_host_map(struct irq_host *h, unsigned int virq,
> +			  irq_hw_number_t hwirq)
> +{
> +	/* All interrupts are LEVEL sensitive */
> +	irq_set_status_flags(virq, IRQ_LEVEL);
> +	irq_set_chip_and_handler(virq, &gef_pic_chip, handle_level_irq);
> +
> +	return 0;
> +}
> +
> +static int gef_pic_host_xlate(struct irq_host *h, struct device_node *ct,
> +			    const u32 *intspec, unsigned int intsize,
> +			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
> +{
> +
> +	*out_hwirq = intspec[0];
> +	if (intsize > 1)
> +		*out_flags = intspec[1];
> +	else
> +		*out_flags = IRQ_TYPE_LEVEL_HIGH;
> +
> +	return 0;
> +}
> +
> +static struct irq_host_ops gef_pic_host_ops = {
> +	.map	= gef_pic_host_map,
> +	.xlate	= gef_pic_host_xlate,
> +};
> +
> +
> +/*
> + * Initialisation of PIC, this should be called in BSP
> + */
> +void __init gef_pic_init(struct device_node *np)
> +{
> +	unsigned long flags;
> +
> +	/* Map the devices registers into memory */
> +	gef_pic_irq_reg_base = of_iomap(np, 0);
> +
> +	raw_spin_lock_irqsave(&gef_pic_lock, flags);
> +
> +	/* Initialise everything as masked. */
> +	out_be32(gef_pic_irq_reg_base + GEF_PIC_CPU0_INTR_MASK, 0);
> +	out_be32(gef_pic_irq_reg_base + GEF_PIC_CPU1_INTR_MASK, 0);
> +
> +	out_be32(gef_pic_irq_reg_base + GEF_PIC_CPU0_MCP_MASK, 0);
> +	out_be32(gef_pic_irq_reg_base + GEF_PIC_CPU1_MCP_MASK, 0);
> +
> +	raw_spin_unlock_irqrestore(&gef_pic_lock, flags);
> +
> +	/* Map controller */
> +	gef_pic_cascade_irq = irq_of_parse_and_map(np, 0);
> +	if (gef_pic_cascade_irq == NO_IRQ) {
> +		printk(KERN_ERR "SBC610: failed to map cascade interrupt");
> +		return;
> +	}
> +
> +	/* Setup an irq_host structure */
> +	gef_pic_irq_host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR,
> +					  GEF_PIC_NUM_IRQS,
> +					  &gef_pic_host_ops, NO_IRQ);
> +	if (gef_pic_irq_host == NULL)
> +		return;
> +
> +	/* Chain with parent controller */
> +	irq_set_chained_handler(gef_pic_cascade_irq, gef_pic_cascade);
> +}
> +
> +/*
> + * This is called when we receive an interrupt with apparently comes from this
> + * chip - check, returning the highest interrupt generated or return NO_IRQ
> + */
> +unsigned int gef_pic_get_irq(void)
> +{
> +	u32 cause, mask, active;
> +	unsigned int virq = NO_IRQ;
> +	int hwirq;
> +
> +	cause = in_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_STATUS);
> +
> +	mask = in_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_MASK(0));
> +
> +	active = cause & mask;
> +
> +	if (active) {
> +		for (hwirq = GEF_PIC_NUM_IRQS - 1; hwirq > -1; hwirq--) {
> +			if (active & (0x1 << hwirq))
> +				break;
> +		}
> +		virq = irq_linear_revmap(gef_pic_irq_host,
> +			(irq_hw_number_t)hwirq);
> +	}
> +
> +	return virq;
> +}
> +
> diff --git a/arch/powerpc/platforms/ge_pic.h b/arch/powerpc/platforms/ge_pic.h
> new file mode 100644
> index 0000000..6149916
> --- /dev/null
> +++ b/arch/powerpc/platforms/ge_pic.h
> @@ -0,0 +1,11 @@
> +#ifndef __GEF_PIC_H__
> +#define __GEF_PIC_H__
> +
> +#include <linux/init.h>
> +
> +void gef_pic_cascade(unsigned int, struct irq_desc *);
> +unsigned int gef_pic_get_irq(void);
> +void gef_pic_init(struct device_node *);
> +
> +#endif /* __GEF_PIC_H__ */
> +
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 877b107..2955c3f 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -1039,7 +1039,7 @@ config LANTIQ_WDT
>  
>  config GEF_WDT
>  	tristate "GE Watchdog Timer"
> -	depends on GEF_SBC610 || GEF_SBC310 || GEF_PPC9A
> +	depends on GE_FPGA
>  	---help---
>  	  Watchdog timer found in a number of GE single board computers.
>  


