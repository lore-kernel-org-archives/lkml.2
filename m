Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab2KNCfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:35:09 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49037 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573Ab2KNCfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:35:04 -0500
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Joerg Roedel <joro@8bytes.org>
Cc: Russell King <linux@arm.linux.org.uk>, Ohad Ben-Cohen <ohad@wizery.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>, Ido Yariv <ido@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH v4 1/2] ARM: OMAP3/4: iommu: migrate to hwmod framework
Date: Tue, 13 Nov 2012 20:34:48 -0600
Message-Id: <1352860489-19960-2-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352860489-19960-1-git-send-email-omar.luna@linaro.org>
References: <1352860489-19960-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use hwmod data and device attributes to build and register an
omap device for iommu driver.

 - Update the naming convention in isp module.
 - Remove unneeded check for number of resources, as this is now
   handled by omap_device and prevents driver from loading.
 - Now unused, remove platform device and resource data, handling
   of sysconfig register for softreset purposes, use default
   latency structure.
 - Use hwmod API for reset handling.

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 arch/arm/mach-omap2/devices.c            |    2 +-
 arch/arm/mach-omap2/omap-iommu.c         |  168 +++++++-----------------------
 drivers/iommu/omap-iommu.c               |   23 +++-
 drivers/iommu/omap-iommu2.c              |   19 ----
 include/linux/platform_data/iommu-omap.h |    8 ++-
 5 files changed, 64 insertions(+), 156 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 1002ff8..28d73c0 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -213,7 +213,7 @@ static struct platform_device omap3isp_device = {
 };
 
 static struct omap_iommu_arch_data omap3_isp_iommu = {
-	.name = "isp",
+	.name = "mmu_isp",
 };
 
 int omap3_init_camera(struct isp_platform_data *pdata)
diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
index a6a4ff8..02726a6 100644
--- a/arch/arm/mach-omap2/omap-iommu.c
+++ b/arch/arm/mach-omap2/omap-iommu.c
@@ -12,153 +12,61 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/slab.h>
 
 #include <linux/platform_data/iommu-omap.h>
+#include <plat/omap_hwmod.h>
+#include <plat/omap_device.h>
 
