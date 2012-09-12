Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab2ILTqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:46:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58001 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab2ILTqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:46:11 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joerg.roedel@amd.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [PATCH v2 5/9] ARM: OMAP3/4: iommu: adapt to runtime pm
Date: Wed, 12 Sep 2012 14:45:48 -0500
Message-Id: <1347479152-588-6-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
References: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use runtime PM functionality interfaced with hwmod enable/idle
functions, to replace direct clock operations and sysconfig
handling.

Dues to reset sequence, pm_runtime_put_sync must be used, to avoid
possible operations with the module under reset.

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 arch/arm/mach-omap2/iommu2.c             |   17 -----------
 arch/arm/mach-omap2/omap-iommu.c         |    1 -
 arch/arm/plat-omap/include/plat/iommu.h  |    2 --
 arch/arm/plat-omap/include/plat/iommu2.h |    2 --
 drivers/iommu/omap-iommu.c               |   45 +++++++++++++-----------------
 5 files changed, 19 insertions(+), 48 deletions(-)

diff --git a/arch/arm/mach-omap2/iommu2.c b/arch/arm/mach-omap2/iommu2.c
index 35cab47..3e47786 100644
--- a/arch/arm/mach-omap2/iommu2.c
+++ b/arch/arm/mach-omap2/iommu2.c
@@ -25,15 +25,6 @@
  */
 #define IOMMU_ARCH_VERSION	0x00000011
 
-/* SYSCONF */
-#define MMU_SYS_IDLE_SHIFT	3
-#define MMU_SYS_IDLE_FORCE	(0 << MMU_SYS_IDLE_SHIFT)
-#define MMU_SYS_IDLE_NONE	(1 << MMU_SYS_IDLE_SHIFT)
-#define MMU_SYS_IDLE_SMART	(2 << MMU_SYS_IDLE_SHIFT)
-#define MMU_SYS_IDLE_MASK	(3 << MMU_SYS_IDLE_SHIFT)
-
-#define MMU_SYS_AUTOIDLE	1
-
 /* IRQSTATUS & IRQENABLE */
 #define MMU_IRQ_MULTIHITFAULT	(1 << 4)
 #define MMU_IRQ_TABLEWALKFAULT	(1 << 3)
@@ -96,11 +87,6 @@ static int omap2_iommu_enable(struct omap_iommu *obj)
 	dev_info(obj->dev, "%s: version %d.%d\n", obj->name,
 		 (l >> 4) & 0xf, l & 0xf);
 
-	l = iommu_read_reg(obj, MMU_SYSCONFIG);
-	l &= ~MMU_SYS_IDLE_MASK;
-	l |= (MMU_SYS_IDLE_SMART | MMU_SYS_AUTOIDLE);
-	iommu_write_reg(obj, l, MMU_SYSCONFIG);
-
 	iommu_write_reg(obj, pa, MMU_TTB);
 
 	__iommu_set_twl(obj, true);
@@ -114,7 +100,6 @@ static void omap2_iommu_disable(struct omap_iommu *obj)
 
 	l &= ~MMU_CNTL_MASK;
 	iommu_write_reg(obj, l, MMU_CNTL);
-	iommu_write_reg(obj, MMU_SYS_IDLE_FORCE, MMU_SYSCONFIG);
 
 	dev_dbg(obj->dev, "%s is shutting down\n", obj->name);
 }
@@ -243,8 +228,6 @@ omap2_iommu_dump_ctx(struct omap_iommu *obj, char *buf, ssize_t len)
 	char *p = buf;
 
 	pr_reg(REVISION);
-	pr_reg(SYSCONFIG);
-	pr_reg(SYSSTATUS);
 	pr_reg(IRQSTATUS);
 	pr_reg(IRQENABLE);
 	pr_reg(WALKING_ST);
diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
index 96eecd8..e8f88dc 100644
--- a/arch/arm/mach-omap2/omap-iommu.c
+++ b/arch/arm/mach-omap2/omap-iommu.c
@@ -32,7 +32,6 @@ static int __init omap_iommu_dev_init(struct omap_hwmod *oh, void *unused)
 		return -ENOMEM;
 
 	pdata->name = oh->name;
