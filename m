Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab2HMSQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:16:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53928 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab2HMSQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:16:56 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH v3 6/6] floppy: remove dr, reuse drive on do_floppy_init
Date: Mon, 13 Aug 2012 15:16:27 -0300
Message-Id: <1344881787-6422-7-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a small cleanup, that also may turn error handling of
unitialized disks more readable. We don't need a separate variable to
track allocated disks, remove dr and reuse drive variable instead.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/block/floppy.c |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 381b9c1..0312ba4 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4124,8 +4124,7 @@ static struct kobject *floppy_find(dev_t dev, int *part, void *data)
 
 static int __init do_floppy_init(void)
 {
-	int i, unit, drive;
-	int err, dr;
+	int i, unit, drive, err;
 
 	set_debugt();
 	interruptjiffies = resultjiffies = jiffies;
@@ -4141,29 +4140,28 @@ static int __init do_floppy_init(void)
 	if (!floppy_wq)
 		return -ENOMEM;
 
-	for (dr = 0; dr < N_DRIVE; dr++) {
-		disks[dr] = alloc_disk(1);
-		if (!disks[dr]) {
+	for (drive = 0; drive < N_DRIVE; drive++) {
+		disks[drive] = alloc_disk(1);
+		if (!disks[drive]) {
 			err = -ENOMEM;
 			goto out_put_disk;
 		}
 
-		disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);
-		if (!disks[dr]->queue) {
-			put_disk(disks[dr]);
+		disks[drive]->queue = blk_init_queue(do_fd_request, &floppy_lock);
+		if (!disks[drive]->queue) {
 			err = -ENOMEM;
 			goto out_put_disk;
 		}
 
-		blk_queue_max_hw_sectors(disks[dr]->queue, 64);
-		disks[dr]->major = FLOPPY_MAJOR;
-		disks[dr]->first_minor = TOMINOR(dr);
-		disks[dr]->fops = &floppy_fops;
-		sprintf(disks[dr]->disk_name, "fd%d", dr);
+		blk_queue_max_hw_sectors(disks[drive]->queue, 64);
+		disks[drive]->major = FLOPPY_MAJOR;
+		disks[drive]->first_minor = TOMINOR(drive);
+		disks[drive]->fops = &floppy_fops;
+		sprintf(disks[drive]->disk_name, "fd%d", drive);
 
-		init_timer(&motor_off_timer[dr]);
-		motor_off_timer[dr].data = dr;
-		motor_off_timer[dr].function = motor_off_callback;
+		init_timer(&motor_off_timer[drive]);
+		motor_off_timer[drive].data = drive;
+		motor_off_timer[drive].function = motor_off_callback;
 	}
 
 	err = register_blkdev(FLOPPY_MAJOR, "fd");
@@ -4328,18 +4326,20 @@ out_unreg_region:
 out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 out_put_disk:
-	while (dr--) {
-		del_timer_sync(&motor_off_timer[dr]);
-		if (disks[dr]->queue) {
-			blk_cleanup_queue(disks[dr]->queue);
+	for (drive = 0; drive < N_DRIVE; drive++) {
+		if (!disks[drive])
+			break;
+		if (disks[drive]->queue) {
+			del_timer_sync(&motor_off_timer[drive]);
+			blk_cleanup_queue(disks[drive]->queue);
 			/*
 			 * put_disk() is not paired with add_disk() and
 			 * will put queue reference one extra time. fix it.
 			 */
-			if (!disk_registered[dr])
-				disks[dr]->queue = NULL;
+			if (!disk_registered[drive])
+				disks[drive]->queue = NULL;
 		}
-		put_disk(disks[dr]);
+		put_disk(disks[drive]);
 	}
 	destroy_workqueue(floppy_wq);
 	return err;
-- 
1.7.9.5

