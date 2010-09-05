Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab0IEHty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 03:49:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40206 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab0IEHtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 03:49:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Clht4LBW1XQt51ylqcOIhD1jcJ4c3eGkNyJyj9ACg1cJcF4s0aGb3wW12G12TrRBxk
         j6W3+T2Cc1Ur1ZEYcl3ohC1nISICJerZwUmty2AA0pfOytrQ6DR93eq2VbGWgQ5+N43b
         +7KV2sXRoyaCOKH7C9dUde5HNufOHuS+mwfXg=
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
In-Reply-To: <20100904203429.GA4891@del.dom.local>
References: <20100904203429.GA4891@del.dom.local>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Sep 2010 09:49:43 +0200
Message-ID: <1283672983.3402.38.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 04 septembre 2010 à 22:34 +0200, Jarek Poplawski a écrit :

> Hi again,
> 
> Just had a second look, and unless I miss something...
> 
> Plamen, could you test this patch, too? (Without removing the previous
> one.)
> 
> Thanks,
> Jarek P.
> 
> ------------------->
> 
> [PATCH] gro: Re-fix different skb headrooms
> 
> The patch: "gro: fix different skb headrooms" in its part:
> "2) allocate a minimal skb for head of frag_list" is buggy. The copied
> skb has p->data set at the ip header at the moment, and skb_gro_offset
> is the length of ip + tcp headers. So, after the change the length of
> mac header is skipped. Later skb_set_mac_header() sets it into the
> NET_SKB_PAD area (if it's long enough) and ip header is misaligned at
> NET_SKB_PAD + NET_IP_ALIGN offset. There is no reason to assume the
> original skb was wrongly allocated, so let's copy it as it was.
> 
> bugzilla : https://bugzilla.kernel.org/show_bug.cgi?id=16626
> fixes commit: 3d3be4333fdf6faa080947b331a6a19bce1a4f57
> 
> Reported-by: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
> Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> ---
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 26396ff..c83b421 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -2706,7 +2706,7 @@ int skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
>  	} else if (skb_gro_len(p) != pinfo->gso_size)
>  		return -E2BIG;
>  
> -	headroom = NET_SKB_PAD + NET_IP_ALIGN;
> +	headroom = skb_headroom(p);
>  	nskb = alloc_skb(headroom + skb_gro_offset(p), GFP_ATOMIC);
>  	if (unlikely(!nskb))
>  		return -ENOMEM;

You are right, thanks for reviewing this patch again :)

By the way, NET_IP_ALIGN is now 0 on x86, so technically speaking, your
patch un-aligns IP header on x86, but thats OK, since other arches might
want it being aligned, while x86 doesnt care.

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



