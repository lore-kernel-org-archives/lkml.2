Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2FIJA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 05:00:27 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60635 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2FIJAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 05:00:23 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V8 02/16] hugetlb: don't use ERR_PTR with VM_FAULT* values
Date: Sat,  9 Jun 2012 14:29:47 +0530
Message-Id: <1339232401-14392-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12060909-8256-0000-0000-000002DBADE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

The current use of VM_FAULT_* codes with ERR_PTR requires us to ensure
VM_FAULT_* values will not exceed MAX_ERRNO value. Decouple the
VM_FAULT_* values from MAX_ERRNO.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 mm/hugetlb.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c868309..34a7e23 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1123,10 +1123,10 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	 */
 	chg = vma_needs_reservation(h, vma, addr);
 	if (chg < 0)
-		return ERR_PTR(-VM_FAULT_OOM);
+		return ERR_PTR(-ENOMEM);
 	if (chg)
 		if (hugepage_subpool_get_pages(spool, chg))
-			return ERR_PTR(-VM_FAULT_SIGBUS);
+			return ERR_PTR(-ENOSPC);
 
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
@@ -1136,7 +1136,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
 			hugepage_subpool_put_pages(spool, chg);
-			return ERR_PTR(-VM_FAULT_SIGBUS);
+			return ERR_PTR(-ENOSPC);
 		}
 	}
 
@@ -2496,6 +2496,7 @@ retry_avoidcopy:
 	new_page = alloc_huge_page(vma, address, outside_reserve);
 
 	if (IS_ERR(new_page)) {
+		long err = PTR_ERR(new_page);
 		page_cache_release(old_page);
 
 		/*
@@ -2524,7 +2525,10 @@ retry_avoidcopy:
 
 		/* Caller expects lock to be held */
 		spin_lock(&mm->page_table_lock);
-		return -PTR_ERR(new_page);
+		if (err == -ENOMEM)
+			return VM_FAULT_OOM;
+		else
+			return VM_FAULT_SIGBUS;
 	}
 
 	/*
@@ -2642,7 +2646,11 @@ retry:
 			goto out;
 		page = alloc_huge_page(vma, address, 0);
 		if (IS_ERR(page)) {
-			ret = -PTR_ERR(page);
+			ret = PTR_ERR(page);
+			if (ret == -ENOMEM)
+				ret = VM_FAULT_OOM;
+			else
+				ret = VM_FAULT_SIGBUS;
 			goto out;
 		}
 		clear_huge_page(page, address, pages_per_huge_page(h));
-- 
1.7.10

