Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab0HIR1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 13:27:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60296 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab0HIR1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:27:20 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Cc: Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/10] Block discard support
Date: Mon,  9 Aug 2010 22:56:52 +0530
Message-Id: <1281374816-904-7-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1281374816-904-1-git-send-email-ngupta@vflare.org>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'discard' bio discard request provides information to
zram disks regarding blocks which are no longer in use by
filesystem. This allows freeing memory allocated for such
blocks.

When zram devices are used as swap disks, we already have
a callback (block_device_operations->swap_slot_free_notify).
So, the discard support is useful only when used as generic
(non-swap) disk.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zram/zram_drv.c   |   25 +++++++++++++++++++++++++
 drivers/staging/zram/zram_sysfs.c |   11 +++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index efe9c93..0f9785f 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -420,6 +420,20 @@ out:
 	return 0;
 }
 
+static void zram_discard(struct zram *zram, struct bio *bio)
+{
+	size_t bytes = bio->bi_size;
+	sector_t sector = bio->bi_sector;
+
+	while (bytes >= PAGE_SIZE) {
+		zram_free_page(zram, sector >> SECTORS_PER_PAGE_SHIFT);
+		sector += PAGE_SIZE >> SECTOR_SHIFT;
+		bytes -= PAGE_SIZE;
+	}
+
+	bio_endio(bio, 0);
+}
+
 /*
  * Check if request is within bounds and page aligned.
  */
@@ -451,6 +465,12 @@ static int zram_make_request(struct request_queue *queue, struct bio *bio)
 		return 0;
 	}
 
+	if (unlikely(bio_rw_flagged(bio, BIO_RW_DISCARD))) {
+		zram_inc_stat(zram, ZRAM_STAT_DISCARD);
+		zram_discard(zram, bio);
+		return 0;
+	}
+
 	switch (bio_data_dir(bio)) {
 	case READ:
 		ret = zram_read(zram, bio);
@@ -606,6 +626,11 @@ static int create_device(struct zram *zram, int device_id)
 	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
 	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
 
+	zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
+	zram->disk->queue->limits.max_discard_sectors = UINT_MAX;
+	zram->disk->queue->limits.discard_zeroes_data = 1;
+	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, zram->queue);
+
 	add_disk(zram->disk);
 
 #ifdef CONFIG_SYSFS
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index 43bcdd4..74971c0 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -165,6 +165,15 @@ static ssize_t notify_free_show(struct device *dev,
 		zram_get_stat(zram, ZRAM_STAT_NOTIFY_FREE));
 }
 
+static ssize_t discard_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return sprintf(buf, "%llu\n",
+		zram_get_stat(zram, ZRAM_STAT_DISCARD));
+}
+
 static ssize_t zero_pages_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -215,6 +224,7 @@ static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
 static DEVICE_ATTR(num_writes, S_IRUGO, num_writes_show, NULL);
 static DEVICE_ATTR(invalid_io, S_IRUGO, invalid_io_show, NULL);
 static DEVICE_ATTR(notify_free, S_IRUGO, notify_free_show, NULL);
+static DEVICE_ATTR(discard, S_IRUGO, discard_show, NULL);
 static DEVICE_ATTR(zero_pages, S_IRUGO, zero_pages_show, NULL);
 static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
 static DEVICE_ATTR(compr_data_size, S_IRUGO, compr_data_size_show, NULL);
@@ -228,6 +238,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_num_writes.attr,
 	&dev_attr_invalid_io.attr,
 	&dev_attr_notify_free.attr,
+	&dev_attr_discard.attr,
 	&dev_attr_zero_pages.attr,
 	&dev_attr_orig_data_size.attr,
 	&dev_attr_compr_data_size.attr,
-- 
1.7.2.1

