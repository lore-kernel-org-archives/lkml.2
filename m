Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354Ab2JKCMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:12:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49622 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933315Ab2JKCMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:12:33 -0400
X-Sasl-enc: 3zZ6lvmfFlVwMQGeEByBPKi3xdCEr1Cr47Aie9gzlXLM 1349921551
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 28/84] tcp: flush DMA queue before sk_wait_data if rcv_wnd is zero
Date: Thu, 11 Oct 2012 11:03:12 +0900
Message-Id: <20121011015422.146118940@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: =?UTF-8?q?Michal=20Kube=C4=8Dek?= <mkubecek@suse.cz>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1592,8 +1592,14 @@ int tcp_recvmsg(struct kiocb *iocb, stru
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


