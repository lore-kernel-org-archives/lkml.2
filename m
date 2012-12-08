Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965290Ab2LHAHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:07:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:52956 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab2LHAGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:06:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,241,1355126400"; 
   d="scan'208";a="230560362"
From: Joseph Gasparakis <joseph.gasparakis@intel.com>
To: davem@davemloft.net, shemminger@vyatta.com, chrisw@sous-sol.org,
        gospo@redhat.com
Cc: Joseph Gasparakis <joseph.gasparakis@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry@broadcom.com,
        saeed.bishara@gmail.com, bhutchings@solarflare.com,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v4 3/5] vxlan: capture inner headers during encapsulation
Date: Fri,  7 Dec 2012 16:14:16 -0800
Message-Id: <1354925658-24115-4-git-send-email-joseph.gasparakis@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354925658-24115-1-git-send-email-joseph.gasparakis@intel.com>
References: <1354925658-24115-1-git-send-email-joseph.gasparakis@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow VXLAN to make use of Tx checksum offloading and Tx scatter-gather.
The advantage to these two changes is that it also allows the VXLAN to
make use of GSO.

Signed-off-by: Joseph Gasparakis <joseph.gasparakis@intel.com>
Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 drivers/net/vxlan.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index ce77b8b..88b31f2 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -876,6 +876,11 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto drop;
 	}
 
+	if (!skb->encapsulation) {
+		skb_reset_inner_headers(skb);
+		skb->encapsulation = 1;
+	}
+
 	/* Need space for new headers (invalidates iph ptr) */
 	if (skb_cow_head(skb, VXLAN_HEADROOM))
 		goto drop;
@@ -947,7 +952,8 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 	vxlan_set_owner(dev, skb);
 
 	/* See iptunnel_xmit() */
-	skb->ip_summed = CHECKSUM_NONE;
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		skb->ip_summed = CHECKSUM_NONE;
 	ip_select_ident(iph, &rt->dst, NULL);
 
 	err = ip_local_out(skb);
@@ -1168,6 +1174,8 @@ static void vxlan_setup(struct net_device *dev)
 	dev->tx_queue_len = 0;
 	dev->features	|= NETIF_F_LLTX;
 	dev->features	|= NETIF_F_NETNS_LOCAL;
+	dev->features	|= NETIF_F_SG | NETIF_F_HW_CSUM;
+	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM;
 	dev->priv_flags	&= ~IFF_XMIT_DST_RELEASE;
 
 	spin_lock_init(&vxlan->hash_lock);
-- 
1.7.11.7

