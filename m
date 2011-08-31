Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1HaBSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 21:18:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56912 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1HaBSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 21:18:32 -0400
X-AuditID: cbfee61b-b7b7fae000005864-18-4e5d8be66fbb
Date: Wed, 31 Aug 2011 10:18:29 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH] ARM: EXYNOS4: iommu: Add IOMMU API and moved to
 drivers/iommu
In-reply-to: <1309743708-1505-8-git-send-email-pullip.cho@samsung.com>
To: "'KyongHo Cho'" <pullip.cho@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kwanghyun La'" <nala.la@samsung.com>,
        "'Ilho Lee'" <ilho215.lee@samsung.com>
Message-id: <000801cc677b$e4952640$adbf72c0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acw58B0YkAhURrQ+TeqWzr47P4ojMQtidjsg
References: <1309743708-1505-1-git-send-email-pullip.cho@samsung.com>
 <1309743708-1505-8-git-send-email-pullip.cho@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KyongHo Cho wrote:
> 
> Implemented IOMMU API for Exynos4 platform that has IOMMU(System MMU).
> The previous System MMU driver exposed its own functions and was lack
> of page table management.
> 
> This patch includes complete implementation of IOMMU API
> and it is capable of mapping and unmapping any number of orders.
> 
> iommu_map() for Exynos4 does not map 16MiB page because it is not
> practical now. 1MiB page is sufficient for larger physically contiguous
> memory mapping. Performance degradation due to TLB miss is not such a
> big problem with 1MiB page.
> 
> Since archdata field of structure 'device' contains nothing in ARM,
> I've used linked list to manage the relation between domain and device.
> 
> Marek is trying to add domain and dma_map_ops fields into dev_archdata.
> This way of relation management will be changed after the Marek's work
> is merged into the mainline.
> 
> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
> ---
>  arch/arm/mach-exynos4/include/mach/sysmmu.h |    9 +-
>  drivers/iommu/Kconfig                       |   11 +
>  drivers/iommu/Makefile                      |    1 +
>  drivers/iommu/exynos4_sysmmu.c              |  343
> ++++++++++++++++++
>  drivers/iommu/exynos4_sysmmu.h              |   18 +
>  drivers/iommu/exynos_iommu.c                |  496
> +++++++++++++++++++++++++++
>  6 files changed, 872 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/iommu/exynos4_sysmmu.c
>  create mode 100644 drivers/iommu/exynos4_sysmmu.h
>  create mode 100644 drivers/iommu/exynos_iommu.c
> 

Hi KyongHo,

Basically, we need this for EXYNOS System MMU but I think, this is required
to re-work based on latest kernel and if possible, please make it look as a
single patch set about regarding patches to prevent missing something
important.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


