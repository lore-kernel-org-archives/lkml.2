Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1HYPUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:20:50 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34374 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab1HYPJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:47 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 077/118] drbd: Converted drbd_send() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:13 +0200
Message-Id: <1314284934-17999-78-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    4 +-
 drivers/block/drbd/drbd_main.c |   45 +++++++++++++++++++--------------------
 2 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e8c2c2a..1f590b9 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1158,8 +1158,8 @@ extern void tl_release(struct drbd_conf *mdev, unsigned int barrier_nr,
 extern void tl_clear(struct drbd_conf *mdev);
 extern void _tl_add_barrier(struct drbd_conf *, struct drbd_tl_epoch *);
 extern void drbd_free_sock(struct drbd_conf *mdev);
-extern int drbd_send(struct drbd_conf *mdev, struct socket *sock,
-			void *buf, size_t size, unsigned msg_flags);
+extern int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
+		     void *buf, size_t size, unsigned msg_flags);
 extern int drbd_send_protocol(struct drbd_conf *mdev);
 extern int drbd_send_uuids(struct drbd_conf *mdev);
 extern int drbd_send_uuids_skip_initial_sync(struct drbd_conf *mdev);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1f9eac0..357397e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -702,7 +702,7 @@ int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
 
 	prepare_header(mdev, h, cmd, size - sizeof(struct p_header));
 
-	sent = drbd_send(mdev, sock, h, size, msg_flags);
+	sent = drbd_send(mdev->tconn, sock, h, size, msg_flags);
 
 	ok = (sent == size);
 	if (!ok && !signal_pending(current))
@@ -752,9 +752,9 @@ int drbd_send_cmd2(struct drbd_conf *mdev, enum drbd_packet cmd, char *data,
 		return 0;
 
 	ok = (sizeof(h) ==
-		drbd_send(mdev, mdev->tconn->data.socket, &h, sizeof(h), 0));
+		drbd_send(mdev->tconn, mdev->tconn->data.socket, &h, sizeof(h), 0));
 	ok = ok && (size ==
-		drbd_send(mdev, mdev->tconn->data.socket, data, size, 0));
+		drbd_send(mdev->tconn, mdev->tconn->data.socket, data, size, 0));
 
 	drbd_put_data_sock(mdev);
 
