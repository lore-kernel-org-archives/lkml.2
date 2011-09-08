Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1IHB3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 21:29:32 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54420 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab1IHB3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 21:29:30 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] Set initial disksize to some default value
Date: Thu,  8 Sep 2011 08:29:17 +0700
Message-Id: <1315445357-14338-6-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315445357-14338-1-git-send-email-ngupta@vflare.org>
References: <1315445357-14338-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we set initial disksize as 0, which forces
user to write some value to corresponding zram device's
sysfs node, before the device can be used. Now, we avoid
this step by providing some default size initially.

To change the disksize, user must:
 - Reset disk.
	Ex: echo 1 > /sys/block/zram0/reset
(NOTE: disksize is set to the default value after reset)

 - Set new disksize.
	Ex: echo $((256*1024*1024)) > /sys/block/zram0/disksize

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Reviewed-by: Jerome Marchand <jmarchan@redhat.com>
---
 drivers/staging/zram/zram_drv.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index b1c4abd..9451d07 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -599,7 +599,7 @@ void zram_reset_device(struct zram *zram)
 	/* Reset stats */
 	memset(&zram->stats, 0, sizeof(zram->stats));
 
-	zram->disksize = 0;
+	zram_set_disksize(zram, zram_default_disksize_bytes());
 	mutex_unlock(&zram->init_lock);
 }
 
@@ -615,9 +615,6 @@ int zram_init_device(struct zram *zram)
 		return 0;
 	}
 
-	if (!zram->disksize)
-		zram_set_disksize(zram, zram_default_disksize_bytes());
-
 	zram->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
 	if (!zram->compress_workmem) {
 		pr_err("Error allocating compressor working memory!\n");
@@ -717,8 +714,12 @@ static int create_device(struct zram *zram, int device_id)
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 
-	/* Actual capacity set using syfs (/sys/block/zram<id>/disksize */
-	zram_set_disksize(zram, 0);
+	/*
+	 * Set some default disksize. To set another disksize, user
+	 * must reset the device and then write a new disksize to
+	 * corresponding device's sysfs node.
+	 */
+	zram_set_disksize(zram, zram_default_disksize_bytes());
 
 	/*
 	 * To ensure that we always get PAGE_SIZE aligned
-- 
1.7.6

