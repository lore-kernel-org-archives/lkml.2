Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab2K1HSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 02:18:49 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53594 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2K1HSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 02:18:47 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH] vfio powerpc: enabled on powernv platform
Date: Wed, 28 Nov 2012 18:18:33 +1100
Message-Id: <1354087113-26733-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353991269.1809.155.camel@bling.home>
References: <1353991269.1809.155.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch initializes IOMMU groups based on the IOMMU
configuration discovered during the PCI scan on POWERNV
(POWER non virtualized) platform. The IOMMU groups are
to be used later by VFIO driver (PCI pass through).

It also implements an API for mapping/unmapping pages for
guest PCI drivers and providing DMA window properties.
This API is going to be used later by QEMU-VFIO to handle
h_put_tce hypercalls from the KVM guest.

Although this driver has been tested only on the POWERNV
platform, it should work on any platform which supports
TCE tables.

To enable VFIO on POWER, enable SPAPR_TCE_IOMMU config
option and configure VFIO as required.

Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h     |    9 +++
 arch/powerpc/kernel/iommu.c          |  147 ++++++++++++++++++++++++++++++++++
 arch/powerpc/platforms/powernv/pci.c |  135 +++++++++++++++++++++++++++++++
 drivers/iommu/Kconfig                |    8 ++
 4 files changed, 299 insertions(+)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index cbfe678..5c7087a 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -76,6 +76,9 @@ struct iommu_table {
 	struct iommu_pool large_pool;
 	struct iommu_pool pools[IOMMU_NR_POOLS];
 	unsigned long *it_map;       /* A simple allocation bitmap for now */
+#ifdef CONFIG_IOMMU_API
+	struct iommu_group *it_group;
+#endif
 };
 
 struct scatterlist;
@@ -147,5 +150,11 @@ static inline void iommu_restore(void)
 }
 #endif
 
+extern long iommu_clear_tces(struct iommu_table *tbl, unsigned long entry,
+		unsigned long pages);
+extern long iommu_put_tces(struct iommu_table *tbl, unsigned long entry,
+		uint64_t tce, enum dma_data_direction direction,
+		unsigned long pages);
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_IOMMU_H */
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index ff5a6ce..1456b6e 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -44,6 +44,7 @@
 #include <asm/kdump.h>
 #include <asm/fadump.h>
 #include <asm/vio.h>
+#include <asm/tce.h>
 
 #define DBG(...)
 
@@ -856,3 +857,149 @@ void iommu_free_coherent(struct iommu_table *tbl, size_t size,
 		free_pages((unsigned long)vaddr, get_order(size));
 	}
 }
