Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2CLDOH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 23:14:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53054 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab2CLDNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 23:13:16 -0400
Message-Id: <20120312031305.730924428@fusionio.com>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 11:04:16 +0800
From: Shaohua Li <shli@fusionio.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
Subject: [patch 4/7] md: raid 1 supports TRIM
References: <20120312030412.375458948@fusionio.com>
Content-Disposition: inline; filename=md-raid1-discard-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes md raid 1 support TRIM.
If one disk supports discard and another not, or one has discard_zero_data and
another not, there could be inconsistent between data from such disks. But this
should not matter, discarded data is useless. This will add extra copy in rebuild
though.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid1.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-03-12 10:09:42.426612652 +0800
+++ linux/drivers/md/raid1.c	2012-03-12 10:16:50.276610783 +0800
@@ -673,7 +673,12 @@ static void flush_pending_writes(struct
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
@@ -835,6 +840,7 @@ static void make_request(struct mddev *m
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
+	const unsigned long do_discard = (bio->bi_rw & (REQ_DISCARD | REQ_SECURE));
 	struct md_rdev *blocked_rdev;
 	int plugged;
 	int first_clone;
@@ -1135,7 +1141,7 @@ read_again:
 				   conf->mirrors[i].rdev->data_offset);
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE | do_flush_fua | do_sync;
+		mbio->bi_rw = WRITE | do_flush_fua | do_sync | do_discard;
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
@@ -1371,6 +1377,8 @@ static int raid1_add_disk(struct mddev *
 		}
 	}
 	md_integrity_add_rdev(rdev, mddev);
+	if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
 	print_conf(conf);
 	return err;
 }
@@ -2585,6 +2593,7 @@ static int run(struct mddev *mddev)
 	struct r1conf *conf;
 	int i;
 	struct md_rdev *rdev;
+	bool discard_supported = false;
 
 	if (mddev->level != 1) {
 		printk(KERN_ERR "md/raid1:%s: raid level not set to mirroring (%d)\n",
@@ -2623,8 +2632,16 @@ static int run(struct mddev *mddev)
 			blk_queue_segment_boundary(mddev->queue,
 						   PAGE_CACHE_SIZE - 1);
 		}
+
+		if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
+			discard_supported = true;
 	}
 
+	if (discard_supported)
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+	else
+		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+
 	mddev->degraded = 0;
 	for (i=0; i < conf->raid_disks; i++)
 		if (conf->mirrors[i].rdev == NULL ||

