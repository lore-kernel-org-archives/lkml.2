Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2GKDMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 23:12:25 -0400
Received: from mail-yw0-f52.google.com ([209.85.213.52]:45929 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2GKDMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 23:12:23 -0400
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2012 23:12:23 EDT
From: Wanpeng Li <liwp.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/hugetlb_cgroup: Add huge_page_order check to avoid incorrectly uncharge
Date: Wed, 11 Jul 2012 11:03:16 +0800
Message-Id: <1341975796-5730-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Against linux-next:

Function alloc_huge_page will call hugetlb_cgroup_charge_cgroup
to charge pages, the compound page have less than 3 pages will not
charge to hugetlb cgroup. When alloc_huge_page fails it will call
hugetlb_cgroup_uncharge_cgroup to uncharge pages, however,
hugetlb_cgroup_uncharge_cgroup doesn't have huge_page_order check.
That means it will uncharge pages even if the compound page have less
than 3 pages. Add huge_page_order check to avoid this incorrectly
uncharge.

Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/hugetlb_cgroup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index b834e8d..2b9e214 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -252,6 +252,9 @@ void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
+
+	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
+		return;
 
 	res_counter_uncharge(&h_cg->hugepage[idx], csize);
 	return;
-- 
1.7.5.4

