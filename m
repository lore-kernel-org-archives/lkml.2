Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1G0VsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:26104 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab1G0VsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="35258005"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: abarry@cray.com, minchan.kim@gmail.com, riel@redhat.com, mgorman@suse.de,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [10/99] mm/page_alloc.c: prevent unending loop in
Message-Id: <20110727214808.7F42A2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andrew Barry <abarry@cray.com>

commit cfa54a0fcfc1017c6f122b6f21aaba36daa07f71 upstream.

I believe I found a problem in __alloc_pages_slowpath, which allows a
process to get stuck endlessly looping, even when lots of memory is
available.

Running an I/O and memory intensive stress-test I see a 0-order page
allocation with __GFP_IO and __GFP_WAIT, running on a system with very
little free memory.  Right about the same time that the stress-test gets
killed by the OOM-killer, the utility trying to allocate memory gets stuck
in __alloc_pages_slowpath even though most of the systems memory was freed
by the oom-kill of the stress-test.

The utility ends up looping from the rebalance label down through the
wait_iff_congested continiously.  Because order=0,
__alloc_pages_direct_compact skips the call to get_page_from_freelist.
Because all of the reclaimable memory on the system has already been
reclaimed, __alloc_pages_direct_reclaim skips the call to
get_page_from_freelist.  Since there is no __GFP_FS flag, the block with
__alloc_pages_may_oom is skipped.  The loop hits the wait_iff_congested,
then jumps back to rebalance without ever trying to
get_page_from_freelist.  This loop repeats infinitely.

The test case is pretty pathological.  Running a mix of I/O stress-tests
that do a lot of fork() and consume all of the system memory, I can pretty
reliably hit this on 600 nodes, in about 12 hours.  32GB/node.

Signed-off-by: Andrew Barry <abarry@cray.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel<riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/mm/page_alloc.c
===================================================================
--- linux-2.6.35.y.orig/mm/page_alloc.c
+++ linux-2.6.35.y/mm/page_alloc.c
@@ -2027,6 +2027,7 @@ restart:
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
+rebalance:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
@@ -2034,7 +2035,6 @@ restart:
 	if (page)
 		goto got_pg;
 
-rebalance:
 	/* Allocate without watermarks if the context allows */
 	if (alloc_flags & ALLOC_NO_WATERMARKS) {
 		page = __alloc_pages_high_priority(gfp_mask, order,
