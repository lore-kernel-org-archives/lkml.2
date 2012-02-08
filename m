Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab2BHVV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:21:58 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:34271 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932236Ab2BHVVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:21:54 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        "Ricardo Ribalda Delgado" <ricardo.ribalda@gmail.com>,
        Thomas Meyer <thomas@m3y3r.de>,
        Richard Cochran <richard.cochran@omicron.at>
Subject: [PATCH 34/50] xilinx ll_temac: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:41 +0100
Message-Id: <1328735457-29986-35-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328736113;72c3bb07;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Reset the state to NET_ADDR_PERM as soon as the MAC get
changed via .ndo_set_mac_address.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index f21addb..d687620 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -322,12 +322,19 @@ out:
 static int temac_set_mac_address(struct net_device *ndev, void *address)
 {
 	struct temac_local *lp = netdev_priv(ndev);
+	bool set_random = false;
 
 	if (address)
 		memcpy(ndev->dev_addr, address, ETH_ALEN);
 
-	if (!is_valid_ether_addr(ndev->dev_addr))
-		random_ether_addr(ndev->dev_addr);
+	if (!is_valid_ether_addr(ndev->dev_addr)) {
+		dev_hw_addr_random(ndev, ndev->dev_addr);
+		set_random = true;
+	}
+	if (!set_random) {
+		if (ndev->addr_assign_type & NET_ADDR_RANDOM)
+			ndev->addr_assign_type ^= NET_ADDR_RANDOM;
+	}
 
 	/* set up unicast MAC address filter set its mac address */
 	mutex_lock(&lp->indirect_mutex);
-- 
1.7.7.3

