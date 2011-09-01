Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1IAMw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:52:28 -0400
Received: from mail09.linbit.com ([212.69.161.110]:55664 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab1IAMtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:49:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/18] drbd: allow holes in minor and volume id allocation
Date: Thu,  1 Sep 2011 14:48:57 +0200
Message-Id: <1314881345-6420-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
References: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

s/idr_get_new/idr_get_new_above/

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    1 +
 drivers/block/drbd/drbd_main.c |   33 +++++++++++++++++----------------
 drivers/block/drbd/drbd_nl.c   |    2 +-
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index acd2877..f4c3c71 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1509,6 +1509,7 @@ extern int is_valid_ar_handle(struct drbd_request *, sector_t);
 
 
 /* drbd_nl.c */
+extern int drbd_msg_put_info(const char *info);
 extern void drbd_suspend_io(struct drbd_conf *mdev);
 extern void drbd_resume_io(struct drbd_conf *mdev);
 extern char *ppsize(char *buf, unsigned long long size);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9b41213..64bf9b6 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2322,6 +2322,7 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	struct request_queue *q;
 	int vnr_got = vnr;
 	int minor_got = minor;
+	enum drbd_ret_code err = ERR_NOMEM;
 
 	mdev = minor_to_mdev(minor);
 	if (mdev)
@@ -2389,33 +2390,33 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	INIT_LIST_HEAD(&mdev->current_epoch->list);
 	mdev->epochs = 1;
 
-	if (!idr_pre_get(&tconn->volumes, GFP_KERNEL))
-		goto out_no_vol_idr;
-	if (idr_get_new(&tconn->volumes, mdev, &vnr_got))
-		goto out_no_vol_idr;
-	if (vnr_got != vnr) {
-		dev_err(DEV, "vnr_got (%d) != vnr (%d)\n", vnr_got, vnr);
-		goto out_idr_remove_vol;
-	}
-
 	if (!idr_pre_get(&minors, GFP_KERNEL))
 		goto out_idr_remove_vol;
-	if (idr_get_new(&minors, mdev, &minor_got))
+	if (idr_get_new_above(&minors, mdev, minor, &minor_got))
 		goto out_idr_remove_vol;
 	if (minor_got != minor) {
-		/* minor exists, or other idr strangeness? */
-		dev_err(DEV, "available minor (%d) != requested minor (%d)\n",
-				minor_got, minor);
+		err = ERR_MINOR_EXISTS;
+		drbd_msg_put_info("requested minor exists already");
 		goto out_idr_remove_minor;
 	}
+
+	if (!idr_pre_get(&tconn->volumes, GFP_KERNEL))
+		goto out_no_vol_idr;
+	if (idr_get_new_above(&tconn->volumes, mdev, vnr, &vnr_got))
+		goto out_no_vol_idr;
+	if (vnr_got != vnr) {
+		err = ERR_INVALID_REQUEST;
+		drbd_msg_put_info("requested volume exists already");
+		goto out_idr_remove_vol;
+	}
 	add_disk(disk);
 
 	return NO_ERROR;
 
-out_idr_remove_minor:
-	idr_remove(&minors, minor_got);
 out_idr_remove_vol:
 	idr_remove(&tconn->volumes, vnr_got);
+out_idr_remove_minor:
+	idr_remove(&minors, minor_got);
 	synchronize_rcu();
 out_no_vol_idr:
 	kfree(mdev->current_epoch);
@@ -2429,7 +2430,7 @@ out_no_disk:
 	blk_cleanup_queue(q);
 out_no_q:
 	kfree(mdev);
-	return ERR_NOMEM;
+	return err;
 }
 
 /* counterpart of drbd_new_device.
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index a8f27cb..b40c83d 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -133,7 +133,7 @@ static void drbd_adm_send_reply(struct sk_buff *skb, struct genl_info *info)
 
 /* Used on a fresh "drbd_adm_prepare"d reply_skb, this cannot fail: The only
  * reason it could fail was no space in skb, and there are 4k available. */
-static int drbd_msg_put_info(const char *info)
+int drbd_msg_put_info(const char *info)
 {
 	struct sk_buff *skb = adm_ctx.reply_skb;
 	struct nlattr *nla;
-- 
1.7.4.1

