Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab1HSPhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:37:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:31183 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1HSPhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:37:13 -0400
From: Maxim Patlasov <maxim.patlasov@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] CFQ: fix handling 'deep' cfqq
Date: Fri, 19 Aug 2011 19:38:38 +0400
Message-Id: <1313768318-7960-2-git-send-email-maxim.patlasov@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313768318-7960-1-git-send-email-maxim.patlasov@gmail.com>
References: <1313768318-7960-1-git-send-email-maxim.patlasov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch re-works changes introduced by commit
8e1ac6655104bc6e1e79d67e2df88cc8fa9b6e07 to make decision about
idle/noidle behaviour on seeky&deep cfqq-s more precise.

The problems found in that former patch:

1. "the queue delivers all requests before half its slice is used" is too
pessimistic estimation. It can be demonstrated by aio-stress on a commodity
server with single slow SATA hdd that the estimate provides so many false
positives to degrade performance significantly (up to 35% as compared with
pristine 3.1.0-rc2 w/o that patch).

2. There is a time gap between marking cfqq as 'deep' and 'idle_window' in
cfq_update_idle_window() and clearing these bits in cfq_select_queue(). Till
these bits are cleared there may be pretty many cfqq-s marked as 'deep' and
'idle_window'. This effectively disables preemption becasue CFQ usually
allows it only between SYNC_NOIDLE_WORKLOAD cfqq-s. It can be demostrated by
slightly modified aio-stress (adding 1 msec think-time) that this problem may
chews up to 30% of performance on fast h/w raids (as compared with setting
slice_idle=0 or noop scheduler).

3. It's possible that a task was preempted in the middle of dispatch round.
Then, condition "the queue delivers all requests before half its slice is used"
will be checked for shallow queue. In such cases CFQ will regard slow disk as
fast.

4. It's possible that the queue at the moment of marking a task as "deep" was
much deeper than four requests. Then the fact that the queue haven't delivered
all requests quickly doesn't imply that the disk is slow. In such cases CFQ
may regard fast disk as slow.

An aproach suggested here avoids performance degradations mentioned above.
With this patch applied, the performance on slow hdd is the same as it used
to be before 8e1ac6655104bc6e1e79d67e2df88cc8fa9b6e07, and, on fast h/w-raids,
it's roughly the same as for noop scheduler or CFQ with slice_idle=0.

Signed-off-by: Maxim Patlasov <maxim.patlasov@gmail.com>
---
 block/cfq-iosched.c |   90 +++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 77 insertions(+), 13 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1f96ad6..cf4b643 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -53,6 +53,11 @@ static const int cfq_hist_divisor = 4;
 #define CFQQ_SECT_THR_NONROT	(sector_t)(2 * 32)
 #define CFQQ_SEEKY(cfqq)	(hweight32(cfqq->seek_history) > 32/8)
 
+#define CFQQ_DEEP_THR		4
+
+#define CFQD_DISK_LOOKS_FAST(cfqd)				\
+	(cfqd->cfq_disk_looks_fast > cfqd->cfq_disk_looks_slow)
+
 #define RQ_CIC(rq)		\
 	((struct cfq_io_context *) (rq)->elevator_private[0])
 #define RQ_CFQQ(rq)		(struct cfq_queue *) ((rq)->elevator_private[1])
@@ -147,6 +152,11 @@ struct cfq_queue {
 	struct cfq_group *cfqg;
 	/* Number of sectors dispatched from queue in single dispatch round */
 	unsigned long nr_sectors;
+
+	/* When fisrst dispatch in dispatch round happened */
+	unsigned long first_dispatch;
+	/* Number of dispatch happened since first dispatch + 1 */
+	int n_dispatched;
 };
 
 /*
@@ -303,6 +313,17 @@ struct cfq_data {
 
 	/* Number of groups which are on blkcg->blkg_list */
 	unsigned int nr_blkcg_linked_grps;
+
+	/*
+	 * # times disk claimed as fast and slow correspondingly
+	 */
+	int cfq_disk_looks_fast;
+	int cfq_disk_looks_slow;
+
+	/*
+	 * when fast/slow fields were updated last time
+	 */
+	unsigned long cfq_disk_last_updated;
 };
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
@@ -333,6 +354,10 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
 	CFQ_CFQQ_FLAG_split_coop,	/* shared cfqq will be splitted */
 	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
+	CFQ_CFQQ_FLAG_deep_early,	/* sync cfqq experienced large depth in
+					 * the beginning of time-slice, check
+					 * whether dirver can drain the queue
+					 * quickly */
 	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
 };
 
@@ -362,6 +387,7 @@ CFQ_CFQQ_FNS(sync);
 CFQ_CFQQ_FNS(coop);
 CFQ_CFQQ_FNS(split_coop);
 CFQ_CFQQ_FNS(deep);
+CFQ_CFQQ_FNS(deep_early);
 CFQ_CFQQ_FNS(wait_busy);
 #undef CFQ_CFQQ_FNS
 
