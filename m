Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1CQCcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:32:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60423 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1CQCc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:32:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4D8172AE.4090300@jp.fujitsu.com>
Date: Thu, 17 Mar 2011 11:32:14 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Free the collapsed pages after the new THP is mapped.
References: <4D817234.9070106@jp.fujitsu.com>
In-Reply-To: <4D817234.9070106@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free pages at once after they are replaced by new THP,
instead of freeing one by one during copy.

This change is for later patches, to allow cancel of page
collapsing.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 mm/huge_memory.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e02f687..c62176a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1704,11 +1704,10 @@ out:
 
 static void __collapse_huge_page_copy(pte_t *pte, struct page *page,
 				      struct vm_area_struct *vma,
-				      unsigned long address,
-				      spinlock_t *ptl)
+				      unsigned long address)
 {
 	pte_t *_pte;
-	for (_pte = pte; _pte < pte+HPAGE_PMD_NR; _pte++) {
+	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte++) {
 		pte_t pteval = *_pte;
 		struct page *src_page;
 
@@ -1720,7 +1719,28 @@ static void __collapse_huge_page_copy(pte_t *pte, struct page *page,
 			copy_user_highpage(page, src_page, address, vma);
 			VM_BUG_ON(page_mapcount(src_page) != 1);
 			VM_BUG_ON(page_count(src_page) != 2);
+		}
+
+		address += PAGE_SIZE;
+		page++;
+	}
+}
+
+static void __collapse_huge_page_free_old_pte(pte_t *pte,
+					      struct vm_area_struct *vma,
+					      unsigned long address,
+					      spinlock_t *ptl)
+{
+	pte_t *_pte;
+
+	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte++) {
+		pte_t pteval = *_pte;
+		struct page *src_page;
+
+		if (!pte_none(pteval)) {
+			src_page = pte_page(pteval);
 			release_pte_page(src_page);
+
 			/*
 			 * ptl mostly unnecessary, but preempt has to
 			 * be disabled to update the per-cpu stats
@@ -1736,9 +1756,7 @@ static void __collapse_huge_page_copy(pte_t *pte, struct page *page,
 			spin_unlock(ptl);
 			free_page_and_swap_cache(src_page);
 		}
-
 		address += PAGE_SIZE;
-		page++;
 	}
 }
 
@@ -1875,7 +1893,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 */
 	lock_page_nosync(new_page);
 
-	__collapse_huge_page_copy(pte, new_page, vma, address, ptl);
+	__collapse_huge_page_copy(pte, new_page, vma, address);
 	pte_unmap(pte);
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
@@ -1905,6 +1923,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 #ifndef CONFIG_NUMA
 	*hpage = NULL;
 #endif
+	__collapse_huge_page_free_old_pte(pte, vma, address, ptl);
 	khugepaged_pages_collapsed++;
 	unlock_page(new_page);
 out_up_write:
-- 
1.7.1


