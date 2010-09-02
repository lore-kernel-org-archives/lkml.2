Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab0IBPND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:13:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51356 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0IBPNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:13:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=p7giowaIYTnhmuyxbPg8M6qpARTx1fRX3x7Cr9OtVgRqlntSarODXGjZDZ0IHGsjZs
         85pYI5T6EhI/gAK8CGa3GgsNcXfflSREiopAGnaogeSJXx4bgZprsJ1YnChqARagVCiu
         Y8bUHOrtCeuviMrZUCTKBE3MJ1GUVGOu7QKYg=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ying Han <yinghan@google.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH v2] vmscan: prevent background aging of anon page in no swap system
Date: Fri,  3 Sep 2010 00:12:13 +0900
Message-Id: <1283440333-14451-1-git-send-email-minchan.kim@gmail.com>
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

This patch prevents unnecessary anon pages demotion in not-yet-swapon and
non-configured swap system. Even, in non-configuared swap system
inactive_anon_is_low can be compiled out.

It could make side effect that hot anon pages could swap out
when admin does swap on. But I think sooner or later it would be
steady state. So it's not a big problem.

We could lose someting but gain more thing(TLB flush and unnecessary
function call to demote anon pages).

In previous version, I used total_swap_pages because I wanted to age
anon pages even though swap full happens. But Ying and KOSAKI don't
like it since it makes code inconsistent(in other place, we have used
nr_swap_pagse) or not simple and I tend to agree swap full is rare event
as KOSAKI mentioned. But I am not convinced yet. So I remove Rik's Reviewed-by
since this version is different with previous version.
Please, review carefully, again.

Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Ying Han <yinghan@google.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3109ff7..20c8459 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1580,6 +1580,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 	spin_unlock_irq(&zone->lru_lock);
 }
 
+#ifdef CONFIG_SWAP
 static int inactive_anon_is_low_global(struct zone *zone)
 {
 	unsigned long active, inactive;
@@ -1605,12 +1606,26 @@ static int inactive_anon_is_low(struct zone *zone, struct scan_control *sc)
 {
 	int low;
 
+	/*
+	 * If we don't have enough swap space, anonymous page deactivation
+	 * is pointless.
+	 */
+	if (!nr_swap_pages)
+		return 0;
+
 	if (scanning_global_lru(sc))
 		low = inactive_anon_is_low_global(zone);
 	else
 		low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup);
 	return low;
 }
+#else
+static inline int inactive_anon_is_low(struct zone *zone,
+					struct scan_control *sc)
+{
+	return 0;
+}
+#endif
 
 static int inactive_file_is_low_global(struct zone *zone)
 {
@@ -1856,7 +1871,7 @@ static void shrink_zone(int priority, struct zone *zone,
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
+	if (inactive_anon_is_low(zone, sc))
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
 	throttle_vm_writeout(sc->gfp_mask);
-- 
1.7.0.5

