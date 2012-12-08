Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813Ab2LHAGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:06:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:52956 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab2LHAGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:06:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,241,1355126400"; 
   d="scan'208";a="230560358"
From: Joseph Gasparakis <joseph.gasparakis@intel.com>
To: davem@davemloft.net, shemminger@vyatta.com, chrisw@sous-sol.org,
        gospo@redhat.com
Cc: Alexander Duyck <alexander.h.duyck@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry@broadcom.com,
        saeed.bishara@gmail.com, bhutchings@solarflare.com
Subject: [PATCH v4 2/5] net: Handle encapsulated offloads before fragmentation or handing to lower dev
Date: Fri,  7 Dec 2012 16:14:15 -0800
Message-Id: <1354925658-24115-3-git-send-email-joseph.gasparakis@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354925658-24115-1-git-send-email-joseph.gasparakis@intel.com>
References: <1354925658-24115-1-git-send-email-joseph.gasparakis@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>

This change allows the VXLAN to enable Tx checksum offloading even on
devices that do not support encapsulated checksum offloads. The
advantage to this is that it allows for the lower device to change due
to routing table changes without impacting features on the VXLAN itself.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 net/core/dev.c       | 15 +++++++++++++--
 net/ipv4/ip_output.c |  4 ++++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 307142a..a4c4a1b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2324,6 +2324,13 @@ int dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 			skb->vlan_tci = 0;
 		}
 
+		/* If encapsulation offload request, verify we are testing
+		 * hardware encapsulation features instead of standard
+		 * features for the netdev
+		 */
+		if (skb->encapsulation)
+			features &= dev->hw_enc_features;
+
 		if (netif_needs_gso(skb, features)) {
 			if (unlikely(dev_gso_segment(skb, features)))
 				goto out_kfree_skb;
@@ -2339,8 +2346,12 @@ int dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 			 * checksumming here.
 			 */
 			if (skb->ip_summed == CHECKSUM_PARTIAL) {
-				skb_set_transport_header(skb,
-					skb_checksum_start_offset(skb));
+				if (skb->encapsulation)
+					skb_set_inner_transport_header(skb,
+						skb_checksum_start_offset(skb));
+				else
+					skb_set_transport_header(skb,
+						skb_checksum_start_offset(skb));
 				if (!(features & NETIF_F_ALL_CSUM) &&
 				     skb_checksum_help(skb))
 					goto out_kfree_skb;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 6537a40..3e98ed2 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -595,6 +595,10 @@ slow_path_clean:
 	}
 
 slow_path:
+	/* for offloaded checksums cleanup checksum before fragmentation */
+	if ((skb->ip_summed == CHECKSUM_PARTIAL) && skb_checksum_help(skb))
+		goto fail;
+
 	left = skb->len - hlen;		/* Space per frame */
 	ptr = hlen;		/* Where to start from */
 
-- 
1.7.11.7

