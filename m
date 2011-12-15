Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab1LONL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 08:11:56 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18242 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1LONLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 08:11:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 15 Dec 2011 05:11:54 -0800
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] [RFC] ARM: IOMMU: Tegra20: iommu_ops for GART driver
Date: Thu, 15 Dec 2011 15:11:29 +0200
Message-Id: <1323954690-7000-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323954690-7000-1-git-send-email-hdoyu@nvidia.com>
References: <1323954690-7000-1-git-send-email-hdoyu@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra 20 IOMMU H/W, GART (Graphics Address Relocation Table). This
patch implements struct iommu_ops for GART for the upper IOMMU API.

This H/W module supports only single virtual address space(domain),
and manages a single level 1-to-1 mapping H/W translation page table.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/iommu/Kconfig      |   11 +
 drivers/iommu/Makefile     |    1 +
 drivers/iommu/tegra-gart.c |  451 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 463 insertions(+), 0 deletions(-)
 create mode 100644 drivers/iommu/tegra-gart.c

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 5414253b..348ff75 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -131,4 +131,15 @@ config OMAP_IOMMU_DEBUG
 
          Say N unless you know you need this.
 
+config TEGRA_IOMMU_GART
+	bool "Tegra GART IOMMU Support"
+	depends on ARCH_TEGRA_2x_SOC
+	default y
+	select IOMMU_API
+	help
+	  Enables support for remapping discontiguous physical memory
+	  shared with the operating system into contiguous I/O virtual
+	  space through the GART (Graphics Address Relocation Table)
+	  hardware included on Tegra SoCs.
+
 endif # IOMMU_SUPPORT
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 2f44487..fc5f42a 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_IRQ_REMAP) += intr_remapping.o
 obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
 obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
 obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
