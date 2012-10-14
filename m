Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2JNOtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:49:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46751 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932415Ab2JNOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:15 -0400
Message-Id: <20121014143538.707089299@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Simon Kirby <sim@hostway.ca>
Subject: [ 036/147] SUNRPC: Ensure that the TCP socket is closed when in CLOSE_WAIT
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit a519fc7a70d1a918574bb826cc6905b87b482eb9 upstream.

Instead of doing a shutdown() call, we need to do an actual close().
Ditto if/when the server is sending us junk RPC headers.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/xprtsock.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index a35b8e5..d1988cf 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1025,6 +1025,16 @@ static void xs_udp_data_ready(struct sock *sk, int len)
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
@@ -1051,7 +1061,7 @@ static inline void xs_tcp_read_fraghdr(struct rpc_xprt *xprt, struct xdr_skb_rea
 	/* Sanity check of the record length */
 	if (unlikely(transport->tcp_reclen < 8)) {
 		dprintk("RPC:       invalid TCP record fragment length\n");
-		xprt_force_disconnect(xprt);
+		xs_tcp_force_close(xprt);
 		return;
 	}
 	dprintk("RPC:       reading TCP record fragment of length %d\n",
@@ -1132,7 +1142,7 @@ static inline void xs_tcp_read_calldir(struct sock_xprt *transport,
 		break;
 	default:
 		dprintk("RPC:       invalid request message type\n");
-		xprt_force_disconnect(&transport->xprt);
+		xs_tcp_force_close(&transport->xprt);
 	}
 	xs_tcp_check_fraghdr(transport);
 }
@@ -1455,6 +1465,8 @@ static void xs_tcp_cancel_linger_timeout(struct rpc_xprt *xprt)
 static void xs_sock_mark_closed(struct rpc_xprt *xprt)
 {
 	smp_mb__before_clear_bit();
+	clear_bit(XPRT_CONNECTION_ABORT, &xprt->state);
+	clear_bit(XPRT_CONNECTION_CLOSE, &xprt->state);
 	clear_bit(XPRT_CLOSE_WAIT, &xprt->state);
 	clear_bit(XPRT_CLOSING, &xprt->state);
 	smp_mb__after_clear_bit();
@@ -1512,8 +1524,8 @@ static void xs_tcp_state_change(struct sock *sk)
 		break;
 	case TCP_CLOSE_WAIT:
 		/* The server initiated a shutdown of the socket */
-		xprt_force_disconnect(xprt);
 		xprt->connect_cookie++;
+		xs_tcp_force_close(xprt);
 	case TCP_CLOSING:
 		/*
 		 * If the server closed down the connection, make sure that
@@ -2199,8 +2211,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 		/* We're probably in TIME_WAIT. Get rid of existing socket,
 		 * and retry
 		 */
-		set_bit(XPRT_CONNECTION_CLOSE, &xprt->state);
-		xprt_force_disconnect(xprt);
+		xs_tcp_force_close(xprt);
 		break;
 	case -ECONNREFUSED:
 	case -ECONNRESET:


