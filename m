Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab0DORXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 13:23:11 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49796 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab0DORVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 13:21:43 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Johannes Weiner <hannes@cmpxchg.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 06/10] vmscan: Split shrink_zone to reduce stack usage
Date: Thu, 15 Apr 2010 18:21:39 +0100
Message-Id: <1271352103-2280-7-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1271352103-2280-1-git-send-email-mel@csn.ul.ie>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shrink_zone() calculculates how many pages it needs to shrink from each
LRU list in a given pass. It uses a number of temporary variables to
work this out that then remain on the stack. This patch splits the
function so that some of the stack variables can be discarded.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1ace7c6..a374879 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1595,19 +1595,14 @@ static unsigned long nr_scan_try_batch(unsigned long nr_to_scan,
 	return nr;
 }
 
-/*
- * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
- */
-static void shrink_zone(struct zone *zone, struct scan_control *sc)
+/* Calculate how many pages from each LRU list should be scanned */
+static void calc_scan_trybatch(struct zone *zone,
+				 struct scan_control *sc, unsigned long *nr)
 {
-	unsigned long nr[NR_LRU_LISTS];
-	unsigned long nr_to_scan;
-	unsigned long percent[2];	/* anon @ 0; file @ 1 */
 	enum lru_list l;
-	unsigned long nr_reclaimed = sc->nr_reclaimed;
-	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
+	unsigned long percent[2];	/* anon @ 0; file @ 1 */
+	int noswap = 0 ;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
-	int noswap = 0;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (!sc->may_swap || (nr_swap_pages <= 0)) {
@@ -1629,6 +1624,20 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
 		nr[l] = nr_scan_try_batch(scan,
 					  &reclaim_stat->nr_saved_scan[l]);
 	}
+}
+
+/*
+ * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
+ */
+static void shrink_zone(struct zone *zone, struct scan_control *sc)
+{
+	unsigned long nr[NR_LRU_LISTS];
+	unsigned long nr_to_scan;
+	unsigned long nr_reclaimed = sc->nr_reclaimed;
+	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
+	enum lru_list l;
+
+	calc_scan_trybatch(zone, sc, nr);
 
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
-- 
1.6.5

