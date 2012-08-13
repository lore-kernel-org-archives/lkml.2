Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2HMSQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:16:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53890 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2HMSQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:16:37 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH v3 1/6] floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop
Date: Mon, 13 Aug 2012 15:16:22 -0300
Message-Id: <1344881787-6422-2-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 070ad7e ("floppy: convert to delayed work and single-thread
wq"), we end up calling alloc_ordered_workqueue multiple times inside
the loop, which shouldn't be intended. Besides the leak, other side
effect in the current code is if blk_init_queue fails, we would end up
calling unregister_blkdev even if we didn't call yet register_blkdev.

Just moved the allocation of floppy_wq before the loop, and adjusted the
code accordingly.

Cc: stable@vger.kernel.org # 3.5+
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/block/floppy.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index a7d6347..c8d9e68 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4138,6 +4138,10 @@ static int __init do_floppy_init(void)
 
 	raw_cmd = NULL;
 
+	floppy_wq = alloc_ordered_workqueue("floppy", 0);
+	if (!floppy_wq)
+		return -ENOMEM;
+
 	for (dr = 0; dr < N_DRIVE; dr++) {
 		disks[dr] = alloc_disk(1);
 		if (!disks[dr]) {
@@ -4145,16 +4149,10 @@ static int __init do_floppy_init(void)
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

