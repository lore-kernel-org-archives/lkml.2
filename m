Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934543Ab2C3USU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:18:20 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41488 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759210Ab2C3USR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:18:17 -0400
Message-Id: <201203302018.q2UKIFH5020745@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 16:07:12 -0400
Subject: [PATCH] hugetlb: fix race condition in hugetlb_fault()
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Hillf Danton <dhillf@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
X-OriginalArrivalTime: 30 Mar 2012 20:18:16.0271 (UTC) FILETIME=[3D850DF0:01CD0EB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The race is as follows.  Suppose a multi-threaded task forks a new
process, thus bumping up the ref count on all the pages.  While the fork
is occurring (and thus we have marked all the PTEs as read-only), another
thread in the original process tries to write to a huge page, taking an
access violation from the write-protect and calling hugetlb_cow().  Now,
suppose the fork() fails.  It will undo the COW and decrement the ref
count on the pages, so the ref count on the huge page drops back to 1.
Meanwhile hugetlb_cow() also decrements the ref count by one on the
original page, since the original address space doesn't need it any more,
having copied a new page to replace the original page.  This leaves the
ref count at zero, and when we call unlock_page(), we panic.

The solution is to take an extra reference to the page while we are
holding the lock on it.

Cc: stable@kernel.org
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 mm/hugetlb.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4531be2..ab674fc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2703,8 +2703,10 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * so no worry about deadlock.
 	 */
 	page = pte_page(entry);
-	if (page != pagecache_page)
+	if (page != pagecache_page) {
+		get_page(page);
 		lock_page(page);
+	}
 
 	spin_lock(&mm->page_table_lock);
 	/* Check for a racing update before calling hugetlb_cow */
@@ -2732,8 +2734,10 @@ out_page_table_lock:
 		unlock_page(pagecache_page);
 		put_page(pagecache_page);
 	}
-	if (page != pagecache_page)
+	if (page != pagecache_page) {
 		unlock_page(page);
+		put_page(page);
+	}
 
 out_mutex:
 	mutex_unlock(&hugetlb_instantiation_mutex);
-- 
1.6.5.2

