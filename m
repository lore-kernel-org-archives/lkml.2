Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab2H3WID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 18:08:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab2H3WIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 18:08:00 -0400
Date: Thu, 30 Aug 2012 18:07:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120830220745.GI27257@redhat.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120829171345.GC20312@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 10:13:45AM -0700, Kent Overstreet wrote:

[..]
> > Performance aside, punting submission to per device worker in case of deep
> > stack usage sounds cleaner solution to me.
> 
> Agreed, but performance tends to matter in the real world. And either
> way the tricky bits are going to be confined to a few functions, so I
> don't think it matters that much.
> 
> If someone wants to code up the workqueue version and test it, they're
> more than welcome...

Here is one quick and dirty proof of concept patch. It checks for stack
depth and if remaining space is less than 20% of stack size, then it
defers the bio submission to per queue worker.

Thanks
Vivek


---
 block/blk-core.c          |  171 ++++++++++++++++++++++++++++++++++------------
 block/blk-sysfs.c         |    1 
 include/linux/blk_types.h |    1 
 include/linux/blkdev.h    |    8 ++
 4 files changed, 138 insertions(+), 43 deletions(-)

Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2012-09-01 17:44:51.686485550 -0400
+++ linux-2.6/include/linux/blkdev.h	2012-09-01 18:09:58.805577658 -0400
@@ -430,6 +430,14 @@ struct request_queue {
 	/* Throttle data */
 	struct throtl_data *td;
 #endif
+
+	/*
+	 * Bio submission to queue can be deferred to a workqueue if stack
+	 * usage of submitter is high.
+	 */
+	struct bio_list         deferred_bios;
+	struct work_struct	deferred_bio_work;
+	struct workqueue_struct *deferred_bio_workqueue;
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2012-09-01 17:44:51.686485550 -0400
+++ linux-2.6/block/blk-core.c	2012-09-02 00:34:55.204091269 -0400
@@ -211,6 +211,23 @@ static void blk_delay_work(struct work_s
 	spin_unlock_irq(q->queue_lock);
 }
 
+static void blk_deferred_bio_work(struct work_struct *work)
+{
+	struct request_queue *q;
+	struct bio *bio = NULL;
+
+	q = container_of(work, struct request_queue, deferred_bio_work);
+
+	do {
+		spin_lock_irq(q->queue_lock);
+		bio = bio_list_pop(&q->deferred_bios);
+		spin_unlock_irq(q->queue_lock);
+		if (!bio)
+			break;
+		generic_make_request(bio);
+	} while (1);
+}
+
 /**
  * blk_delay_queue - restart queueing after defined interval
  * @q:		The &struct request_queue in question
@@ -289,6 +306,7 @@ void blk_sync_queue(struct request_queue
 {
 	del_timer_sync(&q->timeout);
 	cancel_delayed_work_sync(&q->delay_work);
+	cancel_work_sync(&q->deferred_bio_work);
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
@@ -351,6 +369,29 @@ void blk_put_queue(struct request_queue 
 EXPORT_SYMBOL(blk_put_queue);
 
 /**
+ * blk_drain_deferred_bios - drain deferred bios
+ * @q: request_queue to drain deferred bios for
+ *
+ * Dispatch all currently deferred bios on @q through ->make_request_fn().
+ */
+static void blk_drain_deferred_bios(struct request_queue *q)
+{
+	struct bio_list bl;
+	struct bio *bio;
+	unsigned long flags;
+
+	bio_list_init(&bl);
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	bio_list_merge(&bl, &q->deferred_bios);
+	bio_list_init(&q->deferred_bios);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	while ((bio = bio_list_pop(&bl)))
+		generic_make_request(bio);
+}
+
+/**
  * blk_drain_queue - drain requests from request_queue
  * @q: queue to drain
  * @drain_all: whether to drain all requests or only the ones w/ ELVPRIV
@@ -358,6 +399,10 @@ EXPORT_SYMBOL(blk_put_queue);
  * Drain requests from @q.  If @drain_all is set, all requests are drained.
  * If not, only ELVPRIV requests are drained.  The caller is responsible
  * for ensuring that no new requests which need to be drained are queued.
+ *
+ * Note: It does not drain bios on q->deferred_bios list.
+ * Call blk_drain_deferred_bios() if need be.
+ *
  */
 void blk_drain_queue(struct request_queue *q, bool drain_all)
 {
@@ -505,6 +550,9 @@ void blk_cleanup_queue(struct request_qu
 	spin_unlock_irq(lock);
 	mutex_unlock(&q->sysfs_lock);
 
+	/* First drain all deferred bios. */
+	blk_drain_deferred_bios(q);
+
 	/* drain all requests queued before DEAD marking */
 	blk_drain_queue(q, true);
 
@@ -614,11 +662,19 @@ struct request_queue *blk_alloc_queue_no
 	q->bypass_depth = 1;
 	__set_bit(QUEUE_FLAG_BYPASS, &q->queue_flags);
 
-	if (blkcg_init_queue(q))
+	bio_list_init(&q->deferred_bios);
+	INIT_WORK(&q->deferred_bio_work, blk_deferred_bio_work);
+	q->deferred_bio_workqueue = alloc_workqueue("kdeferbiod", WQ_MEM_RECLAIM, 0);
+	if (!q->deferred_bio_workqueue)
 		goto fail_id;
 
+	if (blkcg_init_queue(q))
+		goto fail_deferred_bio_wq;
+
 	return q;
 
+fail_deferred_bio_wq:
+	destroy_workqueue(q->deferred_bio_workqueue);
 fail_id:
 	ida_simple_remove(&blk_queue_ida, q->id);
 fail_q:
@@ -1635,8 +1691,10 @@ static inline int bio_check_eod(struct b
 	return 0;
 }
 
+
+
 static noinline_for_stack bool
-generic_make_request_checks(struct bio *bio)
+generic_make_request_checks_early(struct bio *bio)
 {
 	struct request_queue *q;
 	int nr_sectors = bio_sectors(bio);
@@ -1715,9 +1773,6 @@ generic_make_request_checks(struct bio *
 	 */
 	create_io_context(GFP_ATOMIC, q->node);
 
-	if (blk_throtl_bio(q, bio))
-		return false;	/* throttled, will be resubmitted later */
-
 	trace_block_bio_queue(q, bio);
 	return true;
 
@@ -1726,6 +1781,56 @@ end_io:
 	return false;
 }
 
+static noinline_for_stack bool
+generic_make_request_checks_late(struct bio *bio)
+{
+	struct request_queue *q;
+
+	q = bdev_get_queue(bio->bi_bdev);
+
+	/*
+	 * Various block parts want %current->io_context and lazy ioc
+	 * allocation ends up trading a lot of pain for a small amount of
+	 * memory.  Just allocate it upfront.  This may fail and block
+	 * layer knows how to live with it.
+	 */
+	create_io_context(GFP_ATOMIC, q->node);
+
+	if (blk_throtl_bio(q, bio))
+		return false;	/* throttled, will be resubmitted later */
+
+	return true;
+}
+
+static void __generic_make_request(struct bio *bio)
+{
+	struct request_queue *q;
+
+	if (!generic_make_request_checks_late(bio))
+		return;
+	q = bdev_get_queue(bio->bi_bdev);
+	q->make_request_fn(q, bio);
+}
+
+static void generic_make_request_defer_bio(struct bio *bio)
+{
+	struct request_queue *q;
+	unsigned long flags;
+
+	q = bdev_get_queue(bio->bi_bdev);
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (unlikely(blk_queue_dead(q))) {
+		spin_unlock_irqrestore(q->queue_lock, flags);
+		bio_endio(bio, -ENODEV);
+		return;
+	}
+	set_bit(BIO_DEFERRED, &bio->bi_flags);
+	bio_list_add(&q->deferred_bios, bio);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+	queue_work(q->deferred_bio_workqueue, &q->deferred_bio_work);
+}
+
 /**
  * generic_make_request - hand a buffer to its device driver for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -1752,51 +1857,31 @@ end_io:
  */
 void generic_make_request(struct bio *bio)
 {
-	struct bio_list bio_list_on_stack;
+	unsigned long sp = 0;
+	unsigned int threshold = (THREAD_SIZE * 2)/10;
 
-	if (!generic_make_request_checks(bio))
-		return;
+	BUG_ON(bio->bi_next);
 
-	/*
-	 * We only want one ->make_request_fn to be active at a time, else
-	 * stack usage with stacked devices could be a problem.  So use
-	 * current->bio_list to keep a list of requests submited by a
-	 * make_request_fn function.  current->bio_list is also used as a
-	 * flag to say if generic_make_request is currently active in this
-	 * task or not.  If it is NULL, then no make_request is active.  If
-	 * it is non-NULL, then a make_request is active, and new requests
-	 * should be added at the tail
-	 */
-	if (current->bio_list) {
-		bio_list_add(current->bio_list, bio);
+	/* Submitteing deferred bio from worker context. */
+	if (bio_flagged(bio, BIO_DEFERRED)) {
+		clear_bit(BIO_DEFERRED, &bio->bi_flags);
+		__generic_make_request(bio);
 		return;
 	}
 
-	/* following loop may be a bit non-obvious, and so deserves some
-	 * explanation.
-	 * Before entering the loop, bio->bi_next is NULL (as all callers
-	 * ensure that) so we have a list with a single bio.
-	 * We pretend that we have just taken it off a longer list, so
-	 * we assign bio_list to a pointer to the bio_list_on_stack,
-	 * thus initialising the bio_list of new bios to be
-	 * added.  ->make_request() may indeed add some more bios
-	 * through a recursive call to generic_make_request.  If it
-	 * did, we find a non-NULL value in bio_list and re-enter the loop
-	 * from the top.  In this case we really did just take the bio
-	 * of the top of the list (no pretending) and so remove it from
-	 * bio_list, and call into ->make_request() again.
-	 */
-	BUG_ON(bio->bi_next);
-	bio_list_init(&bio_list_on_stack);
-	current->bio_list = &bio_list_on_stack;
-	do {
-		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+	if (!generic_make_request_checks_early(bio))
+		return;
 
-		q->make_request_fn(q, bio);
+	/*
+	 * FIXME. Provide an arch dependent function to return left stack
+	 * space for current task. This is hack for x86_64.
+	 */
+	asm volatile("movq %%rsp,%0" : "=m"(sp));
 
-		bio = bio_list_pop(current->bio_list);
-	} while (bio);
-	current->bio_list = NULL; /* deactivate */
+	if ((sp - (unsigned long)end_of_stack(current)) < threshold)
+		generic_make_request_defer_bio(bio);
+	else
+		__generic_make_request(bio);
 }
 EXPORT_SYMBOL(generic_make_request);
 
Index: linux-2.6/block/blk-sysfs.c
===================================================================
--- linux-2.6.orig/block/blk-sysfs.c	2012-09-01 17:44:51.686485550 -0400
+++ linux-2.6/block/blk-sysfs.c	2012-09-01 18:09:58.808577661 -0400
@@ -505,6 +505,7 @@ static void blk_release_queue(struct kob
 
 	ida_simple_remove(&blk_queue_ida, q->id);
 	kmem_cache_free(blk_requestq_cachep, q);
+	destroy_workqueue(q->deferred_bio_workqueue);
 }
 
 static const struct sysfs_ops queue_sysfs_ops = {
Index: linux-2.6/include/linux/blk_types.h
===================================================================
--- linux-2.6.orig/include/linux/blk_types.h	2012-09-02 00:34:17.607086696 -0400
+++ linux-2.6/include/linux/blk_types.h	2012-09-02 00:34:21.997087104 -0400
@@ -105,6 +105,7 @@ struct bio {
 #define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	10	/* Make BIO Quiet */
 #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
+#define BIO_DEFERRED	12	/* Bio was deferred for submission by worker */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
