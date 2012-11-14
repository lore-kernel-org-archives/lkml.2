Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab2KNCff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:35:35 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49037 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab2KNCfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:35:07 -0500
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Joerg Roedel <joro@8bytes.org>
Cc: Russell King <linux@arm.linux.org.uk>, Ohad Ben-Cohen <ohad@wizery.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>, Ido Yariv <ido@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH v4 2/2] ARM: OMAP3/4: iommu: adapt to runtime pm
Date: Tue, 13 Nov 2012 20:34:49 -0600
Message-Id: <1352860489-19960-3-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352860489-19960-1-git-send-email-omar.luna@linaro.org>
References: <1352860489-19960-1-git-send-email-omar.luna@linaro.org>
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
 arch/arm/mach-omap2/omap-iommu.c         |    1 -
 drivers/iommu/omap-iommu.c               |   45 ++++++++++++-----------------
 drivers/iommu/omap-iommu.h               |    3 --
 drivers/iommu/omap-iommu2.c              |   17 -----------
 include/linux/platform_data/iommu-omap.h |    1 -
 5 files changed, 19 insertions(+), 48 deletions(-)

diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
index 02726a6..7642fc4 100644
--- a/arch/arm/mach-omap2/omap-iommu.c
+++ b/arch/arm/mach-omap2/omap-iommu.c
@@ -31,7 +31,6 @@ static int __init omap_iommu_dev_init(struct omap_hwmod *oh, void *unused)
 		return -ENOMEM;
 
 	pdata->name = oh->name;
-	pdata->clk_name = oh->main_clk;
 	pdata->nr_tlb_entries = a->nr_tlb_entries;
 	pdata->da_start = a->da_start;
 	pdata->da_end = a->da_end;
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 0a6a901..b42b3d1 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -16,13 +16,13 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
-#include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/iommu.h>
 #include <linux/omap-iommu.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/io.h>
+#include <linux/pm_runtime.h>
 
 #include <asm/cacheflush.h>
 
@@ -160,11 +160,10 @@ static int iommu_enable(struct omap_iommu *obj)
 		}
 	}
 
-	clk_enable(obj->clk);
+	pm_runtime_get_sync(obj->dev);
 
 	err = arch_iommu->enable(obj);
 
-	clk_disable(obj->clk);
 	return err;
 }
 
@@ -176,11 +175,9 @@ static void iommu_disable(struct omap_iommu *obj)
 	if (!obj || !pdata)
 		return;
 
-	clk_enable(obj->clk);
-
 	arch_iommu->disable(obj);
 
-	clk_disable(obj->clk);
+	pm_runtime_put_sync(obj->dev);
 
 	if (pdata->assert_reset)
 		pdata->assert_reset(pdev, pdata->reset_name);
@@ -306,7 +303,7 @@ static int load_iotlb_entry(struct omap_iommu *obj, struct iotlb_entry *e)
 	if (!obj || !obj->nr_tlb_entries || !e)
 		return -EINVAL;
 
-	clk_enable(obj->clk);
+	pm_runtime_get_sync(obj->dev);
 
 	iotlb_lock_get(obj, &l);
 	if (l.base == obj->nr_tlb_entries) {
@@ -336,7 +333,7 @@ static int load_iotlb_entry(struct omap_iommu *obj, struct iotlb_entry *e)
 
 	cr = iotlb_alloc_cr(obj, e);
 	if (IS_ERR(cr)) {
-		clk_disable(obj->clk);
+		pm_runtime_put_sync(obj->dev);
 		return PTR_ERR(cr);
 	}
 
@@ -350,7 +347,7 @@ static int load_iotlb_entry(struct omap_iommu *obj, struct iotlb_entry *e)
 		l.vict = l.base;
 	iotlb_lock_set(obj, &l);
 out:
-	clk_disable(obj->clk);
+	pm_runtime_put_sync(obj->dev);
 	return err;
 }
 
@@ -380,7 +377,7 @@ static void flush_iotlb_page(struct omap_iommu *obj, u32 da)
 	int i;
 	struct cr_regs cr;
 
