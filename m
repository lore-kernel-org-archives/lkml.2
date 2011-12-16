Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906Ab1LPTxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:53:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964814Ab1LPTvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:51:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:09 2011
Message-Id: <20111216194209.531841867@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Allen Kay <allen.m.kay@intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [17/45] intel-iommu: fix return value of iommu_unmap() API
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allen Kay <allen.m.kay@intel.com>

commit 292827cb164ad00cc7689a21283b1261c0b6daed upstream.

iommu_unmap() API expects IOMMU drivers to return the actual page order
of the address being unmapped.  Previous code was just returning page
order passed in from the caller.  This patch fixes this problem.

Signed-off-by: Allen Kay <allen.m.kay@intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -817,13 +817,14 @@ static struct dma_pte *dma_pfn_level_pte
 }
 
 /* clear last level pte, a tlb flush should be followed */
-static void dma_pte_clear_range(struct dmar_domain *domain,
+static int dma_pte_clear_range(struct dmar_domain *domain,
 				unsigned long start_pfn,
 				unsigned long last_pfn)
 {
 	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
 	unsigned int large_page = 1;
 	struct dma_pte *first_pte, *pte;
+	int order;
 
 	BUG_ON(addr_width < BITS_PER_LONG && start_pfn >> addr_width);
 	BUG_ON(addr_width < BITS_PER_LONG && last_pfn >> addr_width);
@@ -847,6 +848,9 @@ static void dma_pte_clear_range(struct d
 				   (void *)pte - (void *)first_pte);
 
 	} while (start_pfn && start_pfn <= last_pfn);
+
+	order = (large_page - 1) * 9;
+	return order;
 }
 
 /* free page table pages. last level pte should already be cleared */
@@ -3865,14 +3869,15 @@ static int intel_iommu_unmap(struct iomm
 {
 	struct dmar_domain *dmar_domain = domain->priv;
 	size_t size = PAGE_SIZE << gfp_order;
+	int order;
 
-	dma_pte_clear_range(dmar_domain, iova >> VTD_PAGE_SHIFT,
+	order = dma_pte_clear_range(dmar_domain, iova >> VTD_PAGE_SHIFT,
 			    (iova + size - 1) >> VTD_PAGE_SHIFT);
 
 	if (dmar_domain->max_addr == iova + size)
 		dmar_domain->max_addr = iova;
 
-	return gfp_order;
+	return order;
 }
 
 static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,


