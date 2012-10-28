Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2J1Xle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:41:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42008 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756741Ab2J1X1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:45 -0400
Message-Id: <20121028231559.531583035@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:49 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Chris Perl <chris.perl@gmail.com>
Subject: [ 073/105] SUNRPC: Get rid of the xs_error_report socket callback
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit f878b657ce8e7d3673afe48110ec208a29e38c4a upstream.

Chris Perl reports that we're seeing races between the wakeup call in
xs_error_report and the connect attempts. Basically, Chris has shown
that in certain circumstances, the call to xs_error_report causes the
rpc_task that is responsible for reconnecting to wake up early, thus
triggering a disconnect and retry.

Since the sk->sk_error_report() calls in the socket layer are always
followed by a tcp_done() in the cases where we care about waking up
the rpc_tasks, just let the state_change callbacks take responsibility
for those wake ups.

Reported-by: Chris Perl <chris.perl@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Chris Perl <chris.perl@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/xprtsock.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 1f105c2..75853ca 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -254,7 +254,6 @@ struct sock_xprt {
 	void			(*old_data_ready)(struct sock *, int);
 	void			(*old_state_change)(struct sock *);
 	void			(*old_write_space)(struct sock *);
-	void			(*old_error_report)(struct sock *);
 };
 
 /*
@@ -781,7 +780,6 @@ static void xs_save_old_callbacks(struct sock_xprt *transport, struct sock *sk)
 	transport->old_data_ready = sk->sk_data_ready;
 	transport->old_state_change = sk->sk_state_change;
 	transport->old_write_space = sk->sk_write_space;
-	transport->old_error_report = sk->sk_error_report;
 }
 
 static void xs_restore_old_callbacks(struct sock_xprt *transport, struct sock *sk)
@@ -789,7 +787,6 @@ static void xs_restore_old_callbacks(struct sock_xprt *transport, struct sock *s
 	sk->sk_data_ready = transport->old_data_ready;
 	sk->sk_state_change = transport->old_state_change;
 	sk->sk_write_space = transport->old_write_space;
-	sk->sk_error_report = transport->old_error_report;
 }
 
 static void xs_reset_transport(struct sock_xprt *transport)
@@ -1546,25 +1543,6 @@ static void xs_tcp_state_change(struct sock *sk)
 	read_unlock_bh(&sk->sk_callback_lock);
 }
 
-/**
- * xs_error_report - callback mainly for catching socket errors
- * @sk: socket
- */
-static void xs_error_report(struct sock *sk)
-{
-	struct rpc_xprt *xprt;
-
-	read_lock_bh(&sk->sk_callback_lock);
-	if (!(xprt = xprt_from_sock(sk)))
-		goto out;
-	dprintk("RPC:       %s client %p...\n"
-			"RPC:       error %d\n",
-			__func__, xprt, sk->sk_err);
-	xprt_wake_pending_tasks(xprt, -EAGAIN);
-out:
-	read_unlock_bh(&sk->sk_callback_lock);
-}
-
 static void xs_write_space(struct sock *sk)
 {
 	struct socket *sock;
@@ -1864,7 +1842,6 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 		sk->sk_user_data = xprt;
 		sk->sk_data_ready = xs_local_data_ready;
 		sk->sk_write_space = xs_udp_write_space;
-		sk->sk_error_report = xs_error_report;
 		sk->sk_allocation = GFP_ATOMIC;
 
 		xprt_clear_connected(xprt);
@@ -1989,7 +1966,6 @@ static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_user_data = xprt;
 		sk->sk_data_ready = xs_udp_data_ready;
 		sk->sk_write_space = xs_udp_write_space;
-		sk->sk_error_report = xs_error_report;
 		sk->sk_no_check = UDP_CSUM_NORCV;
 		sk->sk_allocation = GFP_ATOMIC;
 
@@ -2102,7 +2078,6 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_data_ready = xs_tcp_data_ready;
 		sk->sk_state_change = xs_tcp_state_change;
 		sk->sk_write_space = xs_tcp_write_space;
-		sk->sk_error_report = xs_error_report;
 		sk->sk_allocation = GFP_ATOMIC;
 
 		/* socket options */


