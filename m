Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab2KOJwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:52:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492Ab2KOJwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:52:37 -0500
Date: Thu, 15 Nov 2012 10:52:35 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC 2/5] memcg: rework mem_cgroup_iter to use cgroup iterators
Message-ID: <20121115095235.GC11990@dhcp22.suse.cz>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
 <1352820639-13521-3-git-send-email-mhocko@suse.cz>
 <50A2E3B3.6080007@jp.fujitsu.com>
 <20121114101052.GD17111@dhcp22.suse.cz>
 <50A46BB6.6070902@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A46BB6.6070902@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-11-12 13:12:38, KAMEZAWA Hiroyuki wrote:
> (2012/11/14 19:10), Michal Hocko wrote:
> >On Wed 14-11-12 09:20:03, KAMEZAWA Hiroyuki wrote:
> >>(2012/11/14 0:30), Michal Hocko wrote:
> >[...]
> >>>@@ -1096,30 +1096,64 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
> >>>   			mz = mem_cgroup_zoneinfo(root, nid, zid);
> >>>   			iter = &mz->reclaim_iter[reclaim->priority];
> >>>   			spin_lock(&iter->iter_lock);
> >>>+			last_visited = iter->last_visited;
> >>>   			if (prev && reclaim->generation != iter->generation) {
> >>>+				if (last_visited) {
> >>>+					mem_cgroup_put(last_visited);
> >>>+					iter->last_visited = NULL;
> >>>+				}
> >>>   				spin_unlock(&iter->iter_lock);
> >>>   				return NULL;
> >>>   			}
> >>>-			id = iter->position;
> >>>   		}
> >>>
> >>>   		rcu_read_lock();
> >>>-		css = css_get_next(&mem_cgroup_subsys, id + 1, &root->css, &id);
> >>>-		if (css) {
> >>>-			if (css == &root->css || css_tryget(css))
> >>>-				memcg = mem_cgroup_from_css(css);
> >>>-		} else
> >>>-			id = 0;
> >>>-		rcu_read_unlock();
> >>>+		/*
> >>>+		 * Root is not visited by cgroup iterators so it needs a special
> >>>+		 * treatment.
> >>>+		 */
> >>>+		if (!last_visited) {
> >>>+			css = &root->css;
> >>>+		} else {
> >>>+			struct cgroup *next_cgroup;
> >>>+
> >>>+			next_cgroup = cgroup_next_descendant_pre(
> >>>+					last_visited->css.cgroup,
> >>>+					root->css.cgroup);
> >>
> >>Maybe I miss something but.... last_visited is holded by memcg's refcnt.
> >>The cgroup pointed by css.cgroup is by cgroup's refcnt which can be freed
> >>before memcg is freed and last_visited->css.cgroup is out of RCU cycle.
> >>Is this safe ?
> >
> >Good spotted. You are right. What I need to do is to check that the
> >last_visited is alive and restart from the root if not. Something like
> >the bellow (incremental patch on top of this one) should help, right?
> >
> >diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >index 30efd7e..c0a91a3 100644
> >--- a/mm/memcontrol.c
> >+++ b/mm/memcontrol.c
> >@@ -1105,6 +1105,16 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
> >  				spin_unlock(&iter->iter_lock);
> >  				return NULL;
> >  			}
> >+			/*
> >+			 * memcg is still valid because we hold a reference but
> >+			 * its cgroup might have vanished in the meantime so
> >+			 * we have to double check it is alive and restart the
> >+			 * tree walk otherwise.
> >+			 */
> >+			if (last_visited && !css_tryget(&last_visited->css)) {
> >+				mem_cgroup_put(last_visited);
> >+				last_visited = NULL;
> >+			}
> >  		}
> >
> >  		rcu_read_lock();
> >@@ -1136,8 +1146,10 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
> >  		if (reclaim) {
> >  			struct mem_cgroup *curr = memcg;
> >
> >-			if (last_visited)
> >+			if (last_visited) {
> >+				css_put(&last_visited->css);
> >  				mem_cgroup_put(last_visited);
> >+			}
> >
> >  			if (css && !memcg)
> >  				curr = mem_cgroup_from_css(css);
> >
> 
> I think this will work.

Thanks for double checking. The updated patch:
---
>From 3811de23a0306c229ce44dc655878431a4fdf449 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 13 Nov 2012 11:40:35 +0100
Subject: [PATCH] memcg: rework mem_cgroup_iter to use cgroup iterators

mem_cgroup_iter curently relies on css->id when walking down a group
hierarchy tree. This is really awkward because the tree walk depends on
the groups creation ordering. The only guarantee is that a parent node
is visited before its children.
Example
 1) mkdir -p a a/d a/b/c
 2) mkdir -a a/b/c a/d
Will create the same trees but the tree walks will be different:
 1) a, d, b, c
 2) a, b, c, d

