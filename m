Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab2CMAXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:23:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:48279 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758967Ab2CMAXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Andy Chittenden <andyc.bluearc@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 125/196] SUNRPC: fix NFS client over TCP hangs due to packet loss (Bug 16494)
Date: Mon, 12 Mar 2012 20:20:38 -0400
Message-Id: <1331598109-31424-80-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Chittenden <andyc.bluearc@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 669502ff31d7dba1849aec7ee2450a3c61f57d39 upstream.

When reusing a TCP connection, ensure that it's aborted if a previous
shutdown attempt has been made on that connection so that the RPC over
TCP recovery mechanism succeeds.

Signed-off-by: Andy Chittenden <andyc.bluearc@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sunrpc/xprtsock.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index b613cb7..9bfb685 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1324,10 +1324,11 @@ static void xs_tcp_state_change(struct sock *sk)
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
@@ -1798,10 +1799,25 @@ static void xs_tcp_reuse_connection(struct rpc_xprt *xprt, struct sock_xprt *tra
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
 
-- 
1.7.9.3

