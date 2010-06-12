Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab0FLObu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 10:31:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab0FLObs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 10:31:48 -0400
Date: Sat, 12 Jun 2010 10:30:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Carl Worth <cworth@cworth.org>,
       Eric Anholt <eric@anholt.net>, Divyesh Shah <dpshah@google.com>,
       "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.35-rc2-git2: Reported regressions from 2.6.34
Message-ID: <20100612143039.GA31330@redhat.com>
References: <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org>
 <4C0F4872.7090909@fusionio.com>
 <20100611083249.GA11143@elte.hu>
 <4C11F661.3070604@fusionio.com>
 <20100611085520.GA20218@elte.hu>
 <4C11FF77.1000101@fusionio.com>
 <20100611190714.GA20837@redhat.com>
 <4C128A75.3030501@fusionio.com>
 <20100611194849.GB20837@redhat.com>
 <4C129422.1010900@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C129422.1010900@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 09:53:06PM +0200, Jens Axboe wrote:
[..]
> >>> How about introducing "block/cfq.h" and declaring additional set of wrapper
> >>> functions to update blkiocg stats and make these do nothing if
> >>> CFQ_GROUP_IOSCHED=n.
> >>>
> >>> For example, in linux-2.6/block/cfq.h, we can define functions as follows.
> >>>
> >>> #ifdef CONFIG_CFQ_GROUP_IOSCHED
> >>> cfq_blkiocg_update_dequeue_stats () {
> >>> 	blkiocg_update_dequeue_stats()
> >>> }
> >>> #else
> >>> cfq_blkiocg_update_dequeue_stats () {}
> >>> #endif
> >>>
> >>> Fixing it blk-cgroup.[ch] might not be best as BLK_CGROUP is set.
> >>> Secondly, if there are other IO control policies later, they might
> >>> want to make use of BLK_CGROUP while cfq has disabled the group io 
> >>> scheduling.
> >>
> >> I already tried such a patch, but it's not exactly pretty. How about
> >> splitting blk-cgroup.c into two parts, one that is built for
> >> BLK_CGROUP and an additional one that is also built for
> >> CFQ_GROUP_SCHED? Lets try and improve on the ifdef mess, not extend
> >> it.
> > 
> > Sorry, I did not understand your suggestion. Can you please throw some more
> > light on it.
> > 
> > blk-cgroup.c does not have any cfq specific parts. So I can't split it
> > out and build part of it based on CFQ_GROUP_SCHED.
> 
> I know they are not cfq specific, but cfq is the only one that calls
> them currently. If others depend on them later on, then let that other
> blk-cgroup-iosched.o be built for them as well.

Hi Jens,

IIUC, you are suggesting that all the blkiocg interfaces used by CFQ, pull
these out in a separate file say, blk-cgroup-iosched.c and build this
file only if CFQ_GROUP_IOSCHED is enabled.

Two things come to mind.

- If CFQ_GROUP_IOSCHED=n, then nothing much is left in blk-cgroup.c. IOW, 
  what good a blkio controller interface is without blk-cgroup-iosched.c

- More importantly, when a new policy is implemented, then it will force
  building blk-cgroup-iosched.o (even if CFQ_GROUP_IOSCHED=n) and then
  we will be face the same issue that CFQ_GROUP_IOSCHED=n but CFQ is
  calling all the stat update functions and spin lock warning triggers.

  If we create two binaries, one for cfq and for new policy, say 
  blk-cgroup-cfq.o and blk-cgroup-dm-ioband.o, that is also not a very
  pleasant situation because many of the stats interface in these two
  binaries are common and we will be unnecessary creating two binary
  copies of same functions having different name.
	cfq_blkiocg_update_completion_stats()
	dm_ioband_blkiocg_update_completion_stats()

I am still trying to implement what you suggested. Breaking apart
blk-cgroup.c and blk-cgroup.h is making it ugly. In the mean time, I 
would request you to reconsider the providing another wrapper approach
by implementing the "cfq.h".

I am attaching a patch for that approach. I have done some basic compile
testing on it. I can do more testing on it in case you decide to change your
mind.

Thanks
Vivek


---
 block/cfq-iosched.c |   56 ++++++++++++-------------
 block/cfq.h         |  115 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+), 28 deletions(-)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c	2010-06-12 09:11:39.548160746 -0400
+++ linux-2.6/block/cfq-iosched.c	2010-06-12 09:16:32.364816205 -0400
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
 
@@ -3791,15 +3791,15 @@
 	/* Give preference to root group over other groups */
 	cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
 
-#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	/*
 	 * Take a reference to root group which we never drop. This is just
 	 * to make sure that cfq_put_cfqg() does not try to kfree root group
 	 */
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
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
+++ linux-2.6/block/cfq.h	2010-06-12 09:12:42.497044544 -0400
@@ -0,0 +1,115 @@
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
+static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg, uint64_t start_time, uint64_t io_start_time, bool direction, bool sync)
+{
+	cfq_blkiocg_update_completion_stats(blkg, start_time, io_start_time,
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
