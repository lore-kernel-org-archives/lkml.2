Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab0FTW4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:56:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab0FTW4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:56:38 -0400
Date: Sun, 20 Jun 2010 18:56:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH] cfq-iosched: Fixed boot warning with BLK_CGROUP=y and
 CFQ_GROUP_IOSCHED=n
Message-ID: <20100620225622.GA12368@redhat.com>
References: <20100618143947.GA8431@redhat.com>
 <20100620081016.GA5365@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100620081016.GA5365@elte.hu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 10:10:16AM +0200, Ingo Molnar wrote:
> 
> * Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > Hi Jens,
> > 
> > Few days back Ingo noticed a CFQ boot time warning. This patch fixes it.
> 
> Hm, have you tested it? This bit:

I did compile and boot testing. Booted with CFQ_GROUP_IOSCHED=n to make
sure warning seen by you is gone. And IIRC, I also booted with
CFQ_GROUP_IOSCHED=y and it seems to compile and boot just fine. Not sure
why though.

> 
> > +++ linux-2.6/block/cfq.h	2010-06-18 09:41:23.256220395 -0400
> 
> > +static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg, uint64_t start_time, uint64_t io_start_time, bool direction, bool sync)
> > +{
> > +	cfq_blkiocg_update_completion_stats(blkg, start_time, io_start_time,
> > +				direction, sync);
> > +}
> 
> is an inline function calling itself.

That's my mistake. Sorry for that.  Here is the new patch fixing this
issue.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   54 ++++++++++++------------
 block/cfq.h         |  116 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+), 27 deletions(-)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c	2010-06-18 09:40:46.403163874 -0400
+++ linux-2.6/block/cfq-iosched.c	2010-06-18 09:47:58.747339881 -0400
@@ -14,7 +14,7 @@
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
-#include "blk-cgroup.h"
+#include "cfq.h"
 
 /*
  * tunables
@@ -879,7 +879,7 @@
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
 		cfq_rb_erase(&cfqg->rb_node, st);
 	cfqg->saved_workload_slice = 0;
-	blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
+	cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
 }
 
 static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
@@ -939,8 +939,8 @@
 
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
 					st->min_vdisktime);
-	blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
-	blkiocg_set_start_empty_time(&cfqg->blkg);
+	cfq_blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
+	cfq_blkiocg_set_start_empty_time(&cfqg->blkg);
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
@@ -995,7 +995,7 @@
 
 	/* Add group onto cgroup list */
 	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
+	cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
 					MKDEV(major, minor));
 	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
 
@@ -1079,7 +1079,7 @@
 		 * it from cgroup list, then it will take care of destroying
 		 * cfqg also.
 		 */
-		if (!blkiocg_del_blkio_group(&cfqg->blkg))
+		if (!cfq_blkiocg_del_blkio_group(&cfqg->blkg))
 			cfq_destroy_cfqg(cfqd, cfqg);
 	}
 }
@@ -1421,10 +1421,10 @@
 {
 	elv_rb_del(&cfqq->sort_list, rq);
 	cfqq->queued[rq_is_sync(rq)]--;
-	blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg, rq_data_dir(rq),
-						rq_is_sync(rq));
+	cfq_blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg,
+					rq_data_dir(rq), rq_is_sync(rq));
 	cfq_add_rq_rb(rq);
-	blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
+	cfq_blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
 			&cfqq->cfqd->serving_group->blkg, rq_data_dir(rq),
 			rq_is_sync(rq));
 }
@@ -1482,8 +1482,8 @@
 	cfq_del_rq_rb(rq);
 
 	cfqq->cfqd->rq_queued--;
