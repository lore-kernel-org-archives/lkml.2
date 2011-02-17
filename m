Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab1BQQ7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:59:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab1BQQ7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:59:13 -0500
Date: Thu, 17 Feb 2011 11:59:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: Re: blk_throtl_exit  taking q->queue_lock is problematic
Message-ID: <20110217165906.GE9075@redhat.com>
References: <20110216183114.26a3613b@notabene.brown>
 <20110216155305.GC14653@redhat.com>
 <20110217113536.2bbf308e@notabene.brown>
 <20110217011029.GA6793@redhat.com>
 <20110217165501.47f3c26f@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217165501.47f3c26f@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 04:55:01PM +1100, NeilBrown wrote:
> On Wed, 16 Feb 2011 20:10:29 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > So is it possible to keep the spinlock intact when md is calling up
> > blk_cleanup_queue()?
> > 
> 
> It would be possible, yes - but messy.  I would probably end up just making
> ->queue_lock always point to __queue_lock, and then only take it at the
> places where I call 'block' code which wants to test to see if it is
> currently held (like the plugging routines).
> 
> The queue lock (and most of the request queue) is simply irrelevant for md.
> I would prefer to get away from having to touch it at all...

If queue lock is mostly irrelevant for md, then why md should provide an
external lock and not use queue's internal spin lock?

> 
> I'll see how messy it would be to stop using it completely and it can just be
> __queue_lock.
> 
> Though for me - it would be much easier if you just used __queue_lock .....

Ok, here is the simple patch which splits the queue lock and uses
throtl_lock for throttling logic. I booted and it seems to be working.

Having said that, this now introduces the possibility of races for any
services I take from request queue. I need to see if I need to take
queue lock and that makes me little uncomfortable. 

I am using kblockd_workqueue to queue throtl work. Looks like I don't
need queue lock for that. I am also using block tracing infrastructure
and my understanding is that I don't need queue lock for that as well.

So if we do this change for performance reasons, it still makes sense
but doing this change because md provided a q->queue_lock and took away that
lock without notifying block layer hence we do this change, is still not
the right reason, IMHO.

Thanks
Vivek

Yet-to-be-Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c       |    1 +
 block/blk-throttle.c   |   16 ++++++++--------
 include/linux/blkdev.h |    3 +++
 3 files changed, 12 insertions(+), 8 deletions(-)

Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2011-02-14 17:43:07.000000000 -0500
+++ linux-2.6/include/linux/blkdev.h	2011-02-17 10:08:35.400922999 -0500
@@ -320,6 +320,9 @@ struct request_queue
 	spinlock_t		__queue_lock;
 	spinlock_t		*queue_lock;
 
+	/* Throttling lock. Protectects throttling data structrues on queue */
+	spinlock_t		throtl_lock;
+
 	/*
 	 * queue kobject
 	 */
Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2011-02-16 13:07:30.000000000 -0500
+++ linux-2.6/block/blk-core.c	2011-02-17 10:09:44.236884133 -0500
@@ -547,6 +547,7 @@ struct request_queue *blk_alloc_queue_no
 
 	mutex_init(&q->sysfs_lock);
 	spin_lock_init(&q->__queue_lock);
+	spin_lock_init(&q->throtl_lock);
 
 	return q;
 }
Index: linux-2.6/block/blk-throttle.c
===================================================================
--- linux-2.6.orig/block/blk-throttle.c	2011-02-17 10:01:47.000000000 -0500
+++ linux-2.6/block/blk-throttle.c	2011-02-17 10:12:51.949128895 -0500
@@ -763,7 +763,7 @@ static int throtl_dispatch(struct reques
 	struct bio_list bio_list_on_stack;
 	struct bio *bio;
 
-	spin_lock_irq(q->queue_lock);
+	spin_lock_irq(&q->throtl_lock);
 
 	throtl_process_limit_change(td);
 
@@ -783,7 +783,7 @@ static int throtl_dispatch(struct reques
 
 	throtl_schedule_next_dispatch(td);
 out:
-	spin_unlock_irq(q->queue_lock);
+	spin_unlock_irq(&q->throtl_lock);
 
 	/*
 	 * If we dispatched some requests, unplug the queue to make sure
@@ -882,9 +882,9 @@ void throtl_unlink_blkio_group(void *key
 	unsigned long flags;
 	struct throtl_data *td = key;
 
-	spin_lock_irqsave(td->queue->queue_lock, flags);
+	spin_lock_irqsave(&td->queue->throtl_lock, flags);
 	throtl_destroy_tg(td, tg_of_blkg(blkg));
-	spin_unlock_irqrestore(td->queue->queue_lock, flags);
+	spin_unlock_irqrestore(&td->queue->throtl_lock, flags);
 }
 
 /*
@@ -991,7 +991,7 @@ int blk_throtl_bio(struct request_queue 
 		return 0;
 	}
 
-	spin_lock_irq(q->queue_lock);
+	spin_lock_irq(&q->throtl_lock);
 	tg = throtl_get_tg(td);
 
 	if (tg->nr_queued[rw]) {
@@ -1032,7 +1032,7 @@ queue_bio:
 	}
 
 out:
-	spin_unlock_irq(q->queue_lock);
+	spin_unlock_irq(&q->throtl_lock);
 	return 0;
 }
 
@@ -1093,14 +1093,14 @@ void blk_throtl_exit(struct request_queu
 
 	throtl_shutdown_timer_wq(q);
 
-	spin_lock_irq(q->queue_lock);
+	spin_lock_irq(&q->throtl_lock);
 	throtl_release_tgs(td);
 
 	/* If there are other groups */
 	if (td->nr_undestroyed_grps > 0)
 		wait = true;
 
-	spin_unlock_irq(q->queue_lock);
+	spin_unlock_irq(&q->throtl_lock);
 
 	/*
 	 * Wait for tg->blkg->key accessors to exit their grace periods.
