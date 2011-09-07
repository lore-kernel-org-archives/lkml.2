Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab1IGQ3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:29:17 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:52632
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765Ab1IGQ3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:29:10 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR5SY1-01-4FL-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, <joro@8bytes.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/10] iommu/core: Use bus->iommu_ops in the iommu-api
Date: Wed, 7 Sep 2011 17:41:48 +0200
Message-ID: <1315410113-26608-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the per-bus iommu-ops in the functions of the iommu-api
instead of the global iommu_ops.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/iommu.c |   34 +++++++++++++++++++++++++++-------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2270127..f2ced4c 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -83,34 +83,48 @@ EXPORT_SYMBOL_GPL(iommu_domain_alloc);
 
 void iommu_domain_free(struct iommu_domain *domain)
 {
-	iommu_ops->domain_destroy(domain);
+	if (likely(domain->ops->domain_destroy != NULL))
+		domain->ops->domain_destroy(domain);
+
 	kfree(domain);
 }
 EXPORT_SYMBOL_GPL(iommu_domain_free);
 
 int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 {
-	return iommu_ops->attach_dev(domain, dev);
+	if (unlikely(domain->ops->attach_dev == NULL))
+		return -ENODEV;
+
+	return domain->ops->attach_dev(domain, dev);
 }
 EXPORT_SYMBOL_GPL(iommu_attach_device);
 
 void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 {
-	iommu_ops->detach_dev(domain, dev);
+	if (unlikely(domain->ops->detach_dev == NULL))
+		return;
+
+	domain->ops->detach_dev(domain, dev);
 }
 EXPORT_SYMBOL_GPL(iommu_detach_device);
 
 phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 			       unsigned long iova)
 {
-	return iommu_ops->iova_to_phys(domain, iova);
+	if (unlikely(domain->ops->iova_to_phys == NULL))
+		return 0;
+
+	return domain->ops->iova_to_phys(domain, iova);
 }
 EXPORT_SYMBOL_GPL(iommu_iova_to_phys);
 
 int iommu_domain_has_cap(struct iommu_domain *domain,
 			 unsigned long cap)
 {
-	return iommu_ops->domain_has_cap(domain, cap);
+	if (unlikely(domain->ops->domain_has_cap == NULL))
+		return 0;
+
+	return domain->ops->domain_has_cap(domain, cap);
 }
 EXPORT_SYMBOL_GPL(iommu_domain_has_cap);
 
@@ -119,11 +133,14 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 {
 	size_t size;
 
+	if (unlikely(domain->ops->map == NULL))
+		return -ENODEV;
+
 	size         = PAGE_SIZE << gfp_order;
 
 	BUG_ON(!IS_ALIGNED(iova | paddr, size));
 
-	return iommu_ops->map(domain, iova, paddr, gfp_order, prot);
+	return domain->ops->map(domain, iova, paddr, gfp_order, prot);
 }
 EXPORT_SYMBOL_GPL(iommu_map);
 
@@ -131,10 +148,13 @@ int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
 {
 	size_t size;
 
+	if (unlikely(domain->ops->unmap == NULL))
+		return -ENODEV;
+
 	size         = PAGE_SIZE << gfp_order;
 
 	BUG_ON(!IS_ALIGNED(iova, size));
 
-	return iommu_ops->unmap(domain, iova, gfp_order);
+	return domain->ops->unmap(domain, iova, gfp_order);
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
-- 
1.7.4.1


