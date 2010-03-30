Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab0C3X13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:27:29 -0400
Received: from kroah.org ([198.145.64.141]:46816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932693Ab0C3XWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:22:05 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:53 2010
Message-Id: <20100330224852.835762887@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [142/156] net: Potential null skb->dev dereference
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 0641e4fbf2f824faee00ea74c459a088d94905fd ]

When doing "ifenslave -d bond0 eth0", there is chance to get NULL
dereference in netif_receive_skb(), because dev->master suddenly becomes
NULL after we tested it.

We should use ACCESS_ONCE() to avoid this (or rcu_dereference())

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/netdevice.h |    8 ++++----
 net/8021q/vlan_core.c     |    4 ++--
 net/core/dev.c            |    8 +++++---
 3 files changed, 11 insertions(+), 9 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2023,12 +2023,12 @@ static inline void skb_bond_set_mac_by_m
  * duplicates except for 802.3ad ETH_P_SLOW, alb non-mcast/bcast, and
  * ARP on active-backup slaves with arp_validate enabled.
  */
-static inline int skb_bond_should_drop(struct sk_buff *skb)
+static inline int skb_bond_should_drop(struct sk_buff *skb,
+				       struct net_device *master)
 {
-	struct net_device *dev = skb->dev;
-	struct net_device *master = dev->master;
-
 	if (master) {
+		struct net_device *dev = skb->dev;
+
 		if (master->priv_flags & IFF_MASTER_ARPMON)
 			dev->last_rx = jiffies;
 
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -11,7 +11,7 @@ int __vlan_hwaccel_rx(struct sk_buff *sk
 	if (netpoll_rx(skb))
 		return NET_RX_DROP;
 
-	if (skb_bond_should_drop(skb))
+	if (skb_bond_should_drop(skb, ACCESS_ONCE(skb->dev->master)))
 		goto drop;
 
 	__vlan_hwaccel_put_tag(skb, vlan_tci);
@@ -82,7 +82,7 @@ vlan_gro_common(struct napi_struct *napi
 {
 	struct sk_buff *p;
 
-	if (skb_bond_should_drop(skb))
+	if (skb_bond_should_drop(skb, ACCESS_ONCE(skb->dev->master)))
 		goto drop;
 
 	__vlan_hwaccel_put_tag(skb, vlan_tci);
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2421,6 +2421,7 @@ int netif_receive_skb(struct sk_buff *sk
 {
 	struct packet_type *ptype, *pt_prev;
 	struct net_device *orig_dev;
+	struct net_device *master;
 	struct net_device *null_or_orig;
 	int ret = NET_RX_DROP;
 	__be16 type;
@@ -2440,11 +2441,12 @@ int netif_receive_skb(struct sk_buff *sk
 
 	null_or_orig = NULL;
 	orig_dev = skb->dev;
-	if (orig_dev->master) {
-		if (skb_bond_should_drop(skb))
+	master = ACCESS_ONCE(orig_dev->master);
+	if (master) {
+		if (skb_bond_should_drop(skb, master))
 			null_or_orig = orig_dev; /* deliver only exact match */
 		else
-			skb->dev = orig_dev->master;
+			skb->dev = master;
 	}
 
 	__get_cpu_var(netdev_rx_stat).total++;


