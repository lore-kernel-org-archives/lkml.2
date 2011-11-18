Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab1KRKIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:08:50 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:40914 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab1KRKIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:08:38 -0500
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Younglak Kim <younglak1004.kim@samsung.com>
Cc: Joerg Roedel <joro@8bytes.org>, Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        KyongHo Cho <pullip.cho@samsung.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v7 2/2] iommu/exynos: Add iommu driver for Exynos Platforms
Date: Fri, 18 Nov 2011 18:47:30 +0900
Message-Id: <1321609650-1329-3-git-send-email-pullip.cho@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1321609650-1329-1-git-send-email-pullip.cho@samsung.com>
References: <1321609650-1329-1-git-send-email-pullip.cho@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the System MMU driver and IOMMU API implementation for
Exynos SOC platforms. Exynos platforms has more than 10 System
MMUs dedicated for each multimedia accellerators.

The System MMU driver is already in arc/arm/plat-s5p but it is
moved to drivers/iommu due to Ohad Ben-Cohen gathered IOMMU drivers
there

This patch also includes fault handling feature in IOMMU driver
suggested by Ohad.
Users of IOMMU API can register its own fault handler with
iommu_set_fault_handler() and the handler is called by IRQ handler
of System MMU.
If no user installs fault handler, IOMMU driver prints debugging
message and generates kernel oops.

This IOMMU driver calls bus_set_iommu() instead of register_iommu()
since Joerg suggested that installing iommu_ops in bus_type.

Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 arch/arm/plat-s5p/Kconfig                   |    8 -
 arch/arm/plat-s5p/Makefile                  |    1 -
 arch/arm/plat-s5p/sysmmu.c                  |  312 ---------
 arch/arm/plat-samsung/include/plat/sysmmu.h |   95 ---
 drivers/iommu/Kconfig                       |   12 +
 drivers/iommu/Makefile                      |    1 +
 drivers/iommu/exynos-iommu.c                |  958 +++++++++++++++++++++++++++
 7 files changed, 971 insertions(+), 416 deletions(-)
 delete mode 100644 arch/arm/plat-s5p/sysmmu.c
 delete mode 100644 arch/arm/plat-samsung/include/plat/sysmmu.h
 create mode 100644 drivers/iommu/exynos-iommu.c

diff --git a/arch/arm/plat-s5p/Kconfig b/arch/arm/plat-s5p/Kconfig
index 9b9968f..805b979 100644
--- a/arch/arm/plat-s5p/Kconfig
+++ b/arch/arm/plat-s5p/Kconfig
@@ -45,14 +45,6 @@ config S5P_PM
 	  Common code for power management support on S5P and newer SoCs
 	  Note: Do not select this for S5P6440 and S5P6450.
 
-comment "System MMU"
-
-config S5P_SYSTEM_MMU
-	bool "S5P SYSTEM MMU"
-	depends on ARCH_EXYNOS4
-	help
-	  Say Y here if you want to enable System MMU
-
 config S5P_SLEEP
 	bool
 	help
diff --git a/arch/arm/plat-s5p/Makefile b/arch/arm/plat-s5p/Makefile
index 8763440..0757ce0 100644
--- a/arch/arm/plat-s5p/Makefile
+++ b/arch/arm/plat-s5p/Makefile
@@ -18,7 +18,6 @@ obj-y				+= clock.o
 obj-y				+= irq.o
 obj-$(CONFIG_S5P_EXT_INT)	+= irq-eint.o
 obj-$(CONFIG_S5P_GPIO_INT)	+= irq-gpioint.o
-obj-$(CONFIG_S5P_SYSTEM_MMU)	+= sysmmu.o
 obj-$(CONFIG_S5P_PM)		+= pm.o irq-pm.o
 obj-$(CONFIG_S5P_SLEEP)		+= sleep.o
 obj-$(CONFIG_S5P_HRT) 		+= s5p-time.o
