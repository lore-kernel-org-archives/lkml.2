Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0IAKvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 06:51:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57391 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab0IAKvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 06:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=i13kS2nb8KFu0b+9VaNl+z2F576NCuUpH9747HdPf83XQ8bv9fS7o9C6r0Sh+oBCNK
         svboQ4KpDcl68UU9YA+fxiS2pCYCw130/5fmmdBsBibSUsBJaeE/RP4QzHXxkop0rQ58
         SY7ZM6/ZR9AwAYcuQ+Xy3X8i+sDoqkgDzLW2w=
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>,
        Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
In-Reply-To: <20100831192659.GA3093@del.dom.local>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
	 <4AUWBNzTkbD.A.ey.cGueMB@chimera> <courier.4C7C99F2.00001F74@fs.ru.acad.bg>
	 <20100831192659.GA3093@del.dom.local>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 12:50:51 +0200
Message-ID: <1283338251.2556.124.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Plamen, could you test following patch ?

I reproduced problem on a dev machine and following patch cured it.

Thanks

[PATCH] gro: fix different skb headrooms

packets entering GRO might have different headrooms, even for a given
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
---
patch against linux-2.6 current tree

 net/core/skbuff.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3a2513f..26396ff 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2573,6 +2573,10 @@ struct sk_buff *skb_segment(struct sk_buff *skb, int features)
 		__copy_skb_header(nskb, skb);
 		nskb->mac_len = skb->mac_len;
 
+		/* nskb and skb might have different headroom */
+		if (nskb->ip_summed == CHECKSUM_PARTIAL)
+			nskb->csum_start += skb_headroom(nskb) - headroom;
+
 		skb_reset_mac_header(nskb);
 		skb_set_network_header(nskb, skb->mac_len);
 		nskb->transport_header = (nskb->network_header +
@@ -2702,8 +2706,8 @@ int skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
 	} else if (skb_gro_len(p) != pinfo->gso_size)
 		return -E2BIG;
 
-	headroom = skb_headroom(p);
-	nskb = netdev_alloc_skb(p->dev, headroom + skb_gro_offset(p));
+	headroom = NET_SKB_PAD + NET_IP_ALIGN;
+	nskb = alloc_skb(headroom + skb_gro_offset(p), GFP_ATOMIC);
 	if (unlikely(!nskb))
 		return -ENOMEM;
 


