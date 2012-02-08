Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab2BHVRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:17:44 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:56724 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756150Ab2BHVRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:17:42 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Jesse Gross <jesse@nicira.com>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@openvswitch.org
Subject: [PATCH 49/50] openvswitch: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:56 +0100
Message-Id: <1328735457-29986-50-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328735862;c9ebf9ff;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Reset the state to NET_ADDR_PERM as soon as the MAC get
changed via .ndo_set_mac_address.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 net/openvswitch/vport-internal_dev.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 322b8d2..c71baf0 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -67,6 +67,8 @@ static int internal_dev_mac_addr(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	if (dev->addr_assign_type & NET_ADDR_RANDOM)
+		dev->addr_assign_type ^= NET_ADDR_RANDOM;
 	return 0;
 }
 
@@ -145,7 +147,7 @@ static void do_setup(struct net_device *netdev)
 	netdev->vlan_features = netdev->features;
 	netdev->features |= NETIF_F_HW_VLAN_TX;
 	netdev->hw_features = netdev->features & ~NETIF_F_LLTX;
-	random_ether_addr(netdev->dev_addr);
+	dev_hw_addr_random(netdev, netdev->dev_addr);
 }
 
 static struct vport *internal_dev_create(const struct vport_parms *parms)
-- 
1.7.7.3