-	pdata->clk_name = oh->main_clk;
 	pdata->nr_tlb_entries = a->nr_tlb_entries;
 	pdata->da_start = a->da_start;
 	pdata->da_end = a->da_end;
diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
index bb15b85..004cb9e 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -30,7 +30,6 @@ struct iotlb_entry {
 struct omap_iommu {
 	const char	*name;
 	struct module	*owner;
-	struct clk	*clk;
 	void __iomem	*regbase;
 	struct device	*dev;
 	void		*isr_priv;
@@ -120,7 +119,6 @@ struct omap_mmu_dev_attr {
 
 struct iommu_platform_data {
 	const char *name;
-	const char *clk_name;
 	const char *reset_name;
 	int nr_tlb_entries;
 	u32 da_start;
diff --git a/arch/arm/plat-omap/include/plat/iommu2.h b/arch/arm/plat-omap/include/plat/iommu2.h
index d4116b5..1579694 100644
--- a/arch/arm/plat-omap/include/plat/iommu2.h
+++ b/arch/arm/plat-omap/include/plat/iommu2.h
@@ -19,8 +19,6 @@
  * MMU Register offsets
  */
 #define MMU_REVISION		0x00
-#define MMU_SYSCONFIG		0x10
-#define MMU_SYSSTATUS		0x14
 #define MMU_IRQSTATUS		0x18
 #define MMU_IRQENABLE		0x1c
 #define MMU_WALKING_ST		0x40
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index af8fe53..20ae946 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -16,11 +16,11 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
-#include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/iommu.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/pm_runtime.h>
 
 #include <asm/cacheflush.h>
 
@@ -142,11 +142,10 @@ static int iommu_enable(struct omap_iommu *obj)
 		}
 	}
 
-	clk_enable(obj->clk);
+	pm_runtime_get_sync(obj->dev);
 
 	err = arch_iommu->enable(obj);
 
-	clk_disable(obj->clk);
 	return err;
 }
 
@@ -158,11 +157,9 @@ static void iommu_disable(struct omap_iommu *obj)
 	if (!obj || !pdata)
 		return;
 
-	clk_enable(obj->clk);
-
 	arch_iommu->disable(obj);
 
-	clk_disable(obj->clk);
+	pm_runtime_put_sync(obj->dev);
 
 	if (pdata->assert_reset)
 		pdata->assert_reset(pdev, pdata->reset_name);
@@ -288,7 +285,7 @@ static int load_iotlb_entry(struct omap_iommu *obj, struct iotlb_entry *e)
 	if (!obj || !obj->nr_tlb_entries || !e)
 		return -EINVAL;
 
-	clk_enable(obj->clk);
+	pm_runtime_get_sync(obj->dev);
 
 	iotlb_lock_get(obj, &l);
 	if (l.base == obj->nr_tlb_entries) {
@@ -318,7 +315,7 @@ static int load_iotlb_entry(struct omap_iommu *obj, struct iotlb_entry *e)
 
 	cr = iotlb_alloc_cr(obj, e);
 	if (IS_ERR(cr)) {
-		clk_disable(obj->clk);
+		pm_runtime_put_sync(obj->dev);
 		return PTR_ERR(cr);
 	}
 
@@ -332,7 +329,7 @@ static int load_iotlb_entry(struct omap_iommu *obj, struct iotlb_entry *e)
 		l.vict = l.base;
 	iotlb_lock_set(obj, &l);
 out:
-	clk_disable(obj->clk);
+	pm_runtime_put_sync(obj->dev);
 	return err;
 }
 
@@ -362,7 +359,7 @@ static void flush_iotlb_page(struct omap_iommu *obj, u32 da)
 	int i;
 	struct cr_regs cr;
 
-	clk_enable(obj->clk);
+	pm_runtime_get_sync(obj->dev);
 
 	for_each_iotlb_cr(obj, obj->nr_tlb_entries, i, cr) {
 		u32 start;
@@ -381,7 +378,7 @@ static void flush_iotlb_page(struct omap_iommu *obj, u32 da)
 			iommu_write_reg(obj, 1, MMU_FLUSH_ENTRY);
 		}
 	}