-#include "soc.h"
-#include "common.h"
-
-struct iommu_device {
-	resource_size_t base;
-	int irq;
-	struct iommu_platform_data pdata;
-	struct resource res[2];
-};
-static struct iommu_device *devices;
-static int num_iommu_devices;
-
-#ifdef CONFIG_ARCH_OMAP3
-static struct iommu_device omap3_devices[] = {
-	{
-		.base = 0x480bd400,
-		.irq = 24 + OMAP_INTC_START,
-		.pdata = {
-			.name = "isp",
-			.nr_tlb_entries = 8,
-			.clk_name = "cam_ick",
-			.da_start = 0x0,
-			.da_end = 0xFFFFF000,
-		},
-	},
-#if defined(CONFIG_OMAP_IOMMU_IVA2)
-	{
-		.base = 0x5d000000,
-		.irq = 28 + OMAP_INTC_START,
-		.pdata = {
-			.name = "iva2",
-			.nr_tlb_entries = 32,
-			.clk_name = "iva2_ck",
-			.da_start = 0x11000000,
-			.da_end = 0xFFFFF000,
-		},
-	},
-#endif
-};
-#define NR_OMAP3_IOMMU_DEVICES ARRAY_SIZE(omap3_devices)
-static struct platform_device *omap3_iommu_pdev[NR_OMAP3_IOMMU_DEVICES];
-#else
-#define omap3_devices		NULL
-#define NR_OMAP3_IOMMU_DEVICES	0
-#define omap3_iommu_pdev	NULL
-#endif
-
-#ifdef CONFIG_ARCH_OMAP4
-static struct iommu_device omap4_devices[] = {
-	{
-		.base = OMAP4_MMU1_BASE,
-		.irq = 100 + OMAP44XX_IRQ_GIC_START,
-		.pdata = {
-			.name = "ducati",
-			.nr_tlb_entries = 32,
-			.clk_name = "ipu_fck",
-			.da_start = 0x0,
-			.da_end = 0xFFFFF000,
-		},
-	},
-	{
-		.base = OMAP4_MMU2_BASE,
-		.irq = 28 + OMAP44XX_IRQ_GIC_START,
-		.pdata = {
-			.name = "tesla",
-			.nr_tlb_entries = 32,
-			.clk_name = "dsp_fck",
-			.da_start = 0x0,
-			.da_end = 0xFFFFF000,
-		},
-	},
-};
-#define NR_OMAP4_IOMMU_DEVICES ARRAY_SIZE(omap4_devices)
-static struct platform_device *omap4_iommu_pdev[NR_OMAP4_IOMMU_DEVICES];
-#else
-#define omap4_devices		NULL
-#define NR_OMAP4_IOMMU_DEVICES	0
-#define omap4_iommu_pdev	NULL
-#endif
-
-static struct platform_device **omap_iommu_pdev;
-
-static int __init omap_iommu_init(void)
+static int __init omap_iommu_dev_init(struct omap_hwmod *oh, void *unused)
 {
-	int i, err;
-	struct resource res[] = {
-		{ .flags = IORESOURCE_MEM },
-		{ .flags = IORESOURCE_IRQ },
-	};
+	struct platform_device *pdev;
+	struct iommu_platform_data *pdata;
+	struct omap_mmu_dev_attr *a = (struct omap_mmu_dev_attr *)oh->dev_attr;
+	static int i;
+
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	pdata->name = oh->name;
+	pdata->clk_name = oh->main_clk;
+	pdata->nr_tlb_entries = a->nr_tlb_entries;
+	pdata->da_start = a->da_start;
+	pdata->da_end = a->da_end;
+
+	if (oh->rst_lines_cnt == 1) {
+		pdata->reset_name = oh->rst_lines->name;
+		pdata->assert_reset = omap_device_assert_hardreset;
+		pdata->deassert_reset = omap_device_deassert_hardreset;
+	}
 
-	if (cpu_is_omap34xx()) {
-		devices = omap3_devices;
-		omap_iommu_pdev = omap3_iommu_pdev;
-		num_iommu_devices = NR_OMAP3_IOMMU_DEVICES;
-	} else if (cpu_is_omap44xx()) {
-		devices = omap4_devices;
-		omap_iommu_pdev = omap4_iommu_pdev;
-		num_iommu_devices = NR_OMAP4_IOMMU_DEVICES;
-	} else
-		return -ENODEV;
+	pdev = omap_device_build("omap-iommu", i, oh, pdata, sizeof(*pdata),
+				NULL, 0, 0);
 
-	for (i = 0; i < num_iommu_devices; i++) {
-		struct platform_device *pdev;
-		const struct iommu_device *d = &devices[i];
+	kfree(pdata);
 
-		pdev = platform_device_alloc("omap-iommu", i);
-		if (!pdev) {
-			err = -ENOMEM;
-			goto err_out;
-		}
+	if (IS_ERR(pdev)) {
+		pr_err("%s: device build err: %ld\n", __func__, PTR_ERR(pdev));
+		return PTR_ERR(pdev);
+	}
 
-		res[0].start = d->base;
-		res[0].end = d->base + MMU_REG_SIZE - 1;
-		res[1].start = res[1].end = d->irq;
+	i++;
 
-		err = platform_device_add_resources(pdev, res,
-						    ARRAY_SIZE(res));
-		if (err)
-			goto err_out;
-		err = platform_device_add_data(pdev, &d->pdata,
-					       sizeof(d->pdata));
-		if (err)
-			goto err_out;
-		err = platform_device_add(pdev);
-		if (err)
-			goto err_out;
-		omap_iommu_pdev[i] = pdev;
-	}
 	return 0;
+}
 
