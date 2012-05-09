Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab2EIGOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:14:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38945 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754346Ab2EIFx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:29 -0400
Message-Id: <20120509055041.832065815@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 087/167] [PATCH 26/26] tcp: fix TCP_MAXSEG for established IPv6 passive
 sockets
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit d135c522f1234f62e81be29cebdf59e9955139ad ]

Commit f5fff5d forgot to fix TCP_MAXSEG behavior IPv6 sockets, so IPv6
TCP server sockets that used TCP_MAXSEG would find that the advmss of
child sockets would be incorrect. This commit mirrors the advmss logic
from tcp_v4_syn_recv_sock in tcp_v6_syn_recv_sock. Eventually this
logic should probably be shared between IPv4 and IPv6, but this at
least fixes this issue.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/tcp_ipv6.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index b859e4a..4a56574 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1494,6 +1494,10 @@ static struct sock * tcp_v6_syn_recv_sock(struct sock *sk, struct sk_buff *skb,
 	tcp_mtup_init(newsk);
 	tcp_sync_mss(newsk, dst_mtu(dst));
 	newtp->advmss = dst_metric_advmss(dst);
+	if (tcp_sk(sk)->rx_opt.user_mss &&
+	    tcp_sk(sk)->rx_opt.user_mss < newtp->advmss)
+		newtp->advmss = tcp_sk(sk)->rx_opt.user_mss;
+
 	tcp_initialize_rcv_mss(newsk);
 	if (tcp_rsk(req)->snt_synack)
 		tcp_valid_rtt_meas(newsk,
-- 
1.7.10



