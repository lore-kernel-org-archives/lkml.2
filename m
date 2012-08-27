Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2H0X5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:57:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55625 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab2H0X5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:57:16 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] genhd: Make put_disk() safe for disks that have not been registered
Date: Mon, 27 Aug 2012 20:56:53 -0300
Message-Id: <1346111816-16700-4-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346111816-16700-1-git-send-email-herton.krzesinski@canonical.com>
References: <1346111816-16700-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

Since commit 523e1d3 ('block: make gendisk hold a reference to its
queue'), add_disk() adds a reference to disk->queue, which is then
dropped by disk_release().  But if a disk is destroyed without being
registered through add_disk() (or if add_disk() fails at the first
hurdle) then we have a reference imbalance.

Use the GENHD_FL_UP flag to tell whether this extra reference has been
added.  Remove the incomplete workaround from the floppy driver.

Cc: stable@vger.kernel.org
Acked-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/genhd.c          |    6 +++---
 drivers/block/floppy.c |   16 +---------------
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index d839723..633751d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -587,8 +587,6 @@ void add_disk(struct gendisk *disk)
 	WARN_ON(disk->minors && !(disk->major || disk->first_minor));
 	WARN_ON(!disk->minors && !(disk->flags & GENHD_FL_EXT_DEVT));
 
-	disk->flags |= GENHD_FL_UP;
-
 	retval = blk_alloc_devt(&disk->part0, &devt);
 	if (retval) {
 		WARN_ON(1);
@@ -596,6 +594,8 @@ void add_disk(struct gendisk *disk)
 	}
 	disk_to_dev(disk)->devt = devt;
 
+	disk->flags |= GENHD_FL_UP;
+
 	/* ->major and ->first_minor aren't supposed to be
 	 * dereferenced from here on, but set them just in case.
 	 */
@@ -1105,7 +1105,7 @@ static void disk_release(struct device *dev)
 	disk_replace_part_tbl(disk, NULL);
 	free_part_stats(&disk->part0);
 	free_part_info(&disk->part0);
-	if (disk->queue)
+	if (disk->queue && disk->flags & GENHD_FL_UP)
 		blk_put_queue(disk->queue);
 	kfree(disk);
 }
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 1e09e99..32551f2 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4322,14 +4322,8 @@ out_unreg_blkdev:
 out_put_disk:
 	while (dr--) {
 		del_timer_sync(&motor_off_timer[dr]);
-		if (disks[dr]->queue) {
+		if (disks[dr]->queue)
 			blk_cleanup_queue(disks[dr]->queue);
-			/*
-			 * put_disk() is not paired with add_disk() and
-			 * will put queue reference one extra time. fix it.
-			 */
-			disks[dr]->queue = NULL;
-		}
 		put_disk(disks[dr]);
 	}
 	destroy_workqueue(floppy_wq);
@@ -4558,14 +4552,6 @@ static void __exit floppy_module_exit(void)
 		}
 		blk_cleanup_queue(disks[drive]->queue);
 
-		/*
-		 * These disks have not called add_disk().  Don't put down
-		 * queue reference in put_disk().
-		 */
-		if (!(allowed_drive_mask & (1 << drive)) ||
-		    fdc_state[FDC(drive)].version == FDC_NONE)
-			disks[drive]->queue = NULL;
-
 		put_disk(disks[drive]);
 	}
 
-- 
1.7.9.5

