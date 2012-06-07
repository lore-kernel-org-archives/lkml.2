Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702Ab2FGEZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:25:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54880 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933672Ab2FGEZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:25:29 -0400
Message-Id: <20120607041403.602442970@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:36 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 38/47] skb: avoid unnecessary reallocations in __skb_cow
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1633,8 +1633,6 @@ static inline int __skb_cow(struct sk_bu
 {
 	int delta = 0;
 
-	if (headroom < NET_SKB_PAD)
-		headroom = NET_SKB_PAD;
 	if (headroom > skb_headroom(skb))
 		delta = headroom - skb_headroom(skb);
 


