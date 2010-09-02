Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0IBCF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 22:05:56 -0400
Received: from mailhub.stratus.com ([134.111.1.18]:38807 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab0IBCFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 22:05:55 -0400
Date: Wed, 1 Sep 2010 22:05:45 -0400
From: Bandan Das <bandan.das@stratus.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.hengli.com.au, eric.dumazet@gmail.com,
        bandan.das@stratus.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH net-next-2.6] net/ipv4: push IP options to CB in
 ip_fragment
Message-ID: <20100902020545.GC17843@stratus.com>
References: <1283232031.2405.38.camel@edumazet-laptop>
 <20100901.144658.135972233.davem@davemloft.net>
 <20100901233056.GA15177@gondor.apana.org.au>
 <20100901.180922.163252387.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901.180922.163252387.davem@davemloft.net>
Company: Stratus Technologies
X-Disclaimer: This email will auto delete in 5 days, nah.. I am kidding!
User-Agent: Mutt/1.5.20 (2009-08-17)
X-OriginalArrivalTime: 02 Sep 2010 02:05:45.0463 (UTC) FILETIME=[5AAB4870:01CB4A43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  0, David Miller <davem@davemloft.net> wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Thu, 2 Sep 2010 07:30:56 +0800
> 
> > On Wed, Sep 01, 2010 at 02:46:58PM -0700, David Miller wrote:
> > .
> >> Therefore I'm inclined to agree with Herbert that we need to parse the
> >> options explicitly before invoke ip_fragment().  We must call it with
> >> an SKB in the state it expects, and that means with options parsing
> >> already performed.
> > 
> > FWIW the packet probably doesn't even have IP options.  What is
> > happening here is that we've found yet another entry point from
> > the bridge driver into the IP stack so we need to duplicate my
> > original patch here.
> 
> With that in mind I'm going to commit the following and
> queue it up to -stable too.
> 
> Thanks.
> 
> --------------------
> bridge: Clear INET control block of SKBs passed into ip_fragment().
> 
> In a similar vain to commit 17762060c25590bfddd68cc1131f28ec720f405f
> ("bridge: Clear IPCB before possible entry into IP stack")
> 
> Any time we call into the IP stack we have to make sure the state
> there is as expected by the ipv4 code.
> 
> With help from Eric Dumazet and Herbert Xu.
> 
> Reported-by: Brandan Das <brandan.das@stratus.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/bridge/br_netfilter.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index 5ed00bd..137f232 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -761,9 +761,11 @@ static int br_nf_dev_queue_xmit(struct sk_buff *skb)
>  {
>  	if (skb->nfct != NULL && skb->protocol == htons(ETH_P_IP) &&
>  	    skb->len + nf_bridge_mtu_reduction(skb) > skb->dev->mtu &&
> -	    !skb_is_gso(skb))
> +	    !skb_is_gso(skb)) {
> +		/* BUG: Should really parse the IP options here. */
> +		memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
>  		return ip_fragment(skb, br_dev_queue_push_xmit);
> -	else
> +	} else
>  		return br_dev_queue_push_xmit(skb);
>  }
>  #else
> -- 
> 1.7.2.2
Sounds good, except for one thing :)
It should be:  Reported-by: Bandan Das <bandan.das@stratus.com> (without the "r")

Bandan