@@ -1704,6 +1730,11 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 		cfqq->slice_dispatch = 0;
 		cfqq->nr_sectors = 0;
 
+		cfqq->first_dispatch = 0;
+		cfqq->n_dispatched = 0;
+		if (cfqq->queued[0] + cfqq->queued[1] >= CFQQ_DEEP_THR)
+			cfq_mark_cfqq_deep_early(cfqq);
+
 		cfq_clear_cfqq_wait_request(cfqq);
 		cfq_clear_cfqq_must_dispatch(cfqq);
 		cfq_clear_cfqq_must_alloc_slice(cfqq);
@@ -1725,6 +1756,12 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 {
 	cfq_log_cfqq(cfqd, cfqq, "slice expired t=%d", timed_out);
 
+	if (cfq_cfqq_deep_early(cfqq)) {
+		cfqq->first_dispatch = 0;
+		cfqq->n_dispatched = 0;
+		cfq_clear_cfqq_deep_early(cfqq);
+	}
+
 	if (cfq_cfqq_wait_request(cfqq))
 		cfq_del_timer(cfqd, cfqq);
 
@@ -2059,6 +2096,12 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 
 	cfq_log_cfqq(cfqd, cfqq, "dispatch_insert");
 
+	if (cfq_cfqq_deep_early(cfqq)) {
+		cfqq->n_dispatched++;
+		if (!cfqq->first_dispatch)
+			cfqq->first_dispatch = jiffies;
+	}
+
 	cfqq->next_rq = cfq_find_next_rq(cfqd, cfqq, rq);
 	cfq_remove_request(rq);
 	cfqq->dispatched++;
@@ -2333,6 +2376,27 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 			goto check_group_idle;
 	}
 
+	if (cfq_cfqq_deep_early(cfqq) && cfqq->n_dispatched >= CFQQ_DEEP_THR) {
+		if (cfqq->first_dispatch == jiffies)
+			cfqd->cfq_disk_looks_fast++;
+		else
+			cfqd->cfq_disk_looks_slow++;
+
+		cfqq->first_dispatch = 0;
+		cfqq->n_dispatched = 0;
+		cfq_clear_cfqq_deep_early(cfqq);
+		cfqd->cfq_disk_last_updated = jiffies;
+	}
+
+	if ((cfqd->cfq_disk_last_updated &&
+	     jiffies - cfqd->cfq_disk_last_updated > HZ * 10) ||
+	    cfqd->cfq_disk_looks_fast > 128 ||
+	    cfqd->cfq_disk_looks_slow > 128) {
+		cfqd->cfq_disk_looks_fast >>= 1;
+		cfqd->cfq_disk_looks_slow >>= 1;
+		cfqd->cfq_disk_last_updated = jiffies;
+	}
+
 	/*
 	 * The active queue has requests and isn't expired, allow it to
 	 * dispatch.
@@ -2340,6 +2404,12 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	if (!RB_EMPTY_ROOT(&cfqq->sort_list))
 		goto keep_queue;
 
+	if (cfq_cfqq_deep_early(cfqq)) {
+		cfqq->first_dispatch = 0;
+		cfqq->n_dispatched = 0;
+		cfq_clear_cfqq_deep_early(cfqq);
+	}
+
 	/*
 	 * If another queue has a request waiting within our mean seek
 	 * distance, let it run.  The expire code will check for close
@@ -2363,17 +2433,6 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 		goto keep_queue;
 	}
 
-	/*
-	 * This is a deep seek queue, but the device is much faster than
-	 * the queue can deliver, don't idle
-	 **/
-	if (CFQQ_SEEKY(cfqq) && cfq_cfqq_idle_window(cfqq) &&
-	    (cfq_cfqq_slice_new(cfqq) ||
-	    (cfqq->slice_end - jiffies > jiffies - cfqq->slice_start))) {
-		cfq_clear_cfqq_deep(cfqq);
-		cfq_clear_cfqq_idle_window(cfqq);
-	}
-
 	if (cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
 		cfqq = NULL;
 		goto keep_queue;
@@ -3286,13 +3345,18 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
-	if (cfqq->queued[0] + cfqq->queued[1] >= 4)
+	if (cfqq->queued[0] + cfqq->queued[1] >= CFQQ_DEEP_THR) {
 		cfq_mark_cfqq_deep(cfqq);
 
+		if (cfq_cfqq_slice_new(cfqq))
+			cfq_mark_cfqq_deep_early(cfqq);
+	}
+
 	if (cfqq->next_rq && (cfqq->next_rq->cmd_flags & REQ_NOIDLE))
 		enable_idle = 0;
 	else if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
+		 ((!cfq_cfqq_deep(cfqq) || CFQD_DISK_LOOKS_FAST(cfqd))
+		  && CFQQ_SEEKY(cfqq)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime.ttime_samples)) {
 		if (cic->ttime.ttime_mean > cfqd->cfq_slice_idle)
-- 
1.7.4.4

