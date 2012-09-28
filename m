Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031934Ab2I1ULq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:11:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2I1Sxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:53:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 002/262] net: Allow driver to limit number of GSO segments per skb
Date: Fri, 28 Sep 2012 11:48:51 -0700
Message-Id: <20120928182958.286039688@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 30b678d844af3305cda5953467005cebb5d7b687 ]

A peer (or local user) may cause TCP to use a nominal MSS of as little
as 88 (actual MSS of 76 with timestamps).  Given that we have a
sufficiently prodigious local sender and the peer ACKs quickly enough,
it is nevertheless possible to grow the window for such a connection
to the point that we will try to send just under 64K at once.  This
results in a single skb that expands to 861 segments.

In some drivers with TSO support, such an skb will require hundreds of
DMA descriptors; a substantial fraction of a TX ring or even more than
a full ring.  The TX queue selected for the skb may stall and trigger
the TX watchdog repeatedly (since the problem skb will be retried
after the TX reset).  This particularly affects sfc, for which the
issue is designated as CVE-2012-3412.

Therefore:
1. Add the field net_device::gso_max_segs holding the device-specific
   limit.
2. In netif_skb_features(), if the number of segments is too high then
   mask out GSO features to force fall back to software GSO.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    2 ++
 net/core/dev.c            |    4 ++++
 2 files changed, 6 insertions(+)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1301,6 +1301,8 @@ struct net_device {
 	/* for setting kernel sock attribute on TCP connection setup */
 #define GSO_MAX_SIZE		65536
 	unsigned int		gso_max_size;
+#define GSO_MAX_SEGS		65535
+	u16			gso_max_segs;
 
 #ifdef CONFIG_DCB
 	/* Data Center Bridging netlink ops */
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2119,6 +2119,9 @@ netdev_features_t netif_skb_features(str
 	__be16 protocol = skb->protocol;
 	netdev_features_t features = skb->dev->features;
 
+	if (skb_shinfo(skb)->gso_segs > skb->dev->gso_max_segs)
+		features &= ~NETIF_F_GSO_MASK;
+
 	if (protocol == htons(ETH_P_8021Q)) {
 		struct vlan_ethhdr *veh = (struct vlan_ethhdr *)skb->data;
 		protocol = veh->h_vlan_encapsulated_proto;
@@ -5911,6 +5914,7 @@ struct net_device *alloc_netdev_mqs(int
 	dev_net_set(dev, &init_net);
 
 	dev->gso_max_size = GSO_MAX_SIZE;
+	dev->gso_max_segs = GSO_MAX_SEGS;
 
 	INIT_LIST_HEAD(&dev->napi_list);
 	INIT_LIST_HEAD(&dev->unreg_list);


