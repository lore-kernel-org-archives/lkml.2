Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2FMKbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:31:15 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54239 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab2FMK2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:28:20 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V9 14/15] hugetlb/cgroup: migrate hugetlb cgroup info from oldpage to new page during migration
Date: Wed, 13 Jun 2012 15:57:33 +0530
Message-Id: <1339583254-895-15-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12061310-4790-0000-0000-000003370E38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

With HugeTLB pages, hugetlb cgroup is uncharged in compound page destructor.  Since
we are holding a hugepage reference, we can be sure that old page won't
get uncharged till the last put_page().

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/hugetlb_cgroup.h |    8 ++++++++
 mm/hugetlb_cgroup.c            |   20 ++++++++++++++++++++
 mm/migrate.c                   |    5 +++++
 3 files changed, 33 insertions(+)

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index bd8bc98..e9e6d74 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -63,6 +63,8 @@ extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
 extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg);
 extern int hugetlb_cgroup_file_init(int idx) __init;
+extern void hugetlb_cgroup_migrate(struct page *oldhpage,
+				   struct page *newhpage);
 
 #else
 static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
@@ -114,5 +116,11 @@ static inline int __init hugetlb_cgroup_file_init(int idx)
 	return 0;
 }
 
+static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
+					  struct page *newhpage)
+{
+	return;
+}
+
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 64e93e0..8e7ca0a 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -388,6 +388,26 @@ int __init hugetlb_cgroup_file_init(int idx)
 	return 0;
 }
 
+void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
+{
+	struct hugetlb_cgroup *h_cg;
+
+	if (hugetlb_cgroup_disabled())
+		return;
+
+	VM_BUG_ON(!PageHuge(oldhpage));
+	spin_lock(&hugetlb_lock);
+	h_cg = hugetlb_cgroup_from_page(oldhpage);
+	set_hugetlb_cgroup(oldhpage, NULL);
+	cgroup_exclude_rmdir(&h_cg->css);
+
+	/* move the h_cg details to new cgroup */
+	set_hugetlb_cgroup(newhpage, h_cg);
+	spin_unlock(&hugetlb_lock);
+	cgroup_release_and_wakeup_rmdir(&h_cg->css);
+	return;
+}
+
 struct cgroup_subsys hugetlb_subsys = {
 	.name = "hugetlb",
 	.create     = hugetlb_cgroup_create,
diff --git a/mm/migrate.c b/mm/migrate.c
index fdce3a2..6c37c51 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -33,6 +33,7 @@
 #include <linux/memcontrol.h>
 #include <linux/syscalls.h>
 #include <linux/hugetlb.h>
+#include <linux/hugetlb_cgroup.h>
 #include <linux/gfp.h>
 
 #include <asm/tlbflush.h>
@@ -931,6 +932,10 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 
 	if (anon_vma)
 		put_anon_vma(anon_vma);
+
+	if (!rc)
+		hugetlb_cgroup_migrate(hpage, new_hpage);
+
 	unlock_page(hpage);
 out:
 	put_page(new_hpage);
-- 
1.7.10

