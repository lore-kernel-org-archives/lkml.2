Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab2BEWt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:49:29 -0500
Received: from 1wt.eu ([62.212.114.60]:61835 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab2BEW0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:11 -0500
Message-Id: <20120205220950.046728731@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:03 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andy Chittenden <andyc.bluearc@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 14/91] SUNRPC: fix NFS client over TCP hangs due to packet loss (Bug 16494)
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 669502ff31d7dba1849aec7ee2450a3c61f57d39 upstream.

When reusing a TCP connection, ensure that it's aborted if a previous
shutdown attempt has been made on that connection so that the RPC over
TCP recovery mechanism succeeds.

Signed-off-by: Andy Chittenden <andyc.bluearc@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sunrpc/xprtsock.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

Index: longterm-2.6.27/net/sunrpc/xprtsock.c
===================================================================
--- longterm-2.6.27.orig/net/sunrpc/xprtsock.c	2012-02-05 22:34:34.580914949 +0100
+++ longterm-2.6.27/net/sunrpc/xprtsock.c	2012-02-05 22:34:36.898916728 +0100
@@ -1126,10 +1126,11 @@
 	if (!(xprt = xprt_from_sock(sk)))
 		goto out;
 	dprintk("RPC:       xs_tcp_state_change client %p...\n", xprt);
-	dprintk("RPC:       state %x conn %d dead %d zapped %d\n",
+	dprintk("RPC:       state %x conn %d dead %d zapped %d sk_shutdown %d\n",
 			sk->sk_state, xprt_connected(xprt),
 			sock_flag(sk, SOCK_DEAD),
-			sock_flag(sk, SOCK_ZAPPED));
+			sock_flag(sk, SOCK_ZAPPED),
+			sk->sk_shutdown);
 
 	switch (sk->sk_state) {
 	case TCP_ESTABLISHED:
@@ -1594,10 +1595,25 @@
 {
 	unsigned int state = transport->inet->sk_state;
 
-	if (state == TCP_CLOSE && transport->sock->state == SS_UNCONNECTED)
-		return;
-	if ((1 << state) & (TCPF_ESTABLISHED|TCPF_SYN_SENT))
-		return;
+	if (state == TCP_CLOSE && transport->sock->state == SS_UNCONNECTED) {
+		/* we don't need to abort the connection if the socket
+		 * hasn't undergone a shutdown
+		 */
+		if (transport->inet->sk_shutdown == 0)
+			return;
+		dprintk("RPC:       %s: TCP_CLOSEd and sk_shutdown set to %d\n",
+				__func__, transport->inet->sk_shutdown);
+	}
+	if ((1 << state) & (TCPF_ESTABLISHED|TCPF_SYN_SENT)) {
+		/* we don't need to abort the connection if the socket
+		 * hasn't undergone a shutdown
+		 */
+		if (transport->inet->sk_shutdown == 0)
+			return;
+		dprintk("RPC:       %s: ESTABLISHED/SYN_SENT "
+				"sk_shutdown set to %d\n",
+				__func__, transport->inet->sk_shutdown);
+	}
 	xs_abort_connection(xprt, transport);
 }
 


