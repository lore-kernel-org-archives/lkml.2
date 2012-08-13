Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2HMP1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:27:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64718 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab2HMP1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:27:39 -0400
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
Subject: [patch net-next 07/16] netpoll: remove usage of dev->master
Date: Mon, 13 Aug 2012 17:27:06 +0200
Message-Id: <1344871635-1052-8-git-send-email-jiri@resnulli.us>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344871635-1052-1-git-send-email-jiri@resnulli.us>
References: <1344871635-1052-1-git-send-email-jiri@resnulli.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
---
 net/core/netpoll.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index b4c90e4..5c8e560 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -207,12 +207,16 @@ static void netpoll_poll_dev(struct net_device *dev)
 
 	if (dev->flags & IFF_SLAVE) {
 		if (dev->npinfo) {
-			struct net_device *bond_dev = dev->master;
+			struct net_device *bond_dev;
 			struct sk_buff *skb;
+
+			rcu_read_lock();
+			bond_dev = netdev_unique_upper_dev_get_rcu(dev);
 			while ((skb = skb_dequeue(&dev->npinfo->arp_tx))) {
 				skb->dev = bond_dev;
 				skb_queue_tail(&bond_dev->npinfo->arp_tx, skb);
 			}
+			rcu_read_unlock();
 		}
 	}
 
@@ -795,7 +799,7 @@ int netpoll_setup(struct netpoll *np)
 		return -ENODEV;
 	}
 
-	if (ndev->master) {
+	if (netdev_unique_upper_dev_get(ndev)) {
 		np_err(np, "%s is a slave device, aborting\n", np->dev_name);
 		err = -EBUSY;
 		goto put;
-- 
1.7.10.4

