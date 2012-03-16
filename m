Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032538Ab2CPHfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 03:35:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60840 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161213Ab2CPHfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 03:35:23 -0400
Message-Id: <20120316073512.671665097@fusionio.com>
User-Agent: quilt/0.48-1
Date: Fri, 16 Mar 2012 15:32:17 +0800
From: Shaohua Li <shli@fusionio.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, vgoyal@redhat.com,
        martin.petersen@oracle.com, Shaohua Li <shli@fusionio.com>
Subject: [patch v2 4/6] md: raid 0 supports TRIM
References: <20120316073213.656519005@fusionio.com>
Content-Disposition: inline; filename=md-raid0-discard-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes md raid 0 support TRIM.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid0.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Index: linux/drivers/md/raid0.c
===================================================================
--- linux.orig/drivers/md/raid0.c	2012-03-14 09:16:37.360435113 +0800
+++ linux/drivers/md/raid0.c	2012-03-14 09:32:11.017262138 +0800
@@ -88,6 +88,7 @@ static int create_strip_zones(struct mdd
 	char b[BDEVNAME_SIZE];
 	char b2[BDEVNAME_SIZE];
 	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
+	bool discard_supported = false;
 
 	if (!conf)
 		return -ENOMEM;
@@ -201,6 +202,9 @@ static int create_strip_zones(struct mdd
 		if (!smallest || (rdev1->sectors < smallest->sectors))
 			smallest = rdev1;
 		cnt++;
+
+		if (blk_queue_discard(bdev_get_queue(rdev1->bdev)))
+			discard_supported = true;
 	}
 	if (cnt != mddev->raid_disks) {
 		printk(KERN_ERR "md/raid0:%s: too few disks (%d of %d) - "
@@ -278,6 +282,11 @@ static int create_strip_zones(struct mdd
 	blk_queue_io_opt(mddev->queue,
 			 (mddev->chunk_sectors << 9) * mddev->raid_disks);
 
+	if (!discard_supported)
+		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+	else
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+
 	pr_debug("md/raid0:%s: done.\n", mdname(mddev));
 	*private_conf = conf;
 
@@ -348,6 +357,7 @@ static int raid0_run(struct mddev *mddev
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
+	blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
 
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
@@ -486,7 +496,7 @@ static void raid0_make_request(struct md
 		sector_t sector = bio->bi_sector;
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
-		if (bio->bi_vcnt != 1 ||
+		if ((bio->bi_vcnt != 1 && bio->bi_vcnt != 0) ||
 		    bio->bi_idx != 0)
 			goto bad_map;
 		/* This is a one page bio that upper layers
@@ -512,6 +522,13 @@ static void raid0_make_request(struct md
 	bio->bi_sector = sector_offset + zone->dev_start +
 		tmp_dev->data_offset;
 
+	if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+		!blk_queue_discard(bdev_get_queue(bio->bi_bdev)))) {
+		/* Just ignore it */
+		bio_endio(bio, 0);
+		return;
+	}
+
 	generic_make_request(bio);
 	return;
 

