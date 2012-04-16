Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2DPKp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:45:27 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42280 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2DPKpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:45:22 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V6 02/14] hugetlbfs: don't use ERR_PTR with VM_FAULT* values
Date: Mon, 16 Apr 2012 16:14:39 +0530
Message-Id: <1334573091-18602-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12041610-2000-0000-0000-000007204B3E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Using VM_FAULT_* codes with ERR_PTR will require us to make sure
VM_FAULT_* values will not exceed MAX_ERRNO value.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 mm/hugetlb.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 766eb90..5a472a5 100644
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
 
@@ -2486,6 +2486,7 @@ retry_avoidcopy:
 	new_page = alloc_huge_page(vma, address, outside_reserve);
 
 	if (IS_ERR(new_page)) {
+		int err = PTR_ERR(new_page);
 		page_cache_release(old_page);
 
 		/*
@@ -2515,7 +2516,10 @@ retry_avoidcopy:
 
 		/* Caller expects lock to be held */
 		spin_lock(&mm->page_table_lock);
-		return -PTR_ERR(new_page);
+		if (err == -ENOMEM)
+			return VM_FAULT_OOM;
+		else
+			return VM_FAULT_SIGBUS;
 	}
 
 	/*
@@ -2633,7 +2637,11 @@ retry:
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

