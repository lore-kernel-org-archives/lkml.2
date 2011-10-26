Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab1JZBtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:49:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42275 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1JZBs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:48:58 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/13] block: misc updates to blk_get_queue()
Date: Tue, 25 Oct 2011 18:48:31 -0700
Message-Id: <1319593719-19132-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* blk_get_queue() is peculiar in that it returns 0 on success and 1 on
  failure instead of 0 / -errno or boolean.  Update it such that it
  returns %true on success and %false on failure.

* Make sure the caller checks for the return value.

* Separate out __blk_get_queue() which doesn't check whether @q is
  dead and put it in blk.h.  This will be used later.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c         |    8 ++++----
 block/blk.h              |    5 +++++
 block/bsg.c              |    4 +---
 block/genhd.c            |    2 +-
 drivers/scsi/scsi_scan.c |    2 +-
 include/linux/blkdev.h   |    2 +-
 6 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d7304d8..db936e3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -621,14 +621,14 @@ blk_init_allocated_queue_node(struct request_queue *q, request_fn_proc *rfn,
 }
 EXPORT_SYMBOL(blk_init_allocated_queue_node);
 
-int blk_get_queue(struct request_queue *q)
+bool blk_get_queue(struct request_queue *q)
 {
 	if (likely(!blk_queue_dead(q))) {
-		kobject_get(&q->kobj);
-		return 0;
+		__blk_get_queue(q);
+		return true;
 	}
 
-	return 1;
+	return false;
 }
 EXPORT_SYMBOL(blk_get_queue);
 
diff --git a/block/blk.h b/block/blk.h
index f2b36d8..676a476 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -13,6 +13,11 @@ extern struct kmem_cache *blk_requestq_cachep;
 extern struct kobj_type blk_queue_ktype;
 extern struct ida blk_queue_ida;
 
+static inline void __blk_get_queue(struct request_queue *q)
+{
+	kobject_get(&q->kobj);
+}
+
 void init_request_from_bio(struct request *req, struct bio *bio);
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
diff --git a/block/bsg.c b/block/bsg.c
index 702f131..167d586 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -769,12 +769,10 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 					 struct file *file)
 {
 	struct bsg_device *bd;
-	int ret;
 #ifdef BSG_DEBUG
 	unsigned char buf[32];
 #endif
-	ret = blk_get_queue(rq);
-	if (ret)
+	if (!blk_get_queue(rq))
 		return ERR_PTR(-ENXIO);
 
 	bd = bsg_alloc_device();
diff --git a/block/genhd.c b/block/genhd.c
index d261b73..156a4c3 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -615,7 +615,7 @@ void add_disk(struct gendisk *disk)
 	 * Take an extra ref on queue which will be put on disk_release()
 	 * so that it sticks around as long as @disk is there.
 	 */
-	WARN_ON_ONCE(blk_get_queue(disk->queue));
+	WARN_ON_ONCE(!blk_get_queue(disk->queue));
 
 	retval = sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj,
 				   "bdi");
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 44e8ca3..f8103f4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -297,7 +297,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 		kfree(sdev);
 		goto out;
 	}
-	blk_get_queue(sdev->request_queue);
+	WARN_ON_ONCE(!blk_get_queue(sdev->request_queue));
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 565a4ed..19037fb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -865,7 +865,7 @@ extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatte
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
 
-int blk_get_queue(struct request_queue *);
+bool __must_check blk_get_queue(struct request_queue *);
 struct request_queue *blk_alloc_queue(gfp_t);
 struct request_queue *blk_alloc_queue_node(gfp_t, int);
 extern void blk_put_queue(struct request_queue *);
-- 
1.7.3.1

