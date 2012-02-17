Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2BQPq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:46:57 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:42605 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354Ab2BQPnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:43:49 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        "David S. Miller" <davem@davemloft.net>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/10] batman-adv: use eth_hw_addr_random() instead of random_ether_addr()
Date: Fri, 17 Feb 2012 16:43:27 +0100
Message-Id: <1329493411-25750-7-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329493428;9da6cedf;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use eth_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Remove dev_addr in interface_setup(), it's not needed anymore.

Reset the state to NET_ADDR_PERM as soon as the MAC get
changed via .ndo_set_mac_address.

v2: use bitops, adapt to eth_hw_addr_random()

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 net/batman-adv/soft-interface.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 987c75a..fd1d327 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -541,6 +541,7 @@ static int interface_set_mac_addr(struct net_device *dev, void *p)
 	}
 
 	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
+	dev->addr_assign_type &= ~NET_ADDR_RANDOM;
 	return 0;
 }
 
@@ -783,7 +784,6 @@ static const struct net_device_ops bat_netdev_ops = {
 static void interface_setup(struct net_device *dev)
 {
 	struct bat_priv *priv = netdev_priv(dev);
-	char dev_addr[ETH_ALEN];
 
 	ether_setup(dev);
 
@@ -800,8 +800,7 @@ static void interface_setup(struct net_device *dev)
 	dev->hard_header_len = BAT_HEADER_LEN;
 
 	/* generate random address */
-	random_ether_addr(dev_addr);
-	memcpy(dev->dev_addr, dev_addr, ETH_ALEN);
+	eth_hw_addr_random(dev);
 
 	SET_ETHTOOL_OPS(dev, &bat_ethtool_ops);
 
-- 
1.7.8.3

