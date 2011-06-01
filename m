Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163110Ab1FAI2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:28:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163151Ab1FAI2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:28:39 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:23 2011
Message-Id: <20110601081223.220595354@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:12:03 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [153/165] SUNRPC: Deal with the lack of a SYN_SENT sk->sk_state_change
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 callback...
Content-Length: 1759
Lines: 59

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit fe19a96b10032035a35779f42ad59e35d6dd8ffd upstream.

The TCP connection state code depends on the state_change() callback
being called when the SYN_SENT state is set. However the networking layer
doesn't actually call us back in that case.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/xprtsock.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1344,7 +1344,6 @@ static void xs_tcp_state_change(struct s
 	case TCP_CLOSE_WAIT:
 		/* The server initiated a shutdown of the socket */
 		xprt_force_disconnect(xprt);
-	case TCP_SYN_SENT:
 		xprt->connect_cookie++;
 	case TCP_CLOSING:
 		/*
@@ -1758,6 +1757,7 @@ static void xs_tcp_reuse_connection(stru
 static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 {
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
+	int ret = -ENOTCONN;
 
 	if (!transport->inet) {
 		struct sock *sk = sock->sk;
@@ -1789,12 +1789,22 @@ static int xs_tcp_finish_connecting(stru
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


