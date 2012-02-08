Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab2BHVUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:20:30 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:34080 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291Ab2BHVU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:20:26 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephen Hemminger <shemminger@vyatta.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 10/50] Calxeda XGMAC: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:17 +0100
Message-Id: <1328735457-29986-11-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328736026;35568180;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Reset the state to NET_ADDR_PERM as soon as the MAC get
changed via .ndo_set_mac_address.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/calxeda/xgmac.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 1fce186..dedaaf0 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1012,7 +1012,7 @@ static int xgmac_open(struct net_device *dev)
 	 * address using the following linux command:
 	 *      ifconfig eth0 hw ether xx:xx:xx:xx:xx:xx  */
 	if (!is_valid_ether_addr(dev->dev_addr)) {
-		random_ether_addr(dev->dev_addr);
+		dev_hw_addr_random(dev, dev->dev_addr);
 		netdev_dbg(priv->dev, "generated random MAC address %pM\n",
 			dev->dev_addr);
 	}
@@ -1483,6 +1483,8 @@ static int xgmac_set_mac_address(struct net_device *dev, void *p)
 		return -EADDRNOTAVAIL;
 
 	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	if (dev->addr_assign_type & NET_ADDR_RANDOM)
+		dev->addr_assign_type ^= NET_ADDR_RANDOM;
 
 	xgmac_set_mac_addr(ioaddr, dev->dev_addr, 0);
 
-- 
1.7.7.3

