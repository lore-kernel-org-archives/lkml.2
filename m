Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2BHVS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:18:29 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:33978 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757543Ab2BHVS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:18:27 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 14/50] ethoc: set addr_assign_type if random_ether_addr() used
Date: Wed,  8 Feb 2012 22:10:21 +0100
Message-Id: <1328735457-29986-15-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328735907;156ca4fc;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set addr_assign_type correctly to NET_ADDR_RANDOM in case
a random MAC address was generated and assigned to the netdevice.

Reset the state to NET_ADDR_PERM as soon as the MAC get
changed via .ndo_set_mac_address.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/ethoc.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 60f0e78..4f21471 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -780,6 +780,10 @@ static int ethoc_set_mac_address(struct net_device *dev, void *addr)
 				     (mac[4] <<  8) | (mac[5] <<  0));
 	ethoc_write(priv, MAC_ADDR1, (mac[0] <<  8) | (mac[1] <<  0));
 
+	/* if device marked as NET_ADDR_RANDOM, reset it to NET_ADDR_PERM */
+	if (dev->addr_assign_type & NET_ADDR_RANDOM)
+		dev->addr_assign_type ^= NET_ADDR_RANDOM;
+
 	return 0;
 }
 
@@ -909,6 +913,7 @@ static int __devinit ethoc_probe(struct platform_device *pdev)
 	unsigned int phy;
 	int num_bd;
 	int ret = 0;
+	bool random_mac = false;
 
 	/* allocate networking device */
 	netdev = alloc_etherdev(sizeof(struct ethoc));
@@ -1050,10 +1055,14 @@ static int __devinit ethoc_probe(struct platform_device *pdev)
 
 	/* Check the MAC again for validity, if it still isn't choose and
 	 * program a random one. */
-	if (!is_valid_ether_addr(netdev->dev_addr))
+	if (!is_valid_ether_addr(netdev->dev_addr)) {
 		random_ether_addr(netdev->dev_addr);
+		random_mac = true;
+	}
 
 	ethoc_set_mac_address(netdev, netdev->dev_addr);
+	if (random_mac)
+		netdev->addr_assign_type |= NET_ADDR_RANDOM;
 
 	/* register MII bus */
 	priv->mdio = mdiobus_alloc();
-- 
1.7.7.3

