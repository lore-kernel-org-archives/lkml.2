Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab0C3X2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:28:17 -0400
Received: from kroah.org ([198.145.64.141]:46772 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932616Ab0C3XVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:55 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:50 2010
Message-Id: <20100330224849.710018086@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Steven J. Magnani" <steve@digidescorp.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [137/156] NET_DMA: free skbs periodically
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven J. Magnani <steve@digidescorp.com>

[ Upstream commit 73852e8151b7d7a529fbe019ab6d2d0c02d8f3f2 ]

Under NET_DMA, data transfer can grind to a halt when userland issues a
large read on a socket with a high RCVLOWAT (i.e., 512 KB for both).
This appears to be because the NET_DMA design queues up lots of memcpy
operations, but doesn't issue or wait for them (and thus free the
associated skbs) until it is time for tcp_recvmesg() to return.
The socket hangs when its TCP window goes to zero before enough data is
available to satisfy the read.

Periodically issue asynchronous memcpy operations, and free skbs for ones
that have completed, to prevent sockets from going into zero-window mode.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp.c |   63 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 20 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1254,6 +1254,39 @@ static void tcp_prequeue_process(struct
 	tp->ucopy.memory = 0;
 }
 
+#ifdef CONFIG_NET_DMA
+static void tcp_service_net_dma(struct sock *sk, bool wait)
+{
+	dma_cookie_t done, used;
+	dma_cookie_t last_issued;
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (!tp->ucopy.dma_chan)
+		return;
+
+	last_issued = tp->ucopy.dma_cookie;
+	dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
+
+	do {
+		if (dma_async_memcpy_complete(tp->ucopy.dma_chan,
+					      last_issued, &done,
+					      &used) == DMA_SUCCESS) {
+			/* Safe to free early-copied skbs now */
+			__skb_queue_purge(&sk->sk_async_wait_queue);
+			break;
+		} else {
+			struct sk_buff *skb;
+			while ((skb = skb_peek(&sk->sk_async_wait_queue)) &&
+			       (dma_async_is_complete(skb->dma_cookie, done,
+						      used) == DMA_SUCCESS)) {
+				__skb_dequeue(&sk->sk_async_wait_queue);
+				kfree_skb(skb);
+			}
+		}
+	} while (wait);
+}
+#endif
+
 static inline struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
 {
 	struct sk_buff *skb;
@@ -1546,6 +1579,10 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 			/* __ Set realtime policy in scheduler __ */
 		}
 
+#ifdef CONFIG_NET_DMA
+		if (tp->ucopy.dma_chan)
+			dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
+#endif
 		if (copied >= target) {
 			/* Do not sleep, just process backlog. */
 			release_sock(sk);
@@ -1554,6 +1591,7 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 			sk_wait_data(sk, &timeo);
 
 #ifdef CONFIG_NET_DMA
+		tcp_service_net_dma(sk, false);  /* Don't block */
 		tp->ucopy.wakeup = 0;
 #endif
 
@@ -1633,6 +1671,9 @@ do_prequeue:
 						copied = -EFAULT;
 					break;
 				}
+
+				dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
+
 				if ((offset + used) == skb->len)
 					copied_early = 1;
 
@@ -1702,27 +1743,9 @@ skip_copy:
 	}
 
 #ifdef CONFIG_NET_DMA
-	if (tp->ucopy.dma_chan) {
-		dma_cookie_t done, used;
-
-		dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
-
-		while (dma_async_memcpy_complete(tp->ucopy.dma_chan,
-						 tp->ucopy.dma_cookie, &done,
-						 &used) == DMA_IN_PROGRESS) {
-			/* do partial cleanup of sk_async_wait_queue */
-			while ((skb = skb_peek(&sk->sk_async_wait_queue)) &&
-			       (dma_async_is_complete(skb->dma_cookie, done,
-						      used) == DMA_SUCCESS)) {
-				__skb_dequeue(&sk->sk_async_wait_queue);
-				kfree_skb(skb);
-			}
-		}
+	tcp_service_net_dma(sk, true);  /* Wait for queue to drain */
+	tp->ucopy.dma_chan = NULL;
 
-		/* Safe to free early-copied skbs now */
-		__skb_queue_purge(&sk->sk_async_wait_queue);
-		tp->ucopy.dma_chan = NULL;
-	}
 	if (tp->ucopy.pinned_list) {
 		dma_unpin_iovec_pages(tp->ucopy.pinned_list);
 		tp->ucopy.pinned_list = NULL;


