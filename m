Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab1IGSye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:54:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35099 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1IGSyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:54:31 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 2/3] iommu/omap: migrate to the generic fault report mechanism
Date: Wed,  7 Sep 2011 21:53:23 +0300
Message-Id: <1315421604-12286-2-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315421604-12286-1-git-send-email-ohad@wizery.com>
References: <1315421604-12286-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start using the generic fault report mechanism, as provided by
the IOMMU core, and remove the now-redundant omap_iommu_set_isr API.

Always use the generic IOMMU_ERROR event type as we're only interested
in letting upper layers know about the error, so in case the faulting
device is a remote processor, they could restart it.

Dynamic PTE/TLB loading is not supported.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/plat-omap/include/plat/iommu.h |    3 +--
 drivers/iommu/omap-iommu.c              |   31 +++----------------------------
 2 files changed, 4 insertions(+), 30 deletions(-)

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
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index bd5f606..ef70a08 100644
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
+	if (!report_iommu_fault(domain, obj->dev, da, 0, IOMMU_ERROR))
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
-- 
1.7.4.1

