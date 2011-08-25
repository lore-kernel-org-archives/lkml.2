Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab1HYPQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:16:42 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35484 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab1HYPJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:58 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 091/118] drbd: Converted drbd_connect() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:27 +0200
Message-Id: <1314284934-17999-92-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |  102 +++++++++++++++++++-----------------
 1 files changed, 53 insertions(+), 49 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 42a2b39..b1eedd1 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -746,6 +746,24 @@ static int drbd_socket_okay(struct socket **sock)
 	}
 }
 
+static int drbd_connected(int vnr, void *p, void *data)
+{
+	struct drbd_conf *mdev = (struct drbd_conf *)p;
+	int ok = 1;
+
+	atomic_set(&mdev->packet_seq, 0);
+	mdev->peer_seq = 0;
+
+	ok &= drbd_send_sync_param(mdev, &mdev->sync_conf);
+	ok &= drbd_send_sizes(mdev, 0, 0);
+	ok &= drbd_send_uuids(mdev);
+	ok &= drbd_send_state(mdev);
+	clear_bit(USE_DEGR_WFC_T, &mdev->flags);
+	clear_bit(RESIZE_PENDING, &mdev->flags);
+
+	return !ok;
+}
+
 /*
  * return values:
  *   1 yes, we have a valid connection
@@ -754,18 +772,16 @@ static int drbd_socket_okay(struct socket **sock)
  *     no point in trying again, please go standalone.
  *  -2 We do not have a network config...
  */
