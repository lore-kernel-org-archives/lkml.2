Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab2DPKsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:48:04 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:53110 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab2DPKpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:45:17 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V6 13/14] hugetlb: migrate memcg info from oldpage to new page during migration
Date: Mon, 16 Apr 2012 16:14:50 +0530
Message-Id: <1334573091-18602-14-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12041610-5816-0000-0000-000002274726
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

With HugeTLB pages, memcg is uncharged in compound page destructor.
Since we are holding a hugepage reference, we can be sure that old
page won't get uncharged till the last put_page(). On successful
migrate, we can move the memcg information to new page's page_cgroup
and mark the old page's page_cgroup unused.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/memcontrol.h |    8 ++++++++
 mm/memcontrol.c            |   28 ++++++++++++++++++++++++++++
 mm/migrate.c               |    4 ++++
 3 files changed, 40 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 70317e5..6f2d392 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -464,6 +464,8 @@ extern int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
 					  struct page *page);
 extern bool mem_cgroup_have_hugetlb_usage(struct cgroup *cgroup);
 
+extern void  mem_cgroup_hugetlb_migrate(struct page *oldhpage,
+					struct page *newhpage);
 #else
 static inline int
 mem_cgroup_hugetlb_charge_page(int idx, unsigned long nr_pages,
@@ -510,6 +512,12 @@ static inline bool mem_cgroup_have_hugetlb_usage(struct cgroup *cgroup)
 {
 	return 0;
 }
+
+static inline  void  mem_cgroup_hugetlb_migrate(struct page *oldhpage,
+						struct page *newhpage)
+{
+	return;
+}
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0b245fb..519d370 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3379,6 +3379,34 @@ err_out:
 out:
 	return ret;
 }
+
+void  mem_cgroup_hugetlb_migrate(struct page *oldhpage, struct page *newhpage)
+{
+	struct mem_cgroup *memcg;
+	struct page_cgroup *pc;
+
+	VM_BUG_ON(!PageHuge(oldhpage));
+
+	if (mem_cgroup_disabled())
+		return;
+
+	pc = lookup_page_cgroup(oldhpage);
+	lock_page_cgroup(pc);
+	memcg = pc->mem_cgroup;
+	pc->mem_cgroup = root_mem_cgroup;
+	ClearPageCgroupUsed(pc);
+	cgroup_exclude_rmdir(&memcg->css);
+	unlock_page_cgroup(pc);
+
+	/* move the mem_cg details to new cgroup */
+	pc = lookup_page_cgroup(newhpage);
+	lock_page_cgroup(pc);
+	pc->mem_cgroup = memcg;
+	SetPageCgroupUsed(pc);
+	unlock_page_cgroup(pc);
+	cgroup_release_and_wakeup_rmdir(&memcg->css);
+	return;
+}
 #endif /* CONFIG_MEM_RES_CTLR_HUGETLB */
 
 /*
diff --git a/mm/migrate.c b/mm/migrate.c
index d7eb82d..2b931e5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -928,6 +928,10 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 
 	if (anon_vma)
 		put_anon_vma(anon_vma);
+
+	if (!rc)
+		mem_cgroup_hugetlb_migrate(hpage, new_hpage);
+
 	unlock_page(hpage);
 out:
 	put_page(new_hpage);
-- 
1.7.10

