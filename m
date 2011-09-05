Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1IELvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:51:04 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59865 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1IELpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:52 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/54] drbd: drbd_send_cmd(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:44:59 +0200
Message-Id: <1315223145-20640-9-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h  |    4 ++--
 drivers/block/drbd/drbd_main.c |   18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 8663a1d..c8fd6cc 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1930,14 +1930,14 @@ static inline int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
 static inline int drbd_send_cmd(struct drbd_conf *mdev, struct drbd_socket *sock,
 				enum drbd_packet cmd, struct p_header *h, size_t size)
 {
-	return !conn_send_cmd(mdev->tconn, mdev->vnr, sock, cmd, h, size);
+	return conn_send_cmd(mdev->tconn, mdev->vnr, sock, cmd, h, size);
 }
 
 static inline int drbd_send_short_cmd(struct drbd_conf *mdev,
 				      enum drbd_packet cmd)
 {
 	struct p_header h;
-	return drbd_send_cmd(mdev, &mdev->tconn->data, cmd, &h, sizeof(h));
+	return !drbd_send_cmd(mdev, &mdev->tconn->data, cmd, &h, sizeof(h));
 }
 
 static inline int drbd_send_ping(struct drbd_tconn *tconn)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 3e1cda9..b2f1022 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -886,7 +886,7 @@ int _drbd_send_uuids(struct drbd_conf *mdev, u64 uuid_flags)
 
 	put_ldev(mdev);
 
-	return drbd_send_cmd(mdev, &mdev->tconn->data, P_UUIDS, &p.head, sizeof(p));
+	return !drbd_send_cmd(mdev, &mdev->tconn->data, P_UUIDS, &p.head, sizeof(p));
 }
 
 int drbd_send_uuids(struct drbd_conf *mdev)
@@ -930,7 +930,7 @@ int drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev)
 	drbd_md_sync(mdev);
 	p.uuid = cpu_to_be64(uuid);
 
-	return drbd_send_cmd(mdev, &mdev->tconn->data, P_SYNC_UUID, &p.head, sizeof(p));
+	return !drbd_send_cmd(mdev, &mdev->tconn->data, P_SYNC_UUID, &p.head, sizeof(p));
 }
 
 int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags flags)
@@ -962,7 +962,7 @@ int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags fl
 	p.queue_order_type = cpu_to_be16(q_order_type);
 	p.dds_flags = cpu_to_be16(flags);
 
-	ok = drbd_send_cmd(mdev, &mdev->tconn->data, P_SIZES, &p.head, sizeof(p));
+	ok = !drbd_send_cmd(mdev, &mdev->tconn->data, P_SIZES, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -1006,7 +1006,7 @@ int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode)
 
 	p.retcode    = cpu_to_be32(retcode);
 
-	return drbd_send_cmd(mdev, &mdev->tconn->meta, P_STATE_CHG_REPLY, &p.head, sizeof(p));
+	return !drbd_send_cmd(mdev, &mdev->tconn->meta, P_STATE_CHG_REPLY, &p.head, sizeof(p));
 }
 
 int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode)
@@ -1240,7 +1240,7 @@ int drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr, u32 set_size)
 
 	if (mdev->state.conn < C_CONNECTED)
 		return false;
-	ok = drbd_send_cmd(mdev, &mdev->tconn->meta, P_BARRIER_ACK, &p.head, sizeof(p));
+	ok = !drbd_send_cmd(mdev, &mdev->tconn->meta, P_BARRIER_ACK, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -1265,7 +1265,7 @@ static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 	if (!mdev->tconn->meta.socket || mdev->state.conn < C_CONNECTED)
 		return false;
-	ok = drbd_send_cmd(mdev, &mdev->tconn->meta, cmd, &p.head, sizeof(p));
+	ok = !drbd_send_cmd(mdev, &mdev->tconn->meta, cmd, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -1323,7 +1323,7 @@ int drbd_send_drequest(struct drbd_conf *mdev, int cmd,
 	p.block_id = block_id;
 	p.blksize  = cpu_to_be32(size);
 
-	ok = drbd_send_cmd(mdev, &mdev->tconn->data, cmd, &p.head, sizeof(p));
+	ok = !drbd_send_cmd(mdev, &mdev->tconn->data, cmd, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -1357,7 +1357,7 @@ int drbd_send_ov_request(struct drbd_conf *mdev, sector_t sector, int size)
 	p.block_id = ID_SYNCER /* unused */;
 	p.blksize  = cpu_to_be32(size);
 
-	ok = drbd_send_cmd(mdev, &mdev->tconn->data, P_OV_REQUEST, &p.head, sizeof(p));
+	ok = !drbd_send_cmd(mdev, &mdev->tconn->data, P_OV_REQUEST, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -1654,7 +1654,7 @@ int drbd_send_oos(struct drbd_conf *mdev, struct drbd_request *req)
 	p.sector  = cpu_to_be64(req->i.sector);
 	p.blksize = cpu_to_be32(req->i.size);
 
-	return drbd_send_cmd(mdev, &mdev->tconn->data, P_OUT_OF_SYNC, &p.head, sizeof(p));
+	return !drbd_send_cmd(mdev, &mdev->tconn->data, P_OUT_OF_SYNC, &p.head, sizeof(p));
 }
 
 /*
-- 
1.7.4.1

