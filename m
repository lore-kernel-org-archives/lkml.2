Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752Ab0FKJSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 05:18:50 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48196 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757807Ab0FKJSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 05:18:48 -0400
Message-ID: <4C11FF77.1000101@fusionio.com>
Date: Fri, 11 Jun 2010 11:18:47 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Carl Worth <cworth@cworth.org>,
       Eric Anholt <eric@anholt.net>, vgoyal@redhat.com,
       Divyesh Shah <dpshah@google.com>, guijianfeng@cn.fujitsu.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.35-rc2-git2: Reported regressions from 2.6.34
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera> <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org> <4C0F4872.7090909@fusionio.com> <20100611083249.GA11143@elte.hu> <4C11F661.3070604@fusionio.com> <20100611085520.GA20218@elte.hu>
In-Reply-To: <20100611085520.GA20218@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-11 10:55, Ingo Molnar wrote:
>>> Caused by the same blkiocg_update_io_add_stats() function. Bootlog and config 
>>> attached. Reproducible on that sha1 and with that config.
>>
>> I think I see it, the internal CFQ blkg groups are not properly
>> initialized... Will send a patch shortly.
> 
> Cool - can test it with a short turnaround, the bug is easy to reproduce.

Here's a nasty patch that should fix it. Not optimal, since we really
just want empty functions for these when cfq group scheduling is not
defined.

CC'ing the guilty parties to come up with a better patch that does NOT
involve ifdefs in cfq-iosched.c. We want blk-cgroup.[ch] fixed up.
And trimming the CC list a bit.


diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5ff4f48..7067c97 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -879,7 +879,9 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
 		cfq_rb_erase(&cfqg->rb_node, st);
 	cfqg->saved_workload_slice = 0;
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
+#endif
 }
 
 static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
@@ -939,8 +941,10 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
 					st->min_vdisktime);
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
 	blkiocg_set_start_empty_time(&cfqg->blkg);
+#endif
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
@@ -1421,12 +1425,17 @@ static void cfq_reposition_rq_rb(struct cfq_queue *cfqq, struct request *rq)
 {
 	elv_rb_del(&cfqq->sort_list, rq);
 	cfqq->queued[rq_is_sync(rq)]--;
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg, rq_data_dir(rq),
 						rq_is_sync(rq));
+#endif
 	cfq_add_rq_rb(rq);
+
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
 			&cfqq->cfqd->serving_group->blkg, rq_data_dir(rq),
 			rq_is_sync(rq));
+#endif
 }
 
 static struct request *
@@ -1482,8 +1491,10 @@ static void cfq_remove_request(struct request *rq)
 	cfq_del_rq_rb(rq);
 
 	cfqq->cfqd->rq_queued--;
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg, rq_data_dir(rq),
 						rq_is_sync(rq));
+#endif
 	if (rq_is_meta(rq)) {
 		WARN_ON(!cfqq->meta_pending);
 		cfqq->meta_pending--;
@@ -1518,8 +1529,10 @@ static void cfq_merged_request(struct request_queue *q, struct request *req,
 static void cfq_bio_merged(struct request_queue *q, struct request *req,
 				struct bio *bio)
 {
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkiocg_update_io_merged_stats(&(RQ_CFQG(req))->blkg, bio_data_dir(bio),
 					cfq_bio_sync(bio));
+#endif
 }
 
 static void
@@ -1539,8 +1552,10 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 	if (cfqq->next_rq == next)
 		cfqq->next_rq = rq;
 	cfq_remove_request(next);
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkiocg_update_io_merged_stats(&(RQ_CFQG(rq))->blkg, rq_data_dir(next),
 					rq_is_sync(next));
+#endif
 }
 
 static int cfq_allow_merge(struct request_queue *q, struct request *rq,
@@ -1571,7 +1586,9 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 static inline void cfq_del_timer(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	del_timer(&cfqd->idle_slice_timer);
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
+#endif
 }
 
 static void __cfq_set_active_queue(struct cfq_data *cfqd,
@@ -1580,7 +1597,9 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 	if (cfqq) {
 		cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
 				cfqd->serving_prio, cfqd->serving_type);
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 		blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
+#endif
 		cfqq->slice_start = 0;
 		cfqq->dispatch_start = jiffies;
 		cfqq->allocated_slice = 0;
@@ -1911,7 +1930,9 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	sl = cfqd->cfq_slice_idle;
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkiocg_update_set_idle_time_stats(&cfqq->cfqg->blkg);
+#endif
 	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
 }
 
@@ -1931,8 +1952,10 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 	elv_dispatch_sort(q, rq);
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
 					rq_data_dir(rq), rq_is_sync(rq));
+#endif
 }
 
 /*
@@ -3248,8 +3271,10 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 				cfq_clear_cfqq_wait_request(cfqq);
 				__blk_run_queue(cfqd->queue);
 			} else {
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 				blkiocg_update_idle_time_stats(
 						&cfqq->cfqg->blkg);
+#endif
 				cfq_mark_cfqq_must_dispatch(cfqq);
 			}
 		}
@@ -3276,9 +3301,11 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
 	cfq_add_rq_rb(rq);
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
 			&cfqd->serving_group->blkg, rq_data_dir(rq),
 			rq_is_sync(rq));
+#endif
 	cfq_rq_enqueued(cfqd, cfqq, rq);
 }
 
@@ -3364,9 +3391,11 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	WARN_ON(!cfqq->dispatched);
 	cfqd->rq_in_driver--;
 	cfqq->dispatched--;
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkiocg_update_completion_stats(&cfqq->cfqg->blkg, rq_start_time_ns(rq),
 			rq_io_start_time_ns(rq), rq_data_dir(rq),
 			rq_is_sync(rq));
+#endif
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
@@ -3730,7 +3759,9 @@ static void cfq_exit_queue(struct elevator_queue *e)
 
 	cfq_put_async_queues(cfqd);
 	cfq_release_cfq_groups(cfqd);
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkiocg_del_blkio_group(&cfqd->root_group.blkg);
+#endif
 
 	spin_unlock_irq(q->queue_lock);
 

-- 
Jens Axboe

