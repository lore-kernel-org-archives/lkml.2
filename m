Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1IELwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:52:11 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59852 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1IELpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:51 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/54] drbd: conn_send_cmd(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:44:57 +0200
Message-Id: <1315223145-20640-7-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h  |    6 +++---
 drivers/block/drbd/drbd_main.c |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 32799ea..e7fa168 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1932,7 +1932,7 @@ static inline int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
 static inline int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
 				enum drbd_packet cmd, struct p_header *h, size_t size)
 {
-	return conn_send_cmd(mdev->tconn, mdev->vnr, use_data_socket, cmd, h, size);
+	return !conn_send_cmd(mdev->tconn, mdev->vnr, use_data_socket, cmd, h, size);
 }
 
 static inline int drbd_send_short_cmd(struct drbd_conf *mdev,
@@ -1945,13 +1945,13 @@ static inline int drbd_send_short_cmd(struct drbd_conf *mdev,
 static inline int drbd_send_ping(struct drbd_tconn *tconn)
 {
 	struct p_header h;
-	return conn_send_cmd(tconn, 0, USE_META_SOCKET, P_PING, &h, sizeof(h));
+	return !conn_send_cmd(tconn, 0, USE_META_SOCKET, P_PING, &h, sizeof(h));
 }
 
 static inline int drbd_send_ping_ack(struct drbd_tconn *tconn)
 {
 	struct p_header h;
-	return conn_send_cmd(tconn, 0, USE_META_SOCKET, P_PING_ACK, &h, sizeof(h));
+	return !conn_send_cmd(tconn, 0, USE_META_SOCKET, P_PING_ACK, &h, sizeof(h));
 }
 
 static inline int drbd_send_state_req(struct drbd_conf *mdev,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index cf13c75..c063426 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -739,8 +739,8 @@ int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct socket *sock,
 int conn_send_cmd(struct drbd_tconn *tconn, int vnr, int use_data_socket,
 		  enum drbd_packet cmd, struct p_header *h, size_t size)
 {
-	int ok = 0;
 	struct socket *sock;
+	int err = -EIO;
 
 	if (use_data_socket) {
 		mutex_lock(&tconn->data.mutex);
@@ -753,13 +753,13 @@ int conn_send_cmd(struct drbd_tconn *tconn, int vnr, int use_data_socket,
 	/* drbd_disconnect() could have called drbd_free_sock()
 	 * while we were waiting in down()... */
 	if (likely(sock != NULL))
-		ok = !_conn_send_cmd(tconn, vnr, sock, cmd, h, size, 0);
+		err = _conn_send_cmd(tconn, vnr, sock, cmd, h, size, 0);
 
 	if (use_data_socket)
 		mutex_unlock(&tconn->data.mutex);
 	else
 		mutex_unlock(&tconn->meta.mutex);
-	return ok;
+	return err;
 }
 
 int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd, char *data,
@@ -1011,7 +1011,7 @@ int _conn_send_state_req(struct drbd_tconn *tconn, int vnr, enum drbd_packet cmd
 	p.mask    = cpu_to_be32(mask.i);
 	p.val     = cpu_to_be32(val.i);
 
-	return conn_send_cmd(tconn, vnr, USE_DATA_SOCKET, cmd, &p.head, sizeof(p));
+	return !conn_send_cmd(tconn, vnr, USE_DATA_SOCKET, cmd, &p.head, sizeof(p));
 }
 
 int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode)
@@ -1030,7 +1030,7 @@ int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode)
 
 	p.retcode    = cpu_to_be32(retcode);
 
-	return conn_send_cmd(tconn, 0, USE_META_SOCKET, cmd, &p.head, sizeof(p));
+	return !conn_send_cmd(tconn, 0, USE_META_SOCKET, cmd, &p.head, sizeof(p));
 }
 
 int fill_bitmap_rle_bits(struct drbd_conf *mdev,
-- 
1.7.4.1