> diff --git a/arch/arm/mach-exynos4/include/mach/sysmmu.h b/arch/arm/mach-
> exynos4/include/mach/sysmmu.h
> index 6a5fbb5..2be20c5 100644
> --- a/arch/arm/mach-exynos4/include/mach/sysmmu.h
> +++ b/arch/arm/mach-exynos4/include/mach/sysmmu.h
> @@ -34,13 +34,10 @@ enum exynos4_sysmmu_ips {
>  };
> 
>  #define S5P_SYSMMU_TOTAL_IPNUM
> 	EXYNOS4_SYSMMU_TOTAL_IPNUM
> -
> -extern const char *sysmmu_ips_name[EXYNOS4_SYSMMU_TOTAL_IPNUM];
> +#define SYSMMU_NONE
> 	S5P_SYSMMU_TOTAL_IPNUM
> 
>  typedef enum exynos4_sysmmu_ips sysmmu_ips;
> 
> -void sysmmu_clk_init(struct device *dev, sysmmu_ips ips);
> -void sysmmu_clk_enable(sysmmu_ips ips);
> -void sysmmu_clk_disable(sysmmu_ips ips);
> -
> +#else /* __ASM_ARM_ARCH_SYSMMU_H */
> +#error mach/sysmmu.h must not be included by device drivers
>  #endif /* __ASM_ARM_ARCH_SYSMMU_H */
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index b57b3fa..a9fcc79 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -107,4 +107,15 @@ config INTR_REMAP
>  	  To use x2apic mode in the CPU's which support x2APIC enhancements
> or
>  	  to support platforms with CPU's having > 8 bit APIC ID, say Y.
> 
> +# EXYNOS IOMMU support
> +config EXYNOS_IOMMU
> +	bool "Exynos4 IOMMU(System MMU) Support"
> +	depends on ARCH_EXYNOS4
> +	select IOMMU_API
> +	help
> +	  Support for the System MMU embedded in Samsung Exynos4 SOCs.
> +	  These IOMMUs allow virtualization of the address space used by
most
> +	  cores within the multimedia subsystem.
> +
> +	  If unsure, say N here.
>  endif # IOMMU_SUPPORT
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index 4d4d77d..446bbdd 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -3,3 +3,4 @@ obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o
> msm_iommu_dev.o
>  obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
>  obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
>  obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
> +obj-$(CONFIG_EXYNOS_IOMMU) += exynos_iommu.o exynos4_sysmmu.o
> diff --git a/drivers/iommu/exynos4_sysmmu.c
b/drivers/iommu/exynos4_sysmmu.c
> new file mode 100644
> index 0000000..01e0966
> --- /dev/null
> +++ b/drivers/iommu/exynos4_sysmmu.c
> @@ -0,0 +1,343 @@
> +/* linux/drivers/iommu/exynos4_sysmmu.c
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
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +
> +#include <asm/pgtable.h>
> +
> +#include <mach/map.h>
> +#include <mach/regs-sysmmu.h>
> +
> +#include "exynos4_sysmmu.h"
> +
> +#define CTRL_ENABLE	0x5
> +#define CTRL_BLOCK	0x7
> +#define CTRL_DISABLE	0x0
> +
> +static struct device *dev_sysmmu[S5P_SYSMMU_TOTAL_IPNUM];
> +
> +static void sysmmu_clk_enable(sysmmu_ips ips)
> +{
> +	struct clk *clk;
> +
> +	clk = clk_get(dev_sysmmu[ips], NULL);
> +	if (clk)
> +		clk_enable(clk);
> +}
> +
> +static void sysmmu_clk_disable(sysmmu_ips ips)
> +{
> +	struct clk *clk;
> +
> +	clk = clk_get(dev_sysmmu[ips], NULL);
> +	if (clk)
> +		clk_disable(clk);
> +}
> +
> +enum S5P_SYSMMU_INTERRUPT_TYPE {
> +	SYSMMU_PAGEFAULT,
> +	SYSMMU_AR_MULTIHIT,
> +	SYSMMU_AW_MULTIHIT,
> +	SYSMMU_BUSERROR,
> +	SYSMMU_AR_SECURITY,
> +	SYSMMU_AR_ACCESS,
> +	SYSMMU_AW_SECURITY,
> +	SYSMMU_AW_PROTECTION, /* 7 */
> +	SYSMMU_FAULTS_NUM
> +};
> +
> +static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
> +	S5P_PAGE_FAULT_ADDR,
> +	S5P_AR_FAULT_ADDR,
> +	S5P_AW_FAULT_ADDR,
> +	S5P_DEFAULT_SLAVE_ADDR,
> +	S5P_AR_FAULT_ADDR,
> +	S5P_AR_FAULT_ADDR,
> +	S5P_AW_FAULT_ADDR,
> +	S5P_AW_FAULT_ADDR
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
> +	"AW ACCESS PROTECTION FAULT"
> +};
> +
> +static int (*fault_handlers[S5P_SYSMMU_TOTAL_IPNUM])(
> +		enum S5P_SYSMMU_INTERRUPT_TYPE itype,
> +		unsigned long pgtable_base,
> +		unsigned long fault_addr);
> +
> +/*
> + * If adjacent 2 bits are true, the system MMU is enabled.
> + * The system MMU is disabled, otherwise.
> + */
> +static unsigned long sysmmu_states;
> +
> +static inline int set_sysmmu_active(sysmmu_ips ips)
> +{
> +	/* return true if it is not set */
> +	return !test_and_set_bit(ips, &sysmmu_states);
> +}
> +
> +static inline int set_sysmmu_inactive(sysmmu_ips ips)
> +{
> +	/* return true if it is set */
> +	return test_and_clear_bit(ips, &sysmmu_states);
> +}
> +
> +static inline int is_sysmmu_active(sysmmu_ips ips)
> +{
> +	/* BUG_ON(ips >= S5P_SYSMMU_TOTAL_IPNUM); */
> +	return sysmmu_states & (1 << ips);
> +}
> +
> +static void __iomem *sysmmusfrs[S5P_SYSMMU_TOTAL_IPNUM];
> +
> +static inline void sysmmu_block(sysmmu_ips ips)
> +{
> +	__raw_writel(CTRL_BLOCK, sysmmusfrs[ips] + S5P_MMU_CTRL);
> +	dev_dbg(dev_sysmmu[ips], "blocked.\n");
> +}
> +
> +static inline void sysmmu_unblock(sysmmu_ips ips)
> +{
> +	__raw_writel(CTRL_ENABLE, sysmmusfrs[ips] + S5P_MMU_CTRL);
> +	dev_dbg(dev_sysmmu[ips], "unblocked.\n");
> +}
> +
> +static inline void __sysmmu_tlb_invalidate(sysmmu_ips ips)
> +{
> +	__raw_writel(0x1, sysmmusfrs[ips] + S5P_MMU_FLUSH);
> +	dev_dbg(dev_sysmmu[ips], "TLB is invalidated.\n");
> +}
> +
> +static inline void __sysmmu_set_ptbase(sysmmu_ips ips, unsigned long pgd)
> +{
> +	if (unlikely(pgd == 0)) {
> +		pgd = (unsigned long)ZERO_PAGE(0);
> +		__raw_writel(0x20, sysmmusfrs[ips] + S5P_MMU_CFG); /* 4KB
> LV1 */
> +	} else {
> +		__raw_writel(0x0, sysmmusfrs[ips] + S5P_MMU_CFG); /* 16KB
> LV1 */
> +	}
> +
> +	__raw_writel(pgd, sysmmusfrs[ips] + S5P_PT_BASE_ADDR);
> +
> +	dev_dbg(dev_sysmmu[ips], "Page table base initialized with
0x%08lX.\n",
> +
> 	pgd);
> +	__sysmmu_tlb_invalidate(ips);
> +}
> +
> +static irqreturn_t s5p_sysmmu_irq(int irq, void *dev_id)
> +{
> +	/* SYSMMU is in blocked when interrupt occurred. */
> +	unsigned long base = 0;
> +	unsigned long addr;
> +	sysmmu_ips ips = (sysmmu_ips)dev_id;
> +	enum S5P_SYSMMU_INTERRUPT_TYPE itype;
> +
> +	BUG_ON(!is_sysmmu_active(ips));
> +
> +	itype = (enum S5P_SYSMMU_INTERRUPT_TYPE)
> +		__ffs(__raw_readl(sysmmusfrs[ips] + S5P_INT_STATUS));
> +
> +	BUG_ON(!((itype >= 0) && (itype < 8)));
> +
> +	base = __raw_readl(sysmmusfrs[ips] + S5P_PT_BASE_ADDR);
> +	addr = __raw_readl(sysmmusfrs[ips] + fault_reg_offset[itype]);
> +
> +	dev_alert(dev_sysmmu[ips], "%s occurred at %08lx
> (PT_BASE_ADDR: %08lx)."
> +		"\n", sysmmu_fault_name[itype], addr, base);
> +
> +	if (fault_handlers[ips]) {
> +
> +
> +		if (fault_handlers[ips](itype, base, addr)) {
> +			__raw_writel(1 << itype,
> +					sysmmusfrs[ips] + S5P_INT_CLEAR);
> +			dev_notice(dev_sysmmu[ips], "%s is resolved.
> Retrying"
> +				" translation.\n",
sysmmu_fault_name[itype]);
> +		} else {
> +			base = 0;
> +		}
> +	}
> +
> +	sysmmu_unblock(ips);
> +
> +	if (!base)
> +		dev_notice(dev_sysmmu[ips], "%s is not handled.\n",
> +						sysmmu_fault_name[itype]);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +void s5p_sysmmu_set_tablebase_pgd(sysmmu_ips ips, unsigned long pgd)
> +{
> +	if (is_sysmmu_active(ips)) {
> +		sysmmu_block(ips);
> +		__sysmmu_set_ptbase(ips, pgd);
> +		sysmmu_unblock(ips);
> +	} else {
> +		dev_dbg(dev_sysmmu[ips], "disabled. Skipping initializing
page"
> +				" table base...\n");
> +	}
> +}
> +
> +void s5p_sysmmu_enable(sysmmu_ips ips, unsigned long pgd)
> +{
> +	if (set_sysmmu_active(ips)) {
> +		sysmmu_clk_enable(ips);
> +
> +		__sysmmu_set_ptbase(ips, pgd);
> +
> +		__raw_writel(CTRL_ENABLE, sysmmusfrs[ips] +
> S5P_MMU_CTRL);
> +
> +		set_sysmmu_active(ips);
> +		dev_dbg(dev_sysmmu[ips], "enabled.\n");
> +	} else {
> +		dev_dbg(dev_sysmmu[ips], "already enabled."
> +					" Skipping initialization...\n");
> +	}
> +}
> +
> +void s5p_sysmmu_disable(sysmmu_ips ips)
> +{
> +	if (set_sysmmu_inactive(ips)) {
> +		__raw_writel(CTRL_DISABLE, sysmmusfrs[ips] +
> S5P_MMU_CTRL);
> +		sysmmu_clk_disable(ips);
> +		dev_dbg(dev_sysmmu[ips], "disabled.\n");
> +	} else {
> +		dev_dbg(dev_sysmmu[ips], "already disabled."
> +					" Skipping deinitialization...\n");
> +	}
> +}
> +
> +void s5p_sysmmu_tlb_invalidate(sysmmu_ips ips)
> +{
> +	if (is_sysmmu_active(ips)) {
> +		sysmmu_block(ips);
> +		__sysmmu_tlb_invalidate(ips);
> +		sysmmu_unblock(ips);
> +	} else {
> +		dev_dbg(dev_sysmmu[ips], "is disabled. "
> +			"Skipping invalidating TLB...\n");
> +	}
> +}
> +
> +static int s5p_sysmmu_probe(struct platform_device *pdev)
> +{
> +	sysmmu_ips id;
> +	struct resource *res, *ioarea;
> +	int ret;
> +	int irq;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "Failed probing system MMU: "
> +						"failed to get resource.");
> +		return -ENOENT;
> +	}
> +
> +	id = (sysmmu_ips)pdev->id;
> +
> +	if (id >= S5P_SYSMMU_TOTAL_IPNUM) {
> +		dev_err(&pdev->dev, "Unknown System MMU ID %d.", id);
> +		return -ENOENT;
> +	}
> +
> +	ioarea = request_mem_region(res->start, resource_size(res),
pdev->name);
> +	if (ioarea == NULL) {
> +		dev_err(&pdev->dev, "Failed probing system MMU: "
> +					"failed to request memory region.");
> +		return -ENOMEM;
> +	}
> +
> +	sysmmusfrs[id] = ioremap(res->start, resource_size(res));
> +	if (!sysmmusfrs[id]) {
> +		dev_err(&pdev->dev, "Failed probing system MMU: "
> +						"failed to call
ioremap().");
> +		ret = -ENOENT;
> +		goto err_ioremap;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq <= 0) {
> +		dev_err(&pdev->dev, "Failed probing system MMU: "
> +						"failed to get irq
resource.");
> +		ret = irq;
> +		goto err_irq;
> +	}
> +
> +	if (request_irq(irq, s5p_sysmmu_irq, 0, dev_name(&pdev->dev),
> +								(void *)id))
> {
> +		dev_err(&pdev->dev, "Failed probing system MMU: "
> +						"failed to request irq.");
> +		ret = -ENOENT;
> +		goto err_irq;
> +	}
> +
> +	dev_sysmmu[id] = &pdev->dev;
> +
> +	dev_dbg(&pdev->dev, "Probing system MMU succeeded.");
> +	return 0;
> +
> +err_irq:
> +	iounmap(sysmmusfrs[id]);
> +err_ioremap:
> +	release_resource(ioarea);
> +	kfree(ioarea);
> +	dev_err(&pdev->dev, "Probing system MMU failed.");
> +	return ret;
> +}
> +
> +static int s5p_sysmmu_remove(struct platform_device *pdev)
> +{
> +	return 0;
> +}
> +static int s5p_sysmmu_runtime_suspend(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static int s5p_sysmmu_runtime_resume(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops s5p_sysmmu_pm_ops = {
> +	.runtime_suspend	= s5p_sysmmu_runtime_suspend,
> +	.runtime_resume		= s5p_sysmmu_runtime_resume,
> +};
> +
> +static struct platform_driver s5p_sysmmu_driver = {
> +	.probe		= s5p_sysmmu_probe,
> +	.remove		= s5p_sysmmu_remove,
> +	.driver		= {
> +		.owner		= THIS_MODULE,
> +		.name		= "s5p-sysmmu",
> +		.pm		= &s5p_sysmmu_pm_ops,
> +	}
> +};
> +
> +static int __init s5p_sysmmu_init(void)
> +{
> +	return platform_driver_register(&s5p_sysmmu_driver);
> +}
> +arch_initcall(s5p_sysmmu_init);
> diff --git a/drivers/iommu/exynos4_sysmmu.h
b/drivers/iommu/exynos4_sysmmu.h
> new file mode 100644
> index 0000000..f739240
> --- /dev/null
> +++ b/drivers/iommu/exynos4_sysmmu.h
> @@ -0,0 +1,18 @@
> +/* linux/drivers/iommu/exynos4_sysmmu.h
> + *
> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Samsung System MMU driver for Exynos4 platforms
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#include <mach/sysmmu.h>
> +
> +void s5p_sysmmu_enable(sysmmu_ips ips, unsigned long pgd);
> +void s5p_sysmmu_disable(sysmmu_ips ips);
> +void s5p_sysmmu_set_tablebase_pgd(sysmmu_ips ips, unsigned long pgd);
> +void s5p_sysmmu_tlb_invalidate(sysmmu_ips ips);
> diff --git a/drivers/iommu/exynos_iommu.c b/drivers/iommu/exynos_iommu.c
> new file mode 100644
> index 0000000..cbb94df
> --- /dev/null
> +++ b/drivers/iommu/exynos_iommu.c
> @@ -0,0 +1,496 @@
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
> +#include <linux/mm.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/iommu.h>
> +#include <linux/errno.h>
> +#include <linux/list.h>
> +
> +#include <asm/cacheflush.h>
> +
> +#include "exynos4_sysmmu.h"
> +
> +#ifdef CONFIG_S5P_SYSTEM_MMU_DEBUG
> +#define DEBUG /* for dev_dbg() */
> +#endif
> +
> +/* We does not consider super section mapping (16MB) */
> +#define S5P_SPAGE_SHIFT		12
> +#define S5P_LPAGE_SHIFT		16
> +#define S5P_SECTION_SHIFT	20
> +
> +#define S5P_SPAGE_SIZE		(1 << S5P_SPAGE_SHIFT)
> +#define S5P_LPAGE_SIZE		(1 << S5P_LPAGE_SHIFT)
> +#define S5P_SECTION_SIZE	(1 << S5P_SECTION_SHIFT)
> +
> +#define S5P_SPAGE_MASK		(~(S5P_SPAGE_SIZE - 1))
> +#define S5P_LPAGE_MASK		(~(S5P_LPAGE_SIZE - 1))
> +#define S5P_SECTION_MASK	(~(S5P_SECTION_SIZE - 1))
> +
> +#define S5P_SPAGE_ORDER		(S5P_SPAGE_SHIFT - PAGE_SHIFT)
> +#define S5P_LPAGE_ORDER		(S5P_LPAGE_SHIFT -
> S5P_SPAGE_SHIFT)
> +#define S5P_SECTION_ORDER	(S5P_SECTION_SHIFT - S5P_SPAGE_SHIFT)
> +
> +#define S5P_LV1TABLE_ENTRIES	(1 << (BITS_PER_LONG -
> S5P_SECTION_SHIFT))
> +
> +#define S5P_LV2TABLE_ENTRIES	(1 << S5P_SECTION_ORDER)
> +#define S5P_LV2TABLE_SIZE	(S5P_LV2TABLE_ENTRIES * sizeof(long))
> +#define S5P_LV2TABLE_MASK	(~(S5P_LV2TABLE_SIZE - 1)) /* 0xFFFFFC00 */
> +
> +#define S5P_SECTION_LV1_ENTRY(entry)	((entry & 0x40003) == 2)
> +#define S5P_SUPSECT_LV1_ENTRY(entry)	((entry & 0x40003) ==
> 0x40002)
> +#define S5P_PAGE_LV1_ENTRY(entry)	((entry & 3) == 1)
> +#define S5P_FAULT_LV1_ENTRY(entry) (((entry & 3) == 0) || (entry & 3) ==
3)
> +
> +#define S5P_LPAGE_LV2_ENTRY(entry)	((entry & 3) == 1)
> +#define S5P_SPAGE_LV2_ENTRY(entry)	((entry & 2) == 2)
> +#define S5P_FAULT_LV2_ENTRY(entry)	((entry & 3) == 0)
> +
> +#define MAKE_FAULT_ENTRY(entry)		do { entry = 0; } while (0)
> +#define MAKE_SECTION_ENTRY(entry, pa)	do { entry = pa | 2; } while
(0)
> +#define MAKE_SUPSECT_ENTRY(entry, pa)	do { entry = pa | 0x40002; }
> while (0)
> +#define MAKE_LV2TABLE_ENTRY(entry, pa)	do { entry = pa | 1; } while
(0)
> +
> +#define MAKE_LPAGE_ENTRY(entry, pa)	do { entry = pa | 1; } while (0)
> +#define MAKE_SPAGE_ENTRY(entry, pa)	do { entry = pa | 3; } while (0)
> +
> +#define GET_LV2ENTRY(entry, iova) (\
> +	(unsigned long *)phys_to_virt(entry & S5P_LV2TABLE_MASK) +\
> +	((iova & (~S5P_SECTION_MASK)) >> S5P_SPAGE_SHIFT))
> +
> +struct s5p_iommu_domain {
> +	struct device *dev;
> +	sysmmu_ips ips;
> +	unsigned long *pgtable;
> +};
> +
> +struct s5p_finddev_struct {
> +	char *name;
> +	int id;
> +};
> +/* Shared page table implementation */
> +static unsigned long *pgtable;
> +
> +static struct s5p_finddev_struct pdev_names[S5P_SYSMMU_TOTAL_IPNUM] = {
> +	{"s3c-pl330", 0},
> +	{"s5p-sss", -1},
> +	{"s3c-fimc", 0},
> +	{"s3c-fimc", 1},
> +	{"s3c-fimc", 2},
> +	{"s3c-fimc", 3},
> +	{"s5p-jpeg", -1},
> +	{"s5p-fb", 0},
> +	{"s5p-fb", 1},
> +	{"s5p-pcie", -1},
> +	{"s5p-fimg2d", -1},
> +	{"s5p-rotator", -1},
> +	{"s5p-mdma2", -1},
> +	{"s5p-mixer", -1},
> +	{"mfc", -1}, /* SYSMMU_MFC_L */
> +};
> +/* slab cache for level 2 page tables */
> +static struct kmem_cache *l2table_cachep;
> +
> +LIST_HEAD(dev_lookup_list);
> +
> +struct dev_dom {
> +	struct list_head node;
> +	struct s5p_iommu_domain *dom;
> +	struct device *dev;
> +};
> +
> +static inline struct dev_dom *lookup_dev(struct device *dev)
> +{
> +	struct list_head *pos;
> +	struct dev_dom *rel = NULL;
> +
> +	list_for_each(pos, &dev_lookup_list) {
> +		rel = list_entry(pos, struct dev_dom, node);
> +		if (rel->dev == dev)
> +			return rel;
> +	}
> +
> +	return NULL;
> +}
> +
> +static inline int bind_dev(struct s5p_iommu_domain *dom, struct device
*dev)
> +{
> +	struct dev_dom *rel;
> +
> +	rel = kmalloc(sizeof(*rel), GFP_KERNEL);
> +	if (!rel)
> +		return -ENOMEM;
> +
> +	if (!lookup_dev(dev)) {
> +		rel->dom = dom;
> +		rel->dev = dev;
> +		list_add(&rel->node, &dev_lookup_list);
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void unbind_dev(struct device *dev)
> +{
> +	struct dev_dom *rel;
> +
> +	rel = lookup_dev(dev);
> +	if (rel)
> +		list_del(&rel->node);
> +}
> +
> +static inline void pgtable_flush(void *vastart, void *vaend)
> +{
> +	dmac_flush_range(vastart, vaend);
> +	outer_flush_range(virt_to_phys(vastart),
> +				virt_to_phys(vaend));
> +}
> +
> +static int s5p_iommu_domain_init(struct iommu_domain *domain)
> +{
> +	struct s5p_iommu_domain *priv;
> +
> +	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->pgtable = (unsigned long *)__get_free_pages(GFP_KERNEL,
> +		(S5P_LV1TABLE_ENTRIES * sizeof(unsigned long)) >>
> PAGE_SHIFT);
> +	if (!priv->pgtable) {
> +		kfree(priv);
> +		return -ENOMEM;
> +	}
> +
> +	memset(pgtable, 0, S5P_LV1TABLE_ENTRIES * sizeof(unsigned long));
> +	pgtable_flush(pgtable, pgtable + S5P_LV1TABLE_ENTRIES);
> +
> +	domain->priv = priv;
> +	return 0;
> +}
> +
> +static void s5p_iommu_domain_destroy(struct iommu_domain *domain)
> +{
> +	struct s5p_iommu_domain *priv = domain->priv;
> +
> +	free_pages((unsigned long)priv->pgtable, 2);
> +	kfree(domain->priv);
> +	domain->priv = NULL;
> +}
> +
> +static sysmmu_ips get_sysmmu_id(struct platform_device *pdev)
> +{
> +	int i;
> +
> +	for (i = 0; i < S5P_SYSMMU_TOTAL_IPNUM; i++)
> +		if ((strcmp(pdev->name, pdev_names[i].name) == 0) &&
> +				(pdev->id == pdev_names[i].id))
> +			break;
> +
> +	return (sysmmu_ips)i;
> +}
> +
> +static int s5p_iommu_attach_device(struct iommu_domain *domain,
> +				   struct device *dev)
> +{
> +	sysmmu_ips ips;
> +	int ret;
> +	struct s5p_iommu_domain *s5p_domain = domain->priv;
> +	struct platform_device *pdev =
> +				container_of(dev, struct platform_device,
dev);
> +
> +	ips = get_sysmmu_id(pdev);
> +	if (ips == SYSMMU_NONE)
> +		return -ENODEV;
> +
> +	s5p_domain->ips = ips;
> +
> +	s5p_sysmmu_enable(ips, (unsigned long)s5p_domain->pgtable);
> +	if (ips == SYSMMU_MFC_L)
> +		s5p_sysmmu_enable(ips + 1, (unsigned long)s5p_domain-
> >pgtable);
> +
> +	s5p_domain->dev = dev;
> +
> +	ret = bind_dev(s5p_domain, dev);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static void s5p_iommu_detach_device(struct iommu_domain *domain,
> +				    struct device *dev)
> +{
> +	struct s5p_iommu_domain *s5p_domain = domain->priv;
> +
> +	if (s5p_domain->dev == dev) {
> +		s5p_sysmmu_disable(s5p_domain->ips);
> +		if (s5p_domain->ips == SYSMMU_MFC_L)
> +			s5p_sysmmu_disable(s5p_domain->ips + 1);
> +		unbind_dev(dev);
> +	}
> +}
> +
> +static bool section_available(struct iommu_domain *domain,
> +			      unsigned long *lv1entry)
> +{
> +	struct s5p_iommu_domain *s5p_domain = domain->priv;
> +
> +	if (S5P_SECTION_LV1_ENTRY(*lv1entry)) {
> +		dev_err(s5p_domain->dev,
> +				"1MB entry alread exists at 0x%08x\n",
> +				(lv1entry - s5p_domain->pgtable) * SZ_1M);
> +		return false;
> +	}
> +
> +	if (S5P_PAGE_LV1_ENTRY(*lv1entry)) {
> +		unsigned long *lv2end, *lv2base;
> +
> +		lv2base = phys_to_virt(*lv1entry & S5P_LV2TABLE_MASK);
> +		lv2end = lv2base + S5P_LV2TABLE_ENTRIES;
> +		while (lv2base != lv2end) {
> +			if (S5P_FAULT_LV2_ENTRY(*lv2base)) {
> +				dev_err(s5p_domain->dev,
> +					"Failed to free L2 page table for"
> +					"section mapping.\n");
> +				return false;
> +			}
> +			lv2base++;
> +		}
> +
> +		kmem_cache_free(l2table_cachep,
> +				phys_to_virt(*lv1entry &
> S5P_LV2TABLE_MASK));
> +
> +		MAKE_FAULT_ENTRY(*lv1entry);
> +	}
> +
> +	return true;
> +}
> +
> +static bool write_lpage(unsigned long *head_entry, unsigned long
phys_addr)
> +{
> +	unsigned long *entry, *end;
> +
> +	entry = head_entry;
> +	end = entry + (1 << S5P_LPAGE_ORDER);
> +
> +	while (entry != end) {
> +		if (!S5P_FAULT_LV2_ENTRY(*entry))
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
> +int s5p_iommu_map(struct iommu_domain *domain, unsigned long iova,
> +			 phys_addr_t paddr, int gfp_order, int prot)
> +{
> +	struct s5p_iommu_domain *s5p_domain = domain->priv;
> +	unsigned long *start_entry, *entry, *end_entry;
> +	int num_entry;
> +
> +	BUG_ON(s5p_domain->dev == NULL);
> +
> +	start_entry = entry = s5p_domain->pgtable + (iova >>
> S5P_SECTION_SHIFT);
> +
> +	if (gfp_order >= S5P_SECTION_ORDER) {
> +		BUG_ON((paddr | iova) & ~S5P_SECTION_MASK);
> +		/* 1MiB mapping */
> +
> +		num_entry = 1 << (gfp_order - S5P_SECTION_ORDER);
> +		end_entry = entry + num_entry;
> +
> +		while (entry != end_entry) {
> +			if (!section_available(domain, entry))
> +				break;
> +
> +			MAKE_SECTION_ENTRY(*entry, paddr);
> +
> +			paddr += S5P_SECTION_SIZE;
> +			entry++;
> +		}
> +
> +		if (entry != end_entry)
> +			goto mapping_error;
> +
> +		return 0;
> +	}
> +
> +	if (S5P_FAULT_LV1_ENTRY(*entry)) {
> +		unsigned long *l2table;
> +
> +		l2table = kmem_cache_zalloc(l2table_cachep, GFP_KERNEL);
> +		if (!l2table)
> +			return -ENOMEM;
> +
> +		pgtable_flush(entry, entry + S5P_LV2TABLE_ENTRIES);
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
> +	if (gfp_order >= S5P_LPAGE_ORDER) {
> +		/* large page(64KiB) mapping */
> +		BUG_ON((paddr | iova) & ~S5P_LPAGE_MASK);
> +
> +		while (entry != end_entry) {
> +			if (!write_lpage(entry, paddr)) {
> +				dev_err(s5p_domain->dev,
> +					"Failed to allocate large page
entry.\n"
> +					);
> +				break;
> +			}
> +
> +			paddr += S5P_LPAGE_SIZE;
> +			entry += (1 << S5P_LPAGE_ORDER);
> +		}
> +
> +		if (entry != end_entry) {
> +			entry -= 1 << S5P_LPAGE_ORDER;
> +			goto mapping_error;
> +		}
> +
> +		return 0;
> +	}
> +
> +	/* page (4KiB) mapping */
> +	while (entry != end_entry && !S5P_FAULT_LV2_ENTRY(*entry)) {
> +
> +		MAKE_SPAGE_ENTRY(*entry, paddr);
> +
> +		entry++;
> +		paddr += S5P_SPAGE_SIZE;
> +	}
> +
> +	if (entry != end_entry) {
> +		dev_err(s5p_domain->dev,
> +			"Failed to allocate small page entry.\n");
> +		goto mapping_error;
> +	}
> +
> +	pgtable_flush(start_entry, entry);
> +mapping_error:
> +	if (entry != end_entry) {
> +		while (entry != start_entry)
> +			MAKE_FAULT_ENTRY(*(--entry));
> +		return -EADDRINUSE;
> +	}
> +
> +	return 0;
> +}
> +
> +int s5p_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
> +			   int gfp_order)
> +{
> +	struct s5p_iommu_domain *s5p_domain = domain->priv;
> +	unsigned long *entry;
> +	int num_entry;
> +
> +	BUG_ON(s5p_domain->dev == NULL);
> +
> +	entry = s5p_domain->pgtable + (iova >> S5P_SECTION_SHIFT);
> +
> +	if (gfp_order >= S5P_SECTION_ORDER)
> +		gfp_order -= S5P_SECTION_ORDER;
> +	else
> +		entry = GET_LV2ENTRY(*entry, iova);
> +
> +	BUG_ON(S5P_LPAGE_LV2_ENTRY(*entry) && (gfp_order <
> S5P_LPAGE_ORDER));
> +
> +	num_entry = 1 << gfp_order;
> +
> +	while (num_entry-- > 0) {
> +		MAKE_FAULT_ENTRY(*entry);
> +		entry++;
> +	}
> +
> +	s5p_sysmmu_tlb_invalidate(s5p_domain->ips);
> +	if (s5p_domain->ips == SYSMMU_MFC_L)
> +		s5p_sysmmu_tlb_invalidate(s5p_domain->ips + 1);
> +	return 0;
> +}
> +
> +phys_addr_t s5p_iommu_iova_to_phys(struct iommu_domain *domain,
> +					  unsigned long iova)
> +{
> +	struct s5p_iommu_domain *s5p_domain = domain->priv;
> +	unsigned long *entry;
> +	unsigned long offset;
> +
> +	entry = s5p_domain->pgtable + (iova >> S5P_SECTION_SHIFT);
> +
> +	if (S5P_FAULT_LV1_ENTRY(*entry))
> +		return 0;
> +
> +	offset = iova & ~S5P_SECTION_MASK;
> +
> +	if (S5P_SECTION_LV1_ENTRY(*entry))
> +		return (*entry & S5P_SECTION_MASK) + offset;
> +
> +	entry = GET_LV2ENTRY(*entry, iova);
> +
> +	if (S5P_SPAGE_LV2_ENTRY(*entry))
> +		return (*entry & S5P_SPAGE_MASK) + (iova &
> ~S5P_SPAGE_MASK);
> +
> +	if (S5P_LPAGE_LV2_ENTRY(*entry))
> +		return (*entry & S5P_LPAGE_MASK) + (iova &
> ~S5P_LPAGE_MASK);
> +
> +	return 0;
> +}
> +
> +static int s5p_iommu_domain_has_cap(struct iommu_domain *domain,
> +				    unsigned long cap)
> +{
> +	return 0;
> +}
> +
> +static struct iommu_ops s5p_iommu_ops = {
> +	.domain_init = &s5p_iommu_domain_init,
> +	.domain_destroy = &s5p_iommu_domain_destroy,
> +	.attach_dev = &s5p_iommu_attach_device,
> +	.detach_dev = &s5p_iommu_detach_device,
> +	.map = &s5p_iommu_map,
> +	.unmap = &s5p_iommu_unmap,
> +	.iova_to_phys = &s5p_iommu_iova_to_phys,
> +	.domain_has_cap = &s5p_iommu_domain_has_cap
> +};
> +
> +static int __init s5p_iommu_init(void)
> +{
> +	l2table_cachep = kmem_cache_create("SysMMU Lv2 Tables",
> +				S5P_LV2TABLE_SIZE, S5P_LV2TABLE_SIZE,
> 0, NULL);
> +	if (!l2table_cachep)
> +		return -ENOMEM;
> +
> +	register_iommu(&s5p_iommu_ops);
> +	return 0;
> +}
> +arch_initcall(s5p_iommu_init);
> --
> 1.7.1

