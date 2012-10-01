Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab2JAXNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:13:33 -0400
Received: from 1wt.eu ([62.212.114.60]:35531 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab2JAXCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:18 -0400
Message-Id: <20121001225202.479114542@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 115/180] tcp: perform DMA to userspace only if there is a task waiting for it
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit 59ea33a68a9083ac98515e4861c00e71efdc49a1 ]

Back in 2006, commit 1a2449a87b ("[I/OAT]: TCP recv offload to I/OAT")
added support for receive offloading to IOAT dma engine if available.

The code in tcp_rcv_established() tries to perform early DMA copy if
applicable. It however does so without checking whether the userspace
task is actually expecting the data in the buffer.

This is not a problem under normal circumstances, but there is a corner
case where this doesn't work -- and that's when MSG_TRUNC flag to
recvmsg() is used.

If the IOAT dma engine is not used, the code properly checks whether
there is a valid ucopy.task and the socket is owned by userspace, but
misses the check in the dmaengine case.

This problem can be observed in real trivially -- for example 'tbench' is a
good reproducer, as it makes a heavy use of MSG_TRUNC. On systems utilizing
IOAT, you will soon find tbench waiting indefinitely in sk_wait_data(), as they
have been already early-copied in tcp_rcv_established() using dma engine.

This patch introduces the same check we are performing in the simple
iovec copy case to the IOAT case as well. It fixes the indefinite
recvmsg(MSG_TRUNC) hangs.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/tcp_input.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ce1ce82..4b148e5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5239,7 +5239,9 @@ int tcp_rcv_established(struct sock *sk, struct sk_buff *skb,
 			if (tp->copied_seq == tp->rcv_nxt &&
 			    len - tcp_header_len <= tp->ucopy.len) {
 #ifdef CONFIG_NET_DMA
-				if (tcp_dma_try_early_copy(sk, skb, tcp_header_len)) {
+				if (tp->ucopy.task == current &&
+				    sock_owned_by_user(sk) &&
+				    tcp_dma_try_early_copy(sk, skb, tcp_header_len)) {
 					copied_early = 1;
 					eaten = 1;
 				}
-- 
1.7.2.1.45.g54fbc



