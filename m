Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab1BYUrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:47:00 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:36751 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932620Ab1BYUq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:46:57 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: MzwaCNkVM1lrTOR9_0ebGpA2JUis578qnzoogF5HnX.N8F7
 OR3WGeqxzxJbZaIXe2FDLzgN3gc2d8QHdHAZUBRmJSOynVWR.oytes7sT_1Y
 Vh_88oTBoNV4GjFT8c8875zJacHV4RAtefGEweQJ_QHDln3wW9Hzj.LSt7.E
 QY0ysXaimZLWTgZEwghX.NPfC9CuHtgQuMQ5dyk5pQrj9FcH_faB7bhqBoxV
 P8RR7n0wbRAvachHVrErx0wyzWJ87WjPud97g7KtbVtvrj0_4Nro9_ORx57l
 BRqzvX24cbmlVXI_6JIWDAAPKXp2PU9TlO3DDJJ..kUad3Ek-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 25 Feb 2011 14:46:54 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [cpuops cmpxchg double V3 4/5] Lockless (and preemptless)
 fastpaths for slub
In-Reply-To: <20110225182149.GA24193@Krystal>
Message-ID: <alpine.DEB.2.00.1102251444330.7359@router.home>
References: <20110225173850.486326452@linux.com> <20110225174156.366044038@linux.com> <20110225182149.GA24193@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Mathieu Desnoyers wrote:

> > Index: linux-2.6/include/linux/slub_def.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/slub_def.h	2011-02-25 10:45:49.000000000 -0600
> > +++ linux-2.6/include/linux/slub_def.h	2011-02-25 10:46:19.000000000 -0600
> > @@ -35,7 +35,10 @@ enum stat_item {
> >  	NR_SLUB_STAT_ITEMS };
> >
> >  struct kmem_cache_cpu {
> > -	void **freelist;	/* Pointer to first free per cpu object */
> > +	void **freelist;	/* Pointer to next available object */
> > +#ifdef CONFIG_CMPXCHG_LOCAL
> > +	unsigned long tid;	/* Globally unique transaction id */
> > +#endif
>
> There seem to be no strong guarantee that freelist is double-word aligned here.

The struct kmem_cache_cpu allocation via alloc_percpu() specifies double
word alignment. See the remainder of the code quoted by you:

> > +#ifdef CONFIG_CMPXCHG_LOCAL
> > +	/*
> > +	 * Must align to double word boundary for the double cmpxchg instructions
> > +	 * to work.
> > +	 */
> > +	s->cpu_slab = __alloc_percpu(sizeof(struct kmem_cache_cpu), 2 * sizeof(void *));
> > +#else
> > +	/* Regular alignment is sufficient */
> >  	s->cpu_slab = alloc_percpu(struct kmem_cache_cpu);
> > +#endif
> > +
> > +	if (!s->cpu_slab)
> > +		return 0;
> >
> > -	return s->cpu_slab != NULL;
> > +	init_kmem_cache_cpus(s);
> > +
> > +	return 1;
> >  }
