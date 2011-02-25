Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab1BYQEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:04:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab1BYQEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:04:04 -0500
Date: Fri, 25 Feb 2011 11:03:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dominik Klein <dk@in-telegence.net>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com, Tejun Heo <tj@kernel.org>
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
Message-ID: <20110225160353.GF2994@redhat.com>
References: <20110224143105.GL7840@htj.dyndns.org>
 <4D66720E.70102@in-telegence.net>
 <20110224151701.GQ7840@htj.dyndns.org>
 <4D67591F.10105@in-telegence.net>
 <20110225112936.GH24828@htj.dyndns.org>
 <4D679688.7020503@in-telegence.net>
 <20110225131850.GI24828@htj.dyndns.org>
 <20110225145708.GB2994@redhat.com>
 <20110225150329.GM24828@htj.dyndns.org>
 <20110225151113.GD2994@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225151113.GD2994@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 10:11:13AM -0500, Vivek Goyal wrote:
> On Fri, Feb 25, 2011 at 04:03:29PM +0100, Tejun Heo wrote:
> > Hello,
> > 
> > On Fri, Feb 25, 2011 at 09:57:08AM -0500, Vivek Goyal wrote:
> > > blk_throtl_work() calls generic_make_request() to dispatch some bios and I
> > > guess blk_throtl_work() has been put to sleep because threre are no request
> > > descriptors available and CFQ is frozen so no requests descriptors get freed
> > > hence blk_throtl_work() never finishes.
> > > 
> > > Following caught my eye.
> > > 
> > >      ksoftirqd/0-3     [000]  1640.983585:   8,16   m   N cfq4810 slice
> > > expired t=0
> > >      ksoftirqd/0-3     [000]  1640.983588:   8,16   m   N cfq4810
> > > sl_used=2 disp=6 charge=2 iops=0 sect=2080
> > >      ksoftirqd/0-3     [000]  1640.983589:   8,16   m   N cfq4810
> > > del_from_rr
> > >      ksoftirqd/0-3     [000]  1640.983591:   8,16   m   N cfq schedule
> > > dispatch
> > >             sshd-3125  [004]  1640.983597: workqueue_queue_work: work
> > > struct=ffff88102c3a3110 function=flush_to_ldisc workqueue=ffff88182c834a00
> > > req_cpu=4 cpu=4
> > >             sshd-3125  [004]  1640.983598: workqueue_activate_work: work
> > > struct ffff88102c3a3110
> > > 
> > > CFQ tries to schedule a work and but there is no associated
> > > "workqueue_queue_work" trace. So it looks like that work never got queued.
> > > 
> > > CFQ calls following.
> > > 
> > > cfq_log(cfqd, "schedule dispatch");
> > > kblockd_schedule_work(cfqd->queue, &cfqd->unplug_work);
> > > 
> > > We do see "schedule dispatch" message and kblockd_schedule_work() calls
> > > queue_work(). So what happended here? This is strange. I will put one
> > > more trace after kblockd_schedule_work() to trace that function returned.
> > 
> > It could be that the unplug work was already queued and in pending
> > state.  The second queueing request will be ignored then.  So, I think
> > the problem is that blk_throtl_work() occupies kblockd but requires
> > another work item (unplug_work) to make forward progress.  In such
> > cases, forward progress cannot be guaranteed.  Either
> > blk_throtl_work() or cfq unplug work should use a separate workqueue.
> 
> Ok, that would make sense. So blk_throtl_work() can not finish as CFQ
> is not making progress and no request descriptors are being freed and
> unplug_work() is not being called because blk_throtl_work() has not finished.
> So that's cyclic dependency and I should use a separate work queue for
> queueing throttle related work. I will write a patch.
> 

Hi Dominik,

Can you please try attached patch and see if fixes the issue.

Thanks
Vivek

o Use a separate workqueue for throttle related work and don't reuse kblockd
  workqueue as there occurs a cycle dependency in cfq unplug work and throttle
  dispatch work.

Yet-to-be-signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c   |   28 ++++++++++++++++++++--------
 include/linux/blkdev.h |    2 --
 2 files changed, 20 insertions(+), 10 deletions(-)

Index: linux-2.6/block/blk-throttle.c
===================================================================
--- linux-2.6.orig/block/blk-throttle.c	2011-02-21 22:30:39.000000000 -0500
+++ linux-2.6/block/blk-throttle.c	2011-02-25 10:53:51.884672758 -0500
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
@@ -146,6 +150,12 @@ static inline struct throtl_grp *throtl_
 	return tg;
 }
 
+int kthrotld_schedule_delayed_work(struct throtl_data *td,
+			struct delayed_work *dwork, unsigned long delay)
+{
+	return queue_delayed_work(kthrotld_workqueue, dwork, delay);
+}
+
 static void throtl_put_tg(struct throtl_grp *tg)
 {
 	BUG_ON(atomic_read(&tg->ref) <= 0);
@@ -346,10 +356,9 @@ static void throtl_schedule_next_dispatc
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
@@ -809,10 +818,9 @@ void blk_throtl_work(struct work_struct 
 }
 
 /* Call with queue lock held */
-void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay)
+void throtl_schedule_delayed_work(struct throtl_data *td, unsigned long delay)
 {
 
-	struct throtl_data *td = q->td;
 	struct delayed_work *dwork = &td->throtl_work;
 
 	if (total_nr_queued(td) > 0) {
@@ -821,12 +829,11 @@ void throtl_schedule_delayed_work(struct
 		 * Cancel that and schedule a new one.
 		 */
 		__cancel_delayed_work(dwork);
-		kblockd_schedule_delayed_work(q, dwork, delay);
+		kthrotld_schedule_delayed_work(td, dwork, delay);
 		throtl_log(td, "schedule work. delay=%lu jiffies=%lu",
 				delay, jiffies);
 	}
 }
-EXPORT_SYMBOL(throtl_schedule_delayed_work);
 
 static void
 throtl_destroy_tg(struct throtl_data *td, struct throtl_grp *tg)
@@ -895,7 +902,7 @@ static void throtl_update_blkio_group_co
 	xchg(&tg->limits_changed, true);
 	xchg(&td->limits_changed, true);
 	/* Schedule a work now to process the limit change */
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 /*
@@ -1113,6 +1120,11 @@ void blk_throtl_exit(struct request_queu
 
 static int __init throtl_init(void)
 {
+	kthrotld_workqueue = alloc_workqueue("kthrotld",
+				WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
+	if (!kthrotld_workqueue)
+		panic("Failed to create kthrotld\n");
+
 	blkio_policy_register(&blkio_policy_throtl);
 	return 0;
 }
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2011-02-21 22:30:39.000000000 -0500
+++ linux-2.6/include/linux/blkdev.h	2011-02-25 10:50:50.706137004 -0500
@@ -1136,7 +1136,6 @@ static inline uint64_t rq_io_start_time_
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
 extern int blk_throtl_bio(struct request_queue *q, struct bio **bio);
-extern void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay);
 #else /* CONFIG_BLK_DEV_THROTTLING */
 static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
 {
@@ -1145,7 +1144,6 @@ static inline int blk_throtl_bio(struct 
 
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline int blk_throtl_exit(struct request_queue *q) { return 0; }
-static inline void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay) {}
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 
 #define MODULE_ALIAS_BLOCKDEV(major,minor) \
