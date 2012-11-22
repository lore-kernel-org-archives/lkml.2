Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092Ab2KVTRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:17:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690Ab2KVTRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:17:37 -0500
Message-ID: <50AE08D4.7040602@redhat.com>
Date: Thu, 22 Nov 2012 12:13:24 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Lockdep complain for zram
References: <20121121083737.GB5121@bbox>
In-Reply-To: <20121121083737.GB5121@bbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 09:37 AM, Minchan Kim wrote:
> Hi alls,
> 
> Today, I saw below complain of lockdep.
> As a matter of fact, I knew it long time ago but forgot that.
> The reason lockdep complains is that now zram uses GFP_KERNEL
> in reclaim path(ex, __zram_make_request) :(
> I can fix it via replacing GFP_KERNEL with GFP_NOIO.
> But more big problem is vzalloc in zram_init_device which calls GFP_KERNEL.
> Of course, I can change it with __vmalloc which can receive gfp_t.
> But still we have a problem. Althoug __vmalloc can handle gfp_t, it calls
> allocation of GFP_KERNEL. That's why I sent the patch.
> https://lkml.org/lkml/2012/4/23/77
> Since then, I forgot it, saw the bug today and poped the question again.
> 
> Yes. Fundamental problem is utter crap API vmalloc.
> If we can fix it, everyone would be happy. But life isn't simple like seeing
> my thread of the patch.
> 
> So next option is to move zram_init_device into setting disksize time.
> But it makes unnecessary metadata waste until zram is used really(That's why
> Nitin move zram_init_device from disksize setting time to make_request) and
> it makes user should set the disksize before using, which are behavior change.
> 
> I would like to clean up this issue before promoting because it might change
> usage behavior.
> 
> Do you have any idea?

This is a false positive due to the memory allocation in
zram_init_device() called from zram_make_request(). It appears to
lockdep that the allocation might trigger a request on the device that
would try to take init_lock again, but in fact it doesn't. The device
is not initialized yet, even less swapped on.

The following (quickly tested) patch should prevent lockdep complain.  

Jerome

---
>From ebb3514c4ee18276da7c5ca08025991b493ac204 Mon Sep 17 00:00:00 2001
From: Jerome Marchand <jmarchan@redhat.com>
Date: Thu, 22 Nov 2012 09:07:40 +0100
Subject: [PATCH] staging: zram: Avoid lockdep warning

zram triggers a lockdep warning. The cause of it is the call to
zram_init_device() from zram_make_request(). The memory allocation in
zram_init_device() could start a memory reclaim which in turn could
cause swapout and (as it appears to lockdep) a call to
zram_make_request(). However this is a false positive: an
unititialized device can't be used as swap.
A solution is to split init_lock in two lock. One mutex that protects
init, reset and size setting and a rw_semaphore that protects requests
and reset. Thus init and request would be protected by different locks
and lockdep will be happy.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 drivers/staging/zram/zram_drv.c   |   41 +++++++++++++++++++-----------------
 drivers/staging/zram/zram_drv.h   |   16 ++++++++++---
 drivers/staging/zram/zram_sysfs.c |   20 +++++++++---------
 3 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index fb4a7c9..b3bc3c4 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -470,11 +470,11 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 {
 	struct zram *zram = queue->queuedata;
 
-	if (unlikely(!zram->init_done) && zram_init_device(zram))
+	if (unlikely(!is_initialized(zram)) && zram_init_device(zram))
 		goto error;
 
-	down_read(&zram->init_lock);
-	if (unlikely(!zram->init_done))
+	down_read(&zram->req_lock);
+	if (unlikely(!is_initialized(zram)))
 		goto error_unlock;
 
 	if (!valid_io_request(zram, bio)) {
@@ -483,12 +483,12 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 	}
 
 	__zram_make_request(zram, bio, bio_data_dir(bio));
-	up_read(&zram->init_lock);
+	up_read(&zram->req_lock);
 
 	return;
 
 error_unlock:
-	up_read(&zram->init_lock);
+	up_read(&zram->req_lock);
 error:
 	bio_io_error(bio);
 }
@@ -497,7 +497,7 @@ void __zram_reset_device(struct zram *zram)
 {
 	size_t index;
 
-	zram->init_done = 0;
+	atomic_set(&zram->init_done, 0);
 
 	/* Free various per-device buffers */
 	kfree(zram->compress_workmem);
@@ -529,9 +529,12 @@ void __zram_reset_device(struct zram *zram)
 
 void zram_reset_device(struct zram *zram)
 {
-	down_write(&zram->init_lock);
-	__zram_reset_device(zram);
-	up_write(&zram->init_lock);
+	mutex_lock(&zram->init_lock);
+	down_write(&zram->req_lock);
+	if (is_initialized(zram))
+		__zram_reset_device(zram);
+	up_write(&zram->req_lock);
+	mutex_unlock(&zram->init_lock);
 }
 
 int zram_init_device(struct zram *zram)
@@ -539,10 +542,10 @@ int zram_init_device(struct zram *zram)
 	int ret;
 	size_t num_pages;
 
-	down_write(&zram->init_lock);
+	mutex_lock(&zram->init_lock);
 
-	if (zram->init_done) {
-		up_write(&zram->init_lock);
+	if (is_initialized(zram)) {
+		mutex_unlock(&zram->init_lock);
 		return 0;
 	}
 
@@ -583,8 +586,8 @@ int zram_init_device(struct zram *zram)
 		goto fail;
 	}
 
-	zram->init_done = 1;
-	up_write(&zram->init_lock);
+	atomic_set(&zram->init_done, 1);
+	mutex_unlock(&zram->init_lock);
 
 	pr_debug("Initialization done!\n");
 	return 0;
@@ -594,7 +597,7 @@ fail_no_table:
 	zram->disksize = 0;
 fail:
 	__zram_reset_device(zram);
-	up_write(&zram->init_lock);
+	mutex_unlock(&zram->init_lock);
 	pr_err("Initialization failed: err=%d\n", ret);
 	return ret;
 }
@@ -619,7 +622,8 @@ static int create_device(struct zram *zram, int device_id)
 	int ret = 0;
 
 	init_rwsem(&zram->lock);
-	init_rwsem(&zram->init_lock);
+	mutex_init(&zram->init_lock);
+	init_rwsem(&zram->req_lock);
 	spin_lock_init(&zram->stat64_lock);
 
 	zram->queue = blk_alloc_queue(GFP_KERNEL);
@@ -672,7 +676,7 @@ static int create_device(struct zram *zram, int device_id)
 		goto out;
 	}
 
