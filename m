Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1ABHXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:35541 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab1ABHXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:25 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 117/260] bridge: Clear INET control block of SKBs passed into ip_fragment().
Date: Sun,  2 Jan 2011 02:16:53 -0500
Message-Id: <1293952756-15010-118-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:17.0587 (UTC) FILETIME=[C940EC30:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

commit 87f94b4e91dc042620c527f3c30c37e5127ef757 upstream.

In a similar vain to commit 17762060c25590bfddd68cc1131f28ec720f405f
("bridge: Clear IPCB before possible entry into IP stack")

Any time we call into the IP stack we have to make sure the state
there is as expected by the ipv4 code.

With help from Eric Dumazet and Herbert Xu.

Reported-by: Bandan Das <bandan.das@stratus.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/bridge/br_netfilter.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 54d812e..641d662 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -801,9 +801,11 @@ static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 	if (skb->nfct != NULL &&
 	    (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb)) &&
 	    skb->len > skb->dev->mtu &&
-	    !skb_is_gso(skb))
+	    !skb_is_gso(skb)) {
+		/* BUG: Should really parse the IP options here. */
+		memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
 		return ip_fragment(skb, br_dev_queue_push_xmit);
-	else
+	} else
 		return br_dev_queue_push_xmit(skb);
 }
 #else
-- 
1.7.3.3

