Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab2FIJCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 05:02:31 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:59264 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab2FIJAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 05:00:44 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V8 11/16] hugetlb/cgroup: Add charge/uncharge routines for hugetlb cgroup
Date: Sat,  9 Jun 2012 14:29:56 +0530
Message-Id: <1339232401-14392-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12060909-4790-0000-0000-00000327C662
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This patchset add the charge and uncharge routines for hugetlb cgroup.
This will be used in later patches when we allocate/free HugeTLB
pages.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 mm/hugetlb_cgroup.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 20a32c5..48efd5a 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -105,6 +105,93 @@ static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
 	   return -EBUSY;
 }
 
+int hugetlb_cgroup_charge_page(int idx, unsigned long nr_pages,
+			       struct hugetlb_cgroup **ptr)
+{
+	int ret = 0;
+	struct res_counter *fail_res;
+	struct hugetlb_cgroup *h_cg = NULL;
+	unsigned long csize = nr_pages * PAGE_SIZE;
+
+	if (hugetlb_cgroup_disabled())
+		goto done;
+	/*
+	 * We don't charge any cgroup if the compound page have less
+	 * than 3 pages.
+	 */
+	if (hstates[idx].order < 2)
+		goto done;
+again:
+	rcu_read_lock();
+	h_cg = hugetlb_cgroup_from_task(current);
+	if (!h_cg)
+		h_cg = root_h_cgroup;
+
+	if (!css_tryget(&h_cg->css)) {
+		rcu_read_unlock();
+		goto again;
+	}
+	rcu_read_unlock();
+
+	ret = res_counter_charge(&h_cg->hugepage[idx], csize, &fail_res);
+	css_put(&h_cg->css);
+done:
+	*ptr = h_cg;
+	return ret;
+}
+
+void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
+				  struct hugetlb_cgroup *h_cg,
+				  struct page *page)
+{
+	if (hugetlb_cgroup_disabled() || !h_cg)
+		return;
+
+	spin_lock(&hugetlb_lock);
+	if (hugetlb_cgroup_from_page(page)) {
+		hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg);
+		goto done;
+	}
+	set_hugetlb_cgroup(page, h_cg);
+done:
+	spin_unlock(&hugetlb_lock);
+	return;
+}
+
+void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
+				  struct page *page)
+{
+	struct hugetlb_cgroup *h_cg;
+	unsigned long csize = nr_pages * PAGE_SIZE;
+
+	if (hugetlb_cgroup_disabled())
+		return;
+
+	spin_lock(&hugetlb_lock);
+	h_cg = hugetlb_cgroup_from_page(page);
+	if (unlikely(!h_cg)) {
+		spin_unlock(&hugetlb_lock);
+		return;
+	}
+	set_hugetlb_cgroup(page, NULL);
+	spin_unlock(&hugetlb_lock);
+
+	res_counter_uncharge(&h_cg->hugepage[idx], csize);
+	return;
+}
+
+void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
+				    struct hugetlb_cgroup *h_cg)
+{
+	unsigned long csize = nr_pages * PAGE_SIZE;
+
+	if (hugetlb_cgroup_disabled() || !h_cg)
+		return;
+
+	res_counter_uncharge(&h_cg->hugepage[idx], csize);
+	return;
+}
+
 struct cgroup_subsys hugetlb_subsys = {
 	.name = "hugetlb",
 	.create     = hugetlb_cgroup_create,
-- 
1.7.10

