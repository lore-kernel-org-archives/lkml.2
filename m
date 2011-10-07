Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964954Ab1JGL15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:27:57 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35872 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759957Ab1JGL1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:27:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/12] drbd: Fix the upper limit of resync-after
Date: Fri,  7 Oct 2011 13:27:43 +0200
Message-Id: <1317986865-3706-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
References: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

The 32-bit resync_after netlink field takes a device minor number as
parameter, which is no longer limited to 255.  We cannot statically
verify which device numbers are valid, so set the ummer limit to the
highest possible signed 32-bit integer.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h    |    4 ++--
 drivers/block/drbd/drbd_nl.c     |    4 ++--
 drivers/block/drbd/drbd_worker.c |   26 +++++++++++++-------------
 include/linux/drbd.h             |    4 ++--
 include/linux/drbd_genl.h        |    2 +-
 include/linux/drbd_limits.h      |    7 ++++---
 6 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 8026ada..e167228 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1408,8 +1408,8 @@ extern int drbd_khelper(struct drbd_conf *mdev, char *cmd);
 
 /* drbd_worker.c */
 extern int drbd_worker(struct drbd_thread *thi);
-enum drbd_ret_code drbd_sync_after_valid(struct drbd_conf *mdev, int o_minor);
-void drbd_sync_after_changed(struct drbd_conf *mdev);
+enum drbd_ret_code drbd_resync_after_valid(struct drbd_conf *mdev, int o_minor);
+void drbd_resync_after_changed(struct drbd_conf *mdev);
 extern void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side);
 extern void resume_next_sg(struct drbd_conf *mdev);
 extern void suspend_other_sg(struct drbd_conf *mdev);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 64de372..e67ce20 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1219,10 +1219,10 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	write_lock_irq(&global_state_lock);
-	retcode = drbd_sync_after_valid(mdev, new_disk_conf->resync_after);
+	retcode = drbd_resync_after_valid(mdev, new_disk_conf->resync_after);
 	if (retcode == NO_ERROR) {
 		rcu_assign_pointer(mdev->ldev->disk_conf, new_disk_conf);
-		drbd_sync_after_changed(mdev);
+		drbd_resync_after_changed(mdev);
 	}
 	write_unlock_irq(&global_state_lock);
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 46b5f7f..85bcab9 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -57,7 +57,7 @@ static int w_make_ov_request(struct drbd_work *w, int cancel);
 
 /* About the global_state_lock
    Each state transition on an device holds a read lock. In case we have
-   to evaluate the sync after dependencies, we grab a write lock, because
+   to evaluate the resync after dependencies, we grab a write lock, because
    we need stable states on all devices for that.  */
 rwlock_t global_state_lock;
 
@@ -1340,17 +1340,17 @@ int w_restart_disk_io(struct drbd_work *w, int cancel)
 static int _drbd_may_sync_now(struct drbd_conf *mdev)
 {
 	struct drbd_conf *odev = mdev;
-	int ra;
+	int resync_after;
 
 	while (1) {
 		if (!odev->ldev)
 			return 1;
 		rcu_read_lock();
-		ra = rcu_dereference(odev->ldev->disk_conf)->resync_after;
+		resync_after = rcu_dereference(odev->ldev->disk_conf)->resync_after;
 		rcu_read_unlock();
-		if (ra == -1)
+		if (resync_after == -1)
 			return 1;
-		odev = minor_to_mdev(ra);
+		odev = minor_to_mdev(resync_after);
 		if (!expect(odev))
 			return 1;
 		if ((odev->state.conn >= C_SYNC_SOURCE &&
@@ -1426,36 +1426,36 @@ void suspend_other_sg(struct drbd_conf *mdev)
 }
 
 /* caller must hold global_state_lock */
-enum drbd_ret_code drbd_sync_after_valid(struct drbd_conf *mdev, int o_minor)
+enum drbd_ret_code drbd_resync_after_valid(struct drbd_conf *mdev, int o_minor)
 {
 	struct drbd_conf *odev;
-	int ra;
+	int resync_after;
 
 	if (o_minor == -1)
 		return NO_ERROR;
 	if (o_minor < -1 || minor_to_mdev(o_minor) == NULL)
-		return ERR_SYNC_AFTER;
+		return ERR_RESYNC_AFTER;
 
 	/* check for loops */
 	odev = minor_to_mdev(o_minor);
 	while (1) {
 		if (odev == mdev)
-			return ERR_SYNC_AFTER_CYCLE;
+			return ERR_RESYNC_AFTER_CYCLE;
 
 		rcu_read_lock();
-		ra = rcu_dereference(odev->ldev->disk_conf)->resync_after;
+		resync_after = rcu_dereference(odev->ldev->disk_conf)->resync_after;
 		rcu_read_unlock();
 		/* dependency chain ends here, no cycles. */
-		if (ra == -1)
+		if (resync_after == -1)
 			return NO_ERROR;
 
 		/* follow the dependency chain */
-		odev = minor_to_mdev(ra);
+		odev = minor_to_mdev(resync_after);
 	}
 }
 
 /* caller must hold global_state_lock */
-void drbd_sync_after_changed(struct drbd_conf *mdev)
+void drbd_resync_after_changed(struct drbd_conf *mdev)
 {
 	int changes;
 
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 6c7c85d..05063e6 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -130,8 +130,8 @@ enum drbd_ret_code {
 	ERR_INTR		= 129, /* EINTR */
 	ERR_RESIZE_RESYNC	= 130,
 	ERR_NO_PRIMARY		= 131,
-	ERR_SYNC_AFTER		= 132,
-	ERR_SYNC_AFTER_CYCLE	= 133,
+	ERR_RESYNC_AFTER	= 132,
+	ERR_RESYNC_AFTER_CYCLE	= 133,
 	ERR_PAUSE_IS_SET	= 134,
 	ERR_PAUSE_IS_CLEAR	= 135,
 	ERR_PACKET_NR		= 137,
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 07b4f4a..40606ad 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -116,7 +116,7 @@ GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
 	__u32_field_def(7, GENLA_F_MANDATORY,	fencing, DRBD_FENCING_DEF)
 
 	__u32_field_def(8,	GENLA_F_MANDATORY,	resync_rate, DRBD_RESYNC_RATE_DEF)
-	__u32_field_def(9,	GENLA_F_MANDATORY,	resync_after, DRBD_AFTER_DEF)
+	__u32_field_def(9,	GENLA_F_MANDATORY,	resync_after, DRBD_RESYNC_AFTER_DEF)
 	__u32_field_def(10,	GENLA_F_MANDATORY,	al_extents, DRBD_AL_EXTENTS_DEF)
 	__u32_field_def(11,	GENLA_F_MANDATORY,	c_plan_ahead, DRBD_C_PLAN_AHEAD_DEF)
 	__u32_field_def(12,	GENLA_F_MANDATORY,	c_delay_target, DRBD_C_DELAY_TARGET_DEF)
diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 27f5a13..62e93b2 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -111,9 +111,10 @@
 #define DRBD_AL_EXTENTS_MAX  6433
 #define DRBD_AL_EXTENTS_DEF  127
 
-#define DRBD_AFTER_MIN  -1
-#define DRBD_AFTER_MAX  255
-#define DRBD_AFTER_DEF  -1
+#define DRBD_RESYNC_AFTER_MIN  -1
+#define DRBD_RESYNC_AFTER_MAX  (1<<30)
+#define DRBD_RESYNC_AFTER_DEF  -1
+#define DRBD_RESYNC_AFTER_SCALE '1'
 
 /* } */
 
-- 
1.7.4.1

