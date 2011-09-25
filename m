Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab1IYLBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 07:01:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56363 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1IYLBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 07:01:44 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        <iommu@lists.linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Cousson Benoit <b-cousson@ti.com>,
        Kevin Hilman <khilman@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 5/5] iommu/omap: eliminate the public omap_find_iommu_device() method
Date: Sun, 25 Sep 2011 13:58:57 +0300
Message-Id: <1316948337-7924-6-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316948337-7924-1-git-send-email-ohad@wizery.com>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the public omap_find_iommu_device() method, and don't
expect clients to provide the omap_iommu handle anymore.

Instead, OMAP's iommu driver should now utilize dev_archdata's private iommu
extension to be able to access the required iommu information.

Update omap3isp appropriately.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/include/plat/iommu.h |    5 +--
 arch/arm/plat-omap/include/plat/iovmm.h |   12 +++---
 drivers/iommu/omap-iommu.c              |   58 ++++++++++++++-----------------
 drivers/iommu/omap-iovmm.c              |   31 +++++++++++------
 drivers/media/video/omap3isp/isp.c      |   30 +++-------------
 drivers/media/video/omap3isp/isp.h      |    2 -
 drivers/media/video/omap3isp/ispccdc.c  |   18 +++++-----
 drivers/media/video/omap3isp/ispstat.c  |    8 ++--
 drivers/media/video/omap3isp/ispvideo.c |    4 +-
 9 files changed, 74 insertions(+), 94 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
index fa11ee2..88be3e6 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -189,8 +189,8 @@ extern int omap_iommu_set_isr(const char *name,
 				    void *priv),
 			 void *isr_priv);
 
-extern void omap_iommu_save_ctx(struct omap_iommu *obj);
-extern void omap_iommu_restore_ctx(struct omap_iommu *obj);
+extern void omap_iommu_save_ctx(struct device *dev);
+extern void omap_iommu_restore_ctx(struct device *dev);
 
 extern int omap_install_iommu_arch(const struct iommu_functions *ops);
 extern void omap_uninstall_iommu_arch(const struct iommu_functions *ops);
@@ -202,6 +202,5 @@ extern ssize_t
 omap_iommu_dump_ctx(struct omap_iommu *obj, char *buf, ssize_t len);
 extern size_t
 omap_dump_tlb_entries(struct omap_iommu *obj, char *buf, ssize_t len);
-struct device *omap_find_iommu_device(const char *name);
 
 #endif /* __MACH_IOMMU_H */
