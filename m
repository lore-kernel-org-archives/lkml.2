Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2J1X1v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:27:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41998 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756532Ab2J1X1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:42 -0400
Message-Id: <20121028231559.221965031@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:48 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Chris Perl <chris.perl@gmail.com>
Subject: [ 072/105] SUNRPC: Prevent races in xs_abort_connection()
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

commit 4bc1e68ed6a8b59be8a79eb719be515a55c7bc68 upstream.

The call to xprt_disconnect_done() that is triggered by a successful
connection reset will trigger another automatic wakeup of all tasks
on the xprt->pending rpc_wait_queue. In particular it will cause an
early wake up of the task that called xprt_connect().

All we really want to do here is clear all the socket-specific state
flags, so we split that functionality out of xs_sock_mark_closed()
into a helper that can be called by xs_abort_connection()

Reported-by: Chris Perl <chris.perl@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Chris Perl <chris.perl@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/xprtsock.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 7e2dd0d..1f105c2 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1453,7 +1453,7 @@ static void xs_tcp_cancel_linger_timeout(struct rpc_xprt *xprt)
 	xprt_clear_connecting(xprt);
 }
 
-static void xs_sock_mark_closed(struct rpc_xprt *xprt)
+static void xs_sock_reset_connection_flags(struct rpc_xprt *xprt)
 {
 	smp_mb__before_clear_bit();
 	clear_bit(XPRT_CONNECTION_ABORT, &xprt->state);
@@ -1461,6 +1461,11 @@ static void xs_sock_mark_closed(struct rpc_xprt *xprt)
 	clear_bit(XPRT_CLOSE_WAIT, &xprt->state);
 	clear_bit(XPRT_CLOSING, &xprt->state);
 	smp_mb__after_clear_bit();
+}
+
+static void xs_sock_mark_closed(struct rpc_xprt *xprt)
+{
+	xs_sock_reset_connection_flags(xprt);
 	/* Mark transport as closed and wake up all pending tasks */
 	xprt_disconnect_done(xprt);
 }
@@ -2051,10 +2056,8 @@ static void xs_abort_connection(struct sock_xprt *transport)
 	any.sa_family = AF_UNSPEC;
 	result = kernel_connect(transport->sock, &any, sizeof(any), 0);
 	if (!result)
-		xs_sock_mark_closed(&transport->xprt);
-	else
-		dprintk("RPC:       AF_UNSPEC connect return code %d\n",
-				result);
+		xs_sock_reset_connection_flags(&transport->xprt);
+	dprintk("RPC:       AF_UNSPEC connect return code %d\n", result);
 }
 
 static void xs_tcp_reuse_connection(struct sock_xprt *transport)


