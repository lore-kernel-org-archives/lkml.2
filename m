Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab1IBRdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:33:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39734 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab1IBRdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:33:15 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 6/7] iommu/core: add fault reporting
Date: Fri,  2 Sep 2011 20:32:35 +0300
Message-Id: <1314984756-4400-7-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314984756-4400-1-git-send-email-ohad@wizery.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add iommu fault report mechanism to the IOMMU API, so implementations
could report about mmu faults (translation errors, hardware errors,
etc..).

Fault reports can be used in several ways:
- mere logging
- reset the device that accessed the faulting address (may be necessary
  in case the device is a remote processor for example)
- implement dynamic PTE/TLB loading

Currently the fault handler is installed when allocating a new domain
(less churn for users). Alternatively, we can also add a dedicated
iommu_set_fault_handler() API (presumably with notifiers).

Adopt OMAP's iommu driver (and remove its now-redundant
omap_iommu_set_isr API) and fix existing users of iommu_domain_alloc()
to pass NULL fault handlers.

OMAP's iommu driver will currently only pass the generic IOMMU_ERROR
fault, but in principle we can support dynamic PTE/TLB loading too
in the future.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/plat-omap/include/plat/iommu.h |    3 +-
 drivers/iommu/iommu.c                   |   10 +++++-
 drivers/iommu/omap-iommu.c              |   31 ++--------------
 drivers/media/video/omap3isp/isp.c      |    2 +-
 include/linux/iommu.h                   |   60 ++++++++++++++++++++++++++++++-
 virt/kvm/iommu.c                        |    2 +-
 6 files changed, 74 insertions(+), 34 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
