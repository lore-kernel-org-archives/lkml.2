Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab1GHEPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:15:21 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:32854 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194Ab1GHEPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:15:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0EAIiCFk55LCkBgWdsb2JhbABTp0EVAQEWJiXNDYY4BKMi
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 03/14] vmscan: shrinker->nr updates race and go wrong
Date: Fri,  8 Jul 2011 14:14:35 +1000
Message-Id: <1310098486-6453-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1310098486-6453-1-git-send-email-david@fromorbit.com>
References: <1310098486-6453-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

shrink_slab() allows shrinkers to be called in parallel so the
struct shrinker can be updated concurrently. It does not provide any
exclusio for such updates, so we can get the shrinker->nr value
increasing or decreasing incorrectly.

As a result, when a shrinker repeatedly returns a value of -1 (e.g.
a VFS shrinker called w/ GFP_NOFS), the shrinker->nr goes haywire,
sometimes updating with the scan count that wasn't used, sometimes
losing it altogether. Worse is when a shrinker does work and that
update is lost due to racy updates, which means the shrinker will do
the work again!

Fix this by making the total_scan calculations independent of
shrinker->nr, and making the shrinker->nr updates atomic w.r.t. to
other updates via cmpxchg loops.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mm/vmscan.c |   45 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 646cb6c..666d811 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -251,17 +251,29 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 		unsigned long total_scan;
 		unsigned long max_pass;
 		int shrink_ret = 0;
+		long nr;
+		long new_nr;
 
+		/*
+		 * copy the current shrinker scan count into a local variable
+		 * and zero it so that other concurrent shrinker invocations
+		 * don't also do this scanning work.
+		 */
+		do {
+			nr = shrinker->nr;
+		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
+
+		total_scan = nr;
 		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
 		delta = (4 * nr_pages_scanned) / shrinker->seeks;
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);
-		shrinker->nr += delta;
-		if (shrinker->nr < 0) {
+		total_scan += delta;
+		if (total_scan < 0) {
 			printk(KERN_ERR "shrink_slab: %pF negative objects to "
 			       "delete nr=%ld\n",
-			       shrinker->shrink, shrinker->nr);
-			shrinker->nr = max_pass;
+			       shrinker->shrink, total_scan);
+			total_scan = max_pass;
 		}
 
 		/*
@@ -269,13 +281,10 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 		 * never try to free more than twice the estimate number of
 		 * freeable entries.
 		 */
-		if (shrinker->nr > max_pass * 2)
-			shrinker->nr = max_pass * 2;
-
-		total_scan = shrinker->nr;
-		shrinker->nr = 0;
+		if (total_scan > max_pass * 2)
+			total_scan = max_pass * 2;
 
-		trace_mm_shrink_slab_start(shrinker, shrink, total_scan,
+		trace_mm_shrink_slab_start(shrinker, shrink, nr,
 					nr_pages_scanned, lru_pages,
 					max_pass, delta, total_scan);
 
@@ -296,9 +305,19 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 			cond_resched();
 		}
 
-		shrinker->nr += total_scan;
-		trace_mm_shrink_slab_end(shrinker, shrink_ret, total_scan,
-					 shrinker->nr);
+		/*
+		 * move the unused scan count back into the shrinker in a
+		 * manner that handles concurrent updates. If we exhausted the
+		 * scan, there is no need to do an update.
+		 */
+		do {
+			nr = shrinker->nr;
+			new_nr = total_scan + nr;
+			if (total_scan <= 0)
+				break;
+		} while (cmpxchg(&shrinker->nr, nr, new_nr) != nr);
+
+		trace_mm_shrink_slab_end(shrinker, shrink_ret, nr, new_nr);
 	}
 	up_read(&shrinker_rwsem);
 out:
-- 
1.7.5.1

