Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab0EMFDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 01:03:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab0EMFDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 01:03:08 -0400
Date: Thu, 13 May 2010 01:02:53 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 3/2] dm: bio-based device must not register elevator in
 sysfs
Message-ID: <20100513050252.GC25523@redhat.com>
References: <1273532139-23043-1-git-send-email-snitzer@redhat.com>
 <1273532139-23043-2-git-send-email-snitzer@redhat.com>
 <20100513043108.GB25523@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513043108.GB25523@redhat.com>
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
 drivers/md/dm.c       |   41 ++++++++++++++++++++++++++++++++++++++---
 drivers/md/dm.h       |    1 +
 4 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 6ec9137..168112e 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -1088,7 +1088,7 @@ ssize_t elv_iosched_show(struct request_queue *q, char *name)
 	struct elevator_type *__e;
 	int len = 0;
 
-	if (!q->elevator)
+	if (!q->elevator || !blk_queue_stackable(q))
 		return sprintf(name, "none\n");
 
 	elv = e->elevator_type;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 64a8578..dec8295 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -803,6 +803,7 @@ int dm_table_set_type(struct dm_table *t)
 	if (bio_based) {
 		/* We must use this table as bio-based */
 		t->type = DM_TYPE_BIO_BASED;
+		dm_clear_request_based_queue(t->md);
 		return 0;
 	}
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b2171be..08a4745 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1957,9 +1957,9 @@ bad_module_get:
 int dm_init_request_based_queue(struct mapped_device *md)
 {
 	struct request_queue *q = NULL;
+	int register_queue = 0;
 
-	if (!md->queue)
-		return 0;
+	BUG_ON(!md->queue);
 
 	/*
 	 * Avoid re-initializing the queue (and leaking the existing
@@ -1973,9 +1973,22 @@ int dm_init_request_based_queue(struct mapped_device *md)
 		md->queue = q;
 		md->saved_make_request_fn = md->queue->make_request_fn;
 		blk_queue_make_request(md->queue, dm_request);
-		elv_register_queue(md->queue);
+		register_queue = 1;
+	} else if (!md->queue->request_fn) {
+		/*
+		 * Handle corner-case where bio-based table was cleared
+		 * and requested-based table was loaded in its place.
+		 * - re-instate the ->request_fn that was cleared
+		 *   by dm_clear_request_based_queue().
+		 * - register the queue's 'iosched/' sysfs attributes
+		 */
+		md->queue->request_fn = dm_request_fn;
+		register_queue = 1;
 	}
 
+	if (register_queue)
+		elv_register_queue(md->queue);
+
 	/*
 	 * Request-based dm devices cannot be stacked on top of bio-based dm
 	 * devices.  The type of this dm device has not been decided yet.
@@ -1996,6 +2009,28 @@ int dm_init_request_based_queue(struct mapped_device *md)
 	return 1;
 }
 
+void dm_clear_request_based_queue(struct mapped_device *md)
+{
+	BUG_ON(!md->queue);
+
+	if (!md->queue->elevator)
+		return; /* already bio-based so return */
+
+	/*
+	 * Clear ->request_fn, treat NULL as a flag to indicate a
+	 * bio-based table was loaded after a request-based table.
+	 */
+	md->queue->request_fn = NULL;
+
+	/*
+	 * Unregister the request-based queue's elevator from sysfs.
+	 * NOTE: md->queue doesn't have the QUEUE_FLAG_STACKABLE flag
+	 * set so elv_iosched_show() will report the allocated queue's
+	 * type as "none" through the 'scheduler' sysfs attribute.
+	 */
+	elv_unregister_queue(md->queue);
+}
+
 static void unlock_fs(struct mapped_device *md);
 
 static void free_dev(struct mapped_device *md)
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 489feba..95aec64 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -114,6 +114,7 @@ struct kobject *dm_kobject(struct mapped_device *md);
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj);
 
 int dm_init_request_based_queue(struct mapped_device *md);
+void dm_clear_request_based_queue(struct mapped_device *md);
 
 /*
  * Targets for linear and striped mappings
