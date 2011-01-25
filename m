Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1AYFm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 00:42:59 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45614 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1AYFm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:42:58 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D3E63A0.9000301@np.css.fujitsu.com>
Date: Tue, 25 Jan 2011 14:46:08 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>
CC: =?ISO-2022-JP?B?QUtQTRskQiEhGyhC?= <akpm@linux-foundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] Isolate only one page of anonymous THP
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the tail page of THP is poisoned, the head page will be
poisoned too.

Lets make an assumption like following:
  1. Guest OS is running on KVM.
  2. Two processes(A and B) on Guest OS use pages in the same THP
     of Host.
     - process A is using the head page.
     - process B is using the tail pages.

  So when the tail page is poisoned, process B should be killed.
  But process A is killed and process B is still alive in fact.

  The reason for process A killed is that the head page is poisoned
  when the tail page is poisoned and the address reported
  with sigbus is the address of head page not the poisoned tail page.

  The reason for process B alive is that PG_hwpoisoned of the poisoned
  tail page is cleared after the poisoned THP is split and the address
  reported with sigbus is the address of head page.

It is expected that the process using the poisoned tail page is killed,
but not that the process using the healthy head page is killed.

So it is better to avoid poisoning other than the page which is really
poisoned.
  (While we poison all pages in a huge page in case of hugetlb,
   we can do this for THP thanks to split_huge_page().)

Here we fix two parts:
  1. poison the real poisoned page only.
  2. make the poisoned page work as the poisoned regular
     page(4k page).

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 mm/huge_memory.c    |    7 ++++++-
 mm/memory-failure.c |   25 ++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 004c9c2..2883f83 100644
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
index 55f7d07..5396603 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -854,6 +854,7 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	int ret;
 	int kill = 1;
 	struct page *hpage = compound_head(p);
+	struct page *ppage;
 
 	if (PageReserved(p) || PageSlab(p))
 		return SWAP_SUCCESS;
@@ -906,6 +907,14 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	}
 
 	/*
+	 * ppage: poisoned page
+	 *   if p is regular page(4k page) or THP(anonymous),
+	 *        ppage == real poisoned page;
+	 *   else p is hugetlb or others, ppage == head page.
+	 */
+	ppage = compound_head(p);
+
+	/*
 	 * First collect all the processes that have the page
 	 * mapped in dirty form.  This has to be done before try_to_unmap,
 	 * because ttu takes the rmap data structures down.
@@ -914,12 +923,18 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * there's nothing that can be done.
 	 */
 	if (kill)
-		collect_procs(hpage, &tokill);
+		collect_procs(ppage, &tokill);
 
-	ret = try_to_unmap(hpage, ttu);
+	if (!PageHuge(ppage) && hpage != ppage)
+		lock_page_nosync(ppage);
+
+	ret = try_to_unmap(ppage, ttu);
 	if (ret != SWAP_SUCCESS)
 		printk(KERN_ERR "MCE %#lx: failed to unmap page (mapcount=%d)\n",
-				pfn, page_mapcount(hpage));
+				pfn, page_mapcount(ppage));
+
+	if (!PageHuge(ppage) && hpage != ppage)
+		unlock_page(ppage);
 
 	/*
 	 * Now that the dirty bit has been propagated to the
@@ -930,7 +945,7 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	kill_procs_ao(&tokill, !!PageDirty(hpage), trapno,
+	kill_procs_ao(&tokill, !!PageDirty(ppage), trapno,
 		      ret != SWAP_SUCCESS, p, pfn);
 
 	return ret;
@@ -1073,7 +1088,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
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


