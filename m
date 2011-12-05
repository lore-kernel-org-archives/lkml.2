Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab1LENjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:39:33 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:24783
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932362Ab1LENfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:10 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LVQGEF-01-IPR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/22] iommu/amd: Implement functions to manage GCR3 table
Date: Mon, 5 Dec 2011 14:34:27 +0100
Message-ID: <1323092077-25501-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds functions necessary to set and clear the
GCR3 values associated with a particular PASID in an IOMMUv2
domain.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c       |  130 +++++++++++++++++++++++++++++++++++++++
 drivers/iommu/amd_iommu_proto.h |    4 +
 drivers/iommu/amd_iommu_types.h |    1 +
 3 files changed, 135 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index bd18a04..faf566c 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1637,8 +1637,45 @@ static void free_pagetable(struct protection_domain *domain)
 	domain->pt_root = NULL;
 }
 
+static void free_gcr3_tbl_level1(u64 *tbl)
+{
+	u64 *ptr;
+	int i;
+
+	for (i = 0; i < 512; ++i) {
+		if (!(tbl[i] & GCR3_VALID))
+			continue;
+
+		ptr = __va(tbl[i] & PAGE_MASK);
+
+		free_page((unsigned long)ptr);
+	}
+}
+
+static void free_gcr3_tbl_level2(u64 *tbl)
+{
+	u64 *ptr;
+	int i;
+
+	for (i = 0; i < 512; ++i) {
+		if (!(tbl[i] & GCR3_VALID))
+			continue;
+
+		ptr = __va(tbl[i] & PAGE_MASK);
+
+		free_gcr3_tbl_level1(ptr);
+	}
+}
+
 static void free_gcr3_table(struct protection_domain *domain)
 {
+	if (domain->glx == 2)
+		free_gcr3_tbl_level2(domain->gcr3_tbl);
+	else if (domain->glx == 1)
+		free_gcr3_tbl_level1(domain->gcr3_tbl);
+	else if (domain->glx != 0)
+		BUG();
+
 	free_page((unsigned long)domain->gcr3_tbl);
 }
 
@@ -3282,3 +3319,96 @@ int amd_iommu_flush_tlb(struct iommu_domain *dom, int pasid)
 }
 EXPORT_SYMBOL(amd_iommu_flush_tlb);
 
+static u64 *__get_gcr3_pte(u64 *root, int level, int pasid, bool alloc)
+{
+	int index;
+	u64 *pte;
+
+	while (true) {
+
+		index = (pasid >> (9 * level)) & 0x1ff;
+		pte   = &root[index];
+
+		if (level == 0)
+			break;
+
+		if (!(*pte & GCR3_VALID)) {
+			if (!alloc)
+				return NULL;
+
+			root = (void *)get_zeroed_page(GFP_ATOMIC);
+			if (root == NULL)
+				return NULL;
+
+			*pte = __pa(root) | GCR3_VALID;
+		}
+
+		root = __va(*pte & PAGE_MASK);
+
+		level -= 1;
+	}
+
+	return pte;
+}
+
+static int __set_gcr3(struct protection_domain *domain, int pasid,
+		      unsigned long cr3)
+{
+	u64 *pte;
+
+	if (domain->mode != PAGE_MODE_NONE)
+		return -EINVAL;
+
+	pte = __get_gcr3_pte(domain->gcr3_tbl, domain->glx, pasid, true);
+	if (pte == NULL)
+		return -ENOMEM;
+
+	*pte = (cr3 & PAGE_MASK) | GCR3_VALID;
+
+	return __amd_iommu_flush_tlb(domain, pasid);
+}
+
+static int __clear_gcr3(struct protection_domain *domain, int pasid)
+{
+	u64 *pte;
+
+	if (domain->mode != PAGE_MODE_NONE)
+		return -EINVAL;
+
+	pte = __get_gcr3_pte(domain->gcr3_tbl, domain->glx, pasid, false);
+	if (pte == NULL)
+		return 0;
+
+	*pte = 0;
+
+	return __amd_iommu_flush_tlb(domain, pasid);
+}
+
+int amd_iommu_domain_set_gcr3(struct iommu_domain *dom, int pasid,
+			      unsigned long cr3)
+{
+	struct protection_domain *domain = dom->priv;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&domain->lock, flags);
+	ret = __set_gcr3(domain, pasid, cr3);
+	spin_unlock_irqrestore(&domain->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(amd_iommu_domain_set_gcr3);
+
+int amd_iommu_domain_clear_gcr3(struct iommu_domain *dom, int pasid)
+{
+	struct protection_domain *domain = dom->priv;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&domain->lock, flags);
+	ret = __clear_gcr3(domain, pasid);
+	spin_unlock_irqrestore(&domain->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(amd_iommu_domain_clear_gcr3);
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index a92dc61..a951a70 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -43,6 +43,10 @@ extern int amd_iommu_domain_enable_v2(struct iommu_domain *dom, int pasids);
 extern int amd_iommu_flush_page(struct iommu_domain *dom, int pasid,
 				u64 address);
 extern int amd_iommu_flush_tlb(struct iommu_domain *dom, int pasid);
+extern int amd_iommu_domain_set_gcr3(struct iommu_domain *dom, int pasid,
+				     unsigned long cr3);
+extern int amd_iommu_domain_clear_gcr3(struct iommu_domain *dom, int pasid);
+
 
 #ifndef CONFIG_AMD_IOMMU_STATS
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 64a7642..68937a4 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -279,6 +279,7 @@
 #define DTE_GCR3_SHIFT_B	16
 #define DTE_GCR3_SHIFT_C	43
 
+#define GCR3_VALID		0x01ULL
 
 #define IOMMU_PAGE_MASK (((1ULL << 52) - 1) & ~0xfffULL)
 #define IOMMU_IO_PAGE_MASK	(~(0xfffULL))
-- 
1.7.5.4


