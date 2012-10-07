Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2JGXWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:22:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38168 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771Ab2JGXV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:21:59 -0400
Message-Id: <20121007225847.410655726@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Michal=20Kube=C4=8Dek?= <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 092/108] tcp: flush DMA queue before sk_wait_data if rcv_wnd is  zero
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Kubeček <mkubecek@suse.cz>

[ Upstream commit 15c041759bfcd9ab0a4e43f1c16e2644977d0467 ]

If recv() syscall is called for a TCP socket so that
  - IOAT DMA is used
  - MSG_WAITALL flag is used
  - requested length is bigger than sk_rcvbuf
  - enough data has already arrived to bring rcv_wnd to zero
then when tcp_recvmsg() gets to calling sk_wait_data(), receive
window can be still zero while sk_async_wait_queue exhausts
enough space to keep it zero. As this queue isn't cleaned until
the tcp_service_net_dma() call, sk_wait_data() cannot receive
any data and blocks forever.

If zero receive window and non-empty sk_async_wait_queue is
detected before calling sk_wait_data(), process the queue first.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 043d49b..7397ad8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1589,8 +1589,14 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		}
 
 #ifdef CONFIG_NET_DMA
-		if (tp->ucopy.dma_chan)
-			dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
+		if (tp->ucopy.dma_chan) {
+			if (tp->rcv_wnd == 0 &&
+			    !skb_queue_empty(&sk->sk_async_wait_queue)) {
+				tcp_service_net_dma(sk, true);
+				tcp_cleanup_rbuf(sk, copied);
+			} else
+				dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
+		}
 #endif
 		if (copied >= target) {
 			/* Do not sleep, just process backlog. */


