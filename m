Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965514Ab2EOCSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:49248 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964898Ab2EOCQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:33 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 041/179] SUNRPC: Deal with the lack of a SYN_SENT sk->sk_state_change callback...
Date: Mon, 14 May 2012 22:12:17 -0400
Message-ID: <1337048075-6132-42-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fe19a96b10032035a35779f42ad59e35d6dd8ffd upstream.

The TCP connection state code depends on the state_change() callback
being called when the SYN_SENT state is set. However the networking layer
doesn't actually call us back in that case.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sunrpc/xprtsock.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 9bfb685..b502700 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1362,7 +1362,6 @@ static void xs_tcp_state_change(struct sock *sk)
 	case TCP_CLOSE_WAIT:
 		/* The server initiated a shutdown of the socket */
 		xprt_force_disconnect(xprt);
-	case TCP_SYN_SENT:
 		xprt->connect_cookie++;
 	case TCP_CLOSING:
 		/*
@@ -1824,6 +1823,7 @@ static void xs_tcp_reuse_connection(struct rpc_xprt *xprt, struct sock_xprt *tra
 static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 {
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
+	int ret = -ENOTCONN;
 
 	if (!transport->inet) {
 		struct sock *sk = sock->sk;
@@ -1855,12 +1855,22 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 	}
 
 	if (!xprt_bound(xprt))
-		return -ENOTCONN;
+		goto out;
 
 	/* Tell the socket layer to start connecting... */
 	xprt->stat.connect_count++;
 	xprt->stat.connect_start = jiffies;
-	return kernel_connect(sock, xs_addr(xprt), xprt->addrlen, O_NONBLOCK);
+	ret = kernel_connect(sock, xs_addr(xprt), xprt->addrlen, O_NONBLOCK);
+	switch (ret) {
+	case 0:
+	case -EINPROGRESS:
+		/* SYN_SENT! */
+		xprt->connect_cookie++;
+		if (xprt->reestablish_timeout < XS_TCP_INIT_REEST_TO)
+			xprt->reestablish_timeout = XS_TCP_INIT_REEST_TO;
+	}
+out:
+	return ret;
 }
 
 /**
-- 
1.7.9.6

