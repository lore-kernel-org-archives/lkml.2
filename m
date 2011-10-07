Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289Ab1JGKKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:10:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50492 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759589Ab1JGKKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:10:14 -0400
X-AuditID: cbfee61b-b7b7fae000005864-69-4e8ecff705cc
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Russell King'" <rmk+kernel@arm.linux.org.uk>, joerg.roedel@amd.com,
        "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        younglak1004.kim@samsung.com, "'Kukjin Kim'" <kgene.kim@samsung.com>
Subject: [PATCH v3 RE-SEND 2/2] iommu/exynos: Add iommu driver for Exynos
 Platforms
Date: Fri, 07 Oct 2011 19:09:58 +0900
Message-id: <01e601cc84d9$4530d6a0$cf9283e0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyE13OJGyDzKZgWQFK3L+BdU9axpAAAZFvA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KyongHo Cho <pullip.cho@samsung.com>

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
Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
NOTE: Since previous sending has problem, I'm re-sending.
Sorry, please kindly ignore previous one.

 arch/arm/plat-s5p/Kconfig                   |   14 -
 arch/arm/plat-s5p/Makefile                  |    1 -
 arch/arm/plat-s5p/sysmmu.c                  |  312 ---------
 arch/arm/plat-samsung/include/plat/sysmmu.h |   95 ---
 drivers/iommu/Kconfig                       |   14 +
 drivers/iommu/Makefile                      |    1 +
 drivers/iommu/exynos_iommu.c                |  963 +++++++++++++++++++++++++++
 7 files changed, 978 insertions(+), 422 deletions(-)
 delete mode 100644 arch/arm/plat-s5p/sysmmu.c
 delete mode 100644 arch/arm/plat-samsung/include/plat/sysmmu.h
 create mode 100644 drivers/iommu/exynos_iommu.c

diff --git a/arch/arm/plat-s5p/Kconfig b/arch/arm/plat-s5p/Kconfig
index 7b9dada..fa374cc 100644
--- a/arch/arm/plat-s5p/Kconfig
+++ b/arch/arm/plat-s5p/Kconfig
@@ -46,20 +46,6 @@ config S5P_PM
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
-config S5P_SLEEP
-	bool
-	help
-	  Internal config node to apply common S5P sleep management code.
-	  Can be selected by S5P and newer SoCs with similar sleep procedure.
-
 config S5P_DEV_FIMC0
 	bool
 	help
diff --git a/arch/arm/plat-s5p/Makefile b/arch/arm/plat-s5p/Makefile
index 06401dc..7a9c4fc 100644
--- a/arch/arm/plat-s5p/Makefile
+++ b/arch/arm/plat-s5p/Makefile
@@ -19,7 +19,6 @@ obj-y				+= clock.o
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
index b57b3fa..1c754cd 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -107,4 +107,18 @@ config INTR_REMAP
 	  To use x2apic mode in the CPU's which support x2APIC enhancements or
 	  to support platforms with CPU's having > 8 bit APIC ID, say Y.
 
+# EXYNOS IOMMU support
+config EXYNOS_IOMMU
+	bool "Exynos IOMMU Support"
+	depends on ARCH_EXYNOS4
+	select IOMMU_API
+	select EXYNOS4_DEV_SYSMMU
+	help
+	  Support for the IOMMUs (System MMUs) Samsung Exynos application
+	  processor family. This enables H/W multimedia accellerators to view
+	  non-linear physical memory chunks as a linear memory in their virtual
+	  address spaces.
+
+	  If unsure, say N here.
+
 endif # IOMMU_SUPPORT
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 4d4d77d..1eb924f 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
 obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
 obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
 obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
