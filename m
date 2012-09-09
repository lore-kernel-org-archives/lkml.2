Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2IIXce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:32:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51206 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755874Ab2IIXQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:13 -0400
Message-Id: <20120909224203.552334438@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Satoru Moriya <satoru.moriya@hds.com>,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: [ 95/95] mm: avoid swapping out with swappiness==0
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satoru Moriya <satoru.moriya@hds.com>

commit fe35004fbf9eaf67482b074a2e032abb9c89b1dd upstream.

Sometimes we'd like to avoid swapping out anonymous memory.  In
particular, avoid swapping out pages of important process or process
groups while there is a reasonable amount of pagecache on RAM so that we
can satisfy our customers' requirements.

OTOH, we can control how aggressive the kernel will swap memory pages with
/proc/sys/vm/swappiness for global and
/sys/fs/cgroup/memory/memory.swappiness for each memcg.

But with current reclaim implementation, the kernel may swap out even if
we set swappiness=0 and there is pagecache in RAM.

This patch changes the behavior with swappiness==0.  If we set
swappiness==0, the kernel does not swap out completely (for global reclaim
until the amount of free pages and filebacked pages in a zone has been
reduced to something very very small (nr_free + nr_filebacked < high
watermark)).

Signed-off-by: Satoru Moriya <satoru.moriya@hds.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2:
 - Adjust context
 - vmscan_swappiness() does not have a zone parameter]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1977,10 +1977,10 @@ static void get_scan_count(struct zone *
 	 * proportional to the fraction of recently scanned pages on
 	 * each list that were recently referenced and in active use.
 	 */
-	ap = (anon_prio + 1) * (reclaim_stat->recent_scanned[0] + 1);
+	ap = anon_prio * (reclaim_stat->recent_scanned[0] + 1);
 	ap /= reclaim_stat->recent_rotated[0] + 1;
 
-	fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
+	fp = file_prio * (reclaim_stat->recent_scanned[1] + 1);
 	fp /= reclaim_stat->recent_rotated[1] + 1;
 	spin_unlock_irq(&zone->lru_lock);
 
@@ -1993,7 +1993,7 @@ out:
 		unsigned long scan;
 
 		scan = zone_nr_lru_pages(zone, sc, l);
-		if (priority || noswap) {
+		if (priority || noswap || !vmscan_swappiness(sc)) {
 			scan >>= priority;
 			if (!scan && force_scan)
 				scan = SWAP_CLUSTER_MAX;


