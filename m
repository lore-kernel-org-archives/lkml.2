Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688Ab2FGEZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:25:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933672Ab2FGEZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:25:20 -0400
Message-Id: <20120607041403.332034956@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:34 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [ 36/47] Revert "net: maintain namespace isolation between vlan and real device"
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 59b9997baba5242997ddc7bd96b1391f5275a5a4 ]

This reverts commit 8a83a00b0735190384a348156837918271034144.

It causes regressions for S390 devices, because it does an
unconditional DST drop on SKBs for vlans and the QETH device
needs the neighbour entry hung off the DST for certain things
on transmit.

Arnd can't remember exactly why he even needed this change.

Conflicts:

	drivers/net/macvlan.c
	net/8021q/vlan_dev.c
	net/core/dev.c

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c     |    2 +-
 include/linux/netdevice.h |    9 ---------
 net/8021q/vlan_dev.c      |    2 +-
 net/core/dev.c            |   36 +++++-------------------------------
 4 files changed, 7 insertions(+), 42 deletions(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -247,7 +247,7 @@ static int macvlan_queue_xmit(struct sk_
 
 xmit_world:
 	skb->ip_summed = ip_summed;
-	skb_set_dev(skb, vlan->lowerdev);
+	skb->dev = vlan->lowerdev;
 	return dev_queue_xmit(skb);
 }
 
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1453,15 +1453,6 @@ static inline bool netdev_uses_dsa_tags(
 	return 0;
 }
 
-#ifndef CONFIG_NET_NS
-static inline void skb_set_dev(struct sk_buff *skb, struct net_device *dev)
-{
-	skb->dev = dev;
-}
-#else /* CONFIG_NET_NS */
-void skb_set_dev(struct sk_buff *skb, struct net_device *dev);
-#endif
-
 static inline bool netdev_uses_trailer_tags(struct net_device *dev)
 {
 #ifdef CONFIG_NET_DSA_TAG_TRAILER
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -154,7 +154,7 @@ static netdev_tx_t vlan_dev_hard_start_x
 		skb = __vlan_hwaccel_put_tag(skb, vlan_tci);
 	}
 
-	skb_set_dev(skb, vlan_dev_info(dev)->real_dev);
+	skb->dev = vlan_dev_info(dev)->real_dev;
 	len = skb->len;
 	ret = dev_queue_xmit(skb);
 
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1533,10 +1533,14 @@ int dev_forward_skb(struct net_device *d
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
-	skb_set_dev(skb, dev);
+	skb->dev = dev;
+	skb_dst_drop(skb);
 	skb->tstamp.tv64 = 0;
 	skb->pkt_type = PACKET_HOST;
 	skb->protocol = eth_type_trans(skb, dev);
+	skb->mark = 0;
+	secpath_reset(skb);
+	nf_reset(skb);
 	return netif_rx(skb);
 }
 EXPORT_SYMBOL_GPL(dev_forward_skb);
@@ -1791,36 +1795,6 @@ void netif_device_attach(struct net_devi
 }
 EXPORT_SYMBOL(netif_device_attach);
 
-/**
- * skb_dev_set -- assign a new device to a buffer
- * @skb: buffer for the new device
- * @dev: network device
- *
- * If an skb is owned by a device already, we have to reset
- * all data private to the namespace a device belongs to
- * before assigning it a new device.
- */
-#ifdef CONFIG_NET_NS
-void skb_set_dev(struct sk_buff *skb, struct net_device *dev)
-{
-	skb_dst_drop(skb);
-	if (skb->dev && !net_eq(dev_net(skb->dev), dev_net(dev))) {
-		secpath_reset(skb);
-		nf_reset(skb);
-		skb_init_secmark(skb);
-		skb->mark = 0;
-		skb->priority = 0;
-		skb->nf_trace = 0;
-		skb->ipvs_property = 0;
-#ifdef CONFIG_NET_SCHED
-		skb->tc_index = 0;
-#endif
-	}
-	skb->dev = dev;
-}
-EXPORT_SYMBOL(skb_set_dev);
-#endif /* CONFIG_NET_NS */
-
 /*
  * Invalidate hardware checksum when packet is to be mangled, and
  * complete checksum manually on outgoing path.


