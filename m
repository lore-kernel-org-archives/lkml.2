Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3ABM3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 07:29:14 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:36877 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3ABM3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 07:29:08 -0500
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
Subject: [patch net-next V5 07/15] netpoll: remove usage of dev->master
Date: Wed,  2 Jan 2013 13:28:28 +0100
Message-Id: <1357129716-2450-8-git-send-email-jiri@resnulli.us>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1357129716-2450-1-git-send-email-jiri@resnulli.us>
References: <1357129716-2450-1-git-send-email-jiri@resnulli.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
---
 net/core/netpoll.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 3151acf..d2bda8e 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -210,9 +210,12 @@ static void netpoll_poll_dev(struct net_device *dev)
 
 	if (dev->flags & IFF_SLAVE) {
 		if (ni) {
-			struct net_device *bond_dev = dev->master;
+			struct net_device *bond_dev;
 			struct sk_buff *skb;
-			struct netpoll_info *bond_ni = rcu_dereference_bh(bond_dev->npinfo);
+			struct netpoll_info *bond_ni;
+
+			bond_dev = netdev_master_upper_dev_get_rcu(dev);
+			bond_ni = rcu_dereference_bh(bond_dev->npinfo);
 			while ((skb = skb_dequeue(&ni->arp_tx))) {
 				skb->dev = bond_dev;
 				skb_queue_tail(&bond_ni->arp_tx, skb);
@@ -815,7 +818,7 @@ int netpoll_setup(struct netpoll *np)
 		return -ENODEV;
 	}
 
-	if (ndev->master) {
+	if (netdev_master_upper_dev_get(ndev)) {
 		np_err(np, "%s is a slave device, aborting\n", np->dev_name);
 		err = -EBUSY;
 		goto put;
-- 
1.8.0

