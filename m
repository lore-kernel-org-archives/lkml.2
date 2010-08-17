Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab0HQJ0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:26:51 -0400
Received: from ja.ssi.bg ([178.16.129.10]:44097 "EHLO u.domain.uli"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757451Ab0HQJ0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:26:49 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Aug 2010 05:26:49 EDT
Date: Tue, 17 Aug 2010 12:25:56 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
X-X-Sender: ja@u.domain.uli
To: Simon Horman <horms@verge.net.au>
cc: linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        Xiaoyu Du <tingsrain@gmail.com>
Subject: Re: [patch nf-next] IPVS: ICMPv6 checksum calculation
In-Reply-To: <20100817070036.GB742@verge.net.au>
Message-ID: <Pine.LNX.4.58.1008171143500.2771@u.domain.uli>
References: <20100817070036.GB742@verge.net.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Tue, 17 Aug 2010, Simon Horman wrote:

> From: Xiaoyu Du <tingsrain@gmail.com>
> 
> Correct the ICMPv6 checksum calculation when IPv6 is is used
> 
> Signed-off-by: Xiaoyu Du <tingsrain@gmail.com>
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> ---
>  net/netfilter/ipvs/ip_vs_core.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> I wonder if this is -stable or .35 material.
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 4f8ddba..124a1ae 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -638,8 +638,12 @@ void ip_vs_nat_icmp_v6(struct sk_buff *skb,
> struct ip_vs_protocol *pp,
> 
>  	/* And finally the ICMP checksum */
>  	icmph->icmp6_cksum = 0;
> -	/* TODO IPv6: is this correct for ICMPv6? */

	May be ip_vs_checksum_complete() is not needed here?
Also, skb->csum is not valid for every ip_summed value.
May be we need to apply CHECKSUM_PARTIAL kind of setup for the IPv6.
Such example is net/ipv6/udp.c:udp6_ufo_send_check().
Later dev_queue_xmit() and skb_checksum_help() should take care
for the next steps. Something like this can be tested:

	icmph->icmp6_cksum = csum_ipv6_magic(&iph->saddr,
		&iph->daddr,
		skb->len - icmp_offset, IPPROTO_ICMPV6,
		0);
	skb->csum_start = skb_network_header(skb) - skb->head +
			  icmp_offset;
	skb->csum_offset = offsetof(struct icmp6hdr, icmp6_cksum);
	skb->ip_summed = CHECKSUM_PARTIAL;

>  	ip_vs_checksum_complete(skb, icmp_offset);
> +	icmph->icmp6_cksum = csum_ipv6_magic(&iph->saddr,
> +			&iph->daddr,
> +			skb->len - icmp_offset, IPPROTO_ICMPV6,
> +			skb->csum);
> +
>  	skb->ip_summed = CHECKSUM_UNNECESSARY;
> 
>  	if (inout)

Regards

--
Julian Anastasov <ja@ssi.bg>
