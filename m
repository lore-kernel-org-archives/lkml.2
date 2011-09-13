Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab1IMT02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 15:26:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39525 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab1IMT01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 15:26:27 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 1/2] iommu/core: add fault reporting mechanism
Date: Tue, 13 Sep 2011 22:25:23 +0300
Message-Id: <1315941923-17145-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
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

A dedicated iommu_set_fault_handler() API has been added to allow
users, who are interested to receive such reports, to provide
their handler.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
v1->v2: remove 'event' parameter

 drivers/iommu/iommu.c |   13 ++++++++++++
 include/linux/iommu.h |   51 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index e61a9ba..c68ff29 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -40,6 +40,19 @@ bool iommu_found(void)
 }
 EXPORT_SYMBOL_GPL(iommu_found);
 
+/**
+ * iommu_domain_alloc() - set a fault handler for an iommu domain
+ * @domain: iommu domain
+ * @handler: fault handler
+ */
+void iommu_set_fault_handler(struct iommu_domain *domain,
+					iommu_fault_handler_t handler)
+{
+	BUG_ON(!domain);
+
+	domain->handler = handler;
+}
+
 struct iommu_domain *iommu_domain_alloc(void)
 {
 	struct iommu_domain *domain;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9940319..d084e87 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -26,9 +26,18 @@
 #define IOMMU_CACHE	(4) /* DMA cache coherency */
 
 struct device;
+struct iommu_domain;
+
+/* iommu fault flags */
+#define IOMMU_FAULT_READ	0x0
+#define IOMMU_FAULT_WRITE	0x1
+
+typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
+				struct device *, unsigned long, int);
 
 struct iommu_domain {
 	void *priv;
+	iommu_fault_handler_t handler;
 };
 
 #define IOMMU_CAP_CACHE_COHERENCY	0x1
@@ -67,6 +76,43 @@ extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 				      unsigned long iova);
 extern int iommu_domain_has_cap(struct iommu_domain *domain,
 				unsigned long cap);
+extern void iommu_set_fault_handler(struct iommu_domain *domain,
+					iommu_fault_handler_t handler);
+
+/**
+ * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
+ * @domain: the iommu domain where the fault has happened
+ * @dev: the device where the fault has happened
+ * @iova: the faulting address
+ * @flags: mmu fault flags (e.g. IOMMU_FAULT_READ/IOMMU_FAULT_WRITE/...)
+ *
+ * This function should be called by the low-level IOMMU implementations
+ * whenever IOMMU faults happen, to allow high-level users, that are
+ * interested in such events, to know about them.
+ *
+ * This event may be useful for several possible use cases:
+ * - mere logging of the event
+ * - dynamic TLB/PTE loading
+ * - if restarting of the faulting device is required
+ *
+ * Returns 0 on success and an appropriate error code otherwise (if dynamic
+ * PTE/TLB loading will one day be supported, implementations will be able
+ * to tell whether it succeeded or not according to this return value).
+ */
+static inline int report_iommu_fault(struct iommu_domain *domain,
+		struct device *dev, unsigned long iova, int flags)
+{
+	int ret = 0;
+
+	/*
+	 * if upper layers showed interest and installed a fault handler,
+	 * invoke it.
+	 */
+	if (domain->handler)
+		ret = domain->handler(domain, dev, iova, flags);
+
+	return ret;
+}
 
 #else /* CONFIG_IOMMU_API */
 
@@ -123,6 +169,11 @@ static inline int domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
+static inline void iommu_set_fault_handler(struct iommu_domain *domain,
+					iommu_fault_handler_t handler)
+{
+}
+
 #endif /* CONFIG_IOMMU_API */
 
 #endif /* __LINUX_IOMMU_H */
-- 
1.7.4.1

