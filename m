Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945911Ab2LGB5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:57:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:7305 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422905Ab2LGB5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:57:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,234,1355126400"; 
   d="scan'208";a="230119286"
From: Joseph Gasparakis <joseph.gasparakis@intel.com>
To: davem@davemloft.net, shemminger@vyatta.com, chrisw@sous-sol.org,
        gospo@redhat.com
Cc: Joseph Gasparakis <joseph.gasparakis@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexander.h.duyck@intel.com,
        peter.p.waskiewicz.jr@intel.com
Subject: [PATCH] vxlan: Add capability of Rx checksum offload for inner packet
Date: Thu,  6 Dec 2012 18:05:53 -0800
Message-Id: <1354845953-23424-1-git-send-email-joseph.gasparakis@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds capability in vxlan to identify received
checksummed inner packets and signal them to the upper layers of
the stack. The driver needs to set the skb->encapsulation bit
and also set the skb->ip_summed to CHECKSUM_UNNECESSARY.

Signed-off-by: Joseph Gasparakis <joseph.gasparakis@intel.com>
---
 drivers/net/vxlan.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 88b31f2..cf0231d 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -607,7 +607,12 @@ static int vxlan_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 
 	__skb_tunnel_rx(skb, vxlan->dev);
 	skb_reset_network_header(skb);
-	skb->ip_summed = CHECKSUM_NONE;
+
+	if (skb->ip_summed != CHECKSUM_UNNECESSARY || !skb->encapsulation ||
+	    !(vxlan->dev->features & NETIF_F_RXCSUM))
+		skb->ip_summed = CHECKSUM_NONE;
+
+	skb->encapsulation = 0;
 
 	err = IP_ECN_decapsulate(oip, skb);
 	if (unlikely(err)) {
@@ -1175,7 +1180,9 @@ static void vxlan_setup(struct net_device *dev)
 	dev->features	|= NETIF_F_LLTX;
 	dev->features	|= NETIF_F_NETNS_LOCAL;
 	dev->features	|= NETIF_F_SG | NETIF_F_HW_CSUM;
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM;
+	dev->features   |= NETIF_F_RXCSUM;
+
+	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
 	dev->priv_flags	&= ~IFF_XMIT_DST_RELEASE;
 
 	spin_lock_init(&vxlan->hash_lock);
-- 
1.7.6.4

