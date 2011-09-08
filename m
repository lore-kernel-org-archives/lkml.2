Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742Ab1IHMpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:45:47 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37569 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686Ab1IHMpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:42 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/16] drbd: drbd_connect(): Initialize struct drbd_socket before sending anything
Date: Thu,  8 Sep 2011 14:45:29 +0200
Message-Id: <1315485937-18989-9-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_receiver.c |   66 ++++++++++++++++++-----------------
 1 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index cc236d7..830b107 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -807,7 +807,7 @@ int drbd_connected(int vnr, void *p, void *data)
  */
 static int drbd_connect(struct drbd_tconn *tconn)
 {
-	struct socket *s, *sock, *msock;
+	struct socket *sock, *msock;
 	int try, h, ok;
 
 	if (conn_request_state(tconn, NS(conn, C_WF_CONNECTION), CS_VERBOSE) < SS_SUCCESS)
@@ -818,10 +818,9 @@ static int drbd_connect(struct drbd_tconn *tconn)
 	/* Assume that the peer only understands protocol 80 until we know better.  */
 	tconn->agreed_pro_version = 80;
 
-	sock  = NULL;
-	msock = NULL;
-
 	do {
+		struct socket *s;
+
 		for (try = 0;;) {
 			/* 3 tries, this should take less than a second! */
 			s = drbd_try_connect(tconn);
@@ -832,24 +831,22 @@ static int drbd_connect(struct drbd_tconn *tconn)
 		}
 
 		if (s) {
-			if (!sock) {
-				drbd_send_fp(tconn, s, P_HAND_SHAKE_S);
-				sock = s;
-				s = NULL;
-			} else if (!msock) {
-				drbd_send_fp(tconn, s, P_HAND_SHAKE_M);
-				msock = s;
-				s = NULL;
+			if (!tconn->data.socket) {
+				tconn->data.socket = s;
+				drbd_send_fp(tconn, tconn->data.socket, P_HAND_SHAKE_S);
+			} else if (!tconn->meta.socket) {
+				tconn->meta.socket = s;
+				drbd_send_fp(tconn, tconn->meta.socket, P_HAND_SHAKE_M);
 			} else {
 				conn_err(tconn, "Logic error in drbd_connect()\n");
 				goto out_release_sockets;
 			}
 		}
 
-		if (sock && msock) {
+		if (tconn->data.socket && tconn->meta.socket) {
 			schedule_timeout_interruptible(tconn->net_conf->ping_timeo*HZ/10);
-			ok = drbd_socket_okay(&sock);
-			ok = drbd_socket_okay(&msock) && ok;
+			ok = drbd_socket_okay(&tconn->data.socket);
+			ok = drbd_socket_okay(&tconn->meta.socket) && ok;
 			if (ok)
 				break;
 		}
@@ -858,22 +855,22 @@ retry:
 		s = drbd_wait_for_connect(tconn);
 		if (s) {
 			try = drbd_recv_fp(tconn, s);
-			drbd_socket_okay(&sock);
-			drbd_socket_okay(&msock);
+			drbd_socket_okay(&tconn->data.socket);
+			drbd_socket_okay(&tconn->meta.socket);
 			switch (try) {
 			case P_HAND_SHAKE_S:
-				if (sock) {
+				if (tconn->data.socket) {
 					conn_warn(tconn, "initial packet S crossed\n");
-					sock_release(sock);
+					sock_release(tconn->data.socket);
 				}
-				sock = s;
+				tconn->data.socket = s;
 				break;
 			case P_HAND_SHAKE_M:
-				if (msock) {
+				if (tconn->meta.socket) {
 					conn_warn(tconn, "initial packet M crossed\n");
-					sock_release(msock);
+					sock_release(tconn->meta.socket);
 				}
-				msock = s;
+				tconn->meta.socket = s;
 				set_bit(DISCARD_CONCURRENT, &tconn->flags);
 				break;
 			default:
@@ -893,14 +890,17 @@ retry:
 				goto out_release_sockets;
 		}
 
-		if (sock && msock) {
-			ok = drbd_socket_okay(&sock);
-			ok = drbd_socket_okay(&msock) && ok;
+		if (tconn->data.socket && &tconn->meta.socket) {
+			ok = drbd_socket_okay(&tconn->data.socket);
+			ok = drbd_socket_okay(&tconn->meta.socket) && ok;
 			if (ok)
 				break;
 		}
 	} while (1);
 
+	sock  = tconn->data.socket;
+	msock = tconn->meta.socket;
+
 	msock->sk->sk_reuse = 1; /* SO_REUSEADDR */
 	sock->sk->sk_reuse = 1; /* SO_REUSEADDR */
 
@@ -926,8 +926,6 @@ retry:
 	drbd_tcp_nodelay(sock);
 	drbd_tcp_nodelay(msock);
 
-	tconn->data.socket = sock;
-	tconn->meta.socket = msock;
 	tconn->last_received = jiffies;
 
 	h = drbd_do_handshake(tconn);
@@ -960,10 +958,14 @@ retry:
 	return !idr_for_each(&tconn->volumes, drbd_connected, tconn);
 
 out_release_sockets:
-	if (sock)
-		sock_release(sock);
-	if (msock)
-		sock_release(msock);
+	if (tconn->data.socket) {
+		sock_release(tconn->data.socket);
+		tconn->data.socket = NULL;
+	}
+	if (tconn->meta.socket) {
+		sock_release(tconn->meta.socket);
+		tconn->meta.socket = NULL;
+	}
 	return -1;
 }
 
-- 
1.7.4.1

