Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab2KZRN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:13:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48097 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941Ab2KZRNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:13:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 224/270] SUNRPC: Prevent races in xs_abort_connection()
Date: Mon, 26 Nov 2012 14:58:34 -0200
Message-Id: <1353949160-26803-225-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/sunrpc/xprtsock.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index a3f1990..67c46ec 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1465,7 +1465,7 @@ static void xs_tcp_cancel_linger_timeout(struct rpc_xprt *xprt)
 	xprt_clear_connecting(xprt);
 }
 
-static void xs_sock_mark_closed(struct rpc_xprt *xprt)
+static void xs_sock_reset_connection_flags(struct rpc_xprt *xprt)
 {
 	smp_mb__before_clear_bit();
 	clear_bit(XPRT_CONNECTION_ABORT, &xprt->state);
@@ -1473,6 +1473,11 @@ static void xs_sock_mark_closed(struct rpc_xprt *xprt)
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
@@ -2028,10 +2033,8 @@ static void xs_abort_connection(struct sock_xprt *transport)
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
-- 
1.7.9.5

