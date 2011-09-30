Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab1I3Msb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:48:31 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42732 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588Ab1I3Ms2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:48:28 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/11] drbd: Inlined drbd_free_mdev(); it got called only from one place
Date: Fri, 30 Sep 2011 14:48:17 +0200
Message-Id: <1317386906-19260-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
References: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    1 -
 drivers/block/drbd/drbd_main.c |   25 +++++++------------------
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index ce56aa0..c49dc08 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1366,7 +1366,6 @@ extern rwlock_t global_state_lock;
 
 extern int conn_lowest_minor(struct drbd_tconn *tconn);
 enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor, int vnr);
-extern void drbd_free_mdev(struct drbd_conf *mdev);
 extern void drbd_delete_device(struct drbd_conf *mdev);
 
 struct drbd_tconn *drbd_new_tconn(const char *name);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 8466ee7..03b3ffe 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2224,10 +2224,13 @@ void drbd_delete_device(struct drbd_conf *mdev)
 	kfree(mdev->p_uuid);
 	/* mdev->p_uuid = NULL; */
 
-	/* cleanup the rest that has been
-	 * allocated from drbd_new_device
-	 * and actually free the mdev itself */
-	drbd_free_mdev(mdev);
+	kfree(mdev->current_epoch);
+	if (mdev->bitmap) /* should no longer be there. */
+		drbd_bm_cleanup(mdev);
+	__free_page(mdev->md_io_page);
+	put_disk(mdev->vdisk);
+	blk_cleanup_queue(mdev->rq_queue);
+	kfree(mdev);
 }
 
 static void drbd_cleanup(void)
@@ -2542,20 +2545,6 @@ out_no_q:
 	return err;
 }
 
-/* counterpart of drbd_new_device.
- * last part of drbd_delete_device. */
-void drbd_free_mdev(struct drbd_conf *mdev)
-{
-	kfree(mdev->current_epoch);
-	if (mdev->bitmap) /* should no longer be there. */
-		drbd_bm_cleanup(mdev);
-	__free_page(mdev->md_io_page);
-	put_disk(mdev->vdisk);
-	blk_cleanup_queue(mdev->rq_queue);
-	kfree(mdev);
-}
-
-
 int __init drbd_init(void)
 {
 	int err;
-- 
1.7.4.1