+obj-$(CONFIG_EXYNOS_IOMMU) += exynos_iommu.o
diff --git a/drivers/iommu/exynos_iommu.c b/drivers/iommu/exynos_iommu.c
new file mode 100644
index 0000000..b01345d
--- /dev/null
+++ b/drivers/iommu/exynos_iommu.c
@@ -0,0 +1,963 @@
+/* linux/drivers/iommu/exynos_iommu.c
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/iommu.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/list.h>
+#include <linux/atomic.h>
+#include <linux/spinlock.h>
+
+#include <asm/cacheflush.h>
+#include <asm/pgtable.h>
+
+#include <mach/map.h>
+#include <mach/regs-sysmmu.h>
+#include <mach/sysmmu.h>
+
+#define CTRL_ENABLE	0x5
+#define CTRL_BLOCK	0x7
+#define CTRL_DISABLE	0x0
+
+enum S5P_SYSMMU_INTERRUPT_TYPE {
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
+static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
+	S5P_PAGE_FAULT_ADDR,
+	S5P_AR_FAULT_ADDR,
+	S5P_AW_FAULT_ADDR,
+	S5P_DEFAULT_SLAVE_ADDR,
+	S5P_AR_FAULT_ADDR,
+	S5P_AR_FAULT_ADDR,
+	S5P_AW_FAULT_ADDR,
+	S5P_AW_FAULT_ADDR
+};
+
+static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM + 1] = {
+	"PAGE FAULT",
+	"AR MULTI-HIT FAULT",
+	"AW MULTI-HIT FAULT",
+	"BUS ERROR",
+	"AR SECURITY PROTECTION FAULT",
+	"AR ACCESS PROTECTION FAULT",
+	"AW SECURITY PROTECTION FAULT",
+	"AW ACCESS PROTECTION FAULT",
+	"UNKOWN FAULT"
+};
+
+struct exynos_iommu_domain {
+	struct device *dev;
+	unsigned long *pgtable;
+	spinlock_t lock;
+	spinlock_t pgtablelock;
+};
+
+typedef int (*s5p_sysmmu_fault_handler_t)(enum S5P_SYSMMU_INTERRUPT_TYPE itype,
+					unsigned long pgtable_base,
+					unsigned long fault_addr);
+struct sysmmu_drvdata {
+	struct list_head node;
+	struct device *dev;
+	struct device *owner;
+	void __iomem *sfrbase;
+	struct clk *clk;
+	int activations;
+	rwlock_t lock;
+	struct iommu_domain *domain;
+	s5p_sysmmu_fault_handler_t fault_handler;
+};
+
+
+/* List of sysmmu_drvdata */
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
+	__raw_writel(CTRL_BLOCK, sfrbase + S5P_MMU_CTRL);
+}
+
+static void sysmmu_unblock(void __iomem *sfrbase)
+{
+	__raw_writel(CTRL_ENABLE, sfrbase + S5P_MMU_CTRL);
+}
+
+static void __sysmmu_tlb_invalidate(void __iomem *sfrbase)
+{
+	__raw_writel(0x1, sfrbase + S5P_MMU_FLUSH);
+}
+
+static void __sysmmu_set_ptbase(void __iomem *sfrbase,
+				       unsigned long pgd)
+{
+	if (unlikely(pgd == 0)) {
+		pgd = (unsigned long)ZERO_PAGE(0);
+		__raw_writel(0x20, sfrbase + S5P_MMU_CFG); /* 4KB LV1 */
+	} else {
+		__raw_writel(0x0, sfrbase + S5P_MMU_CFG); /* 16KB LV1 */
+	}
+
+	__raw_writel(pgd, sfrbase + S5P_PT_BASE_ADDR);
+
+	__sysmmu_tlb_invalidate(sfrbase);
+}
+
+static void __set_fault_handler(struct sysmmu_drvdata *data,
+				s5p_sysmmu_fault_handler_t handler)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&data->lock, flags);
+	data->fault_handler = handler;
+	write_unlock_irqrestore(&data->lock, flags);
+}
+
+void s5p_sysmmu_set_fault_handler(struct device *owner,
+				s5p_sysmmu_fault_handler_t handler)
+{
+	struct sysmmu_drvdata *data = NULL;
+
+	while ((data = get_sysmmu_data(owner, data)))
+		__set_fault_handler(data, handler);
+}
+
+static int default_fault_handler(enum S5P_SYSMMU_INTERRUPT_TYPE itype,
+			unsigned long pgtable_base, unsigned long fault_addr)
+{
+	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
+		itype = SYSMMU_FAULT_UNKNOWN;
+
+	pr_err("%s occured at 0x%08lx(Page table base: 0x%08lx)\n",
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
+	enum S5P_SYSMMU_INTERRUPT_TYPE itype;
+	unsigned long addr;
+	int ret = -ENOSYS;
+
+	read_lock(&data->lock);
+
+	WARN_ON(!is_sysmmu_active(data));
+
+	itype = (enum S5P_SYSMMU_INTERRUPT_TYPE)
+		__ffs(__raw_readl(data->sfrbase + S5P_INT_STATUS));
+
+	if (WARN_ON((itype < 0) && (itype >= 8)))
+		itype = SYSMMU_FAULT_UNKNOWN;
+
+	addr = __raw_readl(data->sfrbase + fault_reg_offset[itype]);
+
+	if (data->domain)
+		ret = report_iommu_fault(data->domain, data->owner, addr,
+									itype);
+
+	if ((ret == -ENOSYS) && (data->fault_handler)) {
+		unsigned long base;
+		base = __raw_readl(data->sfrbase + S5P_PT_BASE_ADDR);
+
+		ret = data->fault_handler(itype, base, addr);
+	}
+
+	if (!ret)
+		__raw_writel(1 << itype, data->sfrbase + S5P_INT_CLEAR);
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
+void exynos_sysmmu_set_tablebase_pgd(struct device *owner, unsigned long pgd)
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
+			__sysmmu_set_ptbase(data->sfrbase, pgd);
+			sysmmu_unblock(data->sfrbase);
+			dev_dbg(data->dev,
+				"New page table base is 0x%08lx\n", pgd);
+		} else {
+			dev_dbg(data->dev,
+			"Disabled: Skipping setting page table base.\n");
+		}
+
+		read_unlock_irqrestore(&data->lock, flags);
+	}
+}
+
+static int __exynos_sysmmu_enable(struct device *owner, unsigned long pgtable,
+						struct iommu_domain *domain)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct sysmmu_drvdata *data = NULL;
+
+	/* There are some devices that control more System MMUs than one such
+	 * as MFC.
+	 */
+	while ((data = get_sysmmu_data(owner, data))) {
+		ret = pm_runtime_get_sync(data->dev);
+		if (ret) {
+			set_sysmmu_active(data); /* for rollback */
+			break;
+		}
+
+		write_lock_irqsave(&data->lock, flags);
+
+		if (set_sysmmu_active(data)) {
+			__sysmmu_set_ptbase(data->sfrbase, pgtable);
+
+			__raw_writel(CTRL_ENABLE, data->sfrbase + S5P_MMU_CTRL);
+
+			data->domain = domain;
+
+			dev_dbg(data->dev, "Enabled.\n");
+		} else {
+			dev_dbg(data->dev, "Already enabled.\n");
+		}
+
+		write_unlock_irqrestore(&data->lock, flags);
+	}
+
+	if (ret) {
+		do {
+			write_lock_irqsave(&data->lock, flags);
+			set_sysmmu_inactive(data);
+			data->domain = NULL;
+			/* deinitialization is not required actually. */
+			write_unlock_irqrestore(&data->lock, flags);
+
+			pm_runtime_put_sync(data->dev);
+
+			dev_dbg(data->dev, "Failed to enable.\n");
+		} while ((data = get_sysmmu_data_rollback(owner, data)));
+	}
+
+	return ret;
+}
+
+static int exynos_iommu_enable(struct iommu_domain *domain)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+
+	if (!priv || !priv->dev)
+		return -EINVAL;
+
+	return __exynos_sysmmu_enable(priv->dev, __pa(priv->pgtable), domain);
+}
+
+int exynos_sysmmu_enable(struct device *owner, unsigned long pgtable)
+{
+	return __exynos_sysmmu_enable(owner, pgtable, NULL);
+}
+
+void exynos_sysmmu_disable(struct device *owner)
+{
+	struct sysmmu_drvdata *data = NULL;
+
+	while ((data = get_sysmmu_data(owner, data))) {
+		unsigned long flags;
+
+		write_lock_irqsave(&data->lock, flags);
+
+		if (set_sysmmu_inactive(data)) {
+			__raw_writel(CTRL_DISABLE,
+						data->sfrbase + S5P_MMU_CTRL);
+
+			dev_dbg(data->dev, "Disabled.\n");
+		} else {
+			dev_dbg(data->dev, "Inactivation request ignorred\n");
+		}
+
+		__raw_writel(CTRL_DISABLE, data->sfrbase + S5P_MMU_CTRL);
+
+		data->domain = NULL;
+
+		write_unlock_irqrestore(&data->lock, flags);
+
+		pm_runtime_put_sync(data->dev);
+	}
+}
+
+static void exynos_iommu_disable(struct iommu_domain *domain)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+
+	if (priv && priv->dev)
+		exynos_sysmmu_disable(priv->dev);
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
+				"Disabled: Skipping invalidating TLB.\n");
+		}
+
+		read_unlock_irqrestore(&data->lock, flags);
+	}
+}
+
+static int exynos_sysmmu_probe(struct platform_device *pdev)
+{
+	struct resource *res, *ioarea;
+	int ret = 0;
+	int irq;
+	struct device *dev;
+	void *sfr;
+	struct sysmmu_drvdata *data;
+	struct clk *clk;
+
+	dev = &pdev->dev;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(dev, "Failed to probing System MMU: "
+					"Not enough memory");
+		return -ENOMEM;
+	}
+
+	if (!dev_get_platdata(dev)) {
+		dev_err(dev, "Failed to probing system MMU: "
+						"Owner device is not set.");
+
+		ret = -ENODEV;
+		goto err_init;
+	}
+
+	ret = dev_set_drvdata(dev, data);
+	if (ret) {
+		dev_err(dev, "Failed to probing system MMU: "
+						"Unable to set driver data.");
+		goto err_init;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev,
+			"Failed probing system MMU: failed to get resource.");
+		ret = -ENOENT;
+		goto err_init;
+	}
+
+	ioarea = request_mem_region(res->start, resource_size(res),
+								dev_name(dev));
+	if (ioarea == NULL) {
+		dev_err(dev, "Failed probing system MMU: "
+					"failed to request memory region.");
+		ret = -ENOENT;
+		goto err_init;
+	}
+
+	sfr = ioremap(res->start, resource_size(res));
+	if (!sfr) {
+		dev_err(dev, "Failed probing system MMU: "
+						"failed to call ioremap().");
+		ret = -ENOENT;
+		goto err_ioremap;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		dev_err(dev, "Failed probing system MMU: "
+						"failed to get irq resource.");
+		ret = irq;
+		goto err_irq;
+	}
+
+	ret = request_irq(irq, exynos_sysmmu_irq, 0, dev_name(dev), data);
+	if (ret) {
+		dev_err(dev, "Failed probing system MMU: "
+						"failed to request irq.");
+		goto err_irq;
+	}
+
+	clk = clk_get(dev, "sysmmu");
+	if (IS_ERR(clk)) {
+		dev_err(dev, "Failed to probing System MMU: "
+					"failed to get clock descriptor");
+		ret = PTR_ERR(clk);
+		goto err_clk;
+	}
+
+	data->dev = dev;
+	data->owner = dev_get_platdata(dev);
+	data->clk = clk;
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
+	dev_dbg(dev, "Initialized for %s.\n", dev_name(data->owner));
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
+	dev_err(dev, "Probing system MMU failed.");
+	return ret;
+}
+
+int exynos_sysmmu_runtime_suspend(struct device *dev)
+{
+	struct sysmmu_drvdata *data = dev_get_drvdata(dev);
+
+	clk_disable(data->clk);
+
+	return 0;
+}
+
+int exynos_sysmmu_runtime_resume(struct device *dev)
+{
+	struct sysmmu_drvdata *data = dev_get_drvdata(dev);
+
+	return clk_enable(data->clk);
+}
+
+const struct dev_pm_ops exynos_sysmmu_pm_ops = {
+	.runtime_suspend	= exynos_sysmmu_runtime_suspend,
+	.runtime_resume		= exynos_sysmmu_runtime_resume,
+};
+
+static struct platform_driver exynos_sysmmu_driver = {
+	.probe		= exynos_sysmmu_probe,
+	.driver		= {
+		.owner		= THIS_MODULE,
+		.name		= "s5p-sysmmu",
+		.pm		= &exynos_sysmmu_pm_ops,
+	}
+};
+
+static int __init exynos_sysmmu_init(void)
+{
+	return platform_driver_register(&exynos_sysmmu_driver);
+}
+arch_initcall(exynos_sysmmu_init);
+
+/* We does not consider super section mapping (16MB) */
+#define S5P_SPAGE_SHIFT		12
+#define S5P_LPAGE_SHIFT		16
+#define S5P_SECTION_SHIFT	20
+
+#define S5P_SPAGE_SIZE		(1 << S5P_SPAGE_SHIFT)
+#define S5P_LPAGE_SIZE		(1 << S5P_LPAGE_SHIFT)
+#define S5P_SECTION_SIZE	(1 << S5P_SECTION_SHIFT)
+
+#define S5P_SPAGE_MASK		(~(S5P_SPAGE_SIZE - 1))
+#define S5P_LPAGE_MASK		(~(S5P_LPAGE_SIZE - 1))
+#define S5P_SECTION_MASK	(~(S5P_SECTION_SIZE - 1))
+
+#define S5P_SPAGE_ORDER		(S5P_SPAGE_SHIFT - PAGE_SHIFT)
+#define S5P_LPAGE_ORDER		(S5P_LPAGE_SHIFT - S5P_SPAGE_SHIFT)
+#define S5P_SECTION_ORDER	(S5P_SECTION_SHIFT - S5P_SPAGE_SHIFT)
+
+#define S5P_LV1TABLE_ENTRIES	(1 << (BITS_PER_LONG - S5P_SECTION_SHIFT))
+#define S5P_LV1TABLE_ORDER	2 /* get_order(S5P_LV1TABLE_ENTRIES) */
+
+#define S5P_LV2TABLE_ENTRIES	(1 << S5P_SECTION_ORDER)
+#define S5P_LV2TABLE_SIZE	(S5P_LV2TABLE_ENTRIES * sizeof(long))
+#define S5P_LV2TABLE_MASK	(~(S5P_LV2TABLE_SIZE - 1)) /* 0xFFFFFC00 */
+
+#define S5P_SECTION_LV1_ENTRY(entry)	((entry & 0x40003) == 2)
+#define S5P_SUPSECT_LV1_ENTRY(entry)	((entry & 0x40003) == 0x40002)
+#define S5P_PAGE_LV1_ENTRY(entry)	((entry & 3) == 1)
+#define S5P_FAULT_LV1_ENTRY(entry) (((entry & 3) == 0) || (entry & 3) == 3)
+
+#define S5P_LPAGE_LV2_ENTRY(entry)	((entry & 3) == 1)
+#define S5P_SPAGE_LV2_ENTRY(entry)	((entry & 2) == 2)
+#define S5P_FAULT_LV2_ENTRY(entry)	((entry & 3) == 0)
+
+#define MAKE_FAULT_ENTRY(entry)		do { entry = 0; } while (0)
+#define MAKE_SECTION_ENTRY(entry, pa)	do { entry = pa | 2; } while (0)
+#define MAKE_SUPSECT_ENTRY(entry, pa)	do { entry = pa | 0x40002; } while (0)
+#define MAKE_LV2TABLE_ENTRY(entry, pa)	do { entry = pa | 1; } while (0)
+
+#define MAKE_LPAGE_ENTRY(entry, pa)	do { entry = pa | 1; } while (0)
+#define MAKE_SPAGE_ENTRY(entry, pa)	do { entry = pa | 3; } while (0)
+
+#define GET_LV2ENTRY(entry, iova) (\
+	(unsigned long *)phys_to_virt(entry & S5P_LV2TABLE_MASK) +\
+	((iova & (~S5P_SECTION_MASK)) >> S5P_SPAGE_SHIFT))
+
+/* slab cache for level 2 page tables */
+static struct kmem_cache *l2table_cachep;
+
+static void pgtable_flush(void *vastart, void *vaend)
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
+	priv->pgtable = (unsigned long *)
+			__get_free_pages(S5P_LV1TABLE_ORDER, GFP_KERNEL);
+	if (!priv->pgtable) {
+		kfree(priv);
+		return -ENOMEM;
+	}
+
+	memset(priv->pgtable, 0, S5P_LV1TABLE_ENTRIES * sizeof(unsigned long));
+	pgtable_flush(priv->pgtable, priv->pgtable + S5P_LV1TABLE_ENTRIES);
+
+	spin_lock_init(&priv->lock);
+	spin_lock_init(&priv->pgtablelock);
+
+	domain->priv = priv;
+
+	return 0;
+}
+
+static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+
+	free_pages((unsigned long)priv->pgtable, S5P_LV1TABLE_ORDER);
+
+	kfree(priv);
+
+	domain->priv = NULL;
+}
+
+static int exynos_iommu_attach_device(struct iommu_domain *domain,
+				   struct device *dev)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	int ret;
+
+	spin_lock(&priv->lock);
+
+	priv->dev = dev;
+
+	spin_unlock(&priv->lock);
+
+	ret = exynos_iommu_enable(domain);
+
+	return ret;
+}
+
+static void exynos_iommu_detach_device(struct iommu_domain *domain,
+				    struct device *dev)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+
+	spin_lock(&priv->lock);
+
+	if (priv->dev == dev) {
+		priv->dev = NULL;
+
+		spin_unlock(&priv->lock);
+
+		exynos_iommu_disable(domain);
+	} else {
+		spin_unlock(&priv->lock);
+	}
+}
+
+static bool section_available(struct iommu_domain *domain,
+			      unsigned long *lv1entry)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+
+	if (S5P_SECTION_LV1_ENTRY(*lv1entry)) {
+		dev_err(priv->dev, "1MB entry alread exists at 0x%08x\n",
+				(lv1entry - priv->pgtable) * SZ_1M);
+		return false;
+	}
+
+	if (S5P_PAGE_LV1_ENTRY(*lv1entry)) {
+		unsigned long *lv2end, *lv2base;
+
+		lv2base = phys_to_virt(*lv1entry & S5P_LV2TABLE_MASK);
+		lv2end = lv2base + S5P_LV2TABLE_ENTRIES;
+		while (lv2base != lv2end) {
+			if (!S5P_FAULT_LV2_ENTRY(*lv2base)) {
+				dev_err(priv->dev, "Failed to free L2 page "
+						"table for section mapping.\n");
+				return false;
+			}
+			lv2base++;
+		}
+
+		kmem_cache_free(l2table_cachep,
+				phys_to_virt(*lv1entry & S5P_LV2TABLE_MASK));
+
+		MAKE_FAULT_ENTRY(*lv1entry);
+	}
+
+	return true;
+}
+
+static bool write_lpage(unsigned long *head_entry, unsigned long phys_addr)
+{
+	unsigned long *entry, *end;
+
+	entry = head_entry;
+	end = entry + (1 << S5P_LPAGE_ORDER);
+
+	while (entry != end) {
+		if (!S5P_FAULT_LV2_ENTRY(*entry))
+			break;
+
+		MAKE_LPAGE_ENTRY(*entry, phys_addr);
+
+		entry++;
+	}
+
+	if (entry != end) {
+		end = entry;
+		while (entry != head_entry)
+			MAKE_FAULT_ENTRY(*(--entry));
+
+		return false;
+	}
+
+	return true;
+}
+
+static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
+			 phys_addr_t paddr, int gfp_order, int prot)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	unsigned long *start_entry, *entry, *end_entry;
+	int num_entry;
+	int ret = 0;
+	unsigned long flags;
+
+	BUG_ON(priv->pgtable == NULL);
+
+	spin_lock_irqsave(&priv->pgtablelock, flags);
+
+	start_entry = entry = priv->pgtable + (iova >> S5P_SECTION_SHIFT);
+
+	if (gfp_order >= S5P_SECTION_ORDER) {
+		BUG_ON(!IS_ALIGNED(paddr | iova, S5P_SECTION_SIZE));
+		/* 1MiB mapping */
+
+		num_entry = 1 << (gfp_order - S5P_SECTION_ORDER);
+		end_entry = entry + num_entry;
+
+		while (entry != end_entry) {
+			if (!section_available(domain, entry))
+				break;
+
+			MAKE_SECTION_ENTRY(*entry, paddr);
+
+			paddr += S5P_SECTION_SIZE;
+			entry++;
+		}
+
+		if (entry != end_entry)
+			goto mapping_error;
+
+		pgtable_flush(start_entry, entry);
+		goto mapping_done;
+	}
+
+	if (S5P_FAULT_LV1_ENTRY(*entry)) {
+		unsigned long *l2table;
+
+		l2table = kmem_cache_zalloc(l2table_cachep, GFP_KERNEL);
+		if (!l2table) {
+			ret = -ENOMEM;
+			goto nomem_error;
+		}
+
+		pgtable_flush(entry, entry + S5P_LV2TABLE_ENTRIES);
+
+		MAKE_LV2TABLE_ENTRY(*entry, virt_to_phys(l2table));
+		pgtable_flush(entry, entry + 1);
+	}
+
+	/* 'entry' points level 2 entries, hereafter */
+	entry = GET_LV2ENTRY(*entry, iova);
+
+	start_entry = entry;
+	num_entry = 1 << gfp_order;
+	end_entry = entry + num_entry;
+
+	if (gfp_order >= S5P_LPAGE_ORDER) {
+		/* large page(64KiB) mapping */
+		BUG_ON(!IS_ALIGNED(paddr | iova, S5P_LPAGE_SIZE));
+
+		while (entry != end_entry) {
+			if (!write_lpage(entry, paddr)) {
+				pr_err("%s: "
+					"Failed to allocate large page entry."
+					"\n", __func__);
+				break;
+			}
+
+			paddr += S5P_LPAGE_SIZE;
+			entry += (1 << S5P_LPAGE_ORDER);
+		}
+
+		if (entry != end_entry) {
+			entry -= 1 << S5P_LPAGE_ORDER;
+			goto mapping_error;
+		}
+	} else {
+		/* page (4KiB) mapping */
+		while (entry != end_entry && S5P_FAULT_LV2_ENTRY(*entry)) {
+
+			MAKE_SPAGE_ENTRY(*entry, paddr);
+
+			entry++;
+			paddr += S5P_SPAGE_SIZE;
+		}
+
+		if (entry != end_entry) {
+			pr_err("%s: Failed to allocate small page entry.\n",
+								__func__);
+			goto mapping_error;
+		}
+	}
+
+	pgtable_flush(start_entry, entry);
+mapping_error:
+	if (entry != end_entry) {
+		unsigned long *current_entry = entry;
+		while (entry != start_entry)
+			MAKE_FAULT_ENTRY(*(--entry));
+		pgtable_flush(start_entry, current_entry);
+		ret = -EADDRINUSE;
+	}
+
+nomem_error:
+mapping_done:
+	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+
+	return 0;
+}
+
+static int exynos_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+			   int gfp_order)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	unsigned long *entry;
+	int num_entry;
+	unsigned long flags;
+
+	BUG_ON(priv->pgtable == NULL);
+
+	spin_lock_irqsave(&priv->pgtablelock, flags);
+
+	entry = priv->pgtable + (iova >> S5P_SECTION_SHIFT);
+
+	if (gfp_order >= S5P_SECTION_ORDER) {
+		gfp_order -= S5P_SECTION_ORDER;
+		num_entry = 1 << (gfp_order - S5P_SECTION_ORDER);
+		while (num_entry--) {
+			if (S5P_SECTION_LV1_ENTRY(*entry)) {
+				MAKE_FAULT_ENTRY(*entry);
+			} else if (S5P_PAGE_LV1_ENTRY(*entry)) {
+				unsigned long *lv2beg, *lv2end;
+				lv2beg = phys_to_virt(
+						*entry & S5P_LV2TABLE_MASK);
+				lv2end = lv2beg + S5P_LV2TABLE_ENTRIES;
+				while (lv2beg != lv2end) {
+					MAKE_FAULT_ENTRY(*lv2beg);
+					lv2beg++;
+				}
+			}
+			entry++;
+		}
+	} else {
+		entry = GET_LV2ENTRY(*entry, iova);
+
+		BUG_ON(S5P_LPAGE_LV2_ENTRY(*entry) &&
+						(gfp_order < S5P_LPAGE_ORDER));
+
+		num_entry = 1 << gfp_order;
+
+		while (num_entry--) {
+			MAKE_FAULT_ENTRY(*entry);
+			entry++;
+		}
+	}
+
+	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+
+	if (priv->dev)
+		exynos_sysmmu_tlb_invalidate(priv->dev);
+
+	return 0;
+}
+
+static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
+					  unsigned long iova)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	unsigned long *entry;
+	unsigned long offset;
+
+	entry = priv->pgtable + (iova >> S5P_SECTION_SHIFT);
+
+	if (S5P_FAULT_LV1_ENTRY(*entry))
+		return 0;
+
+	offset = iova & ~S5P_SECTION_MASK;
+
+	if (S5P_SECTION_LV1_ENTRY(*entry))
+		return (*entry & S5P_SECTION_MASK) + offset;
+
+	entry = GET_LV2ENTRY(*entry, iova);
+
+	if (S5P_SPAGE_LV2_ENTRY(*entry))
+		return (*entry & S5P_SPAGE_MASK) + (iova & ~S5P_SPAGE_MASK);
+
+	if (S5P_LPAGE_LV2_ENTRY(*entry))
+		return (*entry & S5P_LPAGE_MASK) + (iova & ~S5P_LPAGE_MASK);
+
+	return 0;
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
+};
+
+static int __init exynos_iommu_init(void)
+{
+	l2table_cachep = kmem_cache_create("SysMMU Lv2 Tables",
+				S5P_LV2TABLE_SIZE, S5P_LV2TABLE_SIZE, 0, NULL);
+	if (!l2table_cachep)
+		return -ENOMEM;
+
+	bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+
+	return 0;
+}
+arch_initcall(exynos_iommu_init);
-- 
1.7.1


