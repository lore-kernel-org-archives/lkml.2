Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab2BQWNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:13:45 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:56105 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752807Ab2BQWNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:13:44 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Christian Benvenuti <benve@cisco.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Roopa Prabhu <roprabhu@cisco.com>,
        "David S. Miller" <davem@davemloft.net>, David Wang <dwang2@cisco.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] cisco/enic: use eth_hw_addr_random() instead of random_ether_addr()
Date: Fri, 17 Feb 2012 23:13:30 +0100
Message-Id: <1329516810-26175-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329516823;43bb9176;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_hw_addr_random() instead of calling random_ether_addr()
to set addr_assign_type correctly to NET_ADDR_RANDOM.

Reset the state to NET_ADDR_PERM as soon as the MAC get
changed via .ndo_set_mac_address.

v3: adapt to net-next
v2: use bitops, adapt to eth_hw_addr_random(), add a comment

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/cisco/enic/enic_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index dd7e24b..7dfa567 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -865,6 +865,7 @@ static int enic_set_mac_addr(struct net_device *netdev, char *addr)
 	}
 
 	memcpy(netdev->dev_addr, addr, netdev->addr_len);
+	netdev->addr_assign_type &= ~NET_ADDR_RANDOM;
 
 	return 0;
 }
@@ -1119,7 +1120,7 @@ static int enic_set_vf_port(struct net_device *netdev, int vf,
 		memcpy(pp->mac_addr, prev_pp.vf_mac, ETH_ALEN);
 
 	if (vf == PORT_SELF_VF && is_zero_ether_addr(netdev->dev_addr))
-		random_ether_addr(netdev->dev_addr);
+		eth_hw_addr_random(netdev);
 
 	err = enic_process_set_pp_request(enic, vf, &prev_pp, &restore_pp);
 	if (err) {
-- 
1.7.8.3

