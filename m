Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1FBWbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:31:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51844 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1FBWbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:31:04 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: <laurent.pinchart@ideasonboard.com>, <Hiroshi.DOYU@nokia.com>,
        <arnd@arndb.de>, <davidb@codeaurora.org>, <Joerg.Roedel@amd.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 1/6] omap: iommu: generic iommu api migration
Date: Fri,  3 Jun 2011 01:27:38 +0300
Message-Id: <1307053663-24572-2-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307053663-24572-1-git-send-email-ohad@wizery.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrate OMAP's iommu to the generic iommu api, so users can stay
generic, and non-omap-specific code can be removed and eventually
consolidated into a generic framework.

Tested on both OMAP3 and OMAP4.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/plat-omap/Kconfig              |    7 +-
 arch/arm/plat-omap/include/plat/iommu.h |    3 +-
 arch/arm/plat-omap/iommu.c              |  288 +++++++++++++++++++++++++++----
 arch/arm/plat-omap/iopgtable.h          |   18 ++
 4 files changed, 278 insertions(+), 38 deletions(-)

diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index 49a4c75..1c3acb5 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -131,8 +131,13 @@ config OMAP_MBOX_KFIFO_SIZE
 	  This can also be changed at runtime (via the mbox_kfifo_size
 	  module parameter).
 
+config IOMMU_API
+	bool
+
+#can't be tristate; iommu api doesn't support un-registration
 config OMAP_IOMMU
-	tristate
+	bool
+	select IOMMU_API
 
 config OMAP_IOMMU_DEBUG
        tristate "Export OMAP IOMMU internals in DebugFS"
diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
index 174f1b9..db1c492 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -167,8 +167,6 @@ extern void iopgtable_lookup_entry(struct iommu *obj, u32 da, u32 **ppgd,
 extern size_t iopgtable_clear_entry(struct iommu *obj, u32 iova);
 
 extern int iommu_set_da_range(struct iommu *obj, u32 start, u32 end);
-extern struct iommu *iommu_get(const char *name);
-extern void iommu_put(struct iommu *obj);
 extern int iommu_set_isr(const char *name,
 			 int (*isr)(struct iommu *obj, u32 da, u32 iommu_errs,
 				    void *priv),
@@ -185,5 +183,6 @@ extern int foreach_iommu_device(void *data,
 
 extern ssize_t iommu_dump_ctx(struct iommu *obj, char *buf, ssize_t len);
 extern size_t dump_tlb_entries(struct iommu *obj, char *buf, ssize_t len);
+struct device *omap_find_iommu_device(const char *name);
 
 #endif /* __MACH_IOMMU_H */
diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index 34fc31e..f06e99c 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -18,6 +18,8 @@
 #include <linux/ioport.h>
 #include <linux/clk.h>
 #include <linux/platform_device.h>
+#include <linux/iommu.h>
+#include <linux/mutex.h>
 
 #include <asm/cacheflush.h>
 
@@ -30,6 +32,19 @@
 	     (__i < (n)) && (cr = __iotlb_read_cr((obj), __i), true);	\
 	     __i++)
 
+/**
+ * struct omap_iommu_domain - omap iommu domain
+ * @pgtable:	the page table
+ * @iommu_dev:	an omap iommu device attached to this domain. only a single
+ *		iommu device can be attached for now.
+ * @lock:	domain lock, should be taken when attaching/detaching
+ */
+struct omap_iommu_domain {
+	u32 *pgtable;
+	struct iommu *iommu_dev;
+	struct mutex lock;
+};
+
 /* accommodate the difference between omap1 and omap2/3 */
 static const struct iommu_functions *arch_iommu;
 
@@ -852,31 +867,50 @@ int iommu_set_da_range(struct iommu *obj, u32 start, u32 end)
 EXPORT_SYMBOL_GPL(iommu_set_da_range);
 
 /**
- * iommu_get - Get iommu handler
- * @name:	target iommu name
+ * omap_find_iommu_device() - find an omap iommu device by name
+ * @name:	name of the iommu device
+ *
+ * The generic iommu API requires the caller to provide the device
+ * he wishes to attach to a certain iommu domain. Users of that API
+ * may look up the device using PCI credentials when relevent, and when
+ * not, this helper should be used to find a specific iommu device by name.
+ *
+ * This may be relevant to other platforms as well (msm ?) so consider
+ * moving this to the generic iommu framework.
+ */
+struct device *omap_find_iommu_device(const char *name)
+{
+	return driver_find_device(&omap_iommu_driver.driver, NULL,
+				(void *)name,
+				device_match_by_alias);
+}
+EXPORT_SYMBOL_GPL(omap_find_iommu_device);
+
+/**
+ * omap_iommu_attach() - attach iommu device to an iommu domain
+ * @dev:	target omap iommu device
+ * @iopgd:	page table
  **/
-struct iommu *iommu_get(const char *name)
+static struct iommu *omap_iommu_attach(struct device *dev, u32 *iopgd)
 {
 	int err = -ENOMEM;
-	struct device *dev;
-	struct iommu *obj;
-
-	dev = driver_find_device(&omap_iommu_driver.driver, NULL, (void *)name,
-				 device_match_by_alias);
-	if (!dev)
-		return ERR_PTR(-ENODEV);
-
-	obj = to_iommu(dev);
+	struct iommu *obj = to_iommu(dev);
 
 	mutex_lock(&obj->iommu_lock);
 
-	if (obj->refcount++ == 0) {
-		err = iommu_enable(obj);
-		if (err)
-			goto err_enable;
-		flush_iotlb_all(obj);
+	/* an iommu device can only be attached once */
+	if (++obj->refcount > 1) {
+		dev_err(dev, "%s: already attached!\n", obj->name);
+		err = -EBUSY;
+		goto err_enable;
 	}
 
+	obj->iopgd = iopgd;
+	err = iommu_enable(obj);
+	if (err)
+		goto err_enable;
+	flush_iotlb_all(obj);
+
 	if (!try_module_get(obj->owner))
 		goto err_module;
 
@@ -893,13 +927,12 @@ err_enable:
 	mutex_unlock(&obj->iommu_lock);
 	return ERR_PTR(err);
 }
-EXPORT_SYMBOL_GPL(iommu_get);
 
 /**
- * iommu_put - Put back iommu handler
+ * omap_iommu_detach - release iommu device
  * @obj:	target iommu
  **/
-void iommu_put(struct iommu *obj)
+static void omap_iommu_detach(struct iommu *obj)
 {
 	if (!obj || IS_ERR(obj))
 		return;
@@ -911,11 +944,12 @@ void iommu_put(struct iommu *obj)
 
 	module_put(obj->owner);
 
+	obj->iopgd = NULL;
+
 	mutex_unlock(&obj->iommu_lock);
 
 	dev_dbg(obj->dev, "%s: %s\n", __func__, obj->name);
 }
-EXPORT_SYMBOL_GPL(iommu_put);
 
 int iommu_set_isr(const char *name,
 		  int (*isr)(struct iommu *obj, u32 da, u32 iommu_errs,
@@ -950,7 +984,6 @@ EXPORT_SYMBOL_GPL(iommu_set_isr);
 static int __devinit omap_iommu_probe(struct platform_device *pdev)
 {
 	int err = -ENODEV;
-	void *p;
 	int irq;
 	struct iommu *obj;
 	struct resource *res;
@@ -1009,22 +1042,9 @@ static int __devinit omap_iommu_probe(struct platform_device *pdev)
 		goto err_irq;
 	platform_set_drvdata(pdev, obj);
 
-	p = (void *)__get_free_pages(GFP_KERNEL, get_order(IOPGD_TABLE_SIZE));
-	if (!p) {
-		err = -ENOMEM;
-		goto err_pgd;
-	}
-	memset(p, 0, IOPGD_TABLE_SIZE);
-	clean_dcache_area(p, IOPGD_TABLE_SIZE);
-	obj->iopgd = p;
-
-	BUG_ON(!IS_ALIGNED((unsigned long)obj->iopgd, IOPGD_TABLE_SIZE));
-
 	dev_info(&pdev->dev, "%s registered\n", obj->name);
 	return 0;
 
-err_pgd:
-	free_irq(irq, obj);
 err_irq:
 	iounmap(obj->regbase);
 err_ioremap:
@@ -1072,6 +1092,202 @@ static void iopte_cachep_ctor(void *iopte)
 	clean_dcache_area(iopte, IOPTE_TABLE_SIZE);
 }
 
+static int omap_iommu_map(struct iommu_domain *domain, unsigned long da,
+			 phys_addr_t pa, int order, int prot)
+{
+	struct omap_iommu_domain *omap_domain = domain->priv;
+	struct iommu *oiommu = omap_domain->iommu_dev;
+	struct device *dev = oiommu->dev;
+	size_t bytes = PAGE_SIZE << order;
+	struct iotlb_entry e;
+	int omap_pgsz;
+	u32 ret, flags;
+
+	/* we only support mapping a single iommu page for now */
+	omap_pgsz = bytes_to_iopgsz(bytes);
+	if (omap_pgsz < 0) {
+		dev_err(dev, "invalid size to map: %d\n", bytes);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "mapping da 0x%lx to pa 0x%x size 0x%x\n", da, pa, bytes);
+
+	flags = omap_pgsz | prot;
+
+	iotlb_init_entry(&e, da, pa, flags);
+
+	ret = iopgtable_store_entry(oiommu, &e);
+	if (ret) {
+		dev_err(dev, "iopgtable_store_entry failed: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int omap_iommu_unmap(struct iommu_domain *domain, unsigned long da,
+			    int order)
+{
+	struct omap_iommu_domain *omap_domain = domain->priv;
+	struct iommu *oiommu = omap_domain->iommu_dev;
+	struct device *dev = oiommu->dev;
+	size_t bytes = PAGE_SIZE << order;
+	size_t ret;
+
+	dev_dbg(dev, "unmapping da 0x%lx size 0x%x\n", da, bytes);
+
+	ret = iopgtable_clear_entry(oiommu, da);
+	if (ret != bytes) {
+		dev_err(dev, "entry @ 0x%lx was %d; not %d\n", da, ret, bytes);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+omap_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
+{
+	struct omap_iommu_domain *omap_domain = domain->priv;
+	struct iommu *oiommu;
+	int ret = 0;
+
+	mutex_lock(&omap_domain->lock);
+
+	/* only a single device is supported per domain for now */
+	if (omap_domain->iommu_dev) {
+		dev_err(dev, "iommu domain is already attached\n");
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/* get a handle to and enable the omap iommu */
+	oiommu = omap_iommu_attach(dev, omap_domain->pgtable);
+	if (IS_ERR(oiommu)) {
+		ret = PTR_ERR(oiommu);
+		dev_err(dev, "can't get omap iommu: %d\n", ret);
+		goto out;
+	}
+
+	omap_domain->iommu_dev = oiommu;
+
+out:
+	mutex_unlock(&omap_domain->lock);
+	return ret;
+}
+
+static void omap_iommu_detach_dev(struct iommu_domain *domain,
+				 struct device *dev)
+{
+	struct omap_iommu_domain *omap_domain = domain->priv;
+	struct iommu *oiommu = to_iommu(dev);
+
+	mutex_lock(&omap_domain->lock);
+
+	/* only a single device is supported per domain for now */
+	if (omap_domain->iommu_dev != oiommu) {
+		dev_err(dev, "invalid iommu device\n");
+		goto out;
+	}
+
+	iopgtable_clear_entry_all(oiommu);
+
+	omap_iommu_detach(oiommu);
+
+	omap_domain->iommu_dev = NULL;
+
+out:
+	mutex_unlock(&omap_domain->lock);
+}
+
+static int omap_iommu_domain_init(struct iommu_domain *domain)
+{
+	struct omap_iommu_domain *omap_domain;
+
+	omap_domain = kzalloc(sizeof(*omap_domain), GFP_KERNEL);
+	if (!omap_domain) {
+		pr_err("kzalloc failed\n");
+		goto fail_nomem;
+	}
+
+	omap_domain->pgtable = (u32 *)__get_free_pages(GFP_KERNEL,
+					get_order(IOPGD_TABLE_SIZE));
+	if (!omap_domain->pgtable) {
+		pr_err("__get_free_pages failed\n");
+		goto fail_nomem;
+	}
+
+	BUG_ON(!IS_ALIGNED((long)omap_domain->pgtable, IOPGD_TABLE_SIZE));
+	memset(omap_domain->pgtable, 0, IOPGD_TABLE_SIZE);
+	clean_dcache_area(omap_domain->pgtable, IOPGD_TABLE_SIZE);
+	mutex_init(&omap_domain->lock);
+
+	domain->priv = omap_domain;
+
+	return 0;
+
+fail_nomem:
+	kfree(omap_domain);
+	return -ENOMEM;
+}
+
+/* assume device was already detached */
+static void omap_iommu_domain_destroy(struct iommu_domain *domain)
+{
+	struct omap_iommu_domain *omap_domain = domain->priv;
+
+	domain->priv = NULL;
+
+	kfree(omap_domain);
+}
+
+static phys_addr_t omap_iommu_iova_to_phys(struct iommu_domain *domain,
+					  unsigned long da)
+{
+	struct omap_iommu_domain *omap_domain = domain->priv;
+	struct iommu *oiommu = omap_domain->iommu_dev;
+	struct device *dev = oiommu->dev;
+	u32 *pgd, *pte;
+	phys_addr_t ret = 0;
+
+	iopgtable_lookup_entry(oiommu, da, &pgd, &pte);
+
+	if (pte) {
+		if (iopte_is_small(*pte))
+			ret = omap_iommu_translate(*pte, da, IOPTE_MASK);
+		else if (iopte_is_large(*pte))
+			ret = omap_iommu_translate(*pte, da, IOLARGE_MASK);
+		else
+			dev_err(dev, "bogus pte 0x%x", *pte);
+	} else {
+		if (iopgd_is_section(*pgd))
+			ret = omap_iommu_translate(*pgd, da, IOSECTION_MASK);
+		else if (iopgd_is_super(*pgd))
+			ret = omap_iommu_translate(*pgd, da, IOSUPER_MASK);
+		else
+			dev_err(dev, "bogus pgd 0x%x", *pgd);
+	}
+
+	return ret;
+}
+
+static int omap_iommu_domain_has_cap(struct iommu_domain *domain,
+				    unsigned long cap)
+{
+	return 0;
+}
+
+static struct iommu_ops omap_iommu_ops = {
+	.domain_init	= omap_iommu_domain_init,
+	.domain_destroy	= omap_iommu_domain_destroy,
+	.attach_dev	= omap_iommu_attach_dev,
+	.detach_dev	= omap_iommu_detach_dev,
+	.map		= omap_iommu_map,
+	.unmap		= omap_iommu_unmap,
+	.iova_to_phys	= omap_iommu_iova_to_phys,
+	.domain_has_cap	= omap_iommu_domain_has_cap,
+};
+
 static int __init omap_iommu_init(void)
 {
 	struct kmem_cache *p;
@@ -1084,6 +1300,8 @@ static int __init omap_iommu_init(void)
 		return -ENOMEM;
 	iopte_cachep = p;
 
+	register_iommu(&omap_iommu_ops);
+
 	return platform_driver_register(&omap_iommu_driver);
 }
 module_init(omap_iommu_init);
diff --git a/arch/arm/plat-omap/iopgtable.h b/arch/arm/plat-omap/iopgtable.h
index c3e93bb..33c7aa9 100644
--- a/arch/arm/plat-omap/iopgtable.h
+++ b/arch/arm/plat-omap/iopgtable.h
@@ -56,6 +56,19 @@
 
 #define IOPAGE_MASK		IOPTE_MASK
 
+/**
+ * omap_iommu_translate() - va to pa translation
+ * @d:		omap iommu descriptor
+ * @va:		virtual address
+ * @mask:	omap iommu descriptor mask
+ *
+ * va to pa translation
+ */
+static inline phys_addr_t omap_iommu_translate(u32 d, u32 va, u32 mask)
+{
+	return (d & mask) | (va & (~mask));
+}
+
 /*
  * some descriptor attributes.
  */
@@ -64,10 +77,15 @@
 #define IOPGD_SUPER		(1 << 18 | 2 << 0)
 
 #define iopgd_is_table(x)	(((x) & 3) == IOPGD_TABLE)
+#define iopgd_is_section(x)	(((x) & (1 << 18 | 3)) == IOPGD_SECTION)
+#define iopgd_is_super(x)	(((x) & (1 << 18 | 3)) == IOPGD_SUPER)
 
 #define IOPTE_SMALL		(2 << 0)
 #define IOPTE_LARGE		(1 << 0)
 
+#define iopte_is_small(x)	(((x) & 2) == IOPTE_SMALL)
+#define iopte_is_large(x)	(((x) & 3) == IOPTE_LARGE)
+
 /* to find an entry in a page-table-directory */
 #define iopgd_index(da)		(((da) >> IOPGD_SHIFT) & (PTRS_PER_IOPGD - 1))
 #define iopgd_offset(obj, da)	((obj)->iopgd + iopgd_index(da))
-- 
1.7.1

