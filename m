Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab0IURuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:50:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59803 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab0IURuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XFnHxbfZOmc85CyMoGZ57NzrxYX3yuaKgLia4p7SVQN8muqe7ibev0iwMkjeYTl5f1
         Pfw5vMZCuEl73q66epJXRwUjeedjBjKp/td7v6bzFOwe5EYTMa4s6PFK004B/UJMN39V
         3LPk029n0tUy6PuJ2a9+aShXcFyHAPKPFV6mA=
Date: Tue, 21 Sep 2010 19:50:14 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v3] ip: fix truesize mismatch in ip fragmentation
Message-ID: <20100921175014.GA2066@del.dom.local>
References: <20100920174443.GA5515@elliptictech.com>
 <1285006844.2323.17.camel@edumazet-laptop>
 <20100920195256.GA14330@elliptictech.com>
 <1285013853.2323.148.camel@edumazet-laptop>
 <1285018272.2323.243.camel@edumazet-laptop>
 <20100921140501.GA21572@elliptictech.com>
 <1285078613.2617.503.camel@edumazet-laptop>
 <1285084705.2617.636.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285084705.2617.636.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 05:58:25PM +0200, Eric Dumazet wrote:
> Hmm, while looking at git history, I found commit from Patrick
> b2722b1c3a893e (ip_fragment: also adjust skb->truesize for packets not
> owned by a socket)
> As my patch reverts it, we probably want a more polished patch.
> 
> (Also port Patrick work to ipv6)
> 
> So here is a V3
> 
> [PATCH v3] ip: fix truesize mismatch in ip fragmentation
> 
> Special care should be taken when slow path is hit in ip_fragment() :
> 
> When walking through frags, we transfert truesize ownership from skb to
> frags. Then if we hit a slow_path condition, we must undo this or risk
> uncharging frags->truesize twice, and in the end, having negative socket
> sk_wmem_alloc counter, or even freeing socket sooner than expected.
> 
> Many thanks to Nick Bowler, who provided a very clean bug report and
> test program.
> 
> Thanks to Jarek for reviewing my first patch and providing a V2
> 
> While Nick bisection pointed to commit 2b85a34e911 (net: No more
> expensive sock_hold()/sock_put() on each tx), underlying bug is older
> (2.6.12-rc5)
> 
> A side effect is to extend work done in commit b2722b1c3a893e
> (ip_fragment: also adjust skb->truesize for packets not owned by a
> socket) to ipv6 as well.
> 
> Reported-and-bisected-by: Nick Bowler <nbowler@elliptictech.com>
> Tested-by: Nick Bowler <nbowler@elliptictech.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Jarek Poplawski <jarkao2@gmail.com>
> CC: Patrick McHardy <kaber@trash.net>
> ---
>  net/ipv4/ip_output.c  |   19 +++++++++++++------
>  net/ipv6/ip6_output.c |   18 +++++++++++++-----
>  2 files changed, 26 insertions(+), 11 deletions(-)
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 04b6989..a643f7a 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -488,9 +488,8 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
>  	 * we can switch to copy when see the first bad fragment.
>  	 */
>  	if (skb_has_frags(skb)) {
> -		struct sk_buff *frag;
> +		struct sk_buff *frag, *frag2;
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
> +			    goto slow_path_undo;

Looks better and better to me, except, checkpatch complains about the
(existing) indentation fault here (and later), but I guess you've seen
that?

Jarek P.