-	clk_enable(obj->clk);
+	pm_runtime_get_sync(obj->dev);
 
 	for_each_iotlb_cr(obj, obj->nr_tlb_entries, i, cr) {
 		u32 start;
@@ -399,7 +396,7 @@ static void flush_iotlb_page(struct omap_iommu *obj, u32 da)
 			iommu_write_reg(obj, 1, MMU_FLUSH_ENTRY);
 		}
 	}
-	clk_disable(obj->clk);
+	pm_runtime_put_sync(obj->dev);
 
 	if (i == obj->nr_tlb_entries)
 		dev_dbg(obj->dev, "%s: no page for %08x\n", __func__, da);
@@ -413,7 +410,7 @@ static void flush_iotlb_all(struct omap_iommu *obj)
 {
 	struct iotlb_lock l;
 
-	clk_enable(obj->clk);
+	pm_runtime_get_sync(obj->dev);
 
 	l.base = 0;
 	l.vict = 0;
@@ -421,7 +418,7 @@ static void flush_iotlb_all(struct omap_iommu *obj)
 
 	iommu_write_reg(obj, 1, MMU_GFLUSH);
 
-	clk_disable(obj->clk);
+	pm_runtime_put_sync(obj->dev);
 }
 
 #if defined(CONFIG_OMAP_IOMMU_DEBUG) || defined(CONFIG_OMAP_IOMMU_DEBUG_MODULE)
@@ -431,11 +428,11 @@ ssize_t omap_iommu_dump_ctx(struct omap_iommu *obj, char *buf, ssize_t bytes)
 	if (!obj || !buf)
 		return -EINVAL;
 
-	clk_enable(obj->clk);
+	pm_runtime_get_sync(obj->dev);
 
 	bytes = arch_iommu->dump_ctx(obj, buf, bytes);
 
-	clk_disable(obj->clk);
+	pm_runtime_put_sync(obj->dev);
 
 	return bytes;
 }
@@ -449,7 +446,7 @@ __dump_tlb_entries(struct omap_iommu *obj, struct cr_regs *crs, int num)
 	struct cr_regs tmp;
 	struct cr_regs *p = crs;
 
-	clk_enable(obj->clk);
+	pm_runtime_get_sync(obj->dev);
 	iotlb_lock_get(obj, &saved);
 
 	for_each_iotlb_cr(obj, num, i, tmp) {
@@ -459,7 +456,7 @@ __dump_tlb_entries(struct omap_iommu *obj, struct cr_regs *crs, int num)
 	}
 
 	iotlb_lock_set(obj, &saved);
-	clk_disable(obj->clk);
+	pm_runtime_put_sync(obj->dev);
 
 	return  p - crs;
 }
@@ -816,9 +813,7 @@ static irqreturn_t iommu_fault_handler(int irq, void *data)
 	if (!obj->refcount)
 		return IRQ_NONE;
 
-	clk_enable(obj->clk);
 	errs = iommu_report_fault(obj, &da);
-	clk_disable(obj->clk);
 	if (errs == 0)
 		return IRQ_HANDLED;
 
@@ -944,10 +939,6 @@ static int __devinit omap_iommu_probe(struct platform_device *pdev)
 	if (!obj)
 		return -ENOMEM;
 
-	obj->clk = clk_get(&pdev->dev, pdata->clk_name);
-	if (IS_ERR(obj->clk))
-		goto err_clk;
-
 	obj->nr_tlb_entries = pdata->nr_tlb_entries;
 	obj->name = pdata->name;
 	obj->dev = &pdev->dev;
@@ -990,6 +981,9 @@ static int __devinit omap_iommu_probe(struct platform_device *pdev)
 		goto err_irq;
 	platform_set_drvdata(pdev, obj);
 
+	pm_runtime_irq_safe(obj->dev);
+	pm_runtime_enable(obj->dev);
+
 	dev_info(&pdev->dev, "%s registered\n", obj->name);
 	return 0;
 
