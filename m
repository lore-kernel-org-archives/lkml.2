Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab0EMH6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:58:45 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:48560 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082Ab0EMH50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:57:26 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: n-horiguchi@ah.jp.nec.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 2/7] HWPOISON, hugetlb: enable error handling path for hugepage
Date: Thu, 13 May 2010 16:55:21 +0900
Message-Id: <1273737326-21211-3-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1273737326-21211-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1273737326-21211-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just enables handling path. Real containing and
recovering operation will be implemented in following patches.

Dependency:
  "hugetlb, rmap: add reverse mapping for hugepage."

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |   39 ++++++++++++++++++++++-----------------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff --git v2.6.34-rc7/mm/memory-failure.c v2.6.34-rc7/mm/memory-failure.c
index 620b0b4..1ec68c8 100644
--- v2.6.34-rc7/mm/memory-failure.c
+++ v2.6.34-rc7/mm/memory-failure.c
@@ -45,6 +45,7 @@
 #include <linux/page-isolation.h>
 #include <linux/suspend.h>
 #include <linux/slab.h>
+#include <linux/hugetlb.h>
 #include "internal.h"
 
 int sysctl_memory_failure_early_kill __read_mostly = 0;
@@ -837,6 +838,7 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	int ret;
 	int i;
 	int kill = 1;
+	struct page *hpage = compound_head(p);
 
 	if (PageReserved(p) || PageSlab(p))
 		return SWAP_SUCCESS;
@@ -845,10 +847,10 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * This check implies we don't kill processes if their pages
 	 * are in the swap cache early. Those are always late kills.
 	 */
-	if (!page_mapped(p))
+	if (!page_mapped(hpage))
 		return SWAP_SUCCESS;
 
-	if (PageCompound(p) || PageKsm(p))
+	if (PageKsm(p))
 		return SWAP_FAIL;
 
 	if (PageSwapCache(p)) {
@@ -863,10 +865,11 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * XXX: the dirty test could be racy: set_page_dirty() may not always
 	 * be called inside page lock (it's recommended but not enforced).
 	 */
-	mapping = page_mapping(p);
-	if (!PageDirty(p) && mapping && mapping_cap_writeback_dirty(mapping)) {
-		if (page_mkclean(p)) {
-			SetPageDirty(p);
+	mapping = page_mapping(hpage);
+	if (!PageDirty(hpage) && mapping &&
+	    mapping_cap_writeback_dirty(mapping)) {
+		if (page_mkclean(hpage)) {
+			SetPageDirty(hpage);
 		} else {
 			kill = 0;
 			ttu |= TTU_IGNORE_HWPOISON;
@@ -885,14 +888,14 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * there's nothing that can be done.
 	 */
 	if (kill)
-		collect_procs(p, &tokill);
+		collect_procs(hpage, &tokill);
 
 	/*
 	 * try_to_unmap can fail temporarily due to races.
 	 * Try a few times (RED-PEN better strategy?)
 	 */
 	for (i = 0; i < N_UNMAP_TRIES; i++) {
-		ret = try_to_unmap(p, ttu);
+		ret = try_to_unmap(hpage, ttu);
 		if (ret == SWAP_SUCCESS)
 			break;
 		pr_debug("MCE %#lx: try_to_unmap retry needed %d\n", pfn,  ret);
@@ -900,7 +903,7 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 
 	if (ret != SWAP_SUCCESS)
 		printk(KERN_ERR "MCE %#lx: failed to unmap page (mapcount=%d)\n",
-				pfn, page_mapcount(p));
+				pfn, page_mapcount(hpage));
 
 	/*
 	 * Now that the dirty bit has been propagated to the
@@ -911,7 +914,7 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	kill_procs_ao(&tokill, !!PageDirty(p), trapno,
+	kill_procs_ao(&tokill, !!PageDirty(hpage), trapno,
 		      ret != SWAP_SUCCESS, pfn);
 
 	return ret;
@@ -921,6 +924,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 {
 	struct page_state *ps;
 	struct page *p;
+	struct page *hpage;
 	int res;
 
 	if (!sysctl_memory_failure_recovery)
@@ -934,6 +938,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	}
 
 	p = pfn_to_page(pfn);
+	hpage = compound_head(p);
 	if (TestSetPageHWPoison(p)) {
 		printk(KERN_ERR "MCE %#lx: already hardware poisoned\n", pfn);
 		return 0;
@@ -953,7 +958,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	 * that may make page_freeze_refs()/page_unfreeze_refs() mismatch.
 	 */
 	if (!(flags & MF_COUNT_INCREASED) &&
-		!get_page_unless_zero(compound_head(p))) {
+		!get_page_unless_zero(hpage)) {
 		if (is_free_buddy_page(p)) {
 			action_result(pfn, "free buddy", DELAYED);
 			return 0;
@@ -971,9 +976,9 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	 * The check (unnecessarily) ignores LRU pages being isolated and
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
-	if (!PageLRU(p))
+	if (!PageLRU(p) && !PageHuge(p))
 		shake_page(p, 0);
-	if (!PageLRU(p)) {
+	if (!PageLRU(p) && !PageHuge(p)) {
 		/*
 		 * shake_page could have turned it free.
 		 */
@@ -991,7 +996,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	 * It's very difficult to mess with pages currently under IO
 	 * and in many cases impossible, so we just avoid it here.
 	 */
-	lock_page_nosync(p);
+	lock_page_nosync(hpage);
 
 	/*
 	 * unpoison always clear PG_hwpoison inside page lock
@@ -1004,8 +1009,8 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
 			atomic_long_dec(&mce_bad_pages);
-		unlock_page(p);
-		put_page(p);
+		unlock_page(hpage);
+		put_page(hpage);
 		return 0;
 	}
 
@@ -1038,7 +1043,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 		}
 	}
 out:
-	unlock_page(p);
+	unlock_page(hpage);
 	return res;
 }
 EXPORT_SYMBOL_GPL(__memory_failure);
-- 
1.7.0

