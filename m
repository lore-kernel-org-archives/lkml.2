Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab2BAVK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:10:58 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58926 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932676Ab2BAVKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:47 -0500
X-Sasl-enc: 5ndmKulEBjXnj6nxui2VbUgwzSSlD7WLT2VIRr7yrY/U 1328130646
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:50 2012
Message-Id: <20120201210050.292249052@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Narendra K <Narendra_K@Dell.com>,
        Jiri Bohac <jbohac@suse.cz>, Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [73/89] bonding: fix enslaving in alb mode when link down
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jiri Bohac <jbohac@suse.cz>

[ Upstream commit b924551bed09f61b64f21bffe241afc5526b091a ]

bond_alb_init_slave() is called from bond_enslave() and sets the slave's MAC
address. This is done differently for TLB and ALB modes.
bond->alb_info.rlb_enabled is used to discriminate between the two modes but
this flag may be uninitialized if the slave is being enslaved prior to calling
bond_open() -> bond_alb_initialize() on the master.

It turns out all the callers of alb_set_slave_mac_addr() pass
bond->alb_info.rlb_enabled as the hw parameter.

This patch cleans up the unnecessary parameter of alb_set_slave_mac_addr() and
makes the function decide based on the bonding mode instead, which fixes the
above problem.

Reported-by: Narendra K <Narendra_K@Dell.com>
Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_alb.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -871,16 +871,12 @@ static void alb_send_learning_packets(st
 	}
 }
 
-/* hw is a boolean parameter that determines whether we should try and
- * set the hw address of the device as well as the hw address of the
- * net_device
- */
-static int alb_set_slave_mac_addr(struct slave *slave, u8 addr[], int hw)
+static int alb_set_slave_mac_addr(struct slave *slave, u8 addr[])
 {
 	struct net_device *dev = slave->dev;
 	struct sockaddr s_addr;
 
-	if (!hw) {
+	if (slave->bond->params.mode == BOND_MODE_TLB) {
 		memcpy(dev->dev_addr, addr, dev->addr_len);
 		return 0;
 	}
@@ -910,8 +906,8 @@ static void alb_swap_mac_addr(struct bon
 	u8 tmp_mac_addr[ETH_ALEN];
 
 	memcpy(tmp_mac_addr, slave1->dev->dev_addr, ETH_ALEN);
-	alb_set_slave_mac_addr(slave1, slave2->dev->dev_addr, bond->alb_info.rlb_enabled);
-	alb_set_slave_mac_addr(slave2, tmp_mac_addr, bond->alb_info.rlb_enabled);
+	alb_set_slave_mac_addr(slave1, slave2->dev->dev_addr);
+	alb_set_slave_mac_addr(slave2, tmp_mac_addr);
 
 }
 
@@ -1058,8 +1054,7 @@ static int alb_handle_addr_collision_on_
 
 		/* Try setting slave mac to bond address and fall-through
 		   to code handling that situation below... */
-		alb_set_slave_mac_addr(slave, bond->dev->dev_addr,
-				       bond->alb_info.rlb_enabled);
+		alb_set_slave_mac_addr(slave, bond->dev->dev_addr);
 	}
 
 	/* The slave's address is equal to the address of the bond.
@@ -1095,8 +1090,7 @@ static int alb_handle_addr_collision_on_
 	}
 
 	if (free_mac_slave) {
-		alb_set_slave_mac_addr(slave, free_mac_slave->perm_hwaddr,
-				       bond->alb_info.rlb_enabled);
+		alb_set_slave_mac_addr(slave, free_mac_slave->perm_hwaddr);
 
 		pr_warning("%s: Warning: the hw address of slave %s is in use by the bond; giving it the hw address of %s\n",
 			   bond->dev->name, slave->dev->name,
@@ -1451,8 +1445,7 @@ int bond_alb_init_slave(struct bonding *
 {
 	int res;
 
-	res = alb_set_slave_mac_addr(slave, slave->perm_hwaddr,
-				     bond->alb_info.rlb_enabled);
+	res = alb_set_slave_mac_addr(slave, slave->perm_hwaddr);
 	if (res) {
 		return res;
 	}
@@ -1603,8 +1596,7 @@ void bond_alb_handle_active_change(struc
 		alb_swap_mac_addr(bond, swap_slave, new_slave);
 	} else {
 		/* set the new_slave to the bond mac address */
-		alb_set_slave_mac_addr(new_slave, bond->dev->dev_addr,
-				       bond->alb_info.rlb_enabled);
+		alb_set_slave_mac_addr(new_slave, bond->dev->dev_addr);
 	}
 
 	if (swap_slave) {
@@ -1664,8 +1656,7 @@ int bond_alb_set_mac_address(struct net_
 		alb_swap_mac_addr(bond, swap_slave, bond->curr_active_slave);
 		alb_fasten_mac_swap(bond, swap_slave, bond->curr_active_slave);
 	} else {
-		alb_set_slave_mac_addr(bond->curr_active_slave, bond_dev->dev_addr,
-				       bond->alb_info.rlb_enabled);
+		alb_set_slave_mac_addr(bond->curr_active_slave, bond_dev->dev_addr);
 
 		read_lock(&bond->lock);
 		alb_send_learning_packets(bond->curr_active_slave, bond_dev->dev_addr);


