Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1KOGFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 01:05:20 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46627 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1KOGFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 01:05:18 -0500
MIME-Version: 1.0
In-Reply-To: <1321333132-17662-3-git-send-email-pullip.cho@samsung.com>
References: <1321333132-17662-1-git-send-email-pullip.cho@samsung.com>
	<1321333132-17662-3-git-send-email-pullip.cho@samsung.com>
Date: Tue, 15 Nov 2011 15:05:18 +0900
X-Google-Sender-Auth: 71yRyjKvAbge241c_J4__NKJdHU
Message-ID: <CAH9JG2U1L1st_D+jp0Qm42HR8Ur7JpdYz6gFJSv+z_ZkGAQv8A@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] iommu/exynos: Add iommu driver for Exynos Platforms
From: Kyungmin Park <kmpark@infradead.org>
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        YoungLak Kim <younglak1004.kim@samsung.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/11, KyongHo Cho <pullip.cho@samsung.com> wrote:
> This is the System MMU driver and IOMMU API implementation for
> Exynos SOC platforms. Exynos platforms has more than 10 System
> MMUs dedicated for each multimedia accellerators.
>
> The System MMU driver is already in arc/arm/plat-s5p but it is
> moved to drivers/iommu due to Ohad Ben-Cohen gathered IOMMU drivers
> there
>
> This patch also includes fault handling feature in IOMMU driver
> suggested by Ohad.
> Users of IOMMU API can register its own fault handler with
> iommu_set_fault_handler() and the handler is called by IRQ handler
> of System MMU.
> If no user installs fault handler, IOMMU driver prints debugging
> message and generates kernel oops.
>
> This IOMMU driver calls bus_set_iommu() instead of register_iommu()
> since Joerg suggested that installing iommu_ops in bus_type.
>
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
> ---
>  arch/arm/plat-s5p/Kconfig                   |    8 -
>  arch/arm/plat-s5p/Makefile                  |    1 -
>  arch/arm/plat-s5p/sysmmu.c                  |  312 --------
>  arch/arm/plat-samsung/include/plat/sysmmu.h |   95 ---
>  drivers/iommu/Kconfig                       |   12 +
>  drivers/iommu/Makefile                      |    1 +
>  drivers/iommu/exynos-iommu.c                | 1035
> +++++++++++++++++++++++++++
>  7 files changed, 1048 insertions(+), 416 deletions(-)
>  delete mode 100644 arch/arm/plat-s5p/sysmmu.c
>  delete mode 100644 arch/arm/plat-samsung/include/plat/sysmmu.h
>  create mode 100644 drivers/iommu/exynos-iommu.c
>
> diff --git a/arch/arm/plat-s5p/Kconfig b/arch/arm/plat-s5p/Kconfig
> index 9b9968f..805b979 100644
> --- a/arch/arm/plat-s5p/Kconfig
> +++ b/arch/arm/plat-s5p/Kconfig
> @@ -45,14 +45,6 @@ config S5P_PM
>  	  Common code for power management support on S5P and newer SoCs
>  	  Note: Do not select this for S5P6440 and S5P6450.
>
> -comment "System MMU"
> -
> -config S5P_SYSTEM_MMU
> -	bool "S5P SYSTEM MMU"
> -	depends on ARCH_EXYNOS4
> -	help
> -	  Say Y here if you want to enable System MMU
> -
>  config S5P_SLEEP
>  	bool
>  	help
> diff --git a/arch/arm/plat-s5p/Makefile b/arch/arm/plat-s5p/Makefile
> index 8763440..0757ce0 100644
> --- a/arch/arm/plat-s5p/Makefile
> +++ b/arch/arm/plat-s5p/Makefile
> @@ -18,7 +18,6 @@ obj-y				+= clock.o
>  obj-y				+= irq.o
>  obj-$(CONFIG_S5P_EXT_INT)	+= irq-eint.o
>  obj-$(CONFIG_S5P_GPIO_INT)	+= irq-gpioint.o
> -obj-$(CONFIG_S5P_SYSTEM_MMU)	+= sysmmu.o
>  obj-$(CONFIG_S5P_PM)		+= pm.o irq-pm.o
>  obj-$(CONFIG_S5P_SLEEP)		+= sleep.o
>  obj-$(CONFIG_S5P_HRT) 		+= s5p-time.o
> diff --git a/arch/arm/plat-s5p/sysmmu.c b/arch/arm/plat-s5p/sysmmu.c
> deleted file mode 100644
> index e1cbc72..0000000
> --- a/arch/arm/plat-s5p/sysmmu.c
> +++ /dev/null
> @@ -1,312 +0,0 @@
> -/* linux/arch/arm/plat-s5p/sysmmu.c
> - *
> - * Copyright (c) 2010 Samsung Electronics Co., Ltd.
> - *		http://www.samsung.com
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#include <linux/io.h>
> -#include <linux/interrupt.h>
> -#include <linux/platform_device.h>
> -
> -#include <asm/pgtable.h>
> -
> -#include <mach/map.h>
> -#include <mach/regs-sysmmu.h>
> -#include <plat/sysmmu.h>
> -
> -#define CTRL_ENABLE	0x5
> -#define CTRL_BLOCK	0x7
> -#define CTRL_DISABLE	0x0
> -
> -static struct device *dev;
> -
> -static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
> -	S5P_PAGE_FAULT_ADDR,
> -	S5P_AR_FAULT_ADDR,
> -	S5P_AW_FAULT_ADDR,
> -	S5P_DEFAULT_SLAVE_ADDR,
> -	S5P_AR_FAULT_ADDR,
> -	S5P_AR_FAULT_ADDR,
> -	S5P_AW_FAULT_ADDR,
> -	S5P_AW_FAULT_ADDR
> -};
> -
> -static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
> -	"PAGE FAULT",
> -	"AR MULTI-HIT FAULT",
> -	"AW MULTI-HIT FAULT",
> -	"BUS ERROR",
> -	"AR SECURITY PROTECTION FAULT",
> -	"AR ACCESS PROTECTION FAULT",
> -	"AW SECURITY PROTECTION FAULT",
> -	"AW ACCESS PROTECTION FAULT"
> -};
> -
> -static int (*fault_handlers[S5P_SYSMMU_TOTAL_IPNUM])(
> -		enum S5P_SYSMMU_INTERRUPT_TYPE itype,
> -		unsigned long pgtable_base,
> -		unsigned long fault_addr);
> -
> -/*
> - * If adjacent 2 bits are true, the system MMU is enabled.
> - * The system MMU is disabled, otherwise.
> - */
> -static unsigned long sysmmu_states;
> -
> -static inline void set_sysmmu_active(sysmmu_ips ips)
> -{
> -	sysmmu_states |= 3 << (ips * 2);
> -}
> -
> -static inline void set_sysmmu_inactive(sysmmu_ips ips)
> -{
> -	sysmmu_states &= ~(3 << (ips * 2));
> -}
> -
> -static inline int is_sysmmu_active(sysmmu_ips ips)
> -{
> -	return sysmmu_states & (3 << (ips * 2));
> -}
> -
> -static void __iomem *sysmmusfrs[S5P_SYSMMU_TOTAL_IPNUM];
> -
> -static inline void sysmmu_block(sysmmu_ips ips)
> -{
> -	__raw_writel(CTRL_BLOCK, sysmmusfrs[ips] + S5P_MMU_CTRL);
> -	dev_dbg(dev, "%s is blocked.\n", sysmmu_ips_name[ips]);
> -}
> -
> -static inline void sysmmu_unblock(sysmmu_ips ips)
> -{
> -	__raw_writel(CTRL_ENABLE, sysmmusfrs[ips] + S5P_MMU_CTRL);
> -	dev_dbg(dev, "%s is unblocked.\n", sysmmu_ips_name[ips]);
> -}
> -
> -static inline void __sysmmu_tlb_invalidate(sysmmu_ips ips)
> -{
> -	__raw_writel(0x1, sysmmusfrs[ips] + S5P_MMU_FLUSH);
> -	dev_dbg(dev, "TLB of %s is invalidated.\n", sysmmu_ips_name[ips]);
> -}
> -
> -static inline void __sysmmu_set_ptbase(sysmmu_ips ips, unsigned long pgd)
> -{
> -	if (unlikely(pgd == 0)) {
> -		pgd = (unsigned long)ZERO_PAGE(0);
> -		__raw_writel(0x20, sysmmusfrs[ips] + S5P_MMU_CFG); /* 4KB LV1 */
> -	} else {
> -		__raw_writel(0x0, sysmmusfrs[ips] + S5P_MMU_CFG); /* 16KB LV1 */
> -	}
> -
> -	__raw_writel(pgd, sysmmusfrs[ips] + S5P_PT_BASE_ADDR);
> -
> -	dev_dbg(dev, "Page table base of %s is initialized with 0x%08lX.\n",
> -						sysmmu_ips_name[ips], pgd);
> -	__sysmmu_tlb_invalidate(ips);
> -}
> -
> -void sysmmu_set_fault_handler(sysmmu_ips ips,
> -			int (*handler)(enum S5P_SYSMMU_INTERRUPT_TYPE itype,
> -					unsigned long pgtable_base,
> -					unsigned long fault_addr))
> -{
> -	BUG_ON(!((ips >= SYSMMU_MDMA) && (ips < S5P_SYSMMU_TOTAL_IPNUM)));
> -	fault_handlers[ips] = handler;
> -}
> -
> -static irqreturn_t s5p_sysmmu_irq(int irq, void *dev_id)
> -{
> -	/* SYSMMU is in blocked when interrupt occurred. */
> -	unsigned long base = 0;
> -	sysmmu_ips ips = (sysmmu_ips)dev_id;
> -	enum S5P_SYSMMU_INTERRUPT_TYPE itype;
> -
> -	itype = (enum S5P_SYSMMU_INTERRUPT_TYPE)
> -		__ffs(__raw_readl(sysmmusfrs[ips] + S5P_INT_STATUS));
> -
> -	BUG_ON(!((itype >= 0) && (itype < 8)));
> -
> -	dev_alert(dev, "%s occurred by %s.\n", sysmmu_fault_name[itype],
> -							sysmmu_ips_name[ips]);
> -
> -	if (fault_handlers[ips]) {
> -		unsigned long addr;
> -
> -		base = __raw_readl(sysmmusfrs[ips] + S5P_PT_BASE_ADDR);
> -		addr = __raw_readl(sysmmusfrs[ips] + fault_reg_offset[itype]);
> -
> -		if (fault_handlers[ips](itype, base, addr)) {
> -			__raw_writel(1 << itype,
> -					sysmmusfrs[ips] + S5P_INT_CLEAR);
> -			dev_notice(dev, "%s from %s is resolved."
> -					" Retrying translation.\n",
> -				sysmmu_fault_name[itype], sysmmu_ips_name[ips]);
> -		} else {
> -			base = 0;
> -		}
> -	}
> -
> -	sysmmu_unblock(ips);
> -
> -	if (!base)
> -		dev_notice(dev, "%s from %s is not handled.\n",
> -			sysmmu_fault_name[itype], sysmmu_ips_name[ips]);
> -
> -	return IRQ_HANDLED;
> -}
> -
> -void s5p_sysmmu_set_tablebase_pgd(sysmmu_ips ips, unsigned long pgd)
> -{
> -	if (is_sysmmu_active(ips)) {
> -		sysmmu_block(ips);
> -		__sysmmu_set_ptbase(ips, pgd);
> -		sysmmu_unblock(ips);
> -	} else {
> -		dev_dbg(dev, "%s is disabled. "
> -			"Skipping initializing page table base.\n",
> -						sysmmu_ips_name[ips]);
> -	}
> -}
> -
> -void s5p_sysmmu_enable(sysmmu_ips ips, unsigned long pgd)
> -{
> -	if (!is_sysmmu_active(ips)) {
> -		sysmmu_clk_enable(ips);
> -
> -		__sysmmu_set_ptbase(ips, pgd);
> -
> -		__raw_writel(CTRL_ENABLE, sysmmusfrs[ips] + S5P_MMU_CTRL);
> -
> -		set_sysmmu_active(ips);
> -		dev_dbg(dev, "%s is enabled.\n", sysmmu_ips_name[ips]);
> -	} else {
> -		dev_dbg(dev, "%s is already enabled.\n", sysmmu_ips_name[ips]);
> -	}
> -}
> -
> -void s5p_sysmmu_disable(sysmmu_ips ips)
> -{
> -	if (is_sysmmu_active(ips)) {
> -		__raw_writel(CTRL_DISABLE, sysmmusfrs[ips] + S5P_MMU_CTRL);
> -		set_sysmmu_inactive(ips);
> -		sysmmu_clk_disable(ips);
> -		dev_dbg(dev, "%s is disabled.\n", sysmmu_ips_name[ips]);
> -	} else {
> -		dev_dbg(dev, "%s is already disabled.\n", sysmmu_ips_name[ips]);
> -	}
> -}
> -
> -void s5p_sysmmu_tlb_invalidate(sysmmu_ips ips)
> -{
> -	if (is_sysmmu_active(ips)) {
> -		sysmmu_block(ips);
> -		__sysmmu_tlb_invalidate(ips);
> -		sysmmu_unblock(ips);
> -	} else {
> -		dev_dbg(dev, "%s is disabled. "
> -			"Skipping invalidating TLB.\n", sysmmu_ips_name[ips]);
> -	}
> -}
> -
> -static int s5p_sysmmu_probe(struct platform_device *pdev)
> -{
> -	int i, ret;
> -	struct resource *res, *mem;
> -
> -	dev = &pdev->dev;
> -
> -	for (i = 0; i < S5P_SYSMMU_TOTAL_IPNUM; i++) {
> -		int irq;
> -
> -		sysmmu_clk_init(dev, i);
> -		sysmmu_clk_disable(i);
> -
> -		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
> -		if (!res) {
> -			dev_err(dev, "Failed to get the resource of %s.\n",
> -							sysmmu_ips_name[i]);
> -			ret = -ENODEV;
> -			goto err_res;
> -		}
> -
> -		mem = request_mem_region(res->start, resource_size(res),
> -					 pdev->name);
> -		if (!mem) {
> -			dev_err(dev, "Failed to request the memory region of %s.\n",
> -							sysmmu_ips_name[i]);
> -			ret = -EBUSY;
> -			goto err_res;
> -		}
> -
> -		sysmmusfrs[i] = ioremap(res->start, resource_size(res));
> -		if (!sysmmusfrs[i]) {
> -			dev_err(dev, "Failed to ioremap() for %s.\n",
> -							sysmmu_ips_name[i]);
> -			ret = -ENXIO;
> -			goto err_reg;
> -		}
> -
> -		irq = platform_get_irq(pdev, i);
> -		if (irq <= 0) {
> -			dev_err(dev, "Failed to get the IRQ resource of %s.\n",
> -							sysmmu_ips_name[i]);
> -			ret = -ENOENT;
> -			goto err_map;
> -		}
> -
> -		if (request_irq(irq, s5p_sysmmu_irq, IRQF_DISABLED,
> -						pdev->name, (void *)i)) {
> -			dev_err(dev, "Failed to request IRQ for %s.\n",
> -							sysmmu_ips_name[i]);
> -			ret = -ENOENT;
> -			goto err_map;
> -		}
> -	}
> -
> -	return 0;
> -
> -err_map:
> -	iounmap(sysmmusfrs[i]);
> -err_reg:
> -	release_mem_region(mem->start, resource_size(mem));
> -err_res:
> -	return ret;
> -}
> -
> -static int s5p_sysmmu_remove(struct platform_device *pdev)
> -{
> -	return 0;
> -}
> -int s5p_sysmmu_runtime_suspend(struct device *dev)
> -{
> -	return 0;
> -}
> -
> -int s5p_sysmmu_runtime_resume(struct device *dev)
> -{
> -	return 0;
> -}
> -
> -const struct dev_pm_ops s5p_sysmmu_pm_ops = {
> -	.runtime_suspend	= s5p_sysmmu_runtime_suspend,
> -	.runtime_resume		= s5p_sysmmu_runtime_resume,
> -};
> -
> -static struct platform_driver s5p_sysmmu_driver = {
> -	.probe		= s5p_sysmmu_probe,
> -	.remove		= s5p_sysmmu_remove,
> -	.driver		= {
> -		.owner		= THIS_MODULE,
> -		.name		= "s5p-sysmmu",
> -		.pm		= &s5p_sysmmu_pm_ops,
> -	}
> -};
> -
> -static int __init s5p_sysmmu_init(void)
> -{
> -	return platform_driver_register(&s5p_sysmmu_driver);
> -}
> -arch_initcall(s5p_sysmmu_init);
> diff --git a/arch/arm/plat-samsung/include/plat/sysmmu.h
> b/arch/arm/plat-samsung/include/plat/sysmmu.h
> deleted file mode 100644
> index 5fe8ee0..0000000
> --- a/arch/arm/plat-samsung/include/plat/sysmmu.h
> +++ /dev/null
> @@ -1,95 +0,0 @@
> -/* linux/arch/arm/plat-samsung/include/plat/sysmmu.h
> - *
> - * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> - *		http://www.samsung.com
> - *
> - * Samsung System MMU driver for S5P platform
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> -*/
> -
> -#ifndef __PLAT_SAMSUNG_SYSMMU_H
> -#define __PLAT_SAMSUNG_SYSMMU_H __FILE__
> -
> -enum S5P_SYSMMU_INTERRUPT_TYPE {
> -	SYSMMU_PAGEFAULT,
> -	SYSMMU_AR_MULTIHIT,
> -	SYSMMU_AW_MULTIHIT,
> -	SYSMMU_BUSERROR,
> -	SYSMMU_AR_SECURITY,
> -	SYSMMU_AR_ACCESS,
> -	SYSMMU_AW_SECURITY,
> -	SYSMMU_AW_PROTECTION, /* 7 */
> -	SYSMMU_FAULTS_NUM
> -};
> -
> -#ifdef CONFIG_S5P_SYSTEM_MMU
> -
> -#include <mach/sysmmu.h>
> -
> -/**
> - * s5p_sysmmu_enable() - enable system mmu of ip
> - * @ips: The ip connected system mmu.
> - * #pgd: Base physical address of the 1st level page table
> - *
> - * This function enable system mmu to transfer address
> - * from virtual address to physical address
> - */
> -void s5p_sysmmu_enable(sysmmu_ips ips, unsigned long pgd);
> -
> -/**
> - * s5p_sysmmu_disable() - disable sysmmu mmu of ip
> - * @ips: The ip connected system mmu.
> - *
> - * This function disable system mmu to transfer address
> - * from virtual address to physical address
> - */
> -void s5p_sysmmu_disable(sysmmu_ips ips);
> -
> -/**
> - * s5p_sysmmu_set_tablebase_pgd() - set page table base address to refer
> page table
> - * @ips: The ip connected system mmu.
> - * @pgd: The page table base address.
> - *
> - * This function set page table base address
> - * When system mmu transfer address from virtaul address to physical
> address,
> - * system mmu refer address information from page table
> - */
> -void s5p_sysmmu_set_tablebase_pgd(sysmmu_ips ips, unsigned long pgd);
> -
> -/**
> - * s5p_sysmmu_tlb_invalidate() - flush all TLB entry in system mmu
> - * @ips: The ip connected system mmu.
> - *
> - * This function flush all TLB entry in system mmu
> - */
> -void s5p_sysmmu_tlb_invalidate(sysmmu_ips ips);
> -
> -/** s5p_sysmmu_set_fault_handler() - Fault handler for System MMUs
> - * @itype: type of fault.
> - * @pgtable_base: the physical address of page table base. This is 0 if
> @ips is
> - *               SYSMMU_BUSERROR.
> - * @fault_addr: the device (virtual) address that the System MMU tried to
> - *             translated. This is 0 if @ips is SYSMMU_BUSERROR.
> - * Called when interrupt occurred by the System MMUs
> - * The device drivers of peripheral devices that has a System MMU can
> implement
> - * a fault handler to resolve address translation fault by System MMU.
> - * The meanings of return value and parameters are described below.
> -
> - * return value: non-zero if the fault is correctly resolved.
> - *         zero if the fault is not handled.
> - */
> -void s5p_sysmmu_set_fault_handler(sysmmu_ips ips,
> -			int (*handler)(enum S5P_SYSMMU_INTERRUPT_TYPE itype,
> -					unsigned long pgtable_base,
> -					unsigned long fault_addr));
> -#else
> -#define s5p_sysmmu_enable(ips, pgd) do { } while (0)
> -#define s5p_sysmmu_disable(ips) do { } while (0)
> -#define s5p_sysmmu_set_tablebase_pgd(ips, pgd) do { } while (0)
> -#define s5p_sysmmu_tlb_invalidate(ips) do { } while (0)
> -#define s5p_sysmmu_set_fault_handler(ips, handler) do { } while (0)
> -#endif
> -#endif /* __ASM_PLAT_SYSMMU_H */
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 5414253..b45a1e3 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -131,4 +131,16 @@ config OMAP_IOMMU_DEBUG
>
>           Say N unless you know you need this.
>
> +config EXYNOS_IOMMU
> +	bool "Exynos IOMMU Support"
> +	depends on ARCH_EXYNOS
> +	select IOMMU_API
> +	help
> +	  Support for the IOMMU(System MMU) of Samsung Exynos application
> +	  processor family. This enables H/W multimedia accellerators to see
> +	  non-linear physical memory chunks as a linear memory in their
> +	  address spaces
> +
> +	  If unsure, say N here.
> +
>  endif # IOMMU_SUPPORT
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index 2f44487..c8a5558 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_IRQ_REMAP) += intr_remapping.o
>  obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
>  obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
>  obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
> +obj-$(CONFIG_EXYNOS_IOMMU) += exynos-iommu.o
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> new file mode 100644
> index 0000000..5e2d82b
> --- /dev/null
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -0,0 +1,1035 @@
> +/* linux/drivers/iommu/exynos_iommu.c
> + *
> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/mm.h>
> +#include <linux/iommu.h>
> +#include <linux/errno.h>
> +#include <linux/list.h>
> +#include <linux/export.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/pgtable.h>
> +
> +#include <mach/map.h>
> +#include <mach/regs-sysmmu.h>
> +
> +#define CTRL_ENABLE	0x5
> +#define CTRL_BLOCK	0x7
> +#define CTRL_DISABLE	0x0
> +
> +enum EXYNOS_SYSMMU_INTERRUPT_TYPE {
> +	SYSMMU_PAGEFAULT,
> +	SYSMMU_AR_MULTIHIT,
> +	SYSMMU_AW_MULTIHIT,
> +	SYSMMU_BUSERROR,
> +	SYSMMU_AR_SECURITY,
> +	SYSMMU_AR_ACCESS,
> +	SYSMMU_AW_SECURITY,
> +	SYSMMU_AW_PROTECTION, /* 7 */
> +	SYSMMU_FAULT_UNKNOWN,
> +	SYSMMU_FAULTS_NUM
> +};
> +
> +typedef int (*sysmmu_fault_handler_t)(enum EXYNOS_SYSMMU_INTERRUPT_TYPE
> itype,
> +			unsigned long pgtable_base, unsigned long fault_addr);
> +
> +static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
> +	EXYNOS_PAGE_FAULT_ADDR,
> +	EXYNOS_AR_FAULT_ADDR,
> +	EXYNOS_AW_FAULT_ADDR,
> +	EXYNOS_DEFAULT_SLAVE_ADDR,
> +	EXYNOS_AR_FAULT_ADDR,
> +	EXYNOS_AR_FAULT_ADDR,
> +	EXYNOS_AW_FAULT_ADDR,
> +	EXYNOS_AW_FAULT_ADDR
> +};
> +
> +static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
> +	"PAGE FAULT",
> +	"AR MULTI-HIT FAULT",
> +	"AW MULTI-HIT FAULT",
> +	"BUS ERROR",
> +	"AR SECURITY PROTECTION FAULT",
> +	"AR ACCESS PROTECTION FAULT",
> +	"AW SECURITY PROTECTION FAULT",
> +	"AW ACCESS PROTECTION FAULT",
> +	"UNKNOWN FAULT"
> +};
> +
> +struct exynos_iommu_domain;
> +
> +struct sysmmu_drvdata {
> +	struct list_head node;
> +	struct device *dev;
> +	struct device *owner;
> +	void __iomem *sfrbase;
> +	struct clk *clk;
> +	int activations;
> +	rwlock_t lock;
> +	struct iommu_domain *domain;
> +	sysmmu_fault_handler_t fault_handler;
> +	unsigned long pgtable;
> +};
> +
> +static LIST_HEAD(sysmmu_list);
> +
> +static struct sysmmu_drvdata *get_sysmmu_data(struct device *owner,
> +						struct sysmmu_drvdata *start)
> +{
> +	if (start) {
> +		list_for_each_entry_continue(start, &sysmmu_list, node)
> +			if (start->owner == owner)
> +				return start;
> +	} else  {
> +		list_for_each_entry(start, &sysmmu_list, node)
> +			if (start->owner == owner)
> +				return start;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct sysmmu_drvdata *get_sysmmu_data_rollback(struct device
> *owner,
> +						struct sysmmu_drvdata *start)
> +{
> +	if (start) {
> +		list_for_each_entry_continue_reverse(start, &sysmmu_list, node)
> +			if (start->owner == owner)
> +				return start;
> +	}
> +
> +	return NULL;
> +}
> +
> +static bool set_sysmmu_active(struct sysmmu_drvdata *data)
> +{
> +	/* return true if the System MMU was not active previously
> +	   and it needs to be initialized */
> +	data->activations++;
> +	return data->activations == 1;
> +}
If it calls the twice, then caller get the active failed return value.
Are there no case to call the multiple activation?
> +
> +static bool set_sysmmu_inactive(struct sysmmu_drvdata *data)
> +{
> +	/* return true if the System MMU is needed to be disabled */
> +	data->activations--;
> +
> +	WARN_ON(data->activations < 0);
> +
> +	return data->activations == 0;
> +}
> +
> +static bool is_sysmmu_active(struct sysmmu_drvdata *data)
> +{
> +	return data->activations != 0;
> +}
> +
> +static void sysmmu_block(void __iomem *sfrbase)
> +{
> +	__raw_writel(CTRL_BLOCK, sfrbase + EXYNOS_MMU_CTRL);
> +}
> +
> +static void sysmmu_unblock(void __iomem *sfrbase)
> +{
> +	__raw_writel(CTRL_ENABLE, sfrbase + EXYNOS_MMU_CTRL);
> +}
> +
> +static void __sysmmu_tlb_invalidate(void __iomem *sfrbase)
> +{
> +	__raw_writel(0x1, sfrbase + EXYNOS_MMU_FLUSH);
> +}
> +
> +static void __sysmmu_set_ptbase(void __iomem *sfrbase,
> +				       unsigned long pgd)
> +{
> +	if (unlikely(pgd == 0)) {
> +		pgd = page_to_phys(ZERO_PAGE(0));
> +		__raw_writel(0x20, sfrbase + EXYNOS_MMU_CFG); /* 4KB LV1 */
> +	} else {
> +		__raw_writel(0x0, sfrbase + EXYNOS_MMU_CFG); /* 16KB LV1 */
> +	}
> +
> +	__raw_writel(pgd, sfrbase + EXYNOS_PT_BASE_ADDR);
> +
> +	__sysmmu_tlb_invalidate(sfrbase);
> +}
> +
> +static void __set_fault_handler(struct sysmmu_drvdata *data,
> +					sysmmu_fault_handler_t handler)
> +{
> +	unsigned long flags;
> +
> +	write_lock_irqsave(&data->lock, flags);
> +	data->fault_handler = handler;
> +	write_unlock_irqrestore(&data->lock, flags);
> +}
> +
> +void exynos_sysmmu_set_fault_handler(struct device *owner,
> +					sysmmu_fault_handler_t handler)
> +{
> +	struct sysmmu_drvdata *data = NULL;
> +
> +	while ((data = get_sysmmu_data(owner, data)))
> +		__set_fault_handler(data, handler);
> +}
> +
> +static int default_fault_handler(enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype,
> +		     unsigned long pgtable_base, unsigned long fault_addr)
> +{
> +	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
> +		itype = SYSMMU_FAULT_UNKNOWN;
> +
> +	pr_err("%s occured at 0x%lx(Page table base: 0x%lx)\n",
> +			sysmmu_fault_name[itype], fault_addr, pgtable_base);
> +	pr_err("\t\tGenerating Kernel OOPS... because it is unrecoverable.\n");
> +
> +	BUG();
> +
> +	return 0;
> +}
> +
> +static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> +{
> +	/* SYSMMU is in blocked when interrupt occurred. */
> +	struct sysmmu_drvdata *data = dev_id;
> +	enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype;
> +	unsigned long addr;
> +	int ret = -ENOSYS;
> +
> +	read_lock(&data->lock);
> +
> +	WARN_ON(!is_sysmmu_active(data));
> +
> +	itype = (enum EXYNOS_SYSMMU_INTERRUPT_TYPE)
> +		__ffs(__raw_readl(data->sfrbase + EXYNOS_INT_STATUS));
> +
> +	if (WARN_ON((itype >= 0) && (itype < 8))) {
> +		itype = SYSMMU_FAULT_UNKNOWN;
> +		addr = (unsigned long)-1;
> +	} else {
> +		addr = __raw_readl(data->sfrbase + fault_reg_offset[itype]);
> +	}
> +
> +	if (data->domain)
> +		ret = report_iommu_fault(data->domain, data->owner, addr,
> +									itype);
> +	if ((ret == -ENOSYS) && data->fault_handler) {
> +		unsigned long base;
> +		base = __raw_readl(data->sfrbase + EXYNOS_PT_BASE_ADDR);
> +		ret = data->fault_handler(itype, base, addr);
> +	}
> +
> +	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
> +		__raw_writel(1 << itype, data->sfrbase + EXYNOS_INT_CLEAR);
> +	else
> +		dev_dbg(data->dev, "%s is not handled.\n",
> +						sysmmu_fault_name[itype]);
> +
> +	sysmmu_unblock(data->sfrbase);
> +
> +	read_unlock(&data->lock);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +void exynos_sysmmu_set_tablebase_pgd(struct device *owner, unsigned long
> pgd)
> +{
> +	struct sysmmu_drvdata *data = NULL;
> +
> +	while ((data = get_sysmmu_data(owner, data))) {
> +		unsigned long flags;
> +
> +		read_lock_irqsave(&data->lock, flags);
It should be 'write_lock_irqsave'
> +
> +		if (is_sysmmu_active(data)) {
> +			sysmmu_block(data->sfrbase);
> +			__sysmmu_set_ptbase(data->sfrbase, pgd);
> +			sysmmu_unblock(data->sfrbase);
> +			dev_dbg(data->dev, "New page table base is %p\n",
> +								(void *)pgd);
> +		} else {
> +			dev_dbg(data->dev,
> +			"Disabled: Skipping setting page table base.\n");
> +		}
> +
> +		read_unlock_irqrestore(&data->lock, flags);
It should be 'write_unlock_irqrestore'
> +	}
> +}
> +
> +static bool __sysmmu_disable(struct sysmmu_drvdata *data, bool
> reset_domain)
> +{
> +	unsigned long flags;
> +	bool disabled = false;
> +
> +	write_lock_irqsave(&data->lock, flags);
> +
> +	if (set_sysmmu_inactive(data)) {
> +		__raw_writel(CTRL_DISABLE, data->sfrbase + EXYNOS_MMU_CTRL);
> +		clk_disable(data->clk);
> +		disabled = true;
> +		data->pgtable = 0;
> +	}
> +
> +	if (reset_domain)
> +		data->domain = NULL;
> +
> +	write_unlock_irqrestore(&data->lock, flags);
> +
> +	pm_runtime_put_sync(data->dev);
> +
> +	return disabled;
> +}
> +
> +static int __exynos_sysmmu_enable(struct device *owner, unsigned long
> pgtable,
> +						struct iommu_domain *domain)
> +{
> +	int ret = 0;
> +	unsigned long flags;
> +	struct sysmmu_drvdata *data = NULL;
> +
> +	/* There are some devices that control more System MMUs than one such
> +	 * as MFC.
> +	 */
> +	while ((data = get_sysmmu_data(owner, data))) {
> +		ret = pm_runtime_get_sync(data->dev);
> +		if (ret < 0)
> +			break;
> +
> +		write_lock_irqsave(&data->lock, flags);
> +
> +		if (set_sysmmu_active(data)) {
> +			clk_enable(data->clk);
> +
> +			data->pgtable = pgtable;
> +
> +			__sysmmu_set_ptbase(data->sfrbase, pgtable);
> +
> +			__raw_writel(CTRL_ENABLE, data->sfrbase + EXYNOS_MMU_CTRL);
> +
> +			data->domain = domain;
> +
> +			dev_dbg(data->dev, "Enabled.\n");
> +		} else {
> +			dev_dbg(data->dev, "Already enabled.\n");
> +		}
> +
> +		write_unlock_irqrestore(&data->lock, flags);
> +	}
> +
> +	if (ret < 0) {
> +		while ((data = get_sysmmu_data_rollback(owner, data))) {
> +			__sysmmu_disable(data, (domain != NULL));
> +			dev_dbg(data->dev, "Failed to enable.\n");
> +		}
> +	} else {
> +		ret = 0;
> +	}
> +
> +	return ret;
> +}
> +
> +int exynos_sysmmu_enable(struct device *owner, unsigned long pgtable)
> +{
> +	return __exynos_sysmmu_enable(owner, pgtable, NULL);
> +}
> +
> +static void exynos_iommu_disable(struct device *owner, bool reset_domain)
> +{
> +	struct sysmmu_drvdata *data = NULL;
> +
> +	while ((data = get_sysmmu_data(owner, data))) {
> +		if (__sysmmu_disable(data, reset_domain))
> +			dev_dbg(data->dev, "Disabled.\n");
> +		else
> +			dev_dbg(data->dev,
> +					"Deactivation request ignorred\n");
> +	}
> +}
> +
> +void exynos_sysmmu_disable(struct device *owner)
> +{
> +	exynos_iommu_disable(owner, false);
> +}
> +
> +void exynos_sysmmu_tlb_invalidate(struct device *owner)
> +{
> +	struct sysmmu_drvdata *data = NULL;
> +
> +	while ((data = get_sysmmu_data(owner, data))) {
> +		unsigned long flags;
> +
> +		read_lock_irqsave(&data->lock, flags);
doesn't use the write_lock_irqsave here?
> +
> +		if (is_sysmmu_active(data)) {
> +			sysmmu_block(data->sfrbase);
> +			__sysmmu_tlb_invalidate(data->sfrbase);
> +			sysmmu_unblock(data->sfrbase);
> +		} else {
> +			dev_dbg(data->dev,
> +				"Disabled. Skipping invalidating TLB.\n");
> +		}
> +
> +		read_unlock_irqrestore(&data->lock, flags);
> +	}
> +}
> +
> +static int exynos_sysmmu_probe(struct platform_device *pdev)
> +{
> +	struct resource *res, *ioarea;
> +	int ret;
> +	int irq;
> +	struct device *dev;
> +	void *sfr;
> +	struct sysmmu_drvdata *data;
> +	char *emsg;
> +
> +	dev = &pdev->dev;
> +
> +	if (dev_get_platdata(dev) == NULL) {
> +		pr_debug("%s: No System MMU is assigned for %s.%d.\n", __func__,
> +				pdev->name, pdev->id);
> +		return -ENODEV;
> +	}
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data) {
> +		emsg = "Not enough memory";
> +		ret = -ENOMEM;
> +		goto err_alloc;
> +	}
> +
> +	data->owner = dev_get_platdata(dev);
> +
> +	ret = dev_set_drvdata(dev, data);
> +	if (ret) {
> +		emsg = "Unable to set driver data.";
> +		goto err_init;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		emsg = "Failed probing system MMU: failed to get resource.";
> +		goto err_init;
> +	}
> +
> +	ioarea = request_mem_region(res->start, resource_size(res),
> +								dev_name(dev));
> +	if (ioarea == NULL) {
> +		emsg = "failed to request memory region.";
> +		ret = -ENOMEM;
> +		goto err_init;
> +	}
> +
> +	sfr = ioremap(res->start, resource_size(res));
> +	if (!sfr) {
> +		emsg = "failed to call ioremap().";
> +		ret = -ENOENT;
> +		goto err_ioremap;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq <= 0) {
> +		emsg = "failed to get irq resource.";
> +		ret = irq;
> +		goto err_irq;
> +	}
> +
> +	ret = request_irq(irq, exynos_sysmmu_irq, 0, dev_name(dev), data);
> +	if (ret) {
> +		emsg = "failed to request irq.";
> +		goto err_irq;
> +	}
> +
> +	data->clk = clk_get(dev, "sysmmu");
> +	if (IS_ERR(data->clk)) {
> +		emsg = "failed to get clock descriptor";
> +		ret = PTR_ERR(data->clk);
> +		goto err_clk;
> +	}
> +
> +	data->dev = dev;
> +	data->sfrbase = sfr;
> +	__set_fault_handler(data, &default_fault_handler);
> +	rwlock_init(&data->lock);
> +	INIT_LIST_HEAD(&data->node);
> +
> +	list_add(&data->node, &sysmmu_list);
> +
> +	if (dev->parent)
> +		pm_runtime_enable(dev);
> +
> +	pr_debug("%s: System MMU for %s.%d Initialized.\n", __func__,
> +							pdev->name, pdev->id);
> +	return 0;
> +err_clk:
> +	free_irq(irq, data);
> +err_irq:
> +	iounmap(sfr);
> +err_ioremap:
> +	release_resource(ioarea);
> +	kfree(ioarea);
> +err_init:
> +	kfree(data);
> +err_alloc:
> +	pr_err("%s: %s.%d Failed: %s\n", __func__, pdev->name, pdev->id, emsg);
> +	return ret;
> +}
> +
> +static int exynos_pm_resume(struct device *dev)
> +{
> +	struct sysmmu_drvdata *data;
> +
> +	data = dev_get_drvdata(dev);
> +
> +	if (is_sysmmu_active(data)) {
> +		__sysmmu_set_ptbase(data->sfrbase, data->pgtable);
> +
> +		__raw_writel(CTRL_ENABLE, data->sfrbase + EXYNOS_MMU_CTRL);
> +	}
> +
> +	return 0;
> +}
> +
> +struct dev_pm_ops exynos_pm_ops = {
> +	.resume = &exynos_pm_resume,
> +};
> +
> +static struct platform_driver exynos_sysmmu_driver = {
> +	.probe		= exynos_sysmmu_probe,
> +	.driver		= {
> +		.owner		= THIS_MODULE,
> +		.name		= "exynos-sysmmu",
> +		.pm		= &exynos_pm_ops,
> +	}
> +};
> +
> +/* We does not consider super section mapping (16MB) */
> +#define EXYNOS_SPAGE_SHIFT	12
> +#define EXYNOS_LPAGE_SHIFT	16
> +#define EXYNOS_SECTION_SHIFT	20
> +
> +#define EXYNOS_SPAGE_SIZE	(1 << EXYNOS_SPAGE_SHIFT)
> +#define EXYNOS_LPAGE_SIZE	(1 << EXYNOS_LPAGE_SHIFT)
> +#define EXYNOS_SECTION_SIZE	(1 << EXYNOS_SECTION_SHIFT)
> +
> +#define EXYNOS_SPAGE_MASK	(~(EXYNOS_SPAGE_SIZE - 1))
> +#define EXYNOS_LPAGE_MASK	(~(EXYNOS_LPAGE_SIZE - 1))
> +#define EXYNOS_SECTION_MASK	(~(EXYNOS_SECTION_SIZE - 1))
> +
> +#define EXYNOS_SPAGE_ORDER	(EXYNOS_SPAGE_SHIFT - PAGE_SHIFT)
> +#define EXYNOS_LPAGE_ORDER	(EXYNOS_LPAGE_SHIFT - EXYNOS_SPAGE_SHIFT)
> +#define EXYNOS_SECTION_ORDER	(EXYNOS_SECTION_SHIFT - EXYNOS_SPAGE_SHIFT)
> +
> +#define EXYNOS_LV1TABLE_ENTRIES	(1 << (BITS_PER_LONG -
> EXYNOS_SECTION_SHIFT))
> +#define EXYNOS_LV1TABLE_ORDER	2 /* get_order(EXYNOS_LV1TABLE_ENTRIES) */
> +
> +#define EXYNOS_LV2TABLE_ENTRIES	(1 << EXYNOS_SECTION_ORDER)
> +#define EXYNOS_LV2TABLE_SIZE	(EXYNOS_LV2TABLE_ENTRIES * sizeof(long))
> +#define EXYNOS_LV2TABLE_MASK	(~(EXYNOS_LV2TABLE_SIZE - 1)) /* 0xFFFFFC00 */
> +
> +#define EXYNOS_SECTION_LV1_ENTRY(entry)	((entry & 0x40003) == 2)
> +#define EXYNOS_SUPSECT_LV1_ENTRY(entry)	((entry & 0x40003) == 0x40002)
> +#define EXYNOS_PAGE_LV1_ENTRY(entry)	((entry & 3) == 1)
> +#define EXYNOS_FAULT_LV1_ENTRY(entry) (((entry & 3) == 0) || (entry & 3) ==
> 3)
> +
> +#define EXYNOS_LPAGE_LV2_ENTRY(entry)	((entry & 3) == 1)
> +#define EXYNOS_SPAGE_LV2_ENTRY(entry)	((entry & 2) == 2)
> +#define EXYNOS_FAULT_LV2_ENTRY(entry)	((entry & 3) == 0)
> +
> +#define MAKE_FAULT_ENTRY(entry)		do { entry = 0; } while (0)
> +#define MAKE_SECTION_ENTRY(entry, pa)	do { entry = pa | 2; } while (0)
> +#define MAKE_SUPSECT_ENTRY(entry, pa)	do { entry = pa | 0x40002; } while
> (0)
> +#define MAKE_LV2TABLE_ENTRY(entry, pa)	do { entry = pa | 1; } while (0)
> +
> +#define MAKE_LPAGE_ENTRY(entry, pa)	do { entry = pa | 1; } while (0)
> +#define MAKE_SPAGE_ENTRY(entry, pa)	do { entry = pa | 3; } while (0)
> +
> +#define GET_LV2ENTRY(entry, iova) (\
> +	(unsigned long *)phys_to_virt(entry & EXYNOS_LV2TABLE_MASK) +\
> +	((iova & (~EXYNOS_SECTION_MASK)) >> EXYNOS_SPAGE_SHIFT))
> +
> +struct iommu_client {
> +	struct list_head node;
> +	struct device *dev;
> +	int refcnt;
> +};
> +
> +struct exynos_iommu_domain {
> +	struct list_head clients; /* list of iommu_client */
> +	unsigned long *pgtable;
> +	spinlock_t lock; /* lock for this structure */
> +	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
> +};
> +
> +/* slab cache for level 2 page tables */
> +static struct kmem_cache *l2table_cachep;
> +
> +static inline void pgtable_flush(void *vastart, void *vaend)
> +{
> +	dmac_flush_range(vastart, vaend);
> +	outer_flush_range(virt_to_phys(vastart),
> +				virt_to_phys(vaend));
> +}
> +
> +static int exynos_iommu_domain_init(struct iommu_domain *domain)
> +{
> +	struct exynos_iommu_domain *priv;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->pgtable = (unsigned long *)__get_free_pages(GFP_KERNEL,
> +							EXYNOS_LV1TABLE_ORDER);
> +	if (!priv->pgtable) {
> +		kfree(priv);
> +		return -ENOMEM;
> +	}
> +
> +	memset(priv->pgtable, 0,
> +			EXYNOS_LV1TABLE_ENTRIES * sizeof(unsigned long));
> +	pgtable_flush(priv->pgtable, priv->pgtable + EXYNOS_LV1TABLE_ENTRIES);
> +
> +	spin_lock_init(&priv->lock);
> +	spin_lock_init(&priv->pgtablelock);
> +	INIT_LIST_HEAD(&priv->clients);
> +
> +	domain->priv = priv;
> +	return 0;
> +}
> +
> +static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
> +{
> +	struct exynos_iommu_domain *priv = domain->priv;
> +	struct list_head *pos, *n;
> +
> +	WARN_ON(!list_empty(&priv->clients));
> +
> +	spin_lock(&priv->lock);
> +
> +	list_for_each_safe(pos, n, &priv->clients) {
> +		struct iommu_client *client;
> +
> +		client = list_entry(pos, struct iommu_client, node);
> +		exynos_sysmmu_disable(client->dev);
I think It occurs sleeping lock error message since it calls the
write_lock within spin_lock.

> +		kfree(client);
> +	}
> +
> +	spin_unlock(&priv->lock);
> +
> +	free_pages((unsigned long)priv->pgtable, EXYNOS_LV1TABLE_ORDER);
> +	kfree(domain->priv);
> +	domain->priv = NULL;
> +}
> +
> +static int exynos_iommu_attach_device(struct iommu_domain *domain,
> +				   struct device *dev)
> +{
> +	int ret;
> +	struct exynos_iommu_domain *priv = domain->priv;
> +	struct iommu_client *client = NULL;
> +	struct list_head *pos;
> +
> +	spin_lock(&priv->lock);
> +
> +	list_for_each(pos, &priv->clients) {
> +		struct iommu_client *cur;
> +
> +		cur = list_entry(pos, struct iommu_client, node);
> +		if (cur->dev == dev) {
> +			client = cur;
> +			break;
> +		}
> +	}
> +
> +	if (client != NULL) {
> +		dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
> +					__func__, __pa(priv->pgtable));
> +		client->refcnt++;
> +	}
> +
> +	spin_unlock(&priv->lock);
> +
> +	if (client != NULL)
> +		return 0;
> +
> +	client = kmalloc(sizeof(*client), GFP_KERNEL);
> +	if (!client)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&client->node);
> +	client->dev = dev;
> +	client->refcnt = 1;
> +
> +	ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
> +	if (ret) {
> +		kfree(client);
> +		return ret;
> +	}
> +
> +	spin_lock(&priv->lock);
> +	list_add_tail(&client->node, &priv->clients);
> +	spin_unlock(&priv->lock);
> +
> +	dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n", __func__,
> +						__pa(priv->pgtable));
> +	return 0;
> +}
> +
> +static void exynos_iommu_detach_device(struct iommu_domain *domain,
> +				    struct device *dev)
> +{
> +	struct exynos_iommu_domain *priv = domain->priv;
> +	struct iommu_client *client = NULL;
> +	struct list_head *pos;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	list_for_each(pos, &priv->clients) {
> +		struct iommu_client *cur;
> +
> +		cur = list_entry(pos, struct iommu_client, node);
> +		if (cur->dev == dev) {
> +			cur->refcnt--;
> +			client = cur;
> +			break;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	if (WARN_ON(client == NULL))
> +		return;
> +
> +	if (client->refcnt > 0) {
> +		dev_dbg(dev, "%s: Detaching IOMMU with pgtable 0x%lx delayed\n",
> +					__func__, __pa(priv->pgtable));
> +		return;
> +	}
> +
> +	BUG_ON(client->refcnt != 0);
> +
> +	list_del(&client->node);
> +	exynos_iommu_disable(client->dev, true);
> +	kfree(client);
> +	dev_dbg(dev, "%s: Detached IOMMU with pgtable 0x%lx\n", __func__,
> +						__pa(priv->pgtable));
> +}
> +
> +static bool section_available(struct iommu_domain *domain,
> +			      unsigned long *lv1entry)
> +{
> +	struct exynos_iommu_domain *priv = domain->priv;
> +
> +	if (EXYNOS_SECTION_LV1_ENTRY(*lv1entry)) {
> +		pr_err("%s: 1MB entry alread exists at 0x%08x\n", __func__,
> +				(lv1entry - priv->pgtable) * SZ_1M);
> +		return false;
> +	}
> +
> +	if (EXYNOS_PAGE_LV1_ENTRY(*lv1entry)) {
> +		unsigned long *lv2end, *lv2base;
> +
> +		lv2base = phys_to_virt(*lv1entry & EXYNOS_LV2TABLE_MASK);
> +		lv2end = lv2base + EXYNOS_LV2TABLE_ENTRIES;
> +		while (lv2base != lv2end) {
> +			if (!EXYNOS_FAULT_LV2_ENTRY(*lv2base)) {
> +				pr_err("%s: "
> +				"Failed to free L2 pgtable for 1MB mapping.\n",
> +				__func__);
> +				return false;
> +			}
> +			lv2base++;
> +		}
> +
> +		kmem_cache_free(l2table_cachep,
> +				phys_to_virt(*lv1entry & EXYNOS_LV2TABLE_MASK));
> +
> +		MAKE_FAULT_ENTRY(*lv1entry);
> +	}
> +
> +	return true;
> +}
> +
> +static bool write_lpage(unsigned long *head_entry, unsigned long phys_addr)
> +{
> +	unsigned long *entry, *end;
> +
> +	entry = head_entry;
> +	end = entry + (1 << EXYNOS_LPAGE_ORDER);
> +
> +	while (entry != end) {
> +		if (!EXYNOS_FAULT_LV2_ENTRY(*entry))
> +			break;
> +
> +		MAKE_LPAGE_ENTRY(*entry, phys_addr);
> +
> +		entry++;
> +	}
> +
> +	if (entry != end) {
> +		end = entry;
> +		while (entry != head_entry)
> +			MAKE_FAULT_ENTRY(*(--entry));
> +
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static int exynos_iommu_map(struct iommu_domain *domain, unsigned long
> iova,
> +			 phys_addr_t paddr, int gfp_order, int prot)
> +{
> +	struct exynos_iommu_domain *priv= domain->priv;
> +	unsigned long *start_entry, *entry, *end_entry;
> +	int num_entry;
> +	int ret = 0;
> +
> +	BUG_ON(priv->pgtable== NULL);
> +
> +	spin_lock(&priv->pgtablelock);
> +
> +	start_entry = entry = priv->pgtable + (iova >> EXYNOS_SECTION_SHIFT);
> +
> +	if (gfp_order >= EXYNOS_SECTION_ORDER) {
> +		BUG_ON((paddr | iova) & ~EXYNOS_SECTION_MASK);
> +		/* 1MiB mapping */
> +
> +		num_entry = 1 << (gfp_order - EXYNOS_SECTION_ORDER);
> +		end_entry = entry + num_entry;
> +
> +		while (entry != end_entry) {
> +			if (!section_available(domain, entry))
> +				break;
> +
> +			MAKE_SECTION_ENTRY(*entry, paddr);
> +
> +			paddr += EXYNOS_SECTION_SIZE;
> +			entry++;
> +		}
> +
> +		if (entry != end_entry)
> +			goto mapping_error;
> +
> +		pgtable_flush(start_entry, entry);
> +		goto mapping_done;
> +	}
> +
> +	if (EXYNOS_FAULT_LV1_ENTRY(*entry)) {
> +		unsigned long *l2table;
> +
> +		l2table = kmem_cache_zalloc(l2table_cachep, GFP_KERNEL);
> +		if (!l2table) {
> +			ret = -ENOMEM;
> +			goto nomem_error;
> +		}
> +
> +		pgtable_flush(entry, entry + EXYNOS_LV2TABLE_ENTRIES);
> +
> +		MAKE_LV2TABLE_ENTRY(*entry, virt_to_phys(l2table));
> +		pgtable_flush(entry, entry + 1);
> +	}
> +
> +	/* 'entry' points level 2 entries, hereafter */
> +	entry = GET_LV2ENTRY(*entry, iova);
> +
> +	start_entry = entry;
> +	num_entry = 1 << gfp_order;
> +	end_entry = entry + num_entry;
> +
> +	if (gfp_order >= EXYNOS_LPAGE_ORDER) {
> +		/* large page(64KiB) mapping */
> +		BUG_ON((paddr | iova) & ~EXYNOS_LPAGE_MASK);
> +
> +		while (entry != end_entry) {
> +			if (!write_lpage(entry, paddr)) {
> +				pr_err("%s: Failed to allocate large page"
> +						" entry.\n", __func__);
> +				break;
> +			}
> +
> +			paddr += EXYNOS_LPAGE_SIZE;
> +			entry += (1 << EXYNOS_LPAGE_ORDER);
> +		}
> +
> +		if (entry != end_entry) {
> +			entry -= 1 << EXYNOS_LPAGE_ORDER;
> +			goto mapping_error;
> +		}
> +	} else {
> +		/* page (4KiB) mapping */
> +		while (entry != end_entry && EXYNOS_FAULT_LV2_ENTRY(*entry)) {
> +
> +			MAKE_SPAGE_ENTRY(*entry, paddr);
> +
> +			entry++;
> +			paddr += EXYNOS_SPAGE_SIZE;
> +		}
> +
> +		if (entry != end_entry) {
> +			pr_err("%s: Failed to allocate small page entry.\n",
> +								__func__);
> +			goto mapping_error;
> +		}
> +	}
> +
> +	pgtable_flush(start_entry, entry);
> +mapping_error:
> +	if (entry != end_entry) {
> +		unsigned long *current_entry = entry;
> +		while (entry != start_entry)
> +			MAKE_FAULT_ENTRY(*(--entry));
> +		pgtable_flush(start_entry, current_entry);
> +		ret = -EADDRINUSE;
> +	}
> +
> +nomem_error:
> +mapping_done:
> +	spin_unlock(&priv->pgtablelock);
> +
> +	return 0;
> +}
> +
> +static void exynos_iommu_commit(struct iommu_domain *domain)
> +{
> +	struct exynos_iommu_domain *priv= domain->priv;
> +	struct iommu_client *client;
> +
> +	list_for_each_entry(client, &priv->clients, node) {
> +		exynos_sysmmu_tlb_invalidate(client->dev);
> +	}
> +}
> +
> +static int exynos_iommu_unmap(struct iommu_domain *domain, unsigned long
> iova,
> +			   int gfp_order)
> +{
> +	struct exynos_iommu_domain *priv = domain->priv;
> +	unsigned long *entry;
> +	int num_entry;
> +	unsigned long flags;
> +
> +	BUG_ON(priv->pgtable == NULL);
> +
> +	spin_lock_irqsave(&priv->pgtablelock, flags);
> +
> +	entry = priv->pgtable + (iova >> EXYNOS_SECTION_SHIFT);
> +
> +	if (gfp_order >= EXYNOS_SECTION_ORDER) {
> +		num_entry = 1 << (gfp_order - EXYNOS_SECTION_ORDER);
> +		while (num_entry--) {
> +			if (EXYNOS_SECTION_LV1_ENTRY(*entry)) {
> +				MAKE_FAULT_ENTRY(*entry);
> +			} else if (EXYNOS_PAGE_LV1_ENTRY(*entry)) {
> +				unsigned long *lv2beg, *lv2end;
> +				lv2beg = phys_to_virt(
> +						*entry & EXYNOS_LV2TABLE_MASK);
> +				lv2end = lv2beg + EXYNOS_LV2TABLE_ENTRIES;
> +				while (lv2beg != lv2end) {
> +					MAKE_FAULT_ENTRY(*lv2beg);
> +					lv2beg++;
> +				}
> +			}
> +			entry++;
> +		}
> +	} else {
> +		entry = GET_LV2ENTRY(*entry, iova);
> +
> +		BUG_ON(EXYNOS_LPAGE_LV2_ENTRY(*entry) &&
> +					(gfp_order < EXYNOS_LPAGE_ORDER));
> +
> +		num_entry = 1 << gfp_order;
> +
> +		while (num_entry--) {
> +			MAKE_FAULT_ENTRY(*entry);
> +			entry++;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&priv->pgtablelock, flags);
> +
> +	exynos_iommu_commit(domain);
> +
> +	return 0;
> +}
> +
> +static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
> +					  unsigned long iova)
> +{
> +	struct exynos_iommu_domain *priv = domain->priv;
> +	unsigned long *entry;
> +	unsigned long offset;
> +
> +	entry = priv->pgtable + (iova >> EXYNOS_SECTION_SHIFT);
> +
> +	if (EXYNOS_FAULT_LV1_ENTRY(*entry))
> +		return 0;
> +
> +	offset = iova & ~EXYNOS_SECTION_MASK;
> +
> +	if (EXYNOS_SECTION_LV1_ENTRY(*entry))
> +		return (*entry & EXYNOS_SECTION_MASK) + offset;
> +
> +	entry = GET_LV2ENTRY(*entry, iova);
> +
> +	if (EXYNOS_SPAGE_LV2_ENTRY(*entry))
> +		return (*entry & EXYNOS_SPAGE_MASK)
> +			+ (iova & ~EXYNOS_SPAGE_MASK);
> +
> +	if (EXYNOS_LPAGE_LV2_ENTRY(*entry))
> +		return (*entry & EXYNOS_LPAGE_MASK)
> +			+ (iova & ~EXYNOS_LPAGE_MASK);
> +
> +	return 0;
> +}
> +
> +static int exynos_iommu_domain_has_cap(struct iommu_domain *domain,
> +				    unsigned long cap)
> +{
> +	return 0;
> +}
> +
> +static struct iommu_ops exynos_iommu_ops = {
> +	.domain_init = &exynos_iommu_domain_init,
> +	.domain_destroy = &exynos_iommu_domain_destroy,
> +	.attach_dev = &exynos_iommu_attach_device,
> +	.detach_dev = &exynos_iommu_detach_device,
> +	.map = &exynos_iommu_map,
> +	.unmap = &exynos_iommu_unmap,
> +	.iova_to_phys = &exynos_iommu_iova_to_phys,
> +	.domain_has_cap = &exynos_iommu_domain_has_cap,
> +	.commit = &exynos_iommu_commit,
> +};
> +
> +static int __init exynos_iommu_init(void)
> +{
> +	int ret;
> +
> +	l2table_cachep = kmem_cache_create("sysmmu_lv2_tables",
> +			EXYNOS_LV2TABLE_SIZE, EXYNOS_LV2TABLE_SIZE, 0, NULL);
> +	if (!l2table_cachep)
> +		return -ENOMEM;
> +
> +	ret = platform_driver_register(&exynos_sysmmu_driver);
> +
> +	if (ret == 0)
> +		bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
> +
> +	return ret;
> +}
> +arch_initcall(exynos_iommu_init);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
