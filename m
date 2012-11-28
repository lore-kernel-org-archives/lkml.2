Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab2K1CgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:36:02 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:63192 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2K1Cf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:35:58 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-a6-50b57889954a
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 2/3] zram: give up lazy initialization of zram metadata
Date: Wed, 28 Nov 2012 11:35:45 +0900
Message-Id: <1354070146-18619-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354070146-18619-1-git-send-email-minchan@kernel.org>
References: <1354070146-18619-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) User of zram normally do mkfs.xxx or mkswap before using
   the zram block device(ex, normally, do it at booting time)
   It ends up allocating such metadata of zram before real usage so
   benefit of lazy initialzation would be mitigated.

2) Some user want to use zram when memory pressure is high.(ie, load zram
   dynamically, NOT booting time). It does make sense because people don't
   want to waste memory until memory pressure is high(ie, where zram is really
   helpful time). In this case, lazy initialzation could be failed easily
   because we will use GFP_NOIO instead of GFP_KERNEL for avoiding deadlock.
   So the benefit of lazy initialzation would be mitigated, too.

3) Metadata overhead is not critical and Nitin has a plan to diet it.
   4K : 12 byte(64bit machine) -> 64G : 192M so 0.3% isn't big overhead
   If insane user use such big zram device up to 20, it could consume 6% of ram
   but efficieny of zram will cover the waste.

So this patch gives up lazy initialization and instead we initialize metadata
at disksize setting time.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zram/zram_drv.c   |   19 ++++---------------
 drivers/staging/zram/zram_sysfs.c |    1 +
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index b036dcc..e04aefc 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -441,16 +441,13 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 {
 	struct zram *zram = queue->queuedata;
 
-	if (unlikely(!zram->init_done) && zram_init_device(zram))
-		goto error;
-
 	down_read(&zram->init_lock);
 	if (unlikely(!zram->init_done))
-		goto error_unlock;
+		goto error;
 
 	if (!valid_io_request(zram, bio)) {
 		zram_stat64_inc(zram, &zram->stats.invalid_io);
-		goto error_unlock;
+		goto error;
 	}
 
 	__zram_make_request(zram, bio, bio_data_dir(bio));
@@ -458,9 +455,8 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 
 	return;
 
-error_unlock:
-	up_read(&zram->init_lock);
 error:
+	up_read(&zram->init_lock);
 	bio_io_error(bio);
 }
 
@@ -509,17 +505,12 @@ void zram_reset_device(struct zram *zram)
 	up_write(&zram->init_lock);
 }
 
+/* zram->init_lock should be held */
 int zram_init_device(struct zram *zram)
 {
 	int ret;
 	size_t num_pages;
 
-	down_write(&zram->init_lock);
-	if (zram->init_done) {
-		up_write(&zram->init_lock);
-		return 0;
-	}
-
 	if (zram->disksize > 2 * (totalram_pages << PAGE_SHIFT)) {
 		pr_info(
 		"There is little point creating a zram of greater than "
@@ -568,7 +559,6 @@ int zram_init_device(struct zram *zram)
 	}
 
 	zram->init_done = 1;
-	up_write(&zram->init_lock);
 
 	pr_debug("Initialization done!\n");
 	return 0;
@@ -578,7 +568,6 @@ fail_no_table:
 	zram->disksize = 0;
 fail:
 	__zram_reset_device(zram);
-	up_write(&zram->init_lock);
 	pr_err("Initialization failed: err=%d\n", ret);
 	return ret;
 }
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index 4143af9..369db12 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -71,6 +71,7 @@ static ssize_t disksize_store(struct device *dev,
 
 	zram->disksize = PAGE_ALIGN(disksize);
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
+	zram_init_device(zram);
 	up_write(&zram->init_lock);
 
 	return len;
-- 
1.7.9.5

