Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1BPPxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:53:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab1BPPxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:53:09 -0500
Date: Wed, 16 Feb 2011 10:53:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: Re: blk_throtl_exit  taking q->queue_lock is problematic
Message-ID: <20110216155305.GC14653@redhat.com>
References: <20110216183114.26a3613b@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216183114.26a3613b@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 06:31:14PM +1100, NeilBrown wrote:
> 
> 
> Hi,
> 
>  I recently discovered that blk_throtl_exit takes ->queue_lock when a blockdev
> is finally released.
> 
> This is a problem for because by that time the queue_lock doesn't exist any
> more.  It is in a separate data structure controlled by the RAID personality
> and by the time that the block device is being destroyed the raid personality
> has shutdown and the data structure containing the lock has been freed.
> 
> This has not been a problem before.  Nothing else takes queue_lock after
> blk_cleanup_queue.

I agree that this is a problem. blk_throtl_exit() needs queue lock to
avoid other races with cgroup code and for avoiding races for its
lists etc.

> 
> I could of course set queue_lock to point to __queue_lock and initialise that,
> but it seems untidy and probably violates some locking requirements.
> 
> Is there some way you could use some other lock - maybe a global lock, or
> maybe used __queue_lock directly ???

Initially I had put blk_throtl_exit() in blk_cleanup_queue() where it is
known that ->queue_lock is still around. Due to a bug, Jens moved it
to blk_release_queue(). I still think that blk_cleanup_queue() is a better
place to call blk_throtl_exit().

I think following patch should solve the issue. This patch is also not
completely race free. I was thinking that can we get rid of
throtl_shutdown_timer_wq() call in blk_sync_queue(). IOW, in what
circumstances blk_sync_queue() is used.

Thanks
Vivek


o Move blk_throtl_exit() in blk_cleanup_queue() as blk_throtl_exit() is
  written in such a way that it needs queue lock. In blk_release_queue()
  there is no gurantee that ->queue_lock is still around.

o Initially blk_throtl_exit() was in blk_cleanup_queue() but Ingo reported
  one problem.

  https://lkml.org/lkml/2010/10/23/86

  And a quick fix moved blk_throtl_exit() to blk_release_queue().

	commit 7ad58c028652753814054f4e3ac58f925e7343f4
	Author: Jens Axboe <jaxboe@fusionio.com>
	Date:   Sat Oct 23 20:40:26 2010 +0200

    	block: fix use-after-free bug in blk throttle code

o This patch reverts above change and instead checks for q->td in
  throtl_shutdown_timer_wq(). 

o This is also not completely race free as check for q->td is without
  spinlock and we can't take spinlock here as it is called from
  blk_release_queue->blk_sync_queue() where ->queue_lock might have gone
  away.

o So the question is should we really call throtl_shutdown_timer_wq() from
  blk_sync_queue(). It might not make much sense because there might
  be queued bios in throttling logic. The only way to cleanup all bios
  and cancel all async activity is blk_throtl_exit(). 

  I also don't see it being called to cancel async activity for CFQ. Who
  makes sure that async activity is cancelled. IOW, I am wondering in
  what circumstances blk_sync_queue() is called and is it required to
  call throtl_shutdown_timer_wq() from blk_sync_queue(). If we can get
  rid of it, then we have taken care of all the races, AFAIK.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c     |    2 ++
 block/blk-sysfs.c    |    2 --
 block/blk-throttle.c |    6 ++++++
 3 files changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2011-02-14 17:43:06.000000000 -0500
+++ linux-2.6/block/blk-core.c	2011-02-16 10:11:58.910022185 -0500
@@ -474,6 +474,8 @@ void blk_cleanup_queue(struct request_qu
 	if (q->elevator)
 		elevator_exit(q->elevator);
 
+	blk_throtl_exit(q);
+
 	blk_put_queue(q);
 }
 EXPORT_SYMBOL(blk_cleanup_queue);
Index: linux-2.6/block/blk-sysfs.c
===================================================================
--- linux-2.6.orig/block/blk-sysfs.c	2011-02-11 09:25:16.000000000 -0500
+++ linux-2.6/block/blk-sysfs.c	2011-02-16 10:12:16.379762988 -0500
@@ -471,8 +471,6 @@ static void blk_release_queue(struct kob
 
 	blk_sync_queue(q);
 
-	blk_throtl_exit(q);
-
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
 
Index: linux-2.6/block/blk-throttle.c
===================================================================
--- linux-2.6.orig/block/blk-throttle.c	2011-02-16 10:08:12.000000000 -0500
+++ linux-2.6/block/blk-throttle.c	2011-02-16 10:45:18.006119406 -0500
@@ -961,6 +961,9 @@ void throtl_shutdown_timer_wq(struct req
 {
 	struct throtl_data *td = q->td;
 
+	if (!td)
+		return;
+
 	cancel_delayed_work_sync(&td->throtl_work);
 }
 
@@ -1122,6 +1125,9 @@ void blk_throtl_exit(struct request_queu
 	 * it.
 	 */
 	throtl_shutdown_timer_wq(q);
+
+	/* Decouple throtl data from queue. */
+	q->td = NULL;
 	throtl_td_free(td);
 }
 
