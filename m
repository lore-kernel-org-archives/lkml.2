Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab1I3Mse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:48:34 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42731 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1I3Ms2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:48:28 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/11] drbd: drbd_delete_device() takes a struct drbd_conf * now
Date: Fri, 30 Sep 2011 14:48:16 +0200
Message-Id: <1317386906-19260-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
References: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    2 +-
 drivers/block/drbd/drbd_main.c |   12 ++++--------
 drivers/block/drbd/drbd_nl.c   |    2 +-
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 9aca1f4..ce56aa0 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1367,7 +1367,7 @@ extern rwlock_t global_state_lock;
 extern int conn_lowest_minor(struct drbd_tconn *tconn);
 enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor, int vnr);
 extern void drbd_free_mdev(struct drbd_conf *mdev);
-extern void drbd_delete_device(unsigned int minor);
+extern void drbd_delete_device(struct drbd_conf *mdev);
 
 struct drbd_tconn *drbd_new_tconn(const char *name);
 extern void drbd_free_tconn(struct drbd_tconn *tconn);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 8097d7a..8466ee7 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2195,15 +2195,10 @@ static void drbd_release_all_peer_reqs(struct drbd_conf *mdev)
 }
 
 /* caution. no locking. */
-void drbd_delete_device(unsigned int minor)
+void drbd_delete_device(struct drbd_conf *mdev)
 {
-	struct drbd_conf *mdev = minor_to_mdev(minor);
-
-	if (!mdev)
-		return;
-
 	idr_remove(&mdev->tconn->volumes, mdev->vnr);
-	idr_remove(&minors, minor);
+	idr_remove(&minors, mdev_to_minor(mdev));
 	synchronize_rcu();
 
 	/* paranoia asserts */
@@ -2256,7 +2251,8 @@ static void drbd_cleanup(void)
 	drbd_genl_unregister();
 
 	idr_for_each_entry(&minors, mdev, i)
-		drbd_delete_device(i);
+		drbd_delete_device(mdev);
+
 	drbd_destroy_mempools();
 	unregister_blkdev(DRBD_MAJOR, "drbd");
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 4b60673..be2ca81 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2916,7 +2916,7 @@ static enum drbd_ret_code adm_delete_minor(struct drbd_conf *mdev)
 	     * we may want to delete a minor from a live replication group.
 	     */
 	    mdev->state.role == R_SECONDARY) {
-		drbd_delete_device(mdev_to_minor(mdev));
+		drbd_delete_device(mdev);
 		return NO_ERROR;
 	} else
 		return ERR_MINOR_CONFIGURED;
-- 
1.7.4.1

