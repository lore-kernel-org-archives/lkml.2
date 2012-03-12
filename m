Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2CLDNx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 23:13:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53054 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2CLDNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 23:13:14 -0400
Message-Id: <20120312031305.556706935@fusionio.com>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 11:04:14 +0800
From: Shaohua Li <shli@fusionio.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
Subject: [patch 2/7] md: linear supports TRIM
References: <20120312030412.375458948@fusionio.com>
Content-Disposition: inline; filename=md-linear-discard-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes md linear support TRIM.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/linear.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux/drivers/md/linear.c
===================================================================
--- linux.orig/drivers/md/linear.c	2012-03-09 16:56:41.173790011 +0800
+++ linux/drivers/md/linear.c	2012-03-12 10:15:44.916611071 +0800
@@ -129,6 +129,7 @@ static struct linear_conf *linear_conf(s
 	struct linear_conf *conf;
 	struct md_rdev *rdev;
 	int i, cnt;
+	bool discard_supported = false;
 
 	conf = kzalloc (sizeof (*conf) + raid_disks*sizeof(struct dev_info),
 			GFP_KERNEL);
@@ -171,6 +172,8 @@ static struct linear_conf *linear_conf(s
 		conf->array_sectors += rdev->sectors;
 		cnt++;
 
+		if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
+			discard_supported = true;
 	}
 	if (cnt != raid_disks) {
 		printk(KERN_ERR "md/linear:%s: not enough drives present. Aborting!\n",
@@ -178,6 +181,11 @@ static struct linear_conf *linear_conf(s
 		goto out;
 	}
 
+	if (!discard_supported)
+		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+	else
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+
 	/*
 	 * Here we calculate the device offsets.
 	 */
@@ -319,6 +327,14 @@ static void linear_make_request(struct m
 	bio->bi_sector = bio->bi_sector - start_sector
 		+ tmp_dev->rdev->data_offset;
 	rcu_read_unlock();
+
+	if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+		!blk_queue_discard(bdev_get_queue(bio->bi_bdev)))) {
+		/* Just ignore it */
+		bio_endio(bio, 0);
+		return;
+	}
+
 	generic_make_request(bio);
 }
 

