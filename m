Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2LLVpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:45:44 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:36217 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab2LLVos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:44:48 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 8/8] mm: reduce rmap overhead for ex-KSM page copies created on swap faults
Date: Wed, 12 Dec 2012 16:43:40 -0500
Message-Id: <1355348620-9382-9-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ex-KSM pages are faulted from swap cache, the fault handler is
not capable of re-establishing anon_vma-spanning KSM pages.  In this
case, a copy of the page is created instead, just like during a COW
break.

These freshly made copies are known to be exclusive to the faulting
VMA and there is no reason to go look for this page in parent and
sibling processes during rmap operations.

Use page_add_new_anon_rmap() for these copies.  This also puts them on
the proper LRU lists and marks them SwapBacked, so we can get rid of
doing this ad-hoc in the KSM copy code.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/ksm.c    | 6 ------
 mm/memory.c | 5 ++++-
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 382d930..7275c74 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1590,13 +1590,7 @@ struct page *ksm_does_need_to_copy(struct page *page,
 
 		SetPageDirty(new_page);
 		__SetPageUptodate(new_page);
-		SetPageSwapBacked(new_page);
 		__set_page_locked(new_page);
-
-		if (!mlocked_vma_newpage(vma, new_page))
-			lru_cache_add_lru(new_page, LRU_ACTIVE_ANON);
-		else
-			add_page_to_unevictable_list(new_page);
 	}
 
 	return new_page;
diff --git a/mm/memory.c b/mm/memory.c
index 7653773..726ff11 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3039,7 +3039,10 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
-	do_page_add_anon_rmap(page, vma, address, exclusive);
+	if (swapcache) /* ksm created a completely new copy */
+		page_add_new_anon_rmap(page, vma, address);
+	else
+		do_page_add_anon_rmap(page, vma, address, exclusive);
 	/* It's better to call commit-charge after rmap is established */
 	mem_cgroup_commit_charge_swapin(page, ptr);
 
-- 
1.7.11.7

