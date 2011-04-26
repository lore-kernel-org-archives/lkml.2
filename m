Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab1DZOKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:10:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab1DZOKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:10:52 -0400
Date: Tue, 26 Apr 2011 15:10:48 +0100
From: Mel Gorman <mgorman@suse.de>
To: NeilBrown <neilb@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 09/13] netvm: Set PF_MEMALLOC as appropriate during SKB
 processing
Message-ID: <20110426141048.GG4658@suse.de>
References: <1303803414-5937-1-git-send-email-mgorman@suse.de>
 <1303803414-5937-10-git-send-email-mgorman@suse.de>
 <20110426222157.33a461f8@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110426222157.33a461f8@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 10:21:57PM +1000, NeilBrown wrote:
> On Tue, 26 Apr 2011 08:36:50 +0100 Mel Gorman <mgorman@suse.de> wrote:
> 
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 3871bf6..2d79a20 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -3095,6 +3095,27 @@ static void vlan_on_bond_hook(struct sk_buff *skb)
> >  	}
> >  }
> >  
> > +/*
> > + * Limit which protocols can use the PFMEMALLOC reserves to those that are
> > + * expected to be used for communication with swap.
> > + */
> > +static bool skb_pfmemalloc_protocol(struct sk_buff *skb)
> > +{
> > +	if (skb_pfmemalloc(skb))
> > +		switch (skb->protocol) {
> > +		case __constant_htons(ETH_P_ARP):
> > +		case __constant_htons(ETH_P_IP):
> > +		case __constant_htons(ETH_P_IPV6):
> > +		case __constant_htons(ETH_P_8021Q):
> > +			break;
> > +
> > +		default:
> > +			return false;
> > +		}
> > +
> > +	return true;
> > +}
> 
> This sort of thing really bugs me :-)
> Neither the comment nor the function name actually describe what the function
> is doing.  The function is checking *2* things.
>    is_pfmemalloc_skb_or_pfmemalloc_protocol()
> might be a more correct name, but is too verbose.
> 
> I would prefer the skb_pfmemalloc test were removed from here and ....
> 
> > +	if (!skb_pfmemalloc_protocol(skb))
> > +		goto drop;
> > +
> 
> ...added here so this becomes:
> 
>       if (!skb_pfmemalloc(skb) && !skb_pfmemalloc_protocol(skb))
>                 goto drop;
> 
> which actually makes sense.
> 

Moving the check is neater but that check should be

	if (skb_pfmemalloc(skb) && !skb_pfmemalloc_protocol(skb))

? It's only if the skb was allocated from emergency reserves that we
need to consider dropping it to make way for other packets to be
received.

-- 
Mel Gorman
SUSE Labs
