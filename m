Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2KGDTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 22:19:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46269 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab2KGDTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 22:19:52 -0500
From: Zheng Li <zheng.x.li@oracle.com>
To: netdev@vger.kernel.org, fubar@us.ibm.com, andy@greyhouse.net
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, joe.jin@oracle.com,
        zheng.x.li@oracle.com
Subject: [PATCH] bonding: rlb mode of bond should not alter ARP replies originating via bridge
Date: Wed,  7 Nov 2012 11:23:00 +0800
Message-Id: <1352258580-8272-1-git-send-email-zheng.x.li@oracle.com>
X-Mailer: git-send-email 1.7.6.5
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARP traffic passing through a bridge and out via the bond (when the bond is a 
port of the bridge) should not have its source MAC address adjusted by the 
receive load balance code in rlb_arp_xmit.

Signed-off-by: Zheng Li <zheng.x.li@oracle.com>
Cc: Jay Vosburgh <fubar@us.ibm.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>

---
 drivers/net/bonding/bond_alb.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index e15cc11..641b3f1 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -700,7 +700,17 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 		*/
 		tx_slave = rlb_choose_channel(skb, bond);
 		if (tx_slave) {
-			memcpy(arp->mac_src,tx_slave->dev->dev_addr, ETH_ALEN);
+			struct slave *tmp_slave = NULL;
+			int i = 0;
+			bond_for_each_slave(bond, tmp_slave, i) {
+				if (ether_addr_equal_64bits(arp->mac_src,
+						tmp_slave->dev->dev_addr)) {
+					memcpy(arp->mac_src,
+						tx_slave->dev->dev_addr,
+						ETH_ALEN);
+					break;
+				}
+			}
 		}
 		pr_debug("Server sent ARP Reply packet\n");
 	} else if (arp->op_code == htons(ARPOP_REQUEST)) {
-- 
1.7.6.5

