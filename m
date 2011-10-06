Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab1JFNls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:41:48 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34105 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981Ab1JFNiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/15] drbd: Split drbd_alter_sa() into drbd_sync_after_valid() and drbd_sync_after_changed()
Date: Thu,  6 Oct 2011 15:37:49 +0200
Message-Id: <1317908280-28951-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
References: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparing RCU for disk_conf

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h    |    3 ++-
 drivers/block/drbd/drbd_nl.c     |   15 +++++++--------
 drivers/block/drbd/drbd_worker.c |   22 ++++++++--------------
 3 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 8c7e340..f8d0ac3 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1409,7 +1409,8 @@ extern int drbd_khelper(struct drbd_conf *mdev, char *cmd);
 
 /* drbd_worker.c */
 extern int drbd_worker(struct drbd_thread *thi);
-extern int drbd_alter_sa(struct drbd_conf *mdev, int na);
+enum drbd_ret_code drbd_sync_after_valid(struct drbd_conf *mdev, int o_minor);
+void drbd_sync_after_changed(struct drbd_conf *mdev);
 extern void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side);
 extern void resume_next_sg(struct drbd_conf *mdev);
 extern void suspend_other_sg(struct drbd_conf *mdev);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index dfe43f2..4efeffa 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1181,13 +1181,6 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	if (!expect(new_disk_conf->al_extents <= DRBD_AL_EXTENTS_MAX))
 		new_disk_conf->al_extents = DRBD_AL_EXTENTS_MAX;
 
-	/* most sanity checks done, try to assign the new sync-after
-	 * dependency.  need to hold the global lock in there,
-	 * to avoid a race in the dependency loop check. */
-	retcode = drbd_alter_sa(mdev, new_disk_conf->resync_after);
-	if (retcode != NO_ERROR)
-		goto fail;
-
 	fifo_size = (new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ;
 	if (fifo_size != mdev->rs_plan_s.size && fifo_size > 0) {
 		rs_plan_s   = kzalloc(sizeof(int) * fifo_size, GFP_KERNEL);
@@ -1221,7 +1214,13 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	 * To avoid someone looking at a half-updated struct, we probably
 	 * should have a rw-semaphor on net_conf and disk_conf.
 	 */
-	mdev->ldev->dc = *new_disk_conf;
+	write_lock_irq(&global_state_lock);
+	retcode = drbd_sync_after_valid(mdev, new_disk_conf->resync_after);
+	if (retcode == NO_ERROR) {
+		mdev->ldev->dc = *new_disk_conf;
+		drbd_sync_after_changed(mdev);
+	}
+	write_unlock_irq(&global_state_lock);
 
 	drbd_md_sync(mdev);
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index f22288b1..f8fdf75 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1401,7 +1401,8 @@ void suspend_other_sg(struct drbd_conf *mdev)
 	write_unlock_irq(&global_state_lock);
 }
 
-static int sync_after_error(struct drbd_conf *mdev, int o_minor)
+/* caller must hold global_state_lock */
+enum drbd_ret_code drbd_sync_after_valid(struct drbd_conf *mdev, int o_minor)
 {
 	struct drbd_conf *odev;
 
@@ -1425,22 +1426,15 @@ static int sync_after_error(struct drbd_conf *mdev, int o_minor)
 	}
 }
 
-int drbd_alter_sa(struct drbd_conf *mdev, int na)
+/* caller must hold global_state_lock */
+void drbd_sync_after_changed(struct drbd_conf *mdev)
 {
 	int changes;
-	int retcode;
 
-	write_lock_irq(&global_state_lock);
-	retcode = sync_after_error(mdev, na);
-	if (retcode == NO_ERROR) {
-		mdev->ldev->dc.resync_after = na;
-		do {
-			changes  = _drbd_pause_after(mdev);
-			changes |= _drbd_resume_next(mdev);
-		} while (changes);
-	}
-	write_unlock_irq(&global_state_lock);
-	return retcode;
+	do {
+		changes  = _drbd_pause_after(mdev);
+		changes |= _drbd_resume_next(mdev);
+	} while (changes);
 }
 
 void drbd_rs_controller_reset(struct drbd_conf *mdev)
-- 
1.7.4.1

