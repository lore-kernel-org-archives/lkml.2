Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1ABH4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:56:30 -0500
Received: from mail.windriver.com ([147.11.1.11]:35406 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab1ABHXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:15 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Jarek Poplawski <jarkao2@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 110/260] gro: fix different skb headrooms
Date: Sun,  2 Jan 2011 02:16:46 -0500
Message-Id: <1293952756-15010-111-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:10.0321 (UTC) FILETIME=[C4EC3810:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 3d3be4333fdf6faa080947b331a6a19bce1a4f57 upstream.

Packets entering GRO might have different headrooms, even for a given
flow (because of implementation details in drivers, like copybreak).
We cant force drivers to deliver packets with a fixed headroom.

1) fix skb_segment()

skb_segment() makes the false assumption headrooms of fragments are same
than the head. When CHECKSUM_PARTIAL is used, this can give csum_start
errors, and crash later in skb_copy_and_csum_dev()

2) allocate a minimal skb for head of frag_list

skb_gro_receive() uses netdev_alloc_skb(headroom + skb_gro_offset(p)) to
allocate a fresh skb. This adds NET_SKB_PAD to a padding already
provided by netdevice, depending on various things, like copybreak.

Use alloc_skb() to allocate an exact padding, to reduce cache line
needs:
NET_SKB_PAD + NET_IP_ALIGN

bugzilla : https://bugzilla.kernel.org/show_bug.cgi?id=16626

Many thanks to Plamen Petrov, testing many debugging patches !
With help of Jarek Poplawski.

Reported-by: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/skbuff.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index cad8e97..c1c86f5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2578,6 +2578,10 @@ struct sk_buff *skb_segment(struct sk_buff *skb, int features)
 		__copy_skb_header(nskb, skb);
 		nskb->mac_len = skb->mac_len;
 
+		/* nskb and skb might have different headroom */
+		if (nskb->ip_summed == CHECKSUM_PARTIAL)
+			nskb->csum_start += skb_headroom(nskb) - headroom;
+
 		skb_reset_mac_header(nskb);
 		skb_set_network_header(nskb, skb->mac_len);
 		nskb->transport_header = (nskb->network_header +
@@ -2707,8 +2711,8 @@ int skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
 	} else if (skb_gro_len(p) != pinfo->gso_size)
 		return -E2BIG;
 
-	headroom = skb_headroom(p);
-	nskb = netdev_alloc_skb(p->dev, headroom + skb_gro_offset(p));
+	headroom = NET_SKB_PAD + NET_IP_ALIGN;
+	nskb = alloc_skb(headroom + skb_gro_offset(p), GFP_ATOMIC);
 	if (unlikely(!nskb))
 		return -ENOMEM;
 
-- 
1.7.3.3

