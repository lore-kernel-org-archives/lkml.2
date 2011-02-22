Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab1BVDyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 22:54:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab1BVDxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 22:53:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: neilb@suse.de, sergey.senozhatsky@gmail.com, tj@kernel.org,
        jmoyer@redhat.com, snitzer@redhat.com
Subject: [PATCH 3/3] block: Move blk_throtl_exit() call to blk_cleanup_queue()
Date: Mon, 21 Feb 2011 22:53:37 -0500
Message-Id: <1298346817-26144-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1298346817-26144-1-git-send-email-vgoyal@redhat.com>
References: <1298346817-26144-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

o This patch reverts above change and does not try to shutdown the
  throtl timer or throtl work in blk_sync_queue.

o blk_sync_queue() seems to be used only by md driver and it seems to be
  using it to make sure q->unplug_fn is not called as md registers its
  own unplug functions and it is about to free up the data structures
  used by unplug_fn(). Block throttle does not call back into unplug_fn()
  or into md. So there is no need to cancel blk throttle work.

  In fact I think cancelling block throttle work is bad because it might
  happen that some bios are throttled and scheduled to be dispatched later
  with the help of pending work and if work is cancelled, these bios might
  never be dispatched.

  Block layer also uses blk_sync_queue() during blk_cleanup_queue() and
  blk_release_queue() time. That should be safe as we are also calling
  blk_throtl_exit() which should make sure all the throttling related
  data structures are cleaned up.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c       |    7 ++++++-
 block/blk-sysfs.c      |    2 --
 block/blk-throttle.c   |    2 +-
 include/linux/blkdev.h |    2 --
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9a8e256..e8bf051 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -390,13 +390,16 @@ EXPORT_SYMBOL(blk_stop_queue);
  *     that its ->make_request_fn will not re-add plugging prior to calling
  *     this function.
  *
+ *     This function does not cancel any asynchronous activity arising
+ *     out of elevator or throttling code. That would require elevaotor_exit()
+ *     and blk_throtl_exit() to be called with queue lock initialized.
+ *
  */
 void blk_sync_queue(struct request_queue *q)
 {
 	del_timer_sync(&q->unplug_timer);
 	del_timer_sync(&q->timeout);
 	cancel_work_sync(&q->unplug_work);
-	throtl_shutdown_timer_wq(q);
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
@@ -482,6 +485,8 @@ void blk_cleanup_queue(struct request_queue *q)
 	if (q->elevator)
 		elevator_exit(q->elevator);
 
+	blk_throtl_exit(q);
+
 	blk_put_queue(q);
 }
 EXPORT_SYMBOL(blk_cleanup_queue);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 41fb691..261c75c 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -471,8 +471,6 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_sync_queue(q);
 
-	blk_throtl_exit(q);
-
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index bb7d21b..db41167 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -947,7 +947,7 @@ static void throtl_update_blkio_group_write_iops(void *key,
 	throtl_update_blkio_group_common(td, tg);
 }
 
-void throtl_shutdown_timer_wq(struct request_queue *q)
+static void throtl_shutdown_timer_wq(struct request_queue *q)
 {
 	struct throtl_data *td = q->td;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4d18ff3..3f6b17b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1137,7 +1137,6 @@ extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
 extern int blk_throtl_bio(struct request_queue *q, struct bio **bio);
 extern void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay);
-extern void throtl_shutdown_timer_wq(struct request_queue *q);
 #else /* CONFIG_BLK_DEV_THROTTLING */
 static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
 {
@@ -1147,7 +1146,6 @@ static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline int blk_throtl_exit(struct request_queue *q) { return 0; }
 static inline void throtl_schedule_delayed_work(struct request_queue *q, unsigned long delay) {}
-static inline void throtl_shutdown_timer_wq(struct request_queue *q) {}
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 
 #define MODULE_ALIAS_BLOCKDEV(major,minor) \
-- 
1.7.1