-static int drbd_connect(struct drbd_conf *mdev)
+static int drbd_connect(struct drbd_tconn *tconn)
 {
 	struct socket *s, *sock, *msock;
 	int try, h, ok;
 
-	D_ASSERT(!mdev->tconn->data.socket);
-
-	if (drbd_request_state(mdev, NS(conn, C_WF_CONNECTION)) < SS_SUCCESS)
+	if (drbd_request_state(tconn->volume0, NS(conn, C_WF_CONNECTION)) < SS_SUCCESS)
 		return -2;
 
-	clear_bit(DISCARD_CONCURRENT, &mdev->tconn->flags);
-	mdev->tconn->agreed_pro_version = 99;
+	clear_bit(DISCARD_CONCURRENT, &tconn->flags);
+	tconn->agreed_pro_version = 99;
 	/* agreed_pro_version must be smaller than 100 so we send the old
 	   header (h80) in the first packet and in the handshake packet. */
 
@@ -775,7 +791,7 @@ static int drbd_connect(struct drbd_conf *mdev)
 	do {
 		for (try = 0;;) {
 			/* 3 tries, this should take less than a second! */
-			s = drbd_try_connect(mdev->tconn);
+			s = drbd_try_connect(tconn);
 			if (s || ++try >= 3)
 				break;
 			/* give the other side time to call bind() & listen() */
@@ -784,21 +800,21 @@ static int drbd_connect(struct drbd_conf *mdev)
 
 		if (s) {
 			if (!sock) {
-				drbd_send_fp(mdev->tconn, s, P_HAND_SHAKE_S);
+				drbd_send_fp(tconn, s, P_HAND_SHAKE_S);
 				sock = s;
 				s = NULL;
 			} else if (!msock) {
-				drbd_send_fp(mdev->tconn, s, P_HAND_SHAKE_M);
+				drbd_send_fp(tconn, s, P_HAND_SHAKE_M);
 				msock = s;
 				s = NULL;
 			} else {
-				dev_err(DEV, "Logic error in drbd_connect()\n");
+				conn_err(tconn, "Logic error in drbd_connect()\n");
 				goto out_release_sockets;
 			}
 		}
 
 		if (sock && msock) {
-			schedule_timeout_interruptible(mdev->tconn->net_conf->ping_timeo*HZ/10);
+			schedule_timeout_interruptible(tconn->net_conf->ping_timeo*HZ/10);
 			ok = drbd_socket_okay(&sock);
 			ok = drbd_socket_okay(&msock) && ok;
 			if (ok)
@@ -806,41 +822,41 @@ static int drbd_connect(struct drbd_conf *mdev)
 		}
 
 retry:
-		s = drbd_wait_for_connect(mdev->tconn);
+		s = drbd_wait_for_connect(tconn);
 		if (s) {
-			try = drbd_recv_fp(mdev->tconn, s);
+			try = drbd_recv_fp(tconn, s);
 			drbd_socket_okay(&sock);
 			drbd_socket_okay(&msock);
 			switch (try) {
 			case P_HAND_SHAKE_S:
 				if (sock) {
-					dev_warn(DEV, "initial packet S crossed\n");
+					conn_warn(tconn, "initial packet S crossed\n");
 					sock_release(sock);
 				}
 				sock = s;
 				break;
 			case P_HAND_SHAKE_M:
 				if (msock) {
-					dev_warn(DEV, "initial packet M crossed\n");
+					conn_warn(tconn, "initial packet M crossed\n");
 					sock_release(msock);
 				}
 				msock = s;
-				set_bit(DISCARD_CONCURRENT, &mdev->tconn->flags);
+				set_bit(DISCARD_CONCURRENT, &tconn->flags);
 				break;
 			default:
-				dev_warn(DEV, "Error receiving initial packet\n");
+				conn_warn(tconn, "Error receiving initial packet\n");
 				sock_release(s);
 				if (random32() & 1)
 					goto retry;
 			}
 		}
 
-		if (mdev->state.conn <= C_DISCONNECTING)
+		if (tconn->volume0->state.conn <= C_DISCONNECTING)
 			goto out_release_sockets;
 		if (signal_pending(current)) {
 			flush_signals(current);
 			smp_rmb();
-			if (get_t_state(&mdev->tconn->receiver) == EXITING)
+			if (get_t_state(&tconn->receiver) == EXITING)
 				goto out_release_sockets;
 		}
 
@@ -862,65 +878,53 @@ retry:
 	msock->sk->sk_priority = TC_PRIO_INTERACTIVE;
 
 	/* NOT YET ...
-	 * sock->sk->sk_sndtimeo = mdev->tconn->net_conf->timeout*HZ/10;
+	 * sock->sk->sk_sndtimeo = tconn->net_conf->timeout*HZ/10;
 	 * sock->sk->sk_rcvtimeo = MAX_SCHEDULE_TIMEOUT;
 	 * first set it to the P_HAND_SHAKE timeout,
 	 * which we set to 4x the configured ping_timeout. */
 	sock->sk->sk_sndtimeo =
-	sock->sk->sk_rcvtimeo = mdev->tconn->net_conf->ping_timeo*4*HZ/10;
+	sock->sk->sk_rcvtimeo = tconn->net_conf->ping_timeo*4*HZ/10;
 
-	msock->sk->sk_sndtimeo = mdev->tconn->net_conf->timeout*HZ/10;
-	msock->sk->sk_rcvtimeo = mdev->tconn->net_conf->ping_int*HZ;
+	msock->sk->sk_sndtimeo = tconn->net_conf->timeout*HZ/10;
+	msock->sk->sk_rcvtimeo = tconn->net_conf->ping_int*HZ;
 
 	/* we don't want delays.
 	 * we use TCP_CORK where appropriate, though */
 	drbd_tcp_nodelay(sock);
 	drbd_tcp_nodelay(msock);
 
-	mdev->tconn->data.socket = sock;
-	mdev->tconn->meta.socket = msock;
-	mdev->tconn->last_received = jiffies;
-
-	D_ASSERT(mdev->tconn->asender.task == NULL);
+	tconn->data.socket = sock;
+	tconn->meta.socket = msock;
+	tconn->last_received = jiffies;
 
-	h = drbd_do_handshake(mdev->tconn);
+	h = drbd_do_handshake(tconn);
 	if (h <= 0)
 		return h;
 
-	if (mdev->tconn->cram_hmac_tfm) {
+	if (tconn->cram_hmac_tfm) {
 		/* drbd_request_state(mdev, NS(conn, WFAuth)); */
-		switch (drbd_do_auth(mdev->tconn)) {
+		switch (drbd_do_auth(tconn)) {
 		case -1:
-			dev_err(DEV, "Authentication of peer failed\n");
+			conn_err(tconn, "Authentication of peer failed\n");
 			return -1;
 		case 0:
-			dev_err(DEV, "Authentication of peer failed, trying again.\n");
+			conn_err(tconn, "Authentication of peer failed, trying again.\n");
 			return 0;
 		}
 	}
 
-	if (drbd_request_state(mdev, NS(conn, C_WF_REPORT_PARAMS)) < SS_SUCCESS)
+	if (drbd_request_state(tconn->volume0, NS(conn, C_WF_REPORT_PARAMS)) < SS_SUCCESS)
 		return 0;
 
-	sock->sk->sk_sndtimeo = mdev->tconn->net_conf->timeout*HZ/10;
+	sock->sk->sk_sndtimeo = tconn->net_conf->timeout*HZ/10;
 	sock->sk->sk_rcvtimeo = MAX_SCHEDULE_TIMEOUT;
 
-	atomic_set(&mdev->packet_seq, 0);
-	mdev->peer_seq = 0;
-
-	drbd_thread_start(&mdev->tconn->asender);
+	drbd_thread_start(&tconn->asender);
 
-	if (drbd_send_protocol(mdev->tconn) == -1)
+	if (drbd_send_protocol(tconn) == -1)
 		return -1;
-	drbd_send_sync_param(mdev, &mdev->sync_conf);
-	drbd_send_sizes(mdev, 0, 0);
-	drbd_send_uuids(mdev);
-	drbd_send_state(mdev);
-	clear_bit(USE_DEGR_WFC_T, &mdev->flags);
-	clear_bit(RESIZE_PENDING, &mdev->flags);
-	mod_timer(&mdev->request_timer, jiffies + HZ); /* just start it here. */
 
-	return 1;
+	return !idr_for_each(&tconn->volumes, drbd_connected, tconn);
 
 out_release_sockets:
 	if (sock)
@@ -4225,7 +4229,7 @@ int drbdd_init(struct drbd_thread *thi)
 	dev_info(DEV, "receiver (re)started\n");
 
 	do {
-		h = drbd_connect(mdev);
+		h = drbd_connect(mdev->tconn);
 		if (h == 0) {
 			drbd_disconnect(mdev);
 			schedule_timeout_interruptible(HZ);
-- 
1.7.4.1

