Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1B1TZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:25:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab1B1TZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:25:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com, neilb@suse.de
Subject: [PATCH 1/3] block: Initialize ->queue_lock to internal lock at queue allocation time
Date: Mon, 28 Feb 2011 14:25:28 -0500
Message-Id: <1298921130-17533-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1298921130-17533-1-git-send-email-vgoyal@redhat.com>
References: <1298921130-17533-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o There does not seem to be a clear convention whether q->queue_lock is
  initialized or not when blk_cleanup_queue() is called. In the past
  it was not necessary but now blk_throtl_exit() takes up queue lock
  by default and needs queue lock to be available.

  In fact elevator_exit() code also has similar requirement just that
  it is less stringent in the sense that elevator_exit() is called only
  if elevator is initialized.

o Two problems have been noticed because of ambiguity about spin lock
  status.

	- If a driver calls blk_alloc_queue() and then soon calls
	  blk_cleanup_queue() almost immediately, (because some other driver
	  structure allocation failed or some other error happened) then
	  blk_throtl_exit() will run into issues as queue lock is not
	  initialized. Loop driver ran into this issue recently and I noticed
	  error paths in md driver too. Similar error paths should exist in
	  other drivers too.

	- If some driver provided external spin lock and zapped the lock
	  before blk_cleanup_queue(), then it can lead to issues.

o So this patch initializes the default queue lock at queue allocation time.
  block throttling code is one of the users of queue lock and it is
  initialized at the queue allocation time, so it makes sense to
  initialize ->queue_lock also to internal lock. A driver can overide that
  lock later. This will take care of the issue where a driver does not have
  to worry about initializing the queue lock to default before calling
  blk_cleanup_queue()

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c     |   16 +++++++++++++++-
 block/blk-settings.c |    7 -------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3cc17e6..bc2b7c5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -446,6 +446,11 @@ void blk_put_queue(struct request_queue *q)
 	kobject_put(&q->kobj);
 }
 
+/*
+ * Note: If a driver supplied the queue lock, it should not zap that lock
+ * unexpectedly as some queue cleanup components like elevator_exit() and
+ * blk_throtl_exit() need queue lock.
+ */
 void blk_cleanup_queue(struct request_queue *q)
 {
 	/*
@@ -540,6 +545,12 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	mutex_init(&q->sysfs_lock);
 	spin_lock_init(&q->__queue_lock);
 
+	/*
+	 * By default initialize queue_lock to internal lock and driver can
+	 * override it later if need be.
+	 */
+	q->queue_lock = &q->__queue_lock;
+
 	return q;
 }
 EXPORT_SYMBOL(blk_alloc_queue_node);
@@ -624,7 +635,10 @@ blk_init_allocated_queue_node(struct request_queue *q, request_fn_proc *rfn,
 	q->unprep_rq_fn		= NULL;
 	q->unplug_fn		= generic_unplug_device;
 	q->queue_flags		= QUEUE_FLAG_DEFAULT;
-	q->queue_lock		= lock;
+
+	/* Override internal queue lock with supplied lock pointer */
+	if (lock)
+		q->queue_lock		= lock;
 
 	/*
 	 * This also sets hw/phys segments, boundary and size
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 36c8c1f..df649fa 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -176,13 +176,6 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	blk_queue_max_hw_sectors(q, BLK_SAFE_MAX_SECTORS);
 
 	/*
-	 * If the caller didn't supply a lock, fall back to our embedded
-	 * per-queue locks
-	 */
-	if (!q->queue_lock)
-		q->queue_lock = &q->__queue_lock;
-
-	/*
 	 * by default assume old behaviour and bounce for any highmem page
 	 */
 	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);
-- 
1.7.2.3

