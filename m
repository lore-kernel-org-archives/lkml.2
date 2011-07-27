Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1G0Afj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:35:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:48912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab1G0Af2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="34855907"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: andyc.bluearc@gmail.com, Trond.Myklebust@netapp.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] [35/98] SUNRPC: fix NFS client over TCP hangs due to packet loss (Bug 16494)
Message-Id: <20110727003527.940292403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andy Chittenden <andyc.bluearc@gmail.com>

commit 669502ff31d7dba1849aec7ee2450a3c61f57d39 upstream.

When reusing a TCP connection, ensure that it's aborted if a previous
shutdown attempt has been made on that connection so that the RPC over
TCP recovery mechanism succeeds.

Signed-off-by: Andy Chittenden <andyc.bluearc@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/sunrpc/xprtsock.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

Index: linux-2.6.35.y/net/sunrpc/xprtsock.c
===================================================================
--- linux-2.6.35.y.orig/net/sunrpc/xprtsock.c
+++ linux-2.6.35.y/net/sunrpc/xprtsock.c
@@ -1307,10 +1307,11 @@ static void xs_tcp_state_change(struct s
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
@@ -1781,10 +1782,25 @@ static void xs_tcp_reuse_connection(stru
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
 
