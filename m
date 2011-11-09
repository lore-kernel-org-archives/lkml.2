Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934812Ab1KJD1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:27:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934785Ab1KJD1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:27:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:14 2011
Message-Id: <20111109212714.296639072@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Hemminger <shemminger@vyatta.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [136/262] bridge: fix hang on removal of bridge via netlink
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: stephen hemminger <shemminger@vyatta.com>

[ Upstream commit 1ce5cce895309862d2c35d922816adebe094fe4a ]

Need to cleanup bridge device timers and ports when being bridge
device is being removed via netlink.

This fixes the problem of observed when doing:
 ip link add br0 type bridge
 ip link set dev eth1 master br0
 ip link set br0 up
 ip link del br0

which would cause br0 to hang in unregister_netdev because
of leftover reference count.

Reported-by: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Acked-by: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_if.c      |    9 +++++----
 net/bridge/br_netlink.c |    1 +
 net/bridge/br_private.h |    1 +
 3 files changed, 7 insertions(+), 4 deletions(-)

--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -161,9 +161,10 @@ static void del_nbp(struct net_bridge_po
 	call_rcu(&p->rcu, destroy_nbp_rcu);
 }
 
-/* called with RTNL */
-static void del_br(struct net_bridge *br, struct list_head *head)
+/* Delete bridge device */
+void br_dev_delete(struct net_device *dev, struct list_head *head)
 {
+	struct net_bridge *br = netdev_priv(dev);
 	struct net_bridge_port *p, *n;
 
 	list_for_each_entry_safe(p, n, &br->port_list, list) {
@@ -268,7 +269,7 @@ int br_del_bridge(struct net *net, const
 	}
 
 	else
-		del_br(netdev_priv(dev), NULL);
+		br_dev_delete(dev, NULL);
 
 	rtnl_unlock();
 	return ret;
@@ -445,7 +446,7 @@ void __net_exit br_net_exit(struct net *
 	rtnl_lock();
 	for_each_netdev(net, dev)
 		if (dev->priv_flags & IFF_EBRIDGE)
-			del_br(netdev_priv(dev), &list);
+			br_dev_delete(dev, &list);
 
 	unregister_netdevice_many(&list);
 	rtnl_unlock();
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -208,6 +208,7 @@ static struct rtnl_link_ops br_link_ops
 	.priv_size	= sizeof(struct net_bridge),
 	.setup		= br_dev_setup,
 	.validate	= br_validate,
+	.dellink	= br_dev_delete,
 };
 
 int __init br_netlink_init(void)
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -294,6 +294,7 @@ static inline int br_is_root_bridge(cons
 
 /* br_device.c */
 extern void br_dev_setup(struct net_device *dev);
+extern void br_dev_delete(struct net_device *dev, struct list_head *list);
 extern netdev_tx_t br_dev_xmit(struct sk_buff *skb,
 			       struct net_device *dev);
 #ifdef CONFIG_NET_POLL_CONTROLLER


