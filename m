Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2KOJo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:44:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34924 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab2KOJoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:44:24 -0500
From: Zheng Li <zheng.x.li@oracle.com>
To: netdev@vger.kernel.org, fubar@us.ibm.com, andy@greyhouse.net
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, joe.jin@oracle.com,
        zheng.x.li@oracle.com
Subject: [PATCH] bonding: rlb mode of bond should not alter ARP originating via bridge
Date: Thu, 15 Nov 2012 17:47:41 +0800
Message-Id: <1352972861-17577-1-git-send-email-zheng.x.li@oracle.com>
X-Mailer: git-send-email 1.7.6.5
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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
 drivers/net/bonding/bond_alb.c |    6 ++++++
 drivers/net/bonding/bonding.h  |   13 +++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index e15cc11..75f6f0d 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -694,6 +694,12 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 	struct arp_pkt *arp = arp_pkt(skb);
 	struct slave *tx_slave = NULL;
 
+	/* Only modify ARP's MAC if it originates locally;
+	 * don't change ARPs arriving via a bridge.
+	 */
+	if (!bond_slave_has_mac(bond, arp->mac_src))
+		return NULL;
+
 	if (arp->op_code == htons(ARPOP_REPLY)) {
 		/* the arp must be sent on the selected
 		* rx channel
diff --git a/drivers/net/bonding/bonding.h b/drivers/net/bonding/bonding.h
index f8af2fc..6dded56 100644
--- a/drivers/net/bonding/bonding.h
+++ b/drivers/net/bonding/bonding.h
@@ -22,6 +22,7 @@
 #include <linux/in6.h>
 #include <linux/netpoll.h>
 #include <linux/inetdevice.h>
+#include <linux/etherdevice.h>
 #include "bond_3ad.h"
 #include "bond_alb.h"
 
@@ -450,6 +451,18 @@ static inline void bond_destroy_proc_dir(struct bond_net *bn)
 }
 #endif
 
+static inline struct slave *bond_slave_has_mac(struct bonding *bond,
+					       const u8 *mac)
+{
+	int i = 0;
+	struct slave *tmp;
+
+	bond_for_each_slave(bond, tmp, i)
+		if (ether_addr_equal_64bits(mac, tmp->dev->dev_addr))
+			return tmp;
+
+	return NULL;
+}
 
 /* exported from bond_main.c */
 extern int bond_net_id;
-- 
1.7.6.5

