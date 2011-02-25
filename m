Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab1BYSX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:23:56 -0500
Received: from mail.openrapids.net ([64.15.138.104]:41418 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932436Ab1BYSXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:23:55 -0500
Date: Fri, 25 Feb 2011 13:23:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [cpuops cmpxchg double V3 2/5] slub: Get rid of
	slab_free_hook_irq()
Message-ID: <20110225182353.GB24193@Krystal>
References: <20110225173850.486326452@linux.com> <20110225174155.212499723@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225174155.212499723@linux.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:22:21 up 93 days, 23:25,  4 users,  load average: 0.10, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> The following patch will make the fastpaths lockless and will no longer
> require interrupts to be disabled. Calling the free hook with irq disabled
> will no longer be possible.
> 
> Move the slab_free_hook_irq() logic into slab_free_hook. Only disable
> interrupts if the features are selected that require callbacks with
> interrupts off and reenable after calls have been made.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  mm/slub.c |   29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-01-10 12:06:58.000000000 -0600
> +++ linux-2.6/mm/slub.c	2011-01-10 12:07:11.000000000 -0600
> @@ -807,14 +807,24 @@ static inline void slab_post_alloc_hook(
>  static inline void slab_free_hook(struct kmem_cache *s, void *x)
>  {
>  	kmemleak_free_recursive(x, s->flags);
> -}
>  
> -static inline void slab_free_hook_irq(struct kmem_cache *s, void *object)
> -{
> -	kmemcheck_slab_free(s, object, s->objsize);
> -	debug_check_no_locks_freed(object, s->objsize);
> -	if (!(s->flags & SLAB_DEBUG_OBJECTS))
> -		debug_check_no_obj_freed(object, s->objsize);
> +	/*
> +	 * Trouble is that we may no longer disable interupts in the fast path

interrupts

/nitpick ;)

Mathieu

> +	 * So in order to make the debug calls that expect irqs to be
> +	 * disabled we need to disable interrupts temporarily.
> +	 */
> +#if defined(CONFIG_KMEMCHECK) || defined(CONFIG_LOCKDEP)
> +	{
> +		unsigned long flags;
> +
> +		local_irq_save(flags);
> +		kmemcheck_slab_free(s, x, s->objsize);
> +		debug_check_no_locks_freed(x, s->objsize);
> +		if (!(s->flags & SLAB_DEBUG_OBJECTS))
> +			debug_check_no_obj_freed(x, s->objsize);
> +		local_irq_restore(flags);
> +	}
> +#endif
>  }
>  
>  /*
> @@ -1101,9 +1111,6 @@ static inline void slab_post_alloc_hook(
>  
>  static inline void slab_free_hook(struct kmem_cache *s, void *x) {}
>  
> -static inline void slab_free_hook_irq(struct kmem_cache *s,
> -		void *object) {}
> -
>  #endif /* CONFIG_SLUB_DEBUG */
>  
>  /*
> @@ -1909,8 +1916,6 @@ static __always_inline void slab_free(st
>  	local_irq_save(flags);
>  	c = __this_cpu_ptr(s->cpu_slab);
>  
> -	slab_free_hook_irq(s, x);
> -
>  	if (likely(page == c->page && c->node != NUMA_NO_NODE)) {
>  		set_freepointer(s, object, c->freelist);
>  		c->freelist = object;
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