-err_out:
-	while (i--)
-		platform_device_put(omap_iommu_pdev[i]);
-	return err;
+static int __init omap_iommu_init(void)
+{
+	return omap_hwmod_for_each_by_class("mmu", omap_iommu_dev_init, NULL);
 }
 /* must be ready before omap3isp is probed */
 subsys_initcall(omap_iommu_init);
 
 static void __exit omap_iommu_exit(void)
 {
-	int i;
-
-	for (i = 0; i < num_iommu_devices; i++)
-		platform_device_unregister(omap_iommu_pdev[i]);
+	/* Do nothing */
 }
 module_exit(omap_iommu_exit);
 
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index f0aba5b..0a6a901 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -143,13 +143,23 @@ EXPORT_SYMBOL_GPL(omap_iommu_arch_version);
 static int iommu_enable(struct omap_iommu *obj)
 {
 	int err;
+	struct platform_device *pdev = to_platform_device(obj->dev);
+	struct iommu_platform_data *pdata = pdev->dev.platform_data;
 
-	if (!obj)
+	if (!obj || !pdata)
 		return -EINVAL;
 
 	if (!arch_iommu)
 		return -ENODEV;
 
+	if (pdata->deassert_reset) {
+		err = pdata->deassert_reset(pdev, pdata->reset_name);
+		if (err) {
+			dev_err(obj->dev, "deassert_reset failed: %d\n", err);
+			return err;
+		}
+	}
+
 	clk_enable(obj->clk);
 
 	err = arch_iommu->enable(obj);
@@ -160,7 +170,10 @@ static int iommu_enable(struct omap_iommu *obj)
 
 static void iommu_disable(struct omap_iommu *obj)
 {
-	if (!obj)
+	struct platform_device *pdev = to_platform_device(obj->dev);
+	struct iommu_platform_data *pdata = pdev->dev.platform_data;
+
+	if (!obj || !pdata)
 		return;
 
 	clk_enable(obj->clk);
@@ -168,6 +181,9 @@ static void iommu_disable(struct omap_iommu *obj)
 	arch_iommu->disable(obj);
 
 	clk_disable(obj->clk);
+
+	if (pdata->assert_reset)
+		pdata->assert_reset(pdev, pdata->reset_name);
 }
 
 /*
@@ -924,9 +940,6 @@ static int __devinit omap_iommu_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct iommu_platform_data *pdata = pdev->dev.platform_data;
 
-	if (pdev->num_resources != 2)
-		return -EINVAL;
-
 	obj = kzalloc(sizeof(*obj) + MMU_REG_SIZE, GFP_KERNEL);
 	if (!obj)
 		return -ENOMEM;
diff --git a/drivers/iommu/omap-iommu2.c b/drivers/iommu/omap-iommu2.c
index c020202..4a3a1c7 100644
--- a/drivers/iommu/omap-iommu2.c
+++ b/drivers/iommu/omap-iommu2.c
@@ -35,12 +35,8 @@
 #define MMU_SYS_IDLE_SMART	(2 << MMU_SYS_IDLE_SHIFT)
 #define MMU_SYS_IDLE_MASK	(3 << MMU_SYS_IDLE_SHIFT)
 
-#define MMU_SYS_SOFTRESET	(1 << 1)
 #define MMU_SYS_AUTOIDLE	1
 
-/* SYSSTATUS */
-#define MMU_SYS_RESETDONE	1
-
 /* IRQSTATUS & IRQENABLE */
 #define MMU_IRQ_MULTIHITFAULT	(1 << 4)
 #define MMU_IRQ_TABLEWALKFAULT	(1 << 3)
@@ -97,7 +93,6 @@ static void __iommu_set_twl(struct omap_iommu *obj, bool on)
 static int omap2_iommu_enable(struct omap_iommu *obj)
 {
 	u32 l, pa;
-	unsigned long timeout;
 
 	if (!obj->iopgd || !IS_ALIGNED((u32)obj->iopgd,  SZ_16K))
 		return -EINVAL;
@@ -106,20 +101,6 @@ static int omap2_iommu_enable(struct omap_iommu *obj)
 	if (!IS_ALIGNED(pa, SZ_16K))
 		return -EINVAL;
 
-	iommu_write_reg(obj, MMU_SYS_SOFTRESET, MMU_SYSCONFIG);
-
-	timeout = jiffies + msecs_to_jiffies(20);
-	do {
-		l = iommu_read_reg(obj, MMU_SYSSTATUS);
-		if (l & MMU_SYS_RESETDONE)
-			break;
-	} while (!time_after(jiffies, timeout));
-
-	if (!(l & MMU_SYS_RESETDONE)) {
-		dev_err(obj->dev, "can't take mmu out of reset\n");
-		return -ENODEV;
-	}
-
 	l = iommu_read_reg(obj, MMU_REVISION);
 	dev_info(obj->dev, "%s: version %d.%d\n", obj->name,
 		 (l >> 4) & 0xf, l & 0xf);
diff --git a/include/linux/platform_data/iommu-omap.h b/include/linux/platform_data/iommu-omap.h
index c677b9f..ef2060d 100644
--- a/include/linux/platform_data/iommu-omap.h
+++ b/include/linux/platform_data/iommu-omap.h
@@ -10,6 +10,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/platform_device.h>
+
 #define MMU_REG_SIZE		256
 
 /**
@@ -43,7 +45,11 @@ struct omap_mmu_dev_attr {
 struct iommu_platform_data {
 	const char *name;
 	const char *clk_name;
-	const int nr_tlb_entries;
+	const char *reset_name;
+	int nr_tlb_entries;
 	u32 da_start;
 	u32 da_end;
+
+	int (*assert_reset)(struct platform_device *pdev, const char *name);
+	int (*deassert_reset)(struct platform_device *pdev, const char *name);
 };
-- 
1.7.4.1

