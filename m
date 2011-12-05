Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab1LENgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:36:31 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:13154
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932416Ab1LENgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:36:12 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVQGEB-02-AUA-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/22] iommu/amd: Convert dev_table_entry to u64
Date: Mon, 5 Dec 2011 14:34:16 +0100
Message-ID: <1323092077-25501-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the contents of 'struct dev_table_entry' to u64 to
allow updating the DTE wit 64bit writes as required by the
spec.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c       |   18 ++++++++++--------
 drivers/iommu/amd_iommu_init.c  |   12 ++++++------
 drivers/iommu/amd_iommu_types.h |    4 ++--
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 4ee277a..661e2bb 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -365,8 +365,8 @@ static void dump_dte_entry(u16 devid)
 {
 	int i;
 
-	for (i = 0; i < 8; ++i)
-		pr_err("AMD-Vi: DTE[%d]: %08x\n", i,
+	for (i = 0; i < 4; ++i)
+		pr_err("AMD-Vi: DTE[%d]: %016llx\n", i,
 			amd_iommu_dev_table[devid].data[i]);
 }
 
@@ -1583,19 +1583,22 @@ static bool dma_ops_domain(struct protection_domain *domain)
 static void set_dte_entry(u16 devid, struct protection_domain *domain, bool ats)
 {
 	u64 pte_root = virt_to_phys(domain->pt_root);
-	u32 flags = 0;
+	u64 flags = 0;
 
 	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
 		    << DEV_ENTRY_MODE_SHIFT;
 	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
 
+	flags = amd_iommu_dev_table[devid].data[1];
+
 	if (ats)
 		flags |= DTE_FLAG_IOTLB;
 
-	amd_iommu_dev_table[devid].data[3] |= flags;
-	amd_iommu_dev_table[devid].data[2]  = domain->id;
-	amd_iommu_dev_table[devid].data[1]  = upper_32_bits(pte_root);
-	amd_iommu_dev_table[devid].data[0]  = lower_32_bits(pte_root);
+	flags &= ~(0xffffUL);
+	flags |= domain->id;
+
+	amd_iommu_dev_table[devid].data[1]  = flags;
+	amd_iommu_dev_table[devid].data[0]  = pte_root;
 }
 
 static void clear_dte_entry(u16 devid)
@@ -1603,7 +1606,6 @@ static void clear_dte_entry(u16 devid)
 	/* remove entry from the device table seen by the hardware */
 	amd_iommu_dev_table[devid].data[0] = IOMMU_PTE_P | IOMMU_PTE_TV;
 	amd_iommu_dev_table[devid].data[1] = 0;
-	amd_iommu_dev_table[devid].data[2] = 0;
 
 	amd_iommu_apply_erratum_63(devid);
 }
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 82d2410..17e0f77 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -584,18 +584,18 @@ static void __init free_event_buffer(struct amd_iommu *iommu)
 /* sets a specific bit in the device table entry. */
 static void set_dev_entry_bit(u16 devid, u8 bit)
 {
-	int i = (bit >> 5) & 0x07;
-	int _bit = bit & 0x1f;
+	int i = (bit >> 6) & 0x03;
+	int _bit = bit & 0x3f;
 
-	amd_iommu_dev_table[devid].data[i] |= (1 << _bit);
+	amd_iommu_dev_table[devid].data[i] |= (1UL << _bit);
 }
 
 static int get_dev_entry_bit(u16 devid, u8 bit)
 {
-	int i = (bit >> 5) & 0x07;
-	int _bit = bit & 0x1f;
+	int i = (bit >> 6) & 0x03;
+	int _bit = bit & 0x3f;
 
-	return (amd_iommu_dev_table[devid].data[i] & (1 << _bit)) >> _bit;
+	return (amd_iommu_dev_table[devid].data[i] & (1UL << _bit)) >> _bit;
 }
 
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 5b9c507..f8dd9ae 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -230,7 +230,7 @@
 #define IOMMU_PTE_IR (1ULL << 61)
 #define IOMMU_PTE_IW (1ULL << 62)
 
-#define DTE_FLAG_IOTLB	0x01
+#define DTE_FLAG_IOTLB	(0x01UL << 32)
 
 #define IOMMU_PAGE_MASK (((1ULL << 52) - 1) & ~0xfffULL)
 #define IOMMU_PTE_PRESENT(pte) ((pte) & IOMMU_PTE_P)
@@ -484,7 +484,7 @@ extern struct list_head amd_iommu_pd_list;
  * Structure defining one entry in the device table
  */
 struct dev_table_entry {
-	u32 data[8];
+	u64 data[4];
 };
 
 /*
-- 
1.7.5.4


