Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0GIGw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 02:52:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45655 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0GIGwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 02:52:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] vmscan: protect to read reclaim_stat by lru_lock
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100709155108.3D2A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Jul 2010 15:52:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel pointed out reading reclaim_stat should be protected
lru_lock, otherwise vmscan might sweep 2x much pages.

This fault was introduced by followint commit.

  commit 4f98a2fee8acdb4ac84545df98cccecfd130f8db
  Author: Rik van Riel <riel@redhat.com>
  Date:   Sat Oct 18 20:26:32 2008 -0700

    vmscan: split LRU lists into anon & file sets

    Split the LRU lists in two, one set for pages that are backed by real file
    systems ("file") and one for pages that are backed by memory and swap
    ("anon").  The latter includes tmpfs.

    The advantage of doing this is that the VM will not have to scan over lots
    of anonymous pages (which we generally do not want to swap out), just to
    find the page cache pages that it should evict.

    This patch has the infrastructure and a basic policy to balance how much
    we scan the anon lists and how much we scan the file lists.  The big
    policy changes are in separate patches.

Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0f9f624..5a377e6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1581,6 +1581,13 @@ static void get_scan_count(struct zone *zone, struct scan_control *sc,
 	}
 
 	/*
+	 * With swappiness at 100, anonymous and file have the same priority.
+	 * This scanning priority is essentially the inverse of IO cost.
+	 */
+	anon_prio = sc->swappiness;
+	file_prio = 200 - sc->swappiness;
+
+	/*
 	 * OK, so we have swap space and a fair amount of page cache
 	 * pages.  We use the recently rotated / recently scanned
 	 * ratios to determine how valuable each cache is.
@@ -1591,28 +1598,18 @@ static void get_scan_count(struct zone *zone, struct scan_control *sc,
 	 *
 	 * anon in [0], file in [1]
 	 */
+	spin_lock_irq(&zone->lru_lock);
 	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
-		spin_lock_irq(&zone->lru_lock);
 		reclaim_stat->recent_scanned[0] /= 2;
 		reclaim_stat->recent_rotated[0] /= 2;
-		spin_unlock_irq(&zone->lru_lock);
 	}
 
 	if (unlikely(reclaim_stat->recent_scanned[1] > file / 4)) {
-		spin_lock_irq(&zone->lru_lock);
 		reclaim_stat->recent_scanned[1] /= 2;
 		reclaim_stat->recent_rotated[1] /= 2;
-		spin_unlock_irq(&zone->lru_lock);
 	}
 
 	/*
-	 * With swappiness at 100, anonymous and file have the same priority.
-	 * This scanning priority is essentially the inverse of IO cost.
-	 */
-	anon_prio = sc->swappiness;
-	file_prio = 200 - sc->swappiness;
-
-	/*
 	 * The amount of pressure on anon vs file pages is inversely
 	 * proportional to the fraction of recently scanned pages on
 	 * each list that were recently referenced and in active use.
@@ -1622,6 +1619,7 @@ static void get_scan_count(struct zone *zone, struct scan_control *sc,
 
 	fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
 	fp /= reclaim_stat->recent_rotated[1] + 1;
+	spin_unlock_irq(&zone->lru_lock);
 
 	fraction[0] = ap;
 	fraction[1] = fp;
-- 
1.6.5.2



