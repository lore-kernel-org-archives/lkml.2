Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1G0Vsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:46879 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487Ab1G0Vsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826318"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: Trond.Myklebust@netapp.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [31/99] SUNRPC: Deal with the lack of a SYN_SENT sk->sk_state_change
Message-Id: <20110727214829.D8FE32403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit fe19a96b10032035a35779f42ad59e35d6dd8ffd upstream.

The TCP connection state code depends on the state_change() callback
being called when the SYN_SENT state is set. However the networking layer
doesn't actually call us back in that case.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/sunrpc/xprtsock.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/net/sunrpc/xprtsock.c
===================================================================
--- linux-2.6.35.y.orig/net/sunrpc/xprtsock.c
+++ linux-2.6.35.y/net/sunrpc/xprtsock.c
@@ -1345,7 +1345,6 @@ static void xs_tcp_state_change(struct s
 	case TCP_CLOSE_WAIT:
 		/* The server initiated a shutdown of the socket */
 		xprt_force_disconnect(xprt);
-	case TCP_SYN_SENT:
 		xprt->connect_cookie++;
 	case TCP_CLOSING:
 		/*
@@ -1807,6 +1806,7 @@ static void xs_tcp_reuse_connection(stru
 static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 {
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
+	int ret = -ENOTCONN;
 
 	if (!transport->inet) {
 		struct sock *sk = sock->sk;
@@ -1838,12 +1838,22 @@ static int xs_tcp_finish_connecting(stru
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
