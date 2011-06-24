Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab1FXNn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:43:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405Ab1FXNnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:43:25 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrew Lutomirski <luto@mit.edu>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 4/4] mm: vmscan: Only read new_classzone_idx from pgdat when reclaiming successfully
Date: Fri, 24 Jun 2011 14:43:18 +0100
Message-Id: <1308922998-15529-5-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308922998-15529-1-git-send-email-mgorman@suse.de>
References: <1308922998-15529-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During allocator-intensive workloads, kswapd will be woken frequently
causing free memory to oscillate between the high and min watermark.
This is expected behaviour.  Unfortunately, if the highest zone is
small, a problem occurs.

When balance_pgdat() returns, it may be at a lower classzone_idx than
it started because the highest zone was unreclaimable. Before checking
if it should go to sleep though, it checks pgdat->classzone_idx which
when there is no other activity will be MAX_NR_ZONES-1. It interprets
this as it has been woken up while reclaiming, skips scheduling and
reclaims again. As there is no useful reclaim work to do, it enters
into a loop of shrinking slab consuming loads of CPU until the highest
zone becomes reclaimable for a long period of time.

There are two problems here. 1) If the returned classzone or order is
lower, it'll continue reclaiming without scheduling. 2) if the highest
zone was marked unreclaimable but balance_pgdat() returns immediately
at DEF_PRIORITY, the new lower classzone is not communicated back to
kswapd() for sleeping.

This patch does two things that are related. If the end_zone is
unreclaimable, this information is communicated back. Second, if
the classzone or order was reduced due to failing to reclaim, new
information is not read from pgdat and instead an attempt is made to go
to sleep. Due to this, it is also necessary that pgdat->classzone_idx
be initialised each time to pgdat->nr_zones - 1 to avoid re-reads
being interpreted as wakeups.

Reported-and-tested-by: Pádraig Brady <P@draigBrady.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |   34 +++++++++++++++++++++-------------
 1 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d859111..9297195 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2448,7 +2448,6 @@ loop_again:
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), 0, 0)) {
 				end_zone = i;
-				*classzone_idx = i;
 				break;
 			}
 		}
@@ -2528,8 +2527,11 @@ loop_again:
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
@@ -2709,8 +2711,8 @@ static void kswapd_try_to_sleep(pg_data_t *pgdat, int order, int classzone_idx)
  */
 static int kswapd(void *p)
 {
-	unsigned long order;
-	int classzone_idx;
+	unsigned long order, new_order;
+	int classzone_idx, new_classzone_idx;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
 
@@ -2740,17 +2742,23 @@ static int kswapd(void *p)
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
@@ -2763,7 +2771,7 @@ static int kswapd(void *p)
 			order = pgdat->kswapd_max_order;
 			classzone_idx = pgdat->classzone_idx;
 			pgdat->kswapd_max_order = 0;
-			pgdat->classzone_idx = MAX_NR_ZONES - 1;
+			pgdat->classzone_idx = pgdat->nr_zones - 1;
 		}
 
 		ret = try_to_freeze();
-- 
1.7.3.4

