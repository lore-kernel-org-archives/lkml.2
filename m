Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab2JAXAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:00:03 -0400
Received: from 1wt.eu ([62.212.114.60]:35061 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570Ab2JAW76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:58 -0400
Message-Id: <20121001225201.120484500@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <shemminger@osdl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 083/180] netem: fix possible skb leak
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 116a0fc31c6c9b8fc821be5a96e5bf0b43260131 ]

skb_checksum_help(skb) can return an error, we must free skb in this
case. qdisc_drop(skb, sch) can also be feeded with a NULL skb (if
skb_unshare() failed), so lets use this generic helper.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Hemminger <shemminger@osdl.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sched/sch_netem.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 2b88295..0ae345a 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -199,12 +199,10 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 	 * do it now in software before we mangle it.
 	 */
 	if (q->corrupt && q->corrupt >= get_crandom(&q->corrupt_cor)) {
-		if (!(skb = skb_unshare(skb, GFP_ATOMIC))
-		    || (skb->ip_summed == CHECKSUM_PARTIAL
-			&& skb_checksum_help(skb))) {
-			sch->qstats.drops++;
-			return NET_XMIT_DROP;
-		}
+		if (!(skb = skb_unshare(skb, GFP_ATOMIC)) ||
+		    (skb->ip_summed == CHECKSUM_PARTIAL &&
+		     skb_checksum_help(skb)))
+			return qdisc_drop(skb, sch);
 
 		skb->data[net_random() % skb_headlen(skb)] ^= 1<<(net_random() % 8);
 	}
-- 
1.7.2.1.45.g54fbc



