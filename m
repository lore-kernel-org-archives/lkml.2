Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab1LENfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:35:21 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:46728
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932250Ab1LENfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:09 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVQGEC-02-AUF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/22] iommu/amd: Add amd_iommu_domain_direct_map function
Date: Mon, 5 Dec 2011 14:34:24 +0100
Message-ID: <1323092077-25501-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function can be used to switch a domain into
paging-mode 0. In this mode all devices can access physical
system memory directly without any remapping.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c       |   38 ++++++++++++++++++++++++++++++++++++--
 drivers/iommu/amd_iommu_proto.h |    3 +++
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 81a709a..f0b289f 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1684,9 +1684,12 @@ static bool dma_ops_domain(struct protection_domain *domain)
 
 static void set_dte_entry(u16 devid, struct protection_domain *domain, bool ats)
 {
-	u64 pte_root = virt_to_phys(domain->pt_root);
+	u64 pte_root = 0;
 	u64 flags = 0;
 
+	if (domain->mode != PAGE_MODE_NONE)
+		pte_root = virt_to_phys(domain->pt_root);
+
 	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
 		    << DEV_ENTRY_MODE_SHIFT;
 	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
@@ -2782,7 +2785,8 @@ static void amd_iommu_domain_destroy(struct iommu_domain *dom)
 
 	BUG_ON(domain->dev_cnt != 0);
 
-	free_pagetable(domain);
+	if (domain->mode != PAGE_MODE_NONE)
+		free_pagetable(domain);
 
 	protection_domain_free(domain);
 
@@ -2846,6 +2850,9 @@ static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
 	int prot = 0;
 	int ret;
 
+	if (domain->mode == PAGE_MODE_NONE)
+		return -EINVAL;
+
 	if (iommu_prot & IOMMU_READ)
 		prot |= IOMMU_PROT_IR;
 	if (iommu_prot & IOMMU_WRITE)
@@ -2864,6 +2871,9 @@ static int amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
 	struct protection_domain *domain = dom->priv;
 	unsigned long page_size, unmap_size;
 
+	if (domain->mode == PAGE_MODE_NONE)
+		return -EINVAL;
+
 	page_size  = 0x1000UL << gfp_order;
 
 	mutex_lock(&domain->api_lock);
@@ -2883,6 +2893,9 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 	phys_addr_t paddr;
 	u64 *pte, __pte;
 
+	if (domain->mode == PAGE_MODE_NONE)
+		return iova;
+
 	pte = fetch_pte(domain, iova);
 
 	if (!pte || !IOMMU_PTE_PRESENT(*pte))
@@ -2976,3 +2989,24 @@ int amd_iommu_unregister_ppr_notifier(struct notifier_block *nb)
 	return atomic_notifier_chain_unregister(&ppr_notifier, nb);
 }
 EXPORT_SYMBOL(amd_iommu_unregister_ppr_notifier);
+
+void amd_iommu_domain_direct_map(struct iommu_domain *dom)
+{
+	struct protection_domain *domain = dom->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&domain->lock, flags);
+
+	/* Update data structure */
+	domain->mode    = PAGE_MODE_NONE;
+	domain->updated = true;
+
+	/* Make changes visible to IOMMUs */
+	update_domain(domain);
+
+	/* Page-table is not visible to IOMMU anymore, so free it */
+	free_pagetable(domain);
+
+	spin_unlock_irqrestore(&domain->lock, flags);
+}
+EXPORT_SYMBOL(amd_iommu_domain_direct_map);
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index cfe2dfc..2c4554e 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -33,9 +33,12 @@ extern void amd_iommu_init_notifier(void);
 extern void amd_iommu_init_api(void);
 
 /* IOMMUv2 specific functions */
+struct iommu_domain;
+
 extern bool amd_iommu_v2_supported(void);
 extern int amd_iommu_register_ppr_notifier(struct notifier_block *nb);
 extern int amd_iommu_unregister_ppr_notifier(struct notifier_block *nb);
+extern void amd_iommu_domain_direct_map(struct iommu_domain *dom);
 
 #ifndef CONFIG_AMD_IOMMU_STATS
 
-- 
1.7.5.4


