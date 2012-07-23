Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab2GWBpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:45:39 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:45356 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab2GWBpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:45:36 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWAHiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2] memcg: add mem_cgroup_from_css() helper
Date: Mon, 23 Jul 2012 09:44:23 +0800
Message-Id: <1343007863-18144-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 12072301-9574-0000-0000-000003A9704E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog v2:
* fix too many args to mem_cgroup_from_css() (spotted by Kirill A. Shutemov)
* fix kernel build failed (spotted by Fengguang)

Add a mem_cgroup_from_css() helper to replace open-coded invokations of
container_of().  To clarify the code and to add a little more type safety.

Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

---
 mm/memcontrol.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 883283d..f0c7639 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -407,6 +407,12 @@ enum charge_type {
 static void mem_cgroup_get(struct mem_cgroup *memcg);
 static void mem_cgroup_put(struct mem_cgroup *memcg);
 
+static inline 
+struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *s)
+{
+	return container_of(s, struct mem_cgroup, css);
+}
+
 /* Writing them here to avoid exposing memcg's inner layout */
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
 #include <net/sock.h>
@@ -864,9 +870,8 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 
 struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
 {
-	return container_of(cgroup_subsys_state(cont,
-				mem_cgroup_subsys_id), struct mem_cgroup,
-				css);
+	return mem_cgroup_from_css(cgroup_subsys_state(cont,
+				mem_cgroup_subsys_id));
 }
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
@@ -879,8 +884,7 @@ struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 	if (unlikely(!p))
 		return NULL;
 
-	return container_of(task_subsys_state(p, mem_cgroup_subsys_id),
-				struct mem_cgroup, css);
+	return mem_cgroup_from_css(task_subsys_state(p, mem_cgroup_subsys_id));
 }
 
 struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
@@ -966,8 +970,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 		css = css_get_next(&mem_cgroup_subsys, id + 1, &root->css, &id);
 		if (css) {
 			if (css == &root->css || css_tryget(css))
-				memcg = container_of(css,
-						     struct mem_cgroup, css);
+				memcg = mem_cgroup_from_css(css);
 		} else
 			id = 0;
 		rcu_read_unlock();
@@ -2429,7 +2432,7 @@ static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
 	css = css_lookup(&mem_cgroup_subsys, id);
 	if (!css)
 		return NULL;
-	return container_of(css, struct mem_cgroup, css);
+	return mem_cgroup_from_css(css);
 }
 
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
-- 
1.7.7.6

