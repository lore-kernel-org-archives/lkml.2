Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2DBVPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:15:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab2DBVPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:15:08 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 3/3] iommu: Create attach/detach group interface
To: david@gibson.dropbear.id.au, dwmw2@infradead.org
Cc: alex.williamson@redhat.com, iommu@lists.linux-foundation.org,
        qemu-devel@nongnu.org, joerg.roedel@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 02 Apr 2012 15:14:55 -0600
Message-ID: <20120402211454.28977.32677.stgit@bling.home>
In-Reply-To: <20120402203721.28977.95285.stgit@bling.home>
References: <20120402203721.28977.95285.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU ops should be working at a group level rather than a device
level as we cannot arbitrarily assign devices from the same group
to different domains.  For now this is just a simple wrapper that
makes use of the dma_dev within a group.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/iommu.c |   12 ++++++++++++
 include/linux/iommu.h |   15 +++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 6a51ed9..af77da1 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -327,6 +327,18 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_detach_device);
 
+int iommu_attach_group(struct iommu_domain *domain, struct iommu_group *group)
+{
+	return iommu_attach_device(domain, group->dma_dev);
+}
+EXPORT_SYMBOL_GPL(iommu_attach_group);
+
+void iommu_detach_group(struct iommu_domain *domain, struct iommu_group *group)
+{
+	iommu_detach_device(domain, group->dma_dev);
+}
+EXPORT_SYMBOL_GPL(iommu_detach_group);
+
 phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 			       unsigned long iova)
 {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 24004d6..d4e9a7a 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -107,6 +107,10 @@ extern int iommu_attach_device(struct iommu_domain *domain,
 			       struct device *dev);
 extern void iommu_detach_device(struct iommu_domain *domain,
 				struct device *dev);
+extern int iommu_attach_group(struct iommu_domain *domain,
+			      struct iommu_group *group);
+extern void iommu_detach_group(struct iommu_domain *domain,
+			       struct iommu_group *group);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		     phys_addr_t paddr, size_t size, int prot);
 extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
@@ -194,6 +198,17 @@ static inline void iommu_detach_device(struct iommu_domain *domain,
 {
 }
 
+static inline int iommu_attach_group(struct iommu_domain *domain,
+				     struct iommu_group *group)
+{
+	return -ENODEV;
+}
+
+static inline void iommu_detach_group(struct iommu_domain *domain,
+				      struct iommu_group *group)
+{
+}
+
 static inline int iommu_map(struct iommu_domain *domain, unsigned long iova,
 			    phys_addr_t paddr, int gfp_order, int prot)
 {

