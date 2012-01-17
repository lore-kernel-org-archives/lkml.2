Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab2AQXRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:17:49 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54106 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab2AQXRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:17:48 -0500
Message-ID: <1326842262.2606.31.camel@edumazet-laptop>
Subject: Re: [patch v3, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefan Gula <steweg@ynet.sk>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Jan 2012 00:17:42 +0100
In-Reply-To: <31531575.2671326838849345.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <31531575.2671326838849345.JavaMail.root@5-MeO-DMT.ynet.sk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 janvier 2012 à 23:20 +0100, Stefan Gula a écrit :
> From: Stefan Gula <steweg@gmail.com>
> 
> This patch is an extension for current Ethernet over GRE
> implementation, which allows user to create virtual bridge (multipoint
> VPN) and forward traffic based on Ethernet MAC address information in
> it. It simulates the Bridge behavior learning mechanism, but instead
> of learning port ID from which given MAC address comes, it learns IP
> address of peer which encapsulated given packet. Multicast, Broadcast
> and unknown-multicast traffic is send over network as multicast
> encapsulated GRE packet, so one Ethernet multipoint GRE tunnel can be
> represented as one single virtual switch on logical level and be also
> represented as one multicast IPv4 address on network level.
> 
> Signed-off-by: Stefan Gula <steweg@gmail.com>
> 
> ---
> 
> code was merged with Eric Dumazet proposal (all except the reordering
> of orig_source as that needed to be previous value), tested and fixed
> with additional lines in ipgre_tap_netdev_ops struct
> 

Sorry, this is buggy (again...)

Its even clearly commented in the code :

/* Warning: All skb pointers will be invalidated! */

>  
>          if (!pskb_may_pull(skb, 16))
>                  goto drop_nolock;
> @@ -659,10 +836,38 @@ static int ipgre_rcv(struct sk_buff *skb
>                                  tunnel->dev->stats.rx_errors++;
>                                  goto drop;
>                          }

At this point, iph can point to freed memory and its dereference can
crash, since pskb_may_pull() can reallocate skb head.

> -
> +#ifdef CONFIG_NET_IPGRE_BRIDGE
> +                        orig_source = iph->saddr;
> +#endif

Without any doubt, you know here there is a bug.

>                          iph = ip_hdr(skb);
>                          skb->protocol = eth_type_trans(skb, tunnel->dev);
>                          skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);


So if you need orig_source as the previous iph->saddr value, you must
fetch it _before_ the pskb_may_pull()


/* Warning: All skb pointers will be invalidated! */
if (tunnel->dev->type == ARPHRD_ETHER) {
#ifdef CONFIG_NET_IPGRE_BRIDGE
 	orig_source = iph->saddr; /* must be done before pskb_may_pull() */
#endif
	if (!pskb_may_pull(skb, ETH_HLEN)) {
		tunnel->dev->stats.rx_length_errors++;
		tunnel->dev->stats.rx_errors++;
		goto drop;
	}

	iph = ip_hdr(skb);
	...



