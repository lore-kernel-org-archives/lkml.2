Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab1HXBfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:35:15 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61219 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab1HXBfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:35:06 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] Simplify zram disk resizing interface
Date: Wed, 24 Aug 2011 08:34:49 +0700
Message-Id: <1314149690-3177-4-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314149690-3177-1-git-send-email-ngupta@vflare.org>
References: <1314149690-3177-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove unnecessary messages.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zram/zram_drv.c |   42 +++++++++++---------------------------
 drivers/staging/zram/zram_drv.h |    2 +-
 2 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 81d6c43..d7fb207 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -104,33 +104,16 @@ static int page_zero_filled(void *ptr)
 	return 1;
 }
 
-static void zram_set_disksize(struct zram *zram, size_t totalram_bytes)
+static u64 zram_default_disksize_bytes(void)
 {
-	if (!zram->disksize) {
-		pr_info(
-		"disk size not provided. You can use disksize_kb module "
-		"param to specify size.\nUsing default: (%u%% of RAM).\n",
-		default_disksize_perc_ram
-		);
-		zram->disksize = default_disksize_perc_ram *
-					(totalram_bytes / 100);
-	}
-
-	if (zram->disksize > 2 * (totalram_bytes)) {
-		pr_info(
-		"There is little point creating a zram of greater than "
-		"twice the size of memory since we expect a 2:1 compression "
-		"ratio. Note that zram uses about 0.1%% of the size of "
-		"the disk when not in use so a huge zram is "
-		"wasteful.\n"
-		"\tMemory Size: %zu kB\n"
-		"\tSize you selected: %llu kB\n"
-		"Continuing anyway ...\n",
-		totalram_bytes >> 10, zram->disksize
-		);
-	}
-
-	zram->disksize &= PAGE_MASK;
+	return ((totalram_pages << PAGE_SHIFT) *
+		default_disksize_perc_ram / 100) & PAGE_MASK;
+}
+
+static void zram_set_disksize(struct zram *zram, u64 size_bytes)
+{
+	zram->disksize = size_bytes;
+	set_capacity(zram->disk, size_bytes >> SECTOR_SHIFT);
 }
 
 static void zram_free_page(struct zram *zram, size_t index)
@@ -632,7 +615,8 @@ int zram_init_device(struct zram *zram)
 		return 0;
 	}
 
-	zram_set_disksize(zram, totalram_pages << PAGE_SHIFT);
+	if (!zram->disksize)
+		zram_set_disksize(zram, zram_default_disksize_bytes());
 
 	zram->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
 	if (!zram->compress_workmem) {
@@ -658,8 +642,6 @@ int zram_init_device(struct zram *zram)
 		goto fail;
 	}
 
-	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-
 	/* zram devices sort of resembles non-rotational disks */
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
 
@@ -735,7 +717,7 @@ static int create_device(struct zram *zram, int device_id)
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 
 	/* Actual capacity set using syfs (/sys/block/zram<id>/disksize */
-	set_capacity(zram->disk, 0);
+	zram_set_disksize(zram, 0);
 
 	/*
 	 * To ensure that we always get PAGE_SIZE aligned
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 59b01d6..83e774c 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -47,7 +47,7 @@ static const unsigned default_disksize_perc_ram = 25;
  * Pages that compress to size greater than this are stored
  * uncompressed in memory.
  */
-static const unsigned max_zpage_size = PAGE_SIZE / 4 * 3;
+static const u64 max_zpage_size = PAGE_SIZE / 4 * 3;
 
 /*
  * NOTE: max_zpage_size must be less than or equal to:
-- 
1.7.6

