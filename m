Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761944Ab2FHFTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:19:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43303 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759226Ab2FHFHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:24 -0400
Message-Id: <20120608041850.672629064@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 73/82] skb: avoid unnecessary reallocations in __skb_cow
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

[ Upstream commit 617c8c11236716dcbda877e764b7bf37c6fd8063 ]

At the beginning of __skb_cow, headroom gets set to a minimum of
NET_SKB_PAD. This causes unnecessary reallocations if the buffer was not
cloned and the headroom is just below NET_SKB_PAD, but still more than the
amount requested by the caller.
This was showing up frequently in my tests on VLAN tx, where
vlan_insert_tag calls skb_cow_head(skb, VLAN_HLEN).

Locally generated packets should have enough headroom, and for forward
paths, we already have NET_SKB_PAD bytes of headroom, so we don't need to
add any extra space here.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/skbuff.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e689b47..bdb4590 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1866,8 +1866,6 @@ static inline int __skb_cow(struct sk_buff *skb, unsigned int headroom,
 {
 	int delta = 0;
 
-	if (headroom < NET_SKB_PAD)
-		headroom = NET_SKB_PAD;
 	if (headroom > skb_headroom(skb))
 		delta = headroom - skb_headroom(skb);
 