574bd9f7 (cgroup: implement generic child / descendant walk macros) has
introduced generic cgroup tree walkers which provide either pre-order
or post-order tree walk. This patch converts css->id based iteration
to pre-order tree walk to keep the semantic with the original iterator
where parent is always visited before its subtree.

cgroup_for_each_descendant_pre suggests using post_create and
pre_destroy for proper synchronization with groups addidition resp.
removal. This implementation doesn't use those because a new memory
cgroup is fully initialized in mem_cgroup_create and css_tryget makes
sure that the group is alive when we encounter it by iterator.

If the reclaim cookie is used we need to store the last visited group
into the iterator so we have to be careful that it doesn't disappear in
the mean time. Elevated reference count on the memcg keeps it alive even
though the group have vanished in the meantime. This is checked by
css_tryget and if the group is gone the iteration is restarted from the
beginning.

V2
- iter->last_visited need to check whether the cgroup is still alive.
  Thanks to Kamezawa for pointing this out.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   74 ++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 60 insertions(+), 14 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0fe5177..c0a91a3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -142,8 +142,8 @@ struct mem_cgroup_stat_cpu {
 };
 
 struct mem_cgroup_reclaim_iter {
-	/* css_id of the last scanned hierarchy member */
-	int position;
+	/* last scanned hierarchy member with elevated ref count */
+	struct mem_cgroup *last_visited;
 	/* scan generation, increased every round-trip */
 	unsigned int generation;
 	/* lock to protect the position and generation */
@@ -1064,7 +1064,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 				   struct mem_cgroup_reclaim_cookie *reclaim)
 {
 	struct mem_cgroup *memcg = NULL;
-	int id = 0;
+	struct mem_cgroup *last_visited = NULL;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1073,7 +1073,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 		root = root_mem_cgroup;
 
 	if (prev && !reclaim)
-		id = css_id(&prev->css);
+		last_visited = prev;
 
 	if (prev && prev != root)
 		css_put(&prev->css);
@@ -1086,7 +1086,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 
 	while (!memcg) {
 		struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
-		struct cgroup_subsys_state *css;
+		struct cgroup_subsys_state *css = NULL;
 
 		if (reclaim) {
 			int nid = zone_to_nid(reclaim->zone);
@@ -1096,30 +1096,76 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 			mz = mem_cgroup_zoneinfo(root, nid, zid);
 			iter = &mz->reclaim_iter[reclaim->priority];
 			spin_lock(&iter->iter_lock);
+			last_visited = iter->last_visited;
 			if (prev && reclaim->generation != iter->generation) {
+				if (last_visited) {
+					mem_cgroup_put(last_visited);
+					iter->last_visited = NULL;
+				}
 				spin_unlock(&iter->iter_lock);
 				return NULL;
 			}
-			id = iter->position;
+			/*
+			 * memcg is still valid because we hold a reference but
+			 * its cgroup might have vanished in the meantime so
+			 * we have to double check it is alive and restart the
+			 * tree walk otherwise.
+			 */
+			if (last_visited && !css_tryget(&last_visited->css)) {
+				mem_cgroup_put(last_visited);
+				last_visited = NULL;
+			}
 		}
 
 		rcu_read_lock();
-		css = css_get_next(&mem_cgroup_subsys, id + 1, &root->css, &id);
-		if (css) {
-			if (css == &root->css || css_tryget(css))
-				memcg = mem_cgroup_from_css(css);
-		} else
-			id = 0;
-		rcu_read_unlock();
+		/*
+		 * Root is not visited by cgroup iterators so it needs a special
+		 * treatment.
+		 */
+		if (!last_visited) {
+			css = &root->css;
+		} else {
+			struct cgroup *next_cgroup;
+
+			next_cgroup = cgroup_next_descendant_pre(
+					last_visited->css.cgroup,
+					root->css.cgroup);
+			if (next_cgroup)
+				css = cgroup_subsys_state(next_cgroup,
+						mem_cgroup_subsys_id);
+		}
+
+		/*
+		 * Even if we find a group we have to make sure it is alive.
+		 * css && !memcg means that the groups should be skipped and
+		 * we should continue the tree walk.
+		 */
+		if (css == &root->css || (css && css_tryget(css)))
+			memcg = mem_cgroup_from_css(css);
 
 		if (reclaim) {
-			iter->position = id;
+			struct mem_cgroup *curr = memcg;
+
+			if (last_visited) {
+				css_put(&last_visited->css);
+				mem_cgroup_put(last_visited);
+			}
+
+			if (css && !memcg)
+				curr = mem_cgroup_from_css(css);
+			if (curr)
+				mem_cgroup_get(curr);
+			iter->last_visited = curr;
+
 			if (!css)
 				iter->generation++;
 			else if (!prev && memcg)
 				reclaim->generation = iter->generation;
 			spin_unlock(&iter->iter_lock);
+		} else if (css && !memcg) {
+			last_visited = mem_cgroup_from_css(css);
 		}
+		rcu_read_unlock();
 
 		if (prev && !css)
 			return NULL;
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
