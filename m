Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab2BHVVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:21:10 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:34173 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757687Ab2BHVVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:21:08 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Solarflare linux maintainers" <linux-net-drivers@solarflare.com>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [PATCH 23/50] efx: use dev_hw_addr_random() instead of random_ether_addr()
Date: Wed,  8 Feb 2012 22:10:30 +0100
Message-Id: <1328735457-29986-24-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328736068;175facbb;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Reset the state to NET_ADDR_PERM as soon as the MAC get
changed via .ndo_set_mac_address.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/sfc/efx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index e43702f..cce339a 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -940,7 +940,7 @@ static int efx_probe_port(struct efx_nic *efx)
 			rc = -EINVAL;
 			goto err;
 		}
-		random_ether_addr(efx->net_dev->dev_addr);
+		dev_hw_addr_random(efx->net_dev, efx->net_dev->dev_addr);
 		netif_info(efx, probe, efx->net_dev,
 			   "using locally-generated MAC %pM\n",
 			   efx->net_dev->dev_addr);
@@ -1858,6 +1858,8 @@ static int efx_set_mac_address(struct net_device *net_dev, void *data)
 	}
 
 	memcpy(net_dev->dev_addr, new_addr, net_dev->addr_len);
+	if (net_dev->addr_assign_type & NET_ADDR_RANDOM)
+		net_dev->addr_assign_type ^= NET_ADDR_RANDOM;
 
 	/* Reconfigure the MAC */
 	mutex_lock(&efx->mac_lock);
-- 
1.7.7.3

