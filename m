Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab2IJQTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:19:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:24396 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758117Ab2IJQTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:19:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,398,1344236400"; 
   d="scan'208";a="191210543"
Subject: [PATCH 3/3 v2] mm: Batch page_check_references in shrink_page_list
 sharing the same i_mmap_mutex
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andi Kleen <ak@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alex Shi <alex.shi@intel.com>, Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Sep 2012 09:19:32 -0700
Message-ID: <1347293972.9977.73.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In shrink_page_list, call to page_referenced_file and try_to_unmap will cause the
acquisition/release of mapping->i_mmap_mutex for each page in the page
list.  However, it is very likely that successive pages in the list
share the same mapping and we can reduce the frequency of i_mmap_mutex
acquisition by holding the mutex in shrink_page_list before calling
__page_referenced and __try_to_unmap. This improves the
performance when the system has a lot page reclamations for file mapped
pages if workloads are using a lot of memory for page cache.

Tim

---
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
--- 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d4ab646..0428639 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -786,7 +786,7 @@ static enum page_references page_check_references(struct page *page,
 	int referenced_ptes, referenced_page;
 	unsigned long vm_flags;
 
-	referenced_ptes = page_referenced(page, 1, mz->mem_cgroup, &vm_flags);
+	referenced_ptes = __page_referenced(page, 1, mz->mem_cgroup, &vm_flags);
 	referenced_page = TestClearPageReferenced(page);
 
 	/* Lumpy reclaim - ignore references */
@@ -856,6 +856,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 	unsigned long nr_congested = 0;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_writeback = 0;
+	struct mutex *i_mmap_mutex = NULL;
 
 	cond_resched();
 
@@ -909,7 +910,15 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 			}
 		}
 
+		if (needs_page_mmap_mutex(page) &&
+			       i_mmap_mutex != &page->mapping->i_mmap_mutex) {
+			if (i_mmap_mutex)
+				mutex_unlock(i_mmap_mutex);
+			i_mmap_mutex = &page->mapping->i_mmap_mutex;
+			mutex_lock(i_mmap_mutex);
+		}
 		references = page_check_references(page, mz, sc);
+
 		switch (references) {
 		case PAGEREF_ACTIVATE:
 			goto activate_locked;
@@ -939,7 +948,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		 * processes. Try to unmap it here.
 		 */
 		if (page_mapped(page) && mapping) {
-			switch (try_to_unmap(page, TTU_UNMAP)) {
+			switch (__try_to_unmap(page, TTU_UNMAP)) {
 			case SWAP_FAIL:
 				goto activate_locked;
 			case SWAP_AGAIN:
@@ -1090,6 +1099,8 @@ keep_lumpy:
 		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
 	}
 
+	if (i_mmap_mutex)
+		mutex_unlock(i_mmap_mutex);
 	nr_reclaimed += __remove_mapping_batch(&unmap_pages, &ret_pages,
 					       &free_pages);
 






