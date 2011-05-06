Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab1EFAwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:52:08 -0400
Received: from kroah.org ([198.145.64.141]:36894 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab1EFAZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:11 2011
Message-Id: <20110506002211.912837948@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Chittenden <andyc.bluearc@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [068/143] SUNRPC: fix NFS client over TCP hangs due to packet loss (Bug 16494)
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Andy Chittenden <andyc.bluearc@gmail.com>

commit 669502ff31d7dba1849aec7ee2450a3c61f57d39 upstream.

When reusing a TCP connection, ensure that it's aborted if a previous
shutdown attempt has been made on that connection so that the RPC over
TCP recovery mechanism succeeds.

Signed-off-by: Andy Chittenden <andyc.bluearc@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sunrpc/xprtsock.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1343,10 +1343,11 @@ static void xs_tcp_state_change(struct s
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
@@ -1817,10 +1818,25 @@ static void xs_tcp_reuse_connection(stru
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
 


