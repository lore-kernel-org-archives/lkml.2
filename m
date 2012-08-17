Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030858Ab2HQDfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:35:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46745 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030630Ab2HQD04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:56 -0400
Message-Id: <20120817030245.473966800@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:02:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 11/37] tcp: perform DMA to userspace only if there is a task  waiting for it
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_input.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 32e6ca2..a08a621 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5415,7 +5415,9 @@ int tcp_rcv_established(struct sock *sk, struct sk_buff *skb,
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


