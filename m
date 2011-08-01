Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab1HAXgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:36:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab1HAXZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:51 2011
Message-Id: <20110801232051.086477753@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [05/70] mm: vmscan: correct check for kswapd sleeping in sleeping_prematurely
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 08951e545918c1594434d000d88a7793e2452a9b upstream.

During allocator-intensive workloads, kswapd will be woken frequently
causing free memory to oscillate between the high and min watermark.  This
is expected behaviour.  Unfortunately, if the highest zone is small, a
problem occurs.

This seems to happen most with recent sandybridge laptops but it's
probably a co-incidence as some of these laptops just happen to have a
small Normal zone.  The reproduction case is almost always during copying
large files that kswapd pegs at 100% CPU until the file is deleted or
cache is dropped.

The problem is mostly down to sleeping_prematurely() keeping kswapd awake
when the highest zone is small and unreclaimable and compounded by the
fact we shrink slabs even when not shrinking zones causing a lot of time
to be spent in shrinkers and a lot of memory to be reclaimed.

Patch 1 corrects sleeping_prematurely to check the zones matching
	the classzone_idx instead of all zones.

Patch 2 avoids shrinking slab when we are not shrinking a zone.

Patch 3 notes that sleeping_prematurely is checking lower zones against
	a high classzone which is not what allocators or balance_pgdat()
	is doing leading to an artifical belief that kswapd should be
	still awake.

Patch 4 notes that when balance_pgdat() gives up on a high zone that the
	decision is not communicated to sleeping_prematurely()

This problem affects 2.6.38.8 for certain and is expected to affect 2.6.39
and 3.0-rc4 as well.  If accepted, they need to go to -stable to be picked
up by distros and this series is against 3.0-rc4.  I've cc'd people that
reported similar problems recently to see if they still suffer from the
problem and if this fixes it.

This patch: correct the check for kswapd sleeping in sleeping_prematurely()

During allocator-intensive workloads, kswapd will be woken frequently
causing free memory to oscillate between the high and min watermark.  This
is expected behaviour.

A problem occurs if the highest zone is small.  balance_pgdat() only
considers unreclaimable zones when priority is DEF_PRIORITY but
sleeping_prematurely considers all zones.  It's possible for this sequence
to occur

  1. kswapd wakes up and enters balance_pgdat()
  2. At DEF_PRIORITY, marks highest zone unreclaimable
  3. At DEF_PRIORITY-1, ignores highest zone setting end_zone
  4. At DEF_PRIORITY-1, calls shrink_slab freeing memory from
        highest zone, clearing all_unreclaimable. Highest zone
        is still unbalanced
  5. kswapd returns and calls sleeping_prematurely
  6. sleeping_prematurely looks at *all* zones, not just the ones
     being considered by balance_pgdat. The highest small zone
     has all_unreclaimable cleared but the zone is not
     balanced. all_zones_ok is false so kswapd stays awake

This patch corrects the behaviour of sleeping_prematurely to check the
zones balance_pgdat() checked.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Pádraig Brady <P@draigBrady.com>
Tested-by: Pádraig Brady <P@draigBrady.com>
Tested-by: Andrew Lutomirski <luto@mit.edu>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2261,7 +2261,7 @@ static bool sleeping_prematurely(pg_data
 		return true;
 
 	/* Check the watermark levels */
-	for (i = 0; i < pgdat->nr_zones; i++) {
+	for (i = 0; i <= classzone_idx; i++) {
 		struct zone *zone = pgdat->node_zones + i;
 
 		if (!populated_zone(zone))