diff --git a/arch/arm/plat-omap/include/plat/iovmm.h b/arch/arm/plat-omap/include/plat/iovmm.h
index 6af1a91..498e57c 100644
--- a/arch/arm/plat-omap/include/plat/iovmm.h
+++ b/arch/arm/plat-omap/include/plat/iovmm.h
@@ -72,18 +72,18 @@ struct iovm_struct {
 #define IOVMF_DA_FIXED		(1 << (4 + IOVMF_SW_SHIFT))
 
 
-extern struct iovm_struct *omap_find_iovm_area(struct omap_iommu *obj, u32 da);
+extern struct iovm_struct *omap_find_iovm_area(struct device *dev, u32 da);
 extern u32
-omap_iommu_vmap(struct iommu_domain *domain, struct omap_iommu *obj, u32 da,
+omap_iommu_vmap(struct iommu_domain *domain, struct device *dev, u32 da,
 			const struct sg_table *sgt, u32 flags);
 extern struct sg_table *omap_iommu_vunmap(struct iommu_domain *domain,
-				struct omap_iommu *obj, u32 da);
+				struct device *dev, u32 da);
 extern u32
-omap_iommu_vmalloc(struct iommu_domain *domain, struct omap_iommu *obj,
+omap_iommu_vmalloc(struct iommu_domain *domain, struct device *dev,
 				u32 da, size_t bytes, u32 flags);
 extern void
-omap_iommu_vfree(struct iommu_domain *domain, struct omap_iommu *obj,
+omap_iommu_vfree(struct iommu_domain *domain, struct device *dev,
 				const u32 da);
-extern void *omap_da_to_va(struct omap_iommu *obj, u32 da);
+extern void *omap_da_to_va(struct device *dev, u32 da);
 
 #endif /* __IOMMU_MMAP_H */
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 849a39e..eea3ee2 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -86,20 +86,24 @@ EXPORT_SYMBOL_GPL(omap_uninstall_iommu_arch);
 
 /**
  * omap_iommu_save_ctx - Save registers for pm off-mode support
- * @obj:	target iommu
+ * @dev:	client device
  **/
-void omap_iommu_save_ctx(struct omap_iommu *obj)
+void omap_iommu_save_ctx(struct device *dev)
 {
+	struct omap_iommu *obj = dev_to_omap_iommu(dev);
+
 	arch_iommu->save_ctx(obj);
 }
 EXPORT_SYMBOL_GPL(omap_iommu_save_ctx);
 
 /**
  * omap_iommu_restore_ctx - Restore registers for pm off-mode support
- * @obj:	target iommu
+ * @dev:	client device
  **/
-void omap_iommu_restore_ctx(struct omap_iommu *obj)
+void omap_iommu_restore_ctx(struct device *dev)
 {
+	struct omap_iommu *obj = dev_to_omap_iommu(dev);
+
 	arch_iommu->restore_ctx(obj);
 }
 EXPORT_SYMBOL_GPL(omap_iommu_restore_ctx);
@@ -815,35 +819,23 @@ static int device_match_by_alias(struct device *dev, void *data)
 }
 
 /**
- * omap_find_iommu_device() - find an omap iommu device by name
- * @name:	name of the iommu device
- *
- * The generic iommu API requires the caller to provide the device
- * he wishes to attach to a certain iommu domain.
- *
- * Drivers generally should not bother with this as it should just
- * be taken care of by the DMA-API using dev_archdata.
- *
- * This function is provided as an interim solution until the latter
- * materializes, and omap3isp is fully migrated to the DMA-API.
- */
-struct device *omap_find_iommu_device(const char *name)
-{
-	return driver_find_device(&omap_iommu_driver.driver, NULL,
-				(void *)name,
-				device_match_by_alias);
-}
-EXPORT_SYMBOL_GPL(omap_find_iommu_device);
-
-/**
  * omap_iommu_attach() - attach iommu device to an iommu domain
- * @dev:	target omap iommu device
+ * @name:	name of target omap iommu device
  * @iopgd:	page table
  **/
-static struct omap_iommu *omap_iommu_attach(struct device *dev, u32 *iopgd)
+static struct omap_iommu *omap_iommu_attach(const char *name, u32 *iopgd)
 {
 	int err = -ENOMEM;
-	struct omap_iommu *obj = to_iommu(dev);
+	struct device *dev;
+	struct omap_iommu *obj;
+
+	dev = driver_find_device(&omap_iommu_driver.driver, NULL,
+				(void *)name,
+				device_match_by_alias);
+	if (!dev)
+		return NULL;
+
+	obj = to_iommu(dev);
 
 	spin_lock(&obj->iommu_lock);
 
@@ -1064,6 +1056,7 @@ omap_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	struct omap_iommu_domain *omap_domain = domain->priv;
 	struct omap_iommu *oiommu;
+	struct omap_iommu_arch_data *arch_data = dev->archdata.iommu;
 	int ret = 0;
 
 	spin_lock(&omap_domain->lock);
@@ -1076,14 +1069,14 @@ omap_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	}
 
 	/* get a handle to and enable the omap iommu */
-	oiommu = omap_iommu_attach(dev, omap_domain->pgtable);
+	oiommu = omap_iommu_attach(arch_data->name, omap_domain->pgtable);
 	if (IS_ERR(oiommu)) {
 		ret = PTR_ERR(oiommu);
 		dev_err(dev, "can't get omap iommu: %d\n", ret);
 		goto out;
 	}
 
-	omap_domain->iommu_dev = oiommu;
+	omap_domain->iommu_dev = arch_data->iommu_dev = oiommu;
 	oiommu->domain = domain;
 
 	/* temporary workaround */
@@ -1098,7 +1091,8 @@ static void omap_iommu_detach_dev(struct iommu_domain *domain,
 				 struct device *dev)
 {
 	struct omap_iommu_domain *omap_domain = domain->priv;
-	struct omap_iommu *oiommu = to_iommu(dev);
+	struct omap_iommu_arch_data *arch_data = dev->archdata.iommu;
+	struct omap_iommu *oiommu = dev_to_omap_iommu(dev);
 
 	spin_lock(&omap_domain->lock);
 
@@ -1112,7 +1106,7 @@ static void omap_iommu_detach_dev(struct iommu_domain *domain,
 
 	omap_iommu_detach(oiommu);
 
-	omap_domain->iommu_dev = NULL;
+	omap_domain->iommu_dev = arch_data->iommu_dev = NULL;
 
 	/* temporary workaround */
 	clk_disable(oiommu->clk);
diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index f4dea5a..28ff3da 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -230,12 +230,14 @@ static struct iovm_struct *__find_iovm_area(struct omap_iommu *obj,
 
 /**
  * omap_find_iovm_area  -  find iovma which includes @da
+ * @dev:	client device
  * @da:		iommu device virtual address
  *
  * Find the existing iovma starting at @da
  */
-struct iovm_struct *omap_find_iovm_area(struct omap_iommu *obj, u32 da)
+struct iovm_struct *omap_find_iovm_area(struct device *dev, u32 da)
 {
+	struct omap_iommu *obj = dev_to_omap_iommu(dev);
 	struct iovm_struct *area;
 
 	mutex_lock(&obj->mmap_lock);
@@ -342,14 +344,15 @@ static void free_iovm_area(struct omap_iommu *obj, struct iovm_struct *area)
 
 /**
  * omap_da_to_va - convert (d) to (v)
- * @obj:	objective iommu
+ * @dev:	client device
  * @da:		iommu device virtual address
  * @va:		mpu virtual address
  *
  * Returns mpu virtual addr which corresponds to a given device virtual addr
  */
-void *omap_da_to_va(struct omap_iommu *obj, u32 da)
+void *omap_da_to_va(struct device *dev, u32 da)
 {
+	struct omap_iommu *obj = dev_to_omap_iommu(dev);
 	void *va = NULL;
 	struct iovm_struct *area;
 
@@ -575,16 +578,18 @@ __iommu_vmap(struct iommu_domain *domain, struct omap_iommu *obj,
 
 /**
  * omap_iommu_vmap  -  (d)-(p)-(v) address mapper
- * @obj:	objective iommu
+ * @domain:	iommu domain
+ * @dev:	client device
  * @sgt:	address of scatter gather table
  * @flags:	iovma and page property
  *
  * Creates 1-n-1 mapping with given @sgt and returns @da.
  * All @sgt element must be io page size aligned.
  */
-u32 omap_iommu_vmap(struct iommu_domain *domain, struct omap_iommu *obj, u32 da,
+u32 omap_iommu_vmap(struct iommu_domain *domain, struct device *dev, u32 da,
 		const struct sg_table *sgt, u32 flags)
 {
+	struct omap_iommu *obj = dev_to_omap_iommu(dev);
 	size_t bytes;
 	void *va = NULL;
 
@@ -615,15 +620,17 @@ EXPORT_SYMBOL_GPL(omap_iommu_vmap);
 
 /**
  * omap_iommu_vunmap  -  release virtual mapping obtained by 'omap_iommu_vmap()'
- * @obj:	objective iommu
+ * @domain:	iommu domain
+ * @dev:	client device
  * @da:		iommu device virtual address
  *
  * Free the iommu virtually contiguous memory area starting at
  * @da, which was returned by 'omap_iommu_vmap()'.
  */
 struct sg_table *
-omap_iommu_vunmap(struct iommu_domain *domain, struct omap_iommu *obj, u32 da)
+omap_iommu_vunmap(struct iommu_domain *domain, struct device *dev, u32 da)
 {
+	struct omap_iommu *obj = dev_to_omap_iommu(dev);
 	struct sg_table *sgt;
 	/*
 	 * 'sgt' is allocated before 'omap_iommu_vmalloc()' is called.
@@ -640,7 +647,7 @@ EXPORT_SYMBOL_GPL(omap_iommu_vunmap);
 
 /**
  * omap_iommu_vmalloc  -  (d)-(p)-(v) address allocator and mapper
- * @obj:	objective iommu
+ * @dev:	client device
  * @da:		contiguous iommu virtual memory
  * @bytes:	allocation size
  * @flags:	iovma and page property
@@ -649,9 +656,10 @@ EXPORT_SYMBOL_GPL(omap_iommu_vunmap);
  * @da again, which might be adjusted if 'IOVMF_DA_FIXED' is not set.
  */
 u32
-omap_iommu_vmalloc(struct iommu_domain *domain, struct omap_iommu *obj, u32 da,
+omap_iommu_vmalloc(struct iommu_domain *domain, struct device *dev, u32 da,
 						size_t bytes, u32 flags)
 {
+	struct omap_iommu *obj = dev_to_omap_iommu(dev);
 	void *va;
 	struct sg_table *sgt;
 
@@ -691,15 +699,16 @@ EXPORT_SYMBOL_GPL(omap_iommu_vmalloc);
 
 /**
  * omap_iommu_vfree  -  release memory allocated by 'omap_iommu_vmalloc()'
- * @obj:	objective iommu
+ * @dev:	client device
  * @da:		iommu device virtual address
  *
  * Frees the iommu virtually continuous memory area starting at
  * @da, as obtained from 'omap_iommu_vmalloc()'.
  */
-void omap_iommu_vfree(struct iommu_domain *domain, struct omap_iommu *obj,
+void omap_iommu_vfree(struct iommu_domain *domain, struct device *dev,
 								const u32 da)
 {
+	struct omap_iommu *obj = dev_to_omap_iommu(dev);
 	struct sg_table *sgt;
 
 	sgt = unmap_vm_area(domain, obj, da, vfree,
diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index a4baa61..1cb3a68 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -80,13 +80,6 @@
 #include "isph3a.h"
 #include "isphist.h"
 
-/*
- * this is provided as an interim solution until omap3isp doesn't need
- * any omap-specific iommu API
- */
-#define to_iommu(dev)							\
-	(struct omap_iommu *)platform_get_drvdata(to_platform_device(dev))
-
 static unsigned int autoidle;
 module_param(autoidle, int, 0444);
 MODULE_PARM_DESC(autoidle, "Enable OMAP3ISP AUTOIDLE support");
@@ -1114,8 +1107,7 @@ isp_restore_context(struct isp_device *isp, struct isp_reg *reg_list)
 static void isp_save_ctx(struct isp_device *isp)
 {
 	isp_save_context(isp, isp_reg_list);
-	if (isp->iommu)
-		omap_iommu_save_ctx(isp->iommu);
+	omap_iommu_save_ctx(isp->dev);
 }
 
 /*
@@ -1128,8 +1120,7 @@ static void isp_save_ctx(struct isp_device *isp)
 static void isp_restore_ctx(struct isp_device *isp)
 {
 	isp_restore_context(isp, isp_reg_list);
-	if (isp->iommu)
-		omap_iommu_restore_ctx(isp->iommu);
+	omap_iommu_restore_ctx(isp->dev);
 	omap3isp_ccdc_restore_context(isp);
 	omap3isp_preview_restore_context(isp);
 }
@@ -1982,7 +1973,7 @@ static int isp_remove(struct platform_device *pdev)
 	isp_cleanup_modules(isp);
 
 	omap3isp_get(isp);
-	iommu_detach_device(isp->domain, isp->iommu_dev);
+	iommu_detach_device(isp->domain, &pdev->dev);
 	iommu_domain_free(isp->domain);
 	omap3isp_put(isp);
 
@@ -2130,17 +2121,6 @@ static int isp_probe(struct platform_device *pdev)
 		}
 	}
 
-	/* IOMMU */
-	isp->iommu_dev = omap_find_iommu_device("isp");
-	if (!isp->iommu_dev) {
-		dev_err(isp->dev, "omap_find_iommu_device failed\n");
-		ret = -ENODEV;
-		goto error_isp;
-	}
-
-	/* to be removed once iommu migration is complete */
-	isp->iommu = to_iommu(isp->iommu_dev);
-
 	isp->domain = iommu_domain_alloc();
 	if (!isp->domain) {
 		dev_err(isp->dev, "can't alloc iommu domain\n");
@@ -2148,7 +2128,7 @@ static int isp_probe(struct platform_device *pdev)
 		goto error_isp;
 	}
 
-	ret = iommu_attach_device(isp->domain, isp->iommu_dev);
+	ret = iommu_attach_device(isp->domain, &pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "can't attach iommu device: %d\n", ret);
 		goto free_domain;
@@ -2187,7 +2167,7 @@ error_modules:
 error_irq:
 	free_irq(isp->irq_num, isp);
 detach_dev:
-	iommu_detach_device(isp->domain, isp->iommu_dev);
+	iommu_detach_device(isp->domain, &pdev->dev);
 free_domain:
 	iommu_domain_free(isp->domain);
 error_isp:
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 81fdd85..60e0e29 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -295,9 +295,7 @@ struct isp_device {
 	unsigned int sbl_resources;
 	unsigned int subclk_resources;
 
-	struct omap_iommu *iommu;
 	struct iommu_domain *domain;
-	struct device *iommu_dev;
 
 	struct isp_platform_callback platform_cb;
 };
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 9891dde..6b4c11e 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -365,7 +365,7 @@ static void ccdc_lsc_free_request(struct isp_ccdc_device *ccdc,
 		dma_unmap_sg(isp->dev, req->iovm->sgt->sgl,
 			     req->iovm->sgt->nents, DMA_TO_DEVICE);
 	if (req->table)
-		omap_iommu_vfree(isp->domain, isp->iommu, req->table);
+		omap_iommu_vfree(isp->domain, isp->dev, req->table);
 	kfree(req);
 }
 
@@ -437,7 +437,7 @@ static int ccdc_lsc_config(struct isp_ccdc_device *ccdc,
 
 		req->enable = 1;
 
-		req->table = omap_iommu_vmalloc(isp->domain, isp->iommu, 0,
+		req->table = omap_iommu_vmalloc(isp->domain, isp->dev, 0,
 					req->config.size, IOMMU_FLAG);
 		if (IS_ERR_VALUE(req->table)) {
 			req->table = 0;
@@ -445,7 +445,7 @@ static int ccdc_lsc_config(struct isp_ccdc_device *ccdc,
 			goto done;
 		}
 
-		req->iovm = omap_find_iovm_area(isp->iommu, req->table);
+		req->iovm = omap_find_iovm_area(isp->dev, req->table);
 		if (req->iovm == NULL) {
 			ret = -ENOMEM;
 			goto done;
@@ -461,7 +461,7 @@ static int ccdc_lsc_config(struct isp_ccdc_device *ccdc,
 		dma_sync_sg_for_cpu(isp->dev, req->iovm->sgt->sgl,
 				    req->iovm->sgt->nents, DMA_TO_DEVICE);
 
-		table = omap_da_to_va(isp->iommu, req->table);
+		table = omap_da_to_va(isp->dev, req->table);
 		if (copy_from_user(table, config->lsc, req->config.size)) {
 			ret = -EFAULT;
 			goto done;
@@ -733,15 +733,15 @@ static int ccdc_config(struct isp_ccdc_device *ccdc,
 			 * already done by omap_iommu_vmalloc().
 			 */
 			size = ccdc->fpc.fpnum * 4;
-			table_new = omap_iommu_vmalloc(isp->domain, isp->iommu,
+			table_new = omap_iommu_vmalloc(isp->domain, isp->dev,
 							0, size, IOMMU_FLAG);
 			if (IS_ERR_VALUE(table_new))
 				return -ENOMEM;
 
-			if (copy_from_user(omap_da_to_va(isp->iommu, table_new),
+			if (copy_from_user(omap_da_to_va(isp->dev, table_new),
 					   (__force void __user *)
 					   ccdc->fpc.fpcaddr, size)) {
-				omap_iommu_vfree(isp->domain, isp->iommu,
+				omap_iommu_vfree(isp->domain, isp->dev,
 								table_new);
 				return -EFAULT;
 			}
@@ -752,7 +752,7 @@ static int ccdc_config(struct isp_ccdc_device *ccdc,
 
 		ccdc_configure_fpc(ccdc);
 		if (table_old != 0)
-			omap_iommu_vfree(isp->domain, isp->iommu, table_old);
+			omap_iommu_vfree(isp->domain, isp->dev, table_old);
 	}
 
 	return ccdc_lsc_config(ccdc, ccdc_struct);
@@ -2287,5 +2287,5 @@ void omap3isp_ccdc_cleanup(struct isp_device *isp)
 	ccdc_lsc_free_queue(ccdc, &ccdc->lsc.free_queue);
 
 	if (ccdc->fpc.fpcaddr != 0)
-		omap_iommu_vfree(isp->domain, isp->iommu, ccdc->fpc.fpcaddr);
+		omap_iommu_vfree(isp->domain, isp->dev, ccdc->fpc.fpcaddr);
 }
diff --git a/drivers/media/video/omap3isp/ispstat.c b/drivers/media/video/omap3isp/ispstat.c
index 7329055..036fc93 100644
--- a/drivers/media/video/omap3isp/ispstat.c
+++ b/drivers/media/video/omap3isp/ispstat.c
@@ -366,7 +366,7 @@ static void isp_stat_bufs_free(struct ispstat *stat)
 				dma_unmap_sg(isp->dev, buf->iovm->sgt->sgl,
 					     buf->iovm->sgt->nents,
 					     DMA_FROM_DEVICE);
-			omap_iommu_vfree(isp->domain, isp->iommu,
+			omap_iommu_vfree(isp->domain, isp->dev,
 							buf->iommu_addr);
 		} else {
 			if (!buf->virt_addr)
@@ -400,7 +400,7 @@ static int isp_stat_bufs_alloc_iommu(struct ispstat *stat, unsigned int size)
 		struct iovm_struct *iovm;
 
 		WARN_ON(buf->dma_addr);
-		buf->iommu_addr = omap_iommu_vmalloc(isp->domain, isp->iommu, 0,
+		buf->iommu_addr = omap_iommu_vmalloc(isp->domain, isp->dev, 0,
 							size, IOMMU_FLAG);
 		if (IS_ERR((void *)buf->iommu_addr)) {
 			dev_err(stat->isp->dev,
@@ -410,7 +410,7 @@ static int isp_stat_bufs_alloc_iommu(struct ispstat *stat, unsigned int size)
 			return -ENOMEM;
 		}
 
-		iovm = omap_find_iovm_area(isp->iommu, buf->iommu_addr);
+		iovm = omap_find_iovm_area(isp->dev, buf->iommu_addr);
 		if (!iovm ||
 		    !dma_map_sg(isp->dev, iovm->sgt->sgl, iovm->sgt->nents,
 				DMA_FROM_DEVICE)) {
@@ -419,7 +419,7 @@ static int isp_stat_bufs_alloc_iommu(struct ispstat *stat, unsigned int size)
 		}
 		buf->iovm = iovm;
 
-		buf->virt_addr = omap_da_to_va(stat->isp->iommu,
+		buf->virt_addr = omap_da_to_va(stat->isp->dev,
 					  (u32)buf->iommu_addr);
 		buf->empty = 1;
 		dev_dbg(stat->isp->dev, "%s: buffer[%d] allocated."
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 912ac07..6d1d55b 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -446,7 +446,7 @@ ispmmu_vmap(struct isp_device *isp, const struct scatterlist *sglist, int sglen)
 	sgt->nents = sglen;
 	sgt->orig_nents = sglen;
 
-	da = omap_iommu_vmap(isp->domain, isp->iommu, 0, sgt, IOMMU_FLAG);
+	da = omap_iommu_vmap(isp->domain, isp->dev, 0, sgt, IOMMU_FLAG);
 	if (IS_ERR_VALUE(da))
 		kfree(sgt);
 
@@ -462,7 +462,7 @@ static void ispmmu_vunmap(struct isp_device *isp, dma_addr_t da)
 {
 	struct sg_table *sgt;
 
-	sgt = omap_iommu_vunmap(isp->domain, isp->iommu, (u32)da);
+	sgt = omap_iommu_vunmap(isp->domain, isp->dev, (u32)da);
 	kfree(sgt);
 }
 
-- 
1.7.4.1

