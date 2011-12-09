Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab1LIKK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 05:10:57 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56724 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1LIKK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 05:10:56 -0500
Date: Fri, 9 Dec 2011 02:10:52 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Alex,Shi" <alex.shi@intel.com>
cc: Christoph Lameter <cl@linux.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/3] slub: set a criteria for slub node partial adding
In-Reply-To: <1323419402.16790.6105.camel@debian>
Message-ID: <alpine.DEB.2.00.1112090203370.12604@chino.kir.corp.google.com>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com> <alpine.DEB.2.00.1112020842280.10975@router.home> <1323419402.16790.6105.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Dec 2011, Alex,Shi wrote:

> I did some experiments on add_partial judgment against rc4, like to put
> the slub into node partial head or tail according to free objects, or
> like Eric's suggest to combine the external parameter, like below: 
> 
>         n->nr_partial++;
> -       if (tail == DEACTIVATE_TO_TAIL)
> +       if (tail == DEACTIVATE_TO_TAIL || 
> +               page->inuse > page->objects /2)
>                 list_add_tail(&page->lru, &n->partial);
>         else
>                 list_add(&page->lru, &n->partial);
> 
> But the result is out of my expectation before.

I don't think you'll get consistent results for all workloads with 
something like this, some things may appear better and other things may 
appear worse.  That's why I've always disagreed with determining whether 
it should be added to the head or to the tail at the time of deactivation: 
you know nothing about frees happening to that slab subsequent to the 
decision you've made.  The only thing that's guaranteed is that you've 
through cache hot objects out the window and potentially increased the 
amount of internally fragmented slabs and/or unnecessarily long partial 
lists.

> Now we set all of slub
> into the tail of node partial, we get the best performance, even it is
> just a slight improvement. 
> 
> {
>         n->nr_partial++;
> -       if (tail == DEACTIVATE_TO_TAIL)
> -               list_add_tail(&page->lru, &n->partial);
> -       else
> -               list_add(&page->lru, &n->partial);
> +       list_add_tail(&page->lru, &n->partial);
>  }
>  
> This change can bring about 2% improvement on our WSM-ep machine, and 1%
> improvement on our SNB-ep and NHM-ex machine. and no clear effect for
> core2 machine. on hackbench process benchmark.
> 
>  	./hackbench 100 process 2000 
>  
> For multiple clients loopback netperf, only a suspicious 1% improvement
> on our 2 sockets machine. and others have no clear effect. 
> 
> But, when I check the deactivate_to_head/to_tail statistics on original
> code, the to_head is just hundreds or thousands times, while to_tail is
> called about teens millions times. 
> 
> David, could you like to try above change? move all slub to partial
> tail. 
> 
> add_partial statistics collection patch: 
> ---
> commit 1ff731282acb521f3a7c2e3fb94d35ec4d0ff07e
> Author: Alex Shi <alex.shi@intel.com>
> Date:   Fri Dec 9 18:12:14 2011 +0800
> 
>     slub: statistics collection for add_partial
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 5843846..a2b1143 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1904,10 +1904,11 @@ static void unfreeze_partials(struct kmem_cache *s)
>  			if (l != m) {
>  				if (l == M_PARTIAL)
>  					remove_partial(n, page);
> -				else
> +				else {
>  					add_partial(n, page,
>  						DEACTIVATE_TO_TAIL);
> -
> +					stat(s, DEACTIVATE_TO_TAIL);
> +				}
>  				l = m;
>  			}
>  
> @@ -2480,6 +2481,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
>  			remove_full(s, page);
>  			add_partial(n, page, DEACTIVATE_TO_TAIL);
>  			stat(s, FREE_ADD_PARTIAL);
> +			stat(s, DEACTIVATE_TO_TAIL);
>  		}
>  	}
>  	spin_unlock_irqrestore(&n->list_lock, flags);

Not sure what you're asking me to test, you would like this:

	{
	        n->nr_partial++;
	-       if (tail == DEACTIVATE_TO_TAIL)
	-               list_add_tail(&page->lru, &n->partial);
	-       else
	-               list_add(&page->lru, &n->partial);
	+       list_add_tail(&page->lru, &n->partial);
	}

with the statistics patch above?  I typically run with CONFIG_SLUB_STATS 
disabled since it impacts performance so heavily and I'm not sure what 
information you're looking for with regards to those stats.
