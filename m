Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2IYHCC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:02:02 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47188 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2IYHCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:02:00 -0400
Date: Tue, 25 Sep 2012 10:01:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/3] remoteproc: memory leak in rproc_handle_carveout()
Message-ID: <20120925070156.GB23009@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only need to allocate mapping if there is an rproc domain.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker stuff.  Handle with appropriate caution.

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index b6c6229..f163704 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -573,17 +573,10 @@ static int rproc_handle_carveout(struct rproc *rproc,
 	dev_dbg(dev, "carveout rsc: da %x, pa %x, len %x, flags %x\n",
 			rsc->da, rsc->pa, rsc->len, rsc->flags);
 
-	mapping = kzalloc(sizeof(*mapping), GFP_KERNEL);
-	if (!mapping) {
-		dev_err(dev, "kzalloc mapping failed\n");
-		return -ENOMEM;
-	}
-
 	carveout = kzalloc(sizeof(*carveout), GFP_KERNEL);
 	if (!carveout) {
 		dev_err(dev, "kzalloc carveout failed\n");
-		ret = -ENOMEM;
-		goto free_mapping;
+		return -ENOMEM;
 	}
 
 	va = dma_alloc_coherent(dev->parent, rsc->len, &dma, GFP_KERNEL);
@@ -613,11 +606,18 @@ static int rproc_handle_carveout(struct rproc *rproc,
 	 * physical address in this case.
 	 */
 	if (rproc->domain) {
+		mapping = kzalloc(sizeof(*mapping), GFP_KERNEL);
+		if (!mapping) {
+			dev_err(dev, "kzalloc mapping failed\n");
+			ret = -ENOMEM;
+			goto dma_free;
+		}
+
 		ret = iommu_map(rproc->domain, rsc->da, dma, rsc->len,
 								rsc->flags);
 		if (ret) {
 			dev_err(dev, "iommu_map failed: %d\n", ret);
-			goto dma_free;
+			goto free_mapping;
 		}
 
 		/*
@@ -662,12 +662,12 @@ static int rproc_handle_carveout(struct rproc *rproc,
 
 	return 0;
 
+free_mapping:
+	kfree(mapping);
 dma_free:
 	dma_free_coherent(dev->parent, rsc->len, va, dma);
 free_carv:
 	kfree(carveout);
-free_mapping:
-	kfree(mapping);
 	return ret;
 }
 