-	blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg, rq_data_dir(rq),
-						rq_is_sync(rq));
+	cfq_blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg,
+					rq_data_dir(rq), rq_is_sync(rq));
 	if (rq_is_meta(rq)) {
 		WARN_ON(!cfqq->meta_pending);
 		cfqq->meta_pending--;
@@ -1518,8 +1518,8 @@
 static void cfq_bio_merged(struct request_queue *q, struct request *req,
 				struct bio *bio)
 {
-	blkiocg_update_io_merged_stats(&(RQ_CFQG(req))->blkg, bio_data_dir(bio),
-					cfq_bio_sync(bio));
+	cfq_blkiocg_update_io_merged_stats(&(RQ_CFQG(req))->blkg,
+					bio_data_dir(bio), cfq_bio_sync(bio));
 }
 
 static void
@@ -1539,8 +1539,8 @@
 	if (cfqq->next_rq == next)
 		cfqq->next_rq = rq;
 	cfq_remove_request(next);
-	blkiocg_update_io_merged_stats(&(RQ_CFQG(rq))->blkg, rq_data_dir(next),
-					rq_is_sync(next));
+	cfq_blkiocg_update_io_merged_stats(&(RQ_CFQG(rq))->blkg,
+					rq_data_dir(next), rq_is_sync(next));
 }
 
 static int cfq_allow_merge(struct request_queue *q, struct request *rq,
@@ -1571,7 +1571,7 @@
 static inline void cfq_del_timer(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	del_timer(&cfqd->idle_slice_timer);
-	blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
+	cfq_blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
 }
 
 static void __cfq_set_active_queue(struct cfq_data *cfqd,
@@ -1580,7 +1580,7 @@
 	if (cfqq) {
 		cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
 				cfqd->serving_prio, cfqd->serving_type);
-		blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
+		cfq_blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
 		cfqq->slice_start = 0;
 		cfqq->dispatch_start = jiffies;
 		cfqq->allocated_slice = 0;
@@ -1911,7 +1911,7 @@
 	sl = cfqd->cfq_slice_idle;
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
-	blkiocg_update_set_idle_time_stats(&cfqq->cfqg->blkg);
+	cfq_blkiocg_update_set_idle_time_stats(&cfqq->cfqg->blkg);
 	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
 }
 
@@ -1931,7 +1931,7 @@
 	elv_dispatch_sort(q, rq);
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
-	blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
+	cfq_blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
 					rq_data_dir(rq), rq_is_sync(rq));
 }
 
@@ -3248,7 +3248,7 @@
 				cfq_clear_cfqq_wait_request(cfqq);
 				__blk_run_queue(cfqd->queue);
 			} else {
-				blkiocg_update_idle_time_stats(
+				cfq_blkiocg_update_idle_time_stats(
 						&cfqq->cfqg->blkg);
 				cfq_mark_cfqq_must_dispatch(cfqq);
 			}
@@ -3276,7 +3276,7 @@
 	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
 	cfq_add_rq_rb(rq);
-	blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
+	cfq_blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
 			&cfqd->serving_group->blkg, rq_data_dir(rq),
 			rq_is_sync(rq));
 	cfq_rq_enqueued(cfqd, cfqq, rq);
@@ -3364,9 +3364,9 @@
 	WARN_ON(!cfqq->dispatched);
 	cfqd->rq_in_driver--;
 	cfqq->dispatched--;
-	blkiocg_update_completion_stats(&cfqq->cfqg->blkg, rq_start_time_ns(rq),
-			rq_io_start_time_ns(rq), rq_data_dir(rq),
-			rq_is_sync(rq));
+	cfq_blkiocg_update_completion_stats(&cfqq->cfqg->blkg,
+			rq_start_time_ns(rq), rq_io_start_time_ns(rq),
+			rq_data_dir(rq), rq_is_sync(rq));
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
@@ -3730,7 +3730,7 @@
 
 	cfq_put_async_queues(cfqd);
 	cfq_release_cfq_groups(cfqd);
-	blkiocg_del_blkio_group(&cfqd->root_group.blkg);
+	cfq_blkiocg_del_blkio_group(&cfqd->root_group.blkg);
 
 	spin_unlock_irq(q->queue_lock);
 
@@ -3798,8 +3798,8 @@
 	 */
 	atomic_set(&cfqg->ref, 1);
 	rcu_read_lock();
