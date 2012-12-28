Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2L1Tvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:51:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55087 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563Ab2L1TRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:43 -0500
Message-Id: <20121228190358.751846960@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Ravi Murty <Ravi.Murty@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 142/173] intel-iommu: Free old page tables before creating superpage
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Woodhouse, David" <david.woodhouse@intel.com>

commit 6491d4d02893d9787ba67279595990217177b351 upstream.

The dma_pte_free_pagetable() function will only free a page table page
if it is asked to free the *entire* 2MiB range that it covers. So if a
page table page was used for one or more small mappings, it's likely to
end up still present in the page tables... but with no valid PTEs.

This was fine when we'd only be repopulating it with 4KiB PTEs anyway
but the same virtual address range can end up being reused for a
*large-page* mapping. And in that case were were trying to insert the
large page into the second-level page table, and getting a complaint
from the sanity check in __domain_mapping() because there was already a
corresponding entry. This was *relatively* harmless; it led to a memory
leak of the old page table page, but no other ill-effects.

Fix it by calling dma_pte_clear_range (hopefully redundant) and
dma_pte_free_pagetable() before setting up the new large page.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Tested-by: Ravi Murty <Ravi.Murty@intel.com>
Tested-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/intel-iommu.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0badfa4..9476c1b 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1827,10 +1827,17 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			if (!pte)
 				return -ENOMEM;
 			/* It is large page*/
-			if (largepage_lvl > 1)
+			if (largepage_lvl > 1) {
 				pteval |= DMA_PTE_LARGE_PAGE;
-			else
+				/* Ensure that old small page tables are removed to make room
+				   for superpage, if they exist. */
+				dma_pte_clear_range(domain, iov_pfn,
+						    iov_pfn + lvl_to_nr_pages(largepage_lvl) - 1);
+				dma_pte_free_pagetable(domain, iov_pfn,
+						       iov_pfn + lvl_to_nr_pages(largepage_lvl) - 1);
+			} else {
 				pteval &= ~(uint64_t)DMA_PTE_LARGE_PAGE;
+			}
 
 		}
 		/* We don't need lock here, nobody else


