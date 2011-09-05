Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1IELwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:52:40 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59827 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab1IELpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:50 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/54] drbd: _conn_send_cmd(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:44:55 +0200
Message-Id: <1315223145-20640-5-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_main.c     |   17 +++++++----------
 drivers/block/drbd/drbd_receiver.c |    6 +++---
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 32799ea..9badc52 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1926,7 +1926,7 @@ static inline int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
 				  enum drbd_packet cmd, struct p_header *h, size_t size,
 				  unsigned msg_flags)
 {
-	return _conn_send_cmd(mdev->tconn, mdev->vnr, sock, cmd, h, size, msg_flags);
+	return !_conn_send_cmd(mdev->tconn, mdev->vnr, sock, cmd, h, size, msg_flags);
 }
 
 static inline int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 79389bf..58141ba 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -723,17 +723,14 @@ int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct socket *sock,
 		   enum drbd_packet cmd, struct p_header *h, size_t size,
 		   unsigned msg_flags)
 {
-	int sent, ok;
+	int err;
 
 	_prepare_header(tconn, vnr, h, cmd, size - sizeof(struct p_header));
-
-	sent = drbd_send(tconn, sock, h, size, msg_flags);
-
-	ok = (sent == size);
-	if (!ok && !signal_pending(current))
-		conn_warn(tconn, "short sent %s size=%d sent=%d\n",
-			  cmdname(cmd), (int)size, sent);
-	return ok;
+	err = drbd_send_all(tconn, sock, h, size, msg_flags);
+	if (err && !signal_pending(current))
+		conn_warn(tconn, "short send %s size=%d\n",
+			  cmdname(cmd), (int)size);
+	return err;
 }
 
 /* don't pass the socket. we may only look at it
@@ -756,7 +753,7 @@ int conn_send_cmd(struct drbd_tconn *tconn, int vnr, int use_data_socket,
 	/* drbd_disconnect() could have called drbd_free_sock()
 	 * while we were waiting in down()... */
 	if (likely(sock != NULL))
-		ok = _conn_send_cmd(tconn, vnr, sock, cmd, h, size, 0);
+		ok = !_conn_send_cmd(tconn, vnr, sock, cmd, h, size, 0);
 
 	if (use_data_socket)
 		mutex_unlock(&tconn->data.mutex);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index e7e6ed6..7431e3c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -711,7 +711,7 @@ static int drbd_send_fp(struct drbd_tconn *tconn, struct socket *sock, enum drbd
 {
 	struct p_header *h = &tconn->data.sbuf.header;
 
-	return _conn_send_cmd(tconn, 0, sock, cmd, h, sizeof(*h), 0);
+	return !_conn_send_cmd(tconn, 0, sock, cmd, h, sizeof(*h), 0);
 }
 
 static enum drbd_packet drbd_recv_fp(struct drbd_tconn *tconn, struct socket *sock)
@@ -4148,8 +4148,8 @@ static int drbd_send_handshake(struct drbd_tconn *tconn)
 	memset(p, 0, sizeof(*p));
 	p->protocol_min = cpu_to_be32(PRO_VERSION_MIN);
 	p->protocol_max = cpu_to_be32(PRO_VERSION_MAX);
-	ok = _conn_send_cmd(tconn, 0, tconn->data.socket, P_HAND_SHAKE,
-			    &p->head, sizeof(*p), 0);
+	ok = !_conn_send_cmd(tconn, 0, tconn->data.socket, P_HAND_SHAKE,
+			     &p->head, sizeof(*p), 0);
 	mutex_unlock(&tconn->data.mutex);
 	return ok;
 }
-- 
1.7.4.1

