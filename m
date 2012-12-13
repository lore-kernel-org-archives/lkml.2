Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab2LMO3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:29:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088Ab2LMOLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Zumbiehl <florz@florz.de>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 178/241] vlan: don't deliver frames for unknown vlans to protocols
Date: Thu, 13 Dec 2012 11:59:03 -0200
Message-Id: <1355407206-17100-179-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Zumbiehl <florz@florz.de>

commit 48cc32d38a52d0b68f91a171a8d00531edc6a46e upstream.

6a32e4f9dd9219261f8856f817e6655114cfec2f made the vlan code skip marking
vlan-tagged frames for not locally configured vlans as PACKET_OTHERHOST if
there was an rx_handler, as the rx_handler could cause the frame to be received
on a different (virtual) vlan-capable interface where that vlan might be
configured.

As rx_handlers do not necessarily return RX_HANDLER_ANOTHER, this could cause
frames for unknown vlans to be delivered to the protocol stack as if they had
been received untagged.

For example, if an ipv6 router advertisement that's tagged for a locally not
configured vlan is received on an interface with macvlan interfaces attached,
macvlan's rx_handler returns RX_HANDLER_PASS after delivering the frame to the
macvlan interfaces, which caused it to be passed to the protocol stack, leading
to ipv6 addresses for the announced prefix being configured even though those
are completely unusable on the underlying interface.

The fix moves marking as PACKET_OTHERHOST after the rx_handler so the
rx_handler, if there is one, sees the frame unchanged, but afterwards,
before the frame is delivered to the protocol stack, it gets marked whether
there is an rx_handler or not.

Signed-off-by: Florian Zumbiehl <florz@florz.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ herton: adjust context from 3.6 patch, same as patch for 3.4 ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/if_vlan.h |    8 ++++----
 net/8021q/vlan_core.c   |   10 ++--------
 net/core/dev.c          |    7 +++++--
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index a810987..561e130 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -82,6 +82,8 @@ static inline int is_vlan_dev(struct net_device *dev)
 }
 
 #define vlan_tx_tag_present(__skb)	((__skb)->vlan_tci & VLAN_TAG_PRESENT)
+#define vlan_tx_nonzero_tag_present(__skb) \
+	(vlan_tx_tag_present(__skb) && ((__skb)->vlan_tci & VLAN_VID_MASK))
 #define vlan_tx_tag_get(__skb)		((__skb)->vlan_tci & ~VLAN_TAG_PRESENT)
 
 #if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
@@ -91,7 +93,7 @@ extern struct net_device *__vlan_find_dev_deep(struct net_device *real_dev,
 extern struct net_device *vlan_dev_real_dev(const struct net_device *dev);
 extern u16 vlan_dev_vlan_id(const struct net_device *dev);
 
-extern bool vlan_do_receive(struct sk_buff **skb, bool last_handler);
+extern bool vlan_do_receive(struct sk_buff **skb);
 extern struct sk_buff *vlan_untag(struct sk_buff *skb);
 
 extern int vlan_vid_add(struct net_device *dev, unsigned short vid);
@@ -120,10 +122,8 @@ static inline u16 vlan_dev_vlan_id(const struct net_device *dev)
 	return 0;
 }
 
-static inline bool vlan_do_receive(struct sk_buff **skb, bool last_handler)
+static inline bool vlan_do_receive(struct sk_buff **skb)
 {
-	if (((*skb)->vlan_tci & VLAN_VID_MASK) && last_handler)
-		(*skb)->pkt_type = PACKET_OTHERHOST;
 	return false;
 }
 
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 830059d..fe29a64 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -5,7 +5,7 @@
 #include <linux/export.h>
 #include "vlan.h"
 
-bool vlan_do_receive(struct sk_buff **skbp, bool last_handler)
+bool vlan_do_receive(struct sk_buff **skbp)
 {
 	struct sk_buff *skb = *skbp;
 	u16 vlan_id = skb->vlan_tci & VLAN_VID_MASK;
@@ -13,14 +13,8 @@ bool vlan_do_receive(struct sk_buff **skbp, bool last_handler)
 	struct vlan_pcpu_stats *rx_stats;
 
 	vlan_dev = vlan_find_dev(skb->dev, vlan_id);
-	if (!vlan_dev) {
-		/* Only the last call to vlan_do_receive() should change
-		 * pkt_type to PACKET_OTHERHOST
-		 */
-		if (vlan_id && last_handler)
-			skb->pkt_type = PACKET_OTHERHOST;
+	if (!vlan_dev)
 		return false;
-	}
 
 	skb = *skbp = skb_share_check(skb, GFP_ATOMIC);
 	if (unlikely(!skb))
diff --git a/net/core/dev.c b/net/core/dev.c
index 8b3dee5..4ef7993 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3206,18 +3206,18 @@ another_round:
 ncls:
 #endif
 
-	rx_handler = rcu_dereference(skb->dev->rx_handler);
 	if (vlan_tx_tag_present(skb)) {
 		if (pt_prev) {
 			ret = deliver_skb(skb, pt_prev, orig_dev);
 			pt_prev = NULL;
 		}
-		if (vlan_do_receive(&skb, !rx_handler))
+		if (vlan_do_receive(&skb))
 			goto another_round;
 		else if (unlikely(!skb))
 			goto out;
 	}
 
+	rx_handler = rcu_dereference(skb->dev->rx_handler);
 	if (rx_handler) {
 		if (pt_prev) {
 			ret = deliver_skb(skb, pt_prev, orig_dev);
@@ -3237,6 +3237,9 @@ ncls:
 		}
 	}
 
+	if (vlan_tx_nonzero_tag_present(skb))
+		skb->pkt_type = PACKET_OTHERHOST;
+
 	/* deliver only exact match when indicated */
 	null_or_dev = deliver_exact ? skb->dev : NULL;
 
-- 
1.7.9.5

