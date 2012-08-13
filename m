Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab2HMLQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:16:12 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:56170 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2HMLQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:16:10 -0400
Message-ID: <5028E1F2.5070407@linux.vnet.ibm.com>
Date: Mon, 13 Aug 2012 19:16:02 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 08/12] thp: release page in page pre-alloc path
References: <5028E12C.70101@linux.vnet.ibm.com>
In-Reply-To: <5028E12C.70101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081311-6102-0000-0000-0000020B3E06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NUMA is enabled, we can release the page in the page pre-alloc operation,
then the CONFIG_NUMA dependent code can be reduced

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/huge_memory.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 42d3d74..050b8d0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1879,15 +1879,12 @@ static void collapse_huge_page(struct mm_struct *mm,
 		*hpage = ERR_PTR(-ENOMEM);
 		return;
 	}
+	*hpage = new_page;
 	count_vm_event(THP_COLLAPSE_ALLOC);
 #endif

-	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
-#ifdef CONFIG_NUMA
-		put_page(new_page);
-#endif
+	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL)))
 		return;
-	}

 	/*
 	 * Prevent all access to pagetables with the exception of
@@ -1992,9 +1989,8 @@ static void collapse_huge_page(struct mm_struct *mm,
 	prepare_pmd_huge_pte(pgtable, mm);
 	spin_unlock(&mm->page_table_lock);

-#ifndef CONFIG_NUMA
 	*hpage = NULL;
-#endif
+
 	khugepaged_pages_collapsed++;
 out_up_write:
 	up_write(&mm->mmap_sem);
@@ -2002,9 +1998,6 @@ out_up_write:

 out:
 	mem_cgroup_uncharge_page(new_page);
-#ifdef CONFIG_NUMA
-	put_page(new_page);
-#endif
 	goto out_up_write;
 }

@@ -2275,8 +2268,6 @@ static void khugepaged_do_scan(void)
 	barrier(); /* write khugepaged_pages_to_scan to local stack */

 	while (progress < pages) {
-		cond_resched();
-
 #ifndef CONFIG_NUMA
 		if (!hpage)
 			hpage = khugepaged_alloc_hugepage(&wait);
@@ -2289,8 +2280,12 @@ static void khugepaged_do_scan(void)
 				break;
 			wait = false;
 			khugepaged_alloc_sleep();
+		} else if (hpage) {
+			put_page(hpage);
+			hpage = NULL;
 		}
 #endif
+		cond_resched();

 		if (unlikely(kthread_should_stop() || freezing(current)))
 			break;
-- 
1.7.7.6

