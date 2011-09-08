Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab1IHMpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:45:46 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37535 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687Ab1IHMpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:42 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/16] drbd: _conn_send_cmd(), _drbd_send_cmd(): Pass a struct drbd_socket instead of a plain socket
Date: Thu,  8 Sep 2011 14:45:30 +0200
Message-Id: <1315485937-18989-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
References: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    4 ++--
 drivers/block/drbd/drbd_main.c     |   22 +++++++++++-----------
 drivers/block/drbd/drbd_receiver.c |   16 ++++++++--------
 drivers/block/drbd/drbd_worker.c   |    2 +-
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 984b2a3..4ee6fc5 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1113,7 +1113,7 @@ extern int _conn_send_state_req(struct drbd_tconn *, int vnr, enum drbd_packet c
 				union drbd_state, union drbd_state);
 extern int _drbd_send_state(struct drbd_conf *mdev);
 extern int drbd_send_state(struct drbd_conf *mdev);
-extern int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct socket *sock,
+extern int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct drbd_socket *sock,
 			  enum drbd_packet cmd, struct p_header *h, size_t size,
 			  unsigned msg_flags);
 extern int conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct drbd_socket *sock,
@@ -1860,7 +1860,7 @@ static inline void request_ping(struct drbd_tconn *tconn)
 	wake_asender(tconn);
 }
 
-static inline int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
+static inline int _drbd_send_cmd(struct drbd_conf *mdev, struct drbd_socket *sock,
 				  enum drbd_packet cmd, struct p_header *h, size_t size,
 				  unsigned msg_flags)
 {
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index ea06d31..05960ab 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -719,14 +719,14 @@ static void prepare_header(struct drbd_conf *mdev, struct p_header *h,
 }
 
 /* the appropriate socket mutex must be held already */
-int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct socket *sock,
+int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct drbd_socket *sock,
 		   enum drbd_packet cmd, struct p_header *h, size_t size,
 		   unsigned msg_flags)
 {
 	int err;
 
 	_prepare_header(tconn, vnr, h, cmd, size - sizeof(struct p_header));
-	err = drbd_send_all(tconn, sock, h, size, msg_flags);
+	err = drbd_send_all(tconn, sock->socket, h, size, msg_flags);
 	if (err && !signal_pending(current))
 		conn_warn(tconn, "short send %s size=%d\n",
 			  cmdname(cmd), (int)size);
@@ -743,7 +743,7 @@ int conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct drbd_socket *sock,
 
 	mutex_lock(&sock->mutex);
 	if (sock->socket)
-		err = _conn_send_cmd(tconn, vnr, sock->socket, cmd, h, size, 0);
+		err = _conn_send_cmd(tconn, vnr, sock, cmd, h, size, 0);
 	mutex_unlock(&sock->mutex);
 	return err;
 }
