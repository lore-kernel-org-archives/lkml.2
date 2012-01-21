Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2AUOmH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 09:42:07 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41728 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab2AUOmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 09:42:01 -0500
MIME-Version: 1.0
Date: Sat, 21 Jan 2012 22:41:59 +0800
Message-ID: <CAJd=RBDVxT5Pc2HZjz15LUb7xhFbztpFmXqLXVB3nCoQLKHiHg@mail.gmail.com>
Subject: [PATCH] mm: vmscan: fix malused nr_reclaimed in shrinking zone
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value of nr_reclaimed is the amount of pages reclaimed in the current round,
whereas nr_to_reclaim shoud be compared with the amount of pages
reclaimed in all
rounds, so we have to buffer the pages reclaimed in the past rounds for correct
comparison.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/vmscan.c	Sat Jan 14 14:02:20 2012
+++ b/mm/vmscan.c	Sat Jan 21 22:23:48 2012
@@ -2081,13 +2081,15 @@ static void shrink_mem_cgroup_zone(int p
 				   struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
+	unsigned long reclaimed = 0;
 	unsigned long nr_to_scan;
 	enum lru_list lru;
-	unsigned long nr_reclaimed, nr_scanned;
+	unsigned long nr_reclaimed = 0, nr_scanned;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct blk_plug plug;

 restart:
+	reclaimed += nr_reclaimed;
 	nr_reclaimed = 0;
 	nr_scanned = sc->nr_scanned;
 	get_scan_count(mz, sc, nr, priority);
@@ -2113,7 +2115,8 @@ restart:
 		 * with multiple processes reclaiming pages, the total
 		 * freeing target can get unreasonably large.
 		 */
-		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
+		if ((nr_reclaimed + reclaimed) >= nr_to_reclaim &&
+					priority < DEF_PRIORITY)
 			break;
 	}
 	blk_finish_plug(&plug);
