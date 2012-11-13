Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2KMPbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:31:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab2KMPbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:31:18 -0500
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>
Subject: [RFC 1/5] memcg: synchronize per-zone iterator access by a spinlock
Date: Tue, 13 Nov 2012 16:30:35 +0100
Message-Id: <1352820639-13521-2-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

per-zone per-priority iterator is aimed at coordinating concurrent
reclaimers on the same hierarchy (or the global reclaim when all
groups are reclaimed) so that all groups get reclaimed evenly as
much as possible. iter->position holds the last css->id visited
and iter->generation signals the completed tree walk (when it is
incremented).
Concurrent reclaimers are supposed to provide a reclaim cookie which
holds the reclaim priority and the last generation they saw. If cookie's
generation doesn't match the iterator's view then other concurrent
reclaimer already did the job and the tree walk is done for that
priority.

This scheme works nicely in most cases but it is not raceless. Two
racing reclaimers can see the same iter->position and so bang on the
same group. iter->generation increment is not serialized as well so a
reclaimer can see an updated iter->position with and old generation so
the iteration might be restarted from the root of the hierarchy.

The simplest way to fix this issue is to synchronise access to the
iterator by a lock. This implementation uses per-zone per-priority
spinlock which linearizes only directly racing reclaimers which use
reclaim cookies so the effect of the new locking should be really
minimal.

I have to note that I haven't seen this as a real issue so far. The
primary motivation for the change is different. The following patch
will change the way how the iterator is implemented and css->id
iteration will be replaced cgroup generic iteration which requires
storing mem_cgroup pointer into iterator and that requires reference
counting and so concurrent access will be a problem.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6136fec..0fe5177 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -146,6 +146,8 @@ struct mem_cgroup_reclaim_iter {
 	int position;
 	/* scan generation, increased every round-trip */
 	unsigned int generation;
+	/* lock to protect the position and generation */
+	spinlock_t iter_lock;
 };
 
 /*
@@ -1093,8 +1095,11 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 
 			mz = mem_cgroup_zoneinfo(root, nid, zid);
 			iter = &mz->reclaim_iter[reclaim->priority];
-			if (prev && reclaim->generation != iter->generation)
+			spin_lock(&iter->iter_lock);
+			if (prev && reclaim->generation != iter->generation) {
+				spin_unlock(&iter->iter_lock);
 				return NULL;
+			}
 			id = iter->position;
 		}
 
@@ -1113,6 +1118,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 				iter->generation++;
 			else if (!prev && memcg)
 				reclaim->generation = iter->generation;
+			spin_unlock(&iter->iter_lock);
 		}
 
 		if (prev && !css)
@@ -5871,8 +5877,12 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 		return 1;
 
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+		int prio;
+
 		mz = &pn->zoneinfo[zone];
 		lruvec_init(&mz->lruvec, &NODE_DATA(node)->node_zones[zone]);
+		for (prio = 0; prio < DEF_PRIORITY + 1; prio++)
+			spin_lock_init(&mz->reclaim_iter[prio].iter_lock);
 		mz->usage_in_excess = 0;
 		mz->on_tree = false;
 		mz->memcg = memcg;
-- 
1.7.10.4

