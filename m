Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab2KZRBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:01:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47116 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab2KZRB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:01:29 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 027/270] SUNRPC: Ensure that the TCP socket is closed when in CLOSE_WAIT
Date: Mon, 26 Nov 2012 14:55:17 -0200
Message-Id: <1353949160-26803-28-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit a519fc7a70d1a918574bb826cc6905b87b482eb9 upstream.

Instead of doing a shutdown() call, we need to do an actual close().
Ditto if/when the server is sending us junk RPC headers.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/sunrpc/xprtsock.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index b88c6bf..00ff343 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1028,6 +1028,16 @@ static void xs_udp_data_ready(struct sock *sk, int len)
 	read_unlock_bh(&sk->sk_callback_lock);
 }
 
+/*
+ * Helper function to force a TCP close if the server is sending
+ * junk and/or it has put us in CLOSE_WAIT
+ */
+static void xs_tcp_force_close(struct rpc_xprt *xprt)
+{
+	set_bit(XPRT_CONNECTION_CLOSE, &xprt->state);
+	xprt_force_disconnect(xprt);
+}
+
 static inline void xs_tcp_read_fraghdr(struct rpc_xprt *xprt, struct xdr_skb_reader *desc)
 {
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
@@ -1054,7 +1064,7 @@ static inline void xs_tcp_read_fraghdr(struct rpc_xprt *xprt, struct xdr_skb_rea
 	/* Sanity check of the record length */
 	if (unlikely(transport->tcp_reclen < 8)) {
 		dprintk("RPC:       invalid TCP record fragment length\n");
-		xprt_force_disconnect(xprt);
+		xs_tcp_force_close(xprt);
 		return;
 	}
 	dprintk("RPC:       reading TCP record fragment of length %d\n",
@@ -1135,7 +1145,7 @@ static inline void xs_tcp_read_calldir(struct sock_xprt *transport,
 		break;
 	default:
 		dprintk("RPC:       invalid request message type\n");
-		xprt_force_disconnect(&transport->xprt);
+		xs_tcp_force_close(&transport->xprt);
 	}
 	xs_tcp_check_fraghdr(transport);
 }
@@ -1458,6 +1468,8 @@ static void xs_tcp_cancel_linger_timeout(struct rpc_xprt *xprt)
 static void xs_sock_mark_closed(struct rpc_xprt *xprt)
 {
 	smp_mb__before_clear_bit();
+	clear_bit(XPRT_CONNECTION_ABORT, &xprt->state);
+	clear_bit(XPRT_CONNECTION_CLOSE, &xprt->state);
 	clear_bit(XPRT_CLOSE_WAIT, &xprt->state);
 	clear_bit(XPRT_CLOSING, &xprt->state);
 	smp_mb__after_clear_bit();
@@ -1515,8 +1527,8 @@ static void xs_tcp_state_change(struct sock *sk)
 		break;
 	case TCP_CLOSE_WAIT:
 		/* The server initiated a shutdown of the socket */
-		xprt_force_disconnect(xprt);
 		xprt->connect_cookie++;
+		xs_tcp_force_close(xprt);
 	case TCP_CLOSING:
 		/*
 		 * If the server closed down the connection, make sure that
@@ -2159,8 +2171,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 		/* We're probably in TIME_WAIT. Get rid of existing socket,
 		 * and retry
 		 */
-		set_bit(XPRT_CONNECTION_CLOSE, &xprt->state);
-		xprt_force_disconnect(xprt);
+		xs_tcp_force_close(xprt);
 		break;
 	case -ECONNREFUSED:
 	case -ECONNRESET:
-- 
1.7.9.5

