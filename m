Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab0KOBha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 20:37:30 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59813 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab0KOBh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 20:37:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] cleanup kswapd()
Cc: kosaki.motohiro@jp.fujitsu.com, Jesper Juhl <jj@chaosbits.net>,
        Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20101115092712.BEF4.A69D9226@jp.fujitsu.com>
References: <alpine.LNX.2.00.1011141202430.3460@swampdragon.chaosbits.net> <20101115092712.BEF4.A69D9226@jp.fujitsu.com>
Message-Id: <20101115103623.BF03.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Nov 2010 10:37:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right. thank you.
> I'll respin.

Done.



>From a29f0f5b780170fc26eb9210df03ed974aad8362 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 3 Dec 2010 10:48:41 +0900
Subject: [PATCH] factor out kswapd sleeping logic from kswapd()

Currently, kswapd() function has deeper nest and it slightly harder to
read. cleanup it.

Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   71 +++++++++++++++++++++++++++++++---------------------------
 1 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8cc90d5..3ee33a8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2364,6 +2364,42 @@ out:
 	return sc.nr_reclaimed;
 }
 
+static void kswapd_try_to_sleep(pg_data_t *pgdat, int order)
+{
+	long remaining = 0;
+	DEFINE_WAIT(wait);
+
+	if (freezing(current) || kthread_should_stop())
+		return;
+
+	prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
+
+	/* Try to sleep for a short interval */
+	if (!sleeping_prematurely(pgdat, order, remaining)) {
+		remaining = schedule_timeout(HZ/10);
+		finish_wait(&pgdat->kswapd_wait, &wait);
+		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
+	}
+
+	/*
+	 * After a short sleep, check if it was a
+	 * premature sleep. If not, then go fully
+	 * to sleep until explicitly woken up
+	 */
+	if (!sleeping_prematurely(pgdat, order, remaining)) {
+		trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
+		set_pgdat_percpu_threshold(pgdat, calculate_normal_threshold);
+		schedule();
+		set_pgdat_percpu_threshold(pgdat, calculate_pressure_threshold);
+	} else {
+		if (remaining)
+			count_vm_event(KSWAPD_LOW_WMARK_HIT_QUICKLY);
+		else
+			count_vm_event(KSWAPD_HIGH_WMARK_HIT_QUICKLY);
+	}
+	finish_wait(&pgdat->kswapd_wait, &wait);
+}
+
 /*
  * The background pageout daemon, started as a kernel thread
  * from the init process.
@@ -2382,7 +2418,7 @@ static int kswapd(void *p)
 	unsigned long order;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
-	DEFINE_WAIT(wait);
+
 	struct reclaim_state reclaim_state = {
 		.reclaimed_slab = 0,
 	};
@@ -2414,7 +2450,6 @@ static int kswapd(void *p)
 		unsigned long new_order;
 		int ret;
 
-		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 		new_order = pgdat->kswapd_max_order;
 		pgdat->kswapd_max_order = 0;
 		if (order < new_order) {
@@ -2424,39 +2459,9 @@ static int kswapd(void *p)
 			 */
 			order = new_order;
 		} else {
-			if (!freezing(current) && !kthread_should_stop()) {
-				long remaining = 0;
-
-				/* Try to sleep for a short interval */
-				if (!sleeping_prematurely(pgdat, order, remaining)) {
-					remaining = schedule_timeout(HZ/10);
-					finish_wait(&pgdat->kswapd_wait, &wait);
-					prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
-				}
-
-				/*
-				 * After a short sleep, check if it was a
-				 * premature sleep. If not, then go fully
-				 * to sleep until explicitly woken up
-				 */
-				if (!sleeping_prematurely(pgdat, order, remaining)) {
-					trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
-					set_pgdat_percpu_threshold(pgdat,
-						calculate_normal_threshold);
-					schedule();
-					set_pgdat_percpu_threshold(pgdat,
-						calculate_pressure_threshold);
-				} else {
-					if (remaining)
-						count_vm_event(KSWAPD_LOW_WMARK_HIT_QUICKLY);
-					else
-						count_vm_event(KSWAPD_HIGH_WMARK_HIT_QUICKLY);
-				}
-			}
-
+			kswapd_try_to_sleep(pgdat, order);
 			order = pgdat->kswapd_max_order;
 		}
-		finish_wait(&pgdat->kswapd_wait, &wait);
 
 		ret = try_to_freeze();
 		if (kthread_should_stop())
-- 
1.6.5.2





