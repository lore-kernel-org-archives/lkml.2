Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966419Ab0CPOyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:54:00 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:34222 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S966396Ab0CPOx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:53:58 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Tristram Ha <Tristram.Ha@micrel.com>
Subject: [PATCH 1/1] NET: ksz884x, fix lock imbalance
Date: Tue, 16 Mar 2010 15:53:50 +0100
Message-Id: <1268751230-14416-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that one error path (when alloc_skb fails) in netdev_tx
omits to unlock hw_priv->hwlock. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tristram Ha <Tristram.Ha@micrel.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/ksz884x.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ksz884x.c b/drivers/net/ksz884x.c
index 7264a3e..0f59099 100644
--- a/drivers/net/ksz884x.c
+++ b/drivers/net/ksz884x.c
@@ -4899,8 +4899,10 @@ static int netdev_tx(struct sk_buff *skb, struct net_device *dev)
 			struct sk_buff *org_skb = skb;
 
 			skb = dev_alloc_skb(org_skb->len);
-			if (!skb)
-				return NETDEV_TX_BUSY;
+			if (!skb) {
+				rc = NETDEV_TX_BUSY;
+				goto unlock;
+			}
 			skb_copy_and_csum_dev(org_skb, skb->data);
 			org_skb->ip_summed = 0;
 			skb->len = org_skb->len;
@@ -4914,7 +4916,7 @@ static int netdev_tx(struct sk_buff *skb, struct net_device *dev)
 		netif_stop_queue(dev);
 		rc = NETDEV_TX_BUSY;
 	}
-
+unlock:
 	spin_unlock_irq(&hw_priv->hwlock);
 
 	return rc;
-- 
1.7.0.1