index 7f1df0e..a1d79ee 100644
--- a/arch/arm/plat-omap/include/plat/iommu.h
+++ b/arch/arm/plat-omap/include/plat/iommu.h
@@ -32,6 +32,7 @@ struct omap_iommu {
 	void __iomem	*regbase;
 	struct device	*dev;
 	void		*isr_priv;
+	struct iommu_domain *domain;
 
 	unsigned int	refcount;
 	spinlock_t	iommu_lock;	/* global for this whole object */
@@ -48,8 +49,6 @@ struct omap_iommu {
 	struct list_head	mmap;
 	struct mutex		mmap_lock; /* protect mmap */
 
-	int (*isr)(struct omap_iommu *obj, u32 da, u32 iommu_errs, void *priv);
-
 	void *ctx; /* iommu context: registres saved area */
 	u32 da_start;
 	u32 da_end;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index e61a9ba..c08f1a0 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -40,7 +40,13 @@ bool iommu_found(void)
 }
 EXPORT_SYMBOL_GPL(iommu_found);
 
-struct iommu_domain *iommu_domain_alloc(void)
+/**
+ * iommu_domain_alloc() - allocate and initialize a new iommu domain
+ * @handler: an optional pointer to a fault handler, or NULL if not needed
+ *
+ * Returns the new domain, or NULL on error.
+ */
+struct iommu_domain *iommu_domain_alloc(iommu_fault_handler_t handler)
 {
 	struct iommu_domain *domain;
 	int ret;
@@ -49,6 +55,8 @@ struct iommu_domain *iommu_domain_alloc(void)
 	if (!domain)
 		return NULL;
 
+	domain->handler = handler;
+
 	ret = iommu_ops->domain_init(domain);
 	if (ret)
 		goto out_free;
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index bd5f606..089fddc 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -775,6 +775,7 @@ static irqreturn_t iommu_fault_handler(int irq, void *data)
 	u32 da, errs;
 	u32 *iopgd, *iopte;
 	struct omap_iommu *obj = data;
+	struct iommu_domain *domain = obj->domain;
 
 	if (!obj->refcount)
 		return IRQ_NONE;
@@ -786,7 +787,7 @@ static irqreturn_t iommu_fault_handler(int irq, void *data)
 		return IRQ_HANDLED;
 
 	/* Fault callback or TLB/PTE Dynamic loading */
-	if (obj->isr && !obj->isr(obj, da, errs, obj->isr_priv))
+	if (!report_iommu_fault(domain, obj->dev, da, IOMMU_ERROR))
 		return IRQ_HANDLED;
 
 	iommu_disable(obj);
@@ -904,33 +905,6 @@ static void omap_iommu_detach(struct omap_iommu *obj)
 	dev_dbg(obj->dev, "%s: %s\n", __func__, obj->name);
 }
 
-int omap_iommu_set_isr(const char *name,
-		  int (*isr)(struct omap_iommu *obj, u32 da, u32 iommu_errs,
-			     void *priv),
-		  void *isr_priv)
-{
-	struct device *dev;
-	struct omap_iommu *obj;
-
-	dev = driver_find_device(&omap_iommu_driver.driver, NULL, (void *)name,
-				 device_match_by_alias);
-	if (!dev)
-		return -ENODEV;
-
-	obj = to_iommu(dev);
-	spin_lock(&obj->iommu_lock);
-	if (obj->refcount != 0) {
-		spin_unlock(&obj->iommu_lock);
-		return -EBUSY;
-	}
-	obj->isr = isr;
-	obj->isr_priv = isr_priv;
-	spin_unlock(&obj->iommu_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(omap_iommu_set_isr);
-
 /*
  *	OMAP Device MMU(IOMMU) detection
  */
@@ -1115,6 +1089,7 @@ omap_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	}
 
 	omap_domain->iommu_dev = oiommu;
+	oiommu->domain = domain;
 
 out:
 	spin_unlock(&omap_domain->lock);
diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index a4baa61..5b06769 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -2141,7 +2141,7 @@ static int isp_probe(struct platform_device *pdev)
 	/* to be removed once iommu migration is complete */
 	isp->iommu = to_iommu(isp->iommu_dev);
 
-	isp->domain = iommu_domain_alloc();
+	isp->domain = iommu_domain_alloc(NULL);
 	if (!isp->domain) {
 		dev_err(isp->dev, "can't alloc iommu domain\n");
 		ret = -ENOMEM;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9940319..3cbea04 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -26,9 +26,27 @@
 #define IOMMU_CACHE	(4) /* DMA cache coherency */
 
 struct device;
+struct iommu_domain;
+
+/**
+ * enum iommu_fault_types - iommu fault types
+ *
+ * @IOMMU_ERROR: Unrecoverable error
+ * @IOMMU_TLBMISS: TLB miss while the page table walker is disabled
+ * @IOMMU_NOPTE: TLB miss and no PTE for the requested address
+ */
+enum iommu_fault_types {
+	IOMMU_ERROR,
+	IOMMU_TLBMISS,
+	IOMMU_NOPTE,
+};
+
+typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
+				struct device *, unsigned long, int);
 
 struct iommu_domain {
 	void *priv;
+	iommu_fault_handler_t handler;
 };
 
 #define IOMMU_CAP_CACHE_COHERENCY	0x1
@@ -53,7 +71,7 @@ struct iommu_ops {
 
 extern void register_iommu(struct iommu_ops *ops);
 extern bool iommu_found(void);
-extern struct iommu_domain *iommu_domain_alloc(void);
+extern struct iommu_domain *iommu_domain_alloc(iommu_fault_handler_t handler);
 extern void iommu_domain_free(struct iommu_domain *domain);
 extern int iommu_attach_device(struct iommu_domain *domain,
 			       struct device *dev);
@@ -68,6 +86,40 @@ extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 extern int iommu_domain_has_cap(struct iommu_domain *domain,
 				unsigned long cap);
 
+/**
+ * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
+ * @domain: the iommu domain where the fault has happened
+ * @dev: the device where the fault has happened
+ * @iova: the faulting address
+ * @event: the mmu fault type
+ *
+ * This function should be called by the low-level IOMMU implementations
+ * whenever IOMMU faults happen, to allow high-level users, that are
+ * interested in such events, to know about them.
+ *
+ * This event may be useful in case the device, generating the fault,
+ * needs to be restarted before it can be used again (e.g. this device
+ * may be a remote processor), or if dynamic TLB/PTE loading is desired.
+ *
+ * Returns 0 on success and an appropriate error code otherwise (if dynamic
+ * PTE/TLB loading will one day be supported, implementations will be able
+ * to tell whether it succeeded or not according to this return value).
+ */
+static inline int report_iommu_fault(struct iommu_domain *domain,
+		struct device *dev, unsigned long iova, int event)
+{
+	int ret = 0;
+
+	/*
+	 * if upper layers showed interest and installed a fault handler,
+	 * invoke it.
+	 */
+	if (domain->handler)
+		ret = domain->handler(domain, dev, iova, event);
+
+	return ret;
+}
+
 #else /* CONFIG_IOMMU_API */
 
 static inline void register_iommu(struct iommu_ops *ops)
@@ -123,6 +175,12 @@ static inline int domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
+static inline int report_iommu_fault(struct iommu_domain *domain,
+			struct device *dev, unsigned long iova, int event)
+{
+	return 0;
+}
+
 #endif /* CONFIG_IOMMU_API */
 
 #endif /* __LINUX_IOMMU_H */
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 78c80f6..2fd67e5 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -233,7 +233,7 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 		return -ENODEV;
 	}
 
-	kvm->arch.iommu_domain = iommu_domain_alloc();
+	kvm->arch.iommu_domain = iommu_domain_alloc(NULL);
 	if (!kvm->arch.iommu_domain)
 		return -ENOMEM;
 
-- 
1.7.4.1

