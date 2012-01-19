Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2ASOaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:30:35 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:58068
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753315Ab2ASOaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:30:21 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dhc1bhc31hc1ah668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LY1UY7-02-CVU-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Date: Thu, 19 Jan 2012 15:30:02 +0100
Message-ID: <1326983405-319-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the attribute itself and add the code for the
AMD IOMMU driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |    4 ++++
 drivers/iommu/iommu.c     |   19 ++++++++++++++++---
 include/linux/iommu.h     |   11 ++++++++++-
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index cce1f03..421c3e6 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3030,6 +3030,10 @@ static int amd_iommu_domain_init(struct iommu_domain *dom)
 
 	dom->priv = domain;
 
+	dom->geometry.aperture_start = 0;
+	dom->geometry.aperture_end   = ~0ULL;
+	dom->geometry.force_aperture = true;
+
 	return 0;
 
 out_free:
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ef54718..3d0b0bf 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -345,10 +345,23 @@ EXPORT_SYMBOL_GPL(iommu_device_group);
 int iommu_domain_get_attr(struct iommu_domain *domain,
 			  enum iommu_attr attr, void *data)
 {
-	if (!domain->ops->domain_get_attr)
-		return -EINVAL;
+	struct iommu_domain_geometry *geometry;
+	int ret = 0;
+
+	switch (attr) {
+	case DOMAIN_ATTR_GEOMETRY:
+		geometry  = data;
+		*geometry = domain->geometry;
+
+		break;
+	default:
+		if (!domain->ops->domain_get_attr)
+			return -EINVAL;
 
-	return domain->ops->domain_get_attr(domain, attr, data);
+		ret = domain->ops->domain_get_attr(domain, attr, data);
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_domain_get_attr);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 32d0de1..3f971b3 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -37,16 +37,24 @@ struct iommu_domain;
 typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
 				struct device *, unsigned long, int);
 
+struct iommu_domain_geometry {
+	u64 aperture_start;	/* First address that can be mapped    */
+	u64 aperture_end;	/* Last address that can be mapped     */
+	bool force_aperture;	/* DMA only allowed in mappable range? */
+};
+
 struct iommu_domain {
 	struct iommu_ops *ops;
 	void *priv;
 	iommu_fault_handler_t handler;
+	struct iommu_domain_geometry geometry;
 };
 
 #define IOMMU_CAP_CACHE_COHERENCY	0x1
 #define IOMMU_CAP_INTR_REMAP		0x2	/* isolates device intrs */
 
 enum iommu_attr {
+	DOMAIN_ATTR_GEOMETRY,	/* struct iommu_domain_geometry */
 	DOMAIN_ATTR_MAX,
 };
 
@@ -62,7 +70,8 @@ enum iommu_attr {
  * @unmap: unmap a physically contiguous memory region from an iommu domain
  * @iova_to_phys: translate iova to physical address
  * @domain_has_cap: domain capabilities query
- * @commit: commit iommu domain
+ * @domain_get_attr: Query domain attributes
+ * @domain_set_attr: Change domain attributes
  * @pgsize_bitmap: bitmap of supported page sizes
  */
 struct iommu_ops {
-- 
1.7.5.4


