Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab0FBWbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:31:00 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:43597
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932601Ab0FBWa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:30:59 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2010 18:30:59 EDT
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next-2.6 PATCH 1/2] skbuff: add check for non-linear to
	warn_if_lro and needs_linearize
To: davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       gospo@redhat.com, Alexander Duyck <alexander.h.duyck@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 02 Jun 2010 15:24:37 -0700
Message-ID: <20100602222230.12962.97260.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>

We can avoid an unecessary cache miss by checking if the skb is non-linear
before accessing gso_size/gso_type in skb_warn_if_lro, the same can also be
done to avoid a cache miss on nr_frags if data_len is 0.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 include/linux/skbuff.h |    3 ++-
 net/core/dev.c         |    7 ++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bf243fc..645e78d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2129,7 +2129,8 @@ static inline bool skb_warn_if_lro(const struct sk_buff *skb)
 	/* LRO sets gso_size but not gso_type, whereas if GSO is really
 	 * wanted then gso_type will be set. */
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
-	if (shinfo->gso_size != 0 && unlikely(shinfo->gso_type == 0)) {
+	if (skb_is_nonlinear(skb) && shinfo->gso_size != 0 &&
+	    unlikely(shinfo->gso_type == 0)) {
 		__skb_warn_lro_forwarding(skb);
 		return true;
 	}
diff --git a/net/core/dev.c b/net/core/dev.c
index d03470f..9f7c407 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2080,9 +2080,10 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 static inline int skb_needs_linearize(struct sk_buff *skb,
 				      struct net_device *dev)
 {
-	return (skb_has_frags(skb) && !(dev->features & NETIF_F_FRAGLIST)) ||
-	       (skb_shinfo(skb)->nr_frags && (!(dev->features & NETIF_F_SG) ||
-					      illegal_highdma(dev, skb)));
+	return skb_is_nonlinear(skb) &&
+	       ((skb_has_frags(skb) && !(dev->features & NETIF_F_FRAGLIST)) ||
+	        (skb_shinfo(skb)->nr_frags && (!(dev->features & NETIF_F_SG) ||
+					      illegal_highdma(dev, skb))));
 }
 
 /**

