Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab1BZO4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 09:56:53 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55131 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1BZO4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 09:56:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:organization:to:subject:date:user-agent:cc
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=CuQI0K2oC1YKOzBGT0FrPsc8JR9SKFVjOTLaYQ9nBJ1PL0+C2FIOSGjcD8nHcLUnqu
         NRth5ySJwM4By8NiTI21fPXVJp1gj4Rb1Rsnkp8jbqF5VkFbmgEVuCxeMhCZxPmhvIhv
         BKB5VEwSiIp/+liUmiXs8Tjq0bOzClkBDS7Hs=
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
Organization: Nanjing University
To: Izik Eidus <ieidus@redhat.com>
Subject: [PATCH] ksm: add vm_stat and meminfo entry to reflect pte mapping to ksm pages
Date: Sat, 26 Feb 2011 22:56:31 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.37.1; KDE/4.6.0; i686; ; )
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Message-Id: <201102262256.31565.nai.xia@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ksm_pages_sharing is updated by ksmd periodically.  In some cases, it cannot 
reflect the actual savings and makes the benchmarks on volatile VMAs very 
inaccurate.

This patch add a vm_stat entry and let the /proc/meminfo show information 
about how much virutal address pte is being mapped to ksm pages.  With default 
ksm paramters (pages_to_scan==100 && sleep_millisecs==20), this can result in 
50% more accurate averaged savings result for the following test program. 
Bigger sleep_millisecs values will increase this deviation. 


--- test.c-----
/*
 * This test program triggers frequent faults on merged ksm pages but 
 * still keeps the faulted pages mergeable.
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

#define MADV_MERGEABLE   12
#define MADV_UNMERGEABLE 13


#define SIZE (1000*1024*1024)
#define SEED	1
#define PAGE_SIZE 4096

int main(int argc, char **argv)
{
	char *p;
	int j;
	long feed = 1, new_feed, tmp;
	unsigned int offset;
	int status;
	int ret;

	pid_t child;

	child = fork();

	p = mmap(NULL, SIZE, PROT_WRITE|PROT_READ, 
		 MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
    	if (p == MAP_FAILED) {
    		printf("mmap error\n");
    		return 0;
    	}

	ret = madvise(p, SIZE, MADV_MERGEABLE);

	if (ret==-1) {
		printf("madvise failed \n");
		return 0;
	}

	memset(p, feed, SIZE);

	while (1) {
		for (j=0; j<SIZE; j+= PAGE_SIZE) {
			    p[j] *= p[j]*1;
		}
	}

	return 0;
}
----test.c ends-------

Some of the patch lines removes trailing spaces in related files.

Signed-off-by: Nai Xia <nai.xia@gmail.com>
---
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index ed257d1..dd0ff82 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -87,6 +87,9 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		"SUnreclaim:     %8lu kB\n"
 		"KernelStack:    %8lu kB\n"
 		"PageTables:     %8lu kB\n"
+#ifdef CONFIG_KSM
+		"KsmSharing:     %8lu kB\n"
+#endif
 #ifdef CONFIG_QUICKLIST
 		"Quicklists:     %8lu kB\n"
 #endif
@@ -145,6 +148,9 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		K(global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		global_page_state(NR_KERNEL_STACK) * THREAD_SIZE / 1024,
 		K(global_page_state(NR_PAGETABLE)),
+#ifdef CONFIG_KSM
+		K(global_page_state(NR_KSM_PAGES_SHARING)),
+#endif
 #ifdef CONFIG_QUICKLIST
 		K(quicklist_total_size()),
 #endif
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 02ecb01..01450e3 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -115,6 +115,9 @@ enum zone_stat_item {
 	NUMA_OTHER,		/* allocation from other node */
 #endif
 	NR_ANON_TRANSPARENT_HUGEPAGES,
