Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab2FZQzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:55:36 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33093 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758079Ab2FZQzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:55:35 -0400
Date: Tue, 26 Jun 2012 18:55:13 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 04/16] mm: allow PF_MEMALLOC from softirq context
Message-ID: <20120626165513.GD6509@breakpoint.cc>
References: <1340375443-22455-1-git-send-email-mgorman@suse.de>
 <1340375443-22455-5-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340375443-22455-5-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 03:30:31PM +0100, Mel Gorman wrote:
> This is needed to allow network softirq packet processing to make
> use of PF_MEMALLOC.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b6c0727..5c6d9c6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2265,7 +2265,11 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>  	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
>  		if (gfp_mask & __GFP_MEMALLOC)
>  			alloc_flags |= ALLOC_NO_WATERMARKS;
> -		else if (likely(!(gfp_mask & __GFP_NOMEMALLOC)) && !in_interrupt())
> +		else if (in_serving_softirq() && (current->flags & PF_MEMALLOC))
> +			alloc_flags |= ALLOC_NO_WATERMARKS;
> +		else if (!in_interrupt() &&
> +				((current->flags & PF_MEMALLOC) ||
> +				 unlikely(test_thread_flag(TIF_MEMDIE))))
>  			alloc_flags |= ALLOC_NO_WATERMARKS;
>  	}

You allocate in RX path with __GFP_MEMALLOC and your sk->sk_allocation has
also __GFP_MEMALLOC set. That means you should get ALLOC_NO_WATERMARKS in
alloc_flags. Is this to done to avoid GFP annotations in skb_share_check() and
friends on your __netif_receive_skb() path?

Sebastian
