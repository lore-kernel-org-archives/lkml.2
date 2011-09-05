Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab1IELqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:46:12 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59856 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1IELpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:52 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/54] drbd: Get rid of USE_DATA_SOCKET and USE_META_SOCKET
Date: Mon,  5 Sep 2011 13:44:58 +0200
Message-Id: <1315223145-20640-8-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h  |   14 +++++-------
 drivers/block/drbd/drbd_main.c |   46 ++++++++++++++--------------------------
 2 files changed, 22 insertions(+), 38 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e7fa168..8663a1d 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1176,12 +1176,10 @@ extern int drbd_send_state(struct drbd_conf *mdev);
 extern int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct socket *sock,
 			  enum drbd_packet cmd, struct p_header *h, size_t size,
 			  unsigned msg_flags);
-extern int conn_send_cmd(struct drbd_tconn *tconn, int vnr, int use_data_socket,
+extern int conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct drbd_socket *sock,
 			 enum drbd_packet cmd, struct p_header *h, size_t size);
 extern int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd,
 			  char *data, size_t size);
-#define USE_DATA_SOCKET 1
-#define USE_META_SOCKET 0
 extern int drbd_send_sync_param(struct drbd_conf *mdev);
 extern int drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr,
 			u32 set_size);
@@ -1929,29 +1927,29 @@ static inline int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
 	return _conn_send_cmd(mdev->tconn, mdev->vnr, sock, cmd, h, size, msg_flags);
 }
 
-static inline int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
+static inline int drbd_send_cmd(struct drbd_conf *mdev, struct drbd_socket *sock,
 				enum drbd_packet cmd, struct p_header *h, size_t size)
 {
-	return !conn_send_cmd(mdev->tconn, mdev->vnr, use_data_socket, cmd, h, size);
+	return !conn_send_cmd(mdev->tconn, mdev->vnr, sock, cmd, h, size);
 }
 
 static inline int drbd_send_short_cmd(struct drbd_conf *mdev,
 				      enum drbd_packet cmd)
 {
 	struct p_header h;
-	return drbd_send_cmd(mdev, USE_DATA_SOCKET, cmd, &h, sizeof(h));
+	return drbd_send_cmd(mdev, &mdev->tconn->data, cmd, &h, sizeof(h));
 }
 
 static inline int drbd_send_ping(struct drbd_tconn *tconn)
 {
 	struct p_header h;
-	return !conn_send_cmd(tconn, 0, USE_META_SOCKET, P_PING, &h, sizeof(h));
+	return !conn_send_cmd(tconn, 0, &tconn->meta, P_PING, &h, sizeof(h));
 }
 
 static inline int drbd_send_ping_ack(struct drbd_tconn *tconn)
 {
 	struct p_header h;
-	return !conn_send_cmd(tconn, 0, USE_META_SOCKET, P_PING_ACK, &h, sizeof(h));
+	return !conn_send_cmd(tconn, 0, &tconn->meta, P_PING_ACK, &h, sizeof(h));
 }
 
 static inline int drbd_send_state_req(struct drbd_conf *mdev,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c063426..3e1cda9 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -736,29 +736,15 @@ int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct socket *sock,
 /* don't pass the socket. we may only look at it
  * when we hold the appropriate socket mutex.
  */
-int conn_send_cmd(struct drbd_tconn *tconn, int vnr, int use_data_socket,
+int conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct drbd_socket *sock,
 		  enum drbd_packet cmd, struct p_header *h, size_t size)
 {
-	struct socket *sock;
 	int err = -EIO;
 
-	if (use_data_socket) {
-		mutex_lock(&tconn->data.mutex);
-		sock = tconn->data.socket;
-	} else {
-		mutex_lock(&tconn->meta.mutex);
-		sock = tconn->meta.socket;
-	}
-
-	/* drbd_disconnect() could have called drbd_free_sock()
-	 * while we were waiting in down()... */
-	if (likely(sock != NULL))
-		err = _conn_send_cmd(tconn, vnr, sock, cmd, h, size, 0);
-
-	if (use_data_socket)
-		mutex_unlock(&tconn->data.mutex);
-	else
-		mutex_unlock(&tconn->meta.mutex);
+	mutex_lock(&sock->mutex);
+	if (sock->socket)
+		err = _conn_send_cmd(tconn, vnr, sock->socket, cmd, h, size, 0);
+	mutex_unlock(&sock->mutex);
 	return err;
 }
 
@@ -900,7 +886,7 @@ int _drbd_send_uuids(struct drbd_conf *mdev, u64 uuid_flags)
 
 	put_ldev(mdev);
 
-	return drbd_send_cmd(mdev, USE_DATA_SOCKET, P_UUIDS, &p.head, sizeof(p));
+	return drbd_send_cmd(mdev, &mdev->tconn->data, P_UUIDS, &p.head, sizeof(p));
 }
 
 int drbd_send_uuids(struct drbd_conf *mdev)
