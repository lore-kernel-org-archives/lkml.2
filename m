Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2KLI3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 03:29:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:47283 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab2KLI30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 03:29:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,761,1344236400"; 
   d="scan'208";a="218174258"
From: Joseph Gasparakis <joseph.gasparakis@intel.com>
To: davem@davemloft.net, shemminger@vyatta.com, chrisw@sous-sol.org
Cc: Joseph Gasparakis <joseph.gasparakis@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry@broadcom.com,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: [PATCH v2 2/3] vxlan: capture inner headers during encapsulation
Date: Mon, 12 Nov 2012 00:36:57 -0800
Message-Id: <1352709418-28996-3-git-send-email-joseph.gasparakis@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352709418-28996-1-git-send-email-joseph.gasparakis@intel.com>
References: <1352709418-28996-1-git-send-email-joseph.gasparakis@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populating the inner header pointers of skb for vxlan

Signed-off-by: Joseph Gasparakis <joseph.gasparakis@intel.com>
Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
---
 drivers/net/vxlan.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 030559d..14e6c8f 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -694,11 +694,23 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 	__be16 df = 0;
 	__u8 tos, ttl;
 	int err;
+	unsigned int offset;
 
 	dst = vxlan_find_dst(vxlan, skb);
 	if (!dst)
 		goto drop;
 
+	offset = skb->data - skb->head;
+
+	skb_reset_inner_mac_header(skb);
+
+	if (skb->network_header)
+		skb_set_inner_network_header(skb, skb->network_header - offset);
+
+	if (skb->transport_header)
+		skb_set_inner_transport_header(skb, skb->transport_header -
+					      offset);
+
 	/* Need space for new headers (invalidates iph ptr) */
 	if (skb_cow_head(skb, VXLAN_HEADROOM))
 		goto drop;
-- 
1.7.11.7

