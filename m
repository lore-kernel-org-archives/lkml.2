Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0GMKX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:23:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773Ab0GMKXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:23:18 -0400
Date: Tue, 13 Jul 2010 06:22:07 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-mm@kvack.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc: riel@redhat.com, cl@linux-foundation.org, a.p.zijlstra@chello.nl,
        Xiaotian Feng <dfeng@redhat.com>, linux-kernel@vger.kernel.org,
        lwang@redhat.com, penberg@cs.helsinki.fi, akpm@linux-foundation.org,
        davem@davemloft.net
Message-Id: <20100713102206.2835.61332.sendpatchset@danny.redhat>
In-Reply-To: <20100713101650.2835.15245.sendpatchset@danny.redhat>
References: <20100713101650.2835.15245.sendpatchset@danny.redhat>
Subject: [PATCH -mmotm 28/30] build fix for skb_emergency_protocol
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 50d2e72527b3e821544cc97c4dd5b1e5a44b6659 Mon Sep 17 00:00:00 2001
From: Xiaotian Feng <dfeng@redhat.com>
Date: Tue, 13 Jul 2010 13:21:10 +0800
Subject: [PATCH 28/30] build fix for skb_emergency_protocol

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 net/core/dev.c |   48 ++++++++++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7169b9b..fd7f8ac 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2791,6 +2791,30 @@ int __skb_bond_should_drop(struct sk_buff *skb, struct net_device *master)
 }
 EXPORT_SYMBOL(__skb_bond_should_drop);
 
+/*
+ * Filter the protocols for which the reserves are adequate.
+ *
+ * Before adding a protocol make sure that it is either covered by the existing
+ * reserves, or add reserves covering the memory need of the new protocol's
+ * packet processing.
+ */
+static int skb_emergency_protocol(struct sk_buff *skb)
+{
+	if (skb_emergency(skb))
+		switch (skb->protocol) {
+		case __constant_htons(ETH_P_ARP):
+		case __constant_htons(ETH_P_IP):
+		case __constant_htons(ETH_P_IPV6):
+		case __constant_htons(ETH_P_8021Q):
+			break;
+
+		default:
+			return 0;
+		}
+
+	return 1;
+}
+
 static int __netif_receive_skb(struct sk_buff *skb)
 {
 	struct packet_type *ptype, *pt_prev;
@@ -2942,30 +2966,6 @@ out:
 	return ret;
 }
 
-/*
- * Filter the protocols for which the reserves are adequate.
- *
- * Before adding a protocol make sure that it is either covered by the existing
- * reserves, or add reserves covering the memory need of the new protocol's
- * packet processing.
- */
-static int skb_emergency_protocol(struct sk_buff *skb)
-{
-	if (skb_emergency(skb))
-		switch (skb->protocol) {
-		case __constant_htons(ETH_P_ARP):
-		case __constant_htons(ETH_P_IP):
-		case __constant_htons(ETH_P_IPV6):
-		case __constant_htons(ETH_P_8021Q):
-			break;
-
-		default:
-			return 0;
-		}
-
-	return 1;
-}
-
 /**
  *	netif_receive_skb - process receive buffer from network
  *	@skb: buffer to process
-- 
1.7.1.1

