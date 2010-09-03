Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab0ICEuC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 00:50:02 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:41396 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0ICEuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 00:50:00 -0400
Date: Fri, 3 Sep 2010 12:49:41 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Bandan Das <bandan.das@stratus.com>
Cc: bunk@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH net-next-2.6] net/ipv4: push IP options to CB in
	ip_fragment
Message-ID: <20100903044941.GA28300@gondor.apana.org.au>
References: <20100830200917.GA10754@stratus.com> <1283204118.2405.32.camel@edumazet-laptop> <20100830232147.GB10754@stratus.com> <1283232031.2405.38.camel@edumazet-laptop> <20100831082444.GB29281@gondor.apana.org.au> <1283246271.2550.35.camel@edumazet-laptop> <20100831123641.GA31017@gondor.apana.org.au> <20100901165743.GB17843@stratus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901165743.GB17843@stratus.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 12:57:43PM -0400, Bandan Das wrote:
> 
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index 2c911c0..de44271 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -759,9 +759,21 @@ static unsigned int br_nf_forward_arp(unsigned int hook, struct sk_buff *skb,
>  #if defined(CONFIG_NF_CONNTRACK_IPV4) || defined(CONFIG_NF_CONNTRACK_IPV4_MODULE)
>  static int br_nf_dev_queue_xmit(struct sk_buff *skb)
>  {
> +       struct ip_options *opt;
> +       struct iphdr *iph;
> +       struct net_device *dev = skb->dev;
> +
>         if (skb->nfct != NULL && skb->protocol == htons(ETH_P_IP) &&
>             skb->len + nf_bridge_mtu_reduction(skb) > skb->dev->mtu &&
> -           !skb_is_gso(skb))
> +           !skb_is_gso(skb)) {
> +               iph = ip_hdr(skb);
> +               opt = &(IPCB(skb)->opt);
> +               opt->optlen = iph->ihl*4 - sizeof(struct iphdr);
> +               if (ip_options_compile(dev_net(dev), opt, skb)){
> +                       IP_INC_STATS(dev_net(dev), IPSTATS_MIB_INHDRERRORS);
> +                       memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
> +               }
> +       }

1. Only parse options if ihl > 5.
2. Please audit the IP stack to ensure that this does not mangle
the packet.  We should not write to the packet here.
3. Please check whether SRR is handled correctly (see ip_rcv_options).

This should go into a helper function as this isn't the only entry
point from the bridge into the IP stack.

Also it may be worth considering whether we should replace
ip_fragment here with something that only refragments a frag_list
since the only time we want to fragment here is if we reassembled
an IP datagram due to netfilter.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
