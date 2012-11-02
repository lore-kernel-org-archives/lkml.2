Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763111Ab2KBRMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:12:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:33382 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab2KBRHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, Jens Axboe <axboe@kernel.dk>
Subject: [ 06/24] floppy: dont call alloc_ordered_workqueue inside the alloc_disk loop
Date: Fri,  2 Nov 2012 10:06:54 -0700
Message-Id: <20121102170247.883582032@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170247.406319110@linuxfoundation.org>
References: <20121102170247.406319110@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/floppy.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

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
 


