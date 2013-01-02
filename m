Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3ABMhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 07:37:15 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:62400 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3ABMhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 07:37:12 -0500
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, edumazet@google.com, faisal.latif@intel.com,
        roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        fubar@us.ibm.com, andy@greyhouse.net, divy@chelsio.com,
        jitendra.kalsaria@qlogic.com, sony.chacko@qlogic.com,
        linux-driver@qlogic.com, kaber@trash.net, ursula.braun@de.ibm.com,
        blaschka@linux.vnet.ibm.com, linux390@de.ibm.com,
        shemminger@vyatta.com, bhutchings@solarflare.com, therbert@google.com,
        xiyou.wangcong@gmail.com, joe@perches.com, gregory.v.rose@intel.com,
        john.r.fastabend@intel.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        bridge@lists.linux-foundation.org, fbl@redhat.com
Subject: [patch net-next V5 11/15] vlan: remove usage of dev->master in __vlan_find_dev_deep()
Date: Wed,  2 Jan 2013 13:28:32 +0100
Message-Id: <1357129716-2450-12-git-send-email-jiri@resnulli.us>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1357129716-2450-1-git-send-email-jiri@resnulli.us>
References: <1357129716-2450-1-git-send-email-jiri@resnulli.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, since all users call __vlan_find_dev_deep() with rcu_read_lock,
make no possibility to call this with rtnl mutex held only.

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
---
 net/8021q/vlan_core.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 65e06ab..380440b 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -60,21 +60,25 @@ bool vlan_do_receive(struct sk_buff **skbp)
 	return true;
 }
 
-/* Must be invoked with rcu_read_lock or with RTNL. */
-struct net_device *__vlan_find_dev_deep(struct net_device *real_dev,
+/* Must be invoked with rcu_read_lock. */
+struct net_device *__vlan_find_dev_deep(struct net_device *dev,
 					u16 vlan_id)
 {
-	struct vlan_info *vlan_info = rcu_dereference_rtnl(real_dev->vlan_info);
+	struct vlan_info *vlan_info = rcu_dereference(dev->vlan_info);
 
 	if (vlan_info) {
 		return vlan_group_get_device(&vlan_info->grp, vlan_id);
 	} else {
 		/*
-		 * Bonding slaves do not have grp assigned to themselves.
-		 * Grp is assigned to bonding master instead.
+		 * Lower devices of master uppers (bonding, team) do not have
+		 * grp assigned to themselves. Grp is assigned to upper device
+		 * instead.
 		 */
-		if (netif_is_bond_slave(real_dev))
-			return __vlan_find_dev_deep(real_dev->master, vlan_id);
+		struct net_device *upper_dev;
+
+		upper_dev = netdev_master_upper_dev_get_rcu(dev);
+		if (upper_dev)
+			return __vlan_find_dev_deep(upper_dev, vlan_id);
 	}
 
 	return NULL;
-- 
1.8.0