+obj-$(CONFIG_TEGRA_IOMMU_GART) += tegra-gart.o
diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
new file mode 100644
index 0000000..f476c21
--- /dev/null
+++ b/drivers/iommu/tegra-gart.c
@@ -0,0 +1,451 @@
+/*
+ * IOMMU API for GART in Tegra20
+ *
+ * Copyright (c) 2010-2011, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#define pr_fmt(fmt)	"%s(): " fmt, __func__
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/iommu.h>
+
+#include <asm/cacheflush.h>
+
+#define GART_CONFIG		0x24
+#define GART_ENTRY_ADDR		0x28
+#define GART_ENTRY_DATA		0x2c
+#define GART_ENTRY_PHYS_ADDR_VALID	(1 << 31)
+
+#define GART_PAGE_SHIFT		12
+#define GART_PAGE_SIZE		(1 << GART_PAGE_SHIFT)
+#define GART_PAGE_MASK						\
+	(~(GART_PAGE_SIZE - 1) & ~GART_ENTRY_PHYS_ADDR_VALID)
+
+struct gart_client {
+	struct device		*dev;
+	struct list_head	list;
+};
+
+struct gart_device {
+	void __iomem		*regs;
+	u32			*savedata;
+	u32			page_count; /* total remappable size */
+	dma_addr_t		iovmm_base; /* offset to apply to vmm_area */
+	spinlock_t		pte_lock; /* for pagetable */
+	struct list_head	client;
+	spinlock_t		client_lock; /* for client list */
+	struct device		*dev;
+};
+
+static struct gart_device *gart_handle; /* unique for a system */
+
+#define GART_PTE(_pfn)						\
+	(GART_ENTRY_PHYS_ADDR_VALID | ((_pfn) << PAGE_SHIFT))
+
+/*
+ * Any interaction between any block on PPSB and a block on APB or AHB
+ * must have these read-back to ensure the APB/AHB bus transaction is
+ * complete before initiating activity on the PPSB block.
+ */
+#define FLUSH_GART_REGS(gart)	(void)readl((gart)->regs + GART_CONFIG)
+
+static inline void gart_set_pte(struct gart_device *gart,
+				unsigned long offs, u32 pte)
+{
+	writel(offs, gart->regs + GART_ENTRY_ADDR);
+	writel(pte, gart->regs + GART_ENTRY_DATA);
+
+	pr_debug("%s %08lx:%08x\n",
+		 pte ? "map" : "unmap", offs, pte & GART_PAGE_MASK);
+}
+
+static inline unsigned long gart_read_pte(struct gart_device *gart,
+					  unsigned long offs)
+{
+	unsigned long pte;
+
+	writel(offs, gart->regs + GART_ENTRY_ADDR);
+	pte = readl(gart->regs + GART_ENTRY_DATA);
+
+	return pte;
+}
+
+static void do_gart_setup(struct gart_device *gart, const u32 *data)
+{
+	unsigned long iova;
+	unsigned int i;
+
+	iova = gart->iovmm_base;
+	for (i = 0; i < gart->page_count; i++) {
+		gart_set_pte(gart, iova, data ? data[i] : 0);
+		iova += GART_PAGE_SIZE;
+	}
+	writel(1, gart->regs + GART_CONFIG);
+	FLUSH_GART_REGS(gart);
+}
+
+#ifdef DEBUG
+static void gart_dump_table(struct gart_device *gart)
+{
+	int i;
+	unsigned long iova;
+
+	spin_lock(&gart->pte_lock);
+	iova = gart->iovmm_base;
+	for (i = 0; i < gart->page_count; i++) {
+		unsigned long pte;
+
+		pte = gart_read_pte(gart, iova);
+
+		pr_debug("[%d] %s %08lx:%08lx\n",
+			 i, (GART_ENTRY_PHYS_ADDR_VALID & pte) ? "v" : " ",
+			 iova, pte & GART_PAGE_MASK);
+
+		iova += GART_PAGE_SIZE;
+	}
+	spin_unlock(&gart->pte_lock);
+}
+#else
+static inline void gart_dump_table(struct gart_device *gart)
+{
+}
+#endif
+
+static inline bool gart_iova_valid(struct gart_device *gart, unsigned long iova)
+{
+	if (gart->iovmm_base > iova)
+		return false;
+	if (iova >= gart->iovmm_base + gart->page_count * GART_PAGE_SIZE)
+		return false;
+	return true;
+}
+
+static int gart_iommu_domain_init(struct iommu_domain *domain)
+{
+	domain->priv = gart_handle;
+	pr_debug("gart@%p\n", gart_handle);
+	return 0;
+}
+
+static void gart_iommu_domain_destroy(struct iommu_domain *domain)
+{
+	struct gart_device *gart = domain->priv;
+
+	spin_lock(&gart->client_lock);
+	if (!list_empty(&gart->client)) {
+		struct gart_client *c;
+
+		list_for_each_entry(c, &gart->client, list)
+			pr_err("%s is still attached\n", dev_name(c->dev));
+	}
+	spin_unlock(&gart->client_lock);
+	domain->priv = NULL;
+	pr_debug("gart@%p\n", gart);
+}
+
+static int gart_iommu_attach_dev(struct iommu_domain *domain,
+				 struct device *dev)
+{
+	struct gart_device *gart = domain->priv;
+	struct gart_client *client, *c;
+	int err = 0;
+
+	client = kmalloc(sizeof(*c), GFP_KERNEL);
+	if (!client)
+		return -ENOMEM;
+	client->dev = dev;
+
+	spin_lock(&gart->client_lock);
+	list_for_each_entry(c, &gart->client, list) {
+		if (c->dev == dev) {
+			pr_err("%s is already attached\n", dev_name(dev));
+			err = -EINVAL;
+			goto fail;
+		}
+	}
+	list_add(&client->list, &gart->client);
+	pr_debug("Attached %s\n", dev_name(dev));
+fail:
+	spin_unlock(&gart->client_lock);
+	return err;
+}
+
+static void gart_iommu_detach_dev(struct iommu_domain *domain,
+				  struct device *dev)
+{
+	struct gart_device *gart = domain->priv;
+	struct gart_client *c;
+
+	spin_lock(&gart->client_lock);
+
+	list_for_each_entry(c, &gart->client, list) {
+		if (c->dev == dev) {
+			list_del(&c->list);
+			pr_debug("Detached %s\n", dev_name(dev));
+			goto out;
+		}
+	}
+	pr_err("Couldn't find %s\n", dev_name(dev));
+out:
+	spin_unlock(&gart->client_lock);
+}
+
+static int gart_iommu_map(struct iommu_domain *domain, unsigned long iova,
+			  phys_addr_t pa, int gfp_order, int prot)
+{
+	struct gart_device *gart = domain->priv;
+	unsigned long count = (PAGE_SIZE << gfp_order) >> GART_PAGE_SHIFT;
+	int i;
+
+	if (!IS_ALIGNED(iova, PAGE_SIZE))
+		return -EINVAL;
+
+	if (count > gart->page_count)
+		return -EINVAL;
+
+	if (!gart_iova_valid(gart, iova))
+		return -EINVAL;
+
+	spin_lock(&gart->pte_lock);
+
+	for (i = 0; i < count; i++) {
+		unsigned long pfn;
+
+		pfn = __phys_to_pfn(pa);
+		if (!pfn_valid(pfn)) {
+			pr_err("Invalid page: %08x\n", pa);
+			goto fail;
+		}
+
+		gart_set_pte(gart, iova, GART_PTE(pfn));
+		iova += GART_PAGE_SIZE;
+	}
+	FLUSH_GART_REGS(gart);
+	spin_unlock(&gart->pte_lock);
+	return 0;
+fail:
+	while (--i >= 0) {
+		iova -= GART_PAGE_SIZE;
+		gart_set_pte(gart, iova, 0);
+	}
+	FLUSH_GART_REGS(gart);
+	spin_unlock(&gart->pte_lock);
+	return -EINVAL;
+}
+
+static int gart_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+			    int gfp_order)
+{
+	int i;
+	struct gart_device *gart = domain->priv;
+	unsigned long count = (PAGE_SIZE << gfp_order) >> GART_PAGE_SHIFT;
+
+	if (!IS_ALIGNED(iova, PAGE_SIZE))
+		return -EINVAL;
+
+	if (count > gart->page_count)
+		return -EINVAL;
+
+	if (!gart_iova_valid(gart, iova))
+		return -EINVAL;
+
+	spin_lock(&gart->pte_lock);
+	for (i = 0; i < count; i++) {
+		gart_set_pte(gart, iova, 0);
+		iova += GART_PAGE_SIZE;
+	}
+	FLUSH_GART_REGS(gart);
+	spin_unlock(&gart->pte_lock);
+	return 0;
+}
+
+static phys_addr_t gart_iommu_iova_to_phys(struct iommu_domain *domain,
+					   unsigned long iova)
+{
+	struct gart_device *gart = domain->priv;
+	unsigned long pte;
+	phys_addr_t pa;
+
+	if (!IS_ALIGNED(iova, PAGE_SIZE))
+		return -EINVAL;
+
+	if (!gart_iova_valid(gart, iova))
+		return -EINVAL;
+
+	spin_lock(&gart->pte_lock);
+	pte = gart_read_pte(gart, iova);
+	spin_unlock(&gart->pte_lock);
+
+	pa = (pte & GART_PAGE_MASK);
+	if (!pfn_valid(__phys_to_pfn(pa))) {
+		pr_err("No entory for %08lx:%08x\n", iova, pa);
+		gart_dump_table(gart);
+		return -EINVAL;
+	}
+	return pa;
+}
+
+static int gart_iommu_domain_has_cap(struct iommu_domain *domain,
+				     unsigned long cap)
+{
+	return 0;
+}
+
+static struct iommu_ops gart_iommu_ops = {
+	.domain_init	= gart_iommu_domain_init,
+	.domain_destroy	= gart_iommu_domain_destroy,
+	.attach_dev	= gart_iommu_attach_dev,
+	.detach_dev	= gart_iommu_detach_dev,
+	.map		= gart_iommu_map,
+	.unmap		= gart_iommu_unmap,
+	.iova_to_phys	= gart_iommu_iova_to_phys,
+	.domain_has_cap	= gart_iommu_domain_has_cap,
+};
+
+static int gart_iommu_suspend(struct device *dev)
+{
+	struct gart_device *gart = dev_get_drvdata(dev);
+	int i;
+	unsigned long iova;
+
+	spin_lock(&gart->pte_lock);
+	iova = gart->iovmm_base;
+	for (i = 0; i < gart->page_count; i++) {
+		gart->savedata[i] = gart_read_pte(gart, iova);
+		iova += GART_PAGE_SIZE;
+	}
+	spin_unlock(&gart->pte_lock);
+	return 0;
+}
+
+static int gart_iommu_resume(struct device *dev)
+{
+	struct gart_device *gart = dev_get_drvdata(dev);
+
+	spin_lock(&gart->pte_lock);
+	do_gart_setup(gart, gart->savedata);
+	spin_unlock(&gart->pte_lock);
+	return 0;
+}
+
+static int gart_iommu_probe(struct platform_device *pdev)
+{
+	struct gart_device *gart;
+	struct resource *res, *res_remap;
+	void __iomem *gart_regs;
+	int err;
+
+	BUILD_BUG_ON(PAGE_SHIFT != GART_PAGE_SHIFT);
+
+	/* the GART memory aperture is required */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mc");
+	res_remap = platform_get_resource_byname(pdev, IORESOURCE_MEM, "iovm");
+	if (!res || !res_remap) {
+		pr_err("GART memory aperture expected\n");
+		return -ENXIO;
+	}
+
+	gart = kzalloc(sizeof(*gart), GFP_KERNEL);
+	if (!gart) {
+		pr_err("failed to allocate gart_device\n");
+		return -ENOMEM;
+	}
+
+	gart_regs = ioremap(res->start, resource_size(res));
+	if (!gart_regs) {
+		pr_err("failed to remap GART registers\n");
+		err = -ENXIO;
+		goto fail;
+	}
+
+	gart->dev = &pdev->dev;
+	spin_lock_init(&gart->pte_lock);
+	spin_lock_init(&gart->client_lock);
+	INIT_LIST_HEAD(&gart->client);
+	gart->regs = gart_regs;
+	gart->iovmm_base = (dma_addr_t)res_remap->start;
+	gart->page_count = (resource_size(res_remap) >> GART_PAGE_SHIFT);
+
+	gart->savedata = vmalloc(sizeof(u32) * gart->page_count);
+	if (!gart->savedata) {
+		pr_err("failed to allocate context save area\n");
+		err = -ENOMEM;
+		goto fail;
+	}
+
+	gart_handle = gart;
+	platform_set_drvdata(pdev, gart);
+	do_gart_setup(gart, NULL);
+	return 0;
+fail:
+	if (gart_regs)
+		iounmap(gart_regs);
+	if (gart && gart->savedata)
+		vfree(gart->savedata);
+	kfree(gart);
+	return err;
+}
+
+static int gart_iommu_remove(struct platform_device *pdev)
+{
+	struct gart_device *gart = platform_get_drvdata(pdev);
+
+	writel(0, gart->regs + GART_CONFIG);
+	platform_set_drvdata(pdev, NULL);
+	if (gart->savedata)
+		vfree(gart->savedata);
+	if (gart->regs)
+		iounmap(gart->regs);
+	kfree(gart);
+	gart_handle = NULL;
+	return 0;
+}
+
+const struct dev_pm_ops gart_iommu_pm_ops = {
+	.suspend	= gart_iommu_suspend,
+	.resume		= gart_iommu_resume,
+};
+
+static struct platform_driver gart_iommu_driver = {
+	.probe		= gart_iommu_probe,
+	.remove		= gart_iommu_remove,
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "gart-iommu",
+		.pm	= &gart_iommu_pm_ops,
+	},
+};
+
+static int __devinit gart_iommu_init(void)
+{
+	bus_set_iommu(&platform_bus_type, &gart_iommu_ops);
+	return platform_driver_register(&gart_iommu_driver);
+}
+
+static void __exit gart_iommu_exit(void)
+{
+	platform_driver_unregister(&gart_iommu_driver);
+}
+
+subsys_initcall(gart_iommu_init);
+module_exit(gart_iommu_exit);
-- 
1.7.5.4

