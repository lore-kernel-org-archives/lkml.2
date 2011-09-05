Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab1IELqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:46:39 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60183 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab1IELp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:59 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 21/54] drbd: _drbd_send_ack(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:12 +0200
Message-Id: <1315223145-20640-22-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_main.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 3bbe85b..2718327 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1249,7 +1249,6 @@ void drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr, u32 set_size)
 static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 			  u64 sector, u32 blksize, u64 block_id)
 {
-	int ok;
 	struct p_block_ack p;
 
 	p.sector   = sector;
@@ -1258,9 +1257,8 @@ static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 	p.seq_num  = cpu_to_be32(atomic_inc_return(&mdev->packet_seq));
 
 	if (!mdev->tconn->meta.socket || mdev->state.conn < C_CONNECTED)
-		return false;
-	ok = !drbd_send_cmd(mdev, &mdev->tconn->meta, cmd, &p.head, sizeof(p));
-	return ok;
+		return -EIO;
+	return drbd_send_cmd(mdev, &mdev->tconn->meta, cmd, &p.head, sizeof(p));
 }
 
 /* dp->sector and dp->block_id already/still in network byte order,
@@ -1271,14 +1269,14 @@ int drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
 {
 	data_size -= (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_r_tfm) ?
 		crypto_hash_digestsize(mdev->tconn->integrity_r_tfm) : 0;
-	return _drbd_send_ack(mdev, cmd, dp->sector, cpu_to_be32(data_size),
-			      dp->block_id);
+	return !_drbd_send_ack(mdev, cmd, dp->sector, cpu_to_be32(data_size),
+			       dp->block_id);
 }
 
 int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
 		     struct p_block_req *rp)
 {
-	return _drbd_send_ack(mdev, cmd, rp->sector, rp->blksize, rp->block_id);
+	return !_drbd_send_ack(mdev, cmd, rp->sector, rp->blksize, rp->block_id);
 }
 
 /**
@@ -1290,10 +1288,10 @@ int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
 int drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 		  struct drbd_peer_request *peer_req)
 {
-	return _drbd_send_ack(mdev, cmd,
-			      cpu_to_be64(peer_req->i.sector),
-			      cpu_to_be32(peer_req->i.size),
-			      peer_req->block_id);
+	return !_drbd_send_ack(mdev, cmd,
+			       cpu_to_be64(peer_req->i.sector),
+			       cpu_to_be32(peer_req->i.size),
+			       peer_req->block_id);
 }
 
 /* This function misuses the block_id field to signal if the blocks
@@ -1301,10 +1299,10 @@ int drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 int drbd_send_ack_ex(struct drbd_conf *mdev, enum drbd_packet cmd,
 		     sector_t sector, int blksize, u64 block_id)
 {
-	return _drbd_send_ack(mdev, cmd,
-			      cpu_to_be64(sector),
-			      cpu_to_be32(blksize),
-			      cpu_to_be64(block_id));
+	return !_drbd_send_ack(mdev, cmd,
+			       cpu_to_be64(sector),
+			       cpu_to_be32(blksize),
+			       cpu_to_be64(block_id));
 }
 
 int drbd_send_drequest(struct drbd_conf *mdev, int cmd,
-- 
1.7.4.1

