Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2KZSs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:48:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab2KZSsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:48:13 -0500
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>,
        Li Zefan <lizefan@huawei.com>
Subject: [patch v2 5/6] memcg: further simplify mem_cgroup_iter
Date: Mon, 26 Nov 2012 19:47:50 +0100
Message-Id: <1353955671-14385-6-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_iter basically does two things currently. It takes care of
the house keeping (reference counting, raclaim cookie) and it iterates
through a hierarchy tree (by using cgroup generic tree walk).
The code would be much more easier to follow if we move the iteration
outside of the function (to __mem_cgrou_iter_next) so the distinction
is more clear.
This patch doesn't introduce any functional changes.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   79 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d1bc0e8..a5018bc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1044,6 +1044,51 @@ struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 	return memcg;
 }
 
+/*
+ * Returns a next (in a pre-order walk) alive memcg (with elevated css
+ * ref. count) or NULL if the whole root's subtree has been visited.
+ *
+ * helper function to be used by mem_cgroup_iter
+ */
+static struct mem_cgroup *__mem_cgrou_iter_next(struct mem_cgroup *root,
+		struct mem_cgroup *last_visited)
+{
+	struct cgroup *prev_cgroup, *next_cgroup;
+
+	/*
+	 * Root is not visited by cgroup iterators so it needs an
+	 * explicit visit.
+	 */
+	if (!last_visited)
+		return root;
+
+	prev_cgroup = (last_visited == root) ? NULL
+		: last_visited->css.cgroup;
+skip_node:
+	next_cgroup = cgroup_next_descendant_pre(
+			prev_cgroup, root->css.cgroup);
+
+	/*
+	 * Even if we found a group we have to make sure it is
+	 * alive. css && !memcg means that the groups should be
+	 * skipped and we should continue the tree walk.
+	 * last_visited css is safe to use because it is
+	 * protected by css_get and the tree walk is rcu safe.
+	 */
+	if (next_cgroup) {
+		struct mem_cgroup *mem = mem_cgroup_from_cont(
+				next_cgroup);
+		if (css_tryget(&mem->css))
+			return mem;
+		else {
+			prev_cgroup = next_cgroup;
+			goto skip_node;
+		}
+	}
+
+	return NULL;
+}
+
 /**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
  * @root: hierarchy root
@@ -1106,39 +1151,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 			}
 		}
 
-		/*
-		 * Root is not visited by cgroup iterators so it needs an
-		 * explicit visit.
-		 */
-		if (!last_visited) {
-			memcg = root;
-		} else {
-			struct cgroup *prev_cgroup, *next_cgroup;
-
-			prev_cgroup = (last_visited == root) ? NULL
-				: last_visited->css.cgroup;
-skip_node:
-			next_cgroup = cgroup_next_descendant_pre(
-					prev_cgroup, root->css.cgroup);
-
-			/*
-			 * Even if we found a group we have to make sure it is
-			 * alive. css && !memcg means that the groups should be
-			 * skipped and we should continue the tree walk.
-			 * last_visited css is safe to use because it is
-			 * protected by css_get and the tree walk is rcu safe.
-			 */
-			if (next_cgroup) {
-				struct mem_cgroup *mem = mem_cgroup_from_cont(
-						next_cgroup);
-				if (css_tryget(&mem->css))
-					memcg = mem;
-				else {
-					prev_cgroup = next_cgroup;
-					goto skip_node;
-				}
-			}
-		}
+		memcg = __mem_cgrou_iter_next(root, last_visited);
 
 		if (reclaim) {
 			if (last_visited)
-- 
1.7.10.4

