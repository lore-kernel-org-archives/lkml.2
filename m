Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1FBWcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:32:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35943 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1FBWbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:31:07 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: <laurent.pinchart@ideasonboard.com>, <Hiroshi.DOYU@nokia.com>,
        <arnd@arndb.de>, <davidb@codeaurora.org>, <Joerg.Roedel@amd.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 3/6] media: omap3isp: generic iommu api migration
Date: Fri,  3 Jun 2011 01:27:40 +0300
Message-Id: <1307053663-24572-4-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307053663-24572-1-git-send-email-ohad@wizery.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First step towards migrating omap3isp to the generic iommu api.

At this point we still need a handle of the omap-specific iommu, mainly
because we highly depend on omap's iovmm.

Migration will be fully completed only once omap's iovmm will be generalized
(or replaced by a generic virtual memory manager framework).

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/media/video/omap3isp/isp.c      |   41 +++++++++++++++++++++++++-----
 drivers/media/video/omap3isp/isp.h      |    3 ++
 drivers/media/video/omap3isp/ispccdc.c  |   16 ++++++------
 drivers/media/video/omap3isp/ispstat.c  |    6 ++--
 drivers/media/video/omap3isp/ispvideo.c |    4 +-
 5 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 897a1cf..25bade9 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -80,6 +80,13 @@
 #include "isph3a.h"
 #include "isphist.h"
 
+/*
+ * this is provided as an interim solution until omap3isp doesn't need
+ * any omap-specific iommu API
+ */
+#define to_iommu(dev)							\
+	(struct iommu *)platform_get_drvdata(to_platform_device(dev))
+
 static unsigned int autoidle;
 module_param(autoidle, int, 0444);
 MODULE_PARM_DESC(autoidle, "Enable OMAP3ISP AUTOIDLE support");
@@ -1975,7 +1982,8 @@ static int isp_remove(struct platform_device *pdev)
 	isp_cleanup_modules(isp);
 
 	omap3isp_get(isp);
-	iommu_put(isp->iommu);
+	iommu_detach_device(isp->domain, isp->iommu_dev);
+	iommu_domain_free(isp->domain);
 	omap3isp_put(isp);
 
 	free_irq(isp->irq_num, isp);
@@ -2123,25 +2131,41 @@ static int isp_probe(struct platform_device *pdev)
 	}
 
 	/* IOMMU */
-	isp->iommu = iommu_get("isp");
-	if (IS_ERR_OR_NULL(isp->iommu)) {
-		isp->iommu = NULL;
+	isp->iommu_dev = omap_find_iommu_device("isp");
+	if (!isp->iommu_dev) {
+		dev_err(isp->dev, "omap_find_iommu_device failed\n");
 		ret = -ENODEV;
 		goto error_isp;
 	}
 
+	/* to be removed once iommu migration is complete */
+	isp->iommu = to_iommu(isp->iommu_dev);
+
+	isp->domain = iommu_domain_alloc();
+	if (!isp->domain) {
+		dev_err(isp->dev, "can't alloc iommu domain\n");
+		ret = -ENOMEM;
+		goto error_isp;
+	}
+
+	ret = iommu_attach_device(isp->domain, isp->iommu_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "can't attach iommu device: %d\n", ret);
+		goto free_domain;
+	}
+
 	/* Interrupt */
 	isp->irq_num = platform_get_irq(pdev, 0);
 	if (isp->irq_num <= 0) {
 		dev_err(isp->dev, "No IRQ resource\n");
 		ret = -ENODEV;
-		goto error_isp;
+		goto detach_dev;
 	}
 
 	if (request_irq(isp->irq_num, isp_isr, IRQF_SHARED, "OMAP3 ISP", isp)) {
 		dev_err(isp->dev, "Unable to request IRQ\n");
 		ret = -EINVAL;
-		goto error_isp;
+		goto detach_dev;
 	}
 
 	/* Entities */
@@ -2162,8 +2186,11 @@ error_modules:
 	isp_cleanup_modules(isp);
 error_irq:
 	free_irq(isp->irq_num, isp);
+detach_dev:
+	iommu_detach_device(isp->domain, isp->iommu_dev);
+free_domain:
+	iommu_domain_free(isp->domain);
 error_isp:
-	iommu_put(isp->iommu);
 	omap3isp_put(isp);
 error:
 	isp_put_clocks(isp);
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 2620c40..1b54aa4 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -32,6 +32,7 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/wait.h>
+#include <linux/iommu.h>
 #include <plat/iommu.h>
 #include <plat/iovmm.h>
 
@@ -289,6 +290,8 @@ struct isp_device {
 	unsigned int subclk_resources;
 
 	struct iommu *iommu;
+	struct iommu_domain *domain;
+	struct device *iommu_dev;
 
 	struct isp_platform_callback platform_cb;
 };
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 39d501b..b59b06f 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -365,7 +365,7 @@ static void ccdc_lsc_free_request(struct isp_ccdc_device *ccdc,
 		dma_unmap_sg(isp->dev, req->iovm->sgt->sgl,
 			     req->iovm->sgt->nents, DMA_TO_DEVICE);
 	if (req->table)
-		iommu_vfree(isp->iommu, req->table);
+		iommu_vfree(isp->domain, isp->iommu, req->table);
 	kfree(req);
 }
 
