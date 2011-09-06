Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1IFNC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 09:02:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab1IFNCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 09:02:23 -0400
From: Jerome Marchand <jmarchan@redhat.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 1/2] staging: zram: fix zram locking
Date: Tue,  6 Sep 2011 15:02:11 +0200
Message-Id: <1315314132-8436-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently init_lock only prevents concurrent execution of zram_init_device()
and zram_reset_device() but not zram_make_request() nor sysfs store functions.

This patch changes init_lock into a rw_semaphore. A write lock is taken by
init, reset and store functions, a read lock is taken by zram_make_request().
Also, avoids to release the lock before calling __zram_reset_device() for
cleaning after a failed init, thus preventing any concurrent task to see an
inconsistent state of zram.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 drivers/staging/zram/zram_drv.c   |   46 +++++++++++++++++++++++-------------
 drivers/staging/zram/zram_drv.h   |    6 ++--
 drivers/staging/zram/zram_sysfs.c |   18 +++++++++-----
 3 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index d70ec1a..2d1c8bd 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -560,27 +560,34 @@ static int zram_make_request(struct request_queue *queue, struct bio *bio)
 {
 	struct zram *zram = queue->queuedata;
 
+	if (unlikely(!zram->init_done) && zram_init_device(zram))
+		goto error;
+
+	down_read(&zram->init_lock);
+	if (unlikely(!zram->init_done))
+		goto error_unlock;
+
 	if (!valid_io_request(zram, bio)) {
 		zram_stat64_inc(zram, &zram->stats.invalid_io);
-		bio_io_error(bio);
-		return 0;
-	}
-
-	if (unlikely(!zram->init_done) && zram_init_device(zram)) {
-		bio_io_error(bio);
-		return 0;
+		goto error_unlock;
 	}
 
 	__zram_make_request(zram, bio, bio_data_dir(bio));
+	up_read(&zram->init_lock);
 
 	return 0;
+
+error_unlock:
+	up_read(&zram->init_lock);
+error:
+	bio_io_error(bio);
+	return 0;
 }
 
-void zram_reset_device(struct zram *zram)
+void __zram_reset_device(struct zram *zram)
 {
 	size_t index;
 
-	mutex_lock(&zram->init_lock);
 	zram->init_done = 0;
 
 	/* Free various per-device buffers */
@@ -617,7 +624,13 @@ void zram_reset_device(struct zram *zram)
 	memset(&zram->stats, 0, sizeof(zram->stats));
 
 	zram->disksize = 0;
-	mutex_unlock(&zram->init_lock);
+}
+
+void zram_reset_device(struct zram *zram)
+{
+	down_write(&zram->init_lock);
+	__zram_reset_device(zram);
+	up_write(&zram->init_lock);
 }
 
 int zram_init_device(struct zram *zram)
@@ -625,10 +638,10 @@ int zram_init_device(struct zram *zram)
 	int ret;
 	size_t num_pages;
 
-	mutex_lock(&zram->init_lock);
+	down_write(&zram->init_lock);
 
 	if (zram->init_done) {
-		mutex_unlock(&zram->init_lock);
+		up_write(&zram->init_lock);
 		return 0;
 	}
 
@@ -671,15 +684,14 @@ int zram_init_device(struct zram *zram)
 	}
 
 	zram->init_done = 1;
-	mutex_unlock(&zram->init_lock);
+	up_write(&zram->init_lock);
 
 	pr_debug("Initialization done!\n");
 	return 0;
 
 fail:
-	mutex_unlock(&zram->init_lock);
-	zram_reset_device(zram);
-
+	__zram_reset_device(zram);
+	up_write(&zram->init_lock);
 	pr_err("Initialization failed: err=%d\n", ret);
 	return ret;
 }
@@ -703,7 +715,7 @@ static int create_device(struct zram *zram, int device_id)
 	int ret = 0;
 
 	init_rwsem(&zram->lock);
-	mutex_init(&zram->init_lock);
+	init_rwsem(&zram->init_lock);
 	spin_lock_init(&zram->stat64_lock);
 
 	zram->queue = blk_alloc_queue(GFP_KERNEL);
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index abe5221..3bf134d 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -112,8 +112,8 @@ struct zram {
 	struct request_queue *queue;
 	struct gendisk *disk;
 	int init_done;
-	/* Prevent concurrent execution of device init and reset */
-	struct mutex init_lock;
+	/* Prevent concurrent execution of device init, reset and R/W request */
+	struct rw_semaphore init_lock;
 	/*
 	 * This is the limit on amount of *uncompressed* worth of data
 	 * we can store in a disk.
@@ -130,6 +130,6 @@ extern struct attribute_group zram_disk_attr_group;
 #endif
 
 extern int zram_init_device(struct zram *zram);
-extern void zram_reset_device(struct zram *zram);
+extern void __zram_reset_device(struct zram *zram);
 
 #endif
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index a70cc01..43670a9 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -55,19 +55,23 @@ static ssize_t disksize_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	int ret;
+	u64 disksize;
 	struct zram *zram = dev_to_zram(dev);
 
+	ret = strict_strtoull(buf, 10, &disksize);
+	if (ret)
+		return ret;
+
+	down_write(&zram->init_lock);
 	if (zram->init_done) {
+		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
 		return -EBUSY;
 	}
 
-	ret = strict_strtoull(buf, 10, &zram->disksize);
-	if (ret)
-		return ret;
-
-	zram->disksize = PAGE_ALIGN(zram->disksize);
+	zram->disksize = PAGE_ALIGN(disksize);
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
+	up_write(&zram->init_lock);
 
 	return len;
 }
@@ -106,8 +110,10 @@ static ssize_t reset_store(struct device *dev,
 	if (bdev)
 		fsync_bdev(bdev);
 
+	down_write(&zram->init_lock);
 	if (zram->init_done)
-		zram_reset_device(zram);
+		__zram_reset_device(zram);
+	up_write(&zram->init_lock);
 
 	return len;
 }
-- 
1.7.6

