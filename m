Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2GKDw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 23:52:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34570 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab2GKDwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 23:52:24 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/hugetlb_cgroup: Add list_del to remove unused page from hugepage_activelist when hugepage migration
Date: Wed, 11 Jul 2012 11:51:58 +0800
Message-Id: <1341978718-6423-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

hugepage_activelist is used to track currently used HugeTLB pages.
We can find the in-use HugeTLB pages to support HugeTLB cgroup
removal. Don't keep unused page in hugetlb_activelist too long.
Otherwise, on cgroup removal we should update the unused page's 
charge to parent count. To reduce this overhead, remove unused page 
from hugepage_activelist immediately.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/hugetlb_cgroup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index b834e8d..d819d66 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -398,6 +398,7 @@ void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 	spin_lock(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(oldhpage);
 	set_hugetlb_cgroup(oldhpage, NULL);
+	list_del(&oldhpage->lru);
 
 	/* move the h_cg details to new cgroup */
 	set_hugetlb_cgroup(newhpage, h_cg);
-- 
1.7.5.4