@@ -437,8 +437,8 @@ static int ccdc_lsc_config(struct isp_ccdc_device *ccdc,
 
 		req->enable = 1;
 
-		req->table = iommu_vmalloc(isp->iommu, 0, req->config.size,
-					   IOMMU_FLAG);
+		req->table = iommu_vmalloc(isp->domain, isp->iommu, 0,
+					req->config.size, IOMMU_FLAG);
 		if (IS_ERR_VALUE(req->table)) {
 			req->table = 0;
 			ret = -ENOMEM;
@@ -733,15 +733,15 @@ static int ccdc_config(struct isp_ccdc_device *ccdc,
 			 * already done by iommu_vmalloc().
 			 */
 			size = ccdc->fpc.fpnum * 4;
-			table_new = iommu_vmalloc(isp->iommu, 0, size,
-						  IOMMU_FLAG);
+			table_new = iommu_vmalloc(isp->domain, isp->iommu, 0,
+							size, IOMMU_FLAG);
 			if (IS_ERR_VALUE(table_new))
 				return -ENOMEM;
 
 			if (copy_from_user(da_to_va(isp->iommu, table_new),
 					   (__force void __user *)
 					   ccdc->fpc.fpcaddr, size)) {
-				iommu_vfree(isp->iommu, table_new);
+				iommu_vfree(isp->domain, isp->iommu, table_new);
 				return -EFAULT;
 			}
 
@@ -751,7 +751,7 @@ static int ccdc_config(struct isp_ccdc_device *ccdc,
 
 		ccdc_configure_fpc(ccdc);
 		if (table_old != 0)
-			iommu_vfree(isp->iommu, table_old);
+			iommu_vfree(isp->domain, isp->iommu, table_old);
 	}
 
 	return ccdc_lsc_config(ccdc, ccdc_struct);
@@ -2287,5 +2287,5 @@ void omap3isp_ccdc_cleanup(struct isp_device *isp)
 	ccdc_lsc_free_queue(ccdc, &ccdc->lsc.free_queue);
 
 	if (ccdc->fpc.fpcaddr != 0)
-		iommu_vfree(isp->iommu, ccdc->fpc.fpcaddr);
+		iommu_vfree(isp->domain, isp->iommu, ccdc->fpc.fpcaddr);
 }
diff --git a/drivers/media/video/omap3isp/ispstat.c b/drivers/media/video/omap3isp/ispstat.c
index b44cb68..afb7d78 100644
--- a/drivers/media/video/omap3isp/ispstat.c
+++ b/drivers/media/video/omap3isp/ispstat.c
@@ -366,7 +366,7 @@ static void isp_stat_bufs_free(struct ispstat *stat)
 				dma_unmap_sg(isp->dev, buf->iovm->sgt->sgl,
 					     buf->iovm->sgt->nents,
 					     DMA_FROM_DEVICE);
-			iommu_vfree(isp->iommu, buf->iommu_addr);
+			iommu_vfree(isp->domain, isp->iommu, buf->iommu_addr);
 		} else {
 			if (!buf->virt_addr)
 				continue;
@@ -399,8 +399,8 @@ static int isp_stat_bufs_alloc_iommu(struct ispstat *stat, unsigned int size)
 		struct iovm_struct *iovm;
 
 		WARN_ON(buf->dma_addr);
-		buf->iommu_addr = iommu_vmalloc(isp->iommu, 0, size,
-						IOMMU_FLAG);
+		buf->iommu_addr = iommu_vmalloc(isp->domain, isp->iommu, 0,
+							size, IOMMU_FLAG);
 		if (IS_ERR((void *)buf->iommu_addr)) {
 			dev_err(stat->isp->dev,
 				 "%s: Can't acquire memory for "
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 9cd8f1a..7bc7986 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -446,7 +446,7 @@ ispmmu_vmap(struct isp_device *isp, const struct scatterlist *sglist, int sglen)
 	sgt->nents = sglen;
 	sgt->orig_nents = sglen;
 
-	da = iommu_vmap(isp->iommu, 0, sgt, IOMMU_FLAG);
+	da = iommu_vmap(isp->domain, isp->iommu, 0, sgt, IOMMU_FLAG);
 	if (IS_ERR_VALUE(da))
 		kfree(sgt);
 
@@ -462,7 +462,7 @@ static void ispmmu_vunmap(struct isp_device *isp, dma_addr_t da)
 {
 	struct sg_table *sgt;
 
-	sgt = iommu_vunmap(isp->iommu, (u32)da);
+	sgt = iommu_vunmap(isp->domain, isp->iommu, (u32)da);
 	kfree(sgt);
 }
 
-- 
1.7.1

