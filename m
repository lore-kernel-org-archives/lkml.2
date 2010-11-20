Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0KTTaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 14:30:16 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41541 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab0KTTaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 14:30:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lydPZZz3JScU9ObAIKl6rgTklnnU2o31PjES3gXxwCoOyA98GScEUHYk1dChEPVo/M
         DMWX53ZwthsmOFn3EB6baa40uIF383Fv5Jt/JqTIb8xfQ8BCq7Q0bsLbcJ54T3JQua7c
         Gl+Nvnnn16enQovJ1nXn3AAx7EbMvkNGAlckY=
Message-ID: <4CE821BF.7030009@gmail.com>
Date: Sat, 20 Nov 2010 21:30:07 +0200
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com>
In-Reply-To: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2010 04:27 PM, Hans Ulli Kroll wrote:
> Add support for PCI Bus on Gemini Devices SL3516
>
> Signed-off-by: Hans Ulli Kroll<ulli.kroll@googlemail.com>
> ---
>   arch/arm/Kconfig                             |    1 +
>   arch/arm/mach-gemini/Makefile                |    2 +
>   arch/arm/mach-gemini/include/mach/hardware.h |    8 +
>   arch/arm/mach-gemini/include/mach/irqs.h     |    7 +-
>   arch/arm/mach-gemini/mm.c                    |    5 +
>   arch/arm/mach-gemini/pci.c                   |  319 ++++++++++++++++++++++++++
>   6 files changed, 340 insertions(+), 2 deletions(-)
>   create mode 100644 arch/arm/mach-gemini/pci.c
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index a19a526..5d4b398 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -307,6 +307,7 @@ config ARCH_GEMINI
>   	select CPU_FA526
>   	select ARCH_REQUIRE_GPIOLIB
>   	select ARCH_USES_GETTIMEOFFSET
> +	select PCI
>   	help
>   	  Support for the Cortina Systems Gemini family SoCs
>
> diff --git a/arch/arm/mach-gemini/Makefile b/arch/arm/mach-gemini/Makefile
> index c5b24b9..c263f48 100644
> --- a/arch/arm/mach-gemini/Makefile
> +++ b/arch/arm/mach-gemini/Makefile
> @@ -6,6 +6,8 @@
>
>   obj-y			:= irq.o mm.o time.o devices.o gpio.o
>
> +obj-$(CONFIG_PCI)	+= pci.o
> +
>   # Board-specific support
>   obj-$(CONFIG_MACH_NAS4220B)	+= board-nas4220b.o
>   obj-$(CONFIG_MACH_RUT100)	+= board-rut1xx.o
> diff --git a/arch/arm/mach-gemini/include/mach/hardware.h b/arch/arm/mach-gemini/include/mach/hardware.h
> index 213a4fc..38c530f 100644
> --- a/arch/arm/mach-gemini/include/mach/hardware.h
> +++ b/arch/arm/mach-gemini/include/mach/hardware.h
> @@ -71,4 +71,12 @@
>    */
>   #define IO_ADDRESS(x)	((((x)&  0xFFF00000)>>  4) | ((x)&  0x000FFFFF) | 0xF0000000)
>
> +/*
> + * PCI subsystem macros
> + */
> +#define PCIBIOS_MIN_IO		0x00000100
> +#define PCIBIOS_MIN_MEM		0x00000000
> +
> +#define pcibios_assign_all_busses()	1
> +
>   #endif
> diff --git a/arch/arm/mach-gemini/include/mach/irqs.h b/arch/arm/mach-gemini/include/mach/irqs.h
> index 06bc47e..c737673 100644
> --- a/arch/arm/mach-gemini/include/mach/irqs.h
> +++ b/arch/arm/mach-gemini/include/mach/irqs.h
> @@ -43,11 +43,14 @@
>
>   #define NORMAL_IRQ_NUM	32
>
> -#define GPIO_IRQ_BASE	NORMAL_IRQ_NUM
> +#define PCI_IRQ_BASE	NORMAL_IRQ_NUM
> +#define PCI_IRQ_NUM	4
> +
> +#define GPIO_IRQ_BASE	(NORMAL_IRQ_NUM + PCI_IRQ_NUM)
>   #define GPIO_IRQ_NUM	(3 * 32)
>
>   #define ARCH_TIMER_IRQ	IRQ_TIMER2
>
> -#define NR_IRQS		(NORMAL_IRQ_NUM + GPIO_IRQ_NUM)
> +#define NR_IRQS		(NORMAL_IRQ_NUM + PCI_IRQ_NUM + GPIO_IRQ_NUM)
>
>   #endif /* __MACH_IRQS_H__ */
> diff --git a/arch/arm/mach-gemini/mm.c b/arch/arm/mach-gemini/mm.c
> index 5194824..2bf20b2 100644
> --- a/arch/arm/mach-gemini/mm.c
> +++ b/arch/arm/mach-gemini/mm.c
> @@ -59,6 +59,11 @@ static struct map_desc gemini_io_desc[] __initdata = {
>   		.length		= SZ_512K,
>   		.type 		= MT_DEVICE,
>   	}, {
> +		.virtual	= IO_ADDRESS(GEMINI_PCI_IO_BASE),
> +		.pfn		= __phys_to_pfn(GEMINI_PCI_IO_BASE),
> +		.length		= SZ_512K,
> +		.type		= MT_DEVICE,
> +	}, {
>   		.virtual	= IO_ADDRESS(GEMINI_FLASH_CTRL_BASE),
>   		.pfn		= __phys_to_pfn(GEMINI_FLASH_CTRL_BASE),
>   		.length		= SZ_512K,
> diff --git a/arch/arm/mach-gemini/pci.c b/arch/arm/mach-gemini/pci.c
> new file mode 100644
> index 0000000..1064b05
> --- /dev/null
> +++ b/arch/arm/mach-gemini/pci.c
> @@ -0,0 +1,319 @@
> +/*
> + *  Support for Gemini PCI Controller
> + *
> + *  Copyright (C) 2009 Janos Laube<janos.dev@gmail.com>
> + *  Copyright (C) 2009 Paulius Zaleckas<paulius.zaleckas@teltonika.lt>

Please update my e-mail. This one is long gone...

> + *
> + * based on SL2312 PCI controller code
> + *   Storlink (C) 2003
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include<linux/kernel.h>
> +#include<linux/pci.h>
> +#include<linux/irq.h>
> +
> +#include<asm/mach/pci.h>
> +#include<asm/gpio.h>
> +
> +#include<mach/irqs.h>
> +
> +#define GEMINI_PCI_IOSIZE_1M		0x0000
> +
> +#define GEMINI_PCI_PMC			0x40
> +#define GEMINI_PCI_PMCSR		0x44
> +#define GEMINI_PCI_CTRL1		0x48
> +#define GEMINI_PCI_CTRL2		0x4C
> +#define GEMINI_PCI_MEM1_BASE_SIZE	0x50
> +#define GEMINI_PCI_MEM2_BASE_SIZE	0x54
> +#define GEMINI_PCI_MEM3_BASE_SIZE	0x58
> +
> +#define PCI_CTRL2_INTSTS_OFFSET		28
> +#define PCI_CTRL2_INTMASK_OFFSET	22
> +
> +#define GEMINI_PCI_DMA_MASK		0xFFF00000
> +#define GEMINI_PCI_DMA_MEM1_BASE	0x00000000
> +#define GEMINI_PCI_DMA_MEM2_BASE	0x00000000
> +#define GEMINI_PCI_DMA_MEM3_BASE	0x00000000
> +#define GEMINI_PCI_DMA_MEM1_SIZE	7
> +#define GEMINI_PCI_DMA_MEM2_SIZE	6
> +#define GEMINI_PCI_DMA_MEM3_SIZE	6
> +
> +#define PCI_CONF_ENABLE		(1<<  31)
> +#define PCI_CONF_WHERE(r)	((r)&  0xFC)
> +#define PCI_CONF_BUS(b)		(((b)&  0xFF)<<  16)
> +#define PCI_CONF_DEVICE(d)	(((d)&  0x1F)<<  11)
> +#define PCI_CONF_FUNCTION(f)	(((f)&  0x07)<<  8)
> +
> +#define PCI_IOSIZE_REG		(IO_ADDRESS(GEMINI_PCI_IO_BASE))
> +#define PCI_PROT_REG		(IO_ADDRESS(GEMINI_PCI_IO_BASE) + 0x04)
> +#define PCI_CTRL_REG		(IO_ADDRESS(GEMINI_PCI_IO_BASE) + 0x08)
> +#define PCI_SOFTRST_REG		(IO_ADDRESS(GEMINI_PCI_IO_BASE) + 0x10)
> +#define PCI_CONFIG_REG		(IO_ADDRESS(GEMINI_PCI_IO_BASE) + 0x28)
> +#define PCI_DATA_REG		(IO_ADDRESS(GEMINI_PCI_IO_BASE) + 0x2C)
> +
> +
> +static DEFINE_SPINLOCK(gemini_pci_lock);
> +
> +static struct resource gemini_pci_resource_io = {
> +	.name	= "PCI I/O Space",
> +	.start	= IO_ADDRESS(GEMINI_PCI_IO_BASE),
> +	.end	= IO_ADDRESS(GEMINI_PCI_IO_BASE) + SZ_1M - 1,
> +	.flags	= IORESOURCE_IO,
> +};
> +
> +static struct resource gemini_pci_resource_mem = {
> +	.name	= "PCI Memory Space",
> +	.start	= GEMINI_PCI_MEM_BASE,
> +	.end	= GEMINI_PCI_MEM_BASE + SZ_128M - 1,
> +	.flags	= IORESOURCE_MEM,
> +};
> +
> +static int gemini_pci_read_config(struct pci_bus *bus, unsigned int fn,
> +				  int config, int size, u32 *value)
> +{
> +	unsigned long irq_flags;
> +
> +	spin_lock_irqsave(&gemini_pci_lock, irq_flags);
> +
> +	__raw_writel(PCI_CONF_BUS(bus->number) |
> +			PCI_CONF_DEVICE(PCI_SLOT(fn)) |
> +			PCI_CONF_FUNCTION(PCI_FUNC(fn)) |
> +			PCI_CONF_WHERE(config) |
> +			PCI_CONF_ENABLE,
> +			PCI_CONFIG_REG);
> +
> +	*value = __raw_readl(PCI_DATA_REG);
> +
> +	if (size == 1)
> +		*value = (*value>>  (8 * (config&  3)))&  0xFF;
> +	else if (size == 2)
> +		*value = (*value>>  (8 * (config&  3)))&  0xFFFF;
> +
> +	spin_unlock_irqrestore(&gemini_pci_lock, irq_flags);
> +
> +	dev_dbg(&bus->dev,
> +		"[read]  slt: %.2d, fnc: %d, cnf: 0x%.2X, val (%d bytes): 0x%.8X\n",
> +		PCI_SLOT(fn), PCI_FUNC(fn), config, size, *value);
> +
> +	return PCIBIOS_SUCCESSFUL;
> +}
> +
> +static int gemini_pci_write_config(struct pci_bus *bus, unsigned int fn,
> +				   int config, int size, u32 value)
> +{
> +	unsigned long irq_flags = 0;
> +	int ret = PCIBIOS_SUCCESSFUL;
> +
> +	dev_dbg(&bus->dev,
> +		"[write] slt: %.2d, fnc: %d, cnf: 0x%.2X, val (%d bytes): 0x%.8X\n",
> +		PCI_SLOT(fn), PCI_FUNC(fn), config, size, value);
> +
> +	spin_lock_irqsave(&gemini_pci_lock, irq_flags);
> +
> +	__raw_writel(PCI_CONF_BUS(bus->number) |
> +			PCI_CONF_DEVICE(PCI_SLOT(fn)) |
> +			PCI_CONF_FUNCTION(PCI_FUNC(fn)) |
> +			PCI_CONF_WHERE(config) |
> +			PCI_CONF_ENABLE,
> +			PCI_CONFIG_REG);
> +
> +	switch (size) {
> +	case 4:
> +		__raw_writel(value, PCI_DATA_REG);
> +		break;
> +	case 2:
> +		__raw_writew(value, PCI_DATA_REG + (config&  3));
> +		break;
> +	case 1:
> +		__raw_writeb(value, PCI_DATA_REG + (config&  3));
> +		break;
> +	default:
> +		ret = PCIBIOS_BAD_REGISTER_NUMBER;
> +	}
> +
> +	spin_unlock_irqrestore(&gemini_pci_lock, irq_flags);
> +
> +	return ret;
> +}
> +
> +static struct pci_ops gemini_pci_ops = {
> +	.read	= gemini_pci_read_config,
> +	.write	= gemini_pci_write_config,
> +};
> +
> +static int __init gemini_pci_request_resources(struct pci_sys_data *sys)
> +{
> +	if (request_resource(&ioport_resource,&gemini_pci_resource_io))
> +		goto bad_resources;
> +	if (request_resource(&iomem_resource,&gemini_pci_resource_mem))
> +		goto bad_resources;
> +
> +	sys->resource[0] =&gemini_pci_resource_io;
> +	sys->resource[1] =&gemini_pci_resource_mem;
> +	sys->resource[2] = 0;
> +
> +	return 0;
> +
> +bad_resources:
> +	pr_err("Gemini PCI: request_resource() failed. "
> +			"Abort PCI bus enumeration.\n");
> +	return -1;
> +}
> +
> +static int __init gemini_pci_setup(int nr, struct pci_sys_data *sys)
> +{
> +	unsigned int cmd;
> +
> +	if ((nr>  0) || gemini_pci_request_resources(sys))
> +		return 0;
> +
> +	/* setup I/O space to 1MB size */
> +	__raw_writel(GEMINI_PCI_IOSIZE_1M, PCI_IOSIZE_REG);
> +
> +	/* setup hostbridge */
> +	cmd = __raw_readl(PCI_CTRL_REG);
> +	cmd |= PCI_COMMAND_IO;
> +	cmd |= PCI_COMMAND_MEMORY;
> +	cmd |= PCI_COMMAND_MASTER;
> +	__raw_writel(cmd, PCI_CTRL_REG);
> +
> +	return 1;
> +}
> +
> +static struct pci_bus __init *gemini_pci_scan_bus(int nr,
> +	struct pci_sys_data *sys)
> +{
> +	unsigned int reg = 0;
> +	struct pci_bus *bus = 0;
> +
> +	bus = pci_scan_bus(nr,&gemini_pci_ops, sys);
> +	if (bus) {
> +		dev_dbg(&bus->dev, "setting up PCI DMA\n");
> +		reg = (GEMINI_PCI_DMA_MEM1_BASE&  GEMINI_PCI_DMA_MASK)
> +			| (GEMINI_PCI_DMA_MEM1_SIZE<<  16);
> +		gemini_pci_write_config(bus, 0, GEMINI_PCI_MEM1_BASE_SIZE,
> +					4, reg);
> +		reg =	(GEMINI_PCI_DMA_MEM2_BASE&  GEMINI_PCI_DMA_MASK)
> +			| (GEMINI_PCI_DMA_MEM2_SIZE<<  16);
> +		gemini_pci_write_config(bus, 0, GEMINI_PCI_MEM2_BASE_SIZE,
> +					4, reg);
> +		reg = (GEMINI_PCI_DMA_MEM3_BASE&  GEMINI_PCI_DMA_MASK)
> +			| (GEMINI_PCI_DMA_MEM3_SIZE<<  16);
> +		gemini_pci_write_config(bus, 0, GEMINI_PCI_MEM3_BASE_SIZE,
> +					4, reg);
> +	}
> +
> +	return bus;
> +}
> +
> +/* Should work with all boards based on original Storlink EVB */
> +static int __init gemini_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
> +{
> +	if (slot<  9 || slot>  12)
> +		return -1;
> +
> +	return PCI_IRQ_BASE + (((slot - 9) + (pin - 1))&  0x3);
> +}
> +
> +static struct hw_pci gemini_hw_pci __initdata = {
> +	.nr_controllers	= 1,
> +	.setup		= gemini_pci_setup,
> +	.scan           = gemini_pci_scan_bus,
> +	.swizzle	= pci_std_swizzle,
> +	.map_irq	= gemini_pci_map_irq,
> +};
> +
> +/* we need this for muxed PCI interrupts handling */
> +static struct pci_bus bogus_pci_bus;
> +
> +static void gemini_pci_ack_irq(unsigned int irq)
> +{
> +	unsigned int reg;
> +
> +	gemini_pci_read_config(&bogus_pci_bus, 0, GEMINI_PCI_CTRL2, 4,&reg);
> +	reg&= ~(0xF<<  PCI_CTRL2_INTSTS_OFFSET);
> +	reg |= 1<<  (irq - PCI_IRQ_BASE + PCI_CTRL2_INTSTS_OFFSET);
> +	gemini_pci_write_config(&bogus_pci_bus, 0, GEMINI_PCI_CTRL2, 4, reg);
> +}
> +
> +static void gemini_pci_mask_irq(unsigned int irq)
> +{
> +	unsigned int reg;
> +
> +	gemini_pci_read_config(&bogus_pci_bus, 0, GEMINI_PCI_CTRL2, 4,&reg);
> +	reg&= ~((0xF<<  PCI_CTRL2_INTSTS_OFFSET)
> +		| (1<<  (irq - PCI_IRQ_BASE + PCI_CTRL2_INTMASK_OFFSET)));
> +	gemini_pci_write_config(&bogus_pci_bus, 0, GEMINI_PCI_CTRL2, 4, reg);
> +}
> +
> +static void gemini_pci_unmask_irq(unsigned int irq)
> +{
> +	unsigned int reg;
> +
> +	gemini_pci_read_config(&bogus_pci_bus, 0, GEMINI_PCI_CTRL2, 4,&reg);
> +	reg&= ~(0xF<<  PCI_CTRL2_INTSTS_OFFSET);
> +	reg |= 1<<  (irq - PCI_IRQ_BASE + PCI_CTRL2_INTMASK_OFFSET);
> +	gemini_pci_write_config(&bogus_pci_bus, 0, GEMINI_PCI_CTRL2, 4, reg);
> +}
> +
> +static void gemini_pci_irq_handler(unsigned int irq, struct irq_desc *desc)
> +{
> +	unsigned int pci_irq_no, irq_stat, reg, i;
> +
> +	gemini_pci_read_config(&bogus_pci_bus, 0, GEMINI_PCI_CTRL2, 4,&reg);
> +	irq_stat = reg>>  PCI_CTRL2_INTSTS_OFFSET;
> +
> +	for (i = 0; i<  4; i++) {
> +
> +		if ((irq_stat&  (1<<  i)) == 0)
> +			continue;
> +
> +		pci_irq_no = PCI_IRQ_BASE + i;
> +
> +		BUG_ON(!(irq_desc[pci_irq_no].handle_irq));
> +		irq_desc[pci_irq_no].handle_irq(pci_irq_no,
> +				&irq_desc[pci_irq_no]);
> +	}
> +}
> +
> +static struct irq_chip gemini_pci_irq_chip = {
> +	.name = "PCI",
> +	.ack = gemini_pci_ack_irq,
> +	.mask = gemini_pci_mask_irq,
> +	.unmask = gemini_pci_unmask_irq,
> +};
> +
> +static int __init gemini_pci_init(void)
> +{
> +	int i;
> +
> +	for (i = 72; i<= 95; i++)
> +		gpio_request(i, "PCI");
> +
> +	/* initialize our bogus bus */
> +	dev_set_name(&bogus_pci_bus.dev, "PCI IRQ handler");
> +	bogus_pci_bus.number = 0;
> +
> +	/* mask and clear all interrupts */
> +	gemini_pci_write_config(&bogus_pci_bus, 0, GEMINI_PCI_CTRL2 + 2, 2,
> +				0xF000);
> +
> +	for (i = PCI_IRQ_BASE; i<  PCI_IRQ_BASE + 4; i++) {
> +		set_irq_chip(i,&gemini_pci_irq_chip);
> +		set_irq_handler(i, handle_level_irq);
> +		set_irq_flags(i, IRQF_VALID);
> +	}
> +
> +	set_irq_chained_handler(IRQ_PCI, gemini_pci_irq_handler);
> +
> +	pci_common_init(&gemini_hw_pci);
> +
> +	return 0;
> +}
> +
> +subsys_initcall(gemini_pci_init);

