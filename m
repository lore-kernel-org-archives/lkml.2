Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2LMOBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:01:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44028 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab2LMOBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Kosina <jkosina@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 018/241] floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop
Date: Thu, 13 Dec 2012 11:56:23 -0200
Message-Id: <1355407206-17100-19-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

commit b54e1f88897bcacc2cd359f48ea3b39eaf55f084 upstream.

Since commit 070ad7e ("floppy: convert to delayed work and single-thread
wq"), we end up calling alloc_ordered_workqueue multiple times inside
the loop, which shouldn't be intended. Besides the leak, other side
effect in the current code is if blk_init_queue fails, we would end up
calling unregister_blkdev even if we didn't call yet register_blkdev.

Just moved the allocation of floppy_wq before the loop, and adjusted the
code accordingly.

Acked-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/block/floppy.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 553f43a..3817084 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4138,6 +4138,10 @@ static int __init floppy_init(void)
 
 	raw_cmd = NULL;
 
+	floppy_wq = alloc_ordered_workqueue("floppy", 0);
+	if (!floppy_wq)
+		return -ENOMEM;
+
 	for (dr = 0; dr < N_DRIVE; dr++) {
 		disks[dr] = alloc_disk(1);
 		if (!disks[dr]) {
@@ -4145,16 +4149,10 @@ static int __init floppy_init(void)
 			goto out_put_disk;
 		}
 
-		floppy_wq = alloc_ordered_workqueue("floppy", 0);
-		if (!floppy_wq) {
-			err = -ENOMEM;
-			goto out_put_disk;
-		}
-
 		disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);
 		if (!disks[dr]->queue) {
 			err = -ENOMEM;
-			goto out_destroy_workq;
+			goto out_put_disk;
 		}
 
 		blk_queue_max_hw_sectors(disks[dr]->queue, 64);
@@ -4318,8 +4316,6 @@ out_release_dma:
 out_unreg_region:
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
 	platform_driver_unregister(&floppy_driver);
-out_destroy_workq:
-	destroy_workqueue(floppy_wq);
 out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 out_put_disk:
@@ -4335,6 +4331,7 @@ out_put_disk:
 		}
 		put_disk(disks[dr]);
 	}
+	destroy_workqueue(floppy_wq);
 	return err;
 }
 
-- 
1.7.9.5

