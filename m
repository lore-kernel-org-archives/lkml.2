Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab0H2Por (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:44:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45049 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab0H2Pop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:44:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=b0Nir2CI1l4vaGa20UQBUxOKiSAPLDh4oM5AcKr7T17AHOW6DErVwCM/36o3HMjXIo
         6RI2NGc4vaDfW6Gm54TrSwPvclLoa+OZOSmqDMXv3ETsTwJB6SGACx8Qx6Sm09EDyLcE
         uKfb5Kr7ln2bPt0zFjv5Cd7o7TDRTOKBaqCDQ=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>, Ying Han <yinghan@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] vmscan: prevent background aging of anon page in no swap system
Date: Mon, 30 Aug 2010 00:43:48 +0900
Message-Id: <1283096628-4450-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ying Han reported that backing aging of anon pages in no swap system
causes unnecessary TLB flush.

When I sent a patch(69c8548175), I wanted this patch but Rik pointed out
and allowed aging of anon pages to give a chance to promote from inactive
to active LRU.

It has a two problem.

1) non-swap system

Never make sense to age anon pages.

2) swap configured but still doesn't swapon

It doesn't make sense to age anon pages until swap-on time.
But it's arguable. If we have aged anon pages by swapon, VM have moved
anon pages from active to inactive. And in the time swapon by admin,
the VM can't reclaim hot pages so we can protect hot pages swapout.

But let's think about it. When does swap-on happen? It depends on admin.
we can't expect it. Nonetheless, we have done aging of anon pages to
protect hot pages swapout. It means we lost run time overhead when
below high watermark but gain hot page swap-[in/out] overhead when VM
decide swapout. Is it true? Let's think more detail.
We don't promote anon pages in case of non-swap system. So even though
VM does aging of anon pages, the pages would be in inactive LRU for a long
time. It means many of pages in there would mark access bit again. So access
bit hot/code separation would be pointless.

This patch prevents unnecessary anon pages demotion in not-swapon and
non-configured swap system. Of course, it could make side effect that
hot anon pages could swap out when admin does swap on.
But I think sooner or later it would be steady state. 
So it's not a big problem.
We could lose someting but gain more thing(TLB flush and unnecessary 
function call to demote anon pages). 

I used total_swap_pages because we want to age anon pages 
even though swap full happens.

Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Ying Han <yinghan@google.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3109ff7..d8fd87d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2211,7 +2211,7 @@ loop_again:
 			 * Do some background aging of the anon list, to give
 			 * pages a chance to be referenced before reclaiming.
 			 */
-			if (inactive_anon_is_low(zone, &sc))
+			if (total_swap_pages > 0 && inactive_anon_is_low(zone, &sc))
 				shrink_active_list(SWAP_CLUSTER_MAX, zone,
 							&sc, priority, 0);
 
-- 
1.7.0.5

