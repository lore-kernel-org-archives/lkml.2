Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1BUTI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:08:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:24888 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab1BUTIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:08:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,201,1297065600"; 
   d="scan'208";a="605050281"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, aarcange@redhat.com,
        lwoodman@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 8/8] Add VM counters for transparent hugepages
Date: Mon, 21 Feb 2011 11:07:50 -0800
Message-Id: <1298315270-10434-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298315270-10434-1-git-send-email-andi@firstfloor.org>
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I found it difficult to make sense of transparent huge pages without
having any counters for its actions. Add some counters to vmstat
for allocation of transparent hugepages and fallback to smaller
pages.

Optional patch, but useful for development and understanding the system.

Cc: aarcange@redhat.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/vmstat.h |    7 +++++++
 mm/huge_memory.c       |   13 ++++++++++---
 mm/vmstat.c            |    8 ++++++++
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 9b5c63d..7794d1a7 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -58,6 +58,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		UNEVICTABLE_PGCLEARED,	/* on COW, page truncate */
 		UNEVICTABLE_PGSTRANDED,	/* unable to isolate on unlock */
 		UNEVICTABLE_MLOCKFREED,
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	        THP_DIRECT_ALLOC,
+		THP_DAEMON_ALLOC,	
+		THP_DIRECT_FALLBACK,	
+		THP_DAEMON_ALLOC_FAILED,
+		THP_SPLIT,
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 877756e..4ef8c32 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -680,13 +680,15 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			return VM_FAULT_OOM;
 		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
 					  vma, haddr, numa_node_id(), 0);
-		if (unlikely(!page))
+		if (unlikely(!page)) {
+			count_vm_event(THP_DIRECT_FALLBACK);
 			goto out;
+		}
 		if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
 			put_page(page);
 			goto out;
 		}
-
+		count_vm_event(THP_DIRECT_ALLOC);
 		return __do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page);
 	}
 out:
@@ -909,6 +911,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		new_page = NULL;
 
 	if (unlikely(!new_page)) {
+		count_vm_event(THP_DIRECT_FALLBACK);
 		ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
 						   pmd, orig_pmd, page, haddr);
 		put_page(page);
@@ -921,7 +924,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		ret |= VM_FAULT_OOM;
 		goto out;
 	}
-
+	count_vm_event(THP_DIRECT_ALLOC);
 	copy_user_huge_page(new_page, page, haddr, vma, HPAGE_PMD_NR);
 	__SetPageUptodate(new_page);
 
@@ -1780,6 +1783,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 				      node, __GFP_OTHER_NODE);
 	if (unlikely(!new_page)) {
 		up_read(&mm->mmap_sem);
+		count_vm_event(THP_DAEMON_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
 		return;
 	}
@@ -2286,6 +2290,9 @@ void __split_huge_page_pmd(struct mm_struct *mm, pmd_t *pmd)
 		spin_unlock(&mm->page_table_lock);
 		return;
 	}
+
+	count_vm_event(THP_SPLIT);
+
 	page = pmd_page(*pmd);
 	VM_BUG_ON(!page_count(page));
 	get_page(page);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 2b461ed..f3ab7e9 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -946,6 +946,14 @@ static const char * const vmstat_text[] = {
 	"unevictable_pgs_stranded",
 	"unevictable_pgs_mlockfreed",
 #endif
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	"thp_direct_alloc",
+	"thp_daemon_alloc",
+	"thp_direct_fallback",
+	"thp_daemon_alloc_failed",
+	"thp_split",
+#endif
 };
 
 static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
-- 
1.7.4

