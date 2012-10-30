Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab2J3OA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:00:59 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:61590 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2J3OA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:00:58 -0400
Date: Tue, 30 Oct 2012 16:58:31 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] zram: call zram_init_device() only from disksize_store()
Message-ID: <20121030135831.GD5052@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 zram: call zram_init_device() only from disksize_store()

 Call device init only when user set desksize (thus makes it possible to init device)
 and before any RW requests can happen. In that case there is no need to call zram_init_device()
 concurrently from zram_make_request().

 
 Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/staging/zram/zram_drv.c   | 18 ++++--------------
 drivers/staging/zram/zram_sysfs.c |  4 ++++
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 47f2e3a..a40ecc1 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -470,12 +470,11 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 {
 	struct zram *zram = queue->queuedata;
 
-	if (unlikely(!zram->init_done) && zram_init_device(zram))
-		goto error;
-
 	down_read(&zram->init_lock);
-	if (unlikely(!zram->init_done))
+	if (unlikely(!zram->init_done)) {
+		WARN_ON_ONCE(1);
 		goto error_unlock;
+	}
 
 	if (!valid_io_request(zram, bio)) {
 		zram_stat64_inc(zram, &zram->stats.invalid_io);
@@ -486,10 +485,8 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 	up_read(&zram->init_lock);
 
 	return;
-
 error_unlock:
 	up_read(&zram->init_lock);
-error:
 	bio_io_error(bio);
 }
 
@@ -539,12 +536,8 @@ int zram_init_device(struct zram *zram)
 	int ret;
 	size_t num_pages;
 
-	down_write(&zram->init_lock);
-
-	if (zram->init_done) {
-		up_write(&zram->init_lock);
+	if (zram->init_done)
 		return 0;
-	}
 
 	zram_set_disksize(zram, totalram_pages << PAGE_SHIFT);
 
@@ -584,8 +577,6 @@ int zram_init_device(struct zram *zram)
 	}
 
 	zram->init_done = 1;
-	up_write(&zram->init_lock);
-
 	pr_debug("Initialization done!\n");
 	return 0;
 
@@ -594,7 +585,6 @@ fail_no_table:
 	zram->disksize = 0;
 fail:
 	__zram_reset_device(zram);
-	up_write(&zram->init_lock);
 	pr_err("Initialization failed: err=%d\n", ret);
 	return ret;
 }
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index de1eacf..ae95a14 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -71,6 +71,10 @@ static ssize_t disksize_store(struct device *dev,
 
 	zram->disksize = PAGE_ALIGN(disksize);
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
+	if (zram_init_device(zram) != 0) {
+		pr_err("Zram device initialization failed\n");
+		len = -EINVAL;
+	}
 	up_write(&zram->init_lock);
 
 	return len;

