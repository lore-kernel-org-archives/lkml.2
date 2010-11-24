Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab0KXBC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 20:02:56 -0500
Received: from mail.openrapids.net ([64.15.138.104]:58777 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755421Ab0KXBCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 20:02:55 -0500
Date: Tue, 23 Nov 2010 20:02:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless)
	fastpaths for slub
Message-ID: <20101124010252.GB8264@Krystal>
References: <20101123235139.908255844@linux.com> <20101123235201.758191189@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123235201.758191189@linux.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:54:31 up  5:57,  3 users,  load average: 0.10, 0.05, 0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:

[...]

> @@ -1737,23 +1770,53 @@ static __always_inline void *slab_alloc(
>  {
>  	void **object;
>  	struct kmem_cache_cpu *c;
> -	unsigned long flags;
> +	unsigned long tid;
>  
>  	if (slab_pre_alloc_hook(s, gfpflags))
>  		return NULL;
>  
> -	local_irq_save(flags);
> +redo:
> +	/*
> +	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
> +	 * enabled. We may switch back and forth between cpus while
> +	 * reading from one cpu area. That does not matter as long
> +	 * as we end up on the original cpu again when doing the cmpxchg.
> +	 */
>  	c = __this_cpu_ptr(s->cpu_slab);
> +
> +	/*
> +	 * The transaction ids are globally unique per cpu and per operation on
> +	 * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
> +	 * occurs on the right processor and that there was no operation on the
> +	 * linked list in between.
> +	 */

There seems to be some voodoo magic I don't understand here. I'm curious to see
what happens if we have:

CPU A                                                  CPU B
slab_alloc()
  c = __this_cpu_ptr(s->cpu_slab);
  tid = c->tid
  thread migrated to CPU B

slab_alloc()
  c = __this_cpu_ptr(s->cpu_slab);
  tid = c->tid
  ...                                                  ...
  irqsafe_cmpxchg_double
    - expect tid, on CPU A, success
                                                       migrate back to CPU A
  irqsafe_cmpxchg_double
    - expect (same) tid, on CPU A, success

So either there is a crucially important point I am missing, or the transaction
ID does not seem to be truly unique due to migration.

Thanks,

Mathieu


> +	tid = c->tid;
> +	barrier();
> +
>  	object = c->freelist;
> -	if (unlikely(!object || !node_match(c, node)))
> +	if (unlikely(!object || !node_match(c, c->node)))
>  
> -		object = __slab_alloc(s, gfpflags, node, addr, c);
> +		object = __slab_alloc(s, gfpflags, c->node, addr);
>  
>  	else {
> -		c->freelist = get_freepointer(s, object);
> +		/*
> +		 * The cmpxchg will only match if there was not additonal
> +		 * operation and if we are on the right processor.
> +		 */
> +		if (unlikely(!irqsafe_cmpxchg_double(&s->cpu_slab->freelist, object, tid,
> +				get_freepointer(s, object), next_tid(tid)))) {


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
