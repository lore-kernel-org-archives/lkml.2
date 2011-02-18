Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1BRJoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:44:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab1BRJoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:44:15 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Amerigo Wang <amwang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: [V4 PATCH 3/3] bond: service netpoll arp queue on master device
Date: Fri, 18 Feb 2011 17:43:34 +0800
Message-Id: <1298022215-21059-3-git-send-email-amwang@redhat.com>
In-Reply-To: <1298022215-21059-1-git-send-email-amwang@redhat.com>
References: <1298022215-21059-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil pointed out that we can't send ARP reply on behalf of slaves,
we need to move the arp queue to their bond device.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>

---
 net/core/netpoll.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index f68e694..013e04a 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -193,6 +193,15 @@ void netpoll_poll_dev(struct net_device *dev)
 
 	poll_napi(dev);
 
+	if (dev->priv_flags & IFF_SLAVE) {
+		if (dev->npinfo) {
+			struct net_device *bond_dev = dev->master;
+			struct sk_buff *skb;
+			while ((skb = skb_dequeue(&dev->npinfo->arp_tx)))
+				skb_queue_tail(&bond_dev->npinfo->arp_tx, skb);
+		}
+	}
+
 	service_arp_queue(dev->npinfo);
 
 	zap_completion_queue();
-- 
1.7.1