-	clk_disable(obj->clk);
+	pm_runtime_put_sync(obj->dev);
 
 	if (i == obj->nr_tlb_entries)
 		dev_dbg(obj->dev, "%s: no page for %08x\n", __func__, da);
@@ -395,7 +392,7 @@ static void flush_iotlb_all(struct omap_iommu *obj)
 {
 	struct iotlb_lock l;
 
-	clk_enable(obj->clk);
+	pm_runtime_get_sync(obj->dev);
 
 	l.base = 0;
 	l.vict = 0;
@@ -403,7 +400,7 @@ static void flush_iotlb_all(struct omap_iommu *obj)
 
 	iommu_write_reg(obj, 1, MMU_GFLUSH);
 
-	clk_disable(obj->clk);
+	pm_runtime_put_sync(obj->dev);
 }
 
 #if defined(CONFIG_OMAP_IOMMU_DEBUG) || defined(CONFIG_OMAP_IOMMU_DEBUG_MODULE)
@@ -413,11 +410,11 @@ ssize_t omap_iommu_dump_ctx(struct omap_iommu *obj, char *buf, ssize_t bytes)
 	if (!obj || !buf)
 		return -EINVAL;
 
-	clk_enable(obj->clk);
+	pm_runtime_get_sync(obj->dev);
 
 	bytes = arch_iommu->dump_ctx(obj, buf, bytes);
 
-	clk_disable(obj->clk);
+	pm_runtime_put_sync(obj->dev);
 
 	return bytes;
 }
@@ -431,7 +428,7 @@ __dump_tlb_entries(struct omap_iommu *obj, struct cr_regs *crs, int num)
 	struct cr_regs tmp;
 	struct cr_regs *p = crs;
 
-	clk_enable(obj->clk);
+	pm_runtime_get_sync(obj->dev);
 	iotlb_lock_get(obj, &saved);
 
 	for_each_iotlb_cr(obj, num, i, tmp) {
@@ -441,7 +438,7 @@ __dump_tlb_entries(struct omap_iommu *obj, struct cr_regs *crs, int num)
 	}
 
 	iotlb_lock_set(obj, &saved);
-	clk_disable(obj->clk);
+	pm_runtime_put_sync(obj->dev);
 
 	return  p - crs;
 }
@@ -798,9 +795,7 @@ static irqreturn_t iommu_fault_handler(int irq, void *data)
 	if (!obj->refcount)
 		return IRQ_NONE;
 
-	clk_enable(obj->clk);
 	errs = iommu_report_fault(obj, &da);
-	clk_disable(obj->clk);
 	if (errs == 0)
 		return IRQ_HANDLED;
 
@@ -926,10 +921,6 @@ static int __devinit omap_iommu_probe(struct platform_device *pdev)
 	if (!obj)
 		return -ENOMEM;
 
-	obj->clk = clk_get(&pdev->dev, pdata->clk_name);
-	if (IS_ERR(obj->clk))
-		goto err_clk;
-
 	obj->nr_tlb_entries = pdata->nr_tlb_entries;
 	obj->name = pdata->name;
 	obj->dev = &pdev->dev;
@@ -972,6 +963,9 @@ static int __devinit omap_iommu_probe(struct platform_device *pdev)
 		goto err_irq;
 	platform_set_drvdata(pdev, obj);
 
+	pm_runtime_irq_safe(obj->dev);
+	pm_runtime_enable(obj->dev);
+
 	dev_info(&pdev->dev, "%s registered\n", obj->name);
 	return 0;
 
@@ -980,8 +974,6 @@ err_irq:
 err_ioremap:
 	release_mem_region(res->start, resource_size(res));
 err_mem:
-	clk_put(obj->clk);
-err_clk:
 	kfree(obj);
 	return err;
 }
@@ -1002,7 +994,8 @@ static int __devexit omap_iommu_remove(struct platform_device *pdev)
 	release_mem_region(res->start, resource_size(res));
 	iounmap(obj->regbase);
 
-	clk_put(obj->clk);
+	pm_runtime_disable(obj->dev);
+
 	dev_info(&pdev->dev, "%s removed\n", obj->name);
 	kfree(obj);
 	return 0;
-- 
1.7.9.5

