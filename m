Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab2LLVou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:44:50 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:36214 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab2LLVos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:44:48 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 6/8] mm: vmscan: clean up get_scan_count()
Date: Wed, 12 Dec 2012 16:43:38 -0500
Message-Id: <1355348620-9382-7-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reclaim pressure balance between anon and file pages is calculated
through a tuple of numerators and a shared denominator.

Exceptional cases that want to force-scan anon or file pages configure
the numerators and denominator such that one list is preferred, which
is not necessarily the most obvious way:

    fraction[0] = 1;
    fraction[1] = 0;
    denominator = 1;
    goto out;

Make this easier by making the force-scan cases explicit and use the
fractionals only in case they are calculated from reclaim history.

And bring the variable declarations/definitions in order.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 05475e1..e20385a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1626,6 +1626,13 @@ static int vmscan_swappiness(struct scan_control *sc)
 	return mem_cgroup_swappiness(sc->target_mem_cgroup);
 }
 
+enum scan_balance {
+	SCAN_EQUAL,
+	SCAN_FRACT,
+	SCAN_ANON,
+	SCAN_FILE,
+};
+
 /*
  * Determine how aggressively the anon and file LRU lists should be
  * scanned.  The relative value of each set of LRU lists is determined
@@ -1638,14 +1645,15 @@ static int vmscan_swappiness(struct scan_control *sc)
 static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			   unsigned long *nr)
 {
-	unsigned long anon, file, free;
+	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
+	u64 fraction[2], uninitialized_var(denominator);
+	struct zone *zone = lruvec_zone(lruvec);
 	unsigned long anon_prio, file_prio;
+	enum scan_balance scan_balance;
+	unsigned long anon, file, free;
+	bool force_scan = false;
 	unsigned long ap, fp;
-	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
-	u64 fraction[2], denominator;
 	enum lru_list lru;
-	bool force_scan = false;
-	struct zone *zone = lruvec_zone(lruvec);
 
 	/*
 	 * If the zone or memcg is small, nr[l] can be 0.  This
@@ -1664,9 +1672,7 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (!sc->may_swap || (nr_swap_pages <= 0)) {
-		fraction[0] = 0;
-		fraction[1] = 1;
-		denominator = 1;
+		scan_balance = SCAN_FILE;
 		goto out;
 	}
 
@@ -1675,9 +1681,7 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	 * system is close to OOM, scan both anon and file equally.
 	 */
 	if (!sc->priority) {
-		fraction[0] = 1;
-		fraction[1] = 1;
-		denominator = 1;
+		scan_balance = SCAN_EQUAL;
 		goto out;
 	}
 
@@ -1686,9 +1690,7 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	 * anything from the anonymous working set right now.
 	 */
 	if (!inactive_file_is_low(lruvec)) {
-		fraction[0] = 0;
-		fraction[1] = 1;
-		denominator = 1;
+		scan_balance = SCAN_FILE;
 		goto out;
 	}
 
@@ -1706,13 +1708,13 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	if (global_reclaim(sc)) {
 		free = zone_page_state(zone, NR_FREE_PAGES);
 		if (unlikely(file + free <= high_wmark_pages(zone))) {
-			fraction[0] = 1;
-			fraction[1] = 0;
-			denominator = 1;
+			scan_balance = SCAN_ANON;
 			goto out;
 		}
 	}
 
+	scan_balance = SCAN_FRACT;
+
 	/*
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
@@ -1765,9 +1767,17 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 
 		size = get_lru_size(lruvec, lru);
 		scan = size >> sc->priority;
+
 		if (!scan && force_scan)
 			scan = min(size, SWAP_CLUSTER_MAX);
-		scan = div64_u64(scan * fraction[file], denominator);
+
+		if (scan_balance == SCAN_EQUAL)
+			; /* scan relative to size */
+		else if (scan_balance == SCAN_FRACT)
+			scan = div64_u64(scan * fraction[file], denominator);
+		else if ((scan_balance == SCAN_FILE) != file)
+			scan = 0;
+
 		nr[lru] = scan;
 	}
 }
-- 
1.7.11.7

