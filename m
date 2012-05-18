Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031137Ab2ERDHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:07:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40434 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762568Ab2ERCwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:31 -0400
Message-Id: <20120518023256.905701155@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tom Herbert <therbert@google.com>, Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 19/53] tcp: change tcp_adv_win_scale and tcp_rmem[2]
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b49960a05e32121d29316cfdf653894b88ac9190 ]

tcp_adv_win_scale default value is 2, meaning we expect a good citizen
skb to have skb->len / skb->truesize ratio of 75% (3/4)

In 2.6 kernels we (mis)accounted for typical MSS=1460 frame :
1536 + 64 + 256 = 1856 'estimated truesize', and 1856 * 3/4 = 1392.
So these skbs were considered as not bloated.

With recent truesize fixes, a typical MSS=1460 frame truesize is now the
more precise :
2048 + 256 = 2304. But 2304 * 3/4 = 1728.
So these skb are not good citizen anymore, because 1460 < 1728

(GRO can escape this problem because it build skbs with a too low
truesize.)

This also means tcp advertises a too optimistic window for a given
allocated rcvspace : When receiving frames, sk_rmem_alloc can hit
sk_rcvbuf limit and we call tcp_prune_queue()/tcp_collapse() too often,
especially when application is slow to drain its receive queue or in
case of losses (netperf is fast, scp is slow). This is a major latency
source.

We should adjust the len/truesize ratio to 50% instead of 75%

This patch :

1) changes tcp_adv_win_scale default to 1 instead of 2

2) increase tcp_rmem[2] limit from 4MB to 6MB to take into account
better truesize tracking and to allow autotuning tcp receive window to
reach same value than before. Note that same amount of kernel memory is
consumed compared to 2.6 kernels.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/networking/ip-sysctl.txt |    4 ++--
 net/ipv4/tcp.c                         |    9 +++++----
 net/ipv4/tcp_input.c                   |    2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 589f2da..a4399f5 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -137,7 +137,7 @@ tcp_adv_win_scale - INTEGER
 	(if tcp_adv_win_scale > 0) or bytes-bytes/2^(-tcp_adv_win_scale),
 	if it is <= 0.
 	Possible values are [-31, 31], inclusive.
-	Default: 2
+	Default: 1
 
 tcp_allowed_congestion_control - STRING
 	Show/set the congestion control choices available to non-privileged
@@ -397,7 +397,7 @@ tcp_rmem - vector of 3 INTEGERs: min, default, max
 	net.core.rmem_max.  Calling setsockopt() with SO_RCVBUF disables
 	automatic tuning of that socket's receive buffer size, in which
 	case this value is ignored.
-	Default: between 87380B and 4MB, depending on RAM size.
+	Default: between 87380B and 6MB, depending on RAM size.
 
 tcp_sack - BOOLEAN
 	Enable select acknowledgments (SACKS).
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 34f5db1..0237ad3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3216,7 +3216,7 @@ void __init tcp_init(void)
 {
 	struct sk_buff *skb = NULL;
 	unsigned long limit;
-	int i, max_share, cnt;
+	int i, max_rshare, max_wshare, cnt;
 	unsigned long jiffy = jiffies;
 
 	BUILD_BUG_ON(sizeof(struct tcp_skb_cb) > sizeof(skb->cb));
@@ -3280,15 +3280,16 @@ void __init tcp_init(void)
 
 	/* Set per-socket limits to no more than 1/128 the pressure threshold */
 	limit = ((unsigned long)sysctl_tcp_mem[1]) << (PAGE_SHIFT - 7);
-	max_share = min(4UL*1024*1024, limit);
+	max_wshare = min(4UL*1024*1024, limit);
+	max_rshare = min(6UL*1024*1024, limit);
 
 	sysctl_tcp_wmem[0] = SK_MEM_QUANTUM;
 	sysctl_tcp_wmem[1] = 16*1024;
-	sysctl_tcp_wmem[2] = max(64*1024, max_share);
+	sysctl_tcp_wmem[2] = max(64*1024, max_wshare);
 
 	sysctl_tcp_rmem[0] = SK_MEM_QUANTUM;
 	sysctl_tcp_rmem[1] = 87380;
-	sysctl_tcp_rmem[2] = max(87380, max_share);
+	sysctl_tcp_rmem[2] = max(87380, max_rshare);
 
 	printk(KERN_INFO "TCP: Hash tables configured "
 	       "(established %u bind %u)\n",
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b9c6567..06a4052 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -83,7 +83,7 @@ int sysctl_tcp_ecn __read_mostly = 2;
 EXPORT_SYMBOL(sysctl_tcp_ecn);
 int sysctl_tcp_dsack __read_mostly = 1;
 int sysctl_tcp_app_win __read_mostly = 31;
-int sysctl_tcp_adv_win_scale __read_mostly = 2;
+int sysctl_tcp_adv_win_scale __read_mostly = 1;
 EXPORT_SYMBOL(sysctl_tcp_adv_win_scale);
 
 int sysctl_tcp_stdurg __read_mostly;
-- 
1.7.10.1



