Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266Ab1JEJla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:41:30 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56205 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934149Ab1JEJiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/16] drbd: rename variable ndc to new_disk_conf
Date: Wed,  5 Oct 2011 11:37:51 +0200
Message-Id: <1317807484-24628-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
References: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 7bfcb96..51dc869 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1181,7 +1181,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
 	struct drbd_conf *mdev;
-	struct disk_conf *ndc; /* new disk conf */
+	struct disk_conf *new_disk_conf;
 	int err, fifo_size;
 	int *rs_plan_s = NULL;
 
@@ -1220,39 +1220,39 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
  * some half-updated struct when we
  * assign it later. */
 
-	ndc = kmalloc(sizeof(*ndc), GFP_KERNEL);
-	if (!ndc) {
+	new_disk_conf = kmalloc(sizeof(*new_disk_conf), GFP_KERNEL);
+	if (!new_disk_conf) {
 		retcode = ERR_NOMEM;
 		goto fail;
 	}
 
-	memcpy(ndc, &mdev->ldev->dc, sizeof(*ndc));
+	memcpy(new_disk_conf, &mdev->ldev->dc, sizeof(*new_disk_conf));
 	if (should_set_defaults(info))
-		drbd_set_disk_conf_defaults(ndc);
+		drbd_set_disk_conf_defaults(new_disk_conf);
 
-	err = disk_conf_from_attrs(ndc, info);
+	err = disk_conf_from_attrs(new_disk_conf, info);
 	if (err) {
 		retcode = ERR_MANDATORY_TAG;
 		drbd_msg_put_info(from_attrs_err_to_txt(err));
 	}
 
-	if (!expect(ndc->resync_rate >= 1))
-		ndc->resync_rate = 1;
+	if (!expect(new_disk_conf->resync_rate >= 1))
+		new_disk_conf->resync_rate = 1;
 
 	/* clip to allowed range */
-	if (!expect(ndc->al_extents >= DRBD_AL_EXTENTS_MIN))
-		ndc->al_extents = DRBD_AL_EXTENTS_MIN;
-	if (!expect(ndc->al_extents <= DRBD_AL_EXTENTS_MAX))
-		ndc->al_extents = DRBD_AL_EXTENTS_MAX;
+	if (!expect(new_disk_conf->al_extents >= DRBD_AL_EXTENTS_MIN))
+		new_disk_conf->al_extents = DRBD_AL_EXTENTS_MIN;
+	if (!expect(new_disk_conf->al_extents <= DRBD_AL_EXTENTS_MAX))
+		new_disk_conf->al_extents = DRBD_AL_EXTENTS_MAX;
 
 	/* most sanity checks done, try to assign the new sync-after
 	 * dependency.  need to hold the global lock in there,
 	 * to avoid a race in the dependency loop check. */
-	retcode = drbd_alter_sa(mdev, ndc->resync_after);
+	retcode = drbd_alter_sa(mdev, new_disk_conf->resync_after);
 	if (retcode != NO_ERROR)
 		goto fail;
 
-	fifo_size = (ndc->c_plan_ahead * 10 * SLEEP_TIME) / HZ;
+	fifo_size = (new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ;
 	if (fifo_size != mdev->rs_plan_s.size && fifo_size > 0) {
 		rs_plan_s   = kzalloc(sizeof(int) * fifo_size, GFP_KERNEL);
 		if (!rs_plan_s) {
@@ -1272,7 +1272,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 
 	wait_event(mdev->al_wait, lc_try_lock(mdev->act_log));
 	drbd_al_shrink(mdev);
-	err = drbd_check_al_size(mdev, ndc);
+	err = drbd_check_al_size(mdev, new_disk_conf);
 	lc_unlock(mdev->act_log);
 	wake_up(&mdev->al_wait);
 
@@ -1285,7 +1285,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	 * To avoid someone looking at a half-updated struct, we probably
 	 * should have a rw-semaphor on net_conf and disk_conf.
 	 */
-	mdev->ldev->dc = *ndc;
+	mdev->ldev->dc = *new_disk_conf;
 
 	drbd_md_sync(mdev);
 
@@ -1295,7 +1295,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 
  fail:
 	put_ldev(mdev);
-	kfree(ndc);
+	kfree(new_disk_conf);
 	kfree(rs_plan_s);
  out:
 	drbd_adm_finish(info, retcode);
-- 
1.7.4.1

