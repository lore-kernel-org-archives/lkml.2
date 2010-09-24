Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab0IXQ1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:27:55 -0400
Received: from kroah.org ([198.145.64.141]:46015 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472Ab0IXQ1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:27:54 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:15 2010
Message-Id: <20100924162615.251004672@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:23:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jarek Poplawski <jarkao2@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [04/80] gro: fix different skb headrooms
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 3d3be4333fdf6faa080947b331a6a19bce1a4f57 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/skbuff.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2574,6 +2574,10 @@ struct sk_buff *skb_segment(struct sk_bu
 		__copy_skb_header(nskb, skb);
 		nskb->mac_len = skb->mac_len;
 
+		/* nskb and skb might have different headroom */
+		if (nskb->ip_summed == CHECKSUM_PARTIAL)
+			nskb->csum_start += skb_headroom(nskb) - headroom;
+
 		skb_reset_mac_header(nskb);
 		skb_set_network_header(nskb, skb->mac_len);
 		nskb->transport_header = (nskb->network_header +
@@ -2703,8 +2707,8 @@ int skb_gro_receive(struct sk_buff **hea
 	} else if (skb_gro_len(p) != pinfo->gso_size)
 		return -E2BIG;
 
-	headroom = skb_headroom(p);
-	nskb = netdev_alloc_skb(p->dev, headroom + skb_gro_offset(p));
+	headroom = NET_SKB_PAD + NET_IP_ALIGN;
+	nskb = alloc_skb(headroom + skb_gro_offset(p), GFP_ATOMIC);
 	if (unlikely(!nskb))
 		return -ENOMEM;
 


