Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab2FIJAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 05:00:47 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:38771 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2FIJAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 05:00:45 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V8 12/16] hugetlb/cgroup: Add support for cgroup removal
Date: Sat,  9 Jun 2012 14:29:57 +0530
Message-Id: <1339232401-14392-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12060909-8878-0000-0000-000002D54225
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This patch add support for cgroup removal. If we don't have parent
cgroup, the charges are moved to root cgroup.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 mm/hugetlb_cgroup.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 48efd5a..9458fe3 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -99,10 +99,87 @@ static void hugetlb_cgroup_destroy(struct cgroup *cgroup)
 	kfree(h_cgroup);
 }
 
+
+static int hugetlb_cgroup_move_parent(int idx, struct cgroup *cgroup,
+				      struct page *page)
+{
+	int csize;
+	struct res_counter *counter;
+	struct res_counter *fail_res;
+	struct hugetlb_cgroup *page_hcg;
+	struct hugetlb_cgroup *h_cg   = hugetlb_cgroup_from_cgroup(cgroup);
+	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(cgroup);
+
+	if (!get_page_unless_zero(page))
+		goto out;
+
+	page_hcg = hugetlb_cgroup_from_page(page);
+	/*
+	 * We can have pages in active list without any cgroup
+	 * ie, hugepage with less than 3 pages. We can safely
+	 * ignore those pages.
+	 */
+	if (!page_hcg || page_hcg != h_cg)
+		goto err_out;
+
+	csize = PAGE_SIZE << compound_order(page);
+	if (!parent) {
+		parent = root_h_cgroup;
+		/* root has no limit */
+		res_counter_charge_nofail(&parent->hugepage[idx],
+					  csize, &fail_res);
+	}
+	counter = &h_cg->hugepage[idx];
+	res_counter_uncharge_until(counter, counter->parent, csize);
+
+	set_hugetlb_cgroup(page, parent);
+err_out:
+	put_page(page);
+out:
+	return 0;
+}
+
+/*
+ * Force the hugetlb cgroup to empty the hugetlb resources by moving them to
+ * the parent cgroup.
+ */
 static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
 {
-	/* We will add the cgroup removal support in later patches */
-	   return -EBUSY;
+	struct hstate *h;
+	struct page *page;
+	int ret = 0, idx = 0;
+
+	do {
+		if (cgroup_task_count(cgroup) ||
+		    !list_empty(&cgroup->children)) {
+			ret = -EBUSY;
+			goto out;
+		}
+		/*
+		 * If the task doing the cgroup_rmdir got a signal
+		 * we don't really need to loop till the hugetlb resource
+		 * usage become zero.
+		 */
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			goto out;
+		}
+		for_each_hstate(h) {
+			spin_lock(&hugetlb_lock);
+			list_for_each_entry(page, &h->hugepage_activelist, lru) {
+				ret = hugetlb_cgroup_move_parent(idx, cgroup, page);
+				if (ret) {
+					spin_unlock(&hugetlb_lock);
+					goto out;
+				}
+			}
+			spin_unlock(&hugetlb_lock);
+			idx++;
+		}
+		cond_resched();
+	} while (hugetlb_cgroup_have_usage(cgroup));
+out:
+	return ret;
 }
 
 int hugetlb_cgroup_charge_page(int idx, unsigned long nr_pages,
-- 
1.7.10

