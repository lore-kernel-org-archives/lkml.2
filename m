Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab2GKKuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:50:19 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:54436
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757203Ab2GKKt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:49:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M6ZSQA-02-212-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/7] iommu: Add domain-attribute handlers
Date: Wed, 11 Jul 2012 12:49:17 +0200
Message-ID: <1342003763-8139-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342003763-8139-1-git-send-email-joerg.roedel@amd.com>
References: <1342003763-8139-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces an extension to the iommu-api to get
and set attributes for an iommu_domain. Two functions are
introduced for this:

	* iommu_domain_get_attr()
	* iommu_domain_set_attr()

These functions will be used to make the iommu-api suitable
for GART-like IOMMUs and to implement hardware-specifc
api-extensions.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/iommu.c |   20 ++++++++++++++++++++
 include/linux/iommu.h |   28 +++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 8b9ded8..c39972d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -344,3 +344,23 @@ int iommu_device_group(struct device *dev, unsigned int *groupid)
 	return -ENODEV;
 }
 EXPORT_SYMBOL_GPL(iommu_device_group);
+
+int iommu_domain_get_attr(struct iommu_domain *domain,
+			  enum iommu_attr attr, void *data)
+{
+	if (!domain->ops->domain_get_attr)
+		return -EINVAL;
+
+	return domain->ops->domain_get_attr(domain, attr, data);
+}
+EXPORT_SYMBOL_GPL(iommu_domain_get_attr);
+
+int iommu_domain_set_attr(struct iommu_domain *domain,
+			  enum iommu_attr attr, void *data)
+{
+	if (!domain->ops->domain_set_attr)
+		return -EINVAL;
+
+	return domain->ops->domain_set_attr(domain, attr, data);
+}
+EXPORT_SYMBOL_GPL(iommu_domain_set_attr);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 450293f..0eef096 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -47,6 +47,10 @@ struct iommu_domain {
 #define IOMMU_CAP_CACHE_COHERENCY	0x1
 #define IOMMU_CAP_INTR_REMAP		0x2	/* isolates device intrs */
 
+enum iommu_attr {
+	DOMAIN_ATTR_MAX,
+};
+
 #ifdef CONFIG_IOMMU_API
 
 /**
@@ -59,7 +63,8 @@ struct iommu_domain {
  * @unmap: unmap a physically contiguous memory region from an iommu domain
  * @iova_to_phys: translate iova to physical address
  * @domain_has_cap: domain capabilities query
- * @commit: commit iommu domain
+ * @domain_get_attr: Query domain attributes
+ * @domain_set_attr: Change domain attributes
  * @pgsize_bitmap: bitmap of supported page sizes
  */
 struct iommu_ops {
@@ -76,6 +81,10 @@ struct iommu_ops {
 	int (*domain_has_cap)(struct iommu_domain *domain,
 			      unsigned long cap);
 	int (*device_group)(struct device *dev, unsigned int *groupid);
+	int (*domain_get_attr)(struct iommu_domain *domain,
+			       enum iommu_attr attr, void *data);
+	int (*domain_set_attr)(struct iommu_domain *domain,
+			       enum iommu_attr attr, void *data);
 	unsigned long pgsize_bitmap;
 };
 
@@ -99,6 +108,11 @@ extern void iommu_set_fault_handler(struct iommu_domain *domain,
 			iommu_fault_handler_t handler, void *token);
 extern int iommu_device_group(struct device *dev, unsigned int *groupid);
 
+extern int iommu_domain_get_attr(struct iommu_domain *domain, enum iommu_attr,
+				 void *data);
+extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
+				 void *data);
+
 /**
  * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
  * @domain: the iommu domain where the fault has happened
@@ -202,6 +216,18 @@ static inline int iommu_device_group(struct device *dev, unsigned int *groupid)
 	return -ENODEV;
 }
 
+static inline int iommu_domain_get_attr(struct iommu_domain *domain,
+					enum iommu_attr attr, void *data)
+{
+	return -EINVAL;
+}
+
+static inline int iommu_domain_set_attr(struct iommu_domain *domain,
+					enum iommu_attr attr, void *data)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_IOMMU_API */
 
 #endif /* __LINUX_IOMMU_H */
-- 
1.7.9.5


