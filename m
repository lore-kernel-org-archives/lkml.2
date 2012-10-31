Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab2JaEXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 00:23:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35071 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab2JaEXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 00:23:07 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] hugetlb: do not fail in hugetlb_cgroup_pre_destroy
Date: Tue, 30 Oct 2012 21:22:44 -0700
Message-Id: <1351657365-25055-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351657365-25055-1-git-send-email-tj@kernel.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

Now that pre_destroy callbacks are called from the context where neither
any task can attach the group nor any children group can be added there
is no other way to fail from hugetlb_pre_destroy.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Glauber Costa <glommer@parallels.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/hugetlb_cgroup.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index a3f358f..dc595c6 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -159,14 +159,9 @@ static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
 {
 	struct hstate *h;
 	struct page *page;
-	int ret = 0, idx = 0;
+	int idx = 0;
 
 	do {
-		if (cgroup_task_count(cgroup) ||
-		    !list_empty(&cgroup->children)) {
-			ret = -EBUSY;
-			goto out;
-		}
 		for_each_hstate(h) {
 			spin_lock(&hugetlb_lock);
 			list_for_each_entry(page, &h->hugepage_activelist, lru)
@@ -177,8 +172,8 @@ static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
 		}
 		cond_resched();
 	} while (hugetlb_cgroup_have_usage(cgroup));
-out:
-	return ret;
+
+	return 0;
 }
 
 int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
-- 
1.7.11.7

