Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab1FJN3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:29:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477Ab1FJN3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:29:09 -0400
From: Jerome Marchand <jmarchan@redhat.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>, Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 4/4] Staging: zram: Replace mutex lock by a R/W semaphore
Date: Fri, 10 Jun 2011 15:28:49 +0200
Message-Id: <1307712529-9757-4-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1307712529-9757-3-git-send-email-jmarchan@redhat.com>
References: <1307712529-9757-1-git-send-email-jmarchan@redhat.com>
 <1307712529-9757-2-git-send-email-jmarchan@redhat.com>
 <1307712529-9757-3-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, nothing protects zram table from concurrent access.
For instance, ZRAM_UNCOMPRESSED bit can be cleared by zram_free_page()
called from a concurrent write between the time ZRAM_UNCOMPRESSED has
been set and the time it is tested to unmap KM_USER0 in
zram_bvec_write(). This ultimately leads to kernel panic.

Also, a read request can occurs when the page has been freed by a
running write request and before it has been updated, leading to
zero filled block being incorrectly read and "Read before write"
error message.

This patch replace the current mutex by a rw_semaphore. It extends
the protection to zram table (currently, only compression buffers are
protected) and read requests (currently, only write requests are
protected).

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 drivers/staging/zram/zram_drv.c |   25 +++++++++++++------------
 drivers/staging/zram/zram_drv.h |    4 ++--
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 54ad29d..c5fdc55 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -359,8 +359,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	    zram_test_flag(zram, index, ZRAM_ZERO))
 		zram_free_page(zram, index);
 
-	mutex_lock(&zram->lock);
-
 	user_mem = kmap_atomic(page, KM_USER0);
 
 	if (is_partial_io(bvec))
@@ -371,7 +369,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	if (page_zero_filled(uncmem)) {
 		kunmap_atomic(user_mem, KM_USER0);
-		mutex_unlock(&zram->lock);
 		if (is_partial_io(bvec))
 			kfree(uncmem);
 		zram_stat_inc(&zram->stats.pages_zero);
@@ -388,7 +385,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			kfree(uncmem);
 
 	if (unlikely(ret != LZO_E_OK)) {
-		mutex_unlock(&zram->lock);
 		pr_err("Compression failed! err=%d\n", ret);
 		goto out;
 	}
@@ -402,7 +398,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		clen = PAGE_SIZE;
 		page_store = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
 		if (unlikely(!page_store)) {
-			mutex_unlock(&zram->lock);
 			pr_info("Error allocating memory for "
 				"incompressible page: %u\n", index);
 			ret = -ENOMEM;
@@ -420,7 +415,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	if (xv_malloc(zram->mem_pool, clen + sizeof(*zheader),
 		      &zram->table[index].page, &store_offset,
 		      GFP_NOIO | __GFP_HIGHMEM)) {
-		mutex_unlock(&zram->lock);
 		pr_info("Error allocating memory for compressed "
 			"page: %u, size=%zu\n", index, clen);
 		ret = -ENOMEM;
@@ -454,8 +448,6 @@ memstore:
 	if (clen <= PAGE_SIZE / 2)
 		zram_stat_inc(&zram->stats.good_compress);
 
-	mutex_unlock(&zram->lock);
-
 	return 0;
 
 out:
@@ -467,10 +459,19 @@ out:
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 			int offset, struct bio *bio, int rw)
 {
-	if (rw == READ)
-		return zram_bvec_read(zram, bvec, index, offset, bio);
+	int ret;
 
-	return zram_bvec_write(zram, bvec, index, offset);
+	if (rw == READ) {
+		down_read(&zram->lock);
+		ret = zram_bvec_read(zram, bvec, index, offset, bio);
+		up_read(&zram->lock);
+	} else {
+		down_write(&zram->lock);
+		ret = zram_bvec_write(zram, bvec, index, offset);
+		up_write(&zram->lock);
+	}
+
+	return ret;
 }
 
 static void update_position(u32 *index, int *offset, struct bio_vec *bvec)
@@ -701,7 +702,7 @@ static int create_device(struct zram *zram, int device_id)
 {
 	int ret = 0;
 
-	mutex_init(&zram->lock);
+	init_rwsem(&zram->lock);
 	mutex_init(&zram->init_lock);
 	spin_lock_init(&zram->stat64_lock);
 
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 8acf9eb..abe5221 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -107,8 +107,8 @@ struct zram {
 	void *compress_buffer;
 	struct table *table;
 	spinlock_t stat64_lock;	/* protect 64-bit stats */
-	struct mutex lock;	/* protect compression buffers against
-				 * concurrent writes */
+	struct rw_semaphore lock; /* protect compression buffers and table
+				   * against concurrent read and writes */
 	struct request_queue *queue;
 	struct gendisk *disk;
 	int init_done;
-- 
1.6.2.5

