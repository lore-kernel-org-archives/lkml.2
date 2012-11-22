Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab2KVSgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:36:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab2KVSf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:35:57 -0500
From: Michal Kubecek <mkubecek@suse.cz>
Date: Thu, 22 Nov 2012 13:48:39 +0100
Subject: [PATCH] bonding: in balance-rr mode, set curr_active_slave only if it is up
To: netdev@vger.kernel.org
Cc: Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        linux-kernel@vger.kernel.org
Message-Id: <20121122125202.14252C35B8@unicorn.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If all slaves of a balance-rr bond with ARP monitor are enslaved
with down link state, bond keeps down state even after slaves
go up.

This is caused by bond_enslave() setting curr_active_slave to
first slave not taking into account its link state. As
bond_loadbalance_arp_mon() uses curr_active_slave to identify
whether slave's down->up transition should update bond's link
state, bond stays down even if slaves are up (until first slave
goes from up to down at least once).

Before commit f31c7937 "bonding: start slaves with link down for
ARP monitor", this was masked by slaves always starting in UP
state with ARP monitor (and MII monitor not relying on
curr_active_slave being NULL if there is no slave up).

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/bonding/bond_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5f5b69f..c8bff3e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1838,7 +1838,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 		 * anyway (it holds no special properties of the bond device),
 		 * so we can change it without calling change_active_interface()
 		 */
-		if (!bond->curr_active_slave)
+		if (!bond->curr_active_slave && new_slave->link == BOND_LINK_UP)
 			bond->curr_active_slave = new_slave;
 
 		break;
-- 
1.7.10.4

