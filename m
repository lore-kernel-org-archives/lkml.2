Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2KLI3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 03:29:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:54312 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab2KLI30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 03:29:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,761,1344236400"; 
   d="scan'208";a="218174261"
From: Joseph Gasparakis <joseph.gasparakis@intel.com>
To: davem@davemloft.net, shemminger@vyatta.com, chrisw@sous-sol.org
Cc: Joseph Gasparakis <joseph.gasparakis@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry@broadcom.com,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: [PATCH v2 3/3] ipgre: capture inner headers during encapsulation
Date: Mon, 12 Nov 2012 00:36:58 -0800
Message-Id: <1352709418-28996-4-git-send-email-joseph.gasparakis@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352709418-28996-1-git-send-email-joseph.gasparakis@intel.com>
References: <1352709418-28996-1-git-send-email-joseph.gasparakis@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populating the inner header pointers of skb for ipgre
This patch has been compile-tested only.

Signed-off-by: Joseph Gasparakis <joseph.gasparakis@intel.com>
Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
---
 net/ipv4/ip_gre.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 7240f8e..e35ed52 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -766,8 +766,10 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 	int    gre_hlen;
 	__be32 dst;
 	int    mtu;
+	unsigned int offset;
 
-	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	if (!(skb->dev->features & NETIF_F_HW_CSUM_ENC_BIT) &&
+	    skb->ip_summed == CHECKSUM_PARTIAL &&
 	    skb_checksum_help(skb))
 		goto tx_error;
 
@@ -902,6 +904,17 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 			tunnel->err_count = 0;
 	}
 
+	offset = skb->data - skb->head;
+
+	skb_reset_inner_mac_header(skb);
+
+	if (skb->network_header)
+		skb_set_inner_network_header(skb, skb->network_header - offset);
+
+	if (skb->transport_header)
+		skb_set_inner_transport_header(skb, skb->transport_header -
+					       offset);
+
 	max_headroom = LL_RESERVED_SPACE(tdev) + gre_hlen + rt->dst.header_len;
 
 	if (skb_headroom(skb) < max_headroom || skb_shared(skb)||
-- 
1.7.11.7

