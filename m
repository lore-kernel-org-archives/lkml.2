Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab2HHPxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:53:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34060 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab2HHPxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:53:14 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] floppy: error handling fixes on floppy_init
Date: Wed,  8 Aug 2012 12:53:04 -0300
Message-Id: <1344441184-2382-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at commit 3f9a5aa (floppy: Cleanup disk->queue before
caling put_disk() if add_disk() was never called) I noticed some
problems with the error handling and cleanup:

* missing cleanup (put_disk) if blk_init_queue fails, dr is decremented
  first in the error handling loop
* if something fails in the add_disk loop, there is no cleanup of
  previous iterations in the error handling.
* "if (disks[dr]->queue)" check is bogus, when reaching there for each
  dr should exist an queue allocated, and it doesn't take into account
  iterations where add_disk wasn't done, if failure happens in add_disk
  loop.
* floppy_module_exit doesn't reset queue pointer if add_disk wasn't
  done.

Later commit 4609dff (floppy: Fix a crash during rmmod) fixed the last
item, this change should handle the remaining problems on floppy_init.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: stable@vger.kernel.org
---
 drivers/block/floppy.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index a7d6347..25ac98b 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4127,6 +4127,7 @@ static int __init do_floppy_init(void)
 {
 	int i, unit, drive;
 	int err, dr;
+	int registered = -1;
 
 	set_debugt();
 	interruptjiffies = resultjiffies = jiffies;
@@ -4153,6 +4154,7 @@ static int __init do_floppy_init(void)
 
 		disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);
 		if (!disks[dr]->queue) {
+			put_disk(disks[dr]);
 			err = -ENOMEM;
 			goto out_destroy_workq;
 		}
@@ -4294,7 +4296,7 @@ static int __init do_floppy_init(void)
 
 		err = platform_device_register(&floppy_device[drive]);
 		if (err)
-			goto out_release_dma;
+			goto out_remove_drives;
 
 		err = device_create_file(&floppy_device[drive].dev,
 					 &dev_attr_cmos);
@@ -4312,6 +4314,16 @@ static int __init do_floppy_init(void)
 
 out_unreg_platform_dev:
 	platform_device_unregister(&floppy_device[drive]);
+out_remove_drives:
+	registered = drive - 1;
+	while (drive--) {
+		if ((allowed_drive_mask & (1 << drive)) &&
+		     fdc_state[FDC(drive)].version != FDC_NONE) {
+			del_gendisk(disks[drive]);
+			device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
+			platform_device_unregister(&floppy_device[drive]);
+		}
+	}
 out_release_dma:
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
@@ -4325,14 +4337,14 @@ out_unreg_blkdev:
 out_put_disk:
 	while (dr--) {
 		del_timer_sync(&motor_off_timer[dr]);
-		if (disks[dr]->queue) {
-			blk_cleanup_queue(disks[dr]->queue);
-			/*
-			 * put_disk() is not paired with add_disk() and
-			 * will put queue reference one extra time. fix it.
-			 */
+		blk_cleanup_queue(disks[dr]->queue);
+		/*
+		 * put_disk() may not be paired with add_disk() and
+		 * will put queue reference one extra time. fix it.
+		 */
+		if (dr > registered || !(allowed_drive_mask & (1 << dr)) ||
+		    fdc_state[FDC(dr)].version == FDC_NONE)
 			disks[dr]->queue = NULL;
-		}
 		put_disk(disks[dr]);
 	}
 	return err;
-- 
1.7.9.5

