Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab2ILM5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:57:38 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55061 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2ILM5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:57:36 -0400
Message-ID: <505086B3.6070603@linux.vnet.ibm.com>
Date: Wed, 12 Sep 2012 20:57:23 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] thp: introduce khugepaged_cleanup_page
References: <50508632.9090003@linux.vnet.ibm.com>
In-Reply-To: <50508632.9090003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091212-1396-0000-0000-000001DCFDFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is used to release the page on the fail path, then the page need not
be cleaned up in khugepaged_prealloc_page anymore

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/huge_memory.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5622347..de0a028 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1827,9 +1827,6 @@ static bool khugepaged_prealloc_page(struct page **hpage, bool *wait)
 		*wait = false;
 		*hpage = NULL;
 		khugepaged_alloc_sleep();
-	} else if (*hpage) {
-		put_page(*hpage);
-		*hpage = NULL;
 	}

 	return true;
@@ -1863,6 +1860,13 @@ static struct page
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	return *hpage;
 }
+
+static void khugepaged_cleanup_page(struct page **hpage)
+{
+	VM_BUG_ON(!*hpage);
+	put_page(*hpage);
+	*hpage = NULL;
+}
 #else
 static struct page *khugepaged_alloc_hugepage(bool *wait)
 {
@@ -1903,6 +1907,10 @@ static struct page
 	VM_BUG_ON(!*hpage);
 	return  *hpage;
 }
+
+static void khugepaged_cleanup_page(struct page **hpage)
+{
+}
 #endif

 static void collapse_huge_page(struct mm_struct *mm,
@@ -1936,8 +1944,10 @@ static void collapse_huge_page(struct mm_struct *mm,
 	if (!new_page)
 		return;

-	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL)))
+	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
+		khugepaged_cleanup_page(hpage);
 		return;
+	}

 	/*
 	 * Prevent all access to pagetables with the exception of
@@ -2048,6 +2058,7 @@ out_up_write:
 	return;

 out:
+	khugepaged_cleanup_page(hpage);
 	mem_cgroup_uncharge_page(new_page);
 	goto out_up_write;
 }
-- 
1.7.7.6