@@ -1318,8 +1318,8 @@ int drbd_send_drequest_csum(struct drbd_conf *mdev, sector_t sector, int size,
 
 	mutex_lock(&mdev->tconn->data.mutex);
 
-	ok = (sizeof(p) == drbd_send(mdev, mdev->tconn->data.socket, &p, sizeof(p), 0));
-	ok = ok && (digest_size == drbd_send(mdev, mdev->tconn->data.socket, digest, digest_size, 0));
+	ok = (sizeof(p) == drbd_send(mdev->tconn, mdev->tconn->data.socket, &p, sizeof(p), 0));
+	ok = ok && (digest_size == drbd_send(mdev->tconn, mdev->tconn->data.socket, digest, digest_size, 0));
 
 	mutex_unlock(&mdev->tconn->data.mutex);
 
@@ -1397,7 +1397,7 @@ static void drbd_update_congested(struct drbd_tconn *tconn)
 static int _drbd_no_send_page(struct drbd_conf *mdev, struct page *page,
 		   int offset, size_t size, unsigned msg_flags)
 {
-	int sent = drbd_send(mdev, mdev->tconn->data.socket, kmap(page) + offset, size, msg_flags);
+	int sent = drbd_send(mdev->tconn, mdev->tconn->data.socket, kmap(page) + offset, size, msg_flags);
 	kunmap(page);
 	if (sent == size)
 		mdev->send_cnt += size>>9;
@@ -1538,11 +1538,11 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	p.dp_flags = cpu_to_be32(dp_flags);
 	set_bit(UNPLUG_REMOTE, &mdev->flags);
 	ok = (sizeof(p) ==
-		drbd_send(mdev, mdev->tconn->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0));
+		drbd_send(mdev->tconn, mdev->tconn->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0));
 	if (ok && dgs) {
 		dgb = mdev->tconn->int_dig_out;
 		drbd_csum_bio(mdev, mdev->tconn->integrity_w_tfm, req->master_bio, dgb);
-		ok = dgs == drbd_send(mdev, mdev->tconn->data.socket, dgb, dgs, 0);
+		ok = dgs == drbd_send(mdev->tconn, mdev->tconn->data.socket, dgb, dgs, 0);
 	}
 	if (ok) {
 		/* For protocol A, we have to memcpy the payload into
@@ -1611,11 +1611,11 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 	if (!drbd_get_data_sock(mdev))
 		return 0;
 
-	ok = sizeof(p) == drbd_send(mdev, mdev->tconn->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0);
+	ok = sizeof(p) == drbd_send(mdev->tconn, mdev->tconn->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0);
 	if (ok && dgs) {
 		dgb = mdev->tconn->int_dig_out;
 		drbd_csum_ee(mdev, mdev->tconn->integrity_w_tfm, peer_req, dgb);
-		ok = dgs == drbd_send(mdev, mdev->tconn->data.socket, dgb, dgs, 0);
+		ok = dgs == drbd_send(mdev->tconn, mdev->tconn->data.socket, dgb, dgs, 0);
 	}
 	if (ok)
 		ok = _drbd_send_zc_ee(mdev, peer_req);
@@ -1651,7 +1651,7 @@ int drbd_send_oos(struct drbd_conf *mdev, struct drbd_request *req)
 /*
  * you must have down()ed the appropriate [m]sock_mutex elsewhere!
  */
-int drbd_send(struct drbd_conf *mdev, struct socket *sock,
+int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
 	      void *buf, size_t size, unsigned msg_flags)
 {
 	struct kvec iov;
@@ -1672,9 +1672,9 @@ int drbd_send(struct drbd_conf *mdev, struct socket *sock,
 	msg.msg_controllen = 0;
 	msg.msg_flags      = msg_flags | MSG_NOSIGNAL;
 
-	if (sock == mdev->tconn->data.socket) {
-		mdev->tconn->ko_count = mdev->tconn->net_conf->ko_count;
-		drbd_update_congested(mdev->tconn);
+	if (sock == tconn->data.socket) {
+		tconn->ko_count = tconn->net_conf->ko_count;
+		drbd_update_congested(tconn);
 	}
 	do {
 		/* STRANGE
@@ -1688,12 +1688,11 @@ int drbd_send(struct drbd_conf *mdev, struct socket *sock,
  */
 		rv = kernel_sendmsg(sock, &msg, &iov, 1, size);
 		if (rv == -EAGAIN) {
-			if (we_should_drop_the_connection(mdev->tconn, sock))
+			if (we_should_drop_the_connection(tconn, sock))
 				break;
 			else
 				continue;
 		}
-		D_ASSERT(rv != 0);
 		if (rv == -EINTR) {
 			flush_signals(current);
 			rv = 0;
@@ -1705,17 +1704,17 @@ int drbd_send(struct drbd_conf *mdev, struct socket *sock,
 		iov.iov_len  -= rv;
 	} while (sent < size);
 
-	if (sock == mdev->tconn->data.socket)
-		clear_bit(NET_CONGESTED, &mdev->tconn->flags);
+	if (sock == tconn->data.socket)
+		clear_bit(NET_CONGESTED, &tconn->flags);
 
 	if (rv <= 0) {
 		if (rv != -EAGAIN) {
-			dev_err(DEV, "%s_sendmsg returned %d\n",
-			    sock == mdev->tconn->meta.socket ? "msock" : "sock",
-			    rv);
-			drbd_force_state(mdev, NS(conn, C_BROKEN_PIPE));
+			conn_err(tconn, "%s_sendmsg returned %d\n",
+				 sock == tconn->meta.socket ? "msock" : "sock",
+				 rv);
+			drbd_force_state(tconn->volume0, NS(conn, C_BROKEN_PIPE));
 		} else
-			drbd_force_state(mdev, NS(conn, C_TIMEOUT));
+			drbd_force_state(tconn->volume0, NS(conn, C_TIMEOUT));
 	}
 
 	return sent;
-- 
1.7.4.1

