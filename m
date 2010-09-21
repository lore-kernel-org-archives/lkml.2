Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab0IUL6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 07:58:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48611 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab0IUL6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 07:58:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rf8Br8Q2oWJZiSsUkpJ1n9HkknRwwxb7HZ8Wq7wmTJbnd0F2kt1NsYjRgUwjGKYaIX
         i53iPEvROmMM5dLqAF+8n2NKKXL9yMyE6hSi1hh6GOlRWs3jmnUezq676SxzhCd1QVAI
         K9J1iS2MROTgiVc2ue3sfF7UyAm20ao6S2xPo=
Subject: Re: Regression, bisected: reference leak with IPSec since ~2.6.31
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20100921104821.GA8986@ff.dom.local>
References: <20100921091248.GA8424@ff.dom.local>
	 <1285060860.2617.158.camel@edumazet-laptop>
	 <20100921093853.GA8664@ff.dom.local>
	 <1285062948.2617.204.camel@edumazet-laptop>
	 <1285063657.2617.226.camel@edumazet-laptop>
	 <20100921104821.GA8986@ff.dom.local>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 13:58:30 +0200
Message-ID: <1285070310.2617.359.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 21 septembre 2010 à 10:48 +0000, Jarek Poplawski a écrit :

> But if you were honest about caches there is no reason to be smart
> no more. ;-)
> 
> Below is your patch mostly as an example only that I didn't mean
> nothing complex (ipv4 only, not compiled).
> 
> Jarek P.
> ---
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 04b6989..049d61f 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -490,7 +490,6 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
>  	if (skb_has_frags(skb)) {
>  		struct sk_buff *frag;
>  		int first_len = skb_pagelen(skb);
> -		int truesizes = 0;
>  
>  		if (first_len - hlen > mtu ||
>  		    ((first_len - hlen) & 7) ||
> @@ -503,18 +502,18 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
>  			if (frag->len > mtu ||
>  			    ((frag->len & 7) && frag->next) ||
>  			    skb_headroom(frag) < hlen)
> -			    goto slow_path;
> +			    goto slow_path_clean;
>  
>  			/* Partially cloned skb? */
>  			if (skb_shared(frag))
> -				goto slow_path;
> +				goto slow_path_clean;
>  
>  			BUG_ON(frag->sk);
>  			if (skb->sk) {
>  				frag->sk = skb->sk;
>  				frag->destructor = sock_wfree;
> +				skb->truesize -= frag->truesize;
>  			}
> -			truesizes += frag->truesize;
>  		}
>  
>  		/* Everything is OK. Generate! */
> @@ -524,7 +523,6 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
>  		frag = skb_shinfo(skb)->frag_list;
>  		skb_frag_list_init(skb);
>  		skb->data_len = first_len - skb_headlen(skb);
> -		skb->truesize -= truesizes;
>  		skb->len = first_len;
>  		iph->tot_len = htons(first_len);
>  		iph->frag_off = htons(IP_MF);
> @@ -576,6 +574,17 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
>  		}
>  		IP_INC_STATS(dev_net(dev), IPSTATS_MIB_FRAGFAILS);
>  		return err;
> +
> +slow_path_clean:
> +		if (skb->sk) {
> +			skb_walk_frags(skb, frag) {
> +				if (!frag->sk)
> +					break;
> +				frag->sk = NULL;
> +				frag->destructor = NULL;
> +				skb->truesize += frag->truesize;
> +			}
> +		}
>  	}
>  
>  slow_path:

Nice try, but this adds a bug unfortunately, or if you prefer makes the
"BUG_ON(frag->sk);" being not fully covered.

If we hit slow path, and one or more frags had frag->sk set, we silently
unset it, instead of a nice BUG_ON().

If you really want to have a slow_path_clean, you should use a different
frag2 iterator :

slow_path_clean:
       if (skb->sk) {
                skb_walk_frags(skb, frag2) {
                       if (frag2 == frag)
                               break;
                       frag2->sk = NULL;
                       frag2->destructor = NULL;
                       skb->truesize += frag2->truesize;
               }
       }

Face it, this is too complex for net-2.6, could we just fix the bug, and
'optimize' later ?



