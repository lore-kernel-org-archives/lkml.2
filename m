Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab1CCKza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:55:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1CCKz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:55:28 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>
Subject: [RFC PATCH] net/core: fix skb handling on netif serves for both bridge and vlan
Date: Thu,  3 Mar 2011 18:55:13 +0800
Message-Id: <1299149713-18740-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider network topology as follows:

eth0  eth1
 |_____|
    |
  bond0 --- br0
    |
  vlan0 --- br1

bond0 serves for both br0 and vlan0, if a vlan tagged packet was sent
to br1 through bond0, bridge handling code is seeing the packet on bond0
and handing it off to my "legacy" bridge before vlan_tx_tag_present
and vlan_hwaccel_do_receive even haven't a chance to look at it.

Moving the vlan_tx_tag_present before bridge/macvlan handling code could
cure this.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tom Herbert <therbert@google.com>
---
 net/core/dev.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8ae6631..d2d12c2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3079,27 +3079,27 @@ static int __netif_receive_skb(struct sk_buff *skb)
 ncls:
 #endif
 
-	/* Handle special case of bridge or macvlan */
-	rx_handler = rcu_dereference(skb->dev->rx_handler);
-	if (rx_handler) {
+	if (vlan_tx_tag_present(skb)) {
 		if (pt_prev) {
 			ret = deliver_skb(skb, pt_prev, orig_dev);
 			pt_prev = NULL;
 		}
-		skb = rx_handler(skb);
-		if (!skb)
+		if (vlan_hwaccel_do_receive(&skb)) {
+			ret = __netif_receive_skb(skb);
+			goto out;
+		} else if (unlikely(!skb))
 			goto out;
 	}
 
-	if (vlan_tx_tag_present(skb)) {
+	/* Handle special case of bridge or macvlan */
+	rx_handler = rcu_dereference(skb->dev->rx_handler);
+	if (rx_handler) {
 		if (pt_prev) {
 			ret = deliver_skb(skb, pt_prev, orig_dev);
 			pt_prev = NULL;
 		}
-		if (vlan_hwaccel_do_receive(&skb)) {
-			ret = __netif_receive_skb(skb);
-			goto out;
-		} else if (unlikely(!skb))
+		skb = rx_handler(skb);
+		if (!skb)
 			goto out;
 	}
 
-- 
1.7.1

