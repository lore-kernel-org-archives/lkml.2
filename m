Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab2LLTYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 14:24:47 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39239 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab2LLTYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 14:24:44 -0500
Date: Wed, 12 Dec 2012 20:24:41 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 3/6] memcg: rework mem_cgroup_iter to use cgroup
 iterators
Message-ID: <20121212192441.GD10374@dhcp22.suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
 <1353955671-14385-4-git-send-email-mhocko@suse.cz>
 <CALWz4ixPmvguxQO8s9mqH+OLEXC5LDfzEVFx_qqe2hBaRcsXiA@mail.gmail.com>
 <20121211155432.GC1612@dhcp22.suse.cz>
 <CALWz4izL7fEuQhEvKa7mUqi0sa25mcFP-xnTnL3vU3Z17k7VHg@mail.gmail.com>
 <20121212090652.GB32081@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212090652.GB32081@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 12-12-12 10:06:52, Michal Hocko wrote:
> On Tue 11-12-12 14:36:10, Ying Han wrote:
[...]
> > One exception is mem_cgroup_iter_break(), where the loop terminates
> > with *leaked* refcnt and that is what the iter_break() needs to clean
> > up. We can not rely on the next caller of the loop since it might
> > never happen.
> 
> Yes, this is true and I already have a half baked patch for that. I
> haven't posted it yet but it basically checks all node-zone-prio
> last_visited and removes itself from them on the way out in pre_destroy
> callback (I just need to cleanup "find a new last_visited" part and will
> post it).

And a half baked patch - just compile tested
---
>From 1c976c079c383175c679e00115aee0ab8e215bf2 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 11 Dec 2012 21:02:39 +0100
Subject: [PATCH] NOT READY YET - just compile tested

memcg: remove memcg from the reclaim iterators

Now that per-node-zone-priority iterator caches memory cgroups rather
than their css ids we have to be careful and remove them from the
iterator when they are on the way out otherwise they might hang for
unbounded amount of time (until the global reclaim triggers the zone
under priority to find out the group is dead and let it to find the
final rest).

This is solved by hooking into mem_cgroup_pre_destroy and checking all
per-node-zone-priority iterators. If the current memcg is found in
iter->last_visited then it is replaced by its left sibling or its parent
otherwise. This guarantees that no group gets more reclaiming than
necessary and the next iteration will continue seemingly.

Spotted-by: Ying Han <yinghan@google.com>
Not-signed-off-by-yet: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7134148..286db74 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6213,12 +6213,50 @@ free_out:
 	return ERR_PTR(error);
 }
 
+static void mem_cgroup_remove_cached(struct mem_cgroup *memcg)
+{
+	int node, zone;
+
+	for_each_node(node) {
+		struct mem_cgroup_per_node *pn = memcg->info.nodeinfo[node];
+		int prio;
+
+		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+			struct mem_cgroup_per_zone *mz;
+
+			mz = &pn->zoneinfo[zone];
+			for (prio = 0; prio < DEF_PRIORITY + 1; prio++) {
+				struct mem_cgroup_reclaim_iter *iter;
+
+				iter = &mz->reclaim_iter[prio];
+				rcu_read_lock();
+				spin_lock(&iter->iter_lock);
+				if (iter->last_visited == memcg) {
+					struct cgroup *cgroup, *prev;
+
+					cgroup = memcg->css.cgroup;
+					prev = list_entry_rcu(cgroup->sibling.prev, struct cgroup, sibling);
+					if (&prev->sibling == &prev->parent->children)
+						prev = prev->parent;
+					iter->last_visited = mem_cgroup_from_cont(prev);
+
+					/* TODO can we do this? */
+					css_put(&memcg->css);
+				}
+				spin_unlock(&iter->iter_lock);
+				rcu_read_unlock();
+			}
+		}
+	}
+}
+
 static void mem_cgroup_pre_destroy(struct cgroup *cont)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
 	mem_cgroup_reparent_charges(memcg);
 	mem_cgroup_destroy_all_caches(memcg);
+	mem_cgroup_remove_cached(memcg);
 }
 
 static void mem_cgroup_destroy(struct cgroup *cont)
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
