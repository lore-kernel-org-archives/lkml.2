Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1F1JDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 05:03:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56096 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab1F1JBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 05:01:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Jun 2011 17:54:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 3/3] mm: preallocate page before lock_page() at filemap COW
Message-Id: <20110628175414.6a316402.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110628173122.9e5aecdf.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110628173122.9e5aecdf.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 32c2ca2c3b24945c7078122b99c3ed89fc84dcc2 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 28 Jun 2011 17:30:03 +0900
Subject: [PATCH 3/3] mm: preallocate page before lock_page() at filemap COW.

Currently we are keeping faulted page locked throughout whole __do_fault
call (except for page_mkwrite code path) after calling file system's
fault code. If we do early COW, we allocate a new page which has to be
charged for a memcg (mem_cgroup_newpage_charge).

This function, however, might block for unbounded amount of time if memcg
oom killer is disabled or fork-bomb is running because the only way out of
the OOM situation is either an external event or OOM-situation fix.

In the end we are keeping the faulted page locked and blocking other
processes from faulting it in which is not good at all because we are
basically punishing potentially an unrelated process for OOM condition
in a different group (I have seen stuck system because of ld-2.11.1.so being
locked).

We can do test easily.

 % cgcreate -g memory:A
 % cgset -r memory.limit_in_bytes=64M A
 % cgset -r memory.memsw.limit_in_bytes=64M A
 % cd kernel_dir; cgexec -g memory:A make -j

Then, the whole system will live-locked until you kill 'make -j'
by hands (or push reboot...) This is because some important page in a
a shared library are locked.

Considering again, the new page is not necessary to be allocated
with lock_page() held. And usual page allocation may dive into
long memory reclaim loop with holding lock_page() and can cause
very long latency.

There are 3 ways.
  1. do allocation/charge before lock_page()
     Pros. - simple and can handle page allocation in the same manner.
             This will reduce holding time of lock_page() in general.
     Cons. - we do page allocation even if ->fault() returns error.

  2. do charge after unlock_page(). Even if charge fails, it's just OOM.
     Pros. - no impact to non-memcg path.
     Cons. - implemenation requires special cares of LRU and we need to modify
             page_add_new_anon_rmap()...

  3. do unlock->charge->lock again method.
     Pros. - no impact to non-memcg path.  
     Cons. - This may kill LOCK_PAGE_RETRY optimization. We need to release
             lock and get it again...

This patch moves "charge" and memory allocation for COW page
before lock_page(). Then, we can avoid scanning LRU with holding
a lock on a page and latency under lock_page() will be reduced.

Then, above livelock disappears.


Reported-by: Lutz Vieweg <lvml@5t9.de>
Original-idea-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memory.c |   56 ++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 40b7531..7d7d3a2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3103,14 +3103,34 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	pte_t *page_table;
 	spinlock_t *ptl;
 	struct page *page;
+	struct page *cow_page;
 	pte_t entry;
 	int anon = 0;
-	int charged = 0;
 	struct page *dirty_page = NULL;
 	struct vm_fault vmf;
 	int ret;
 	int page_mkwrite = 0;
 
+	/*
+	 * If we do COW later, allocate page befor taking lock_page()
+	 * on the file cache page. This will reduce lock holding time.
+	 */
+	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
+
+		if (unlikely(anon_vma_prepare(vma)))
+			return  VM_FAULT_OOM;
+
+		cow_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
+		if (!cow_page)
+			return VM_FAULT_OOM;
+
+		if (mem_cgroup_newpage_charge(cow_page, mm, GFP_KERNEL)) {
+			page_cache_release(cow_page);
+			return VM_FAULT_OOM;
+		}
+	} else
+		cow_page = NULL;
+
 	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
 	vmf.pgoff = pgoff;
 	vmf.flags = flags;
@@ -3119,12 +3139,13 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	ret = vma->vm_ops->fault(vma, &vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
 			    VM_FAULT_RETRY)))
-		return ret;
+		goto uncharge_out;
 
 	if (unlikely(PageHWPoison(vmf.page))) {
 		if (ret & VM_FAULT_LOCKED)
 			unlock_page(vmf.page);
-		return VM_FAULT_HWPOISON;
+		ret = VM_FAULT_HWPOISON;
+		goto uncharge_out;
 	}
 
 	/*
@@ -3142,23 +3163,8 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	page = vmf.page;
 	if (flags & FAULT_FLAG_WRITE) {
 		if (!(vma->vm_flags & VM_SHARED)) {
+			page = cow_page;
 			anon = 1;
-			if (unlikely(anon_vma_prepare(vma))) {
-				ret = VM_FAULT_OOM;
-				goto out;
-			}
-			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
-						vma, address);
-			if (!page) {
-				ret = VM_FAULT_OOM;
-				goto out;
-			}
-			if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL)) {
-				ret = VM_FAULT_OOM;
-				page_cache_release(page);
-				goto out;
-			}
-			charged = 1;
 			copy_user_highpage(page, vmf.page, address, vma);
 			__SetPageUptodate(page);
 		} else {
@@ -3227,8 +3233,8 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		/* no need to invalidate: a not-present page won't be cached */
 		update_mmu_cache(vma, address, page_table);
 	} else {
-		if (charged)
-			mem_cgroup_uncharge_page(page);
+		if (cow_page)
+			mem_cgroup_uncharge_page(cow_page);
 		if (anon)
 			page_cache_release(page);
 		else
@@ -3237,7 +3243,6 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	pte_unmap_unlock(page_table, ptl);
 
-out:
 	if (dirty_page) {
 		struct address_space *mapping = page->mapping;
 
@@ -3267,6 +3272,13 @@ out:
 unwritable_page:
 	page_cache_release(page);
 	return ret;
+uncharge_out:
+	/* fs's fault handler get error */
+	if (cow_page) {
+		mem_cgroup_uncharge_page(cow_page);
+		page_cache_release(cow_page);
+	}
+	return ret;
 }
 
 static int do_linear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
-- 
1.7.4.1


