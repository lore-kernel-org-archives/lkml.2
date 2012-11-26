Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2KZSGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:06:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47380 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab2KZRE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:04:28 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 076/270] libceph: rename socket callbacks
Date: Mon, 26 Nov 2012 14:56:06 -0200
Message-Id: <1353949160-26803-77-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 327800bdc2cb9b71f4b458ca07aa9d522668dde0 upstream.

Change the names of the three socket callback functions to make it
more obvious they're specifically associated with a connection's
socket (not the ceph connection that uses it).

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 18f69a8..5fb9937 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -153,46 +153,46 @@ EXPORT_SYMBOL(ceph_msgr_flush);
  */
 
 /* data available on socket, or listen socket received a connect */
-static void ceph_data_ready(struct sock *sk, int count_unused)
+static void ceph_sock_data_ready(struct sock *sk, int count_unused)
 {
 	struct ceph_connection *con = sk->sk_user_data;
 
 	if (sk->sk_state != TCP_CLOSE_WAIT) {
-		dout("ceph_data_ready on %p state = %lu, queueing work\n",
+		dout("%s on %p state = %lu, queueing work\n", __func__,
 		     con, con->state);
 		queue_con(con);
 	}
 }
 
 /* socket has buffer space for writing */
-static void ceph_write_space(struct sock *sk)
+static void ceph_sock_write_space(struct sock *sk)
 {
 	struct ceph_connection *con = sk->sk_user_data;
 
 	/* only queue to workqueue if there is data we want to write,
 	 * and there is sufficient space in the socket buffer to accept
-	 * more data.  clear SOCK_NOSPACE so that ceph_write_space()
+	 * more data.  clear SOCK_NOSPACE so that ceph_sock_write_space()
 	 * doesn't get called again until try_write() fills the socket
 	 * buffer. See net/ipv4/tcp_input.c:tcp_check_space()
 	 * and net/core/stream.c:sk_stream_write_space().
 	 */
 	if (test_bit(WRITE_PENDING, &con->state)) {
 		if (sk_stream_wspace(sk) >= sk_stream_min_wspace(sk)) {
-			dout("ceph_write_space %p queueing write work\n", con);
+			dout("%s %p queueing write work\n", __func__, con);
 			clear_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 			queue_con(con);
 		}
 	} else {
-		dout("ceph_write_space %p nothing to write\n", con);
+		dout("%s %p nothing to write\n", __func__, con);
 	}
 }
 
 /* socket's state has changed */
-static void ceph_state_change(struct sock *sk)
+static void ceph_sock_state_change(struct sock *sk)
 {
 	struct ceph_connection *con = sk->sk_user_data;
 
-	dout("ceph_state_change %p state = %lu sk_state = %u\n",
+	dout("%s %p state = %lu sk_state = %u\n", __func__,
 	     con, con->state, sk->sk_state);
 
 	if (test_bit(CLOSED, &con->state))
@@ -200,9 +200,9 @@ static void ceph_state_change(struct sock *sk)
 
 	switch (sk->sk_state) {
 	case TCP_CLOSE:
-		dout("ceph_state_change TCP_CLOSE\n");
+		dout("%s TCP_CLOSE\n", __func__);
 	case TCP_CLOSE_WAIT:
-		dout("ceph_state_change TCP_CLOSE_WAIT\n");
+		dout("%s TCP_CLOSE_WAIT\n", __func__);
 		if (test_and_set_bit(SOCK_CLOSED, &con->state) == 0) {
 			if (test_bit(CONNECTING, &con->state))
 				con->error_msg = "connection failed";
@@ -212,7 +212,7 @@ static void ceph_state_change(struct sock *sk)
 		}
 		break;
 	case TCP_ESTABLISHED:
-		dout("ceph_state_change TCP_ESTABLISHED\n");
+		dout("%s TCP_ESTABLISHED\n", __func__);
 		queue_con(con);
 		break;
 	default:	/* Everything else is uninteresting */
@@ -228,9 +228,9 @@ static void set_sock_callbacks(struct socket *sock,
 {
 	struct sock *sk = sock->sk;
 	sk->sk_user_data = con;
-	sk->sk_data_ready = ceph_data_ready;
-	sk->sk_write_space = ceph_write_space;
-	sk->sk_state_change = ceph_state_change;
+	sk->sk_data_ready = ceph_sock_data_ready;
+	sk->sk_write_space = ceph_sock_write_space;
+	sk->sk_state_change = ceph_sock_state_change;
 }
 
 
-- 
1.7.9.5

