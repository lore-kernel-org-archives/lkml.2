Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1CQCdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:33:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41399 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1CQCdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:33:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4D8172D7.3040201@jp.fujitsu.com>
Date: Thu, 17 Mar 2011 11:32:55 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Check whether pages are poisoned before copying
References: <4D817234.9070106@jp.fujitsu.com>
In-Reply-To: <4D817234.9070106@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No matter whether it is one of collapsing pages or the new THP,
if the poisoned page is accessed during page copy, MCE will happen
and the system will panic.

So to avoid the above problem, add poison checks for both of 4K pages
and the THP before copying in __collapse_huge_page_copy().
If poisoned page is found, cancel page collapsing to keep the poisoned
4k page to be owned by the APL, or free poisoned THP before use it.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 mm/huge_memory.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c62176a..6345279 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1702,20 +1702,26 @@ out:
 	return isolated;
 }
 
-static void __collapse_huge_page_copy(pte_t *pte, struct page *page,
-				      struct vm_area_struct *vma,
-				      unsigned long address)
+static int __collapse_huge_page_copy(pte_t *pte, struct page *page,
+				     struct vm_area_struct *vma,
+				     unsigned long address)
 {
 	pte_t *_pte;
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte++) {
 		pte_t pteval = *_pte;
 		struct page *src_page;
 
+		if (PageHWPoison(page))
+			return 0;
+
 		if (pte_none(pteval)) {
 			clear_user_highpage(page, address);
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
 		} else {
 			src_page = pte_page(pteval);
+			if (PageHWPoison(src_page))
+				return 0;
+
 			copy_user_highpage(page, src_page, address, vma);
 			VM_BUG_ON(page_mapcount(src_page) != 1);
 			VM_BUG_ON(page_count(src_page) != 2);
@@ -1724,6 +1730,8 @@ static void __collapse_huge_page_copy(pte_t *pte, struct page *page,
 		address += PAGE_SIZE;
 		page++;
 	}
+
+	return 1;
 }
 
 static void __collapse_huge_page_free_old_pte(pte_t *pte,
@@ -1893,7 +1901,9 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 */
 	lock_page_nosync(new_page);
 
-	__collapse_huge_page_copy(pte, new_page, vma, address);
+	if (__collapse_huge_page_copy(pte, new_page, vma, address) == 0)
+		goto out_poison;
+
 	pte_unmap(pte);
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
@@ -1930,6 +1940,15 @@ out_up_write:
 	up_write(&mm->mmap_sem);
 	return;
 
+out_poison:
+	release_all_pte_pages(pte);
+	pte_unmap(pte);
+	spin_lock(&mm->page_table_lock);
+	BUG_ON(!pmd_none(*pmd));
+	set_pmd_at(mm, address, pmd, _pmd);
+	spin_unlock(&mm->page_table_lock);
+	unlock_page(new_page);
+
 out:
 	mem_cgroup_uncharge_page(new_page);
 #ifdef CONFIG_NUMA
-- 
1.7.1