-	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd,
-					0);
+	cfq_blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg,
+					(void *)cfqd, 0);
 	rcu_read_unlock();
 #endif
 	/*
Index: linux-2.6/block/cfq.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/block/cfq.h	2010-06-20 18:47:29.990241567 -0400
@@ -0,0 +1,116 @@
+#ifndef _CFQ_H
+#define _CFQ_H
+#include "blk-cgroup.h"
+
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+static inline void cfq_blkiocg_update_io_add_stats(struct blkio_group *blkg,
+	struct blkio_group *curr_blkg, bool direction, bool sync)
+{
+	blkiocg_update_io_add_stats(blkg, curr_blkg, direction, sync);
+}
+
+static inline void cfq_blkiocg_update_dequeue_stats(struct blkio_group *blkg,
+			unsigned long dequeue)
+{
+	blkiocg_update_dequeue_stats(blkg, dequeue);
+}
+
+static inline void cfq_blkiocg_update_timeslice_used(struct blkio_group *blkg,
+			unsigned long time)
+{
+	blkiocg_update_timeslice_used(blkg, time);
+}
+
+static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg)
+{
+	blkiocg_set_start_empty_time(blkg);
+}
+
+static inline void cfq_blkiocg_update_io_remove_stats(struct blkio_group *blkg,
+				bool direction, bool sync)
+{
+	blkiocg_update_io_remove_stats(blkg, direction, sync);
+}
+
+static inline void cfq_blkiocg_update_io_merged_stats(struct blkio_group *blkg,
+		bool direction, bool sync)
+{
+	blkiocg_update_io_merged_stats(blkg, direction, sync);
+}
+
+static inline void cfq_blkiocg_update_idle_time_stats(struct blkio_group *blkg)
+{
+	blkiocg_update_idle_time_stats(blkg);
+}
+
+static inline void
+cfq_blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg)
+{
+	blkiocg_update_avg_queue_size_stats(blkg);
+}
+
+static inline void
+cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg)
+{
+	blkiocg_update_set_idle_time_stats(blkg);
+}
+
+static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
+				uint64_t bytes, bool direction, bool sync)
+{
+	blkiocg_update_dispatch_stats(blkg, bytes, direction, sync);
+}
+
+static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg,
+ uint64_t start_time, uint64_t io_start_time, bool direction, bool sync)
+{
+	blkiocg_update_completion_stats(blkg, start_time, io_start_time,
+				direction, sync);
+}
+
+static inline void cfq_blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
+			struct blkio_group *blkg, void *key, dev_t dev) {
+	blkiocg_add_blkio_group(blkcg, blkg, key, dev);
+}
+
+static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
+{
+	return blkiocg_del_blkio_group(blkg);
+}
+
+#else /* CFQ_GROUP_IOSCHED */
+static inline void cfq_blkiocg_update_io_add_stats(struct blkio_group *blkg,
+	struct blkio_group *curr_blkg, bool direction, bool sync) {}
+
+static inline void cfq_blkiocg_update_dequeue_stats(struct blkio_group *blkg,
+			unsigned long dequeue) {}
+
+static inline void cfq_blkiocg_update_timeslice_used(struct blkio_group *blkg,
+			unsigned long time) {}
+static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg) {}
+static inline void cfq_blkiocg_update_io_remove_stats(struct blkio_group *blkg,
+				bool direction, bool sync) {}
+static inline void cfq_blkiocg_update_io_merged_stats(struct blkio_group *blkg,
+		bool direction, bool sync) {}
+static inline void cfq_blkiocg_update_idle_time_stats(struct blkio_group *blkg)
+{
+}
+static inline void
+cfq_blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg) {}
+
+static inline void
+cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg) {}
+
+static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
+				uint64_t bytes, bool direction, bool sync) {}
+static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg, uint64_t start_time, uint64_t io_start_time, bool direction, bool sync) {}
+
+static inline void cfq_blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
+			struct blkio_group *blkg, void *key, dev_t dev) {}
+static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
+{
+	return 0;
+}
+
+#endif /* CFQ_GROUP_IOSCHED */
+#endif
