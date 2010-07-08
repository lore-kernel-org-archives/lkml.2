Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab0GHWxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 18:53:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758670Ab0GHWxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 18:53:15 -0400
Date: Thu, 8 Jul 2010 18:52:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Nauman Rafique <nauman@google.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
       Divyesh Shah <dpshah@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC/RFT PATCH] cfq-iosched: Implement cfq group idling
Message-ID: <20100708225256.GB2520@redhat.com>
References: <20100707230521.GB7842@redhat.com>
 <AANLkTik9ubpcxaMe9DEjwLJBr2nyRxJDAx4fK1NidbHq@mail.gmail.com>
 <20100708131305.GB5093@redhat.com>
 <20100708153234.GG5093@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708153234.GG5093@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 11:32:34AM -0400, Vivek Goyal wrote:
> On Thu, Jul 08, 2010 at 09:13:05AM -0400, Vivek Goyal wrote:
> > On Wed, Jul 07, 2010 at 10:53:48PM -0700, Nauman Rafique wrote:
> > > If group idling is enabled, wouldn't it lower the throughput on
> > > traditional drives that handle one IO at a time?
> > 
> > I did not understand why group idling is bad for SATA disk.
> > 
> > In fact group idling will take place only if queue idling is not taking
> > place. Most of the time it will kick in only if slice_idle = 0. If
> > there are cases where we it kicks in, lets get rid of these.
> > 
> > I am wondering about the case of sync-noidle queue where queue idle will
> > not kick in if other sync-noidle queues are on the tree. I need to
> > make sure group idle also does not come into the picture. I guess I 
> > need to check for only one queue in the group condition to make sure
> > group timer is not armed. I will look into it...
> > 
> 
> I tried it but can't see it happening for various other conditions. But
> yes, theoritically for sync-noidle queues a whole existed where we did
> not idle on queue but could have idled on group.
> 
> I have put anohter check to make sure we are last queue in the group
> before we arm the group idle timer.
> 
> So now, practically there is no case where slice_idle is enabled and group
> idle timer will kick in. For async queues we will not even call arm_timer.
> For sync-idle queues we always idle. For sync-noidle queues we anyway idle
> on the last queue in the service tree.
> 
> Hence group idle will kick in only if slice_idle=0 and should not impact
> any of the slow SATA storage.
> 
> Attaching the revised version of the patch.

This version had a bug. While checking for last queue in the group
I also need to check that I am looking for group idle otherwise normal
cfq queue idle also get disabled. This new patch fixes it.

By not idling on the queues, we switch between queues across very nicely.
That way request queue gets request from multiple groups at the same
time in request queue and latencies for groups are low. Of course all
this is true only for HBA hardware RAID and sotrage arrays.

What we lose in the process is capability to measure time accurately but
I guess that is secondary thing on high end storage as long as we get
decent service differentation between groups while maintainig good
throughput.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com> 
---
 block/cfq-iosched.c |   46 ++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 40 insertions(+), 6 deletions(-)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c
+++ linux-2.6/block/cfq-iosched.c
@@ -30,6 +30,7 @@ static const int cfq_slice_sync = HZ / 1
 static int cfq_slice_async = HZ / 25;
 static const int cfq_slice_async_rq = 2;
 static int cfq_slice_idle = HZ / 125;
+static int cfq_group_idle = HZ / 125;
 static const int cfq_target_latency = HZ * 3/10; /* 300 ms */
 static const int cfq_hist_divisor = 4;
 
@@ -198,6 +199,8 @@ struct cfq_group {
 	struct hlist_node cfqd_node;
 	atomic_t ref;
 #endif
+	/* number of requests that are on the dispatch list or inside driver */
+	int dispatched;
 };
 
 /*
@@ -271,6 +274,7 @@ struct cfq_data {
 	unsigned int cfq_slice[2];
 	unsigned int cfq_slice_async_rq;
 	unsigned int cfq_slice_idle;
+	unsigned int cfq_group_idle;
 	unsigned int cfq_latency;
 	unsigned int cfq_group_isolation;
 
@@ -1838,6 +1842,9 @@ static bool cfq_should_idle(struct cfq_d
 	BUG_ON(!service_tree);
 	BUG_ON(!service_tree->count);
 
+	if (!cfqd->cfq_slice_idle)
+		return false;
+
 	/* We never do for idle class queues. */
 	if (prio == IDLE_WORKLOAD)
 		return false;