@@ -998,8 +992,6 @@ err_irq:
 err_ioremap:
 	release_mem_region(res->start, resource_size(res));
 err_mem:
-	clk_put(obj->clk);
-err_clk:
 	kfree(obj);
 	return err;
 }
@@ -1020,7 +1012,8 @@ static int __devexit omap_iommu_remove(struct platform_device *pdev)
 	release_mem_region(res->start, resource_size(res));
 	iounmap(obj->regbase);
 
-	clk_put(obj->clk);
+	pm_runtime_disable(obj->dev);
+
 	dev_info(&pdev->dev, "%s removed\n", obj->name);
 	kfree(obj);
 	return 0;
diff --git a/drivers/iommu/omap-iommu.h b/drivers/iommu/omap-iommu.h
index 2b5f3c0..1200842 100644
--- a/drivers/iommu/omap-iommu.h
+++ b/drivers/iommu/omap-iommu.h
@@ -29,7 +29,6 @@ struct iotlb_entry {
 struct omap_iommu {
 	const char	*name;
 	struct module	*owner;
-	struct clk	*clk;
 	void __iomem	*regbase;
 	struct device	*dev;
 	void		*isr_priv;
@@ -116,8 +115,6 @@ static inline struct omap_iommu *dev_to_omap_iommu(struct device *dev)
  * MMU Register offsets
  */
 #define MMU_REVISION		0x00
-#define MMU_SYSCONFIG		0x10
-#define MMU_SYSSTATUS		0x14
 #define MMU_IRQSTATUS		0x18
 #define MMU_IRQENABLE		0x1c
 #define MMU_WALKING_ST		0x40
diff --git a/drivers/iommu/omap-iommu2.c b/drivers/iommu/omap-iommu2.c
index 4a3a1c7..d745094 100644
--- a/drivers/iommu/omap-iommu2.c
+++ b/drivers/iommu/omap-iommu2.c
@@ -28,15 +28,6 @@
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
@@ -105,11 +96,6 @@ static int omap2_iommu_enable(struct omap_iommu *obj)
 	dev_info(obj->dev, "%s: version %d.%d\n", obj->name,
 		 (l >> 4) & 0xf, l & 0xf);
 
-	l = iommu_read_reg(obj, MMU_SYSCONFIG);
-	l &= ~MMU_SYS_IDLE_MASK;
-	l |= (MMU_SYS_IDLE_SMART | MMU_SYS_AUTOIDLE);
-	iommu_write_reg(obj, l, MMU_SYSCONFIG);
-
 	iommu_write_reg(obj, pa, MMU_TTB);
 
 	__iommu_set_twl(obj, true);
@@ -123,7 +109,6 @@ static void omap2_iommu_disable(struct omap_iommu *obj)
 
 	l &= ~MMU_CNTL_MASK;
 	iommu_write_reg(obj, l, MMU_CNTL);
-	iommu_write_reg(obj, MMU_SYS_IDLE_FORCE, MMU_SYSCONFIG);
 
 	dev_dbg(obj->dev, "%s is shutting down\n", obj->name);
 }
@@ -252,8 +237,6 @@ omap2_iommu_dump_ctx(struct omap_iommu *obj, char *buf, ssize_t len)
 	char *p = buf;
 
 	pr_reg(REVISION);
-	pr_reg(SYSCONFIG);
-	pr_reg(SYSSTATUS);
 	pr_reg(IRQSTATUS);
 	pr_reg(IRQENABLE);
 	pr_reg(WALKING_ST);
diff --git a/include/linux/platform_data/iommu-omap.h b/include/linux/platform_data/iommu-omap.h
index ef2060d..5b429c4 100644
--- a/include/linux/platform_data/iommu-omap.h
+++ b/include/linux/platform_data/iommu-omap.h
@@ -44,7 +44,6 @@ struct omap_mmu_dev_attr {
 
 struct iommu_platform_data {
 	const char *name;
-	const char *clk_name;
 	const char *reset_name;
 	int nr_tlb_entries;
 	u32 da_start;
-- 
1.7.4.1

