Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3ACSJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 13:09:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab3ACSJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 13:09:04 -0500
Date: Thu, 3 Jan 2013 19:09:01 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -repost] memcg,vmscan: do not break out targeted reclaim
 without reclaimed pages
Message-ID: <20130103180901.GA22067@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have posted this quite some time ago
(https://lkml.org/lkml/2012/12/14/102) but it probably slipped through
---
>From 28b4e10bc3c18b82bee695b76f4bf25c03baa5f8 Mon Sep 17 00:00:00 2001
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
 mm/vmscan.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 916afbc..bfd41a6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1973,18 +1973,17 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
 			shrink_lruvec(lruvec, sc);
 
 			/*
-			 * Limit reclaim has historically picked one
-			 * memcg and scanned it with decreasing
-			 * priority levels until nr_to_reclaim had
-			 * been reclaimed.  This priority cycle is
-			 * thus over after a single memcg.
-			 *
-			 * Direct reclaim and kswapd, on the other
-			 * hand, have to scan all memory cgroups to
-			 * fulfill the overall scan target for the
+			 * Direct reclaim and kswapd have to scan all memory
+			 * cgroups to fulfill the overall scan target for the
 			 * zone.
+			 *
+			 * Limit reclaim, on the other hand, only cares about
+			 * nr_to_reclaim pages to be reclaimed and it will
+			 * retry with decreasing priority if one round over the
+			 * whole hierarchy is not sufficient.
 			 */
-			if (!global_reclaim(sc)) {
+			if (!global_reclaim(sc) &&
+					sc->nr_to_reclaim >= sc->nr_reclaimed) {
 				mem_cgroup_iter_break(root, memcg);
 				break;
 			}
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
