Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0HRAWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 20:22:01 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38556 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab0HRAVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 20:21:54 -0400
Date: Wed, 18 Aug 2010 09:21:49 +0900
From: Simon Horman <horms@verge.net.au>
To: Julian Anastasov <ja@ssi.bg>
Cc: linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        Xiaoyu Du <tingsrain@gmail.com>
Subject: Re: [patch nf-next] IPVS: ICMPv6 checksum calculation
Message-ID: <20100818002149.GA18114@verge.net.au>
References: <20100817070036.GB742@verge.net.au>
 <Pine.LNX.4.58.1008171143500.2771@u.domain.uli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.1008171143500.2771@u.domain.uli>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CCing netdev for comment ]

On Tue, Aug 17, 2010 at 12:25:56PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Tue, 17 Aug 2010, Simon Horman wrote:
> 
> > From: Xiaoyu Du <tingsrain@gmail.com>
> > 
> > Correct the ICMPv6 checksum calculation when IPv6 is is used
> > 
> > Signed-off-by: Xiaoyu Du <tingsrain@gmail.com>
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> > 
> > ---
> >  net/netfilter/ipvs/ip_vs_core.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > I wonder if this is -stable or .35 material.
> > 
> > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> > index 4f8ddba..124a1ae 100644
> > --- a/net/netfilter/ipvs/ip_vs_core.c
> > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > @@ -638,8 +638,12 @@ void ip_vs_nat_icmp_v6(struct sk_buff *skb,
> > struct ip_vs_protocol *pp,
> > 
> >  	/* And finally the ICMP checksum */
> >  	icmph->icmp6_cksum = 0;
> > -	/* TODO IPv6: is this correct for ICMPv6? */
> 
> 	May be ip_vs_checksum_complete() is not needed here?
> Also, skb->csum is not valid for every ip_summed value.
> May be we need to apply CHECKSUM_PARTIAL kind of setup for the IPv6.
> Such example is net/ipv6/udp.c:udp6_ufo_send_check().
> Later dev_queue_xmit() and skb_checksum_help() should take care
> for the next steps. Something like this can be tested:
> 
> 	icmph->icmp6_cksum = csum_ipv6_magic(&iph->saddr,
> 		&iph->daddr,
> 		skb->len - icmp_offset, IPPROTO_ICMPV6,
> 		0);
> 	skb->csum_start = skb_network_header(skb) - skb->head +
> 			  icmp_offset;
> 	skb->csum_offset = offsetof(struct icmp6hdr, icmp6_cksum);
> 	skb->ip_summed = CHECKSUM_PARTIAL;
> 
> >  	ip_vs_checksum_complete(skb, icmp_offset);
> > +	icmph->icmp6_cksum = csum_ipv6_magic(&iph->saddr,
> > +			&iph->daddr,
> > +			skb->len - icmp_offset, IPPROTO_ICMPV6,
> > +			skb->csum);
> > +
> >  	skb->ip_summed = CHECKSUM_UNNECESSARY;
> > 
> >  	if (inout)
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