@@ -944,7 +930,7 @@ int drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev)
 	drbd_md_sync(mdev);
 	p.uuid = cpu_to_be64(uuid);
 
-	return drbd_send_cmd(mdev, USE_DATA_SOCKET, P_SYNC_UUID, &p.head, sizeof(p));
+	return drbd_send_cmd(mdev, &mdev->tconn->data, P_SYNC_UUID, &p.head, sizeof(p));
 }
 
 int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags flags)
@@ -976,7 +962,7 @@ int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags fl
 	p.queue_order_type = cpu_to_be16(q_order_type);
 	p.dds_flags = cpu_to_be16(flags);
 
-	ok = drbd_send_cmd(mdev, USE_DATA_SOCKET, P_SIZES, &p.head, sizeof(p));
+	ok = drbd_send_cmd(mdev, &mdev->tconn->data, P_SIZES, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -1011,7 +997,7 @@ int _conn_send_state_req(struct drbd_tconn *tconn, int vnr, enum drbd_packet cmd
 	p.mask    = cpu_to_be32(mask.i);
 	p.val     = cpu_to_be32(val.i);
 
-	return !conn_send_cmd(tconn, vnr, USE_DATA_SOCKET, cmd, &p.head, sizeof(p));
+	return !conn_send_cmd(tconn, vnr, &tconn->data, cmd, &p.head, sizeof(p));
 }
 
 int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode)
@@ -1020,7 +1006,7 @@ int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode)
 
 	p.retcode    = cpu_to_be32(retcode);
 
-	return drbd_send_cmd(mdev, USE_META_SOCKET, P_STATE_CHG_REPLY, &p.head, sizeof(p));
+	return drbd_send_cmd(mdev, &mdev->tconn->meta, P_STATE_CHG_REPLY, &p.head, sizeof(p));
 }
 
 int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode)
@@ -1030,7 +1016,7 @@ int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode)
 
 	p.retcode    = cpu_to_be32(retcode);
 
-	return !conn_send_cmd(tconn, 0, USE_META_SOCKET, cmd, &p.head, sizeof(p));
+	return !conn_send_cmd(tconn, 0, &tconn->meta, cmd, &p.head, sizeof(p));
 }
 
 int fill_bitmap_rle_bits(struct drbd_conf *mdev,
@@ -1254,7 +1240,7 @@ int drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr, u32 set_size)
 
 	if (mdev->state.conn < C_CONNECTED)
 		return false;
-	ok = drbd_send_cmd(mdev, USE_META_SOCKET, P_BARRIER_ACK, &p.head, sizeof(p));
+	ok = drbd_send_cmd(mdev, &mdev->tconn->meta, P_BARRIER_ACK, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -1279,7 +1265,7 @@ static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 	if (!mdev->tconn->meta.socket || mdev->state.conn < C_CONNECTED)
 		return false;
-	ok = drbd_send_cmd(mdev, USE_META_SOCKET, cmd, &p.head, sizeof(p));
+	ok = drbd_send_cmd(mdev, &mdev->tconn->meta, cmd, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -1337,7 +1323,7 @@ int drbd_send_drequest(struct drbd_conf *mdev, int cmd,
 	p.block_id = block_id;
 	p.blksize  = cpu_to_be32(size);
 
-	ok = drbd_send_cmd(mdev, USE_DATA_SOCKET, cmd, &p.head, sizeof(p));
+	ok = drbd_send_cmd(mdev, &mdev->tconn->data, cmd, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -1371,7 +1357,7 @@ int drbd_send_ov_request(struct drbd_conf *mdev, sector_t sector, int size)
 	p.block_id = ID_SYNCER /* unused */;
 	p.blksize  = cpu_to_be32(size);
 
-	ok = drbd_send_cmd(mdev, USE_DATA_SOCKET, P_OV_REQUEST, &p.head, sizeof(p));
+	ok = drbd_send_cmd(mdev, &mdev->tconn->data, P_OV_REQUEST, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -1668,7 +1654,7 @@ int drbd_send_oos(struct drbd_conf *mdev, struct drbd_request *req)
 	p.sector  = cpu_to_be64(req->i.sector);
 	p.blksize = cpu_to_be32(req->i.size);
 
-	return drbd_send_cmd(mdev, USE_DATA_SOCKET, P_OUT_OF_SYNC, &p.head, sizeof(p));
+	return drbd_send_cmd(mdev, &mdev->tconn->data, P_OUT_OF_SYNC, &p.head, sizeof(p));
 }
 
 /*
-- 
1.7.4.1

