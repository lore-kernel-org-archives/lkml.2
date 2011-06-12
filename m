Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab1FLQVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 12:21:23 -0400
Received: from mail.perches.com ([173.55.12.10]:2811 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab1FLQVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 12:21:19 -0400
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] block: Add __attribute__((format(printf...) and fix fallout
Date: Sun, 12 Jun 2011 09:21:14 -0700
Message-Id: <5cfffa9f4ffc97d87beb2195cf949eb353f70d7a.1307895296.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <17ffbd77627a21c05ab9e1a07b5207334291cf01.1307895293.git.joe@perches.com>
References: <17ffbd77627a21c05ab9e1a07b5207334291cf01.1307895293.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the compiler to verify format strings and arguments.

Fix fallout.

Signed-off-by: Joe Perches <joe@perches.com>
---
 block/blk-throttle.c         |    4 ++--
 block/cfq-iosched.c          |   11 ++++++-----
 include/linux/blktrace_api.h |    3 ++-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a62be8d..3689f83 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -927,7 +927,7 @@ static int throtl_dispatch(struct request_queue *q)
 
 	bio_list_init(&bio_list_on_stack);
 
-	throtl_log(td, "dispatch nr_queued=%lu read=%u write=%u",
+	throtl_log(td, "dispatch nr_queued=%d read=%u write=%u",
 			total_nr_queued(td), td->nr_queued[READ],
 			td->nr_queued[WRITE]);
 
@@ -1204,7 +1204,7 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 	}
 
 queue_bio:
-	throtl_log_tg(td, tg, "[%c] bio. bdisp=%u sz=%u bps=%llu"
+	throtl_log_tg(td, tg, "[%c] bio. bdisp=%llu sz=%u bps=%llu"
 			" iodisp=%u iops=%u queued=%d/%d",
 			rw == READ ? 'R' : 'W',
 			tg->bytes_disp[rw], bio->bi_size, tg->bps[rw],
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3c7b537..587513e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -988,9 +988,10 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
 					st->min_vdisktime);
-	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u"
-			" sect=%u", used_sl, cfqq->slice_dispatch, charge,
-			iops_mode(cfqd), cfqq->nr_sectors);
+	cfq_log_cfqq(cfqq->cfqd, cfqq,
+		     "sl_used=%u disp=%u charge=%u iops=%u sect=%lu",
+		     used_sl, cfqq->slice_dispatch, charge,
+		     iops_mode(cfqd), cfqq->nr_sectors);
 	cfq_blkiocg_update_timeslice_used(&cfqg->blkg, used_sl,
 					  unaccounted_sl);
 	cfq_blkiocg_set_start_empty_time(&cfqg->blkg);
@@ -2023,8 +2024,8 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 */
 	if (sample_valid(cic->ttime_samples) &&
 	    (cfqq->slice_end - jiffies < cic->ttime_mean)) {
-		cfq_log_cfqq(cfqd, cfqq, "Not idling. think_time:%d",
-				cic->ttime_mean);
+		cfq_log_cfqq(cfqd, cfqq, "Not idling. think_time:%lu",
+			     cic->ttime_mean);
 		return;
 	}
 
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index b22fb0d..8c7c2de 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -169,7 +169,8 @@ extern void blk_trace_shutdown(struct request_queue *);
 extern int do_blk_trace_setup(struct request_queue *q, char *name,
 			      dev_t dev, struct block_device *bdev,
 			      struct blk_user_trace_setup *buts);
-extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
+extern __attribute__((format(printf, 2, 3)))
+void __trace_note_message(struct blk_trace *, const char *fmt, ...);
 
 /**
  * blk_add_trace_msg - Add a (simple) message to the blktrace stream
-- 
1.7.6.rc1

