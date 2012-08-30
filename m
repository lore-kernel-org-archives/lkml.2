Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2H3CTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 22:19:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54192 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753638Ab2H3CTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 22:19:52 -0400
X-Sasl-enc: qlCITnU2EmG/jUUseyLrcpKiGKf1c98NaQ/M+fGpuOJQ 1346293192
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH] 6lowpan: Make a copy of skb's delivered to 6lowpan
Date: Wed, 29 Aug 2012 22:19:27 -0400
Message-Id: <1346293168-26498-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since lowpan_process_data() modifies the skb (by calling skb_pull()), we
need our own copy so that it doesn't affect the data received by other
protcols (in this case, af_ieee802154).

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/ieee802154/6lowpan.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index 6a09522..ce33b02 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -1133,6 +1133,8 @@ static int lowpan_validate(struct nlattr *tb[], struct nlattr *data[])
 static int lowpan_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct packet_type *pt, struct net_device *orig_dev)
 {
+	struct sk_buff *local_skb;
+
 	if (!netif_running(dev))
 		goto drop;
 
@@ -1144,7 +1146,12 @@ static int lowpan_rcv(struct sk_buff *skb, struct net_device *dev,
 	case LOWPAN_DISPATCH_IPHC:	/* ipv6 datagram */
 	case LOWPAN_DISPATCH_FRAG1:	/* first fragment header */
 	case LOWPAN_DISPATCH_FRAGN:	/* next fragments headers */
-		lowpan_process_data(skb);
+		local_skb = skb_copy(skb, GFP_ATOMIC);
+		if (!local_skb)
+			goto drop;
+		lowpan_process_data(local_skb);
+
+		kfree_skb(skb);
 		break;
 	default:
 		break;
-- 
1.7.0.4

