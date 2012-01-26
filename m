Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab2AZSlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:41:23 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:50552
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753492Ab2AZSlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:41:10 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dhc1bhc31hc1ah668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYF58G-02-HLC-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/6] iommu: Add domain-attribute handlers
Date: Thu, 26 Jan 2012 19:40:52 +0100
Message-ID: <1327603257-17028-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com>
References: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com>
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
 2 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2198b2d..ef54718 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -341,3 +341,23 @@ int iommu_device_group(struct device *dev, unsigned int *groupid)
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
index d937580..8b66e84 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -46,6 +46,10 @@ struct iommu_domain {
 #define IOMMU_CAP_CACHE_COHERENCY	0x1
 #define IOMMU_CAP_INTR_REMAP		0x2	/* isolates device intrs */
 
+enum iommu_attr {
+	DOMAIN_ATTR_MAX,
+};
+
 #ifdef CONFIG_IOMMU_API
 
 /**
@@ -58,7 +62,8 @@ struct iommu_domain {
  * @unmap: unmap a physically contiguous memory region from an iommu domain
  * @iova_to_phys: translate iova to physical address
  * @domain_has_cap: domain capabilities query
- * @commit: commit iommu domain
+ * @domain_get_attr: Query domain attributes
+ * @domain_set_attr: Change domain attributes
  * @pgsize_bitmap: bitmap of supported page sizes
  */
 struct iommu_ops {
@@ -75,6 +80,10 @@ struct iommu_ops {
 	int (*domain_has_cap)(struct iommu_domain *domain,
 			      unsigned long cap);
 	int (*device_group)(struct device *dev, unsigned int *groupid);
+	int (*domain_get_attr)(struct iommu_domain *domain,
+			       enum iommu_attr attr, void *data);
+	int (*domain_set_attr)(struct iommu_domain *domain,
+			       enum iommu_attr attr, void *data);
 	unsigned long pgsize_bitmap;
 };
 
@@ -98,6 +107,11 @@ extern void iommu_set_fault_handler(struct iommu_domain *domain,
 					iommu_fault_handler_t handler);
 extern int iommu_device_group(struct device *dev, unsigned int *groupid);
 
+extern int iommu_domain_get_attr(struct iommu_domain *domain, enum iommu_attr,
+				 void *data);
+extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
+				 void *data);
+
 /**
  * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
  * @domain: the iommu domain where the fault has happened
@@ -200,6 +214,18 @@ static inline int iommu_device_group(struct device *dev, unsigned int *groupid)
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
1.7.5.4


