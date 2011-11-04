Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab1KDOrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:47:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517Ab1KDOre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:47:34 -0400
Message-ID: <4EB3FA89.6090601@redhat.com>
Date: Fri, 04 Nov 2011 15:45:29 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: linux-mm@kvack.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [RFC PATCH] Enforce RSS+Swap rlimit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently RSS rlimit is not enforced. We can not forbid a process to exceeds
its RSS limit and allow it swap out. That would hurts the performance of all
system, even when memory resources are plentiful.

Therefore, instead of enforcing a limit on rss usage alone, this patch enforces
a limit on rss+swap value. This is similar to memsw limits of cgroup.
If a process rss+swap usage exceeds RLIMIT_RSS max limit, he received a SIGBUS
signal. 

My tests show that code in do_anonymous_page() and __do_fault() indeed prevents
processes to get more memory than the limit and I haven't seen any adverse
effect, but so far I have no test coverage of the code in do_wp_page(). I'm
not sure how to test it.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 include/linux/mm.h |    7 +++++++
 mm/memory.c        |   21 +++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3dc3a8c..3b54ff1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1092,6 +1092,13 @@ static inline unsigned long get_mm_rss(struct mm_struct *mm)
 		get_mm_counter(mm, MM_ANONPAGES);
 }
 
+static inline unsigned long get_mm_memsw(struct mm_struct *mm)
+{
+	return get_mm_counter(mm, MM_FILEPAGES) +
+		get_mm_counter(mm, MM_ANONPAGES) +
+		get_mm_counter(mm, MM_SWAPENTS);
+}
+
 static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
 {
 	return max(mm->hiwater_rss, get_mm_rss(mm));
diff --git a/mm/memory.c b/mm/memory.c
index b2b8731..c7226f5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2661,8 +2661,14 @@ gotten:
 				dec_mm_counter_fast(mm, MM_FILEPAGES);
 				inc_mm_counter_fast(mm, MM_ANONPAGES);
 			}
-		} else
+		} else {
+			if (get_mm_memsw(mm) >=
+			    rlimit_max(RLIMIT_RSS) >> PAGE_SHIFT) {
+				ret |= VM_FAULT_SIGBUS;
+				goto release;
+			}
 			inc_mm_counter_fast(mm, MM_ANONPAGES);
+		}
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
@@ -2713,6 +2719,7 @@ gotten:
 	} else
 		mem_cgroup_uncharge_page(new_page);
 
+release:
 	if (new_page)
 		page_cache_release(new_page);
 unlock:
@@ -3073,6 +3080,7 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct page *page;
 	spinlock_t *ptl;
 	pte_t entry;
+	int ret = 0;
 
 	pte_unmap(page_table);
 
@@ -3109,6 +3117,10 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (!pte_none(*page_table))
 		goto release;
 
+	if (get_mm_memsw(mm) >=  rlimit_max(RLIMIT_RSS) >> PAGE_SHIFT) {
+		ret = VM_FAULT_SIGBUS;
+		goto release;
+	}
 	inc_mm_counter_fast(mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, address);
 setpte:
@@ -3118,7 +3130,7 @@ setpte:
 	update_mmu_cache(vma, address, page_table);
 unlock:
 	pte_unmap_unlock(page_table, ptl);
-	return 0;
+	return ret;
 release:
 	mem_cgroup_uncharge_page(page);
 	page_cache_release(page);
@@ -3263,6 +3275,10 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		entry = mk_pte(page, vma->vm_page_prot);
 		if (flags & FAULT_FLAG_WRITE)
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+		if (get_mm_memsw(mm) >=  rlimit_max(RLIMIT_RSS) >> PAGE_SHIFT) {
+			ret = VM_FAULT_SIGBUS;
+			goto unlock;
+		}
 		if (anon) {
 			inc_mm_counter_fast(mm, MM_ANONPAGES);
 			page_add_new_anon_rmap(page, vma, address);
@@ -3287,6 +3303,7 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			anon = 1; /* no anon but release faulted_page */
 	}
 
+unlock:
 	pte_unmap_unlock(page_table, ptl);
 
 	if (dirty_page) {
