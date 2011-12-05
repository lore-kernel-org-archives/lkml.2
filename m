Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab1LENfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:35:12 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:11619
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932309Ab1LENfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:06 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LVQGEC-02-AUH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/22] iommu/amd: Add function to get IOMMUv2 domain for pdev
Date: Mon, 5 Dec 2011 14:34:29 +0100
Message-ID: <1323092077-25501-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD IOMMUv2 driver needs to get the IOMMUv2 domain
associated with a particular device. This patch adds a
function to get this information.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c       |   18 ++++++++++++++++++
 drivers/iommu/amd_iommu_proto.h |    1 +
 drivers/iommu/amd_iommu_types.h |    4 ++++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index e363180..dd66211 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2958,6 +2958,8 @@ static int amd_iommu_domain_init(struct iommu_domain *dom)
 	if (!domain->pt_root)
 		goto out_free;
 
+	domain->iommu_domain = dom;
+
 	dom->priv = domain;
 
 	return 0;
@@ -3463,3 +3465,19 @@ int amd_iommu_complete_ppr(struct pci_dev *pdev, int pasid,
 	return iommu_queue_command(iommu, &cmd);
 }
 EXPORT_SYMBOL(amd_iommu_complete_ppr);
+
+struct iommu_domain *amd_iommu_get_v2_domain(struct pci_dev *pdev)
+{
+	struct protection_domain *domain;
+
+	domain = get_domain(&pdev->dev);
+	if (IS_ERR(domain))
+		return NULL;
+
+	/* Only return IOMMUv2 domains */
+	if (!(domain->flags & PD_IOMMUV2_MASK))
+		return NULL;
+
+	return domain->iommu_domain;
+}
+EXPORT_SYMBOL(amd_iommu_get_v2_domain);
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index bb5ecfe..1a7f41c 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -46,6 +46,7 @@ extern int amd_iommu_flush_tlb(struct iommu_domain *dom, int pasid);
 extern int amd_iommu_domain_set_gcr3(struct iommu_domain *dom, int pasid,
 				     unsigned long cr3);
 extern int amd_iommu_domain_clear_gcr3(struct iommu_domain *dom, int pasid);
+extern struct iommu_domain *amd_iommu_get_v2_domain(struct pci_dev *pdev);
 
 #define PPR_SUCCESS			0x0
 #define PPR_INVALID			0x1
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index e21c74a..2ba7b9a 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -361,6 +361,8 @@ struct amd_iommu_fault {
 #define PPR_FAULT_RSVD  (1 << 7)
 #define PPR_FAULT_GN    (1 << 8)
 
+struct iommu_domain;
+
 /*
  * This structure contains generic data for  IOMMU protection domains
  * independent of their use.
@@ -380,6 +382,8 @@ struct protection_domain {
 	unsigned dev_cnt;	/* devices assigned to this domain */
 	unsigned dev_iommu[MAX_IOMMUS]; /* per-IOMMU reference count */
 	void *priv;		/* private data */
+	struct iommu_domain *iommu_domain; /* Pointer to generic
+					      domain structure */
 
 };
 
-- 
1.7.5.4


