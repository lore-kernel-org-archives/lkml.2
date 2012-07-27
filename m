Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab2G0Ui6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 16:38:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab2G0Ui5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:38:57 -0400
Date: Fri, 27 Jul 2012 22:38:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Miller <davem@davemloft.net>
Cc: christopher.leech@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jbohac@suse.cz
Subject: [PATCH v2] tcp: perform DMA to userspace only if there is a task
 waiting for it
In-Reply-To: <20120727.133135.2017747630291360657.davem@davemloft.net>
Message-ID: <alpine.LNX.2.00.1207272237470.30412@pobox.suse.cz>
References: <alpine.LNX.2.00.1207271556320.11375@pobox.suse.cz> <20120727.133135.2017747630291360657.davem@davemloft.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 net/ipv4/tcp_input.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3e07a64..76e3bf6 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5475,7 +5475,9 @@ int tcp_rcv_established(struct sock *sk, struct sk_buff *skb,
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
Jiri Kosina
SUSE Labs
