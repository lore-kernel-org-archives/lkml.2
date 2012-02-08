Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab2BHVVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:21:42 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:34223 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932177Ab2BHVVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:21:39 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        "David S. Miller" <davem@davemloft.net>,
        b.a.t.m.a.n@lists.open-mesh.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 40/50] batman-adv: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:47 +0100
Message-Id: <1328735457-29986-41-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328736099;2cdab860;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Reset the state to NET_ADDR_PERM as soon as the MAC get
changed via .ndo_set_mac_address.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 net/batman-adv/soft-interface.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 987c75a..865a485 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -541,6 +541,9 @@ static int interface_set_mac_addr(struct net_device *dev, void *p)
 	}
 
 	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
+	if (dev->addr_assign_type & NET_ADDR_RANDOM)
+		dev->addr_assign_type ^= NET_ADDR_RANDOM;
+
 	return 0;
 }
 
@@ -783,7 +786,6 @@ static const struct net_device_ops bat_netdev_ops = {
 static void interface_setup(struct net_device *dev)
 {
 	struct bat_priv *priv = netdev_priv(dev);
-	char dev_addr[ETH_ALEN];
 
 	ether_setup(dev);
 
@@ -800,8 +802,7 @@ static void interface_setup(struct net_device *dev)
 	dev->hard_header_len = BAT_HEADER_LEN;
 
 	/* generate random address */
-	random_ether_addr(dev_addr);
-	memcpy(dev->dev_addr, dev_addr, ETH_ALEN);
+	dev_hw_addr_random(dev, dev->dev_addr);
 
 	SET_ETHTOOL_OPS(dev, &bat_ethtool_ops);
 
-- 
1.7.7.3

