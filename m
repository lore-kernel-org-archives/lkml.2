Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab1ESKZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 06:25:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab1ESKZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 06:25:44 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, WANG Cong <amwang@redhat.com>,
        Neil Horman <nhorman@redhat.com>, Jay Vosburgh <fubar@us.ibm.com>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: [Patch] bridge: call NETDEV_ENSLAVE notifiers when adding a slave
Date: Thu, 19 May 2011 18:24:17 +0800
Message-Id: <1305800661-4081-1-git-send-email-amwang@redhat.com>
In-Reply-To: <1305794393-20775-1-git-send-email-amwang@redhat.com>
References: <1305794393-20775-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the previous patch I added NETDEV_ENSLAVE, now
we can notify netconsole when adding a device to a bridge too.

By the way, s/netdev_bonding_change/call_netdevice_notifiers/ in
bond_main.c, since this is not bonding specific.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>

---
 drivers/net/bonding/bond_main.c |    2 +-
 net/bridge/br_if.c              |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b9c70c5..765fdcf 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1640,7 +1640,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 		}
 	}
 
-	netdev_bonding_change(slave_dev, NETDEV_ENSLAVE);
+	call_netdevice_notifiers(NETDEV_ENSLAVE, slave_dev);
 
 	/* If this is the first slave, then we need to set the master's hardware
 	 * address to be the same as the slave's. */
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 5dbdfdf..b44fae5 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -338,6 +338,8 @@ int br_add_if(struct net_bridge *br, struct net_device *dev)
 	if (IS_ERR(p))
 		return PTR_ERR(p);
 
+	call_netdevice_notifiers(NETDEV_ENSLAVE, dev);
+
 	err = dev_set_promiscuity(dev, 1);
 	if (err)
 		goto put_back;