diff --git a/arch/arm/plat-s5p/sysmmu.c b/arch/arm/plat-s5p/sysmmu.c
deleted file mode 100644
index e1cbc72..0000000
--- a/arch/arm/plat-s5p/sysmmu.c
+++ /dev/null
@@ -1,312 +0,0 @@
-/* linux/arch/arm/plat-s5p/sysmmu.c
- *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/io.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-
-#include <asm/pgtable.h>
-
-#include <mach/map.h>
-#include <mach/regs-sysmmu.h>
-#include <plat/sysmmu.h>
-
-#define CTRL_ENABLE	0x5
-#define CTRL_BLOCK	0x7
-#define CTRL_DISABLE	0x0
-
-static struct device *dev;
-
-static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
-	S5P_PAGE_FAULT_ADDR,
-	S5P_AR_FAULT_ADDR,
-	S5P_AW_FAULT_ADDR,
-	S5P_DEFAULT_SLAVE_ADDR,
-	S5P_AR_FAULT_ADDR,
-	S5P_AR_FAULT_ADDR,
-	S5P_AW_FAULT_ADDR,
-	S5P_AW_FAULT_ADDR
-};
-
-static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
-	"PAGE FAULT",
-	"AR MULTI-HIT FAULT",
-	"AW MULTI-HIT FAULT",
-	"BUS ERROR",
-	"AR SECURITY PROTECTION FAULT",
-	"AR ACCESS PROTECTION FAULT",
-	"AW SECURITY PROTECTION FAULT",
-	"AW ACCESS PROTECTION FAULT"
-};
-
-static int (*fault_handlers[S5P_SYSMMU_TOTAL_IPNUM])(
-		enum S5P_SYSMMU_INTERRUPT_TYPE itype,
-		unsigned long pgtable_base,
-		unsigned long fault_addr);
-
-/*
- * If adjacent 2 bits are true, the system MMU is enabled.
- * The system MMU is disabled, otherwise.
- */
-static unsigned long sysmmu_states;
-
-static inline void set_sysmmu_active(sysmmu_ips ips)
-{
-	sysmmu_states |= 3 << (ips * 2);
-}
-
-static inline void set_sysmmu_inactive(sysmmu_ips ips)
-{
-	sysmmu_states &= ~(3 << (ips * 2));
-}
-
-static inline int is_sysmmu_active(sysmmu_ips ips)
-{
-	return sysmmu_states & (3 << (ips * 2));
-}
-
-static void __iomem *sysmmusfrs[S5P_SYSMMU_TOTAL_IPNUM];
-
-static inline void sysmmu_block(sysmmu_ips ips)
-{
-	__raw_writel(CTRL_BLOCK, sysmmusfrs[ips] + S5P_MMU_CTRL);
-	dev_dbg(dev, "%s is blocked.\n", sysmmu_ips_name[ips]);
-}
-
-static inline void sysmmu_unblock(sysmmu_ips ips)
-{
-	__raw_writel(CTRL_ENABLE, sysmmusfrs[ips] + S5P_MMU_CTRL);
-	dev_dbg(dev, "%s is unblocked.\n", sysmmu_ips_name[ips]);
-}
-
-static inline void __sysmmu_tlb_invalidate(sysmmu_ips ips)
-{
-	__raw_writel(0x1, sysmmusfrs[ips] + S5P_MMU_FLUSH);
-	dev_dbg(dev, "TLB of %s is invalidated.\n", sysmmu_ips_name[ips]);
-}
-
-static inline void __sysmmu_set_ptbase(sysmmu_ips ips, unsigned long pgd)
-{
-	if (unlikely(pgd == 0)) {
-		pgd = (unsigned long)ZERO_PAGE(0);
-		__raw_writel(0x20, sysmmusfrs[ips] + S5P_MMU_CFG); /* 4KB LV1 */
-	} else {
-		__raw_writel(0x0, sysmmusfrs[ips] + S5P_MMU_CFG); /* 16KB LV1 */
-	}
-
-	__raw_writel(pgd, sysmmusfrs[ips] + S5P_PT_BASE_ADDR);
-
-	dev_dbg(dev, "Page table base of %s is initialized with 0x%08lX.\n",
-						sysmmu_ips_name[ips], pgd);
-	__sysmmu_tlb_invalidate(ips);
-}
-
-void sysmmu_set_fault_handler(sysmmu_ips ips,
-			int (*handler)(enum S5P_SYSMMU_INTERRUPT_TYPE itype,
-					unsigned long pgtable_base,
-					unsigned long fault_addr))
-{
-	BUG_ON(!((ips >= SYSMMU_MDMA) && (ips < S5P_SYSMMU_TOTAL_IPNUM)));
-	fault_handlers[ips] = handler;
-}
-
-static irqreturn_t s5p_sysmmu_irq(int irq, void *dev_id)
-{
-	/* SYSMMU is in blocked when interrupt occurred. */
-	unsigned long base = 0;
-	sysmmu_ips ips = (sysmmu_ips)dev_id;
-	enum S5P_SYSMMU_INTERRUPT_TYPE itype;
-
-	itype = (enum S5P_SYSMMU_INTERRUPT_TYPE)
-		__ffs(__raw_readl(sysmmusfrs[ips] + S5P_INT_STATUS));
-
-	BUG_ON(!((itype >= 0) && (itype < 8)));
-
-	dev_alert(dev, "%s occurred by %s.\n", sysmmu_fault_name[itype],
-							sysmmu_ips_name[ips]);
-
-	if (fault_handlers[ips]) {
-		unsigned long addr;
-
-		base = __raw_readl(sysmmusfrs[ips] + S5P_PT_BASE_ADDR);
-		addr = __raw_readl(sysmmusfrs[ips] + fault_reg_offset[itype]);
-
-		if (fault_handlers[ips](itype, base, addr)) {
-			__raw_writel(1 << itype,
-					sysmmusfrs[ips] + S5P_INT_CLEAR);
-			dev_notice(dev, "%s from %s is resolved."
-					" Retrying translation.\n",
-				sysmmu_fault_name[itype], sysmmu_ips_name[ips]);
-		} else {
-			base = 0;
-		}
-	}
-
-	sysmmu_unblock(ips);
-
-	if (!base)
-		dev_notice(dev, "%s from %s is not handled.\n",
-			sysmmu_fault_name[itype], sysmmu_ips_name[ips]);
-
-	return IRQ_HANDLED;
-}
-
-void s5p_sysmmu_set_tablebase_pgd(sysmmu_ips ips, unsigned long pgd)
-{
-	if (is_sysmmu_active(ips)) {
-		sysmmu_block(ips);
-		__sysmmu_set_ptbase(ips, pgd);
-		sysmmu_unblock(ips);
-	} else {
-		dev_dbg(dev, "%s is disabled. "
-			"Skipping initializing page table base.\n",
-						sysmmu_ips_name[ips]);
-	}
-}
-
-void s5p_sysmmu_enable(sysmmu_ips ips, unsigned long pgd)
-{
-	if (!is_sysmmu_active(ips)) {
-		sysmmu_clk_enable(ips);
-
-		__sysmmu_set_ptbase(ips, pgd);
-
-		__raw_writel(CTRL_ENABLE, sysmmusfrs[ips] + S5P_MMU_CTRL);
-
-		set_sysmmu_active(ips);
-		dev_dbg(dev, "%s is enabled.\n", sysmmu_ips_name[ips]);
-	} else {
-		dev_dbg(dev, "%s is already enabled.\n", sysmmu_ips_name[ips]);
-	}
-}
-
-void s5p_sysmmu_disable(sysmmu_ips ips)
-{
-	if (is_sysmmu_active(ips)) {
-		__raw_writel(CTRL_DISABLE, sysmmusfrs[ips] + S5P_MMU_CTRL);
-		set_sysmmu_inactive(ips);
-		sysmmu_clk_disable(ips);
-		dev_dbg(dev, "%s is disabled.\n", sysmmu_ips_name[ips]);
-	} else {
-		dev_dbg(dev, "%s is already disabled.\n", sysmmu_ips_name[ips]);
-	}
-}
-
-void s5p_sysmmu_tlb_invalidate(sysmmu_ips ips)
-{
-	if (is_sysmmu_active(ips)) {
-		sysmmu_block(ips);
-		__sysmmu_tlb_invalidate(ips);
-		sysmmu_unblock(ips);
-	} else {
-		dev_dbg(dev, "%s is disabled. "
-			"Skipping invalidating TLB.\n", sysmmu_ips_name[ips]);
-	}
-}
-
-static int s5p_sysmmu_probe(struct platform_device *pdev)
-{
-	int i, ret;
-	struct resource *res, *mem;
-
-	dev = &pdev->dev;
-
-	for (i = 0; i < S5P_SYSMMU_TOTAL_IPNUM; i++) {
-		int irq;
-
-		sysmmu_clk_init(dev, i);
-		sysmmu_clk_disable(i);
-
-		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		if (!res) {
-			dev_err(dev, "Failed to get the resource of %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -ENODEV;
-			goto err_res;
-		}
-
-		mem = request_mem_region(res->start, resource_size(res),
-					 pdev->name);
-		if (!mem) {
-			dev_err(dev, "Failed to request the memory region of %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -EBUSY;
-			goto err_res;
-		}
-
-		sysmmusfrs[i] = ioremap(res->start, resource_size(res));
-		if (!sysmmusfrs[i]) {
-			dev_err(dev, "Failed to ioremap() for %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -ENXIO;
-			goto err_reg;
-		}
-
-		irq = platform_get_irq(pdev, i);
-		if (irq <= 0) {
-			dev_err(dev, "Failed to get the IRQ resource of %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -ENOENT;
-			goto err_map;
-		}
-
-		if (request_irq(irq, s5p_sysmmu_irq, IRQF_DISABLED,
-						pdev->name, (void *)i)) {
-			dev_err(dev, "Failed to request IRQ for %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -ENOENT;
-			goto err_map;
-		}
-	}
-
-	return 0;
-
-err_map:
-	iounmap(sysmmusfrs[i]);
-err_reg:
-	release_mem_region(mem->start, resource_size(mem));
-err_res:
-	return ret;
-}
-
-static int s5p_sysmmu_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-int s5p_sysmmu_runtime_suspend(struct device *dev)
-{
-	return 0;
-}
-
-int s5p_sysmmu_runtime_resume(struct device *dev)
-{
-	return 0;
-}
-
-const struct dev_pm_ops s5p_sysmmu_pm_ops = {
-	.runtime_suspend	= s5p_sysmmu_runtime_suspend,
-	.runtime_resume		= s5p_sysmmu_runtime_resume,
-};
-
-static struct platform_driver s5p_sysmmu_driver = {
-	.probe		= s5p_sysmmu_probe,
-	.remove		= s5p_sysmmu_remove,
-	.driver		= {
-		.owner		= THIS_MODULE,
-		.name		= "s5p-sysmmu",
-		.pm		= &s5p_sysmmu_pm_ops,
-	}
-};
-
-static int __init s5p_sysmmu_init(void)
-{
-	return platform_driver_register(&s5p_sysmmu_driver);
-}
-arch_initcall(s5p_sysmmu_init);
diff --git a/arch/arm/plat-samsung/include/plat/sysmmu.h b/arch/arm/plat-samsung/include/plat/sysmmu.h
deleted file mode 100644
index 5fe8ee0..0000000
--- a/arch/arm/plat-samsung/include/plat/sysmmu.h
+++ /dev/null
@@ -1,95 +0,0 @@
-/* linux/arch/arm/plat-samsung/include/plat/sysmmu.h
- *
- * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * Samsung System MMU driver for S5P platform
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __PLAT_SAMSUNG_SYSMMU_H
-#define __PLAT_SAMSUNG_SYSMMU_H __FILE__
-
-enum S5P_SYSMMU_INTERRUPT_TYPE {
-	SYSMMU_PAGEFAULT,
-	SYSMMU_AR_MULTIHIT,
-	SYSMMU_AW_MULTIHIT,
-	SYSMMU_BUSERROR,
-	SYSMMU_AR_SECURITY,
-	SYSMMU_AR_ACCESS,
-	SYSMMU_AW_SECURITY,
-	SYSMMU_AW_PROTECTION, /* 7 */
-	SYSMMU_FAULTS_NUM
-};
-
-#ifdef CONFIG_S5P_SYSTEM_MMU
-
-#include <mach/sysmmu.h>
-
-/**
- * s5p_sysmmu_enable() - enable system mmu of ip
- * @ips: The ip connected system mmu.
- * #pgd: Base physical address of the 1st level page table
- *
- * This function enable system mmu to transfer address
- * from virtual address to physical address
- */
-void s5p_sysmmu_enable(sysmmu_ips ips, unsigned long pgd);
-
-/**
- * s5p_sysmmu_disable() - disable sysmmu mmu of ip
- * @ips: The ip connected system mmu.
- *
- * This function disable system mmu to transfer address
- * from virtual address to physical address
- */
-void s5p_sysmmu_disable(sysmmu_ips ips);
-
-/**
- * s5p_sysmmu_set_tablebase_pgd() - set page table base address to refer page table
- * @ips: The ip connected system mmu.
- * @pgd: The page table base address.
- *
- * This function set page table base address
- * When system mmu transfer address from virtaul address to physical address,
- * system mmu refer address information from page table
- */
-void s5p_sysmmu_set_tablebase_pgd(sysmmu_ips ips, unsigned long pgd);
-
-/**
- * s5p_sysmmu_tlb_invalidate() - flush all TLB entry in system mmu
- * @ips: The ip connected system mmu.
- *
- * This function flush all TLB entry in system mmu
- */
-void s5p_sysmmu_tlb_invalidate(sysmmu_ips ips);
-
-/** s5p_sysmmu_set_fault_handler() - Fault handler for System MMUs
- * @itype: type of fault.
- * @pgtable_base: the physical address of page table base. This is 0 if @ips is
- *               SYSMMU_BUSERROR.
- * @fault_addr: the device (virtual) address that the System MMU tried to
- *             translated. This is 0 if @ips is SYSMMU_BUSERROR.
- * Called when interrupt occurred by the System MMUs
- * The device drivers of peripheral devices that has a System MMU can implement
- * a fault handler to resolve address translation fault by System MMU.
- * The meanings of return value and parameters are described below.
-
- * return value: non-zero if the fault is correctly resolved.
- *         zero if the fault is not handled.
- */
-void s5p_sysmmu_set_fault_handler(sysmmu_ips ips,
-			int (*handler)(enum S5P_SYSMMU_INTERRUPT_TYPE itype,
-					unsigned long pgtable_base,
-					unsigned long fault_addr));
-#else
-#define s5p_sysmmu_enable(ips, pgd) do { } while (0)
-#define s5p_sysmmu_disable(ips) do { } while (0)
-#define s5p_sysmmu_set_tablebase_pgd(ips, pgd) do { } while (0)
-#define s5p_sysmmu_tlb_invalidate(ips) do { } while (0)
-#define s5p_sysmmu_set_fault_handler(ips, handler) do { } while (0)
-#endif
-#endif /* __ASM_PLAT_SYSMMU_H */
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 5414253..b45a1e3 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -131,4 +131,16 @@ config OMAP_IOMMU_DEBUG
 
          Say N unless you know you need this.
 
+config EXYNOS_IOMMU
+	bool "Exynos IOMMU Support"
+	depends on ARCH_EXYNOS
+	select IOMMU_API
+	help
+	  Support for the IOMMU(System MMU) of Samsung Exynos application
+	  processor family. This enables H/W multimedia accellerators to see
+	  non-linear physical memory chunks as a linear memory in their
+	  address spaces
+
+	  If unsure, say N here.
+
 endif # IOMMU_SUPPORT
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 2f44487..c8a5558 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_IRQ_REMAP) += intr_remapping.o
 obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
 obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
 obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
+obj-$(CONFIG_EXYNOS_IOMMU) += exynos-iommu.o
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
new file mode 100644
index 0000000..862f6b6
--- /dev/null
+++ b/drivers/iommu/exynos-iommu.c
@@ -0,0 +1,958 @@
+/* linux/drivers/iommu/exynos_iommu.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/pm_runtime.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/mm.h>
+#include <linux/iommu.h>
+#include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/memblock.h>
+#include <linux/export.h>
+
+#include <asm/cacheflush.h>
+#include <asm/pgtable.h>
+
+#include <mach/map.h>
+#include <mach/regs-sysmmu.h>
+
+#define CTRL_ENABLE	0x5
+#define CTRL_BLOCK	0x7
+#define CTRL_DISABLE	0x0
+
+enum EXYNOS_SYSMMU_INTERRUPT_TYPE {
+	SYSMMU_PAGEFAULT,
+	SYSMMU_AR_MULTIHIT,
+	SYSMMU_AW_MULTIHIT,
+	SYSMMU_BUSERROR,
+	SYSMMU_AR_SECURITY,
+	SYSMMU_AR_ACCESS,
+	SYSMMU_AW_SECURITY,
+	SYSMMU_AW_PROTECTION, /* 7 */
+	SYSMMU_FAULT_UNKNOWN,
+	SYSMMU_FAULTS_NUM
+};
+
+typedef int (*sysmmu_fault_handler_t)(enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype,
+			unsigned long pgtable_base, unsigned long fault_addr);
+
+static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
+	EXYNOS_PAGE_FAULT_ADDR,
+	EXYNOS_AR_FAULT_ADDR,
+	EXYNOS_AW_FAULT_ADDR,
+	EXYNOS_DEFAULT_SLAVE_ADDR,
+	EXYNOS_AR_FAULT_ADDR,
+	EXYNOS_AR_FAULT_ADDR,
+	EXYNOS_AW_FAULT_ADDR,
+	EXYNOS_AW_FAULT_ADDR
+};
+
+static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
+	"PAGE FAULT",
+	"AR MULTI-HIT FAULT",
+	"AW MULTI-HIT FAULT",
+	"BUS ERROR",
+	"AR SECURITY PROTECTION FAULT",
+	"AR ACCESS PROTECTION FAULT",
+	"AW SECURITY PROTECTION FAULT",
+	"AW ACCESS PROTECTION FAULT",
+	"UNKNOWN FAULT"
+};
+
+struct exynos_iommu_domain;
+
+struct sysmmu_drvdata {
+	struct list_head node;
+	struct device *dev;
+	struct device *owner;
+	void __iomem *sfrbase;
+	struct clk *clk;
+	int activations;
+	rwlock_t lock;
+	struct iommu_domain *domain;
+	sysmmu_fault_handler_t fault_handler;
+	unsigned long pgtable;
+};
+
+static LIST_HEAD(sysmmu_list);
+
+static struct sysmmu_drvdata *get_sysmmu_data(struct device *owner,
+						struct sysmmu_drvdata *start)
+{
+	if (start) {
+		list_for_each_entry_continue(start, &sysmmu_list, node)
+			if (start->owner == owner)
+				return start;
+	} else  {
+		list_for_each_entry(start, &sysmmu_list, node)
+			if (start->owner == owner)
+				return start;
+	}
+
+	return NULL;
+}
+
+static struct sysmmu_drvdata *get_sysmmu_data_rollback(struct device *owner,
+						struct sysmmu_drvdata *start)
+{
+	if (start) {
+		list_for_each_entry_continue_reverse(start, &sysmmu_list, node)
+			if (start->owner == owner)
+				return start;
+	}
+
+	return NULL;
+}
+
+static bool set_sysmmu_active(struct sysmmu_drvdata *data)
+{
+	/* return true if the System MMU was not active previously
+	   and it needs to be initialized */
+	data->activations++;
+	return data->activations == 1;
+}
+
+static bool set_sysmmu_inactive(struct sysmmu_drvdata *data)
+{
+	/* return true if the System MMU is needed to be disabled */
+	data->activations--;
+
+	WARN_ON(data->activations < 0);
+
+	return data->activations == 0;
+}
+
+static bool is_sysmmu_active(struct sysmmu_drvdata *data)
+{
+	return data->activations != 0;
+}
+
+static void sysmmu_block(void __iomem *sfrbase)
+{
+	__raw_writel(CTRL_BLOCK, sfrbase + EXYNOS_MMU_CTRL);
+}
+
+static void sysmmu_unblock(void __iomem *sfrbase)
+{
+	__raw_writel(CTRL_ENABLE, sfrbase + EXYNOS_MMU_CTRL);
+}
+
+static void __sysmmu_tlb_invalidate(void __iomem *sfrbase)
+{
+	__raw_writel(0x1, sfrbase + EXYNOS_MMU_FLUSH);
+}
+
+static void __sysmmu_set_ptbase(void __iomem *sfrbase,
+				       unsigned long pgd)
+{
+	__raw_writel(0x0, sfrbase + EXYNOS_MMU_CFG); /* 16KB LV1 */
+	__raw_writel(pgd, sfrbase + EXYNOS_PT_BASE_ADDR);
+
+	__sysmmu_tlb_invalidate(sfrbase);
+}
+
+static void __set_fault_handler(struct sysmmu_drvdata *data,
+					sysmmu_fault_handler_t handler)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&data->lock, flags);
+	data->fault_handler = handler;
+	write_unlock_irqrestore(&data->lock, flags);
+}
+
+void exynos_sysmmu_set_fault_handler(struct device *owner,
+					sysmmu_fault_handler_t handler)
+{
+	struct sysmmu_drvdata *data = NULL;
+
+	while ((data = get_sysmmu_data(owner, data)))
+		__set_fault_handler(data, handler);
+}
+
+static int default_fault_handler(enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype,
+		     unsigned long pgtable_base, unsigned long fault_addr)
+{
+	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
+		itype = SYSMMU_FAULT_UNKNOWN;
+
+	pr_err("%s occured at 0x%lx(Page table base: 0x%lx)\n",
+			sysmmu_fault_name[itype], fault_addr, pgtable_base);
+	pr_err("\t\tGenerating Kernel OOPS... because it is unrecoverable.\n");
+
+	BUG();
+
+	return 0;
+}
+
+static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
+{
+	/* SYSMMU is in blocked when interrupt occurred. */
+	struct sysmmu_drvdata *data = dev_id;
+	enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype;
+	unsigned long addr;
+	int ret = -ENOSYS;
+
+	read_lock(&data->lock);
+
+	WARN_ON(!is_sysmmu_active(data));
+
+	itype = (enum EXYNOS_SYSMMU_INTERRUPT_TYPE)
+		__ffs(__raw_readl(data->sfrbase + EXYNOS_INT_STATUS));
+
+	if (WARN_ON((itype >= 0) && (itype < 8))) {
+		itype = SYSMMU_FAULT_UNKNOWN;
+		addr = (unsigned long)-1;
+	} else {
+		addr = __raw_readl(data->sfrbase + fault_reg_offset[itype]);
+	}
+
+	if (data->domain)
+		ret = report_iommu_fault(data->domain, data->owner, addr,
+									itype);
+	if ((ret == -ENOSYS) && data->fault_handler) {
+		unsigned long base;
+		base = __raw_readl(data->sfrbase + EXYNOS_PT_BASE_ADDR);
+		ret = data->fault_handler(itype, base, addr);
+	}
+
+	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
+		__raw_writel(1 << itype, data->sfrbase + EXYNOS_INT_CLEAR);
+	else
+		dev_dbg(data->dev, "%s is not handled.\n",
+						sysmmu_fault_name[itype]);
+
+	sysmmu_unblock(data->sfrbase);
+
+	read_unlock(&data->lock);
+
+	return IRQ_HANDLED;
+}
+
+static bool __sysmmu_disable(struct sysmmu_drvdata *data, bool reset_domain)
+{
+	unsigned long flags;
+	bool disabled = false;
+
+	write_lock_irqsave(&data->lock, flags);
+
+	if (set_sysmmu_inactive(data)) {
+		__raw_writel(CTRL_DISABLE, data->sfrbase + EXYNOS_MMU_CTRL);
+		clk_disable(data->clk);
+		disabled = true;
+		data->pgtable = 0;
+	}
+
+	if (reset_domain)
+		data->domain = NULL;
+
+	write_unlock_irqrestore(&data->lock, flags);
+
+	pm_runtime_put_sync(data->dev);
+
+	return disabled;
+}
+
+static int __exynos_sysmmu_enable(struct device *owner, unsigned long pgtable,
+						struct iommu_domain *domain)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct sysmmu_drvdata *data = NULL;
+
+	BUG_ON(!memblock_is_memory(pgtable));
+
+	/* There are some devices that control more System MMUs than one such
+	 * as MFC.
+	 */
+	while ((data = get_sysmmu_data(owner, data))) {
+		ret = pm_runtime_get_sync(data->dev);
+		if (ret < 0)
+			break;
+
+		write_lock_irqsave(&data->lock, flags);
+
+		if (set_sysmmu_active(data)) {
+			clk_enable(data->clk);
+
+			data->pgtable = pgtable;
+
+			__sysmmu_set_ptbase(data->sfrbase, pgtable);
+
+			__raw_writel(CTRL_ENABLE,
+					data->sfrbase + EXYNOS_MMU_CTRL);
+
+			data->domain = domain;
+
+			dev_dbg(data->dev, "Enabled.\n");
+		} else {
+			if (WARN_ON(pgtable != data->pgtable)) {
+				set_sysmmu_inactive(data);
+				ret = -EBUSY;
+				break;
+			}
+
+			dev_dbg(data->dev, "Already enabled.\n");
+		}
+
+		write_unlock_irqrestore(&data->lock, flags);
+	}
+
+	if (ret < 0) {
+		if (pgtable != data->pgtable)
+			pm_runtime_put_sync(data->dev);
+
+		while ((data = get_sysmmu_data_rollback(owner, data))) {
+			__sysmmu_disable(data, (domain != NULL));
+			dev_dbg(data->dev, "Failed to enable.\n");
+		}
+	} else {
+		ret = 0;
+	}
+
+	return ret;
+}
+
+int exynos_sysmmu_enable(struct device *owner, unsigned long pgtable)
+{
+	return __exynos_sysmmu_enable(owner, pgtable, NULL);
+}
+
+static void exynos_iommu_disable(struct device *owner, bool reset_domain)
+{
+	struct sysmmu_drvdata *data = NULL;
+
+	while ((data = get_sysmmu_data(owner, data))) {
+		if (__sysmmu_disable(data, reset_domain))
+			dev_dbg(data->dev, "Disabled.\n");
+		else
+			dev_dbg(data->dev,
+					"Deactivation request ignorred\n");
+	}
+}
+
+void exynos_sysmmu_disable(struct device *owner)
+{
+	exynos_iommu_disable(owner, false);
+}
+
+void exynos_sysmmu_tlb_invalidate(struct device *owner)
+{
+	struct sysmmu_drvdata *data = NULL;
+
+	while ((data = get_sysmmu_data(owner, data))) {
+		unsigned long flags;
+
+		read_lock_irqsave(&data->lock, flags);
+
+		if (is_sysmmu_active(data)) {
+			sysmmu_block(data->sfrbase);
+			__sysmmu_tlb_invalidate(data->sfrbase);
+			sysmmu_unblock(data->sfrbase);
+		} else {
+			dev_dbg(data->dev,
+				"Disabled. Skipping invalidating TLB.\n");
+		}
+
+		read_unlock_irqrestore(&data->lock, flags);
+	}
+}
+
+static int exynos_sysmmu_probe(struct platform_device *pdev)
+{
+	struct resource *res, *ioarea;
+	int ret;
+	int irq;
+	struct device *dev;
+	void *sfr;
+	struct sysmmu_drvdata *data;
+	char *emsg;
+
+	dev = &pdev->dev;
+
+	if (dev_get_platdata(dev) == NULL) {
+		pr_debug("%s: No System MMU is assigned for %s.%d.\n", __func__,
+				pdev->name, pdev->id);
+		return -ENODEV;
+	}
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		emsg = "Not enough memory";
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+
+	data->owner = dev_get_platdata(dev);
+
+	ret = dev_set_drvdata(dev, data);
+	if (ret) {
+		emsg = "Unable to set driver data.";
+		goto err_init;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		emsg = "Failed probing system MMU: failed to get resource.";
+		goto err_init;
+	}
+
+	ioarea = request_mem_region(res->start, resource_size(res),
+								dev_name(dev));
+	if (ioarea == NULL) {
+		emsg = "failed to request memory region.";
+		ret = -ENOMEM;
+		goto err_init;
+	}
+
+	sfr = ioremap(res->start, resource_size(res));
+	if (!sfr) {
+		emsg = "failed to call ioremap().";
+		ret = -ENOENT;
+		goto err_ioremap;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		emsg = "failed to get irq resource.";
+		ret = irq;
+		goto err_irq;
+	}
+
+	ret = request_irq(irq, exynos_sysmmu_irq, 0, dev_name(dev), data);
+	if (ret) {
+		emsg = "failed to request irq.";
+		goto err_irq;
+	}
+
+	data->clk = clk_get(dev, "sysmmu");
+	if (IS_ERR(data->clk)) {
+		emsg = "failed to get clock descriptor";
+		ret = PTR_ERR(data->clk);
+		goto err_clk;
+	}
+
+	data->dev = dev;
+	data->sfrbase = sfr;
+	__set_fault_handler(data, &default_fault_handler);
+	rwlock_init(&data->lock);
+	INIT_LIST_HEAD(&data->node);
+
+	list_add(&data->node, &sysmmu_list);
+
+	if (dev->parent)
+		pm_runtime_enable(dev);
+
+	pr_debug("%s: System MMU for %s.%d Initialized.\n", __func__,
+							pdev->name, pdev->id);
+	return 0;
+err_clk:
+	free_irq(irq, data);
+err_irq:
+	iounmap(sfr);
+err_ioremap:
+	release_resource(ioarea);
+	kfree(ioarea);
+err_init:
+	kfree(data);
+err_alloc:
+	pr_err("%s: %s.%d Failed: %s\n", __func__, pdev->name, pdev->id, emsg);
+	return ret;
+}
+
+static int exynos_pm_resume(struct device *dev)
+{
+	struct sysmmu_drvdata *data;
+
+	data = dev_get_drvdata(dev);
+
+	if (is_sysmmu_active(data)) {
+		__sysmmu_set_ptbase(data->sfrbase, data->pgtable);
+
+		__raw_writel(CTRL_ENABLE, data->sfrbase + EXYNOS_MMU_CTRL);
+	}
+
+	return 0;
+}
+
+const struct dev_pm_ops exynos_pm_ops = {
+	.resume = &exynos_pm_resume,
+};
+
+static struct platform_driver exynos_sysmmu_driver = {
+	.probe		= exynos_sysmmu_probe,
+	.driver		= {
+		.owner		= THIS_MODULE,
+		.name		= "exynos-sysmmu",
+		.pm		= &exynos_pm_ops,
+	}
+};
+
+/* We does not consider super section mapping (16MB) */
+struct iommu_client {
+	struct list_head node;
+	struct device *dev;
+	int refcnt;
+};
+
+struct exynos_iommu_domain {
+	struct list_head clients; /* list of iommu_client */
+	unsigned long *pgtable; /* lv1 page table, 16KB */
+	short *lv2entcnt; /* free lv2 entry counter for each section */
+	spinlock_t lock; /* lock for this structure */
+	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
+};
+
+static inline void pgtable_flush(void *vastart, void *vaend)
+{
+	dmac_flush_range(vastart, vaend);
+	outer_flush_range(virt_to_phys(vastart),
+				virt_to_phys(vaend));
+}
+
+static int exynos_iommu_domain_init(struct iommu_domain *domain)
+{
+	struct exynos_iommu_domain *priv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->pgtable = (unsigned long *)__get_free_pages(
+						GFP_KERNEL | __GFP_ZERO, 2);
+	if (!priv->pgtable)
+		goto err_pgtable;
+
+	priv->lv2entcnt = (short *)__get_free_pages(
+						GFP_KERNEL | __GFP_ZERO, 1);
+	if (!priv->lv2entcnt)
+		goto err_counter;
+
+	pgtable_flush(priv->pgtable, priv->pgtable + 4096);
+
+	spin_lock_init(&priv->lock);
+	spin_lock_init(&priv->pgtablelock);
+	INIT_LIST_HEAD(&priv->clients);
+
+	domain->priv = priv;
+	return 0;
+
+err_counter:
+	free_pages((unsigned long)priv->pgtable, 2);
+err_pgtable:
+	kfree(priv);
+	return -ENOMEM;
+}
+
+static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	struct list_head *pos, *n;
+
+	WARN_ON(!list_empty(&priv->clients));
+
+	spin_lock(&priv->lock);
+
+	list_for_each_safe(pos, n, &priv->clients) {
+		struct iommu_client *client;
+
+		client = list_entry(pos, struct iommu_client, node);
+		exynos_sysmmu_disable(client->dev);
+		kfree(client);
+	}
+
+	spin_unlock(&priv->lock);
+
+	free_pages((unsigned long)priv->pgtable, 2);
+	kfree(domain->priv);
+	domain->priv = NULL;
+}
+
+static int exynos_iommu_attach_device(struct iommu_domain *domain,
+				   struct device *dev)
+{
+	int ret;
+	struct exynos_iommu_domain *priv = domain->priv;
+	struct iommu_client *client = NULL;
+	struct list_head *pos;
+
+	spin_lock(&priv->lock);
+
+	list_for_each(pos, &priv->clients) {
+		struct iommu_client *cur;
+
+		cur = list_entry(pos, struct iommu_client, node);
+		if (cur->dev == dev) {
+			client = cur;
+			break;
+		}
+	}
+
+	if (client != NULL) {
+		dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
+					__func__, __pa(priv->pgtable));
+		client->refcnt++;
+	}
+
+	spin_unlock(&priv->lock);
+
+	if (client != NULL)
+		return 0;
+
+	client = kmalloc(sizeof(*client), GFP_KERNEL);
+	if (!client)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&client->node);
+	client->dev = dev;
+	client->refcnt = 1;
+
+	ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
+	if (ret) {
+		kfree(client);
+		return ret;
+	}
+
+	spin_lock(&priv->lock);
+	list_add_tail(&client->node, &priv->clients);
+	spin_unlock(&priv->lock);
+
+	dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n", __func__,
+						__pa(priv->pgtable));
+	return 0;
+}
+
+static void exynos_iommu_detach_device(struct iommu_domain *domain,
+				    struct device *dev)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	struct iommu_client *client = NULL;
+	struct list_head *pos;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	list_for_each(pos, &priv->clients) {
+		struct iommu_client *cur;
+
+		cur = list_entry(pos, struct iommu_client, node);
+		if (cur->dev == dev) {
+			cur->refcnt--;
+			client = cur;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (WARN_ON(client == NULL))
+		return;
+
+	if (client->refcnt > 0) {
+		dev_dbg(dev, "%s: Detaching IOMMU with pgtable 0x%lx delayed\n",
+					__func__, __pa(priv->pgtable));
+		return;
+	}
+
+	BUG_ON(client->refcnt != 0);
+
+	list_del(&client->node);
+	exynos_iommu_disable(client->dev, true);
+	kfree(client);
+	dev_dbg(dev, "%s: Detached IOMMU with pgtable 0x%lx\n", __func__,
+						__pa(priv->pgtable));
+}
+
+#define section_phys(sent) (*sent & 0xFFF00000)
+#define section_offs(iova) (iova & 0xFFFFF)
+#define lpage_phys(pent) (*pent & 0xFFFF0000)
+#define lpage_offs(iova) (iova & 0xFFFF)
+#define spage_phys(pent) (*pent & 0xFFFFF000)
+#define spage_offs(iova) (iova & 0xFFF)
+
+#define lv1ent_offset(iova) (iova >> 20)
+#define lv2ent_offset(iova) ((iova & 0xFF000) >> 12)
+
+static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
+{
+	return pgtable + lv1ent_offset(iova);
+}
+
+static unsigned long *page_entry(unsigned long *sent, unsigned long iova)
+{
+	return (unsigned long *)__va(*sent & 0xFFFFFC00) + lv2ent_offset(iova);
+}
+
+#define lv1ent_fault(sent) (((*sent & 3) == 0) || ((*sent & 3) == 3))
+#define lv1ent_page(sent) ((*sent & 3) == 1)
+#define lv1ent_section(sent) ((*sent & 3) == 2)
+
+#define lv2ent_fault(pent) ((*pent & 3) == 0)
+#define lv2ent_small(pent) ((*pent & 2) == 2)
+#define lv2ent_large(pent) ((*pent & 3) == 1)
+
+static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
+					short *pgcounter)
+{
+	if (lv1ent_fault(sent)) {
+		unsigned long *pent;
+
+		pent = kzalloc(1024, GFP_KERNEL);
+		BUG_ON((unsigned long)pent & 0x3FF);
+		if (!pent)
+			return NULL;
+
+		*sent = __pa(pent) | 1;
+		*pgcounter = 256;
+		pgtable_flush(pent, pent + 256);
+		pgtable_flush(sent, sent + 1);
+	}
+
+	return page_entry(sent, iova);
+}
+
+static int lv1set_section(unsigned long *sent, phys_addr_t paddr, int nent,
+							short *pgcounter)
+{
+	int i;
+
+	for (i = 0; i < nent; i++) {
+		if (lv1ent_section(sent))
+			goto error;
+
+		if (lv1ent_page(sent)) {
+			if (*pgcounter != 256)
+				goto error;
+
+			kfree(page_entry(sent, 0));
+
+			*pgcounter = 0;
+		}
+
+		*sent = paddr | 2;
+
+		paddr += 0x100000;
+		sent++;
+		pgcounter++;
+	}
+
+	pgtable_flush(sent - nent, sent);
+
+	return 0;
+error:
+	if (i > 0)
+		memset(sent - i, 0, i * sizeof(*sent));
+
+	return -EADDRINUSE;
+}
+
+static int lv2set_page(unsigned long *pent, phys_addr_t paddr, int nent,
+							short *pgcounter)
+{
+	int i;
+
+	if (pent == NULL)
+		return -ENOMEM;
+
+	if (nent < 16) {
+		for (i = 0; i < nent; i++) {
+			if (!lv2ent_fault(pent))
+				goto error;
+
+			*pent = paddr | 3;
+
+			paddr += 0x1000;
+			pent++;
+		}
+	} else {
+		for (i = 0; i < nent; i += 16) {
+			int j;
+			for (j = 0; j < 16; j++) {
+				if (!lv2ent_fault(pent)) {
+					i += j;
+					goto error;
+				}
+
+				*pent = paddr | 1;
+				pent++;
+			}
+			paddr += 0x10000;
+		}
+	}
+
+	pgtable_flush(pent - nent, pent);
+
+	*pgcounter -= nent;
+	if (*pgcounter < 0)
+		pr_err("%s: pgcounter < 0: pgcounter = %d, nent = %d\n",
+				__func__, *pgcounter, nent);
+	return 0;
+
+error:
+	memset(pent - i, 0, i * sizeof(*pent));
+
+	return -EADDRINUSE;
+}
+
+static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
+			 phys_addr_t paddr, size_t size, int prot)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	unsigned long *entry;
+	int ret = -ENOMEM;
+
+	BUG_ON(priv->pgtable == NULL);
+
+	spin_lock(&priv->pgtablelock);
+
+	entry = section_entry(priv->pgtable, iova);
+
+	if (size >= 0x100000) {
+		ret = lv1set_section(entry, paddr, size >> 20,
+					&priv->lv2entcnt[lv1ent_offset(iova)]);
+	} else {
+		unsigned long *pent;
+
+		pent = alloc_lv2entry(entry, iova,
+					&priv->lv2entcnt[lv1ent_offset(iova)]);
+
+		ret = lv2set_page(pent, paddr, size >> 12,
+					&priv->lv2entcnt[lv1ent_offset(iova)]);
+	}
+	if (ret) {
+		pr_err("%s: Failed to map iova 0x%lx/0x%x bytes\n",
+				__func__, iova, size);
+	}
+
+	spin_unlock(&priv->pgtablelock);
+
+	return ret;
+}
+
+static size_t exynos_iommu_unmap(struct iommu_domain *domain,
+					       unsigned long iova, size_t size)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	struct iommu_client *client;
+	unsigned long flags;
+
+	BUG_ON(priv->pgtable == NULL);
+
+	spin_lock_irqsave(&priv->pgtablelock, flags);
+
+	while (size != 0) {
+		int i, nent, order;
+		unsigned long *pent, *sent;
+
+		sent = section_entry(priv->pgtable, iova);
+
+		order = min(__ffs(iova), __fls(size));
+
+		if (order < 20) {
+			pent = page_entry(sent, iova);
+
+			BUG_ON((order < 16) && lv2ent_large(pent));
+
+			nent = 1 << (order - 12);
+			memset(pent, 0, nent * sizeof(*pent));
+			pgtable_flush(pent, pent + nent);
+
+			priv->lv2entcnt[lv1ent_offset(iova)] += (short)nent;
+			iova += 1 << order;
+		} else {
+			nent = 1 << (order - 20);
+
+			for (i = 0; i < nent; i++) {
+				if (lv1ent_section(sent)) {
+					*sent = 0;
+				} else if (lv1ent_page(sent)) {
+					pent = page_entry(sent, 0);
+					memset(pent, 0, 256 * sizeof(*pent));
+					pgtable_flush(pent, pent + 256);
+					priv->lv2entcnt[lv1ent_offset(iova)]
+									= 256;
+				}
+				iova += 0x100000;
+				sent++;
+			}
+			pgtable_flush(sent - nent, sent);
+		}
+
+		size -= 1 << order;
+	}
+
+	list_for_each_entry(client, &priv->clients, node) {
+		exynos_sysmmu_tlb_invalidate(client->dev);
+	}
+
+	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+
+	return size;
+}
+
+static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
+					  unsigned long iova)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	unsigned long *entry;
+
+	entry = section_entry(priv->pgtable, iova);
+
+	if (lv1ent_fault(entry))
+		return 0;
+
+	if (lv1ent_section(entry))
+		return section_phys(entry) + section_offs(iova);
+
+	entry = page_entry(entry, iova);
+
+	if (lv2ent_fault(entry))
+		return 0;
+	else if (lv2ent_large(entry))
+		return lpage_phys(entry) + lpage_offs(iova);
+
+	return spage_phys(entry) + spage_offs(iova);
+}
+
+static int exynos_iommu_domain_has_cap(struct iommu_domain *domain,
+				    unsigned long cap)
+{
+	return 0;
+}
+
+static struct iommu_ops exynos_iommu_ops = {
+	.domain_init = &exynos_iommu_domain_init,
+	.domain_destroy = &exynos_iommu_domain_destroy,
+	.attach_dev = &exynos_iommu_attach_device,
+	.detach_dev = &exynos_iommu_detach_device,
+	.map = &exynos_iommu_map,
+	.unmap = &exynos_iommu_unmap,
+	.iova_to_phys = &exynos_iommu_iova_to_phys,
+	.domain_has_cap = &exynos_iommu_domain_has_cap,
+	.pgsize_bitmap = 0xFFFFF000,
+};
+
+static int __init exynos_iommu_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&exynos_sysmmu_driver);
+
+	if (ret == 0)
+		bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+
+	return ret;
+}
+arch_initcall(exynos_iommu_init);
-- 
1.7.1