+
+#ifdef CONFIG_IOMMU_API
+/*
+ * SPAPR TCE API
+ */
+static void tce_flush(struct iommu_table *tbl)
+{
+	/* Flush/invalidate TLB caches if necessary */
+	if (ppc_md.tce_flush)
+		ppc_md.tce_flush(tbl);
+
+	/* Make sure updates are seen by hardware */
+	mb();
+}
+
+/*
+ * iommu_clear_tces clears tces and returned the number of pages
+ * which it called put_page() on.
+ */
+static long clear_tces_nolock(struct iommu_table *tbl, unsigned long entry,
+		unsigned long pages)
+{
+	int i, pages_put = 0;
+	unsigned long oldtce;
+	struct page *page;
+
+	for (i = 0; i < pages; ++i) {
+		oldtce = ppc_md.tce_get(tbl, entry + i);
+		ppc_md.tce_free(tbl, entry + i, 1);
+
+		if (!(oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)))
+			continue;
+
+		page = pfn_to_page(oldtce >> PAGE_SHIFT);
+
+		WARN_ON(!page);
+		if (!page)
+			continue;
+
+		if (oldtce & TCE_PCI_WRITE)
+			SetPageDirty(page);
+
+		++pages_put;
+		put_page(page);
+	}
+
+	return pages_put;
+}
+
+/*
+ * iommu_clear_tces clears tces and returned the number of released pages
+ */
+long iommu_clear_tces(struct iommu_table *tbl, unsigned long entry,
+		unsigned long pages)
+{
+	int ret;
+	struct iommu_pool *pool = get_pool(tbl, entry);
+
+	spin_lock(&(pool->lock));
+	ret = clear_tces_nolock(tbl, entry, pages);
+	tce_flush(tbl);
+	spin_unlock(&(pool->lock));
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_clear_tces);
+
+static int put_tce(struct iommu_table *tbl, unsigned long entry,
+		uint64_t tce, enum dma_data_direction direction)
+{
+	int ret;
+	struct page *page = NULL;
+	unsigned long kva, offset;
+
+	/* Map new TCE */
+	offset = (tce & IOMMU_PAGE_MASK) - (tce & PAGE_MASK);
+
+	ret = get_user_pages_fast(tce & PAGE_MASK, 1,
+			direction != DMA_TO_DEVICE, &page);
+	if (ret < 1) {
+		printk(KERN_ERR "tce_vfio: get_user_pages_fast failed tce=%llx ioba=%lx ret=%d\n",
+				tce, entry << IOMMU_PAGE_SHIFT, ret);
+		if (!ret)
+			ret = -EFAULT;
+		return ret;
+	}
+
+	kva = (unsigned long) page_address(page);
+	kva += offset;
+
+	/* tce_build receives a virtual address */
+	entry += tbl->it_offset; /* Offset into real TCE table */
+	ret = ppc_md.tce_build(tbl, entry, 1, kva, direction, NULL);
+
+	/* tce_build() only returns non-zero for transient errors */
+	if (unlikely(ret)) {
+		printk(KERN_ERR "tce_vfio: tce_put failed on tce=%llx ioba=%lx kva=%lx ret=%d\n",
+				tce, entry << IOMMU_PAGE_SHIFT, kva, ret);
+		put_page(page);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/*
+ * iommu_put_tces builds tces and returned the number of actually locked pages
+ */
+long iommu_put_tces(struct iommu_table *tbl, unsigned long entry,
+		uint64_t tce, enum dma_data_direction direction,
+		unsigned long pages)
+{
+	int i, ret = 0;
+	struct iommu_pool *pool = get_pool(tbl, entry);
+
+	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
+	BUG_ON(direction == DMA_NONE);
+
+	spin_lock(&(pool->lock));
+
+	/* Check if any is in use */
+	for (i = 0; i < pages; ++i) {
+		unsigned long oldtce = ppc_md.tce_get(tbl, entry + i);
+		if (oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)) {
+			spin_unlock(&(pool->lock));
+			return -EBUSY;
+		}
+	}
+
+	/* Put tces to the table */
+	for (i = 0; (i < pages) && !ret; ++i, tce += IOMMU_PAGE_SIZE)
+		ret = put_tce(tbl, entry + i, tce, direction);
+
+	/* If failed, release locked pages, otherwise return the number of pages */
+	if (ret)
+		clear_tces_nolock(tbl, entry, i);
+	else
+		ret = pages;
+
+	tce_flush(tbl);
+	spin_unlock(&(pool->lock));
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_put_tces);
+#endif /* CONFIG_IOMMU_API */
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index 05205cf..21250ef 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -20,6 +20,7 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/msi.h>
+#include <linux/iommu.h>
 
 #include <asm/sections.h>
 #include <asm/io.h>
@@ -613,3 +614,137 @@ void __init pnv_pci_init(void)
 	ppc_md.teardown_msi_irqs = pnv_teardown_msi_irqs;
 #endif
 }
