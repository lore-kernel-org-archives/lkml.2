Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760495Ab2EJReh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:34:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52483 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760343Ab2EJRed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:33 -0400
Message-Id: <20120510173134.935895399@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <shemminger@osdl.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 23/52] netem: fix possible skb leak
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
---
 net/sched/sch_netem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -408,10 +408,8 @@ static int netem_enqueue(struct sk_buff
 	if (q->corrupt && q->corrupt >= get_crandom(&q->corrupt_cor)) {
 		if (!(skb = skb_unshare(skb, GFP_ATOMIC)) ||
 		    (skb->ip_summed == CHECKSUM_PARTIAL &&
-		     skb_checksum_help(skb))) {
-			sch->qstats.drops++;
-			return NET_XMIT_DROP;
-		}
+		     skb_checksum_help(skb)))
+			return qdisc_drop(skb, sch);
 
 		skb->data[net_random() % skb_headlen(skb)] ^= 1<<(net_random() % 8);
 	}


