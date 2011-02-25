Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab1BYQaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:30:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab1BYQaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:30:13 -0500
Date: Fri, 25 Feb 2011 11:30:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dominik Klein <dk@in-telegence.net>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
Message-ID: <20110225163002.GH2994@redhat.com>
References: <20110224151701.GQ7840@htj.dyndns.org>
 <4D67591F.10105@in-telegence.net>
 <20110225112936.GH24828@htj.dyndns.org>
 <4D679688.7020503@in-telegence.net>
 <20110225131850.GI24828@htj.dyndns.org>
 <20110225145708.GB2994@redhat.com>
 <20110225150329.GM24828@htj.dyndns.org>
 <20110225151113.GD2994@redhat.com>
 <20110225160353.GF2994@redhat.com>
 <20110225160903.GR24828@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225160903.GR24828@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 05:09:03PM +0100, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 25, 2011 at 11:03:53AM -0500, Vivek Goyal wrote:
> > +int kthrotld_schedule_delayed_work(struct throtl_data *td,
> > +			struct delayed_work *dwork, unsigned long delay)
> > +{
> > +	return queue_delayed_work(kthrotld_workqueue, dwork, delay);
> > +}
> > +
> 
> I don't think wrapping is necessary.  Defining and using a workqueue
> directly should be enough.
> 
> > @@ -1113,6 +1120,11 @@ void blk_throtl_exit(struct request_queu
> >  
> >  static int __init throtl_init(void)
> >  {
> > +	kthrotld_workqueue = alloc_workqueue("kthrotld",
> > +				WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
> 
> And I don't think kthrotld needs to be HIGHPRI.
> 
> Thanks.

Here is the new patch.

Dominik, can you please try it and see if fixes the issue.

Thanks
Vivek

o Use a separate workqueue for throttle related work and don't reuse kblockd
  workqueue as there occurs a cycle dependency in cfq unplug work and throttle
  dispatch work.

Yet-to-be-signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c   |   27 ++++++++++++++++-----------
 include/linux/blkdev.h |    2 --
 2 files changed, 16 insertions(+), 13 deletions(-)

Index: linux-2.6/block/blk-throttle.c
===================================================================
--- linux-2.6.orig/block/blk-throttle.c	2011-02-25 11:11:49.000000000 -0500
+++ linux-2.6/block/blk-throttle.c	2011-02-25 11:21:51.709326299 -0500
@@ -20,6 +20,10 @@ static int throtl_quantum = 32;
 /* Throttling is performed over 100ms slice and after that slice is renewed */
 static unsigned long throtl_slice = HZ/10;	/* 100 ms */
 
+/* A workqueue to queue throttle related work */
+static struct workqueue_struct *kthrotld_workqueue;
+void throtl_schedule_delayed_work(struct throtl_data *td, unsigned long delay);
+
 struct throtl_rb_root {
 	struct rb_root rb;
 	struct rb_node *left;
@@ -345,10 +349,9 @@ static void throtl_schedule_next_dispatc
 	update_min_dispatch_time(st);
 
 	if (time_before_eq(st->min_disptime, jiffies))
-		throtl_schedule_delayed_work(td->queue, 0);
+		throtl_schedule_delayed_work(td, 0);
 	else
-		throtl_schedule_delayed_work(td->queue,
-				(st->min_disptime - jiffies));
+		throtl_schedule_delayed_work(td, (st->min_disptime - jiffies));
 }
 
 static inline void
@@ -815,10 +818,9 @@ void blk_throtl_work(struct work_struct 
 }
 
 /* Call with queue lock held */
-void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay)
+void throtl_schedule_delayed_work(struct throtl_data *td, unsigned long delay)
 {
 
-	struct throtl_data *td = q->td;
 	struct delayed_work *dwork = &td->throtl_work;
 
 	if (total_nr_queued(td) > 0) {
@@ -827,12 +829,11 @@ void throtl_schedule_delayed_work(struct
 		 * Cancel that and schedule a new one.
 		 */
 		__cancel_delayed_work(dwork);
-		kblockd_schedule_delayed_work(q, dwork, delay);
+		queue_delayed_work(kthrotld_workqueue, dwork, delay);
 		throtl_log(td, "schedule work. delay=%lu jiffies=%lu",
 				delay, jiffies);
 	}
 }
-EXPORT_SYMBOL(throtl_schedule_delayed_work);
 
 static void
 throtl_destroy_tg(struct throtl_data *td, struct throtl_grp *tg)
@@ -920,7 +921,7 @@ static void throtl_update_blkio_group_re
 	smp_mb__after_atomic_inc();
 
 	/* Schedule a work now to process the limit change */
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 static void throtl_update_blkio_group_write_bps(void *key,
@@ -934,7 +935,7 @@ static void throtl_update_blkio_group_wr
 	smp_mb__before_atomic_inc();
 	atomic_inc(&td->limits_changed);
 	smp_mb__after_atomic_inc();
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 static void throtl_update_blkio_group_read_iops(void *key,
@@ -948,7 +949,7 @@ static void throtl_update_blkio_group_re
 	smp_mb__before_atomic_inc();
 	atomic_inc(&td->limits_changed);
 	smp_mb__after_atomic_inc();
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 static void throtl_update_blkio_group_write_iops(void *key,
@@ -962,7 +963,7 @@ static void throtl_update_blkio_group_wr
 	smp_mb__before_atomic_inc();
 	atomic_inc(&td->limits_changed);
 	smp_mb__after_atomic_inc();
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 void throtl_shutdown_timer_wq(struct request_queue *q)
@@ -1135,6 +1136,10 @@ void blk_throtl_exit(struct request_queu
 
 static int __init throtl_init(void)
 {
+	kthrotld_workqueue = alloc_workqueue("kthrotld", WQ_MEM_RECLAIM, 0);
+	if (!kthrotld_workqueue)
+		panic("Failed to create kthrotld\n");
+
 	blkio_policy_register(&blkio_policy_throtl);
 	return 0;
 }
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2011-02-25 11:11:49.000000000 -0500
+++ linux-2.6/include/linux/blkdev.h	2011-02-25 11:13:03.670455489 -0500
@@ -1136,7 +1136,6 @@ static inline uint64_t rq_io_start_time_
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
 extern int blk_throtl_bio(struct request_queue *q, struct bio **bio);
-extern void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay);
 extern void throtl_shutdown_timer_wq(struct request_queue *q);
 #else /* CONFIG_BLK_DEV_THROTTLING */
 static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
@@ -1146,7 +1145,6 @@ static inline int blk_throtl_bio(struct 
 
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline int blk_throtl_exit(struct request_queue *q) { return 0; }
-static inline void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay) {}
 static inline void throtl_shutdown_timer_wq(struct request_queue *q) {}
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 
