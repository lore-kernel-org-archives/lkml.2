Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab2BCP1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:27:18 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:49042 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754439Ab2BCP1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:27:13 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: eZuVAU8VM1kUMcfEgRK1tL56YCxvgVh9d7zJMYaqcW8U3ei
 MFQpFVKO8_4o3l7KcTvXOcIKJC6RqZhmt1KSOwnV1Z9PgY8MZ4.tVvbPFfa.
 h4jDIybV5sF1bRDeASjKeB3no8LoNjLztOYDTS6AoCJci79kQaFqzzmpxN1L
 kY44OsFmOQTLWngnGFd1I_r3adq5.jjSJsfMjMft3atbiL2TF4fuEcbXLzPn
 I6k5L.JJFD2dKv02tkotTYuWL5nRDJwLpQIe4UzyhR1ytwvtyWUIbe6d2c8X
 FtO6MtBno6D961M84dpP0LSQlURvrNpDIA84ntm5BevGUJTCjqLp2zToyQgr
 dzQYQLxWSFDSj31agdTZjI0G_BAoxaAiHrF0pjHXAwUuirEOvq51V3Hm15hv
 v2YLfGcvQev1HJIxvumc_nhRvLZ.PLqipIWYC
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 3 Feb 2012 09:27:10 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [rfc PATCH]slub: per cpu partial statistics change
In-Reply-To: <1328256695.12669.24.camel@debian>
Message-ID: <alpine.DEB.2.00.1202030920060.2420@router.home>
References: <1328256695.12669.24.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Feb 2012, Alex,Shi wrote:

> This patch split the cpu_partial_free into 2 parts: cpu_partial_node, PCP refilling
> times from node partial; and same name cpu_partial_free, PCP refilling times in
> slab_free slow path. A new statistic 'release_cpu_partial' is added to get PCP
> release times. These info are useful when do PCP tunning.

Releasing? The code where you inserted the new statistics counts the pages
put on the cpu partial list when refilling from the node partial list.

See more below.

>  struct kmem_cache_cpu {
> diff --git a/mm/slub.c b/mm/slub.c
> index 4907563..5dd299c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1560,6 +1560,7 @@ static void *get_partial_node(struct kmem_cache *s,
>  		} else {
>  			page->freelist = t;
>  			available = put_cpu_partial(s, page, 0);
> +			stat(s, CPU_PARTIAL_NODE);

This is refilling the per cpu partial list from the node list.

>  		}
>  		if (kmem_cache_debug(s) || available > s->cpu_partial / 2)
>  			break;
> @@ -1973,6 +1974,7 @@ int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
>  				local_irq_restore(flags);
>  				pobjects = 0;
>  				pages = 0;
> +				stat(s, RELEASE_CPU_PARTIAL);

The callers count the cpu partial operations. Why is there now one in
put_cpu_partial? It is moving a page to the cpu partial list. Not
releasing it from the cpu partial list.

>
> @@ -2465,9 +2466,10 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
>  		 * If we just froze the page then put it onto the
>  		 * per cpu partial list.
>  		 */
> -		if (new.frozen && !was_frozen)
> +		if (new.frozen && !was_frozen) {
>  			put_cpu_partial(s, page, 1);
> -
> +			stat(s, CPU_PARTIAL_FREE);

cpu partial list filled with a partial page created from a fully allocated
slab (which therefore was not on any list before).


