Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab0KPGH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 01:07:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34835 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab0KPGH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 01:07:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH v3] factor out kswapd sleeping logic from kswapd()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20101115094239.GH27362@csn.ul.ie>
References: <20101114180505.BEE2.A69D9226@jp.fujitsu.com> <20101115094239.GH27362@csn.ul.ie>
Message-Id: <20101116144709.BF26.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Nov 2010 15:07:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +void kswapd_try_to_sleep(pg_data_t *pgdat, int order)
> > +{
> 
> As pointed out elsewhere, this should be static.

Fixed.


> > +	long remaining = 0;
> > +	DEFINE_WAIT(wait);
> > +
> > +	if (freezing(current) || kthread_should_stop())
> > +		return;
> > +
> > +	prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
> > +
> > +	/* Try to sleep for a short interval */
> > +	if (!sleeping_prematurely(pgdat, order, remaining)) {
> > +		remaining = schedule_timeout(HZ/10);
> > +		finish_wait(&pgdat->kswapd_wait, &wait);
> > +		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
> > +	}
> > +
> > +	/*
> > +	 * After a short sleep, check if it was a
> > +	 * premature sleep. If not, then go fully
> > +	 * to sleep until explicitly woken up
> > +	 */
> 
> Very minor but that comment should now fit on fewer lines.

Thanks, fixed.


> > +	if (!sleeping_prematurely(pgdat, order, remaining)) {
> > +		trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
> > +		set_pgdat_percpu_threshold(pgdat, calculate_normal_threshold);
> > +		schedule();
> > +		set_pgdat_percpu_threshold(pgdat, calculate_pressure_threshold);
> 
> I posted a patch adding a comment on why set_pgdat_percpu_threshold() is
> called. I do not believe it has been picked up by Andrew but it if is,
> the patches will conflict. The resolution will be obvious but you may
> need to respin this patch if the comment patch gets picked up in mmotm.
> 
> Otherwise, I see no problems.

OK, I've rebased the patch on top your comment patch. 



>From 1bd232713d55f033676f80cc7451ff83d4483884 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 6 Dec 2010 20:44:27 +0900
Subject: [PATCH] factor out kswapd sleeping logic from kswapd()

Currently, kswapd() function has deeper nest and it slightly harder to
read. cleanup it.

Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   92 +++++++++++++++++++++++++++++-----------------------------
 1 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33994b7..cd07b97 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2364,6 +2364,50 @@ out:
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
+	 * After a short sleep, check if it was a premature sleep. If not, then
+	 * go fully to sleep until explicitly woken up.
+	 */
+	if (!sleeping_prematurely(pgdat, order, remaining)) {
+		trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
+
+		/*
+		 * vmstat counters are not perfectly accurate and the estimated
+		 * value for counters such as NR_FREE_PAGES can deviate from the
+		 * true value by nr_online_cpus * threshold. To avoid the zone
+		 * watermarks being breached while under pressure, we reduce the
+		 * per-cpu vmstat threshold while kswapd is awake and restore
+		 * them before going back to sleep.
+		 */
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
@@ -2382,7 +2426,7 @@ static int kswapd(void *p)
 	unsigned long order;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
-	DEFINE_WAIT(wait);
+
 	struct reclaim_state reclaim_state = {
 		.reclaimed_slab = 0,
 	};
@@ -2414,7 +2458,6 @@ static int kswapd(void *p)
 		unsigned long new_order;
 		int ret;
 
-		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 		new_order = pgdat->kswapd_max_order;
 		pgdat->kswapd_max_order = 0;
 		if (order < new_order) {
@@ -2424,52 +2467,9 @@ static int kswapd(void *p)
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
-
-					/*
-					 * vmstat counters are not perfectly
-					 * accurate and the estimated value
-					 * for counters such as NR_FREE_PAGES
-					 * can deviate from the true value by
-					 * nr_online_cpus * threshold. To
-					 * avoid the zone watermarks being
-					 * breached while under pressure, we
-					 * reduce the per-cpu vmstat threshold
-					 * while kswapd is awake and restore
-					 * them before going back to sleep.
-					 */
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



