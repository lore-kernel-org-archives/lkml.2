Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab1LPUCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:02:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932852Ab1LPTvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:51:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:10 2011
Message-Id: <20111216194209.864233769@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Allen Kay <allen.m.kay@intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [19/45] intel-iommu: fix superpage support in pfn_to_dma_pte()
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allen Kay <allen.m.kay@intel.com>

commit 4399c8bf2b9093696fa8160d79712e7346989c46 upstream.

If target_level == 0, current code breaks out of the while-loop if
SUPERPAGE bit is set. We should also break out if PTE is not present.
If we don't do this, KVM calls to iommu_iova_to_phys() will cause
pfn_to_dma_pte() to create mapping for 4KiB pages.

Signed-off-by: Allen Kay <allen.m.kay@intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -307,6 +307,11 @@ static inline bool dma_pte_present(struc
 	return (pte->val & 3) != 0;
 }
 
+static inline bool dma_pte_superpage(struct dma_pte *pte)
+{
+	return (pte->val & (1 << 7));
+}
+
 static inline int first_pte_in_page(struct dma_pte *pte)
 {
 	return !((unsigned long)pte & ~VTD_PAGE_MASK);
@@ -732,29 +737,23 @@ out:
 }
 
 static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
-				      unsigned long pfn, int large_level)
+				      unsigned long pfn, int target_level)
 {
 	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
 	struct dma_pte *parent, *pte = NULL;
 	int level = agaw_to_level(domain->agaw);
-	int offset, target_level;
+	int offset;
 
 	BUG_ON(!domain->pgd);
 	BUG_ON(addr_width < BITS_PER_LONG && pfn >> addr_width);
 	parent = domain->pgd;
 
-	/* Search pte */
-	if (!large_level)
-		target_level = 1;
-	else
-		target_level = large_level;
-
 	while (level > 0) {
 		void *tmp_page;
 
 		offset = pfn_level_offset(pfn, level);
 		pte = &parent[offset];
-		if (!large_level && (pte->val & DMA_PTE_LARGE_PAGE))
+		if (!target_level && (dma_pte_superpage(pte) || !dma_pte_present(pte)))
 			break;
 		if (level == target_level)
 			break;


