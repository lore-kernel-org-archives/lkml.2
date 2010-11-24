Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab0KXDXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 22:23:14 -0500
Received: from mail.perches.com ([173.55.12.10]:1833 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab0KXDXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 22:23:13 -0500
Subject: [PATCH] block: Add __attribute__((format (printf to
 __trace_note_message and fix fallout
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 19:23:12 -0800
Message-ID: <1290568992.11971.32.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And change formats match arguments.
Change !CONFIG_BLK_DEV_IO_TRACE blk_add_trace_msg macro to no_printk

Signed-off-by: Joe Perches <joe@perches.com>
---
 block/blk-throttle.c         |   18 +++++++++---------
 block/cfq-iosched.c          |   11 ++++++-----
 include/linux/blktrace_api.h |    6 ++++--
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 56ad453..40cee22 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -761,9 +761,9 @@ static int throtl_dispatch(struct request_queue *q)
 
 	bio_list_init(&bio_list_on_stack);
 
-	throtl_log(td, "dispatch nr_queued=%lu read=%u write=%u",
-			total_nr_queued(td), td->nr_queued[READ],
-			td->nr_queued[WRITE]);
+	throtl_log(td, "dispatch nr_queued=%d read=%u write=%u",
+		   total_nr_queued(td), td->nr_queued[READ],
+		   td->nr_queued[WRITE]);
 
 	nr_disp = throtl_select_dispatch(td, &bio_list_on_stack);
 
@@ -1005,12 +1005,12 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 	}
 
 queue_bio:
-	throtl_log_tg(td, tg, "[%c] bio. bdisp=%u sz=%u bps=%llu"
-			" iodisp=%u iops=%u queued=%d/%d",
-			rw == READ ? 'R' : 'W',
-			tg->bytes_disp[rw], bio->bi_size, tg->bps[rw],
-			tg->io_disp[rw], tg->iops[rw],
-			tg->nr_queued[READ], tg->nr_queued[WRITE]);
+	throtl_log_tg(td, tg,
+		      "[%c] bio. bdisp=%llu sz=%u bps=%llu iodisp=%u iops=%u queued=%d/%d",
+		      rw == READ ? 'R' : 'W',
+		      (unsigned long long)tg->bytes_disp[rw], bio->bi_size,
+		      tg->bps[rw], tg->io_disp[rw], tg->iops[rw],
+		      tg->nr_queued[READ], tg->nr_queued[WRITE]);
 
 	throtl_add_bio_tg(q->td, tg, bio);
 	*biop = NULL;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 78ee4b1..dd51f6b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -971,9 +971,10 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
 					st->min_vdisktime);
-	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u"
-			" sect=%u", used_sl, cfqq->slice_dispatch, charge,
-			iops_mode(cfqd), cfqq->nr_sectors);
+	cfq_log_cfqq(cfqq->cfqd, cfqq,
+		     "sl_used=%u disp=%u charge=%u iops=%u sect=%lu",
+		     used_sl, cfqq->slice_dispatch, charge,
+		     iops_mode(cfqd), cfqq->nr_sectors);
 	cfq_blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
 	cfq_blkiocg_set_start_empty_time(&cfqg->blkg);
 }
@@ -1955,8 +1956,8 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
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
index 3395cf7..514503c 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -169,7 +169,8 @@ extern void blk_trace_shutdown(struct request_queue *);
 extern int do_blk_trace_setup(struct request_queue *q, char *name,
 			      dev_t dev, struct block_device *bdev,
 			      struct blk_user_trace_setup *buts);
-extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
+extern __attribute((format (printf, 2, 3)))
+void __trace_note_message(struct blk_trace *, const char *fmt, ...);
 
 /**
  * blk_add_trace_msg - Add a (simple) message to the blktrace stream
@@ -212,7 +213,8 @@ extern struct attribute_group blk_trace_attr_group;
 # define blk_trace_setup(q, name, dev, bdev, arg)	(-ENOTTY)
 # define blk_trace_startstop(q, start)			(-ENOTTY)
 # define blk_trace_remove(q)				(-ENOTTY)
-# define blk_add_trace_msg(q, fmt, ...)			do { } while (0)
+# define blk_add_trace_msg(q, fmt, ...)			\
+	do { no_printk(fmt, ##__VA_ARGS__); } while (0)
 # define blk_trace_remove_sysfs(dev)			do { } while (0)
 static inline int blk_trace_init_sysfs(struct device *dev)
 {


