Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1KIWLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 17:11:04 -0500
Received: from smtp-out.google.com ([74.125.121.67]:41870 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab1KIWK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 17:10:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization:x-system-of-record;
	b=LCKnpGYuf8YSsOKPZDqqzxuXMBU0VEQSJYncD0CcLiP6jnFRt4gDi/kX0ZQ2VPJlF
	iIU4EJqF8+S72TP0fni+A==
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net-next v1 4/9] forcedeth: stats for rx_packets based on hardware registers
Date: Wed,  9 Nov 2011 14:09:18 -0800
Message-Id: <30a7c46d924c29d1faf879bc9522e4ec8565d378.1320875577.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320875577.git.david.decotigny@google.com>
References: <cover.1320875577.git.david.decotigny@google.com>
In-Reply-To: <cover.1320875577.git.david.decotigny@google.com>
References: <cover.1320875577.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hardware registers instead of a software implementation to
account for the number of RX packets.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index cd7f83d..0071d5c 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -1712,6 +1712,7 @@ static struct net_device_stats *nv_get_stats(struct net_device *dev)
 		nv_get_hw_stats(dev);
 
 		/* copy to net_device stats */
+		dev->stats.rx_packets = np->estats.rx_packets;
 		dev->stats.tx_packets = np->estats.tx_packets;
 		dev->stats.rx_bytes = np->estats.rx_bytes;
 		dev->stats.tx_bytes = np->estats.tx_bytes;
@@ -2690,7 +2691,6 @@ static int nv_rx_process(struct net_device *dev, int limit)
 		skb_put(skb, len);
 		skb->protocol = eth_type_trans(skb, dev);
 		napi_gro_receive(&np->napi, skb);
-		dev->stats.rx_packets++;
 next_pkt:
 		if (unlikely(np->get_rx.orig++ == np->last_rx.orig))
 			np->get_rx.orig = np->first_rx.orig;
@@ -2773,7 +2773,6 @@ static int nv_rx_process_optimized(struct net_device *dev, int limit)
 				__vlan_hwaccel_put_tag(skb, vid);
 			}
 			napi_gro_receive(&np->napi, skb);
-			dev->stats.rx_packets++;
 		} else {
 			dev_kfree_skb(skb);
 		}
-- 
1.7.3.1

