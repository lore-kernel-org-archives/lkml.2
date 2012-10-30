Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038Ab2J3RBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:01:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:51639 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2J3RBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:01:52 -0400
Date: Tue, 30 Oct 2012 18:01:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: Use the correct per cpu slab on CPU_DEAD
In-Reply-To: <0000013ab24a800e-75ac1059-9697-42ed-b64a-7ba0d6223fba-000000@email.amazonses.com>
Message-ID: <alpine.LFD.2.02.1210301801030.2756@ionos>
References: <alpine.LFD.2.02.1210272117060.2756@ionos> <0000013ab24a800e-75ac1059-9697-42ed-b64a-7ba0d6223fba-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012, Christoph Lameter wrote:

> On Sat, 27 Oct 2012, Thomas Gleixner wrote:
> 
> > Correct this by extending the arguments of unfreeze_partials with the
> > target cpu number and use per_cpu_ptr instead of this_cpu_ptr.
> 
> Passing the kmem_cache_cpu pointer instead simplifies this a bit and avoid
> a per_cpu_ptr operations. That reduces code somewhat and results in no
> additional operations for the fast path.
> 
> 
> Subject: Use correct cpu_slab on dead cpu
> 
> Pass a kmem_cache_cpu pointer into unfreeze partials so that a different
> kmem_cache_cpu structure than the local one can be specified.
> 
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Yep. That looks less ugly :)

Acked-by: Thomas Gleixner <tglx@linutronix.de>
 
> Index: linux/mm/slub.c
> ===================================================================
> --- linux.orig/mm/slub.c	2012-10-30 10:23:33.040649727 -0500
> +++ linux/mm/slub.c	2012-10-30 10:25:03.401312250 -0500
> @@ -1874,10 +1874,10 @@ redo:
>   *
>   * This function must be called with interrupt disabled.
>   */
> -static void unfreeze_partials(struct kmem_cache *s)
> +static void unfreeze_partials(struct kmem_cache *s,
> +		struct kmem_cache_cpu *c)
>  {
>  	struct kmem_cache_node *n = NULL, *n2 = NULL;
> -	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
>  	struct page *page, *discard_page = NULL;
> 
>  	while ((page = c->partial)) {
> @@ -1963,7 +1963,7 @@ static int put_cpu_partial(struct kmem_c
>  				 * set to the per node partial list.
>  				 */
>  				local_irq_save(flags);
> -				unfreeze_partials(s);
> +				unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
>  				local_irq_restore(flags);
>  				oldpage = NULL;
>  				pobjects = 0;
> @@ -2006,7 +2006,7 @@ static inline void __flush_cpu_slab(stru
>  		if (c->page)
>  			flush_slab(s, c);
> 
> -		unfreeze_partials(s);
> +		unfreeze_partials(s, c);
>  	}
>  }
> 
> 
