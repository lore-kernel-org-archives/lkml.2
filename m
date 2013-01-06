Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3AFCSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 21:18:33 -0500
Received: from 1wt.eu ([62.212.114.60]:37519 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab3AFCSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 21:18:30 -0500
Date: Sun, 6 Jan 2013 03:18:24 +0100
From: Willy Tarreau <w@1wt.eu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Major network performance regression in 3.7
Message-ID: <20130106021824.GW16031@1wt.eu>
References: <20130105214958.GA19814@1wt.eu> <1357427926.1678.4771.camel@edumazet-glaptop> <20130105232913.GQ16031@1wt.eu> <1357430523.1678.4901.camel@edumazet-glaptop> <20130106005053.GS16031@1wt.eu> <1357435276.1678.5067.camel@edumazet-glaptop> <20130106013027.GV16031@1wt.eu> <1357436430.1678.5111.camel@edumazet-glaptop> <1357437086.1678.5135.camel@edumazet-glaptop> <1357438591.1678.5205.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357438591.1678.5205.camel@edumazet-glaptop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 06:16:31PM -0800, Eric Dumazet wrote:
> On Sat, 2013-01-05 at 17:51 -0800, Eric Dumazet wrote:
> > On Sat, 2013-01-05 at 17:40 -0800, Eric Dumazet wrote:
> > > On Sun, 2013-01-06 at 02:30 +0100, Willy Tarreau wrote:
> > > 
> > > > Ah interesting because these were some of the mm patches that I had
> > > > tried to revert.
> > > 
> > > Hmm, or we should fix __skb_splice_bits()
> > > 
> > > I'll send a patch.
> > > 
> > 
> > Could you try the following ?
> 
> Or more exactly...

The first one did not change a iota unfortunately. I'm about to
spot the commit causing the loopback regression. It's a few patches
before the first one you pointed. It's almost finished and I test
your patch below immediately after.

Thanks,
Willy

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 3ab989b..01f222c 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1736,11 +1736,8 @@ static bool __splice_segment(struct page *page, unsigned int poff,
>  		return false;
>  	}
>  
> -	/* ignore any bits we already processed */
> -	if (*off) {
> -		__segment_seek(&page, &poff, &plen, *off);
> -		*off = 0;
> -	}
> +	__segment_seek(&page, &poff, &plen, *off);
> +	*off = 0;
>  
>  	do {
>  		unsigned int flen = min(*len, plen);
> @@ -1768,14 +1765,15 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
>  			      struct splice_pipe_desc *spd, struct sock *sk)
>  {
>  	int seg;
> +	struct page *page = virt_to_page(skb->data);
> +	unsigned int poff = skb->data - (unsigned char *)page_address(page);
>  
>  	/* map the linear part :
>  	 * If skb->head_frag is set, this 'linear' part is backed by a
>  	 * fragment, and if the head is not shared with any clones then
>  	 * we can avoid a copy since we own the head portion of this page.
>  	 */
> -	if (__splice_segment(virt_to_page(skb->data),
> -			     (unsigned long) skb->data & (PAGE_SIZE - 1),
> +	if (__splice_segment(page, poff,
>  			     skb_headlen(skb),
>  			     offset, len, skb, spd,
>  			     skb_head_is_locked(skb),
> 