+
+#ifdef CONFIG_IOMMU_API
+/*
+ * IOMMU groups support required by VFIO
+ */
+static int add_device(struct device *dev)
+{
+	struct iommu_table *tbl;
+	int ret = 0;
+
+	if (WARN_ON(dev->iommu_group)) {
+		printk(KERN_WARNING "tce_vfio: device %s is already in iommu group %d, skipping\n",
+				dev_name(dev),
+				iommu_group_id(dev->iommu_group));
+		return -EBUSY;
+	}
+
+	tbl = get_iommu_table_base(dev);
+	if (!tbl) {
+		pr_debug("tce_vfio: skipping device %s with no tbl\n",
+				dev_name(dev));
+		return 0;
+	}
+
+	pr_debug("tce_vfio: adding %s to iommu group %d\n",
+			dev_name(dev), iommu_group_id(tbl->it_group));
+
+	ret = iommu_group_add_device(tbl->it_group, dev);
+	if (ret < 0)
+		printk(KERN_ERR "tce_vfio: %s has not been added, ret=%d\n",
+				dev_name(dev), ret);
+
+	return ret;
+}
+
+static void del_device(struct device *dev)
+{
+	iommu_group_remove_device(dev);
+}
+
+static int iommu_bus_notifier(struct notifier_block *nb,
+			      unsigned long action, void *data)
+{
+	struct device *dev = data;
+
+	switch (action) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		return add_device(dev);
+	case BUS_NOTIFY_DEL_DEVICE:
+		del_device(dev);
+		return 0;
+	default:
+		return 0;
+	}
+}
+
+static struct notifier_block tce_iommu_bus_nb = {
+	.notifier_call = iommu_bus_notifier,
+};
+
+static void group_release(void *iommu_data)
+{
+	struct iommu_table *tbl = iommu_data;
+	tbl->it_group = NULL;
+}
+
+static int __init tce_iommu_init(void)
+{
+	struct pci_dev *pdev = NULL;
+	struct iommu_table *tbl;
+	struct iommu_group *grp;
+
+	/* Allocate and initialize IOMMU groups */
+	for_each_pci_dev(pdev) {
+		tbl = get_iommu_table_base(&pdev->dev);
+		if (!tbl)
+			continue;
+
+		/* Skip already initialized */
+		if (tbl->it_group)
+			continue;
+
+		grp = iommu_group_alloc();
+		if (IS_ERR(grp)) {
+			printk(KERN_INFO "tce_vfio: cannot create "
+					"new IOMMU group, ret=%ld\n",
+					PTR_ERR(grp));
+			return PTR_ERR(grp);
+		}
+		tbl->it_group = grp;
+		iommu_group_set_iommudata(grp, tbl, group_release);
+	}
+
+	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
+
+	/* Add PCI devices to VFIO groups */
+	for_each_pci_dev(pdev)
+		add_device(&pdev->dev);
+
+	return 0;
+}
+
+static void __exit tce_iommu_cleanup(void)
+{
+	struct pci_dev *pdev = NULL;
+	struct iommu_table *tbl;
+	struct iommu_group *grp = NULL;
+
+	bus_unregister_notifier(&pci_bus_type, &tce_iommu_bus_nb);
+
+	/* Delete PCI devices from VFIO groups */
+	for_each_pci_dev(pdev)
+		del_device(&pdev->dev);
+
+	/* Release VFIO groups */
+	for_each_pci_dev(pdev) {
+		tbl = get_iommu_table_base(&pdev->dev);
+		if (!tbl)
+			continue;
+		grp = tbl->it_group;
+
+		/* Skip (already) uninitialized */
+		if (!grp)
+			continue;
+
+		/* Do actual release, group_release() is expected to work */
+		iommu_group_put(grp);
+		BUG_ON(tbl->it_group);
+	}
+}
+
+module_init(tce_iommu_init);
+module_exit(tce_iommu_cleanup);
+#endif /* CONFIG_IOMMU_API */
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 9f69b56..29d11dc 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -187,4 +187,12 @@ config EXYNOS_IOMMU_DEBUG
 
 	  Say N unless you need kernel log message for IOMMU debugging
 
+config SPAPR_TCE_IOMMU
+	bool "sPAPR TCE IOMMU Support"
+	depends on PPC_POWERNV
+	select IOMMU_API
+	help
+	  Enables bits of IOMMU API required by VFIO. The iommu_ops is
+	  still not implemented.
+
 endif # IOMMU_SUPPORT
-- 
1.7.10.4

