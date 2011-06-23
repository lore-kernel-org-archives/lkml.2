Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204Ab1FWKJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 06:09:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44616 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759159Ab1FWKJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 06:09:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 23 Jun 2011 19:01:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Lutz Vieweg <lvml@5t9.de>
Subject: [PATCH] mm: preallocate page before lock_page at filemap COW.
 (WasRe: [PATCH V2] mm: Do not keep page locked during page fault while
 charging it for memcg
Message-Id: <20110623190157.1bc8cbb9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110623090204.GE31593@tiehlicka.suse.cz>
References: <20110622120635.GB14343@tiehlicka.suse.cz>
	<20110622121516.GA28359@infradead.org>
	<20110622123204.GC14343@tiehlicka.suse.cz>
	<20110623150842.d13492cd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110623074133.GA31593@tiehlicka.suse.cz>
	<20110623170811.16f4435f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110623090204.GE31593@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011 11:02:04 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 23-06-11 17:08:11, KAMEZAWA Hiroyuki wrote:
> > On Thu, 23 Jun 2011 09:41:33 +0200
> > Michal Hocko <mhocko@suse.cz> wrote:
> [...]
> > > Other than that:
> > > Reviewed-by: Michal Hocko <mhocko@suse.cz>
> > > 
> > 
> > I found the page is added to LRU before charging. (In this case,
> > memcg's LRU is ignored.) I'll post a new version with a fix.
> 
> Yes, you are right. I have missed that.
> This means that we might race with reclaim which could evict the COWed
> page wich in turn would uncharge that page even though we haven't
> charged it yet.
> 
> Can we postpone page_add_new_anon_rmap to the charging path or it would
> just race somewhere else?
> 

I got a different idea. How about this ?
I think this will have benefit for non-memcg users under OOM, too.

A concerns is VM_FAULT_RETRY case but wait-for-lock will be much heavier
than preallocation + free-for-retry cost.

(I'm sorry I'll not be very active until the next week, so feel free to
 post your own version if necessary.)

This is onto -rc4 and worked well on my test.

==
>From 7b0aa038f3a1c6a479a3ce6acb38c7d2740d7a75 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 23 Jun 2011 18:50:32 +0900
Subject: [PATCH] mm: preallocate page before lock_page() at filemap COW.

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
by hands (or push reboot...) This is because some important
page in a shared library are locked.

Considering again, the new page is not necessary to be allocated
with lock_page() held. So....

This patch moves "charge" and memory allocation for COW page
before lock_page(). Then, we can avoid scanning LRU with holding
a lock on a page.

Then, above livelock disappears.

Reported-by: Lutz Vieweg <lvml@5t9.de>
Original-idea-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changelog:
  - change the logic from "do charge after unlock" to
    "do charge before lock".
---
 mm/memory.c |   56 ++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 87d9353..845378c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3127,14 +3127,34 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -3143,12 +3163,13 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -3166,23 +3187,8 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -3251,8 +3257,8 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -3261,7 +3267,6 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	pte_unmap_unlock(page_table, ptl);
 
-out:
 	if (dirty_page) {
 		struct address_space *mapping = page->mapping;
 
@@ -3291,6 +3296,13 @@ out:
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



