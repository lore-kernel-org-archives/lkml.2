Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1A1Ftw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 00:49:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39084 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab1A1Ftv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 00:49:51 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D4259C3.8050105@np.css.fujitsu.com>
Date: Fri, 28 Jan 2011 14:53:07 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>
CC: =?ISO-2022-JP?B?QUtQTRskQiEhGyhC?= <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2 2/3] Fix the wrong reported address of poisoned THP.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the tail page of THP is poisoned, the head page will be
poisoned too. And the wrong address, address of head page, will
be sent with sigbus always.

So when the poisoned page is used by Guest OS which is running
on KVM, after the address changing(hva->gpa) by qemu,
the unexpected process on Guest OS will be killed by sigbus.

What we expected is that the process using the poisoned tail
page could be killed on Guest OS, but not that the process
using the healthy head page is killed.

Since it is not good to poison the healthy page, avoid poisoning other
than the page which is really poisoned.
  (While we poison all pages in a huge page in case of hugetlb,
   we can do this for THP thanks to split_huge_page().)

Here we fix two parts:
  1. Isolate the poisoned page only to make sure
     the reported address is the address of poisoned page.
  2. make the poisoned page work as the poisoned regular page.

-v2
   Abbreviate the description.
   Remove the checking of PageHuge() after split_huge_page().

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 mm/huge_memory.c    |    7 ++++++-
 mm/memory-failure.c |   27 ++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e187454..aa18b21 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1162,7 +1162,12 @@ static void __split_huge_page_refcount(struct page *page)
 		/* after clearing PageTail the gup refcount can be released */
 		smp_mb();
 
-		page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+		/*
+		 * remain hwpoison flag of the poisoned tail page:
+		 *   fix for the unsuitable process killed on Guest Machine(KVM)
+		 *   by the memory-failure.
+		 */
+		page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP | __PG_HWPOISON;
 		page_tail->flags |= (page->flags &
 				     ((1L << PG_referenced) |
 				      (1L << PG_swapbacked) |
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2fa5f94..c526469 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -854,6 +854,7 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	int ret;
 	int kill = 1;
 	struct page *hpage = compound_head(p);
+	struct page *ppage;
 
 	if (PageReserved(p) || PageSlab(p))
 		return SWAP_SUCCESS;
@@ -894,6 +895,14 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 		}
 	}
 
+	/*
+	 * ppage: poisoned page
+	 *   if p is regular page(4k page)
+	 *        ppage == real poisoned page;
+	 *   else p is hugetlb or THP, ppage == head page.
+	 */
+	ppage = hpage;
+
 	if (PageTransHuge(hpage)) {
 		/*
 		 * Verify that this isn't a hugetlbfs head page, the check for
@@ -919,6 +928,8 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 				BUG_ON(!PageHWPoison(p));
 				return SWAP_FAIL;
 			}
+			/* THP is split, so ppage should be the real poisoned page. */
+			ppage = p;
 		}
 	}
 
@@ -931,12 +942,18 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * there's nothing that can be done.
 	 */
 	if (kill)
-		collect_procs(hpage, &tokill);
+		collect_procs(ppage, &tokill);
 
-	ret = try_to_unmap(hpage, ttu);
+	if (hpage != ppage)
+		lock_page_nosync(ppage);
+
+	ret = try_to_unmap(ppage, ttu);
 	if (ret != SWAP_SUCCESS)
 		printk(KERN_ERR "MCE %#lx: failed to unmap page (mapcount=%d)\n",
-				pfn, page_mapcount(hpage));
+				pfn, page_mapcount(ppage));
+
+	if (hpage != ppage)
+		unlock_page(ppage);
 
 	/*
 	 * Now that the dirty bit has been propagated to the
@@ -947,7 +964,7 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	kill_procs_ao(&tokill, !!PageDirty(hpage), trapno,
+	kill_procs_ao(&tokill, !!PageDirty(ppage), trapno,
 		      ret != SWAP_SUCCESS, p, pfn);
 
 	return ret;
@@ -1090,7 +1107,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	 * For error on the tail page, we should set PG_hwpoison
 	 * on the head page to show that the hugepage is hwpoisoned
 	 */
-	if (PageTail(p) && TestSetPageHWPoison(hpage)) {
+	if (PageHuge(p) && PageTail(p) && TestSetPageHWPoison(hpage)) {
 		action_result(pfn, "hugepage already hardware poisoned",
 				IGNORED);
 		unlock_page(hpage);
-- 
1.7.2.2


