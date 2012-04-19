Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660Ab2DSVaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:30:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933546Ab2DSVPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:15:41 -0400
Message-Id: <20120419210820.048436819@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:08:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Metcalf <cmetcalf@tilera.com>,
        Hillf Danton <dhillf@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
Subject: [ 16/68] hugetlb: fix race condition in hugetlb_fault()
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit 66aebce747eaf9bc456bf1f1b217d8db843031d0 upstream.

The race is as follows:

Suppose a multi-threaded task forks a new process (on cpu A), thus
bumping up the ref count on all the pages.  While the fork is occurring
(and thus we have marked all the PTEs as read-only), another thread in
the original process (on cpu B) tries to write to a huge page, taking an
access violation from the write-protect and calling hugetlb_cow().  Now,
suppose the fork() fails.  It will undo the COW and decrement the ref
count on the pages, so the ref count on the huge page drops back to 1.
Meanwhile hugetlb_cow() also decrements the ref count by one on the
original page, since the original address space doesn't need it any
more, having copied a new page to replace the original page.  This
leaves the ref count at zero, and when we call unlock_page(), we panic.

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

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2686,6 +2686,7 @@ int hugetlb_fault(struct mm_struct *mm,
 	 * so no worry about deadlock.
 	 */
 	page = pte_page(entry);
+	get_page(page);
 	if (page != pagecache_page)
 		lock_page(page);
 
@@ -2717,6 +2718,7 @@ out_page_table_lock:
 	}
 	if (page != pagecache_page)
 		unlock_page(page);
+	put_page(page);
 
 out_mutex:
 	mutex_unlock(&hugetlb_instantiation_mutex);


