Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1BYU42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:56:28 -0500
Received: from mail.openrapids.net ([64.15.138.104]:41024 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751227Ab1BYU41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:56:27 -0500
Date: Fri, 25 Feb 2011 15:56:24 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [cpuops cmpxchg double V3 4/5] Lockless (and preemptless)
	fastpaths for slub
Message-ID: <20110225205624.GA24988@Krystal>
References: <20110225173850.486326452@linux.com> <20110225174156.366044038@linux.com> <20110225182149.GA24193@Krystal> <alpine.DEB.2.00.1102251444330.7359@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102251444330.7359@router.home>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:55:27 up 94 days,  1:58,  5 users,  load average: 0.00, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Fri, 25 Feb 2011, Mathieu Desnoyers wrote:
> 
> > > Index: linux-2.6/include/linux/slub_def.h
> > > ===================================================================
> > > --- linux-2.6.orig/include/linux/slub_def.h	2011-02-25 10:45:49.000000000 -0600
> > > +++ linux-2.6/include/linux/slub_def.h	2011-02-25 10:46:19.000000000 -0600
> > > @@ -35,7 +35,10 @@ enum stat_item {
> > >  	NR_SLUB_STAT_ITEMS };
> > >
> > >  struct kmem_cache_cpu {
> > > -	void **freelist;	/* Pointer to first free per cpu object */
> > > +	void **freelist;	/* Pointer to next available object */
> > > +#ifdef CONFIG_CMPXCHG_LOCAL
> > > +	unsigned long tid;	/* Globally unique transaction id */
> > > +#endif
> >
> > There seem to be no strong guarantee that freelist is double-word aligned here.
> 
> The struct kmem_cache_cpu allocation via alloc_percpu() specifies double
> word alignment. See the remainder of the code quoted by you:

So adding a comment on top of struct kmem_cache_cpu declaration might be
appropriate too, just in case it is ever defined elsewhere.

Thanks,

Mathieu

> 
> > > +#ifdef CONFIG_CMPXCHG_LOCAL
> > > +	/*
> > > +	 * Must align to double word boundary for the double cmpxchg instructions
> > > +	 * to work.
> > > +	 */
> > > +	s->cpu_slab = __alloc_percpu(sizeof(struct kmem_cache_cpu), 2 * sizeof(void *));
> > > +#else
> > > +	/* Regular alignment is sufficient */
> > >  	s->cpu_slab = alloc_percpu(struct kmem_cache_cpu);
> > > +#endif
> > > +
> > > +	if (!s->cpu_slab)
> > > +		return 0;
> > >
> > > -	return s->cpu_slab != NULL;
> > > +	init_kmem_cache_cpus(s);
> > > +
> > > +	return 1;
> > >  }

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
