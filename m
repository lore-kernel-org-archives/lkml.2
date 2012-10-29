Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab2J2VwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:52:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:48594 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761399Ab2J2Vl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Perl <chris.perl@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 14/54] SUNRPC: Prevent races in xs_abort_connection()
Date: Mon, 29 Oct 2012 14:40:15 -0700
Message-Id: <20121029213804.371760820@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtsock.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1462,7 +1462,7 @@ static void xs_tcp_cancel_linger_timeout
 	xprt_clear_connecting(xprt);
 }
 
-static void xs_sock_mark_closed(struct rpc_xprt *xprt)
+static void xs_sock_reset_connection_flags(struct rpc_xprt *xprt)
 {
 	smp_mb__before_clear_bit();
 	clear_bit(XPRT_CONNECTION_ABORT, &xprt->state);
@@ -1470,6 +1470,11 @@ static void xs_sock_mark_closed(struct r
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
@@ -2004,10 +2009,8 @@ static void xs_abort_connection(struct s
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


