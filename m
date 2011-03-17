Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab1CQCd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:33:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41417 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1CQCdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:33:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4D817300.80102@jp.fujitsu.com>
Date: Thu, 17 Mar 2011 11:33:36 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Check whether the new THP is poisoned before it is mapped
 to APL.
References: <4D817234.9070106@jp.fujitsu.com>
In-Reply-To: <4D817234.9070106@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the new THP is poisoned after the 4K pages are copied to it
and mapped to APL, APL will be killed by kernel with SIGBUS signal.

There is not much doubt that it is a right behavior. But we can
do our best to reduce the impact of the poisoned THP to the least.

So add final poison check for the new THP before the THP is mapped
to APL. If check find a poison, back to 4K pages and trash the THP.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 mm/huge_memory.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6345279..9aed3a8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1776,13 +1776,14 @@ static void collapse_huge_page(struct mm_struct *mm,
 {
 	pgd_t *pgd;
 	pud_t *pud;
-	pmd_t *pmd, _pmd;
+	pmd_t *pmd, _pmd, old_pmd;
 	pte_t *pte;
 	pgtable_t pgtable;
 	struct page *new_page;
 	spinlock_t *ptl;
 	int isolated;
 	unsigned long hstart, hend;
+	struct page *p;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 #ifndef CONFIG_NUMA
@@ -1873,6 +1874,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 * to avoid the risk of CPU bugs in that area.
 	 */
 	_pmd = pmdp_clear_flush_notify(vma, address, pmd);
+	old_pmd = _pmd;
 	spin_unlock(&mm->page_table_lock);
 
 	spin_lock(ptl);
@@ -1904,7 +1906,6 @@ static void collapse_huge_page(struct mm_struct *mm,
 	if (__collapse_huge_page_copy(pte, new_page, vma, address) == 0)
 		goto out_poison;
 
-	pte_unmap(pte);
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
 	VM_BUG_ON(page_count(pgtable) != 1);
@@ -1921,6 +1922,15 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 */
 	smp_wmb();
 
+	for (p = new_page; p < new_page + HPAGE_PMD_NR; p++) {
+		if (PageHWPoison(p)) {
+			_pmd = old_pmd;
+			goto out_poison;
+		}
+	}
+
+	pte_unmap(pte);
+
 	spin_lock(&mm->page_table_lock);
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address);
-- 
1.7.1


