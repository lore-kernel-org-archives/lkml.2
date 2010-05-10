Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab0EJXWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:22:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932780Ab0EJWzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:55:51 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 2/2] dm: only initialize full request_queue for request-based device
Date: Mon, 10 May 2010 18:55:39 -0400
Message-Id: <1273532139-23043-2-git-send-email-snitzer@redhat.com>
In-Reply-To: <1273532139-23043-1-git-send-email-snitzer@redhat.com>
References: <1273532139-23043-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert back to only allocating a minimalist request_queue structure
initially (needed for both bio and request-based DM).  Initialization of
a full request_queue (request_fn, elevator, etc) is deferred until it is
known that the DM device is request-based.

dm_init_request_based_queue is now called at the end of a request-based
DM device's table load.

Otherwise bio-based DM devices will have an elevator, request_fn, etc.
As a result bio-based DM devices had an 'iosched/' tree as well as an
'elevator' other than "none" in sysfs.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c |    5 ++++
 drivers/md/dm.c       |   52 ++++++++++++++++++++++++++++++++-----------------
 drivers/md/dm.h       |    2 +
 3 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9924ea2..64a8578 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -829,6 +829,11 @@ int dm_table_set_type(struct dm_table *t)
 		return -EINVAL;
 	}
 
+	if (!dm_init_request_based_queue(t->md)) {
+		DMWARN("Cannot initialize queue for Request-based dm");
+		return -EINVAL;
+	}
+
 	t->type = DM_TYPE_REQUEST_BASED;
 
 	return 0;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d21e128..6df7f6c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1886,22 +1886,10 @@ static struct mapped_device *alloc_dev(int minor)
 	INIT_LIST_HEAD(&md->uevent_list);
 	spin_lock_init(&md->uevent_lock);
 
-	md->queue = blk_init_queue(dm_request_fn, NULL);
+	md->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!md->queue)
 		goto bad_queue;
 
-	/*
-	 * Request-based dm devices cannot be stacked on top of bio-based dm
-	 * devices.  The type of this dm device has not been decided yet,
-	 * although we initialized the queue using blk_init_queue().
-	 * The type is decided at the first table loading time.
-	 * To prevent problematic device stacking, clear the queue flag
-	 * for request stacking support until then.
-	 *
-	 * This queue is new, so no concurrency on the queue_flags.
-	 */
-	queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
-	md->saved_make_request_fn = md->queue->make_request_fn;
 	md->queue->queuedata = md;
 	md->queue->backing_dev_info.congested_fn = dm_any_congested;
 	md->queue->backing_dev_info.congested_data = md;
@@ -1909,11 +1897,6 @@ static struct mapped_device *alloc_dev(int minor)
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
 	md->queue->unplug_fn = dm_unplug_all;
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
-	blk_queue_softirq_done(md->queue, dm_softirq_done);
-	blk_queue_prep_rq(md->queue, dm_prep_fn);
-	blk_queue_lld_busy(md->queue, dm_lld_busy);
-	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
-			  dm_rq_prepare_flush);
 
 	md->disk = alloc_disk(1);
 	if (!md->disk)
@@ -1968,6 +1951,39 @@ bad_module_get:
 	return NULL;
 }
 
+int dm_init_request_based_queue(struct mapped_device *md)
+{
+	struct request_queue *q = NULL;
+
+	q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
+	if (!q)
+		return 0;
+	md->queue = q;
+
+	/*
+	 * Request-based dm devices cannot be stacked on top of bio-based dm
+	 * devices.  The type of this dm device has not been decided yet.
+	 * The type is decided at the first table loading time.
+	 * To prevent problematic device stacking, clear the queue flag
+	 * for request stacking support until then.
+	 *
+	 * This queue is new, so no concurrency on the queue_flags.
+	 */
+	queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
+	md->saved_make_request_fn = md->queue->make_request_fn;
+
+	blk_queue_softirq_done(md->queue, dm_softirq_done);
+	blk_queue_prep_rq(md->queue, dm_prep_fn);
+	blk_queue_lld_busy(md->queue, dm_lld_busy);
+	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
+			  dm_rq_prepare_flush);
+
+	/* Register the request-based queue's elevator with sysfs */
+	elv_register_queue(md->queue);
+
+	return 1;
+}
+
 static void unlock_fs(struct mapped_device *md);
 
 static void free_dev(struct mapped_device *md)
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index bad1724..489feba 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -113,6 +113,8 @@ void dm_sysfs_exit(struct mapped_device *md);
 struct kobject *dm_kobject(struct mapped_device *md);
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj);
 
+int dm_init_request_based_queue(struct mapped_device *md);
+
 /*
  * Targets for linear and striped mappings
  */
-- 
1.6.6.1