@@ -780,7 +780,7 @@ int drbd_send_ping_ack(struct drbd_tconn *tconn)
 int drbd_send_sync_param(struct drbd_conf *mdev)
 {
 	struct p_rs_param_95 *p;
-	struct socket *sock;
+	struct drbd_socket *sock;
 	int size, err;
 	const int apv = mdev->tconn->agreed_pro_version;
 
@@ -791,9 +791,9 @@ int drbd_send_sync_param(struct drbd_conf *mdev)
 		: /* apv >= 95 */ sizeof(struct p_rs_param_95);
 
 	mutex_lock(&mdev->tconn->data.mutex);
-	sock = mdev->tconn->data.socket;
+	sock = &mdev->tconn->data;
 
-	if (likely(sock != NULL)) {
+	if (likely(sock->socket != NULL)) {
 		enum drbd_packet cmd =
 			apv >= 89 ? P_SYNC_PARAM89 : P_SYNC_PARAM;
 
@@ -979,16 +979,16 @@ int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags fl
  */
 int drbd_send_state(struct drbd_conf *mdev)
 {
-	struct socket *sock;
+	struct drbd_socket *sock;
 	struct p_state p;
 	int err = -EIO;
 
 	mutex_lock(&mdev->tconn->data.mutex);
 
 	p.state = cpu_to_be32(mdev->state.i); /* Within the send mutex */
-	sock = mdev->tconn->data.socket;
+	sock = &mdev->tconn->data;
 
-	if (likely(sock != NULL))
+	if (likely(sock->socket != NULL))
 		err = _drbd_send_cmd(mdev, sock, P_STATE, &p.head, sizeof(p), 0);
 
 	mutex_unlock(&mdev->tconn->data.mutex);
@@ -1157,7 +1157,7 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev, struct bm_xfer_ctx *c)
 
 	if (len) {
 		dcbp_set_code(p, RLE_VLI_Bits);
-		err = _drbd_send_cmd(mdev, mdev->tconn->data.socket,
+		err = _drbd_send_cmd(mdev, &mdev->tconn->data,
 				     P_COMPRESSED_BITMAP, &p->head,
 				     sizeof(*p) + len, 0);
 
@@ -1175,7 +1175,7 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev, struct bm_xfer_ctx *c)
 		if (len)
 			drbd_bm_get_lel(mdev, c->word_offset, num_words,
 					(unsigned long *)h->payload);
-		err = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BITMAP,
+		err = _drbd_send_cmd(mdev, &mdev->tconn->data, P_BITMAP,
 				     h, sizeof(struct p_header80) + len, 0);
 		c->word_offset += num_words;
 		c->bit_offset = c->word_offset * BITS_PER_LONG;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 830b107..80d85af 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -729,7 +729,7 @@ out:
 	return s_estab;
 }
 
-static int drbd_send_fp(struct drbd_tconn *tconn, struct socket *sock, enum drbd_packet cmd)
+static int drbd_send_fp(struct drbd_tconn *tconn, struct drbd_socket *sock, enum drbd_packet cmd)
 {
 	struct p_header *h = tconn->data.sbuf;
 
@@ -738,13 +738,13 @@ static int drbd_send_fp(struct drbd_tconn *tconn, struct socket *sock, enum drbd
 
 static enum drbd_packet drbd_recv_fp(struct drbd_tconn *tconn, struct socket *sock)
 {
-	struct p_header80 *h = tconn->data.rbuf;
+	struct p_header80 h;
 	int rr;
 
-	rr = drbd_recv_short(sock, h, sizeof(*h), 0);
+	rr = drbd_recv_short(sock, &h, sizeof(h), 0);
 
-	if (rr == sizeof(*h) && h->magic == cpu_to_be32(DRBD_MAGIC))
-		return be16_to_cpu(h->command);
+	if (rr == sizeof(h) && h.magic == cpu_to_be32(DRBD_MAGIC))
+		return be16_to_cpu(h.command);
 
 	return 0xffff;
 }
@@ -833,10 +833,10 @@ static int drbd_connect(struct drbd_tconn *tconn)
 		if (s) {
 			if (!tconn->data.socket) {
 				tconn->data.socket = s;
-				drbd_send_fp(tconn, tconn->data.socket, P_HAND_SHAKE_S);
+				drbd_send_fp(tconn, &tconn->data, P_HAND_SHAKE_S);
 			} else if (!tconn->meta.socket) {
 				tconn->meta.socket = s;
-				drbd_send_fp(tconn, tconn->meta.socket, P_HAND_SHAKE_M);
+				drbd_send_fp(tconn, &tconn->meta, P_HAND_SHAKE_M);
 			} else {
 				conn_err(tconn, "Logic error in drbd_connect()\n");
 				goto out_release_sockets;
@@ -4198,7 +4198,7 @@ static int drbd_send_handshake(struct drbd_tconn *tconn)
 	memset(p, 0, sizeof(*p));
 	p->protocol_min = cpu_to_be32(PRO_VERSION_MIN);
 	p->protocol_max = cpu_to_be32(PRO_VERSION_MAX);
-	err = _conn_send_cmd(tconn, 0, tconn->data.socket, P_HAND_SHAKE,
+	err = _conn_send_cmd(tconn, 0, &tconn->data, P_HAND_SHAKE,
 			     &p->head, sizeof(*p), 0);
 	mutex_unlock(&tconn->data.mutex);
 	return err;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 829a2ce..3f7d27c 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1217,7 +1217,7 @@ int w_send_barrier(struct drbd_work *w, int cancel)
 	/* inc_ap_pending was done where this was queued.
 	 * dec_ap_pending will be done in got_BarrierAck
 	 * or (on connection loss) in w_clear_epoch.  */
-	err = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BARRIER,
+	err = _drbd_send_cmd(mdev, &mdev->tconn->data, P_BARRIER,
 			     &p->head, sizeof(*p), 0);
 	drbd_put_data_sock(mdev->tconn);
 
-- 
1.7.4.1

