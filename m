Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab0EMWO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:14:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932808Ab0EMWOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:14:20 -0400
Date: Thu, 13 May 2010 18:14:04 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 3/2 v2] dm: bio-based device must not register elevator in
 sysfs
Message-ID: <20100513221404.GA17153@redhat.com>
References: <1273532139-23043-1-git-send-email-snitzer@redhat.com>
 <1273532139-23043-2-git-send-email-snitzer@redhat.com>
 <20100513043108.GB25523@redhat.com>
 <20100513050252.GC25523@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513050252.GC25523@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly clear io scheduler state from sysfs if transitioning from a
request-based table back to bio-based.  Unregister the elevator from
sysfs (removes 'iosched/') and have the 'scheduler' sysfs attribute
properly report "none" for bio-based DM.

Adjust elv_iosched_show() to return "none" if !blk_queue_stackable.
This allows the block layer to take bio-based DM into consideration.

These changes address the following (albeit obscure) corner-case:
   # dmsetup create --notable bio-based
   # echo "0 100 multipath ..." | dmsetup load bio-based
   # echo "0 100 linear ..."    | dmsetup load bio-based
   # dmsetup resume bio-based
   # ls /sys/block/dm-0/queue/
   ... iosched ...

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/elevator.c      |    2 +-
 drivers/md/dm-table.c |    1 +
 drivers/md/dm.c       |   44 ++++++++++++++++++++++++++++++++++++--------
 drivers/md/dm.h       |    1 +
 4 files changed, 39 insertions(+), 9 deletions(-)

v2 changes:
* switched to using BUG_ON in dm_{init,clear}_request_based_queue
* refined dm_clear_request_based_queue slightly
* introduced dm_bio_based_md
* cleaned up some comments

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -803,6 +803,7 @@ int dm_table_set_type(struct dm_table *t
 	if (bio_based) {
 		/* We must use this table as bio-based */
 		t->type = DM_TYPE_BIO_BASED;
+		dm_clear_request_based_queue(t->md);
 		return 0;
 	}
 
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -1445,6 +1445,11 @@ static int dm_request_based(struct mappe
 	return blk_queue_stackable(md->queue);
 }
 
+static int dm_bio_based_md(struct mapped_device *md)
+{
+	return (md->queue->request_fn) ? 0 : 1;
+}
+
 static int dm_request(struct request_queue *q, struct bio *bio)
 {
 	struct mapped_device *md = q->queuedata;
@@ -1952,19 +1957,16 @@ bad_module_get:
 }
 
 /*
- * Fully initialize the request_queue (elevator, ->request_fn, etc).
+ * Fully initialize a request-based queue (->elevator, ->request_fn, etc).
  */
 int dm_init_request_based_queue(struct mapped_device *md)
 {
 	struct request_queue *q = NULL;
+	int register_elevator = 0;
 
-	if (!md->queue)
-		return 0;
+	BUG_ON(!md->queue);
 
-	/*
-	 * Avoid re-initializing the queue (and leaking the existing
-	 * elevator) if dm_init_request_based_queue() was already used.
-	 */
+	/* Avoid re-initializing the queue if already fully initialized */
 	if (!md->queue->elevator) {
 		/* Fully initialize the queue */
 		q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
@@ -1973,9 +1975,21 @@ int dm_init_request_based_queue(struct m
 		md->queue = q;
 		md->saved_make_request_fn = md->queue->make_request_fn;
 		blk_queue_make_request(md->queue, dm_request);
-		elv_register_queue(md->queue);
+		register_elevator = 1;
+	} else if (dm_bio_based_md(md)) {
+		/*
+		 * Queue was fully initialized on behalf of a previous
+		 * request-based table load.  Table is now switching from
+		 * bio-based back to request-based, e.g.: rq -> bio -> rq
+		 */
+		md->queue->request_fn = dm_request_fn;
+		register_elevator = 1;
 	}
 
+	/* Avoid re-registering elevator if already registered */
+	if (register_elevator)
+		elv_register_queue(md->queue);
+
 	/*
 	 * Request-based dm devices cannot be stacked on top of bio-based dm
 	 * devices.  The type of this dm device has not been decided yet.
@@ -1996,6 +2010,20 @@ int dm_init_request_based_queue(struct m
 	return 1;
 }
 
+void dm_clear_request_based_queue(struct mapped_device *md)
+{
+	BUG_ON(!md->queue);
+
+	if (dm_bio_based_md(md))
+		return; /* already bio-based so return */
+
+	/* Clear ->request_fn, not used for bio-based */
+	md->queue->request_fn = NULL;
+
+	/* Unregister the request-based queue's elevator from sysfs */
+	elv_unregister_queue(md->queue);
+}
+
 static void unlock_fs(struct mapped_device *md);
 
 static void free_dev(struct mapped_device *md)
Index: linux-2.6/drivers/md/dm.h
===================================================================
--- linux-2.6.orig/drivers/md/dm.h
+++ linux-2.6/drivers/md/dm.h
@@ -114,6 +114,7 @@ struct kobject *dm_kobject(struct mapped
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj);
 
 int dm_init_request_based_queue(struct mapped_device *md);
+void dm_clear_request_based_queue(struct mapped_device *md);
 
 /*
  * Targets for linear and striped mappings
Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c
+++ linux-2.6/block/elevator.c
@@ -1086,7 +1086,7 @@ ssize_t elv_iosched_show(struct request_
 	struct elevator_type *__e;
 	int len = 0;
 
-	if (!q->elevator)
+	if (!q->elevator || !blk_queue_stackable(q))
 		return sprintf(name, "none\n");
 
 	elv = e->elevator_type;
