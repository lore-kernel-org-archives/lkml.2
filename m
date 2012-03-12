Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab2CLDOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 23:14:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41301 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2CLDNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 23:13:15 -0400
Message-Id: <20120312031305.854321433@fusionio.com>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 11:04:17 +0800
From: Shaohua Li <shli@fusionio.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
Subject: [patch 5/7] md: raid 10 supports TRIM
References: <20120312030412.375458948@fusionio.com>
Content-Disposition: inline; filename=md-raid10-discard-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes md raid 10 support TRIM.
If one disk supports discard and another not, or one has discard_zero_data and
another not, there could be inconsistent between data from such disks. But this
should not matter, discarded data is useless. This will add extra copy in rebuild
though.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid10.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

Index: linux/drivers/md/raid10.c
===================================================================
--- linux.orig/drivers/md/raid10.c	2012-03-12 10:09:42.426612652 +0800
+++ linux/drivers/md/raid10.c	2012-03-12 10:19:05.046610195 +0800
@@ -800,7 +800,12 @@ static void flush_pending_writes(struct
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
 			bio->bi_next = NULL;
-			generic_make_request(bio);
+			if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+			    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+				/* Just ignore it */
+				bio_endio(bio, 0);
+			else
+				generic_make_request(bio);
 			bio = next;
 		}
 	} else
@@ -926,6 +931,7 @@ static void make_request(struct mddev *m
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_fua = (bio->bi_rw & REQ_FUA);
+	const unsigned long do_discard = (bio->bi_rw & (REQ_DISCARD | REQ_SECURE));
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
 	int plugged;
@@ -1241,7 +1247,7 @@ retry_write:
 				   conf->mirrors[d].rdev->data_offset);
 		mbio->bi_bdev = conf->mirrors[d].rdev->bdev;
 		mbio->bi_end_io	= raid10_end_write_request;
-		mbio->bi_rw = WRITE | do_sync | do_fua;
+		mbio->bi_rw = WRITE | do_sync | do_fua | do_discard;
 		mbio->bi_private = r10_bio;
 
 		atomic_inc(&r10_bio->remaining);
@@ -1266,7 +1272,7 @@ retry_write:
 				   conf->mirrors[d].replacement->data_offset);
 		mbio->bi_bdev = conf->mirrors[d].replacement->bdev;
 		mbio->bi_end_io	= raid10_end_write_request;
-		mbio->bi_rw = WRITE | do_sync | do_fua;
+		mbio->bi_rw = WRITE | do_sync | do_fua | do_discard;
 		mbio->bi_private = r10_bio;
 
 		atomic_inc(&r10_bio->remaining);
@@ -1543,6 +1549,9 @@ static int raid10_add_disk(struct mddev
 	}
 
 	md_integrity_add_rdev(rdev, mddev);
+	if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+
 	print_conf(conf);
 	return err;
 }
@@ -3214,6 +3223,7 @@ static int run(struct mddev *mddev)
 	struct mirror_info *disk;
 	struct md_rdev *rdev;
 	sector_t size;
+	bool discard_supported = false;
 
 	/*
 	 * copy the already verified devices into our private RAID10
@@ -3234,6 +3244,7 @@ static int run(struct mddev *mddev)
 	mddev->thread = conf->thread;
 	conf->thread = NULL;
 
+	blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
 	chunk_size = mddev->chunk_sectors << 9;
 	blk_queue_io_min(mddev->queue, chunk_size);
 	if (conf->raid_disks % conf->near_copies)
@@ -3273,7 +3284,16 @@ static int run(struct mddev *mddev)
 		}
 
 		disk->head_position = 0;
+
+		if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
+			discard_supported = true;
 	}
+
+	if (discard_supported)
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+	else
+		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+
 	/* need to check that every block has at least one working mirror */
 	if (!enough(conf, -1)) {
 		printk(KERN_ERR "md/raid10:%s: not enough operational mirrors.\n",

