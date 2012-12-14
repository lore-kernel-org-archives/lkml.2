Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2LNK4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 05:56:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab2LNK42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 05:56:28 -0500
Date: Fri, 14 Dec 2012 11:56:26 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH] memcg,vmscan: do not break out targeted reclaim without
 reclaimed pages
Message-ID: <20121214105626.GE6898@dhcp22.suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
 <1353955671-14385-4-git-send-email-mhocko@suse.cz>
 <CALWz4ixPmvguxQO8s9mqH+OLEXC5LDfzEVFx_qqe2hBaRcsXiA@mail.gmail.com>
 <20121211155432.GC1612@dhcp22.suse.cz>
 <CALWz4izL7fEuQhEvKa7mUqi0sa25mcFP-xnTnL3vU3Z17k7VHg@mail.gmail.com>
 <20121212090652.GB32081@dhcp22.suse.cz>
 <CALWz4iwq+vRN+rreOk7Jg4rHWWBSmNwBW8Kko45E-D8Vi66eQA@mail.gmail.com>
 <20121212183446.GB10374@dhcp22.suse.cz>
 <20121212184207.GC10374@dhcp22.suse.cz>
 <CALWz4ix7byi=R9_N=LbtpgpvK_rV5UCZGHyWaTECiKqCB2rGwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALWz4ix7byi=R9_N=LbtpgpvK_rV5UCZGHyWaTECiKqCB2rGwQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-12-12 17:06:38, Ying Han wrote:
[...]
> Off topic of the following discussion.
> Take the following hierarchy as example:
> 
>                 root
>               /  |   \
>             a   b     c
>                         |  \
>                         d   e
>                         |      \
>                         g      h
> 
> Let's say c hits its hardlimit and then triggers target reclaim. There
> are two reclaimers at the moment and reclaimer_1 starts earlier. The
> cgroup_next_descendant_pre() returns in order : c->d->g->e->h
> 
> Then we might get the reclaim result as the following where each
> reclaimer keep hitting one node of the sub-tree for all the priorities
> like the following:
> 
>                 reclaimer_1  reclaimer_2
> priority 12  c                 d
> ...             c                 d
> ...             c                 d
> ...             c                 d
>            0   c                 d
> 
> However, this is not how global reclaim works:
> 
> the cgroup_next_descendant_pre returns in order: root->a->b->c->d->g->e->h
> 
>                 reclaimer_1  reclaimer_1 reclaimer_1  reclaimer_2
> priority 12  root                 a            b                 c
> ...             root                 a            b                 c
> ...
> ...
> 0
> 
> There is no reason for me to think of why target reclaim behave
> differently from global reclaim, which the later one is just the
> target reclaim of root cgroup.

Well, this is not a fair comparison because global reclaim is not just
targeted reclaim of the root cgroup. The difference is that global
reclaim balances zones while targeted reclaim only tries to get bellow
a threshold (hard or soft limit). So we cannot really do the same thing
for both.

On the other hand you are right that targeted reclaim iteration can be
weird, especially when nodes higher in the hierarchy do not have any
pages to reclaim (if they do not have any tasks then only re-parented
are on the list). Then we would drop the priority rather quickly and
hammering the same group again and again until we exhaust all priorities
and come back to the shrinker which finds out that nothing changed so it
will try again and we will slowly get to something to reclaim (always
starting with DEF_PRIORITY). So true we are doing a lot of work without
any point.

Maybe we shouldn't break out of the loop if we didn't reclaim enough for
targeted reclaim. Something like:
---
>From a9183bd69ce8a9758383b2279b11c44ac10a049a Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 14 Dec 2012 11:12:43 +0100
Subject: [PATCH] memcg,vmscan: do not break out targeted reclaim without
 reclaimed pages

Targeted (hard resp. soft) reclaim has traditionally tried to scan one
group with decreasing priority until nr_to_reclaim (SWAP_CLUSTER_MAX
pages) is reclaimed or all priorities are exhausted. The reclaim is
then retried until the limit is met.

This approach, however, doesn't work well with deeper hierarchies where
groups higher in the hierarchy do not have any or only very few pages
(this usually happens if those groups do not have any tasks and they
have only re-parented pages after some of their children is removed).
Those groups are reclaimed with decreasing priority pointlessly as there
is nothing to reclaim from them.

An easiest fix is to break out of the memcg iteration loop in shrink_zone
only if the whole hierarchy has been visited or sufficient pages have
been reclaimed. This is also more natural because the reclaimer expects
that the hierarchy under the given root is reclaimed. As a result we can
simplify the soft limit reclaim which does its own iteration.

Reported-by: Ying Han <yinghan@google.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 53dcde9..161e3ad 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1912,16 +1912,16 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
 		shrink_lruvec(lruvec, sc);
 
 		/*
-		 * Limit reclaim has historically picked one memcg and
-		 * scanned it with decreasing priority levels until
-		 * nr_to_reclaim had been reclaimed.  This priority
-		 * cycle is thus over after a single memcg.
+		 * Direct reclaim and kswapd have to scan all memory cgroups
+		 * to fulfill the overall scan target for the zone.
 		 *
-		 * Direct reclaim and kswapd, on the other hand, have
-		 * to scan all memory cgroups to fulfill the overall
-		 * scan target for the zone.
+		 * Limit reclaim, on the other hand, only cares about
+		 * nr_to_reclaim pages to be reclaimed and it will retry with
+		 * decreasing priority if one round over the whole hierarchy
+		 * is not sufficient.
 		 */
-		if (!global_reclaim(sc)) {
+		if (!global_reclaim(sc) &&
+				sc->nr_to_reclaim >= sc->nr_reclaimed) {
 			mem_cgroup_iter_break(root, memcg);
 			break;
 		}
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
