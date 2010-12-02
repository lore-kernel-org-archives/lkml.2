Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab0LBQBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:01:19 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58837 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab0LBQBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:01:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fuSaX97Ra8JVD80ZLSOETuG+ZwBJm0if2inMAWZQpzV0zJQq2b5SzvHDKpELLJ0PeM
         w30Sj2NyfI0SVA6UdyYIIlpt1XtOVnI0x3Z1pjsRo+Oeygp1yrvGH8kNdKTStkS5C+03
         V3c57d16BVsoLzMwlmhQPTQwRE9xbB+Ux0I2A=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH] vmscan: make kswapd use a correct order
Date: Fri,  3 Dec 2010 01:00:49 +0900
Message-Id: <1291305649-2405-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we wake up prematurely, it means we should keep going on
reclaiming not new order page but at old order page.
Sometime new order can be smaller than old order by below
race so it could make failure of old order page reclaiming.

T0: Task 1 wakes up kswapd with order-3
T1: So, kswapd starts to reclaim pages using balance_pgdat
T2: Task 2 wakes up kswapd with order-2 because pages reclaimed
	by T1 are consumed quickly.
T3: kswapd exits balance_pgdat and will do following:
T4-1: In beginning of kswapd's loop, pgdat->kswapd_max_order will
	be reset with zero.
T4-2: 'order' will be set to pgdat->kswapd_max_order(0), since it
        enters the false branch of 'if (order (3) < new_order (2))'
T4-3: If previous balance_pgdat can't meet requirement of order-2
	free pages by high watermark, it will start reclaiming again.
        So balance_pgdat will use order-0 to do reclaim while it
	really should use order-2 at the moment.
T4-4: At last, Task 1 can't get the any page if it wanted with
	GFP_ATOMIC.

Reported-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Shaohua Li <shaohua.li@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 42a4859..27d0839 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2447,13 +2447,18 @@ out:
 	return sc.nr_reclaimed;
 }
 
-static void kswapd_try_to_sleep(pg_data_t *pgdat, int order)
+/*
+ * Return true if we slept enough. Otherwise, return false
+ */
+static bool kswapd_try_to_sleep(pg_data_t *pgdat, int order)
 {
 	long remaining = 0;
+	bool slept = false;
+
 	DEFINE_WAIT(wait);
 
 	if (freezing(current) || kthread_should_stop())
-		return;
+		return slept;
 
 	prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 
@@ -2482,6 +2487,7 @@ static void kswapd_try_to_sleep(pg_data_t *pgdat, int order)
 		set_pgdat_percpu_threshold(pgdat, calculate_normal_threshold);
 		schedule();
 		set_pgdat_percpu_threshold(pgdat, calculate_pressure_threshold);
+		slept = true;
 	} else {
 		if (remaining)
 			count_vm_event(KSWAPD_LOW_WMARK_HIT_QUICKLY);
@@ -2489,6 +2495,8 @@ static void kswapd_try_to_sleep(pg_data_t *pgdat, int order)
 			count_vm_event(KSWAPD_HIGH_WMARK_HIT_QUICKLY);
 	}
 	finish_wait(&pgdat->kswapd_wait, &wait);
+
+	return slept;
 }
 
 /*
@@ -2550,8 +2558,15 @@ static int kswapd(void *p)
 			 */
 			order = new_order;
 		} else {
-			kswapd_try_to_sleep(pgdat, order);
-			order = pgdat->kswapd_max_order;
+			/*
+			 * If we wake up after enough sleeping, it means
+			 * we reclaimed enough pages at that order. so
+			 * we starts reclaim new order in this time.
+			 * Otherwise, it was a premature sleep so we should
+			 * keep going on reclaiming at that order pages.
+			 */
+			if (kswapd_try_to_sleep(pgdat, order))
+				order = pgdat->kswapd_max_order;
 		}
 
 		ret = try_to_freeze();
-- 
1.7.0.4

