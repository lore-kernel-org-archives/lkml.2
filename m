Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab1JFNiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:38:12 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34103 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab1JFNiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/15] drbd: drbd_dew_dev_size() gets the user requests disk_size as argument
Date: Thu,  6 Oct 2011 15:37:48 +0200
Message-Id: <1317908280-28951-4-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_nl.c       |   11 ++++++-----
 drivers/block/drbd/drbd_receiver.c |    2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 0311dfd..8c7e340 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1395,7 +1395,7 @@ extern int drbd_msg_put_info(const char *info);
 extern void drbd_suspend_io(struct drbd_conf *mdev);
 extern void drbd_resume_io(struct drbd_conf *mdev);
 extern char *ppsize(char *buf, unsigned long long size);
-extern sector_t drbd_new_dev_size(struct drbd_conf *, struct drbd_backing_dev *, int);
+extern sector_t drbd_new_dev_size(struct drbd_conf *, struct drbd_backing_dev *, sector_t, int);
 enum determine_dev_size { dev_size_error = -1, unchanged = 0, shrunk = 1, grew = 2 };
 extern enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *, enum dds_flags) __must_hold(local);
 extern void resync_after_online_grow(struct drbd_conf *);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 6317ae5..dfe43f2 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -797,7 +797,7 @@ void drbd_resume_io(struct drbd_conf *mdev)
 enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *mdev, enum dds_flags flags) __must_hold(local)
 {
 	sector_t prev_first_sect, prev_size; /* previous meta location */
-	sector_t la_size;
+	sector_t la_size, u_size;
 	sector_t size;
 	char ppb[10];
 
@@ -825,7 +825,8 @@ enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *mdev, enum dds
 	/* TODO: should only be some assert here, not (re)init... */
 	drbd_md_set_sector_offsets(mdev, mdev->ldev);
 
-	size = drbd_new_dev_size(mdev, mdev->ldev, flags & DDSF_FORCED);
+	u_size = mdev->ldev->dc.disk_size;
+	size = drbd_new_dev_size(mdev, mdev->ldev, u_size, flags & DDSF_FORCED);
 
 	if (drbd_get_capacity(mdev->this_bdev) != size ||
 	    drbd_bm_capacity(mdev) != size) {
@@ -888,12 +889,12 @@ out:
 }
 
 sector_t
-drbd_new_dev_size(struct drbd_conf *mdev, struct drbd_backing_dev *bdev, int assume_peer_has_space)
+drbd_new_dev_size(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
+		  sector_t u_size, int assume_peer_has_space)
 {
 	sector_t p_size = mdev->p_size;   /* partner's disk size. */
 	sector_t la_size = bdev->md.la_size_sect; /* last agreed size. */
 	sector_t m_size; /* my size */
-	sector_t u_size = bdev->dc.disk_size; /* size requested by user. */
 	sector_t size = 0;
 
 	m_size = drbd_get_max_capacity(bdev);
@@ -1442,7 +1443,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 
 	/* Prevent shrinking of consistent devices ! */
 	if (drbd_md_test_flag(nbc, MDF_CONSISTENT) &&
-	    drbd_new_dev_size(mdev, nbc, 0) < nbc->md.la_size_sect) {
+	    drbd_new_dev_size(mdev, nbc, nbc->dc.disk_size, 0) < nbc->md.la_size_sect) {
 		dev_warn(DEV, "refusing to truncate a consistent device\n");
 		retcode = ERR_DISK_TO_SMALL;
 		goto force_diskless_dec;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 567d64b..23614e4 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3379,7 +3379,7 @@ static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 
 		/* Never shrink a device with usable data during connect.
 		   But allow online shrinking if we are connected. */
-		if (drbd_new_dev_size(mdev, mdev->ldev, 0) <
+		if (drbd_new_dev_size(mdev, mdev->ldev, p_usize, 0) <
 		   drbd_get_capacity(mdev->this_bdev) &&
 		   mdev->state.disk >= D_OUTDATED &&
 		   mdev->state.conn < C_CONNECTED) {
-- 
1.7.4.1

