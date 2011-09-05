Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1IELuC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:50:02 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60316 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab1IELqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:02 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 23/54] drbd: drbd_send_ack_{dp,rp}(): Return void: the result is never used
Date: Mon,  5 Sep 2011 13:45:14 +0200
Message-Id: <1315223145-20640-24-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    8 ++++----
 drivers/block/drbd/drbd_main.c |   14 +++++++-------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 8e0f59b..d10505e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1185,10 +1185,10 @@ extern void drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr,
 			    u32 set_size);
 extern int drbd_send_ack(struct drbd_conf *, enum drbd_packet,
 			 struct drbd_peer_request *);
-extern int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
-			    struct p_block_req *rp);
-extern int drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
-			    struct p_data *dp, int data_size);
+extern void drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
+			     struct p_block_req *rp);
+extern void drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
+			     struct p_data *dp, int data_size);
 extern int drbd_send_ack_ex(struct drbd_conf *mdev, enum drbd_packet cmd,
 			    sector_t sector, int blksize, u64 block_id);
 extern int drbd_send_oos(struct drbd_conf *mdev, struct drbd_request *req);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 6d40647..a5371fb 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1264,19 +1264,19 @@ static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 /* dp->sector and dp->block_id already/still in network byte order,
  * data_size is payload size according to dp->head,
  * and may need to be corrected for digest size. */
-int drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
-		     struct p_data *dp, int data_size)
+void drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
+		      struct p_data *dp, int data_size)
 {
 	data_size -= (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_r_tfm) ?
 		crypto_hash_digestsize(mdev->tconn->integrity_r_tfm) : 0;
-	return !_drbd_send_ack(mdev, cmd, dp->sector, cpu_to_be32(data_size),
-			       dp->block_id);
+	_drbd_send_ack(mdev, cmd, dp->sector, cpu_to_be32(data_size),
+		       dp->block_id);
 }
 
-int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
-		     struct p_block_req *rp)
+void drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
+		      struct p_block_req *rp)
 {
-	return !_drbd_send_ack(mdev, cmd, rp->sector, rp->blksize, rp->block_id);
+	_drbd_send_ack(mdev, cmd, rp->sector, rp->blksize, rp->block_id);
 }
 
 /**
-- 
1.7.4.1

