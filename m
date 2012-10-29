Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2J2JIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:08:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26380 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab2J2JIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:08:19 -0400
Message-ID: <508E4840.40104@oracle.com>
Date: Mon, 29 Oct 2012 17:11:28 +0800
From: "zheng.li" <zheng.x.li@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: netdev@vger.kernel.org, Jay Vosburgh <fubar@us.ibm.com>,
        Andy Gospodarek <andy@greyhouse.net>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Joe Jin <joe.jin@oracle.com>, zheng.x.li@oracle.com
Subject: [PATCH] bonding: fix bond-6-mode change MAC of arp reply from vif
 to  cause Domu's network unreachable intermittently
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix for a bug in bond_alb.c
Rate of reproduced:100%
Scenario: set Dom0 to bond 6 mode, Domu communicate with Dom0 through
vif which is in bridge mode. The Dom0's bridge of xenbr0 contains vif
and bond0, bond0 contains eth0 and eth1. You can just need to ping a
host which is in same LAN on
Domu, some of packets will be lost intermittently.
Analyse: When Dom0 set bond mode to 6(alb), the bond_alb will change MAC
of every arp reply in rlb_arp_xmit function to affect receive packets,
it is ok for normal NIC, but it's wrong to Domu, when Domu send arp
reply through vif of Dom0, bond of alb replace Domu's MAC in arp reply
with NIC's MAC address, that will cause remote host send packets to Domu
using real NIC's MAC instead of Domu's MAC. Domu
can't receive the packets whose dst MAC is not Domu's MAC.

Signed-off-by: Zheng Li <zheng.x.li@oracle.com>
Cc: Jay Vosburgh <fubar@us.ibm.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/net/bonding/bond_alb.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index e15cc11..d6b134a 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -700,7 +700,18 @@ static struct slave *rlb_arp_xmit(struct sk_buff
*skb, struct bonding *bond)
 		*/
 		tx_slave = rlb_choose_channel(skb, bond);
 		if (tx_slave) {
-			memcpy(arp->mac_src,tx_slave->dev->dev_addr, ETH_ALEN);
+			struct slave *tmp_slave = NULL;
+			int i = 0, found_mac = 0;
+			bond_for_each_slave(bond, tmp_slave, i) {
+				if (ether_addr_equal_64bits(arp->mac_src,
+						tmp_slave->dev->dev_addr)) {
+					found_mac = 1;
+					break;
+				}
+			}
+			if (found_mac)
+				memcpy(arp->mac_src, tx_slave->dev->dev_addr,
+					ETH_ALEN);
 		}
 		pr_debug("Server sent ARP Reply packet\n");
 	} else if (arp->op_code == htons(ARPOP_REQUEST)) {
-- 
1.7.6.5

