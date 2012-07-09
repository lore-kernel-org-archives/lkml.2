Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2GIWr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:47:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34632 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2GIWr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:47:27 -0400
Date: Mon, 9 Jul 2012 15:46:53 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] shmem: cleanup shmem_add_to_page_cache
In-Reply-To: <alpine.LSU.2.00.1207091533001.2051@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1207091544290.2051@eggly.anvils>
References: <alpine.LSU.2.00.1207091533001.2051@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shmem_add_to_page_cache() has three callsites, but only one of them
wants the radix_tree_preload() (an exceptional entry guarantees that
the radix tree node is present in the other cases), and only that site
can achieve mem_cgroup_uncharge_cache_page() (PageSwapCache makes it a
no-op in the other cases).  We did it this way originally to reflect
add_to_page_cache_locked(); but it's confusing now, so move the
radix_tree preloading and mem_cgroup uncharging to that one caller.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
---
This is just a cleanup: I'd prefer it to go in along with the fix 2/3,
but it can be delayed to v3.6 if you prefer.

 mm/shmem.c |   58 ++++++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

--- 3.5-rc6+/mm/shmem.c	2012-07-07 19:20:52.026952048 -0700
+++ linux/mm/shmem.c	2012-07-07 19:21:44.342952082 -0700
@@ -288,40 +288,31 @@ static int shmem_add_to_page_cache(struc
 				   struct address_space *mapping,
 				   pgoff_t index, gfp_t gfp, void *expected)
 {
-	int error = 0;
+	int error;
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(!PageSwapBacked(page));
 
+	page_cache_get(page);
+	page->mapping = mapping;
+	page->index = index;
+
+	spin_lock_irq(&mapping->tree_lock);
 	if (!expected)
-		error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
+		error = radix_tree_insert(&mapping->page_tree, index, page);
+	else
+		error = shmem_radix_tree_replace(mapping, index, expected,
+								 page);
 	if (!error) {
-		page_cache_get(page);
-		page->mapping = mapping;
-		page->index = index;
-
-		spin_lock_irq(&mapping->tree_lock);
-		if (!expected)
-			error = radix_tree_insert(&mapping->page_tree,
-							index, page);
-		else
-			error = shmem_radix_tree_replace(mapping, index,
-							expected, page);
-		if (!error) {
-			mapping->nrpages++;
-			__inc_zone_page_state(page, NR_FILE_PAGES);
-			__inc_zone_page_state(page, NR_SHMEM);
-			spin_unlock_irq(&mapping->tree_lock);
-		} else {
-			page->mapping = NULL;
-			spin_unlock_irq(&mapping->tree_lock);
-			page_cache_release(page);
-		}
-		if (!expected)
-			radix_tree_preload_end();
+		mapping->nrpages++;
+		__inc_zone_page_state(page, NR_FILE_PAGES);
+		__inc_zone_page_state(page, NR_SHMEM);
+		spin_unlock_irq(&mapping->tree_lock);
+	} else {
+		page->mapping = NULL;
+		spin_unlock_irq(&mapping->tree_lock);
+		page_cache_release(page);
 	}
-	if (error)
-		mem_cgroup_uncharge_cache_page(page);
 	return error;
 }
 
@@ -1202,11 +1193,18 @@ repeat:
 		__set_page_locked(page);
 		error = mem_cgroup_cache_charge(page, current->mm,
 						gfp & GFP_RECLAIM_MASK);
-		if (!error)
-			error = shmem_add_to_page_cache(page, mapping, index,
-						gfp, NULL);
 		if (error)
 			goto decused;
+		error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
+		if (!error) {
+			error = shmem_add_to_page_cache(page, mapping, index,
+							gfp, NULL);
+			radix_tree_preload_end();
+		}
+		if (error) {
+			mem_cgroup_uncharge_cache_page(page);
+			goto decused;
+		}
 		lru_cache_add_anon(page);
 
 		spin_lock(&info->lock);
