Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638Ab1FWPcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:32:14 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:33821
	"EHLO CH1EHSOBE014.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758366Ab1FWPbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:31:45 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LN91SQ-02-H67-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, David Brown <davidb@codeaurora.org>,
        <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] iommu-api: Introduce iommu_comit function
Date: Thu, 23 Jun 2011 17:31:22 +0200
Message-ID: <1308843083-10442-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com>
References: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function will be used to coalesce cache-flushes
required after a domain was changed. This should
significantly improve performance in some cases.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/iommu.c |    7 +++++++
 include/linux/iommu.h |    6 ++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 6e6b6a1..4099cc6 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -122,3 +122,10 @@ int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
 	return iommu_ops->unmap(domain, iova, gfp_order);
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
+
+void iommu_commit(struct iommu_domain *domain)
+{
+	if (iommu_ops->commit)
+		iommu_ops->commit(domain);
+}
+EXPORT_SYMBOL_GPL(iommu_commit);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9940319..dbb4324 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -47,6 +47,7 @@ struct iommu_ops {
 				    unsigned long iova);
 	int (*domain_has_cap)(struct iommu_domain *domain,
 			      unsigned long cap);
+	void (*commit)(struct iommu_domain *domain);
 };
 
 #ifdef CONFIG_IOMMU_API
@@ -67,6 +68,7 @@ extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 				      unsigned long iova);
 extern int iommu_domain_has_cap(struct iommu_domain *domain,
 				unsigned long cap);
+extern void iommu_commit(struct iommu_domain *domain);
 
 #else /* CONFIG_IOMMU_API */
 
@@ -123,6 +125,10 @@ static inline int domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
+static inline void iommu_commit(struct iommu_domain *domain)
+{
+}
+
 #endif /* CONFIG_IOMMU_API */
 
 #endif /* __LINUX_IOMMU_H */
-- 
1.7.4.1


