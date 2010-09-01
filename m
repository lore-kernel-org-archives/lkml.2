Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0IALUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 07:20:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61803 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab0IALUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 07:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=co0Yxxok8W9Zou32bL5Xyiqp1W1sMVSCGU5qd8JxFb9W175UWjy9euaZYaHKYWQp7b
         ZNWeZyEWKgfy8SmroJh+rw/1OofufFJRQP97qd2EofIjTPgwky2RcKssOe0YN4RUwcJT
         7qWMo4nQQBeqW8YfYsoj1XWgSbX+Dukp3vEnI=
Date: Wed, 1 Sep 2010 11:20:26 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
Message-ID: <20100901112026.GA9468@ff.dom.local>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera> <4AUWBNzTkbD.A.ey.cGueMB@chimera> <courier.4C7C99F2.00001F74@fs.ru.acad.bg> <20100831192659.GA3093@del.dom.local> <1283338251.2556.124.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283338251.2556.124.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 12:50:51PM +0200, Eric Dumazet wrote:
> Plamen, could you test following patch ?
> 
> I reproduced problem on a dev machine and following patch cured it.
> 
> Thanks
> 
> [PATCH] gro: fix different skb headrooms
> 
> packets entering GRO might have different headrooms, even for a given
> flow (because of implementation details in drivers, like copybreak).
> We cant force drivers to deliver packets with a fixed headroom.
> 
> 1) fix skb_segment()
> 
> skb_segment() makes the false assumption headrooms of fragments are same
> than the head. When CHECKSUM_PARTIAL is used, this can give csum_start
> errors, and crash later in skb_copy_and_csum_dev()

Eric, probably I missed something, but since the same test as in
skb_copy_and_csum_dev() gave different result a bit earlier on exactly
the same skb, I've suspected some sharing (or use after free)
problems, so I'm not sure your current diagnose can explain this.
(Unless this old test was dismissed later.)

Thanks,
Jarek P.

> 
> 2) allocate a minimal skb for head of frag_list
> 
> skb_gro_receive() uses netdev_alloc_skb(headroom + skb_gro_offset(p)) to
> allocate a fresh skb. This adds NET_SKB_PAD to a padding already
> provided by netdevice, depending on various things, like copybreak.
> 
> Use alloc_skb() to allocate an exact padding, to reduce cache line
> needs:
> NET_SKB_PAD + NET_IP_ALIGN
> 
> bugzilla : https://bugzilla.kernel.org/show_bug.cgi?id=16626
> 
> Many thanks to Plamen Petrov, testing many debugging patches !
> With help of Jarek Poplawski.
> 
> Reported-by: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Jarek Poplawski <jarkao2@gmail.com>
> ---
> patch against linux-2.6 current tree
> 
>  net/core/skbuff.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 3a2513f..26396ff 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -2573,6 +2573,10 @@ struct sk_buff *skb_segment(struct sk_buff *skb, int features)
>  		__copy_skb_header(nskb, skb);
>  		nskb->mac_len = skb->mac_len;
>  
> +		/* nskb and skb might have different headroom */
> +		if (nskb->ip_summed == CHECKSUM_PARTIAL)
> +			nskb->csum_start += skb_headroom(nskb) - headroom;
> +
>  		skb_reset_mac_header(nskb);
>  		skb_set_network_header(nskb, skb->mac_len);
>  		nskb->transport_header = (nskb->network_header +
> @@ -2702,8 +2706,8 @@ int skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
>  	} else if (skb_gro_len(p) != pinfo->gso_size)
>  		return -E2BIG;
>  
> -	headroom = skb_headroom(p);
> -	nskb = netdev_alloc_skb(p->dev, headroom + skb_gro_offset(p));
> +	headroom = NET_SKB_PAD + NET_IP_ALIGN;
> +	nskb = alloc_skb(headroom + skb_gro_offset(p), GFP_ATOMIC);
>  	if (unlikely(!nskb))
>  		return -ENOMEM;
>  
> 
> 