+#ifdef CONFIG_KSM
+	NR_KSM_PAGES_SHARING,
+#endif
 	NR_VM_ZONE_STAT_ITEMS };
 
 /*
@@ -344,7 +347,7 @@ struct zone {
 	ZONE_PADDING(_pad1_)
 
 	/* Fields commonly accessed by the page reclaim scanner */
-	spinlock_t		lru_lock;	
+	spinlock_t		lru_lock;
 	struct zone_lru {
 		struct list_head list;
 	} lru[NR_LRU_LISTS];
@@ -722,7 +725,7 @@ static inline int is_normal_idx(enum zone_type idx)
 }
 
 /**
- * is_highmem - helper function to quickly check if a struct zone is a 
+ * is_highmem - helper function to quickly check if a struct zone is a
  *              highmem zone or not.  This is an attempt to keep references
  *              to ZONE_{DMA/NORMAL/HIGHMEM/etc} in general code to a 
minimum.
  * @zone - pointer to struct zone variable
diff --git a/mm/ksm.c b/mm/ksm.c
index c2b2a94..3c22d30 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -897,6 +897,7 @@ static int try_to_merge_one_page(struct vm_area_struct 
*vma,
 	 */
 	if (write_protect_page(vma, page, &orig_pte) == 0) {
 		if (!kpage) {
+			long mapcount = page_mapcount(page);
 			/*
 			 * While we hold page lock, upgrade page from
 			 * PageAnon+anon_vma to PageKsm+NULL stable_node:
@@ -904,6 +905,10 @@ static int try_to_merge_one_page(struct vm_area_struct 
*vma,
 			 */
 			set_page_stable_node(page, NULL);
 			mark_page_accessed(page);
+			if (mapcount)
+				add_zone_page_state(page_zone(page),
+						    NR_KSM_PAGES_SHARING,
+						    mapcount);
 			err = 0;
 		} else if (pages_identical(page, kpage))
 			err = replace_page(vma, page, kpage, orig_pte);
diff --git a/mm/memory.c b/mm/memory.c
index 8e8c183..d86abe9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -719,6 +719,8 @@ copy_one_pte(struct mm_struct *dst_mm, struct mm_struct 
*src_mm,
 			rss[MM_ANONPAGES]++;
 		else
 			rss[MM_FILEPAGES]++;
+		if (PageKsm(page)) /* follows page_dup_rmap() */
+			inc_zone_page_state(page, NR_KSM_PAGES_SHARING);
 	}
 
 out_set_pte:
@@ -1423,7 +1425,7 @@ int __get_user_pages(struct task_struct *tsk, struct 
mm_struct *mm,
 
 	VM_BUG_ON(!!pages != !!(gup_flags & FOLL_GET));
 
-	/* 
+	/*
 	 * Require read or write permissions.
 	 * If FOLL_FORCE is set, we only require the "MAY" flags.
 	 */
diff --git a/mm/rmap.c b/mm/rmap.c
index f21f4a1..0d7ab31 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -801,9 +801,9 @@ void page_move_anon_rmap(struct page *page,
 
 /**
  * __page_set_anon_rmap - set up new anonymous rmap
- * @page:	Page to add to rmap	
+ * @page:	Page to add to rmap
  * @vma:	VM area to add page to.
- * @address:	User virtual address of the mapping	
+ * @address:	User virtual address of the mapping
  * @exclusive:	the page is exclusively owned by the current process
  */
 static void __page_set_anon_rmap(struct page *page,
@@ -889,8 +889,10 @@ void do_page_add_anon_rmap(struct page *page,
 			__inc_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
 	}
-	if (unlikely(PageKsm(page)))
+	if (unlikely(PageKsm(page))) {
+		__inc_zone_page_state(page, NR_KSM_PAGES_SHARING);
 		return;
+	}
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
@@ -949,6 +951,9 @@ void page_add_file_rmap(struct page *page)
  */
 void page_remove_rmap(struct page *page)
 {
+	if (PageKsm(page))
+		__dec_zone_page_state(page, NR_KSM_PAGES_SHARING);
+
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
 		return;

---

  
