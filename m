Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab2FOMlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:41:46 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:33511 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab2FOMln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:41:43 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 2/4] hugetlb: Move all the in use pages to active list
Date: Fri, 15 Jun 2012 18:11:20 +0530
Message-Id: <1339764082-1611-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339764082-1611-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1339764082-1611-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12061512-4790-0000-0000-000003404428
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

When we fail to allocate pages from the reserve pool, hugetlb
do try to allocate huge pages using alloc_buddy_huge_page.
Add these to the active list. We also need to add the huge
page we allocate when we soft offline the oldpage to active
list.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 mm/hugetlb.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c57740b..ec7b86e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -928,8 +928,14 @@ struct page *alloc_huge_page_node(struct hstate *h, int nid)
 	page = dequeue_huge_page_node(h, nid);
 	spin_unlock(&hugetlb_lock);
 
-	if (!page)
+	if (!page) {
 		page = alloc_buddy_huge_page(h, nid);
+		if (page) {
+			spin_lock(&hugetlb_lock);
+			list_move(&page->lru, &h->hugepage_activelist);
+			spin_unlock(&hugetlb_lock);
+		}
+	}
 
 	return page;
 }
@@ -1155,6 +1161,9 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 			hugepage_subpool_put_pages(spool, chg);
 			return ERR_PTR(-ENOSPC);
 		}
+		spin_lock(&hugetlb_lock);
+		list_move(&page->lru, &h->hugepage_activelist);
+		spin_unlock(&hugetlb_lock);
 	}
 
 	set_page_private(page, (unsigned long)spool);
-- 
1.7.10

