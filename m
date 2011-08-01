Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1HAXaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:30:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab1HAX2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:28:02 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:57 2011
Message-Id: <20110801232057.008562147@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mgorman@suse.de,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [64/70] mm: vmscan: only read new_classzone_idx from pgdat when reclaiming successfully
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 215ddd6664ced067afca7eebd2d1eb83f064ff5a upstream

During allocator-intensive workloads, kswapd will be woken frequently
causing free memory to oscillate between the high and min watermark.  This
is expected behaviour.  Unfortunately, if the highest zone is small, a
problem occurs.

When balance_pgdat() returns, it may be at a lower classzone_idx than it
started because the highest zone was unreclaimable.  Before checking if it
should go to sleep though, it checks pgdat->classzone_idx which when there
is no other activity will be MAX_NR_ZONES-1.  It interprets this as it has
been woken up while reclaiming, skips scheduling and reclaims again.  As
there is no useful reclaim work to do, it enters into a loop of shrinking
slab consuming loads of CPU until the highest zone becomes reclaimable for
a long period of time.

There are two problems here.  1) If the returned classzone or order is
lower, it'll continue reclaiming without scheduling.  2) if the highest
zone was marked unreclaimable but balance_pgdat() returns immediately at
DEF_PRIORITY, the new lower classzone is not communicated back to kswapd()
for sleeping.

This patch does two things that are related.  If the end_zone is
unreclaimable, this information is communicated back.  Second, if the
classzone or order was reduced due to failing to reclaim, new information
is not read from pgdat and instead an attempt is made to go to sleep.  Due
to this, it is also necessary that pgdat->classzone_idx be initialised
each time to pgdat->nr_zones - 1 to avoid re-reads being interpreted as
wakeups.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Pádraig Brady <P@draigBrady.com>
Tested-by: Pádraig Brady <P@draigBrady.com>
Tested-by: Andrew Lutomirski <luto@mit.edu>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/vmscan.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2394,7 +2394,6 @@ loop_again:
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), 0, 0)) {
 				end_zone = i;
-				*classzone_idx = i;
 				break;
 			}
 		}
@@ -2471,8 +2470,11 @@ loop_again:
 			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
 				sc.may_writepage = 1;
 
-			if (zone->all_unreclaimable)
+			if (zone->all_unreclaimable) {
+				if (end_zone && end_zone == i)
+					end_zone--;
 				continue;
+			}
 
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), end_zone, 0)) {
@@ -2652,8 +2654,8 @@ static void kswapd_try_to_sleep(pg_data_
  */
 static int kswapd(void *p)
 {
-	unsigned long order;
-	int classzone_idx;
+	unsigned long order, new_order;
+	int classzone_idx, new_classzone_idx;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
 
@@ -2683,17 +2685,23 @@ static int kswapd(void *p)
 	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 	set_freezable();
 
-	order = 0;
-	classzone_idx = MAX_NR_ZONES - 1;
+	order = new_order = 0;
+	classzone_idx = new_classzone_idx = pgdat->nr_zones - 1;
 	for ( ; ; ) {
-		unsigned long new_order;
-		int new_classzone_idx;
 		int ret;
 
-		new_order = pgdat->kswapd_max_order;
-		new_classzone_idx = pgdat->classzone_idx;
-		pgdat->kswapd_max_order = 0;
-		pgdat->classzone_idx = MAX_NR_ZONES - 1;
+		/*
+		 * If the last balance_pgdat was unsuccessful it's unlikely a
+		 * new request of a similar or harder type will succeed soon
+		 * so consider going to sleep on the basis we reclaimed at
+		 */
+		if (classzone_idx >= new_classzone_idx && order == new_order) {
+			new_order = pgdat->kswapd_max_order;
+			new_classzone_idx = pgdat->classzone_idx;
+			pgdat->kswapd_max_order =  0;
+			pgdat->classzone_idx = pgdat->nr_zones - 1;
+		}
+
 		if (order < new_order || classzone_idx > new_classzone_idx) {
 			/*
 			 * Don't sleep if someone wants a larger 'order'
@@ -2706,7 +2714,7 @@ static int kswapd(void *p)
 			order = pgdat->kswapd_max_order;
 			classzone_idx = pgdat->classzone_idx;
 			pgdat->kswapd_max_order = 0;
-			pgdat->classzone_idx = MAX_NR_ZONES - 1;
+			pgdat->classzone_idx = pgdat->nr_zones - 1;
 		}
 
 		ret = try_to_freeze();


