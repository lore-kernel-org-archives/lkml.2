Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab0HXXCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:02:54 -0400
Received: from kroah.org ([198.145.64.141]:41157 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933511Ab0HXXCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:44 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:06 2010
Message-Id: <20100824224506.548013948@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [061/114] bridge: add rcu_read_lock on transmit
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Stephen Hemminger <shemminger@vyatta.com>

[ Upstream commit eeaf61d8891f9c9ed12c1a667e72bf83f0857954 ]

Long ago, when bridge was converted to RCU, rcu lock was equivalent
to having preempt disabled. RCU has changed a lot since then and
bridge code was still assuming the since transmit was called with
bottom half disabled, it was RCU safe.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Tested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_device.c   |    4 +++-
 net/bridge/br_fdb.c      |    2 +-
 net/bridge/br_input.c    |    6 +++---
 net/bridge/br_stp_bpdu.c |    2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -22,7 +22,7 @@
 #include <asm/uaccess.h>
 #include "br_private.h"
 
-/* net device transmit always called with no BH (preempt_disabled) */
+/* net device transmit always called with BH disabled */
 netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct net_bridge *br = netdev_priv(dev);
@@ -46,6 +46,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *
 	skb_reset_mac_header(skb);
 	skb_pull(skb, ETH_HLEN);
 
+	rcu_read_lock();
 	if (is_multicast_ether_addr(dest)) {
 		if (br_multicast_rcv(br, NULL, skb))
 			goto out;
@@ -61,6 +62,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *
 		br_flood_deliver(br, skb);
 
 out:
+	rcu_read_unlock();
 	return NETDEV_TX_OK;
 }
 
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -214,7 +214,7 @@ void br_fdb_delete_by_port(struct net_br
 	spin_unlock_bh(&br->hash_lock);
 }
 
-/* No locking or refcounting, assumes caller has no preempt (rcu_read_lock) */
+/* No locking or refcounting, assumes caller has rcu_read_lock */
 struct net_bridge_fdb_entry *__br_fdb_get(struct net_bridge *br,
 					  const unsigned char *addr)
 {
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -37,7 +37,7 @@ static int br_pass_frame_up(struct sk_bu
 		       netif_receive_skb);
 }
 
-/* note: already called with rcu_read_lock (preempt_disabled) */
+/* note: already called with rcu_read_lock */
 int br_handle_frame_finish(struct sk_buff *skb)
 {
 	const unsigned char *dest = eth_hdr(skb)->h_dest;
@@ -108,7 +108,7 @@ drop:
 	goto out;
 }
 
-/* note: already called with rcu_read_lock (preempt_disabled) */
+/* note: already called with rcu_read_lock */
 static int br_handle_local_finish(struct sk_buff *skb)
 {
 	struct net_bridge_port *p = rcu_dereference(skb->dev->br_port);
@@ -133,7 +133,7 @@ static inline int is_link_local(const un
 /*
  * Called via br_handle_frame_hook.
  * Return NULL if skb is handled
- * note: already called with rcu_read_lock (preempt_disabled)
+ * note: already called with rcu_read_lock
  */
 struct sk_buff *br_handle_frame(struct net_bridge_port *p, struct sk_buff *skb)
 {
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -131,7 +131,7 @@ void br_send_tcn_bpdu(struct net_bridge_
 /*
  * Called from llc.
  *
- * NO locks, but rcu_read_lock (preempt_disabled)
+ * NO locks, but rcu_read_lock
  */
 void br_stp_rcv(const struct stp_proto *proto, struct sk_buff *skb,
 		struct net_device *dev)


