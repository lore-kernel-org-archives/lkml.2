Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1KNLoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 06:44:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43280 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab1KNLop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 06:44:45 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] ARM: NUC900: Add PCI driver support for NUC960
Date: Mon, 14 Nov 2011 12:44:38 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Wan ZongShun <mcuos.com@gmail.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
References: <4EBE98FC.6070903@gmail.com> <4EC0BF9B.2050300@gmail.com>
In-Reply-To: <4EC0BF9B.2050300@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111141244.39117.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Modify PCI driver for nuc960 per Russell's comments as following:
> (1)Use the common PCI swizzle API.
> (2)Use the pr_err insteading of prink.
> (3)Request the IO resource in ioport_resource tree.
> 
> Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
> 
> ---
>  arch/arm/mach-w90x900/Kconfig                 |    1 +
>  arch/arm/mach-w90x900/Makefile                |    3 +
>  arch/arm/mach-w90x900/include/mach/map.h      |    4 +
>  arch/arm/mach-w90x900/include/mach/regs-pci.h |   37 +++++
>  arch/arm/mach-w90x900/nuc960.c                |    2 +
>  arch/arm/mach-w90x900/pci.c                   |  195
> +++++++++++++++++++++++++
>  6 files changed, 242 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-w90x900/include/mach/regs-pci.h
>  create mode 100644 arch/arm/mach-w90x900/pci.c
> 
> diff --git a/arch/arm/mach-w90x900/Kconfig b/arch/arm/mach-w90x900/Kconfig
> index 69bab32..17be262 100644
> --- a/arch/arm/mach-w90x900/Kconfig
> +++ b/arch/arm/mach-w90x900/Kconfig
> @@ -41,6 +41,7 @@ menu "NUC960 Machines"
>  config MACH_W90N960EVB
>  	bool "Nuvoton NUC960 Evaluation Board"
>  	select CPU_NUC960
> +	select PCI
>  	help
>  	   Say Y here if you are using the Nuvoton NUC960EVB
> 
> diff --git a/arch/arm/mach-w90x900/Makefile
> b/arch/arm/mach-w90x900/Makefile index 828c032..0c35800 100644
> --- a/arch/arm/mach-w90x900/Makefile
> +++ b/arch/arm/mach-w90x900/Makefile
> @@ -17,3 +17,6 @@ obj-$(CONFIG_CPU_NUC960)	+= nuc960.o
>  obj-$(CONFIG_MACH_W90P910EVB)	+= mach-nuc910evb.o
>  obj-$(CONFIG_MACH_W90P950EVB)	+= mach-nuc950evb.o
>  obj-$(CONFIG_MACH_W90N960EVB)	+= mach-nuc960evb.o
> +
> +# Add pci support for nuc960, nuc920
> +obj-$(CONFIG_PCI)		+= pci.o
> diff --git a/arch/arm/mach-w90x900/include/mach/map.h
> b/arch/arm/mach-w90x900/include/mach/map.h
> index 1a20953..69f6c73 100644
> --- a/arch/arm/mach-w90x900/include/mach/map.h
> +++ b/arch/arm/mach-w90x900/include/mach/map.h
> @@ -154,4 +154,8 @@
>  #define W90X900_PA_EMC		(0xB0003000)
>  #define W90X900_SZ_EMC		SZ_4K
> 
> +/* PCI interface controller */
> +#define	W90X900_VA_PCI		W90X900_ADDR(0x00002000)
> +#define	W90X900_PA_PCI		(0xB0002000)
> +#define	W90X900_SZ_PCI		SZ_4K
>  #endif /* __ASM_ARCH_MAP_H */
> diff --git a/arch/arm/mach-w90x900/include/mach/regs-pci.h
> b/arch/arm/mach-w90x900/include/mach/regs-pci.h
> new file mode 100644
> index 0000000..d1975eb
> --- /dev/null
> +++ b/arch/arm/mach-w90x900/include/mach/regs-pci.h
> @@ -0,0 +1,37 @@
> +/*
> + * arch/arm/mach-w90x900/include/mach/regs-pci.h
> + *
> + * Copyright (c) 2011 Nuvoton technology corporation.
> + *
> + * Wan ZongShun <mcuos.com@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation;version 2 of the License.
> + *
> + */
> +
> +#ifndef __ASM_ARCH_REGS_PCI_H
> +#define __ASM_ARCH_REGS_PCI_H
> +
> +#define PCI_BA    W90X900_VA_PCI /* PCI Control */
> +/* PCI Control Registers */
> +#define REG_PCICTR		(PCI_BA + 0x000)
> +#define REG_PCISTR		(PCI_BA + 0x004)
> +#define REG_PCILATIMER		(PCI_BA + 0x008)
> +#define REG_PCIINTEN		(PCI_BA + 0x010)
> +#define REG_PCIINT		(PCI_BA + 0x014)
> +#define REG_CFGADDR		(PCI_BA + 0x020)
> +#define REG_CFGDATA		(PCI_BA + 0x024)
> +#define REG_PCIARB		(PCI_BA + 0x04C)
> +#define REG_PCIBIST		(PCI_BA + 0x050)
> +
> +#define NUC900_PCI_IO_BASE	0xE0000000
> +#define NUC900_PCI_IO_END	0xE000FFFF
> +#define NUC900_PCI_IO_SIZE	0x10000
> +
> +#define NUC900_PCI_MEM_BASE	0xC0000000
> +#define NUC900_PCI_MEM_END	0xDFFFEFFFF
> +#define NUC900_PCI_MEM_SIZE	0x20000000
> +
> +#endif /* ___ASM_ARCH_REGS_PCI_H */
> diff --git a/arch/arm/mach-w90x900/nuc960.c
> b/arch/arm/mach-w90x900/nuc960.c index 8851a3a..0212964 100644
> --- a/arch/arm/mach-w90x900/nuc960.c
> +++ b/arch/arm/mach-w90x900/nuc960.c
> @@ -19,6 +19,7 @@
>  #include <asm/mach/map.h>
>  #include <mach/hardware.h>
>  #include "cpu.h"
> +#include "clock.h"
> 
>  /* define specific CPU platform device */
> 
> @@ -30,6 +31,7 @@ static struct platform_device *nuc960_dev[] __initdata =
> { /* define specific CPU platform io map */
> 
>  static struct map_desc nuc960evb_iodesc[] __initdata = {
> +	IODESC_ENT(PCI),
>  };
> 
>  /*Init NUC960 evb io*/
> diff --git a/arch/arm/mach-w90x900/pci.c b/arch/arm/mach-w90x900/pci.c
> new file mode 100644
> index 0000000..74095b0
> --- /dev/null
> +++ b/arch/arm/mach-w90x900/pci.c
> @@ -0,0 +1,195 @@
> +/*
> + * linux/arch/arm/mach-w90x900/pci.c
> + *
> + * Copyright (c) 2008 Nuvoton technology corporation.
> + *
> + * Wan ZongShun <mcuos.com@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation;version 2 of the License.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/pci.h>
> +#include <linux/ioport.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +
> +#include <mach/hardware.h>
> +#include <asm/irq.h>
> +#include <asm/system.h>
> +#include <asm/mach/pci.h>
> +
> +#include <mach/regs-pci.h>
> +#include <mach/regs-clock.h>
> +#include <mach/regs-gcr.h>
> +
> +#define EXTAL15M	(0x03 << 2)
> +#define CK33DIV5	(0x05 << 4)
> +#define RESET_VAL1	0x20C0
> +#define RESET_VAL2	0x20CF
> +
> +static int nuc900_read_config(struct pci_bus *bus, unsigned int devfn,
> +				int where,  int size, unsigned int  *val)
> +{
> +	unsigned int v;
> +
> +	__raw_writel(devfn * 0x100 + (where & 0xfffffffc), REG_CFGADDR);
> +	v = __raw_readl(REG_CFGDATA);
> +	switch (size) {
> +	case 1:
> +		*val = (v >> ((where % 4) * 8)) & 0xff;
> +		break;
> +	case 2:
> +		*val = (v >> ((where % 4) * 8)) & 0xffff;
> +		break;
> +	default:

case 4 ? Default case should error out.

> +		*val = v;
> +		break;
> +	}
> +
> +	return PCIBIOS_SUCCESSFUL;
> +}
> +
> +
> +static int nuc900_write_config(struct pci_bus *bus, unsigned int devfn,
> +					int where, int size, unsigned int val)
> +{
> +	unsigned int v;
> +
> +	__raw_writel(devfn * 0x100 + where, REG_CFGADDR);
> +
> +	v = __raw_readl(REG_CFGDATA);
> +
> +	__raw_writel(devfn * 0x100 + where, REG_CFGADDR);
> +
> +	switch (size) {
> +	case 1:
> +		v &= ~(0xff << (where % 4) * 8);
> +		v |= (val << (where % 4) * 8);
> +		__raw_writel(val, REG_CFGDATA);
> +		break;
> +	case 2:
> +		v &= ~(0xffff << (where % 4) * 8);
> +		v |= (val << (where % 4) * 8);
> +		__raw_writel(val, REG_CFGDATA);
> +		break;
> +	case 4:
> +		__raw_writel(val, REG_CFGDATA);
> +		break;
> +	}
> +	return PCIBIOS_SUCCESSFUL;
> +}
> +
> +static struct pci_ops pci_nuc900_ops = {
> +	.read	= nuc900_read_config,
> +	.write	= nuc900_write_config,
> +};
> +
> +static struct resource pci_io = {
> +	.name	= "NUC900 PCI IO",
> +	.start	= NUC900_PCI_IO_BASE,
> +	.end	= NUC900_PCI_IO_BASE + NUC900_PCI_IO_SIZE - 1,
> +	.flags	= IORESOURCE_IO,
> +};
> +
> +static struct resource pci_mem = {
> +	.name	= "nuc900 PCI Memory",
> +	.start	= NUC900_PCI_MEM_BASE,
> +	.end	= NUC900_PCI_MEM_BASE + NUC900_PCI_MEM_SIZE - 1,
> +	.flags	= IORESOURCE_MEM,
> +};
> +
> +static int __init pci_nuc900_setup_resources(struct resource **resource)
> +{
> +	int ret = 0;
> +
> +	ret = request_resource(&ioport_resource, &pci_io);
> +	if (ret) {
> +		pr_err("%s: failed to request resources: %d\n", __func__, ret);
> +		goto out;
> +	}

newline

> +	ret = request_resource(&iomem_resource, &pci_mem);
> +	if (ret) {
> +		pr_err("%s: failed to request resources: %d\n", __func__, ret);
> +		goto release_io_mem;
> +	}
> +
> +	/*
> +	 * bus->resource[0] is the IO resource for this bus
> +	 * bus->resource[1] is the mem resource for this bus
> +	 * bus->resource[2] is the prefetch mem resource for this bus
> +	 */
> +	resource[0] = &pci_io;
> +	resource[1] = &pci_mem;
> +	resource[2] = NULL;
> +
> +	goto out;
> +
> + release_io_mem:
> +	release_resource(&pci_io);
> + out:
> +	return ret;
> +}
> +
> +int __init pci_nuc900_setup(int nr, struct pci_sys_data *sys)
> +{
> +	int ret = 0;
> +
> +	if (nr > 0)
> +		return 0;

pr_err() missing in this if ?

> +
> +	sys->mem_offset = 0;
> +	sys->io_offset = 0;
> +	ret = pci_nuc900_setup_resources(sys->resource);
> +	if (ret)
> +		pr_err("%s: failed to setup resources: %d\n", __func__, ret);
> +
> +	return !ret;
> +}
> +
> +struct pci_bus *pci_nuc900_scan_bus(int nr, struct pci_sys_data *sys)
> +{
> +	return pci_scan_bus(sys->busnr, &pci_nuc900_ops, sys);
> +}
> +
> +void __init pci_nuc900_preinit(void)
> +{
> +	/* CK33 from PLL0 */
> +	__raw_writel(__raw_readl(REG_CLKSEL) & ~EXTAL15M, REG_CLKSEL);
> +	/* PCI CLOCK = 200/6 = 33Mhz */
> +	 __raw_writel(((__raw_readl(REG_CLKDIV) &
> +				(~(0xf<<4))) | CK33DIV5), REG_CLKDIV);
> +
> +	/* enable PCI clock */
> +	__raw_writel(__raw_readl(REG_CLKEN) | 0x4, REG_CLKEN);

What's this magic 0x4?

> +
> +	__raw_writel(RESET_VAL1, REG_PCICTR);
> +
> +	mdelay(100);
> +
> +	__raw_writel(RESET_VAL2, REG_PCICTR);
> +
> +	mdelay(200);
> +}
> +
> +static struct hw_pci nuc900_pci __initdata = {
> +	.swizzle		= pci_std_swizzle,
> +	.setup			= pci_nuc900_setup,
> +	.nr_controllers		= 1,
> +	.scan			= pci_nuc900_scan_bus,
> +	.preinit		= pci_nuc900_preinit,
> +};
> +
> +static int __init nuc900_pci_init(void)
> +{
> +	pci_common_init(&nuc900_pci);
> +	return 0;
> +}
> +
> +subsys_initcall(nuc900_pci_init);

Reviewed-by: Marek Vasut <marek.vasut@gmail.com>
