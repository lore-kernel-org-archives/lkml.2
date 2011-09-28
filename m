Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab1I1Wuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:50:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933566Ab1I1Wus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:50:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:51 2011
Message-Id: <20110928220151.100485943@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [244/244] block: Free queue resources at blk_release_queue()
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 777eb1bf15b8532c396821774bf6451e563438f5 upstream.

A kernel crash is observed when a mounted ext3/ext4 filesystem is
physically removed. The problem is that blk_cleanup_queue() frees up
some resources eg by calling elevator_exit(), which are not checked for
in normal operation. So we should rather move these calls to the
destructor function blk_release_queue() as at that point all remaining
references are gone. However, in doing so we have to ensure that any
externally supplied queue_lock is disconnected as the driver might free
up the lock after the call of blk_cleanup_queue(),

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-core.c  |   13 ++++++-------
 block/blk-sysfs.c |    5 +++++
 2 files changed, 11 insertions(+), 7 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -348,9 +348,10 @@ void blk_put_queue(struct request_queue
 EXPORT_SYMBOL(blk_put_queue);
 
 /*
- * Note: If a driver supplied the queue lock, it should not zap that lock
- * unexpectedly as some queue cleanup components like elevator_exit() and
- * blk_throtl_exit() need queue lock.
+ * Note: If a driver supplied the queue lock, it is disconnected
+ * by this function. The actual state of the lock doesn't matter
+ * here as the request_queue isn't accessible after this point
+ * (QUEUE_FLAG_DEAD is set) and no other requests will be queued.
  */
 void blk_cleanup_queue(struct request_queue *q)
 {
@@ -367,10 +368,8 @@ void blk_cleanup_queue(struct request_qu
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
 
-	if (q->elevator)
-		elevator_exit(q->elevator);
-
-	blk_throtl_exit(q);
+	if (q->queue_lock != &q->__queue_lock)
+		q->queue_lock = &q->__queue_lock;
 
 	blk_put_queue(q);
 }
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -472,6 +472,11 @@ static void blk_release_queue(struct kob
 
 	blk_sync_queue(q);
 
+	if (q->elevator)
+		elevator_exit(q->elevator);
+
+	blk_throtl_exit(q);
+
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
 


