Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2KMPbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:31:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab2KMPbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:31:22 -0500
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>
Subject: [RFC 5/5] cgroup: remove css_get_next
Date: Tue, 13 Nov 2012 16:30:39 +0100
Message-Id: <1352820639-13521-6-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have generic and well ordered cgroup tree walkers there is
no need to keep css_get_next in the place.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/cgroup.h |    7 -------
 kernel/cgroup.c        |   49 ------------------------------------------------
 2 files changed, 56 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 329eb46..ba46041 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -676,13 +676,6 @@ void free_css_id(struct cgroup_subsys *ss, struct cgroup_subsys_state *css);
 
 struct cgroup_subsys_state *css_lookup(struct cgroup_subsys *ss, int id);
 
-/*
- * Get a cgroup whose id is greater than or equal to id under tree of root.
- * Returning a cgroup_subsys_state or NULL.
- */
-struct cgroup_subsys_state *css_get_next(struct cgroup_subsys *ss, int id,
-		struct cgroup_subsys_state *root, int *foundid);
-
 /* Returns true if root is ancestor of cg */
 bool css_is_ancestor(struct cgroup_subsys_state *cg,
 		     const struct cgroup_subsys_state *root);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d51958a..4d874b2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5230,55 +5230,6 @@ struct cgroup_subsys_state *css_lookup(struct cgroup_subsys *ss, int id)
 }
 EXPORT_SYMBOL_GPL(css_lookup);
 
-/**
- * css_get_next - lookup next cgroup under specified hierarchy.
- * @ss: pointer to subsystem
- * @id: current position of iteration.
- * @root: pointer to css. search tree under this.
- * @foundid: position of found object.
- *
- * Search next css under the specified hierarchy of rootid. Calling under
- * rcu_read_lock() is necessary. Returns NULL if it reaches the end.
- */
-struct cgroup_subsys_state *
-css_get_next(struct cgroup_subsys *ss, int id,
-	     struct cgroup_subsys_state *root, int *foundid)
-{
-	struct cgroup_subsys_state *ret = NULL;
-	struct css_id *tmp;
-	int tmpid;
-	int rootid = css_id(root);
-	int depth = css_depth(root);
-
-	if (!rootid)
-		return NULL;
-
-	BUG_ON(!ss->use_id);
-	WARN_ON_ONCE(!rcu_read_lock_held());
-
-	/* fill start point for scan */
-	tmpid = id;
-	while (1) {
-		/*
-		 * scan next entry from bitmap(tree), tmpid is updated after
-		 * idr_get_next().
-		 */
-		tmp = idr_get_next(&ss->idr, &tmpid);
-		if (!tmp)
-			break;
-		if (tmp->depth >= depth && tmp->stack[depth] == rootid) {
-			ret = rcu_dereference(tmp->css);
-			if (ret) {
-				*foundid = tmpid;
-				break;
-			}
-		}
-		/* continue to scan from next id */
-		tmpid = tmpid + 1;
-	}
-	return ret;
-}
-
 /*
  * get corresponding css from file open on cgroupfs directory
  */
-- 
1.7.10.4