-	zram->init_done = 0;
+	atomic_set(&zram->init_done, 0);
 
 out:
 	return ret;
@@ -755,8 +759,7 @@ static void __exit zram_exit(void)
 		zram = &zram_devices[i];
 
 		destroy_device(zram);
-		if (zram->init_done)
-			zram_reset_device(zram);
+		zram_reset_device(zram);
 	}
 
 	unregister_blkdev(zram_major, "zram");
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index df2eec4..f6bcead 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -96,9 +96,12 @@ struct zram {
 				   * against concurrent read and writes */
 	struct request_queue *queue;
 	struct gendisk *disk;
-	int init_done;
-	/* Prevent concurrent execution of device init, reset and R/W request */
-	struct rw_semaphore init_lock;
+	atomic_t init_done;
+	/* Prevent concurrent execution of device init, reset and
+	 * disksize_store */
+	struct mutex init_lock;
+	/* Prevent concurent execution device reset and R/W requests */
+	struct rw_semaphore req_lock;
 	/*
 	 * This is the limit on amount of *uncompressed* worth of data
 	 * we can store in a disk.
@@ -108,6 +111,11 @@ struct zram {
 	struct zram_stats stats;
 };
 
+static inline int is_initialized(struct zram *zram)
+{
+	return atomic_read(&zram->init_done);
+}
+
 extern struct zram *zram_devices;
 unsigned int zram_get_num_devices(void);
 #ifdef CONFIG_SYSFS
@@ -115,6 +123,6 @@ extern struct attribute_group zram_disk_attr_group;
 #endif
 
 extern int zram_init_device(struct zram *zram);
-extern void __zram_reset_device(struct zram *zram);
+extern void zram_reset_device(struct zram *zram);
 
 #endif
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index de1eacf..b300881 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -62,16 +62,19 @@ static ssize_t disksize_store(struct device *dev,
 	if (!disksize)
 		return -EINVAL;
 
-	down_write(&zram->init_lock);
-	if (zram->init_done) {
-		up_write(&zram->init_lock);
+	mutex_lock(&zram->init_lock);
+	down_write(&zram->req_lock);
+	if (is_initialized(zram)) {
+		up_write(&zram->req_lock);
+		mutex_unlock(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
 		return -EBUSY;
 	}
 
 	zram->disksize = PAGE_ALIGN(disksize);
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-	up_write(&zram->init_lock);
+	up_write(&zram->req_lock);
+	mutex_unlock(&zram->init_lock);
 
 	return len;
 }
@@ -81,7 +84,7 @@ static ssize_t initstate_show(struct device *dev,
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%u\n", zram->init_done);
+	return sprintf(buf, "%u\n", atomic_read(&zram->init_done));
 }
 
 static ssize_t reset_store(struct device *dev,
@@ -110,10 +113,7 @@ static ssize_t reset_store(struct device *dev,
 	if (bdev)
 		fsync_bdev(bdev);
 
-	down_write(&zram->init_lock);
-	if (zram->init_done)
-		__zram_reset_device(zram);
-	up_write(&zram->init_lock);
+	zram_reset_device(zram);
 
 	return len;
 }
@@ -186,7 +186,7 @@ static ssize_t mem_used_total_show(struct device *dev,
 	u64 val = 0;
 	struct zram *zram = dev_to_zram(dev);
 
-	if (zram->init_done)
+	if (is_initialized(zram))
 		val = zs_get_total_size_bytes(zram->mem_pool);
 
 	return sprintf(buf, "%llu\n", val);
-- 
1.7.7.6
