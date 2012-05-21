Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab2EURUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:20:36 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50911 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab2EURUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:20:34 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Joerg Roedel <Joerg.Roedel@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCH] iommu/core: pass a user-provided token to fault handlers
Date: Mon, 21 May 2012 20:20:05 +0300
Message-Id: <1337620805-30217-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes a single IOMMU user may have to deal with several
different IOMMU devices (e.g. remoteproc).

When an IOMMU fault happens, such users have to regain their
context in order to deal with the fault.

Users can't use the private fields of neither the iommu_domain nor
the IOMMU device, because those are already used by the IOMMU core
and low level driver (respectively).

This patch just simply allows users to pass a private token (most
notably their own context pointer) to iommu_set_fault_handler(),
and then makes sure it is provided back to the users whenever
an IOMMU fault happens.

The patch also adopts remoteproc to the new fault handling
interface, but the real functionality using this (recovery of
remote processors) will only be added later in a subsequent patch
set.

Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/iommu/iommu.c                |    5 ++++-
 drivers/remoteproc/remoteproc_core.c |    4 ++--
 include/linux/iommu.h                |   10 ++++++----
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2198b2d..8b9ded8 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -119,6 +119,7 @@ EXPORT_SYMBOL_GPL(iommu_present);
  * iommu_set_fault_handler() - set a fault handler for an iommu domain
  * @domain: iommu domain
  * @handler: fault handler
+ * @token: user data, will be passed back to the fault handler
  *
  * This function should be used by IOMMU users which want to be notified
  * whenever an IOMMU fault happens.
@@ -127,11 +128,13 @@ EXPORT_SYMBOL_GPL(iommu_present);
  * error code otherwise.
  */
 void iommu_set_fault_handler(struct iommu_domain *domain,
-					iommu_fault_handler_t handler)
+					iommu_fault_handler_t handler,
+					void *token)
 {
 	BUG_ON(!domain);
 
 	domain->handler = handler;
+	domain->handler_token = token;
 }
 EXPORT_SYMBOL_GPL(iommu_set_fault_handler);
 
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index ee15c68..f71d07e 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -78,7 +78,7 @@ typedef int (*rproc_handle_resource_t)(struct rproc *rproc, void *, int avail);
  * the recovery of the remote processor.
  */
 static int rproc_iommu_fault(struct iommu_domain *domain, struct device *dev,
-		unsigned long iova, int flags)
+		unsigned long iova, int flags, void *token)
 {
 	dev_err(dev, "iommu fault: da 0x%lx flags 0x%x\n", iova, flags);
 
@@ -117,7 +117,7 @@ static int rproc_enable_iommu(struct rproc *rproc)
 		return -ENOMEM;
 	}
 
-	iommu_set_fault_handler(domain, rproc_iommu_fault);
+	iommu_set_fault_handler(domain, rproc_iommu_fault, rproc);
 
 	ret = iommu_attach_device(domain, dev);
 	if (ret) {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d937580..450293f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -35,12 +35,13 @@ struct iommu_domain;
 #define IOMMU_FAULT_WRITE	0x1
 
 typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
-				struct device *, unsigned long, int);
+			struct device *, unsigned long, int, void *);
 
 struct iommu_domain {
 	struct iommu_ops *ops;
 	void *priv;
 	iommu_fault_handler_t handler;
+	void *handler_token;
 };
 
 #define IOMMU_CAP_CACHE_COHERENCY	0x1
@@ -95,7 +96,7 @@ extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 extern int iommu_domain_has_cap(struct iommu_domain *domain,
 				unsigned long cap);
 extern void iommu_set_fault_handler(struct iommu_domain *domain,
-					iommu_fault_handler_t handler);
+			iommu_fault_handler_t handler, void *token);
 extern int iommu_device_group(struct device *dev, unsigned int *groupid);
 
 /**
@@ -132,7 +133,8 @@ static inline int report_iommu_fault(struct iommu_domain *domain,
 	 * invoke it.
 	 */
 	if (domain->handler)
-		ret = domain->handler(domain, dev, iova, flags);
+		ret = domain->handler(domain, dev, iova, flags,
+						domain->handler_token);
 
 	return ret;
 }
@@ -191,7 +193,7 @@ static inline int domain_has_cap(struct iommu_domain *domain,
 }
 
 static inline void iommu_set_fault_handler(struct iommu_domain *domain,
-					iommu_fault_handler_t handler)
+				iommu_fault_handler_t handler, void *token)
 {
 }
 
-- 
1.7.5.4

