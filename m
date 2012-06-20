Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2FTKLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:11:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab2FTKLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:11:22 -0400
Date: Wed, 20 Jun 2012 12:11:19 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH v2 -mm] memcg: prevent from OOM with too many dirty pages
Message-ID: <20120620101119.GC5541@tiehlicka.suse.cz>
References: <1340117404-30348-1-git-send-email-mhocko@suse.cz>
 <20120619150014.1ebc108c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120619150014.1ebc108c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
here is an updated version if it is easier for you to drop the previous
one.
changes since v1
* added Mel's Reviewed-by
* updated changelog as per Andrew
* updated the condition to be optimized for no-memcg case
---
>From 72b61c1c5da8039a7ba31d3f98420e6649ab73b8 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 20 Jun 2012 12:06:07 +0200
Subject: [PATCH] memcg: prevent from OOM with too many dirty pages

The current implementation of dirty pages throttling is not memcg aware
which makes it easy to have memcg LRUs full of dirty pages.  Without
throttling, these LRUs can be scanned faster than the rate of writeback,
leading to memcg OOM conditions when the hard limit is small.

This patch fixes the problem by throttling the allocating process (possibly
a writer) during the hard limit reclaim by waiting on PageReclaim pages.
We are waiting only for PageReclaim pages because those are the pages
that made one full round over LRU and that means that the writeback is much
slower than scanning.
The solution is far from being ideal - long term solution is memcg aware
dirty throttling - but it is meant to be a band aid until we have a real
fix.
We are seeing this happening during nightly backups which are placed into
containers to prevent from eviction of the real working set.

The change affects only memcg reclaim and only when we encounter PageReclaim
pages which is a signal that the reclaim doesn't catch up on with the writers
so somebody should be throttled. This could be potentially unfair because it
could be somebody else from the group who gets throttled on behalf of the
writer but as writers need to allocate as well and they allocate in higher rate
the probability that only innocent processes would be penalized is not that
high.

I have tested this change by a simple dd copying /dev/zero to tmpfs or ext3
running under small memcg (1G copy under 5M, 60M, 300M and 2G containers) and
dd got killed by OOM killer every time. With the patch I could run the dd with
the same size under 5M controller without any OOM.
The issue is more visible with slower devices for output.

* With the patch
================
* tmpfs size=2G
---------------
$ vim cgroup_cache_oom_test.sh
$ ./cgroup_cache_oom_test.sh 5M
using Limit 5M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 30.4049 s, 34.5 MB/s
$ ./cgroup_cache_oom_test.sh 60M
using Limit 60M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 31.4561 s, 33.3 MB/s
$ ./cgroup_cache_oom_test.sh 300M
using Limit 300M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 20.4618 s, 51.2 MB/s
$ ./cgroup_cache_oom_test.sh 2G
using Limit 2G for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 1.42172 s, 738 MB/s

* ext3
------
$ ./cgroup_cache_oom_test.sh 5M
using Limit 5M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 27.9547 s, 37.5 MB/s
$ ./cgroup_cache_oom_test.sh 60M
using Limit 60M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 30.3221 s, 34.6 MB/s
$ ./cgroup_cache_oom_test.sh 300M
using Limit 300M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 24.5764 s, 42.7 MB/s
$ ./cgroup_cache_oom_test.sh 2G
using Limit 2G for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 3.35828 s, 312 MB/s

* Without the patch
===================
* tmpfs size=2G
---------------
$ ./cgroup_cache_oom_test.sh 5M
using Limit 5M for group
./cgroup_cache_oom_test.sh: line 46:  4668 Killed                  dd if=/dev/zero of=$OUT/zero bs=1M count=$count
$ ./cgroup_cache_oom_test.sh 60M
using Limit 60M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 25.4989 s, 41.1 MB/s
$ ./cgroup_cache_oom_test.sh 300M
using Limit 300M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 24.3928 s, 43.0 MB/s
$ ./cgroup_cache_oom_test.sh 2G
using Limit 2G for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 1.49797 s, 700 MB/s

* ext3
------
$ ./cgroup_cache_oom_test.sh 5M
using Limit 5M for group
./cgroup_cache_oom_test.sh: line 46:  4689 Killed                  dd if=/dev/zero of=$OUT/zero bs=1M count=$count
$ ./cgroup_cache_oom_test.sh 60M
using Limit 60M for group
./cgroup_cache_oom_test.sh: line 46:  4692 Killed                  dd if=/dev/zero of=$OUT/zero bs=1M count=$count
$ ./cgroup_cache_oom_test.sh 300M
using Limit 300M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 20.248 s, 51.8 MB/s
$ ./cgroup_cache_oom_test.sh 2G
using Limit 2G for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 2.85201 s, 368 MB/s

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
[akpm@linux-foundation.org: tweak changelog, reordered the test to
 optimize for CONFIG_CGROUP_MEM_RES_CTLR=n]
Reviewed-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/vmscan.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c978ce4..3b6cc22 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -720,9 +720,19 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
 
 		if (PageWriteback(page)) {
-			nr_writeback++;
-			unlock_page(page);
-			goto keep;
+			/*
+			 * memcg doesn't have any dirty pages throttling so we
+			 * could easily OOM just because too many pages are in
+			 * writeback from reclaim and there is nothing else to
+			 * reclaim.
+			 */
+			if (!global_reclaim(sc) && PageReclaim(page))
+				wait_on_page_writeback(page);
+			else {
+				nr_writeback++;
+				unlock_page(page);
+				goto keep;
+			}
 		}
 
 		references = page_check_references(page, sc);
-- 
1.7.10

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
