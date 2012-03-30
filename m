Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab2DAR7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:59:09 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:1906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab2DAR7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:59:08 -0400
Message-Id: <201204011759.q31Hx5ej030121@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 16:07:12 -0400
Subject: [PATCH v3] hugetlb: fix race condition in hugetlb_fault()
In-Reply-To: <4F7887A5.3060700@tilera.com>
References: <4F7887A5.3060700@tilera.com> <201203302018.q2UKIFH5020745@farm-0012.internal.tilera.com> <CAJd=RBCoLNB+iRX1shKGAwSbE8PsZXyk9e3inPTREcm2kk3nXA@mail.gmail.com> <201203311339.q2VDdJMD006254@farm-0012.internal.tilera.com> <CAJd=RBBWx7uZcw=_oA06RVunPAGeFcJ7LY=RwFCyB_BreJb_kg@mail.gmail.com>
To: Hillf Danton <dhillf@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
X-OriginalArrivalTime: 01 Apr 2012 17:59:06.0828 (UTC) FILETIME=[21B0A8C0:01CD1031]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The race is as follows.

Suppose a multi-threaded task forks a new process (on cpu A), thus
bumping up the ref count on all the pages.  While the fork is occurring
(and thus we have marked all the PTEs as read-only), another thread in
the original process (on cpu B) tries to write to a huge page, taking
an access violation from the write-protect and calling hugetlb_cow().
Now, suppose the fork() fails.  It will undo the COW and decrement the
ref count on the pages, so the ref count on the huge page drops back
to 1.  Meanwhile hugetlb_cow() also decrements the ref count by one on
the original page, since the original address space doesn't need it any
more, having copied a new page to replace the original page.  This leaves
the ref count at zero, and when we call unlock_page(), we panic.

	fork on CPU A				fault on CPU B
	=============				==============
	...
	down_write(&parent->mmap_sem);
	down_write_nested(&child->mmap_sem);
	...
	while duplicating vmas
		if error
			break;
	...
	up_write(&child->mmap_sem);
	up_write(&parent->mmap_sem);		...
						down_read(&parent->mmap_sem);
						...
						lock_page(page);
						handle COW
						page_mapcount(old_page) == 2
						alloc and prepare new_page
	...
	handle error
	page_remove_rmap(page);
	put_page(page);
	...
						fold new_page into pte
						page_remove_rmap(page);
						put_page(page);
						...
				oops ==>	unlock_page(page);
						up_read(&parent->mmap_sem);

The solution is to take an extra reference to the page while we are
holding the lock on it.

Reviewed-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 mm/hugetlb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1871753..2a04cfd 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2701,6 +2701,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * so no worry about deadlock.
 	 */
 	page = pte_page(entry);
+	get_page(page);
 	if (page != pagecache_page)
 		lock_page(page);
 
@@ -2732,6 +2733,7 @@ out_page_table_lock:
 	}
 	if (page != pagecache_page)
 		unlock_page(page);
+	put_page(page);
 
 out_mutex:
 	mutex_unlock(&hugetlb_instantiation_mutex);
-- 
1.6.5.2