@@ -1862,7 +1869,7 @@ static void cfq_arm_slice_timer(struct c
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 	struct cfq_io_context *cic;
-	unsigned long sl;
+	unsigned long sl, group_idle = 0;
 
 	/*
 	 * SSD device without seek penalty, disable idling. But only do so
@@ -1878,8 +1885,13 @@ static void cfq_arm_slice_timer(struct c
 	/*
 	 * idle is disabled, either manually or by past process history
 	 */
-	if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq))
-		return;
+	if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq)) {
+		/* no queue idling. Check for group idling */
+		if (cfqd->cfq_group_idle)
+			group_idle = cfqd->cfq_group_idle;
+		else
+			return;
+	}
 
 	/*
 	 * still active requests from this queue, don't idle
@@ -1906,13 +1918,21 @@ static void cfq_arm_slice_timer(struct c
 		return;
 	}
 
+	/* There are other queues in the group, don't do group idle */
+	if (group_idle && cfqq->cfqg->nr_cfqq > 1)
+		return;
+	
 	cfq_mark_cfqq_wait_request(cfqq);
 
-	sl = cfqd->cfq_slice_idle;
+	if (group_idle)
+		sl = cfqd->cfq_group_idle;
+	else
+		sl = cfqd->cfq_slice_idle;
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
 	cfq_blkiocg_update_set_idle_time_stats(&cfqq->cfqg->blkg);
-	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
+	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu group_idle: %d", sl,
+			group_idle ? 1 : 0);
 }
 
 /*
@@ -1928,6 +1948,7 @@ static void cfq_dispatch_insert(struct r
 	cfqq->next_rq = cfq_find_next_rq(cfqd, cfqq, rq);
 	cfq_remove_request(rq);
 	cfqq->dispatched++;
+	(RQ_CFQG(rq))->dispatched++;
 	elv_dispatch_sort(q, rq);
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
@@ -2231,6 +2252,16 @@ static struct cfq_queue *cfq_select_queu
 		goto keep_queue;
 	}
 
+	/*
+	 * If group idle is enabled and there are requests dispatched from
+	 * this group, wait for requests to complete.
+	 */
+	if (cfqd->cfq_group_idle && cfqq->cfqg->nr_cfqq == 1
+	    && cfqq->cfqg->dispatched) {
+		cfqq = NULL;
+		goto keep_queue;
+	}
+
 expire:
 	cfq_slice_expired(cfqd, 0);
 new_queue:
@@ -3373,6 +3404,7 @@ static void cfq_completed_request(struct
 	WARN_ON(!cfqq->dispatched);
 	cfqd->rq_in_driver--;
 	cfqq->dispatched--;
+	(RQ_CFQG(rq))->dispatched--;
 	cfq_blkiocg_update_completion_stats(&cfqq->cfqg->blkg,
 			rq_start_time_ns(rq), rq_io_start_time_ns(rq),
 			rq_data_dir(rq), rq_is_sync(rq));
@@ -3847,6 +3879,7 @@ static void *cfq_init_queue(struct reque
 	cfqd->cfq_slice[1] = cfq_slice_sync;
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
+	cfqd->cfq_group_idle = cfq_group_idle;
 	cfqd->cfq_latency = 1;
 	cfqd->cfq_group_isolation = 0;
 	cfqd->hw_tag = -1;
@@ -3919,6 +3952,7 @@ SHOW_FUNCTION(cfq_fifo_expire_async_show
 SHOW_FUNCTION(cfq_back_seek_max_show, cfqd->cfq_back_max, 0);
 SHOW_FUNCTION(cfq_back_seek_penalty_show, cfqd->cfq_back_penalty, 0);
 SHOW_FUNCTION(cfq_slice_idle_show, cfqd->cfq_slice_idle, 1);
+SHOW_FUNCTION(cfq_group_idle_show, cfqd->cfq_group_idle, 1);
 SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
 SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
 SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
@@ -3951,6 +3985,7 @@ STORE_FUNCTION(cfq_back_seek_max_store, 
 STORE_FUNCTION(cfq_back_seek_penalty_store, &cfqd->cfq_back_penalty, 1,
 		UINT_MAX, 0);
 STORE_FUNCTION(cfq_slice_idle_store, &cfqd->cfq_slice_idle, 0, UINT_MAX, 1);
+STORE_FUNCTION(cfq_group_idle_store, &cfqd->cfq_group_idle, 0, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_sync_store, &cfqd->cfq_slice[1], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
@@ -3972,6 +4007,7 @@ static struct elv_fs_entry cfq_attrs[] =
 	CFQ_ATTR(slice_async),
 	CFQ_ATTR(slice_async_rq),
 	CFQ_ATTR(slice_idle),
+	CFQ_ATTR(group_idle),
 	CFQ_ATTR(low_latency),
 	CFQ_ATTR(group_isolation),
 	__ATTR_NULL
@@ -4025,6 +4061,12 @@ static int __init cfq_init(void)
 	if (!cfq_slice_idle)
 		cfq_slice_idle = 1;
 
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	if (!cfq_group_idle)
+		cfq_group_idle = 1;
+#else
+		cfq_group_idle = 0;
+#endif
 	if (cfq_slab_setup())
 		return -ENOMEM;
 
