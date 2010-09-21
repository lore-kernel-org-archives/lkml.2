Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab0IUJM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 05:12:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38397 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab0IUJM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 05:12:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=NvFGK+NhXtL7Mp/6+l2wrCplp3Xu8vJc0/Sz7+bDxfXO8c+gz9xY8FPnvw4n2fvd6c
         8ufQqlR9tSgdJBldAxPjlbKOjeEWvpuMG91xcW7h7Fy5mWBMWLXoqInsZVaT9t4v/fAD
         EKiFxnynf2aZxtM+BtyJSEGO7eZAbvHcpw1v8=
Date: Tue, 21 Sep 2010 09:12:48 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: Regression, bisected: reference leak with IPSec since ~2.6.31
Message-ID: <20100921091248.GA8424@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285018272.2323.243.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-20 23:31, Eric Dumazet wrote:
...
> [PATCH] ip : fix truesize mismatch in ip fragmentation
> 
> We should not set frag->destructor to sock_wkfree() until we are sure we
> dont hit slow path in ip_fragment(). Or we risk uncharging
> frag->truesize twice, and in the end, having negative socket
> sk_wmem_alloc counter, or even freeing socket sooner than expected.
> 
> Many thanks to Nick Bowler, who provided a very clean bug report and
> test programs.
> 
> While Nick bisection pointed to commit 2b85a34e911bf483 (net: No more
> expensive sock_hold()/sock_put() on each tx), underlying bug is older.
> 
> Reported-and-bisected-by: Nick Bowler <nbowler@elliptictech.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  net/ipv4/ip_output.c  |    8 ++++----
>  net/ipv6/ip6_output.c |   10 +++++-----
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 04b6989..126d9b3 100644
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
> @@ -510,11 +509,13 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
>  				goto slow_path;
>  
>  			BUG_ON(frag->sk);
> -			if (skb->sk) {
> +		}
> +		if (skb->sk) {
> +			skb_walk_frags(skb, frag) {
>  				frag->sk = skb->sk;
>  				frag->destructor = sock_wfree;

Nice catch, but it seems doing it in the first loop as now, and
reverting changes before goto slow_path might be more optimal here.

Jarek P.
