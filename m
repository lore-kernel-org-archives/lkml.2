Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2IAP5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 11:57:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33941 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974Ab2IAP5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 11:57:18 -0400
X-Sasl-enc: h/NUQxUSz8839y7nNRcz1UYTFp43HY6oIQvkIXmimCBW 1346515038
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Cheneau <tony.cheneau@amnesiak.org>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v3 1/2] 6lowpan: Make a copy of skb's delivered to 6lowpan
Date: Sat,  1 Sep 2012 11:57:06 -0400
Message-Id: <1346515027-5237-2-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1346294341-26808-1-git-send-email-alan@signal11.us>
References: <1346294341-26808-1-git-send-email-alan@signal11.us>
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
index 6a09522..b28ec79 100644
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
+		local_skb = skb_clone(skb, GFP_ATOMIC);
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

