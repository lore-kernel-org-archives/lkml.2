Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab2BHVVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:21:39 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:34212 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932154Ab2BHVVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:21:37 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Patrick McHardy <kaber@trash.net>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 43/50] macvlan: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:50 +0100
Message-Id: <1328735457-29986-44-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328736096;d9e1d63d;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Reset the state to NET_ADDR_PERM as soon as the MAC get
changed via .ndo_set_mac_address.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/macvlan.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 9ea9921..bc4614e 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -373,6 +373,8 @@ static int macvlan_set_mac_address(struct net_device *dev, void *p)
 	if (!(dev->flags & IFF_UP)) {
 		/* Just copy in the new address */
 		memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
+		if (dev->addr_assign_type & NET_ADDR_RANDOM)
+			dev->addr_assign_type ^= NET_ADDR_RANDOM;
 	} else {
 		/* Rehash and update the device filters */
 		if (macvlan_addr_busy(vlan->port, addr->sa_data))
@@ -687,7 +689,7 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 		return -EINVAL;
 
 	if (!tb[IFLA_ADDRESS])
-		random_ether_addr(dev->dev_addr);
+		dev_hw_addr_random(dev, dev->dev_addr);
 
 	if (!macvlan_port_exists(lowerdev)) {
 		err = macvlan_port_create(lowerdev);
-- 
1.7.7.3

