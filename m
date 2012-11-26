Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab2KZR2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:28:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48101 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231Ab2KZRN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:13:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 225/270] SUNRPC: Get rid of the xs_error_report socket callback
Date: Mon, 26 Nov 2012 14:58:35 -0200
Message-Id: <1353949160-26803-226-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/sunrpc/xprtsock.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 67c46ec..420abf8 100644
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
@@ -1558,25 +1555,6 @@ static void xs_tcp_state_change(struct sock *sk)
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
@@ -1876,7 +1854,6 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 		sk->sk_user_data = xprt;
 		sk->sk_data_ready = xs_local_data_ready;
 		sk->sk_write_space = xs_udp_write_space;
-		sk->sk_error_report = xs_error_report;
 		sk->sk_allocation = GFP_ATOMIC;
 
 		xprt_clear_connected(xprt);
@@ -1965,7 +1942,6 @@ static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_user_data = xprt;
 		sk->sk_data_ready = xs_udp_data_ready;
 		sk->sk_write_space = xs_udp_write_space;
-		sk->sk_error_report = xs_error_report;
 		sk->sk_no_check = UDP_CSUM_NORCV;
 		sk->sk_allocation = GFP_ATOMIC;
 
@@ -2079,7 +2055,6 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_data_ready = xs_tcp_data_ready;
 		sk->sk_state_change = xs_tcp_state_change;
 		sk->sk_write_space = xs_tcp_write_space;
-		sk->sk_error_report = xs_error_report;
 		sk->sk_allocation = GFP_ATOMIC;
 
 		/* socket options */
-- 
1.7.9.5

