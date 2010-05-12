Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab0ELViF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:38:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48369 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072Ab0ELVd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:33:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [PATCH RFC tip/core/rcu 04/23] net: Make accesses to ->br_port safe for sparse RCU
Date: Wed, 12 May 2010 14:33:23 -0700
Message-Id: <1273700022-16523-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new versions of the rcu_dereference() APIs requires that any pointers
passed to one of these APIs be fully defined.  The ->br_port field
in struct net_device points to a struct net_bridge_port, which is an
incomplete type.  This commit therefore changes ->br_port to be a void*,
and introduces a br_port() helper function to convert the type to struct
net_bridge_port, and applies this new helper function where required.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Miller <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/if_bridge.h           |    3 +++
 net/bridge/br_fdb.c                 |    2 +-
 net/bridge/br_private.h             |    8 ++++++++
 net/bridge/netfilter/ebt_redirect.c |    2 +-
 net/bridge/netfilter/ebt_ulog.c     |    4 ++--
 net/bridge/netfilter/ebtables.c     |    4 ++--
 net/netfilter/nfnetlink_log.c       |    4 ++--
 net/netfilter/nfnetlink_queue.c     |    4 ++--
 8 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 938b7e8..d001d78 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -101,6 +101,9 @@ struct __fdb_entry {
 
 #include <linux/netdevice.h>
 
+/* br_handle_frame_hook() needs the following forward declaration. */
+struct net_bridge_port;
+
 extern void brioctl_set(int (*ioctl_hook)(struct net *, unsigned int, void __user *));
 extern struct sk_buff *(*br_handle_frame_hook)(struct net_bridge_port *p,
 					       struct sk_buff *skb);
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 9101a4e..3f66cd1 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -246,7 +246,7 @@ int br_fdb_test_addr(struct net_device *dev, unsigned char *addr)
 		return 0;
 
 	rcu_read_lock();
-	fdb = __br_fdb_get(dev->br_port->br, addr);
+	fdb = __br_fdb_get(br_port(dev)->br, addr);
 	ret = fdb && fdb->dst->dev != dev &&
 		fdb->dst->state == BR_STATE_FORWARDING;
 	rcu_read_unlock();
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 846d7d1..4fedb60 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -229,6 +229,14 @@ static inline int br_is_root_bridge(const struct net_bridge *br)
 	return !memcmp(&br->bridge_id, &br->designated_root, 8);
 }
 
+static inline struct net_bridge_port *br_port(const struct net_device *dev)
+{
+	if (!dev)
+		return NULL;
+
+	return rcu_dereference(dev->br_port);
+}
+
 /* br_device.c */
 extern void br_dev_setup(struct net_device *dev);
 extern netdev_tx_t br_dev_xmit(struct sk_buff *skb,
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 9be8fbc..4fa8377 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -25,7 +25,7 @@ ebt_redirect_tg(struct sk_buff *skb, const struct xt_target_param *par)
 
 	if (par->hooknum != NF_BR_BROUTING)
 		memcpy(eth_hdr(skb)->h_dest,
-		       par->in->br_port->br->dev->dev_addr, ETH_ALEN);
+		       br_port(par->in)->br->dev->dev_addr, ETH_ALEN);
 	else
 		memcpy(eth_hdr(skb)->h_dest, par->in->dev_addr, ETH_ALEN);
 	skb->pkt_type = PACKET_HOST;
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index f9560f3..32ca502 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -183,7 +183,7 @@ static void ebt_ulog_packet(unsigned int hooknr, const struct sk_buff *skb,
 		strcpy(pm->physindev, in->name);
 		/* If in isn't a bridge, then physindev==indev */
 		if (in->br_port)
-			strcpy(pm->indev, in->br_port->br->dev->name);
+			strcpy(pm->indev, br_port(in)->br->dev->name);
 		else
 			strcpy(pm->indev, in->name);
 	} else
@@ -192,7 +192,7 @@ static void ebt_ulog_packet(unsigned int hooknr, const struct sk_buff *skb,
 	if (out) {
 		/* If out exists, then out is a bridge port */
 		strcpy(pm->physoutdev, out->name);
-		strcpy(pm->outdev, out->br_port->br->dev->name);
+		strcpy(pm->outdev, br_port(out)->br->dev->name);
 	} else
 		pm->outdev[0] = pm->physoutdev[0] = '\0';
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index f0865fd..ac1361b 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -141,10 +141,10 @@ ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
 	if (FWINV2(ebt_dev_check(e->out, out), EBT_IOUT))
 		return 1;
 	if ((!in || !in->br_port) ? 0 : FWINV2(ebt_dev_check(
-	   e->logical_in, in->br_port->br->dev), EBT_ILOGICALIN))
+	   e->logical_in, br_port(in)->br->dev), EBT_ILOGICALIN))
 		return 1;
 	if ((!out || !out->br_port) ? 0 : FWINV2(ebt_dev_check(
-	   e->logical_out, out->br_port->br->dev), EBT_ILOGICALOUT))
+	   e->logical_out, br_port(out)->br->dev), EBT_ILOGICALOUT))
 		return 1;
 
 	if (e->bitmask & EBT_SOURCEMAC) {
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 203643f..d89c1be 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -404,7 +404,7 @@ __build_packet_message(struct nfulnl_instance *inst,
 				     htonl(indev->ifindex));
 			/* this is the bridge group "brX" */
 			NLA_PUT_BE32(inst->skb, NFULA_IFINDEX_INDEV,
-				     htonl(indev->br_port->br->dev->ifindex));
+				     htonl(br_port(indev)->br->dev->ifindex));
 		} else {
 			/* Case 2: indev is bridge group, we need to look for
 			 * physical device (when called from ipv4) */
@@ -431,7 +431,7 @@ __build_packet_message(struct nfulnl_instance *inst,
 				     htonl(outdev->ifindex));
 			/* this is the bridge group "brX" */
 			NLA_PUT_BE32(inst->skb, NFULA_IFINDEX_OUTDEV,
-				     htonl(outdev->br_port->br->dev->ifindex));
+				     htonl(br_port(outdev)->br->dev->ifindex));
 		} else {
 			/* Case 2: indev is a bridge group, we need to look
 			 * for physical device (when called from ipv4) */
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index e70a6ef..0be9156 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -298,7 +298,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 				     htonl(indev->ifindex));
 			/* this is the bridge group "brX" */
 			NLA_PUT_BE32(skb, NFQA_IFINDEX_INDEV,
-				     htonl(indev->br_port->br->dev->ifindex));
+				     htonl(br_port(indev)->br->dev->ifindex));
 		} else {
 			/* Case 2: indev is bridge group, we need to look for
 			 * physical device (when called from ipv4) */
@@ -323,7 +323,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 				     htonl(outdev->ifindex));
 			/* this is the bridge group "brX" */
 			NLA_PUT_BE32(skb, NFQA_IFINDEX_OUTDEV,
-				     htonl(outdev->br_port->br->dev->ifindex));
+				     htonl(br_port(outdev)->br->dev->ifindex));
 		} else {
 			/* Case 2: outdev is bridge group, we need to look for
 			 * physical output device (when called from ipv4) */
-- 
1.7.0.6

